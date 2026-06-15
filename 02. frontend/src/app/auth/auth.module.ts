import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { IonicModule } from '@ionic/angular';

import { AuthRoutingModule } from './auth-routing.module';
import { SignInComponent } from './pages/signin/signin.component';
import { SeleccionRazonSocialComponent } from './pages/seleccion-razon-social/seleccion-razon-social.component';

// Servicios
import { AuthService } from './services/auth.service';

// Guards
import { SesionValidaGuard } from './guards/sesion-valida.guard';
import { SesionNoValidaGuard } from './guards/sesion-no-valida.guard';
import { AdminUiModule } from '../ui/admin-ui.module';
import { VerificacionContraseniaComponent } from './components/verificacion-contrasenia/verificacion-contrasenia.component';

@NgModule({
  declarations: [
    SignInComponent,
    SeleccionRazonSocialComponent,
    VerificacionContraseniaComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    IonicModule,
    AuthRoutingModule,
    AdminUiModule
  ],
  providers: [
    AuthService,
    SesionValidaGuard,
    SesionNoValidaGuard,
  ],
  schemas: [CUSTOM_ELEMENTS_SCHEMA]
})
export class AuthModule { }
