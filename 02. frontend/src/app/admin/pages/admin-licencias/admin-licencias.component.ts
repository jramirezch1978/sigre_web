import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { SigreModalService } from '@sigre-common';
import { StorageService } from '../../../core/services/storage.service';
import { LoginData } from '../../../auth/services/auth.service';
import { AdminLicenciasService, LicenciaAdminDto } from '../../services/admin-licencias.service';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { EmpresaAdminDto, EdicionErpDto } from '../../models/admin.models';
import { TablaColumna } from '../../../erp/shared/models/api-page.model';
import { ErpExportService, ExportFormato } from '../../../erp/shared/utils/erp-export.service';
import { AdminTablaPageBase } from '../../shared/admin-tabla-page-base';

@Component({
  selector: 'app-admin-licencias',
  templateUrl: './admin-licencias.component.html',
  styleUrls: ['./admin-licencias.component.scss'],
  standalone: false,
})
export class AdminLicenciasComponent extends AdminTablaPageBase<LicenciaAdminDto> implements OnInit {
  // Tabla propia (celdas/acciones especiales); columnas reales usadas solo para exportar.
  readonly columnasTabla: TablaColumna[] = [
    { key: 'empresa', header: 'Empresa' },
    { key: 'licencia', header: 'Licencia' },
    { key: 'edicion', header: 'Edición' },
    { key: 'tipo', header: 'Tipo' },
    { key: 'vence', header: 'Vence', format: 'fecha' },
    { key: 'dias', header: 'Días', format: 'numero' },
  ];
  protected get registrosTabla(): LicenciaAdminDto[] { return this.licenciasFiltradas; }
  protected aFila(l: LicenciaAdminDto): Record<string, unknown> { return { id: l.id }; }

  // ── Orden por columna (persistido, como el resto de admin) ──
  ordenColumna: string | null = (this.ordenInicial ?? '').split(':')[0] || null;
  ordenDir: 'asc' | 'desc' = (this.ordenInicial ?? '').split(':')[1] === 'desc' ? 'desc' : 'asc';

  // ── Exportar (xlsx/docx/pdf) ──
  mostrarModalExport = false;
  exportando = false;

  private readonly exportSvc = inject(ErpExportService);
  private readonly api = inject(AdminLicenciasService);
  private readonly adminApi = inject(AdminSeguridadApiService);
  private readonly fb = inject(FormBuilder);
  private readonly modal = inject(SigreModalService);
  private readonly storage = inject(StorageService);

  licencias: LicenciaAdminDto[] = [];
  empresas: EmpresaAdminDto[] = [];
  ediciones: EdicionErpDto[] = [];
  cargando = true;
  guardando = false;
  filtro = '';
  tipoSales: string | null = null;

  mostrarRenovar = false;
  mostrarAmpliar = false;
  mostrarNueva = false;
  mostrarEditar = false;
  seleccion: LicenciaAdminDto | null = null;

  readonly formEditar: FormGroup = this.fb.group({
    edicionCodigo: ['', Validators.required],
    maxUsuarios: [null],
    correoResponsable: ['', [Validators.email, Validators.maxLength(150)]],
  });

  readonly formNueva: FormGroup = this.fb.group({
    empresaId: [null, Validators.required],
    edicionCodigo: ['', Validators.required],
    tipo: ['P', Validators.required],
    maxUsuarios: [null],
    correoResponsable: ['', [Validators.email, Validators.maxLength(150)]],
  });

  readonly formRenovar: FormGroup = this.fb.group({
    fechaPago: [this.hoy(), Validators.required],
    voucher: ['', [Validators.required, Validators.maxLength(80)]],
  });
  readonly formAmpliar: FormGroup = this.fb.group({
    nuevaFecha: ['', Validators.required],
  });

  get esLicensing(): boolean {
    return this.tipoSales === 'LICENSING';
  }

  ngOnInit(): void {
    this.tipoSales = this.storage.getUser<LoginData>()?.tipoSales ?? null;
    this.cargar();
    if (this.esLicensing) {
      this.adminApi.listarEmpresas().subscribe({ next: r => this.empresas = r.data ?? [] });
      this.adminApi.listarEdiciones().subscribe({ next: r => this.ediciones = (r.data ?? []).filter(e => e.activo !== false) });
      // Autocompletar Máx. usuarios al cambiar edición o tipo.
      this.formNueva.get('edicionCodigo')?.valueChanges.subscribe(() => this.autoMaxUsuarios());
      this.formNueva.get('tipo')?.valueChanges.subscribe(() => this.autoMaxUsuarios());
    }
  }

