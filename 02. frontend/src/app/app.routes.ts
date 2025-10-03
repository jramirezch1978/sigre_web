import { Routes } from '@angular/router';
import { MenuInicialComponent } from './components/menu-inicial/menu-inicial.component';
import { AsistenciaComponent } from './components/asistencia/asistencia.component';
import { RacionSelectionComponent } from './components/racion-selection/racion-selection.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { CentrosCostoDashboardComponent } from './components/centros-costo-dashboard/centros-costo-dashboard.component';

export const routes: Routes = [
  { path: '', component: MenuInicialComponent },
  { path: 'asistencia', component: AsistenciaComponent },
  { path: 'racion-selection', component: RacionSelectionComponent },
  { path: 'dashboard', component: DashboardComponent },
  { path: 'centros-costo-dashboard', component: CentrosCostoDashboardComponent },
  { path: '**', redirectTo: '' }
];
