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

export interface ReporteAsistencia {
  nro: number;
  tipoTrabajador: string;
  codigoTrabajador: string;
  dni: string;
  apellidosNombres: string;
  area: string;
  cargoPuesto: string;
  turno: string;
  fecha: string;
  horaIngreso: string;
  horaSalida: string;
  horasTrabajadas: string;
  horasExtras: number;
  tardanzaMin: number;
  totalHorasTrabajadasSemana: number;
  totalHorasExtrasSemana: number;
  totalDiasAsistidos: number;
  totalFaltas: number;
  porcAsistencia: number;
  porcAusentismo: number;
}

@Component({
  selector: 'app-reporte-asistencia',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    HttpClientModule,
    FormsModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule,
    MatTableModule,
    MatProgressSpinnerModule,
    MatSnackBarModule,
    MatToolbarModule,
    MatDatepickerModule,
    MatFormFieldModule,
    MatInputModule,
    MatSelectModule,
    MatNativeDateModule,
    MatMenuModule,
    MatDividerModule,
    MainLayoutComponent
  ],
  providers: [
    { provide: MAT_DATE_LOCALE, useValue: 'es-PE' },
    { provide: DateAdapter, useClass: CustomDateAdapter },
    { provide: MAT_DATE_FORMATS, useValue: MY_DATE_FORMATS }
  ],
  templateUrl: './reporte-asistencia.component.html',
  styleUrls: ['./reporte-asistencia.component.scss']
})
export class ReporteAsistenciaComponent implements OnInit, OnDestroy {
  
  // Datos
  registros: ReporteAsistencia[] = [];
  registrosFiltrados: ReporteAsistencia[] = [];
  
  // Filtros
  codOrigen: string = 'SE';
  fechaInicio: Date = new Date();
  fechaFin: Date = new Date();
  busquedaNombre: string = '';
  tipoTrabajadorFiltro: string = 'TODOS';
  
  // Opciones de origen (se cargan desde el backend)
  origenes: Origen[] = [];
  tiposTrabajador: string[] = [];
  
  // Ordenamiento
  columnaOrdenada: string = '';
  ordenAscendente: boolean = true;
  
  // Estados
  cargando: boolean = false;
  error: string | null = null;
  
  // Columnas de la tabla
  columnasVisibles: string[] = [
    'nro', 'tipoTrabajador', 'codigoTrabajador', 'dni', 'apellidosNombres',
    'area', 'cargoPuesto', 'turno', 'fecha', 'horaIngreso', 'horaSalida',
    'horasTrabajadas', 'horasExtras', 'tardanzaMin', 'totalHorasTrabajadasSemana',
    'totalHorasExtrasSemana', 'totalDiasAsistidos', 'totalFaltas',
    'porcAsistencia', 'porcAusentismo'
  ];

  constructor(
    private dashboardService: DashboardService,
    private router: Router,
    private snackBar: MatSnackBar
  ) {
    // Inicializar fechas: primer y último día del mes actual
    const hoy = new Date();
    this.fechaInicio = new Date(hoy.getFullYear(), hoy.getMonth(), hoy.getDate());
    this.fechaFin = new Date(hoy.getFullYear(), hoy.getMonth(), hoy.getDate());
  }

  ngOnInit(): void {
    console.log('📊 Iniciando Reporte de Asistencia');
    this.cargarOrigenes();
    this.cargarReporte();
  }

  cargarOrigenes(): void {
    console.log('📍 Cargando orígenes desde backend...');
    this.dashboardService.obtenerOrigenes().subscribe({
      next: (data) => {
        console.log('✅ Orígenes cargados:', data);
        this.origenes = data;
        if (data.length > 0 && !this.codOrigen) {
          this.codOrigen = data[0].codOrigen;
        }
      },
      error: (error) => {
        console.error('❌ Error cargando orígenes:', error);
        // Fallback: usar origen por defecto
        this.origenes = [{ codOrigen: 'SE', nombre: 'SECHURA', ubicacion: 'SECHURA, PIURA' }];
      }
    });
  }

  ngOnDestroy(): void {
    // Cleanup si es necesario
  }

