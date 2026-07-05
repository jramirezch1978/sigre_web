import { Routes } from '@angular/router';
import { MenuInicialComponent } from './components/menu-inicial/menu-inicial.component';
import { AsistenciaComponent } from './components/asistencia/asistencia.component';
import { RacionSelectionComponent } from './components/racion-selection/racion-selection.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { CentrosCostoDashboardComponent } from './components/centros-costo-dashboard/centros-costo-dashboard.component';
import { ReporteAsistenciaComponent } from './components/reporte-asistencia/reporte-asistencia.component';
import { ReporteProduccionComponent } from './components/reporte-produccion/reporte-produccion.component';
import { OpcionNoDesarrolladaComponent } from './components/opcion-no-desarrollada/opcion-no-desarrollada.component';

export const routes: Routes = [
  { path: '', component: MenuInicialComponent, title: 'Asistencia' },
  { path: 'asistencia', component: AsistenciaComponent, title: 'Asistencia' },
  { path: 'racion-selection', component: RacionSelectionComponent, title: 'Selección de Ración' },
  { path: 'dashboard', component: DashboardComponent, title: 'Dashboard de Asistencia' },
  { path: 'centros-costo-dashboard', component: CentrosCostoDashboardComponent, title: 'Centros de Costo' },
  { path: 'reporte-asistencia', component: ReporteAsistenciaComponent, title: 'Reporte de Asistencia' },
  { path: 'reporte-produccion', component: ReporteProduccionComponent, title: 'Reporte de Producción' },
  { path: 'en-construccion', component: OpcionNoDesarrolladaComponent, title: 'En Construcción' },
  {
    path: 'sigre',
    loadChildren: () => import('./erp/erp.routes').then(m => m.erpRoutes)
  },
  {
    path: 'almacen',
    redirectTo: '/sigre/almacen',
    pathMatch: 'prefix'
  },
  {
    path: 'auth',
    loadChildren: () => import('./auth/auth.module').then(m => m.AuthModule)
  },
  {
    path: 'admin',
    loadChildren: () => import('./admin/admin.module').then(m => m.AdminModule)
  },
  { path: '**', redirectTo: '/sigre/inicio' }
];
