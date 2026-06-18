import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  {
    path: 'home',
    loadChildren: () =>
      import('../home/home.module').then((m) => m.HomePageModule),
  },
  {
    path: 'inicio',
    loadChildren: () =>
      import('./dashboard/dashboard.module').then((m) => m.DashboardModule),
  },
  {
    path: 'almacen',
    loadChildren: () =>
      import('./almacen/apartado-almacen.module').then(
        (m) => m.ApartadoAlmacenModule
      ),
  },
  {
    path: 'compras',
    loadChildren: () =>
      import('./compras/apartado-compras.module').then(
        (m) => m.ApartadoComprasModule
      ),
  },
  {
    path: 'contabilidad',
    loadChildren: () =>
      import('./contabilidad/apartado-contabilidad.module').then(
        (m) => m.ApartadoContabilidadPageModule
      ),
  },
  {
    path: 'finanzas',
    loadChildren: () =>
      import('./finanzas/apartado-finanzas.module').then(
        (m) => m.ApartadoFinanzasModule
      ),
  },
  {
    path: 'ventas',
    loadChildren: () =>
      import('./ventas/ventas-module').then(
        (m) => m.VentasModule
      ),
  },
  {
    path: 'caja',
    loadChildren: () =>
      import('./caja/apartado-caja.module').then(
        (m) => m.ApartadoCajaModule
      ),
  },
  {
    path: 'costos',
    loadChildren: () =>
      import('./costos/apartado-costos.module').then(
        (m) => m.ApartadoCostosModule
      ),
  },
  {
    path: 'facturacion',
    loadChildren: () =>
      import('./facturacion/apartado-facturacion.module').then(
        (m) => m.ApartadoFacturacionModule
      ),
  },
  {
    path: 'activos',
    loadChildren: () =>
      import('./activos/activos-fijos.module').then(
        (m) => m.ActivosFijosPageModule
      ),
  },
  {
    path: 'rrhh',
    loadChildren: () =>
      import('./rrhh/apartado-rr-hh.module').then(
        (m) => m.ApartadoRrHhModule
      ),
  },
  {
    path: 'produccion',
    loadChildren: () =>
      import('./produccion/apartado-produccion.module').then(
        (m) => m.ApartadoProduccionPageModule
      ),
  },
  {
    path: 'configuracion',
    loadChildren: () =>
      import('./configuracion/apartado-configuracion.module').then(
        (m) => m.ApartadoConfiguracionModule
      ),
  },
  {
    path: 'notificaciones',
    loadChildren: () =>
      import('./notificaciones/apartado-notificaciones.module').then(
        (m) => m.ApartadoNotificacionesPageModule
      ),
  },
  {
    path: 'ia',
    loadChildren: () =>
      import('./ia/apartado-ia.module').then(
        (m) => m.ApartadoIaPageModule
      ),
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ModulesRoutingModule {}
