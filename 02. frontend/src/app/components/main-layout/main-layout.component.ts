import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatMenuModule } from '@angular/material/menu';
import { MatDividerModule } from '@angular/material/divider';

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

  menuCollapsed = false;
  submenusAbiertos: { [key: string]: boolean } = {
    asistencia: false,
    comedores: false,
    reportes: false,
    configuracion: false,
    administracion: false
  };

  constructor(
    private router: Router
  ) {}

  /**
   * Navega a la pagina de "opcion en construccion" (mismo patron que el ERP)
   * en vez de mostrar un modal, para las opciones del menu aun no desarrolladas.
   */
  private irANoDesarrollado(nombreOpcion: string): void {
    void this.router.navigate(['/en-construccion'], { queryParams: { op: nombreOpcion } });
  }

  toggleMenu() {
    this.menuCollapsed = !this.menuCollapsed;
  }

  toggleSubmenu(menu: string) {
    this.submenusAbiertos[menu] = !this.submenusAbiertos[menu];
  }

  // Navegación
  irADashboard() { this.router.navigate(['/dashboard']); }
  irAReporteAsistencia() { this.router.navigate(['/reporte-asistencia']); }
  irACentrosCosto() { this.router.navigate(['/centros-costo-dashboard']); }
  volverMenuPrincipal() { this.router.navigate(['/']); }

  // Métodos del menú lateral - No implementados
  onMetricasTiempoReal() { this.irANoDesarrollado('Métricas Tiempo Real'); }
  onRegistrosDiarios() { this.irANoDesarrollado('Registros Diarios'); }
  onReportesPorEmpleado() { this.irANoDesarrollado('Reportes por Empleado'); }
  onHorariosYTurnos() { this.irANoDesarrollado('Horarios y Turnos'); }
  onAusenciasPermisos() { this.irANoDesarrollado('Ausencias y Permisos'); }
  onControlRaciones() { this.irANoDesarrollado('Control de Raciones'); }
  onMenusDiarios() { this.irANoDesarrollado('Menús Diarios'); }
  onReportesAlimentarios() { this.irANoDesarrollado('Reportes Alimentarios'); }
  onReportesSemanales() { this.irANoDesarrollado('Reportes Semanales'); }
  onReportesMensuales() { this.irANoDesarrollado('Reportes Mensuales'); }
  onAnalisisTendencias() { this.irANoDesarrollado('Análisis de Tendencias'); }
  onExportarDatos() { this.irANoDesarrollado('Exportar Datos'); }
  onResumenPorArea() { this.irANoDesarrollado('Resumen por Área'); }
  onProductividad() { this.irANoDesarrollado('Productividad'); }
  onCostosOperativos() { this.irANoDesarrollado('Costos Operativos'); }
  onParametrosGenerales() { this.irANoDesarrollado('Parámetros Generales'); }
  onDispositivos() { this.irANoDesarrollado('Dispositivos'); }
  onSincronizacion() { this.irANoDesarrollado('Sincronización'); }
  onUsuariosSistema() { this.irANoDesarrollado('Usuarios del Sistema'); }
  onPermisosRoles() { this.irANoDesarrollado('Permisos y Roles'); }
  onLogsSistema() { this.irANoDesarrollado('Logs del Sistema'); }
  onConfiguracion() { this.irANoDesarrollado('Configuración'); }
  onPantallaCompleta() { this.irANoDesarrollado('Pantalla Completa'); }
  onAyuda() { this.irANoDesarrollado('Ayuda'); }
  onMiPerfil() { this.irANoDesarrollado('Mi Perfil'); }
  onConfiguracionUsuario() { this.irANoDesarrollado('Configuración de Usuario'); }
}

