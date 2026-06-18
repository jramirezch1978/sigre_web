import { Component, OnInit, inject, effect } from '@angular/core';
import {
  ColDef,
  GridApi,
  GridReadyEvent,
  GridState,
  RowSelectionOptions,
} from 'ag-grid-community';
import { PanelReenvioFacade } from '../../application/facades/panel-reenvio.facade';
import { PanelReenvioFeedbackEffects } from '../../effects/panel-reenvio-feedback.effect';
import { PanelReenvioEntity } from '../../domain/models/panel-reenvio.entity';
import { VistaFechaHoraRenderComponent } from 'src/app/ui/vista-fecha-hora-render/vista-fecha-hora-render.component';
import { AccionesEnviarComponent } from 'src/app/ui/acciones-enviar/acciones-enviar.component';
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faPaperPlane, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { ToastService } from '@ui/services/toast.service';
import { ModalDetalleComponent } from '@ui/modal-detalle/modal-detalle.component';
import { ModalController } from '@ionic/angular';
import { last } from 'rxjs';

@Component({
  selector: 'app-v-r-panel-reenvio',
  templateUrl: './v-r-panel-reenvio.component.html',
  styleUrls: ['./v-r-panel-reenvio.component.scss'],
  standalone: false,
})
export class VRPanelReenvioComponent  implements OnInit {
  // #region Inyecciones
  private readonly panelReenvioFacade = inject(PanelReenvioFacade);
  private readonly _feedbackEffects = inject(PanelReenvioFeedbackEffects);

  // Signals del facade
  readonly isLoading = this.panelReenvioFacade.isLoading;

  //#endregion

  // #region iconos
    farSearch = faSearch;
    fasDownload = faDownload;
    fasAngleDown = faAngleDown;
    fasRotateRight = faRotateRight;
    fasPaperPlane = faPaperPlane;
  // #endregion

  //#region variables del filtro

  //RANGO DE FECHAS
    startDate: Date | undefined;
    endDate: Date | undefined;
    minDate: Date;
    maxDate: Date;

    comprobanteSeleccionado: string = 'todos';
    tipoSeleccionado: string = 'todos';
    estadoSeleccionado: string = 'todos';
    rangoFechaSeleccionada: any | null = null;

    reporteGenerado: boolean = false;

    comprobantes=[
      { value: 'todos', label: 'Todos los comprobantes'},
      { value: 'boleta', label: 'Boleta'},
      { value: 'factura', label: 'Factura'},
      { value: 'nota_de_credito', label: 'Nota de crédito'},
      { value: 'nota_de_debito', label: 'Nota de débito'},
      { value: 'guia_de_remision', label: 'Guía de remisión remitente'},
    ]

    tiposDoc=[
      { value: 'todos', label: 'Todos los tipos de documento'},
      { value: 'electronicos', label: 'Electrónicos'},
      { value: 'no-electronicos', label: 'No electrónicos'},
    ]

    estados=[
      { value: 'todos', label: 'Todos los estados'},
      { value: 'pendiente', label: 'Pendiente'},
      { value: 'enviado', label: 'Enviado'},
    ]
  //#endregion

  filasSeleccionadasCheckbox: any[] = [];

  //#region ag-grid
  private gridApi!: GridApi;
  rowData: PanelReenvioEntity[] = [];

