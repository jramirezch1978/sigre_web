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
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';

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
  
  // Opciones de origen (se cargan desde el backend)
  origenes: Origen[] = [];
  
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
    this.fechaInicio = new Date(hoy.getFullYear(), hoy.getMonth(), 1);
    this.fechaFin = hoy;
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
          this.registrosFiltrados = data;
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

  exportarExcel(): void {
    console.log('📥 Exportando a Excel...');
    
    const datosExcel = this.registrosFiltrados.map(reg => ({
      'Nro': reg.nro,
      'Tipo': reg.tipoTrabajador,
      'Código': reg.codigoTrabajador,
      'DNI': reg.dni,
      'Apellidos y Nombres': reg.apellidosNombres,
      'Área': reg.area,
      'Cargo': reg.cargoPuesto,
      'Turno': reg.turno,
      'Fecha': reg.fecha,
      'Hora Ingreso': reg.horaIngreso,
      'Hora Salida': reg.horaSalida,
      'Horas Trabajadas': reg.horasTrabajadas,
      'Horas Extras': reg.horasExtras,
      'Tardanza (min)': reg.tardanzaMin,
      'Total Hrs Semana': reg.totalHorasTrabajadasSemana,
      'Total Extras Semana': reg.totalHorasExtrasSemana,
      'Días Asistidos': reg.totalDiasAsistidos,
      'Faltas': reg.totalFaltas,
      '% Asistencia': reg.porcAsistencia,
      '% Ausentismo': reg.porcAusentismo
    }));

    const ws: XLSX.WorkSheet = XLSX.utils.json_to_sheet(datosExcel);
    const wb: XLSX.WorkBook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Reporte Asistencia');
    
    const fileName = `reporte-asistencia-${this.formatearFechaParaArchivo(this.fechaInicio)}-${this.formatearFechaParaArchivo(this.fechaFin)}.xlsx`;
    XLSX.writeFile(wb, fileName);
    
    this.mostrarMensaje('Reporte exportado a Excel', 'success');
  }

  exportarPDF(): void {
    console.log('📄 Exportando a PDF...');
    
    if (this.registros.length === 0) {
      this.mostrarMensaje('No hay datos para exportar', 'info');
      return;
    }

    try {
      const doc = new jsPDF('landscape', 'mm', 'a4');
      
      // Título
      doc.setFontSize(16);
      doc.setTextColor(40, 63, 84);
      doc.text('Reporte de Asistencia', 14, 15);
      
      // Subtítulo
      doc.setFontSize(10);
      doc.setTextColor(115, 135, 156);
      doc.text('Análisis detallado de horas trabajadas, tardanzas y asistencia del personal', 14, 22);
      
      // Filtros aplicados
      doc.setFontSize(9);
      doc.setTextColor(60, 60, 60);
      const origenSeleccionado = this.origenes.find(o => o.codOrigen === this.codOrigen);
      const origenTexto = origenSeleccionado ? `${origenSeleccionado.codOrigen} - ${origenSeleccionado.nombre}` : this.codOrigen;
      doc.text(`Origen: ${origenTexto} | Período: ${this.formatearFechaParaArchivo(this.fechaInicio)} - ${this.formatearFechaParaArchivo(this.fechaFin)}`, 14, 28);
      
      // Preparar datos para la tabla
      const headers = [
        ['N°', 'Tipo', 'Código', 'DNI', 'Apellidos y Nombres', 'Área', 'Cargo/Puesto', 'Turno', 
         'Fecha', 'Ingreso', 'Salida', 'Hrs.Trab.', 'Hrs.Extras', 'Tard.(min)', 
         'Tot.Hrs.Sem', 'Extras Sem', 'Días', 'Faltas', '%Asis.', '%Ausent.']
      ];
      
      const data = this.registros.map(row => [
        row.nro,
        row.tipoTrabajador,
        row.codigoTrabajador,
        row.dni,
        row.apellidosNombres,
        row.area,
        row.cargoPuesto,
        row.turno,
        this.formatearFecha(row.fecha),
        this.formatearHora(row.horaIngreso),
        row.horaSalida ? this.formatearHora(row.horaSalida) : 'Pendiente',
        row.horasTrabajadas,
        row.horasExtras?.toFixed(2) || '0.00',
        row.tardanzaMin || 0,
        row.totalHorasTrabajadasSemana?.toFixed(2) || '0.00',
        row.totalHorasExtrasSemana?.toFixed(2) || '0.00',
        row.totalDiasAsistidos || 0,
        row.totalFaltas || 0,
        row.porcAsistencia?.toFixed(2) || '0.00',
        row.porcAusentismo?.toFixed(2) || '0.00'
      ]);
      
      // Generar tabla con autoTable
      autoTable(doc, {
        head: headers,
        body: data,
        startY: 32,
        theme: 'grid',
        styles: {
          fontSize: 7,
          cellPadding: 2,
          overflow: 'linebreak',
          halign: 'center'
        },
        headStyles: {
          fillColor: [102, 126, 234],
          textColor: 255,
          fontStyle: 'bold',
          halign: 'center',
          valign: 'middle'
        },
        columnStyles: {
          0: { halign: 'center', cellWidth: 8 },   // N°
          1: { halign: 'left', cellWidth: 20 },    // Tipo
          2: { halign: 'center', cellWidth: 12 },  // Código
          3: { halign: 'center', cellWidth: 12 },  // DNI
          4: { halign: 'left', cellWidth: 35 },    // Nombres
          5: { halign: 'left', cellWidth: 25 },    // Área
          6: { halign: 'left', cellWidth: 28 },    // Cargo
          7: { halign: 'center', cellWidth: 15 },  // Turno
          8: { halign: 'center', cellWidth: 15 },  // Fecha
          9: { halign: 'center', cellWidth: 12 },  // Ingreso
          10: { halign: 'center', cellWidth: 12 }, // Salida
          11: { halign: 'right', cellWidth: 10 },  // Hrs Trab
          12: { halign: 'right', cellWidth: 10 },  // Hrs Extras
          13: { halign: 'right', cellWidth: 10 },  // Tard
          14: { halign: 'right', cellWidth: 12 },  // Tot Hrs Sem
          15: { halign: 'right', cellWidth: 12 },  // Extras Sem
          16: { halign: 'right', cellWidth: 8 },   // Días
          17: { halign: 'right', cellWidth: 8 },   // Faltas
          18: { halign: 'right', cellWidth: 10 },  // %Asis
          19: { halign: 'right', cellWidth: 10 }   // %Ausent
        },
        alternateRowStyles: {
          fillColor: [249, 250, 251]
        },
        margin: { top: 32, left: 10, right: 10 }
      });
      
      // Pie de página
      const pageCount = (doc as any).internal.getNumberOfPages();
      for (let i = 1; i <= pageCount; i++) {
        doc.setPage(i);
        doc.setFontSize(8);
        doc.setTextColor(150, 150, 150);
        doc.text(`Página ${i} de ${pageCount}`, doc.internal.pageSize.width - 30, doc.internal.pageSize.height - 10);
        doc.text(`Generado: ${new Date().toLocaleString('es-PE')}`, 14, doc.internal.pageSize.height - 10);
      }
      
      // Descargar PDF
      const nombreArchivo = `Reporte_Asistencia_${this.codOrigen}_${this.formatearFechaParaArchivo(this.fechaInicio)}_${this.formatearFechaParaArchivo(this.fechaFin)}.pdf`;
      doc.save(nombreArchivo);
      
      this.mostrarMensaje('PDF generado exitosamente', 'success');
      console.log('✅ PDF exportado:', nombreArchivo);
      
    } catch (error) {
      console.error('❌ Error exportando PDF:', error);
      this.mostrarMensaje('Error al generar el PDF', 'error');
    }
  }

  private formatearFecha(fecha: string): string {
    if (!fecha) return '';
    const f = new Date(fecha);
    return f.toLocaleDateString('es-PE');
  }

  private formatearHora(hora: string): string {
    if (!hora) return '';
    const h = new Date(hora);
    return h.toLocaleTimeString('es-PE', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
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

