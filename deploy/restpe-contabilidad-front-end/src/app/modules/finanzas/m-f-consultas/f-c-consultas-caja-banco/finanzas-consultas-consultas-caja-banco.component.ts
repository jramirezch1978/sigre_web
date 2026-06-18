import { Component, OnInit, inject, Signal, signal, computed, effect } from '@angular/core';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalController } from '@ionic/angular';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ConsultaCajaBancoFacade } from 'src/app/modules/finanzas/application/facades/consulta-caja-banco.facade';
import { ConsultaCajaBancoFeedbackEffects } from 'src/app/modules/finanzas/effects/consulta-caja-banco-feedback.effect';
import { ConsultaCajaBancoEntity } from 'src/app/modules/finanzas/domain/models/consulta-caja-banco.entity';

// Font Awesome Icons
import { faHandHoldingDollar } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDisplayChartUpCircleDollar, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { ModalDetalleConsultasCajabancoComponent } from './modal-detalle-consultas-cajabanco/modal-detalle-consultas-cajabanco.component';



@Component({
  selector: 'app-finanzas-consultas-consultas-caja-banco',
  templateUrl: './finanzas-consultas-consultas-caja-banco.component.html',
  styleUrls: ['./finanzas-consultas-consultas-caja-banco.component.scss'],
  standalone: false,
})
export class FinanzasConsultasConsultasCajaBancoComponent implements OnInit {
  // ── Clean Architecture ────────────────────────────────────────────
  readonly facade = inject(ConsultaCajaBancoFacade);
  private readonly _feedbackEffects = inject(ConsultaCajaBancoFeedbackEffects);
  readonly isLoading: Signal<boolean> = this.facade.isLoading;
  readonly buscando = signal(false);
  readonly loaderActivo = computed(() => this.isLoading() || this.buscando());

  // Font Awesome Icons
  farHandHoldingDollar = faHandHoldingDollar;
  fasAngleDown = faAngleDown;
  fasDisplayChartUpCircleDollar = faDisplayChartUpCircleDollar;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  private gridApi!: GridApi;

  // Control de estado de filtros
  hasFilter: boolean = false;
  canExport: boolean = false;

  // Totales calculados
  totalSaldoContable: number = 0;
  totalSaldoDisponible: number = 0;

