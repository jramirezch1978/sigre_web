import { Component, OnInit, OnDestroy, inject, HostListener } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NavigationEnd, Router, RouterModule } from '@angular/router';
import { filter } from 'rxjs/operators';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { StorageService } from '../../../core/services/storage.service';
import { AuthService } from '../../../auth/services/auth.service';
import { ErpMenuService, MenuModulo } from '../../services/erp-menu.service';
import { ErpLayoutService } from '../../services/erp-layout.service';

@Component({
  selector: 'app-erp-inicio',
  standalone: true,
  imports: [CommonModule, RouterModule, MatIconModule, MatButtonModule, MatProgressSpinnerModule],
  templateUrl: './erp-inicio.component.html',
  styleUrls: ['./erp-inicio.component.scss'],
})
export class ErpInicioComponent implements OnInit, OnDestroy {

  private readonly router = inject(Router);
  private readonly storage = inject(StorageService);
  private readonly authService = inject(AuthService);
  private readonly menuService = inject(ErpMenuService);
  private readonly layout = inject(ErpLayoutService);

  nombreUsuario = '';
  empresaActual = '';
  sucursalActual = '';

  modulos: MenuModulo[] = [];
  moduloActivo: MenuModulo | null = null;
  cargandoMenu = true;
  errorMenu = '';

  dropdownAbiertoId: number | null = null;
  private dropdownTimeout: ReturnType<typeof setTimeout> | null = null;

  ngOnInit(): void {
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
    this.limpiarTimeout();
  }

  @HostListener('document:click', ['$event'])
  onDocumentClick(): void {
    this.dropdownAbiertoId = null;
  }

  cargarMenu(): void {
    this.cargandoMenu = true;
    this.errorMenu = '';
    this.menuService.obtenerMiMenu().subscribe({
      next: (modulos) => {
        this.modulos = modulos;
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
    this.dropdownAbiertoId = null;
    void this.router.navigateByUrl(this.menuService.rutaDashboardModulo(modulo.codigo));
  }

  irADashboard(): void {
    this.layout.seleccionarModulo(null);
    this.dropdownAbiertoId = null;
    void this.router.navigate(['/sigre/dashboard']);
  }

  abrirDropdown(seccionId: number): void {
    this.limpiarTimeout();
    this.dropdownAbiertoId = seccionId;
  }

  cerrarDropdown(): void {
    this.limpiarTimeout();
    this.dropdownTimeout = setTimeout(() => {
      this.dropdownAbiertoId = null;
    }, 150);
  }

  navegarOpcion(event: Event, ruta: string | null, codigo?: string): void {
    event.preventDefault();
    event.stopPropagation();
    const destino = codigo
      ? this.menuService.resolverRutaFrontend(codigo, ruta)
      : this.menuService.normalizarRutaFrontend(ruta);
    if (!destino) return;
    this.dropdownAbiertoId = null;
    void this.router.navigateByUrl(destino);
  }

  get contenidoAnchoCompleto(): boolean {
    return !this.enDashboard;
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

  private limpiarTimeout(): void {
    if (this.dropdownTimeout) {
      clearTimeout(this.dropdownTimeout);
      this.dropdownTimeout = null;
    }
  }
}
