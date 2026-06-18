import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faExclamationTriangle, faEye } from '@fortawesome/pro-regular-svg-icons';
import { faXmark } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-modal-sancion',
  templateUrl: './modal-sancion.component.html',
  styleUrls: ['./modal-sancion.component.scss'],
  standalone:false,
})
export class ModalSancionComponent  implements OnInit {
  // Font Awesome Icons
  farExclamationTriangle = faExclamationTriangle;
  farEye = faEye;
  fasXmark = faXmark;


  @Input() data : any =[];
  esVista: boolean = false;

  tipos = [
    { value: 'amonestacion', label: 'Amonestación' },
    { value: 'suspension', label: 'Suspensión' },
    { value: 'descuento', label: 'Descuento salarial' },
    { value: 'despido', label: 'Despido' }
  ];
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
      monto: [''],
      fecha: [new Date(), [Validators.required]],
      doct: [''],
      motivo: ['', Validators.required,]
    });
  }
  llenarFormulario(){
    const datos = this.data;
    this.formulario.patchValue({
      tipo: datos.tipo || '',
      monto: datos.monto  || '',
      // fecha: new Date(datos.fecha),
      doct: datos.doct || '',
      motivo: datos.motivo,
    });
    this.formulario.disable();
  }
  
  // HABILITA EL BOTON - Valida que los campos requeridos estén llenos
  puedeGuardar(): boolean {
    const tipo = this.formulario.get('tipo')?.value;
    const fecha = this.formulario.get('fecha')?.value;
    const motivo = this.formulario.get('motivo')?.value;
    const monto = this.formulario.get('monto')?.value;

    // Si es descuento, requiere monto
    if (tipo === 'descuento') {
      return tipo && fecha && motivo && monto;
    }

    // Para otros tipos, no requiere monto
    return tipo && fecha && motivo;
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
