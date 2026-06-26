import { Component, HostListener, OnDestroy, OnInit, inject } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { filter } from 'rxjs/operators';
import { ModalController } from '@ionic/angular';
import { AuthService, LoginData } from '../../../auth/services/auth.service';
import { StorageService } from '../../../core/services/storage.service';
import { MetoxiInitService } from '../../../erp/services/metoxi-init.service';
import { ModalConfirmationComponent } from '@sigre-common';

export interface AdminMenuItem {
  label: string;
  icon: string;
  route: string;
}

@Component({
  selector: 'app-admin-shell',
  templateUrl: './admin-shell.component.html',
  styleUrls: ['./admin-shell.component.scss'],
  standalone: false,
})
export class AdminShellComponent implements OnInit, OnDestroy {

  private readonly router = inject(Router);
  private readonly authService = inject(AuthService);
  private readonly storage = inject(StorageService);
  private readonly modalCtrl = inject(ModalController);
  private readonly metoxi = inject(MetoxiInitService);

  rutaActiva = '';
  menuUsuarioAbierto = false;
  nombreUsuario = 'Usuario';
  emailUsuario = '';
  inicialesUsuario = 'U';

  readonly menuItems: AdminMenuItem[] = [
    { label: 'Inicio', icon: 'dashboard', route: '/admin/inicio' },
    { label: 'Empresas', icon: 'business', route: '/admin/empresas' },
    { label: 'Usuarios', icon: 'group', route: '/admin/usuarios' },
    { label: 'Roles', icon: 'vpn_key', route: '/admin/roles' },
    { label: 'Módulos', icon: 'grid_view', route: '/admin/modulos' },
    { label: 'Opciones de menú', icon: 'list', route: '/admin/opciones-menu' },
    { label: 'Acciones', icon: 'bolt', route: '/admin/acciones' },
    { label: 'Roles x Usuario', icon: 'person_add', route: '/admin/roles-usuario' },
    { label: 'Grupos de usuario', icon: 'groups', route: '/admin/grupos-usuario' },
    { label: 'Sucursales', icon: 'storefront', route: '/admin/sucursales' },
    { label: 'Usuarios x Sucursal', icon: 'account_tree', route: '/admin/usuarios-sucursales' },
    { label: 'Versiones', icon: 'info', route: '/admin/versiones' },
  ];

  constructor() {
    this.rutaActiva = this.router.url;
    this.router.events
      .pipe(filter((e): e is NavigationEnd => e instanceof NavigationEnd))
      .subscribe(e => this.rutaActiva = e.urlAfterRedirects);
  }

  ngOnInit(): void {
    this.cargarDatosUsuario();
    this.metoxi.activarShellErp();
    // Marca la zona admin para estilos globales (p.ej. modales Metoxi en styles.scss)
    document.body.classList.add('sigre-admin-zone');
  }

  ngOnDestroy(): void {
    this.metoxi.desactivarShellErp();
    document.body.classList.remove('sigre-admin-zone');
  }

  @HostListener('document:click')
  cerrarMenuUsuario(): void {
    this.menuUsuarioAbierto = false;
  }

  isActive(route: string): boolean {
    return this.rutaActiva.startsWith(route);
  }

  navegar(route: string): void {
    void this.router.navigateByUrl(route);
  }

  toggleMenu(): void {
    document.body.classList.toggle('toggled');
  }

  toggleMenuUsuario(event: Event): void {
    event.stopPropagation();
    this.menuUsuarioAbierto = !this.menuUsuarioAbierto;
  }

  irAlErp(): void {
    void this.router.navigateByUrl('/dashboard');
  }

  irPerfil(): void {
    this.menuUsuarioAbierto = false;
    void this.router.navigateByUrl('/admin/perfil');
  }

  irPreferencias(): void {
    this.menuUsuarioAbierto = false;
    void this.router.navigateByUrl('/admin/preferencias');
  }

  async cerrarSesion(): Promise<void> {
    this.menuUsuarioAbierto = false;
    const modal = await this.modalCtrl.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Cerrar sesión',
        title: '¿Desea cerrar sesión?',
        message:
          'Se cerrará su sesión y se eliminarán los tokens y datos temporales guardados en este navegador.',
        btnCancelTxt: 'Cancelar',
        btnOkTxt: 'Sí, cerrar sesión',
      },
    });
    await modal.present();
    const { data } = await modal.onDidDismiss<boolean>();
    if (!data) {
      return;
    }
    await this.authService.signOut({ redirectTo: '/admin/login' });
  }

  private cargarDatosUsuario(): void {
    const user = this.storage.getUser<LoginData>();
    this.nombreUsuario = this.resolverNombreUsuario(user);
    this.emailUsuario = user?.email?.trim() ?? '';
    this.inicialesUsuario = this.calcularIniciales(this.nombreUsuario);
  }

  private resolverNombreUsuario(user: LoginData | null): string {
    if (!user) {
      return 'Usuario';
    }
    const completo = user.nombreCompleto?.trim();
    if (completo) {
      return completo;
    }
    const partes = [user.nombres, user.apellidos]
      .map(v => v?.trim())
      .filter((v): v is string => !!v);
    if (partes.length) {
      return partes.join(' ');
    }
    return user.username?.trim() || user.email?.trim() || 'Usuario';
  }

  private calcularIniciales(nombre: string): string {
    const partes = nombre.split(/\s+/).filter(Boolean);
    if (partes.length >= 2) {
      return `${partes[0][0]}${partes[partes.length - 1][0]}`.toUpperCase();
    }
    if (partes.length === 1) {
      return partes[0].slice(0, 2).toUpperCase();
    }
    return 'U';
  }
}
