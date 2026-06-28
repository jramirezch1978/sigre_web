import { Component, HostListener, OnDestroy, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NavigationEnd, Router, RouterModule } from '@angular/router';
import { filter } from 'rxjs/operators';
import { StorageService } from '../../../core/services/storage.service';
import { AuthService } from '../../../auth/services/auth.service';
import { ErpMenuService, MenuModulo, MenuOpcion } from '../../services/erp-menu.service';
import { ErpLayoutService } from '../../services/erp-layout.service';
import { MetoxiInitService } from '../../services/metoxi-init.service';
import { ErpNotificacionService, NotificacionItem } from '../../services/erp-notificacion.service';
import { fusionarModulosConCatalogo } from '../../shared/erp-modulos-catalog.config';
import { iconoModulo } from '../../shared/modulos-iconos';

interface CeldaAppsLauncher {
  codigo: string;
  modulo: MenuModulo | null;
}

@Component({
  selector: 'app-erp-inicio',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './erp-inicio.component.html',
  styleUrls: ['./erp-inicio.component.scss'],
})
export class ErpInicioComponent implements OnInit, OnDestroy {

  private readonly router = inject(Router);
  private readonly storage = inject(StorageService);
  private readonly authService = inject(AuthService);
  private readonly menuService = inject(ErpMenuService);
  private readonly layout = inject(ErpLayoutService);
  private readonly metoxiInit = inject(MetoxiInitService);
  private readonly notificacionService = inject(ErpNotificacionService);

  nombreUsuario = '';
  empresaActual = '';
  sucursalActual = '';

  modulos: MenuModulo[] = [];
  moduloActivo: MenuModulo | null = null;
  cargandoMenu = true;
  errorMenu = '';

  dropdownActivo: 'apps' | 'notificaciones' | 'usuario' | null = null;
  /** Ids de nodos (secciones/submenús) expandidos en el sidebar (profundidad arbitraria). */
  nodosExpandidos = new Set<number>();

  notificaciones: NotificacionItem[] = [];
  notificacionesNoLeidas = 0;

  ngOnInit(): void {
    this.metoxiInit.activarShellErp();

    const user = this.storage.getUser<{
      nombreCompleto?: string;
      nombres?: string;
      empresaNombre?: string;
      sucursalNombre?: string;
    }>();

    if (user?.nombreCompleto) {
      this.nombreUsuario = user.nombreCompleto;
      this.empresaActual = user.empresaNombre ?? '';
      this.sucursalActual = user.sucursalNombre ?? '';
    } else {
      const claims = this.leerClaimsToken();
      this.nombreUsuario = claims?.nombreCompleto ?? claims?.nombres ?? 'Usuario';
      this.empresaActual = claims?.empresaNombre ?? '';
      this.sucursalActual = claims?.sucursalNombre ?? '';
    }

    this.cargarMenu();
    this.cargarNotificaciones();
    this.layout.moduloActivo$.subscribe(modulo => {
      this.moduloActivo = modulo;
    });
    this.router.events
      .pipe(filter((e): e is NavigationEnd => e instanceof NavigationEnd))
      .subscribe(() => this.sincronizarModuloConRuta());
  }

  ngOnDestroy(): void {
    this.metoxiInit.desactivarShellErp();
  }

  @HostListener('document:click')
  onDocumentClick(): void {
    this.dropdownActivo = null;
  }

  get inicialesUsuario(): string {
    const partes = this.nombreUsuario.trim().split(/\s+/).filter(Boolean);
    if (!partes.length) return 'U';
    if (partes.length === 1) return partes[0].slice(0, 2).toUpperCase();
    return (partes[0][0] + partes[partes.length - 1][0]).toUpperCase();
  }

  get filasAppsLauncher(): CeldaAppsLauncher[][] {
    const celdas: CeldaAppsLauncher[] = this.modulos.map(m => ({
      codigo: m.codigo,
      modulo: m,
    }));
    const total = celdas.length;
    const resto = total % 3;
    if (resto > 0) {
      for (let i = 0; i < 3 - resto; i++) {
        celdas.push({ codigo: `empty-${i}`, modulo: null });
      }
    }
    const filas: CeldaAppsLauncher[][] = [];
    for (let i = 0; i < celdas.length; i += 3) {
      filas.push(celdas.slice(i, i + 3));
    }
    return filas;
  }

  toggleSidebar(): void {
    document.body.classList.toggle('toggled');
  }

  toggleDropdown(tipo: 'apps' | 'notificaciones' | 'usuario'): void {
    const abriendo = this.dropdownActivo !== tipo;
    this.dropdownActivo = abriendo ? tipo : null;
    // Al abrir el panel de notificaciones, marcar como leídas (el badge cuenta no leídas).
    if (abriendo && tipo === 'notificaciones' && this.notificacionesNoLeidas > 0) {
      this.notificacionService.marcarTodasLeidas().subscribe({
        next: () => {
          this.notificacionesNoLeidas = 0;
          this.notificaciones = this.notificaciones.map(n => ({ ...n, leido: true }));
        },
        error: () => { /* el listado igual se muestra */ },
      });
    }
  }

