import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { CuentaPagarFacade } from '../../../application/facades/cuenta-pagar.facade';
import { CuentaPagarFeedbackEffects } from '../../../effects/cuenta-pagar-feedback.effect';
import { CuentaPagarEntity } from '../../../domain/models/cuenta-pagar.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCalendar, faDownload, faPercent } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-f-r-cuentas-pagar',
  templateUrl: './f-r-cuentas-pagar.component.html',
  styleUrls: ['./f-r-cuentas-pagar.component.scss'],
  standalone: false,
})
export class FRCuentasPagarComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCalendar = faCalendar;
  fasDownload = faDownload;
  fasPercent = faPercent;


  //Tipo de cambio para ecuador

  pais = this.countryService.getCountryCode();
  mostrarTipoCambio: boolean = true;
  countries = ALL_COUNTRIES;
  //RANGO DE FECHAS
  startDateEmision: Date | undefined;
  endDateEmision: Date | undefined;
  startDateVencimiento: Date | undefined;
  endDateVencimiento: Date | undefined;
  startDateFiltro: Date | undefined;
  endDateFiltro: Date | undefined;
  minDate: Date;
  maxDate: Date;

  // Variables para el flujo de generación de reporte
  reporteGenerado: boolean = false;
  fechaEjecucion = '';
  tipoCambio = '3.45'
  monedaSeleccionada: string[] = [];
  estadoSeleccionado: string[] = [];
  sucursalesSeleccionadas: string[] = [];
  tipoSeleccionado: string = 'emision';
  private gridApiDetalle!: GridApi;

  tipoFs = [
    { value: 'emision', nombre: 'Emisión' },
    { value: 'vencimiento', nombre: 'Vencimiento' },
  ]

  sucursales = [
    { id: 'La Molina, Lima', nombre: 'La Molina, Lima' },
    { id: 'San Isidro, Lima', nombre: 'San Isidro, Lima' },
    { id: 'San Borja, Lima', nombre: 'San Borja, Lima' },
    { id: 'Santa Isabel, Piura', nombre: 'Santa Isabel, Piura' },
  ];

  facturasPorSucursal: CuentaPagarEntity[] = [];

  context: any;
  monedaSelect = [
    { id: 'Soles', nombre: 'Soles' },
    { id: 'Dólares', nombre: 'Dólares' },
  ]

  estadoSelect = [
    { id: 'Pendiente', nombre: 'Pendiente' },
    { id: 'Pagada', nombre: 'Pagada' },
    { id: 'Vencida', nombre: 'Vencida' },
    { id: 'Anulado', nombre: 'Anulado' },
    { id: 'Parcial', nombre: 'Parcial' },

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

  rowDataDetalle: CuentaPagarEntity[] = [];

  colDefsDetalle: ColDef[] = [
    { field: 'cpa_codigo', headerName: 'Código', width: 80 },
    // { field: 'cpa_sucursal', headerName: 'Sucursal', width: 150, filter: true, },
    { field: 'cpa_proveedor', headerName: 'Proveedor', width: 150, filter: true, },
    { field: 'cpa_ruc', headerName: 'Documento fiscal', width: 150 },
    { field: 'cpa_tipoDoc', headerName: 'Tipo de comprobante', width: 150 },
    { field: 'cpa_nDoc', headerName: 'N° comprobante', width: 150 },
    // { field: 'cpa_centroC', headerName: 'Centro de costos', width: 150, filter: true, },
    {
      field: 'cpa_fechaE', headerName: 'Fecha de emisión', width: 130,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
    },
    {
      field: 'cpa_fechaV', headerName: 'Fecha de vencimiento', width: 130,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
    },
    { field: 'cpa_moneda', headerName: 'Moneda', width: 100 },

    {
      field: 'cpa_tipoC', headerName: 'Tipo cambio', width: 100, headerClass: 'derechaencabezado', hide: this.pais === 'EC',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      valueFormatter: (params: any) => {
        return `S/ ${params.value}`;
      }
    },
    {
      field: 'cpa_montoT', headerName: 'Monto total', width: 120, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      valueFormatter: (params: any) => {
        return `S/ ${params.value}`;
      }
    },
    {
      field: 'cpa_montoP', headerName: 'Monto pagado', width: 120, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      valueFormatter: (params: any) => {
        return `S/ ${params.value}`;
      }
    },
    {
      field: 'cpa_saldoP', headerName: 'Saldo pendiente', width: 120, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      valueFormatter: (params: any) => {
        return `S/ ${params.value}`;
      }
    },
    { field: 'cpa_cuentaC', headerName: 'Cuenta contable', width: 130 },
    { field: 'cpa_centroC', headerName: 'Centro de costos', width: 130 },
    { field: 'cpa_numeroA', headerName: 'N° de asiento', width: 130, cellRenderer: VistaCellRenderComponent, },
    {
      field: 'cpa_estado', headerName: 'Estado', width: 100, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', }, filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Vencida') {
          return '<span class="badge-table bg-[#FFF0BF] text-yellow">Vencida</span>';
        } else if (params.value === 'Pagada') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagada</span>';
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85 !w-16">Pendiente</span>';
        } else if (params.value === 'Parcial') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Parcial</span>';
        }
        return params.value;
      },
    }
  ];


  private readonly facade = inject(CuentaPagarFacade);
  private readonly feedbackEffects = inject(CuentaPagarFeedbackEffects);
  readonly isLoading = this.facade.isLoading;

  constructor(
    private modalController: ModalController,
    private toastService: ToastService,
    private countryService: CountryService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    effect(() => {
      const facturas = this.facade.facturas();
      if (facturas.length > 0) {
        this.facturasPorSucursal = facturas;
        if (this.reporteGenerado) {
          this.filtrarFacturasPorReporte();
          this.toastService.success('¡Reporte generado exitosamente!');
        }
      }
    });
  }

  ngOnInit() {
    this.sucursalesSeleccionadas = [];
    this.rowDataDetalle = [];
    this.fechaEjecucion = this.getFechaHoy();
    this.onFechaEmision({ start: new Date(), end: new Date() });
    this.context = { componentParent: this };
    this.configurarLabelsPorPais();
  }

  ngOnDestroy() {
    this.facade.resetState();
  }
  // obtenerdatospais(){
  //   this.countries.find(country => {
  //     if(country.codigo === this.pais){

  //     }
  //   });
  // }

  configurarLabelsPorPais() {
    if (this.pais === 'EC') {
      this.mostrarTipoCambio = false; // Ocultar tipo de cambio en Ecuador
    }
  }



  getFechaHoy(): string {
    return new Date().toISOString().substring(0, 10);
  }

  onsucursalesSeleccionadas(sucursal: any) {
    if (sucursal) {
      this.sucursalesSeleccionadas = sucursal;
    } else {
      this.sucursalesSeleccionadas = [];
    }
  }
  onestadosSeleccionados(estado: any) {
    if (estado) {
      this.estadoSeleccionado = estado;
    } else {
      this.estadoSeleccionado = [];
    }
  }
  onmonedasSeleccionadas(moneda: any) {
    if (moneda) {
      this.monedaSeleccionada = moneda;
    } else {
      this.monedaSeleccionada = [];
    }
  }

  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApiDetalle = params.api;
  }

  generarReporte() {
    // Validar campos requeridos
    if (!this.startDateEmision || !this.endDateEmision) {
      this.toastService.danger("Debes seleccionar un rango de fecha de emisión");
      return;
    }
    if (!this.startDateVencimiento || !this.endDateVencimiento) {
      this.toastService.danger("Debes seleccionar un rango de fecha de vencimiento");
      return;
    }

    if (!this.monedaSeleccionada || this.monedaSeleccionada.length === 0) {
      this.toastService.danger("Debes seleccionar al menos una moneda");
      return;
    }

    if (!this.sucursalesSeleccionadas || this.sucursalesSeleccionadas.length === 0) {
      this.toastService.danger("Debes seleccionar al menos una sucursal");
      return;
    }

    if (!this.estadoSeleccionado || this.estadoSeleccionado.length === 0) {
      this.toastService.danger("Debes seleccionar al menos un estado");
      return;
    }

    // Generar el reporte
    this.reporteGenerado = true;
    this.fechaEjecucion = this.getFechaHoy();
    this.facade.resetState();
    this.facade.cargarFacturas();
  }

  filtrarFacturasPorReporte() {
    // Obtener las facturas de todas las sucursales seleccionadas
    let facturas = this.facturasPorSucursal.filter((factura: any) =>
      this.sucursalesSeleccionadas.includes(factura.cpa_sucursal)
    );

    // Filtrar por fecha de emisión
    if (this.startDateEmision && this.endDateEmision) {
      const startDate = new Date(this.startDateEmision);
      const endDate = new Date(this.endDateEmision);
      endDate.setHours(23, 59, 59, 999);

      facturas = facturas.filter((f: any) => {
        const fechaFactura = new Date(f.cpa_fechaE);
        return fechaFactura >= startDate && fechaFactura <= endDate;
      });
    }

    // Filtrar por fecha de vencimiento
    if (this.startDateVencimiento && this.endDateVencimiento) {
      const startDate = new Date(this.startDateVencimiento);
      const endDate = new Date(this.endDateVencimiento);
      endDate.setHours(23, 59, 59, 999);

      facturas = facturas.filter((f: any) => {
        const fechaFactura = new Date(f.cpa_fechaV);
        return fechaFactura >= startDate && fechaFactura <= endDate;
      });
    }

    // Filtrar por moneda seleccionada
    if (this.monedaSeleccionada && this.monedaSeleccionada.length > 0) {
      facturas = facturas.filter((f: any) => this.monedaSeleccionada.includes(f.cpa_moneda));
    }

    // Filtrar por estado seleccionado
    if (this.estadoSeleccionado && this.estadoSeleccionado.length > 0) {
      facturas = facturas.filter((f: any) => this.estadoSeleccionado.includes(f.cpa_estado));
    }

    // Asignar las facturas filtradas a la tabla de detalles
    this.rowDataDetalle = facturas;
  }

  async botonCancelar() {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Cancelar reporte',
        title: '¿Estás seguro de cancelar este reporte?',
        message:
          'Al cancelar este reporte, todo cálculo que hayas realizado se eliminará. Una vez cancelaado, no podrás modificar ni deshacer esta acción.',
        btnOkTxt: 'Sí, cancelar',
        btnCancelTxt: 'No, regresar',
      },
    });

    await modal.present();
    const { data } = await modal.onDidDismiss();

    if (data === true) {
      this.cancelarReporte();
    }
  }

  cancelarReporte() {
    // Limpiar el estado del reporte
    this.reporteGenerado = false;
    this.rowDataDetalle = [];

    // Limpiar variables de filtro
    this.startDateEmision = undefined;
    this.endDateEmision = undefined;
    this.startDateVencimiento = undefined;
    this.endDateVencimiento = undefined;
    this.monedaSeleccionada = [];
    this.sucursalesSeleccionadas = [];
    this.estadoSeleccionado = [];
    this.fechaEjecucion = this.getFechaHoy();

    this.toastService.warning("Reporte cancelado");
    this.onFechaEmision({ start: new Date(), end: new Date() });
    this.onFechaVencimiento({ start: new Date(), end: new Date() });

  }

  onFechaEmision(range: { start: Date; end: Date }) {
    this.startDateEmision = range.start;
    this.endDateEmision = range.end;
  }

  onFechaVencimiento(range: { start: Date; end: Date }) {
    this.startDateVencimiento = range.start;
    this.endDateVencimiento = range.end;
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDateFiltro = range.start;
    this.endDateFiltro = range.end;
  }

  async modalverActualizaciones() {
    // Definir las columnas
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 150, },
      { headerName: 'Usuario', field: 'usuario', width: 120, },
      {
        headerName: 'Acción', field: 'accion', width: 150,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
      {
        headerName: 'Detalle del cambio', field: 'detalleCambio', flex: 1,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
    ];

    // Datos de ejemplo
    const rowData = [
      { fechaHora: `${this.fechaEjecucion} 10:30`, usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: `Se ha generado el reporte de cuentas por pagar para las sucursales: ${this.sucursalesSeleccionadas.join(', ') || 'N/A'}` },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones de reportes de cuentas por pagar`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

  async abrirModal(numeroAsiento: string, rowData: any) {

    const detalleAsiento = [
      { label: 'Fecha de registro', value: '05/11/2025' },
      { label: 'Origen', value: 'Tesoreria' },
      { label: 'Sucursal', value: `${this.sucursalesSeleccionadas.join(', ')}` },
      { label: 'Total Debe (S/)', value: '5,5000.00' },
      { label: 'Estado', value: 'Registrado' },
      { label: 'Total Haber (S/)', value: '5,5000.00' },
    ]

    const colDefs: ColDef[] = [
      { field: 'cuentaContable', headerName: 'Cuenta contable', width: 130 },
      { field: 'descripcion', headerName: 'Descripción', width: 150, flex: 1, },
      {
        field: 'debe', headerName: 'Debe (S/)', width: 80, headerClass: 'centrarencabezado',
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
        field: 'haber', headerName: 'Haber (S/)', width: 80,
        headerClass: 'centrarencabezado', cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
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

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Informacíon del asiento contable ${numeroAsiento}`,
        subtitulomodal: 'Detalle del asiento',
        detalles: detalleAsiento,
        mostrarTabla: true,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        colDefs: colDefs,
        rowData: [
          {
            cuentaContable: rowData.cuentaC || '151002',
            descripcion: `Asiento para ${rowData.proveedor || 'Proveedor'}`,
            debe: rowData.montoT || 'S/0.00',
            haber: ''
          },
          {
            cuentaContable: '381001',
            descripcion: 'Contrapartida del asiento',
            debe: '',
            haber: rowData.montoT || 'S/0.00'
          }
        ]
      }
    });

    await modal.present();
  }
}