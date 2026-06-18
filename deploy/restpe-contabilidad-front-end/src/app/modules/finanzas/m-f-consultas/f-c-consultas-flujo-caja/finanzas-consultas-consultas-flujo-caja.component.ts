import { Component, OnInit, inject, signal, computed, effect } from '@angular/core';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalController } from '@ionic/angular';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { SingleSelectFilterComponent } from 'src/app/modules/activos/m-af-reporte/pages/af-r-resumenactivofijo/single-select-filter.component';
import { ConsultaFlujoCajaFacade } from 'src/app/modules/finanzas/application/facades/consulta-flujo-caja.facade';
import { ConsultaFlujoCajaFeedbackEffects } from 'src/app/modules/finanzas/effects/consulta-flujo-caja-feedback.effect';
import { ConsultaFlujoCajaEntity } from 'src/app/modules/finanzas/domain/models/consulta-flujo-caja.entity';

// Font Awesome Icons
import { faAngleDown, faArrowsRotate, faChartLineDown, faCircleDollar, faDisplayChartUpCircleDollar, faDownload, faHandHoldingDollar, faRotateRight, faSackDollar } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-finanzas-consultas-consultas-flujo-caja',
  templateUrl: './finanzas-consultas-consultas-flujo-caja.component.html',
  styleUrls: ['./finanzas-consultas-consultas-flujo-caja.component.scss'],
  standalone: false,
})
export class FinanzasConsultasConsultasFlujoCajaComponent implements OnInit {
  // ── Clean Architecture ───────────────────────────────────────────────────
  private readonly flujoCajaFacade = inject(ConsultaFlujoCajaFacade);
  private readonly _effects = inject(ConsultaFlujoCajaFeedbackEffects);

  private readonly isLoading = this.flujoCajaFacade.isLoading;
  readonly buscando = signal(false);
  readonly loaderActivo = computed(() => this.isLoading() || this.buscando());

  // Font Awesome Icons
  fasAngleDown = faAngleDown;
  fasArrowsRotate = faArrowsRotate;
  fasChartLineDown = faChartLineDown;
  fasCircleDollar = faCircleDollar;
  fasDisplayChartUpCircleDollar = faDisplayChartUpCircleDollar;
  fasDownload = faDownload;
  fasHandHoldingDollar = faHandHoldingDollar;
  fasRotateRight = faRotateRight;
  fasSackDollar = faSackDollar;


  private gridApi!: GridApi;

  // Control de estado de filtros
  hasFilter: boolean = false;
  canExport: boolean = false;
  canSearch: boolean = false;
  hasSearched: boolean = false;

   // Rango de fechas
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  // Totales calculados
  totalSaldoActual: number = 0;
  totalIngresosProgramados: number = 0;
  totalEgresosProyectados: number = 0;
  totalFlujoNeto: number = 0;
  totalSaldoProyectado: number = 0;

  // Propiedades individuales para filtros
  filtroEntidadFinanciera: string = '';
  filtroTipoCuenta: string = '';
  filtroMoneda: string = '';
  filtroSucursal: string = '';
  filtroEstado: string = 'activo';

  // Lista de sucursales para el autocomplete
  sucursalList = [
    { id: '1', nombre: 'Centro de producción' },
    { id: '2', nombre: 'Sucursal principal' },
    { id: '3', nombre: 'Sucursal 1' },
    { id: '4', nombre: 'Sucursal 2' },
    { id: '5', nombre: 'Sucursal 3' }
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
    { value: 'caja', label: 'Caja' },
    { value: 'fija', label: 'Fija' },
    { value: 'cajaprincipal', label: 'Caja Principal' }
  ];

  monedasList = [
    { value: 'soles', label: 'Soles' },
    { value: 'dolares', label: 'Dólares' }
  ];

  estadosList = [
    { value: 'activo', label: 'Activo' },
    { value: 'inactivo', label: 'Inactivo' }
  ];

