import { Component, OnInit, inject, signal, computed, effect } from '@angular/core';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ModalController } from '@ionic/angular';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ConsultaDocumentosFacade } from 'src/app/modules/finanzas/application/facades/consulta-documentos.facade';
import { ConsultaDocumentosFeedbackEffects } from 'src/app/modules/finanzas/effects/consulta-documentos-feedback.effect';
import { ConsultaDocumentosEntity } from 'src/app/modules/finanzas/domain/models/consulta-documentos.entity';

// Font Awesome Icons
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-finanzas-consultas-consultas-documentos',
  templateUrl: './finanzas-consultas-consultas-documentos.component.html',
  styleUrls: ['./finanzas-consultas-consultas-documentos.component.scss'],
  standalone: false,
})
export class FinanzasConsultasConsultasDocumentosComponent implements OnInit {
  // ── Clean Architecture ───────────────────────────────────────────────────
  private readonly documentosFacade = inject(ConsultaDocumentosFacade);
  private readonly _effects = inject(ConsultaDocumentosFeedbackEffects);

  private readonly isLoading = this.documentosFacade.isLoading;
  readonly buscando = signal(false);
  readonly loaderActivo = computed(() => this.isLoading() || this.buscando());

  // Font Awesome Icons
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  private gridApi!: GridApi;

  // Control de estado de botones
  canExport: boolean = false;
  canSearch: boolean = false;
  hasSearched: boolean = false;

  // Propiedades individuales para filtros
  filtroUsuario: string = '';
  filtroTipoDocumento: string = '';
  filtroMoneda: string = '';
  filtroSucursal: string = '';
  filtroModuloOrigen: string = '';
  filtroEstado: string = 'registrado';

  // Fechas para el calendario
  minDate: Date;
  maxDate: Date;
  startDate: Date | undefined;
  endDate: Date | undefined;


  // Lista de usuarios para el autocomplete
  usuariosList = [
    { id: '1', nombre: 'Carlos Zapata' },
    { id: '2', nombre: 'Sandra Olivares' },
    { id: '3', nombre: 'Vanessa López' },
    { id: '4', nombre: 'César Pérez' },
    { id: '5', nombre: 'Úrsula Ríos' }
  ];

  // Lista de sucursales para el autocomplete
  sucursalList = [
    { id: '1', nombre: 'Centro de producción' },
    { id: '2', nombre: 'Sucursal principal' },
    { id: '3', nombre: 'Sucursal 1' },
    { id: '4', nombre: 'Sucursal 2' },
    { id: '5', nombre: 'Sucursal 3' }
  ];

  // Listas para los filtros select
  tiposDocumentoList = [
    { value: 'pago', label: 'Pago' },
    { value: 'cobro', label: 'Cobro' },
    { value: 'transferencia', label: 'Transferencia' },
    { value: 'anulacion', label: 'Anulación' },
    { value: 'otro', label: 'Otros' }
  ];

  monedasList = [
    { value: 'soles', label: 'Soles' },
    { value: 'dolares', label: 'Dólares' }
  ];

  modulosOrigenList = [
    { value: 'tesorería', label: 'Tesorería' },
    { value: 'ventas', label: 'Ventas' },
    { value: 'compras', label: 'Compras' },
    { value: 'conciliaciones', label: 'Conciliaciones' },
    { value: 'otro', label: 'Otros' }
  ];

  estadosList = [
    { value: 'todos', label: 'Todos' },
    { value: 'registrado', label: 'Registrado' },
    { value: 'pagado', label: 'Pagado' },
    { value: 'anulado', label: 'Anulado' },
    { value: 'en_revision', label: 'En revisión' },
  ];

