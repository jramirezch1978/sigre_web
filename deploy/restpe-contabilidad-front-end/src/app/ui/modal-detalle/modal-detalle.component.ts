import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef } from 'ag-grid-community';

// Font Awesome Icons
import { faSearch, faXmark } from '@fortawesome/pro-regular-svg-icons';
import { IconDefinition } from '@fortawesome/fontawesome-svg-core';



export interface DetalleItem {
  label: string;
  value: string;
}

@Component({
  selector: 'app-modal-detalle',
  templateUrl: './modal-detalle.component.html',
  styleUrls: ['./modal-detalle.component.scss'],
  standalone: false,
})
export class ModalDetalleComponent  implements OnInit {
  // Font Awesome Icons
  farSearch = faSearch;
  farXmark = faXmark;


  @Input() tituloModal: string = 'Detalle';
  @Input() iconoModal?: IconDefinition;
  @Input() widthModal: string = '550px';
  @Input() subtitulomodal: string = 'Información detallada:';
  @Input() subtituloTabla: string = '';
  @Input() detalles: DetalleItem[] = [];
  @Input() detalleEdit: DetalleItem | null = null;
  @Input() textareaWidth: string = 'w-full';
  @Input() detalleInput: DetalleItem | null = null;
  @Input() mostrarbuscador: boolean = false;
  @Input() mostrarTextarea: boolean = true;
  @Input() tituloTextarea: string = 'Motivo de anulación:';
  @Input() placeholderTextarea: string = 'Describe el motivo...';
  @Input() mostrarBotonEliminar: boolean = true;
  @Input() mostrarBotonSecundario: boolean = false;
  @Input() textoBotonConfirmar: string = 'Eliminar';
  @Input() textoBotonSecundario: string = 'Revertir';
  @Input() textoBotonCancelar: string = 'Cancelar';
  @Input() colorBotonConfirmar: string = 'danger';
  @Input() botonoutline = 'outline';
  @Input() motivoObligatorio: boolean = false;
  @Input() mostrarTabla: boolean = false;
  @Input() colDefs: ColDef[] = [];
  @Input() rowData: any[] = [];
  @Input() mostrarAutocomplete: boolean = false;
  @Input() labelAutocomplete: string = 'Seleccionar';
  @Input() placeholderAutocomplete: string = 'Selecciona una opción';
  @Input() itemsAutocomplete: any[] = [];
  @Input() displayKeyAutocomplete: string = 'nombre';
  @Input() valueKeyAutocomplete: string = 'id';
  @Input() mostrarTotales: boolean = false;
  @Input() mostrarDetalle: boolean = false;


  @Input() totalDebe: string = '';
  @Input() totalHaber: string = '';
  @Input() ocultarBotonConfirmar: boolean = false;
  @Input() mostrarTotal: boolean = false;
  @Input() itemstotal: any[] = [];
  @Input() isdoblecolumna: boolean = false;
  
  motivoTexto: string = '';
  itemSeleccionado: any = null;

  constructor(private modalController: ModalController) { }

  ngOnInit() {
    if(this.colorBotonConfirmar === 'danger' || this.colorBotonConfirmar === 'warning'){
      this.botonoutline = 'outline';
    }
    else{
      this.botonoutline = 'solid';
    }
  }

  cerrarModal() {
    this.modalController.dismiss();
  }

  cancelar() {
    this.modalController.dismiss({ action: 'cancelar' });
  }

  btnSecundario() {
    this.modalController.dismiss({ action: 'secundario' });
  }

  confirmar() {
    if (this.motivoObligatorio && !this.motivoTexto?.trim()) {
      return; // no cierra el modal si es obligatorio y está vacío
    }

    this.modalController.dismiss({ 
      action: 'confirmar',
      motivo: this.motivoTexto,
      itemSeleccionado: this.itemSeleccionado
    });
  }

  onItemSeleccionado(item: any) {
    this.itemSeleccionado = item;
  }

}
