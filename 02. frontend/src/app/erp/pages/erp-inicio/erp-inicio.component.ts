import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { StorageService } from '../../../core/services/storage.service';
import { AuthService } from '../../../auth/services/auth.service';
import { ErpMenuService, MenuModulo } from '../../services/erp-menu.service';

@Component({
  selector: 'app-erp-inicio',
  standalone: true,
  imports: [CommonModule, RouterModule, MatIconModule, MatButtonModule, MatProgressSpinnerModule],
  templateUrl: './erp-inicio.component.html',
  styleUrls: ['./erp-inicio.component.scss'],
})
export class ErpInicioComponent implements OnInit {

  private readonly router = inject(Router);
  private readonly storage = inject(StorageService);
  private readonly authService = inject(AuthService);
  private readonly menuService = inject(ErpMenuService);

  nombreUsuario = '';
  empresaActual = '';
  sucursalActual = '';
  currentYear = new Date().getFullYear();

  modulos: MenuModulo[] = [];
  moduloActivo: MenuModulo | null = null;
  cargandoMenu = true;
  errorMenu = '';

  ngOnInit(): void {
    const user = this.storage.getUser<{
      nombreCompleto?: string;
      nombres?: string;
      empresaNombre?: string;
      sucursalNombre?: string;
    }>();
    this.nombreUsuario = user?.nombreCompleto ?? user?.nombres ?? 'Usuario';
    this.empresaActual = user?.empresaNombre ?? '';
    this.sucursalActual = user?.sucursalNombre ?? '';

    this.cargarMenu();
  }

  cargarMenu(): void {
    this.cargandoMenu = true;
    this.menuService.obtenerMiMenu().subscribe({
      next: (modulos) => {
        this.modulos = modulos;
        this.cargandoMenu = false;
      },
      error: (err) => {
        this.cargandoMenu = false;
        this.errorMenu = err?.error?.message ?? 'No se pudo cargar el menú';
      },
    });
  }

  seleccionarModulo(modulo: MenuModulo): void {
    this.moduloActivo = this.moduloActivo?.moduloId === modulo.moduloId ? null : modulo;
  }

  navegarOpcion(ruta: string | null): void {
    if (!ruta) return;
    void this.router.navigateByUrl(ruta);
  }

  cerrarSesion(): void {
    void this.authService.signOut();
  }
}
