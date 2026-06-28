import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { SigreModalService } from '@sigre-common';
import { StorageService } from '../../../core/services/storage.service';
import { LoginData } from '../../../auth/services/auth.service';
import { AdminLicenciasService, LicenciaAdminDto } from '../../services/admin-licencias.service';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { EmpresaAdminDto, EdicionErpDto } from '../../models/admin.models';

@Component({
  selector: 'app-admin-licencias',
  templateUrl: './admin-licencias.component.html',
  styleUrls: ['./admin-licencias.component.scss'],
  standalone: false,
})
export class AdminLicenciasComponent implements OnInit {

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
    }
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
    if (!q) {
      return this.licencias;
    }
    return this.licencias.filter(l =>
      `${l.razon_social} ${l.codigo_licencia} ${l.edicion_codigo}`.toLowerCase().includes(q));
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
