import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faFaceWorried, faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-alert',
  templateUrl: './alert.component.html',
  styleUrls: ['./alert.component.scss'],
  standalone: false
})
export class AlertComponent  implements OnInit {
  // Font Awesome Icons
  farFaceWorried = faFaceWorried;
  farXmark = faXmark;


  
  @Input() title: string = '';
  @Input() mensaje: string = '';
  @Input() confirmText: string = '';
  @Input() cancelText: string = '';
  @Input() type: 'alert' | 'warning' | 'error' = 'alert';
  @Input() botonDoble?: Boolean;
  @Input() soloConf?: Boolean;

  constructor(
    public modalController :ModalController,
  ) { }

  ngOnInit() {
    this.botonDoble = this.botonDoble ?? false;
    this.soloConf = this.soloConf ?? false;
  }

  closeModal(valor: boolean) {
    this.modalController.dismiss(valor);

  }
}


