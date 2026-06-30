import { Routes } from '@angular/router';

/** Rutas del módulo Compras. Por ahora: Ficha de Proveedores/Clientes (CM002). */
export const comprasRoutes: Routes = [
  {
    path: 'tablas/proveedores',
    loadComponent: () =>
      import('./pages/proveedores-list-page/proveedores-list-page.component').then(
        m => m.ProveedoresListPageComponent,
      ),
  },
  // Maestros de catálogo (CRUD genérico por config).
  ...['marcas', 'colores', 'clases-articulo', 'categorias', 'sub-categorias', 'articulos'].map(key => ({
    path: `tablas/${key}`,
    loadComponent: () =>
      import('./pages/catalogo-maestro-page/catalogo-maestro-page.component').then(
        m => m.CatalogoMaestroPageComponent,
      ),
    data: { catalogoKey: key },
  })),
  // Opciones de compras aún sin desarrollar: muestran "en construcción".
  {
    path: '**',
    loadComponent: () =>
      import('../../pages/erp-opcion-no-desarrollada/erp-opcion-no-desarrollada.component')
        .then(m => m.ErpOpcionNoDesarrolladaComponent),
  },
];
