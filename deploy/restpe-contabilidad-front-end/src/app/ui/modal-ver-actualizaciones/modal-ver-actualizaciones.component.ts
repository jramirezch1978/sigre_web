import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-modal-ver-actualizaciones',
  templateUrl: './modal-ver-actualizaciones.component.html',
  styleUrls: ['./modal-ver-actualizaciones.component.scss'],
  standalone: false,
})
export class ModalVerActualizacionesComponent implements OnInit {
  // Font Awesome Icons
  fasXmark = faXmark;


  
  @Input() titulo!: string;
  @Input() subtitulo!: string;
  @Input() rowData: any[] = [];
  @Input() colDefs!: ColDef[];
  @Input() altoModal: string = '300px';
  @Input() anchoModal: string = '700px';

  private gridApi!: GridApi;

  constructor(private modalController: ModalController) { }

  ngOnInit() {
    this.validarAltoModal();
  }

  validarAltoModal() {
    if (this.rowData.length >= 5) {
      this.altoModal = '500px';
    } else {
      this.altoModal = '300px';
    }
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  cerrarmodal() {
    this.modalController.dismiss();
  }
}
