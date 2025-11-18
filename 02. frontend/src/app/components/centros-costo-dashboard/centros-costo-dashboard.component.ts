import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatTableModule } from '@angular/material/table';
import { MatTabsModule } from '@angular/material/tabs';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSnackBarModule, MatSnackBar } from '@angular/material/snack-bar';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatNativeDateModule, MAT_DATE_LOCALE, MAT_DATE_FORMATS, NativeDateAdapter, DateAdapter } from '@angular/material/core';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { Subscription } from 'rxjs';

import {
  DashboardService,
  IndicadorCentroCosto,
  IndicadorArea,
  IndicadorSeccion
} from '../../services/dashboard.service';

// Adaptador personalizado para formato dd/MM/yyyy
export class CustomDateAdapter extends NativeDateAdapter {
  override parse(value: any): Date | null {
    if (typeof value === 'string') {
      const parts = value.split('/');
      if (parts.length === 3) {
        const day = parseInt(parts[0], 10);
        const month = parseInt(parts[1], 10) - 1;
        const year = parseInt(parts[2], 10);
        return new Date(year, month, day);
      }
    }
    return super.parse(value);
  }

  override format(date: Date, displayFormat: Object): string {
    if (displayFormat === 'input') {
      const day = date.getDate().toString().padStart(2, '0');
      const month = (date.getMonth() + 1).toString().padStart(2, '0');
      const year = date.getFullYear();
      return `${day}/${month}/${year}`;
    }
    return super.format(date, displayFormat);
  }
}

// Formato de fecha personalizado para dd/MM/yyyy
export const MY_DATE_FORMATS = {
  parse: {
    dateInput: 'input',
  },
  display: {
    dateInput: 'input',
    monthYearLabel: { year: 'numeric', month: 'short' },
    dateA11yLabel: { year: 'numeric', month: 'long', day: 'numeric' },
    monthYearA11yLabel: { year: 'numeric', month: 'long' },
  },
};

@Component({
  selector: 'app-centros-costo-dashboard',
  standalone: true,
  imports: [
    CommonModule,
    HttpClientModule,
    FormsModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule,
    MatTableModule,
    MatTabsModule,
    MatProgressSpinnerModule,
    MatSnackBarModule,
    MatToolbarModule,
    MatDatepickerModule,
    MatFormFieldModule,
    MatInputModule,
    MatNativeDateModule
  ],
  providers: [
    { provide: MAT_DATE_LOCALE, useValue: 'es-PE' },
    { provide: DateAdapter, useClass: CustomDateAdapter },
    { provide: MAT_DATE_FORMATS, useValue: MY_DATE_FORMATS }
  ],
  templateUrl: './centros-costo-dashboard.component.html',
  styleUrls: ['./centros-costo-dashboard.component.scss']
})
export class CentrosCostoDashboardComponent implements OnInit, OnDestroy {

  // Datos
  indicadoresCentrosCosto: IndicadorCentroCosto[] = [];
  indicadoresAreas: IndicadorArea[] = [];
  indicadoresSecciones: IndicadorSeccion[] = [];

  // Estados de UI
  cargandoCentrosCosto = false;
  cargandoAreas = false;
  cargandoSecciones = false;
  error: string | null = null;

  // Filtros de fecha
  fechaSeleccionada: Date = new Date();

  // Columnas para las tablas
  columnasCentrosCosto = [
    'tipoTrabajador', 'descTipoTrabajador', 'codArea', 'descArea',
    'codSeccion', 'descSeccion', 'descCentroCosto',
    'ingresoPlanta', 'salidaPlanta', 'salidaAlmorzar', 'regresoAlmorzar',
    'salidaComision', 'retornoComision', 'ingresoProduccion', 'salidaProduccion',
    'salidaCenar', 'regresoCenar', 'total'
  ];

  columnasAreas = [
    'tipoTrabajador', 'descTipoTrabajador', 'codArea', 'descArea', 'descCentroCosto',
    'ingresoPlanta', 'salidaPlanta', 'salidaAlmorzar', 'regresoAlmorzar',
    'salidaComision', 'retornoComision', 'ingresoProduccion', 'salidaProduccion',
    'salidaCenar', 'regresoCenar', 'total'
  ];

