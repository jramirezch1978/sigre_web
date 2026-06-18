import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-editar-factor',
  templateUrl: './modal-editar-factor.component.html',
  styleUrls: ['./modal-editar-factor.component.scss'],
  standalone: false,
})
export class ModalEditarFactorComponent implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;


  @Input() centrosCosto: any[] = [];
  
  centroSeleccionado: any = null;
  factorTemporal: number = 0;

  constructor(private modalController: ModalController) {}

  ngOnInit() {
    // Inicialización si es necesaria
  }

  cerrarModal() {
    this.modalController.dismiss();
  }

  onCentroSeleccionado(centro: any) {
    if (centro) {
      this.centroSeleccionado = centro;
      this.factorTemporal = centro.centro_costo_factor || 0;
    } else {
      this.centroSeleccionado = null;
      this.factorTemporal = 0;
    }
  }

  guardar() {
    if (!this.centroSeleccionado) {
      return;
    }

    // Validar que el factor esté entre 0 y 100
    let factor = this.factorTemporal;
    if (factor < 0) factor = 0;
    if (factor > 100) factor = 100;

    this.modalController.dismiss({
      action: 'guardar',
      centro: {
        ...this.centroSeleccionado,
        factor: factor
      }
    });
  }
}
