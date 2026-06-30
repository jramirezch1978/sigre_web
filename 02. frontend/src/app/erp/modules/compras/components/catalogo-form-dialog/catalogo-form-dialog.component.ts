import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { forkJoin, of } from 'rxjs';
import {
  SigreMetoxiModalShellComponent,
  SigreMetoxiModalActionsComponent,
} from '@sigre-common';
import { ErpMetoxiFormFieldComponent, ErpMetoxiSelectOption } from '../../../../shared/erp-metoxi-form-field/erp-metoxi-form-field.component';
import { noSoloEspaciosValidator } from '../../../../shared/utils/erp-form-validators.util';
import { CatalogoCampo, CatalogoMaestroConfig } from '../../config/catalogo-maestros.config';
import { ComprasCatalogoService } from '../../services/compras-catalogo.service';

export interface CatalogoFormDialogData {
  titulo: string;
  config: CatalogoMaestroConfig;
  registro?: Record<string, unknown> | null;
}

/** Formulario genérico de alta/edición para los maestros de catálogo. */
@Component({
  selector: 'app-catalogo-form-dialog',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    SigreMetoxiModalShellComponent,
    SigreMetoxiModalActionsComponent,
    ErpMetoxiFormFieldComponent,
  ],
  templateUrl: './catalogo-form-dialog.component.html',
})
export class CatalogoFormDialogComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly dialogRef = inject(MatDialogRef<CatalogoFormDialogComponent>);
  private readonly catalogoSvc = inject(ComprasCatalogoService);
  readonly data = inject<CatalogoFormDialogData>(MAT_DIALOG_DATA);

  form!: FormGroup;
  cargandoOpciones = true;
  guardando = false;
  opciones: Record<string, ErpMetoxiSelectOption[]> = {};
  private esEdicion = false;

  ngOnInit(): void {
    this.esEdicion = !!this.data.registro?.['id'];
    this.form = this.fb.group({});
    for (const campo of this.data.config.campos) {
      const validators = campo.required ? [Validators.required] : [];
      if (campo.required && campo.type === 'text') validators.push(noSoloEspaciosValidator());
      if (campo.maxLength) validators.push(Validators.maxLength(campo.maxLength));
      this.form.addControl(
        campo.key,
        this.fb.control(
          { value: this.valorInicial(campo), disabled: this.esEdicion && !!campo.readonlyOnEdit },
          validators,
        ),
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
    const body = this.normalizarBody(this.form.getRawValue());
    const id = this.data.registro?.['id'] as number | undefined;
    const obs = id != null
      ? this.catalogoSvc.actualizar(this.data.config.endpoint, id, body)
      : this.catalogoSvc.crear(this.data.config.endpoint, body);
    obs.subscribe({
      next: () => this.dialogRef.close(true),
      error: () => { this.guardando = false; },
    });
  }

  controlDe(campo: CatalogoCampo) {
    return this.form.get(campo.key);
  }

  opcionesDe(campo: CatalogoCampo): ErpMetoxiSelectOption[] {
    return this.opciones[campo.key] ?? [];
  }

  tipoFormField(campo: CatalogoCampo): 'text' | 'number' | 'select' | 'switch' {
    return campo.type;
  }

  layoutDe(campo: CatalogoCampo): 'icon-inside' | 'input-group' {
    return campo.type === 'select' ? 'input-group' : 'icon-inside';
  }

  get camposNoSwitch(): CatalogoCampo[] {
    return this.data.config.campos.filter(c => c.type !== 'switch');
  }

  get camposSwitch(): CatalogoCampo[] {
    return this.data.config.campos.filter(c => c.type === 'switch');
  }

  placeholderDe(campo: CatalogoCampo): string {
    return `Ingrese ${campo.label.toLowerCase()}…`;
  }

  private valorInicial(campo: CatalogoCampo): unknown {
    const reg = this.data.registro;
    if (!reg) {
      if (campo.type === 'switch') return true; // estado activo por defecto
      if (campo.type === 'select' || campo.type === 'number') return null;
      return '';
    }
    if (campo.type === 'switch') {
      const raw = reg[campo.key];
      return raw === '1' || raw === 1 || raw === true;
    }
    if (campo.type === 'select') {
      const raw = reg[campo.key];
      return raw == null || raw === '' ? null : Number(raw);
    }
    return reg[campo.key] ?? (campo.type === 'number' ? null : '');
  }

  private normalizarBody(raw: Record<string, unknown>): Record<string, unknown> {
    const body: Record<string, unknown> = {};
    for (const campo of this.data.config.campos) {
      let valor = raw[campo.key];
      if (campo.type === 'switch') {
        valor = valor === true || valor === '1' || valor === 1 ? '1' : '0';
      } else if (campo.type === 'number' || campo.type === 'select') {
        valor = valor === '' || valor == null ? null : Number(valor);
      } else if (typeof valor === 'string') {
        valor = valor.trim();
      }
      body[campo.key] = valor;
    }
    return body;
  }

  private cargarOpciones(): void {
    const selects = this.data.config.campos.filter(c => c.type === 'select' && c.optionsEndpoint);
    if (!selects.length) {
      this.cargandoOpciones = false;
      return;
    }
    const cargas = selects.map(c =>
      this.catalogoSvc.listar<Record<string, unknown>>(c.optionsEndpoint!),
    );
    forkJoin(cargas.length ? cargas : [of([])]).subscribe({
      next: resultados => {
        selects.forEach((campo, i) => {
          const filas = (resultados[i] ?? []) as Record<string, unknown>[];
          const valueKey = campo.optionsValueKey ?? 'id';
          const labelKeys = campo.optionsLabelKeys ?? ['nombre'];
          this.opciones[campo.key] = filas
            .filter(f => String(f['flagEstado'] ?? '1') !== '0')
            .map(f => ({
              value: Number(f[valueKey]),
              label: labelKeys.map(k => f[k]).filter(v => v != null && v !== '').join(' — '),
            }));
        });
        this.cargandoOpciones = false;
      },
      error: () => { this.cargandoOpciones = false; },
    });
  }
}
