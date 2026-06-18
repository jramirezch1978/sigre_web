import { Component, effect, inject, OnInit } from '@angular/core';
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { VistaFechaHoraRenderComponent } from '@ui/vista-fecha-hora-render/vista-fecha-hora-render.component';
import { DataProveedorRenderComponent } from '@ui/data-proveedor-render/data-proveedor-render.component';
import { InformacionFeRenderComponent } from '@ui/informacion-fe-render/informacion-fe-render.component';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { PanelDocumentoFacade } from '../../application/facades/panel-documento.facade';
import { PanelDocumentoFeedbackEffects } from '../../effects/panel-documento-feedback.effect';
import { PanelDocumentoEntity } from '../../domain/models/panel-documento.entity';

@Component({
  selector: 'app-v-r-panel-estados-doc',
  templateUrl: './v-r-panel-estados-doc.component.html',
  styleUrls: ['./v-r-panel-estados-doc.component.scss'],
  standalone: false,
})
export class VRPanelEstadosDocComponent  implements OnInit {
// #region Inyecciones
  private readonly panelDocumentoFacade = inject(PanelDocumentoFacade);
  private readonly _feedbackEffects = inject(PanelDocumentoFeedbackEffects);

  // Signals del facade
  readonly isLoading = this.panelDocumentoFacade.isLoading;

  //#endregion

  // #region iconos
    farSearch = faSearch;
    fasDownload = faDownload;
    fasAngleDown = faAngleDown;
    fasRotateRight = faRotateRight;
  // #endregion

  //#region variables del filtro

  //RANGO DE FECHAS
    startDate: Date | undefined;
    endDate: Date | undefined;
    minDate: Date;
    maxDate: Date;

    comprobanteSeleccionado: string = 'todos';
    estadoProvSeleccionado: string = 'todos';
    estadoSeleccionado: string = 'todos';
    rangoFechaSeleccionada: any | null = null;

    reporteGenerado: boolean = false;

    comprobantes=[
      { value: 'todos', label: 'Todos los comprobantes'},
      { value: 'boleta', label: 'Boleta'},
      { value: 'factura', label: 'Factura'},
      { value: 'nota_de_credito', label: 'Nota de crédito'},
      { value: 'nota_de_debito', label: 'Nota de débito'},
      { value: 'guia_de_remision', label: 'Guía de remisión'},
    ]

    estadosProv=[
      { value: 'todos', label: 'Todos los estados del proveedor'},
      { value: 'activo', label: 'Activo'},
      { value: 'anulado', label: 'Anulado'},
      { value: 'aceptado', label: 'Aceptado en sunat'},
      { value: 'baja-aceptada', label: 'Baja aceptada'},
      { value: 'pendiente-baja', label: 'Pendiente de baja'},
      { value: 'pendiente-aceptacion', label: 'Pendiente de aceptación'},
      { value: 'pendiente-rd', label: 'Pendiente RD'},
    ]

    estados=[
      { value: 'todos', label: 'Todos los estados'},
      { value: 'activo', label: 'Activo'},
      { value: 'anulado', label: 'Anulado'},
    ]
  //#endregion

  filasSeleccionadasCheckbox: any[] = [];

  //#region ag-grid
  private gridApi!: GridApi;
  rowData: PanelDocumentoEntity[] = [];

  colDefs: ColDef[] = [
    { field: 'panel_estado_doc_fecha', headerName: 'Fecha', width: 100,
      cellRenderer: VistaFechaHoraRenderComponent,
      cellRendererParams: { vertical: true },
    },
    { field: 'panel_estado_doc_cliente', headerName: 'Cliente', minWidth: 200, flex: 1 },
    { field: 'panel_estado_doc_documento', headerName: 'Documento', width: 100, },
    { field: 'panel_estado_doc_nro_documento', headerName: 'N° Documento', width: 100,  },
    { field: 'panel_estado_doc_total', headerName: 'Total venta', width: 150, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      valueFormatter: (params: any) => {
        if (params.value != null) {
          return `S/ ${params.value.toFixed(2)}`;
        }
        return '';
      }
    },
    { headerClass: 'centrarencabezado', headerName: 'Estado', field: 'panel_estado_doc_estado', width: 80, filter: true,
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        const estado = params.value;
        let colorClasses = 'bg-[#DCFDE7] text-[#16A34A]'; // Activo por defecto
        if (estado === 'Anulado') {
          colorClasses = 'bg-[#FEE2E2] text-[#DC2626]';
        }

        return `<span class="badge-table ${colorClasses}">${estado}</span>`;
      },
    },
    { field: 'panel_estado_doc_data_proveedor', headerName: 'Data según proveedor', minWidth: 250, flex: 1, wrapText: true, autoHeight: true,
      cellRenderer: DataProveedorRenderComponent,
    },
    { field: 'panel_estado_doc_informacion_fe', headerName: 'Información FE', minWidth: 210, flex: 1, wrapText: true, autoHeight: true,
      cellRenderer: InformacionFeRenderComponent,
    },
    { field: 'panel_estado_doc_mensaje', headerName: 'Mensaje', minWidth: 170, flex: 1, wrapText: true, autoHeight: true,
      cellStyle: { 'white-space': 'pre-wrap', 'line-height': '1.4', 'padding-top': '8px', 'padding-bottom': '8px' },
    },
  ];

  defaultColDef = {
    valueFormatter: (params: any) => {
      if (params.colDef.checkboxSelection) return params.value;
      return (params.value === null || params.value === undefined || params.value === '')
        ? '-'
        : params.value;
    }
  };
  columnTypes = {};
  gridOptions = {
    context: { componentParent: this },
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
    noRowsToShow: 'No hay datos para mostrar'
  };
  //#endregion

  constructor() {
    const today = new Date();
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );
    this.maxDate = today;

    // Sincronizar rowData desde el facade
    effect(() => {
      this.rowData = this.panelDocumentoFacade.registros();
    });
   }

  ngOnInit() {}

  // #region funciones
    filtrarPorFechas(range: { start: Date; end: Date }) {
      this.startDate = range.start;
      this.endDate = range.end;
      this.rangoFechaSeleccionada = range;
    }

    generarReporte() {
      this.panelDocumentoFacade.cargarReporte({
        comprobante: this.comprobanteSeleccionado,
        estadoProv: this.estadoProvSeleccionado,
        estado: this.estadoSeleccionado,
      });
      this.reporteGenerado = true;
    }

    aplicarFiltros() {
      this.panelDocumentoFacade.filtrarRegistros({
        comprobante: this.comprobanteSeleccionado,
        estadoProv: this.estadoProvSeleccionado,
        estado: this.estadoSeleccionado,
      });
    }

    onBtReset() {
      this.panelDocumentoFacade.cargarReporte();
    }

    onGridReady(params: GridReadyEvent) {
      this.gridApi = params.api;
    }

    // #end region
    
    // #region modals
    

    // #end region
}
