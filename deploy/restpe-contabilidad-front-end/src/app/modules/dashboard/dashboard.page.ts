import { Component, OnInit, AfterViewInit, ViewChild, ElementRef } from '@angular/core';
import {
  Chart, ChartConfiguration, ChartType,
  BarController, BarElement,
  LineController, LineElement, PointElement,
  LinearScale, CategoryScale,
  Tooltip, Legend, Title, Filler
} from 'chart.js';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { CountryService } from 'src/app/ui/services/countryservice.service';

// Font Awesome Icons
import { faBank as faBankRegular, faFile, faFileInvoiceDollar, faShoppingCart } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faBank as faBankSolid, faCalculator, faDollar, faDollarSign, faDownload, faFileCheck, faList, faTriangleExclamation } from '@fortawesome/pro-solid-svg-icons';

// Font Awesome Icons

Chart.register(
  BarController, BarElement,
  LineController, LineElement, PointElement,
  LinearScale, CategoryScale,
  Tooltip, Legend, Title, Filler
);

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.page.html',
  styleUrls: ['./dashboard.page.scss'],
  standalone: false
})
export class DashboardPage implements OnInit, AfterViewInit {
  // Font Awesome Icons
  farBank = faBankRegular;
  farFile = faFile;
  farFileInvoiceDollar = faFileInvoiceDollar;
  farShoppingCart = faShoppingCart;
  fasAngleDown = faAngleDown;
  fasBank = faBankSolid;
  fasCalculator = faCalculator;
  fasDollar = faDollar;
  fasDollarSign = faDollarSign;
  fasDownload = faDownload;
  fasFileCheck = faFileCheck;
  fasList = faList;
  fasTriangleExclamation = faTriangleExclamation;


  ventasperiodo=  485.00;
  comprasperiodo=  1500.00;
  periodo = Math.abs(this.ventasperiodo - this.comprasperiodo);
  @ViewChild('infoPlanillaChart', { static: false }) infoPlanillaChart!: ElementRef<HTMLCanvasElement>;
  @ViewChild('cobrarPagarChart', { static: false }) cobrarPagarChart!: ElementRef<HTMLCanvasElement>;
  
  private ChartInfoPlanilla: Chart | undefined;
  private ChartCobrarPagar: Chart | undefined;

  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  sucursales = [
    { id: 0, nombre: 'Todas' },
    { id: 1, nombre: 'Sucursal Norte' },
    { id: 2, nombre: 'Sucursal Sur' },
    { id: 3, nombre: 'Sucursal Centro' },
    { id: 4, nombre: 'Sucursal Este' },
    { id: 5, nombre: 'Sucursal Oeste' },
  ];

  canales = [
    { id: 'salon', nombre: 'Salón' },
    { id: 'delivery', nombre: 'Delivery' },
  ];

  sucursalSeleccionada = this.sucursales[0].id;
  canalSeleccionado = this.canales[0].id;

  porcCompra=  4.8;
  porcVenta= - 3.3;

  pais = this.countryService.getCountryCode();
  monedapais: any ='S/';
  tipoImpuesto: any = 'IGV';
  countries= ALL_COUNTRIES

