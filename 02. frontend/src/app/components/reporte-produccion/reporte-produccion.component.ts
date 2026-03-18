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
import ExcelJS from 'exceljs';
import { saveAs } from 'file-saver';

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
    this.fechaInicio = new Date(hoy.getFullYear(), hoy.getMonth(), hoy.getDate());
    this.fechaFin = new Date(hoy.getFullYear(), hoy.getMonth(), hoy.getDate());
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

  async exportarExcel(): Promise<void> {
    const wb = new ExcelJS.Workbook();
    const ws = wb.addWorksheet('Reporte Producción');

    const headers = ['N°', 'Código', 'DNI', 'Apellidos', 'Nombres', 'Tipo Trabajador',
      'Fecha', 'Ingreso Planta', 'Ingreso Producción', 'Cambio Ropa (min)',
      'Salida Producción', 'Salida Planta', 'Hrs Efect. Producción', 'Hrs Total Planta', 'Hrs Muertas'];

    const headerRow = ws.addRow(headers);
    headerRow.eachCell(cell => {
      cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF16A34A' } };
      cell.font = { bold: true, color: { argb: 'FFFFFFFF' }, size: 11 };
      cell.alignment = { horizontal: 'center', vertical: 'middle', wrapText: true };
      cell.border = { top: { style: 'thin' }, bottom: { style: 'thin' }, left: { style: 'thin' }, right: { style: 'thin' } };
    });
    headerRow.height = 30;

    const thinBorder: Partial<ExcelJS.Borders> = {
      top: { style: 'thin' }, bottom: { style: 'thin' }, left: { style: 'thin' }, right: { style: 'thin' }
    };

    const formatTime = (val: any): string => {
      if (!val) return '';
      try { return new Date(val).toLocaleTimeString('es-PE'); } catch { return ''; }
    };

    this.registrosFiltrados.forEach((reg, idx) => {
      const salidaProd = reg.horaSalidaProduccion ? formatTime(reg.horaSalidaProduccion) : 'Pendiente';
      const salidaPlanta = reg.horaSalidaPlanta ? formatTime(reg.horaSalidaPlanta) : 'Pendiente';

      const row = ws.addRow([
        reg.nro, reg.codigoTrabajador, reg.dni, reg.apellidos, reg.nombres, reg.tipoTrabajador,
        reg.fecha ? new Date(reg.fecha).toLocaleDateString('es-PE') : '',
        formatTime(reg.horaIngresoPlanta), formatTime(reg.horaIngresoProduccion),
        reg.minutosCambioRopa ?? '', salidaProd, salidaPlanta,
        reg.horasEfectivasProduccion ?? '-', reg.horasTotalPlanta ?? '-', reg.horasMuertas ?? '-'
      ]);

      const bgColor = idx % 2 === 0 ? 'FFFFFFFF' : 'FFF9FAFB';
      row.eachCell((cell, colNumber) => {
        cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: bgColor } };
        cell.border = thinBorder;
        cell.alignment = { vertical: 'middle' };

        if ([8, 9, 11, 12].includes(colNumber)) {
          cell.alignment = { horizontal: 'center', vertical: 'middle' };
        }
        if ([10, 13, 14, 15].includes(colNumber)) {
          cell.alignment = { horizontal: 'right', vertical: 'middle' };
        }
      });

      if (!reg.horaSalidaProduccion) {
        const c = row.getCell(11);
        c.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFF9800' } };
        c.font = { color: { argb: 'FFFFFFFF' }, bold: true, size: 10 };
        c.alignment = { horizontal: 'center', vertical: 'middle' };
      }
      if (!reg.horaSalidaPlanta) {
        const c = row.getCell(12);
        c.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFF9800' } };
        c.font = { color: { argb: 'FFFFFFFF' }, bold: true, size: 10 };
        c.alignment = { horizontal: 'center', vertical: 'middle' };
      }
    });

    ws.columns.forEach(col => {
      let maxLen = 10;
      col.eachCell?.({ includeEmpty: true }, cell => {
        const len = cell.value ? cell.value.toString().length : 0;
        if (len > maxLen) maxLen = len;
      });
      col.width = Math.min(maxLen + 3, 35);
    });

    const buffer = await wb.xlsx.writeBuffer();
    const fileName = `reporte-produccion-${this.formatearFechaParaArchivo(this.fechaInicio)}-${this.formatearFechaParaArchivo(this.fechaFin)}.xlsx`;
    saveAs(new Blob([buffer]), fileName);
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
