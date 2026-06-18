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
    path: '',
    canActivate: [erpSessionGuard],
    children: [
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
      {
        path: 'dashboard',
        loadComponent: () =>
          import('./pages/erp-inicio/erp-inicio.component').then(m => m.ErpInicioComponent),
      },
    ],
  },
];
