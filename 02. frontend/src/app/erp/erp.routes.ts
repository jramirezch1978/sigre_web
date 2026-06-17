import { Routes } from '@angular/router';
import { erpSessionGuard } from './guards/erp-session.guard';

export const erpRoutes: Routes = [
  {
    path: '',
    canActivate: [erpSessionGuard],
    children: [
      { path: '', redirectTo: 'inicio', pathMatch: 'full' },
      {
        path: 'inicio',
        loadComponent: () =>
          import('./pages/erp-inicio/erp-inicio.component').then(m => m.ErpInicioComponent),
      },
    ],
  },
];
