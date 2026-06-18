import { Component, OnInit, inject, effect } from '@angular/core';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalController } from '@ionic/angular';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { AnalisisCuentaContableFacade } from '../../../application/facades/analisis-cuenta-contable.facade';
import { AnalisisCuentaContableFeedbackEffects } from '../../../effects/analisis-cuenta-contable-feedback.effect';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-contabilidad-reporte-analisiscuentacontable',
  templateUrl: './contabilidad-reporte-analisiscuentacontable.component.html',
  styleUrls: ['./contabilidad-reporte-analisiscuentacontable.component.scss'],
  standalone: false,
})
export class ContabilidadReporteAnalisiscuentacontableComponent implements OnInit {

  private readonly analisisFacade      = inject(AnalisisCuentaContableFacade);
  private readonly feedbackEffects     = inject(AnalisisCuentaContableFeedbackEffects);
  readonly isLoading                   = this.analisisFacade.isLoading;

  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  private gridApi!: GridApi;

  // Rango de fechas
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  // Valores de filtros
  tipoAsientoSeleccionado: string = 'todos';
  monedaSeleccionada: string = 'todas';
  estadoSeleccionado: string = 'todos';
  sucursalSeleccionada: string = '';
  centroCostoSeleccionado: string = '';
  cuentaContableSeleccionada: string = '';

  // Data fija para los autocomplete
  sucursales = [
    { id: '1', nombre: 'San Juan de lurigancho, Lima' },
    { id: '2', nombre: 'Santa Isabel, Piura' },
    { id: '3', nombre: 'Miraflores, Lima' },
    { id: '4', nombre: 'San Isidro, Lima' },
  ];

  cuentasContables = [
    { id: '1', codigo: '10', nombre: '10 - EFECTIVO Y EQUIVALENTES DE EFECTIVO' },
    { id: '2', codigo: '12', nombre: '12 - CUENTAS POR COBRAR COMERCIALES' },
    { id: '3', codigo: '20', nombre: '20 - MERCADERÍAS' },
    { id: '4', codigo: '40', nombre: '40 - TRIBUTOS Y APORTES AL SISTEMA' },
    { id: '5', codigo: '41010', nombre: '41010 - Remuneraciones por pagar' },
    { id: '6', codigo: '42', nombre: '42 - CUENTAS POR PAGAR COMERCIALES' },
    { id: '7', codigo: '60', nombre: '60 - COMPRAS' },
    { id: '8', codigo: '70', nombre: '70 - VENTAS' },
  ];

  centrosCosto = [
    { id: '1', nombre: 'Operaciones' },
    { id: '2', nombre: 'Marketing' },
    { id: '3', nombre: 'Administración' },
    { id: '4', nombre: 'Tesorería' },
    { id: '5', nombre: 'Ventas' },
  ];

  // Opciones de filtros
  opcionesTipoAsiento = [
    { label: 'Selecciona un tipo de asiento', value: '' },
    { label: 'Manual', value: 'manual' },
    { label: 'Automático', value: 'automatico' },
  ];

  opcionesMoneda = [
    { label: 'Todas las monedas', value: 'todas' },
    { label: 'Soles', value: 'soles' },
    { label: 'Dólares ($)', value: 'dolares' },
  ];

  opcionesEstado = [
    { label: 'Todos los estados', value: 'todos' },
    { label: 'Activo', value: 'activo' },
    { label: 'Anulado', value: 'anulado' },
  ];

  filasGeneradas: any[] = [];

  // Definición de tipo de columna para precios
  columnTypes = {
    precioColumn: {
      valueFormatter: (params: any) => {
        if (params.value !== null && params.value !== undefined && params.value !== '') {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          if (params.value < 0) {
            return `(${formattedValue})`;
          }
          return formattedValue;
        }
        return '–';
      },
      cellStyle: (params: any) => {
        const style: any = { justifyContent: 'end' };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      }
    }
  };

