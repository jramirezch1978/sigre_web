import { Component, OnInit } from '@angular/core';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-aprobar',
  templateUrl: './modal-aprobar.component.html',
  styleUrls: ['./modal-aprobar.component.scss'],
  standalone: false,
})
export class ModalAprobarComponent  implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;



  constructor() { }

  ngOnInit() {}

}
