import { AfterViewInit, Component, OnDestroy, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ErpLayoutService } from '../../services/erp-layout.service';
import {
  METOXI_CHART1_OPTIONS,
  METOXI_CHART2_OPTIONS,
  METOXI_CHART3_OPTIONS,
  METOXI_CHART4_OPTIONS,
} from './sigre-metoxi-dashboard.charts';

interface ApexChartInstance {
  destroy(): void;
  render(): Promise<void>;
}

declare global {
  interface Window {
    ApexCharts?: new (el: Element, opts: object) => ApexChartInstance;
  }
}

@Component({
  selector: 'app-erp-dashboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './erp-dashboard.component.html',
  styleUrls: ['./erp-dashboard.component.scss'],
})
export class ErpDashboardComponent implements OnInit, AfterViewInit, OnDestroy {
  private readonly layout = inject(ErpLayoutService);
  private charts: ApexChartInstance[] = [];

  readonly proyectosEnCurso = [
    { nombre: 'Angular 12', subtitulo: 'Admin Template', porcentaje: 95, icono: 'code', iconClass: 'text-danger', barClass: 'bg-danger' },
    { nombre: 'React Js', subtitulo: 'eCommerce Admin', porcentaje: 90, icono: 'web', iconClass: 'text-info', barClass: 'bg-info' },
    { nombre: 'Vue Js', subtitulo: 'Dashboard Template', porcentaje: 85, icono: 'dashboard', iconClass: 'text-success', barClass: 'bg-success' },
    { nombre: 'Bootstrap 5', subtitulo: 'Corporate Website', porcentaje: 75, icono: 'layers', iconClass: 'text-primary', barClass: 'bg-primary' },
    { nombre: 'Magento', subtitulo: 'Shoping Portal', porcentaje: 65, icono: 'storefront', iconClass: 'text-warning', barClass: 'bg-warning' },
    { nombre: 'Django', subtitulo: 'Backend Admin', porcentaje: 55, icono: 'dns', iconClass: 'text-info', barClass: 'bg-info' },
    { nombre: 'Python', subtitulo: 'User Panel', porcentaje: 45, icono: 'terminal', iconClass: 'text-secondary', barClass: 'bg-secondary' },
  ];

  readonly campanias = [
    { nombre: 'Facebook', porcentaje: 55, icono: 'facebook', iconBg: 'bg-primary', donutClass: 'sigre-dash-donut--primary' },
    { nombre: 'LinkedIn', porcentaje: 67, icono: 'work', iconBg: 'bg-danger', donutClass: 'sigre-dash-donut--danger' },
    { nombre: 'Instagram', porcentaje: 78, icono: 'photo_camera', iconBg: 'bg-success', donutClass: 'sigre-dash-donut--success' },
    { nombre: 'Snapchat', porcentaje: 46, icono: 'chat', iconBg: 'bg-warning', donutClass: 'sigre-dash-donut--warning' },
    { nombre: 'Google', porcentaje: 38, icono: 'search', iconBg: 'bg-info', donutClass: 'sigre-dash-donut--info' },
    { nombre: 'Altaba', porcentaje: 15, icono: 'business', iconBg: 'bg-purple', donutClass: 'sigre-dash-donut--purple' },
    { nombre: 'Spotify', porcentaje: 12, icono: 'music_note', iconBg: 'bg-pink', donutClass: 'sigre-dash-donut--pink' },
    { nombre: 'Photoes', porcentaje: 24, icono: 'collections', iconBg: 'bg-success', donutClass: 'sigre-dash-donut--teal' },
  ];

  readonly transacciones = [
    { titulo: 'Online Purchase', fecha: '03/10/2022', monto: '$97,896', icono: 'shopping_cart', iconBg: 'bg-danger' },
    { titulo: 'Bank Transfer', fecha: '03/10/2022', monto: '$86,469', icono: 'monetization_on', iconBg: 'bg-primary' },
    { titulo: 'Credit Card', fecha: '03/10/2022', monto: '$45,259', icono: 'credit_card', iconBg: 'bg-success' },
    { titulo: 'Laptop Payment', fecha: '03/10/2022', monto: '$35,249', icono: 'account_balance', iconBg: 'bg-purple' },
    { titulo: 'Template Payment', fecha: '03/10/2022', monto: '$68,478', icono: 'savings', iconBg: 'bg-orange' },
    { titulo: 'iPhone Purchase', fecha: '03/10/2022', monto: '$55,128', icono: 'paid', iconBg: 'bg-info' },
    { titulo: 'Account Credit', fecha: '03/10/2022', monto: '$24,568', icono: 'card_giftcard', iconBg: 'bg-pink' },
  ];

  readonly productosPopulares = [
    { nombre: 'Apple Hand Watch', ventas: 258, precio: '$199', icono: 'watch', thumbBg: 'sigre-dash-product-thumb--1' },
    { nombre: 'Mobile Phone Set', ventas: 169, precio: '$159', icono: 'smartphone', thumbBg: 'sigre-dash-product-thumb--2' },
    { nombre: 'Fancy Chair', ventas: 268, precio: '$678', icono: 'chair', thumbBg: 'sigre-dash-product-thumb--3' },
    { nombre: 'Blue Shoes Pair', ventas: 859, precio: '$279', icono: 'shopping_bag', thumbBg: 'sigre-dash-product-thumb--4' },
    { nombre: 'Blue Yoga Mat', ventas: 328, precio: '$389', icono: 'fitness_center', thumbBg: 'sigre-dash-product-thumb--5' },
    { nombre: 'White water Bottle', ventas: 992, precio: '$856', icono: 'water_drop', thumbBg: 'sigre-dash-product-thumb--6' },
  ];

  ngOnInit(): void {
    this.layout.seleccionarModulo(null);
  }

  ngAfterViewInit(): void {
    setTimeout(() => this.renderCharts(), 0);
  }

  ngOnDestroy(): void {
    this.charts.forEach(c => c.destroy());
    this.charts = [];
  }

  private renderCharts(): void {
    const Apex = window.ApexCharts;
    if (!Apex) return;

    const defs: Array<[string, object]> = [
      ['#sigre-chart1', METOXI_CHART1_OPTIONS],
      ['#sigre-chart2', METOXI_CHART2_OPTIONS],
      ['#sigre-chart3', METOXI_CHART3_OPTIONS],
      ['#sigre-chart4', METOXI_CHART4_OPTIONS],
    ];

    for (const [selector, options] of defs) {
      const el = document.querySelector(selector);
      if (!el) continue;
      const chart = new Apex(el, options);
      void chart.render();
      this.charts.push(chart);
    }
  }
}
