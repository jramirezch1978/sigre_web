import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faFileLines } from '@fortawesome/pro-light-svg-icons';
import { faXmark } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-modal-ver-documento',
  templateUrl: './modal-ver-documento.component.html',
  styleUrls: ['./modal-ver-documento.component.scss'],
  standalone: false,
})
export class ModalVerDocumentoComponent  implements OnInit {
  // Font Awesome Icons
  falFileLines = faFileLines;
  fasXmark = faXmark;



  @Input() titulo: string = '';

  constructor(private modalController: ModalController) { }

  ngOnInit() {}

  closemodal() {
    this.modalController.dismiss();
  }

}
