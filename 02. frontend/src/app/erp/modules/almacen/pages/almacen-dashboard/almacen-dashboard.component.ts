import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { forkJoin } from 'rxjs';
import { ErpLayoutService } from '../../../../services/erp-layout.service';
import { ErpMenuService, MenuModulo, MenuSeccion } from '../../../../services/erp-menu.service';
import { AlmacenApiService } from '../../services/almacen-api.service';

interface AlmacenKpi {
  label: string;
  value: string;
  icon: string;
  color: string;
}

@Component({
  selector: 'app-almacen-dashboard',
  standalone: true,
  imports: [CommonModule, MatIconModule],
  templateUrl: './almacen-dashboard.component.html',
  styleUrls: ['./almacen-dashboard.component.scss'],
})
export class AlmacenDashboardComponent implements OnInit {
  private readonly router = inject(Router);
  private readonly layout = inject(ErpLayoutService);
  private readonly menuService = inject(ErpMenuService);
  private readonly almacenApi = inject(AlmacenApiService);

  modulo: MenuModulo | null = null;
  kpis: AlmacenKpi[] = [];
  cargando = true;

  ngOnInit(): void {
    this.menuService.obtenerMiMenu().subscribe({
      next: modulos => {
        this.modulo = modulos.find(m => m.codigo === 'ALMACEN') ?? null;
        if (this.modulo) {
          this.layout.seleccionarModulo(this.modulo);
        }
      },
    });

    forkJoin({
      almacenes: this.almacenApi.listarAlmacenes(),
      tiposMov: this.almacenApi.listarTiposMovimiento(),
      motivos: this.almacenApi.listarMotivosTraslado(),
    }).subscribe({
      next: ({ almacenes, tiposMov, motivos }) => {
        const activos = almacenes.filter(a => a.flagEstado === '1').length;
        this.kpis = [
          { label: 'Almacenes registrados', value: String(almacenes.length), icon: 'warehouse', color: '#2E7D32' },
          { label: 'Almacenes activos', value: String(activos), icon: 'check_circle', color: '#1abb9c' },
          { label: 'Tipos de movimiento', value: String(tiposMov.length), icon: 'swap_horiz', color: '#1565C0' },
          { label: 'Motivos de traslado', value: String(motivos.length), icon: 'local_shipping', color: '#E65100' },
        ];
        this.cargando = false;
      },
      error: () => {
        this.kpis = [
          { label: 'Almacenes', value: '—', icon: 'warehouse', color: '#2E7D32' },
          { label: 'Movimientos', value: '—', icon: 'swap_horiz', color: '#1565C0' },
        ];
        this.cargando = false;
      },
    });
  }

  abrirOpcion(codigo: string, ruta: string | null): void {
    const destino = this.menuService.resolverRutaFrontend(codigo, ruta);
    if (!destino) return;
    void this.router.navigateByUrl(destino);
  }

  iconoSeccion(codigo: string): string {
    if (codigo.includes('TABLAS')) return 'table_chart';
    if (codigo.includes('OPERACIONES')) return 'sync_alt';
    if (codigo.includes('CONSULTAS')) return 'search';
    if (codigo.includes('REPORTES')) return 'assessment';
    if (codigo.includes('PROCESOS')) return 'settings_suggest';
    return 'folder';
  }

  accesosRapidos(seccion: MenuSeccion): typeof seccion.opciones {
    return seccion.opciones.slice(0, 6);
  }
}
