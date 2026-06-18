import { Component, OnInit, effect, inject } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { SingleSelectFilterComponent } from '../af-r-resumenactivofijo/single-select-filter.component';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faFiles, faGear, faHandHoldingDollar, faList, faPerson, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

import { ResumenRangosFacade } from '../../../application/facades/resumen-rangos.facade';
import { ResumenRangosEntity } from '../../../domain/models/resumen-rangos.entity';

@Component({
  selector: 'app-activofijo-reporte-resumenrangos',
  templateUrl: './activofijo-reporte-resumenrangos.component.html',
  styleUrls: ['./activofijo-reporte-resumenrangos.component.scss'],
  standalone: false
})
export class ActivofijoReporteResumenrangosComponent implements OnInit {
  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasFiles = faFiles;
  fasGear = faGear;
  fasHandHoldingDollar = faHandHoldingDollar;
  fasList = faList;
  fasPerson = faPerson;
  fasRotateRight = faRotateRight;



  startDate: Date | undefined;
  endDate: Date | undefined;
  selectedDate: Date | undefined;
  sumarcantidad: number = 0;
  filaSeleccionada: any = null; // Almacena la fila que se está editando
  camponuevo: boolean = false;

  private gridApi!: GridApi;
  mostrartabla: boolean = true;
  rango='';
  loaded: boolean = !false;
  // responsableSeleccionado: any;
  AnalisisOrdenForm!: FormGroup;

  readonly facade = inject(ResumenRangosFacade);
  rowData: ResumenRangosEntity[] = [];

  colDefs: ColDef<ResumenRangosEntity>[] = [
    { field: 'rr_codigo', headerName: 'Código', width: 90 },
    { field: 'rr_descripcion', headerName: 'Descripción', flex: 1, minWidth: 200 },
    { field: 'rr_clase', headerName: 'Clase/Subclase', flex: 1, minWidth: 200 },
    { field: 'rr_fecha_adqui', headerName: 'Fecha adq.', width: 80 },
    { field: 'rr_costo_ac', headerName: 'Costo de adquisición', width: 110,
      valueFormatter: (params) => {
        return params.value != null ? 'S/ ' + new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : 'S/ 0.00';
      },
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    { field: 'rr_depre_ac', headerName: 'Depre. acum.', width: 100,
      valueFormatter: (params) => {
        return params.value != null ? 'S/ ' + new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : 'S/ 0.00';
      },
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    { field: 'rr_valor_net', headerName: 'Valor neto', width: 100,
      valueFormatter: (params) => {
        return params.value != null ? 'S/ ' + new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : 'S/ 0.00';
      },
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    { field: 'rr_ubicacion', headerName: 'Ubicación', flex: 1, minWidth: 200, filter: true },
    { field: 'rr_responsable', headerName: 'Responsable', flex: 1, minWidth: 120, filter: true },
    { field: 'rr_centro_costo', headerName: 'Centro de costo', width: 140, filter: true },
    { field: 'rr_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado', filter: true,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        switch (estado) {
          case 'Activo':
            badgeClass = 'bg-[#DCFDE7] text-[#16A34A]';
            break;
          case 'Dado de baja':
            badgeClass = 'bg-gray-100 text-gray-600';
            break;
          default:
            badgeClass = 'bg-gray-100 text-gray-600';
        }
        return `<span class="${badgeClass} badge-table">${estado}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
    { field: 'rr_moneda', headerName: 'Moneda', width: 80, filter: SingleSelectFilterComponent, floatingFilter: false },
  ];

  responsables = [
    { id: 1, nombre: 'Carlos Zapata' }
  ]

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
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '-'
        : params.value;
    }
  };

  columnTypes = {
    numberColumn: { filter: false }
  };

  constructor() {
    const today = new Date();
    this.startDate = new Date(today.getFullYear(), today.getMonth(), 1);
    this.endDate = today;
    effect(() => {
      this.rowData = this.facade.rangos();
    });
  }

  ngOnInit() {
    this.facade.cargarRangos();
  }

  actualizar() {
    this.facade.cargarRangos();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onCellClicked(event: any) {
    this.camponuevo = false;

    const data = event.data;
    this.filaSeleccionada = data; // Guardar referencia de la fila seleccionada
    this.gridApi.deselectAll(); // Deseleccionar todas las filas primero

    event.node.setSelected(true); // Seleccionar la fila clickeada
    this.filaSeleccionada = data; // Guardar referencia de la fila seleccionada
  }


  
  onResponsableSeleccionado(event: any){
    console.log('Responsable seleccionado', event);
    // aplicar filtro a tus datos / guardar en variables del componente
  }

   // Para modo RANGE - Manejo de rango de fechas
   filtradoRango(range: { start: Date; end: Date }) {
    console.log('Rango de fechas:', range);
    this.startDate = range.start;
    this.endDate = range.end;
    this.cargarDatos(range.start, range.end);
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }
  sumardatos(opcion: string) {
    this.sumarcantidad = 0;
    if (opcion === 'costototal') {
      this.rowData.map(item => {
        this.sumarcantidad += item.rr_costo_ac;
        return this.sumarcantidad;
      });
    }
    if (opcion === 'costoAc') {
      this.rowData.map(item => {
        this.sumarcantidad += item.rr_depre_ac;
        return this.sumarcantidad;
      });
    }
    if (opcion === 'valorNet') {
      this.rowData.map(item => {
        this.sumarcantidad += item.rr_valor_net;
        return this.sumarcantidad;
      });
    }
    return this.sumarcantidad;
  }

  onBtReset() {
    this.facade.cargarRangos();
  }
}

