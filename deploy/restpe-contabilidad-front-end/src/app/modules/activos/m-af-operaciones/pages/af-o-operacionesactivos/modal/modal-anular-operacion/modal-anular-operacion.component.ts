import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-modal-anular-operacion',
  templateUrl: './modal-anular-operacion.component.html',
  styleUrls: ['./modal-anular-operacion.component.scss'],
  standalone: false
})
export class ModalAnularOperacionComponent implements OnInit {
  // Font Awesome Icons
  fasXmark = faXmark;



  @Input() operacion: any;
  motivoAnulacion: string = '';

  constructor(
    private modalController: ModalController
  ) { }

  ngOnInit() {
    console.log('Operación recibida:', this.operacion);
  }

  cerrarModal() {
    this.modalController.dismiss();
  }

  anularOperacion() {
    if (this.motivoAnulacion.trim() === '') {
      // Validación: motivo es requerido
      return;
    }
    
    this.modalController.dismiss({
      anulada: true,
      motivo: this.motivoAnulacion
    });
  }

}
