import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormArray, FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { forkJoin, of } from 'rxjs';
import { catchError } from 'rxjs/operators';
import {
  SigreModalService,
  SigreMetoxiModalShellComponent, SigreMetoxiModalActionsComponent,
} from '@sigre-common';
import { SigreSearchableSelectComponent, SigreSelectOption } from '../../../../shared/sigre-searchable-select/sigre-searchable-select.component';
import { SigreArticuloSelectComponent } from '../../../../shared/sigre-articulo-select/sigre-articulo-select.component';
import { CoreApiService } from '../../../almacen/services/core-api.service';
import { AlmacenApiService } from '../../../almacen/services/almacen-api.service';
import { SolicitudCompraApiService } from '../../services/solicitud-compra-api.service';

export interface SolicitudCompraDialogData {
  registroId?: number | null;
  /** true si el estado del documento no permite edición (solo lectura). */
  soloLectura?: boolean;
}

const PRIORIDADES: SigreSelectOption[] = [
  { value: 'BAJA', label: 'Baja' },
  { value: 'MEDIA', label: 'Media' },
  { value: 'ALTA', label: 'Alta' },
  { value: 'URGENTE', label: 'Urgente' },
];

/** Form maestro-detalle de Solicitud de Compra (compras.solicitud_compra + solicitud_compra_det). */
@Component({
  selector: 'app-solicitud-compra-dialog',
  standalone: true,
  imports: [
    CommonModule, ReactiveFormsModule,
    SigreMetoxiModalShellComponent, SigreMetoxiModalActionsComponent,
    SigreSearchableSelectComponent, SigreArticuloSelectComponent,
  ],
  templateUrl: './solicitud-compra-dialog.component.html',
  styleUrls: ['./solicitud-compra-dialog.component.scss'],
})
export class SolicitudCompraDialogComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly dialogRef = inject(MatDialogRef<SolicitudCompraDialogComponent>);
  private readonly coreApi = inject(CoreApiService);
  private readonly almacenApi = inject(AlmacenApiService);
  private readonly api = inject(SolicitudCompraApiService);
  private readonly modal = inject(SigreModalService);
  readonly data = inject<SolicitudCompraDialogData>(MAT_DIALOG_DATA);

  form!: FormGroup;
  cargando = true;
  guardando = false;
  numero = '';

  readonly prioridades = PRIORIDADES;
  sucursales: SigreSelectOption[] = [];
  usuarios: SigreSelectOption[] = [];
  almacenes: SigreSelectOption[] = [];

  get lineas(): FormArray { return this.form.get('lineas') as FormArray; }
  get soloLectura(): boolean { return !!this.data.soloLectura; }

  ngOnInit(): void {
    this.form = this.fb.group({
      sucursalId: [null, Validators.required],
      fecha: [this.hoy(), Validators.required],
      solicitanteId: [null],
      prioridad: ['MEDIA'],
      justificacion: [null],
      lineas: this.fb.array([]),
    });

    if (this.soloLectura) this.form.disable();

    forkJoin({
      suc: this.coreApi.listarMisSucursales().pipe(catchError(() => of([]))),
      usr: this.coreApi.listarUsuariosEmpresa().pipe(catchError(() => of([]))),
      alm: this.almacenApi.listarMisAlmacenes().pipe(catchError(() => of([]))),
    }).subscribe(({ suc, usr, alm }) => {
      this.sucursales = suc.map(s => ({ value: s.id, label: `${s.codigo ?? s.id} — ${s.nombre}` }));
      this.usuarios = usr;
      this.almacenes = this.activos(alm).map(a => ({ value: a.id, label: `${a.codigo} — ${a.nombre}` }));

      if (this.data.registroId) {
        this.cargarRegistro(this.data.registroId);
      } else {
        if (this.sucursales.length === 1) this.form.get('sucursalId')!.setValue(this.sucursales[0].value);
        this.agregarLinea();
        this.cargando = false;
      }
    });
  }

  private activos<T>(items: T[]): T[] {
    return items.filter(i => String((i as { flagEstado?: unknown }).flagEstado ?? '1') !== '0');
  }

  private cargarRegistro(id: number): void {
    this.api.obtener(id).subscribe({
      next: sc => {
        this.numero = sc.numero;
        this.form.patchValue({
          sucursalId: sc.sucursalId,
          fecha: sc.fecha,
          solicitanteId: sc.solicitanteId,
          prioridad: sc.prioridad ?? 'MEDIA',
          justificacion: sc.justificacion,
        });
        (sc.lineas ?? []).forEach(l => this.agregarLinea(l));
        if (!sc.lineas?.length) this.agregarLinea();
        this.cargando = false;
      },
      error: () => { this.agregarLinea(); this.cargando = false; },
    });
  }

  agregarLinea(l?: Partial<{ articuloId: number; almacenId: number; cantidad: number; especificaciones: string }>): void {
    const grupo = this.fb.group({
      articuloId: [l?.articuloId ?? null, Validators.required],
      almacenId: [l?.almacenId ?? null],
      cantidad: [l?.cantidad ?? null, [Validators.required, Validators.min(0.0001)]],
      especificaciones: [l?.especificaciones ?? null],
    });
    if (this.soloLectura) grupo.disable();
    this.lineas.push(grupo);
  }

  quitarLinea(i: number): void {
    this.lineas.removeAt(i);
    if (this.lineas.length === 0) this.agregarLinea();
  }

  cancelar(): void { this.dialogRef.close(null); }

  guardar(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      void this.modal.warning('Complete los campos obligatorios de la cabecera y del detalle.', 'Datos incompletos');
      return;
    }
    if (this.lineas.length === 0) {
      void this.modal.warning('Agregue al menos un artículo al detalle.', 'Detalle vacío');
      return;
    }
    this.guardando = true;
    const body = this.form.getRawValue();
    const id = this.data.registroId;
    const req = id ? this.api.actualizar(id, body) : this.api.crear(body);
    req.subscribe({
      next: () => this.dialogRef.close(true),
      // El error lo muestra el interceptor global (ApiErrorInterceptor); aquí solo se restaura el estado.
      error: () => { this.guardando = false; },
    });
  }

  private hoy(): string { return new Date().toISOString().slice(0, 10); }
}
