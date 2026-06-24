import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute } from '@angular/router';
import { BaseChartDirective } from 'ng2-charts';
import { ChartData, ChartOptions } from 'chart.js';
import { ErpMenuService, MenuModulo } from '../../services/erp-menu.service';
import { ErpLayoutService } from '../../services/erp-layout.service';

interface ModuloKpi {
  label: string;
  value: string;
  icon: string;
  color: string;
}

@Component({
  selector: 'app-erp-module-home',
  standalone: true,
  imports: [CommonModule, BaseChartDirective],
  templateUrl: './erp-module-home.component.html',
  styleUrls: ['./erp-module-home.component.scss'],
})
export class ErpModuleHomeComponent implements OnInit {
  private readonly route = inject(ActivatedRoute);
  private readonly menuService = inject(ErpMenuService);
  private readonly layout = inject(ErpLayoutService);

  readonly anio = new Date().getFullYear();

  modulo: MenuModulo | null = null;
  cargando = true;
  kpis: ModuloKpi[] = [];

  seccionesBarData: ChartData<'bar'> = { labels: [], datasets: [] };
  seccionesBarOptions: ChartOptions<'bar'> = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: { legend: { display: false } },
    scales: {
      x: { grid: { display: false } },
      y: { beginAtZero: true, ticks: { precision: 0 } },
    },
  };

  opcionesDonutData: ChartData<'doughnut'> = { labels: [], datasets: [{ data: [], backgroundColor: [] }] };
  opcionesDonutOptions: ChartOptions<'doughnut'> = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { position: 'bottom', labels: { padding: 12, usePointStyle: true, pointStyle: 'circle' } },
    },
  };

  ngOnInit(): void {
    const codigo = (this.route.snapshot.paramMap.get('codigo') ?? '').toUpperCase();
    this.menuService.obtenerMiMenu().subscribe({
      next: modulos => {
        this.modulo = modulos.find(m => m.codigo.toUpperCase() === codigo) ?? null;
        if (this.modulo) {
          this.layout.seleccionarModulo(this.modulo);
          this.construirResumen(this.modulo);
        }
        this.cargando = false;
      },
      error: () => {
        this.cargando = false;
      },
    });
  }

  private construirResumen(modulo: MenuModulo): void {
    const secciones = modulo.secciones.length;
    const opciones = modulo.secciones.reduce((sum, s) => sum + s.opciones.length, 0);
    const activas = modulo.secciones.reduce(
      (sum, s) => sum + s.opciones.filter(o => !!o.rutaFrontend).length,
      0
    );
    const proximamente = opciones - activas;
    const acciones = modulo.secciones.reduce(
      (sum, s) => sum + s.opciones.reduce((a, o) => a + o.acciones.length, 0),
      0
    );

    this.kpis = [
      { label: 'Secciones del menú', value: String(secciones), icon: 'folder', color: '#1abb9c' },
      { label: 'Opciones totales', value: String(opciones), icon: 'list_alt', color: '#1565C0' },
      { label: 'Opciones disponibles', value: String(activas), icon: 'check_circle', color: '#2E7D32' },
      { label: 'Acciones asignadas', value: String(acciones), icon: 'security', color: '#E65100' },
    ];

    const labels = modulo.secciones.map(s => this.abreviar(s.nombre, 14));
    const data = modulo.secciones.map(s => s.opciones.length);

    this.seccionesBarData = {
      labels,
      datasets: [
        {
          label: 'Opciones',
          data,
          backgroundColor: '#1abb9c',
          borderRadius: 6,
          maxBarThickness: 40,
        },
      ],
    };

    this.opcionesDonutData = {
      labels: ['Disponibles', 'Próximamente'],
      datasets: [
        {
          data: [activas, proximamente],
          backgroundColor: ['#2E7D32', '#E2E8F0'],
        },
      ],
    };
  }

  private abreviar(texto: string, max: number): string {
    return texto.length <= max ? texto : `${texto.slice(0, max - 1)}…`;
  }
}
