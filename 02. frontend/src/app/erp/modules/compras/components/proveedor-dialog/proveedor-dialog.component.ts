import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA, MatDialogModule } from '@angular/material/dialog';
import { forkJoin, of } from 'rxjs';
import {
  abrirDialogoMetoxi,
  SigreModalService,
  SigreMetoxiModalShellComponent,
} from '@sigre-common';
import { ErpMetoxiFormFieldComponent, ErpMetoxiSelectOption } from '../../../../shared/erp-metoxi-form-field/erp-metoxi-form-field.component';
import { ErpDataTableComponent } from '../../../../shared/erp-data-table/erp-data-table.component';
import { noSoloEspaciosValidator } from '../../../../shared/utils/erp-form-validators.util';
import { ComprasApiService } from '../../services/compras-api.service';
import { ComprasCatalogoService } from '../../services/compras-catalogo.service';
import { ConsultaRucResult } from '../../../../services/erp-consulta-ruc.service';
import { BuscarRucDialogComponent } from '../../../../shared/buscar-ruc-dialog/buscar-ruc-dialog.component';
import { CatalogoCampo, CatalogoMaestroConfig } from '../../config/catalogo-maestros.config';
import { PROVEEDOR_DATOS_GENERALES, PROVEEDOR_SUBTABS, ProveedorSubTab } from '../../config/proveedor-tabs.config';
import {
  CatalogoFormDialogComponent,
  CatalogoFormDialogData,
} from '../catalogo-form-dialog/catalogo-form-dialog.component';

export interface ProveedorDialogData {
  /** Id de la relación a editar; null = nueva. */
  registroId: number | null;
}

/** Ficha de Proveedores/Clientes (CM002) — multipestaña. */
@Component({
  selector: 'app-proveedor-dialog',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    MatDialogModule,
    SigreMetoxiModalShellComponent,
    ErpMetoxiFormFieldComponent,
    ErpDataTableComponent,
  ],
  templateUrl: './proveedor-dialog.component.html',
})
export class ProveedorDialogComponent implements OnInit {
  private readonly fb = inject(FormBuilder);
  private readonly dialogRef = inject(MatDialogRef<ProveedorDialogComponent>);
  private readonly api = inject(ComprasApiService);
  private readonly catalogoSvc = inject(ComprasCatalogoService);
  private readonly dialog = inject(MatDialog);
  private readonly modal = inject(SigreModalService);
  readonly data = inject<ProveedorDialogData>(MAT_DIALOG_DATA);

  readonly camposGenerales = PROVEEDOR_DATOS_GENERALES;
  readonly subtabs = PROVEEDOR_SUBTABS;

  form!: FormGroup;
  opciones: Record<string, ErpMetoxiSelectOption[]> = {};
  subListas: Record<string, Record<string, unknown>[]> = {};
  tabActiva = 'generales';
  relacionId: number | null = null;
  cargando = true;
  guardando = false;

  get esEdicion(): boolean {
    return this.relacionId != null;
  }

  ngOnInit(): void {
    this.relacionId = this.data.registroId;
    this.form = this.fb.group({});
    for (const campo of this.camposGenerales) {
      const validators = campo.required ? [Validators.required] : [];
      if (campo.required && campo.type === 'text') validators.push(noSoloEspaciosValidator());
      if (campo.maxLength) validators.push(Validators.maxLength(campo.maxLength));
      this.form.addControl(campo.key, this.fb.control(this.valorInicialGeneral(campo, null), validators));
    }
    this.cargarOpcionesYDatos();
  }

  cerrar(): void {
    this.dialogRef.close(this.relacionId != null);
  }

  seleccionarTab(key: string): void {
    if (key !== 'generales' && !this.esEdicion) {
      void this.modal.info(
        'Primero debe crear la ficha (botón "Crear ficha" en Datos generales) para poder registrar direcciones, cuentas, líneas de crédito, representantes o teléfonos.',
        'Guarde primero los datos generales',
      );
      return;
    }
    this.tabActiva = key;
  }

