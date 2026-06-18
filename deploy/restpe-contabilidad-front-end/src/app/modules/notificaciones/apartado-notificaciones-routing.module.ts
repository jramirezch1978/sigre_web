import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { ApartadoNotificacionesPage } from './apartado-notificaciones.page';

const routes: Routes = [
  {
    path: '',
    component: ApartadoNotificacionesPage
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ApartadoNotificacionesPageRoutingModule {}
