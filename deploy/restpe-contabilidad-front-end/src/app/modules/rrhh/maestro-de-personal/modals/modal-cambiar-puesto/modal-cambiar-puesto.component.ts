import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faEye } from '@fortawesome/pro-regular-svg-icons';
import { faArrowsRotate, faXmark } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-modal-cambiar-puesto',
  templateUrl: './modal-cambiar-puesto.component.html',
  styleUrls: ['./modal-cambiar-puesto.component.scss'],
  standalone:false,
})
export class ModalCambiarPuestoComponent  implements OnInit {
  // Font Awesome Icons
  farEye = faEye;
  fasArrowsRotate = faArrowsRotate;
  fasXmark = faXmark;



  @Input() data: any = [];

  esVista: boolean = false;
  
  @Input() centrosCostos: any = [];
  @Input() cargos: any = [];
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
    console.log('Cargos recibidos en el modal:', this.cargos);
  }

  crearFormulario() {
    this.formulario = this.formBuilder.group({
      nuevoCargo: ['', [Validators.required]],
      centroCosto: ['', [Validators.required]],
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
      nuevoCargo: datos.nuevoCargo || '',
      centroCosto: datos.centroCosto || '',
      // fechaI: new Date(datos.fechaI),
      // fechaF: new Date(datos.fechaF),
      remuneracion: datos.remuneracion,
      doct: datos.doct || '',
      motivo: datos.motivo,
    });
    this.formulario.disable();
  }

  onCentroCostoSeleccionado(evento: any) {
    this.formulario.patchValue({
      centroCosto: evento.nombre
    });
  }

  onCargoSeleccionado(evento: any) {
    this.formulario.patchValue({
      nuevoCargo: evento.nombre
    });
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