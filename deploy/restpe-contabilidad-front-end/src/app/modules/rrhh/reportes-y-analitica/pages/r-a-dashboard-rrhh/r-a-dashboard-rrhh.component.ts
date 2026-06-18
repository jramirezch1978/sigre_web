import { Component, OnInit, OnDestroy, ViewChild, ElementRef, AfterViewInit, inject } from '@angular/core';
import {
  Chart, ChartConfiguration, ChartType,
  BarController, BarElement,
  LineController, LineElement, PointElement,
  LinearScale, CategoryScale,
  Tooltip, Legend, Title, Filler
} from 'chart.js';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { DashboardRrhhEntity } from 'src/app/modules/rrhh/domain/models/dashboard-rrhh.entity';
import { SucursalEntity } from 'src/app/modules/rrhh/domain/models/sucursal.entity';

// Font Awesome Icons
import { faAngleDown, faCalendarXmark, faClock, faCoin, faDownload, faRotate, faUsers, faWarning } from '@fortawesome/pro-solid-svg-icons';



Chart.register(
  BarController, BarElement,
  LineController, LineElement, PointElement,
  LinearScale, CategoryScale,
  Tooltip, Legend, Title, Filler
);

@Component({
  selector: 'app-r-a-dashboard-rrhh',
  templateUrl: './r-a-dashboard-rrhh.component.html',
  styleUrls: ['./r-a-dashboard-rrhh.component.scss'],
  standalone: false,
})
export class RADashboardRrhhComponent  implements OnInit, AfterViewInit, OnDestroy {
  // Facade
  private readonly rrHhFacade = inject(RrHhFacade);
  readonly isLoading = this.rrHhFacade.loadingDashboardRrhh;
  dashboardData: DashboardRrhhEntity | null = null;
  // Font Awesome Icons
  fasAngleDown = faAngleDown;
  fasCalendarXmark = faCalendarXmark;
  fasClock = faClock;
  fasCoin = faCoin;
  fasDownload = faDownload;
  fasRotate = faRotate;
  fasUsers = faUsers;
  fasWarning = faWarning;



  @ViewChild('costoLaboralChart', { static: false }) costoLaboralChart!: ElementRef<HTMLCanvasElement>;
  @ViewChild('propinasChart', { static: false }) propinasChart!: ElementRef<HTMLCanvasElement>;
  @ViewChild('rotacionChart', { static: false }) rotacionChart!: ElementRef<HTMLCanvasElement>;
  @ViewChild('ausentismoChart', { static: false }) ausentismoChart!: ElementRef<HTMLCanvasElement>;
  @ViewChild('horasExtraChart', { static: false }) horasExtraChart!: ElementRef<HTMLCanvasElement>;
  
  private chartCostoLaboral: Chart | undefined;
  private chartPropinas: Chart | undefined;
  private chartRotacion: Chart | undefined;
  private chartAusentismo: Chart | undefined;
  private chartHorasExtra: Chart | undefined;
  private pollTimer?: ReturnType<typeof setInterval>;

  startDate: Date | undefined;
  endDate: Date | undefined;

  sucursales: SucursalEntity[] = [
    { id: 0, nombre: 'Todas las sucursales' },
    { id: 1, nombre: 'San Juan de Lurigancho, Lima' },
    { id: 2, nombre: 'Miraflores, Lima' },
    { id: 3, nombre: 'San Isidro, Lima' },
    { id: 4, nombre: 'Surco, Lima' },
    { id: 5, nombre: 'Callao' },
  ];

  canales: string[] = [
    'Salón',
    'Delivery',
    'Takeout',
    'Todos'
  ];

  constructor() { }