  // Definición de columnas
  columnDefs: ColDef[] = [
    { field: 'ana_cta_fregistro', headerName: 'F. registro', width: 75 },
    { field: 'ana_cta_periodo', headerName: 'Periodo', width: 70 },
    { field: 'ana_cta_cta_contable', headerName: 'Cta contable', width: 90 },
    { field: 'ana_cta_doc_relacionado', headerName: 'Doc. relacionado', width: 120 },
    { field: 'ana_cta_nro_asiento', headerName: 'Nº Asiento', flex: 2, cellRenderer: VistaCellRenderComponent},
    { field: 'ana_cta_glosa', headerName: 'Glosa', flex: 2 },
    { field: 'ana_cta_moneda', headerName: 'Moneda', flex:1 },
    { field: 'ana_cta_debe', headerName: 'Debe', headerClass: 'derechaencabezado', flex: 1, type: 'precioColumn'},
    { field: 'ana_cta_haber', headerName: 'Haber', headerClass: 'derechaencabezado', flex: 1, type: 'precioColumn'},
    { field: 'ana_cta_saldo', headerName: 'Saldo', headerClass: 'derechaencabezado', flex: 1, type: 'precioColumn'},
    { field: 'ana_cta_sucursal', headerName: 'Sucursal', flex: 1 },
    { field: 'ana_cta_centro_costo', headerName: 'Centro de costo', flex: 1 },
    { field: 'ana_cta_estado', headerClass: 'centrarencabezado', headerName: 'Estado', flex: 1,
      cellRenderer: (params: any) => {
        const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  gridOptions = {
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
    noRowsToShow: 'No hay datos para mostrar'
  };

  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  private analisisGenerado = false;

  constructor(
    private toastService: ToastService,
    private modalController: ModalController
  ) {
    // Configurar fechas
    this.minDate = new Date(2020, 0, 1);
    this.maxDate = new Date();
    this.startDate = new Date(2025, 0, 1);
    this.endDate = new Date(2025, 0, 31);

    effect(() => {
      const items = this.analisisFacade.items();
      const loading = this.analisisFacade.isLoading();
      if (this.analisisGenerado && !loading && items.length > 0) {
        this.filasGeneradas = [...items];
        this.toastService.success('¡Análisis generado exitosamente!');
        this.analisisGenerado = false;
      }
    });
  }

  ngOnInit() {
  }

  onBtReset() {
    this.analisisFacade.cargarDatos();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  filtrarPorFechas(event: any) {
    console.log('Rango de fechas seleccionado:', event);
    this.startDate = event.startDate;
    this.endDate = event.endDate;
  }

  onSucursalSeleccionada(sucursal: any) {
    this.sucursalSeleccionada = sucursal?.id || '';
    console.log('Sucursal seleccionada:', sucursal);
  }

  onCuentaContableSeleccionada(cuenta: any) {
    this.cuentaContableSeleccionada = cuenta?.id || '';
    console.log('Cuenta contable seleccionada:', cuenta);
  }

  onCentroCostoSeleccionado(centroCosto: any) {
    this.centroCostoSeleccionado = centroCosto?.id || '';
    console.log('Centro de costo seleccionado:', centroCosto);
  }

  generarAnalisis() {
    this.analisisGenerado = true;
    this.analisisFacade.cargarDatos();
  }

  // Método llamado por VistaCellRenderComponent al hacer clic en el ojo
  abrirModal(value: string, rowData: any) {
    this.abrirModalDetalleAsiento(rowData);
  }

  async abrirModalDetalleAsiento(data: any) {
    // Preparar detalles para el modal
    const detalles: DetalleItem[] = [
      { label: 'Fecha de registro', value: data.ana_cta_fecha_registro || '-' },
      { label: 'Origen', value: data.ana_cta_fecha_contable || '-' },
      { label: 'Sucursal', value: data.ana_cta_duplicado || '-' },
      { label: 'Total Debe (S/)', value: '5,500.00' },
      { label: 'Estado', value: 'Activo' },
      { label: 'Total Haber (S/)', value: '5,500.00' }
    ];

    // Columnas para la tabla de cuentas
    const columnDefsModal: ColDef[] = [
      { field: 'ana_cta_det_cta_contable', headerName: 'Cuenta Contable', width: 130 },
      { field: 'ana_cta_det_descripcion', headerName: 'Descripción', flex: 1 },
      { field: 'ana_cta_det_debe', headerName: 'Debe (S/)', headerClass: 'derechaencabezado', width: 100, cellStyle: { textAlign: 'right' }},
      { field: 'ana_cta_det_haber', headerName: 'Haber (S/)', headerClass: 'derechaencabezado', width: 100, cellStyle: { textAlign: 'right' }},
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Información del asiento contable ${data.ana_cta_nro_asiento || 'ASC-2025-000145'}`,
        subtitulomodal: 'Detalle del asiento:',
        detalles: detalles,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        ocultarBotonConfirmar: true,
        textoBotonCancelar: 'Cerrar',
        mostrarTabla: true,
        colDefs: columnDefsModal,
        rowData: data.ana_cta_detalles || [],
        mostrarTotales: true,
        totalDebe: '5,500.00',
        totalHaber: '5,500.00'
      }
    });

    await modal.present();
  }
}
