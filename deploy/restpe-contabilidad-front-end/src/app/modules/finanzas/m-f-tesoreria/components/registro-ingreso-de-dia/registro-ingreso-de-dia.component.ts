import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ModalController } from '@ionic/angular';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { RegistroIngresoDeDiaEntity } from 'src/app/modules/finanzas/domain/models/registro-ingreso-de-dia.entity';
import { RegistroIngresoDeDiaFacade } from 'src/app/modules/finanzas/application/facades/registro-ingreso-de-dia.facade';
import { RegistroIngresoDeDiaFeedbackEffects } from 'src/app/modules/finanzas/effects/registro-ingreso-de-dia-feedback.effect';
import { AccionesHerramientasCellRenderComponent } from 'src/app/ui/acciones-herramientas-cell-render/acciones-herramientas-cell-render.component';
import { ModalRegistrarIngresosComponent } from 'src/app/ui/modal-registrar-ingresos/modal-registrar-ingresos.component';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faCreditCard, faDollar, faDownload, faMoneyBill, faRotateRight, faShield } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-registro-ingreso-de-dia',
  templateUrl: './registro-ingreso-de-dia.component.html',
  styleUrls: ['./registro-ingreso-de-dia.component.scss'],
  standalone: false,
})
export class RegistroIngresoDeDiaComponent implements OnInit, OnDestroy {
  private readonly facade = inject(RegistroIngresoDeDiaFacade);
  private readonly feedbackEffects = inject(RegistroIngresoDeDiaFeedbackEffects);
  readonly isLoading = this.facade.isLoading;

  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasCreditCard = faCreditCard;
  fasDollar = faDollar;
  fasDownload = faDownload;
  fasMoneyBill = faMoneyBill;
  fasRotateRight = faRotateRight;
  fasShield = faShield;


  private gridApi!: GridApi;

  // Control de estado de botones
  canExport: boolean = false;
  canSearch: boolean = false;
  hasSearched: boolean = false;

  // Filtros
  filtroSucursal: string = '';
  filtroCaja: string = '';
  filtroMedioPago: string = '';
  filtroEstado: string = '';
  filtroUsuario: string = '';

  // Fecha
  fechaSeleccionada: Date | undefined;
  minDate: Date;
  maxDate: Date;

  // Totales para las cards
  totalIngresosDia: string = 'S/ 48,531.25';
  ingresosEfectivo: string = 'S/ 15,420.50';
  ingresosTarjeta: string = 'S/ 15,170.75';
  ingresosTransferencia: string = 'S/ 15,170.75';
  mostrarRegistro: boolean = false;

  // Listas para filtros
  sucursalesList = [
    { id: '1', nombre: 'Sucursal Lima Centro' },
    { id: '2', nombre: 'Sucursal Miraflores' },
    { id: '3', nombre: 'Sucursal San Isidro' },
    { id: '4', nombre: 'Sucursal Surco' }
  ];

  cajasList = [
    { id: '1', nombre: 'Caja principal' },
    { id: '2', nombre: 'Caja barra' },
    { id: '3', nombre: 'Caja terraza' },
    { id: '4', nombre: 'Caja delivery' }
  ];

  mediosPagoList = [
    { id: '1', nombre: 'Efectivo' },
    { id: '2', nombre: 'Tarjeta' },
    { id: '3', nombre: 'Transferencia' }
  ];

  estadosList = [
    { id: 'Procesado', nombre: 'Procesado' },
    { id: 'Conciliado', nombre: 'Conciliado' }
  ];

  usuariosList = [
    { id: '1', nombre: 'Juan Pérez' },
    { id: '2', nombre: 'María García' },
    { id: '3', nombre: 'Carlos López' }
  ];

