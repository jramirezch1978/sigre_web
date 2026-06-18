import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import {Component, OnInit, OnDestroy, inject} from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController, ViewWillEnter } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

// Facades
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';

@Component({
  selector: 'app-a-o-gestion-devoluciones',
  templateUrl: './a-o-gestion-devoluciones.component.html',
  styleUrls: ['./a-o-gestion-devoluciones.component.scss'],
  standalone: false,
})
export class AOGestionDevolucionesComponent implements OnInit, OnDestroy, CanComponentDeactivate, ViewWillEnter {
  // Facades
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Acceso al facade desde el template
  protected readonly facade = this.almacenFacade;

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.isLoading;


  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  //RANGO DE FECHAS

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  fechaInicial: Date | undefined;
  fechaR: Date | undefined;

  panelLateralVisible = true;

  DevolucionForm!: FormGroup;
  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'a-o-gestion-devoluciones'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }
  tipoSeleccionado: string = 'registro';
  gridContext!: { componentParent: AOGestionDevolucionesComponent };
  filaSeleccionada: any = null;
  private devolucionSeleccionadaData: any = null;
  facturaSeleccionada: any = null;
  camposDeshabilitados: boolean = false;
  modoCreacion: boolean = true;

  tipoFs = [
    { value: 'registro', nombre: 'Registro' },
    { value: 'devol', nombre: 'Devolución' },
  ]

  proveedores = [
    { id: 'ABARROTES ANDINOS S.A.', nombre: 'ABARROTES ANDINOS S.A.' },
    { id: 'AHORRA MAS GO S.A.', nombre: 'AHORRA MAS GO S.A.' },
    { id: 'CASTAGNINO PRODUCTS S.A.', nombre: 'CASTAGNINO PRODUCTS S.A.' },
    { id: 'DISTRIBUIDORA LA FAMILIA E.I.R.L.', nombre: 'DISTRIBUIDORA LA FAMILIA E.I.R.L.' },
    { id: 'ECONOMICO SUPERMERCADOS S.A.', nombre: 'ECONOMICO SUPERMERCADOS S.A.' },
  ];

  ordenesCompra = [
    { id: 'OC-2025-00001', nombre: 'OC-2025-00001' },
    { id: 'OC-2025-00002', nombre: 'OC-2025-00002' },
    { id: 'OC-2025-00003', nombre: 'OC-2025-00003' },
    { id: 'OC-2025-00004', nombre: 'OC-2025-00004' },
    { id: 'OC-2025-00005', nombre: 'OC-2025-00005' },
  ];

  facturas = [
    { id: 'F-2025-00001', nombre: 'F-2025-00001', almacen: 'Almacén Alvarado', estado: 'Pendiente' },
    { id: 'F-2025-00002', nombre: 'F-2025-00002', almacen: 'Almacén Alvarado', estado: 'Pendiente' },
    { id: 'F-2025-00003', nombre: 'F-2025-00003', almacen: 'Almacén Alvarado', estado: 'Pendiente' },
    { id: 'F-2025-00004', nombre: 'F-2025-00004', almacen: 'Almacén Alvarado', estado: 'Pendiente' },
    { id: 'F-2025-00005', nombre: 'F-2025-00005', almacen: 'Almacén Alvarado', estado: 'Pendiente' },
  ]
  productosPorFactura: any = {

    'F-2025-00001': [
      { almacen_codigo: 'PROD-001', nombre: 'Harina de Trigo 10KG', cantidadC: 10, cantidadD: 0, medida: 'UND' },
      { almacen_codigo: 'PROD-002', nombre: 'Leche Gloria 410g', cantidadC: 8, cantidadD: 0, medida: 'UND' },
      { almacen_codigo: 'PROD-003', nombre: 'Azúcar Rubia 5KG', cantidadC: 5, cantidadD: 0, medida: 'UND' },
    ],

    'F-2025-00002': [
      { almacen_codigo: 'PROD-010', nombre: 'Aceite Girasol 1L', cantidadC: 12, cantidadD: 0, medida: 'UND' },
      { almacen_codigo: 'PROD-011', nombre: 'Arroz Extra 50KG', cantidadC: 2, cantidadD: 0, medida: 'SACO' },
    ],

    'F-2025-00003': [
      { almacen_codigo: 'PROD-020', nombre: 'Fideos Tallarín 1KG', cantidadC: 20, cantidadD: 0, medida: 'UND' },
      { almacen_codigo: 'PROD-021', nombre: 'Mantequilla Gloria 200g', cantidadC: 15, cantidadD: 0, medida: 'UND' },
      { almacen_codigo: 'PROD-022', nombre: 'Huevos AA Caja x 30', cantidadC: 6, cantidadD: 0, medida: 'CJ' },
    ],

    'F-2025-00004': [
      { almacen_codigo: 'PROD-030', nombre: 'Gaseosa Coca-Cola 1.5L', cantidadC: 24, cantidadD: 0, medida: 'UND' },
      { almacen_codigo: 'PROD-031', nombre: 'Jabón Bolívar Barra', cantidadC: 30, cantidadD: 0, medida: 'UND' },
    ],

    'F-2025-00005': [
      { almacen_codigo: 'PROD-040', nombre: 'Café Altomayo 200g', cantidadC: 18, cantidadD: 0, medida: 'UND' },
      { almacen_codigo: 'PROD-041', nombre: 'Té Hornimans 100 sobres', cantidadC: 5, cantidadD: 0, medida: 'UND' },
      { almacen_codigo: 'PROD-042', nombre: 'Chocolate Sol del Cusco 90g', cantidadC: 22, cantidadD: 0, medida: 'UND' },
    ]

  };
  private gridApiDetalle!: GridApi;

  estadoSelect = [
    { id: 'Pendiente', nombre: 'Pendiente' },
    { id: 'Aprobado', nombre: 'Aprobado' },
    { id: 'Anulado', nombre: 'Anulado' },
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
  rowDataDetalle: any[] = [];

  // La lista principal de gestiones de devoluciones se gestiona a través del store (facade.gestionesDevoluciones)

  colDefs: ColDef[] = [
    { field: 'gestion_devolucion_codigo', headerName: 'Código', width: 90 },
    { field: 'gestion_devolucion_factura_asociada', headerName: 'Factura asociada', width: 110 },
    { field: 'gestion_devolucion_fecha_registro', headerName: 'Fecha registro', width: 100 },
    { field: 'gestion_devolucion_producto', headerName: 'Productos', width: 70 },
    { field: 'gestion_devolucion_proveedor', headerName: 'Proveedor', width: 170 },
    { field: 'gestion_devolucion_almacen', headerName: 'Almacén', width: 150, filter: true, },
    { field: 'gestion_devolucion_motivo', headerName: 'Fecha devolución', width: 115 },
    { field: 'gestion_devolucion_responsable', headerName: 'Responsable de devolucion', flex: 1, minWidth: 150 },
    {
      field: 'gestion_devolucion_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', },
      cellRenderer: (params: any) => {
        if (params.value === 'Aprobado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Aprobado</span>';
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        } else if (params.value === 'Anulado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulado</span>';
        }
        return params.value;
      },
    },

  ];
  colDefsDetalleNuevo: ColDef[] = [
    {
      field: 'seleccionado',
      headerName: '',
      width: 30,
      checkboxSelection: true,
      headerCheckboxSelection: true,
    },
    { field: 'almacen_codigo', headerName: 'Código', width: 70 },
    { field: 'nombre', headerName: 'Nombre de producto', width: 130 },
    { field: 'cantidadC', headerName: 'Cantidad contada', width: 80 },
    {
      field: 'cantidadD',
      headerName: 'Cantidad devuelta',
      width: 80,
      editable: true
    },
    { field: 'medida', headerName: 'Medida', width: 50 },
  ];

  colDefsDetalleVer: ColDef[] = [
    {
      field: 'seleccionado',
      headerName: '',
      width: 30,
      checkboxSelection: true,
      headerCheckboxSelection: true,
    },
    { field: 'almacen_codigo', headerName: 'Código', width: 80 },
    { field: 'nombre', headerName: 'Nombre de producto', width: 150 },
    { field: 'cantidadC', headerName: 'Cantidad contada', width: 80 },
    {
      field: 'cantidadD',
      headerName: 'Cantidad devuelta',
      width: 80,
      editable: (params: any) => {
        // Solo editable si el estado no es 'Pendiente' o si no hay fila seleccionada
        return !this.filaSeleccionada || this.filaSeleccionada.estado !== 'Pendiente';
      }
    },
    { field: 'medida', headerName: 'Medida', width: 80 },
  ];


  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  ngOnInit() {
    // Inicializar formulario con valores por defecto para nuevo registro
    this.DevolucionForm = this.formBuilder.group({
      usuario: [{ value: 'Eduardo Jimenez Lopez', disabled: true }],
      fechaR:  [{ value: this.getFechaHoy(), disabled: true }],
      // fechaD: ['', Validators.required],
      fechaD:[this.getFechaHoy(), Validators.required],
      ordenCompra: [''],
      proveedor: ['', Validators.required],
      facturaA: ['', Validators.required],
      almacen: [{ value: '', disabled: true }],
      motivo: [''],
      estado: ['Pendiente'],
    });

    // Inicializar servicio de validación de formularios
    this.formValidationService.inicializarFormulario(this.DevolucionForm);

    // Contexto de la grilla (si se usa en cellRenderers u otros)
    this.gridContext = { componentParent: this };

    // Asegurar que inicie sin fila seleccionada
    this.filaSeleccionada = null;
    this.facturaSeleccionada = null;
    this.rowDataDetalle = [];
  }

  ionViewWillEnter() {
    this.almacenFacade.cargarGestionesDevoluciones();
  }

  ngOnDestroy() {
    // Limpiar el tracking del formulario
    this.formValidationService.limpiarFormulario();
  }

  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  getFechaHoy(): string {
    const hoy = new Date();
    const year = hoy.getFullYear();
    const month = String(hoy.getMonth() + 1).padStart(2, '0');
    const day = String(hoy.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`; // Formato yyyy-MM-dd para input type="date"
  }

  tieneModificaciones(): boolean {
    return this.formValidationService.tieneModificaciones();
  }

  // Convertir fecha de dd/mm/yyyy a yyyy-MM-dd
  convertirFechaAISO(fecha: string): string {
    if (!fecha) return '';
    const partes = fecha.split('/');
    if (partes.length === 3) {
      const [dia, mes, anio] = partes;
      return `${anio}-${mes.padStart(2, '0')}-${dia.padStart(2, '0')}`;
    }
    return fecha;
  }

  onProveedorSeleccionado(proveedor: any) {
    console.log('Proveedor seleccionado:', proveedor);
  }

  onOrdenCompraSeleccionada(ordenCompra: any) {
    console.log('Orden de compra seleccionada:', ordenCompra);
  }

  onFacturaSeleccionada(factura: any) {
    if (factura) {
      this.facturaSeleccionada = factura;

      // llenar campos del formulario
      this.DevolucionForm.patchValue({
        almacen: factura.almacen,
        estado: factura.estado
      });

      // cargar productos
      this.rowDataDetalle = this.productosPorFactura[factura.id] ?? [];
    } else {
      this.rowDataDetalle = [];
    }
  }



  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    if (this.devolucionSeleccionadaData) {
      setTimeout(() => {
        this.gridApi.forEachNode(node => {
          if (node.data === this.devolucionSeleccionadaData) {
            node.setSelected(true);
            this.filaSeleccionada = node.data;
          }
        });
      }, 150);
    }
  }


  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApiDetalle = params.api;
  }

  async onCellClicked(event: any) {
    const data = event?.data;
    if (!data) { return; }

    // Validar si hay cambios sin guardar
    const puede = await this.formValidationService.validarCambios();
    
    if (!puede) {
      // Si cancela, deseleccionar
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
          this.gridApi.refreshCells({ force: true });
        }
      }, 0);
      return;
    }

    this.cargarDatos(data);
  }

  private cargarDatos(data: any) {
    // Deseleccionar todas las filas primero
    this.gridApi.deselectAll();

    // Seleccionar la fila clickeada
    this.gridApi.forEachNode((node) => {
      if (node.data === data) {
        node.setSelected(true);
      }
    });

    this.filaSeleccionada = data;
    this.devolucionSeleccionadaData = data;
    this.modoCreacion = false;

    // Asegurar que [disabled] del autocomplete esté en false ANTES de patchValue
    this.camposDeshabilitados = false;

    // Habilitar todos los controles antes de patchValue para que writeValue llegue al autocomplete
    Object.keys(this.DevolucionForm.controls).forEach(key =>
      this.DevolucionForm.get(key)?.enable({ emitEvent: false })
    );

    const estado   = data.gestion_devolucion_estado           ?? data.estado   ?? '';
    const factura  = data.gestion_devolucion_factura_asociada ?? data.facturaA ?? '';
    const proveedor = data.gestion_devolucion_proveedor       ?? data.proveedor ?? '';
    const almacen  = data.gestion_devolucion_almacen          ?? data.almacen  ?? '';

    this.DevolucionForm.patchValue({
      usuario:  data.gestion_devolucion_responsable   ?? data.responsable ?? '',
      fechaR:   this.convertirFechaAISO(data.gestion_devolucion_fecha_registro ?? data.fechaR ?? ''),
      fechaD:   this.convertirFechaAISO(data.gestion_devolucion_motivo         ?? data.devolucion ?? ''),
      ordenCompra: data.gestion_devolucion_orden_compra ?? data.ordenCompra ?? '',
      proveedor,
      facturaA: factura,
      almacen,
      motivo:   data.gestion_devolucion_motivo_texto  ?? data.motivo ?? '',
      estado,
    });

    // Cargar productos de la factura correspondiente
    this.facturaSeleccionada = this.facturas.find(f => f.id === factura) ?? { id: factura, nombre: factura };
    this.rowDataDetalle = this.productosPorFactura[factura] ?? [];

    // Controlar habilitación/deshabilitación de campos según el estado
    this.controlarEstadoCampos(estado);

    // Marcar como estado guardado
    this.formValidationService.resetearEstado();
  }

  controlarEstadoCampos(estado: string) {
    // Resetear estado de deshabilitación
    this.camposDeshabilitados = false;

    if (estado === 'Pendiente') {
      // Si el estado es Pendiente, deshabilitar todos los campos excepto el estado
      this.camposDeshabilitados = true;
      this.DevolucionForm.get('usuario')?.disable();
      this.DevolucionForm.get('fechaR')?.disable();
      this.DevolucionForm.get('fechaD')?.disable();
      this.DevolucionForm.get('proveedor')?.disable();
      this.DevolucionForm.get('facturaA')?.disable();
      this.DevolucionForm.get('almacen')?.disable();
      this.DevolucionForm.get('motivo')?.disable();
      // El campo estado permanece habilitado
      this.DevolucionForm.get('estado')?.enable();
    } else if (estado === 'Aprobado') {
      // Si el estado es Aprobado, deshabilitar todos los campos incluyendo el estado
      this.camposDeshabilitados = true;
      this.DevolucionForm.get('usuario')?.disable();
      this.DevolucionForm.get('fechaR')?.disable();
      this.DevolucionForm.get('fechaD')?.disable();
      this.DevolucionForm.get('proveedor')?.disable();
      this.DevolucionForm.get('facturaA')?.disable();
      this.DevolucionForm.get('almacen')?.disable();
      this.DevolucionForm.get('motivo')?.disable();
      this.DevolucionForm.get('estado')?.disable();
    } else if (estado === 'Anulado') {
      // Si el estado es Anulado, deshabilitar todos los campos incluyendo el estado
      this.camposDeshabilitados = true;
      this.DevolucionForm.get('usuario')?.disable();
      this.DevolucionForm.get('fechaR')?.disable();
      this.DevolucionForm.get('fechaD')?.disable();
      this.DevolucionForm.get('proveedor')?.disable();
      this.DevolucionForm.get('facturaA')?.disable();
      this.DevolucionForm.get('almacen')?.disable();
      this.DevolucionForm.get('motivo')?.disable();
      this.DevolucionForm.get('estado')?.disable();
    } else {
      // Para otros estados, habilitar todos los campos
      this.camposDeshabilitados = false;
      this.DevolucionForm.get('usuario')?.enable();
      this.DevolucionForm.get('fechaR')?.disable(); // Este siempre debe estar deshabilitado según la lógica original
      this.DevolucionForm.get('fechaD')?.enable();
      this.DevolucionForm.get('proveedor')?.enable();
      this.DevolucionForm.get('facturaA')?.enable();
      this.DevolucionForm.get('almacen')?.disable(); // Este también se deshabilita según la lógica original
      this.DevolucionForm.get('motivo')?.enable();
      this.DevolucionForm.get('estado')?.enable();
    }
  }

  async botonRegistrarDevolucion() {
    // Validar si hay cambios sin guardar
    const puede = await this.formValidationService.validarCambios();
    
    if (!puede) {
      // Si cancela, deseleccionar
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
          this.gridApi.refreshCells({ force: true });
        }
      }, 0);
      return;
    }

    // Deseleccionar cualquier fila en la grilla
    if (this.gridApi) {
      this.gridApi.deselectAll();
      // Forzar la actualización visual de la grilla
      this.gridApi.refreshCells({ force: true });
    }

    // Limpiar la fila seleccionada
    this.filaSeleccionada = null;
    this.devolucionSeleccionadaData = null;
    this.modoCreacion = true;

    // Limpiar datos relacionados
    this.rowDataDetalle = [];
    this.facturaSeleccionada = null;

    // Resetear el estado de deshabilitación
    this.camposDeshabilitados = false;

    // Reiniciar el formulario a los valores por defecto
    if (this.DevolucionForm) {
      this.DevolucionForm.reset();
      // Inicializar con valores por defecto
      this.DevolucionForm.patchValue({
        usuario: 'Eduardo Jimenez Lopez',
        fechaR: this.getFechaHoy(),
        fechaD: this.getFechaHoy(),
        estado: 'Pendiente'
      });
      
      // Deshabilitar campos que no se deben editar
      this.DevolucionForm.get('usuario')?.disable();
      this.DevolucionForm.get('fechaR')?.disable();
      this.DevolucionForm.get('almacen')?.disable();
      
      // Habilitar campos editables
      this.DevolucionForm.get('fechaD')?.enable();
      this.DevolucionForm.get('ordenCompra')?.enable();
      this.DevolucionForm.get('proveedor')?.enable();
      this.DevolucionForm.get('facturaA')?.enable();
      this.DevolucionForm.get('motivo')?.enable();
      this.DevolucionForm.get('estado')?.enable();
    }

    this.formValidationService.resetearEstado();
  }

  botonAnularDevolucion() {
    this.abrirModalAnular();
  }
  async abrirModalAnular() {

    const detallesEjemplo = [
      { label: 'Código', value: this.filaSeleccionada.almacen_codigo },
      { label: 'Factura asociada', value: this.filaSeleccionada.facturaA },
      { label: 'Cant. productos', value: this.filaSeleccionada.producto },
      { label: 'Proveedor', value: this.filaSeleccionada.proveedor },
      { label: 'Usuario ejecutor', value: this.filaSeleccionada.responsable },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Anular devolución',
        subtitulomodal: 'Detalle de anulación',
        detalles: detallesEjemplo,
        tituloTextarea: 'Motivo de anulación',
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Anular',
        colorBotonConfirmar: 'danger'
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      // Confirmar inactivación - mantener el estado Inactivo
      // this.toastService.success('¡Proceso anulado exitosamente!');
    }
  }

  botonGuardar() {
    if (!this.gridApiDetalle) {
      this.toastService.warning("Por faovr, completa todos los campos requeridos");
      return;
    }

    const seleccionados = this.gridApiDetalle.getSelectedRows();

    console.log("Productos seleccionados:", seleccionados);

    if (!this.filaSeleccionada && seleccionados.length === 0) {
      this.toastService.warning("Debes seleccionar al menos 1 producto para devolver.");
      return;
    }

    // aquí ya puedes enviarlo al backend
    console.log("Guardando devolución con:", {
      form: this.DevolucionForm.value,
      productos: seleccionados
    });

    this.toastService.success("Devolución guardada correctamente.");

    // Resetear servicio de validación después de guardar
    this.formValidationService.resetearEstado();
  }

  onTipoSeleccionado(tipo: any) {
    console.log('Tipo seleccionado:', tipo);
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos
    // this.cargarDatos(range.start, range.end);
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
        titulo: `Historial de Actualizaciones de la devolución ${this.filaSeleccionada.almacen_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

  onFechaSeleccionada(date: Date) {
    console.log('Fecha seleccionada:', date);
    if (this.DevolucionForm && date) {
      const fechaCtrl = this.DevolucionForm.get('fechaD');
      if (fechaCtrl) {
        fechaCtrl.setValue(date);
      }
    }
  }

  onBtReset() {
    this.almacenFacade.cargarGestionesDevoluciones();
  }
  togglePanelLateral(): void {
    this.panelLateralVisible = !this.panelLateralVisible;
  }
}
