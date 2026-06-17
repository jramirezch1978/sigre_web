import { Routes } from '@angular/router';
import { authGuard } from '../core/guards/auth.guard';

export const erpRoutes: Routes = [
  {
    path: '',
    canActivate: [authGuard],
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