  cargarNotificaciones(): void {
    this.notificacionService.getResumen().subscribe({
      next: (r) => {
        this.notificaciones = r.items;
        this.notificacionesNoLeidas = r.noLeidas;
      },
      error: () => { /* silencioso: el dashboard no debe romperse por notificaciones */ },
    });
  }

  /** Icono Material según el tipo de notificación (I/S/W/E). */
  iconoNotificacion(tipo: string): string {
    switch (tipo) {
      case 'S': return 'check_circle';
      case 'W': return 'warning';
      case 'E': return 'error';
      default: return 'info';
    }
  }

  /** Clase de color del icono según el tipo. */
  claseNotificacion(tipo: string): string {
    switch (tipo) {
      case 'S': return 'bg-success text-success bg-opacity-10';
      case 'W': return 'bg-warning text-warning bg-opacity-10';
      case 'E': return 'bg-danger text-danger bg-opacity-10';
      default: return 'bg-primary text-primary bg-opacity-10';
    }
  }

  cargarMenu(): void {
    this.cargandoMenu = true;
    this.errorMenu = '';
    this.menuService.obtenerMiMenu().subscribe({
      next: (modulosApi) => {
        this.modulos = fusionarModulosConCatalogo(modulosApi, true);
        this.cargandoMenu = false;
        this.sincronizarModuloConRuta();
      },
      error: (err) => {
        this.cargandoMenu = false;
        this.errorMenu = err?.error?.message ?? 'No se pudo cargar el menú';
      },
    });
  }

  seleccionarModulo(modulo: MenuModulo): void {
    this.layout.seleccionarModulo(modulo);
    this.dropdownActivo = null;
    this.nodosExpandidos.clear();
    void this.router.navigateByUrl(this.menuService.rutaDashboardModulo(modulo.codigo));
  }

  abrirModuloDesdeApps(modulo: MenuModulo): void {
    this.seleccionarModulo(modulo);
  }

  onClickModuloSidebar(modulo: MenuModulo): void {
    if (this.moduloActivo?.codigo === modulo.codigo && modulo.secciones.length > 0) {
      return;
    }
    this.seleccionarModulo(modulo);
  }

  toggleNodo(nodoId: number): void {
    if (this.nodosExpandidos.has(nodoId)) {
      this.nodosExpandidos.delete(nodoId);
    } else {
      this.nodosExpandidos.add(nodoId);
    }
  }

  estaExpandido(nodoId: number): boolean {
    return this.nodosExpandidos.has(nodoId);
  }

  irADashboard(): void {
    this.layout.seleccionarModulo(null);
    this.dropdownActivo = null;
    this.nodosExpandidos.clear();
    void this.router.navigate(['/sigre/dashboard']);
  }

  irASeguridadUsuarios(): void {
    this.dropdownActivo = null;
    void this.router.navigate(['/sigre/seguridad-usuarios']);
  }

  /** Click en una opción del menú: si tiene hijos despliega; si es hoja navega a su path_url. */
  navegarOpcion(event: Event, opcion: MenuOpcion): void {
    event.preventDefault();
    event.stopPropagation();
    if (opcion.hijos && opcion.hijos.length > 0) {
      this.toggleNodo(opcion.id);
      return;
    }
    this.dropdownActivo = null;
    if (opcion.pathUrl) {
      void this.router.navigateByUrl(this.menuService.rutaDestinoPath(opcion.pathUrl));
    } else {
      void this.router.navigate(['/sigre/en-construccion'], { queryParams: { op: opcion.nombre } });
    }
  }

  get enDashboard(): boolean {
    return this.router.url.includes('/dashboard') || this.router.url === '/sigre' || this.router.url === '/sigre/';
  }

  private sincronizarModuloConRuta(): void {
    if (!this.modulos.length) return;
    if (this.enDashboard) {
      this.layout.seleccionarModulo(null);
      return;
    }
    const mod = this.menuService.resolverModuloPorUrl(this.router.url, this.modulos);
    if (mod) {
      this.layout.seleccionarModulo(mod);
    }
  }

  cerrarSesion(): void {
    void this.authService.signOut();
  }

  iconoSidebar(modulo: MenuModulo): string {
    return modulo.iconoSvg || iconoModulo(modulo.codigo);
  }

  private leerClaimsToken(): Record<string, string> | null {
    const token = this.storage.getToken();
    if (!token) return null;
    try {
      const parts = token.split('.');
      if (parts.length !== 3) return null;
      let base64 = parts[1].replace(/-/g, '+').replace(/_/g, '/');
      while (base64.length % 4 !== 0) base64 += '=';
      return JSON.parse(atob(base64));
    } catch {
      return null;
    }
  }
}
