import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { IonicModule } from '@ionic/angular';

import { ApartadoNotificacionesPageRoutingModule } from './apartado-notificaciones-routing.module';

import { ApartadoNotificacionesPage } from './apartado-notificaciones.page';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { UiModule } from 'src/app/ui/ui.module';

@NgModule({
  imports: [
    CommonModule,
    ReactiveFormsModule,
    FormsModule,
    IonicModule,
    UiModule,
    FontAwesomeModule,
    ReactiveFormsModule,
    ApartadoNotificacionesPageRoutingModule
  ],
  declarations: [ApartadoNotificacionesPage]
})
export class ApartadoNotificacionesPageModule {}
