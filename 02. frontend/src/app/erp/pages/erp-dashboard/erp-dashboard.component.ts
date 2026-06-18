import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { ErpMenuService, MenuModulo } from '../../services/erp-menu.service';
import { ErpLayoutService } from '../../services/erp-layout.service';
import { MODULOS_ICONOS } from '../../shared/modulos-iconos';

interface ModuloGrid {
  codigo: string;
  nombre: string;
  icono: string;
  iconoSvg: string;
  moduloReal: MenuModulo | null;
}

const TODOS_MODULOS: { codigo: string; nombre: string; icono: string }[] = [
  { codigo: 'ALMACEN', nombre: 'Almacén', icono: 'inventory_2' },
  { codigo: 'COMPRAS', nombre: 'Compras', icono: 'shopping_cart' },
  { codigo: 'APROVISIONAMIENTO', nombre: 'Aprovisionamiento', icono: 'local_shipping' },
  { codigo: 'COMERCIALIZACION', nombre: 'Comercialización', icono: 'storefront' },
  { codigo: 'FINANZAS', nombre: 'Finanzas', icono: 'account_balance_wallet' },
  { codigo: 'CONTABILIDAD', nombre: 'Contabilidad', icono: 'calculate' },
  { codigo: 'ACTIVOS_FIJOS', nombre: 'Activos Fijos', icono: 'domain' },
  { codigo: 'RRHH', nombre: 'RR.HH.', icono: 'groups' },
  { codigo: 'PRODUCCION', nombre: 'Producción', icono: 'precision_manufacturing' },
  { codigo: 'PRESUPUESTO', nombre: 'Presupuesto', icono: 'request_quote' },
  { codigo: 'FLOTA', nombre: 'Flota', icono: 'local_shipping' },
  { codigo: 'MANTENIMIENTO', nombre: 'Mantenimiento', icono: 'build' },
  { codigo: 'AUDITORIA', nombre: 'Auditoría', icono: 'fact_check' },
  { codigo: 'CAMPO', nombre: 'Campo', icono: 'grass' },
  { codigo: 'COMEDOR', nombre: 'Comedor', icono: 'restaurant' },
  { codigo: 'SIG', nombre: 'SIG', icono: 'monitoring' },
  { codigo: 'OPERACIONES', nombre: 'Operaciones', icono: 'hub' },
  { codigo: 'HORECA', nombre: 'HORECA', icono: 'hotel' },
];

@Component({
  selector: 'app-erp-dashboard',
  standalone: true,
  imports: [CommonModule, MatIconModule],
  templateUrl: './erp-dashboard.component.html',
  styleUrls: ['./erp-dashboard.component.scss'],
})
export class ErpDashboardComponent implements OnInit {
  private readonly menuService = inject(ErpMenuService);
  private readonly layout = inject(ErpLayoutService);
  private readonly router = inject(Router);

  modulos: ModuloGrid[] = [];

  ngOnInit(): void {
    this.layout.seleccionarModulo(null);
    this.menuService.obtenerMiMenu().subscribe({
      next: modulosApi => {
        const mapa = new Map<string, MenuModulo>();
        for (const m of modulosApi) {
          mapa.set(m.codigo.toUpperCase(), m);
        }
        this.modulos = TODOS_MODULOS.map(def => {
          const real = mapa.get(def.codigo);
          return {
            codigo: def.codigo,
            nombre: real?.nombre ?? def.nombre,
            icono: real?.icono ?? def.icono,
            iconoSvg: real?.iconoSvg ?? (MODULOS_ICONOS[def.codigo] || ''),
            moduloReal: real ?? null,
          };
        });
      },
    });
  }

  abrirModulo(modulo: ModuloGrid): void {
    if (modulo.moduloReal) {
      this.layout.seleccionarModulo(modulo.moduloReal);
      void this.router.navigateByUrl(this.menuService.rutaDashboardModulo(modulo.codigo));
    } else {
      void this.router.navigateByUrl(`/sigre/m/${modulo.codigo.toLowerCase()}`);
    }
  }
}
