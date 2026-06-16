import { Component, inject } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { filter } from 'rxjs/operators';
import { AuthService } from '../../../auth/services/auth.service';

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
export class AdminShellComponent {

  private readonly router = inject(Router);
  private readonly authService = inject(AuthService);

  rutaActiva = '';
  menuAbierto = true;

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

  isActive(route: string): boolean {
    return this.rutaActiva.startsWith(route);
  }

  navegar(route: string): void {
    void this.router.navigateByUrl(route);
  }

  toggleMenu(): void {
    this.menuAbierto = !this.menuAbierto;
  }

  irAlErp(): void {
    void this.router.navigateByUrl('/dashboard');
  }

  cerrarSesion(): void {
    void this.authService.signOut({ redirectTo: '/admin/login' });
  }
}
