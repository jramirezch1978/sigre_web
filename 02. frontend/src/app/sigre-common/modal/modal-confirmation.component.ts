import { Component, Input, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule, ModalController } from '@ionic/angular';
import { SigreMetoxiModalActionsComponent } from './metoxi-modal-actions.component';
import { SigreMetoxiModalShellComponent } from './metoxi-modal-shell.component';

@Component({
  selector: 'app-modal-confirmation',
  standalone: true,
  imports: [CommonModule, IonicModule, SigreMetoxiModalShellComponent, SigreMetoxiModalActionsComponent],
  templateUrl: './modal-confirmation.component.html',
  styleUrls: ['./modal-confirmation.component.scss'],
})
export class ModalConfirmationComponent {
  private readonly modalController = inject(ModalController);

  @Input() titlemodal = 'Confirmar validación';
  @Input() title = '';
  @Input() message = '';
  @Input() submessage = '';
  @Input() btnCancelTxt = '';
  @Input() tipemodal = '';
  @Input() btnOkTxt = '';
  @Input() isDelete = false;
  @Input() isConfirmation = false;
  @Input() isWarning = false;
  @Input() isIniciar = false;
  @Input() isDeleteTarea = false;
  @Input() isWarningEvi = false;

  cerrarModal(opcion?: boolean): void {
    void this.modalController.dismiss(opcion);
  }
}
