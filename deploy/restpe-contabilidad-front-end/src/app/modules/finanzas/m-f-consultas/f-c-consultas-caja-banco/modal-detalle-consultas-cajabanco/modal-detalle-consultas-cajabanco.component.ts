import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef } from 'ag-grid-community';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-detalle-consultas-cajabanco',
  templateUrl: './modal-detalle-consultas-cajabanco.component.html',
  styleUrls: ['./modal-detalle-consultas-cajabanco.component.scss'],
  standalone: false,
})
export class ModalDetalleConsultasCajabancoComponent implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;


  @Input() datosCuenta: any = {};
  @Input() numeroCuenta: string = '';
  @Input() asientosContables: any[] = [];
  @Input() movimientosBancarios: any[] = [];
  @Input() colDefsMovimientos: ColDef[] = [];
  @Input() colDefsAsientos: ColDef[] = [];
  
  // Control de tabs
  tabSeleccionado: string = 'movimientos';
  
  // Configuración de ag-grid para movimientos bancarios
  columnTypesMovimientos = {};
  gridOptionsMovimientos = {
    context: {
      componentParent: this,
    },
  };
  
  // Configuración de ag-grid para asientos contables
  columnTypesAsientos = {};
  gridOptionsAsientos = {
    context: {
      componentParent: this,
    },
  };
  
  localeText = {
    page: 'Página',
    to: 'a',
    of: 'de',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    loadingOoo: 'Cargando...',
    noRowsToShow: 'No hay datos para mostrar',
  };
  
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null ||
        params.value === undefined ||
        params.value === ''
        ? '–'
        : params.value;
    },
  };
  


  constructor(private modalController: ModalController) {}

  ngOnInit() {}
  
  cerrarModal() {
    this.modalController.dismiss();
  }

}
