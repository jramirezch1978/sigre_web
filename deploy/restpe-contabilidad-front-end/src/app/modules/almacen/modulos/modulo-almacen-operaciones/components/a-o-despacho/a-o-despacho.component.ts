import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import { Component, OnInit, OnDestroy, ViewChild, inject } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalController, ViewWillEnter } from '@ionic/angular';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { Observable } from 'rxjs';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';

// Font Awesome Icons
import { faBook, faSearch as faSearchRegular } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight, faSearch as faSearchSolid } from '@fortawesome/pro-solid-svg-icons';
import { DespachoEntity } from '../../../../domain/models/despacho.entity';

@Component({
  selector: 'app-a-o-despacho',
  templateUrl: './a-o-despacho.component.html',
  styleUrls: ['./a-o-despacho.component.scss'],
  standalone: false,
})
export class AoDespachoComponent implements OnInit, OnDestroy, CanComponentDeactivate, ViewWillEnter {
  // Facades
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Acceso al facade desde el template
  protected readonly facade = this.almacenFacade;

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.isLoading;



  // ---------------------------------------------------------------------------
  // Inyección de dependencias
  // ---------------------------------------------------------------------------

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearchRegular;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;
  fasSearch = faSearchSolid;



  @ViewChild('autocompleteProductos') autocompleteProductos: any;

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  fechaDespacho: Date = new Date();
  mostrartabla = true;

