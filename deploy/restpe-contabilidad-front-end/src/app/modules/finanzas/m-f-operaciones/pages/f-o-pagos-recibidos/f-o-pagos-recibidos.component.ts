import { Component, OnInit, inject, signal, computed, Signal, effect } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ModalPagarComponent } from '../../modals/modal-pagar/modal-pagar.component';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { BilleteCellRenderComponent } from 'src/app/ui/billete-cell-render/billete-cell-render.component';
import { AcciEditEliminarComponent } from 'src/app/ui/acci-edit-eliminar/acci-edit-eliminar.component';
import { DetalleItem } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalAgregarMedioDePagoComponent } from '../../modals/modal-agregar-medio-de-pago/modal-agregar-medio-de-pago.component';
import { ModalDetalleDocComponent } from '../../modals/modal-detalle-doc/modal-detalle-doc.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { PagoRecibidoFacade } from '../../../application/facades/pago-recibido.facade';
import { PagoRecibidoFeedbackEffects } from '../../../effects/pago-recibido-feedback.effect';
import { PagoRecibidoEntity } from '../../../domain/models/pago-recibido.entity';


@Component({
  selector: 'app-f-o-pagos-recibidos',
  templateUrl: './f-o-pagos-recibidos.component.html',
  styleUrls: ['./f-o-pagos-recibidos.component.scss'],
  standalone: false,
})
export class FOPagosRecibidosComponent implements OnInit {
  // ── Arquitectura limpia ───────────────────────────────────────────────────
  readonly pagoFacade = inject(PagoRecibidoFacade);
  private readonly _feedbackEffects = inject(PagoRecibidoFeedbackEffects);
  readonly isLoading: Signal<boolean> = this.pagoFacade.isLoading;
  readonly buscando = signal(false);
  readonly loaderActivo = computed(() => this.isLoading() || this.buscando());

  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  //RANGO DE FECHAS

  startDateEmision: Date | undefined;
  endDateEmision: Date | undefined;
  startDateVencimiento: Date | undefined;
  endDateVencimiento: Date | undefined;
  minDate: Date;
  maxDate: Date;
  mesSeleccionadoE: string | null = null;
  anioSeleccionadoE: number | null = null;
  mesSeleccionadoV: string | null = null;
  anioSeleccionadoV: number | null = null;
  periodoE: string = '';
  periodoV: string = '';

  private gridApi!: GridApi;
  context: any;

  // Variables para el flujo de generación de reporte
  docBuscados: boolean = false;
  fechaEjecucion = '';
  monedaSeleccionada: string = '';
  estadoSeleccionado: string = '';
  clienteSeleccionado: string = '';
  sucursalSeleccionada: any = null;
  tipoSeleccionado: string = '';
  totalDoc: number = 0;
  montoPendiente: string = '0.00';
  tipoCambio: string = '3.75';

  clientes = [
    { value: 'todos', nombre: 'Todos los clientes' },
    { value: 'cliente1', nombre: 'Restaurant El Buen Sabor S.A.C.' },
    { value: 'cliente2', nombre: 'Hotel Lima Plaza E.I.R.L.' },
    { value: 'cliente3', nombre: 'Catering & Eventos Del Sur' },
  ];

  tipoDoc = [
    { value: 'todos', nombre: 'Todos los tipos' },
    { value: 'factura', nombre: 'Factura' },
    { value: 'notaC', nombre: 'Nota de crédito' },
    { value: 'notaD', nombre: 'Nota de débito' },
    { value: 'letra', nombre: 'Letra' },
    { value: 'otros', nombre: 'Otros' },
  ]

  sucursales = [
    { id: 'La Molina, Lima', nombre: 'La Molina, Lima' },
    { id: 'San Isidro, Lima', nombre: 'San Isidro, Lima' },
    { id: 'San Borja, Lima', nombre: 'San Borja, Lima' },
    { id: 'Santa Isabel, Piura', nombre: 'Santa Isabel, Piura' },
  ];

  facturasData: PagoRecibidoEntity[] = [];

  monedaSelect = [
    'Todas las monedas',
    'Soles',
    'Dólares',
  ]

