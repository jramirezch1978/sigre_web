import { Component, OnInit, Input } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

// Font Awesome Icons
import { faCirclePlus, faScrewdriverWrench, faXmark } from '@fortawesome/pro-regular-svg-icons';



export interface DetalleItem {
  label: string;
  value: string;
}
@Component({
  selector: 'app-modal-registrar-ingresos',
  templateUrl: './modal-registrar-ingresos.component.html',
  styleUrls: ['./modal-registrar-ingresos.component.scss'],
  standalone: false,
})
export class ModalRegistrarIngresosComponent  implements OnInit {
  // Font Awesome Icons
  farCirclePlus = faCirclePlus;
  farScrewdriverWrench = faScrewdriverWrench;
  farXmark = faXmark;



  @Input() ajustarregistro: boolean = false;
  @Input() detalles: DetalleItem[] = [];
  @Input() botonguardar: string = 'Registrar Ingreso';

  formularioAjuste!: FormGroup;

  cajasList = [
    { id: 'caja1', nombre: 'Caja 1 - Principal' },
    { id: 'caja2', nombre: 'Caja 2 - Secundaria' },
    { id: 'caja3', nombre: 'Caja 3 - Delivery' }
  ];

  mediosPagoList = [
    { id: 'efectivo', nombre: 'Efectivo' },
    { id: 'tarjeta', nombre: 'Tarjeta' },
    { id: 'transferencia', nombre: 'Transferencia' }
  ];

  monedasList = [
    { id: 'Soles', nombre: 'Soles' },
    { id: 'USD', nombre: 'Dólares' }
  ];

  constructor(
    private modalController: ModalController,
    private fb: FormBuilder
  ) { }

  ngOnInit() {
    this.formularioAjuste = this.fb.group({
      montoAjustado: ['', Validators.required],
      motivoAjuste: ['', Validators.required]
    });
  }

  async confirmar() {
    if (this.ajustarregistro) {
      if (this.formularioAjuste.invalid) {
        this.formularioAjuste.markAllAsTouched();
        return;
      }
    }
    await this.modalController.dismiss({ action: 'confirmar', data: this.formularioAjuste.value });
  }

  formatearMonto(event: any) {
    let valor = event.target.value;
    // Eliminar todo excepto números y punto
    valor = valor.replace(/[^\d.]/g, '');
    
    // Asegurar solo un punto decimal
    let partes = valor.split('.');
    if (partes.length > 2) {
      valor = partes[0] + '.' + partes.slice(1).join('');
      partes = valor.split('.');
    }
    
    // Limitar a 5 decimales
    if (partes.length > 1 && partes[1].length > 5) {
      partes[1] = partes[1].substring(0, 5);
      valor = partes.join('.');
    }
    
    // Formatear con comas para miles (solo en la parte entera)
    if (partes[0]) {
      const parteEntera = partes[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
      valor = partes.length > 1 ? parteEntera + '.' + partes[1] : parteEntera;
    }
    
    event.target.value = valor;
    
    // Actualizar el valor del formulario sin formato para el cálculo
    const valorSinFormato = valor.replace(/,/g, '');
    this.formularioAjuste.patchValue({ montoAjustado: valorSinFormato }, { emitEvent: false });
  }

  async cancelar() {
    await this.modalController.dismiss({ action: 'cancelar' });
  }

}
