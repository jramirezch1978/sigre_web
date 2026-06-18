import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';

import { ApartadoIaPageRoutingModule } from './apartado-ia-routing.module';
import { UiModule } from 'src/app/ui/ui.module';
import { ApartadoIaPage } from './apartado-ia.page';

@NgModule({
  declarations: [ApartadoIaPage],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    IonicModule,
    FontAwesomeModule,
    ApartadoIaPageRoutingModule,
    UiModule,
  ],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
})
export class ApartadoIaPageModule {}
