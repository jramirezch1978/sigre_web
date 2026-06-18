import { Component, OnInit } from '@angular/core';
import { faArrowUpRightAndArrowDownLeftFromCenter, faPaperPlane, faPaperPlaneTop, faXmark } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-chat-ia',
  templateUrl: './chat-ia.component.html',
  styleUrls: ['./chat-ia.component.scss'],
  standalone:false,
})
export class ChatIaComponent  implements OnInit {
  faArrowUpRightAndArrowDownLeftFromCenter= faArrowUpRightAndArrowDownLeftFromCenter;
  faXmark = faXmark;
  faPaperPlaneTop= faPaperPlaneTop;
  clase='hidden';
  constructor() { }

  ngOnInit() {}
  mostarchat(mostrar: boolean) : string  {
    if(mostrar === true){
    return this.clase='animacion-chat';
    }
    else if(mostrar === false){
      return this.clase='animacion-esconder-chat';
    }
    return this.clase='invisible';
  }
}
