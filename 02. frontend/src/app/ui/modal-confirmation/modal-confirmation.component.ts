import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

@Component({
  selector: 'app-modal-confirmation',
  templateUrl: './modal-confirmation.component.html',
  styleUrls: ['./modal-confirmation.component.scss'],
  standalone: false
})
export class ModalConfirmationComponent implements OnInit {
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

  constructor(private modalController: ModalController) {}

  ngOnInit() {}

  cerrarModal(opcion?: boolean): void {
    void this.modalController.dismiss(opcion);
  }
}
