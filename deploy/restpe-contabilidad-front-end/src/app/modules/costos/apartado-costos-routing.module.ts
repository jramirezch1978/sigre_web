import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  {
    path: '',
    loadComponent: () =>
      import('./pages/costos-home/costos-home.component').then(m => m.CostosHomeComponent),
    children: [
      { path: '', redirectTo: 'centros', pathMatch: 'full' },
      {
        path: 'centros',
        loadComponent: () =>
          import('./pages/centro-costo-list/centro-costo-list.component').then(m => m.CentroCostoListComponent),
        title: 'Centros de Costos',
      },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ApartadoCostosRoutingModule {}
