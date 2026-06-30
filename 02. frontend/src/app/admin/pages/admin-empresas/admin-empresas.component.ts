import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { firstValueFrom } from 'rxjs';
import { ToastController } from '@ionic/angular';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { AdminProvisioningApiService } from '../../services/admin-provisioning-api.service';
import { AdminUbigeoApiService } from '../../services/admin-ubigeo-api.service';
import { EmpresaAdminDto, UbigeoItem, UsuarioAdminDto } from '../../models/admin.models';
import { TablaColumna } from '../../../erp/shared/models/api-page.model';
import { AdminTablaPageBase } from '../../shared/admin-tabla-page-base';
import { SigreModalService } from '@sigre-common';

@Component({
  selector: 'app-admin-empresas',
  templateUrl: './admin-empresas.component.html',
  styleUrls: ['./admin-empresas.component.scss'],
  standalone: false,
})
export class AdminEmpresasComponent extends AdminTablaPageBase<EmpresaAdminDto> implements OnInit {
  // Tabla propia (muchas acciones por fila); solo se reusa la paginación de la base.
  columnasTabla: TablaColumna[] = [];
  protected get registrosTabla(): EmpresaAdminDto[] { return this.empresasFiltradas; }
  protected aFila(e: EmpresaAdminDto): Record<string, unknown> { return { id: e.id }; }


  private readonly api = inject(AdminSeguridadApiService);
  private readonly provisioning = inject(AdminProvisioningApiService);
  private readonly ubigeoApi = inject(AdminUbigeoApiService);
  private readonly fb = inject(FormBuilder);
  private readonly sigreModal = inject(SigreModalService);
  private readonly toastCtrl = inject(ToastController);

  empresas: EmpresaAdminDto[] = [];
  loading = true;
  filtro = '';

  mostrandoNueva = false;
  guardandoNueva = false;
  formNueva!: FormGroup;

  mostrandoEditar = false;
  empresaEditando: EmpresaAdminDto | null = null;
  formEditar!: FormGroup;

  mostrandoEliminar = false;
  empresaEliminar: EmpresaAdminDto | null = null;

  mostrandoUsuarios = false;
  mostrandoSeleccionUsuarios = false;
  empresaGestionUsuarios: EmpresaAdminDto | null = null;
  todosLosUsuarios: UsuarioAdminDto[] = [];
  usuariosAsociados: UsuarioAdminDto[] = [];
  usuariosSeleccionados = new Set<number>();
  busquedaSeleccionUsuarios = '';
  loadingUsuarios = false;
  asociandoUsuarios = false;

  departamentos: UbigeoItem[] = [];
  provinciasNueva: UbigeoItem[] = [];
  distritosNueva: UbigeoItem[] = [];
  provinciasEditar: UbigeoItem[] = [];
  distritosEditar: UbigeoItem[] = [];
  selectedDepartamentoNueva: number | null = null;
  selectedProvinciaNueva: number | null = null;
  selectedDepartamentoEditar: number | null = null;
  selectedProvinciaEditar: number | null = null;

  enviandoCorreoBienvenidaId: number | null = null;

  ngOnInit(): void {
    this.formNueva = this.fb.group({
      sigla: ['', [Validators.required, Validators.maxLength(50)]],
      razonSocial: ['', [Validators.required, Validators.maxLength(200)]],
      ruc: ['', [Validators.required, Validators.pattern(/^\d{11}$/)]],
      nombreComercial: ['', [Validators.maxLength(200)]],
      correoContacto: ['', [Validators.required, Validators.email, Validators.maxLength(150)]],
      celular: ['', [Validators.maxLength(30)]],
      direccion: ['', [Validators.maxLength(300)]],
      distritoId: [null],
      represLegal: ['', [Validators.maxLength(200)]],
      dniRepresLegal: ['', [Validators.maxLength(20)]],
    });
    this.formEditar = this.fb.group({
      razonSocial: ['', [Validators.required, Validators.maxLength(200)]],
      nombreComercial: ['', [Validators.maxLength(200)]],
      direccionFiscal: ['', [Validators.maxLength(300)]],
      distritoId: [null],
      representanteLegal: ['', [Validators.maxLength(200)]],
      dniRepresentanteLegal: ['', [Validators.maxLength(20)]],
      correoContacto: ['', [Validators.maxLength(150)]],
      telefonoContacto: ['', [Validators.maxLength(30)]],
    });
    this.cargarDepartamentos();
    this.cargar();
  }

