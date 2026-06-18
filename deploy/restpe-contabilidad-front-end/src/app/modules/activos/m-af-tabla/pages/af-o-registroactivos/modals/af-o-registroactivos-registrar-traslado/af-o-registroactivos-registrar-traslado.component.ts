import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-af-o-registroactivos-registrar-traslado',
  templateUrl: './af-o-registroactivos-registrar-traslado.component.html',
  styleUrls: ['./af-o-registroactivos-registrar-traslado.component.scss'],
  standalone: false,
})
export class AfORegistroactivosRegistrarTrasladoComponent implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;


  
  trasladoForm: FormGroup;
  fechaProgramada: Date = new Date();

  // Datos de ejemplo para los autocomplete
  responsables = [
    { id: 1, nombre: 'Juan Pérez' },
    { id: 2, nombre: 'María García' },
    { id: 3, nombre: 'Carlos López' },
  ];

  destinos = [
    { id: 1, nombre: 'Almacén Central' },
    { id: 2, nombre: 'Sucursal Norte' },
    { id: 3, nombre: 'Sucursal Sur' },
  ];

  solicitantes = [
    { id: 1, nombre: 'Pedro Martínez' },
    { id: 2, nombre: 'Ana Rodríguez' },
    { id: 3, nombre: 'Luis Fernández' },
  ];

  constructor(
    private modalController: ModalController,
    private formBuilder: FormBuilder
  ) {
    this.trasladoForm = this.formBuilder.group({
      responsable: [null, Validators.required],
      destino: [null, Validators.required],
      solicitante: [null, Validators.required],
      fechaProgramada: [this.fechaProgramada, Validators.required],
      observaciones: ['']
    });
  }

  ngOnInit() {}

  dismissModal() {
    this.modalController.dismiss();
  }

  onResponsableSeleccionado(responsable: any) {
    this.trasladoForm.patchValue({ responsable: responsable });
  }

  onDestinoSeleccionado(destino: any) {
    this.trasladoForm.patchValue({ destino: destino });
  }

  onSolicitanteSeleccionado(solicitante: any) {
    this.trasladoForm.patchValue({ solicitante: solicitante });
  }

  onFechaProgramada(fecha: Date) {
    this.fechaProgramada = fecha;
    this.trasladoForm.patchValue({ fechaProgramada: fecha });
  }

  registrarTraslado() {
    if (this.trasladoForm.valid) {
      this.modalController.dismiss({
        traslado: this.trasladoForm.value
      });
    }
  }
}