  /** Máx. usuarios por defecto: Demo = 5; Pago = el de la edición seleccionada. */
  private autoMaxUsuarios(): void {
    if (this.formNueva.get('tipo')?.value === 'D') {
      this.formNueva.get('maxUsuarios')?.setValue(5);
      return;
    }
    const cod = this.formNueva.get('edicionCodigo')?.value;
    const ed = this.ediciones.find(e => e.codigo === cod);
    this.formNueva.get('maxUsuarios')?.setValue(ed?.maxUsuarios ?? null);
  }

  // ── Crear licencia (solo LICENSING) ──
  abrirNueva(): void {
    this.formNueva.reset({ empresaId: null, edicionCodigo: '', tipo: 'P', maxUsuarios: null, correoResponsable: '' });
    this.mostrarNueva = true;
  }
  cerrarNueva(): void { this.mostrarNueva = false; }

  confirmarNueva(): void {
    if (this.formNueva.invalid) { this.formNueva.markAllAsTouched(); return; }
    this.guardando = true;
    const v = this.formNueva.value;
    this.api.crear({
      empresaId: Number(v.empresaId),
      edicionCodigo: v.edicionCodigo,
      tipo: v.tipo,
      maxUsuarios: v.maxUsuarios ? Number(v.maxUsuarios) : null,
      correoResponsable: v.correoResponsable || null,
    }).subscribe({
      next: () => {
        this.guardando = false;
        this.cerrarNueva();
        void this.modal.success('Licencia creada', 'La licencia se asignó correctamente.');
        this.cargar();
      },
      error: e => { this.guardando = false; void this.modal.error(e?.error?.message ?? 'No se pudo crear la licencia.'); },
    });
  }

  // ── Editar licencia (solo LICENSING) ──
  abrirEditar(l: LicenciaAdminDto): void {
    this.seleccion = l;
    this.formEditar.reset({
      edicionCodigo: l.edicion_codigo,
      maxUsuarios: l.max_usuarios,
      correoResponsable: l.correo_responsable ?? '',
    });
    this.mostrarEditar = true;
  }
  cerrarEditar(): void { this.mostrarEditar = false; this.seleccion = null; }

  confirmarEditar(): void {
    if (this.formEditar.invalid || !this.seleccion) { this.formEditar.markAllAsTouched(); return; }
    this.guardando = true;
    const v = this.formEditar.value;
    this.api.modificar(this.seleccion.id, {
      edicionCodigo: v.edicionCodigo,
      maxUsuarios: v.maxUsuarios ? Number(v.maxUsuarios) : null,
      correoResponsable: v.correoResponsable || null,
    }).subscribe({
      next: () => {
        this.guardando = false;
        this.cerrarEditar();
        void this.modal.success('Licencia actualizada', 'Los cambios se guardaron correctamente.');
        this.cargar();
      },
      error: e => { this.guardando = false; void this.modal.error(e?.error?.message ?? 'No se pudo modificar la licencia.'); },
    });
  }

  async anular(l: LicenciaAdminDto): Promise<void> {
    const ok = await this.modal.confirm({
      titulo: 'Anular licencia', mensaje: `¿Anular la licencia de ${l.razon_social}?`,
      tipo: 'warning', textoConfirmar: 'Anular', textoCancelar: 'Cancelar', conCancelar: true,
    });
    if (!ok) return;
    this.api.anular(l.id).subscribe({
      next: () => { void this.modal.success('Licencia anulada', ''); this.cargar(); },
      error: e => void this.modal.error(e?.error?.message ?? 'No se pudo anular.'),
    });
  }

  async eliminar(l: LicenciaAdminDto): Promise<void> {
    const ok = await this.modal.confirm({
      titulo: 'Eliminar licencia', mensaje: `¿Eliminar la licencia de ${l.razon_social}?`,
      submensaje: 'Esta acción la retira del listado.',
      tipo: 'warning', textoConfirmar: 'Eliminar', textoCancelar: 'Cancelar', conCancelar: true,
    });
    if (!ok) return;
    this.api.eliminar(l.id).subscribe({
      next: () => { void this.modal.success('Licencia eliminada', ''); this.cargar(); },
      error: e => void this.modal.error(e?.error?.message ?? 'No se pudo eliminar.'),
    });
  }

  get licenciasFiltradas(): LicenciaAdminDto[] {
    const q = this.filtro.trim().toLowerCase();
    let lista = !q
      ? this.licencias
      : this.licencias.filter(l =>
          `${l.razon_social} ${l.codigo_licencia} ${l.edicion_codigo}`.toLowerCase().includes(q));

    if (this.ordenColumna) {
      const col = this.ordenColumna;
      const factor = this.ordenDir === 'desc' ? -1 : 1;
      lista = [...lista].sort((a, b) => this.compararCampo(a, b, col) * factor);
    }
    return lista;
  }

