import { Component, ElementRef, OnInit, ViewChild, inject, computed, effect } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalVerActualizacionesComponent } from '../../../../../ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';
import { BotonAccionesComponent } from 'src/app/ui/boton-acciones/boton-acciones.component';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { AprobarGiroFacade } from 'src/app/modules/finanzas/application/facades/aprobar-giro.facade';
import { AprobarGiroEntity } from 'src/app/modules/finanzas/domain/models/aprobar-giro.entity';
import { AprobarGiroSyncEffects } from 'src/app/modules/finanzas/effects/aprobar-giro-sync.effect';
import { AprobarGiroFeedbackEffects } from 'src/app/modules/finanzas/effects/aprobar-giro-feedback.effect';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



interface IBanco {
  id: number;
  nombre: string;
  cuentaBancaria: string;
  condicionPago: string;
  numeroCuotas: number;
  montoTotal: number;
}

interface ICuentaB {
  id: number;
  nombre: string;
}

interface ICuota {
  numeroCuotas: number;
  montoTotal: number;
  fechaPago: string;
  estado: string;
}

interface INdeOrden {
  id: number;
  nombre: string;
  ruc: string;
  nombreBeneficiario: string;
  condicionPago: string;
  numeroCuotas: number;
  montoTotal: number;
  montoContado?: number;
  montoFinanciar?: number;
  cuotas?: ICuota[];
}