  // Configuración de ag-grid
  columnTypes = {};

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
  };
  // Datos de muestra para el autocomplete de sucursales
   sucursalList = [
    { id: 1, nombre: 'Centro de producción'},
    { id: 2, nombre: 'Sucursal principal' },
    { id: 3, nombre: 'Sucursal 1' },
    { id: 4, nombre: 'Sucursal 2'},
    { id: 5, nombre: 'Sucursal 3'},
  ];

  // Listas para los filtros select
  entidadesFinancierasList = [
    { value: 'interbank', label: 'Interbank' },
    { value: 'scotiabank', label: 'Scotiabank' },
    { value: 'cajapiura', label: 'Caja Piura' },
    { value: 'cajasullana', label: 'Caja Sullana' },
    { value: 'bancodelanacion', label: 'Banco de la Nación' }
  ];

  tiposCuentaList = [
    { value: 'corriente', label: 'Corriente' },
    { value: 'ahorros', label: 'Ahorros' },
    { value: 'lineadecredito', label: 'Línea de crédito' },
    { value: 'otros', label: 'Otros' }
  ];

  monedasList = [
    { value: 'soles', label: 'Soles' },
    { value: 'dolares', label: 'Dólares' }
  ];

  estadosList = [
    { value: 'activo', label: 'Activo' },
    { value: 'inactivo', label: 'Inactivo' }
  ];

  // Datos de la tabla - vacío al inicio
  rowData: ConsultaCajaBancoEntity[] = [];

  colDefs: ColDef[] = [
    // { field: 'razonSocial', headerName: 'Razón social', width: 180,},
    { field: 'ccb_entidad_financiera', headerName: 'Entidad financiera', width: 140 },
    { field: 'ccb_tipo_cuenta', headerName: 'Tipo de cuenta', width: 120 },
    { field: 'ccb_numero_cuenta', headerName: 'N° de cuenta', width: 140 },
    { field: 'ccb_moneda', headerName: 'Moneda', width: 100 },
    {
      field: 'ccb_saldo_contable',
      headerName: 'Saldo contable',
      width: 140,
      headerClass: 'ag-right-aligned-header',
      valueFormatter: (params) => {
        if (params.value === null || params.value === undefined) return '–';
        const value = Number(params.value);
        if (isNaN(value)) return '–';
        
        const absValue = Math.abs(value);
        const formattedValue = new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2,
        }).format(absValue);
        
        if (value < 0) {
          return `(${formattedValue})`;
        }
        return `${formattedValue}`;
      },
      cellStyle: (params) => {
        const style: any = {  textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'end' };
        const value = Number(params.value);
        if (!isNaN(value) && value < 0) {
          style.color = '#EF4444';
        }
        return style;
        
      },
    },
    {
      field: 'ccb_saldo_disponible',
      headerName: 'Saldo disponible',
      width: 140,
      headerClass: 'ag-right-aligned-header',
      valueFormatter: (params) => {
        if (params.value === null || params.value === undefined) return '–';
        const value = Number(params.value);
        if (isNaN(value)) return '–';
        
        const absValue = Math.abs(value);
        const formattedValue = new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2,
        }).format(absValue);
        
        if (value < 0) {
          return `(${formattedValue})`;
        }
        return `${formattedValue}`;
      },
      cellStyle: (params) => {
        const style: any = { textAlign: 'right' };
        const value = Number(params.value);
        if (!isNaN(value) && value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
      cellRenderer: VistaCellRenderComponent,
    },
    { field: 'ccb_sucursal', headerName: 'Sucursal', width: 140 },
    {
      field: 'ccb_estado',
      headerName: 'Estado',
      width: 100,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>`;
        } else if (params.value === 'Inactivo') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>`;
        }
        return params.value;
      },
    },
  ];

  constructor(private modalController: ModalController) {
    // Sincronizar store → rowData + totales automáticamente
    effect(() => {
      const data = this.facade.cuentas();
      this.rowData = data;
      this.calcularTotales();
      if (this.gridApi && data.length > 0) {
        this.gridApi.setGridOption('rowData', data);
      }
    });
  }

  ngOnInit() {}

  onBtReset() {
    this.buscando.set(true);
    setTimeout(() => {
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }
      this.buscando.set(false);
    }, 400);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onCellClicked(event: any) {
    console.log('Celda clickeada:', event);
    // Abrir modal de detalle si es la columna de saldo disponible
    if (event.colDef.field === 'ccb_saldo_disponible') {
      this.abrirModalDetalleCuenta(event.data);
    }
  }

  async abrirModalDetalleCuenta(rowData: any) {
    
    // Obtener los datos específicos para esta cuenta
    const asientosContables = this.obtenerAsientosContables(rowData.ccb_numero_cuenta);
    const movimientosBancarios = this.obtenerMovimientosBancarios(rowData.ccb_numero_cuenta);
    const colDefsAsientos = this.obtenerColumnasAsientos();
    const colDefsMovimientos = this.obtenerColumnasMovimientos();
    
    const modal = await this.modalController.create({
      component: ModalDetalleConsultasCajabancoComponent,
      cssClass: 'promo',
      componentProps: {
        numeroCuenta: rowData.ccb_numero_cuenta,
        datosCuenta: {
          razonSocial: 'RESTAURANTE SABOR PERUANO SAC',
          banco: 'Interbank – Cuenta Corriente',
          saldoContable: 'S/ 25,450.78',
          saldoDisponible: 'S/ 18,300.25',
          fechaContable: '12/12/2025',
          glosaContable: 'Pago del servicio de luz en "Luz del Sur".'
        },
        asientosContables: asientosContables,
        movimientosBancarios: movimientosBancarios,
        colDefsAsientos: colDefsAsientos,
        colDefsMovimientos: colDefsMovimientos
      }
    });

    await modal.present();
  }

  obtenerAsientosContables(numeroCuenta: string) {
    // Datos personalizados de asientos contables según la cuenta
    const asientosPorCuenta: any = {
      '200-3001234567': [
        {
          cuenta: '4212',
          descripcion: 'Factura por pagar',
          debe: 'S/354.00',
          haber: '',
          centroCosto: 'Administración',
          docReferencial: 'F001-000123'
        },
        {
          cuenta: '1041',
          descripcion: 'Cuenta de banco Interbank soles',
          debe: '',
          haber: 'S/354.00',
          centroCosto: 'Administración',
          docReferencial: 'F001-000123'
        }
      ],
      '000-4567890123': [
        {
          cuenta: '1042',
          descripcion: 'Cuenta de banco Scotiabank dólares',
          debe: '$1,200.00',
          haber: '',
          centroCosto: 'Ventas',
          docReferencial: 'B001-000456'
        },
        {
          cuenta: '7011',
          descripcion: 'Ventas de mercaderías',
          debe: '',
          haber: '$1,200.00',
          centroCosto: 'Ventas',
          docReferencial: 'B001-000456'
        }
      ],
      '001-2345678901': [
        {
          cuenta: '6321',
          descripcion: 'Servicios de mantenimiento',
          debe: 'S/850.00',
          haber: '',
          centroCosto: 'Operaciones',
          docReferencial: 'F001-000789'
        },
        {
          cuenta: '1041',
          descripcion: 'Cuenta de banco Caja Piura soles',
          debe: '',
          haber: 'S/850.00',
          centroCosto: 'Operaciones',
          docReferencial: 'F001-000789'
        }
      ],
      '002-9876543210': [
        {
          cuenta: '4511',
          descripcion: 'Préstamos bancarios',
          debe: 'S/5,000.00',
          haber: '',
          centroCosto: 'Finanzas',
          docReferencial: 'LC-001'
        },
        {
          cuenta: '1041',
          descripcion: 'Línea de crédito Caja Sullana',
          debe: '',
          haber: 'S/5,000.00',
          centroCosto: 'Finanzas',
          docReferencial: 'LC-001'
        }
      ],
      '00-456-789012': [
        {
          cuenta: '6241',
          descripcion: 'Pago de servicios',
          debe: 'S/450.00',
          haber: '',
          centroCosto: 'Administración',
          docReferencial: 'F001-000321'
        },
        {
          cuenta: '1041',
          descripcion: 'Cuenta Banco de la Nación soles',
          debe: '',
          haber: 'S/450.00',
          centroCosto: 'Administración',
          docReferencial: 'F001-000321'
        }
      ]
    };

    return asientosPorCuenta[numeroCuenta] || [];
  }

  obtenerMovimientosBancarios(numeroCuenta: string) {
    // Datos personalizados de movimientos bancarios según la cuenta
    const movimientosPorCuenta: any = {
      '200-3001234567': [
        {
          fecha: '10/11/2025',
          tipoMovimiento: 'Orden de giro',
          documento: 'CB-000145',
          descripcion: 'Pago POS',
          cargo: '353.00',
          abono: '',
          saldo: '25,450.78'
        },
        {
          fecha: '08/11/2025',
          tipoMovimiento: 'Depósito',
          documento: 'DEP-001234',
          descripcion: 'Depósito en efectivo',
          cargo: '',
          abono: '5,000.00',
          saldo: '25,803.78'
        }
      ],
      '000-4567890123': [
        {
          fecha: '15/11/2025',
          tipoMovimiento: 'Transferencia',
          documento: 'TRF-000789',
          descripcion: 'Pago a proveedor internacional',
          cargo: '$800.00',
          abono: '',
          saldo: '$5,000.00'
        },
        {
          fecha: '12/11/2025',
          tipoMovimiento: 'Depósito',
          documento: 'DEP-000567',
          descripcion: 'Cobro de exportación',
          cargo: '',
          abono: '$3,000.00',
          saldo: '$5,800.00'
        }
      ],
      '001-2345678901': [
        {
          fecha: '18/11/2025',
          tipoMovimiento: 'Cheque',
          documento: 'CHQ-000456',
          descripcion: 'Pago de servicios',
          cargo: 'S/850.00',
          abono: '',
          saldo: 'S/8,200.00'
        },
        {
          fecha: '16/11/2025',
          tipoMovimiento: 'Depósito',
          documento: 'DEP-000890',
          descripcion: 'Cobro a cliente',
          cargo: '',
          abono: 'S/2,500.00',
          saldo: 'S/9,050.00'
        }
      ],
      '002-9876543210': [
        {
          fecha: '20/11/2025',
          tipoMovimiento: 'Disposición',
          documento: 'DIS-000123',
          descripcion: 'Uso de línea de crédito',
          cargo: '',
          abono: 'S/10,000.00',
          saldo: 'S/25,000.00'
        },
        {
          fecha: '18/11/2025',
          tipoMovimiento: 'Amortización',
          documento: 'AMORT-000045',
          descripcion: 'Pago de línea de crédito',
          cargo: 'S/5,000.00',
          abono: '',
          saldo: 'S/15,000.00'
        }
      ],
      '00-456-789012': [
        {
          fecha: '19/11/2025',
          tipoMovimiento: 'Transferencia',
          documento: 'TRF-000234',
          descripcion: 'Pago de impuestos',
          cargo: 'S/1,200.00',
          abono: '',
          saldo: 'S/-3,200.00'
        },
        {
          fecha: '15/11/2025',
          tipoMovimiento: 'Depósito',
          documento: 'DEP-000678',
          descripcion: 'Depósito inicial',
          cargo: '',
          abono: 'S/500.00',
          saldo: 'S/-2,000.00'
        }
      ]
    };

    return movimientosPorCuenta[numeroCuenta] || [];
  }

  obtenerColumnasAsientos(): ColDef[] {
    return [
      { field: 'cuenta', headerName: 'Cuenta', width: 60},
      { field: 'descripcion', headerName: 'Descripción', flex:1},
      { 
        field: 'debe', 
        headerName: 'Debe', 
        width: 80, 
        headerClass: 'derechaencabezado',
        cellStyle: {
          textAlign: 'right',
          display: 'flex',
          justifyContent: 'right',
          fontSize: '11px'
        }
      },
      { 
        field: 'haber', 
        headerName: 'Haber', 
        width: 80, 
        headerClass: 'derechaencabezado',
        cellStyle: {
          textAlign: 'right',
          display: 'flex',
          justifyContent: 'right',
          fontSize: '11px'
        }
      },
      { field: 'centroCosto', headerName: 'Centro de costo', width: 120},
      { field: 'docReferencial', headerName: 'Doc. referencial', width: 120}
    ];
  }

  obtenerColumnasMovimientos(): ColDef[] {
    return [
      { field: 'fecha', headerName: 'Fecha', width: 85},
      { field: 'tipoMovimiento', headerName: 'Tipo Movimiento', width: 120},
      { field: 'documento', headerName: 'Documento', width: 100},
      { field: 'descripcion', headerName: 'Descripción', flex: 1, minWidth: 150},
      { 
        field: 'cargo', 
        headerName: 'Cargo', 
        headerClass:'derechaencabezado', 
        width: 90,  
        cellStyle: {
          textAlign: 'right',
          display: 'flex',
          justifyContent: 'right',
        } 
      },
      { 
        field: 'abono', 
        headerName: 'Abono', 
        headerClass: 'derechaencabezado', 
        width: 90,
        cellStyle: {
          textAlign: 'right',
          display: 'flex',
          justifyContent: 'right',
        }  
      },
      { 
        field: 'saldo', 
        headerName: 'Saldo', 
        headerClass: 'derechaencabezado', 
        width: 90, 
        cellStyle: {
          textAlign: 'right',
          display: 'flex',
          justifyContent: 'right',
        } 
      }
    ];
  }

  onFilterChange() {
    // Activar los botones cuando hay al menos un filtro seleccionado
    this.hasFilter = true;
  }

  onSucursalSelected(sucursal: any) {
    console.log('Sucursal seleccionada:', sucursal);
    this.onFilterChange();
  }

  onEntidadSelected(entidad: any) {
    console.log('Entidad financiera seleccionada:', entidad);
    this.onFilterChange();
  }

  buscar() {
    this.buscando.set(true);
    this.facade.cargarDatos();
    setTimeout(() => {
      this.hasFilter = false;
      this.canExport = true;
      this.buscando.set(false);
    }, 400);
  }

  calcularTotales() {
    this.totalSaldoContable = this.rowData.reduce((sum, item) => sum + (item.ccb_saldo_contable || 0), 0);
    this.totalSaldoDisponible = this.rowData.reduce((sum, item) => sum + (item.ccb_saldo_disponible || 0), 0);
  }

  // Método llamado por VistaCellRenderComponent al hacer clic en el ojo
  abrirModal(value: string, rowData: any) {
    this.abrirModalDetalleCuenta(rowData);
  }
}
