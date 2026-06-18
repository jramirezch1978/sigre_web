import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent } from 'ag-grid-enterprise';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';
import { faPercent } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-modal-asignacion-distribucion',
  templateUrl: './modal-asignacion-distribucion.component.html',
  styleUrls: ['./modal-asignacion-distribucion.component.scss'],
  standalone: false,
})
export class ModalAsignacionDistribucionComponent  implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;
  fasPercent = faPercent;



  @Input() tipo: 'porcentaje' | 'fijo' | 'horas' = 'porcentaje';
  @Input() tituloModal: string = 'Asignar Distribución';

  tiposDistribucionLabel: { [key: string]: string } = {
    'porcentaje': 'Porcentaje',
    'fijo': 'Valor fijo',
    'horas': 'Hrs trabajadas'
  };

    private gridApi!: GridApi;
  
    // Variables para distribución de canales
    distribucionDelivery: number = 0;
    distribucionSalon: number = 0;
    distribucionExtra1: number = 0;
    distribucionExtra2: number = 0;

   localeText = {
    page: 'Página',
    to: 'a',
    of: 'de',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    loadingOoo: 'Cargando...',
    noRowsToShow: 'No hay datos para mostrar'
  };

  constructor(private modalController: ModalController) { }

  ngOnInit() {}
  
  validarNumero(event: any, campo: string) {
    const valor = event.target.value;
    
    if (valor > 100) {
      event.target.value = 100;
      if (campo === 'delivery') this.distribucionDelivery = 100;
      else if (campo === 'salon') this.distribucionSalon = 100;
      else if (campo === 'extra1') this.distribucionExtra1 = 100;
      else if (campo === 'extra2') this.distribucionExtra2 = 100;
    }
  }
  
   cerrarModal() {
    this.modalController.dismiss(null, 'cancel');
  }

  guardar() {
      // Obtener los datos actualizados de la tabla
      const datosActualizados = this.gridApi?.getRenderedNodes().map(node => node.data) || [];
      this.modalController.dismiss(datosActualizados, 'confirm');
    }
  
    onGridReady(params: GridReadyEvent) {
      this.gridApi = params.api;
    }

}