  ngOnInit() {
    // Establecer fechas iniciales (último mes)
    const today = new Date();
    this.endDate = today;
    this.startDate = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate());
    // Iniciar carga antes del renderizado para que el skeleton sea visible
    this.rrHhFacade.cargarDashboardRrhh();
  }

  ngAfterViewInit() {
    this.pollTimer = setInterval(() => {
      if (!this.isLoading()) {
        this.dashboardData = this.rrHhFacade.dashboardRrhh();
        if (this.dashboardData) {
          this.crearGraficoCostoLaboral();
          this.crearGraficoPropinas();
          this.crearGraficoRotacion();
          this.crearGraficoAusentismo();
          this.crearGraficoHorasExtra();
        }
        clearInterval(this.pollTimer);
        this.pollTimer = undefined;
      }
    }, 100);
  }

  crearGraficoCostoLaboral() {
    if (!this.costoLaboralChart) return;

    const ctx = this.costoLaboralChart.nativeElement.getContext('2d');
    if (!ctx) return;

    // Datos basados en la imagen proporcionada
    const meses = this.dashboardData?.dashboard_rrhh_grafico_costo_laboral.grafico_meses ?? ['Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    const porcentajes = this.dashboardData?.dashboard_rrhh_grafico_costo_laboral.grafico_valores ?? [];
    const montosMeta = new Array(meses.length).fill(this.dashboardData?.dashboard_rrhh_grafico_costo_laboral.grafico_meta ?? 25);

    const config: ChartConfiguration = {
      type: 'line' as ChartType,
      data: {
        labels: meses,
        datasets: [
          {
            label: 'Costo laboral mensual',
            data: porcentajes,
            borderColor: '#3B82F6',
            backgroundColor: 'rgba(59, 130, 246, 0.1)',
            borderWidth: 1,
            tension: 0.4,
            fill: false,
            pointRadius: 0,
            pointHoverRadius: 6,
            pointHoverBackgroundColor: '#3B82F6',
            pointHoverBorderColor: '#fff',
            pointHoverBorderWidth: 2,
            yAxisID: 'y',
          },
          {
            label: 'Meta (25%)',
            data: montosMeta,
            borderColor: '#EF4444',
            backgroundColor: 'transparent',
            borderWidth: 1,
            borderDash: [8, 4],
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
              boxWidth: 8,
              boxHeight: 8,
              padding: 10,
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
              size: 13
            },
            bodyFont: {
              size: 12
            },
            callbacks: {
              label: function(context) {
                let label = context.dataset.label || '';
                if (label) {
                  label += ': ';
                }
                if (context.parsed.y !== null) {
                  label += context.parsed.y.toFixed(1) + '%';
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
            min: 15,
            max: 40,
            ticks: {
              stepSize: 5,
              callback: function(value) {
                return value + '%';
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
          y1: {
            type: 'linear',
            position: 'right',
            beginAtZero: false,
            min: 0,
            max: 20000,
            ticks: {
              stepSize: 5000,
              callback: function(value) {
                return 'S/' + (Number(value) / 1000).toFixed(0) + ',000';
              },
              font: {
                size: 11
              }
            },
            grid: {
              drawOnChartArea: false,
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

    this.chartCostoLaboral = new Chart(ctx, config);
  }

  crearGraficoPropinas() {
    if (!this.propinasChart) return;

    const ctx = this.propinasChart.nativeElement.getContext('2d');
    if (!ctx) return;

    const meses = this.dashboardData?.dashboard_rrhh_grafico_propinas.grafico_meses ?? ['Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    const porcentajes = this.dashboardData?.dashboard_rrhh_grafico_propinas.grafico_valores ?? [];

    // Encontrar el índice del valor máximo
    const maxValue = porcentajes.length > 0 ? Math.max(...porcentajes) : 0;
    const maxIndex = porcentajes.indexOf(maxValue);

    // Colores: gris para todos excepto el de mayor porcentaje (azul)
    const coloresBarras = porcentajes.map((_, index) => 
      index === maxIndex ? '#3B82F6' : '#C5CFD6'
    );

    const config: ChartConfiguration = {
      type: 'bar' as ChartType,
      data: {
        labels: meses,
        datasets: [
          {
            label: 'Propinas',
            data: porcentajes,
            backgroundColor: coloresBarras,
            borderRadius: 4,
            borderSkipped: false,
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            enabled: true,
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 12,
            titleFont: {
              size: 13
            },
            bodyFont: {
              size: 12
            },
            callbacks: {
              label: function(context) {
                if (context.parsed.y !== null) {
                  return context.parsed.y.toFixed(1) + '%';
                }
                return '';
              }
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            max: 6,
            ticks: {
              stepSize: 1,
              callback: function(value) {
                return value + '%';
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

    this.chartPropinas = new Chart(ctx, config);
  }

  crearGraficoRotacion() {
    if (!this.rotacionChart) return;

    const ctx = this.rotacionChart.nativeElement.getContext('2d');
    if (!ctx) return;

    const meses = this.dashboardData?.dashboard_rrhh_grafico_rotacion.grafico_meses ?? ['Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    const porcentajes = this.dashboardData?.dashboard_rrhh_grafico_rotacion.grafico_valores ?? [];

    // Encontrar el índice del valor máximo
    const maxValue = porcentajes.length > 0 ? Math.max(...porcentajes) : 0;
    const maxIndex = porcentajes.indexOf(maxValue);

    // Colores: gris para todos excepto el de mayor porcentaje (azul)
    const coloresBarras = porcentajes.map((_, index) => 
      index === maxIndex ? '#3B82F6' : '#C5CFD6'
    );

    const config: ChartConfiguration = {
      type: 'bar' as ChartType,
      data: {
        labels: meses,
        datasets: [
          {
            label: 'Rotación',
            data: porcentajes,
            backgroundColor: coloresBarras,
            borderRadius: 4,
            borderSkipped: false,
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            enabled: true,
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 12,
            titleFont: {
              size: 13
            },
            bodyFont: {
              size: 12
            },
            callbacks: {
              label: function(context) {
                if (context.parsed.y !== null) {
                  return context.parsed.y.toFixed(1) + '%';
                }
                return '';
              }
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            max: 16,
            ticks: {
              stepSize: 2,
              callback: function(value) {
                return value + '%';
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

    this.chartRotacion = new Chart(ctx, config);
  }

  crearGraficoAusentismo() {
    if (!this.ausentismoChart) return;

    const ctx = this.ausentismoChart.nativeElement.getContext('2d');
    if (!ctx) return;

    const meses = this.dashboardData?.dashboard_rrhh_grafico_ausentismo.grafico_meses ?? ['Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    const porcentajes = this.dashboardData?.dashboard_rrhh_grafico_ausentismo.grafico_valores ?? [];

    // Encontrar el índice del valor máximo
    const maxValue = porcentajes.length > 0 ? Math.max(...porcentajes) : 0;
    const maxIndex = porcentajes.indexOf(maxValue);

    // Colores: gris para todos excepto el de mayor porcentaje (azul)
    const coloresBarras = porcentajes.map((_, index) => 
      index === maxIndex ? '#3B82F6' : '#C5CFD6'
    );

    const config: ChartConfiguration = {
      type: 'bar' as ChartType,
      data: {
        labels: meses,
        datasets: [
          {
            label: 'Ausentismo',
            data: porcentajes,
            backgroundColor: coloresBarras,
            borderRadius: 4,
            borderSkipped: false,
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            enabled: true,
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 12,
            titleFont: {
              size: 13
            },
            bodyFont: {
              size: 12
            },
            callbacks: {
              label: function(context) {
                if (context.parsed.y !== null) {
                  return context.parsed.y.toFixed(1) + '%';
                }
                return '';
              }
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            max: 16,
            ticks: {
              stepSize: 2,
              callback: function(value) {
                return value + '%';
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

    this.chartAusentismo = new Chart(ctx, config);
  }

  crearGraficoHorasExtra() {
    if (!this.horasExtraChart) return;

    const ctx = this.horasExtraChart.nativeElement.getContext('2d');
    if (!ctx) return;

    const meses = this.dashboardData?.dashboard_rrhh_grafico_horas_extra.grafico_meses ?? ['Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    const horas = this.dashboardData?.dashboard_rrhh_grafico_horas_extra.grafico_valores ?? [];

    // Encontrar el índice del valor máximo
    const maxValue = horas.length > 0 ? Math.max(...horas) : 0;
    const maxIndex = horas.indexOf(maxValue);

    // Colores: gris para todos excepto el de mayor valor (azul)
    const coloresBarras = horas.map((_, index) => 
      index === maxIndex ? '#3B82F6' : '#C5CFD6'
    );

    const config: ChartConfiguration = {
      type: 'bar' as ChartType,
      data: {
        labels: meses,
        datasets: [
          {
            label: 'Horas extra',
            data: horas,
            backgroundColor: coloresBarras,
            borderRadius: 4,
            borderSkipped: false,
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            enabled: true,
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 12,
            titleFont: {
              size: 13
            },
            bodyFont: {
              size: 12
            },
            callbacks: {
              label: function(context) {
                if (context.parsed.y !== null) {
                  return context.parsed.y + ' hrs';
                }
                return '';
              }
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            max: 350,
            ticks: {
              stepSize: 90,
              callback: function(value) {
                return value + 'hrs';
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

    this.chartHorasExtra = new Chart(ctx, config);
  }

  ngOnDestroy() {
    if (this.pollTimer) {
      clearInterval(this.pollTimer);
      this.pollTimer = undefined;
    }
    if (this.chartCostoLaboral) {
      this.chartCostoLaboral.destroy();
    }
    if (this.chartPropinas) {
      this.chartPropinas.destroy();
    }
    if (this.chartRotacion) {
      this.chartRotacion.destroy();
    }
    if (this.chartAusentismo) {
      this.chartAusentismo.destroy();
    }
    if (this.chartHorasExtra) {
      this.chartHorasExtra.destroy();
    }
  }

  onCanalChange(event: any) {
    console.log('Canal seleccionado:', event.detail.value);
    // Aquí puedes llamar al servicio para filtrar los datos
  }

  onFechasSeleccionadas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    console.log('Rango de fechas:', range);
    // Aquí puedes llamar al servicio para filtrar los datos
  }

}
