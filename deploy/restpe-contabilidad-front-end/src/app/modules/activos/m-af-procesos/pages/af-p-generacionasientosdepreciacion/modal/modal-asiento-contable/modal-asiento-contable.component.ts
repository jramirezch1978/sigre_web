import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-asiento-contable',
  templateUrl: './modal-asiento-contable.component.html',
  styleUrls: ['./modal-asiento-contable.component.scss'],
  standalone: false
})
export class ModalAsientoContableComponent implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;



  @Input() nroAsiento: string = 'ASC-2025-09-003';
  @Input() asientoData: any[] = [];

  private gridApi!: GridApi;

  colDefs: ColDef[] = [
    { 
      field: 'cuentaContable', 
      headerName: 'Cuenta contable', 
      width: 130 
    },
    { 
      field: 'descripcion', 
      headerName: 'Descripción', 
      width: 150,
      flex: 1 ,
    },
    { 
      field: 'debito', 
      headerName: 'Débito', 
      width: 80,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `(${formattedValue})`;
          }
          return formattedValue;
        }
        return '-';
      },
    },
    { 
      field: 'credito', 
      headerName: 'Crédito', 
      width: 80,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `(${formattedValue})`;
          }
          return formattedValue;
        }
        return '-';
      },
    }
  ];

  constructor(private modalController: ModalController) { }

  ngOnInit() {
    // Si no se pasan datos, usar datos de ejemplo
    if (this.asientoData.length === 0) {
      this.asientoData = [
        {
          cuentaContable: '1510.02',
          descripcion: 'Equipos de cocina - Depreciación',
          debito: 600.00,
          credito: 0.00
        },
        {
          cuentaContable: '3810.01',
          descripcion: 'Depreciación por equis motivo',
          debito: 0.00,
          credito: 600.00
        }
      ];
    }
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  dismissModal() {
    this.modalController.dismiss();
  }

}
