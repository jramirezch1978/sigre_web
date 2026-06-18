import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';

// Font Awesome Icons
import { faCircleXmark, faXmark } from '@fortawesome/pro-regular-svg-icons';
import { faArrowTrendUp } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-af-o-registroactivos-revaluar',
  templateUrl: './af-o-registroactivos-revaluar.component.html',
  styleUrls: ['./af-o-registroactivos-revaluar.component.scss'],
  standalone: false,
})
export class AfORegistroactivosRevaluarComponent implements OnInit {
  // Font Awesome Icons
  farCircleXmark = faCircleXmark;
  farXmark = faXmark;
  fasArrowTrendUp = faArrowTrendUp;


  
  revaluacionForm: FormGroup;
  fechaRevaluacion: Date = new Date();

  tiposRevaluacion = [
    { id: 1, nombre: 'Revaluación técnica' },
    { id: 2, nombre: 'Revaluación comercial' },
    { id: 3, nombre: 'Ajuste por inflación' },
  ];

  fuentesRevaluacion = [
    { id: 1, nombre: 'Tasación externa' },
    { id: 2, nombre: 'Índice de precios' },
    { id: 3, nombre: 'Valor de mercado' },
  ];

  monedas = [
    { id: 'Soles', nombre: 'Soles' },
    { id: 'Dólares', nombre: 'Dólares' },
  ];

  responsables = [
    { id: 1, nombre: 'Usuario' },
    { id: 2, nombre: 'Valuador externo' },
    { id: 3, nombre: 'Contador' },
  ];

  constructor(
    private modalController: ModalController,
    private formBuilder: FormBuilder,
    private toastService: ToastService
  ) {
    this.revaluacionForm = this.formBuilder.group({
      tipoRevaluacion: [null, Validators.required],
      fechaRevaluacion: [this.fechaRevaluacion, Validators.required],
      fuenteRevaluacion: [null, Validators.required],
      factorRevaluacion: ['', Validators.required],
      nuevoValor: ['', Validators.required],
      moneda: [null, Validators.required],
      documentoSoporte: ['', Validators.required],
      responsable: [null, Validators.required]
    });
  }

  ngOnInit() {}

  dismissModal() {
    this.modalController.dismiss();
  }

  onTipoRevaluacionSeleccionado(event: any) {
    this.revaluacionForm.patchValue({ tipoRevaluacion: event.detail.value });
  }

  onFuenteRevaluacionSeleccionada(event: any) {
    this.revaluacionForm.patchValue({ fuenteRevaluacion: event.detail.value });
  }

  onMonedaSeleccionada(event: any) {
    this.revaluacionForm.patchValue({ moneda: event.detail.value });
  }

  onResponsableSeleccionado(event: any) {
    this.revaluacionForm.patchValue({ responsable: event.detail.value });
  }

  onFechaRevaluacion(fecha: Date) {
    this.fechaRevaluacion = fecha;
    this.revaluacionForm.patchValue({ fechaRevaluacion: fecha });
  }

  subirArchivo(event: any) {
    const archivo = event.target.files[0];
    if (archivo) {
      this.revaluacionForm.patchValue({
        documentoSoporte: archivo.name
      });
      this.toastService.success('Archivo cargado exitosamente');
    }
  }

  removeFile() {
    this.revaluacionForm.patchValue({
      documentoSoporte: ''
    });
    this.toastService.success('Archivo eliminado');
  }

  confirmarRevaluacion() {
    if (this.revaluacionForm.valid) {
      this.modalController.dismiss({
        revaluacion: this.revaluacionForm.value
      });
      this.toastService.success('¡Revaluación registrada exitosamente!');
    }
  }
}
