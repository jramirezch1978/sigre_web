import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

// Font Awesome Icons
import { faScrewdriverWrench, faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-ajuste-proyeccion',
  templateUrl: './modal-ajuste-proyeccion.component.html',
  styleUrls: ['./modal-ajuste-proyeccion.component.scss'],
  standalone: false,
})
export class ModalAjusteProyeccionComponent implements OnInit {
  // Font Awesome Icons
  farScrewdriverWrench = faScrewdriverWrench;
  farXmark = faXmark;


  @Input() sucursal: string = '';
  @Input() periodo: string = '';

  ajusteForm!: FormGroup;

  tipoAjusteList = [
    { id: 'Ingreso', nombre: 'Ingreso' },
    { id: 'Egreso', nombre: 'Egreso' }
  ];

  categoriasList = [
    { id: 'Operativo', nombre: 'Operativo' },
    { id: 'Financiero', nombre: 'Financiero' },
    { id: 'Extraordinario', nombre: 'Extraordinario' },
  ];

  constructor(
    private modalController: ModalController,
    private fb: FormBuilder
  ) {}

  ngOnInit() {
    this.initForm();
  }

  initForm() {
    this.ajusteForm = this.fb.group({
      tipoAjuste: ['', Validators.required],
      categoria: [''],
      monto: ['', [Validators.required, Validators.min(0.01)]],
      motivoAjuste: ['', Validators.required]
    });
  }

  cerrarModal() {
    this.modalController.dismiss();
  }

  cancelar() {
    this.modalController.dismiss({ action: 'cancelar' });
  }

  confirmarAjuste() {
    if (this.ajusteForm.invalid) {
      // Marcar todos los campos como touched para mostrar errores
      Object.keys(this.ajusteForm.controls).forEach(key => {
        this.ajusteForm.get(key)?.markAsTouched();
      });
      return;
    }

    this.modalController.dismiss({
      action: 'confirmar',
      data: this.ajusteForm.value
    });
  }

  // Helper para validación
  isFieldInvalid(fieldName: string): boolean {
    const field = this.ajusteForm.get(fieldName);
    return !!(field && field.invalid && field.touched);
  }
}