  // Configuración ag-grid
  rowData: ConsultaDocumentosEntity[] = [];
  colDefs: ColDef[] = [
    { field: 'cdoc_tipo_documento', headerName: 'Tipo de documento', width: 150, minWidth: 130 },
    { field: 'cdoc_numero_documento', headerName: 'N° de documento', width: 130, minWidth: 130, cellRenderer: VistaCellRenderComponent },
    { field: 'cdoc_fecha_emision', headerName: 'Fecha emisión', width: 110, minWidth: 130 },
    { field: 'cdoc_modulo_origen', headerName: 'Módulo de origen', width: 130, minWidth: 130 },
    { field: 'cdoc_referencia', headerName: 'Referencia', width: 130, minWidth: 130 },
    { field: 'cdoc_moneda', headerName: 'Moneda', width: 80, minWidth: 80 },
    {
      field: 'cdoc_monto_total',
      headerName: 'Monto total',
      width: 110, minWidth: 110,
      headerClass: 'ag-right-aligned-header',
      cellStyle: {
        textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'end'
      }
    },
    { field: 'cdoc_cuenta_bancaria', headerName: 'Cuenta bancaria', width: 140, minWidth: 130 },
    { field: 'cdoc_responsable', headerName: 'Responsable', width: 130, minWidth: 130 },
    { field: 'cdoc_numero_asiento', headerName: 'N° de asiento', width: 110, minWidth: 130, cellRenderer: VistaCellRenderComponent },
    { field: 'cdoc_observaciones', headerName: 'Observaciones', width: 180, minWidth: 130 },
    {
      field: 'cdoc_estado',
      headerName: 'Estado',
      width: 100, minWidth: 130,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Registrado') {
          return `<span class="badge-table bg-[#F5F5F5] text-[#363636]">Registrado</span>`;
        } else if (params.value === 'Pagado') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagado</span>`;
        } else if (params.value === 'Anulado') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulado</span>`;
        } else if (params.value === 'En revisión') {
          return `<span class="badge-table bg-[#FEF3C7] text-[#F59E0B]">En revisión</span>`;
        }
        return params.value;
      }
    }
  ];

  columnTypes = {
    VistaCellRenderComponent: {
      cellRenderer: VistaCellRenderComponent,
    },
  };

  gridOptions = {
    context: {
      componentParent: this,
    },
  };

  localeText = {
    page: 'Página',
    more: 'más',
    to: 'a',
    of: 'de',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    loadingOoo: 'Cargando...',
    noRowsToShow: 'No hay datos para mostrar',
  };

  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null ||
        params.value === undefined ||
        params.value === ''
        ? '–'
        : params.value;
    },
    suppressMovable: true,
    sortable: true,
    resizable: true,
    wrapHeaderText: true,
    autoHeaderHeight: true,
  };

  constructor(private modalController: ModalController) {
    // Configurar fechas mínimas y máximas
    this.minDate = new Date(2020, 0, 1);
    this.maxDate = new Date();

    // Sync store → rowData
    effect(() => {
      const data = this.documentosFacade.registros();
      this.rowData = data;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }
    });
  }

  ngOnInit() {}

  onFilterChange() {
    // Verificar si hay al menos un filtro con valor
    const hasFilter = !!(this.filtroUsuario ||
      this.filtroTipoDocumento ||
      this.filtroMoneda ||
      this.filtroSucursal ||
      this.filtroModuloOrigen ||
      // this.filtroEstado || 
      (this.startDate && this.endDate));

    // El botón buscar se activa cuando hay al menos un filtro
    this.canSearch = hasFilter;

    // Si movió un filtro después de haber buscado, reactivar el botón buscar
    if (this.hasSearched && hasFilter) {
      this.hasSearched = false;
    }
  }

  buscar() {
    if (!this.canSearch) return;

    this.buscando.set(true);
    this.documentosFacade.cargarDatos();
    setTimeout(() => {
      this.buscando.set(false);
    }, 400);

    this.canExport = true;
    this.hasSearched = true;
    this.canSearch = false;
  }

  onSucursalSelected(sucursal: any) {
    this.filtroSucursal = sucursal?.id || '';
    console.log('Sucursal seleccionada:', sucursal);
    this.onFilterChange();
  }

  filtrarPorFechas(event: any) {
    console.log('Rango de fechas seleccionado:', event);
    this.startDate = event.startDate;
    this.endDate = event.endDate;
    this.onFilterChange();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.gridApi.sizeColumnsToFit();
  }

  onBtReset() {
    if (this.gridApi) {
      this.buscando.set(true);
      this.gridApi.setFilterModel(null);
      this.gridApi.setGridOption('rowData', [...this.rowData]);
      setTimeout(() => {
        this.buscando.set(false);
      }, 400);
    }
  }

  async abrirModal(value: any, rowData: any) {
    console.log('Abriendo modal para:', value, rowData);

    // Determinar si es documento o asiento basándose en el valor
    const esDocumento = value.includes('TRF') || value.includes('DOC');
    const esAsiento = value.includes('MN') || value.includes('ASC');

    if (esDocumento) {
      await this.abrirModalDocumento(value, rowData);
    } else if (esAsiento) {
      await this.abrirModalAsiento(value, rowData);
    }
  }

  async abrirModalDocumento(numeroDocumento: string, rowData: any) {
    const detalleDocumento: DetalleItem[] = [
      { label: 'Razón Social', value: 'RESTAURANTE EL SABOR PERUANO S.A.C.' },
      { label: 'Tipo documento', value: 'Transferencia' },
      { label: 'Fecha emisión', value: '05/11/2025' },
      { label: 'Monto total', value: 'S/ 5,500.00' },
      { label: 'Observaciones', value: 'Pago correspondiente al servicio del mes de octubre.' }
    ];

    // Datos de movimientos del documento
    const movimientosDocumento = [
      { fecha: '05/11/2025', tipoMov: 'Cargo', descripcion: 'Transferencia a proveedor', monto: 'S/ 5,500.00', saldoPosterior: 'S/ 30,950.78' },
      { fecha: '05/11/2025', tipoMov: 'Costo bancario', descripcion: 'Comisión Interbank', monto: 'S/ 3.50', saldoPosterior: 'S/ 30,947.28' }
    ];

    // Definir columnas para la tabla
    const colDefsMovimientos: ColDef[] = [
      { field: 'fecha', headerName: 'Fecha', width: 100 },
      { field: 'tipoMov', headerName: 'Tipo de movimiento', width: 120 },
      { field: 'descripcion', headerName: 'Descripción', flex: 1, minWidth: 150 },
      { field: 'monto', headerName: 'Monto', width: 110, headerClass: 'derechaencabezado',
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' }
      },
      { field: 'saldoPosterior', headerName: 'Saldo posterior', width: 120, headerClass: 'derechaencabezado',
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' }
      }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Movimientos del documento ${numeroDocumento}`,
        subtitulomodal: '',
        widthModal: '632px',
        detalles: detalleDocumento,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        textoBotonCancelar: 'Cerrar',
        mostrarTabla: true,
        colDefs: colDefsMovimientos,
        rowData: movimientosDocumento
      }
    });

    await modal.present();
  }

  async abrirModalAsiento(numeroAsiento: string, rowData: any) {
    const detalleAsiento: DetalleItem[] = [
      { label: 'Fecha de registro', value: rowData.cdoc_fecha_emision },
      { label: 'Origen', value: rowData.cdoc_modulo_origen },
      { label: 'Sucursal', value: 'Sucursal Principal' },
      // { label: 'Total Debe (S/)', value: rowData.cdoc_monto_total },
      { label: 'Estado', value: 'Registrado' },
      // { label: 'Total Haber (S/)', value: rowData.cdoc_monto_total }
    ];

    const asientoData = [
      { cuentaContable: '421101', descripcion: 'Proveedores nacionales', debe: rowData.cdoc_monto_total, haber: '-'},
      { cuentaContable: '101101', descripcion: 'Caja y Bancos – Interbank', debe: '-', haber: rowData.cdoc_monto_total }
    ];

    const colDefsAsiento: ColDef[] = [
      { field: 'cuentaContable', headerName: 'Cuenta contable', width: 130 },
      { field: 'descripcion', headerName: 'Descripción', flex: 1, minWidth: 150 },
      { field: 'debe', headerName: 'Debe (S/)', width: 100, headerClass: 'derechaencabezado', cellStyle: { textAlign: 'right', justifyContent: 'right', display: 'flex' } },
      { field: 'haber', headerName: 'Haber (S/)', width: 100, headerClass: 'derechaencabezado', cellStyle: { textAlign: 'right', justifyContent: 'right', display: 'flex' } }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Información del asiento contable ${numeroAsiento}`,
        widthModal: '740px',
        subtitulomodal: '',
        detalles: detalleAsiento,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        textoBotonCancelar: 'Cerrar',
        mostrarTabla: true,
        colDefs: colDefsAsiento,
        rowData: asientoData,
        mostrarTotal: true,
        itemstotal: [
          { label: 'Total Debe (S/)', value: rowData.cdoc_monto_total },
          { label: 'Total Haber (S/)', value: rowData.cdoc_monto_total }
        ]
      }
    });

    await modal.present();
  }

}