  colDefs: ColDef[] = [
    { field: 'panel_reenvio_fecha', headerName: 'Fecha', width: 160,
      cellRenderer: VistaFechaHoraRenderComponent,
    },
    { field: 'panel_reenvio_documento', headerName: 'Documento', minWidth: 200, flex: 1 },
    { field: 'panel_reenvio_nro_documento', headerName: 'N° Documento', minWidth: 200, flex: 1 },
    { field: 'panel_reenvio_total', headerName: 'Total', width: 150, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      valueFormatter: (params: any) => {
        if (params.value != null) {
          return `S/ ${params.value.toFixed(2)}`;
        }
        return '';
      }
    },
    { headerClass: 'centrarencabezado', headerName: 'Estado', field: 'panel_reenvio_estado', width: 80, filter: true,
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        const estado = params.value;
        let colorClasses = 'bg-[#F5F5F5] text-[#363636]'; // Pendiente por defecto

        if (estado === 'Enviado') {
          colorClasses = 'bg-[#DCFDE7] text-[#16A34A]';
        } else if (estado === 'Error') {
          colorClasses = 'bg-[#FEE2E2] text-[#DC2626]';
        }

        return `<span class="badge-table ${colorClasses}">${estado}</span>`;
      },
    },
    { headerName: 'Acciones', width: 80, headerClass: 'centrarencabezado',
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: AccionesEnviarComponent,
      cellRendererParams: {
        isDisabled: (data: any) => data?.panel_reenvio_estado === 'Enviado',
        razonDeshabilitado: 'Documento ya enviado',
      },
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
  rowSelection: RowSelectionOptions | 'single' | 'multiple' = {
    mode: 'multiRow',
    isRowSelectable: (node: any) => node.data?.panel_reenvio_estado != 'Enviado',
    hideDisabledCheckboxes: true,
  };
  initialState: GridState = {};
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

  constructor(
    private toast: ToastService,
    private modalController: ModalController,
  ) {
    const today = new Date();
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );
    this.maxDate = today;

    // Sincronizar rowData desde el facade
    effect(() => {
      this.rowData = this.panelReenvioFacade.registros();
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
      this.panelReenvioFacade.cargarReporte({
        comprobante: this.comprobanteSeleccionado,
        tipo: this.tipoSeleccionado,
        estado: this.estadoSeleccionado,
      });
      this.reporteGenerado = true;
    }

    aplicarFiltros() {
      this.panelReenvioFacade.filtrarRegistros({
        comprobante: this.comprobanteSeleccionado,
        tipo: this.tipoSeleccionado,
        estado: this.estadoSeleccionado,
      });
    }

    notificacionMasiva(){
      if (this.filasSeleccionadasCheckbox.length === 0) {
        this.toast.warning('Selecciona al menos un documento para notificar.');
        return;
      }

      for (const fila of this.filasSeleccionadasCheckbox) {
        this.panelReenvioFacade.actualizarEstadoRegistro(fila.panel_reenvio_nro_documento, 'Enviado');
      }

      this.toast.success('¡Documento enviado exitosamente!');
      this.filasSeleccionadasCheckbox = [];
    }

    onBtReset() {
      this.panelReenvioFacade.cargarReporte();
    }

    onSelectionChanged() {
      if (this.gridApi) {
        this.filasSeleccionadasCheckbox = this.gridApi.getSelectedRows();
      }
    }

    get tieneMultiplesSelecciones(): boolean {
      return this.filasSeleccionadasCheckbox.length > 1;
    }

    onGridReady(params: GridReadyEvent) {
      this.gridApi = params.api;
    }

    onEnviar(data: any) {
      const rowNode = this.gridApi.getRenderedNodes().find(node => node.data === data);
      if (!rowNode) return;

      // Simular error en la segunda fila (índice 1)
      if (rowNode.rowIndex === 1) {
        this.panelReenvioFacade.actualizarEstadoRegistro(data.panel_reenvio_nro_documento, 'Error');
        this.toast.danger('¡El documento ha sido rechazado!');
        return;
      }

      this.panelReenvioFacade.actualizarEstadoRegistro(data.panel_reenvio_nro_documento, 'Enviado');
      this.toast.success('¡Documento enviado exitosamente!');
    }

    // #end region
    
    // #region modals
    async onVerDetalle(data: any) {

      const detalles =[
        { label: 'Cliente', value: data.panel_reenvio_cliente},
        { label: 'Direccion', value: data.panel_reenvio_direccion},
      ]

      const colDefs: any[] = [
        { field: 'det_cantidad', headerName: 'Cantidad', width: 70, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
        },
        { field: 'det_solicitado', headerName: 'Solicitado por', width: 90, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
        },
        { field: 'det_categoria', headerName: 'Categoría', width: 80, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
        },
        { field: 'det_producto', headerName: 'Producto', width: 100, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
        },
        { field: 'det_descuento', headerName: 'Descuento', width: 80, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
          valueFormatter: (params: any) => {
            if (params.value != null) {
              return `${params.value.toFixed(2)}`;
            }
            return '';
          }
        },
        { field: 'det_pu', headerName: 'P.U.', width: 50, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
          valueFormatter: (params: any) => {
            if (params.value != null) {
              return `${params.value.toFixed(2)}`;
            }
            return '';
          }
        },
        { field: 'det_total', headerName: 'Total con dscto.', width: 90, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
          valueFormatter: (params: any) => {
            if (params.value != null) {
              return `${params.value.toFixed(2)}`;
            }
            return '';
          }
        },
      ] 
      //calcular suma en data.detalles
      const detallesData = data.detalles || [];
      const totalDescuentos = detallesData.reduce((sum: number, d: any) => sum + (d.det_descuento * d.det_cantidad || 0), 0);
      const subtotal = detallesData.reduce((sum: number, d: any) => sum + (d.det_total || 0), 0);
      const igv = +(subtotal * 0.18 / 1.18).toFixed(2);
      const baseImponible = +(subtotal - igv).toFixed(2);
      const totalFacturado = subtotal;

      const cardTotal = [
        { label: 'Total', value: baseImponible.toFixed(2) },
        { label: 'IGV', value: igv.toFixed(2) },
        { label: 'Descuentos', value: totalDescuentos.toFixed(2) },
        { label: 'Total facturado', value: totalFacturado.toFixed(2) },
      ]

      const modal = await this.modalController.create({
        component: ModalDetalleComponent,
        cssClass: 'promo',
        componentProps: {
          tituloModal: `Documento ${data.panel_reenvio_tipo.charAt(0).toUpperCase()}${data.panel_reenvio_nro_documento}`,
          widthModal: '555px',
          detalles: detalles,
          mostrarTabla: true,
          colDefs: colDefs,
          rowData: data.detalles || [],
          mostrarTextarea: false,
          mostrarTotal: true,
          itemstotal: cardTotal,
          mostrarBotonEliminar: false,
          ocultarBotonConfirmar: true,
          textoBotonCancelar: 'Cerrar'
        },
      });

      await modal.present();
    }

    // #end region
}
