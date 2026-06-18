import { Component, OnInit, inject, effect } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalFormulasComponent } from './modals/modal-formulas/modal-formulas.component';
import { SingleSelectFilterComponent } from '../af-r-resumenactivofijo/single-select-filter.component';
import { DepreciacionAnualFacade } from 'src/app/modules/activos/application/facades/depreciacion-anual.facade';
import { DepreciacionAnualEntity } from 'src/app/modules/activos/domain/models/depreciacion-anual.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faFiles, faGear, faHandHoldingDollar, faList, faPercent, faPerson, faQuestionCircle, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-activofijo-reporte-depreciacionanual',
  templateUrl: './activofijo-reporte-depreciacionanual.component.html',
  styleUrls: ['./activofijo-reporte-depreciacionanual.component.scss'],
  standalone: false
})
export class ActivofijoReporteDepreciacionanualComponent implements OnInit {
  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasFiles = faFiles;
  fasGear = faGear;
  fasHandHoldingDollar = faHandHoldingDollar;
  fasList = faList;
  fasPercent = faPercent;
  fasPerson = faPerson;
  fasQuestionCircle = faQuestionCircle;
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
  cargando = true;
  rango = '';
  loaded: boolean = !false;

  readonly facade = inject(DepreciacionAnualFacade);
  rowData: DepreciacionAnualEntity[] = [];

  colDefs: ColDef<DepreciacionAnualEntity>[] = [
    { field: 'dep_codigo', headerName: 'Código', width: 80 },
    { field: 'dep_descripcion', headerName: 'Descripción', flex: 1, minWidth: 200 },
    { field: 'dep_clase', headerName: 'Clase', flex: 1, minWidth: 200, filter: 'agSetColumnFilter', filterParams: { selectAllOnMiniFilter: true } },
    { field: 'dep_subclase', headerName: 'Subclase', flex: 1, minWidth: 200, filter: 'agSetColumnFilter', filterParams: { selectAllOnMiniFilter: true } },
    { field: 'dep_fecha_dep', headerName: 'Fecha depreciación', width: 120 },
    { field: 'dep_valor_orig', headerName: 'Valor original', width: 90,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      },
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    { field: 'dep_base_dep', headerName: 'Base depreciación', width: 140,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      },
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    { field: 'dep_metodo_dep', headerName: 'Método de Depreciacion', width: 150 },
    { field: 'dep_tasa_anual', headerName: 'Tasa Anual (%)', width: 100 },
    { field: 'dep_meses_dep', headerName: 'Meses Depreciación', width: 130 },
    { field: 'dep_deprec_mens', headerName: 'Depreciación Mensual', width: 150,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      },
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    { field: 'dep_deprec_anual', headerName: 'Depreciación Anual', width: 130,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      },
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    { field: 'dep_deprec_acum', headerName: 'Depreciación acumulada', width: 150,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      },
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    { field: 'dep_valor_neto', headerName: 'Valor neto contable', width: 120,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      },
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    { field: 'dep_proyeccion_dep', headerName: 'Proyección depreciación', width: 140,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      },
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    { field: 'dep_moneda', headerName: 'Moneda', width: 90, filter: SingleSelectFilterComponent, floatingFilter: false },
    { field: 'dep_tipo_calculo', headerName: 'Tipo de cálculo', width: 130, filter: 'agSetColumnFilter', filterParams: { selectAllOnMiniFilter: true } },
    { field: 'dep_centro_costo', headerName: 'Centro de costo', width: 130, filter: 'agSetColumnFilter', filterParams: { selectAllOnMiniFilter: true } },
    { field: 'dep_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado', filter: true,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        switch (estado) {
          case 'Activo':
            badgeClass = 'bg-[#DCFDE7] text-[#16A34A]';
            break;
          case 'Inactivo':
            badgeClass = 'bg-gray-100 text-gray-600';
            break;
          default:
            badgeClass = 'bg-gray-100 text-gray-600';
        }
        return `<span class="${badgeClass} badge-table">${estado}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];



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

  constructor(private modalController: ModalController) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Sincronizar el signal de la facade con la propiedad rowData del grid
    effect(() => {
      this.rowData = this.facade.depreciaciones();
    });
  }

  ngOnInit() {
    this.facade.cargarDepreciaciones();
    setTimeout(() => {
      this.cargando = false;
    }, 1000);
  }
  
  actualizar() {
    this.cargando = true;
    this.facade.cargarDepreciaciones();
    setTimeout(() => { this.cargando = false; }, 1000);
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


  public async abrirModalFormulas() {
    const modal = await this.modalController.create({
      component: ModalFormulasComponent,
      cssClass: 'promo',
      componentProps: {

      }
    });
    await modal.present();
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
    if (this.gridApi) {
      // Mostrar loading y recargar datos
      this.gridApi.showLoadingOverlay();
      
      // Simular recarga de datos
      setTimeout(() => {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.gridApi.hideOverlay();
        console.log('Tabla refrescada');
      }, 300);
    }
  }

}


