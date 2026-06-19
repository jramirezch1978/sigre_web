import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatDialogModule, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { forkJoin, of } from 'rxjs';
import { TablaCrudCampo, TablaCrudConfig } from '../../config/almacen-tabla-crud.config';
import { AlmacenApiService } from '../../services/almacen-api.service';
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
  readonly data = inject<AlmacenRegistroDialogData>(MAT_DIALOG_DATA);

  form!: FormGroup;
  cargandoOpciones = true;
  guardando = false;
  error = '';
  opciones: Record<string, SelectOptionDto[]> = {};

  ngOnInit(): void {
    this.form = this.fb.group({});
    for (const campo of this.data.config.campos) {
      const valor = this.data.registro?.[campo.key];
      const validators = campo.required ? [Validators.required] : [];
      if (campo.maxLength) {
        validators.push(Validators.maxLength(campo.maxLength));
      }
      this.form.addControl(
        campo.key,
        this.fb.control(valor ?? (campo.type === 'number' ? null : ''), validators)
      );
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
    const id = Number(this.data.registro?.['id'] ?? 0);
    const peticion = id
      ? this.almacenApi.actualizarRegistro(this.data.config.basePath, id, body)
      : this.almacenApi.crearRegistro(this.data.config.basePath, body);

    peticion.subscribe({
      next: () => this.dialogRef.close(true),
      error: err => {
        this.guardando = false;
        this.error = err?.error?.message ?? 'No se pudo guardar el registro';
      },
    });
  }

  opcionesDe(campo: TablaCrudCampo): SelectOptionDto[] {
    return campo.optionsFrom ? (this.opciones[campo.optionsFrom] ?? []) : [];
  }

  private cargarOpciones(): void {
    const necesitaTipos = this.data.config.campos.some(c => c.optionsFrom === 'tipos-almacen');
    const necesitaSucursales = this.data.config.campos.some(c => c.optionsFrom === 'sucursales');

    if (!necesitaTipos && !necesitaSucursales) {
      this.cargandoOpciones = false;
      return;
    }

    forkJoin({
      tipos: necesitaTipos ? this.almacenApi.listarTiposAlmacen() : of([]),
      sucursales: necesitaSucursales ? this.coreApi.listarMisSucursales() : of([]),
    }).subscribe({
      next: ({ tipos, sucursales }) => {
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
      if (campo.type === 'number' || campo.type === 'select') {
        valor = valor === '' || valor == null ? null : Number(valor);
      } else if (typeof valor === 'string') {
        valor = valor.trim();
      }
      body[campo.key] = valor;
    }
    return body;
  }
}
