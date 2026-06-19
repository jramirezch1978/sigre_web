import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatDialogModule, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { forkJoin, of } from 'rxjs';
import { TablaCrudCampo, TablaCrudConfig } from '../../config/almacen-tabla-crud.config';
import { AlmacenApiService } from '../../services/almacen-api.service';
import { AlmacenCrudService } from '../../services/almacen-crud.service';
import { CoreApiService, SelectOptionDto } from '../../services/core-api.service';

export interface AlmacenRegistroDialogData {
  titulo: string;
  config: TablaCrudConfig;
  registro?: Record<string, unknown> | null;
}

@Component({
  selector: 'app-almacen-registro-dialog',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    MatDialogModule,
    MatButtonModule,
    MatFormFieldModule,
    MatInputModule,
    MatSelectModule,
    MatSlideToggleModule,
    MatProgressSpinnerModule,
  ],
  templateUrl: './almacen-registro-dialog.component.html',
  styleUrls: ['./almacen-registro-dialog.component.scss'],
})
export class AlmacenRegistroDialogComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly dialogRef = inject(MatDialogRef<AlmacenRegistroDialogComponent>);
  private readonly almacenApi = inject(AlmacenApiService);
  private readonly coreApi = inject(CoreApiService);
  private readonly crudService = inject(AlmacenCrudService);
  readonly data = inject<AlmacenRegistroDialogData>(MAT_DIALOG_DATA);

  form!: FormGroup;
  cargandoOpciones = true;
  guardando = false;
  error = '';
  opciones: Record<string, SelectOptionDto[]> = {};
  private esEdicion = false;

  ngOnInit(): void {
    this.esEdicion = !!this.data.registro?.['id'] || this.data.config.handler === 'parametro';
    this.form = this.fb.group({});
    for (const campo of this.data.config.campos) {
      const valor = this.valorInicial(campo);
      const validators = campo.required ? [Validators.required] : [];
      if (campo.maxLength) {
        validators.push(Validators.maxLength(campo.maxLength));
      }
      const control = this.fb.control(
        { value: valor, disabled: this.esEdicion && !!campo.readonlyOnEdit },
        validators
      );
      this.form.addControl(campo.key, control);
    }
    this.cargarOpciones();
  }

  cancelar(): void {
    this.dialogRef.close(null);
  }

  guardar(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    this.guardando = true;
    this.error = '';
    const body = this.normalizarBody(this.form.getRawValue());

    this.crudService.guardar(this.data.config, this.data.registro ?? null, body).subscribe({
      next: () => this.dialogRef.close(true),
      error: err => {
        this.guardando = false;
        this.error = this.extraerMensajeError(err);
      },
    });
  }

  opcionesDe(campo: TablaCrudCampo): SelectOptionDto[] {
    return campo.optionsFrom ? (this.opciones[campo.optionsFrom] ?? []) : [];
  }

  esCampoDate(campo: TablaCrudCampo): boolean {
    return campo.type === 'date';
  }

  esCampoNumber(campo: TablaCrudCampo): boolean {
    return campo.type === 'number';
  }

  esCampoSwitch(campo: TablaCrudCampo): boolean {
    return campo.type === 'switch';
  }

  etiquetaSwitch(campo: TablaCrudCampo): string {
    const valor = this.form.get(campo.key)?.value;
    return valor ? (campo.switchOnLabel ?? 'Activo') : (campo.switchOffLabel ?? 'Anulado');
  }

  private valorInicial(campo: TablaCrudCampo): unknown {
    const reg = this.data.registro;
    if (!reg) {
      if (campo.type === 'switch') return true;
      if (campo.key === 'ano') return new Date().getFullYear();
      if (campo.key === 'fechaMov' || campo.key === 'fecha' || campo.key === 'fechaConteo') {
        return new Date().toISOString().slice(0, 10);
      }
      return campo.type === 'number' ? null : '';
    }
    if (campo.type === 'switch') {
      const raw = reg[campo.key];
      return raw === '1' || raw === 1 || raw === true;
    }
    if (campo.key === 'valor' && reg['valor'] === '—') return '';
    if (campo.key === 'sucursalId' && reg['sucursalId'] == null && reg['nombreTabla']) {
      return reg['sucursalId'];
    }
    return reg[campo.key] ?? (campo.type === 'number' ? null : '');
  }

  private cargarOpciones(): void {
    const campos = this.data.config.campos;
    const necesitaTipos = campos.some(c => c.optionsFrom === 'tipos-almacen');
    const necesitaSucursales = campos.some(c => c.optionsFrom === 'sucursales');
    const necesitaAlmacenes = campos.some(c => c.optionsFrom === 'almacenes');
    const necesitaTiposMov = campos.some(c => c.optionsFrom === 'tipos-movimiento');

    if (!necesitaTipos && !necesitaSucursales && !necesitaAlmacenes && !necesitaTiposMov) {
      this.cargandoOpciones = false;
      return;
    }

    forkJoin({
      tipos: necesitaTipos ? this.almacenApi.listarTiposAlmacen() : of([]),
      sucursales: necesitaSucursales ? this.coreApi.listarMisSucursales() : of([]),
      almacenes: necesitaAlmacenes ? this.almacenApi.listarAlmacenes() : of([]),
      tiposMov: necesitaTiposMov ? this.almacenApi.listarTiposMovimiento() : of([]),
    }).subscribe({
      next: ({ tipos, sucursales, almacenes, tiposMov }) => {
        if (necesitaTipos) {
          this.opciones['tipos-almacen'] = tipos.map(t => ({
            value: t.id,
            label: `${t.codigo} — ${t.nombre}`,
          }));
        }
        if (necesitaSucursales) {
          this.opciones['sucursales'] = sucursales.map(s => ({
            value: s.id,
            label: `${s.codigo ?? s.id} — ${s.nombre}`,
          }));
        }
        if (necesitaAlmacenes) {
          this.opciones['almacenes'] = almacenes.map(a => ({
            value: a.id,
            label: `${a.codigo} — ${a.nombre}`,
          }));
        }
        if (necesitaTiposMov) {
          this.opciones['tipos-movimiento'] = tiposMov.map(t => ({
            value: t.id,
            label: `${t.tipoMov} — ${t.descTipoMov}`,
          }));
        }
        this.cargandoOpciones = false;
      },
      error: () => {
        this.cargandoOpciones = false;
        this.error = 'No se pudieron cargar las listas del formulario';
      },
    });
  }

  private normalizarBody(raw: Record<string, unknown>): Record<string, unknown> {
    const body: Record<string, unknown> = {};
    for (const campo of this.data.config.campos) {
      let valor = raw[campo.key];
      if (campo.type === 'switch') {
        valor = valor === true || valor === '1' || valor === 1 ? '1' : '0';
      } else if (campo.type === 'number' || campo.type === 'select') {
        valor = valor === '' || valor == null ? null : Number(valor);
      } else if (campo.type === 'date') {
        valor = valor === '' ? null : valor;
      } else if (typeof valor === 'string') {
        valor = valor.trim();
      }
      body[campo.key] = valor;
    }
    return body;
  }

  private extraerMensajeError(err: unknown): string {
    const e = err as { error?: { message?: string; data?: Array<{ message?: string }> }; message?: string };
    const detalle = e?.error?.data?.[0]?.message;
    if (detalle) return detalle;
    if (e?.error?.message) return e.error.message;
    if (e?.message) return e.message;
    return 'No se pudo guardar el registro';
  }
}
