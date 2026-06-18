import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { firstValueFrom } from 'rxjs';
import { ModalController, ToastController } from '@ionic/angular';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { AdminProvisioningApiService } from '../../services/admin-provisioning-api.service';
import { EmpresaAdminDto, UsuarioAdminDto } from '../../models/admin.models';
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
  secretoEliminar = '';

  mostrandoUsuarios = false;
  empresaGestionUsuarios: EmpresaAdminDto | null = null;
  todosLosUsuarios: UsuarioAdminDto[] = [];
  usuariosAsociados: UsuarioAdminDto[] = [];
  loadingUsuarios = false;
  provisionSecretUsuarios = '';
  busquedaUsuarioDisponible = '';

  ngOnInit(): void {
    this.formNueva = this.fb.group({
      provisionSecret: ['', [Validators.required]],
      sigla: ['', [Validators.required, Validators.maxLength(50)]],
      razonSocial: ['', [Validators.required, Validators.maxLength(200)]],
      ruc: ['', [Validators.required, Validators.pattern(/^\d{11}$/)]],
      nombreComercial: ['', [Validators.maxLength(200)]],
      correoContacto: ['', [Validators.maxLength(150)]],
      celular: ['', [Validators.maxLength(30)]],
      direccion: ['', [Validators.maxLength(300)]],
      dirDistrito: ['', [Validators.maxLength(120)]],
      dirProvincia: ['', [Validators.maxLength(120)]],
      dirDepartamento: ['', [Validators.maxLength(120)]],
      dirPais: ['PERU', [Validators.maxLength(120)]],
      dirUbigeo: ['', [Validators.maxLength(12)]],
      represLegal: ['', [Validators.maxLength(200)]],
    });
    this.formEditar = this.fb.group({
      razonSocial: ['', [Validators.required, Validators.maxLength(200)]],
      nombreComercial: ['', [Validators.maxLength(200)]],
      direccionFiscal: ['', [Validators.maxLength(300)]],
      correoContacto: ['', [Validators.maxLength(150)]],
      telefonoContacto: ['', [Validators.maxLength(30)]],
    });
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
      provisionSecret: '',
      sigla: '',
      razonSocial: '',
      ruc: '',
      nombreComercial: '',
      correoContacto: '',
      celular: '',
      direccion: '',
      dirDistrito: '',
      dirProvincia: '',
      dirDepartamento: '',
      dirPais: 'PERU',
      dirUbigeo: '',
      represLegal: '',
    });
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
    const secret = (v.provisionSecret ?? '').trim();
    if (!secret) {
      void this.presentToast('Indique el secreto de aprovisionamiento', 'warning');
      return;
    }

    this.guardandoNueva = true;
    this.provisioning.provisionar(
      {
        sigla: (v.sigla ?? '').trim().toUpperCase(),
        razonSocial: (v.razonSocial ?? '').trim(),
        ruc: (v.ruc ?? '').trim(),
        nombreComercial: this.trimOrUndef(v.nombreComercial),
        personeria: 'J',
        direccion: this.trimOrUndef(v.direccion),
        dirCalle: this.trimOrUndef(v.direccion),
        dirDistrito: this.trimOrUndef(v.dirDistrito),
        dirProvincia: this.trimOrUndef(v.dirProvincia),
        dirDepartamento: this.trimOrUndef(v.dirDepartamento),
        dirPais: this.trimOrUndef(v.dirPais) ?? 'PERU',
        dirUbigeo: this.trimOrUndef(v.dirUbigeo),
        ciuCodPais: 'PE',
        correoContacto: this.trimOrUndef(v.correoContacto),
        celular: this.trimOrUndef(v.celular),
        represLegal: this.trimOrUndef(v.represLegal),
        flagReplicacion: '1',
        flagCntrlCd: '0',
      },
      secret,
    ).subscribe({
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

  abrirEditar(e: EmpresaAdminDto): void {
    this.empresaEditando = e;
    this.formEditar.patchValue({
      razonSocial: e.razonSocial ?? '',
      nombreComercial: e.nombreComercial ?? '',
      direccionFiscal: e.direccionFiscal ?? '',
      correoContacto: e.correoContacto ?? '',
      telefonoContacto: e.telefonoContacto ?? '',
    });
    this.mostrandoEditar = true;
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

  abrirEliminar(e: EmpresaAdminDto): void {
    this.empresaEliminar = e;
    this.secretoEliminar = '';
    this.mostrandoEliminar = true;
  }

  cerrarEliminar(): void {
    this.mostrandoEliminar = false;
    this.empresaEliminar = null;
    this.secretoEliminar = '';
  }

  async ejecutarEliminar(): Promise<void> {
    const e = this.empresaEliminar;
    const secret = this.secretoEliminar?.trim();
    if (!e || !secret) {
      await this.presentToast('Indique el secreto de aprovisionamiento', 'warning');
      return;
    }
    try {
      const res = await firstValueFrom(
        this.provisioning.desaprovisionar(
          { codigo: e.codigo, ruc: e.ruc, dbName: e.dbName },
          secret
        )
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

  // ── Gestión de usuarios de empresa ──

  abrirGestionUsuarios(e: EmpresaAdminDto): void {
    this.empresaGestionUsuarios = e;
    this.provisionSecretUsuarios = '';
    this.mostrandoUsuarios = true;
    this.cargarUsuariosEmpresa();
  }

  cerrarGestionUsuarios(): void {
    this.mostrandoUsuarios = false;
    this.empresaGestionUsuarios = null;
    this.todosLosUsuarios = [];
    this.usuariosAsociados = [];
    this.provisionSecretUsuarios = '';
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
    if (!this.empresaGestionUsuarios || !this.provisionSecretUsuarios.trim()) {
      await this.presentToast('Ingrese el secreto de aprovisionamiento', 'warning');
      return;
    }

    const eid = this.empresaGestionUsuarios.id;
    const secret = this.provisionSecretUsuarios;

    try {
      await firstValueFrom(this.api.asociarUsuarioAEmpresa(eid, usuarioId, secret));
      this.provisionSecretUsuarios = '';
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
        message: `¿Está seguro de retirar a "${usuario.nombreCompleto}" de esta empresa?\n\nEsto eliminará sus roles y sucursales asignadas.`,
        btnOkTxt: 'Continuar',
        btnCancelTxt: 'Cancelar',
      },
    });
    await modal.present();
    const { data } = await modal.onWillDismiss();
    
    if (!data) return;

    // Pedir el secreto de aprovisionamiento
    const secret = prompt('Ingrese el secreto de aprovisionamiento:');
    if (!secret || !secret.trim()) {
      await this.presentToast('Debe ingresar el secreto de aprovisionamiento', 'warning');
      return;
    }

    const eid = this.empresaGestionUsuarios.id;

    try {
      await firstValueFrom(this.api.retirarUsuarioDeEmpresa(eid, usuarioId, secret.trim()));
      await this.presentToast('Usuario retirado exitosamente', 'success');
      await this.cargarUsuariosEmpresa();
    } catch (err: any) {
      await this.presentError(err?.error?.message ?? 'Error al retirar usuario de la empresa.');
    }
  }
}
