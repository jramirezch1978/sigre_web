import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faCirclePlus, faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-activosfijos-operaciones-registroactivos-crear-accesorio',
  templateUrl: './activosfijos-operaciones-registroactivos-crear-accesorio.component.html',
  styleUrls: ['./activosfijos-operaciones-registroactivos-crear-accesorio.component.scss'],
  standalone: false,
})
export class ActivosfijosOperacionesRegistroactivosCrearAccesorioComponent implements OnInit {
  // Font Awesome Icons
  farCirclePlus = faCirclePlus;
  farXmark = faXmark;


  
  accesorioForm: FormGroup;

  monedas = [
    { value: 'Soles', label: 'Soles' },
    { value: 'USD', label: 'Dólares' },
  ];

  constructor(
    private modalController: ModalController,
    private formBuilder: FormBuilder
  ) {
    this.accesorioForm = this.formBuilder.group({
      codigoAccesorio: ['', Validators.required],
      descripcion: ['', Validators.required],
      selecciondemoneda: ['Soles', Validators.required],
      valorIndividual: ['', Validators.required],
      relacionActivo: ['', Validators.required]
    });
  }

  ngOnInit() {
    // this.accesorioForm.get('selecciondemoneda')?.disable();
  }

  dismissModal() {
    this.modalController.dismiss();
  }

  guardarAccesorio() {
    // Usar getRawValue para incluir campos deshabilitados
    this.modalController.dismiss({
      accesorio: this.accesorioForm.getRawValue()
    });
  }
}