  estadoSelect = [
    'Todos los estados',
    'Pendiente',
    'Pagado',
    'Parcial',
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

  rowData: PagoRecibidoEntity[] = [];

  colDefs: ColDef[] = [
    {
      field: 'seleccionado',
      headerName: '',
      width: 50,
      headerCheckboxSelection: true,
      checkboxSelection: true,
      headerClass: 'centrarencabezadocheck',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
    { field: 'pago_codigo', headerName: 'Código', width: 80 },
    { field: 'pago_tipo_doc', headerName: 'Tipo de documento', flex: 1, minWidth: 150 },
    { field: 'pago_nro_doc', headerName: 'N° de documento', width: 150, cellRenderer: VistaCellRenderComponent },
    {
      field: 'pago_fecha_emision', headerName: 'Fecha de emisión', width: 130,
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
      field: 'pago_fecha_vencimiento', headerName: 'Fecha de vencimiento', width: 130,
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
    { field: 'pago_moneda', headerName: 'Moneda', width: 100 },
    { field: 'pago_tipo_cambio', headerName: 'Tipo de cambio', width: 120 },
    {
      field: 'pago_monto_total', headerName: 'Monto total', width: 120,
      valueFormatter: (params: any) => {
        if (params.data?.pago_moneda === 'Soles') {
          return `S/ ${params.value}`;
        }
        return params.value;
      }
    },
    {
      field: 'pago_monto_pendiente', headerName: 'Monto pendiente', width: 120,
      valueFormatter: (params: any) => {
        if (params.data?.pago_moneda === 'Soles') {
          return `S/ ${params.value}`;
        }
        return params.value;
      }
    },
    { field: 'pago_cuenta_contable', headerName: 'Cuenta contable', width: 130 },
    { field: 'pago_nro_asiento', headerName: 'N° asiento', width: 130, cellRenderer: VistaCellRenderComponent },
    {
      field: 'pago_estado', headerName: 'Estado', width: 100, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', },
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85 !w-16">Pendiente</span>';
        } else if (params.value === 'Pagado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagado</span>';
        } else if (params.value === 'Parcial') {
          return '<span class="badge-table bg-[#FFF0BF] text-[#F2A626]">Parcial</span>';
        }
        return params.value;
      },
    },
    {
      field: 'acciones',
      headerName: 'Acciones',
      width: 100,
      headerClass: 'centrarencabezado',
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: BilleteCellRenderComponent,
      cellRendererParams: {
        context: this
      }
    }
  ];

  constructor(
    private modalController: ModalController,
    private toastService: ToastService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
    this.context = { componentParent: this };

    // Sincronizar facturasData cuando lleguen los datos del store
    effect(() => {
      const pagos = this.pagoFacade.pagos();
      if (pagos.length > 0) {
        this.facturasData = pagos;
      }
    });
  }

  ngOnInit() {
    this.sucursalSeleccionada = null;
    this.rowData = [];
    this.pagoFacade.cargarPagos();
  }


  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onFechaEmision(event: any) {
    this.startDateEmision = event.startDate;
    this.endDateEmision = event.endDate;
  }

  onFechaVencimiento(event: any) {
    this.startDateVencimiento = event.startDate;
    this.endDateVencimiento = event.endDate;
  }

  onsucursalSeleccionada(event: any) {
    this.sucursalSeleccionada = event;
  }
  onMonthYearChangePeriodoE(event: { month: string; year: number }) {
    this.mesSeleccionadoE = event.month;
    this.anioSeleccionadoE = event.year;
    this.periodoE = `${this.mesSeleccionadoE}`+` ${this.anioSeleccionadoE}`; 
  }

  onMonthYearChangePeriodoV(event: { month: string; year: number }) {
    this.mesSeleccionadoV = event.month;
    this.anioSeleccionadoV = event.year;
    this.periodoV = `${this.mesSeleccionadoV}`+` ${this.anioSeleccionadoV}`; 
  }

  onFiltroChange() {
    // Este método se llama cada vez que cambia un filtro
    // No hace nada específico, solo dispara la detección de cambios
  }

  tieneFiltrosSeleccionados(): boolean {
    // Verificar si al menos un filtro tiene un valor válido
    const tieneCliente = this.clienteSeleccionado && this.clienteSeleccionado !== '' && this.clienteSeleccionado !== 'todos';
    const tieneTipo = this.tipoSeleccionado && this.tipoSeleccionado !== '' && this.tipoSeleccionado !== 'todos';
    const tieneEstado = this.estadoSeleccionado && this.estadoSeleccionado !== '' && this.estadoSeleccionado !== 'Todos los estados';
    const tieneMoneda = this.monedaSeleccionada && this.monedaSeleccionada !== '' && this.monedaSeleccionada !== 'Todas las monedas';
    const tieneFechaEmision = !!(this.startDateEmision && this.endDateEmision);
    const tieneFechaVencimiento = !!(this.startDateVencimiento && this.endDateVencimiento);
    const tieneSucursal = this.sucursalSeleccionada !== null && this.sucursalSeleccionada !== undefined;

    return tieneCliente || tieneTipo || tieneEstado || tieneMoneda || tieneFechaEmision || tieneFechaVencimiento || tieneSucursal;
  }

  onBtReset() {
    this.buscando.set(true);
    setTimeout(() => {
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }
      this.buscando.set(false);
    }, 400);
  }


