import { Component, OnInit, OnDestroy, ViewChild, ElementRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatTableModule } from '@angular/material/table';
import { MatTabsModule } from '@angular/material/tabs';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSnackBarModule, MatSnackBar } from '@angular/material/snack-bar';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatMenuModule } from '@angular/material/menu';
import { MatDividerModule } from '@angular/material/divider';
import { HttpClientModule } from '@angular/common/http';
import { Subscription, interval } from 'rxjs';

import { 
  DashboardService, 
  DashboardResponse, 
  EstadisticasGenerales, 
  MarcajesPorHora, 
  MarcajeDelDia, 
  ResumenCentroCosto 
} from '../../services/dashboard.service';
import { FloatingClockComponent } from '../floating-clock/floating-clock.component';

declare var Chart: any; // Para Chart.js

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [
    CommonModule,
    HttpClientModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule,
    MatTableModule,
    MatTabsModule,
    MatProgressSpinnerModule,
    MatSnackBarModule,
    MatToolbarModule,
    MatMenuModule,
    MatDividerModule,
    FloatingClockComponent
  ],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit, OnDestroy {

  @ViewChild('chartMarcajesHora', { static: false }) chartMarcajesHora!: ElementRef;
  @ViewChild('chartMarcajes24h', { static: false }) chartMarcajes24h!: ElementRef;

  // Datos del dashboard
  estadisticasGenerales: EstadisticasGenerales | null = null;
  marcajesDelDia: MarcajesPorHora | null = null;
  marcajes24Horas: MarcajesPorHora | null = null;
  listadoMarcajes: MarcajeDelDia[] = [];
  resumenCentrosCosto: ResumenCentroCosto[] = [];
  racionesPorTipo: any = null; // Datos reales de raciones
  trabajadoresUnicosHoy: number = 0; // Total real de trabajadores únicos

  // Estados de UI
  cargandoDatos = true;
  error: string | null = null;
  ultimaActualizacion: Date = new Date();

  // Ya no necesitamos configuraciones de columnas porque están hardcodeadas en el HTML

  // Charts
  private chartInstances: { [key: string]: any } = {};
  private subscriptions: Subscription = new Subscription();

  constructor(
    private dashboardService: DashboardService,
    private router: Router,
    private snackBar: MatSnackBar
  ) {}

  async ngOnInit() {
    console.log('🚀 Iniciando Dashboard Component');
    
    try {
      // Cargar Chart.js dinámicamente
      console.log('📈 Cargando Chart.js...');
      await this.cargarChartJS();
      console.log('✅ Chart.js cargado');
      
      // Suscribirse a cambios en los datos ANTES de cargar
      this.subscriptions.add(
        this.dashboardService.dashboardData$.subscribe(data => {
          console.log('📊 Datos recibidos en componente:', data);
          if (data) {
            this.procesarDatosDashboard(data);
          }
        })
      );
      
      // Cargar datos iniciales
      console.log('🔄 Cargando datos iniciales del dashboard...');
      
      // Intentar cargar datos reales, si falla mostrar datos de prueba
      try {
        await this.cargarDashboard();
        await this.cargarDatosAdicionales(); // Cargar raciones y trabajadores únicos
      } catch (error) {
        console.log('🔧 Backend no disponible, generando datos de prueba...');
        this.generarDatosPrueba();
      }
      
      // Configurar actualización automática cada 30 segundos
      this.configurarActualizacionAutomatica();
      
    } catch (error) {
      console.error('❌ Error durante la inicialización:', error);
      this.error = 'Error durante la inicialización del dashboard';
      this.cargandoDatos = false;
    }
  }

  ngOnDestroy() {
    // Limpiar suscripciones
    this.subscriptions.unsubscribe();
    
    // Destruir gráficos
    Object.values(this.chartInstances).forEach(chart => {
      if (chart) {
        chart.destroy();
      }
    });
  }

  async cargarDashboard() {
    this.cargandoDatos = true;
    this.error = null;

    try {
      console.log('📊 Iniciando carga del dashboard...');
      
      // Esperar a que se cargue la configuración
      await this.dashboardService['configService'].waitForConfig();
      console.log('✅ Configuración cargada');
      
      await this.dashboardService.actualizarDashboard();
      this.ultimaActualizacion = new Date();
      console.log('✅ Dashboard cargado exitosamente');
      this.mostrarMensaje('Dashboard actualizado correctamente');
    } catch (error: any) {
      console.error('❌ Error cargando dashboard:', error);
      
      let mensajeError = 'Error al cargar los datos del dashboard';
      if (error?.status) {
        switch (error.status) {
          case 0:
            mensajeError = 'Sin conexión al servidor. Verifique la conexión de red.';
            break;
          case 404:
            mensajeError = 'Endpoint del dashboard no encontrado en el servidor.';
            break;
          case 500:
            mensajeError = 'Error interno del servidor. Contacte al administrador.';
            break;
          default:
            mensajeError = `Error del servidor (${error.status}): ${error.message || 'Error desconocido'}`;
        }
      }
      
      this.error = mensajeError;
      this.mostrarError(mensajeError);
      
      // Si hay error de conectividad, mostrar datos de prueba
      if (error?.status === 0 || error?.status === 404) {
        console.log('🔧 Backend no disponible, mostrando datos de prueba...');
        setTimeout(() => {
          this.generarDatosPrueba();
          this.error = null; // Limpiar el error ya que mostramos datos de prueba
        }, 1000);
      }
    } finally {
      this.cargandoDatos = false;
    }
  }

  /**
   * Cargar datos adicionales (raciones y trabajadores únicos)
   */
  async cargarDatosAdicionales() {
    try {
      console.log('📊 Cargando datos adicionales...');
      
      // Cargar raciones por tipo
      const raciones = await this.dashboardService.obtenerRacionesPorTipo().toPromise();
      this.racionesPorTipo = raciones;
      console.log('🍽️ Raciones por tipo:', raciones);
      
      // Cargar trabajadores únicos
      const trabajadores = await this.dashboardService.obtenerTrabajadoresUnicosHoy().toPromise();
      this.trabajadoresUnicosHoy = trabajadores || 0;
      console.log('👥 Trabajadores únicos hoy:', trabajadores);
      
    } catch (error) {
      console.warn('⚠️ Error cargando datos adicionales:', error);
      // No generar error, usar datos de prueba para estos campos
      this.racionesPorTipo = { desayunos: 45, almuerzos: 178, cenas: 203, totalRaciones: 426, fecha: new Date().toISOString().split('T')[0] };
      this.trabajadoresUnicosHoy = 89;
    }
  }

  private procesarDatosDashboard(data: DashboardResponse) {
    console.log('📊 Procesando datos del dashboard:', data);
    
    this.estadisticasGenerales = data.estadisticasGenerales;
    this.marcajesDelDia = data.marcajesDelDia;
    this.marcajes24Horas = data.marcajesUltimas24Horas;
    this.listadoMarcajes = data.listadoMarcajesHoy || [];
    this.resumenCentrosCosto = data.resumenPorCentroCosto || [];

    console.log('📊 Estadísticas generales:', this.estadisticasGenerales);
    console.log('📊 Marcajes del día:', this.marcajesDelDia);
    console.log('📊 Listado marcajes:', this.listadoMarcajes.length);
    console.log('📊 Resumen centros:', this.resumenCentrosCosto.length);

    // Actualizar gráficos
    setTimeout(() => {
      this.actualizarGraficos();
    }, 100);
  }

  // Método temporal para generar datos de prueba
  public generarDatosPrueba() {
    console.log('🔧 Generando datos de prueba para el dashboard...');
    
    const datosPrueba: DashboardResponse = {
      estadisticasGenerales: {
        totalRegistrosHoy: 247,
        totalRegistrosDbLocal: 15,
        totalRegistrosDbRemoto: 232,
        ticketsPendientes: 3,
        ticketsProcessed: 244,
        ticketsError: 0,
        ultimaActualizacion: new Date().toISOString(),
        estadoSincronizacion: 'SINCRONIZADO'
      },
      marcajesDelDia: {
        // CORREGIDO: Mismo formato que 24h - Últimas 24 horas con horas negativas para ayer
        horas: [-12,-13,-14,-15,-16,-17,-18,-19,-20,-21,-22,-23,0,1,2,3,4,5,6,7,8,9,10,11,12],
        cantidadPorHora: [8,5,2,12,18,22,28,15,6,3,1,0,0,0,0,0,0,0,25,45,35,20,18,12,8], // SIN acumular
        cantidadAcumulada: [8,5,2,12,18,22,28,15,6,3,1,0,0,0,0,0,0,0,25,45,35,20,18,12,8], // Igual que cantidadPorHora
        totalMarcajes: 283,
        fecha: "24h-hasta-" + new Date().toISOString().split('T')[0]
      },
      marcajesUltimas24Horas: {
        // CORREGIDO: Horas negativas para ayer, positivas para hoy
        // Ejemplo si son las 12:00 de hoy: [-12,-13,-14,...,-23,0,1,2,...,12]
        horas: [-12,-13,-14,-15,-16,-17,-18,-19,-20,-21,-22,-23,0,1,2,3,4,5,6,7,8,9,10,11,12],
        cantidadPorHora: [5,3,2,8,12,15,25,18,8,2,1,0,0,0,0,0,0,0,28,48,35,25,40,22,15],
        cantidadAcumulada: [5,8,10,18,30,45,70,88,96,98,99,99,99,99,99,99,99,99,127,175,210,235,275,297,312],
        totalMarcajes: 312,
        fecha: new Date().toISOString().split('T')[0]
      },
      listadoMarcajesHoy: [
        {
          reckey: 'TEST001',
          codigoTrabajador: 'PR001234',
          nombreTrabajador: 'Juan Pérez García',
          tipoMarcaje: '1',
          tipoMovimiento: '1',
          descripcionMovimiento: 'INGRESO',
          fechaMovimiento: new Date().toISOString(),
          centroCosto: 'PR',
          turno: '001',
          direccionIp: '192.168.1.100',
          estadoSincronizacion: 'SINCRONIZADO'
        },
        {
          reckey: 'TEST002', 
          codigoTrabajador: 'AD005678',
          nombreTrabajador: 'María López Silva',
          tipoMarcaje: '1',
          tipoMovimiento: '2', 
          descripcionMovimiento: 'SALIDA',
          fechaMovimiento: new Date(Date.now() - 300000).toISOString(),
          centroCosto: 'AD',
          turno: '002',
          direccionIp: '192.168.1.101',
          estadoSincronizacion: 'PENDIENTE'
        }
      ],
      resumenPorCentroCosto: [
        { centroCosto: 'PR', descripcionCentroCosto: 'PRODUCCIÓN', cantidadMarcajes: 125, cantidadTrabajadores: 85 },
        { centroCosto: 'AD', descripcionCentroCosto: 'ADMINISTRACIÓN', cantidadMarcajes: 45, cantidadTrabajadores: 25 },
        { centroCosto: 'MA', descripcionCentroCosto: 'MANTENIMIENTO', cantidadMarcajes: 35, cantidadTrabajadores: 18 },
        { centroCosto: 'SE', descripcionCentroCosto: 'SEGURIDAD', cantidadMarcajes: 28, cantidadTrabajadores: 12 }
      ]
    };

    this.procesarDatosDashboard(datosPrueba);
    
    // Datos adicionales de prueba
    this.racionesPorTipo = { 
      desayunos: 45, 
      almuerzos: 178, 
      cenas: 203, 
      totalRaciones: 426, 
      fecha: new Date().toISOString().split('T')[0] 
    };
    this.trabajadoresUnicosHoy = 89;
    
    this.mostrarMensaje('Mostrando datos de prueba - Backend no disponible');
  }

  private configurarActualizacionAutomatica() {
    // Actualizar cada 30 segundos
    this.subscriptions.add(
      interval(30000).subscribe(async () => {
        try {
          await this.cargarDashboard();
          await this.cargarDatosAdicionales();
        } catch (error) {
          console.warn('⚠️ Error en actualización automática:', error);
        }
      })
    );
  }

  private async cargarChartJS() {
    return new Promise((resolve, reject) => {
      if (typeof Chart !== 'undefined') {
        console.log('✅ Chart.js ya está cargado');
        resolve(Chart);
        return;
      }

      console.log('📦 Cargando Chart.js desde CDN...');
      const script = document.createElement('script');
      script.src = 'https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.js';  // Versión específica
      script.onload = () => {
        console.log('✅ Chart.js cargado exitosamente');
        resolve(Chart);
      };
      script.onerror = (error) => {
        console.error('❌ Error cargando Chart.js:', error);
        reject(error);
      };
      document.head.appendChild(script);
    });
  }

  private actualizarGraficos() {
    if (!this.marcajesDelDia || !this.marcajes24Horas) return;

    this.crearGraficoMarcajesHora();
    this.crearGraficoMarcajes24h();
  }

  private crearGraficoMarcajesHora() {
    if (!this.chartMarcajesHora?.nativeElement || !this.marcajesDelDia) return;

    const ctx = this.chartMarcajesHora.nativeElement.getContext('2d');
    
    if (this.chartInstances['marcajesHora']) {
      this.chartInstances['marcajesHora'].destroy();
    }

    // MISMAS ETIQUETAS que el gráfico de 24h - distinguir ayer vs hoy
    const etiquetas = this.marcajesDelDia.horas.map(h => {
      if (h < 0) {
        // Hora negativa = día anterior
        const horaReal = Math.abs(h);
        return `${horaReal.toString().padStart(2, '0')}:00 ayer`;
      } else {
        // Hora positiva = día actual
        return `${h.toString().padStart(2, '0')}:00 hoy`;
      }
    });

    // Configuración idéntica a Gentelella - GRÁFICO DE CANTIDAD POR HORA (no acumulado)
    this.chartInstances['marcajesHora'] = new Chart(ctx, {
      type: 'line',
      data: {
        labels: etiquetas,
        datasets: [{
          label: 'Marcajes por Hora',
          data: this.marcajesDelDia.cantidadPorHora, // CANTIDAD por hora (no acumulado)
          borderColor: '#1ABB9C',  // Verde teal de Gentelella
          backgroundColor: 'rgba(26, 187, 156, 0.1)',
          borderWidth: 2,
          fill: true,
          tension: 0.4
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'top',
          },
          title: {
            display: true,
            text: 'Tráfico de Marcajes por Hora - Últimas 24 Horas'
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            grid: {
              color: 'rgba(0,0,0,0.1)'
            }
          },
          x: {
            grid: {
              color: 'rgba(0,0,0,0.1)'
            },
            ticks: {
              maxRotation: 45,
              minRotation: 0
            }
          }
        }
      }
    });
  }

  private crearGraficoMarcajes24h() {
    if (!this.chartMarcajes24h?.nativeElement || !this.marcajes24Horas) return;

    const ctx = this.chartMarcajes24h.nativeElement.getContext('2d');
    
    if (this.chartInstances['marcajes24h']) {
      this.chartInstances['marcajes24h'].destroy();
    }

    // Generar etiquetas correctas para horas con fecha (distinguir ayer vs hoy)
    const etiquetas = this.marcajes24Horas.horas.map(h => {
      if (h < 0) {
        // Hora negativa = día anterior
        const horaReal = Math.abs(h);
        return `${horaReal.toString().padStart(2, '0')}:00 ayer`;
      } else {
        // Hora positiva = día actual
        return `${h.toString().padStart(2, '0')}:00 hoy`;
      }
    });

    // Configuración dual idéntica a Gentelella (con 2 datasets como el ejemplo)
    this.chartInstances['marcajes24h'] = new Chart(ctx, {
      type: 'line',
      data: {
        labels: etiquetas,
        datasets: [{
          label: 'Marcajes 24h',
          data: this.marcajes24Horas.cantidadPorHora,
          borderColor: '#1ABB9C',  // Verde teal de Gentelella
          backgroundColor: 'rgba(26, 187, 156, 0.1)',
          borderWidth: 2,
          fill: true,
          tension: 0.4
        }, {
          label: 'Acumulados',
          data: this.marcajes24Horas.cantidadAcumulada,
          borderColor: '#E74C3C',  // Rojo de Gentelella
          backgroundColor: 'rgba(231, 76, 60, 0.1)',
          borderWidth: 2,
          fill: true,
          tension: 0.4
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'top',
          },
          title: {
            display: true,
            text: 'Tendencia de Marcajes - Últimas 24 Horas (Corregido)'
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            grid: {
              color: 'rgba(0,0,0,0.1)'
            }
          },
          x: {
            grid: {
              color: 'rgba(0,0,0,0.1)'
            },
            ticks: {
              maxRotation: 45,
              minRotation: 0
            }
          }
        }
      }
    });
  }

  obtenerColorEstado(estado: string): string {
    const colores = {
      'SINCRONIZADO': 'success',
      'PENDIENTE': 'warn',
      'PARCIAL': 'accent'
    };
    return colores[estado as keyof typeof colores] || 'basic';
  }

  obtenerColorSincronizacion(estado: string): string {
    return estado === 'SINCRONIZADO' ? 'success' : 'warn';
  }

  formatearFecha(fecha: string): string {
    return new Date(fecha).toLocaleString('es-PE', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }

  formatearHora(fecha: string): string {
    return new Date(fecha).toLocaleString('es-PE', {
      hour: '2-digit',
      minute: '2-digit'
    });
  }

  formatNumber(value: number): string {
    if (value >= 1000000) {
      return (value / 1000000).toFixed(1) + 'M';
    } else if (value >= 1000) {
      return (value / 1000).toFixed(1) + 'K';
    }
    return value.toString();
  }

  getTotalMarcajes(): number {
    return this.resumenCentrosCosto.reduce((total, centro) => total + centro.cantidadMarcajes, 0);
  }

  // Método temporal para probar conectividad
  public async probarConectividad() {
    console.log('🔧 Probando conectividad del dashboard...');
    try {
      const healthResponse = await this.dashboardService.healthCheck().toPromise();
      console.log('✅ Health check exitoso:', healthResponse);
      this.mostrarMensaje('Conectividad OK - ' + healthResponse);
    } catch (error) {
      console.error('❌ Health check falló:', error);
      this.mostrarError('No se puede conectar al servidor del dashboard');
      
      // Mostrar datos de prueba si no hay conectividad
      this.generarDatosPrueba();
    }
  }

  volverMenuPrincipal() {
    this.router.navigate(['/']);
  }

  private mostrarError(mensaje: string) {
    this.snackBar.open(mensaje, 'Cerrar', {
      duration: 5000,
      panelClass: ['error-snackbar']
    });
  }

  private mostrarMensaje(mensaje: string) {
    this.snackBar.open(mensaje, 'OK', {
      duration: 3000,
      panelClass: ['success-snackbar']
    });
  }
}
