import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
// Clean Architecture — Reporte Finanzas
import { ReporteFinanzasFacade } from '../../../application/facades/reporte-finanzas.facade';
import { ReporteFinanzasFeedbackEffects } from '../../../effects/reporte-finanzas-feedback.effect';
import { ReporteFinanzasEntity } from '../../../domain/models/reporte-finanzas.entity';
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
  selector: 'app-f-r-finanzas',
  templateUrl: './f-r-finanzas.component.html',
  styleUrls: ['./f-r-finanzas.component.scss'],
  standalone: false,
})
export class FRFinanzasComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;


   //Tipo de cambio para ecuador

  pais = this.countryService.getCountryCode();
  mostrarTipoCambio: boolean = true;

  //RANGO DE FECHAS
  startDateRango: Date | undefined;
  endDateRango: Date | undefined;
  startDateFiltro: Date | undefined;
  endDateFiltro: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private gridApi!: GridApi;

  // Variables para el flujo de generación de reporte
  reporteGenerado: boolean = false;
  fechaEjecucion = '';
  monedaSeleccionada: string[] = [];
  estadoSeleccionado: string[] = [];
  sucursalesSeleccionadas: string[] = [];
  tipoCambio = '3.45';

  sucursales = [
    { id: 'La Molina, Lima', nombre: 'La Molina, Lima' },
    { id: 'San Isidro, Lima', nombre: 'San Isidro, Lima' },
    { id: 'San Borja, Lima', nombre: 'San Borja, Lima' },
    { id: 'Santa Isabel, Piura', nombre: 'Santa Isabel, Piura' },
  ];

  movimientoPorSucursal: ReporteFinanzasEntity[] = [];
  context: any;
  monedaSelect = [
    { id: 'Soles', nombre: 'Soles' },
    { id: 'Dólares', nombre: 'Dólares' }
  ];
  estadoSelect = [
    { id: 'Activo', nombre: 'Activo' },
    { id: 'Pendiente', nombre: 'Pendiente' },
    { id: 'Anulado', nombre: 'Anulado' }
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

  rowDataDetalle: ReporteFinanzasEntity[] = [];

  colDefsDetalle: ColDef[] = [
    {
      field: 'rf_fechaRegistro', headerName: 'Fecha de Registro', width: 120,
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
    { field: 'rf_sucursal', headerName: 'Sucursal', width: 120 },
    { field: 'rf_cliProveedor', headerName: 'Cliente / Proveedor', flex: 1, filter:true },
    { field: 'rf_nombre', headerName: 'Nombre', flex: 2 },
    {
      field: 'rf_documentofiscal', headerName: 'Documento fiscal', width: 120,
    },
    { field: 'rf_origenDoc', headerName: 'Origen del documento', width: 120 },
    {
      field: 'rf_tipoComp', headerName: 'Tipo de comprobante', flex:3, filter: true, 
      cellRenderer: (params: any) => {
        const tipoComp = params.value?.toString().trim();
        const nroDocumento = params.data?.rf_nucDoc?.toString().trim();

        if (!tipoComp) return '';

        // Verificar si es Nota de crédito
        if (tipoComp.toLowerCase().includes('nota de cr')) {
           return `<span>Nota de crédito</span> <span class="!font-bold">(${nroDocumento || ''})</span>`;
        }

        return tipoComp;
      }
    },
    { field: 'rf_nucDoc', headerName: 'N° de comprobante', width: 120, filter: true },

    // { field: 'tipoM', headerName: 'Tipo de movimiento', width: 140, filter: true },
    // { field: 'comprobante', headerName: 'Comprobante', width: 120 },
    // { field: 'entidadF', headerName: 'Entidad financiera', width: 150, filter: true },
    // { field: 'ncuenta', headerName: 'N° de cuenta', width: 150 },

    { field: 'rf_desConcepto', headerName: 'Descripción / Concepto', flex: 1, minWidth: 250 },
    { field: 'rf_moneda', headerName: 'Moneda', width: 70 },
    {
      field: 'rf_tipoCambio', headerName: 'Tipo de cambio', width: 80, headerClass: 'derechaencabezado', hide: this.pais === 'EC', 
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      valueFormatter: (params: any) => {
        return `${params.value}`;
      }
    },
    {
      field: 'rf_montoT', headerName: 'Monto total', width: 120, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      valueFormatter: (params: any) => {
        const formattedValue = new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2,
        }).format(params.value);
        return `S/ ${formattedValue}`;
      }
    },
    // { field: 'rf_cuentaC', headerName: 'Cuenta contable', width: 100 },
    { field: 'rf_numeroA', headerName: 'N° de asiento', width: 130, cellRenderer: VistaCellRenderComponent, },
    // { field: 'observaciones', headerName: 'Observaciones', flex: 1, minWidth: 200 },
    {
      field: 'rf_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }, filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
        } else if (params.value === 'Anulado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulado</span>';
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85 !w-16">Pendiente</span>';
        }
        return params.value;
      }
    }
  ];

  private readonly facade = inject(ReporteFinanzasFacade);
  private readonly feedbackEffects = inject(ReporteFinanzasFeedbackEffects);
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
      const movimientos = this.facade.movimientos();
      if (movimientos.length > 0) {
        this.movimientoPorSucursal = movimientos;
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
    this.onRangoFechas({ start: new Date(), end: new Date() });

    this.context = { componentParent: this };

    //Labels de formulario: Tipo de cambio por ahora
    this.configurarLabelsPorPais();

  }

  ngOnDestroy() {
    this.facade.resetState();
  }

  configurarLabelsPorPais() {
  if(this.pais === 'EC') {
    this.mostrarTipoCambio = false; // Ocultar tipo de cambio en Ecuador
  }
}

  getFechaHoy(): string {
    return new Date().toISOString().substring(0, 10);
  }

  onsucursalesSeleccionadas(sucursales: any) {
    if (sucursales) {
      this.sucursalesSeleccionadas = sucursales;
    } else {
      this.sucursalesSeleccionadas = [];
    }
  }
  onestadoSeleccionado(estado: any) {
    if (estado) {
      this.estadoSeleccionado = estado;
    } else {
      this.estadoSeleccionado = [];
    }
  }
  onmonedaSeleccionada(moneda: any) {
    if (moneda) {
      this.monedaSeleccionada = moneda;
    } else {
      this.monedaSeleccionada = [];
    }
  }



  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  generarReporte() {
    // Validar campos requeridos
    if (!this.startDateRango || !this.endDateRango) {
      this.toastService.danger("Debes seleccionar un rango de fecha de emisión");
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
    this.facade.cargarMovimientos();
  }

  filtrarMovPorReporte() {

    let movimiento = this.movimientoPorSucursal;

    // Filtrar por sucursal seleccionada
    if (this.sucursalesSeleccionadas && this.sucursalesSeleccionadas.length > 0) {
      movimiento = movimiento.filter((m: any) => this.sucursalesSeleccionadas.includes(m.rf_sucursal));
    }

    // Filtrar por moneda seleccionada
    if (this.monedaSeleccionada && this.monedaSeleccionada.length > 0) {
      movimiento = movimiento.filter((m: any) => this.monedaSeleccionada.includes(m.rf_moneda));
    }

    // Filtrar por estado
    if (this.estadoSeleccionado && this.estadoSeleccionado.length > 0) {
      movimiento = movimiento.filter((m: any) => this.estadoSeleccionado.includes(m.rf_estado));
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
    this.startDateRango = undefined;
    this.endDateRango = undefined;
    this.monedaSeleccionada = [];
    this.sucursalesSeleccionadas = [];
    this.estadoSeleccionado = [];
    this.fechaEjecucion = this.getFechaHoy();

    this.toastService.warning("Reporte cancelado");
    this.onRangoFechas({ start: new Date(), end: new Date() });

  }

  onRangoFechas(range: { start: Date; end: Date }) {
    this.startDateRango = range.start;
    this.endDateRango = range.end;
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
      { fechaHora: `${this.fechaEjecucion} 10:30`, usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: `Se ha generado el reporte de tesorería para las sucursales: ${this.sucursalesSeleccionadas.join(', ')}` },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones de reportes de tesorería`,
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
      { label: 'Sucursales', value: `${this.sucursalesSeleccionadas.join(', ')}` },
      { label: 'Total Debe (S/)', value: '5,5000.00' },
      { label: 'Estado', value: 'Registrado' },
      { label: 'Total Haber (S/)', value: '5,5000.00' },
    ]

    const colDefs: ColDef[] = [
      // { field: 'cuentaContable', headerName: 'Cuenta contable', width: 130 },
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
