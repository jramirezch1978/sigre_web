import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faCirclePlus, faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-agregar-centro',
  templateUrl: './modal-agregar-centro.component.html',
  styleUrls: ['./modal-agregar-centro.component.scss'],
  standalone: false,
})


export class ModalAgregarCentroComponent  implements OnInit {
  // Font Awesome Icons
  farCirclePlus = faCirclePlus;
  farXmark = faXmark;



  CentroCostoForm: FormGroup;
  centroCostoSeleccionado: any = null;

  // Array de centros de costos
  centrosCostos = [
    { codigo: 'AC01', nombre: 'AC01 - Administración', porcentaje: '10%' },
    { codigo: 'AC02', nombre: 'AC02 - Ventas', porcentaje: '10%' },
    { codigo: 'AC03', nombre: 'AC03 - Producción', porcentaje: '10%' },
    { codigo: 'AC04', nombre: 'AC04 - Logística', porcentaje: '10%' },
    { codigo: 'AC05', nombre: 'AC05 - Finanzas', porcentaje: '10%' }
  ];

  constructor(
    private fb: FormBuilder,
    private modalController: ModalController
  ) {
    this.CentroCostoForm = this.fb.group({
      centroCosto: ['', Validators.required],
      porcentajeDistribucion: ['', Validators.required]
    });
  }

  ngOnInit() {
    console.log('Modal agregar centro de costo inicializado');
  }

  dismissModal() {
    console.log('Cerrando modal sin guardar');
    this.modalController.dismiss();
  }

  onCentroCostoSeleccionado(evento: any) {
    console.log('Centro de costo seleccionado:', evento);
    this.centroCostoSeleccionado = evento;
    if (evento && evento.porcentaje) {
      this.CentroCostoForm.patchValue({
        centroCosto: evento.nombre,
        porcentajeDistribucion: evento.porcentaje
      });
    }
  }

  guardarAccesorio() {
    console.log('Guardar centro de costo:', this.CentroCostoForm.value);
    if (this.CentroCostoForm.valid) {
      const datosParaEnviar = {
        centroCosto: this.centroCostoSeleccionado?.nombre || this.CentroCostoForm.value.centroCosto,
        porcentajeDistribucion: this.CentroCostoForm.value.porcentajeDistribucion
      };
      console.log('Enviando datos al componente padre:', datosParaEnviar);
      this.modalController.dismiss(datosParaEnviar);
    } else {
      console.log('Formulario inválido');
    }
  }

}
