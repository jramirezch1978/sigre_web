import { Routes } from '@angular/router';
import { erpSessionGuard } from './guards/erp-session.guard';

export const erpRoutes: Routes = [
  {
    path: 'inicio',
    loadComponent: () =>
      import('./pages/erp-landing/erp-landing.component').then(m => m.ErpLandingComponent),
  },
  {
    path: 'registro',
    loadComponent: () =>
      import('./pages/erp-registro-demo/erp-registro-demo.component').then(m => m.ErpRegistroDemoComponent),
  },
  {
    path: 'modulo/:codigo',
    loadComponent: () =>
      import('./pages/erp-modulo-detalle/erp-modulo-detalle.component').then(m => m.ErpModuloDetalleComponent),
  },
  {
    path: 'politicas-seguridad',
    loadComponent: () =>
      import('./pages/erp-politicas-seguridad/erp-politicas-seguridad.component')
        .then(m => m.ErpPoliticasSeguridadComponent),
  },
  {
    path: '',
    canActivate: [erpSessionGuard],
    loadComponent: () =>
      import('./pages/erp-inicio/erp-inicio.component').then(m => m.ErpInicioComponent),
    children: [
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
      {
        path: 'dashboard',
        loadComponent: () =>
          import('./pages/erp-dashboard/erp-dashboard.component').then(m => m.ErpDashboardComponent),
      },
      {
        path: 'm/:codigo',
        loadComponent: () =>
          import('./pages/erp-module-home/erp-module-home.component').then(m => m.ErpModuleHomeComponent),
      },
      {
        path: 'almacen',
        loadChildren: () =>
          import('./modules/almacen/almacen.routes').then(m => m.almacenRoutes),
      },
      {
        path: 'compras',
        loadChildren: () =>
          import('./modules/compras/compras.routes').then(m => m.comprasRoutes),
      },
      {
        path: 'seguridad-usuarios',
        loadComponent: () =>
          import('./pages/erp-seguridad-usuarios/erp-seguridad-usuarios.component')
            .then(m => m.ErpSeguridadUsuariosComponent),
      },
      // Cualquier opción del ERP sin ruta desarrollada cae aquí (NO a la landing pública).
      {
        path: '**',
        loadComponent: () =>
          import('./pages/erp-opcion-no-desarrollada/erp-opcion-no-desarrollada.component')
            .then(m => m.ErpOpcionNoDesarrolladaComponent),
      },
    ],
  },
];
