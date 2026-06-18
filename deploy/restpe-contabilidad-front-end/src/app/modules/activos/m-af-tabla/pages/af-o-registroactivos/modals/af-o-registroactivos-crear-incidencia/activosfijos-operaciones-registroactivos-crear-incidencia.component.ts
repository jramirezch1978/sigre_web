import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faCirclePlus, faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-activosfijos-operaciones-registroactivos-crear-incidencia',
  templateUrl: './activosfijos-operaciones-registroactivos-crear-incidencia.component.html',
  styleUrls: ['./activosfijos-operaciones-registroactivos-crear-incidencia.component.scss'],
  standalone: false,
})
export class ActivosfijosOperacionesRegistroactivosCrearIncidenciaComponent implements OnInit {
  // Font Awesome Icons
  farCirclePlus = faCirclePlus;
  farXmark = faXmark;


  selectedDate: Date = new Date();
  minDate: Date = new Date(2020, 0, 1);
  maxDate: Date = new Date();
  incidenciaForm: FormGroup;

  constructor(
    private modalController: ModalController,
    private formBuilder: FormBuilder
  ) {
    this.incidenciaForm = this.formBuilder.group({
      fechaIncidencia: ['', Validators.required],
      tipoIncidencia: ['', Validators.required],
      descripcion: ['', Validators.required],
      accionCorrectiva: ['', Validators.required],
      costoAsociado: ['', Validators.required],
      estado: ['', Validators.required]
    });
  }

  ngOnInit() {}

  dismissModal() {
    this.modalController.dismiss();
  }

  guardarIncidencia() {
    // Usar getRawValue para incluir campos deshabilitados
    this.modalController.dismiss({
      incidencia: this.incidenciaForm.getRawValue()
    });
  }
  guardarFecha(date: Date) {
    console.log('Guardando:', date);
    this.incidenciaForm.get('fechaIncidencia')?.setValue(date);
  }
}
