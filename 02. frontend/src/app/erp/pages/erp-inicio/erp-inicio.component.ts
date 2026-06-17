import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { StorageService } from '../../../core/services/storage.service';
import { AuthService } from '../../../auth/services/auth.service';

interface ModuloERP {
  titulo: string;
  descripcion: string;
  icono: string;
  color: string;
  ruta: string;
  habilitado: boolean;
}

@Component({
  selector: 'app-erp-inicio',
  standalone: true,
  imports: [CommonModule, RouterModule, MatIconModule, MatButtonModule],
  templateUrl: './erp-inicio.component.html',
  styleUrls: ['./erp-inicio.component.scss'],
})
export class ErpInicioComponent implements OnInit {

  private readonly router = inject(Router);
  private readonly storage = inject(StorageService);
  private readonly authService = inject(AuthService);

  nombreUsuario = '';
  empresaActual = '';
  sucursalActual = '';
  currentYear = new Date().getFullYear();

  modulos: ModuloERP[] = [
    {
      titulo: 'Contabilidad',
      descripcion: 'Plan de cuentas, asientos, libros electrónicos',
      icono: 'account_balance',
      color: '#3498db',
      ruta: '/erp/contabilidad',
      habilitado: false,
    },
    {
      titulo: 'Compras',
      descripcion: 'Órdenes de compra, proveedores, cuentas por pagar',
      icono: 'shopping_cart',
      color: '#27ae60',
      ruta: '/erp/compras',
      habilitado: false,
    },
    {
      titulo: 'Ventas',
      descripcion: 'Facturación, clientes, cuentas por cobrar',
      icono: 'point_of_sale',
      color: '#e67e22',
      ruta: '/erp/ventas',
      habilitado: false,
    },
    {
      titulo: 'Activos Fijos',
      descripcion: 'Control de activos, depreciación, revaluación',
      icono: 'domain',
      color: '#8e44ad',
      ruta: '/erp/activos-fijos',
      habilitado: false,
    },
    {
      titulo: 'Tesorería',
      descripcion: 'Flujo de caja, bancos, conciliaciones',
      icono: 'savings',
      color: '#16a085',
      ruta: '/erp/tesoreria',
      habilitado: false,
    },
    {
      titulo: 'Planillas',
      descripcion: 'Nómina, boletas, AFP, PLAME',
      icono: 'groups',
      color: '#c0392b',
      ruta: '/erp/planillas',
      habilitado: false,
    },
  ];

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
  }

  navegarModulo(modulo: ModuloERP): void {
    if (!modulo.habilitado) return;
    void this.router.navigateByUrl(modulo.ruta);
  }

  cerrarSesion(): void {
    void this.authService.signOut();
  }
}
