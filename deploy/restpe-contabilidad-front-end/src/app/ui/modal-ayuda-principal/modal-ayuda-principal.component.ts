import { Component, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faCalendar, faCircleQuestion, faEnvelope, faInfoCircle, faMessages, faPhoneArrowUp } from '@fortawesome/pro-regular-svg-icons';
import { faArrowUpRightFromSquare, faPhone, faXmark } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-modal-ayuda-principal',
  templateUrl: './modal-ayuda-principal.component.html',
  styleUrls: ['./modal-ayuda-principal.component.scss'],
  standalone: false,
})
export class ModalAyudaPrincipalComponent  implements OnInit {
  // Font Awesome Icons
  farCalendar = faCalendar;
  farCircleQuestion = faCircleQuestion;
  farEnvelope = faEnvelope;
  farInfoCircle = faInfoCircle;
  farMessages = faMessages;
  farPhoneArrowUp = faPhoneArrowUp;
  fasArrowUpRightFromSquare = faArrowUpRightFromSquare;
  fasPhone = faPhone;
  fasXmark = faXmark;


  modalidadSeleccionada: string = 'inmediata';
  metodoContactoSeleccionado: string = 'llamada';
  metodoAsesoriaSeleccionado: string = 'correo';

  constructor(private modalController: ModalController) { }

  ngOnInit() {}

  seleccionarModalidad(modalidad: string) {
    this.modalidadSeleccionada = modalidad;
    console.log('Modalidad de ayuda seleccionada:', modalidad);
  }

  seleccionarMetodoContacto(metodo: string) {
    this.metodoContactoSeleccionado = metodo;
    console.log('Método de contacto seleccionado:', metodo);
  }
  seleccionarAsesoriaSeleccionado(asesoria: string) {
    this.metodoAsesoriaSeleccionado=asesoria
  }
  cerrarmodal(){
    this.modalController.dismiss();
  }
}
