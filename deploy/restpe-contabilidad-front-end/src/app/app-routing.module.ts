import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LayoutComponent } from './layout/components/layout-wrapper/layout.component';
import { sessionCompleteGuard } from './core/guards/session-complete.guard';

const routes: Routes = [
  {
    path: '',
    redirectTo: '/auth/signin',
    pathMatch: 'full',
  },
  {
    path: 'auth',
    loadChildren: () => import('./auth/auth.module').then(m => m.AuthModule),
  },
  {
    path: 'admin',
    loadChildren: () => import('./admin/admin.module').then(m => m.AdminModule),
  },
  {
    path: '',
    component: LayoutComponent,
    canActivate: [sessionCompleteGuard],
    canActivateChild: [sessionCompleteGuard],
    children: [
      {
        path: '',
        loadChildren: () =>
          import('./modules/modules.module').then(m => m.ModulesModule),
      },
    ],
  },
  {
    path: '**',
    loadComponent: () =>
      import('./ui/page-not-found/page-not-found.component').then(m => m.PageNotFoundComponent),
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
