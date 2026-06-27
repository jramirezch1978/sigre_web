import { Component, HostListener, OnDestroy, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NavigationEnd, Router, RouterModule } from '@angular/router';
import { filter } from 'rxjs/operators';
import { StorageService } from '../../../core/services/storage.service';
import { AuthService } from '../../../auth/services/auth.service';
import { ErpMenuService, MenuModulo } from '../../services/erp-menu.service';
import { ErpLayoutService } from '../../services/erp-layout.service';
import { MetoxiInitService } from '../../services/metoxi-init.service';
import { fusionarModulosConCatalogo } from '../../shared/erp-modulos-catalog.config';
import { iconoModulo } from '../../shared/modulos-iconos';

interface CeldaAppsLauncher {
  codigo: string;
  modulo: MenuModulo | null;
}

interface NotificacionDemo {
  titulo: string;
  descripcion: string;
  tiempo: string;
  iniciales: string;
  badgeClass: string;
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

  nombreUsuario = '';
  empresaActual = '';
  sucursalActual = '';

  modulos: MenuModulo[] = [];
  moduloActivo: MenuModulo | null = null;
  cargandoMenu = true;
  errorMenu = '';

  dropdownActivo: 'apps' | 'notificaciones' | 'usuario' | null = null;
  seccionExpandidaId: number | null = null;

  readonly notificacionesDemo: NotificacionDemo[] = [
    {
      titulo: 'Stock bajo',
      descripcion: 'Hay artículos por debajo del mínimo en almacén.',
      tiempo: 'Hoy',
      iniciales: 'ST',
      badgeClass: 'bg-warning text-warning bg-opacity-10',
    },
    {
      titulo: 'OC pendiente',
      descripcion: 'Una orden de compra espera aprobación.',
      tiempo: 'Ayer',
      iniciales: 'OC',
      badgeClass: 'bg-primary text-primary bg-opacity-10',
    },
    {
      titulo: 'Planilla',
      descripcion: 'Periodo de planilla abierto para revisión.',
      tiempo: '2d',
      iniciales: 'RH',
      badgeClass: 'bg-success text-success bg-opacity-10',
    },
  ];

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
    this.dropdownActivo = this.dropdownActivo === tipo ? null : tipo;
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
    this.seccionExpandidaId = null;
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

  toggleSeccionSidebar(seccionId: number): void {
    this.seccionExpandidaId = this.seccionExpandidaId === seccionId ? null : seccionId;
  }

  irADashboard(): void {
    this.layout.seleccionarModulo(null);
    this.dropdownActivo = null;
    this.seccionExpandidaId = null;
    void this.router.navigate(['/sigre/dashboard']);
  }

  irASeguridadUsuarios(): void {
    this.dropdownActivo = null;
    void this.router.navigate(['/sigre/seguridad-usuarios']);
  }

  navegarOpcion(event: Event, ruta: string | null, codigo?: string): void {
    event.preventDefault();
    event.stopPropagation();
    const destino = codigo
      ? this.menuService.resolverRutaFrontend(codigo, ruta)
      : this.menuService.normalizarRutaFrontend(ruta);
    if (!destino) return;
    this.dropdownActivo = null;
    void this.router.navigateByUrl(destino);
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
