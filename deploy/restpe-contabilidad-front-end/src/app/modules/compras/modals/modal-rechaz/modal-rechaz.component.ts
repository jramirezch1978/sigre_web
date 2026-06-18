import { Component, OnInit } from '@angular/core';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-rechaz',
  templateUrl: './modal-rechaz.component.html',
  styleUrls: ['./modal-rechaz.component.scss'],
  standalone: false,
})
export class ModalRechazComponent  implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;



  constructor() { }

  ngOnInit() {}

}
