import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { firstValueFrom } from 'rxjs';
import { ModalController, ToastController } from '@ionic/angular';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { AdminProvisioningApiService } from '../../services/admin-provisioning-api.service';
import { AdminUbigeoApiService } from '../../services/admin-ubigeo-api.service';
import { EmpresaAdminDto, UbigeoItem, UsuarioAdminDto } from '../../models/admin.models';
import { ModalConfirmationComponent } from '@ui/modal-confirmation/modal-confirmation.component';

@Component({
  selector: 'app-admin-empresas',
  templateUrl: './admin-empresas.component.html',
  styleUrls: ['./admin-empresas.component.scss'],
  standalone: false,
})
export class AdminEmpresasComponent implements OnInit {

  private readonly api = inject(AdminSeguridadApiService);
  private readonly provisioning = inject(AdminProvisioningApiService);
  private readonly ubigeoApi = inject(AdminUbigeoApiService);
  private readonly fb = inject(FormBuilder);
  private readonly modalCtrl = inject(ModalController);
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
  empresaGestionUsuarios: EmpresaAdminDto | null = null;
  todosLosUsuarios: UsuarioAdminDto[] = [];
  usuariosAsociados: UsuarioAdminDto[] = [];
  loadingUsuarios = false;
  busquedaUsuarioDisponible = '';

  departamentos: UbigeoItem[] = [];
  provinciasNueva: UbigeoItem[] = [];
  distritosNueva: UbigeoItem[] = [];
  provinciasEditar: UbigeoItem[] = [];
  distritosEditar: UbigeoItem[] = [];
  selectedDepartamentoNueva: number | null = null;
  selectedProvinciaNueva: number | null = null;
  selectedDepartamentoEditar: number | null = null;
  selectedProvinciaEditar: number | null = null;

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
    const modal = await this.modalCtrl.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: '',
        tipemodal: 'confirm',
        title: activar ? 'Reactivar empresa' : 'Anular empresa',
        message: activar
          ? `¿Reactivar «${this.escapeHtmlLite(e.razonSocial)}»?`
          : `¿Marcar como inactiva «${this.escapeHtmlLite(e.razonSocial)}»?`,
        btnCancelTxt: 'Cancelar',
        btnOkTxt: activar ? 'Reactivar' : 'Anular',
      },
    });
    await modal.present();
    const { data } = await modal.onDidDismiss<boolean>();
    if (!data) return;
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

  async confirmarRecrear(e: EmpresaAdminDto): Promise<void> {
    const modal = await this.modalCtrl.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: '',
        tipemodal: 'warning',
        title: 'Recrear base de datos',
        message: `Se eliminará y recreará la BD <strong>${this.escapeHtmlLite(e.dbName ?? '')}</strong> desde el template. Esta acción borra todos los datos del tenant «${this.escapeHtmlLite(e.razonSocial)}». ¿Continuar?`,
        btnCancelTxt: 'CANCELAR',
        btnOkTxt: 'RECREAR',
      },
    });
    await modal.present();
    const { data: confirmed } = await modal.onDidDismiss<boolean>();
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
    await this.presentModal('Error', message, 'error');
  }

  private async presentSuccess(title: string, message: string): Promise<void> {
    await this.presentModal(title, message, 'success');
  }

  private async presentModal(title: string, message: string, tipo: 'error' | 'success'): Promise<void> {
    const modal = await this.modalCtrl.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: '',
        tipemodal: tipo,
        title,
        message,
        btnOkTxt: 'Aceptar',
        mostrarCancelar: false,
      },
    });
    await modal.present();
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
    this.empresaGestionUsuarios = null;
    this.todosLosUsuarios = [];
    this.usuariosAsociados = [];
    this.busquedaUsuarioDisponible = '';
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
    return this.todosLosUsuarios.filter(u => !idsAsociados.has(u.id));
  }

  get usuariosDisponiblesFiltrados(): UsuarioAdminDto[] {
    const disponibles = this.usuariosDisponibles;
    if (!this.busquedaUsuarioDisponible.trim()) {
      return [];
    }
    const q = this.busquedaUsuarioDisponible.toLowerCase();
    return disponibles.filter(u =>
      u.nombreCompleto?.toLowerCase().includes(q) ||
      u.username?.toLowerCase().includes(q) ||
      u.email?.toLowerCase().includes(q)
    );
  }

  async asociarUsuario(usuarioId: number): Promise<void> {
    if (!this.empresaGestionUsuarios) return;

    const eid = this.empresaGestionUsuarios.id;
    try {
      await firstValueFrom(this.api.asociarUsuarioAEmpresa(eid, usuarioId));
      await this.presentToast('Usuario asociado exitosamente', 'success');
      await this.cargarUsuariosEmpresa();
    } catch (err: any) {
      await this.presentError(err?.error?.message ?? 'Error al asociar usuario a la empresa.');
    }
  }

  async retirarUsuario(usuarioId: number): Promise<void> {
    if (!this.empresaGestionUsuarios) return;

    const usuario = this.usuariosAsociados.find(u => u.id === usuarioId);
    if (!usuario) return;

    const modal = await this.modalCtrl.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: '',
        tipemodal: 'warning',
        title: 'Confirmar retiro',
        message: `¿Está seguro de retirar a «${this.escapeHtmlLite(usuario.nombreCompleto ?? '')}» de esta empresa? Esto eliminará sus roles y sucursales asignadas.`,
        btnOkTxt: 'Continuar',
        btnCancelTxt: 'Cancelar',
      },
    });
    await modal.present();
    const { data } = await modal.onWillDismiss();
    if (!data) return;

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
