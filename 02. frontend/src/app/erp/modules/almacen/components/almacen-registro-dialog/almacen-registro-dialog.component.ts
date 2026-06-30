import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { forkJoin, of, Observable } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { TablaCrudCampo, TablaCrudConfig } from '../../config/almacen-tabla-crud.config';
import { AlmacenApiService } from '../../services/almacen-api.service';
import { AlmacenCrudService } from '../../services/almacen-crud.service';
import { CoreApiService, SelectOptionDto } from '../../services/core-api.service';
import {
  abrirDialogoMetoxi,
  SigreModalService,
  SigreMetoxiModalActionsComponent,
  SigreMetoxiModalShellComponent,
} from '@sigre-common';
import {
  ArticuloBuscadorDialogComponent,
  ArticuloBuscarItem,
} from '../../../../shared/articulo-buscador-dialog/articulo-buscador-dialog.component';
import { ErpMetoxiFormFieldComponent } from '../../../../shared/erp-metoxi-form-field/erp-metoxi-form-field.component';
import { colClassMetoxiCampo } from '../../../../shared/utils/erp-metoxi-form-icons.util';
import { noSoloEspaciosValidator } from '../../../../shared/utils/erp-form-validators.util';

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
    SigreMetoxiModalShellComponent,
    SigreMetoxiModalActionsComponent,
    ErpMetoxiFormFieldComponent,
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
  private readonly modal = inject(SigreModalService);
  private readonly matDialog = inject(MatDialog);
  readonly data = inject<AlmacenRegistroDialogData>(MAT_DIALOG_DATA);

  form!: FormGroup;
  cargandoOpciones = true;
  guardando = false;
  error = '';
  opciones: Record<string, SelectOptionDto[]> = {};
  /** Etiqueta visible del artículo elegido por campo (key -> "codigo — descripción"). */
  articuloLabels: Record<string, string> = {};
  private esEdicion = false;

  /** Abre el buscador de artículos activos (con equivalencias) y fija el id elegido. */
  abrirBuscadorArticulo(campo: TablaCrudCampo): void {
    abrirDialogoMetoxi(this.matDialog, ArticuloBuscadorDialogComponent, { width: '900px' })
      .afterClosed()
      .subscribe((item: ArticuloBuscarItem | null) => {
        if (!item) return;
        this.form.get(campo.key)?.setValue(item.id);
        this.form.get(campo.key)?.markAsDirty();
        this.articuloLabels[campo.key] = `${item.codigo} — ${item.descripcion}`;
      });
  }

  /** Texto a mostrar en el botón del campo artículo. */
  etiquetaArticulo(campo: TablaCrudCampo): string {
    if (this.articuloLabels[campo.key]) return this.articuloLabels[campo.key];
    const v = this.form.get(campo.key)?.value;
    return v ? `Artículo #${v}` : 'Buscar artículo…';
  }

  limpiarArticulo(campo: TablaCrudCampo): void {
    this.form.get(campo.key)?.setValue(null);
    delete this.articuloLabels[campo.key];
  }

  ngOnInit(): void {
    this.esEdicion = !!this.data.registro?.['id'] || this.data.config.handler === 'parametro';
    this.form = this.fb.group({});
    for (const campo of this.data.config.campos) {
      const valor = this.valorInicial(campo);
      const validators = campo.required ? [Validators.required] : [];
      if (campo.required && campo.type === 'text') {
        validators.push(noSoloEspaciosValidator());
      }
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
      // El error lo muestra el interceptor global (ApiErrorInterceptor); aquí solo se restaura el estado.
      error: () => { this.guardando = false; },
    });
  }

  opcionesDe(campo: TablaCrudCampo): SelectOptionDto[] {
    return campo.optionsFrom ? (this.opciones[campo.optionsFrom] ?? []) : [];
  }

  /** Excluye de los desplegables FK los registros anulados/inactivos (flag_estado = '0'). */
  private soloActivos<T>(items: T[]): T[] {
    return items.filter(i => String((i as { flagEstado?: unknown }).flagEstado ?? '1') !== '0');
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

  controlDe(campo: TablaCrudCampo) {
    return this.form.get(campo.key);
  }

  etiquetaCampo(campo: TablaCrudCampo): string {
    return campo.required ? `${campo.label} *` : campo.label;
  }

  colClassDe(campo: TablaCrudCampo): string {
    return colClassMetoxiCampo(campo.key, this.tipoFormField(campo));
  }

  /** Campos normales (no flags ni factores de saldo) — van en la fila principal. */
  get camposNoSwitch(): TablaCrudCampo[] {
    return this.data.config.campos.filter(c => c.type !== 'switch' && c.type !== 'saldo-factor');
  }

  /** Flags (switch) — van juntos en una fila aparte al final. */
  get camposSwitch(): TablaCrudCampo[] {
    return this.data.config.campos.filter(c => c.type === 'switch');
  }

  /** Factores de saldo (tri-estado) — van en su propio panel al final. */
  get camposSaldo(): TablaCrudCampo[] {
    return this.data.config.campos.filter(c => c.type === 'saldo-factor');
  }

  /** Tipo que ve el form-field compartido (select-text se renderiza como select). */
  tipoFormField(campo: TablaCrudCampo): 'text' | 'number' | 'select' | 'date' | 'switch' | 'centros-costo' | 'textarea' {
    if (campo.type === 'select-text') return 'select';
    if (campo.type === 'saldo-factor') return 'number';
    return campo.type as 'text' | 'number' | 'select' | 'date' | 'switch' | 'centros-costo' | 'textarea';
  }

  /** Opciones del radio tri-estado para los factores de saldo. */
  readonly opcionesSaldo: ReadonlyArray<{ valor: number; etiqueta: string }> = [
    { valor: 1, etiqueta: 'Incrementa' },
    { valor: -1, etiqueta: 'Disminuye' },
    { valor: 0, etiqueta: 'Nada' },
  ];

  /** Marca el valor tri-estado de un factor de saldo. */
  setSaldo(campo: TablaCrudCampo, valor: number): void {
    const c = this.form.get(campo.key);
    c?.setValue(valor);
    c?.markAsDirty();
  }

  placeholderDe(campo: TablaCrudCampo): string {
    return `Ingrese ${campo.label.toLowerCase()}…`;
  }

  layoutDe(campo: TablaCrudCampo): 'icon-inside' | 'input-group' {
    return campo.type === 'select' || campo.type === 'select-text' ? 'input-group' : 'icon-inside';
  }

  private valorInicial(campo: TablaCrudCampo): unknown {
    const reg = this.data.registro;
    if (!reg) {
      // Valor por defecto explícito en la config (tiene prioridad).
      if (campo.defaultValue !== undefined) {
        if (campo.type === 'switch') {
          return campo.defaultValue === true || campo.defaultValue === '1' || campo.defaultValue === 1;
        }
        return campo.defaultValue;
      }
      if (campo.type === 'switch') {
        // Activos por defecto solo el estado y el control de lote; el resto, apagado.
        return ['flagEstado', 'flagCntrlLote'].includes(campo.key);
      }
      if (campo.type === 'saldo-factor') return 0;
      if (campo.type === 'articulo') return null;
      if (campo.key === 'ano') return new Date().getFullYear();
      if (campo.key === 'fechaMov' || campo.key === 'fecha' || campo.key === 'fechaConteo') {
        return new Date().toISOString().slice(0, 10);
      }
      if (campo.type === 'select' || campo.type === 'number') return null;
      return '';
    }
    if (campo.type === 'switch') {
      const raw = reg[campo.key];
      return raw === '1' || raw === 1 || raw === true;
    }
    if (campo.type === 'saldo-factor') {
      const raw = reg[campo.key];
      if (raw == null || raw === '') return 0;
      const n = Number(raw);
      // Normaliza a tri-estado: >0 -> 1, <0 -> -1, 0 -> 0.
      return Number.isNaN(n) ? 0 : (n > 0 ? 1 : (n < 0 ? -1 : 0));
    }
    if (campo.type === 'select-text') {
      const raw = reg[campo.key];
      return raw == null || raw === '—' ? '' : String(raw);
    }
    if (campo.type === 'articulo') {
      const raw = reg[campo.key];
      return raw == null || raw === '' ? null : Number(raw);
    }
    if (campo.type === 'select') {
      const raw = reg[campo.key];
      if (raw == null || raw === '') return null;
      const num = Number(raw);
      return Number.isNaN(num) ? raw : num;
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
    const necesitaCentrosCosto = campos.some(c => c.optionsFrom === 'centros-costo');
    const necesitaProveedores = campos.some(c => c.optionsFrom === 'proveedores');
    const necesitaUbigeos = campos.some(c => c.optionsFrom === 'ubigeos');
    const necesitaUsuarios = campos.some(c => c.optionsFrom === 'usuarios-empresa');
    const necesitaUnidades = campos.some(c => c.optionsFrom === 'unidades');
    const necesitaLibros = campos.some(c => c.optionsFrom === 'libros-contables');
    const necesitaSunat = campos.some(c => c.optionsFrom === 'sunat-tab12');

    if (!necesitaTipos && !necesitaSucursales && !necesitaAlmacenes && !necesitaTiposMov
        && !necesitaCentrosCosto && !necesitaProveedores && !necesitaUbigeos && !necesitaUsuarios
        && !necesitaUnidades && !necesitaLibros && !necesitaSunat) {
      this.cargandoOpciones = false;
      return;
    }

    // Cada lista se carga de forma independiente: si una falla (servicio caído, endpoint nuevo
    // sin desplegar, etc.) NO debe bloquear el resto del formulario. Se reporta solo cuáles fallaron.
    const fallidas: string[] = [];
    const resiliente = <T>(etiqueta: string, fuente: Observable<T[]>): Observable<T[]> =>
      fuente.pipe(catchError(() => { fallidas.push(etiqueta); return of([] as T[]); }));

    forkJoin({
      tipos: necesitaTipos ? resiliente('tipos de almacén', this.almacenApi.listarTiposAlmacen()) : of([]),
      sucursales: necesitaSucursales ? resiliente('sucursales', this.coreApi.listarMisSucursales()) : of([]),
      almacenes: necesitaAlmacenes ? resiliente('almacenes', this.almacenApi.listarAlmacenes()) : of([]),
      tiposMov: necesitaTiposMov ? resiliente('tipos de movimiento', this.almacenApi.listarTiposMovimiento()) : of([]),
      centrosCosto: necesitaCentrosCosto ? resiliente('centros de costo', this.coreApi.listarCentrosCosto()) : of([]),
      proveedores: necesitaProveedores ? resiliente('proveedores', this.coreApi.listarProveedores()) : of([]),
      ubigeos: necesitaUbigeos ? resiliente('ubigeos', this.almacenApi.listarUbigeos()) : of([]),
      usuarios: necesitaUsuarios ? resiliente('responsables', this.coreApi.listarUsuariosEmpresa()) : of([]),
      unidades: necesitaUnidades ? resiliente('unidades de medida', this.coreApi.listarUnidadesMedida()) : of([]),
      libros: necesitaLibros ? resiliente('libros contables', this.coreApi.listarLibrosContables()) : of([]),
      sunat: necesitaSunat ? resiliente('códigos SUNAT', this.coreApi.listarSunatTab12()) : of([]),
    }).subscribe({
      next: ({ tipos, sucursales, almacenes, tiposMov, centrosCosto, proveedores, ubigeos, usuarios, unidades, libros, sunat }) => {
        if (necesitaTipos) {
          this.opciones['tipos-almacen'] = this.soloActivos(tipos).map(t => ({
            value: t.id,
            label: `${t.codigo} — ${t.nombre}`,
          }));
        }
        if (necesitaSucursales) {
          this.opciones['sucursales'] = this.soloActivos(sucursales).map(s => ({
            value: s.id,
            label: `${s.codigo ?? s.id} — ${s.nombre}`,
          }));
        }
        if (necesitaAlmacenes) {
          this.opciones['almacenes'] = this.soloActivos(almacenes).map(a => ({
            value: a.id,
            label: `${a.codigo} — ${a.nombre}`,
          }));
        }
        if (necesitaTiposMov) {
          this.opciones['tipos-movimiento'] = this.soloActivos(tiposMov).map(t => ({
            value: t.id,
            label: `${t.tipoMov} — ${t.descTipoMov}`,
          }));
        }
        if (necesitaCentrosCosto) {
          this.opciones['centros-costo'] = centrosCosto;
        }
        if (necesitaProveedores) {
          this.opciones['proveedores'] = proveedores;
        }
        if (necesitaUbigeos) {
          this.opciones['ubigeos'] = ubigeos;
        }
        if (necesitaUsuarios) {
          this.opciones['usuarios-empresa'] = usuarios;
        }
        if (necesitaUnidades) {
          this.opciones['unidades'] = this.soloActivos(unidades).map(u => ({
            value: u.id,
            label: `${u.codigo ?? u.id} — ${u.nombre}`,
          }));
        }
        if (necesitaLibros) {
          this.opciones['libros-contables'] = libros;
        }
        if (necesitaSunat) {
          this.opciones['sunat-tab12'] = sunat;
        }
        this.cargandoOpciones = false;
        // El formulario queda usable; solo se avisa (modal WARNING) de las listas que no cargaron.
        if (fallidas.length) {
          void this.modal.warning(
            `No se pudieron cargar algunas listas (${fallidas.join(', ')}). Esos campos quedarán vacíos; puede continuar.`,
            'Advertencia');
        }
      },
      error: () => {
        this.cargandoOpciones = false;
        void this.modal.error('No se pudieron cargar las listas del formulario.', 'Error');
      },
    });
  }

  private normalizarBody(raw: Record<string, unknown>): Record<string, unknown> {
    const body: Record<string, unknown> = {};
    for (const campo of this.data.config.campos) {
      let valor = raw[campo.key];
      if (campo.type === 'switch') {
        valor = valor === true || valor === '1' || valor === 1 ? '1' : '0';
      } else if (campo.type === 'saldo-factor') {
        const n = Number(valor);
        valor = Number.isNaN(n) ? 0 : (n > 0 ? 1 : (n < 0 ? -1 : 0));
      } else if (campo.type === 'number' || campo.type === 'select' || campo.type === 'articulo') {
        valor = valor === '' || valor == null ? null : Number(valor);
      } else if (campo.type === 'select-text') {
        valor = valor == null || valor === '' ? null : String(valor);
      } else if (campo.type === 'date') {
        valor = valor === '' ? null : valor;
      } else if (typeof valor === 'string') {
        valor = valor.trim();
      }
      body[campo.key] = valor;
    }
    return body;
  }
}