  cargar(): void {
    this.loading = true;
    this.api.listarEmpresas().subscribe({
      next: res => {
        this.loading = false;
        this.empresas = res.data ?? [];
      },
      error: async () => {
        this.loading = false;
        await this.presentError('No se pudieron cargar las empresas.');
      },
    });
  }

  get empresasFiltradas(): EmpresaAdminDto[] {
    if (!this.filtro.trim()) return this.empresas;
    const q = this.filtro.toLowerCase();
    return this.empresas.filter(e =>
      e.codigo?.toLowerCase().includes(q)
      || e.razonSocial?.toLowerCase().includes(q)
      || e.ruc?.toLowerCase().includes(q)
      || e.dbName?.toLowerCase().includes(q)
    );
  }

  abrirNueva(): void {
    this.formNueva.reset({
      sigla: '',
      razonSocial: '',
      ruc: '',
      nombreComercial: '',
      correoContacto: '',
      celular: '',
      direccion: '',
      distritoId: null,
      represLegal: '',
      dniRepresLegal: '',
    });
    this.selectedDepartamentoNueva = null;
    this.selectedProvinciaNueva = null;
    this.provinciasNueva = [];
    this.distritosNueva = [];
    this.guardandoNueva = false;
    this.mostrandoNueva = true;
  }

  cerrarNueva(): void {
    this.mostrandoNueva = false;
    this.guardandoNueva = false;
  }

  guardarNueva(): void {
    if (this.formNueva.invalid || this.guardandoNueva) {
      this.formNueva.markAllAsTouched();
      return;
    }

    const v = this.formNueva.getRawValue();
    const distritoSel = this.distritosNueva.find(d => d.id === v.distritoId);
    const provinciaSel = this.provinciasNueva.find(p => p.id === this.selectedProvinciaNueva);
    const departamentoSel = this.departamentos.find(d => d.id === this.selectedDepartamentoNueva);

    this.guardandoNueva = true;
    this.provisioning.provisionar({
      sigla: (v.sigla ?? '').trim().toUpperCase(),
      razonSocial: (v.razonSocial ?? '').trim(),
      ruc: (v.ruc ?? '').trim(),
      nombreComercial: this.trimOrUndef(v.nombreComercial),
      personeria: 'J',
      direccion: this.trimOrUndef(v.direccion),
      dirCalle: this.trimOrUndef(v.direccion),
      dirDistrito: distritoSel?.nombre,
      dirProvincia: provinciaSel?.nombre,
      dirDepartamento: departamentoSel?.nombre,
      dirPais: 'PERU',
      dirUbigeo: distritoSel?.codigo,
      distritoId: v.distritoId || null,
      ciuCodPais: 'PE',
      correoContacto: this.trimOrUndef(v.correoContacto),
      celular: this.trimOrUndef(v.celular),
      represLegal: this.trimOrUndef(v.represLegal),
      dniRepresLegal: this.trimOrUndef(v.dniRepresLegal),
      flagReplicacion: '1',
      flagCntrlCd: '0',
    }).subscribe({
      next: async res => {
        this.guardandoNueva = false;
        const data = res.data;
        const msg = data?.mensaje ?? res.message ?? 'Empresa creada y base de datos aprovisionada.';
        this.cerrarNueva();
        await this.presentSuccess('Empresa creada', msg);
        this.cargar();
      },
      error: async (err: any) => {
        this.guardandoNueva = false;
        await this.presentError(err?.error?.message ?? 'No se pudo crear la empresa.');
      },
    });
  }