  // Configuración ag-grid
  rowData: ConsultaFlujoCajaEntity[] = [];
  colDefs: ColDef[] = [
    { field: 'cfc_razon_social', headerName: 'Razón social', width: 130, minWidth: 130 },
    { field: 'cfc_entidad_financiera', headerName: 'Entidad financiera', width: 120, minWidth: 110, filter: true },
    { field: 'cfc_tipo_cuenta', headerName: 'Tipo de cuenta', width: 110, minWidth: 110, filter: true },
    { field: 'cfc_moneda', headerName: 'Moneda',filter: SingleSelectFilterComponent, width: 80, minWidth: 80,  },
    {
      field: 'cfc_saldo_actual',
      headerName: 'Saldo actual',
      width: 120,
      minWidth: 110,
      headerClass: 'ag-right-aligned-header',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
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
      cellStyle: (params) => {
        const style: any = { textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'end'};
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      }
    },
    {
      field: 'cfc_ingresos_programados',
      headerName: 'Ingresos programados',
      width: 150,
      minWidth: 150,
      headerClass: 'ag-right-aligned-header',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
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
      cellStyle: (params) => {
        const style: any = {textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'end'};
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      }
    },
    {
      field: 'cfc_egresos_proyectados',
      headerName: 'Egresos programados',
      width: 140,
      minWidth: 130,
      headerClass: 'ag-right-aligned-header',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
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
      cellStyle: (params) => {
        const style: any = {textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'end'};
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      }
    },
    {
      field: 'cfc_flujo_neto',
      headerName: 'Flujo neto',
      width: 120,
      minWidth: 110,  
      headerClass: 'ag-right-aligned-header',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
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
      cellStyle: (params) => {
        const style: any = {textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'end'};
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      }
    },
    {
      field: 'cfc_saldo_proyectado',
      headerName: 'Saldo proyectado',
      headerClass: 'ag-right-aligned-header',
      width: 130,
      minWidth: 110,
      cellRenderer: VistaCellRenderComponent,
      cellRendererParams: {
        useFormattedValue: true
      },
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
            useGrouping: true
          }).format(absValue);
          
