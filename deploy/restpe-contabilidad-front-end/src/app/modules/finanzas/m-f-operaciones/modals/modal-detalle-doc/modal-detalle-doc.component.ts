import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';



interface detalle {
  label: string;
  value: any;
}
@Component({
  selector: 'app-modal-detalle-doc',
  templateUrl: './modal-detalle-doc.component.html',
  styleUrls: ['./modal-detalle-doc.component.scss'],
  standalone: false,
})
export class ModalDetalleDocComponent  implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;


  @Input() tituloModal: string = 'Detalle';
  @Input() detalles: detalle[] = [];
  @Input() textoBotonSecundario: string = 'Cerrar';
  @Input() textoBotonPrimario: string = 'Aceptar';
  @Input() colorBoton: string = '';
  @Input() mostrarBotonPrimario: boolean = true;


  constructor(private modalController: ModalController) { }

  ngOnInit() {
  }

  cerrarModal() {
    this.modalController.dismiss();
  }
  aplicarAccion(tipo: 'primaria' | 'secundaria') {
    this.modalController.dismiss({ accion: tipo });
  }
}
