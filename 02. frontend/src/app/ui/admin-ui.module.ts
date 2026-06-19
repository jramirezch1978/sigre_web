import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { ModalConfirmationComponent } from '@sigre-common';
import { ToastContainerComponent } from './toast-container/toast-container.component';
import { SearchableSelectComponent } from './searchable-select/searchable-select.component';
import { SearchableSelectModalComponent } from './searchable-select/searchable-select-modal.component';

/** UI mínima para consola admin y auth (sin dependencias del ERP RESTPE). */
@NgModule({
  declarations: [
    ToastContainerComponent,
    SearchableSelectComponent,
    SearchableSelectModalComponent,
  ],
  imports: [CommonModule, FormsModule, IonicModule, ModalConfirmationComponent],
  exports: [
    ModalConfirmationComponent,
    ToastContainerComponent,
    SearchableSelectComponent,
  ],
})
export class AdminUiModule {}
