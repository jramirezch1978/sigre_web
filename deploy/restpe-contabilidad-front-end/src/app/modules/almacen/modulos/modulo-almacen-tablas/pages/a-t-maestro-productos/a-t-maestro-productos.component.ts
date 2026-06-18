import {Component, ElementRef, OnInit, ViewChild, inject, effect} from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { HttpClient } from '@angular/common/http';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { PdfExportService } from 'src/app/core/infrastructure/export/pdf-export.service';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
import { MaestroProductoEntity } from '../../../../domain/models/maestro-producto.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronLeft, faChevronRight, faCirclePlus, faCog, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-a-t-maestro-productos',
  templateUrl: './a-t-maestro-productos.component.html',
  styleUrls: ['./a-t-maestro-productos.component.scss'],
  standalone: false,
})
export class ATMaestroProductosComponent implements OnInit {
  // Facades
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);
  private readonly pdfExport = inject(PdfExportService);

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.loadingMaestroProductos;


  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronLeft = faChevronLeft;
  fasChevronRight = faChevronRight;
  fasCirclePlus = faCirclePlus;
  fasCog = faCog;
  fasRotateRight = faRotateRight;



  @ViewChild('scrollBox', { read: ElementRef }) scrollBox!: ElementRef;

  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  fechaInicial: Date | undefined;
  panelLateralVisible: boolean = true;
  registroForm!: FormGroup;
  private gridApi!: GridApi;
  gridContext!: { componentParent: ATMaestroProductosComponent };
  filaSeleccionada: any = null;
  productoSeleccionado: any = null;
  archivo: any = null;
  tabSeleccionado: string = 'detalle';
  claseArtSelect: any = [];
  cuentasContables: any[] = [];
  // Variable para controlar si estamos en modo creación o edición
  modoCreacion: boolean = true;
  
  // Variable para controlar si hay cambios en el formulario
  formularioConCambios: boolean = false;

  gridOptions = {
    context: { componentParent: this }
  };

  tabs = [
    { value: 'detalle', label: 'Detalle producto' },
    { value: 'cuentas', label: 'Cuentas asociadas' },
    { value: 'impuestos', label: 'Impuestos' },
  ];

  naturalezaSelect = [
    { id: 'Contable', nombre: 'Contable' },
    { id: 'Inventario', nombre: 'Inventario' },
    { id: 'Gestión', nombre: 'Gestión' },
    { id: 'Importación', nombre: 'Importación' },
  ];

  //  Inyección del facade de catálogos
  readonly sucursales = this.catalogosFacade.sucursalesActivas;
  readonly unidadesMedida = this.catalogosFacade.unidadesMedida;

  claseSelect = [
    { id: 'insumos', nombre: 'Insumos de cocina' },
    { id: 'servicios', nombre: 'Servicios' },
    // { id: '', nombre: 'Activos fijos' },
    // { id: '', nombre: 'Otros' },
  ];

  tipoISelect: any = [
    // { id: 'IGV (18%)', nombre: 'IGV (18%)' },
    // { id: 'IGV (10%)', nombre: 'IGV (10%)' },
  ];

  centrosC: any
  // = [
  //   { id: 'AC01', nombre: 'AC01 - Administración' },
  //   { id: 'AC02', nombre: 'AC02 - Ventas' },
  //   { id: 'AC03', nombre: 'AC03 - Producción' },
  //   { id: 'AC04', nombre: 'AC04 - Logística' },
  //   { id: 'AC05', nombre: 'AC05 - Finanzas' }
  // ];
  // cuentasC: any = [
  //   { id: '150100000000', descripcion: 'Caja y Bancos' },
  //   { id: '150101000000', descripcion: 'Caja Principal' },
  //   { id: '150102000000', descripcion: 'Caja Chica' },
  //   { id: '150200000000', descripcion: 'Cuentas por Cobrar' },
  //   { id: '150201000000', descripcion: 'Clientes Nacionales' },
  //   { id: '150202000000', descripcion: 'Clientes del Exterior' },
  // ];
  // cuentasCI: any = [
  //   { id: '150100000000', descripcion: 'Caja y Bancos' },
  //   { id: '150101000000', descripcion: 'Caja Principal' },
  //   { id: '150102000000', descripcion: 'Caja Chica' },
  //   { id: '150200000000', descripcion: 'Cuentas por Cobrar' },
  //   { id: '150201000000', descripcion: 'Clientes Nacionales' },
  //   { id: '150202000000', descripcion: 'Clientes del Exterior' },
  // ];

  estadoSelect = [
    { id: 'Activo', nombre: 'Activo' },
    { id: 'Inactivo', nombre: 'Inactivo' },
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

  rowData: MaestroProductoEntity[] = [];

  colDefs: ColDef<MaestroProductoEntity>[] = [
    { field: 'maestro_producto_codigo', headerName: 'Código', width: 90 },
    { field: 'maestro_producto_nombre', headerName: 'Descripción producto', flex: 1 },
    { field: 'maestro_producto_naturaleza', headerName: 'Naturaleza', width: 120, filter: true, },
    { field: 'maestro_producto_centro_costo', headerName: 'Centro de costo', width: 120, filter: true, },
    { field: 'maestro_producto_sucursal', headerName: 'Sucursales', width: 130, filter: true, cellRenderer: VistaCellRenderComponent, },
    { field: 'maestro_producto_impuesto', headerName: 'Impuesto', width: 100, },
    { field: 'maestro_producto_fecha_creacion', headerName: 'Fecha de creación', width: 130, },
    {
      field: 'maestro_producto_estado', headerName: 'Estado', width: 130, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', },
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
        } else if (params.value === 'Inactivo') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>';
        }
        return params.value;
      },
    },
  ];

  constructor(
    private formBuilder: FormBuilder,
    private http: HttpClient,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService,
    private simulation: SimulationService
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Sincronizar datos del facade (JSON) con rowData local
    effect(() => {
      const datos = this.almacenFacade.maestroProductos();
      if (datos.length > 0) {
        const simulationData = this.simulation.list('producto');
        const isNewFormat =
          simulationData.length > 0 &&
          'maestro_producto_codigo' in simulationData[0];

        if (isNewFormat) {
          this.rowData = [...simulationData];
        } else {
          this.rowData = [...datos];
          this.simulation.replace('producto', datos);
        }
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', this.rowData);
        }
      }
    });
  }

  ngOnInit() {
    // Cargar datos iniciales desde JSON via facade (arquitectura limpia)
    this.almacenFacade.cargarMaestroProductos();
    // Cargar datos guardados desde simulation (fallback)
    // const simulationData = this.simulation.list('producto');
    // const isNewFormat = simulationData.length > 0 && 'maestro_producto_codigo' in simulationData[0];
    // if (isNewFormat) {
    //   this.rowData = simulationData;
    // }

    // Inicializar formulario con valores por defecto para evitar errores al usarlo
    this.registroForm = this.formBuilder.group({
      usuario: [{ value: 'Eduardo Jimenez Lopez', disabled: true }],
      fechaC: [{ value: this.getFechaHoy(), disabled: true }],
      producto: ['', Validators.required],
      sucursal: ['', Validators.required],
      centroC: ['', Validators.required],
      tipoN: ['', Validators.required],
      clase: [''],
      impuesto: [''],
      medida: ['UND', Validators.required],
      observacion: [''],
      estado: ['Activo'],
      cuentaCI: ['', Validators.required],
      cuentaCC: ['', Validators.required],
      // cuentaCIG: ['', Validators.required],
      tipoI: [''],
      porcentajeI: [{ value: '18%', disabled: true }],
    });

    this.formValidationService.inicializarFormulario(this.registroForm);

    // Escuchar cambios en el formulario para activar/desactivar el botón "Nuevo Producto"
    this.registroForm.valueChanges.subscribe(() => {
      // Si no hay producto seleccionado, marcar si hay cambios
      if (!this.filaSeleccionada) {
        this.formularioConCambios = this.registroForm.dirty;
      } else {
        // Si hay producto seleccionado, siempre permitir nuevo
        this.formularioConCambios = true;
      }
    });

    this.cargarClaseArticuloDesdeSimulacion();
    this.cargarCentroCostos();
    this.cargarCuentasContables();
    this.cargarImpuestos();
    // Contexto de la grilla (si se usa en cellRenderers u otros)
    this.gridContext = { componentParent: this };

    // Inicializar catálogos compartidos
    this.catalogosFacade.inicializarCatalogos();
  }

  cargarClaseArticuloDesdeSimulacion() {
    // Leer directamente desde localStorage para obtener los datos más recientes
    const datosGuardados = localStorage.getItem('categoria');
    let claseart: any[] = [];

    if (datosGuardados) {
      try {
        claseart = JSON.parse(datosGuardados);
      } catch (e) {
        console.error('Error al parsear clases de artículo:', e);
        claseart = [];
      }
    }

    // Normalizar para que el autocomplete encuentre las keys correctas
    this.claseArtSelect = claseart.map((item: any, index: number) => ({
      id: item.almacen_codigo || index + 1,
      nombre: item.nombre || item.nombredealmacen || '',
      almacen_codigo: item.almacen_codigo || `CAT-${String(index + 1).padStart(3, '0')}`,
      descripcion: item.descripcion || item.nombre || '',
      ...item
    }));
  }
  cargarCuentasContables() {
    const cuentasLS = localStorage.getItem('plancontable');
    let cuentasData: any[] = [];

    if (cuentasLS) {
      try {
        cuentasData = JSON.parse(cuentasLS);
      } catch (e) {
        console.error('Error al parsear cuentas contables:', e);
      }
    }

    // Si no hay datos en localStorage, cargar datos por defecto
    if (!cuentasData || cuentasData.length === 0) {
      cuentasData = this.getCuentasContablesPorDefecto();
      // Guardar en localStorage para la próxima vez
      this.simulation.replace('plancontable', cuentasData);
    }

    // Mapear cuentas con el formato necesario para el autocomplete
    this.cuentasContables = cuentasData.map((item: any) => ({
      id: item.almacen_codigo,
      almacen_codigo: item.almacen_codigo,
      descripcion: item.descripcion,
      nombre: `${item.almacen_codigo} - ${item.descripcion}`,
      naturaleza: item.naturaleza,
      tipo: item.tipo,
      nivel: item.nivel,
      estado: item.estado,
      ...item
    }));
  }
  cargarImpuestos() {
    const impuestosLS = this.simulation.list('impuestos') || [];

    // Mapear cuentas con el formato necesario para el autocomplete
    this.tipoISelect = impuestosLS.map((item: any) => ({
      id: item.almacen_codigo,
      almacen_codigo: item.almacen_codigo,
      descripcion: item.descripcion,
      nombre: `${item.tipo}`,
      naturaleza: item.naturaleza,
      tipo: item.tipoimpuesto,
      nivel: item.nivel,
      estado: item.estado,
      impuesto: item.impuesto,
      ...item
    }));
  }

  /**
   * Datos por defecto del plan contable si no existen en localStorage
   */
  getCuentasContablesPorDefecto(): any[] {
    const fechaActual = this.getFechaHoy();
    return [
      // 1 - ACTIVO
      { orgHierarchy: ['1 - ACTIVO'], almacen_codigo: '1', descripcion: 'ACTIVO', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['1 - ACTIVO', '10 - EFECTIVO Y EQUIVALENTES DE EFECTIVO'], almacen_codigo: '10', descripcion: 'EFECTIVO Y EQUIVALENTES DE EFECTIVO', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '1' },
      { orgHierarchy: ['1 - ACTIVO', '10 - EFECTIVO Y EQUIVALENTES DE EFECTIVO', '101 - CAJA'], almacen_codigo: '101', descripcion: 'CAJA', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '10' },
      { orgHierarchy: ['1 - ACTIVO', '10 - EFECTIVO Y EQUIVALENTES DE EFECTIVO', '104 - CUENTAS CORRIENTES EN INSTITUCIONES FINANCIERAS'], almacen_codigo: '104', descripcion: 'CUENTAS CORRIENTES EN INSTITUCIONES FINANCIERAS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '10' },
      { orgHierarchy: ['1 - ACTIVO', '12 - CUENTAS POR COBRAR COMERCIALES – TERCEROS'], almacen_codigo: '12', descripcion: 'CUENTAS POR COBRAR COMERCIALES – TERCEROS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '1' },
      { orgHierarchy: ['1 - ACTIVO', '12 - CUENTAS POR COBRAR COMERCIALES – TERCEROS', '121 - FACTURAS, BOLETAS Y OTROS COMPROBANTES POR COBRAR'], almacen_codigo: '121', descripcion: 'FACTURAS, BOLETAS Y OTROS COMPROBANTES POR COBRAR', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '12' },

      // 2 - ACTIVO REALIZABLE
      { orgHierarchy: ['2 - ACTIVO REALIZABLE'], almacen_codigo: '2', descripcion: 'ACTIVO REALIZABLE', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['2 - ACTIVO REALIZABLE', '20 - MERCADERÍAS'], almacen_codigo: '20', descripcion: 'MERCADERÍAS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '2' },
      { orgHierarchy: ['2 - ACTIVO REALIZABLE', '21 - PRODUCTOS TERMINADOS'], almacen_codigo: '21', descripcion: 'PRODUCTOS TERMINADOS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '2' },
      { orgHierarchy: ['2 - ACTIVO REALIZABLE', '24 - MATERIAS PRIMAS'], almacen_codigo: '24', descripcion: 'MATERIAS PRIMAS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '2' },
      { orgHierarchy: ['2 - ACTIVO REALIZABLE', '25 - MATERIALES AUXILIARES, SUMINISTROS Y REPUESTOS'], almacen_codigo: '25', descripcion: 'MATERIALES AUXILIARES, SUMINISTROS Y REPUESTOS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '2' },

      // 3 - ACTIVO INMOVILIZADO
      { orgHierarchy: ['3 - ACTIVO INMOVILIZADO'], almacen_codigo: '3', descripcion: 'ACTIVO INMOVILIZADO', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['3 - ACTIVO INMOVILIZADO', '33 - INMUEBLES, MAQUINARIA Y EQUIPO'], almacen_codigo: '33', descripcion: 'INMUEBLES, MAQUINARIA Y EQUIPO', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '3' },
      { orgHierarchy: ['3 - ACTIVO INMOVILIZADO', '33 - INMUEBLES, MAQUINARIA Y EQUIPO', '331 - TERRENOS'], almacen_codigo: '331', descripcion: 'TERRENOS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '33' },
      { orgHierarchy: ['3 - ACTIVO INMOVILIZADO', '33 - INMUEBLES, MAQUINARIA Y EQUIPO', '335 - MUEBLES Y ENSERES'], almacen_codigo: '335', descripcion: 'MUEBLES Y ENSERES', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '33' },
      { orgHierarchy: ['3 - ACTIVO INMOVILIZADO', '33 - INMUEBLES, MAQUINARIA Y EQUIPO', '336 - EQUIPOS DIVERSOS'], almacen_codigo: '336', descripcion: 'EQUIPOS DIVERSOS', naturaleza: 'Deudora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '33' },
      { orgHierarchy: ['3 - ACTIVO INMOVILIZADO', '39 - DEPRECIACIÓN, AMORTIZACIÓN Y AGOTAMIENTO ACUMULADOS'], almacen_codigo: '39', descripcion: 'DEPRECIACIÓN, AMORTIZACIÓN Y AGOTAMIENTO ACUMULADOS', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '3' },

      // 4 - PASIVO
      { orgHierarchy: ['4 - PASIVO'], almacen_codigo: '4', descripcion: 'PASIVO', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['4 - PASIVO', '40 - TRIBUTOS, CONTRAPRESTACIONES Y APORTES AL SISTEMA'], almacen_codigo: '40', descripcion: 'TRIBUTOS, CONTRAPRESTACIONES Y APORTES AL SISTEMA', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '4' },
      { orgHierarchy: ['4 - PASIVO', '40 - TRIBUTOS, CONTRAPRESTACIONES Y APORTES AL SISTEMA', '401 - GOBIERNO CENTRAL'], almacen_codigo: '401', descripcion: 'GOBIERNO CENTRAL', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '40' },
      { orgHierarchy: ['4 - PASIVO', '41 - REMUNERACIONES Y PARTICIPACIONES POR PAGAR'], almacen_codigo: '41', descripcion: 'REMUNERACIONES Y PARTICIPACIONES POR PAGAR', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '4' },
      { orgHierarchy: ['4 - PASIVO', '42 - CUENTAS POR PAGAR COMERCIALES – TERCEROS'], almacen_codigo: '42', descripcion: 'CUENTAS POR PAGAR COMERCIALES – TERCEROS', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '4' },
      { orgHierarchy: ['4 - PASIVO', '42 - CUENTAS POR PAGAR COMERCIALES – TERCEROS', '421 - FACTURAS, BOLETAS Y OTROS COMPROBANTES POR PAGAR'], almacen_codigo: '421', descripcion: 'FACTURAS, BOLETAS Y OTROS COMPROBANTES POR PAGAR', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '42' },
      { orgHierarchy: ['4 - PASIVO', '45 - OBLIGACIONES FINANCIERAS'], almacen_codigo: '45', descripcion: 'OBLIGACIONES FINANCIERAS', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '4' },
      { orgHierarchy: ['4 - PASIVO', '46 - CUENTAS POR PAGAR DIVERSAS – TERCEROS'], almacen_codigo: '46', descripcion: 'CUENTAS POR PAGAR DIVERSAS – TERCEROS', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '4' },

      // 5 - PATRIMONIO NETO
      { orgHierarchy: ['5 - PATRIMONIO NETO'], almacen_codigo: '5', descripcion: 'PATRIMONIO NETO', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['5 - PATRIMONIO NETO', '50 - CAPITAL'], almacen_codigo: '50', descripcion: 'CAPITAL', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '5' },
      { orgHierarchy: ['5 - PATRIMONIO NETO', '50 - CAPITAL', '501 - CAPITAL SOCIAL'], almacen_codigo: '501', descripcion: 'CAPITAL SOCIAL', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '50' },
      { orgHierarchy: ['5 - PATRIMONIO NETO', '58 - RESERVAS'], almacen_codigo: '58', descripcion: 'RESERVAS', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '5' },
      { orgHierarchy: ['5 - PATRIMONIO NETO', '59 - RESULTADOS ACUMULADOS'], almacen_codigo: '59', descripcion: 'RESULTADOS ACUMULADOS', naturaleza: 'Acreedora', tipo: 'Balance', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '5' },

      // 6 - GASTOS POR NATURALEZA
      { orgHierarchy: ['6 - GASTOS POR NATURALEZA'], almacen_codigo: '6', descripcion: 'GASTOS POR NATURALEZA', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['6 - GASTOS POR NATURALEZA', '60 - COMPRAS'], almacen_codigo: '60', descripcion: 'COMPRAS', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '6' },
      { orgHierarchy: ['6 - GASTOS POR NATURALEZA', '62 - GASTOS DE PERSONAL, DIRECTORES Y GERENTES'], almacen_codigo: '62', descripcion: 'GASTOS DE PERSONAL, DIRECTORES Y GERENTES', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '6' },
      { orgHierarchy: ['6 - GASTOS POR NATURALEZA', '63 - GASTOS DE SERVICIOS PRESTADOS POR TERCEROS'], almacen_codigo: '63', descripcion: 'GASTOS DE SERVICIOS PRESTADOS POR TERCEROS', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '6' },
      { orgHierarchy: ['6 - GASTOS POR NATURALEZA', '65 - OTROS GASTOS DE GESTIÓN'], almacen_codigo: '65', descripcion: 'OTROS GASTOS DE GESTIÓN', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '6' },
      { orgHierarchy: ['6 - GASTOS POR NATURALEZA', '68 - VALUACIÓN Y DETERIORO DE ACTIVOS Y PROVISIONES'], almacen_codigo: '68', descripcion: 'VALUACIÓN Y DETERIORO DE ACTIVOS Y PROVISIONES', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '6' },
      { orgHierarchy: ['6 - GASTOS POR NATURALEZA', '69 - COSTO DE VENTAS'], almacen_codigo: '69', descripcion: 'COSTO DE VENTAS', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '6' },

      // 7 - INGRESOS
      { orgHierarchy: ['7 - INGRESOS'], almacen_codigo: '7', descripcion: 'INGRESOS', naturaleza: 'Acreedora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['7 - INGRESOS', '70 - VENTAS'], almacen_codigo: '70', descripcion: 'VENTAS', naturaleza: 'Acreedora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '7' },
      { orgHierarchy: ['7 - INGRESOS', '70 - VENTAS', '701 - MERCADERÍAS'], almacen_codigo: '701', descripcion: 'MERCADERÍAS', naturaleza: 'Acreedora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '70' },
      { orgHierarchy: ['7 - INGRESOS', '70 - VENTAS', '702 - PRODUCTOS TERMINADOS'], almacen_codigo: '702', descripcion: 'PRODUCTOS TERMINADOS', naturaleza: 'Acreedora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '03', ctaPadre: '70' },
      { orgHierarchy: ['7 - INGRESOS', '73 - DESCUENTOS, REBAJAS Y BONIFICACIONES OBTENIDOS'], almacen_codigo: '73', descripcion: 'DESCUENTOS, REBAJAS Y BONIFICACIONES OBTENIDOS', naturaleza: 'Acreedora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '7' },
      { orgHierarchy: ['7 - INGRESOS', '75 - OTROS INGRESOS DE GESTIÓN'], almacen_codigo: '75', descripcion: 'OTROS INGRESOS DE GESTIÓN', naturaleza: 'Acreedora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '7' },
      { orgHierarchy: ['7 - INGRESOS', '77 - INGRESOS FINANCIEROS'], almacen_codigo: '77', descripcion: 'INGRESOS FINANCIEROS', naturaleza: 'Acreedora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '7' },

      // 8 - SALDOS INTERMEDIARIOS DE GESTIÓN
      { orgHierarchy: ['8 - SALDOS INTERMEDIARIOS DE GESTIÓN'], almacen_codigo: '8', descripcion: 'SALDOS INTERMEDIARIOS DE GESTIÓN', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['8 - SALDOS INTERMEDIARIOS DE GESTIÓN', '80 - MARGEN COMERCIAL'], almacen_codigo: '80', descripcion: 'MARGEN COMERCIAL', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '8' },
      { orgHierarchy: ['8 - SALDOS INTERMEDIARIOS DE GESTIÓN', '89 - DETERMINACIÓN DEL RESULTADO DEL EJERCICIO'], almacen_codigo: '89', descripcion: 'DETERMINACIÓN DEL RESULTADO DEL EJERCICIO', naturaleza: 'Deudora', tipo: 'Resultados', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '8' },

      // 9 - CONTABILIDAD ANALÍTICA
      { orgHierarchy: ['9 - CONTABILIDAD ANALÍTICA DE EXPLOTACIÓN'], almacen_codigo: '9', descripcion: 'CONTABILIDAD ANALÍTICA DE EXPLOTACIÓN', naturaleza: 'Deudora', tipo: 'Orden', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
      { orgHierarchy: ['9 - CONTABILIDAD ANALÍTICA DE EXPLOTACIÓN', '90 - CUENTAS DE ORDEN'], almacen_codigo: '90', descripcion: 'CUENTAS DE ORDEN', naturaleza: 'Deudora', tipo: 'Orden', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '02', ctaPadre: '9' },
      { orgHierarchy: ['0 - CUENTAS DE ORDEN'], almacen_codigo: '0', descripcion: 'CUENTAS DE ORDEN', naturaleza: 'Deudora', tipo: 'Orden', movimiento: 'Si', moneda: 'Soles', vigencia: fechaActual, estado: 'Activo', nivel: '01', ctaPadre: '', isNivel1: true },
    ];
  }
  cargarCentroCostos() {
    this.http.get<any[]>('assets/data/contabilidad/tablas/centro-de-costos.json').subscribe({
      next: (data) => {
        this.centrosC = data.map((item: any) => ({
          id: item.codigo,
          nombre: `${item.codigo} - ${item.nombre}`,
          codigo: item.codigo,
          descripcion: item.descripcion,
          clasificacion: item.clasificacion,
          estado: item.estado,
        }));
      },
      error: () => {
        this.centrosC = [];
      }
    });
  }
  onCuentaArticulo(event: any) { }
  // FUNCIONES DEL SCROLL

  scrollLeft() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: -150, behavior: 'smooth' });
  }

  scrollRight() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: 150, behavior: 'smooth' });
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible
  }

  onSucursalSeleccionada(sucursales: any) {
    console.log('Sucursales seleccionadas:', sucursales);
  };

  onCentroCSeleccionado(centroC: any) {

  }

  onClaseSeleccionada(clase: any) {
    console.log('Clase seleccionada:', clase);
  }

  onCuentaCISeleccionada(cuentaCI: any) {

  }
  onCuentaCCSeleccionada(cuentaCC: any) {

  }
  // onCuentaCIGSeleccionada(cuentaCIG: any) {

  // }

  onImpuestoSeleccionado(impuestosIds: any) {
    console.log('IDs de impuestos seleccionados:', impuestosIds);

    // Validar que impuestosIds sea un array
    if (!Array.isArray(impuestosIds) || impuestosIds.length === 0) {
      // Si no hay impuestos seleccionados, limpiar el campo de porcentaje
      this.registroForm.get('porcentajeI')?.setValue('');
      return;
    }

    // Buscar los objetos completos basándose en los IDs recibidos
    const impuestosCompletos = impuestosIds
      .map((id: any) => this.tipoISelect.find((imp: any) => imp.id === id))
      .filter((imp: any) => imp); // Filtrar valores undefined

    console.log('Impuestos completos encontrados:', impuestosCompletos);

    // Extraer los porcentajes de los impuestos seleccionados
    const porcentajes = impuestosCompletos
      .map((imp: any) => imp.porcentaje)
      .filter((porcentaje: any) => porcentaje) // Filtrar valores vacíos
      .join(', '); // Unir con comas y espacios

    console.log('Porcentajes extraídos:', porcentajes);

    // Asignar los porcentajes al campo porcentajeI
    this.registroForm.get('porcentajeI')?.setValue(porcentajes);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // Si los datos ya llegaron antes que el grid, aplicarlos ahora
    if (this.rowData.length > 0) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  /** Exporta el maestro de productos a Excel (ag-grid-enterprise). */
  exportarExcel() {
    if (!this.gridApi || this.rowData.length === 0) {
      this.toastService.warning('No hay productos para exportar');
      return;
    }
    this.gridApi.exportDataAsExcel({ fileName: 'maestro-productos.xlsx', sheetName: 'Maestro de productos' });
  }

  /** PDF vía el servicio transversal del proyecto (imprimir → "Guardar como PDF"). */
  exportarPdf() {
    this.pdfExport.printCurrentPage();
  }

  async onCellClicked(event: any) {

    const data = event?.data;
    if (!data) return;

    // Cancelar selección automática de AG-Grid
    event.node?.setSelected(true);

    // Si NO hay cambios reales → permitir cambio directo
    if (!this.formValidationService.tieneModificaciones()) {
      this.seleccionarProducto(data, event);
      return;
    }

    // Hay cambios → validar
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) {
      // Revertir selección
      setTimeout(() => {
        this.gridApi?.deselectAll();
        if (this.filaSeleccionada) {
          this.gridApi?.forEachNode((node) => {
            if (node.data === this.filaSeleccionada) {
              node.setSelected(true);
            }
          });
        }
      });
      return;
    }

    // Acepta → cambiar de fila
    this.seleccionarProducto(data, event);
  }

  private seleccionarProducto(data: any, event?: any) {

    event?.node?.setSelected(true);

    this.filaSeleccionada = data;
    this.modoCreacion = false;
    this.formularioConCambios = true; // Marcar que hay cambios cuando se selecciona un producto

    this.registroForm.patchValue({
      usuario: data.maestro_producto_responsable,
      fechaC: data.maestro_producto_fecha_creacion,
      producto: data.maestro_producto_nombre,
      sucursal: data.maestro_producto_sucursal_ids || [],
      centroC: data.maestro_producto_centro_costo,
      tipoN: data.maestro_producto_naturaleza,
      clase: data.maestro_producto_clase,
      medida: data.maestro_producto_medida,
      observacion: data.maestro_producto_observacion,
      estado: data.maestro_producto_estado,
      cuentaCI: data.maestro_producto_cuenta_ci,
      cuentaCC: data.maestro_producto_cuenta_cc,
      tipoI: data.maestro_producto_impuesto,
      porcentajeI: data.maestro_producto_porcentaje_impuesto,
    });

    // CLAVE
    this.formValidationService.resetearEstado();
  }


  async botonRegistrarProducto() {

    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;

    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.formularioConCambios = false; // Resetear estado de cambios

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    this.registroForm.reset({
      usuario: 'Eduardo Jimenez Lopez',
      fechaC: this.getFechaHoy(),
      producto: '',
      sucursal: '',
      centroC: '',
      tipoN: '',
      clase: '',
      medida: 'UND',
      observacion: '',
      estado: 'Activo',
      cuentaCI: '',
      cuentaCC: '',
      // cuentaCIG: '',
      tipoI: '',
    });

    // CLAVE
    this.formValidationService.resetearEstado();
  }

  botonEliminarProducto() {
    this.abrirModalEliminar();
  }

  async abrirModalEliminar() {

    const detallesEjemplo = [
      { label: 'Código', value: this.filaSeleccionada.maestro_producto_codigo },
      { label: 'Nombre del prod.', value: this.filaSeleccionada.maestro_producto_nombre },
      { label: 'Fecha de registro', value: this.filaSeleccionada.maestro_producto_fecha_creacion },
      { label: 'Naturaleza', value: this.filaSeleccionada.maestro_producto_naturaleza },
      { label: 'Usuario ejecutor', value: this.filaSeleccionada.maestro_producto_responsable },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Eliminar producto',
        subtitulomodal: 'Detalle de eliminación:',
        detalles: detallesEjemplo,
        tituloTextarea: 'Motivo de eliminación',
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Eliminar',
        colorBotonConfirmar: 'danger'
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      // Confirmar inactivación - mantener el estado Inactivo
      this.toastService.success('¡Producto eliminado exitosamente!');
    }
  }

  botonSiguiente() {
    if (this.tabSeleccionado == 'detalle') {
      const camposDetalle = ['producto', 'sucursal', 'centroC', 'tipoN', 'medida'];
      const invalidos = camposDetalle.filter(campo => {
        const control = this.registroForm.get(campo);
        const valor = control?.value;
        return !valor || (Array.isArray(valor) ? valor.length === 0 : valor === '');
      });

      if (invalidos.length > 0) {
        camposDetalle.forEach(campo => this.registroForm.get(campo)?.markAsTouched());
        this.toastService.warning('Por favor, complete todos los campos requeridos del detalle del producto');
        return;
      }

      this.tabSeleccionado = 'cuentas';
    }
  }

  /**
   * Valida que todos los campos requeridos estén completados
   * Campos requeridos: producto, sucursal, centroC, tipoN, medida, cuentaCI, cuentaCC, impuesto
   */
  validarCamposRequeridos(): boolean {
    const camposRequeridos = ['producto', 'sucursal', 'centroC', 'tipoN', 'medida', 'cuentaCI', 'cuentaCC', 'impuesto'];
    
    for (const campo of camposRequeridos) {
      const control = this.registroForm.get(campo);
      const valor = control?.value;

      // Validar que el valor no esté vacío o nulo
      if (!valor || valor.length === 0) {
        return false;
      }
    }

    return true;
  }

  botonGuardar() {
    // Validar que todos los campos requeridos estén completados
    if (!this.validarCamposRequeridos()) {
      this.toastService.warning('Por favor, complete todos los campos requeridos');
      return;
    }

    // Obtener valores del formulario
    const formValues = this.registroForm.getRawValue();

    // Generar código si es nuevo
    if (this.modoCreacion || !this.filaSeleccionada) {
      const nuevoCodigoNumero = this.rowData.length > 0
        ? Math.max(...this.rowData.map(r => parseInt(r.maestro_producto_codigo.split('-')[1]) || 0)) + 1
        : 1;
      formValues.maestro_producto_codigo = `PROD-${String(nuevoCodigoNumero).padStart(3, '0')}`;
      formValues.maestro_producto_fecha_creacion = this.getFechaHoy();
    }

    // Crear objeto para la tabla
    const nuevoProducto: MaestroProductoEntity = {
      maestro_producto_codigo: formValues.maestro_producto_codigo || this.filaSeleccionada?.maestro_producto_codigo || '',
      maestro_producto_nombre: formValues.producto,
      maestro_producto_naturaleza: formValues.tipoN,
      maestro_producto_centro_costo: formValues.centroC,
      maestro_producto_sucursal_ids: Array.isArray(formValues.sucursal) ? formValues.sucursal : [],
      maestro_producto_sucursal: Array.isArray(formValues.sucursal)
        ? `${String(formValues.sucursal.length).padStart(2, '0')} sucursales`
        : formValues.sucursal,
      maestro_producto_impuesto: formValues.tipoI || '',
      maestro_producto_clase: formValues.clase || '',
      maestro_producto_medida: formValues.medida,
      maestro_producto_observacion: formValues.observacion || '',
      maestro_producto_cuenta_ci: formValues.cuentaCI,
      maestro_producto_cuenta_cc: formValues.cuentaCC,
      maestro_producto_fecha_creacion: formValues.maestro_producto_fecha_creacion || this.getFechaHoy(),
      maestro_producto_estado: formValues.estado || 'Activo',
      maestro_producto_porcentaje_impuesto: formValues.porcentajeI || '',
      maestro_producto_responsable: formValues.usuario || 'Eduardo Jimenez Lopez',
    };

    if (this.modoCreacion || !this.filaSeleccionada) {
      // Guardar nuevo producto en simulation
      this.simulation.save('producto', nuevoProducto);
      this.toastService.success('¡Producto creado exitosamente!');
    } else {
      // Actualizar producto existente
      const indice = this.rowData.findIndex(r => r.maestro_producto_codigo === this.filaSeleccionada?.maestro_producto_codigo);
      if (indice !== -1) {
        this.rowData[indice] = { ...this.rowData[indice], ...nuevoProducto };
      }
      this.toastService.success('¡Producto actualizado exitosamente!');
    }

    // Actualizar tabla desde simulation
    this.rowData = [...this.simulation.list('producto')];

    // Actualizar la tabla en AG-Grid
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', [...this.rowData]);
    }

    // Limpiar formulario
    this.registroForm.reset({
      usuario: 'Eduardo Jimenez Lopez',
      fechaC: this.getFechaHoy(),
      producto: '',
      sucursal: '',
      centroC: '',
      tipoN: '',
      clase: '',
      medida: 'UND',
      observacion: '',
      estado: 'Activo',
      cuentaCI: '',
      cuentaCC: '',
      // cuentaCIG: '',
      tipoI: '',
    });
    this.tabSeleccionado = 'detalle'
    this.formValidationService.resetearEstado();
  }
  refrescarVista() {
    this.rowData = [...this.simulation.list('producto')];
  }

  getFechaHoy(): string {
    return new Date().toLocaleDateString('es-PE');
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
      { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Se ha creado el grupo 1.00' },
      { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se edito la descripción del grupo' },
      { fechaHora: '13/11/2025 09:00', usuario: 'Carlos Rodríguez', accion: 'Actualización', detalleCambio: 'Se cambió el tipo de flujo' },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones del producto ${this.filaSeleccionada.maestro_producto_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

  onFechaSeleccionada(date: Date) {
    console.log('Fecha seleccionada:', date);
    if (this.registroForm && date) {
      const fechaCtrl = this.registroForm.get('fechaR');
      if (fechaCtrl) {
        fechaCtrl.setValue(date);
      }
    }
  }

  onBtReset() {
    // Recargar desde JSON vía facade → activa appLoader automáticamente
    this.almacenFacade.cargarMaestroProductos();
  }

  async modalImportar() {
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar productos',
        descripcionSubir: 'Comparte tu archivo de excel con la información de tus productos y regístralos automáticamente en la plataforma.',
        buttonName: 'Importar productos',
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
          this.toastService.success('Archivo subido', nombre, 3000);
        } catch (e) {
          console.warn('ToastService falló', e);
        }
        // Llamar al método importar para procesar el archivo
        try { this.importar(data); } catch (e) {
          this.toastService.danger('Importacion fallida');
        }
      }
    } catch (e) {
      console.warn('Error al obtener resultado del modal', e);
      this.toastService.danger('Error al obtener resultado del modal');
    }
  }
  importar(data: any) {
    // Placeholder: aquí se procesaría el archivo (validaciones, parseo, subida, etc.)
    console.log('Importar llamado con:', data);
    // Por ahora solo guardamos el archivo en el estado (ya lo hacemos en modalImportar),
    // y se puede mostrar un toast adicional si se desea.
  }
  async abrirModal(value: string, rowData: any) {
    // VistaCellRenderComponent llama este método con value y rowData
    if (!rowData) {
      console.error('No se proporcionaron datos de la fila');
      return;
    }

    // Definir las columnas
    const colDefs = [
      { headerName: 'Sucursal', field: 'sucursal', width: 120 },
      { headerName: 'Dirección', field: 'direccion', flex: 1 },
    ];

    // Obtener las sucursales asociadas al producto
    const sucursalesIds = rowData.maestro_producto_sucursal_ids || [];
    const sucursalesData = sucursalesIds.map((id: string) => {
      const sucursal = this.sucursales().find(s => s.codigo === id);
      return {
        sucursal: sucursal?.nombre || id,
        direccion: 'Av. Genérica 1024, Lima, Perú' // Placeholder
      };
    });

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Sucursales para: ${rowData.maestro_producto_codigo}`,
        subtitulo: `Total de sucursales: ${sucursalesData.length}`,
        rowData: sucursalesData.length > 0 ? sucursalesData : [{ sucursal: 'Sin sucursales', direccion: '-' }],
        colDefs: colDefs,
        anchoModal: '461px',
        altoModal: '250px',

      }
    });

    await modal.present();
  }
}
