import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef } from 'ag-grid-community';
import { ToastService } from 'src/app/ui/services/toast.service';

// Font Awesome Icons
import { faCirclePlus, faXmark } from '@fortawesome/pro-regular-svg-icons';



export interface DetalleItem {
  label: string;
  value: string;
}

export interface MedioPago {
  id?: number;
  numero: number;
  medioPago: string;
  banco: string;
  numeroOperacion: string;
  moneda: string;
  monto: number;
}

@Component({
  selector: 'app-modal-agregar-medio-de-pago',
  templateUrl: './modal-agregar-medio-de-pago.component.html',
  styleUrls: ['./modal-agregar-medio-de-pago.component.scss'],
  standalone: false,
})
export class ModalAgregarMedioDePagoComponent implements OnInit {
  // Font Awesome Icons
  farCirclePlus = faCirclePlus;
  farXmark = faXmark;



  @Input() tituloModal: string = 'Agregar medio de pago';
  @Input() widthModal: string = '450px';
  @Input() textoBotonConfirmar: string = 'Agregar';
  @Input() textoBotonCancelar: string = 'Cancelar';

  medioPago: string = '';
  moneda: string = '';
  monto: number | string = '';
  numeroOperacion: string = '';
  numeroCheque: string = '';
  bancoOrigen: string = '';

  pagos = [
    { id: 'Mayor', nombre: 'Efectivo' },
    { id: 'transferencia', nombre: 'Transferenia' },
    { id: 'cheque', nombre: 'Cheque' },
    { id: 'Tdebito', nombre: 'Tarjeta de débito' },
    { id: 'Tcredito', nombre: 'Tarjeta de crédito' },
    { id: 'deposito', nombre: 'Déposito' }
  ];
   bancos = [
    { id: 'bbva', nombre: 'BBVVA Continental' },
    { id: 'bcp', nombre: 'BCP' },
    { id: 'interbank', nombre: 'Interbank' },
  ];

   monedas = [
    { id: 'soles', nombre: 'Soles' },
    { id: 'dolares', nombre: 'Dólares' },
  ];

  constructor(private modalController: ModalController, private toastservice: ToastService,) { }

  ngOnInit() {
  }

  cerrarModal() {
    this.modalController.dismiss();
  }

  cancelar() {
    this.modalController.dismiss({ action: 'cancelar' });
  }

  agregar() {
    if (this.validar()) {
      this.modalController.dismiss({
        action: 'agregar',
        data: {
          medioPago: this.medioPago,
          moneda: this.moneda,
          monto: this.monto,
          numeroOperacion: this.numeroOperacion,
          numeroCheque: this.numeroCheque,
          bancoOrigen: this.bancoOrigen
        }
      });
    }
  }

  validar(): boolean {
    if (!this.medioPago || this.medioPago.trim() === '') {
      this.toastservice.warning('Por favor, selecciona un medio de pago');
      return false;
    }
    if (!this.moneda || this.moneda.trim() === '') {
      this.toastservice.warning('Por favor, selecciona una moneda');
      return false;
    }
    if (!this.monto || parseFloat(this.monto.toString()) <= 0) {
      this.toastservice.warning('Por favor, ingresa un monto válido');
      return false;
    }
    return true;
  }

  validarDecimales(event: any) {
    const valor = event.target.value;
    if (valor && valor.includes('.')) {
      const partes = valor.split('.');
      if (partes[1] && partes[1].length > 5) {
        const valorLimitado = partes[0] + '.' + partes[1].substring(0, 5);
        this.monto = valorLimitado;
        event.target.value = valorLimitado;
      }
    }
  }

}
