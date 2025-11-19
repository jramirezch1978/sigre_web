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
import { NotImplementedService } from '../../services/not-implemented.service';
import * as XLSX from 'xlsx';

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
    MatDividerModule
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
    private snackBar: MatSnackBar,
    private notImplementedService: NotImplementedService
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
    this.mostrarMensaje('Función de exportación a PDF en desarrollo', 'info');
    // TODO: Implementar exportación a PDF
  }

  volver(): void {
    this.router.navigate(['/dashboard']);
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

  // Métodos del menú lateral
  onRegistrosDiarios() { this.notImplementedService.menuNotImplemented('Registros Diarios'); }
  onReportesPorEmpleado() { this.notImplementedService.menuNotImplemented('Reportes por Empleado'); }
  onHorariosYTurnos() { this.notImplementedService.menuNotImplemented('Horarios y Turnos'); }
  onAusenciasPermisos() { this.notImplementedService.menuNotImplemented('Ausencias y Permisos'); }
  onControlRaciones() { this.notImplementedService.menuNotImplemented('Control de Raciones'); }
  onMenusDiarios() { this.notImplementedService.menuNotImplemented('Menús Diarios'); }
  onReportesAlimentarios() { this.notImplementedService.menuNotImplemented('Reportes Alimentarios'); }
  onReportesSemanales() { this.notImplementedService.reportNotImplemented('Reportes Semanales'); }
  onReportesMensuales() { this.notImplementedService.reportNotImplemented('Reportes Mensuales'); }
  onAnalisisTendencias() { this.notImplementedService.menuNotImplemented('Análisis de Tendencias'); }
  onExportarDatos() { this.notImplementedService.menuNotImplemented('Exportar Datos'); }
  onParametrosGenerales() { this.notImplementedService.menuNotImplemented('Parámetros Generales'); }
  onDispositivos() { this.notImplementedService.menuNotImplemented('Dispositivos'); }
  onSincronizacion() { this.notImplementedService.menuNotImplemented('Sincronización'); }
  onUsuariosSistema() { this.notImplementedService.menuNotImplemented('Usuarios del Sistema'); }
  onPermisosRoles() { this.notImplementedService.menuNotImplemented('Permisos y Roles'); }
  onLogsSistema() { this.notImplementedService.menuNotImplemented('Logs del Sistema'); }
  onConfiguracion() { this.notImplementedService.actionNotImplemented('Configuración'); }
  onPantallaCompleta() { this.notImplementedService.actionNotImplemented('Pantalla Completa'); }
  onAyuda() { this.notImplementedService.actionNotImplemented('Ayuda'); }
  volverMenuPrincipal() { this.router.navigate(['/']); }
  onMiPerfil() { this.notImplementedService.actionNotImplemented('Mi Perfil'); }
  onConfiguracionUsuario() { this.notImplementedService.actionNotImplemented('Configuración de Usuario'); }
}

