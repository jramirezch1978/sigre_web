import { Component, Input, OnInit } from '@angular/core';
import { AbstractControl, FormArray, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ModalCuentaBancariaComponent } from '../../modals/modal-cuenta-bancaria/modal-cuenta-bancaria.component';

// Font Awesome Icons
import { faEdit, faPlusCircle as faPlusCircleRegular, faTrashAlt } from '@fortawesome/pro-regular-svg-icons';
import { faPlusCircle as faPlusCircleSolid } from '@fortawesome/pro-solid-svg-icons';

// Font Awesome Icons

export interface CuentaBancaria {
  id?: string;
  entidadFinanciera: string;
  tipoCuenta: string;
  moneda: string;
  nroCuenta: string;
  cci: string;
}

@Component({
  selector: 'app-agregar-cuenta',
  templateUrl: './agregar-cuenta.component.html',
  styleUrls: ['./agregar-cuenta.component.scss'],
  standalone: false
})
export class AgregarCuentaComponent implements OnInit {
  // Font Awesome Icons
  farEdit = faEdit;
  farPlusCircle = faPlusCircleRegular;
  farTrashAlt = faTrashAlt;
  fasPlusCircle = faPlusCircleSolid;


  @Input() cuentasFormArray!: AbstractControl | null; // Recibe el FormArray del padre
  @Input() panelLateralVisible: boolean = false;

  cuentasArray: FormArray | null = null;

  get cuentas(): any[] {
    return this.cuentasArray?.value || [];
  }

  constructor(
    private modalController: ModalController,
    private formBuilder: FormBuilder
  ) {}

  ngOnInit() {
    // Asignar el FormArray recibido del padre
    if (this.cuentasFormArray && this.cuentasFormArray instanceof FormArray) {
      this.cuentasArray = this.cuentasFormArray;
    }
  }

  async abrirModalCuentasBancarias(index?: number) {
    if (!this.cuentasArray) return;

    const cuentaEditar = index !== undefined ? this.cuentas[index] : null;

    const modal = await this.modalController.create({
      component: ModalCuentaBancariaComponent,
      cssClass: 'promo2',
      componentProps: {
        cuentaEditar: cuentaEditar || null
      }
    });

    await modal.present();

    const { data } = await modal.onDidDismiss();

    if (data) {
      if (index !== undefined) {
        // Actualizar cuenta existente
        this.cuentasArray.at(index).patchValue(data);
      } else {
        // Agregar nueva cuenta
        this.cuentasArray.push(this.crearCuentaFormGroup(data));
      }
    }
  }

  borrarCuenta(index: number) {
    if (this.cuentasArray) {
      this.cuentasArray.removeAt(index);
    }
  }

  private crearCuentaFormGroup(data: any): FormGroup {
    return this.formBuilder.group({
      id: [data?.id || this.generarId()],
      entidadFinanciera: [data?.entidadFinanciera || '', Validators.required],
      tipoCuenta: [data?.tipoCuenta || '', Validators.required],
      moneda: [data?.moneda || '', Validators.required],
      nroCuenta: [data?.nroCuenta || '', Validators.required],
      cci: [data?.cci || '', Validators.required]
    });
  }

  private generarId(): string {
    return `CTA_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }
}
