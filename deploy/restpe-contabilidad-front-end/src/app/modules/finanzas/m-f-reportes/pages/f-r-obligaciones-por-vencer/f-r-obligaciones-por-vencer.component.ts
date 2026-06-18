import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
// Clean Architecture — Obligaciones por Vencer
import { ObligacionVencerFacade } from '../../../application/facades/obligacion-vencer.facade';
import { ObligacionVencerFeedbackEffects } from '../../../effects/obligacion-vencer-feedback.effect';
import { ObligacionVencerEntity } from '../../../domain/models/obligacion-vencer.entity';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-f-r-obligaciones-por-vencer',
  templateUrl: './f-r-obligaciones-por-vencer.component.html',
  styleUrls: ['./f-r-obligaciones-por-vencer.component.scss'],
  standalone: false,
})
export class FRObligacionesPorVencerComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;


  //Tipo de cambio para ecuador

  pais = this.countryService.getCountryCode();
  mostrarTipoCambio: boolean = true;


  //RANGO DE FECHAS
  startDateFiltro: Date | undefined;
  endDateFiltro: Date | undefined;
  minDate: Date;
  maxDate: Date;
  mesSeleccionadoE: string | null = null;
  anioSeleccionadoE: number | null = null;
  mesSeleccionadoV: string | null = null;
  anioSeleccionadoV: number | null = null;

  periodoE: string = '';
  periodoV: string = '';

  private gridApi!: GridApi;

  // Variables para el flujo de generación de reporte
  reporteGenerado: boolean = false;
  fechaEjecucion = '';
  monedaSeleccionada: string[] = [];
  estadoSeleccionado: string[] = [];
  sucursalesSeleccionadas: string[] = [];
  tipoSeleccionado: string = 'emision';
  tipoCambio = '3.45';

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

  cuentasPorSucursal: ObligacionVencerEntity[] = [];
  private gridApiDetalle!: GridApi;
  context: any;
  monedaSelect = [
    { id: 'Soles', nombre: 'Soles' },
    { id: 'Dólares', nombre: 'Dólares' },
  ]

  estadoSelect = [
    { id: 'Por vencer', nombre: 'Por vencer' },
    { id: 'Vencida', nombre: 'Vencida' },
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

  rowDataDetalle: ObligacionVencerEntity[] = [];

  colDefsDetalle: ColDef[] = [
    { field: 'ov_sucursal', headerName: 'Sucursal', width: 150, filter: true },
    { field: 'ov_proveedor', headerName: 'Proveedor', width: 200, filter: true },
    { field: 'ov_ruc', headerName: 'Documento fiscal', width: 120 },
    { field: 'ov_tipoDoc', headerName: 'Tipo de comprobante', width: 120, filter: true },
    { field: 'ov_nroDoc', headerName: 'N° de documento', width: 120 },
    {
      field: 'ov_moneda', headerName: 'Moneda', width: 90, filter: true,
      valueFormatter: (params: any) => {
        if (params.data?.ov_moneda === 'Soles') {
          return `S/ ${params.value}`;
        } else if (params.data?.ov_moneda === 'Dólares') {
          return `$ ${params.value}`;
        }
        return params.value;
      }
    },
    {
      field: 'ov_tipoCambio', headerName: 'Tipo cambio', width: 100, headerClass: 'derechaencabezado', hide: this.pais === 'EC',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      valueFormatter: (params: any) => {
        if (params.data?.ov_moneda === 'Soles') {
          return `${params.value}`;
        } else if (params.data?.ov_moneda === 'Dólares') {
          return `${params.value}`;
        }
        return params.value;
      }
    },
    {
      field: 'ov_montoTotal', headerName: 'Monto total', width: 120, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      valueFormatter: (params: any) => {
        const formattedValue = new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2,
        }).format(params.value);
        if (params.data?.ov_moneda === 'Soles') {
          return `S/ ${formattedValue}`;
        } else if (params.data?.ov_moneda === 'Dólares') {
          return `$ ${formattedValue}`;
        }
        return params.value;
      }
    },
    {
      field: 'ov_saldoPendiente', headerName: 'Saldo pendiente', width: 120, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      valueFormatter: (params: any) => {
        const formattedValue = new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2,
        }).format(params.value);
        if (params.data?.ov_moneda === 'Soles') {
          return `S/ ${formattedValue}`;
        } else if (params.data?.ov_moneda === 'Dólares') {
          return `$ ${formattedValue}`;
        }
        return params.value;
      }
    },
    {
      field: 'ov_vencimiento', headerName: 'Vencimiento', width: 120,
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
    { field: 'ov_venceEn', headerName: 'Vence en', width: 90 },
    { field: 'ov_mora', headerName: 'Días mora', width: 80 },
    {
      field: 'ov_numeroAsiento',
      headerName: 'N° de asiento',
      width: 130,
      cellRendererSelector: (params: any) => {
        if (params.data?.ov_estado === 'Por vencer') {
          return { component: VistaCellRenderComponent };
        }
        return undefined;
      },
      valueFormatter: (params: any) => {
        if (params.data?.ov_estado === 'Vencida') {
          return '-';
        }
        return params.value;
      }
    },
    { field: 'ov_observaciones', headerName: 'Observaciones', flex: 1, minWidth: 200 },
    {
      field: 'ov_estado', headerName: 'Estado', width: 110, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }, filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Vencida') {
          return '<span class="badge-table bg-[#FFF0BF] text-yellow">Vencida</span>';
        } else if (params.value === 'Por vencer') {
          return '<span class="badge-table bg-[#FFDECC] text-warning">Por vencer</span>';
        }
        return params.value;
      }
    }
  ];

  private readonly facade = inject(ObligacionVencerFacade);
  private readonly feedbackEffects = inject(ObligacionVencerFeedbackEffects);
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
      const obligaciones = this.facade.obligaciones();
      if (obligaciones.length > 0) {
        this.cuentasPorSucursal = obligaciones;
        if (this.reporteGenerado) {
          this.filtrarMovPorReporte();
          this.toastService.success('¡Reporte generado exitosamente!');
        }
      }
    });
  }

  ngOnInit() {

    this.sucursalesSeleccionadas = [];
    this.rowDataDetalle = [];
    this.fechaEjecucion = this.getFechaHoy();
    this.context = { componentParent: this };

    //Labels de formulario: Tipo de cambio por ahora
    this.configurarLabelsPorPais();
  }

  ngOnDestroy() {
    this.facade.resetState();
  }

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
  onmonedaSeleccionada(moneda: any) {
    if (moneda) {
      this.monedaSeleccionada = moneda;
    } else {
      this.monedaSeleccionada = [];
    }
  }
  onestadoSeleccionado(estado: any) {
    if (estado) {
      this.estadoSeleccionado = estado;
    } else {
      this.estadoSeleccionado = [];
    }
  }

  onMonthYearChangePeriodoE(event: { month: string; year: number }) {
    this.mesSeleccionadoE = event.month;
    this.anioSeleccionadoE = event.year;
    this.periodoE = `${this.mesSeleccionadoE}` + ` ${this.anioSeleccionadoE}`;
  }

  onMonthYearChangePeriodoV(event: { month: string; year: number }) {
    this.mesSeleccionadoV = event.month;
    this.anioSeleccionadoV = event.year;
    this.periodoV = `${this.mesSeleccionadoV}` + ` ${this.anioSeleccionadoV}`;
  }

  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  generarReporte() {
    // Validar campos requeridos
    if (!this.periodoE || this.periodoE.length === 0) {
      this.toastService.danger("Debes seleccionar una fecha de emisión");
      return;
    }
    if (!this.periodoV || this.periodoV.length === 0) {
      this.toastService.danger("Debes seleccionar una fecha de vencimiento");
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
    this.facade.cargarObligaciones();
  }

  filtrarMovPorReporte() {

    // Obtener los documentos de todas las sucursales seleccionadas
    let movimiento = this.cuentasPorSucursal.filter((cuenta: any) =>
      this.sucursalesSeleccionadas.includes(cuenta.ov_sucursal)
    );

    // Filtrar por moneda seleccionada
    if (this.monedaSeleccionada && this.monedaSeleccionada.length > 0) {
      movimiento = movimiento.filter((m: any) => this.monedaSeleccionada.includes(m.ov_moneda));
    }

    // Filtrar por estado
    if (this.estadoSeleccionado && this.estadoSeleccionado.length > 0) {
      movimiento = movimiento.filter((m: any) => this.estadoSeleccionado.includes(m.ov_estado));
    }

    // Asignar los movimientos filtrados a la tabla de detalles
    this.rowDataDetalle = movimiento;
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
    this.periodoE = '';
    this.periodoV = '';
    this.monedaSeleccionada = [];
    this.sucursalesSeleccionadas = [];
    this.estadoSeleccionado = [];
    this.fechaEjecucion = this.getFechaHoy();

    this.toastService.warning("Reporte cancelado");

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
      { fechaHora: `${this.fechaEjecucion} 10:30`, usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: `Se ha generado el reporte de obligaciones por vencer para las sucursales: ${this.sucursalesSeleccionadas.join(', ') || 'N/A'}` },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones de reportes de obligaciones por vencer`,
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
        mmostrarBotonEliminar: false,
        colDefs: colDefs,
        rowData: [
          {
            cuentaContable: rowData.cuentaC || '151002',
            descripcion: `Asiento para ${rowData.proveedor || 'Proveedor'}`,
            debe: rowData.saldoPendiente || 5000,
            haber: rowData.montoTotal || 10000
          },
          {
            cuentaContable: '381001',
            descripcion: 'Contrapartida del asiento',
            debe: rowData.montoTotal || 10000,
            haber: rowData.saldoPendiente || 5000
          }
        ]
      }
    });

    await modal.present();
  }
}
