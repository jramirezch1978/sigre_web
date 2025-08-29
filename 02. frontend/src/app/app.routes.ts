import { Routes } from '@angular/router';
import { AsistenciaComponent } from './components/asistencia/asistencia.component';
import { RacionSelectionComponent } from './components/racion-selection/racion-selection.component';

export const routes: Routes = [
  { path: '', component: AsistenciaComponent },
  { path: 'racion-selection', component: RacionSelectionComponent },
  { path: '**', redirectTo: '' }
];
