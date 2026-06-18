import { Component, ElementRef, OnInit, OnDestroy, ViewChild, inject, effect, signal, computed } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalVerActualizacionesComponent } from '../../../../../ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';
import { BotonAccionesComponent } from 'src/app/ui/boton-acciones/boton-acciones.component';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ModalDetalleComponent } from '../../../../../ui/modal-detalle/modal-detalle.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { OrdenGiroFacade } from 'src/app/modules/finanzas/application/facades/orden-giro.facade';
import { OrdenGiroFeedbackEffects } from 'src/app/modules/finanzas/effects/orden-giro-feedback.effect';
import { OrdenGiroSyncEffects } from 'src/app/modules/finanzas/effects/orden-giro-sync.effect';
import { OrdenGiroEntity } from 'src/app/modules/finanzas/domain/models/orden-giro.entity';
import { StorageService } from 'src/app/core/services/storage.service';

// Font Awesome Icons
import { faBook, faEye, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';


interface IBanco {
  id: number;
  nombre: string;
  cuentaBancaria: string;
  montoTotal: number;
  numeroCuotas?: number;
}
interface ICuentaB {
  id: number;
  nombre: string;
}
interface IDocumentoAprobado {
  id: string;
  numero: string;
  proveedor: string;
  monto: number;
  moneda: string;
}

interface ICuota {
  numeroCuotas: number;
  montoTotal: string;
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
  sucursal?: string;
  fechaProgramadaPago?: string;
  centroCosto?: string;
}

interface ICondicionPago {
  id: number;
  nombre: string;
  banco: IBanco;
  cuentaBancaria: ICuentaB;
}
interface ITipoCambio {
  id: number;
  fecha: string;
  tipoCambio: number;
  moneda: string;
}
interface ICentroCosto {
  id: number;
  nombre: string;
  codigo: string;
}
interface IProveedor {
  id: string;
  ruc: string;
  nombre: string;
}
interface IColaborador {
  id: string;
  documento: string;
  nombre: string;
}
interface ISucursal {
  id: number;
  nombre: string;
  codigo: string;
}

interface IAlmacen {
  id: number;
  nombre: string;
  codigo: string;
  sucursal?: string;
}



@Component({
  selector: 'app-f-a-ordenes-giro',
  templateUrl: './f-a-ordenes-giro.component.html',
  styleUrls: ['./f-a-ordenes-giro.component.scss'],
  standalone: false,
})
export class FAOrdenesGiroComponent implements OnInit, OnDestroy {
  // ── Clean Architecture ───────────────────────────────────────────────────
  private readonly ordenGiroFacade = inject(OrdenGiroFacade);
  private readonly _feedbackEffects = inject(OrdenGiroFeedbackEffects);
  private readonly _syncEffects = inject(OrdenGiroSyncEffects);
  private readonly storage = inject(StorageService);

  /** Id del usuario logueado (de la sesión); se registra como solicitante de la orden de giro. */
  private solicitanteActualId(): number | undefined {
    return this.storage.getUser<{ userId?: number }>()?.userId ?? undefined;
  }

  readonly loaderActivo = computed(() => this.ordenGiroFacade.isLoading());

  // Font Awesome Icons
  farBook = faBook;
  farEye = faEye;
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
  fechaEmisionSeleccionada: Date | undefined;

  // ESTADO DEL COMPONENTE
  filaSeleccionada: OrdenGiroEntity | null = null;
  selectedRowIndex: number | null = null;
  panelLateralVisible = true;
  cargando = false;
  tabSeleccionado: string = 'registro';
  monedapais: any = 'S/';
  mostrarBuscadorPrincipal = true;
  editandoFilaIndex: number | null = null;
  botonBorradorHabilitado = false;
  botonAnularHabilitado = false;

  // FORMULARIO
  OrdenesDeGiroForm!: FormGroup;
  fechaprogramada: Date | undefined;

  // GRID
  private gridApi!: GridApi;

  cuentasBancarias = [
    { id: '1', nombre: 'BCP' },
    { id: '2', nombre: 'BBVA' },
    { id: '3', nombre: 'Interbank' },
    { id: '4', nombre: 'Scotiabank' },
    { id: '5', nombre: 'Banco de la Nación' },
    { id: '6', nombre: 'Caja Piura' },
    { id: '7', nombre: 'Caja Sullana' },
  ];



  gridOptions = {
    context: {
      componentParent: this,
    },
    rowSelection: 'single',
    suppressRowClickSelection: false
  };

  // DEFINICIÓN DE COLUMNAS
  colDefs: ColDef[] = [
    {
      field: 'og_num_orden_giro',
      headerName: 'N° orden de giro',
      width: 120,
    },
    {
      field: 'og_fecha_emision',
      headerName: 'Fecha emisión',
      width: 150,
      valueFormatter: (params: any) => {
        if (params.value) {
          return this.formatearFecha(params.value);
        }
        return '';
      }
    },
    {
      field: 'og_sucursal_id',
      headerName: 'Sucursal',
      width: 160,
      filter: true,
      valueGetter: (p: any) =>
        this.sucursalesReales.find((s) => s.id === p.data?.og_sucursal_id)?.nombre
        ?? (p.data?.og_sucursal_id ?? ''),
    },
    {
      field: 'og_tipo_solicitud',
      headerName: 'Tipo',
      width: 130,
      filter: true,
      valueFormatter: (p: any) => p.value === 'F' ? 'Fondo Fijo' : (p.value === 'O' ? 'Orden de Giro' : (p.value ?? '')),
    },
    {
      field: 'og_monto',
      headerName: 'Monto',
      headerClass: 'derechaencabezado',
      width: 100,
      cellStyle: { display: 'flex', justifyContent: 'end' },
      valueFormatter: (p: any) => (p.value != null && p.value !== '') ? Number(p.value).toFixed(2) : '-',
    },
    // SOBRA: el backend (solicitud_giro) no devuelve estos campos → columnas comentadas, no borradas.
    // { field: 'og_fecha_deposito', headerName: 'Fecha de deposito', width: 130, filter: true },
    // { field: 'og_beneficiario', headerName: 'Beneficiario', width: 170, filter: true },
    // { field: 'og_banco', headerName: 'Banco', width: 130, filter: true },
    // { field: 'og_moneda', headerName: 'Moneda', width: 80 },
    // {
    //   field: 'og_doc_asociado',
    //   headerName: 'Orden asociada',
    //   width: 150,

    //   cellRendererSelector: (params: any) => {
    //     // Si el estado es "Emitida" o "Pendiente", usar el componente personalizado
    //     if (params.data?.estado === 'Emitida' || params.data?.estado === 'Pendiente') {
    //       return {
    //         component: VistaCellRenderComponent,
    //       };
    //     }
    //     // Para otros estados, usar el renderer por defecto
    //     return undefined;
    //   },
    // },
    // {
    //   // field: 'responsable',
    //   headerName: 'Responsable',
    //   flex: 1, minWidth: 150,
    //   filter: true,
    // },
    {
      field: 'og_centro_costo_id',
      headerName: 'Centro de costo',
      width: 200,
      filter: true,
      valueGetter: (p: any) =>
        this.centrosCostoReales.find((c) => c.id === p.data?.og_centro_costo_id)?.nombre
        ?? (p.data?.og_centro_costo_id ?? '—'),
    },
    {
      field: 'og_solicitante_id',
      headerName: 'Solicitante (ID)',
      width: 120,
      filter: true,
      valueFormatter: (p: any) => (p.value != null && p.value !== '') ? String(p.value) : '—',
    },
    {
      field: 'og_motivo',
      headerName: 'Motivo',
      flex: 1,
      minWidth: 180,
      filter: true,
      valueFormatter: (p: any) => p.value || '—',
    },
    {
      headerClass: 'centrarencabezado',
      field: 'og_estado',
      headerName: 'Estado',
      width: 80,
      filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return `<span class="badge-table bg-[#F5F5F5] text-[#1F1F1F]">Pendiente</span>`;
        } else if (params.value === 'Emitida' || params.value === 'Aprobada') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">${params.value}</span>`;
        } else if (params.value === 'Anulada') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulada</span>`;
        }
        return params.value;
      },
      cellStyle: {
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center'
      }
    },
  ];

  banco: IBanco[] = [
    { id: 1, nombre: 'BCP', cuentaBancaria: '19100012345678901234', montoTotal: 1200 },
    { id: 2, nombre: 'Interbank', cuentaBancaria: '20100098765432109876', montoTotal: 1200 },
    { id: 3, nombre: 'BBVA', cuentaBancaria: '01100056781234567890', montoTotal: 1200 },
    { id: 4, nombre: 'Banco de la Nación', cuentaBancaria: '00100011112222333344', montoTotal: 1200 },
  ];
  pagoSelect: any[] = [
    { nombre: 'Transferencia', value: 'transferencia' },
    { nombre: 'Cheque', value: 'cheque' },
    { nombre: 'Efectivo', value: 'efectivo' },
    { nombre: 'Otro', value: 'otro' },
  ];
  cuentaBancaria: ICuentaB[] = [
    { id: 1, nombre: '19100012345678901234' },
    { id: 2, nombre: '20100098765432109876' },
    { id: 3, nombre: '01100056781234567890' },
    { id: 4, nombre: '00100011112222333344' },
  ];

  // DATOS PARA NUEVO FLUJO
  // Número de ordenes
  numeroOrden: INdeOrden[] = [
    {
      id: 1,
      nombre: 'OC-2025-00023',
      ruc: '10983547892',
      nombreBeneficiario: 'LACTEOS S.A',
      condicionPago: 'Crédito',
      numeroCuotas: 3,
      montoTotal: 1800,
      sucursal: 'Lima - Sede Central',
      fechaProgramadaPago: '2025/12/25',
      centroCosto: 'Administración',
      cuotas: [
        { numeroCuotas: 1, montoTotal: '600.00', fechaPago: '2025-12-25', estado: 'Pagada' },
        { numeroCuotas: 2, montoTotal: '600.00', fechaPago: '2025-12-31', estado: 'Pendiente' },
        { numeroCuotas: 3, montoTotal: '600.00', fechaPago: '2026-01-15', estado: 'Pendiente' }
      ]
    },
    {
      id: 2,
      nombre: 'OC-2025-00024',
      ruc: '20512345678',
      nombreBeneficiario: 'DISTRIBUIDORA ALIMENTOS PERU S.A.C',
      condicionPago: 'Crédito',
      numeroCuotas: 6,
      montoTotal: 3600,
      sucursal: 'Arequipa',
      fechaProgramadaPago: '2025/12/30',
      centroCosto: 'Operaciones',
      cuotas: [
        { numeroCuotas: 1, montoTotal: '600.00', fechaPago: '2025-12-25', estado: 'Pagada' },
        { numeroCuotas: 2, montoTotal: '600.00', fechaPago: '2026-01-15', estado: 'Pendiente' },
        { numeroCuotas: 3, montoTotal: '600.00', fechaPago: '2026-02-15', estado: 'Pendiente' },
        { numeroCuotas: 4, montoTotal: '600.00', fechaPago: '2026-03-15', estado: 'Pendiente' },
        { numeroCuotas: 5, montoTotal: '600.00', fechaPago: '2026-04-15', estado: 'Pendiente' },
        { numeroCuotas: 6, montoTotal: '600.00', fechaPago: '2026-05-15', estado: 'Pendiente' }
      ]
    },
    {
      id: 3,
      nombre: 'OC-2025-00025',
      ruc: '20678901234',
      nombreBeneficiario: 'IMPORTACIONES COSTA S.A.C',
      condicionPago: 'Contado',
      numeroCuotas: 0,
      montoTotal: 1500,
      sucursal: 'Cusco',
      fechaProgramadaPago: '2025/12/20',
      centroCosto: 'Ventas'
    },
    {
      id: 4,
      nombre: 'OC-2025-000023',
      ruc: '10983547892',
      nombreBeneficiario: 'LACTEOS S.A',
      condicionPago: 'Mixto',
      numeroCuotas: 2,
      montoTotal: 1800,
      montoContado: 900,
      montoFinanciar: 900,
      sucursal: 'Trujillo',
      fechaProgramadaPago: '2025/12/28',
      centroCosto: 'Logística',
      cuotas: [
        { numeroCuotas: 1, montoTotal: '450.00', fechaPago: '2025-12-15', estado: 'Pagada' },
        { numeroCuotas: 2, montoTotal: '450.00', fechaPago: '2025-12-31', estado: 'Pendiente' }
      ]
    },
  ];

  // Documentos aprobados de órdenes de compra



  documentosAprobados: IDocumentoAprobado[] = [
    { id: '1', numero: 'OC-2025-000156', proveedor: 'DISTRIBUIDORA NORTE', monto: 12000, moneda: 'Soles' },
    { id: '2', numero: 'OC-2025-000189', proveedor: 'PROVEEDORA SUR S.A.C', monto: 8500, moneda: 'Dólares' },
    { id: '3', numero: 'OC-2025-000145', proveedor: 'EMPRESA LOGISTICA GLOBAL', monto: 6750, moneda: 'Soles' },
    { id: '4', numero: 'OC-2025-000201', proveedor: 'SUMINISTROS INDUSTRIALES LLC', monto: 15200, moneda: 'Soles' },
    { id: '5', numero: 'OC-2025-000220', proveedor: 'SERVICIOS PROFESIONALES SAC', monto: 5300, moneda: 'Dólares' },
  ];

  // Propiedad para la tabla, inicializada con documentosAprobados
  documento: any[] = this.documentosAprobados;

  // Condiciones de pago simplificadas
  condicionesPago: ICondicionPago[] = [
    {
      id: 1,
      nombre: 'Transferencia',
      banco: null as any,
      cuentaBancaria: { id: 1, nombre: 'Cuenta 01' }
    },
    {
      id: 2,
      nombre: 'Cheque',
      banco: null as any,
      cuentaBancaria: { id: 2, nombre: 'Cuenta 02' }
    },
    {
      id: 3,
      nombre: 'Efectivo',
      banco: null as any,
      cuentaBancaria: { id: 3, nombre: 'Cuenta 03' }
    },
    {
      id: 4,
      nombre: 'Otro',
      banco: null as any,
      cuentaBancaria: { id: 4, nombre: 'Cuenta 04' }
    },
  ];

  // Tipos de cambio
  tiposCambio: ITipoCambio[] = [
    { id: 1, fecha: '2025-12-17', tipoCambio: 3.75, moneda: 'dolares' },
    { id: 2, fecha: '2025-12-16', tipoCambio: 3.74, moneda: 'dolares' },
    { id: 3, fecha: '2025-12-15', tipoCambio: 3.73, moneda: 'dolares' },
  ];

  // Plan de centros de costos
  centrosCosto: ICentroCosto[] = [
    { id: 1, nombre: 'Administración', codigo: 'ADM-001' },
    { id: 2, nombre: 'Ventas', codigo: 'VEN-001' },
    { id: 3, nombre: 'Operaciones', codigo: 'OPE-001' },
    { id: 4, nombre: 'Finanzas', codigo: 'FIN-001' },
    { id: 5, nombre: 'RR.HH', codigo: 'RRH-001' },
    { id: 6, nombre: 'Logística', codigo: 'LOG-001' },
    { id: 7, nombre: 'Producción', codigo: 'PRD-001' },
  ];

  // Proveedores (con RUC)
  proveedores: IProveedor[] = [
    { id: '1', ruc: '123456789012', nombre: 'DISTRIBUIDORA NORTE' },
    { id: '2', ruc: '20234567890', nombre: 'PROVEEDORA SUR S.A.C' },
    { id: '3', ruc: '20345678901', nombre: 'EMPRESA LOGISTICA GLOBAL' },
    { id: '4', ruc: '20456789012', nombre: 'SUMINISTROS INDUSTRIALES LLC' },
    { id: '5', ruc: '20567890123', nombre: 'SERVICIOS PROFESIONALES SAC' },
  ];

  // Colaboradores (con DNI/Documento)
  colaboradores: IColaborador[] = [
    { id: '1', documento: '74581632', nombre: 'Juan Carlos Pérez López' },
    { id: '2', documento: '23456789', nombre: 'María Alejandra González Ruiz' },
    { id: '3', documento: '34567890', nombre: 'Roberto Miguel Salazar Flores' },
    { id: '4', documento: '45678901', nombre: 'Patricia Rosario Mendez Silva' },
    { id: '5', documento: '56789012', nombre: 'Carlos Eduardo Rodríguez Campos' },
    { id: '6', documento: '41256789', nombre: 'Ana Lucía Torres Vega' },
    { id: '7', documento: '42367890', nombre: 'Luis Fernando Castro Morales' },
    { id: '8', documento: '43478901', nombre: 'Carmen Rosa Díaz Herrera' },
    { id: '9', documento: '44589012', nombre: 'Jorge Alberto Ramírez Soto' },
    { id: '10', documento: '45690123', nombre: 'Diana Patricia Vargas Córdova' },
    { id: '11', documento: '46701234', nombre: 'Miguel Ángel Flores Jiménez' },
    { id: '12', documento: '47812345', nombre: 'Rosa Elena Castillo Quispe' },
    { id: '13', documento: '48923456', nombre: 'Fernando José Medina Paredes' },
    { id: '14', documento: '49034567', nombre: 'Gabriela Sofia Ramos Chávez' },
    { id: '15', documento: '50145678', nombre: 'Ricardo Manuel Gutiérrez Luna' },
    { id: '16', documento: '51256789', nombre: 'Claudia Beatriz Navarro Ortiz' },
    { id: '17', documento: '52367890', nombre: 'Daniel Arturo Romero Arias' },
    { id: '18', documento: '53478901', nombre: 'Vanessa Paola Cruz Velásquez' },
    { id: '19', documento: '54589012', nombre: 'Rodrigo Alejandro Rojas Espinoza' },
    { id: '20', documento: '55690123', nombre: 'Mónica Isabel Reyes Cabrera' },
  ];

  // Sucursales
  sucursales: ISucursal[] = [
    { id: 1, nombre: 'Lima - Sede Central', codigo: 'SUC-001' },
    { id: 2, nombre: 'Arequipa', codigo: 'SUC-002' },
    { id: 3, nombre: 'Cusco', codigo: 'SUC-003' },
    { id: 4, nombre: 'Trujillo', codigo: 'SUC-004' },
    { id: 5, nombre: 'Piura', codigo: 'SUC-005' },
  ];

  // Almacenes
  almacenes: IAlmacen[] = [
    { id: 1, nombre: 'Almacén Central', codigo: 'ALM-001', sucursal: 'Lima - Sede Central' },
    { id: 2, nombre: 'Almacén Arequipa', codigo: 'ALM-002', sucursal: 'Arequipa' },
    { id: 3, nombre: 'Almacén Cusco', codigo: 'ALM-003', sucursal: 'Cusco' },
    { id: 4, nombre: 'Almacén Trujillo', codigo: 'ALM-004', sucursal: 'Trujillo' },
    { id: 5, nombre: 'Almacén Piura', codigo: 'ALM-005', sucursal: 'Piura' },
  ];

  // DATOS CONDICIÓN DE PAGO
  rowDataCondicionPago: any[] = [];
  private gridApiCondicionPago!: GridApi;

  // DATOS DE LA TABLA
  rowData: OrdenGiroEntity[] = [];

  colDefsDetalle: ColDef[] = [
    {
      field: 'codigo',
      headerName: 'Código',
      width: 120,
      sortable: true,
    },
    {
      field: 'descripcion',
      headerName: 'Descripción',
      width: 250,
      sortable: true,
    },
    {
      field: 'sucursal',
      headerName: 'Sucursal',
      width: 150,
      sortable: true,
    },
    {
      field: 'valor',
      headerName: 'Valor neto',
      headerClass: 'derechaencabezado',
      width: 150,
      sortable: true,
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
      }

    },
    {
      field: 'depreacumulada',
      headerName: 'Depreciación Acumulada',
      headerClass: 'derechaencabezado',
      width: 150,
      sortable: true,
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
      }
    },
    {
      field: 'vidautil',
      headerName: 'Vida útil restante',
      width: 150,
      sortable: true,
    },
    {
      field: 'acciones',
      headerName: 'Acciones',
      headerClass: 'centrarencabezado',
      width: 100,
      cellRenderer: BotonAccionesComponent,
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },

  ]

  columnTypes = {
    rightAligned: {
      headerClass: 'ag-right-aligned-header',
      cellClass: 'ag-right-aligned-cell'
    }
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


  constructor(private fb: FormBuilder, private modalController: ModalController, private toastService: ToastService, private countryService: CountryService, private formValidationService: FormValidationService) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
    this.fechaEmisionSeleccionada = today;

    // Sync store → rowData + grid (aplicando el buscador en cliente)
    effect(() => {
      const data = this.ordenGiroFacade.ordenes();
      this.rowData = [...data];
      this.aplicarBuscador();
    });

    // Formulario alineado al backend (solicitud_giro): sucursal, fecha, monto, tipo (O/F), motivo.
    // SOBRA: el backend no modela beneficiario/banco/cuenta/forma de pago/cuotas/moneda → no se incluyen.
    this.OrdenesDeGiroForm = this.fb.group({
      sucursalId: [null, Validators.required],
      fecha: [new Date().toISOString().slice(0, 10), Validators.required],
      monto: [null, [Validators.required, Validators.min(0.01)]],
      tipoSolicitud: ['O', Validators.required],
      centroCostoId: [null],
      motivo: [''],
      estado: [{ value: 'Pendiente', disabled: true }],
    });
  }

  // Catálogo real de sucursales (id numérico) para el selector.
  sucursalesReales: { id: number; nombre: string }[] = [];
  centrosCostoReales: { id: number; nombre: string }[] = [];
  // Tipos de solicitud del backend (O = Orden de Giro, F = Fondo Fijo).
  tiposSolicitud = [
    { id: 'O', nombre: 'Orden de Giro' },
    { id: 'F', nombre: 'Fondo Fijo' },
  ];
  // Buscador (cliente) + filtros (backend).
  busqueda = '';
  fechaDesdeFiltro = '';
  fechaHastaFiltro = '';
  estadoFiltro = '';
  estadosFiltro = [
    { id: '', nombre: 'Todos los estados' },
    { id: '3', nombre: 'Pendiente' },
    { id: '1', nombre: 'Aprobada' },
    { id: '0', nombre: 'Anulada' },
  ];

  ngOnInit(): void {
    this.ordenGiroFacade.cargarDatos();
    // Catálogo real de sucursales (id numérico) para el selector.
    this.ordenGiroFacade.listarSucursales().subscribe({
      next: (s) => { this.sucursalesReales = s; this.gridApi?.refreshCells({ force: true }); },
      error: () => (this.sucursalesReales = []),
    });
    this.ordenGiroFacade.listarCentrosCosto().subscribe({
      next: (c) => { this.centrosCostoReales = c; this.gridApi?.refreshCells({ force: true }); },
      error: () => (this.centrosCostoReales = []),
    });
    this.configurarLabelsPorPais();
    this.formValidationService.inicializarFormulario(this.OrdenesDeGiroForm);
  }

  /** Ionic cachea la página; recarga la lista en CADA entrada para reflejar
   *  los cambios de estado hechos en Aprobación (aprobada/rechazada). */
  ionViewWillEnter(): void {
    this.ordenGiroFacade.cargarDatos();
  }

  /** Aplica el buscador (texto) en cliente sobre rowData y empuja a la grilla. */
  private aplicarBuscador(): void {
    const t = (this.busqueda ?? '').trim().toLowerCase();
    const filtradas = !t
      ? this.rowData
      : this.rowData.filter((o) =>
          `${o.og_num_orden_giro ?? ''} ${o.og_monto ?? ''} ${o.og_estado ?? ''} ${o.og_motivo ?? ''}`
            .toLowerCase().includes(t));
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', filtradas);
    }
  }

  /** Buscador (texto, cliente). */
  onBuscar(): void {
    this.aplicarBuscador();
  }

  /** Aplica filtros del backend (fecha desde/hasta, estado) y recarga. */
  aplicarFiltros(): void {
    this.ordenGiroFacade.cargarDatos({
      fechaDesde: this.fechaDesdeFiltro || undefined,
      fechaHasta: this.fechaHastaFiltro || undefined,
      estado: this.estadoFiltro || undefined,
    });
  }

  /** Exporta la grilla a Excel (.xlsx). */
  exportarExcel(): void {
    this.gridApi?.exportDataAsExcel({ fileName: 'ordenes-giro.xlsx', sheetName: 'Ordenes de giro' });
  }

  /** Crea o actualiza la solicitud de giro contra el backend real. */
  guardar(): void {
    if (this.OrdenesDeGiroForm.invalid) {
      this.toastService.warning('Completa los campos requeridos: sucursal, fecha, monto y tipo');
      return;
    }
    const f = this.OrdenesDeGiroForm.getRawValue();
    const esEdicion = !!this.filaSeleccionada?.og_id;
    const entity: OrdenGiroEntity = {
      ...(this.filaSeleccionada ?? {} as OrdenGiroEntity),
      og_id: this.filaSeleccionada?.og_id,
      og_num_orden_giro: this.filaSeleccionada?.og_num_orden_giro ?? '',
      og_sucursal_id: Number(f.sucursalId),
      og_fecha_emision: f.fecha,
      og_monto: Number(f.monto),
      og_tipo_solicitud: f.tipoSolicitud,
      og_motivo: f.motivo ?? '',
      og_estado: this.filaSeleccionada?.og_estado ?? 'Pendiente',
      // Opción A: el solicitante es el usuario logueado (en edición se conserva el original).
      og_solicitante_id: this.filaSeleccionada?.og_solicitante_id ?? this.solicitanteActualId(),
      og_centro_costo_id: f.centroCostoId != null ? Number(f.centroCostoId) : undefined,
    };
    if (esEdicion) {
      this.ordenGiroFacade.actualizar(entity);   // PUT (solo si está Pendiente)
    } else {
      this.ordenGiroFacade.guardar(entity, false); // POST (crea pendiente)
    }
    this.filaSeleccionada = null;
    this.editandoFilaIndex = null;
    this.OrdenesDeGiroForm.reset({ fecha: new Date().toISOString().slice(0, 10), tipoSolicitud: 'O', estado: 'Pendiente' });
    this.formValidationService.resetearEstado();
    setTimeout(() => this.ordenGiroFacade.cargarDatos(), 300);
  }

  /** Anula la solicitud seleccionada (solo si está pendiente). */
  anularSolicitud(): void {
    if (!this.filaSeleccionada?.og_id) {
      this.toastService.warning('Selecciona una solicitud para anular');
      return;
    }
    this.ordenGiroFacade.anular(this.filaSeleccionada.og_id).subscribe({
      next: () => {
        this.toastService.success('Solicitud anulada');
        this.filaSeleccionada = null;
        this.ordenGiroFacade.cargarDatos();
      },
      error: (e) => this.toastService.danger(e?.message || 'No se pudo anular la solicitud'),
    });
  }

  ngOnDestroy(): void {
    this.formValidationService.limpiarFormulario();
  }

  configurarLabelsPorPais() {
    if (this.pais === 'EC') {
      this.mostrarTipoCambio = false; // Ocultar tipo de cambio en Ecuador
    }
  }



  onGridReady(params: GridReadyEvent): void {
    this.gridApi = params.api;
    if (this.rowData.length > 0) {
      this.gridApi.setGridOption('rowData', [...this.rowData]);
    }

    // Restaurar la selección visual cuando el grid se recrea (toggle del panel lateral)
    if (this.filaSeleccionada) {
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node: any) => {
            if (node.data && node.data.og_num_orden_giro === this.filaSeleccionada?.og_num_orden_giro) {
              node.setSelected(true);
              this.gridApi.ensureNodeVisible(node, 'middle');
            }
          });
        }
      }, 150);
    }
  }

  async onCellClicked(event: any): Promise<void> {
    const data = event.data;

    // Si es la misma fila, no validar
    if (this.filaSeleccionada && this.filaSeleccionada.og_num_orden_giro === data.og_num_orden_giro) {
      return;
    }

    // Capturar el foco actual antes de abrir el modal
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Restaurar la selección anterior
      setTimeout(() => {
        this.gridApi.deselectAll();
        if (this.filaSeleccionada) {
          this.gridApi.forEachNode((node: any) => {
            if (node.data.og_num_orden_giro === this.filaSeleccionada!.og_num_orden_giro) {
              node.setSelected(true);
            }
          });
        }
        if (elementoConFoco && elementoConFoco.tagName === 'INPUT') {
          setTimeout(() => elementoConFoco.focus(), 100);
        }
      }, 0);
      return;
    }

    // Usuario confirmó - cargar nueva fila
    this.gridApi.deselectAll();
    this.filaSeleccionada = data;
    console.log('Fila seleccionada:', this.filaSeleccionada);
    event.node.setSelected(true);

    // Cargar datos de la orden seleccionada
    this.cargarDatosOrdenGiro(data, event.node);
  }

  onSelectionChanged(event: any): void {
    // Este método se mantiene por compatibilidad pero la lógica principal está en onCellClicked
  }

  onCuentasBancarias(cuenta: any) {
    console.log('Entidad financiera seleccionada:', cuenta);
  }

  /**
   * Cargar datos de una orden de giro en el formulario
   */
  private cargarDatosOrdenGiro(data: OrdenGiroEntity, node?: any): void {
    // Rastrear el índice de la fila siendo editada
    this.editandoFilaIndex = this.rowData.findIndex(r => r.og_num_orden_giro === data.og_num_orden_giro);
    this.selectedRowIndex = this.editandoFilaIndex;

    if (this.filaSeleccionada) {
      // Rellenar el formulario con los campos reales del backend (solicitud_giro).
      this.OrdenesDeGiroForm.patchValue({
        sucursalId: data.og_sucursal_id ?? null,
        fecha: (data.og_fecha_emision || '').slice(0, 10),
        monto: data.og_monto ?? null,
        tipoSolicitud: data.og_tipo_solicitud || 'O',
        centroCostoId: data.og_centro_costo_id ?? null,
        motivo: data.og_motivo || '',
        estado: data.og_estado,
      });

      // Habilitar/deshabilitar botones según el estado (anular/editar solo si Pendiente).
      this.botonAnularHabilitado = data.og_estado === 'Pendiente';
      this.botonBorradorHabilitado = data.og_estado === 'Pendiente';

      // Marcar el formulario como sin cambios después de cargar
      this.formValidationService.resetearEstado();
    }
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

  // onNumeroOrden(orden: INdeOrden) {
  //   console.log('Número de orden seleccionado:', orden);
  //   if (orden) {
  //     // Calcular monto de giro según la condición de pago
  //     let montoGiro: number | string;

  //     if (orden.condicionPago === 'Mixto' && orden.montoFinanciar && orden.numeroCuotas > 0) {
  //       // Para Mixto: monto a financiar / número de cuotas
  //       montoGiro = (orden.montoFinanciar / orden.numeroCuotas).toFixed(2);
  //     } else if (orden.numeroCuotas > 0) {
  //       // Para Crédito: monto total / número de cuotas
  //       montoGiro = (orden.montoTotal / orden.numeroCuotas).toFixed(2);
  //     } else {
  //       // Para Contado: monto total
  //       montoGiro = orden.montoTotal;
  //     }

  //     this.OrdenesDeGiroForm.patchValue({
  //       documentoBeneficiario: orden.ruc,
  //       nombreBeneficiario: orden.nombreBeneficiario,
  //       documentoAsociado: orden.nombre,
  //       condicionPago: orden.condicionPago,
  //       numeroCuotas: orden.numeroCuotas > 0 ? orden.numeroCuotas.toString().padStart(2, '0') : '',
  //       montoTotal: `S/${orden.montoTotal.toFixed(2)}`,
  //       montoContado: orden.montoContado ? `S/${orden.montoContado.toFixed(2)}` : '',
  //       montoFinanciar: orden.montoFinanciar ? `S/${orden.montoFinanciar.toFixed(2)}` : '',
  //       montoGiro: montoGiro,
  //       fechaProgramadaPago: orden.fechaProgramadaPago,
  //       sucursal: orden.sucursal,
  //       centroCosto: orden.centroCosto
  //     });

  //     // Mostrar cuotas en la tabla si existen
  //     if (orden.cuotas && orden.cuotas.length > 0) {
  //       this.rowDataCondicionPago = orden.cuotas.map(cuota => ({
  //         numeroCuotas: cuota.numeroCuotas.toString().padStart(2, '0'),
  //         montoTotal: cuota.montoTotal,
  //         fechaPago: cuota.fechaPago,
  //         estado: cuota.estado
  //       }));
  //     } else {
  //       this.rowDataCondicionPago = [];
  //     }

  //     // Actualizar la tabla
  //     if (this.gridApiCondicionPago) {
  //       this.gridApiCondicionPago.setGridOption('rowData', this.rowDataCondicionPago);
  //     }

  //     // Habilitar botones Guardar y Emitir cuando se selecciona una orden
  //     this.botonBorradorHabilitado = true;
  //     this.botonAnularHabilitado = false;
  //   }
  // }

  onDocumentoBeneficiario(tipo: 'Proveedor' | 'colaborador') {
    const documento = this.OrdenesDeGiroForm.get('documentoBeneficiario')?.value;
    console.log(`Documento ${tipo} ingresado:`, documento);

    if (tipo === 'Proveedor') {
      // Buscar en el array de proveedores por RUC
      const proveedor = this.proveedores.find(p => p.ruc === documento);
      if (proveedor) {
        this.OrdenesDeGiroForm.patchValue({
          nombreBeneficiario: proveedor.nombre
        });
      }
    } else if (tipo === 'colaborador') {
      // Buscar en el array de colaboradores por documento
      const colaborador = this.colaboradores.find(c => c.documento === documento);
      if (colaborador) {
        this.OrdenesDeGiroForm.patchValue({
          nombreBeneficiario: colaborador.nombre
        });
      }
    }
  }


  onSucursalSeleccionada(sucursal: ISucursal) {
    console.log('Sucursal seleccionada:', sucursal);
    // El formulario se actualiza automáticamente con valueKey='id'
  }

  onBeneficiarioSeleccionado(beneficiario: IProveedor) {
    console.log('Beneficiario seleccionado:', beneficiario);
    // El formulario se actualiza automáticamente con valueKey='id'
  }

  onBancoSeleccionado(banco: IBanco) {
    console.log('Banco seleccionado:', banco);
    // Habilitar y actualizar la cuenta bancaria del banco seleccionado
    if (banco) {
      const cuentaBancariaControl = this.OrdenesDeGiroForm.get('cuentaBancaria');
      if (cuentaBancariaControl) {
        cuentaBancariaControl.enable();
        // Buscar la cuenta bancaria que coincida con la del banco seleccionado
        const cuentaSeleccionada = this.cuentaBancaria.find(cuenta => cuenta.nombre === banco.cuentaBancaria);
        if (cuentaSeleccionada) {
          // Setear el ID de la cuenta bancaria que coincide con el número
          cuentaBancariaControl.patchValue(cuentaSeleccionada.id);
        } else {
          // Si no encuentra, setear directamente el número de cuenta
          cuentaBancariaControl.patchValue(banco.cuentaBancaria);
        }
      }
    }
  }
  onCuentaBancaria(cuentaBancaria: ICuentaB) {
    console.log('Banco seleccionado:', cuentaBancaria);
  }
  onFechaProgramada(date: Date) {
    console.log('Fecha seleccionada:', date);
    this.fechaprogramada = date;
    this.OrdenesDeGiroForm.patchValue({
      fechaProgramadaPago: date.toLocaleDateString('es-PE')
    });
  }
  onFormaPago(formaPago: ICondicionPago) {
    console.log('Forma de pago seleccionada:', formaPago);
    if (formaPago) {
      // Autocompletar banco y cuenta bancaria desde la condición de pago
      this.OrdenesDeGiroForm.patchValue({
        banco: formaPago.banco.id,
        cuentaBancaria: formaPago.cuentaBancaria.id
      });
      // Obtener el tipo de cambio más reciente
      if (this.tiposCambio.length > 0) {
        const tipoCambioReciente = this.tiposCambio[0];
        this.OrdenesDeGiroForm.patchValue({
          tipoCambio: tipoCambioReciente.tipoCambio
        });
      }
    }
  }

  onCentroCosto(centroCosto: ICentroCosto) {
    console.log('Centro de costo seleccionado:', centroCosto);
    // El formulario ya se actualiza automáticamente con el valueKey='id'
    // Este método puede usarse para lógica adicional si es necesaria
  }

  togglePanelLateral(): void {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  async botonNuevaOrden(): Promise<void> {
    // Validar si hay cambios sin guardar antes de limpiar
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;

    // Limpiar la selección
    this.filaSeleccionada = null;
    this.selectedRowIndex = null;
    this.editandoFilaIndex = null;

    // Resetear formulario (campos del backend)
    this.OrdenesDeGiroForm.reset({
      fecha: new Date().toISOString().slice(0, 10),
      tipoSolicitud: 'O',
      estado: 'Pendiente'
    });

    // Deshabilitar botones hasta llenar el formulario
    this.botonBorradorHabilitado = false;
    this.botonAnularHabilitado = false;

    // Deseleccionar todas las filas del grid
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Limpiar tabla de cuotas
    this.rowDataCondicionPago = [];
    if (this.gridApiCondicionPago) {
      this.gridApiCondicionPago.setGridOption('rowData', []);
    }

    // Marcar el formulario limpio como punto de partida
    this.formValidationService.resetearEstado();
  }

  trackByOrderId(index: number, item: INdeOrden): number {
    return item.id;
  }

  // ==================== MÉTODOS DE MODALES ====================

  async modalverActualizaciones(): Promise<void> {
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

    const rowData = [
      { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Registro inicial de la orden de giro' },
      { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: `Cambio de estado de "Pendiente" a "${this.filaSeleccionada?.og_estado || ''}"` },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones de la orden ${this.filaSeleccionada?.og_num_orden_giro || ''}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }


  filtrarPorFechas(range: { start: Date; end: Date }): void {
    this.startDate = range.start;
    this.endDate = range.end;
    this.fechaDesdeFiltro = range.start ? range.start.toISOString().slice(0, 10) : '';
    this.fechaHastaFiltro = range.end ? range.end.toISOString().slice(0, 10) : '';
    this.aplicarFiltros();
  }

  onFechaSeleccionadaE(fecha: Date): void {
    this.fechaEmisionSeleccionada = fecha;
    const fechaFormateada = fecha.toLocaleDateString('es-PE');
    this.OrdenesDeGiroForm.patchValue({
      fechaEmision: fechaFormateada
    });
  }

  /**
  * Formatear monto a 2 decimales
  */
  formatearMonto(monto: any): number {
    if (monto === null || monto === undefined || monto === '') {
      return 0;
    }
    const montoNumerico = parseFloat(String(monto).replace(/[^0-9.-]/g, ''));
    return isNaN(montoNumerico) ? 0 : Math.round(montoNumerico * 100) / 100;
  }

  // Formateo fecha para modal
  formatearFecha(fecha: string): string {
    if (!fecha) return '-';

    // Si está vacío o es undefined
    if (typeof fecha !== 'string') {
      return '-';
    }

    // Limpiar espacios en blanco
    fecha = fecha.trim();

    // Si ya está en formato dd/MM/yyyy, devolverlo como está
    if (/^\d{1,2}\/\d{1,2}\/\d{4}$/.test(fecha)) {
      return fecha;
    }

    // Si está en formato yyyy-MM-dd, convertir a dd/MM/yyyy
    if (/^\d{4}-\d{1,2}-\d{1,2}$/.test(fecha)) {
      const [año, mes, dia] = fecha.split('-');
      return `${dia}/${mes}/${año}`;
    }

    return '-';
  }

  async abrirModal(valor: string, fila: any): Promise<void> {
    // Obtener los datos de la fila para mostrar en el detalle
    const data = fila || this.filaSeleccionada;

    if (!data) {
      return;
    }

    // Buscar la orden asociada por docAsociado primero, luego por beneficiario
    let ordenAsociada = this.numeroOrden.find(o => o.nombre === data.og_doc_asociado);

    if (!ordenAsociada) {
      ordenAsociada = this.numeroOrden.find(o => o.nombreBeneficiario === data.og_beneficiario);
    }

    if (!ordenAsociada && data.og_ruc) {
      ordenAsociada = this.numeroOrden.find(o => o.ruc === data.og_ruc);
    }

    // Obtener RUC del beneficiario si no está en data
    let ruc = data.og_ruc;
    if (!ruc) {
      const proveedor = this.proveedores.find(p => p.nombre === data.og_beneficiario);
      if (proveedor) {
        ruc = proveedor.ruc;
      }
    }

    // Obtener valores dinámicos de la orden asociada o datos por defecto
    const sucursal = ordenAsociada?.sucursal || '-';
    const centroCosto = ordenAsociada?.centroCosto || '-';
    const condicionPagoNombre = ordenAsociada?.condicionPago || '-';

    // Buscar almacén según la sucursal
    let almacen = '-';
    if (sucursal && sucursal !== '-') {
      const almacenFound = this.almacenes.find(a => a.sucursal === sucursal);
      almacen = almacenFound?.nombre || '-';
    }

    // Buscar condición de pago para obtener detalles
    let condicionPago = condicionPagoNombre;
    if (condicionPagoNombre && condicionPagoNombre !== '-') {
      const condPago = this.condicionesPago.find(cp => cp.nombre === condicionPagoNombre);
      condicionPago = condPago?.nombre || condicionPagoNombre;
    }

    const detalleOrdenGiro = [
      { label: 'Proveedor', value: data.og_beneficiario || '-' },
      { label: 'Almacen', value: 'Cocina' },
      { label: 'Ruc', value: ruc || '-' },
      { label: 'Sucursal', value: 'Sucursal Piura' },
      { label: 'Fecha de registro', value: this.formatearFecha(data.og_fecha_emision) || '-' },
      { label: 'Centro de costo', value: 'Administración' },
      { label: 'Fecha de entrega', value: this.formatearFecha(data.og_fecha_programada_pago ?? '') || '-' },
      { label: 'Condición de pago', value: 'Crédito 15 días fin de mes' },
    ];

    const colDefs: ColDef[] = [
      { field: 'codigo', headerName: 'Codigo', width: 70 },
      { field: 'cantidad', headerName: 'Cantidad', width: 70 },
      { field: 'descripcion', headerName: 'Descripción', width: 150, flex: 1 },
      { field: 'unidad', headerName: 'Unidad', width: 70 },
      {
        field: 'precio', headerName: 'Precio Unitario', headerClass: 'derechaencabezado', width: 80,
        valueFormatter: (params: any) => {
          if (params.value) {
            return `${this.monedapais} ${parseFloat(params.value).toFixed(2)}`;
          }
          return '-'
        },
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', }
      },

      {
        field: 'subtotal', headerName: 'Subtotal', headerClass: 'derechaencabezado', width: 80,
        valueFormatter: (params: any) => {
          if (params.value) {
            return `${this.monedapais} ${parseFloat(params.value).toFixed(2)}`;
          }
          return '-'
        },
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', }
      },

      {
        field: 'impuestos', headerName: 'Impuestos', headerClass: 'derechaencabezado', width: 80,
        valueFormatter: (params: any) => {
          if (params.value) {
            return `${this.monedapais} ${parseFloat(params.value).toFixed(2)}`;
          }
          return '-'
        },
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', }
      },

      {
        field: 'total', headerName: 'Total', headerClass: 'derechaencabezado', width: 80,
        valueFormatter: (params: any) => {
          if (params.value) {
            return `${this.monedapais} ${parseFloat(params.value).toFixed(2)}`;
          }
          return '-'
        },
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', }
      },


    ];

    // Calcular el símbolo de moneda
    const simboloMoneda = (data.og_moneda ?? '').toLowerCase() === 'dólares' ? '$' : 'S/';

    // Datos dinámicos para la tabla contable
    const rowDataTabla = [
      { codigo: 'PR-0001', cantidad: 1, descripcion: 'Aceite Vegetal Primor x200 ml', unidad: 'Corriente', precio: 50.00, subtotal: 41.00, impuestos: 9.00, total: 50.00 },
      { codigo: 'PR-0001', cantidad: 1, descripcion: 'Leche condensada', unidad: 'Corriente', precio: 103.44, subtotal: 84.52, impuestos: 18.62, total: 103.44 },
      { codigo: 'PR-0001', cantidad: 1, descripcion: 'Fanta naranja 1.5L', unidad: 'Corriente', precio: 5.00, subtotal: 4.10, impuestos: 0.90, total: 5.00 },
      { codigo: 'PR-0001', cantidad: 1, descripcion: 'Conserva de durazno', unidad: 'Corriente', precio: 40.00, subtotal: 32.80, impuestos: 7.20, total: 40.00 },



    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Detalle de la orden asociada ${data.og_num_orden_giro}`,
        detalles: detalleOrdenGiro,
        mostrarTabla: true,
        mostrarDetalle: true,
        subtituloTabla: 'Detalle de los artículos',
        colDefs: colDefs,
        rowData: rowDataTabla,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        textoBotonCancelar: 'Cerrar',
        ocultarBotonConfirmar: true,
        isdoblecolumna: true,
        mostrarTotal: true,
        itemstotal: [
          { label: 'Subtotal', value: `${simboloMoneda} ${data.og_monto.toFixed(2)}` },
          { label: 'Impuestos', value: `${simboloMoneda} ${(data.og_monto * 0.18).toFixed(2)}` },
          { label: 'Total', value: `${simboloMoneda} ${(data.og_monto * 1.18).toFixed(2)}` },
        ],
        widthModal: '706px',
      }
    });

    await modal.present();
  }

  onGridReadyCondicionPago(params: GridReadyEvent): void {
    this.gridApiCondicionPago = params.api;
    this.gridApiCondicionPago.setGridOption('rowData', this.rowDataCondicionPago);
  }

  onCellClickedCondicionPago(event: any): void {
    console.log('Celda de condición de pago clickeada:', event.data);
  }

  onCondicionPagoSeleccionada(condicion: ICondicionPago): void {
    console.log('Condición de pago seleccionada:', condicion);
    const numeroCuotas = condicion?.banco?.numeroCuotas ?? 0;
    if (condicion && numeroCuotas > 0) {
      // Generar datos de cuotas
      const cuotas = [];
      const montoPorCuota = condicion.banco.montoTotal / numeroCuotas;

      for (let i = 1; i <= numeroCuotas; i++) {
        const fechaPago = new Date();
        fechaPago.setMonth(fechaPago.getMonth() + i);

        cuotas.push({
          numeroCuotas: i,
          montoTotal: montoPorCuota.toFixed(2),
          fechaPago: fechaPago.toLocaleDateString('es-PE'),
          estado: 'Pendiente'
        });
      }

      this.rowDataCondicionPago = cuotas;
      if (this.gridApiCondicionPago) {
        this.gridApiCondicionPago.setGridOption('rowData', this.rowDataCondicionPago);
      }
    }
  }

  botonAnular(): void {
    if (!this.filaSeleccionada) {
      this.toastService.warning('Por favor, selecciona una orden de giro para anular');
      return;
    }

    this.openAnularModal();
  }

  async openAnularModal(): Promise<void> {
    // Función para obtener el símbolo de moneda
    const obtenerSimboloMoneda = (moneda: string): string => {
      if (moneda.toLowerCase() === 'dólares') {
        return '$';
      }
      return 'S/';
    };

    const detalles = [
      { label: 'Beneficiario', value: this.filaSeleccionada?.og_beneficiario || '' },
      { label: 'Fecha de emisión', value: this.formatearFecha(this.filaSeleccionada?.og_fecha_emision || '') },
      { label: 'Fecha  de pago', value: this.formatearFecha(this.filaSeleccionada?.og_fecha_programada_pago || '') },
      { label: 'Orden de compra', value: this.filaSeleccionada?.og_doc_asociado || '' },
      { label: 'Monto', value: `${obtenerSimboloMoneda(this.filaSeleccionada?.og_moneda || '')} ${this.filaSeleccionada?.og_monto}` || '' }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      componentProps: {
        tituloModal: `Anular orden de giro ${this.filaSeleccionada?.og_num_orden_giro}`,
        subtitulomodal: 'Detalle de la orden de giro',
        detalles: detalles,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo de la anulación:',
        placeholderTextarea: 'Describe el motivo de la anulación de la orden de giro.',
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Anular',
        textoBotonCancelar: 'Cancelar',
        colorBotonConfirmar: 'danger',
        motivoObligatorio: true
      },
      cssClass: 'promo',
    });

    await modal.present();

    const { data } = await modal.onDidDismiss();

    if (data && data.action === 'confirmar') {
      // Usuario confirmó la anulación
      console.log('Motivo de anulación:', data.motivo);

      // Persistir anulación a través de la fachada
      if (this.filaSeleccionada) {
        const ordenAnulada: OrdenGiroEntity = { ...this.filaSeleccionada, og_estado: 'Anulada' };
        this.ordenGiroFacade.actualizar(ordenAnulada);

        // Actualizar el formulario para reflejar el cambio
        this.OrdenesDeGiroForm.patchValue({ estado: 'Anulada' });

        // Deshabilitar el botón Anular
        this.botonAnularHabilitado = false;

        // Limpiar la selección
        this.filaSeleccionada = null;
        this.selectedRowIndex = null;
        this.editandoFilaIndex = null;
      }
    }
  }

  botonGuardarBorrador(): void {
    const formValue = this.OrdenesDeGiroForm.getRawValue();

      // Validar solo los campos requeridos que deben estar llenos
    if (this.OrdenesDeGiroForm.invalid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    // Crear nueva orden de giro
    const nuevaOrden: OrdenGiroEntity = {
      og_num_orden_giro: this.editandoFilaIndex !== null ? this.rowData[this.editandoFilaIndex].og_num_orden_giro : `OG-2025-${String(this.rowData.length + 1).padStart(4, '0')}`,
      og_fecha_emision: formValue.fechaEmision,
      og_beneficiario: formValue.nombreBeneficiario,
      og_fecha_deposito: formValue.fechaProgramadaPago,
      og_banco: formValue.banco ? this.banco.find(b => b.id === formValue.banco)?.nombre || '' : '',
      og_moneda: formValue.moneda,
      og_monto: this.formatearMonto(formValue.montoGiro),
      og_doc_asociado: formValue.documentoAsociado,
      // responsable: 'Usuario Actual',
      og_estado: 'Pendiente',
      og_tipo_beneficiario: formValue.tipoBeneficiario,
      og_fecha_programada_pago: formValue.fechaProgramadaPago,
      og_ruc: formValue.documentoBeneficiario || ''
    };

    // Persistir a través de la fachada (el effect() sincroniza rowData + grid automáticamente)
    this.ordenGiroFacade.guardar(nuevaOrden, this.editandoFilaIndex !== null);

    // Resetear formulario
    this.editandoFilaIndex = null;
    this.filaSeleccionada = nuevaOrden;
    this.OrdenesDeGiroForm.reset({
      fechaEmision: new Date().toLocaleDateString('es-PE'),
      tipoDocumento: 'RUC',
      moneda: 'Soles',
      tipoCambio: '3.75',
      estado: 'Pendiente'
    });

    // Marcar como guardado para resetear el tracking de cambios
    this.formValidationService.resetearEstado();
  }

  botonEmitir(): void {
    const formValue = this.OrdenesDeGiroForm.getRawValue();

    // Validar solo los campos requeridos que deben estar llenos
    if (this.OrdenesDeGiroForm.invalid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    // Crear nueva orden de giro
    const nuevaOrden: OrdenGiroEntity = {
      og_num_orden_giro: this.editandoFilaIndex !== null ? this.rowData[this.editandoFilaIndex].og_num_orden_giro : `OG-2025-${String(this.rowData.length + 1).padStart(4, '0')}`,
      og_fecha_emision: formValue.fechaEmision,
      og_beneficiario: formValue.nombreBeneficiario,
      og_fecha_deposito: formValue.fechadeposito || '',
      og_banco: formValue.banco ? this.banco.find(b => b.id === formValue.banco)?.nombre || '' : '',
      og_moneda: formValue.moneda,
      og_monto: this.formatearMonto(formValue.montoGiro),
      og_doc_asociado: formValue.documentoAsociado,
      // responsable: 'Usuario Actual',
      og_estado: 'Emitida',
      og_tipo_beneficiario: formValue.tipoBeneficiario,
      og_fecha_programada_pago: formValue.fechaProgramadaPago,
      og_ruc: formValue.documentoBeneficiario || ''
    };

    // Persistir a través de la fachada (el effect() sincroniza rowData + grid automáticamente)
    this.ordenGiroFacade.actualizar(nuevaOrden);

    // Actualizar filaSeleccionada para que el botón Anular aparezca
    this.filaSeleccionada = nuevaOrden;
    this.selectedRowIndex = this.editandoFilaIndex !== null ? this.editandoFilaIndex : this.rowData.length - 1;

    // Deshabilitar botones después de emitir
    this.botonBorradorHabilitado = false;

    // Habilitar botón Anular cuando la orden está emitida
    this.botonAnularHabilitado = true;

    // Actualizar el estado de la cuota correspondiente a "Pagada"
    const montoPagado = formValue.montoGiro;
    const cuotaPorPagar = this.rowDataCondicionPago.find(cuota => {
      const montoEnTexto = cuota.montoTotal.replace('S/ ', '').replace('.00', '');
      return parseFloat(montoEnTexto) === montoPagado && cuota.estado === 'Pendiente';
    });

    if (cuotaPorPagar) {
      cuotaPorPagar.estado = 'Pagada';
      if (this.gridApiCondicionPago) {
        this.gridApiCondicionPago.refreshCells({ force: true });
      }
    }

    // Mostrar toast
    this.toastService.success('¡Orden de giro emitida exitosamente!');

    // NO limpiar la selección - mantenerla para poder anular si es necesario
    this.editandoFilaIndex = null;

    // Cargar los datos de la nueva orden en el formulario para mantener la información
    // (cargarDatosOrdenGiro ya llama a resetearEstado internamente)
    this.cargarDatosOrdenGiro(nuevaOrden);
  }

}
