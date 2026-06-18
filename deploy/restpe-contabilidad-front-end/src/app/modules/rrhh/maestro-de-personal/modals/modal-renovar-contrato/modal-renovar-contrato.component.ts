import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faEye } from '@fortawesome/pro-regular-svg-icons';
import { faArrowsRotate, faXmark } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-modal-renovar-contrato',
  templateUrl: './modal-renovar-contrato.component.html',
  styleUrls: ['./modal-renovar-contrato.component.scss'],
  standalone:false,
})
export class ModalRenovarContratoComponent  implements OnInit {
  // Font Awesome Icons
  farEye = faEye;
  fasArrowsRotate = faArrowsRotate;
  fasXmark = faXmark;



  @Input() data: any = [];
  esVista: boolean = false;
  @Input() tipos: any = [];
  contrato: File | null = null;

  formulario!: FormGroup;


  constructor(
    private modalController: ModalController,
    private formBuilder: FormBuilder
  ) {}

  ngOnInit() {
    this.crearFormulario();
    if(this.data){
      this.esVista = true;
      this.llenarFormulario()
    }
  }

  crearFormulario() {
    this.formulario = this.formBuilder.group({
      tipo: ['', [Validators.required]],
      fechaI: [new Date(), [Validators.required]],
      fechaF: [new Date(), [Validators.required]],
      remuneracion: ['', Validators.required],
      doct: [''],
      motivo: ['', Validators.required,]
    });
  }
  llenarFormulario(){
    const datos = this.data;
    this.formulario.patchValue({
      tipo: datos.tipo || '',
      // fechaI: new Date(datos.fechaI),
      // fechaF: new Date(datos.fechaF),
      remuneracion: datos.remuneracion,
      doct: datos.doct || '',
      motivo: datos.motivo,
    });
    this.formulario.disable();
  } 

  onContratoSelected(file: File) {
    this.contrato = file;
    console.log('Contrato seleccionado:', file.name);
  }

  onContratoRemoved() {
    this.contrato = null;
    console.log('Contrato removido');
  }

  showFileError(errorMessage: string) {
    console.error('Error de archivo:', errorMessage);
    // Aquí puedes mostrar un toast o mensaje de error al usuario
  }

  registrarContrato() {
    if (this.formulario.valid) {
      this.modalController.dismiss(this.formulario.value);
    }
  }

  closemodal() {
    this.modalController.dismiss();
  }

}