  ordenarPor(columna: string): void {
    if (this.ordenColumna === columna) {
      this.ordenDir = this.ordenDir === 'asc' ? 'desc' : 'asc';
    } else {
      this.ordenColumna = columna;
      this.ordenDir = 'asc';
    }
    this.paginaActual = 1;
    this.onOrdenCambiado(`${this.ordenColumna}:${this.ordenDir}`);
  }

  private compararCampo(a: LicenciaAdminDto, b: LicenciaAdminDto, key: string): number {
    const va = (a as unknown as Record<string, unknown>)[key];
    const vb = (b as unknown as Record<string, unknown>)[key];
    if (va == null && vb == null) return 0;
    if (va == null) return -1;
    if (vb == null) return 1;
    if (typeof va === 'number' && typeof vb === 'number') return va - vb;
    return String(va).localeCompare(String(vb), 'es', { numeric: true, sensitivity: 'base' });
  }

  // ── Exportar ──
  abrirModalExport(): void {
    if (this.licenciasFiltradas.length === 0) return;
    this.mostrarModalExport = true;
  }
  cerrarModalExport(): void { this.mostrarModalExport = false; }

  exportarExcel(): void { this.ejecutarExport('xlsx'); }
  exportarWord(): void { this.ejecutarExport('docx'); }
  exportarPdf(): void { this.ejecutarExport('pdf'); }

  private ejecutarExport(formato: ExportFormato): void {
    if (this.exportando) return;
    this.exportando = true;
    const filas = this.filasExport();
    this.exportSvc
      .exportar(formato, this.columnasTabla, filas, 'licencias', (fila, col) => String(fila[col.key] ?? '—'))
      .subscribe({
        next: () => { this.exportando = false; this.cerrarModalExport(); },
        error: () => { this.exportando = false; this.cerrarModalExport(); },
      });
  }

  private filasExport(): Record<string, unknown>[] {
    return this.licenciasFiltradas.map(l => ({
      empresa: l.razon_social,
      licencia: l.codigo_licencia,
      edicion: l.edicion_codigo,
      tipo: this.esDemo(l) ? 'Demo' : 'Pago',
      vence: l.fecha_vencimiento,
      dias: l.dias_restantes,
    }));
  }

  cargar(): void {
    this.cargando = true;
    this.api.listar().subscribe({
      next: r => { this.licencias = r.data ?? []; this.cargando = false; },
      error: () => { this.cargando = false; void this.modal.error('No se pudieron cargar las licencias.'); },
    });
  }

  // ── Renovar (LICENSING o SALES) ──
  abrirRenovar(l: LicenciaAdminDto): void {
    this.seleccion = l;
    this.formRenovar.reset({ fechaPago: this.hoy(), voucher: '' });
    this.mostrarRenovar = true;
  }
  cerrarRenovar(): void { this.mostrarRenovar = false; this.seleccion = null; }

  confirmarRenovar(): void {
    if (this.formRenovar.invalid || !this.seleccion) { this.formRenovar.markAllAsTouched(); return; }
    this.guardando = true;
    const { fechaPago, voucher } = this.formRenovar.value;
    this.api.renovar(this.seleccion.empresa_id, fechaPago, voucher).subscribe({
      next: () => {
        this.guardando = false;
        this.cerrarRenovar();
        void this.modal.success('Licencia renovada', 'La renovación se registró correctamente.');
        this.cargar();
      },
      error: e => { this.guardando = false; void this.modal.error(e?.error?.message ?? 'No se pudo renovar.'); },
    });
  }

  // ── Ampliar demo (solo LICENSING) ──
  abrirAmpliar(l: LicenciaAdminDto): void {
    this.seleccion = l;
    this.formAmpliar.reset({ nuevaFecha: '' });
    this.mostrarAmpliar = true;
  }
  cerrarAmpliar(): void { this.mostrarAmpliar = false; this.seleccion = null; }

  confirmarAmpliar(): void {
    if (this.formAmpliar.invalid || !this.seleccion) { this.formAmpliar.markAllAsTouched(); return; }
    this.guardando = true;
    const iso = new Date(this.formAmpliar.value.nuevaFecha).toISOString();
    this.api.ampliarDemo(this.seleccion.empresa_id, iso).subscribe({
      next: () => {
        this.guardando = false;
        this.cerrarAmpliar();
        void this.modal.success('Demo ampliada', 'El vencimiento se amplió correctamente.');
        this.cargar();
      },
      error: e => { this.guardando = false; void this.modal.error(e?.error?.message ?? 'No se pudo ampliar.'); },
    });
  }

  esDemo(l: LicenciaAdminDto): boolean { return l.tipo === 'D'; }

  private hoy(): string { return new Date().toISOString().slice(0, 10); }
}
