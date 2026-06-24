import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { IonicModule } from '@ionic/angular';

import { AuthRoutingModule } from './auth-routing.module';
import { SignInComponent } from './pages/signin/signin.component';
import { SeleccionRazonSocialComponent } from './pages/seleccion-razon-social/seleccion-razon-social.component';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatIconModule } from '@angular/material/icon';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';

// Servicios
import { AuthService } from './services/auth.service';

// Guards
import { SesionValidaGuard } from './guards/sesion-valida.guard';
import { SesionNoValidaGuard } from './guards/sesion-no-valida.guard';
import { AdminUiModule } from '../ui/admin-ui.module';
import { VerificacionContraseniaComponent } from './components/verificacion-contrasenia/verificacion-contrasenia.component';
import { SigreValidatedFieldComponent } from '@sigre-common';

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
    HttpClientModule,
    IonicModule,
    AuthRoutingModule,
    AdminUiModule,
    MatButtonModule,
    MatFormFieldModule,
    MatInputModule,
    MatIconModule,
    MatCheckboxModule,
    MatProgressSpinnerModule,
    SigreValidatedFieldComponent,
  ],
  providers: [
    AuthService,
    SesionValidaGuard,
    SesionNoValidaGuard,
  ],
  schemas: [CUSTOM_ELEMENTS_SCHEMA]
})
export class AuthModule { }
