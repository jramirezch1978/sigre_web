import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AsignacionGastosIndirectosComponent } from './m-p-procesos/pages/asignacion-gastos-indirectos/asignacion-gastos-indirectos.component';
import { CanDeactivateGuard } from 'src/app/auth/guards/can-deactivate.guard';

const routes: Routes = [
  {
    path: '',
    redirectTo: 'procesos/asignacion-gastos-indirectos',
    pathMatch: 'full'
  },
  {
    path: 'procesos/asignacion-gastos-indirectos',
    component: AsignacionGastosIndirectosComponent,
    canDeactivate: [CanDeactivateGuard],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ApartadoProduccionPageRoutingModule {}