@Component({
  selector: 'app-f-a-aprobar-giro',
  templateUrl: './f-a-aprobar-giro.component.html',
  styleUrls: ['./f-a-aprobar-giro.component.scss'],
  standalone: false,
})
export class FAAprobarGiroComponent implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  @ViewChild('scrollBox', { read: ElementRef }) scrollBox!: ElementRef;

   //Tipo de cambio para ecuador
  pais = this.countryService.getCountryCode();
  mostrarTipoCambio: boolean = true;  

  // RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  // ESTADO DEL COMPONENTE
  filaSeleccionada: AprobarGiroEntity | null = null;
  panelLateralVisible = true;
  tabSeleccionado: string = 'registro';
  mostrarBuscadorPrincipal = true;
  botonesHabilitados = false;
  cantidadSeleccionadas = 0;
  fechaEjecucion: string = new Date().toLocaleDateString('es-PE');
  sucursalSeleccionada: { nombre: string } = { nombre: 'Lima - Sede Central' };

  // FACADE
  readonly aprobarGiroFacade = inject(AprobarGiroFacade);
  readonly loaderActivo = computed(() => this.aprobarGiroFacade.isLoading());

  // EFFECTS (inyectar para que los constructores registren los effect())
  private readonly _syncEffects = inject(AprobarGiroSyncEffects);
  private readonly _feedbackEffects = inject(AprobarGiroFeedbackEffects);

  // FORMULARIO
  AprobarGiroForm!: FormGroup;
  fechaprogramada: Date | undefined;

  // GRID
  private gridApi!: GridApi;

  frameworkComponents = {
    BotonAccionesComponent: BotonAccionesComponent,
    VistaCellRenderComponent: VistaCellRenderComponent,
  };

  gridOptions = {
    context: {
      componentParent: this,
    },
    frameworkComponents: this.frameworkComponents,
  };

  // DEFINICIÓN DE COLUMNAS
  colDefs: ColDef[] = [
    { headerCheckboxSelection: true, checkboxSelection: (params: any) => params.data && params.data.ag_estado === 'Pendiente', width: 40, headerName: '', pinned: 'left', headerClass: 'header-checkbox-col', cellClass: 'cell-checkbox-col',},
    { field: 'ag_num_orden_giro', headerName: 'N° orden de giro', width: 110 },
    { field: 'ag_fecha_solicitud', headerName: 'Fecha de solicitud', width: 120,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      },
    },
    // Campos REALES que entrega el backend (pendientes-aprobacion).
    { field: 'ag_solicitante_id', headerName: 'Solicitante (ID)', width: 120, filter: true,
      valueFormatter: (p: any) => (p.value != null && p.value !== '') ? `#${p.value}` : '—' },
    { field: 'ag_motivo', headerName: 'Motivo', flex: 1, minWidth: 180, filter: true,
      valueFormatter: (p: any) => p.value || '—' },
    /* SOBRA: el backend (pendientes-aprobacion) NO entrega estos campos → columnas comentadas, no borradas.
    { field: 'ag_fecha_aprobacion', headerName: 'Fecha de aprobación', width: 120,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      },
    },
    { field: 'ag_tipo_beneficiario',headerName: 'Tipo beneficiario',width: 120,filter: true, },
    { field: 'ag_beneficiario',headerName: 'Beneficiario',width: 170,filter: true, },
    { field: 'ag_centro_costo',headerName: 'Centro de costo',width: 150 },
    { field: 'ag_banco', headerName: 'Banco', width: 130},
    { field: 'ag_moneda', headerName: 'Moneda', width: 130},
    */
    { field: 'ag_monto_giro', headerName: 'Monto', headerClass: 'derechaencabezado', width: 70,
      cellRendererSelector: (params: any) => {
        // Si el estado es "Aprobada", usar el componente personalizado
        if (params.data?.estado === 'Aprobada') {
          return {
            component: VistaCellRenderComponent,
          };
        }
        // Para otros estados, usar el renderer por defecto
        return undefined;
      },
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
              return `${formattedValue}`;
          }
          return '';
        },
        cellStyle: (params) => {
          const style: any = { justifyContent: 'end', };
          if (params.value < 0) {
            style.color = '#EF4444'; // Rojo para negativos
          }
          return style;
        }
    },
    /* SOBRA: sin respaldo en backend (pendientes-aprobacion) → comentado, no borrado.
    { field: 'ag_sucursal', headerName: 'Sucursal', width: 130, filter: true },
    { field: 'ag_aprobador', headerName: 'Aprobador', width: 120 },
    */
    { headerClass: 'centrarencabezado', field: 'ag_estado', headerName: 'Estado', width: 90, filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return `<span class="badge-table bg-[#F5F5F5] text-[#1F1F1F]">Pendiente</span>`;
        } else if (params.value === 'Rechazado') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Rechazado</span>`;
        } else if (params.value === 'Aprobada') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Aprobada</span>`;
        }
        return params.value;
      },
      cellStyle: {
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    },
  ];

  documento: any[] = [];
  banco: IBanco[] = [
    { id: 1,nombre: 'BCP',cuentaBancaria: '19100012345678901234',condicionPago: 'Crédito',numeroCuotas: 3,montoTotal: 1200,},
    { id: 2,nombre: 'Interbank',cuentaBancaria: '20100098765432109876',condicionPago: 'Crédito',numeroCuotas: 3,montoTotal: 1200,},
    { id: 3,nombre: 'BBVA',cuentaBancaria: '01100056781234567890',condicionPago: 'Crédito',numeroCuotas: 3,montoTotal: 1200,},
    { id: 4,nombre: 'Banco de la Nación',cuentaBancaria: '00100011112222333344',condicionPago: 'Crédito',numeroCuotas: 3,montoTotal: 1200,},
  ];
  pagoSelect: any[] = [
    { nombre: 'Transferencia', value: 'transferencia' },
    { nombre: 'Cheque', value: 'cheque' },
    { nombre: 'Efectivo', value: 'efectivo' },
    { nombre: 'Otro', value: 'otro' },
  ];
  cuentaBancaria: ICuentaB[] = [
    { id: 1, nombre: 'Cuenta 01' },
    { id: 2, nombre: 'Cuenta 02' },
    { id: 3, nombre: 'Cuenta 03' },
    { id: 4, nombre: 'Cuenta 04' },
  ];

  // DATOS PARA NUEVO FLUJO
  // Número de ordenes
  numeroOrden: INdeOrden[] = [
    { id: 1, nombre: 'OC-2025-00023', ruc: '10983547892', nombreBeneficiario: 'LACTEOS S.A', condicionPago: 'Crédito', numeroCuotas: 3, montoTotal: 1800,
      cuotas: [
        {
          numeroCuotas: 1,
          montoTotal: 600.00,
          fechaPago: '2025-12-15',
          estado: 'Pagada',
        },
        {
          numeroCuotas: 2,
          montoTotal: 600.00,
          fechaPago: '2025-12-31',
          estado: 'Pendiente',
        },
        {
          numeroCuotas: 3,
          montoTotal: 600.00,
          fechaPago: '2026-01-15',
          estado: 'Pendiente',
        },
      ],
    },
    { id: 2,nombre: 'OC-2025-00024',ruc: '20678901234',nombreBeneficiario: 'IMPORTACIONES COSTA S.A.C',condicionPago: 'Contado',numeroCuotas: 0,montoTotal: 1500,},
     {id: 3,nombre: 'OC-2025-000023',ruc: '10983547892',nombreBeneficiario: 'LACTEOS S.A',condicionPago: 'Mixto',numeroCuotas: 2,montoTotal: 1800,montoContado: 900,montoFinanciar: 900,
      cuotas: [
        {
          numeroCuotas: 1,
          montoTotal: 450.00,
          fechaPago: '2025-12-15',
          estado: 'Pagada',
        },
        {
          numeroCuotas: 2,
          montoTotal: 450.00,
          fechaPago: '2025-12-31',
          estado: 'Pendiente',
        },
      ],
    },
  ];

  // Condiciones de pago con banco y cuenta bancaria
  condicionesPago: any[] = [
    {
      id: 1,
      nombre: 'Condición 1 - BCP',
      banco: { id: 1, nombre: 'BCP', cuentaBancaria: '19100012345678901234', condicionPago: 'Crédito', numeroCuotas: 3, montoTotal: 1200,},
      cuentaBancaria: { id: 1, nombre: 'Cuenta 01' },
    },
    {
      id: 2,
      nombre: 'Condición 2 - Interbank',
      banco: { id: 2, nombre: 'Interbank', cuentaBancaria: '20100098765432109876', condicionPago: 'Crédito', numeroCuotas: 3, montoTotal: 1200,},
      cuentaBancaria: { id: 2, nombre: 'Cuenta 02' },
    },
    {
      id: 3,
      nombre: 'Condición 3 - BBVA',
      banco: { id: 3, nombre: 'BBVA', cuentaBancaria: '01100056781234567890', condicionPago: 'Crédito', numeroCuotas: 3, montoTotal: 1200,},
      cuentaBancaria: { id: 3, nombre: 'Cuenta 03' },
    },
    {
      id: 4,
      nombre: 'Condición 4 - Banco de la Nación',
      banco: { id: 4, nombre: 'Banco de la Nación', cuentaBancaria: '00100011112222333344', condicionPago: 'Crédito', numeroCuotas: 3, montoTotal: 1200,},
      cuentaBancaria: { id: 4, nombre: 'Cuenta 04' },
    },
  ];

  // DATOS CONDICIÓN DE PAGO
  rowDataCondicionPago: any[] = [];
  private gridApiCondicionPago!: GridApi;

  colDefsCondicionPago: ColDef[] = [
    { field: 'numeroCuotas', headerName: 'Nº de cuotas', width: 80},
    { field: 'montoTotal', headerClass: 'derechaencabezado', headerName: 'Monto', width: 85,
      cellStyle: {display: 'flex', justifyContent: 'right'},  
      valueFormatter: (params: any) => {
        return `S/ ${params.value}`;
      },
    },
    { field: 'fechaPago', headerName: 'Fecha de pago', width: 100,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      },
    },
    { field: 'estado', headerName: 'Estado', headerClass:'centrarencabezado',width: 70,
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center'},
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return `<span class="badge-table bg-[#F5F5F5] text-[#1F1F1F]">Pendiente</span>`;
        } else if (params.value === 'Pagada') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagada</span>`;
        }
        return params.value;
      },
    },
  ];

  // DATOS DE LA TABLA
  rowData: AprobarGiroEntity[] = [];

  columnTypes = {
    rightAligned: {
      headerClass: 'ag-right-aligned-header',
      cellClass: 'ag-right-aligned-cell',
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
    noRowsToShow: 'No hay datos para mostrar',
  };

  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null ||
        params.value === undefined ||
        params.value === ''
        ? ''
        : params.value;
    },
  };

  getRowClass = (params: any) => {
    if (params.data && params.data.ag_estado !== 'Pendiente') {
      return 'row-disabled';
    }
    return '';
  };

  get noHayOrdenesSeleccionadas(): boolean {
    return !this.rowData.some(
      (row) => row.ag_seleccionado === true && row.ag_estado === 'Pendiente'
    );
  }

  constructor(
    private fb: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private countryService: CountryService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );

    // Inicializar el formulario
    this.AprobarGiroForm = this.fb.group({
      fechaEmision: [
        { value: new Date().toLocaleDateString('es-PE'), disabled: true },
      ],
      numeroOrden: [{ value: '', disabled: true }],
      // Campos REALES del backend (solo lectura).
      solicitante: [{ value: '', disabled: true }],
      monto: [{ value: '', disabled: true }],
      motivo: [{ value: '', disabled: true }],
      tipoBeneficiario: [{ value: 'Colaborador', disabled: true }],
      documentoBeneficiario: [{ value: '', disabled: true }],
      nombreBeneficiario: [{ value: '', disabled: true }],
      banco: [{ value: '', disabled: true }],
      cuentaBancaria: [{ value: '', disabled: true }],
      condicionPago: [{ value: '', disabled: true }],
      montoContado: [{ value: '', disabled: true }],
      montoFinanciar: [{ value: '', disabled: true }],
      numeroCuotas: [{ value: '', disabled: true }],
      montoTotal: [{ value: '', disabled: true }],
      formaPago: [{ value: '', disabled: true }],
      fechaProgramadaPago: [{ value: '', disabled: true }],
      centroCosto: [{ value: '', disabled: true }],
      sucursal: [{ value: '', disabled: true }],
      estado: [{ value: '', disabled: true }],
      glosaContable: [{ value: '', disabled: true }],
      motivoRechazo: [{ value: '', disabled: true }],
    });

    // Sincronizar store → rowData + grid
    effect(() => {
      const data = this.aprobarGiroFacade.ordenes();
      this.rowData = [...data];
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });
  }

  ngOnInit(): void {
    this.aprobarGiroFacade.cargarDatos();
    //Labels de formulario: Tipo de cambio por ahora
    this.configurarLabelsPorPais();
  }

  /** Ionic cachea la página; este hook se dispara en CADA entrada a la pantalla,
   *  así la bandeja se recarga del backend (refleja órdenes creadas/aprobadas/rechazadas). */
  ionViewWillEnter(): void {
    this.aprobarGiroFacade.cargarDatos();
  }

  configurarLabelsPorPais() {
  if(this.pais === 'EC') {
    this.mostrarTipoCambio = false; // Ocultar tipo de cambio en Ecuador
  }
}



  onGridReady(params: GridReadyEvent): void {
    this.gridApi = params.api;
    if (this.rowData.length > 0) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
    if (this.filaSeleccionada) {
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node: any) => {
            if (node.data && node.data.ag_num_orden_giro === this.filaSeleccionada?.ag_num_orden_giro) {
              node.setSelected(true);
              this.gridApi.ensureNodeVisible(node, 'middle');
            }
          });
        }
      }, 150);
    }
  }

  isRowSelectable(params: any): boolean {
    // Solo permitir seleccionar filas en estado "Pendiente"
    return params.data && params.data.ag_estado === 'Pendiente';
  }

  onCellClicked(event: any): void {
    console.log('Event recibido:', event);
    const data = event.data;
    this.filaSeleccionada = data;
    console.log('Fila seleccionada:', this.filaSeleccionada);
    this.gridApi.deselectAll();
    event.node.setSelected(true);

    // Buscar la orden correspondiente en numeroOrden usando documentoAsociado
    const ordenEncontrada = this.numeroOrden.find(
      (orden) => orden.nombre === data.ag_documento_asociado
    );

    // Calcular monto de giro según la condición de pago
    let condicionPago = '';
    let numeroCuotas = '';
    let montoTotal = '';
    let montoContado = '';
    let montoFinanciar = '';

    if (ordenEncontrada) {
      condicionPago = ordenEncontrada.condicionPago;
      numeroCuotas =
        ordenEncontrada.numeroCuotas > 0
          ? ordenEncontrada.numeroCuotas.toString().padStart(2, '0')
          : '';
      montoTotal = `S/${ordenEncontrada.montoTotal.toFixed(2)}`;
      montoContado = ordenEncontrada.montoContado
        ? `S/${ordenEncontrada.montoContado.toFixed(2)}`
        : '';
      montoFinanciar = ordenEncontrada.montoFinanciar
        ? `S/${ordenEncontrada.montoFinanciar.toFixed(2)}`
        : '';

      // Cargar cuotas en la tabla si existen
      if (ordenEncontrada.cuotas && ordenEncontrada.cuotas.length > 0) {
        this.rowDataCondicionPago = ordenEncontrada.cuotas.map((cuota) => ({
          numeroCuotas: cuota.numeroCuotas.toString().padStart(2, '0'),
          montoTotal: cuota.montoTotal,
          fechaPago: cuota.fechaPago,
          estado: cuota.estado,
        }));
      } else {
        this.rowDataCondicionPago = [];
      }

      // Actualizar la tabla de cuotas
      if (this.gridApiCondicionPago) {
        this.gridApiCondicionPago.setGridOption(
          'rowData',
          this.rowDataCondicionPago
        );
      }
    }

    // Buscar el banco por nombre para obtener su ID
    const bancoEncontrado = this.banco.find(
      (b) => b.nombre === data.ag_banco
    );

    // Cargar datos en el formulario
    this.AprobarGiroForm.patchValue({
      fechaEmision: data.ag_fecha_solicitud || data.fechaEmision || new Date().toLocaleDateString('es-PE'),
      numeroOrden: ordenEncontrada ? ordenEncontrada.id : '',
      // Campos REALES del backend.
      solicitante: data.ag_solicitante_id != null ? `#${data.ag_solicitante_id}` : '—',
      monto: data.ag_monto_giro != null ? Number(data.ag_monto_giro).toFixed(2) : '',
      motivo: data.ag_motivo || '—',
      tipoBeneficiario: data.ag_tipo_beneficiario || 'Proveedor',
      documentoBeneficiario: data.ag_documento_beneficiario || '',
      nombreBeneficiario: data.ag_nombre_beneficiario || data.ag_beneficiario,
      banco: bancoEncontrado ? bancoEncontrado.id : '',
      cuentaBancaria: data.ag_cuenta_bancaria || '',
      condicionPago: condicionPago,
      montoContado: montoContado,
      montoFinanciar: montoFinanciar,
      numeroCuotas: numeroCuotas,
      montoTotal: montoTotal,
      montoGiro: data.ag_monto_giro,
      moneda: data.ag_moneda?.toLowerCase() || 'soles',
      tipoCambio: data.ag_tipo_cambio || '',
      formaPago: data.ag_forma_pago?.toLowerCase() || '',
      fechaProgramadaPago: data.ag_fecha_programada_pago || '',
      centroCosto: data.ag_centro_costo || '',
      sucursal: data.ag_sucursal || '',
      estado: data.ag_estado,
      glosaContable: '',
    });

    // Habilitar/Deshabilitar botones según el estado
    this.botonesHabilitados = data.ag_estado === 'Pendiente';
  }

  onBtReset(): void {
    if (this.gridApi) {
      this.gridApi.showLoadingOverlay();
      setTimeout(() => {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.gridApi.hideOverlay();
        console.log('Tabla refrescada');
      }, 300);
    }
  }

  onDocumentoAsociado(documento: any) {
    console.log('Documento seleccionado:', documento);
  }

  onNumeroOrden(orden: INdeOrden) {
    console.log('Número de orden seleccionado:', orden);
    if (orden) {
      // Calcular monto de giro según la condición de pago
      let montoGiro: number | string;

      if (
        orden.condicionPago === 'Mixto' &&
        orden.montoFinanciar &&
        orden.numeroCuotas > 0
      ) {
        // Para Mixto: monto a financiar / número de cuotas
        montoGiro = (orden.montoFinanciar / orden.numeroCuotas).toFixed(2);
      } else if (orden.numeroCuotas > 0) {
        // Para Crédito: monto total / número de cuotas
        montoGiro = (orden.montoTotal / orden.numeroCuotas).toFixed(2);
      } else {
        // Para Contado: monto total
        montoGiro = orden.montoTotal;
      }

      this.AprobarGiroForm.patchValue({
        documentoBeneficiario: orden.ruc,
        nombreBeneficiario: orden.nombreBeneficiario,
        condicionPago: orden.condicionPago,
        numeroCuotas:
          orden.numeroCuotas > 0
            ? orden.numeroCuotas.toString().padStart(2, '0')
            : '',
        montoTotal: `S/${orden.montoTotal.toFixed(2)}`,
        montoContado: orden.montoContado
          ? `S/${orden.montoContado.toFixed(2)}`
          : '',
        montoFinanciar: orden.montoFinanciar
          ? `S/${orden.montoFinanciar.toFixed(2)}`
          : '',
        montoGiro: montoGiro,
      });

      // Mostrar cuotas en la tabla si existen
      if (orden.cuotas && orden.cuotas.length > 0) {
        this.rowDataCondicionPago = orden.cuotas.map((cuota) => ({
          numeroCuotas: cuota.numeroCuotas.toString().padStart(2, '0'),
          montoTotal: cuota.montoTotal,
          fechaPago: cuota.fechaPago,
          estado: cuota.estado,
        }));
      } else {
        this.rowDataCondicionPago = [];
      }

      // Actualizar la tabla
      if (this.gridApiCondicionPago) {
        this.gridApiCondicionPago.setGridOption(
          'rowData',
          this.rowDataCondicionPago
        );
      }
    }
  }

  onDocumentoBeneficiario(tipo: 'Proveedor') {
    const documento = this.AprobarGiroForm.get('documentoBeneficiario')?.value;
    console.log(`Documento ${tipo} ingresado:`, documento);
  }

  onBancoSeleccionado(banco: IBanco) {
    console.log('Banco seleccionado:', banco);
    if (banco) {
      this.AprobarGiroForm.patchValue({
        cuentaBancaria: banco.cuentaBancaria,
        condicionPago: banco.condicionPago,
        numeroCuotas: banco.numeroCuotas,
        montoTotal: banco.montoTotal,
        montoGiro: (banco.montoTotal / banco.numeroCuotas).toFixed(2),
        fechaProgramadaPago: '25/12/2025',
        centroCosto: 'Operaciones',
        sucursal: 'Lima - Sede Central',
      });
    }
  }

  onCuentaBancaria(cuentaBancaria: ICuentaB) {
    console.log('Cuenta bancaria seleccionada:', cuentaBancaria);
  }

  onFechaProgramada(date: Date) {
    console.log('Fecha seleccionada:', date);
    this.fechaprogramada = date;
    this.AprobarGiroForm.patchValue({
      fechaProgramadaPago: date.toLocaleDateString('es-PE'),
    });
  }

  onGridReadyCondicionPago(params: GridReadyEvent): void {
    this.gridApiCondicionPago = params.api;
    this.gridApiCondicionPago.setGridOption(
      'rowData',
      this.rowDataCondicionPago
    );
  }

  onCellClickedCondicionPago(event: any): void {
    console.log('Celda de condición de pago clickeada:', event.data);
  }

  onCondicionPagoSeleccionada(condicion: any): void {
    console.log('Condición de pago seleccionada:', condicion);
    if (condicion) {
      // Generar datos de cuotas
      const cuotas = [];
      const montoPorCuota =
        condicion.banco.montoTotal / condicion.banco.numeroCuotas;

      for (let i = 1; i <= condicion.banco.numeroCuotas; i++) {
        const fechaPago = new Date();
        fechaPago.setMonth(fechaPago.getMonth() + i);

        cuotas.push({
          numeroCuotas: i,
          montoTotal: montoPorCuota.toFixed(2),
          fechaPago: fechaPago.toLocaleDateString('es-PE'),
          estado: 'Pendiente',
        });
      }

      this.rowDataCondicionPago = cuotas;
      if (this.gridApiCondicionPago) {
        this.gridApiCondicionPago.setGridOption(
          'rowData',
          this.rowDataCondicionPago
        );
      }
    }
  }

  togglePanelLateral(): void {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  async botonConfirmar() {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Confirmar aprobación',
        title: 'Confirmar aprobación de orden(es)',
        message:
          'Por favor, revisa los detalles antes de proceder. Una vez aprobados, no podrás modificar ni deshacer esta acción',
        btnOkTxt: 'Confirmar',
        btnCancelTxt: 'Cancelar',
      },
    });

    await modal.present();
    const { data } = await modal.onDidDismiss();

    if (data === true) {
      this.botonAprobar();
    }
  }

  async botonConfirmarRechazar() {
     const obtenerSimboloMoneda = (moneda: string): string => {
      if (moneda.toLowerCase() === 'dólares') {
        return '$';
      }
      return 'S/';
    };

    // Obtener fecha de hoy en formato YYYY-MM-DD
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    const fechaHoy = `${year}-${month}-${day}`;

    const detalles = [
      {label: 'Beneficiario',value: this.filaSeleccionada?.ag_beneficiario || '',},
      {label: 'Orden de compra',value: this.filaSeleccionada?.ag_num_orden_giro || '',},
      { label: 'Monto', value: `${obtenerSimboloMoneda(this.filaSeleccionada?.ag_moneda || '')} ${this.filaSeleccionada?.ag_monto_giro?.toFixed(2) || '0.00'}` || '' },
      {label: 'Fecha de emisión',value: this.formatearFecha(this.filaSeleccionada?.ag_fecha_solicitud || '') || '',},
      {label: 'Fecha de aprobación',value: this.formatearFecha(fechaHoy) || '-',},

    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      componentProps: {
        tituloModal: `Rechazar orden de giro ${this.filaSeleccionada?.ag_num_orden_giro}`,
        subtitulomodal: 'Detalle de la orden de giro',
        detalles: detalles,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo del rechazo:',
        placeholderTextarea:
          'Describe el motivo del rechazo o las observaciones.',
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Rechazar',
        textoBotonCancelar: 'Cancelar',
        colorBotonConfirmar: 'danger',
        motivoObligatorio: true,
      },
      cssClass: 'promo',
    });

    await modal.present();

    const { data } = await modal.onDidDismiss();

    console.log('Data del modal:', data);
    console.log('Motivo recibido:', data?.motivo);

    if (data && data.action === 'confirmar') {
      // Usuario confirmó el rechazo
      this.botonRechazar(data.motivo);
      console.log('Motivo de rechazo:', data.motivo);
    }
  }

  filtrarPorFechas(range: { start: Date; end: Date }): void {
    this.startDate = range.start;
    this.endDate = range.end;
  }

  botonAprobar(): void {
    if (this.filaSeleccionada) {
      const today = new Date();
      const year = today.getFullYear();
      const month = String(today.getMonth() + 1).padStart(2, '0');
      const day = String(today.getDate()).padStart(2, '0');

      this.aprobarGiroFacade.actualizar({
        ...this.filaSeleccionada,
        ag_estado: 'Aprobada',
        ag_show_eye: true,
        ag_fecha_aprobacion: `${year}-${month}-${day}`,
        ag_seleccionado: false,
      }, '¡Orden de giro aprobada exitosamente!');

      this.AprobarGiroForm.patchValue({ estado: 'Aprobada' });
      this.botonesHabilitados = false;

      if (this.gridApi) {
        this.gridApi.deselectAll();
      }
    }
  }

  botonRechazar(motivo?: string): void {
    if (this.filaSeleccionada) {
      const today = new Date();
      const year = today.getFullYear();
      const month = String(today.getMonth() + 1).padStart(2, '0');
      const day = String(today.getDate()).padStart(2, '0');

      this.aprobarGiroFacade.actualizar({
        ...this.filaSeleccionada,
        ag_estado: 'Rechazado',
        ag_show_eye: true,
        ag_fecha_aprobacion: `${year}-${month}-${day}`,
        ag_motivo_rechazo: motivo,
        ag_seleccionado: false,
      }, '¡La acción se realizó con éxito!');

      const formUpdate: any = { estado: 'Rechazado' };
      if (motivo) {
        formUpdate.motivoRechazo = motivo;
      }
      this.AprobarGiroForm.patchValue(formUpdate);
      this.botonesHabilitados = false;

      if (this.gridApi) {
        this.gridApi.deselectAll();
      }
    }
  }

  onSelectionChanged(event: any): void {
    const selectedNodes = this.gridApi.getSelectedNodes();
    
    // Actualizar la propiedad seleccionado en cada fila
    this.rowData.forEach((row) => {
      const isSelected = selectedNodes.some(
        (node) => node.data?.ag_num_orden_giro === row.ag_num_orden_giro
      );
      row.ag_seleccionado = isSelected;
    });

    this.cantidadSeleccionadas = this.rowData.filter((r) => r.ag_seleccionado).length;
    
    console.log(
      'Filas seleccionadas:',
      this.rowData.filter((r) => r.ag_seleccionado)
    );
  }

  async botonConfirmarMasivamente() {
    // Obtener las filas seleccionadas
    const filasSeleccionadas = this.rowData.filter(
      (row) => row.ag_seleccionado === true && row.ag_estado === 'Pendiente'
    );

    if (filasSeleccionadas.length === 0) {
      this.toastService.warning(
        'Por favor selecciona al menos una orden de giro en estado Pendiente para aprobar'
      );
      return;
    }

    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Confirmar aprobación',
        title: 'Confirmar aprobación de orden(es)',
        message:
          'Por favor, revisa los detalles antes de proceder. Una vez aprobados, no podrás modificar ni deshacer esta acción',
        btnOkTxt: 'Confirmar',
        btnCancelTxt: 'Cancelar',
      },
    });

    await modal.present();

    const { data } = await modal.onDidDismiss();

    if (data === true) {
      this.aprobarMultiplesOrdenes(filasSeleccionadas);
    }
  }

  private aprobarMultiplesOrdenes(filasSeleccionadas: AprobarGiroEntity[]): void {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    const fechaAprobacion = `${year}-${month}-${day}`;

    filasSeleccionadas.forEach((fila) => {
      this.aprobarGiroFacade.actualizar({
        ...fila,
        ag_estado: 'Aprobada',
        ag_show_eye: true,
        ag_fecha_aprobacion: fechaAprobacion,
        ag_seleccionado: false,
      });
    });

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    this.filaSeleccionada = null;
    this.botonesHabilitados = false;
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
      {
        fechaHora: `${this.fechaEjecucion} 10:30`,
        usuario: 'Juan Pérez',
        accion: 'Creación',
        detalleCambio: 'Se ha generado la Orden de giro',
      },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de actualizaciones de la orden ${this.filaSeleccionada?.ag_num_orden_giro}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '758px',
      },
    });

    await modal.present();
  }

  // Formateo fecha para modal
  formatearFecha(fecha: string): string {
    if (!fecha) return '-';
    // Si ya está en formato dd/MM/yyyy, devolverlo como está
    if (fecha.includes('/')) {
      return fecha;
    }

    // Si está en formato yyyy-MM-dd, convertir a dd/MM/yyyy
    if (fecha.includes('-')) {
      const [año, mes, dia] = fecha.split('-');
      return `${dia}/${mes}/${año}`;
    }

    return '-';
  }

  async abrirModal(monto: string, rowData: any) {
    // Obtener los datos de la fila para mostrar en el detalle
    const data = rowData || this.filaSeleccionada;

    if (!data) {
      return;
    }

    const detalleOrdenGiro = [
      {
        label: 'Fecha de solicitud',
        value: this.formatearFecha(data.ag_fecha_solicitud) || '-',
      },
      {
        label: 'Fecha de aprobación',
        value: this.formatearFecha(data.ag_fecha_aprobacion) || '-',
      },
      {
        label: 'Glosa',
        value:
          data.ag_glosa_contable ||
          'Liquidación de gastos por comisión de servicio, en el que el colaborador usó auto propio para trasladarse de Piura a Chiclayo.',
      },
      { label: 'Total', value: `S/ ${data.ag_monto_giro}.00` },
    ];

    const colDefs: ColDef[] = [
      { field: 'cuenta', headerName: 'Cuenta', width: 70 },
      { field: 'descripcion', headerName: 'Descripción', width: 150, flex: 1 },
      {
        field: 'debe',
        headerName: 'Debe(S/)',
        width: 90,
        headerClass: 'derechaencabezado',
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
          return '';
        },
        cellStyle: (params) => {
          const style: any = { justifyContent: 'end', };
          if (params.value < 0) {
            style.color = '#EF4444'; // Rojo para negativos
          }
          return style;
        }
      },
      {
        field: 'haber',
        headerName: 'Haber(S/)',
        width: 90,
        headerClass: 'derechaencabezado',
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
          return '';
        },
        cellStyle: (params) => {
          const style: any = { justifyContent: 'end', };
          if (params.value < 0) {
            style.color = '#EF4444'; // Rojo para negativos
          }
          return style;
        }
      },
      { field: 'tercero', headerName: 'Tercero', width: 130 },
    ];

    // Datos de ejemplo para la tabla contable
    const rowDataTabla = [
      {
        cuenta: '63112',
        descripcion: 'Combustible para viajar',
        debe: data.ag_monto_giro,
        haber: '',
        tercero: data.ag_beneficiario,
      },
      {
        cuenta: '63131',
        descripcion: 'Alojamiento - ' + data.ag_banco,
        debe: '',
        haber: data.ag_monto_giro,
        tercero: data.ag_banco,
      },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Detalle de Orden de Giro ${data.ag_num_orden_giro}`,
        detalles: detalleOrdenGiro,
        mostrarTabla: true,
        colDefs: colDefs,
        rowData: rowDataTabla,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        textoBotonCancelar: 'Cerrar',
        ocultarBotonConfirmar: true,
      },
    });

    await modal.present();
  }

  async verAsientoContable() {
    // Obtener el número de orden seleccionado del formulario
    const numeroOrdenId = this.AprobarGiroForm.get('numeroOrden')?.value;
    
    if (!numeroOrdenId) {
      this.toastService.warning('No hay una orden de compra seleccionada');
      return;
    }

    // Buscar la orden en el array de numeroOrden
    const ordenSeleccionada = this.numeroOrden.find(orden => orden.id === numeroOrdenId);
    
    if (!ordenSeleccionada) {
      this.toastService.warning('No se encontró la información de la orden');
      return;
    }

    // Preparar los detalles para mostrar en el modal
    const detalles = [
      { label: 'N° de orden:', value: ordenSeleccionada.nombre },
      { label: 'N° de cuotas:', value: ordenSeleccionada.numeroCuotas.toString().padStart(2, '0') },
      { label: 'Monto total:', value: `S/${ordenSeleccionada.montoTotal.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}` },
    ];

    // Configurar las columnas de la tabla de cuotas
    const colDefs: ColDef[] = [
      { field: 'numeroCuotas', headerName: 'Cuotas', width: 100,
        valueFormatter: (params: any) => {
          return params.value.toString().padStart(2, '0');
        }
      },
      { field: 'montoTotal', headerName: 'Monto', flex: 1,headerClass: 'derechaencabezado',
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
          return '';
        },
        cellStyle: (params) => {
          const style: any = { justifyContent: 'end', };
          if (params.value < 0) {
            style.color = '#EF4444'; // Rojo para negativos
          }
          return style;
        }
      },
      { field: 'fechaPago', headerName: 'Fecha de pago', flex: 1,
        valueFormatter: (params: any) => {
          if (params.value) {
            const date = new Date(params.value);
            const day = String(date.getDate()).padStart(2, '0');
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const year = date.getFullYear();
            return `${day}/${month}/${year}`;
          }
          return params.value;
        }
      },
      { 
        field: 'estado', 
        headerName: 'Estado', 
        headerClass: 'centrarencabezado',
        width: 100,
        cellRenderer: (params: any) => {
          if (params.value === 'Pendiente') {
            return '<span class="badge-table bg-[#F5F5F5] text-[#1F1F1F]">Pendiente</span>';
          } else if (params.value === 'Pagada') {
            return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagada</span>';
          }
          return params.value;
        },
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
      },
    ];

    // Usar las cuotas de la orden seleccionada
    const rowData = ordenSeleccionada.cuotas || [];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Detalle de condición de compra',
        detalles: detalles,
        mostrarTabla: true,
        colDefs: colDefs,
        rowData: rowData,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        textoBotonCancelar: 'Cerrar',
        ocultarBotonConfirmar: true,
      },
    });

    await modal.present();
  }
}
