import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatTableModule } from '@angular/material/table';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSnackBarModule, MatSnackBar } from '@angular/material/snack-bar';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatNativeDateModule, MAT_DATE_LOCALE, MAT_DATE_FORMATS, NativeDateAdapter, DateAdapter } from '@angular/material/core';
import { MatMenuModule } from '@angular/material/menu';
import { MatDividerModule } from '@angular/material/divider';
import { HttpClientModule } from '@angular/common/http';
import { DashboardService, Origen } from '../../services/dashboard.service';
import { MainLayoutComponent } from '../main-layout/main-layout.component';
import * as XLSX from 'xlsx';

export class CustomDateAdapter extends NativeDateAdapter {
  override parse(value: any): Date | null {
    if (typeof value === 'string') {
      const parts = value.split('/');
      if (parts.length === 3) {
        return new Date(parseInt(parts[2], 10), parseInt(parts[1], 10) - 1, parseInt(parts[0], 10));
      }
    }
    return super.parse(value);
  }

  override format(date: Date, displayFormat: Object): string {
    if (displayFormat === 'input') {
      return `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getFullYear()}`;
    }
    return super.format(date, displayFormat);
  }
}

export const MY_DATE_FORMATS = {
  parse: { dateInput: 'input' },
  display: {
    dateInput: 'input',
    monthYearLabel: { year: 'numeric', month: 'short' },
    dateA11yLabel: { year: 'numeric', month: 'long', day: 'numeric' },
    monthYearA11yLabel: { year: 'numeric', month: 'long' },
  },
};

export interface ReporteProduccion {
  nro: number;
  codigoTrabajador: string;
  dni: string;
  nombres: string;
  apellidos: string;
  tipoTrabajador: string;
  horaIngresoPlanta: string;
  horaIngresoProduccion: string;
  minutosCambioRopa: number;
  horaSalidaProduccion: string;
  horaSalidaPlanta: string;
  horasEfectivasProduccion: number;
  horasTotalPlanta: number;
  horasMuertas: number;
  fecha: string;
}

@Component({
  selector: 'app-reporte-produccion',
  standalone: true,
  imports: [
    CommonModule, RouterModule, HttpClientModule, FormsModule,
    MatCardModule, MatButtonModule, MatIconModule, MatTableModule,
    MatProgressSpinnerModule, MatSnackBarModule, MatToolbarModule,
    MatDatepickerModule, MatFormFieldModule, MatInputModule,
    MatSelectModule, MatNativeDateModule, MatMenuModule, MatDividerModule,
    MainLayoutComponent
  ],
  providers: [
    { provide: MAT_DATE_LOCALE, useValue: 'es-PE' },
    { provide: DateAdapter, useClass: CustomDateAdapter },
    { provide: MAT_DATE_FORMATS, useValue: MY_DATE_FORMATS }
  ],
  templateUrl: './reporte-produccion.component.html',
  styleUrls: ['./reporte-produccion.component.scss']
})
export class ReporteProduccionComponent implements OnInit, OnDestroy {

  registros: ReporteProduccion[] = [];
  registrosFiltrados: ReporteProduccion[] = [];

  codOrigen: string = 'SE';
  fechaInicio: Date = new Date();
  fechaFin: Date = new Date();
  busquedaNombre: string = '';
  tipoTrabajadorFiltro: string = 'TODOS';

  origenes: Origen[] = [];
  tiposTrabajador: string[] = [];

  columnaOrdenada: string = '';
  ordenAscendente: boolean = true;

  cargando: boolean = false;
  error: string | null = null;

  constructor(
    private dashboardService: DashboardService,
    private router: Router,
    private snackBar: MatSnackBar
  ) {
    const hoy = new Date();
    this.fechaInicio = new Date(hoy.getFullYear(), hoy.getMonth(), 1);
    this.fechaFin = hoy;
  }

  ngOnInit(): void {
    this.cargarOrigenes();
    this.cargarReporte();
  }

  ngOnDestroy(): void {}

  cargarOrigenes(): void {
    this.dashboardService.obtenerOrigenes().subscribe({
      next: (data) => {
        this.origenes = data;
        if (data.length > 0 && !this.codOrigen) {
          this.codOrigen = data[0].codOrigen;
        }
      },
      error: () => {
        this.origenes = [{ codOrigen: 'SE', nombre: 'SECHURA', ubicacion: 'SECHURA, PIURA' }];
      }
    });
  }

  cargarReporte(): void {
    this.cargando = true;
    this.error = null;

    const fechaInicioStr = this.formatearFechaParaApi(this.fechaInicio);
    const fechaFinStr = this.formatearFechaParaApi(this.fechaFin);

    this.dashboardService.obtenerReporteProduccion(this.codOrigen, fechaInicioStr, fechaFinStr)
      .subscribe({
        next: (data) => {
          this.registros = data;
          this.extraerTiposTrabajador();
          this.aplicarFiltros();
          this.cargando = false;
          this.mostrarMensaje(`Reporte generado: ${data.length} registros`, 'success');
        },
        error: (error) => {
          this.error = 'Error al cargar el reporte: ' + error.message;
          this.cargando = false;
          this.mostrarMensaje('Error al cargar el reporte', 'error');
        }
      });
  }

