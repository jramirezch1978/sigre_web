import { Component, ElementRef, OnInit, ViewChild, signal } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { IContableRow, PlanContableLoaderService } from './plan-contable-loader.service';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronLeft, faChevronRight, faChevronsLeft, faChevronsRight, faCirclePlus, faCog, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-contabilidad-tabla-plancontable',
  templateUrl: './contabilidad-tabla-plancontable.component.html',
  styleUrls: ['./contabilidad-tabla-plancontable.component.scss'],
  standalone: false,
})
export class ContabilidadTablaPlancontableComponent  implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronLeft = faChevronLeft;
  fasChevronRight = faChevronRight;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasCog = faCog;
  fasRotateRight = faRotateRight;



  @ViewChild('scrollBox', { read: ElementRef }) scrollBox!: ElementRef;

  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  planContableForm: FormGroup;
  private gridApi!: GridApi;
  panelLateralVisible: boolean = true;
  camponuevo: boolean = false;
  tabSeleccionado: string = 'identificacion';
  gridContext!: { componentParent: ContabilidadTablaPlancontableComponent };
  filaSeleccionada: any = null;
  cuentasFiltradas: any[] = [];
  cuentas: any[] = [];
  archivo: any;
  anioActual: number = new Date().getFullYear();

  // Configuración para Tree Data
    treeData = true;
    groupDefaultExpanded = 2; // 0 = todo colapsado, -1 = todo expandido, 2 = expandir hasta nivel 2
    getDataPath = (data: IContableRow) => data.orgHierarchy;
  
    autoGroupColumnDef: ColDef = {
      headerName: 'Código | Descripción de cuenta',
      flex: 1,
      cellRendererParams: {
        suppressCount: true,
      },
    };
  
    // Función para aplicar clases CSS a las filas
    getRowClass = (params: any) => {
      if (params.data && params.data.isNivel1) {
        return 'row-main-category';
      }
      return '';
    };



  tabs = [
    { value: 'identificacion', label: 'Identificación Cuenta' },
    { value: 'clasificacion', label: 'Clasificación' },
    { value: 'param', label: 'Parametrización operativa' },
    { value: 'normativa', label: 'Normativa/Plantilla' }
  ];

  monedas=[
    'Soles',
    'Dólares',
  ]

  // Arreglos para los selects
  nivelesSelect = [
    '01',
    '02',
    '03',
    '04',
    '05',
  ];

  naturalezaSelect = [
    'Deudora',
    'Acreedora',
  ];

  tipoCtaSelect = [
    'Balance',
    'Resultados',
    'Orden',
    'Control',
  ];

  siNoSelect = [
    'Si',
    'No',
  ];

  terceroSelect = [
    'Ninguno',
    'Cliente',
    'Proveedor',
    'Empleado',
    'Otro',
  ];

  centroCostoSelect = [
    'Si',
    'No',
    'Según nivel',
  ];

  asocImpSelect = [
    'Selección de Impuesto',
    'Retención aplicable'
  ];

  activoFijoSelect = [
    'Si',
    'No',
    'Alta',
    'Depreciación',
    'Baja',
  ];

  monedaPermitidaSelect = [
    'Moneda funcional',
    'Multimoneda',
  ];

  etiquetasSelect = [
    'Libre',
    'Para segmentación'
  ];

  plantillaSelect = [
    'PCGE',
    'NIIF',
    'PUC',
    'Personalizada',
  ];

  mapaSelect = [
    'Contable',
    'Tributaria'
  ];

  estadoSelect = [
    'Activo',
    'Inactivo'
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
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  isLoading = signal(false);

  // rowData: IContableRow[] = [
  rowData: IContableRow[] = [];


  colDefs: ColDef<IContableRow>[] = [
    { field: 'naturaleza', headerName: 'Naturaleza', filter: true, width: 90 },
    { field: 'tipo', headerName: 'Tipo', filter: true, width: 80 },
    { field: 'movimiento', headerName: 'Movimiento', width: 80 },
    { field: 'moneda', headerName: 'Moneda', width: 80 },
    { field: 'vigencia', headerName: 'Vigente desde', width: 100,
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
    { field: "estado", headerName: "Estado", headerClass: 'ag-header-hover ag-header-10px centrarencabezado', filter: true, width: 90,
      cellRenderer: (params: any) => {
        const estado = params.value;
        const estadoClass = estado === 'Activo' ? 'text-green-600 bg-green-100' : 'text-red-600 bg-red-100';
        return `<span class="px-2 py-[1px] rounded-full text-xxss font-medium ${estadoClass}">${estado}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
  ];

  columnTypes = {};


  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController,
    private formValidationService: FormValidationService,
    private simulation: SimulationService,
    private planContableLoader: PlanContableLoaderService,
  ) {
    this.planContableForm = this.formBuilder.group({
      // Identificación cuenta
      monedaF: ['Soles'],
      codigo: ['', Validators.required],
      nombreD:  ['', Validators.required],
      nivel: ['01', Validators.required],
      cuentaPadre: [''],   
      // Clasificación
      naturaleza: ['', Validators.required],
      tipoC: ['', Validators.required],
      permiteM: ['', Validators.required],
      estado: ['', Validators.required],
      // Parametrización operativa
      rTercero: ['', Validators.required],
      reqDoc: ['', Validators.required],
      reqCentro: ['', Validators.required],
      reqSucursal: ['', Validators.required],
      asocImp: [''],
      afectaC: ['', Validators.required],
      asociacion: ['', Validators.required],
      monedap: ['', Validators.required],
      etiqueta: ['', Validators.required],
      // Normativa/Plantilla
      plantillaV: ['', Validators.required],
      mapaN: [''],
      vigenciaD: ['', Validators.required],
      vigenciaH: ['']
    });

    this.gridContext = { componentParent: this };

    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  async ngOnInit() {
    // Cargar datos desde localStorage o usar datos de ejemplo
    await this.cargarPlanContableDesdeSimulacion();

     // Para que actualice en vivo si otra parte del sistema cambia el storage
    this.simulation.storageChanges().subscribe(data => {
      this.rowData = data['plancontable'] || [];
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });

    this.inicializarCuentas();
    // Escuchar cambios en el nivel para filtrar cuentas padre
    this.planContableForm.get('nivel')?.valueChanges.subscribe(() => {
      this.filtrarCuentasPorNivel();
    });
    // aplicar estado inicial del control cuentaPadre según nivel (si no existe o es 01, deshabilitado)
    this.filtrarCuentasPorNivel();
    
    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.planContableForm);
  }

  /**
   * Cargar plan contable desde localStorage o usar datos de ejemplo
   */
  async cargarPlanContableDesdeSimulacion() {
    this.isLoading.set(true);
    // Delay para que Angular renderice el loader antes de cargar datos
    await new Promise(resolve => setTimeout(resolve, 600));
    console.log('  Cargando plan contable desde localStorage...');
    
    const datosGuardados = this.simulation.list('plancontable') || [];
    
    if (datosGuardados.length > 0) {
      this.rowData = datosGuardados;
      this.isLoading.set(false);
      console.log(' Datos cargados desde localStorage:', this.rowData.length, 'cuentas');
    } else {
      console.log('  No hay datos en localStorage, cargando desde Excel...');
      try {
        // Cargar desde el Excel en assets
        this.rowData = await this.planContableLoader.cargarDesdeExcel();
        // Guardar en localStorage para la próxima vez
        this.guardarPlanContableCompleto();
        console.log(' Plan contable cargado desde Excel:', this.rowData.length, 'cuentas');
        this.isLoading.set(false);
        this.toastService.success(`Plan contable cargado: ${this.rowData.length} cuentas`);
      } catch (error) {
        console.error('  Error al cargar Excel:', error);
        this.isLoading.set(false);
        this.toastService.danger('Error al cargar el plan contable desde Excel. Revise el archivo.');
        this.rowData = [];
      }
    }
  }

  /**
   * Guardar todo el plan contable en el SimulationService
   * Esta función reemplaza todo el array de cuentas en localStorage
   */
  guardarPlanContableCompleto() {
    console.log('  Guardando plan contable completo...');
    // Reemplazar todo el array de una sola vez
    this.simulation.replace('plancontable', this.rowData);
    console.log(' Plan contable guardado correctamente:', this.rowData.length, 'cuentas');
  }

  /**
   * Cargar cuentas contables desde SimulationService
   * Esta función puede ser llamada desde cualquier otro componente
   * @returns Array de cuentas contables
   */
  static cargarCuentasContables(simulationService: SimulationService): IContableRow[] {
    return simulationService.list('plancontable') || [];
  }

  /**
   * Obtener datos de ejemplo base del plan contable
   */
  getDatosEjemploBase(): IContableRow[] {
    const fechaActual = this.formatearFecha(new Date());
    return [
      // 1 - ACTIVO
      { orgHierarchy: ['1 - ACTIVO'], codigo: '1', descripcion: 'ACTIVO', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['1 - ACTIVO', '10 - EFECTIVO Y EQUIVALENTES DE EFECTIVO'], codigo: '10', descripcion: 'EFECTIVO Y EQUIVALENTES DE EFECTIVO', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '1' },
      { orgHierarchy: ['1 - ACTIVO', '10 - EFECTIVO Y EQUIVALENTES DE EFECTIVO', '101 - CAJA'], codigo: '101', descripcion: 'CAJA', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '10' },
      { orgHierarchy: ['1 - ACTIVO', '10 - EFECTIVO Y EQUIVALENTES DE EFECTIVO', '104 - CUENTAS CORRIENTES EN INSTITUCIONES FINANCIERAS'], codigo: '104', descripcion: 'CUENTAS CORRIENTES EN INSTITUCIONES FINANCIERAS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '10' },
      { orgHierarchy: ['1 - ACTIVO', '12 - CUENTAS POR COBRAR COMERCIALES – TERCEROS'], codigo: '12', descripcion: 'CUENTAS POR COBRAR COMERCIALES – TERCEROS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '1' },
      { orgHierarchy: ['1 - ACTIVO', '12 - CUENTAS POR COBRAR COMERCIALES – TERCEROS', '121 - FACTURAS, BOLETAS Y OTROS COMPROBANTES POR COBRAR'], codigo: '121', descripcion: 'FACTURAS, BOLETAS Y OTROS COMPROBANTES POR COBRAR', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '12' },
      { orgHierarchy: ['1 - ACTIVO', '14 - CUENTAS POR COBRAR AL PERSONAL'], codigo: '14', descripcion: 'CUENTAS POR COBRAR AL PERSONAL, ACCIONISTAS, DIRECTORES Y GERENTES', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '1' },
      { orgHierarchy: ['1 - ACTIVO', '16 - CUENTAS POR COBRAR DIVERSAS – TERCEROS'], codigo: '16', descripcion: 'CUENTAS POR COBRAR DIVERSAS – TERCEROS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '1' },
      { orgHierarchy: ['1 - ACTIVO', '18 - SERVICIOS Y OTROS CONTRATADOS POR ANTICIPADO'], codigo: '18', descripcion: 'SERVICIOS Y OTROS CONTRATADOS POR ANTICIPADO', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '1' },
      
      // 2 - ACTIVO REALIZABLE
      { orgHierarchy: ['2 - ACTIVO REALIZABLE'], codigo: '2', descripcion: 'ACTIVO REALIZABLE', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['2 - ACTIVO REALIZABLE', '20 - MERCADERÍAS'], codigo: '20', descripcion: 'MERCADERÍAS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '2' },
      { orgHierarchy: ['2 - ACTIVO REALIZABLE', '21 - PRODUCTOS TERMINADOS'], codigo: '21', descripcion: 'PRODUCTOS TERMINADOS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '2' },
      { orgHierarchy: ['2 - ACTIVO REALIZABLE', '24 - MATERIAS PRIMAS'], codigo: '24', descripcion: 'MATERIAS PRIMAS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '2' },
      { orgHierarchy: ['2 - ACTIVO REALIZABLE', '25 - MATERIALES AUXILIARES, SUMINISTROS Y REPUESTOS'], codigo: '25', descripcion: 'MATERIALES AUXILIARES, SUMINISTROS Y REPUESTOS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '2' },
      
      // 3 - ACTIVO INMOVILIZADO
      { orgHierarchy: ['3 - ACTIVO INMOVILIZADO'], codigo: '3', descripcion: 'ACTIVO INMOVILIZADO', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['3 - ACTIVO INMOVILIZADO', '33 - INMUEBLES, MAQUINARIA Y EQUIPO'], codigo: '33', descripcion: 'INMUEBLES, MAQUINARIA Y EQUIPO', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '3' },
      { orgHierarchy: ['3 - ACTIVO INMOVILIZADO', '33 - INMUEBLES, MAQUINARIA Y EQUIPO', '331 - TERRENOS'], codigo: '331', descripcion: 'TERRENOS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '33' },
      { orgHierarchy: ['3 - ACTIVO INMOVILIZADO', '33 - INMUEBLES, MAQUINARIA Y EQUIPO', '332 - EDIFICACIONES'], codigo: '332', descripcion: 'EDIFICACIONES', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '33' },
      { orgHierarchy: ['3 - ACTIVO INMOVILIZADO', '33 - INMUEBLES, MAQUINARIA Y EQUIPO', '335 - MUEBLES Y ENSERES'], codigo: '335', descripcion: 'MUEBLES Y ENSERES', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '33' },
      { orgHierarchy: ['3 - ACTIVO INMOVILIZADO', '33 - INMUEBLES, MAQUINARIA Y EQUIPO', '336 - EQUIPOS DIVERSOS'], codigo: '336', descripcion: 'EQUIPOS DIVERSOS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '33' },
      { orgHierarchy: ['3 - ACTIVO INMOVILIZADO', '39 - DEPRECIACIÓN, AMORTIZACIÓN Y AGOTAMIENTO ACUMULADOS'], codigo: '39', descripcion: 'DEPRECIACIÓN, AMORTIZACIÓN Y AGOTAMIENTO ACUMULADOS', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '3' },
      
      // 4 - PASIVO
      { orgHierarchy: ['4 - PASIVO'], codigo: '4', descripcion: 'PASIVO', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['4 - PASIVO', '40 - TRIBUTOS, CONTRAPRESTACIONES Y APORTES AL SISTEMA'], codigo: '40', descripcion: 'TRIBUTOS, CONTRAPRESTACIONES Y APORTES AL SISTEMA DE PENSIONES Y DE SALUD POR PAGAR', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '4' },
      { orgHierarchy: ['4 - PASIVO', '40 - TRIBUTOS, CONTRAPRESTACIONES Y APORTES AL SISTEMA', '401 - GOBIERNO CENTRAL'], codigo: '401', descripcion: 'GOBIERNO CENTRAL', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '40' },
      { orgHierarchy: ['4 - PASIVO', '40 - TRIBUTOS, CONTRAPRESTACIONES Y APORTES AL SISTEMA', '401 - GOBIERNO CENTRAL', '4011 - IGV'], codigo: '4011', descripcion: 'IGV', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '04', ctaPadre: '401' },
      { orgHierarchy: ['4 - PASIVO', '40 - TRIBUTOS, CONTRAPRESTACIONES Y APORTES AL SISTEMA', '401 - GOBIERNO CENTRAL', '4017 - IMPUESTO A LA RENTA'], codigo: '4017', descripcion: 'IMPUESTO A LA RENTA', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '04', ctaPadre: '401' },
      { orgHierarchy: ['4 - PASIVO', '41 - REMUNERACIONES Y PARTICIPACIONES POR PAGAR'], codigo: '41', descripcion: 'REMUNERACIONES Y PARTICIPACIONES POR PAGAR', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '4' },
      { orgHierarchy: ['4 - PASIVO', '42 - CUENTAS POR PAGAR COMERCIALES – TERCEROS'], codigo: '42', descripcion: 'CUENTAS POR PAGAR COMERCIALES – TERCEROS', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '4' },
      { orgHierarchy: ['4 - PASIVO', '42 - CUENTAS POR PAGAR COMERCIALES – TERCEROS', '421 - FACTURAS, BOLETAS Y OTROS COMPROBANTES POR PAGAR'], codigo: '421', descripcion: 'FACTURAS, BOLETAS Y OTROS COMPROBANTES POR PAGAR', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '42' },
      { orgHierarchy: ['4 - PASIVO', '45 - OBLIGACIONES FINANCIERAS'], codigo: '45', descripcion: 'OBLIGACIONES FINANCIERAS', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '4' },
      { orgHierarchy: ['4 - PASIVO', '46 - CUENTAS POR PAGAR DIVERSAS – TERCEROS'], codigo: '46', descripcion: 'CUENTAS POR PAGAR DIVERSAS – TERCEROS', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '4' },
      
      // 5 - PATRIMONIO NETO
      { orgHierarchy: ['5 - PATRIMONIO NETO'], codigo: '5', descripcion: 'PATRIMONIO NETO', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['5 - PATRIMONIO NETO', '50 - CAPITAL'], codigo: '50', descripcion: 'CAPITAL', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '5' },
      { orgHierarchy: ['5 - PATRIMONIO NETO', '50 - CAPITAL', '501 - CAPITAL SOCIAL'], codigo: '501', descripcion: 'CAPITAL SOCIAL', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '50' },
      { orgHierarchy: ['5 - PATRIMONIO NETO', '58 - RESERVAS'], codigo: '58', descripcion: 'RESERVAS', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '5' },
      { orgHierarchy: ['5 - PATRIMONIO NETO', '59 - RESULTADOS ACUMULADOS'], codigo: '59', descripcion: 'RESULTADOS ACUMULADOS', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '5' },
      
      // 6 - GASTOS POR NATURALEZA
      { orgHierarchy: ['6 - GASTOS POR NATURALEZA'], codigo: '6', descripcion: 'GASTOS POR NATURALEZA', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['6 - GASTOS POR NATURALEZA', '60 - COMPRAS'], codigo: '60', descripcion: 'COMPRAS', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '6' },
      { orgHierarchy: ['6 - GASTOS POR NATURALEZA', '62 - GASTOS DE PERSONAL, DIRECTORES Y GERENTES'], codigo: '62', descripcion: 'GASTOS DE PERSONAL, DIRECTORES Y GERENTES', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '6' },
      { orgHierarchy: ['6 - GASTOS POR NATURALEZA', '63 - GASTOS DE SERVICIOS PRESTADOS POR TERCEROS'], codigo: '63', descripcion: 'GASTOS DE SERVICIOS PRESTADOS POR TERCEROS', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '6' },
      { orgHierarchy: ['6 - GASTOS POR NATURALEZA', '65 - OTROS GASTOS DE GESTIÓN'], codigo: '65', descripcion: 'OTROS GASTOS DE GESTIÓN', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '6' },
      { orgHierarchy: ['6 - GASTOS POR NATURALEZA', '68 - VALUACIÓN Y DETERIORO DE ACTIVOS Y PROVISIONES'], codigo: '68', descripcion: 'VALUACIÓN Y DETERIORO DE ACTIVOS Y PROVISIONES', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '6' },
      { orgHierarchy: ['6 - GASTOS POR NATURALEZA', '69 - COSTO DE VENTAS'], codigo: '69', descripcion: 'COSTO DE VENTAS', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '6' },
      
      // 7 - INGRESOS
      { orgHierarchy: ['7 - INGRESOS'], codigo: '7', descripcion: 'INGRESOS', naturaleza: 'Acreedora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['7 - INGRESOS', '70 - VENTAS'], codigo: '70', descripcion: 'VENTAS', naturaleza: 'Acreedora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '7' },
      { orgHierarchy: ['7 - INGRESOS', '70 - VENTAS', '701 - MERCADERÍAS'], codigo: '701', descripcion: 'MERCADERÍAS', naturaleza: 'Acreedora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '70' },
      { orgHierarchy: ['7 - INGRESOS', '70 - VENTAS', '702 - PRODUCTOS TERMINADOS'], codigo: '702', descripcion: 'PRODUCTOS TERMINADOS', naturaleza: 'Acreedora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '70' },
      { orgHierarchy: ['7 - INGRESOS', '73 - DESCUENTOS, REBAJAS Y BONIFICACIONES OBTENIDOS'], codigo: '73', descripcion: 'DESCUENTOS, REBAJAS Y BONIFICACIONES OBTENIDOS', naturaleza: 'Acreedora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '7' },
      { orgHierarchy: ['7 - INGRESOS', '75 - OTROS INGRESOS DE GESTIÓN'], codigo: '75', descripcion: 'OTROS INGRESOS DE GESTIÓN', naturaleza: 'Acreedora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '7' },
      { orgHierarchy: ['7 - INGRESOS', '77 - INGRESOS FINANCIEROS'], codigo: '77', descripcion: 'INGRESOS FINANCIEROS', naturaleza: 'Acreedora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '7' },
      
      // 8 - SALDOS INTERMEDIARIOS DE GESTIÓN
      { orgHierarchy: ['8 - SALDOS INTERMEDIARIOS DE GESTIÓN'], codigo: '8', descripcion: 'SALDOS INTERMEDIARIOS DE GESTIÓN', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['8 - SALDOS INTERMEDIARIOS DE GESTIÓN', '80 - MARGEN COMERCIAL'], codigo: '80', descripcion: 'MARGEN COMERCIAL', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '8' },
      { orgHierarchy: ['8 - SALDOS INTERMEDIARIOS DE GESTIÓN', '81 - PRODUCCIÓN DEL EJERCICIO'], codigo: '81', descripcion: 'PRODUCCIÓN DEL EJERCICIO', naturaleza: 'Acreedora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '8' },
      { orgHierarchy: ['8 - SALDOS INTERMEDIARIOS DE GESTIÓN', '89 - DETERMINACIÓN DEL RESULTADO DEL EJERCICIO'], codigo: '89', descripcion: 'DETERMINACIÓN DEL RESULTADO DEL EJERCICIO', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '8' },
      
      // 9 - CONTABILIDAD ANALÍTICA DE EXPLOTACIÓN (CUENTAS DE ORDEN)
      { orgHierarchy: ['9 - CONTABILIDAD ANALÍTICA DE EXPLOTACIÓN'], codigo: '9', descripcion: 'CONTABILIDAD ANALÍTICA DE EXPLOTACIÓN', naturaleza: 'Deudora', tipo: 'Orden', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['9 - CONTABILIDAD ANALÍTICA DE EXPLOTACIÓN', '90 - CUENTAS DE ORDEN'], codigo: '90', descripcion: 'CUENTAS DE ORDEN', naturaleza: 'Deudora', tipo: 'Orden', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '9' },
      { orgHierarchy: ['0 - CUENTAS DE ORDEN'], codigo: '0', descripcion: 'CUENTAS DE ORDEN', naturaleza: 'Deudora', tipo: 'Orden', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
    ];
  }
  onBtReset() {
    this.isLoading.set(true);
    setTimeout(() => {
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }
      this.isLoading.set(false);
    }, 600);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.gridApi.setGridOption('rowData', this.rowData);

    // Restaurar la selección visual cuando el grid se recrea (toggle del panel)
    if (this.filaSeleccionada) {
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
            if (node.data && node.data.codigo === this.filaSeleccionada?.codigo) {
              node.setSelected(true);
              this.gridApi.ensureNodeVisible(node, 'middle');
            }
          });
        }
      }, 150);
    }
  }

  togglePanelLateral(){
    this.panelLateralVisible = !this.panelLateralVisible;
  }
  
  // FUNCIONES DEL SCROLL

  scrollLeft() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: -150, behavior: 'smooth' });
  }

  scrollRight() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: 150, behavior: 'smooth' });
  }

  formatearFecha(fecha: Date): string {
    const dia = fecha.getDate().toString().padStart(2, '0');
    const mes = (fecha.getMonth() + 1).toString().padStart(2, '0');
    const anio = fecha.getFullYear();
    return `${anio}-${mes}-${dia}`;
  }

  parsearFecha(fechaStr: string | undefined): Date | null {
    if (!fechaStr) return null;
    const partes = fechaStr.split('-');
    return new Date(
      parseInt(partes[0]),
      parseInt(partes[1]) - 1,
      parseInt(partes[2]),
    );
  }

  /**
   * Inicializa el arreglo de cuentas con los códigos de rowData
   */
  inicializarCuentas() {
    this.cuentas = this.rowData.map(item => ({
      id: item.codigo,
      nombre: `${item.codigo} - ${item.descripcion}`,
      codigo: item.codigo,
      nivel: item.nivel,
      ctaPadre: item.ctaPadre
    }));
  }

  /**
   * Filtra las cuentas padre según el nivel seleccionado en el formulario
   * Nivel 1: se oculta el autocomplete
   * Nivel 2: caracteres con estructura "2" 
   * Nivel 3: caracteres con estructura "12"
   */
  filtrarCuentasPorNivel() {
    const nivelSeleccionado = this.planContableForm.get('nivel')?.value;

    // Si no hay nivel seleccionado o es nivel 01 -> no mostrar autocomplete
    const nivelNum = Number(nivelSeleccionado);
    if (!nivelSeleccionado || isNaN(nivelNum) || nivelNum <= 1) {
      this.cuentasFiltradas = [];
      // limpiar y deshabilitar control de cuentaPadre para evitar validación
      const ctrl = this.planContableForm.get('cuentaPadre');
      if (ctrl) {
        ctrl.reset();
        ctrl.disable({ emitEvent: false });
      }
      return;
    }

    // habilitar control si es necesario
    const ctrl = this.planContableForm.get('cuentaPadre');
    if (ctrl && ctrl.disabled) {
      ctrl.enable({ emitEvent: false });
    }

    // Para nivel N mostramos como posibles padres las cuentas cuyo código
    // tenga longitud igual a (N - 1). Ej: si N=2, padres con código de 1 carácter.
    const parentCodeLength = nivelNum - 1;

    this.cuentasFiltradas = this.cuentas.filter(cuenta => {
      const codigo = (cuenta.codigo ?? cuenta.id ?? '').toString();
      return codigo.length === parentCodeLength;
    });
  }
  
  onFirstDataRendered(params: any) {
    const firstNode = params.api.getDisplayedRowAtIndex(0);
    if (firstNode) {
      firstNode.setSelected(true);
      this.filaSeleccionada = firstNode.data;
      this.llenarFormulario(firstNode.data);
    }
  }

  async onCellClicked(event: any) {
    const data = event.data;
    
    // Prevenir selección automática
    event.node.setSelected(false);
    
    // Guardar referencia del elemento que tiene el foco actualmente
    const elementoConFoco = document.activeElement as HTMLElement;
    
    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Mantener selección anterior
      if (this.filaSeleccionada) {
        setTimeout(() => {
          if (this.gridApi) {
            this.gridApi.deselectAll();
            this.gridApi.forEachNode((node) => {
              if (node.data.codigo === this.filaSeleccionada.codigo) {
                node.setSelected(true);
              }
            });
          }
          
          // Restaurar el foco al campo que estaba activo
          if (elementoConFoco && elementoConFoco.tagName === 'INPUT') {
            setTimeout(() => {
              elementoConFoco.focus();
            }, 100);
          }
        }, 0);
      } else {
        if (this.gridApi) {
          this.gridApi.deselectAll();
        }
      }
      return;
    }
    
    // Cargar datos de la relación seleccionada
    this.cargarDatosRelacion(data);
  }

  private cargarDatosRelacion(data: any) {
    this.filaSeleccionada = data;
    
    if (!this.gridApi) return;
    
    this.gridApi.deselectAll();
    
    // Seleccionar el nodo en AG-Grid
    this.gridApi.forEachNode((node) => {
      if (node.data === data) {
        node.setSelected(true);
      }
    });

    this.llenarFormulario(data);
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  private llenarFormulario(data: any) {
    if (!data) return;
    this.planContableForm.patchValue({
      monedaF: data.moneda,
      codigo: data.codigo,
      nombreD: data.descripcion,
      nivel: data.nivel,
      cuentaPadre: data.ctaPadre,
      naturaleza: data.naturaleza,
      tipoC: data.tipo,
      permiteM: data.movimiento,
      estado: data.estado,
      rTercero: data.rTercero,
      reqDoc: data.reqDoc,
      reqCentro: data.reqCentro,
      reqSucursal: data.reqSucursal,
      asocImp: data.asocImp,
      afectaC: data.afectaC,
      asociacion: data.asociacion,
      monedap: data.monedap,
      etiqueta: data.etiqueta,
      plantillaV: data.plantillaV,
      mapaN: data.mapaN,
      vigenciaD: data.vigencia ? this.parsearFecha(data.vigencia) : null,
      vigenciaH: data.vigenciaH ? this.parsearFecha(data.vigenciaH) : null,
    });

    this.planContableForm.get('codigo')?.disable();

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  async botonNuevaCuenta() {
    // Validar cambios antes de limpiar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Cancelar acción
    }
    
    this.camponuevo = true;
    this.filaSeleccionada = null;

    // Reiniciar el formulario a los valores por defecto
    if (this.planContableForm) {
      this.planContableForm.reset();
      // usar id esperado por los selects 
      this.planContableForm.patchValue({ 
        estado: 'Activo',
        nivel: '01',
        monedaF: 'Soles'
      });
    }
    this.planContableForm.get('codigo')?.enable();

    // Deseleccionar filas de la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
    this.tabSeleccionado = 'identificacion';
  }

  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  private construirOrgHierarchy(codigo: string, descripcion: string, padre: IContableRow | null): string[] {
    if (!padre) return [`${codigo} - ${descripcion}`];
    return [...padre.orgHierarchy, `${codigo} - ${descripcion}`];
  }

  botonSiguiente(){
    if(this.tabSeleccionado === 'identificacion'){
      this.tabSeleccionado= 'clasificacion'
    } else if(this.tabSeleccionado === 'clasificacion'){
      this.tabSeleccionado= 'param'
    } else if(this.tabSeleccionado === 'param'){
      this.tabSeleccionado= 'normativa'
    }
  }
  botonAnterior(){
    if(this.tabSeleccionado === 'normativa'){
      this.tabSeleccionado= 'param'
    } else if(this.tabSeleccionado === 'param'){
      this.tabSeleccionado= 'clasificacion'
    } else if(this.tabSeleccionado === 'clasificacion'){
      this.tabSeleccionado= 'identificacion'
    }
  }

  async botonCancelar() {
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return;
    }
    
    this.filaSeleccionada = null;
    this.camponuevo = false;
    this.tabSeleccionado = 'identificacion';

    if (this.planContableForm) {
      this.planContableForm.reset();
      this.planContableForm.patchValue({ 
        estado: 'Activo',
        nivel: '01',
        monedaF: 'Soles',
        vigenciaD: new Date(),
      });
      this.planContableForm.get('codigo')?.enable();
    }

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    this.formValidationService.resetearEstado();
  }

  botonGuardar() {
    if (this.planContableForm.invalid) {
    this.toastService.warning('Por favor, completa todos los campos requeridos');
    return;
  }
  
  // Obtener valores incluyendo campos deshabilitados
  const f = this.planContableForm.getRawValue();
  const nivelNum = Number(f.nivel);
  
  // En modo edición, usar el código de la fila seleccionada
  const codigoFinal = this.filaSeleccionada ? this.filaSeleccionada.codigo : f.codigo;
  
  let padre: IContableRow | null = null;
  if (nivelNum > 1 && f.cuentaPadre) {
    padre = this.rowData.find(x => x.codigo === f.cuentaPadre) || null;
  }
    const orgHierarchy = this.construirOrgHierarchy(codigoFinal, f.nombreD, padre);


    const registro: IContableRow = {
    orgHierarchy,
    codigo: codigoFinal,
    descripcion: f.nombreD,
    naturaleza: f.naturaleza,
    tipo: f.tipoC,
    movimiento: f.permiteM,
    nivel: f.nivel,
    ctaPadre: padre?.codigo ?? '',
    moneda: f.monedaF,
    vigencia: f.vigenciaD,
    estado: f.estado,
    isNivel1: nivelNum === 1,
    rTercero: f.rTercero,
    reqDoc: f.reqDoc,
    reqCentro: f.reqCentro,
    reqSucursal: f.reqSucursal,
    asocImp: f.asocImp,
    afectaC: f.afectaC,
    asociacion: f.asociacion,
    monedap: f.monedap,
    etiqueta: f.etiqueta,
    plantillaV: f.plantillaV,
    mapaN: f.mapaN,
    vigenciaH: f.vigenciaH,
    };


    let lista = this.simulation.list('plancontable');


    // CREAR
    if (!this.filaSeleccionada) {
    this.simulation.save('plancontable', registro);
    this.toastService.success('¡Cuenta registrada exitosamente!');
    }


    // EDITAR
    else {
    const index = lista.findIndex((x: IContableRow) => x.codigo === this.filaSeleccionada?.codigo);
    if (index === -1) {
    this.toastService.danger('Error al editar registro');
    return;
    }


    lista[index] = registro;
    this.simulation.replace('plancontable', lista);
    this.toastService.success('¡Cuenta actualizada exitosamente!');
    }

    // Reset
    this.filaSeleccionada = null;
    this.planContableForm.reset({
      estado: 'Activo',
      vigenciaD: new Date(),
    });
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();

    this.tabSeleccionado = 'identificacion';
    // Refrescar la vista manualmente
    this.refrescarVista();
  }

  refrescarVista() {
    // Usar setTimeout para evitar errores de AG-Grid durante el renderizado
    setTimeout(() => {
      this.rowData = [...this.simulation.list('plancontable')];
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    }, 0);
  }

  botonDuplicarCuenta() {
    if (this.planContableForm.valid) {
      console.log('Guardar activo', this.planContableForm.value);
    }
  }

  onCuentaSeleccionada(cuenta: any) {
    console.log('Cuenta seleccionado:', cuenta);
  }

  async modalImportar(){
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar cuentas',
        descripcionSubir: 'Comparte tu archivo de excel con la información de tus cuentas y regístralos automáticamente en la plataforma.',
        buttonName: 'Importar cuentas',
      }
    });
    await modal.present();

    try {
      const result = await modal.onWillDismiss();
      const data = result?.data;
      if (data && data.archivo) {
        // Guardar archivo en el componente padre
        this.archivo = data.archivo;
        // Mostrar toast indicando que el archivo fue subido
        try {
          const nombre = data.archivo?.name ?? 'archivo';
          this.toastService.success('¡Archivo subido!', nombre, 3000);
        } catch (e) {
          console.warn('ToastService falló', e);
        }
        // Llamar al método importar para procesar el archivo
        try { this.importar(data); } catch (e) { 
          this.toastService.danger('¡Importación fallida!');
         }
      }
    } catch (e) {
      console.warn('Error al obtener resultado del modal', e);
      this.toastService.danger('¡Error al obtener resultado del modal!');
    }
  }

  /**
   * Recargar plan contable desde el Excel en assets
   * Útil para actualizar los datos cuando se modifica el Excel
   */
  async recargarDesdeExcel() {
    try {
      this.toastService.warning('Recargando plan contable desde Excel...');
      
      // Cargar desde Excel
      this.rowData = await this.planContableLoader.cargarDesdeExcel();
      
      // Guardar en localStorage
      this.guardarPlanContableCompleto();
      
      // Actualizar grid
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
      
      // Reinicializar cuentas para el autocomplete
      this.inicializarCuentas();
      
      this.toastService.success(`Plan contable actualizado: ${this.rowData.length} cuentas`);
      console.log(' Plan contable recargado desde Excel:', this.rowData.length, 'cuentas');
      
    } catch (error) {
      console.error('  Error al recargar Excel:', error);
      this.toastService.danger('Error al recargar el plan contable desde Excel');
    }
  }

  /**
   * Limpiar localStorage y recargar desde Excel
   * Solo usar para desarrollo o cuando se quiera resetear todos los datos
   */
  async limpiarYRecargarDesdeExcel() {
    try {
      // Limpiar localStorage usando replace con array vacío
      this.simulation.replace('plancontable', []);
      console.log('🗑️ localStorage limpiado');
      
      // Recargar desde Excel
      await this.recargarDesdeExcel();
      
    } catch (error) {
      console.error('  Error al limpiar y recargar:', error);
      this.toastService.danger('Error al limpiar y recargar datos');
    }
  }

  importar(data:any){
    // Placeholder: aquí se procesaría el archivo (validaciones, parseo, subida, etc.)
    console.log('Importar llamado con:', data);
    // Por ahora solo guardamos el archivo en el estado (ya lo hacemos en modalImportar),
    // y se puede mostrar un toast adicional si se desea.
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos
    this.cargarDatos(range.start, range.end);
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }


  // Para modo SINGLE - Manejo de fechas seleccionadas
  onFechaVigenciaSelected(date: Date) {
    console.log('Fecha vigencia', date);
    this.planContableForm.patchValue({ vigenciaD: this.formatearFecha(date) });


  }

  onFechaVigenciaHastaSelected(date: Date) {
    console.log('Fecha vigencia hasta', date);
    this.planContableForm.patchValue({ vigenciaH: this.formatearFecha(date) });

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
      { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Se ha creado el grupo 1.00'},
      { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se edito la descripción del grupo'},
      { fechaHora: '13/11/2025 09:00', usuario: 'Carlos Rodríguez', accion: 'Actualización', detalleCambio: 'Se cambió el tipo de flujo'},
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones del plan contable ${this.filaSeleccionada?.codigo || ''}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
       
      }
    });
    
    await modal.present();
  }

}

