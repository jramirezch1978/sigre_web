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
      sucursalId: [null, Validators.required],
      almacenId: [null, Validators.required],
      articuloMovTipoId: [null, Validators.required],
      fechaMov: [this.hoy(), Validators.required],
      fecProduccion: [null],
      proveedorId: [null],
      nomReceptor: [null],
      nroDocExt: [null],
      observaciones: [null],
      lineas: this.fb.array([]),
    });

    forkJoin({
      suc: this.coreApi.listarMisSucursales().pipe(catchError(() => of([]))),
      alm: this.almacenApi.listarAlmacenes().pipe(catchError(() => of([]))),
      tip: this.almacenApi.listarTiposMovimiento().pipe(catchError(() => of([]))),
      prov: this.coreApi.listarProveedores().pipe(catchError(() => of([]))),
    }).subscribe(({ suc, alm, tip, prov }) => {
      this.sucursales = suc.map(s => ({ value: s.id, label: `${s.codigo ?? s.id} — ${s.nombre}` }));
      this.almacenes = this.activos(alm).map(a => ({ value: a.id, label: `${a.codigo} — ${a.nombre}` }));
      this.tiposMov = this.activos(tip).map((t: { id: number; tipoMov: string; descTipoMov: string }) => ({ value: t.id, label: `${t.tipoMov} — ${t.descTipoMov}` }));
      this.proveedores = prov;
      if (this.data.registroId) {
        this.cargarRegistro(this.data.registroId);
      } else {
        this.agregarLinea();
        this.cargando = false;
      }
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
