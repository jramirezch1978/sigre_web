import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { BaseChartDirective } from 'ng2-charts';
import { ChartData, ChartOptions } from 'chart.js';
import { forkJoin } from 'rxjs';
import { ErpLayoutService } from '../../../../services/erp-layout.service';
import { ErpMenuService } from '../../../../services/erp-menu.service';
import { AlmacenApiService } from '../../services/almacen-api.service';

interface AlmacenKpi {
  label: string;
  value: string;
  icon: string;
  color: string;
}

const MESES = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
const CHART_COLORS = ['#2E7D32', '#1abb9c', '#1565C0', '#E65100', '#6A1B9A', '#00838F', '#C62828', '#4527A0'];

@Component({
  selector: 'app-almacen-dashboard',
  standalone: true,
  imports: [CommonModule, MatIconModule, BaseChartDirective],
  templateUrl: './almacen-dashboard.component.html',
  styleUrls: ['./almacen-dashboard.component.scss'],
})
export class AlmacenDashboardComponent implements OnInit {
  private readonly layout = inject(ErpLayoutService);
  private readonly menuService = inject(ErpMenuService);
  private readonly almacenApi = inject(AlmacenApiService);

  readonly anio = new Date().getFullYear();

  kpis: AlmacenKpi[] = [];
  cargando = true;
  errorCarga = '';

  ingresosBarData: ChartData<'bar'> = { labels: MESES, datasets: [] };
  ingresosBarOptions: ChartOptions<'bar'> = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { display: false },
      tooltip: {
        callbacks: {
          label: ctx => `${ctx.parsed.y} ingreso(s)`,
        },
      },
    },
    scales: {
      x: { grid: { display: false } },
      y: { beginAtZero: true, ticks: { precision: 0 } },
    },
  };

  valorizacionDonutData: ChartData<'doughnut'> = { labels: [], datasets: [{ data: [], backgroundColor: [] }] };
  valorizacionDonutOptions: ChartOptions<'doughnut'> = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { position: 'bottom', labels: { padding: 12, usePointStyle: true, pointStyle: 'circle' } },
    },
  };

  ngOnInit(): void {
    this.menuService.obtenerMiMenu().subscribe({
      next: modulos => {
        const modulo = modulos.find(m => m.codigo === 'ALMACEN') ?? null;
        if (modulo) {
          this.layout.seleccionarModulo(modulo);
        }
      },
    });

    const fechaDesde = `${this.anio}-01-01`;
    const fechaHasta = `${this.anio}-12-31`;

    forkJoin({
      movimientos: this.almacenApi.listarMovimientosPeriodo(fechaDesde, fechaHasta),
      diagnostico: this.almacenApi.obtenerDiagnostico(),
      almacenes: this.almacenApi.listarAlmacenes(),
    }).subscribe({
      next: ({ movimientos, diagnostico, almacenes }) => {
        this.construirKpis(movimientos, diagnostico, almacenes.length);
        this.construirGraficoIngresos(movimientos);
        this.construirGraficoValorizacion(diagnostico);
        this.cargando = false;
      },
      error: () => {
        this.errorCarga = 'No se pudo cargar el resumen de almacén.';
        this.kpis = [
          { label: 'Ingresos del año', value: '—', icon: 'input', color: '#2E7D32' },
          { label: 'Salidas del año', value: '—', icon: 'output', color: '#C62828' },
          { label: 'Artículos en stock', value: '—', icon: 'inventory_2', color: '#1565C0' },
          { label: 'Valor inventario', value: '—', icon: 'paid', color: '#E65100' },
        ];
        this.cargando = false;
      },
    });
  }

  private construirKpis(
    movimientos: { tipoReferenciaOrigen?: string; flagEstado?: string }[],
    diagnostico: { totalArticulos: number; valorInventario: number }[],
    totalAlmacenes: number
  ): void {
    let ingresos = 0;
    let salidas = 0;

    for (const mov of movimientos) {
      if (mov.flagEstado === '0') continue;
      const clase = (mov.tipoReferenciaOrigen ?? '').trim().toUpperCase();
      if (clase === 'I' || clase === 'P') {
        ingresos++;
      } else if (clase === 'C' || clase === 'S') {
        salidas++;
      }
    }

    const totalArticulos = diagnostico.reduce((sum, d) => sum + (d.totalArticulos ?? 0), 0);
    const valorInventario = diagnostico.reduce((sum, d) => sum + Number(d.valorInventario ?? 0), 0);

    this.kpis = [
      { label: `Ingresos ${this.anio}`, value: String(ingresos), icon: 'input', color: '#2E7D32' },
      { label: `Salidas ${this.anio}`, value: String(salidas), icon: 'output', color: '#C62828' },
      { label: 'Artículos con stock', value: String(totalArticulos), icon: 'inventory_2', color: '#1565C0' },
      { label: 'Almacenes activos', value: String(totalAlmacenes), icon: 'warehouse', color: '#1abb9c' },
      {
        label: 'Valor inventario',
        value: this.formatearMoneda(valorInventario),
        icon: 'paid',
        color: '#E65100',
      },
    ];
  }

  private construirGraficoIngresos(movimientos: { fechaMov?: string; tipoReferenciaOrigen?: string; flagEstado?: string }[]): void {
    const porMes = Array(12).fill(0);

    for (const mov of movimientos) {
      if (mov.flagEstado === '0') continue;
      const clase = (mov.tipoReferenciaOrigen ?? '').trim().toUpperCase();
      if (clase !== 'I' && clase !== 'P') continue;
      if (!mov.fechaMov) continue;
      const mes = new Date(`${mov.fechaMov}T12:00:00`).getMonth();
      if (mes >= 0 && mes < 12) {
        porMes[mes]++;
      }
    }

    this.ingresosBarData = {
      labels: MESES,
      datasets: [
        {
          label: 'Ingresos',
          data: porMes,
          backgroundColor: '#2E7D32',
          borderRadius: 6,
          maxBarThickness: 36,
        },
      ],
    };
  }

  private construirGraficoValorizacion(
    diagnostico: { almacenNombre: string; valorInventario: number }[]
  ): void {
    const items = diagnostico
      .filter(d => Number(d.valorInventario) > 0)
      .sort((a, b) => Number(b.valorInventario) - Number(a.valorInventario))
      .slice(0, 8);

    if (!items.length) {
      this.valorizacionDonutData = {
        labels: ['Sin datos'],
        datasets: [{ data: [1], backgroundColor: ['#E2E8F0'] }],
      };
      return;
    }

    this.valorizacionDonutData = {
      labels: items.map(d => d.almacenNombre),
      datasets: [
        {
          data: items.map(d => Number(d.valorInventario)),
          backgroundColor: items.map((_, i) => CHART_COLORS[i % CHART_COLORS.length]),
        },
      ],
    };
  }

  private formatearMoneda(valor: number): string {
    if (!valor) return 'S/ 0';
    return new Intl.NumberFormat('es-PE', {
      style: 'currency',
      currency: 'PEN',
      maximumFractionDigits: 0,
    }).format(valor);
  }
}