  controlDe(campo: CatalogoCampo) {
    return this.form.get(campo.key);
  }

  opcionesDe(campo: CatalogoCampo): ErpMetoxiSelectOption[] {
    return this.opciones[campo.key] ?? [];
  }

  layoutDe(campo: CatalogoCampo): 'icon-inside' | 'input-group' {
    return campo.type === 'select' ? 'input-group' : 'icon-inside';
  }

  get camposGeneralesNoSwitch(): CatalogoCampo[] {
    return this.camposGenerales.filter(c => c.type !== 'switch');
  }

  get camposGeneralesSwitch(): CatalogoCampo[] {
    return this.camposGenerales.filter(c => c.type === 'switch');
  }

  /** Abre el popup "Buscar RUC" (valida formato + dígito verificador antes de llamar a la API) y llena Datos generales. */
  abrirBuscarRuc(): void {
    abrirDialogoMetoxi(this.dialog, BuscarRucDialogComponent, {})
      .afterClosed()
      .subscribe((data: ConsultaRucResult | null) => {
        if (!data) return;
        this.form.patchValue({
          nroDocumento: data.ruc || this.form.get('nroDocumento')?.value,
          razonSocial: data.razonSocial || this.form.get('razonSocial')?.value,
          nombreComercial: this.form.get('nombreComercial')?.value || data.nombreComercial || data.razonSocial || '',
          direccion: data.direccionFiscal || this.form.get('direccion')?.value,
        });
        this.preseleccionarTipoDocRuc();
      });
  }

  /** Si hay una opción "RUC" en Tipo de documento y aún no se eligió ninguna, la preselecciona. */
  private preseleccionarTipoDocRuc(): void {
    const control = this.form.get('tipoDocIdentidadId');
    if (!control || control.value != null) return;
    const opcionRuc = (this.opciones['tipoDocIdentidadId'] ?? []).find(o =>
      o.label.toUpperCase().includes('RUC'));
    if (opcionRuc) control.setValue(opcionRuc.value);
  }

  guardarGenerales(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    this.guardando = true;
    const body = this.normalizarGenerales(this.form.getRawValue());
    const obs = this.relacionId != null
      ? this.api.actualizarRelacion(this.relacionId, body)
      : this.api.crearRelacion(body);
    obs.subscribe({
      next: (res: unknown) => {
        this.guardando = false;
        if (this.relacionId == null) {
          const id = (res as { id?: number })?.id;
          if (id != null) {
            this.relacionId = id;
            void this.modal.info('Ficha creada. Ahora puede registrar direcciones, cuentas, etc.', 'Listo');
          }
        } else {
          void this.modal.info('Datos generales actualizados.', 'Listo');
        }
      },
      error: () => { this.guardando = false; },
    });
  }

  // ── Sub-recursos ────────────────────────────────────────────────
  filasSub(tab: ProveedorSubTab): Record<string, unknown>[] {
    return this.subListas[tab.key] ?? [];
  }

  agregarSub(tab: ProveedorSubTab): void {
    this.abrirSubDialogo(tab, null);
  }

  editarSub(tab: ProveedorSubTab, fila: Record<string, unknown>): void {
    if (!tab.editable) return;
    this.abrirSubDialogo(tab, fila);
  }

  eliminarSub(tab: ProveedorSubTab, fila: Record<string, unknown>): void {
    if (!tab.editable || this.relacionId == null) return;
    const id = fila['id'] as number;
    this.modal.confirmEliminar$(tab.label).subscribe(ok => {
      if (!ok) return;
      this.catalogoSvc.eliminar(this.endpointSub(tab), id).subscribe({
        next: () => this.cargarSub(tab),
      });
    });
  }

