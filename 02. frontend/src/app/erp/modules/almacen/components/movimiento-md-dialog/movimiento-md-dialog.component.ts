import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormArray, FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { forkJoin, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';
import {
  SigreModalService,
  SigreMetoxiModalShellComponent, SigreMetoxiModalActionsComponent,
} from '@sigre-common';
import { ApiBaseService } from '../../../../../services/api-base.service';
import { ApiResponse } from '../../../../shared/models/api-page.model';
import { SigreSearchableSelectComponent, SigreSelectOption } from '../../../../shared/sigre-searchable-select/sigre-searchable-select.component';
import { SigreArticuloSelectComponent } from '../../../../shared/sigre-articulo-select/sigre-articulo-select.component';
import { SigreCentrosCostoSelectComponent } from '../../../../shared/sigre-centros-costo-select/sigre-centros-costo-select.component';
import { CoreApiService } from '../../services/core-api.service';
import { AlmacenApiService } from '../../services/almacen-api.service';

export interface MovimientoMdDialogData {
  titulo: string;
  registroId?: number | null;
}

/** Form maestro-detalle de Movimiento de Almacén (cabecera almacen.vale_mov + detalle vale_mov_det). */
@Component({
  selector: 'app-movimiento-md-dialog',
  standalone: true,
  imports: [
    CommonModule, ReactiveFormsModule,
    SigreMetoxiModalShellComponent, SigreMetoxiModalActionsComponent,
    SigreSearchableSelectComponent, SigreArticuloSelectComponent, SigreCentrosCostoSelectComponent,
  ],
  templateUrl: './movimiento-md-dialog.component.html',
  styleUrls: ['./movimiento-md-dialog.component.scss'],
})
export class MovimientoMdDialogComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly dialogRef = inject(MatDialogRef<MovimientoMdDialogComponent>);
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);
  private readonly coreApi = inject(CoreApiService);
  private readonly almacenApi = inject(AlmacenApiService);
  private readonly modal = inject(SigreModalService);
  readonly data = inject<MovimientoMdDialogData>(MAT_DIALOG_DATA);

  form!: FormGroup;
  cargando = true;
  guardando = false;

  sucursales: SigreSelectOption[] = [];
  almacenes: SigreSelectOption[] = [];
  tiposMov: SigreSelectOption[] = [];
  proveedores: SigreSelectOption[] = [];

  private get base(): string { return `${this.apiBase.getApiBaseUrl()}/almacen`; }

  get lineas(): FormArray { return this.form.get('lineas') as FormArray; }

  ngOnInit(): void {
    this.form = this.fb.group({
      // Sucursal fija a la del usuario (no editable).
      sucursalId: [{ value: null, disabled: true }, Validators.required],
      almacenId: [null, Validators.required],
      articuloMovTipoId: [null, Validators.required],
      // Fecha de registro = hora de la BD, no editable.
      fechaMov: [{ value: this.hoy(), disabled: true }, Validators.required],
      fecProduccion: [null], // Fecha auxiliar (por defecto = fecha registro)
      proveedorId: [null],
      nomReceptor: [null],
      nroDocExt: [null],
      observaciones: [null],
      lineas: this.fb.array([]),
    });

    // Al cambiar de almacén: recargar SOLO los tipos de movimiento asignados a ese almacén (activos).
    this.form.get('almacenId')!.valueChanges.subscribe((almId: number | null) => {
      this.form.get('articuloMovTipoId')!.setValue(null);
      this.cargarTiposPorAlmacen(almId);
    });

    forkJoin({
      suc: this.coreApi.listarMisSucursales().pipe(catchError(() => of([]))),
      alm: this.almacenApi.listarMisAlmacenes().pipe(catchError(() => of([]))),
      prov: this.coreApi.listarProveedores().pipe(catchError(() => of([]))),
      hora: this.almacenApi.obtenerHoraServidor().pipe(catchError(() => of({ fecha: this.hoy(), fechaHora: '' }))),
    }).subscribe(({ suc, alm, prov, hora }) => {
      this.sucursales = suc.map(s => ({ value: s.id, label: `${s.codigo ?? s.id} — ${s.nombre}` }));
      this.almacenes = this.activos(alm).map(a => ({ value: a.id, label: `${a.codigo} — ${a.nombre}` }));
      this.proveedores = prov;

      if (this.data.registroId) {
        this.cargarRegistro(this.data.registroId);
      } else {
        // Sucursal del usuario (la primera de sus sucursales) y fecha de BD.
        if (this.sucursales.length) this.form.get('sucursalId')!.setValue(this.sucursales[0].value);
        const fecha = hora?.fecha || this.hoy();
        this.form.get('fechaMov')!.setValue(fecha);
        this.form.get('fecProduccion')!.setValue(fecha); // auxiliar = registro por defecto
        this.agregarLinea();
        this.cargando = false;
      }
    });
  }

  /** Carga los tipos de movimiento asignados a un almacén (activos). */
  private cargarTiposPorAlmacen(almacenId: number | null): void {
    if (!almacenId) { this.tiposMov = []; return; }
    this.almacenApi.listarTiposMovimientoPorAlmacen(almacenId).pipe(catchError(() => of([]))).subscribe(tipos => {
      this.tiposMov = this.activos(tipos)
        .map(t => ({ value: t.articuloMovTipoId ?? t.id, label: `${t.tipoMov} — ${t.descTipoMov}` }));
    });
  }

  private activos<T>(items: T[]): T[] {
    return items.filter(i => String((i as { flagEstado?: unknown }).flagEstado ?? '1') !== '0');
  }

  private cargarRegistro(id: number): void {
    this.http.get<ApiResponse<Record<string, unknown>>>(`${this.base}/movimientos/${id}`).subscribe({
      next: res => {
        const d = res.data ?? {};
        this.form.patchValue({
          sucursalId: d['sucursalId'], almacenId: d['almacenId'], articuloMovTipoId: d['articuloMovTipoId'],
          fechaMov: d['fechaMov'], fecProduccion: d['fecProduccion'], proveedorId: d['proveedorId'],
          nomReceptor: d['nomReceptor'], nroDocExt: d['nroDocExt'], observaciones: d['observaciones'],
        });
        const lineas = (d['lineas'] as Record<string, unknown>[]) ?? [];
        lineas.forEach(l => this.agregarLinea(l));
        if (lineas.length === 0) this.agregarLinea();
        this.cargando = false;
      },
      error: () => { this.agregarLinea(); this.cargando = false; },
    });
  }

  agregarLinea(l?: Record<string, unknown>): void {
    this.lineas.push(this.fb.group({
      articuloId: [l?.['articuloId'] ?? null, Validators.required],
      cantProcesada: [l?.['cantProcesada'] ?? null, [Validators.required]],
      costoUnitario: [l?.['costoUnitario'] ?? null],
      centrosCostoId: [l?.['centrosCostoId'] ?? null],
      pesoNetoTm: [l?.['pesoNetoTm'] ?? null],
    }));
  }

  quitarLinea(i: number): void {
    this.lineas.removeAt(i);
    if (this.lineas.length === 0) this.agregarLinea();
  }

  lineaGroup(i: number): FormGroup { return this.lineas.at(i) as FormGroup; }

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
    const req = id
      ? this.almacenApi.actualizarRegistro('/movimientos', id, body)
      : this.almacenApi.crearRegistro('/movimientos', body);
    req.subscribe({
      next: () => this.dialogRef.close(true),
      // El error lo muestra el interceptor global (ApiErrorInterceptor); aquí solo se restaura el estado.
      error: () => { this.guardando = false; },
    });
  }

  private hoy(): string { return new Date().toISOString().slice(0, 10); }
}