  DespachoSeleccionado: DespachoEntity | null = null;
  selectedDespacho: DespachoEntity | null = null;
  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'a-o-despacho'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }
  despachoForm!: FormGroup;
  detalleGridApi!: GridApi;

  filaSeleccionada: any = null;

  // Variable para persistir la selección cuando se oculta/muestra la tabla
  private despachoSeleccionadoData: any = null;

  // Estados de habilitación de campos
  esFechaDespachoHabilitada = false;
  esFormularioHabilitado = false;

  // Control de totales
  totalSolicitada: number = 0;
  totalDespachada: number = 0;
  diferencia: number = 0;

  // Estado del despacho confirmado
  despachoConfirmado: boolean = false;

  // Datos de productos del almacén
  productosAlmacen: any[] = [];
  productos: any[] = [];

  // Variables para validación de formulario
  private despachoFormInicial: any = null;
  private formularioModificado: boolean = false;

  // Historial de ediciones y despachos
  historialDespachos: any[] = [];

  tipoDespacho = [
    'Venta',
    'Consumo Interno',
  ]

  tipoDoc = [
    'DNI',
    'RUC',
  ]

  estados = [
    'Activo',
    'Inactivo'
  ]

  // Base de datos de productos simulada
  productosDb = [
    { id: 'prod001', nombre: 'Tomate fresco', almacen_codigo: '0006', stock: 100, unidad: 'kg', cantidadSolicitada: 50, cantidadDespachada: 40, diferencia: 10, porcentaje: '20%' },
    { id: 'prod002', nombre: 'Queso mozzarella', almacen_codigo: '0321', stock: 80, unidad: 'kg', cantidadSolicitada: 45, cantidadDespachada: 45, diferencia: 0, porcentaje: '0%' },
    { id: 'prod003', nombre: 'Aceite vegetal', almacen_codigo: '0089', stock: 50, unidad: 'Litros', cantidadSolicitada: 5, cantidadDespachada: 5, diferencia: 0, porcentaje: '0%' },
    { id: 'prod004', nombre: 'Lechuga', almacen_codigo: 'LEC-001', stock: 150, unidad: 'unidad', cantidadSolicitada: 20, cantidadDespachada: 20, diferencia: 0, porcentaje: '0%' },
    { id: 'prod005', nombre: 'Pollo fresco', almacen_codigo: 'POL-001', stock: 60, unidad: 'kg', cantidadSolicitada: 50, cantidadDespachada: 50, diferencia: 0, porcentaje: '0%' },
    { id: 'prod006', nombre: 'Arroz blanco', almacen_codigo: 'ARR-001', stock: 200, unidad: 'kg', cantidadSolicitada: 100, cantidadDespachada: 100, diferencia: 0, porcentaje: '0%' },
    { id: 'prod007', nombre: 'Aceite de oliva', almacen_codigo: 'ACE-001', stock: 40, unidad: 'litros', cantidadSolicitada: 30, cantidadDespachada: 30, diferencia: 0, porcentaje: '0%' },
    { id: 'prod008', nombre: 'Pan francés', almacen_codigo: 'PAN-001', stock: 120, unidad: 'unidad', cantidadSolicitada: 100, cantidadDespachada: 100, diferencia: 0, porcentaje: '0%' },
  ];

  // Base de datos de productos por RUC/Cliente (simulada)
  productosPorCliente = {
    '20567891234': [ // Alimentos Deliciosos S.A.
      { id: 'prod001', nombre: 'Tomate', almacen_codigo: '0006', stock: 100, unidad: 'kg', cantidadSolicitada: 50, cantidadDespachada: 50, diferencia: 0, porcentaje: '0%' },
      { id: 'prod002', nombre: 'Queso mozzarella', almacen_codigo: '0321', stock: 100, unidad: 'kg', cantidadSolicitada: 45, cantidadDespachada: 45, diferencia: 0, porcentaje: '0%' },
      { id: 'prod003', nombre: 'Aceite vegetal', almacen_codigo: '0089', stock: 100, unidad: 'Litros', cantidadSolicitada: 5, cantidadDespachada: 5, diferencia: 0, porcentaje: '0%' },
    ],
  };

  // ---------------------------------------------------------------------------
  // Catálogos desde Facade
  // ---------------------------------------------------------------------------
  // Base de datos de clientes (en la práctica vendría de un servicio)
  clientesRegistrados = [
    { documento: '12345678', nombre: 'Juan Pérez García', ruc: '10123456789' },
    { documento: '87654321', nombre: 'Andrea Díaz López', ruc: '10987654321' },
    { documento: '20123456789', nombre: 'Restaurante El Bu SAC', ruc: '20123456789' },
    { documento: '20987654321', nombre: 'Empresa Delicias SAC', ruc: '20987654321' },
    { documento: '45678901', nombre: 'Carlos Mendes Silva', ruc: '10456789012' },
    { documento: '20567891234', nombre: 'Alimentos Deliciosos S.A.', ruc: '20567891234' },
  ];

  documentosFuente = [
    { numero: 'OC-001-2025', tipo: 'Orden de Compra', fecha: '20/03/2025', proveedor: 'Proveedor A', ruc: '10123456789' },
    { numero: 'OC-002-2025', tipo: 'Orden de Compra', fecha: '21/03/2025', proveedor: 'Proveedor B', ruc: '10987654321' },
    { numero: 'REQ-001-2025', tipo: 'Requisición', fecha: '22/03/2025', area: 'Cocina', ruc: '20123456789' },
    { numero: 'REQ-002-2025', tipo: 'Requisición', fecha: '23/03/2025', area: 'Bar', ruc: '20987654321' },
    { numero: 'PED-001-2025', tipo: 'Pedido', fecha: '24/03/2025', cliente: 'Juan Pérez', ruc: '10123456789' },
    { numero: 'OC-003-2025', tipo: 'Orden de Compra', fecha: '25/03/2025', proveedor: 'Proveedor C', ruc: '10456789012' },
    { numero: 'OC-004-2025', tipo: 'Orden de Compra', fecha: '26/03/2025', proveedor: 'Proveedor D', ruc: '20567891234' },
  ];

  // Base de datos de destinos para Consumo Interno (autonplic)
  destinosConsumoInterno = [
    { id: 'cocina', nombre: 'Cocina', numeroDocumento: 'REQ-001-2025', almacenOrigen: 'Almacén Previos' },
    // Agregar más destinos según sea necesario
  ];

  // Base de datos de almacenes por RUC (simulada)
  almacenesPorRuc = [
    { ruc: '10123456789', almacenOrigen: 'Almacén Principal', numeroDocumento: 'OC-001-2025' },
    { ruc: '10987654321', almacenOrigen: 'Almacén Central', numeroDocumento: 'OC-002-2025' },
    { ruc: '20123456789', almacenOrigen: 'Almacén Previos', numeroDocumento: 'REQ-001-2025' },
    { ruc: '20987654321', almacenOrigen: 'Almacén Bebidas', numeroDocumento: 'REQ-002-2025' },
    { ruc: '10456789012', almacenOrigen: 'Almacén Insumos', numeroDocumento: 'OC-003-2025' },
    { ruc: '20567891234', almacenOrigen: 'Almacén Carnes', numeroDocumento: 'OC-004-2025' },
  ];





  colDefs: ColDef[] = [
    {
      field: 'despacho_fecha', headerName: 'Fecha despacho', width: 120,
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
    { field: 'despacho_tipo', headerName: 'Tipo despacho', width: 140, filter: true },
    { field: 'despacho_destino', headerName: 'Destino', width: 150 },
    { field: 'despacho_cantidad_solicitada', headerName: 'Cantidad solicitada', width: 120, },
    { field: 'despacho_cantidad_despachada', headerName: 'Cantidad despachada', width: 150, },
    { field: 'despacho_diferencia', headerName: 'Diferencia', width: 100, },
    { field: 'despacho_almacen_origen', headerName: 'Almacén origen', flex: 1, minWidth: 150, filter: true },
    { field: 'despacho_usuario', headerName: 'Usuario', width: 112, filter: true },
    {
      headerClass: 'centrarencabezado', field: 'despacho_estado', headerName: 'Estado', width: 120, filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Despachado') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Despachado</span>`;
        } else if (params.value === 'Parcial') {
          return `<span class="badge-table bg-[#FFF0BF] text-[#F2A626]">Parcial</span>`;
        }
        return params.value;
      },
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
  ];

  // Columnas para tabla de detalle de productos
  colDefsDetalle: ColDef[] = [
    { field: 'almacen_codigo', headerName: 'Código', width: 100 },
    { field: 'producto', headerName: 'Producto', width: 150 },
    { field: 'unidad', headerName: 'Unidad de medida', width: 120 },
    {
      field: 'stock', headerName: 'Stock disponible', width: 130, editable: false, headerClass: 'derecha-encabezado',
      cellStyle: { color: '#9CA3AF', textAlign: 'right', display: 'flex', justifyContent: 'flex-end', alignItems: 'center' }
    },
    {
      field: 'cantidadFac', headerName: 'Cantidad facturada', width: 150, editable: false, headerClass: 'derecha-encabezado',
      cellStyle: { color: '#9CA3AF', textAlign: 'right', display: 'flex', justifyContent: 'flex-end', alignItems: 'center' }
    },
    {
      field: 'cantidadDes', headerName: 'Cantidad despachada', width: 150, editable: true, cellEditor: 'agNumberCellEditor',
      valueParser: (params: any) => Number(params.newValue),
      headerClass: 'derecha-encabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'flex-end', alignItems: 'center', cursor: 'pointer' },
      onCellValueChanged: (params: any) => this.onCantidadDespachadaChanged(params)
    },
    {
      field: 'diferencia', headerName: 'Diferencia unidades', width: 120, editable: false, headerClass: 'derecha-encabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'flex-end', alignItems: 'center' }
    },
    {
      field: 'porcentaje', headerName: 'Diferencia (%)', width: 120, editable: false, headerClass: 'derecha-encabezado',
      cellStyle: { color: '#9CA3AF', textAlign: 'right', display: 'flex', justifyContent: 'flex-end', alignItems: 'center' }
    },
  ];

  columnTypes = {};

  rowClassRules = {
    'ag-row-diferencia-rojo': (params: any) => params.data.diferencia > 0
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

  constructor(private fb: FormBuilder, private modalController: ModalController, private toastService: ToastService, private formValidationService: FormValidationService, private simulation: SimulationService) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  togglePanelLateral() {
    this.mostrartabla = !this.mostrartabla;

  }

  ngOnInit() {
    // Inicializar catálogos compartidos
    this.catalogosFacade.inicializarCatalogos();

    this.despachoForm = this.fb.group({
      tipoDespacho: ['', Validators.required],
      documentoproveedor: ['DNI'],
      documentoproveedorinput: [''],
      nombreCliente: [''],
      numeroDocumentoFuente: ['', Validators.required],
      destino: [''],
      almacenOrigen: ['', Validators.required],
      fechaDespacho: [{ value: new Date(), disabled: true }, Validators.required],
      cantidadSolicitada: [''],
      cantidadDespachada: [''],
      observaciones: [''],
      estado: ['Despachado']
    });

    // Inicializar el servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.despachoForm);

    // Guardar estado inicial del formulario
    this.despachoFormInicial = this.despachoForm.value;

    // Suscribirse a cambios en el tipo de despacho
    this.despachoForm.get('tipoDespacho')?.valueChanges.subscribe((valor) => {
      this.onTipoDespachoChange({ detail: { value: valor } });
    });

    // Suscribirse a cambios en el almacén de origen
    this.despachoForm.get('almacenOrigen')?.valueChanges.subscribe((valor) => {
      this.onAlmacenSeleccionado(valor);
    });

    this.cargarProductosDesdeSimulacion();
  }

  ionViewWillEnter() {
    this.almacenFacade.cargarDespachos();
  }

  ngOnDestroy() {
    // Limpiar el tracking del formulario
    this.formValidationService.limpiarFormulario();
  }

  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  tieneModificaciones(): boolean {
    return this.formValidationService.tieneModificaciones();
  }

  formatearFecha(fecha: Date): string {
    const dia = fecha.getDate().toString().padStart(2, '0');
    const mes = (fecha.getMonth() + 1).toString().padStart(2, '0');
    const anio = fecha.getFullYear();
    return `${anio}-${mes}-${dia}`;
  }

  parsearFecha(fechaStr: string): Date {
    const partes = fechaStr.split('-');
    return new Date(
      parseInt(partes[0]),
      parseInt(partes[1]) - 1,
      parseInt(partes[2]),
    );
  }

  reformateoFecha(fecha: string): string {
    const [year, month, day] = fecha.split('-');
    return `${day}/${month}/${year}`;
  }
  cargarProductosDesdeSimulacion() {
    const productosLS = this.simulation.list('producto') || [];
    console.log('  Productos cargados desde maestro de productos:', productosLS);

    // Mapear productos con el formato necesario para el autocomplete
    this.productos = productosLS.map((item: any) => ({
      almacen_codigo: item.almacen_codigo,
      descripcion: item.producto || item.descripcion,
      producto: item.producto,
      unidadMedida: item.medida || 'UND',
      stockActual: item.stockActual || 0,
      chp: item.chp || 0,
      demandaProyectada: item.demandaProyectada || 0,
      ...item
    }));

    console.log(' Productos del maestro cargados:', this.productos.length);
  }

  /**
   * Verifica si el formulario ha sido modificado
   */
  private verificarCambios() {
    if (!this.despachoFormInicial) {
      this.formularioModificado = false;
      return;
    }

    const valorActual = this.despachoForm.value;
    this.formularioModificado = JSON.stringify(this.despachoFormInicial) !== JSON.stringify(valorActual);
  }

  onBtReset() {
    this.almacenFacade.cargarDespachos();
  }

  /**
   * Botón para crear un nuevo despacho - resetea el formulario completamente
   */
  async botonNuevoDespacho() {
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
      this.gridApi.refreshCells({ force: true });
    }

    this.filaSeleccionada = null;
    this.selectedDespacho = null;
    
    // Resetear el formulario inmediatamente
    this.resetearFormularioDespacho();
  }

  async onCellClicked(event: any) {
    const data = event.data;
    if (!data) { return; }

    // Validar si hay cambios sin guardar
    const puede = await this.formValidationService.validarCambios();
    
    if (!puede) {
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
          if (this.despachoSeleccionadoData) {
            this.gridApi.forEachNode(node => {
              if (node.data === this.despachoSeleccionadoData) node.setSelected(true);
            });
          }
        }
      }, 0);
      return;
    }

    // Prevenir selección automática
    event.node.setSelected(false);

    this.llenarFormulario(data, event);

    // Cargar datos del despacho seleccionado
    this.selectedDespacho = data;
    this.despachoSeleccionadoData = data;
    this.gridApi.deselectAll();
    event.node.setSelected(true);

    // Actualizar estado inicial
    this.despachoFormInicial = this.despachoForm.value;
    this.formularioModificado = false;
  }

  private llenarFormulario(data: any, event?: any) {

    event?.node?.setSelected(true);

    this.filaSeleccionada = data;

    this.despachoForm.patchValue({
      tipoDespacho:            data.despacho_tipo       ?? data.tipoDespacho       ?? '',
      documentoproveedor:      data.despacho_tipo_doc   ?? data.tipoDocProv        ?? '',
      documentoproveedorinput: data.despacho_doc_prov   ?? data.docProv            ?? '',
      nombreCliente:           data.despacho_destino    ?? data.destino            ?? '',
      numeroDocumentoFuente:   data.despacho_doc_fuente ?? data.docFuente          ?? '',
      destino:                 data.despacho_destino    ?? data.destino            ?? '',
      almacenOrigen:           data.despacho_almacen_origen ?? data.almacenOrigen  ?? '',
      fechaDespacho:           data.despacho_fecha      ?? data.fechaDespacho      ?? '',
      cantidadSolicitada:      data.despacho_cantidad_solicitada ?? data.cantSolict ?? '',
      cantidadDespachada:      data.despacho_cantidad_despachada ?? data.cantDesp   ?? '',
      observaciones:           data.despacho_observaciones ?? data.observaciones   ?? '',
      estado:                  data.despacho_estado     ?? data.estado             ?? '',
    });

    // CLAVE
    this.formValidationService.resetearEstado();
  }
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;

    // Restaurar la selección cuando la tabla se muestra de nuevo
    if (this.despachoSeleccionadoData) {
      setTimeout(() => {
        this.gridApi.deselectAll();
        this.gridApi.forEachNode((node) => {
          if (node.data === this.despachoSeleccionadoData) {
            node.setSelected(true);
          }
        });
      }, 150);
    }
  }

  onDetalleGridReady(params: GridReadyEvent) {
    this.detalleGridApi = params.api;
  }

  confirmarDespacho() {
    if(this.despachoForm.invalid){
      this.toastService.warning('Por favor, complete todos los campos requeridos')
      return;
    }
    if(this.productosAlmacen.length === 0){
      this.toastService.warning('Ingrese al menos un producto para despachar')
      return;
    }


    // Crear objeto de despacho a agregar a la tabla
    const nuevoDespacho: DespachoEntity = {
      despacho_fecha: this.formatearFecha(this.despachoForm.get('fechaDespacho')?.value),
      despacho_tipo: this.despachoForm.get('tipoDespacho')?.value || 'Despacho',
      despacho_destino: this.despachoForm.get('nombreCliente')?.value || 'Interno',
      despacho_cantidad_solicitada: this.totalSolicitada,
      despacho_cantidad_despachada: this.totalDespachada,
      despacho_diferencia: this.diferencia,
      despacho_almacen_origen: this.despachoForm.get('almacenOrigen')?.value || '',
      despacho_usuario: 'usuario-actual',
      despacho_estado: 'Despachado'
    };

    // Agregar el nuevo despacho al store
    this.almacenFacade.actualizarListaDespachos([nuevoDespacho, ...this.facade.despachos()]);

    // Refrescar la tabla (ag-grid reacciona al signal automáticamente)

    // Guardar en historial con detalles de productos
    const detalleProductos = this.productosAlmacen.map(p =>
      `${p.nombre} (${p.almacen_codigo}): Solicitado ${p.cantidadSolicitada}${p.unidad}, Despachado ${p.cantidadDespachada}${p.unidad}, Diferencia ${p.diferencia}${p.unidad}`
    ).join(' | ');

    const registroHistorial = {
      fechaHora: new Date().toLocaleString('es-PE'),
      usuario: 'usuario-actual',
      accion: 'Confirmación de despacho',
      detalleCambio: `Cliente: ${this.despachoForm.get('nombreCliente')?.value}. Total solicitado: ${this.totalSolicitada}, Total despachado: ${this.totalDespachada}, Diferencia: ${this.diferencia}. Productos: ${detalleProductos}`
    };

    this.historialDespachos.unshift(registroHistorial);

    // Marcar despacho como confirmado
    this.despachoConfirmado = true;

    // Mostrar toast de confirmación usando ToastService (mismo estilo que almacenamiento)
    this.toastService.success('¡Se registró despacho exitosamente!');

    console.log('Despacho confirmado y agregado a la tabla:', nuevoDespacho);

    // Resetear el formulario para crear un nuevo despacho
    setTimeout(() => {
      this.resetearFormularioDespacho();
    }, 500);
  }

  generarComp() {

    this.toastService.success('¡Comprobante generado exitosamente!');

  }

  /**
   * Resetea el formulario de despacho completamente como si fuera nuevo
   */
  private resetearFormularioDespacho() {
    // Resetear el formulario con todos los campos vacíos
    this.despachoForm.reset({
      fechaDespacho: new Date(),
      tipoDespacho: '',
      nombreCliente: '',
      numeroDocumento: '',
      almacenOrigen: ''
    });

    // Resetear arrays y variables de productos
    this.productosAlmacen = [];
    this.totalSolicitada = 0;
    this.totalDespachada = 0;
    this.diferencia = 0;

    // Resetear estados de habilitación
    this.esFechaDespachoHabilitada = false;
    this.esFormularioHabilitado = false;

    // Resetear estados del despacho
    this.despachoConfirmado = false;
    this.formularioModificado = false;

    // Resetear selecciones
    this.DespachoSeleccionado = null;
    this.selectedDespacho = null;
    this.filaSeleccionada = null;
    this.despachoSeleccionadoData = null;

    // Resetear estado inicial del formulario
    this.despachoFormInicial = null;

    // Resetear el servicio de validación
    this.formValidationService.resetearEstado();

    // Limpiar tabla de detalle
    if (this.detalleGridApi) {
      this.detalleGridApi.setGridOption('rowData', []);
    }

    console.log(' Formulario de despacho reseteado completamente');
  }

  filtrarPorFechas(event: any) {
    const range = event.detail?.value || event;
    if (range && range.start && range.end) {
      this.startDate = range.start;
      this.endDate = range.end;
      console.log('Filtrar desde:', range.start, 'hasta:', range.end);
    }
  }

  onAlmacenSeleccionado(almacen: any) {
    console.log('Almacén seleccionado:', almacen);

    if (almacen) {
      // Simular carga de productos del almacén
      // En caso real, esto vendría de un servicio
      this.productosAlmacen = [...this.productosDb];

      if (this.detalleGridApi) {
        this.detalleGridApi.setGridOption('rowData', this.productosAlmacen);
      }

      // Recalcular totales cuando se carga un almacén
      this.recalcularTotales();
    } else {
      this.productosAlmacen = [];
      if (this.detalleGridApi) {
        this.detalleGridApi.setGridOption('rowData', []);
      }
      // Limpiar totales si no hay almacén
      this.totalSolicitada = 0;
      this.totalDespachada = 0;
      this.diferencia = 0;
    }
  }

  /**
   * Maneja el cambio de tipo de despacho
   * Si NO es "venta", limpia los campos de cliente
   */
  onTipoDespachoChange(event: any) {
    const tipoSeleccionado = event.detail?.value || event;
    console.log('Tipo de despacho seleccionado:', tipoSeleccionado);

    // Habilitar fecha y otros campos cuando se selecciona un tipo de despacho
    if (tipoSeleccionado) {
      this.despachoForm.get('fechaDespacho')?.enable();
      this.esFechaDespachoHabilitada = true;
      this.esFormularioHabilitado = true;
    } else {
      this.despachoForm.get('fechaDespacho')?.disable();
      this.esFechaDespachoHabilitada = false;
      this.esFormularioHabilitado = false;
    }

    if (tipoSeleccionado !== 'venta') {
      // Limpiar campos de cliente si no es venta
      this.despachoForm.patchValue({
        documentoCliente: '',
        nombreCliente: '',
        tipoDocumento: 'ruc'
      });
    }
  }

  /**
   * Maneja el cambio de destino para Consumo Interno
   * Busca automáticamente el documento fuente y almacén de origen
   */
  onDestinoChange(event: any) {
    const destinoSeleccionado = event.detail?.value || event;
    console.log('Destino seleccionado:', destinoSeleccionado);

    if (destinoSeleccionado) {
      // Buscar el destino en la base de datos
      const destino = this.destinosConsumoInterno.find(d => d.id === destinoSeleccionado);

      if (destino) {
        // Llenar automáticamente el número de documento fuente y almacén de origen
        this.despachoForm.patchValue({
          numeroDocumentoFuente: destino.numeroDocumento,
          almacenOrigen: destino.almacenOrigen
        });

        console.log('Documento fuente:', destino.numeroDocumento, 'Almacén origen:', destino.almacenOrigen);
      }
    } else {
      // Limpiar campos si no hay destino seleccionado
      this.despachoForm.patchValue({
        numeroDocumentoFuente: '',
        almacenOrigen: ''
      });
    }
  }

  onDocSeleccionado(doc: any) {
    this.despachoForm.patchValue({
      numeroDocumentoFuente: doc.almacen_codigo
    })
  }

  /**
   * Maneja la selección de fecha de despacho
   */
  onFechaDespachoSelected(date: Date) {
    this.fechaDespacho = date;
    this.despachoForm.patchValue({
      fechaDespacho: date
    });
    console.log('Fecha de despacho seleccionada:', date);
  }

  /**
   * Busca el cliente por documento y llena automáticamente:
   * - Nombre del cliente
   * - Número de documento fuente
   * - Almacén de origen
   * - Carga la tabla de productos del almacén
   * Soporta búsqueda por DNI o RUC
   */
  onBuscarCliente() {
    const documentoIngresado = String(this.despachoForm.get('documentoproveedorinput')?.value || '').trim();

    if (!documentoIngresado) {
      console.log('No hay documento ingresado');
      this.toastService.warning('Por favor ingresa un documento');
      return;
    }

    console.log('Buscando con documento:', documentoIngresado);

    // Buscar el cliente en la base de datos simulada
    const clienteEncontrado = this.clientesRegistrados.find(
      c => c.documento === documentoIngresado || c.ruc === documentoIngresado
    );

    console.log('Cliente encontrado:', clienteEncontrado);

    if (clienteEncontrado) {
      // Obtener el RUC del cliente
      const rucCliente = clienteEncontrado.ruc;
      console.log('RUC del cliente:', rucCliente);

      // Buscar el almacén y documento fuente asociado al RUC
      const datosAlmacen = this.almacenesPorRuc.find(a => a.ruc === rucCliente);
      const documentoFuente = this.documentosFuente.find(d => d.ruc === rucCliente);

      console.log('Almacén:', datosAlmacen);
      console.log('Documento fuente:', documentoFuente);

      // Rellenar todos los campos automáticamente
      this.despachoForm.get('nombreCliente')?.setValue(clienteEncontrado.nombre, { emitEvent: false });
      this.despachoForm.get('numeroDocumentoFuente')?.setValue(documentoFuente?.numero || '', { emitEvent: false });
      this.despachoForm.get('almacenOrigen')?.setValue(datosAlmacen?.almacenOrigen || '', { emitEvent: false });

      // Marcar como tocado
      this.despachoForm.get('nombreCliente')?.markAsTouched();
      this.despachoForm.get('numeroDocumentoFuente')?.markAsTouched();
      this.despachoForm.get('almacenOrigen')?.markAsTouched();

      // Cargar productos específicos del cliente desde la base de datos
      const productosDelCliente = this.productosPorCliente[rucCliente as keyof typeof this.productosPorCliente];
      this.productosAlmacen = productosDelCliente ? [...productosDelCliente] : [...this.productosDb];

      if (this.detalleGridApi) {
        this.detalleGridApi.setGridOption('rowData', this.productosAlmacen);
      }

      // Recalcular totales después de cargar productos
      this.recalcularTotales();

    } else {
      console.log('Cliente NO encontrado');
      this.despachoForm.get('nombreCliente')?.setValue('', { emitEvent: false });
      this.despachoForm.get('numeroDocumentoFuente')?.setValue('', { emitEvent: false });
      this.despachoForm.get('almacenOrigen')?.setValue('', { emitEvent: false });
      this.productosAlmacen = [];
      if (this.detalleGridApi) {
        this.detalleGridApi.setGridOption('rowData', []);
      }
      this.totalSolicitada = 0;
      this.totalDespachada = 0;
      this.diferencia = 0;
      this.toastService.danger('Cliente no encontrado. Verifica el documento');
    }
  }

  /**
   * Método auxiliar para obtener el RUC de un cliente
   * Útil si necesitas extraer el RUC del cliente encontrado
   */
  obtenerRucCliente(documento: string): string {
    const cliente = this.clientesRegistrados.find(
      c => c.documento === documento || c.ruc === documento
    );
    return cliente?.ruc || '';
  }

  async modalverActualizaciones() {
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

    // Usar historial real si existe, sino mostrar datos por defecto
    const rowData = this.historialDespachos.length > 0 ? this.historialDespachos : [
      {
        fechaHora: '12/11/2025 14:40:22',
        usuario: 'Juan Pérez',
        accion: 'Crear',
        detalleCambio: 'Se a creado el documento REC-001'
      },
      {
        fechaHora: '12/11/2025 14:40:22',
        usuario: 'Carlos Zapata',
        accion: 'Edición del documento',
        detalleCambio: 'Se edito la descripción del documento'
      },
      {
        fechaHora: '08/11/2025 14:15:30',
        usuario: 'Jorgue Gomez',
        accion: 'Cambio de cuenta contable',
        detalleCambio: 'Se cambio la cuenta contable por la de 1010'
      },
    ];

    const documentoNombre = this.despachoForm.get('numeroDocumentoFuente')?.value || 'DESPACHO';

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones del documento ${documentoNombre}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

  async botonAnularDespacho() {

    const detallesEjemplo = [
      { label: 'Fecha de despacho', value: this.reformateoFecha(this.filaSeleccionada.fechaDespacho) },
      { label: 'Tipo de despacho', value: this.filaSeleccionada.tipoDespacho },
      { label: 'Destino', value: this.filaSeleccionada.destino },
      { label: 'Cantidad solicitada', value: this.filaSeleccionada.cantidadSolicitada },
      { label: 'Cantidad despachada', value: this.filaSeleccionada.cantidadDespachada },
      { label: 'Usuario ejecutor', value: this.filaSeleccionada.usuario },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Anular despacho',
        subtitulomodal: 'Detalle de anulación',
        detalles: detallesEjemplo,
        tituloTextarea: 'Motivo de anulación',
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Anular',
        colorBotonConfirmar: 'danger',
        motivoObligatorio: true,
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      this.anularDespacho()
    }
  }

  anularDespacho() {
    this.despachoConfirmado = false;
    this.limpiarFormulario();
    console.log('Despacho anulado');
    setTimeout(() => {
      this.toastService.success("¡Despacho anulado exitosamente!");
    }, 400);
  }



  generarComprobanteDespacho() {
    this.toastService.success('Comprobante de salida generado exitosamente');

    console.log('Comprobante de salida generado');
    // Aquí puedes agregar la lógica para generar el PDF o descargarlo
  }

  onProductoSeleccionado(producto: any) {
    console.log(' Producto seleccionado:', producto);

    // Verificar si el producto ya existe en la tabla
    const productoExistente = this.productosAlmacen.find(item => item.almacen_codigo === producto.almacen_codigo);
    if (productoExistente) {
      this.toastService.warning('El producto ya está agregado a la orden');
      // Limpiar el autocomplete incluso si el producto ya existe
      if (this.autocompleteProductos) {
        this.autocompleteProductos.clearSelection();
      }
      return;
    }
    // Cantidad por defecto
    const stock = 150;
    const cantidadS = 50;
    const cantidadE = 0;
    const diferencia = cantidadS - cantidadE;
    const porcentaje = 12;
    // Crear nuevo artículo para la tabla
    const nuevoArticulo = {
      almacen_codigo: producto.almacen_codigo,
      nombre: producto.descripcion,
      unidad: producto.medida,
      stock: stock,
      cantidadSolicitada: cantidadS,
      cantidadDespachada: cantidadE,
      diferencia: diferencia,
      porcentaje: porcentaje
    };
    // Agregar el producto a la tabla
    this.productosAlmacen = [...this.productosAlmacen, nuevoArticulo];

    // Actualizar la tabla
    if (this.detalleGridApi) {
      this.detalleGridApi.setGridOption('rowData', this.productosAlmacen);
    }
    // Actualizar totales
    this.actualizarTotales();

    // LIMPIAR el autocomplete después de agregar el producto
    setTimeout(() => {
      if (this.autocompleteProductos) {
        this.autocompleteProductos.clearSelection();
        console.log(' Autocomplete limpiado - listo para agregar otro producto');
      }
    }, 100);

    this.toastService.success('Producto agregado a la orden');
  }
  private actualizarTotales() {
    this.totalDespachada = this.productosAlmacen.reduce((sum, item) => sum + (item.cantidadD || 0), 0);
    this.totalSolicitada = this.productosAlmacen.reduce((sum, item) => sum + (item.cantidadS || 0), 0);
    this.diferencia = this.productosAlmacen.reduce((sum, item) => sum + (item.diferencia || 0), 0);

    console.log(' Totales - Subtotal:', this.totalDespachada.toFixed(2), 'Impuestos:', this.totalSolicitada.toFixed(2), 'Total:', this.diferencia.toFixed(2));
  }


  limpiarFormulario() {
    this.despachoForm.reset({
      tipoDespacho: '',
      documentoproveedor: 'ruc',
      documentoproveedorinput: '',
      nombreCliente: '',
      numeroDocumentoFuente: '',
      destino: '',
      almacenOrigen: '',
      fechaDespacho: { value: new Date(), disabled: true },
      cantidadSolicitada: '',
      cantidadDespachada: '',
      observaciones: '',
      estado: 'despachado'
    });
    this.productosAlmacen = [];
    this.totalSolicitada = 0;
    this.totalDespachada = 0;
    this.diferencia = 0;
    this.esFechaDespachoHabilitada = false;
    this.esFormularioHabilitado = false;
  }

  /**
   * Recalcula los totales cuando cambia la cantidad despachada
   */
  onCantidadDespachadaChanged(params: any) {
    const cantidadSolicitada = params.data.cantidadSolicitada;
    const cantidadDespachada = params.newValue || 0;
    const diferencia = cantidadSolicitada - cantidadDespachada;
    const porcentaje = cantidadSolicitada > 0 ? ((diferencia / cantidadSolicitada) * 100).toFixed(2) : 0;

    // Actualizar la fila con los nuevos valores
    params.data.diferencia = diferencia;
    params.data.porcentaje = porcentaje + '%';

    // Refrescar las celdas de diferencia y porcentaje
    params.api.refreshCells({
      rowNodes: [params.node],
      columns: ['diferencia', 'porcentaje'],
      force: true
    });

    // Recalcular totales generales
    this.recalcularTotales();
  }

  /**
   * Recalcula los totales solicitada, despachada y diferencia
   */
  recalcularTotales() {
    this.totalSolicitada = this.productosAlmacen.reduce((sum, item) => sum + (item.cantidadSolicitada || 0), 0);
    this.totalDespachada = this.productosAlmacen.reduce((sum, item) => sum + (item.cantidadDespachada || 0), 0);
    this.diferencia = this.totalSolicitada - this.totalDespachada;
  }

  public async modaleliminar() {
    // Ejemplo de datos que puedes personalizar
    const detallesEjemplo: DetalleItem[] = [
      { label: 'Código:', value: 'ALM001' },
      { label: 'Nombre de almacén:', value: 'Almacén Central Lima' },
      { label: 'Dirección:', value: 'Jirón Enrique del Falcao 879, Santa Magnolia - Piura - Piura' },
      { label: 'Capacidad:', value: '150m2' },
      { label: 'Usuario ejecutor:', value: 'Eduardo Jiménez López' }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Eliminar almacén',
        subtitulomodal: 'Detalle de eliminación:',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo de eliminación',
        placeholderTextarea: 'Describe el motivo de la eliminación',
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Eliminar',
        colorBotonConfirmar: 'danger'
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      console.log('Almacén eliminado. Motivo:', data.motivo);
      // Aquí puedes agregar la lógica para eliminar el almacén
    }
  }

  /**
   * Muestra modal de confirmación cuando hay cambios sin guardar
   */
  private async mostrarModalConfirmacion(): Promise<boolean> {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Confirmar cambios',
        title: '¿Seguro que quieres continuar sin guardar la información?',
        message: 'Si sales ahora, perderás la información ingresada',
        btnOkTxt: 'Continuar',
        btnCancelTxt: 'Cancelar',
      }
    });

    await modal.present();
    const { data } = await modal.onWillDismiss();

    return data === true;
  }

}
