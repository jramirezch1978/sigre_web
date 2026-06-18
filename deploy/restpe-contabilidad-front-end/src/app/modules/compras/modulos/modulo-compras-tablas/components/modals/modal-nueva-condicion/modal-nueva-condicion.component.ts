import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { CondicionPagoFacade } from 'src/app/modules/compras/application/facades/condicion-pago.facade';
import { CondicionPagoEntity } from 'src/app/modules/compras/domain/models/condicion-pago.entity';

// Font Awesome Icons
import { faCirclePlus, faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-nueva-condicion',
  templateUrl: './modal-nueva-condicion.component.html',
  styleUrls: ['./modal-nueva-condicion.component.scss'],
  standalone: false,
})
export class ModalNuevaCondicionComponent  implements OnInit {
  // Font Awesome Icons
  farCirclePlus = faCirclePlus;
  farXmark = faXmark;

  private readonly condicionPagoFacade = inject(CondicionPagoFacade);

  CondicionesPagoForm!: FormGroup;

  constructor(
    private modalCtrl: ModalController,
    private fb : FormBuilder,
  ) { }

  ngOnInit() {
    this.CondicionesPagoForm = this.fb.group({
      nombre: [''],
      tipoCondicion: [''],
      plazopagos: [''],
      cuotas: [''],
      periocidadCuotas: [''],
      descripcion: [''],
      estado: ['Activo'],
    });
  }

  cerrar() {
    this.modalCtrl.dismiss();
  }
  botonGuardar() {
    const formValues = this.CondicionesPagoForm.value;

    if (!formValues.nombre?.trim() || !formValues.tipoCondicion?.trim()) {
      return;
    }

    const condicionPago: CondicionPagoEntity = {
      condicion_pago_codigo: '',
      condicion_pago_nombre: formValues.nombre,
      condicion_pago_tipo: formValues.tipoCondicion,
      condicion_pago_plazo: formValues.plazopagos || '',
      condicion_pago_cuotas: formValues.cuotas || '',
      condicion_pago_periodicidad_cuotas: formValues.periocidadCuotas || '',
      condicion_pago_descripcion: formValues.descripcion || '',
      condicion_pago_estado: formValues.estado || 'Activo'
    };

    this.condicionPagoFacade.guardarCondicionPago(condicionPago);

    this.modalCtrl.dismiss(true);
  }

}
