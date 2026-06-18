import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  {
    path: '',
    loadComponent: () =>
      import('./pages/caja-home/caja-home.component').then(m => m.CajaHomeComponent),
    children: [
      { path: '', redirectTo: 'movimientos', pathMatch: 'full' },
      {
        path: 'movimientos',
        loadComponent: () =>
          import('./pages/movimiento-caja-list/movimiento-caja-list.component').then(m => m.MovimientoCajaListComponent),
        title: 'Movimientos — Caja',
      },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ApartadoCajaRoutingModule {}
