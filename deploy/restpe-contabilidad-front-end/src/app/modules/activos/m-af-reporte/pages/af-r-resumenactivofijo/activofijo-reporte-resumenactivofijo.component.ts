import { Component, OnInit, inject, effect } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { SingleSelectFilterComponent } from './single-select-filter.component';
import { ResumenActivoFijoFacade } from 'src/app/modules/activos/application/facades/resumen-activo-fijo.facade';
import { ResumenActivoFijoEntity } from 'src/app/modules/activos/domain/models/resumen-activo-fijo.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faFiles, faGear, faHandHoldingDollar, faList, faPerson, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
@Component({
  selector: 'app-activofijo-reporte-resumenactivofijo',
  templateUrl: './activofijo-reporte-resumenactivofijo.component.html',
  styleUrls: ['./activofijo-reporte-resumenactivofijo.component.scss'],
  standalone: false
})
export class ActivofijoReporteResumenactivofijoComponent implements OnInit {
  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasFiles = faFiles;
  fasGear = faGear;
  fasHandHoldingDollar = faHandHoldingDollar;
  fasList = faList;
  fasPerson = faPerson;
  fasRotateRight = faRotateRight;


  //RANGO DE FECHAS

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  filaSeleccionada: any = null; // Almacena la fila que se está editando
  camponuevo: boolean = false;
  private gridApi!: GridApi;
  mostrartabla: boolean = true;
  rangoSeleccionado: any = null;
  loaded: boolean = !false;

  readonly facade = inject(ResumenActivoFijoFacade);
  rowData: ResumenActivoFijoEntity[] = [];

  colDefs: ColDef<ResumenActivoFijoEntity>[] = [
    { field: 'raf_codigo', headerName: 'Código', width: 80 },
    { field: 'raf_descripcion', headerName: 'Descripción', flex: 1, minWidth: 200 },
    { field: 'raf_clase', headerName: 'Clase/Subclase', flex: 1, minWidth: 200, filter: true },
    { field: 'raf_ubicacion', headerName: 'Ubicación', flex: 1, minWidth: 200, filter: true },
    { field: 'raf_fecha_adqui', headerName: 'Fecha de adquisición', width: 130 },
    { field: 'raf_inicio_dep', headerName: 'Inicio depreciación', width: 120 },
    { field: 'raf_valor_adqui', headerName: 'Valor de adquisicion', width: 130,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'end', alignItems: 'center' }
     },
    { field: 'raf_depre_ac', headerName: 'Depreciación acumulada', width: 150,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    { field: 'raf_valor_net', headerName: 'Valor neto contable', width: 130,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    { 
      field: 'raf_moneda', 
      headerName: 'Moneda', 
      width: 80, 
      filter: SingleSelectFilterComponent,
      floatingFilter: false
    },
    { field: 'raf_centro_costo', headerName: 'Centro de costo', width: 120, filter: true },
    { field: 'raf_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado', filter: true,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        
        switch(estado) {
          case 'Activo':
            badgeClass = 'bg-[#DCFDE7] text-[#16A34A]';
            break;
            case 'Inactivo':
            badgeClass = 'bg-[#FEE2E2] text-[#DC2626]';
            break;
          default:
            badgeClass = 'bg-gray-100 text-gray-600';
        }
        
        return `<span class="${badgeClass} badge-table">${estado}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];



  selectorestado=
  [
    {value: 'activo', nombre:'Activo'},
    {value: 'inactivo', nombre:'Inactivo'},
    {value: 'todoslosestados', nombre:'Todos los estados'},
  ]

  selectordepreciacion=
  [
    {value: 'tipodepreciacion', nombre:'Todos los tipos de depreciación'},
    {value: 'contable', nombre:'Contable'},
    {value: 'tributario', nombre:'Tributario'},

  ]

  selectoradquisicion=[
    {value: 'iniciodepreciacion', nombre:'Inicio de depreciación'},
    {value: 'adquisicion', nombre:'Adquisición'},


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
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Sincronizar el signal de la facade con la propiedad rowData del grid
    effect(() => {
      this.rowData = this.facade.resumenes();
    });
  }

  ngOnInit() {
    this.facade.cargarResumenes();
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

  actualizar() {
    this.facade.cargarResumenes();
  }

  onRangoSeleccionado(rango: any) {
    console.log('Rango seleccionado:', rango);
    // rango puede ser:
    // { tipo: 'menores', max: 1000 }
    // { tipo: 'de', min: 1000, max: 5000 }
    // { tipo: 'mayores', min: 20000 }
    // { tipo: 'personalizado', min: 1500, max: 3000 }
    
    // Aplicar filtro a la tabla según el rango
    if (rango && this.gridApi) {
      // Aquí puedes filtrar los datos según el rango
      // Por ejemplo: this.gridApi.setFilterModel({ ... });
    }
  }

    filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos
    this.cargarDatos(range.start, range.end);
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }

  onBtReset() {
    this.facade.cargarResumenes();
  }
}