  private abrirSubDialogo(tab: ProveedorSubTab, registro: Record<string, unknown> | null): void {
    if (this.relacionId == null) return;
    const cfg: CatalogoMaestroConfig = {
      codigo: '', nombre: tab.label,
      endpoint: this.endpointSub(tab),
      columnas: tab.columnas, campos: tab.campos,
    };
    const data: CatalogoFormDialogData = {
      titulo: registro ? `Editar ${tab.label}` : `Nuevo · ${tab.label}`,
      config: cfg, registro,
    };
    abrirDialogoMetoxi(this.dialog, CatalogoFormDialogComponent, { data, width: '640px' })
      .afterClosed()
      .subscribe(ok => { if (ok) this.cargarSub(tab); });
  }

  private endpointSub(tab: ProveedorSubTab): string {
    return `/relaciones-comerciales/${this.relacionId}/${tab.endpointSuffix}`;
  }

  private cargarSub(tab: ProveedorSubTab): void {
    if (this.relacionId == null) return;
    this.api.listarSub(this.relacionId, tab.endpointSuffix).subscribe({
      next: filas => { this.subListas[tab.key] = filas; },
    });
  }

  // ── Carga inicial ───────────────────────────────────────────────
  private cargarOpcionesYDatos(): void {
    forkJoin({
      tiposDoc: this.catalogoSvc.listar<Record<string, unknown>>('/tipos-documento-identidad'),
      tiposEnt: this.api.listarTiposEntidad(),
      detalle: this.relacionId != null ? this.api.detalleRelacion(this.relacionId) : of(null),
    }).subscribe({
      next: ({ tiposDoc, tiposEnt, detalle }) => {
        this.opciones['tipoDocIdentidadId'] = (tiposDoc as Record<string, unknown>[])
          .filter(d => String(d['flagEstado'] ?? '1') !== '0')
          .map(d => ({ value: Number(d['id']), label: `${d['codigo'] ?? ''} — ${d['nombre'] ?? ''}` }));
        this.opciones['tipoEntidadContribuyenteId'] = tiposEnt.map(t => ({ value: t.id, label: `${t.tipo}${t.descripcion ? ' — ' + t.descripcion : ''}` }));
        if (detalle) this.cargarDetalle(detalle as Record<string, unknown>);
        this.cargando = false;
      },
      error: () => { this.cargando = false; },
    });
  }

  private cargarDetalle(detalle: Record<string, unknown>): void {
    for (const campo of this.camposGenerales) {
      this.form.get(campo.key)?.setValue(this.valorInicialGeneral(campo, detalle));
    }
    for (const tab of this.subtabs) {
      if (tab.detalleKey && Array.isArray(detalle[tab.detalleKey])) {
        this.subListas[tab.key] = detalle[tab.detalleKey] as Record<string, unknown>[];
      } else {
        this.cargarSub(tab);
      }
    }
  }

  private valorInicialGeneral(campo: CatalogoCampo, reg: Record<string, unknown> | null): unknown {
    if (!reg) {
      if (campo.type === 'switch') return campo.key === 'flagEstado';
      if (campo.type === 'select') return null;
      return '';
    }
    if (campo.type === 'switch') {
      const raw = reg[campo.key];
      return raw === true || raw === '1' || raw === 1;
    }
    if (campo.type === 'select') {
      const raw = reg[campo.key];
      return raw == null || raw === '' ? null : Number(raw);
    }
    return reg[campo.key] ?? '';
  }

  private normalizarGenerales(raw: Record<string, unknown>): Record<string, unknown> {
    const body: Record<string, unknown> = {};
    for (const campo of this.camposGenerales) {
      let valor = raw[campo.key];
      if (campo.type === 'switch') {
        const on = valor === true || valor === '1' || valor === 1;
        valor = campo.key === 'flagEstado' ? (on ? '1' : '0') : on; // flagEstado string; el resto boolean
      } else if (campo.type === 'select') {
        valor = valor === '' || valor == null ? null : Number(valor);
      } else if (typeof valor === 'string') {
        valor = valor.trim();
      }
      body[campo.key] = valor;
    }
    return body;
  }
}
