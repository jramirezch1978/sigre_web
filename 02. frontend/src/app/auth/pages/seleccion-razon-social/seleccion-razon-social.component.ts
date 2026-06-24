import { Component, HostBinding, OnDestroy, OnInit, inject } from '@angular/core';
import { Router } from '@angular/router';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from '@sigre-common';
import { AuthService, EmpresaUsuario, LoginData } from '../../services/auth.service';
import { PostAuthIntentService } from '../../../admin/services/post-auth-intent.service';
import { StorageService } from '@core/services/storage.service';
import { CanComponentDeactivate } from '../../guards/can-deactivate.guard';

export interface Sucursal {
  id: number;
  codigo: string;
  nombre: string;
  direccion: string;
  ciudad?: string;
  pais?: string;
  departamento?: string;
  provincia?: string;
  distrito?: string;
}

@Component({
  selector: 'app-seleccion-razon-social',
  templateUrl: './seleccion-razon-social.component.html',
  styleUrls: ['./seleccion-razon-social.component.scss'],
  standalone: false,
})
export class SeleccionRazonSocialComponent implements OnInit, OnDestroy, CanComponentDeactivate {

  @HostBinding('class.sigre-auth-page') readonly authPageClass = true;

  private readonly router = inject(Router);
  private readonly authService = inject(AuthService);
  private readonly modalController = inject(ModalController);
  private readonly postAuthIntent = inject(PostAuthIntentService);
  private readonly storageService = inject(StorageService);

  paso: 'empresa' | 'sucursal' = 'empresa';
  searchQuery = '';
  empresas: EmpresaUsuario[] = [];
  sucursales: Sucursal[] = [];
  empresaSeleccionada: EmpresaUsuario | null = null;
  loading = true;
  loadingSucursales = false;
  isSelecting = false;
  currentYear = new Date().getFullYear();
  private seleccionCompletada = false;
  private cerrandoSesion = false;
  private ipAddress = '';

  ngOnInit() {
    document.body.classList.add('sigre-auth-body');
    this.obtenerIpPublica();

    const user = this.storageService.getUser<LoginData>();
    if (this.postAuthIntent.isAdminTarget()) {
      if (user?.adminSistema !== true) {
        void this.accesoAdminDenegadoEnSeleccion();
        return;
      }
      this.ejecutarAutoSeleccionParaAdmin();
      return;
    }

    this.cargarEmpresas();
  }

  ngOnDestroy(): void {
    document.body.classList.remove('sigre-auth-body');
  }

  private obtenerIpPublica(): void {
    fetch('https://api.ipify.org?format=json')
      .then(r => r.json())
      .then((data: { ip: string }) => this.ipAddress = data.ip)
      .catch(() => this.ipAddress = 'unknown');
  }

  private ejecutarAutoSeleccionParaAdmin(): void {
    this.loading = true;
    const browser = navigator.userAgent;
    const so = this.detectarSO();
    this.authService
      .completarContextoConPrimeraEmpresaYSucursal(this.ipAddress, browser, so)
      .subscribe({
        next: (response) => {
          this.loading = false;
          if (response.success && response.data) {
            this.seleccionCompletada = true;
            const dest = this.postAuthIntent.consumeHomeRoute();
            void this.router.navigateByUrl(dest);
            return;
          }
          void this.mostrarErrorYVolverAlLoginAdmin(response.message ?? 'No se pudo completar el acceso.');
        },
        error: (err: unknown) => {
          this.loading = false;
          const msg =
            err instanceof Error
              ? err.message
              : 'No se pudo preparar el acceso al panel de administración.';
          void this.mostrarErrorYVolverAlLoginAdmin(msg);
        }
      });
  }

