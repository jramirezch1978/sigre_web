import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatMenuModule } from '@angular/material/menu';
import { MatDividerModule } from '@angular/material/divider';
import { NotImplementedService } from '../../services/not-implemented.service';

/**
 * Layout principal con menú lateral que se reutiliza en todas las páginas del dashboard
 */
@Component({
  selector: 'app-main-layout',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    MatIconModule,
    MatButtonModule,
    MatMenuModule,
    MatDividerModule
  ],
  templateUrl: './main-layout.component.html',
  styleUrls: ['./main-layout.component.scss']
})
export class MainLayoutComponent {

  constructor(
    private router: Router,
    private notImplementedService: NotImplementedService
  ) {}

  // Navegación
  irADashboard() { this.router.navigate(['/dashboard']); }
  irAReporteAsistencia() { this.router.navigate(['/reporte-asistencia']); }
  irACentrosCosto() { this.router.navigate(['/centros-costo-dashboard']); }
  volverMenuPrincipal() { this.router.navigate(['/']); }

  // Métodos del menú lateral - No implementados
  onMetricasTiempoReal() { this.notImplementedService.menuNotImplemented('Métricas Tiempo Real'); }
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
  onResumenPorArea() { this.notImplementedService.menuNotImplemented('Resumen por Área'); }
  onProductividad() { this.notImplementedService.menuNotImplemented('Productividad'); }
  onCostosOperativos() { this.notImplementedService.menuNotImplemented('Costos Operativos'); }
  onParametrosGenerales() { this.notImplementedService.menuNotImplemented('Parámetros Generales'); }
  onDispositivos() { this.notImplementedService.menuNotImplemented('Dispositivos'); }
  onSincronizacion() { this.notImplementedService.menuNotImplemented('Sincronización'); }
  onUsuariosSistema() { this.notImplementedService.menuNotImplemented('Usuarios del Sistema'); }
  onPermisosRoles() { this.notImplementedService.menuNotImplemented('Permisos y Roles'); }
  onLogsSistema() { this.notImplementedService.menuNotImplemented('Logs del Sistema'); }
  onConfiguracion() { this.notImplementedService.actionNotImplemented('Configuración'); }
  onPantallaCompleta() { this.notImplementedService.actionNotImplemented('Pantalla Completa'); }
  onAyuda() { this.notImplementedService.actionNotImplemented('Ayuda'); }
  onMiPerfil() { this.notImplementedService.actionNotImplemented('Mi Perfil'); }
  onConfiguracionUsuario() { this.notImplementedService.actionNotImplemented('Configuración de Usuario'); }
}