  async abrirEditar(e: EmpresaAdminDto): Promise<void> {
    this.empresaEditando = e;
    this.formEditar.patchValue({
      razonSocial: e.razonSocial ?? '',
      nombreComercial: e.nombreComercial ?? '',
      direccionFiscal: e.direccionFiscal ?? '',
      distritoId: e.distritoId ?? null,
      representanteLegal: e.representanteLegal ?? '',
      dniRepresentanteLegal: e.dniRepresentanteLegal ?? '',
      correoContacto: e.correoContacto ?? '',
      telefonoContacto: e.telefonoContacto ?? '',
    });
    this.selectedDepartamentoEditar = e.departamentoId ?? null;
    this.selectedProvinciaEditar = e.provinciaId ?? null;
    this.provinciasEditar = [];
    this.distritosEditar = [];
    this.mostrandoEditar = true;

    if (e.departamentoId) {
      await this.cargarCascadaEditarDesdeEmpresa(e);
    }
  }

  cerrarEditar(): void {
    this.mostrandoEditar = false;
    this.empresaEditando = null;
  }

  guardarEdicion(): void {
    const e = this.empresaEditando;
    if (!e || this.formEditar.invalid) {
      this.formEditar.markAllAsTouched();
      return;
    }
    const v = this.formEditar.getRawValue();
    this.api.actualizarEmpresa(e.id, {
      razonSocial: (v.razonSocial ?? '').trim(),
      nombreComercial: this.trimOrUndef(v.nombreComercial),
      direccionFiscal: this.trimOrUndef(v.direccionFiscal),
      distritoId: v.distritoId || null,
      representanteLegal: this.trimOrUndef(v.representanteLegal),
      dniRepresentanteLegal: this.trimOrUndef(v.dniRepresentanteLegal),
      correoContacto: this.trimOrUndef(v.correoContacto),
      telefonoContacto: this.trimOrUndef(v.telefonoContacto),
    }).subscribe({
      next: () => {
        this.cerrarEditar();
        void this.presentToast('Empresa actualizada', 'success');
        this.cargar();
      },
      error: async (err: any) => await this.presentError(err?.error?.message ?? 'No se pudo guardar.'),
    });
  }

  private trimOrUndef(s: string | null | undefined): string | undefined {
    if (s == null) return undefined;
    const t = String(s).trim();
    return t === '' ? undefined : t;
  }

  async confirmarCambioEstado(e: EmpresaAdminDto, activar: boolean): Promise<void> {
    const confirmed = await this.sigreModal.confirm({
      titulo: activar ? 'Reactivar empresa' : 'Anular empresa',
      mensaje: activar
        ? `¿Reactivar «${this.escapeHtmlLite(e.razonSocial)}»?`
        : `¿Marcar como inactiva «${this.escapeHtmlLite(e.razonSocial)}»?`,
      tipo: 'confirm',
      textoConfirmar: activar ? 'Reactivar' : 'Anular',
      conCancelar: true,
    });
    if (!confirmed) return;
    this.api.cambiarEstadoEmpresa(e.id, activar).subscribe({
      next: () => {
        void this.presentToast(activar ? 'Empresa reactivada' : 'Empresa anulada', 'success');
        this.cargar();
      },
      error: async (err: any) => await this.presentError(err?.error?.message ?? 'No se pudo cambiar el estado.'),
    });
  }

  private escapeHtmlLite(s: string): string {
    return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  }

