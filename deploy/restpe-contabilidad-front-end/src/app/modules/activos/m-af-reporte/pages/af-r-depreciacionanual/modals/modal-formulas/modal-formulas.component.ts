import { Component, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-formulas',
  templateUrl: './modal-formulas.component.html',
  styleUrls: ['./modal-formulas.component.scss'],
  standalone: false,
})
export class ModalFormulasComponent  implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;



  constructor(
      private modalController : ModalController,
    ) { }
  
    ngOnInit() {}
  
     dismissModal() {
      this.modalController.dismiss();
    }

}