          if (params.value < 0) {
            return `(${formattedValue})`;
          }
          return formattedValue;
        }
        return '–';
      },
      cellStyle: (params) => {
        const style: any = {textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'end'};
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { field: 'cfc_fecha_proyeccion', headerName: 'Fecha de proyección', width: 110, minWidth: 120 },
    { field: 'cfc_sucursal', headerName: 'Sucursal', width: 100, minWidth: 100 },
    { field: 'cfc_estado', headerName: 'Estado', width: 80, minWidth: 80,
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
     }
  ];

  columnTypes = {};

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

  constructor(
    private modalController: ModalController
  ) {
    // Configurar fechas mínimas y máximas
    this.minDate = new Date(2020, 0, 1);
    this.maxDate = new Date();

    // Sync store → rowData + totales
    effect(() => {
      const data = this.flujoCajaFacade.registros();
      this.rowData = data;
      this.calcularTotales();
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }
    });
  }

  ngOnInit() {}

  onFilterChange() {
    // Verificar si hay al menos un filtro con valor
    this.hasFilter = !!(this.filtroEntidadFinanciera || 
                        this.filtroTipoCuenta || 
                        this.filtroMoneda || 
                        this.filtroSucursal || 
                         
                        (this.startDate && this.endDate));
    
    // El botón buscar se activa cuando hay al menos un filtro
    this.canSearch = this.hasFilter;
    
    // Si movió un filtro después de haber buscado, reactivar el botón buscar
    if (this.hasSearched && this.hasFilter) {
      this.hasSearched = false;
    }
  }

  buscar() {
    if (!this.canSearch) return;

    this.buscando.set(true);
    this.flujoCajaFacade.cargarDatos();
    setTimeout(() => {
      this.buscando.set(false);
    }, 400);

    this.canExport = true;
    this.hasSearched = true;
    this.canSearch = false;
  }

  private calcularTotales() {
    // Calcular totales basados en los datos de la tabla
    this.totalSaldoActual = this.rowData.reduce((sum, item) => sum + (item.cfc_saldo_actual || 0), 0);
    this.totalIngresosProgramados = this.rowData.reduce((sum, item) => sum + (item.cfc_ingresos_programados || 0), 0);
    this.totalEgresosProyectados = this.rowData.reduce((sum, item) => sum + (item.cfc_egresos_proyectados || 0), 0);
    this.totalFlujoNeto = this.rowData.reduce((sum, item) => sum + (item.cfc_flujo_neto || 0), 0);
    this.totalSaldoProyectado = this.rowData.reduce((sum, item) => sum + (item.cfc_saldo_proyectado || 0), 0);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.gridApi.sizeColumnsToFit();
  }

  onSucursalSelected(sucursal: any) {
    this.filtroSucursal = sucursal?.id || '';
    this.onFilterChange();
  }

  onEntidadFinancieraSelected(entidad: any) {
    this.filtroEntidadFinanciera = entidad?.value || '';
    this.onFilterChange();
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

  filtrarPorFechas(event: any) {
    console.log('Rango de fechas seleccionado:', event);
    this.startDate = event.startDate;
    this.endDate = event.endDate;
    this.onFilterChange();
  }


  onCellClicked(event: any) {
    console.log('Cell clicked:', event);
    // Abrir modal de detalle si es la columna de saldo proyectado
    if (event.colDef.field === 'cfc_saldo_proyectado') {
      this.abrirModalDetalleFlujoCaja(event.data);
    }
  }

  async abrirModal(value: any, rowData: any) {
    // Método llamado por VistaCellRenderComponent
    await this.abrirModalDetalleFlujoCaja(rowData);
  }

  async abrirModalDetalleFlujoCaja(rowData: any) {
    const { ModalDetalleConsultasCajabancoComponent } = await import('../f-c-consultas-caja-banco/modal-detalle-consultas-cajabanco/modal-detalle-consultas-cajabanco.component');
    
    // Obtener los datos específicos para esta cuenta
    const movimientosBancarios = this.obtenerMovimientosBancarios(rowData.numeroCuenta);
    const asientosContables = this.obtenerAsientosContables(rowData.numeroCuenta);
    const colDefsMovimientos = this.obtenerColumnasMovimientos();
    const colDefsAsientos = this.obtenerColumnasAsientos();
    
    const modal = await this.modalController.create({
      component: ModalDetalleConsultasCajabancoComponent,
      cssClass: 'promo',
      componentProps: {
        numeroCuenta: '191-1234567-0-12',
        datosCuenta: {
          razonSocial: 'RESTAURANTE SABOR PERUANO SAC',
          banco: 'Interbank – Cuenta Corriente',
          saldoContable: 'S/ 25,450.78',
          saldoDisponible: 'S/ 18,300.25',
          fechaContable: '12/12/2025',
          glosaContable: 'Pago del servicio de luz en "Luz del Sur".',
          esFlujoProyectado: false
        },
        movimientosBancarios: movimientosBancarios,
        asientosContables: asientosContables,
        colDefsMovimientos: colDefsMovimientos,
        colDefsAsientos: colDefsAsientos
      }
    });

    await modal.present();
  }

  obtenerMovimientosBancarios(numeroCuenta: string) {
    // Datos personalizados de movimientos bancarios
    return [
      {
        fecha: '20/11/2025',
        tipoMovimiento: 'Orden de Giro',
        documento: 'OC-000145',
        descripcion: 'Pago a proveedor "Luz del Sur"',
        cargo: 'S/354.00',
        abono: '-',
        saldo: 'S/18,300.25'
      }
    ];
  }

  obtenerAsientosContables(numeroCuenta: string) {
    // Datos de asientos contables
    return [
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
    ];
  }

  obtenerColumnasMovimientos(): ColDef[] {
    return [
      { field: 'fecha', headerName: 'Fecha', width: 80},
      { field: 'tipoMovimiento', headerName: 'Tipo de movimiento', width: 110},
      { field: 'documento', headerName: 'Documento', width: 90},
      { field: 'descripcion', headerName: 'Descripción', width: 230},
      { 
        field: 'cargo', 
        headerName: 'Cargo', 
        headerClass:'derechaencabezado', 
        width: 70,  
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
        width: 70,
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
        width: 75, 
        cellStyle: {
          textAlign: 'right',
          display: 'flex',
          justifyContent: 'right',
        } 
      }
    ];
  }

  obtenerColumnasAsientos(): ColDef[] {
    return [
      { field: 'cuenta', headerName: 'Cuenta', width: 60},
      { field: 'descripcion', headerName: 'Descripción', flex: 1},
      { 
        field: 'debe', 
        headerName: 'Debe', 
        width: 80, 
        headerClass: 'derechaencabezado',
        cellStyle: {
          textAlign: 'right',
          display: 'flex',
          justifyContent: 'right',
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
        }
      },
      { field: 'centroCosto', headerName: 'Centro de costo', width: 120},
      { field: 'docReferencial', headerName: 'Doc. referencial', width: 120}
    ];
  }

}

