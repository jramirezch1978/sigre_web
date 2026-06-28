import { Routes } from '@angular/router';
import { ALMACEN_TABLAS_OPCIONES, rutaRelativaAlmacen } from './config/almacen-opciones-menu.config';
import {
  ALMACEN_CONSULTAS_VISTAS,
  ALMACEN_OPERACIONES_VISTAS,
  ALMACEN_PROCESOS_VISTAS,
  ALMACEN_REPORTES_VISTAS,
} from './config/almacen-vistas.config';

export const almacenRoutes: Routes = [
  {
    path: '',
    loadComponent: () =>
      import('./pages/almacen-dashboard/almacen-dashboard.component').then(m => m.AlmacenDashboardComponent),
  },
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
  ...ALMACEN_OPERACIONES_VISTAS.map(vista => ({
    path: rutaRelativaAlmacen(vista.rutaFrontend),
    loadComponent: () =>
      import('./pages/almacen-listado-page/almacen-listado-page.component').then(m => m.AlmacenListadoPageComponent),
    data: { vista, titulo: vista.nombre, subtitulo: vista.subtitulo ?? null, columnas: vista.columnas, rutaFrontend: vista.rutaFrontend },
  })),
  ...ALMACEN_CONSULTAS_VISTAS.map(vista => ({
    path: rutaRelativaAlmacen(vista.rutaFrontend),
    loadComponent: () =>
      import('./pages/almacen-listado-page/almacen-listado-page.component').then(m => m.AlmacenListadoPageComponent),
    data: { vista, titulo: vista.nombre, subtitulo: vista.subtitulo ?? null, columnas: vista.columnas, rutaFrontend: vista.rutaFrontend },
  })),
  ...ALMACEN_REPORTES_VISTAS.map(vista => ({
    path: rutaRelativaAlmacen(vista.rutaFrontend),
    loadComponent: () =>
      import('./pages/almacen-listado-page/almacen-listado-page.component').then(m => m.AlmacenListadoPageComponent),
    data: { vista, titulo: vista.nombre, subtitulo: vista.subtitulo ?? null, columnas: vista.columnas, rutaFrontend: vista.rutaFrontend },
  })),
  ...ALMACEN_PROCESOS_VISTAS.map(vista => ({
    path: rutaRelativaAlmacen(vista.rutaFrontend),
    loadComponent: () =>
      import('./pages/almacen-proceso-page/almacen-proceso-page.component').then(m => m.AlmacenProcesoPageComponent),
    data: { vista, titulo: vista.nombre, subtitulo: vista.subtitulo ?? null, rutaFrontend: vista.rutaFrontend, procesoPath: vista.procesoPath ?? null },
  })),
  { path: 'tablas/tablas-almacenes', redirectTo: 'tablas/almacenes', pathMatch: 'full' },
  { path: 'tablas/almacenes-movimiento', redirectTo: 'tablas/movimientos-almacen', pathMatch: 'full' },
  // Opción de almacén sin ruta desarrollada: muestra "no desarrollada" dentro del ERP (no la landing).
  {
    path: '**',
    loadComponent: () =>
      import('../../pages/erp-opcion-no-desarrollada/erp-opcion-no-desarrollada.component')
        .then(m => m.ErpOpcionNoDesarrolladaComponent),
  },
];