  buscarDoc() {
    this.buscando.set(true);
    // Aplicar filtros
    let resultados = [...this.facturasData];

    // Filtrar por cliente si se seleccionó
    if (this.clienteSeleccionado && this.clienteSeleccionado !== '' && this.clienteSeleccionado !== 'todos') {
      // Aplicar filtro de cliente (ejemplo)
      // resultados = resultados.filter(...);
    }

    // Filtrar por tipo de documento
    if (this.tipoSeleccionado && this.tipoSeleccionado !== '' && this.tipoSeleccionado !== 'todos') {
      resultados = resultados.filter(doc => {
        if (this.tipoSeleccionado === 'factura') return doc.pago_tipo_doc === 'Factura';
        if (this.tipoSeleccionado === 'notaD') return doc.pago_tipo_doc === 'Nota de débito';
        return true;
      });
    }

    // Filtrar por estado
    if (this.estadoSeleccionado && this.estadoSeleccionado !== '' && this.estadoSeleccionado !== 'Todos los estados') {
      resultados = resultados.filter(doc => doc.pago_estado === this.estadoSeleccionado);
    }

    // Filtrar por moneda
    if (this.monedaSeleccionada && this.monedaSeleccionada !== '' && this.monedaSeleccionada !== 'Todas las monedas') {
      resultados = resultados.filter(doc => doc.pago_moneda === this.monedaSeleccionada);
    }

    // Filtrar por sucursal
    if (this.sucursalSeleccionada && this.sucursalSeleccionada !== null) {
      // Aplicar filtro de sucursal (ejemplo)
      // resultados = resultados.filter(...);
    }

    setTimeout(() => {
      // Mostrar resultados
      this.docBuscados = true;
      this.rowData = resultados;
      this.totalDoc = resultados.length;

      // Calcular monto pendiente total
      const totalPendiente = resultados.reduce((sum, doc) => {
        const monto = parseFloat(doc.pago_monto_pendiente.replace(',', ''));
        return sum + monto;
      }, 0);

      this.montoPendiente = totalPendiente.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

      const today = new Date();
      this.fechaEjecucion = `${String(today.getDate()).padStart(2, '0')}/${String(today.getMonth() + 1).padStart(2, '0')}/${today.getFullYear()}`;
      this.buscando.set(false);
    }, 400);
  }

  // async abrirModal(value: string, rowData: any) {
  //   // Este método será llamado desde el VistaCellRenderComponent
  //   // Distinguir si es número de documento o número de asiento
  //   if (rowData.nDoc === value) {
  //     // Clic en número de documento
  //     this.toastService.success(`Ver detalles del documento: ${value} - Cliente: ${rowData.tipoDoc} - Monto: S/ ${rowData.montoTotal}`);
  //     // Aquí puedes abrir un modal con los detalles del documento
  //   } else if (rowData.numeroA === value) {
  //     // Clic en número de asiento

  //     this.toastService.success(`Ver asiento contable: ${value} - Estado: ${rowData.estado}`);
  //     // Aquí puedes abrir un modal con los detalles del asiento
  //   }
  // }

