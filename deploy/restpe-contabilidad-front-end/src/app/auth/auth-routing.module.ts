import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { SignInComponent } from './pages/signin/signin.component';
import { SeleccionRazonSocialComponent } from './pages/seleccion-razon-social/seleccion-razon-social.component';
import { SesionNoValidaGuard } from './guards/sesion-no-valida.guard';
import { CanDeactivateGuard } from './guards/can-deactivate.guard';
import { authGuard } from '../core/guards/auth.guard';

const routes: Routes = [
  {
    path: '',
    redirectTo: 'signin',
    pathMatch: 'full'
  },
  {
    path: 'signin',
    component: SignInComponent,
    canActivate: [SesionNoValidaGuard]
  },
  {
    path: 'seleccion-razon-social',
    component: SeleccionRazonSocialComponent,
    canActivate: [authGuard],
    canDeactivate: [CanDeactivateGuard]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AuthRoutingModule { }
