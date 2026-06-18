import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef } from 'ag-grid-community';
import { AcciEditEliminarComponent } from 'src/app/ui/acci-edit-eliminar/acci-edit-eliminar.component';
import { ModalAgregarMedioDePagoComponent } from '../modal-agregar-medio-de-pago/modal-agregar-medio-de-pago.component';
import { ToastService } from 'src/app/ui/services/toast.service';

// Font Awesome Icons
import { faMoneyBill, faXmark } from '@fortawesome/pro-regular-svg-icons';
import { faCirclePlus } from '@fortawesome/pro-solid-svg-icons';



export interface DetalleItem {
  label: string;
  value: string;
}

export interface MedioPago {
  id?: number;
  medioPago: string;
  banco: string;
  numeroOperacion: string;
  moneda: string;
  monto: string;
}

@Component({
  selector: 'app-modal-pagar',
  templateUrl: './modal-pagar.component.html',
  styleUrls: ['./modal-pagar.component.scss'],
  standalone: false,
})
export class ModalPagarComponent implements OnInit {
  // Font Awesome Icons
  farMoneyBill = faMoneyBill;
  farXmark = faXmark;
  fasCirclePlus = faCirclePlus;



  @Input() tituloModal: string = 'Aplicar Pago';
  @Input() widthModal: string = '550px';
  @Input() subtitulomodal: string = 'Información detallada';
  @Input() detalles: DetalleItem[] = [];
  @Input() mostrarBotonConfirmar: boolean = true;
  @Input() textoBotonConfirmar: string = 'Aplicar Pago';
  @Input() textoBotonCancelar: string = 'Cancelar';
  @Input() textoBotonAplicarPago: string = 'Aplicar Pago';
  @Input() BotonAgregarMedioPago: string = 'Agregar Medio de Pago';
  @Input() TextoMediosPago: string = 'Medios de Pago';
  @Input() mostrarTabla: boolean = true;
  @Input() colDefs: ColDef[] = [];
  @Input() rowData: any[] = [];


  motivoTexto: string = '';
  itemSeleccionado: any = null;
  
  mediosPago: MedioPago[] = [
    { medioPago: 'Efectivo', banco: '-', numeroOperacion: '-', moneda: 'Soles', monto: '10,000.00'},
    { medioPago: 'Transferencia', banco: 'BBVA Continental', numeroOperacion: 'OP-12321', moneda: 'Soles', monto: '10,000.00'},
];
  mostrarFormularioAgregarMedioPago: boolean = false;

  constructor(private modalController: ModalController, private toastService: ToastService) { }

  ngOnInit() {
    
    // Inicializar las columnas del ag-grid si no están definidas
    if (!this.colDefs || this.colDefs.length === 0) {
      this.colDefs = [
        { headerName: '#',valueGetter: 'node.rowIndex + 1', width: 50, },
        { field: 'medioPago', headerName: 'Medio de pago', width: 120, editable: true },
        { field: 'banco', headerName: 'Banco', width: 100, editable: true },
        { field: 'numeroOperacion', headerName: 'N° operación', width: 120, editable: true },
        { field: 'moneda', headerName: 'Moneda', width: 80, editable: true },
        { field: 'monto', headerName: 'Monto', width: 100, editable: true,
          valueFormatter: params => {return `S/ ${params.value}`},
         },
        { 
          field: 'acciones', 
          headerName: 'Acciones', 
          headerClass: 'centrarencabezado',
          cellRenderer: AcciEditEliminarComponent,
          width: 80, 
          cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' },
          editable: false,
        }
      ];
    }
    
    if (this.rowData) {
      this.rowData = this.mediosPago;
    }
  }
  onEditar(item: any) {
    console.log('Editar item:', item);
    // Lógica para editar el item
  }
  onEliminar(item: any) {
    console.log('Eliminar item:', item);
    // Lógica para eliminar el item
  }
  cerrarModal() {
    this.modalController.dismiss();
  }
  async  agregarMedioPago() {
    const modal = await this.modalController.create({
      component: ModalAgregarMedioDePagoComponent,
      cssClass: 'promo2',
      componentProps: {
        tituloModal: 'Agregar medio de pago',
        textoBotonConfirmar: 'Agregar',
        textoBotonCancelar: 'Cancelar'
      }
    });
  
    await modal.present();
  
    const { data } = await modal.onDidDismiss();
  
    if (data?.action === 'agregar') {
  
  
      console.log('Datos del medio de pago:', data.data);
      // Aquí procesas los datos que regresa el modal
      const { medioPago, moneda, monto, numeroOperacion } = data.data;
    }
  }
  cancelar() {
    this.modalController.dismiss({ action: 'cancelar' });
  }
  confirmar() {
    this.modalController.dismiss({ 
      action: 'confirmar',
      itemSeleccionado: this.itemSeleccionado
    });
  }
  onItemSeleccionado(item: any) {
    this.itemSeleccionado = item;
  }

}
