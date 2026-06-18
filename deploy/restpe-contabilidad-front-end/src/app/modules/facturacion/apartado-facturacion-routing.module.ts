import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  {
    path: '',
    loadComponent: () =>
      import('./pages/facturacion-home/facturacion-home.component').then(m => m.FacturacionHomeComponent),
    children: [
      { path: '', redirectTo: 'comprobantes', pathMatch: 'full' },
      {
        path: 'comprobantes',
        loadComponent: () =>
          import('./pages/comprobante-list/comprobante-list.component').then(m => m.ComprobanteListComponent),
        title: 'Facturación Electrónica',
      },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ApartadoFacturacionRoutingModule {}