  private async accesoAdminDenegadoEnSeleccion(): Promise<void> {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: '',
        tipemodal: 'error',
        title: 'Acceso denegado',
        message:
          'No tiene permisos de administrador de sistema. Solo los usuarios autorizados pueden acceder al panel de administración.',
        tipo: 'error',
        btnOkTxt: 'Aceptar',
        mostrarCancelar: false
      }
    });
    await modal.present();
    await modal.onDidDismiss();
    this.postAuthIntent.markDefault();
    this.cerrandoSesion = true;
    await this.authService.signOut({ redirectTo: '/admin/login' });
  }

  private async mostrarErrorYVolverAlLoginAdmin(mensaje: string): Promise<void> {
    this.postAuthIntent.markDefault();
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: '',
        tipemodal: 'error',
        title: 'Error',
        message: mensaje,
        tipo: 'error',
        btnOkTxt: 'Aceptar',
        mostrarCancelar: false
      }
    });
    await modal.present();
    await modal.onDidDismiss();
    this.cerrandoSesion = true;
    await this.authService.signOut({ redirectTo: '/admin/login' });
  }

  private cargarEmpresas(): void {
    this.loading = true;
    this.authService.listarEmpresas().subscribe({
      next: (response) => {
        this.loading = false;
        if (response.success && response.data) {
          this.empresas = response.data;

          if (this.empresas.length === 0) {
            void this.showError(
              'Sin empresa asignada',
              'No tiene ninguna empresa asignada. Coordine con el administrador del sistema.',
              true
            );
          } else if (this.empresas.length === 1) {
            this.onEmpresaClick(this.empresas[0]);
          }
          return;
        }
        const msg = response.message ?? 'No se pudieron cargar las empresas';
        void this.showError('Error', msg);
      },
      error: (err) => {
        this.loading = false;
        const msg = err.error?.message ?? 'Error al cargar empresas';
        void this.showError('Error', msg);
      }
    });
  }

  getEmpresasFiltradas(): EmpresaUsuario[] {
    if (!this.searchQuery.trim()) return this.empresas;
    const q = this.searchQuery.trim().toLowerCase();
    return this.empresas.filter(e =>
      e.razonSocial.toLowerCase().includes(q) ||
      e.ruc.toLowerCase().includes(q)
    );
  }

  onEmpresaClick(empresa: EmpresaUsuario): void {
    this.empresaSeleccionada = empresa;
    this.paso = 'sucursal';
    this.cargarSucursales(empresa);
  }

  private cargarSucursales(empresa: EmpresaUsuario): void {
    this.loadingSucursales = true;
    this.sucursales = [];
    this.authService.listarSucursales(empresa.empresaId).subscribe({
      next: (response: { success?: boolean; message?: string; data?: Sucursal[] }) => {
        this.loadingSucursales = false;
        if (response.success && Array.isArray(response.data)) {
          this.sucursales = response.data;
          if (this.sucursales.length === 0) {
            void this.showError(
              'Sin sucursales asignadas',
              'No tiene sucursales asignadas para esta empresa. Coordine con el administrador.'
            );
            return;
          }
          if (this.sucursales.length === 1) {
            this.seleccionarSucursal(this.sucursales[0]);
          }
          return;
        }
        const msg = response.message ?? 'No se pudieron cargar las sucursales';
        void this.showError('Error al cargar sucursales', msg);
      },
      error: (err) => {
        this.loadingSucursales = false;
        const body = err?.error;
        const msg =
          (typeof body === 'object' && body !== null && 'message' in body
            ? (body as { message?: string }).message
            : undefined) ??
          err?.message ??
          'No se pudo obtener el listado de sucursales. Intente nuevamente.';
        void this.showError('Error al cargar sucursales', msg);
      }
    });
  }

  async canDeactivate(): Promise<boolean> {
    if (this.seleccionCompletada || this.cerrandoSesion) {
      return true;
    }
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      backdropDismiss: false,
      componentProps: {
        titlemodal: '',
        tipemodal: 'error',
        title: 'Selección obligatoria',
        message: 'Debe seleccionar una empresa y una sucursal para continuar. Si desea salir, cierre sesión.',
        tipo: 'error',
        btnOkTxt: 'Entendido',
        mostrarCancelar: false,
      },
    });
    await modal.present();
    await modal.onDidDismiss();
    return false;
  }

  seleccionarSucursal(sucursal: Sucursal): void {
    if (this.isSelecting || !this.empresaSeleccionada) return;
    this.isSelecting = true;

    const browser = navigator.userAgent;
    const so = this.detectarSO();

    this.authService.seleccionarEmpresa(
      this.empresaSeleccionada.empresaId, this.ipAddress, browser, so, sucursal.id
    ).subscribe({
      next: (response) => {
        this.isSelecting = false;
        if (response.success && response.data) {
          this.seleccionCompletada = true;
          this.postAuthIntent.markDefault();
          void this.router.navigateByUrl('/sigre/dashboard');
          return;
        }
        const msg = response.message ?? 'No se pudo completar la selección de sucursal';
        void this.showError('Error', msg);
      },
      error: (err) => {
        this.isSelecting = false;
        const msg = err.error?.message ?? 'Error al seleccionar sucursal';
        void this.showError('Error', msg);
      }
    });
  }

  volverAEmpresas(): void {
    this.paso = 'empresa';
    this.empresaSeleccionada = null;
    this.sucursales = [];
    this.isSelecting = false;
  }

  logout(): void {
    this.cerrandoSesion = true;
    this.authService.signOut();
  }

  private detectarSO(): string {
    const ua = navigator.userAgent;
    if (ua.includes('Windows NT 10')) return 'Windows 10/11';
    if (ua.includes('Mac OS X')) return 'macOS';
    if (ua.includes('Linux')) return 'Linux';
    if (ua.includes('Android')) return 'Android';
    if (ua.includes('iPhone') || ua.includes('iPad')) return 'iOS';
    return 'Desconocido';
  }

  /**
   * @param cerrarSesionSiSinEmpresas Si es true y no hay empresas cargadas, cierra sesión al aceptar (flujo inicial sin empresas).
   */
  private async showError(
    titulo: string,
    mensaje: string,
    cerrarSesionSiSinEmpresas = false
  ): Promise<void> {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: '',
        tipemodal: 'error',
        title: titulo,
        message: mensaje,
        tipo: 'error',
        btnOkTxt: 'Aceptar',
        mostrarCancelar: false
      }
    });
    await modal.present();
    await modal.onDidDismiss();
    if (cerrarSesionSiSinEmpresas && this.empresas.length === 0) {
      this.authService.signOut();
    }
  }
}