  // Modal de documento y asiento 
  async abrirModal(value: any, rowData: any) {
    console.log('Abriendo modal para:', value, rowData);

    // Determinar si es documento o asiento basándose en el valor
    const esDocumento = value.includes('F') || value.includes('DOC');
    const esAsiento = value.includes('MN') || value.includes('ASC');

    if (esDocumento) {
      await this.abrirModalDocumento(value, rowData);
    } else if (esAsiento) {
      await this.abrirModalAsiento(value, rowData);
    }
  }

  async abrirModalDocumento(numeroDocumento: string, rowData: any) {
    const detalleDocumento = [
      { label: 'Cliente', value: 'Restaurante el Buen Sabor S.A.C.' },
      { label: 'Fecha emisión', value: '12/12/2025' },
      { label: 'Fecha vencimiento', value: '12/12/2025' },
      { label: 'Moneda', value: 'Soles' },
      { label: 'Monto total', value: 'S/ 1,000.00' },
      { label: 'Monto pendiente', value: 'S/ 200.00' },
      { label: 'Centro de costo', value: 'Almacenes y bodegas' },
      { label: 'Sucursal', value: 'Lima Centro' },
      { label: 'Estado', value: 'Pendiente' },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleDocComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Documento ${numeroDocumento}`,
        detalles: detalleDocumento,
        mostrarBotonPrimario: false,
        colorBoton: 'medium',
        
      }
    });

    await modal.present();

  }

    async abrirModalAsiento(numeroAsiento: string, rowData: any) {
    
      const detalleAsiento=[
        { label: 'Fecha de registro', value: '12/12/2025'},
        { label: 'Fecha contable', value: '12/12/2025'},
        { label: 'Glosa', value: 'Provisión de servicios de internet - Local San Isidro (Mes 11/2025)'},
        { label: 'Total', value: 'S/ 380.00'},
        { label: 'Duplicado', value: 'No'},

      ]
  
      const colDefs: ColDef[] = [
        {  field: 'cuentaContable',  headerName: 'Cuenta',  width: 70 },
        {  field: 'descripcion',  headerName: 'Descripción',  minWidth: 150, flex: 1 ,},
        { field: 'debe', headerName: 'Debe (S/)',  width: 80, headerClass: 'centrarencabezado',
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
        { field: 'haber', headerName: 'Haber (S/)', width: 80,
          headerClass: 'centrarencabezado',cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
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
        {  field: 'centroC',  headerName: 'Centro de costo',  width: 100 },
        {  field: 'docRef',  headerName: 'Documento referencial',  width: 110 },
        {  field: 'tercero',  headerName: 'Tercero',  width: 100 },
  
      ];
    
      const modal = await this.modalController.create({
        component: ModalDetalleComponent,
        cssClass: 'promo',
        componentProps: {
          tituloModal: `Asiento ${numeroAsiento}`,
          subtitulomodal: 'Detalle del asiento',
          detalles: detalleAsiento,
          widthModal: '740px',
          mostrarTabla: true,
          mostrarTextarea: false,
          mostrarBotonEliminar: false,
          colDefs: colDefs,
          mostrarTotal:true,
          itemstotal: [
            { label: 'Total debe (S/)', value: '380.00' },
            { label: 'Total haber (S/)', value: '380.00' },
          ],
          rowData: [
            {
              cuentaContable: rowData.pago_cuenta_contable || '151002',
              descripcion: `Servicios de internert ${rowData.proveedor || 'Proveedor'}`,
              debe: rowData.montoT || '380.00',
              haber: '',
              centroC: 'CC-SI01',
              docRef: 'F001-00123',
              tercero: 'Claro Peru',
            },
            {
              cuentaContable: '381001',
              descripcion: 'Proveedores nacionales / Cuentas por pagar comerciales',
              debe: '',
              haber: rowData.montoT || '380.00',
              centroC: 'CC-SI01',
              docRef: rowData.pago_nro_doc,
              tercero: 'Claro Peru',
            }
          ]
        }
      });
  
      await modal.present();
    }


  async abrirModalPagar(rowData: any) {
    // Obtener las filas seleccionadas
    const selectedRows = this.gridApi.getSelectedRows();
    
    if (selectedRows.length === 0) {
      this.toastService.warning('Por favor, selecciona al menos un documento');
      return;
    }

    const detallesEjemplo: DetalleItem[] = [
      { label: 'Cliente', value: 'Constructora ABC' },
      { label: 'Razón social', value: 'CONSTRUCTORA ABC S.A.C.' },
      { label: 'N° documento', value: selectedRows.length > 1 ? `${selectedRows.length} documentos seleccionados` : selectedRows[0].pago_nro_doc },
      { label: 'Monto pendiente', value: selectedRows.length > 1 ? this.calcularTotalPendiente(selectedRows) : selectedRows[0].pago_monto_pendiente },
    ];
    
    const modal = await this.modalController.create({
      component: ModalPagarComponent,
      cssClass: 'promo2',
      componentProps: {
        detalles: detallesEjemplo,
        rowData: selectedRows,
        widthModal: '684px',
      }
    });
    await modal.present();

    const result = await modal.onDidDismiss();

    if (result.data?.action == 'confirmar') {
      // Actualizar el estado de las filas seleccionadas a "Pagado"
      selectedRows.forEach(row => {
        row.pago_estado = 'Pagado';
        row.pago_monto_pendiente = '0';
      });

      // Usar applyTransaction para actualizar las filas
      this.gridApi.applyTransaction({ update: selectedRows });
      
      // Deseleccionar todas las filas
      this.gridApi.deselectAll();
      
      this.toastService.success('¡Se aplico el pago exitosamente!');
    }

  }

  calcularTotalPendiente(rows: any[]): string {
    const total = rows.reduce((sum, row) => {
      const monto = parseFloat(row.pago_monto_pendiente.replace(',', ''));
      return sum + monto;
    }, 0);
    return `S/ ${total.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigals: 2 })}`;
  }

  async abrirModalPago(value: string, rowData: any) {
    // Este método será llamado desde el BilleteCellRenderComponent
    // Verificar si hay filas seleccionadas
    const selectedRows = this.gridApi.getSelectedRows();
    const rowsToProcess = selectedRows.length > 0 ? selectedRows : [rowData];
    
    const detallesEjemplo: DetalleItem[] = [
      { label: 'Cliente', value: 'Constructora ABC' },
      { label: 'Razón social', value: 'CONSTRUCTORA ABC S.A.C.' },
      { label: 'N° documento', value: rowsToProcess.length > 1 ? `${rowsToProcess.length} documentos seleccionados` : rowsToProcess[0].pago_nro_doc },
      { label: 'Monto pendiente', value: rowsToProcess.length > 1 ? this.calcularTotalPendiente(rowsToProcess) : rowsToProcess[0].pago_monto_pendiente },
    ];

    const modal = await this.modalController.create({
      component: ModalPagarComponent,
      cssClass: 'promo2',
      componentProps: {
        detalles: detallesEjemplo,
        rowData: rowsToProcess,
        widthModal: '684px',
      }
    });

    await modal.present();

    const { data } = await modal.onDidDismiss();

    if (data?.action === 'confirmar') {
      // Actualizar el estado de todas las filas a "Pagado"
      rowsToProcess.forEach(row => {
        row.pago_estado = 'Pagado';
        row.pago_monto_pendiente = '0';
      });
      
      // Usar applyTransaction para actualizar las filas
      this.gridApi.applyTransaction({ update: rowsToProcess });
      
      // Deseleccionar todas las filas
      this.gridApi.deselectAll();
      
      this.toastService.success('¡Se aplico el pago exitosamente!');
    }
  }

  aplicarPago() {
    const selectedRows = this.gridApi.getSelectedRows();
    if (selectedRows.length === 0) {
      this.toastService.warning('Por favor, selecciona al menos un documento');
      return;
    }
    this.toastService.success(`Aplicar pago a ${selectedRows.length} documento(s) seleccionado(s)`);
    // Aquí puedes abrir un modal para aplicar pago masivo
  }

  onEditar(rowData: any) {
    this.toastService.success(`Editar documento: ${rowData.pago_nro_doc}`);
    // Aquí abre un modal para editar el documento
  }

  onEliminar(rowData: any) {
    this.toastService.warning(`Eliminar documento: ${rowData.pago_nro_doc}`);
    // Aquí puedes eliminar el documento o abrir un modal de confirmación
  }

}

