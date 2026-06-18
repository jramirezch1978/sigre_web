import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';



interface detalle {
  razonS: string;
  estado: string;
  proveedor?: string;
  cliente?: string;
  moneda: string;
  fechaE: string;
  montoT: string;
  fechaV: string;
  montoP: string;
  centroC: string;
  montoPend: string;
  sucursal: string;
}

@Component({
  selector: 'app-modal-detalle-doc-edit',
  templateUrl: './modal-detalle-doc-edit.component.html',
  styleUrls: ['./modal-detalle-doc-edit.component.scss'],
  standalone: false,
})
export class ModalDetalleDocEditComponent  implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;



  @Input() tituloModal: string = 'Detalle';
  @Input() detalle: detalle | null = null;
  @Input() textoBotonSecundario: string = 'Cerrar';
  @Input() textoBotonPrimario: string = 'Aceptar';
  @Input() modoEdicion: boolean = true;

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
