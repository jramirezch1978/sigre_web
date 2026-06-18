import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef } from 'ag-grid-community';

// Font Awesome Icons
import { faFileLines } from '@fortawesome/pro-light-svg-icons';
import { faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-detalle-calculo',
  templateUrl: './modal-detalle-calculo.component.html',
  styleUrls: ['./modal-detalle-calculo.component.scss'],
  standalone: false,
})
export class ModalDetalleCalculoComponent implements OnInit {
  // Font Awesome Icons
  falFileLines = faFileLines;
  farXmark = faXmark;



  @Input() mostrarTabla1: boolean = true;
  @Input() mostrarTabla2: boolean = false;
  @Input() mostrardatos:boolean= false;
  @Input() tituloTabla1 = 'Detalle de fondo de pensiones';
  @Input() tituloTabla2 = 'Detalle cálculo de vacaciones truncas';
  @Input() datos1: boolean = false;
  @Input() datos2: boolean = false;
  @Input() dato1cantidad: boolean = false;
  @Input() dato2cantidad: boolean = false;
  @Input() mostrarIcono: boolean = true;
  @Input() tituloModal: string = "Detalle del cálculo";



  @Input() rowData1 = [];
  @Input() rowData2 = [];
  @Input() colDefs1: ColDef[] = [];
  @Input() colDefs2: ColDef[] = [];

  // ColDef por defecto
  colDefDefault: ColDef[] = [
    { field: 'concepto', headerName: 'Concepto', flex:2 },
    { 
      field: 'baseM', 
      headerName: 'Base mensual', 
      headerClass: 'derechaencabezado', 
      cellClass: 'justify-end',
      flex:1, 
      valueFormatter: (params: any) => {
        if (params.value === null || params.value === undefined || params.value === '' || params.value === 0) return '-';
        const num = typeof params.value === 'string' ? parseFloat(params.value) : params.value;
        return isNaN(num) ? '-' : `S/${num.toFixed(2)}`;
      }
    },
    { field: 'formula', headerName: 'Fórmula base', flex:2 },
    { field: 'meses', headerName: 'Meses', flex:1, valueFormatter: (params: any) => params.value || '-' },
    { field: 'dias', headerName: 'Días', flex:1, valueFormatter: (params: any) => params.value || '-' },
    { 
      field: 'monto', 
      headerName: 'Monto', 
      headerClass: 'derechaencabezado', 
      cellClass: 'justify-end',
      flex:1, 
      valueFormatter: (params: any) => {
        if (params.value === null || params.value === undefined || params.value === '') return '-';
        const num = typeof params.value === 'string' ? parseFloat(params.value) : params.value;
        if (isNaN(num)) return '-';
        // Si es negativo, mostrarlo entre paréntesis sin el signo menos
        if (num < 0) {
          return `S/(${Math.abs(num).toFixed(2)})`;
        }
        return `S/${num.toFixed(2)}`;
      },
      cellStyle: (params: any) => {
        if (params.value === null || params.value === undefined || params.value === '') return undefined;
        const num = typeof params.value === 'string' ? parseFloat(params.value) : params.value;
        // Si es negativo, aplicar color rojo
        if (!isNaN(num) && num < 0) {
          return { color: '#DC2626' };
        }
        return undefined;
      }
    },
  ];

  getRowStyle = (params: any) => {
    // Aplicar color de fondo #CEE0FD a las filas que tienen isTotal = true
    if (params.data && params.data.isTotal === true) {
      return { 'background-color': '#CEE0FD', 'font-weight': 'bold' };
    }
    // Aplicar semibold para filas con isLightBlue = true con fondo azul claro
    if (params.data && params.data.isLightBlue === true) {
      return { 'background-color': '#ECF4FF', 'font-weight': '600' };
    }
    // Aplicar semibold para filas con isSemibold = true con fondo gris
    if (params.data && params.data.isSemibold === true) {
      return { 'background-color': '#F5FAFE', 'font-weight': '600' };
    }
    return undefined;
  };

  constructor(
    private modalController: ModalController
  ) { }

  ngOnInit() {
    // Si no se proporciona colDefs, usar el default
    if (!this.colDefs1 || this.colDefs1.length === 0) {
      this.colDefs1 = this.colDefDefault;
    }
    if (!this.colDefs2 || this.colDefs2.length === 0) {
      this.colDefs2 = this.colDefDefault;
    }
  }

  dismissModal() {
    this.modalController.dismiss();
  }

}
