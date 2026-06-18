import { Routes } from '@angular/router';
import { ALMACEN_TABLAS_OPCIONES, rutaRelativaAlmacen } from './config/almacen-opciones-menu.config';

export const almacenRoutes: Routes = [
  { path: '', redirectTo: 'tablas/almacenes', pathMatch: 'full' },
  ...ALMACEN_TABLAS_OPCIONES.map(opcion => ({
    path: rutaRelativaAlmacen(opcion.rutaFrontend),
    loadComponent: () =>
      import('./pages/almacen-tabla-page/almacen-tabla-page.component').then(m => m.AlmacenTablaPageComponent),
    data: {
      tablaKey: opcion.tablaKey,
      opcionMenuCodigo: opcion.codigo,
      titulo: opcion.nombre,
      nombreTablaDocumento: opcion.nombreTablaDocumento ?? null,
    },
  })),
  { path: 'tablas/tablas-almacenes', redirectTo: 'tablas/almacenes', pathMatch: 'full' },
  { path: 'tablas/almacenes-movimiento', redirectTo: 'tablas/movimientos-almacen', pathMatch: 'full' },
];