  columnasSecciones = [
    'tipoTrabajador', 'descTipoTrabajador', 'codArea', 'descArea',
    'codSeccion', 'descSeccion', 'descCentroCosto',
    'ingresoPlanta', 'salidaPlanta', 'salidaAlmorzar', 'regresoAlmorzar',
    'salidaComision', 'retornoComision', 'ingresoProduccion', 'salidaProduccion',
    'salidaCenar', 'regresoCenar', 'total'
  ];

  private subscriptions: Subscription = new Subscription();

  constructor(
    private dashboardService: DashboardService,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit() {
    console.log('🚀 Iniciando CentrosCostoDashboard Component');
    this.cargarDatos();
  }

  ngOnDestroy() {
    this.subscriptions.unsubscribe();
  }

  cargarDatos() {
    this.cargarIndicadoresCentrosCosto();
    this.cargarIndicadoresAreas();
    this.cargarIndicadoresSecciones();
  }

  cargarIndicadoresCentrosCosto() {
    this.cargandoCentrosCosto = true;
    this.error = null;

    const fechaString = this.fechaSeleccionada.toISOString().split('T')[0];

    this.subscriptions.add(
      this.dashboardService.obtenerIndicadoresCentrosCosto(fechaString).subscribe({
        next: (data) => {
          this.indicadoresCentrosCosto = data;
          this.cargandoCentrosCosto = false;
          console.log('✅ Indicadores centros de costo cargados:', data.length);
        },
        error: (error) => {
          console.error('❌ Error cargando indicadores centros de costo:', error);
          this.error = 'Error al cargar indicadores de centros de costo';
          this.cargandoCentrosCosto = false;
          this.mostrarError('Error al cargar indicadores de centros de costo');
        }
      })
    );
  }

  cargarIndicadoresAreas() {
    this.cargandoAreas = true;

    const fechaString = this.fechaSeleccionada.toISOString().split('T')[0];

    this.subscriptions.add(
      this.dashboardService.obtenerIndicadoresAreas(fechaString).subscribe({
        next: (data) => {
          this.indicadoresAreas = data;
          this.cargandoAreas = false;
          console.log('✅ Indicadores áreas cargados:', data.length);
        },
        error: (error) => {
          console.error('❌ Error cargando indicadores áreas:', error);
          this.cargandoAreas = false;
          this.mostrarError('Error al cargar indicadores de áreas');
        }
      })
    );
  }

  cargarIndicadoresSecciones() {
    this.cargandoSecciones = true;

    const fechaString = this.fechaSeleccionada.toISOString().split('T')[0];

    this.subscriptions.add(
      this.dashboardService.obtenerIndicadoresSecciones(fechaString).subscribe({
        next: (data) => {
          this.indicadoresSecciones = data;
          this.cargandoSecciones = false;
          console.log('✅ Indicadores secciones cargados:', data.length);
        },
        error: (error) => {
          console.error('❌ Error cargando indicadores secciones:', error);
          this.cargandoSecciones = false;
          this.mostrarError('Error al cargar indicadores de secciones');
        }
      })
    );
  }

  onFechaChange() {
    console.log('📅 Fecha cambiada:', this.fechaSeleccionada);
    this.cargarDatos();
  }

  onRefresh() {
    this.cargarDatos();
  }

  // Método helper para obtener descripción del movimiento
  getDescripcionMovimiento(tipo: string): string {
    const descripciones: { [key: string]: string } = {
      'ingresoPlanta': 'INGRESO A PLANTA',
      'salidaPlanta': 'SALIDA DE PLANTA',
      'salidaAlmorzar': 'SALIDA A ALMORZAR',
      'regresoAlmorzar': 'REGRESO DE ALMORZAR',
      'salidaComision': 'SALIDA DE COMISIÓN',
      'retornoComision': 'RETORNO DE COMISIÓN',
      'ingresoProduccion': 'INGRESO A PRODUCCIÓN',
      'salidaProduccion': 'SALIDA DE PRODUCCIÓN',
      'salidaCenar': 'SALIDA A CENAR',
      'regresoCenar': 'REGRESO DE CENAR'
    };
    return descripciones[tipo] || tipo;
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