  // Configuración ag-grid
  rowData: RegistroIngresoDeDiaEntity[] = [];
  colDefs: ColDef[] = [
    { field: 'rid_caja', headerName: 'Caja', width: 130, minWidth: 130 },
    { field: 'rid_fecha', headerName: 'Fecha', width: 100,  minWidth: 100 },
    { field: 'rid_medioPago', headerName: 'Medio de pago', width: 130, minWidth: 130 },
    {
      field: 'rid_montoTotal',
      headerName: 'Monto total',
      width: 120, minWidth: 120,
      headerClass: 'ag-right-aligned-header',
      cellStyle: { textAlign: 'right' }
    },
    {
      field: 'rid_nComprobantes',
      headerName: 'N° comprobantes',
      width: 140, minWidth: 140,
      cellRenderer: VistaCellRenderComponent
    },
    { field: 'rid_usuario', headerName: 'Usuario', flex: 1, minWidth: 130 },
    { field: 'rid_cuentaIngreso', headerName: 'Cuenta de ingreso', width: 150, minWidth: 150 },
    {
      field: 'rid_asientoContable',
      headerName: 'Asiento contable',
      width: 140, minWidth: 140,
      cellRenderer: VistaCellRenderComponent
    },
    { field: 'rid_observaciones', headerName: 'Observaciones', flex: 1, minWidth: 150 },
    {
      field: 'rid_estado',
      headerName: 'Estado',
      width: 110, minWidth: 110,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Procesado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Procesado</span>';
        } else if (params.value === 'Conciliado') {
          return '<span class="badge-table bg-[#D6E6FF] text-[#3B82F6]">Conciliado</span>';
        }
        return params.value;
      }
    },
    {
      field: 'rid_acciones',
      headerName: 'Acciones',
      width: 80,
      minWidth: 80,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: AccionesHerramientasCellRenderComponent
    },
  ];

  columnTypes = {
    VistaCellRenderComponent: {
      cellRenderer: VistaCellRenderComponent,
    },
    AccionesHerramientasCellRenderComponent: {
      cellRenderer: AccionesHerramientasCellRenderComponent,
    }
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

  constructor(private modalController: ModalController, private toastService: ToastService) {
    this.minDate = new Date(2020, 0, 1);
    this.maxDate = new Date();
    effect(() => {
      const ingresos = this.facade.ingresos();
      this.rowData = ingresos;
      if (this.gridApi) this.gridApi.setGridOption('rowData', this.rowData);
    });
  }

  ngOnInit() {
    this.fechaSeleccionada = new Date();
    this.onFilterChange();
    // No cargar datos inicialmente, esperar a que el usuario presione "Buscar"
  }

  ngOnDestroy() {
    this.facade.resetState();
  }

  onFilterChange() {
    // Solo el responsable de cierre es obligatorio
    const hasRequiredFilter = !!this.filtroUsuario;

    this.canSearch = hasRequiredFilter;

    if (this.hasSearched && hasRequiredFilter) {
      this.hasSearched = false;
    }
  }

  onResponsableSelected(item: any) {
    this.filtroUsuario = item?.id || '';
    this.onFilterChange();
  }

  onSucursalSelected(item: any) {
    this.filtroSucursal = item?.id || '';
    this.onFilterChange();
  }

  onFechaSelected(fecha: Date) {
    this.fechaSeleccionada = fecha;
    this.onFilterChange();
  }

  buscar() {
    if (!this.canSearch) return;

    console.log('Buscando ingresos con filtros:', {
      caja: this.filtroCaja,
      medioPago: this.filtroMedioPago,
      estado: this.filtroEstado,
      // usuario: this.filtroUsuario,
      fecha: this.fechaSeleccionada
    });

    this.mostrarRegistro = true;
    this.facade.cargarIngresos();

    this.canExport = true;
    this.hasSearched = true;
    this.canSearch = false;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.gridApi.sizeColumnsToFit();
  }

  async modalRegistrarIngreso() {
    const DetalleItem: DetalleItem[] = [
      { label: 'Caja', value: '14/01/2025' },
      { label: 'Medio de pago', value: 'Efectivo' },
      { label: 'Monto total', value: 'S/ 15,420.50' },
    ]
    const modal = await this.modalController.create({
      component: ModalRegistrarIngresosComponent,
      cssClass: 'promo',
      componentProps: {
        ajustarregistro: false,
      }
    });
    await modal.present();
    
    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      this.toastService.success('¡Ingreso registrado exitosamente!');
    }
  }

  // Método llamado por VistaCellRenderComponent cuando se hace clic en el ojo
  async abrirModal(value: any, rowData: any) {
    console.log('Abriendo modal para:', value, rowData);

    // Determinar si es número de comprobantes o asiento contable
    const esComprobante = !value.includes('MN') && !value.includes('-');
    const esAsiento = value.includes('MN-');

    if (esComprobante) {
      await this.abrirModalComprobantes(value, rowData);
    } else if (esAsiento) {
      await this.abrirModalAsiento(value, rowData);
    }
  }

  async abrirModalComprobantes(nComprobantes: string, rowData: any) {
    const detalleIngreso: DetalleItem[] = [
      { label: 'Fecha', value: rowData.rid_fecha },
      // { label: 'Usuario', value: rowData.usuario },
      { label: 'Venta total', value: rowData.rid_montoTotal },
    ];

    // Datos de comprobantes
    const comprobantesData = [
      { comprobante: 'B001-0001234', tipoVenta: 'Delivery', cliente: 'Cliente varios', subtotal: 'S/ 100.00', igv: 'S/ 18.00', monto: 'S/ 145.50', estado: 'Registrado'},
      { comprobante: 'B001-0001234', tipoVenta: 'Delivery', cliente: 'Cliente varios', subtotal: 'S/ 100.00', igv: 'S/ 18.00', monto: 'S/ 145.50', estado: 'Ajustado'},
      { comprobante: 'B001-0001234', tipoVenta: 'Delivery', cliente: 'Cliente varios', subtotal: 'S/ 100.00', igv: 'S/ 18.00', monto: 'S/ 145.50', estado: 'Registrado'},
    ];

    const colDefsComprobantes: ColDef[] = [
      { field: 'comprobante', headerName: 'N° Comprobante', width: 120 },
      { field: 'tipoVenta', headerName: 'Tipo', width: 80 },
      { field: 'cliente', headerName: 'Cliente', flex: 1, minWidth: 150 },
      { field: 'subtotal', headerName: 'Subtotal', width: 80, headerClass: 'derechaencabezado',
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center',}
       },
      { field: 'igv', headerName: 'IGV', width: 80, headerClass: 'derechaencabezado',
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center',}
       },
      { field: 'monto', headerName: 'Monto total', width: 100, headerClass: 'derechaencabezado',
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center',}
       },
      { headerClass: 'centrarencabezado',field: 'estado', headerName: 'Estado', width: 80,
        cellRenderer: (params: any) => {
        if (params.value === 'Registrado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Registrado</span>';
        } else if (params.value === 'Ajustado') {
          return '<span class="badge-table bg-[#FFF0BF] text-[#F2A626]">Ajustado</span>';
        }
        return params.value;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center'},
       }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `ComprobantesDetalle de ventas - Caja principal`,
        // subtitulomodal: `${nComprobantes} comprobantes registrados`,
        detalles: detalleIngreso,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        textoBotonCancelar: 'Cerrar',
        widthModal: '740px ',
        mostrarTabla: true,
        colDefs: colDefsComprobantes,
        rowData: comprobantesData
      }
    });

    await modal.present();
  }

  async abrirModalAsiento(numeroAsiento: string, rowData: any) {
    const detalleAsiento: DetalleItem[] = [
      { label: 'Fecha de registro', value: '12/12/2025' },
      { label: 'Fecha contable', value: '12/12/2025' },
      { label: 'Glosa', value: 'Registro de ventas diarias en efectivo – Caja Principal (15/01/2025).' },
      { label: 'Total', value: 'S/ 15,420.50' },
      { label: 'Duplicado', value: 'No' },
    ];

    const asientoData = [
      { cuenta: '631109', descripcion: 'Servicios de internet', debe: 'S/ 380.00', haber: '-', centroCosto: 'CC-SI01', docReferencial: 'F001- 000123', tercero: 'Claro Perú'},
      { cuenta: '421101', descripcion: 'Proveedores Nacionales / Cuentas por Pagar Comerciales', debe: '-', haber: 'S/380.00', centroCosto: 'CC-SI01', docReferencial: 'F001- 000123', tercero: 'Claro Perú'},
    ];

    const colDefsAsiento: ColDef[] = [
      { field: 'cuenta', headerName: 'Cuenta', width: 80 },
      { field: 'descripcion', headerName: 'Descripción', flex: 1, minWidth: 180 },
      { field: 'debe', headerName: 'Debe (S/)', width: 100, headerClass: 'ag-right-aligned-header', 
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center',}
      },
      { field: 'haber', headerName: 'Haber (S/)', width: 100, headerClass: 'ag-right-aligned-header', 
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center',}
      },
      { field: 'centroCosto', headerName: 'Centro de costo', width: 110},
      { field: 'docReferencial', headerName: 'Doc. referencial', width: 110},
      { field: 'tercero', headerName: 'Tercero', width: 100},
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Asiento ${numeroAsiento}`,
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
          { label: 'Total debe (S/)', value: 'S/380.00' },
          { label: 'Total haber (S/)', value: 'S/380.00' }
        ]
      }
    });

    await modal.present();
  }
  async abrirModalAcciones() {
    const DetalleItem: DetalleItem[] = [
      { label: 'Caja', value: '14/01/2025' },
      { label: 'Medio de pago', value: 'Efectivo' },
      { label: 'Monto total', value: 'S/ 15,420.50' },
    ]
    const modal = await this.modalController.create({
      component: ModalRegistrarIngresosComponent,
      cssClass: 'promo',
      componentProps: {
        ajustarregistro: true,
        detalles: DetalleItem,
        botonguardar: 'Confirmar ajuste',
      }
    });
    await modal.present();
    
    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      this.toastService.success('¡Ajuste confirmado exitosamente!');
    }
  }

}
