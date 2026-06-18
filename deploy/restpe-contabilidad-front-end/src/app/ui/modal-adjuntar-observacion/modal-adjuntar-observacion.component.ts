import { Component, OnInit, Input } from '@angular/core';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faCircleInfo, faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-adjuntar-observacion',
  templateUrl: './modal-adjuntar-observacion.component.html',
  styleUrls: ['./modal-adjuntar-observacion.component.scss'],
  standalone: false,
})
export class ModalAdjuntarObservacionComponent implements OnInit {
  // Font Awesome Icons
  farCircleInfo = faCircleInfo;
  farXmark = faXmark;


  @Input() titulo: string = 'Adjuntar observación';
  @Input() observacionActual: string = '';
  @Input() placeholder: string = 'Escriba aquí...';
  @Input() readonly: boolean = false;

  observacion: string = '';

  constructor(private modalController: ModalController) {}

  ngOnInit() {
    this.observacion = this.observacionActual || '';
  }

  cancelar() {
    this.modalController.dismiss(null, 'cancelar');
  }

  aplicar() {
    this.modalController.dismiss(
      { observacion: this.observacion },
      'aplicar'
    );
  }
}