  cargarReporte(): void {
    this.cargando = true;
    this.error = null;
    
    const fechaInicioStr = this.formatearFechaParaApi(this.fechaInicio);
    const fechaFinStr = this.formatearFechaParaApi(this.fechaFin);
    
    console.log('🔄 Cargando reporte:', { 
      origen: this.codOrigen, 
      fechaInicio: fechaInicioStr, 
      fechaFin: fechaFinStr 
    });
    
    this.dashboardService.obtenerReporteAsistencia(this.codOrigen, fechaInicioStr, fechaFinStr)
      .subscribe({
        next: (data) => {
          console.log('✅ Reporte cargado:', data.length, 'registros');
          this.registros = data;
          this.extraerTiposTrabajador();
          this.aplicarFiltros();
          this.cargando = false;
          this.mostrarMensaje(`Reporte generado: ${data.length} registros`, 'success');
        },
        error: (error) => {
          console.error('❌ Error cargando reporte:', error);
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
    console.log('🔍 Aplicando filtros de búsqueda');
    this.aplicarFiltros();
  }

  extraerTiposTrabajador(): void {
    const tipos = new Set<string>();
    this.registros.forEach(r => tipos.add(r.tipoTrabajador));
    this.tiposTrabajador = ['TODOS', ...Array.from(tipos).sort()];
  }

  aplicarFiltros(): void {
    let filtrados = [...this.registros];

    // Filtro por nombre (búsqueda contextual)
    if (this.busquedaNombre.trim()) {
      const busqueda = this.busquedaNombre.toLowerCase();
      filtrados = filtrados.filter(r => 
        r.apellidosNombres.toLowerCase().includes(busqueda) ||
        r.codigoTrabajador.includes(busqueda) ||
        r.dni.includes(busqueda)
      );
    }

    // Filtro por tipo de trabajador
    if (this.tipoTrabajadorFiltro && this.tipoTrabajadorFiltro !== 'TODOS') {
      filtrados = filtrados.filter(r => r.tipoTrabajador === this.tipoTrabajadorFiltro);
    }

    this.registrosFiltrados = filtrados;
    console.log('📊 Registros filtrados:', this.registrosFiltrados.length, 'de', this.registros.length);
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

    console.log('📊 Ordenado por:', columna, this.ordenAscendente ? 'ASC' : 'DESC');
  }

  async exportarExcel(): Promise<void> {
    const wb = new ExcelJS.Workbook();
    const ws = wb.addWorksheet('Reporte Asistencia');

    const headers = ['N°', 'Tipo', 'Código', 'DNI', 'Apellidos y Nombres', 'Área',
      'Cargo', 'Turno', 'Fecha', 'Hora Ingreso', 'Hora Salida', 'Hrs Trabajadas',
      'Hrs Extras', 'Tardanza (min)', 'Total Hrs Semana', 'Total Extras Semana',
      'Días Asistidos', 'Faltas', '% Asistencia', '% Ausentismo'];

    const headerRow = ws.addRow(headers);
    headerRow.eachCell(cell => {
      cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF667EEA' } };
      cell.font = { bold: true, color: { argb: 'FFFFFFFF' }, size: 11 };
      cell.alignment = { horizontal: 'center', vertical: 'middle', wrapText: true };
      cell.border = { top: { style: 'thin' }, bottom: { style: 'thin' }, left: { style: 'thin' }, right: { style: 'thin' } };
    });
    headerRow.height = 30;

    const thinBorder: Partial<ExcelJS.Borders> = {
      top: { style: 'thin' }, bottom: { style: 'thin' }, left: { style: 'thin' }, right: { style: 'thin' }
    };

    this.registrosFiltrados.forEach((reg, idx) => {
      const horaSalida = reg.horaSalida ? new Date(reg.horaSalida).toLocaleTimeString('es-PE') : 'Pendiente';
      const row = ws.addRow([
        reg.nro, reg.tipoTrabajador, reg.codigoTrabajador, reg.dni, reg.apellidosNombres,
        reg.area, reg.cargoPuesto, reg.turno,
        reg.fecha ? new Date(reg.fecha).toLocaleDateString('es-PE') : '',
        reg.horaIngreso ? new Date(reg.horaIngreso).toLocaleTimeString('es-PE') : '',
        horaSalida,
        reg.horasTrabajadas, reg.horasExtras, reg.tardanzaMin,
        reg.totalHorasTrabajadasSemana, reg.totalHorasExtrasSemana,
        reg.totalDiasAsistidos, reg.totalFaltas, reg.porcAsistencia, reg.porcAusentismo
      ]);

      const bgColor = idx % 2 === 0 ? 'FFFFFFFF' : 'FFF9FAFB';
      row.eachCell(cell => {
        cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: bgColor } };
        cell.border = thinBorder;
        cell.alignment = { vertical: 'middle' };
      });

      if (!reg.horaSalida) {
        const salidaCell = row.getCell(11);
        salidaCell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFF9800' } };
        salidaCell.font = { color: { argb: 'FFFFFFFF' }, bold: true, size: 10 };
        salidaCell.alignment = { horizontal: 'center', vertical: 'middle' };
      }

      if (reg.tardanzaMin > 15) {
        const tardanzaCell = row.getCell(14);
        tardanzaCell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFEBEE' } };
        tardanzaCell.font = { color: { argb: 'FFDC2626' }, bold: true };
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
    const fileName = `reporte-asistencia-${this.formatearFechaParaArchivo(this.fechaInicio)}-${this.formatearFechaParaArchivo(this.fechaFin)}.xlsx`;
    saveAs(new Blob([buffer]), fileName);
    this.mostrarMensaje('Reporte exportado a Excel', 'success');
  }

  exportarPDF(): void {
    console.log('📄 Solicitando PDF al backend...');
    
    if (this.registros.length === 0) {
      this.mostrarMensaje('No hay datos para exportar', 'info');
      return;
    }

    const fechaInicio = this.formatearFechaParaApi(this.fechaInicio);
    const fechaFin = this.formatearFechaParaApi(this.fechaFin);
    const nombreArchivo = `Reporte_Asistencia_${this.codOrigen}_${this.formatearFechaParaArchivo(this.fechaInicio)}_${this.formatearFechaParaArchivo(this.fechaFin)}.pdf`;
    
    this.dashboardService.descargarReportePDF(this.codOrigen, fechaInicio, fechaFin).subscribe({
      next: (blob) => {
        // Crear URL temporal para el blob
        const url = window.URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = url;
        link.download = nombreArchivo;
        link.click();
        window.URL.revokeObjectURL(url);
        
        this.mostrarMensaje('PDF generado exitosamente', 'success');
        console.log('✅ PDF descargado:', nombreArchivo);
      },
      error: (error) => {
        console.error('❌ Error descargando PDF:', error);
        this.mostrarMensaje('Error al generar el PDF', 'error');
      }
    });
  }

  private formatearFechaParaApi(fecha: Date): string {
    const year = fecha.getFullYear();
    const month = (fecha.getMonth() + 1).toString().padStart(2, '0');
    const day = fecha.getDate().toString().padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  private formatearFechaParaArchivo(fecha: Date): string {
    const year = fecha.getFullYear();
    const month = (fecha.getMonth() + 1).toString().padStart(2, '0');
    const day = fecha.getDate().toString().padStart(2, '0');
    return `${year}${month}${day}`;
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