  onFiltroChange(): void {
    this.cargarReporte();
  }

  onFiltroBusqueda(): void {
    this.aplicarFiltros();
  }

  extraerTiposTrabajador(): void {
    const tipos = new Set<string>();
    this.registros.forEach(r => { if (r.tipoTrabajador) tipos.add(r.tipoTrabajador); });
    this.tiposTrabajador = ['TODOS', ...Array.from(tipos).sort()];
  }

  aplicarFiltros(): void {
    let filtrados = [...this.registros];

    if (this.busquedaNombre.trim()) {
      const busqueda = this.busquedaNombre.toLowerCase();
      filtrados = filtrados.filter(r =>
        r.nombres?.toLowerCase().includes(busqueda) ||
        r.apellidos?.toLowerCase().includes(busqueda) ||
        r.codigoTrabajador?.includes(busqueda) ||
        r.dni?.includes(busqueda)
      );
    }

    if (this.tipoTrabajadorFiltro && this.tipoTrabajadorFiltro !== 'TODOS') {
      filtrados = filtrados.filter(r => r.tipoTrabajador === this.tipoTrabajadorFiltro);
    }

    this.registrosFiltrados = filtrados;
  }

  ordenarPor(columna: string): void {
    if (this.columnaOrdenada === columna) {
      this.ordenAscendente = !this.ordenAscendente;
    } else {
      this.columnaOrdenada = columna;
      this.ordenAscendente = true;
    }

    this.registrosFiltrados.sort((a: any, b: any) => {
      const valorA = a[columna];
      const valorB = b[columna];
      let comparacion = 0;
      if (valorA == null) comparacion = -1;
      else if (valorB == null) comparacion = 1;
      else if (valorA < valorB) comparacion = -1;
      else if (valorA > valorB) comparacion = 1;
      return this.ordenAscendente ? comparacion : -comparacion;
    });
  }

  exportarExcel(): void {
    const datosExcel = this.registrosFiltrados.map(reg => ({
      'Nro': reg.nro,
      'Código': reg.codigoTrabajador,
      'DNI': reg.dni,
      'Nombres': reg.nombres,
      'Apellidos': reg.apellidos,
      'Tipo Trabajador': reg.tipoTrabajador,
      'Fecha': reg.fecha,
      'Ingreso Planta': reg.horaIngresoPlanta,
      'Ingreso Producción': reg.horaIngresoProduccion,
      'Cambio Ropa (min)': reg.minutosCambioRopa,
      'Salida Producción': reg.horaSalidaProduccion,
      'Salida Planta': reg.horaSalidaPlanta,
      'Hrs Efectivas Producción': reg.horasEfectivasProduccion,
      'Hrs Total Planta': reg.horasTotalPlanta,
      'Hrs Muertas': reg.horasMuertas
    }));

    const ws: XLSX.WorkSheet = XLSX.utils.json_to_sheet(datosExcel);
    const wb: XLSX.WorkBook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Reporte Producción');

    const fileName = `reporte-produccion-${this.formatearFechaParaArchivo(this.fechaInicio)}-${this.formatearFechaParaArchivo(this.fechaFin)}.xlsx`;
    XLSX.writeFile(wb, fileName);
    this.mostrarMensaje('Reporte exportado a Excel', 'success');
  }

  exportarPDF(): void {
    if (this.registros.length === 0) {
      this.mostrarMensaje('No hay datos para exportar', 'info');
      return;
    }

    const fechaInicio = this.formatearFechaParaApi(this.fechaInicio);
    const fechaFin = this.formatearFechaParaApi(this.fechaFin);
    const nombreArchivo = `Reporte_Produccion_${this.codOrigen}_${this.formatearFechaParaArchivo(this.fechaInicio)}_${this.formatearFechaParaArchivo(this.fechaFin)}.pdf`;

    this.dashboardService.descargarReporteProduccionPDF(this.codOrigen, fechaInicio, fechaFin).subscribe({
      next: (blob) => {
        const url = window.URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = url;
        link.download = nombreArchivo;
        link.click();
        window.URL.revokeObjectURL(url);
        this.mostrarMensaje('PDF generado exitosamente', 'success');
      },
      error: () => {
        this.mostrarMensaje('Error al generar el PDF', 'error');
      }
    });
  }

  private formatearFechaParaApi(fecha: Date): string {
    return `${fecha.getFullYear()}-${(fecha.getMonth() + 1).toString().padStart(2, '0')}-${fecha.getDate().toString().padStart(2, '0')}`;
  }

  private formatearFechaParaArchivo(fecha: Date): string {
    return `${fecha.getFullYear()}${(fecha.getMonth() + 1).toString().padStart(2, '0')}${fecha.getDate().toString().padStart(2, '0')}`;
  }

  private mostrarMensaje(mensaje: string, tipo: 'success' | 'error' | 'info' = 'info'): void {
    this.snackBar.open(mensaje, 'Cerrar', {
      duration: 3000,
      horizontalPosition: 'end',
      verticalPosition: 'top',
      panelClass: tipo === 'success' ? 'snackbar-success' : tipo === 'error' ? 'snackbar-error' : 'snackbar-info'
    });
  }
}
