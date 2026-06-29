import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormArray, FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { of } from 'rxjs';
import { catchError } from 'rxjs/operators';
import {
  extraerMensajeErrorApi, SigreModalService,
  SigreMetoxiModalShellComponent, SigreMetoxiModalActionsComponent,
} from '@sigre-common';
import { ApiBaseService } from '../../../../../services/api-base.service';
import { ApiResponse } from '../../../../shared/models/api-page.model';
import { SigreSearchableSelectComponent, SigreSelectOption } from '../../../../shared/sigre-searchable-select/sigre-searchable-select.component';
import { SigreArticuloSelectComponent } from '../../../../shared/sigre-articulo-select/sigre-articulo-select.component';
import { AlmacenApiService } from '../../services/almacen-api.service';

export interface OrdenTrasladoMdDialogData {
  titulo: string;
  registroId?: number | null;
}

/** Form maestro-detalle de Orden de Traslado (cabecera almacen.orden_traslado + detalle orden_traslado_det). */
@Component({
  selector: 'app-orden-traslado-md-dialog',
  standalone: true,
  imports: [
    CommonModule, ReactiveFormsModule,
    SigreMetoxiModalShellComponent, SigreMetoxiModalActionsComponent,
    SigreSearchableSelectComponent, SigreArticuloSelectComponent,
  ],
  templateUrl: './orden-traslado-md-dialog.component.html',
  styleUrls: ['./orden-traslado-md-dialog.component.scss'],
})
export class OrdenTrasladoMdDialogComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly dialogRef = inject(MatDialogRef<OrdenTrasladoMdDialogComponent>);
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);
  private readonly almacenApi = inject(AlmacenApiService);
  private readonly modal = inject(SigreModalService);
  readonly data = inject<OrdenTrasladoMdDialogData>(MAT_DIALOG_DATA);

  form!: FormGroup;
  cargando = true;
  guardando = false;
  almacenes: SigreSelectOption[] = [];

  private get base(): string { return `${this.apiBase.getApiBaseUrl()}/almacen`; }
  get lineas(): FormArray { return this.form.get('lineas') as FormArray; }

  ngOnInit(): void {
    this.form = this.fb.group({
      almacenOrigenId: [null, Validators.required],
      almacenDestinoId: [null, Validators.required],
      fecha: [new Date().toISOString().slice(0, 10), Validators.required],
      observacion: [null],
      lineas: this.fb.array([]),
    });

    this.almacenApi.listarAlmacenes().pipe(catchError(() => of([]))).subscribe(alm => {
      this.almacenes = alm.filter(a => String((a as { flagEstado?: unknown }).flagEstado ?? '1') !== '0')
        .map(a => ({ value: a.id, label: `${a.codigo} — ${a.nombre}` }));
      if (this.data.registroId) {
        this.cargarRegistro(this.data.registroId);
      } else {
        this.agregarLinea();
        this.cargando = false;
      }
    });
  }

  private cargarRegistro(id: number): void {
    this.http.get<ApiResponse<Record<string, unknown>>>(`${this.base}/ordenes-traslado/${id}`).subscribe({
      next: res => {
        const d = res.data ?? {};
        this.form.patchValue({
          almacenOrigenId: d['almacenOrigenId'], almacenDestinoId: d['almacenDestinoId'],
          fecha: d['fecha'], observacion: d['observacion'],
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
      cantidad: [l?.['cantidad'] ?? null, Validators.required],
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
      void this.modal.warning('Complete origen, destino, fecha y al menos un artículo.', 'Datos incompletos');
      return;
    }
    if (this.form.value.almacenOrigenId === this.form.value.almacenDestinoId) {
      void this.modal.warning('El almacén de origen y destino no pueden ser el mismo.', 'Validación');
      return;
    }
    this.guardando = true;
    const body = this.form.getRawValue();
    const id = this.data.registroId;
    const req = id
      ? this.almacenApi.actualizarRegistro('/ordenes-traslado', id, body)
      : this.almacenApi.crearRegistro('/ordenes-traslado', body);
    req.subscribe({
      next: () => this.dialogRef.close(true),
      error: err => {
        this.guardando = false;
        void this.modal.error(extraerMensajeErrorApi(err, 'No se pudo guardar la orden de traslado'), 'Error');
      },
    });
  }
}
