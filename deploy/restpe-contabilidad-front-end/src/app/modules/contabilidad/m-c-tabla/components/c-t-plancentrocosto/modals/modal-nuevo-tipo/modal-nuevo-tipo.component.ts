import { Component, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-nuevo-tipo',
  templateUrl: './modal-nuevo-tipo.component.html',
  styleUrls: ['./modal-nuevo-tipo.component.scss'],
  standalone: false,
})
export class ModalNuevoTipoComponent implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;


  nuevoTipo: string = '';

  constructor(private modalController: ModalController) {}

  ngOnInit() {}

  cerrarModal() {
    this.modalController.dismiss();
  }

  guardar() {
    if (!this.nuevoTipo.trim()) {
      return;
    }
    this.modalController.dismiss({
      action: 'guardar',
      nuevoTipo: this.nuevoTipo
    });
  }
}
