import { Component, OnInit } from '@angular/core';
import { faArrowUpRightAndArrowDownLeftFromCenter, faPaperPlaneTop, faXmark } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-apartado-ia',
  templateUrl: './apartado-ia.page.html',
  styleUrls: ['./apartado-ia.page.scss'],
  standalone: false,
})
export class ApartadoIaPage implements OnInit {
  faArrowUpRightAndArrowDownLeftFromCenter= faArrowUpRightAndArrowDownLeftFromCenter;
  faXmark = faXmark;
  faPaperPlaneTop= faPaperPlaneTop;  
  constructor() {}

  ngOnInit(): void {}
}
