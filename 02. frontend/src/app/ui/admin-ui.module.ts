import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { ModalConfirmationComponent } from './modal-confirmation/modal-confirmation.component';
import { ToastContainerComponent } from './toast-container/toast-container.component';
import { SearchableSelectComponent } from './searchable-select/searchable-select.component';
import { SearchableSelectModalComponent } from './searchable-select/searchable-select-modal.component';

/** UI mínima para consola admin y auth (sin dependencias del ERP RESTPE). */
@NgModule({
  declarations: [
    ModalConfirmationComponent,
    ToastContainerComponent,
    SearchableSelectComponent,
    SearchableSelectModalComponent,
  ],
  imports: [CommonModule, FormsModule, IonicModule],
  exports: [
    ModalConfirmationComponent,
    ToastContainerComponent,
    SearchableSelectComponent,
  ],
})
export class AdminUiModule {}