  constructor(
    private countryService: CountryService,
  ) { 
    const today = new Date();
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );
    this.maxDate = today;
  }

  ngOnInit() {
    this.filtrarPorPais()
  }
  filtrarPorPais(){
    this.countries.find(c => {
      if(c.codigo === this.pais){
        c.monedapais?.find(tip => {
          this.monedapais= tip.simbolo;
        })
      }
    })   
    const countryData = this.countries.find(c => c.codigo === this.pais);
    if(countryData){
      this.tipoImpuesto = countryData.tipoImpuesto;
    }
  }

  filtrarPorFechas(range: any) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos

  }

  ngAfterViewInit() {
    this.crearGraficoInfoPlanilla();
    this.crearGraficoCobrarPagar();
  }
  crearGraficoInfoPlanilla() {
    if (!this.infoPlanillaChart) return;

    const ctx = this.infoPlanillaChart.nativeElement.getContext('2d');
    if (!ctx) return;

    const meses = ['Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    const montoPlanilla = [50, 70, 100, 95, 120, 110, 120]; // Monto de planilla (línea azul)
    const estandarRegular = [80, 80, 80, 80, 80, 80, 80]; // Número de trabajadores (línea roja punteada)

    const config: ChartConfiguration = {
      type: 'line' as ChartType,
      data: {
        labels: meses,
        datasets: [
          {
            label: 'Monto de planilla',
            data: montoPlanilla,
            borderColor: '#3B82F6',
            backgroundColor: 'rgba(59, 130, 246, 0.05)',
            borderWidth: 2,
            tension: 0.4,
            fill: true,
            pointRadius: 3,
            pointBackgroundColor: '#3B82F6',
            pointBorderColor: '#fff',
            pointBorderWidth: 1,
            pointHoverRadius: 6,
            pointHoverBackgroundColor: '#3B82F6',
            pointHoverBorderColor: '#fff',
            pointHoverBorderWidth: 2,
            yAxisID: 'y',
          },
          {
            label: 'Número de trabajadores',
            data: estandarRegular,
            borderColor: '#EF4444',
            backgroundColor: 'transparent',
            borderWidth: 1.5,
            borderDash: [5, 5],
            tension: 0,
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 0,
            yAxisID: 'y',
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: {
          mode: 'index',
          intersect: false,
        },
        plugins: {
          legend: {
            display: true,
            position: 'bottom',
            labels: {
              usePointStyle: true,
              boxWidth: 6,
              boxHeight: 6,
              padding: 15,
              font: {
                size: 12,
              },
              generateLabels: (chart) => {
                const datasets = chart.data.datasets;
                return datasets.map((dataset, i) => ({
                  text: dataset.label || '',
                  fillStyle: dataset.borderColor as string,
                  strokeStyle: dataset.borderColor as string,
                  lineWidth: 0,
                  hidden: !chart.isDatasetVisible(i),
                  index: i,
                  pointStyle: 'circle' as const,
                }));
              }
            }
          },
          tooltip: {
            enabled: true,
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 12,
            titleFont: {
              size: 12
            },
            bodyFont: {
              size: 11
            },
            callbacks: {
              label: (context) => {
                let label = context.dataset.label || '';
                if (label) {
                  label += ': ';
                }
                if (context.parsed.y !== null) {
                  if (context.dataset.label === 'Monto de planilla') {
                    label += `${this.monedapais }` + context.parsed.y.toLocaleString('es-PE', {minimumFractionDigits: 2, maximumFractionDigits: 2});
                  } else {
                    label += context.parsed.y;
                  }
                }
                return label;
              }
            }
          }
        },
        scales: {
          y: {
            type: 'linear',
            position: 'left',
            beginAtZero: false,
            min: 40,
            max: 140,
            ticks: {
              stepSize: 20,
              callback: function(value) {
                return value;
              },
              font: {
                size: 11
              }
            },
            grid: {
              color: 'rgba(200, 200, 200, 0.1)',
            },
            border: {
              display: false
            }
          },
          x: {
            grid: {
              display: false,
            },
            ticks: {
              font: {
                size: 11
              }
            },
            border: {
              display: false
            }
          }
        }
      }
    };

    this.ChartInfoPlanilla = new Chart(ctx, config);
  }

  crearGraficoCobrarPagar() {
    if (!this.cobrarPagarChart) return;

    const ctx = this.cobrarPagarChart.nativeElement.getContext('2d');
    if (!ctx) return;

    const meses = ['Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    const cuentasPorCobrar = [2000, 2800, 3200, 2800, 2800, 4000];
    const cuentasPorPagar = [1500, 1400, 2600, 1800, 1500, 2800];

    const config: ChartConfiguration = {
      type: 'bar' as ChartType,
      data: {
        labels: meses,
        datasets: [
          {
            label: 'Cuentas por cobrar',
            data: cuentasPorCobrar,
            backgroundColor: '#3B82F6',
            borderRadius: 4,
            barThickness: 'flex',
            maxBarThickness: 40,
          },
          {
            label: 'Cuentas por pagar',
            data: cuentasPorPagar,
            backgroundColor: '#FCD34D',
            borderRadius: 4,
            barThickness: 'flex',
            maxBarThickness: 40,
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: {
          mode: 'index',
          intersect: false,
        },
        plugins: {
          legend: {
            display: true,
            position: 'bottom',
            labels: {
              usePointStyle: true,
              boxWidth: 8,
              boxHeight: 8,
              padding: 10,
              font: {
                size: 12,
              }
            }
          },
          tooltip: {
            enabled: true,
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 12,
            callbacks: {
              label: (context) => {
                let label = context.dataset.label || '';
                if (label) {
                  label += ': ';
                }
                if (context.parsed.y !== null) {
                  label += `${this.monedapais} ` + context.parsed.y.toLocaleString('es-PE', {minimumFractionDigits: 2, maximumFractionDigits: 2});
                }
                return label;
              }
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            min: 0,
            max: 5000,
            ticks: {
              stepSize: 500,
              callback: (value) => {
                return `${this.monedapais} ` + (Number(value)).toFixed(2);
              },
              font: {
                size: 11
              }
            },
            grid: {
              color: 'rgba(0, 0, 0, 0.05)',
            },
            border: {
              display: false
            }
          },
          x: {
            grid: {
              display: false,
            },
            ticks: {
              font: {
                size: 11
              }
            },
            border: {
              display: false
            }
          }
        }
      }
    };

    this.ChartCobrarPagar = new Chart(ctx, config);
  }

  ngOnDestroy() {
    if (this.ChartInfoPlanilla) {
      this.ChartInfoPlanilla.destroy();
    }
    if (this.ChartCobrarPagar) {
      this.ChartCobrarPagar.destroy();
    }
  }

}