  async confirmarEnviarCorreoBienvenida(e: EmpresaAdminDto): Promise<void> {
    if (!e.correoContacto?.trim()) {
      await this.presentError('La empresa no tiene correo de contacto registrado.');
      return;
    }

    const confirmed = await this.sigreModal.confirm({
      titulo: 'Enviar correo de bienvenida',
      mensaje: `Se enviará el correo de registro a <strong>${this.escapeHtmlLite(e.correoContacto)}</strong> con los datos de «${this.escapeHtmlLite(e.razonSocial)}». ¿Continuar?`,
      tipo: 'info',
      textoConfirmar: 'ENVIAR',
      textoCancelar: 'CANCELAR',
      conCancelar: true,
    });
    if (!confirmed) return;

    this.enviandoCorreoBienvenidaId = e.id;
    this.api.enviarCorreoBienvenida(e.id).subscribe({
      next: async res => {
        this.enviandoCorreoBienvenidaId = null;
        const msg = res.data?.mensaje ?? res.message ?? 'Correo enviado correctamente.';
        await this.presentSuccess('Correo enviado', msg);
      },
      error: async (err: any) => {
        this.enviandoCorreoBienvenidaId = null;
        await this.presentError(err?.error?.message ?? 'No se pudo enviar el correo de bienvenida.');
      },
    });
  }

  async confirmarRecrear(e: EmpresaAdminDto): Promise<void> {
    const confirmed = await this.sigreModal.confirm({
      titulo: 'Recrear base de datos',
      mensaje: `Se eliminará y recreará la BD <strong>${this.escapeHtmlLite(e.dbName ?? '')}</strong> desde el template. Esta acción borra todos los datos del tenant «${this.escapeHtmlLite(e.razonSocial)}». ¿Continuar?`,
      tipo: 'warning',
      textoConfirmar: 'RECREAR',
      textoCancelar: 'CANCELAR',
      conCancelar: true,
    });
    if (!confirmed) return;

    this.provisioning.recrearEmpresa({ dbName: e.dbName }).subscribe({
      next: async res => {
        const msg = res.data?.mensaje ?? res.message ?? 'Base de datos recreada exitosamente.';
        await this.presentSuccess('BD recreada', msg);
        this.cargar();
      },
      error: async (err: any) => {
        await this.presentError(err?.error?.message ?? 'No se pudo recrear la base de datos.');
      },
    });
  }

  abrirEliminar(e: EmpresaAdminDto): void {
    this.empresaEliminar = e;
    this.mostrandoEliminar = true;
  }

  cerrarEliminar(): void {
    this.mostrandoEliminar = false;
    this.empresaEliminar = null;
  }

  async ejecutarEliminar(): Promise<void> {
    const e = this.empresaEliminar;
    if (!e) return;
    try {
      const res = await firstValueFrom(
        this.provisioning.desaprovisionar({ codigo: e.codigo, ruc: e.ruc, dbName: e.dbName })
      );
      const msg = res.data?.mensaje ?? res.message ?? 'Operación completada';
      this.cerrarEliminar();
      await this.presentToast(msg, 'success');
      this.cargar();
    } catch (err: any) {
      await this.presentError(err?.error?.message ?? 'No se pudo eliminar la empresa.');
    }
  }

  private async presentToast(message: string, color: string): Promise<void> {
    const t = await this.toastCtrl.create({ message, duration: 2600, color, position: 'bottom' });
    await t.present();
  }

  private async presentError(message: string): Promise<void> {
    await this.sigreModal.error(message);
  }

  private async presentSuccess(title: string, message: string): Promise<void> {
    await this.sigreModal.success(title, message);
  }

  // ── Ubigeo cascada ──

  cargarDepartamentos(): void {
    this.ubigeoApi.listarDepartamentos().subscribe({
      next: res => this.departamentos = res.data ?? [],
      error: () => this.departamentos = [],
    });
  }

  onDepartamentoChangeNueva(departamentoId: number | null): void {
    this.selectedDepartamentoNueva = departamentoId;
    this.selectedProvinciaNueva = null;
    this.provinciasNueva = [];
    this.distritosNueva = [];
    this.formNueva.patchValue({ distritoId: null });
    if (departamentoId) {
      this.ubigeoApi.listarProvincias(departamentoId).subscribe({
        next: res => this.provinciasNueva = res.data ?? [],
        error: () => this.provinciasNueva = [],
      });
    }
  }

