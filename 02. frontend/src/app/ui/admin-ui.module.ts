import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { ModalConfirmationComponent } from './modal-confirmation/modal-confirmation.component';
import { ToastContainerComponent } from './toast-container/toast-container.component';

/** UI mínima para consola admin y auth (sin dependencias del ERP RESTPE). */
@NgModule({
  declarations: [ModalConfirmationComponent, ToastContainerComponent],
  imports: [CommonModule, IonicModule],
  exports: [ModalConfirmationComponent, ToastContainerComponent],
})
export class AdminUiModule {}
