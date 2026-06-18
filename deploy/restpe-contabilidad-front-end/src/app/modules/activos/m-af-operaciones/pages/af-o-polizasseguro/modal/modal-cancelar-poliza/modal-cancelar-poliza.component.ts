import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-cancelar-poliza',
  templateUrl: './modal-cancelar-poliza.component.html',
  styleUrls: ['./modal-cancelar-poliza.component.scss'],
  standalone: false
})
export class ModalCancelarPolizaComponent implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;



  @Input() poliza: any;
  motivoCancelacion: string = 'Describe el motivo de la cancelación de la póliza.';

  constructor(
    private modalController: ModalController
  ) { }

  ngOnInit() {
    console.log('Póliza recibida:', this.poliza);
  }

  cerrarModal() {
    this.modalController.dismiss();
  }

  cancelarPoliza() {
    if (this.motivoCancelacion.trim() === '') {
      // Podríamos agregar validación aquí
      return;
    }
    
    this.modalController.dismiss({
      cancelada: true,
      motivo: this.motivoCancelacion
    });
  }

}