  onProvinciaChangeNueva(provinciaId: number | null): void {
    this.selectedProvinciaNueva = provinciaId;
    this.distritosNueva = [];
    this.formNueva.patchValue({ distritoId: null });
    if (provinciaId) {
      this.ubigeoApi.listarDistritos(provinciaId).subscribe({
        next: res => this.distritosNueva = res.data ?? [],
        error: () => this.distritosNueva = [],
      });
    }
  }

  onDepartamentoChangeEditar(departamentoId: number | null): void {
    this.selectedDepartamentoEditar = departamentoId;
    this.selectedProvinciaEditar = null;
    this.provinciasEditar = [];
    this.distritosEditar = [];
    this.formEditar.patchValue({ distritoId: null });
    if (departamentoId) {
      this.ubigeoApi.listarProvincias(departamentoId).subscribe({
        next: res => this.provinciasEditar = res.data ?? [],
        error: () => this.provinciasEditar = [],
      });
    }
  }

  onProvinciaChangeEditar(provinciaId: number | null): void {
    this.selectedProvinciaEditar = provinciaId;
    this.distritosEditar = [];
    this.formEditar.patchValue({ distritoId: null });
    if (provinciaId) {
      this.ubigeoApi.listarDistritos(provinciaId).subscribe({
        next: res => this.distritosEditar = res.data ?? [],
        error: () => this.distritosEditar = [],
      });
    }
  }

  private async cargarCascadaEditarDesdeEmpresa(e: EmpresaAdminDto): Promise<void> {
    try {
      if (e.departamentoId) {
        const provRes = await firstValueFrom(this.ubigeoApi.listarProvincias(e.departamentoId));
        this.provinciasEditar = provRes.data ?? [];
      }
      if (e.provinciaId) {
        const distRes = await firstValueFrom(this.ubigeoApi.listarDistritos(e.provinciaId));
        this.distritosEditar = distRes.data ?? [];
      }
    } catch {
      // silently fail
    }
  }

  // ── Gestión de usuarios de empresa ──

  abrirGestionUsuarios(e: EmpresaAdminDto): void {
    this.empresaGestionUsuarios = e;
    this.mostrandoUsuarios = true;
    this.cargarUsuariosEmpresa();
  }

  cerrarGestionUsuarios(): void {
    this.mostrandoUsuarios = false;
    this.mostrandoSeleccionUsuarios = false;
    this.empresaGestionUsuarios = null;
    this.todosLosUsuarios = [];
    this.usuariosAsociados = [];
    this.usuariosSeleccionados.clear();
    this.busquedaSeleccionUsuarios = '';
  }

  async cargarUsuariosEmpresa(): Promise<void> {
    if (!this.empresaGestionUsuarios) return;
    const eid = this.empresaGestionUsuarios.id;
    this.loadingUsuarios = true;
    try {
      const [todos, asociados] = await Promise.all([
        firstValueFrom(this.api.listarUsuarios()),
        firstValueFrom(this.api.listarUsuariosDeEmpresa(eid)),
      ]);
      this.todosLosUsuarios = todos.data ?? [];
      this.usuariosAsociados = asociados.data ?? [];
    } catch (err: any) {
      await this.presentError(err?.error?.message ?? 'No se pudieron cargar usuarios.');
    } finally {
      this.loadingUsuarios = false;
    }
  }

  get usuariosDisponibles(): UsuarioAdminDto[] {
    const idsAsociados = new Set(this.usuariosAsociados.map(u => u.id));
    return this.ordenarPorFechaCreacion(
      this.todosLosUsuarios.filter(u => !idsAsociados.has(u.id))
    );
  }

  get usuariosAsociadosOrdenados(): UsuarioAdminDto[] {
    return this.ordenarPorFechaCreacion(this.usuariosAsociados);
  }

  get usuariosDisponiblesFiltradosSeleccion(): UsuarioAdminDto[] {
    const disponibles = this.usuariosDisponibles;
    const q = this.busquedaSeleccionUsuarios.trim().toLowerCase();
    if (!q) {
      return disponibles;
    }
    return disponibles.filter(u =>
      u.nombreCompleto?.toLowerCase().includes(q) ||
      u.username?.toLowerCase().includes(q) ||
      u.email?.toLowerCase().includes(q)
    );
  }

