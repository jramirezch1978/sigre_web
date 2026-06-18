import { Component, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-rechazar-traslado',
  templateUrl: './modal-rechazar-traslado.component.html',
  styleUrls: ['./modal-rechazar-traslado.component.scss'],
  standalone: false,
})
export class ModalRechazarTrasladoComponent  implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;



  constructor(private modalController: ModalController) { }

  ngOnInit() {}

  dismissModal() {
    this.modalController.dismiss(false);
  }

  Rechazar(){
    this.modalController.dismiss(true);
  }
}
