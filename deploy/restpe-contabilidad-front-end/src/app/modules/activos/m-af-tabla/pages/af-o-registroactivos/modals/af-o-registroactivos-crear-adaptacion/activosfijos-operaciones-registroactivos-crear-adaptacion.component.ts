import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faCirclePlus, faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-activosfijos-operaciones-registroactivos-crear-adaptacion',
  templateUrl: './activosfijos-operaciones-registroactivos-crear-adaptacion.component.html',
  styleUrls: ['./activosfijos-operaciones-registroactivos-crear-adaptacion.component.scss'],
  standalone: false,
})
export class ActivosfijosOperacionesRegistroactivosCrearAdaptacionComponent implements OnInit {
  // Font Awesome Icons
  farCirclePlus = faCirclePlus;
  farXmark = faXmark;


  selectedDate: Date = new Date();
  minDate: Date = new Date(2020, 0, 1);
  maxDate: Date = new Date();
  adaptacionForm: FormGroup;

  constructor(
    private modalController: ModalController,
    private formBuilder: FormBuilder
  ) {
    this.adaptacionForm = this.formBuilder.group({
      fechaAdaptacion: ['', Validators.required],
      descripcion: ['', Validators.required],
      valorIncremental: ['', Validators.required],
      responsable: ['', Validators.required]
    });
  }

  ngOnInit() {}

  dismissModal() {
    this.modalController.dismiss();
  }

  guardarAdaptacion() {
    // Usar getRawValue para incluir campos deshabilitados
    this.modalController.dismiss({
      adaptacion: this.adaptacionForm.getRawValue()
    });
  }
  guardarFecha(date: Date) {
    console.log('Guardando:', date);
    this.adaptacionForm.get('fechaAdaptacion')?.setValue(date);
  }
}