  get cantidadSeleccionados(): number {
    return this.usuariosSeleccionados.size;
  }

  abrirSeleccionUsuarios(): void {
    this.usuariosSeleccionados.clear();
    this.busquedaSeleccionUsuarios = '';
    this.mostrandoSeleccionUsuarios = true;
  }

  cerrarSeleccionUsuarios(): void {
    this.mostrandoSeleccionUsuarios = false;
    this.usuariosSeleccionados.clear();
    this.busquedaSeleccionUsuarios = '';
  }

  isUsuarioSeleccionado(usuarioId: number): boolean {
    return this.usuariosSeleccionados.has(usuarioId);
  }

  onUsuarioSeleccionChange(usuarioId: number, event: Event): void {
    const checked = (event as CustomEvent<{ checked: boolean }>).detail?.checked ?? false;
    if (checked) {
      this.usuariosSeleccionados.add(usuarioId);
    } else {
      this.usuariosSeleccionados.delete(usuarioId);
    }
  }

  seleccionarTodosVisibles(): void {
    for (const u of this.usuariosDisponiblesFiltradosSeleccion) {
      this.usuariosSeleccionados.add(u.id);
    }
  }

  limpiarSeleccionUsuarios(): void {
    this.usuariosSeleccionados.clear();
  }

  async asociarUsuariosSeleccionados(): Promise<void> {
    if (!this.empresaGestionUsuarios || this.usuariosSeleccionados.size === 0) {
      return;
    }

    const eid = this.empresaGestionUsuarios.id;
    const ids = [...this.usuariosSeleccionados];
    this.asociandoUsuarios = true;

    try {
      await Promise.all(
        ids.map(id => firstValueFrom(this.api.asociarUsuarioAEmpresa(eid, id)))
      );
      const msg = ids.length === 1
        ? 'Usuario asociado exitosamente'
        : `${ids.length} usuarios asociados exitosamente`;
      await this.presentToast(msg, 'success');
      this.cerrarSeleccionUsuarios();
      await this.cargarUsuariosEmpresa();
    } catch (err: any) {
      await this.presentError(err?.error?.message ?? 'Error al asociar usuarios a la empresa.');
      await this.cargarUsuariosEmpresa();
    } finally {
      this.asociandoUsuarios = false;
    }
  }

  private ordenarPorFechaCreacion(usuarios: UsuarioAdminDto[]): UsuarioAdminDto[] {
    return [...usuarios].sort((a, b) =>
      this.compareFechaCreacion(b.fecCreacion, a.fecCreacion));
  }

  private compareFechaCreacion(a?: string, b?: string): number {
    const ta = a ? Date.parse(a) : 0;
    const tb = b ? Date.parse(b) : 0;
    return ta - tb;
  }

  async retirarUsuario(usuarioId: number): Promise<void> {
    if (!this.empresaGestionUsuarios) return;

    const usuario = this.usuariosAsociados.find(u => u.id === usuarioId);
    if (!usuario) return;

    const confirmed = await this.sigreModal.confirm({
      titulo: 'Confirmar retiro',
      mensaje: `¿Está seguro de retirar a «${this.escapeHtmlLite(usuario.nombreCompleto ?? '')}» de esta empresa? Esto eliminará sus roles y sucursales asignadas.`,
      tipo: 'warning',
      textoConfirmar: 'Continuar',
      conCancelar: true,
    });
    if (!confirmed) return;

    const eid = this.empresaGestionUsuarios.id;
    try {
      await firstValueFrom(this.api.retirarUsuarioDeEmpresa(eid, usuarioId));
      await this.presentToast('Usuario retirado exitosamente', 'success');
      await this.cargarUsuariosEmpresa();
    } catch (err: any) {
      await this.presentError(err?.error?.message ?? 'Error al retirar usuario de la empresa.');
    }
  }
}
