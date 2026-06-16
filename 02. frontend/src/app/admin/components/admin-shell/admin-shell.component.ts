import { Component, HostListener, OnInit, inject } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { filter } from 'rxjs/operators';
import { AuthService, LoginData } from '../../../auth/services/auth.service';
import { StorageService } from '../../../core/services/storage.service';

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
export class AdminShellComponent implements OnInit {

  private readonly router = inject(Router);
  private readonly authService = inject(AuthService);
  private readonly storage = inject(StorageService);

  rutaActiva = '';
  menuAbierto = true;
  menuUsuarioAbierto = false;
  nombreUsuario = 'Usuario';
  emailUsuario = '';
  inicialesUsuario = 'U';

  readonly menuItems: AdminMenuItem[] = [
    { label: 'Inicio', icon: 'home-outline', route: '/admin/inicio' },
    { label: 'Empresas', icon: 'business-outline', route: '/admin/empresas' },
    { label: 'Usuarios', icon: 'people-outline', route: '/admin/usuarios' },
    { label: 'Roles', icon: 'key-outline', route: '/admin/roles' },
    { label: 'Módulos', icon: 'grid-outline', route: '/admin/modulos' },
    { label: 'Opciones de menú', icon: 'list-outline', route: '/admin/opciones-menu' },
    { label: 'Acciones', icon: 'flash-outline', route: '/admin/acciones' },
    { label: 'Roles x Usuario', icon: 'person-add-outline', route: '/admin/roles-usuario' },
    { label: 'Sucursales', icon: 'storefront-outline', route: '/admin/sucursales' },
    { label: 'Usuarios x Sucursal', icon: 'git-network-outline', route: '/admin/usuarios-sucursales' },
  ];

  constructor() {
    this.rutaActiva = this.router.url;
    this.router.events
      .pipe(filter((e): e is NavigationEnd => e instanceof NavigationEnd))
      .subscribe(e => this.rutaActiva = e.urlAfterRedirects);
  }

  ngOnInit(): void {
    this.cargarDatosUsuario();
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
    this.menuAbierto = !this.menuAbierto;
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

  cerrarSesion(): void {
    this.menuUsuarioAbierto = false;
    void this.authService.signOut({ redirectTo: '/admin/login' });
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
