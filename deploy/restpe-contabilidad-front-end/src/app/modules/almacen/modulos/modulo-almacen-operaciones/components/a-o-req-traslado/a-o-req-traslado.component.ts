import {Component, OnInit, OnDestroy, ViewChild, inject, effect} from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalController } from '@ionic/angular';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { BotonAccionesComponent } from 'src/app/ui/boton-acciones/boton-acciones.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { Observable, Subject } from 'rxjs';
import { takeUntil } from 'rxjs/operators';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faChevronsLeft, faChevronsRight, faCirclePlus, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

// Facades
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { ReqTrasladoEntity, ReqTrasladoArticuloEntity } from '../../../../domain/models/req-traslado.entity';
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';

@Component({
  selector: 'app-a-o-req-traslado',
  templateUrl: './a-o-req-traslado.component.html',
  styleUrls: ['./a-o-req-traslado.component.scss'],
  standalone: false,
})
export class AoReqTrasladoComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // Facades
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);
  private readonly simulation = inject(SimulationService);

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.loadingReqTraslados;


  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasRotateRight = faRotateRight;



  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private _mostrartabla = true;
  
  private gridApi!: GridApi;
  private gridApiSucursales!: GridApi;
  @ViewChild('autocompleteProductos') autocompleteProductos: any;
  requerimientoForm!: FormGroup;

  // Productos para el autocomplete
  productos: any[] = [];
  
  totalSolicitada: number = 0;
  requerimientoAnulado: boolean = false;

  // Variables para validación de formulario
  private requerimientoFormInicial: any = null;
  private formularioModificado: boolean = false;
  private requerimientoSeleccionadoData: any = null;
  filaSeleccionada: any = null;
  
  // Variable para persistir la selección cuando se oculta/muestra la tabla
  private requerimientoSeleccionadoId: string | null = null;
  
  // Para desuscribirse de observables
  private destroy$ = new Subject<void>();
  
  // Variable reactiva para validar si puede crear requerimiento
  formularioValido: boolean = false;
  
  // Texto del botón de confirmar
  btnTexto: string = 'Registrar';

  frameworkComponents = {
    BotonAccionesComponent: BotonAccionesComponent
  };

  gridOptions = {
    context: {
      componentParent: this,
    },
    frameworkComponents: this.frameworkComponents
  };

  // Array de requerimientos (para compatibilidad con lógica interna)
  datosRequerimientos: ReqTrasladoEntity[] = [];

  origen = [
    { id: 'Almacén central', nombre: 'Almacén central' },
    { id: 'Almacén norte',   nombre: 'Almacén norte' },
    { id: 'Almacén sur',     nombre: 'Almacén sur' },
    { id: 'Almacén este',    nombre: 'Almacén este' },
    { id: 'Almacén oeste',   nombre: 'Almacén oeste' }
  ];
  
  destino = [
    { id: 'Almacén central', nombre: 'Almacén central' },
    { id: 'Almacén norte',   nombre: 'Almacén norte' },
    { id: 'Almacén sur',     nombre: 'Almacén sur' },
    { id: 'Almacén este',    nombre: 'Almacén este' },
    { id: 'Almacén oeste',   nombre: 'Almacén oeste' }
  ];

  centrocostos = [
    { id: 'Administración',    nombre: 'Administración' },
    { id: 'Ventas',            nombre: 'Ventas' },
    { id: 'Producción',        nombre: 'Producción' },
    { id: 'Logística',         nombre: 'Logística' },
    { id: 'Recursos Humanos',  nombre: 'Recursos Humanos' }
  ];

  // Array externo con datos completos de requerimientos
  // datosRequerimientos se carga desde el facade (ver effect en constructor)

  sucursalesColDefs: ColDef[] = [
    { field: 'req_traslado_art_codigo', headerName: 'Código de artículo', width: 120 },
    { field: 'req_traslado_art_descripcion', headerName: 'Descripción', flex: 1, minWidth: 200 },
    { field: 'req_traslado_art_unidad_medida', headerName: 'Unidad de medida', width: 150 },
    { 
      field: 'req_traslado_art_stock_disponible', 
      headerName: 'Stock disponible', 
      width: 130,
      headerClass: 'derechaencabezado',
      cellStyle: { color: '#9CA3AF', textAlign: 'right', display: 'flex', justifyContent: 'flex-end', alignItems: 'center' }
    },
    { 
      field: 'req_traslado_art_cantidad_solicitada', 
      headerName: 'Cantidad solicitada', 
      width: 130,
      headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'flex-end', alignItems: 'center' }
    },
    { 
      field: 'acciones', 
      headerName: 'Acciones', 
      width: 100,
      headerClass:'centrarencabezado', 
      cellRenderer: BotonAccionesComponent,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
  ];

  sucursalesRowData: ReqTrasladoArticuloEntity[] = [];

  columnTypes = {
    default: {
      resizable: false,
      sortable: false,
      filter: false,
      floatingFilter: false,
    }
  };

  colDefs: ColDef[] = [
    { field: 'req_traslado_nro', headerName: 'N° requerimiento', width: 140 },
    { field: 'req_traslado_fecha_registro', headerName: 'Fecha registro', width: 110 },
    { field: 'req_traslado_origen', headerName: 'Origen', width: 140, filter: true },
    { field: 'req_traslado_destino', headerName: 'Destino', width: 140, filter: true },
    { field: 'req_traslado_prioridad', headerName: 'Prioridad', width: 110 },
    { field: 'req_traslado_centro_costo', headerName: 'Centro de costo', flex: 1, minWidth: 200, filter: true },
    { field: 'req_traslado_motivo', headerName: 'Motivo traslado', width: 150 },
    { 
      field: 'req_traslado_estado', 
      headerName: 'Estado', 
      filter: true, 
      width: 110,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        let color = '';
        if (params.value === 'Pendiente') {
          color = 'bg-[#F5F5F5] text-[#363636]';
        } else if (params.value === 'Aprobado') {
          color = 'bg-[#DCFDE7] text-[#16A34A]';
        } else if (params.value === 'Anulado') {
          color = 'bg-[#FEE2E2] text-[#DC2626]';
        }
        return `<span class="badge-table ${color}">${params.value}</span>`;
      }
    }
  ];

  rowData: ReqTrasladoEntity[] = [];

  localeText = {
    page: 'Página',
    of: 'de',
    to: 'a',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    noRowsToShow: 'No hay filas para mostrar',
    loadingOoo: 'Cargando...',
  };

  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController,
    private formValidationService: FormValidationService
  ) { 
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    effect(() => {
      const datos = this.almacenFacade.reqTraslados();
      if (datos && datos.length > 0) {
        const isNewFormat = datos[0] && 'req_traslado_id' in datos[0];
        if (isNewFormat) {
          this.datosRequerimientos = datos;
          this.rowData = [...datos];
          if (this.gridApi) {
            this.gridApi.setGridOption('rowData', this.rowData);
          }
        }
      }
    });

    // Alimentar el buscador de artículos del detalle con los productos reales
    // del backend (consultaArticulos). Si aún no hay datos, conserva el seed de
    // simulación cargado en ngOnInit.
    effect(() => {
      const articulos = this.almacenFacade.consultaArticulos();
      if (articulos && articulos.length > 0) {
        this.productos = articulos.map((a: any) => ({
          ...a,
          almacen_codigo: a.almacen_codigo ?? a.codigo,
          descripcion: a.nombre ?? a.descripcion ?? a.producto,
          unidadMedida: a.unidad || a.medida || 'UND',
          stockActual: a.stockActual ?? 0,
        }));
      }
    });
  }

  ngOnInit() {
    this.catalogosFacade.inicializarCatalogos();
    this.almacenFacade.cargarReqTraslados();
    // Cargar artículos reales del backend para el buscador del detalle
    this.almacenFacade.cargarConsultaArticulos();
    this.initForm();
    this.cargarProductosDesdeSimulacion();
  }

  ngOnDestroy() {
    this.destroy$.next();
    this.destroy$.complete();
    // Limpiar el tracking del formulario
    this.formValidationService.limpiarFormulario();
  }

  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  tieneModificaciones(): boolean {
    return this.formValidationService.tieneModificaciones();
  }

  initForm() {
    this.requerimientoForm = this.formBuilder.group({
      nroRequerimiento: [''],
      motivoTrastlado: ['', Validators.required],
      origen: ['', Validators.required],
      centroDeCosto: ['', Validators.required],
      destino: ['', Validators.required],
      prioridad: ['', Validators.required],
      observaciones: ['']
    });

    // Inicializar el servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.requerimientoForm);

    // Guardar estado inicial del formulario
    this.requerimientoFormInicial = this.requerimientoForm.value;

    // Suscribirse a cambios en el formulario (se ejecuta en tiempo real)
    this.requerimientoForm.valueChanges
      .pipe(takeUntil(this.destroy$))
      .subscribe(() => {
        this.verificarCambios();
        this.actualizarEstadoBoton(); // Actualizar el estado del botón
      });
  }

  get mostrartabla(): boolean {
    return this._mostrartabla;
  }
  
  set mostrartabla(value: boolean) {
    this._mostrartabla = value;
    
    // Cuando se muestra la tabla nuevamente, restaurar la selección
    // if (value && this.requerimientoSeleccionadoId && this.gridApi) {
    //   setTimeout(() => {
    //     this.gridApi.deselectAll();
    //     this.gridApi.forEachNode((node) => {
    //       if (node.data.id === this.requerimientoSeleccionadoId) {
    //         node.setSelected(true);
    //       }
    //     });
    //   }, 100);
    // }
  }

  /**
   * Verifica si el formulario ha sido modificado
   * Solo valida cambios en el campo 'observaciones'
   */
  private verificarCambios() {
    if (!this.requerimientoFormInicial) {
      this.formularioModificado = false;
      return;
    }
    
    const valorActual = this.requerimientoForm.value;
    // Solo detectar cambios en el campo observaciones
    this.formularioModificado = 
      this.requerimientoFormInicial.observaciones !== valorActual.observaciones;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    
    // Restaurar la selección cuando la tabla se muestra de nuevo
    if (this.requerimientoSeleccionadoId && this.requerimientoSeleccionadoData) {
      setTimeout(() => {
        this.gridApi.deselectAll();
        this.gridApi.forEachNode((node) => {
          if (node.data.req_traslado_id === this.requerimientoSeleccionadoId) {
            node.setSelected(true);
          }
        });
      }, 150);
    }
  }

  async onCellClicked(event: any) {
    const data = event.data;
    if (!data) { return; }

    // Prevenir selección automática
    event.node.setSelected(true);

    // Validar si hay cambios sin guardar
    const puede = await this.formValidationService.validarCambios();

    if (!puede) {
      // Si cancela, restaurar selección anterior
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
          if (this.requerimientoSeleccionadoData) {
            this.gridApi.forEachNode(node => {
              if (node.data === this.requerimientoSeleccionadoData) node.setSelected(true);
            });
          }
        }
      }, 0);
      return;
    }

    this.cargarDatosRequerimiento(data, event.node);
  }

  private cargarDatosRequerimiento(data: any, node?: any): void {
    // Guardar referencia para restaurar selección
    this.requerimientoSeleccionadoData = data;
    this.requerimientoSeleccionadoId = data.req_traslado_id;
    this.filaSeleccionada = data;

    // Seleccionar fila en el grid
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    if (node) {
      node.setSelected(true);
    } else if (this.gridApi) {
      this.gridApi.forEachNode(n => { if (n.data === data) n.setSelected(true); });
    }

    // Habilitar formulario antes de rellenar
    this.requerimientoForm.enable();

    this.requerimientoForm.patchValue({
      nroRequerimiento: data.req_traslado_nro,
      motivoTrastlado:  data.req_traslado_motivo,
      origen:           data.req_traslado_origen,
      destino:          data.req_traslado_destino,
      prioridad:        data.req_traslado_prioridad,
      centroDeCosto:    data.req_traslado_centro_costo,
      observaciones:    data.req_traslado_observaciones || ''
    });

    // Cargar artículos del requerimiento
    this.sucursalesRowData = data.req_traslado_articulos ? [...data.req_traslado_articulos] : [];

    // Actualizar grid de artículos
    if (this.gridApiSucursales) {
      this.gridApiSucursales.setGridOption('rowData', this.sucursalesRowData);
    }

    // Calcular total
    this.totalSolicitada = this.sucursalesRowData.reduce(
      (sum, item) => sum + (item.req_traslado_art_cantidad_solicitada || 0), 0
    );

    // Verificar si el requerimiento está anulado
    this.requerimientoAnulado = data.req_traslado_estado === 'Anulado';
    if (this.requerimientoAnulado) {
      this.requerimientoForm.disable();
    }

    // Actualizar estado inicial y resetear tracking
    this.requerimientoFormInicial = this.requerimientoForm.value;
    this.formularioModificado = false;
    this.actualizarEstadoBoton();
    this.formValidationService.resetearEstado();

    // Cambiar texto del botón
    this.btnTexto = 'Confirmar requerimiento';
  }

  onBtReset() {
    this.almacenFacade.cargarReqTraslados();
  }

  onSucursalesGridReady(params: GridReadyEvent) {
    this.gridApiSucursales = params.api;
  }

  cargarProductosDesdeSimulacion() {
    const productosLS = this.simulation.list('producto') || [];
    this.productos = productosLS.map((item: any) => ({
      almacen_codigo: item.almacen_codigo,
      descripcion: item.producto || item.descripcion,
      unidadMedida: item.medida || 'UND',
      stockActual: item.stockActual || 0,
      ...item
    }));
  }

  onProductoSeleccionado(producto: any) {
    const yaExiste = this.sucursalesRowData.find(
      item => item.req_traslado_art_codigo === (producto.almacen_codigo || producto.codigo)
    );
    if (yaExiste) {
      this.toastService.warning('El producto ya está en la lista');
      if (this.autocompleteProductos) { this.autocompleteProductos.clearSelection(); }
      return;
    }

    const nuevoArticulo: ReqTrasladoArticuloEntity = {
      req_traslado_art_codigo:             producto.almacen_codigo || producto.codigo,
      req_traslado_art_descripcion:        producto.descripcion || producto.producto,
      req_traslado_art_unidad_medida:      producto.unidadMedida || producto.medida || 'UND',
      req_traslado_art_stock_disponible:   producto.stockActual || 0,
      req_traslado_art_cantidad_solicitada: 1
    };

    this.sucursalesRowData = [...this.sucursalesRowData, nuevoArticulo];
    this.totalSolicitada = this.sucursalesRowData.reduce(
      (sum, item) => sum + (item.req_traslado_art_cantidad_solicitada || 0), 0
    );

    if (this.gridApiSucursales) {
      this.gridApiSucursales.setGridOption('rowData', this.sucursalesRowData);
    }

    setTimeout(() => {
      if (this.autocompleteProductos) { this.autocompleteProductos.clearSelection(); }
    }, 100);

    this.toastService.success('Artículo agregado al requerimiento');
  }

  onOrigenSeleccionado(evento: any) {
    console.log('Origen seleccionado:', evento);
    if (evento && evento.nombre) {
      this.requerimientoForm.patchValue({ origen: evento.nombre });
    }
  }

  onDestinoSeleccionado(evento: any) {
    console.log('Destino seleccionado:', evento);
    if (evento && evento.nombre) {
      this.requerimientoForm.patchValue({ destino: evento.nombre });
    }
  }

  onCentroCostoSeleccionado(evento: any) {
    console.log('Centro de costo seleccionado:', evento);
    if (evento && evento.nombre) {
      this.requerimientoForm.patchValue({ centroDeCosto: evento.nombre });
    }
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

    const rowData = [
      {
        fechaHora: '20/11/2025 16:01:44',
        usuario: 'Ana Pérez',
        accion: 'Actualización de estado',
        detalleCambio: 'Estado: De "Pendiente" a "Aprobado".'
      },
      {
        fechaHora: '12/11/2025 14:40:22',
        usuario: 'Jorge Gómez',
        accion: 'Edición del requerimiento',
        detalleCambio: 'Centro de costo actualizado a Administración.'
      }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });
    
    await modal.present();
  }

  /**
   * Maneja la acción de crear un nuevo requerimiento
   * Limpia el formulario y prepara para crear uno nuevo
   */
  async botonNuevoRequerimiento() {
    // Validar cambios antes de limpiar
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
    
    // Deseleccionar fila en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
      this.gridApi.refreshCells({ force: true });
    }

    // Limpiar formulario y preparar para nuevo requerimiento
    this.requerimientoSeleccionadoData = null;
    this.requerimientoAnulado = false;
    this.filaSeleccionada = null;
    
    // Habilitar formulario
    this.requerimientoForm.enable();
    
    // Resetear formulario
    this.requerimientoForm.reset({
      nroRequerimiento: '',
      motivoTrastlado: '',
      origen: '',
      destino: '',
      prioridad: '',
      centroDeCosto: '',
      observaciones: ''
    });
    
    // Limpiar tabla de artículos
    this.sucursalesRowData = [];
    this.totalSolicitada = 0;
    
    // Actualizar estado inicial
    this.requerimientoFormInicial = this.requerimientoForm.value;
    this.formularioModificado = false;
    this.actualizarEstadoBoton();
    
    // Cambiar texto del botón a 'Registrar'
    this.btnTexto = 'Registrar';
    
    // Resetear el servicio de validación
    this.formValidationService.resetearEstado();
  }

  /**
   * Actualiza el estado del botón en tiempo real
   */
  private actualizarEstadoBoton(): void {
    const formData = this.requerimientoForm.value;
    
    // Validar que todos los campos obligatorios estén llenos y haya artículos
    this.formularioValido = 
      formData.origen && 
      formData.destino && 
      formData.prioridad && 
      formData.centroDeCosto && 
      formData.motivoTrastlado &&
      this.sucursalesRowData.length > 0;
  }

  /**
   * Verifica si el formulario está completo y listo para crear requerimiento
   */
  puedeCrearRequerimiento(): boolean {
    return this.formularioValido;
  }

  /**
   * Confirma y guarda el requerimiento (nuevo o editado)
   */
  confirmarRequerimiento() {
    const formData = this.requerimientoForm.getRawValue();
    
    // Validar campos requeridos
    if (this.requerimientoForm.invalid) {
      this.toastService.warning('Por favor, complete todos los campos requeridos');
      return;
    }

    // Validar que tenga artículos
    if (this.sucursalesRowData.length === 0) {
      this.toastService.warning('Debe agregar al menos un artículo al requerimiento');
      return;
    }

    // Verificar si es nuevo o edición
    const esNuevo = !this.requerimientoSeleccionadoData;

    if (esNuevo) {
      // CREAR NUEVO REQUERIMIENTO

      // Generar nuevo número de requerimiento
      const ultimoNumero = this.datosRequerimientos.length + 1;
      const nuevoNumero = `RQT-${String(ultimoNumero).padStart(3, '0')}-2025`;

      // Obtener fecha actual
      const fechaActual = new Date();
      const fechaRegistro = `${String(fechaActual.getDate()).padStart(2, '0')}/${String(fechaActual.getMonth() + 1).padStart(2, '0')}/${fechaActual.getFullYear()}`;

      // Crear objeto del nuevo requerimiento con snake_case
      const nuevoRequerimiento: ReqTrasladoEntity = {
        req_traslado_id: nuevoNumero,
        req_traslado_nro: nuevoNumero,
        req_traslado_fecha_registro: fechaRegistro,
        req_traslado_origen: formData.origen,
        req_traslado_destino: formData.destino,
        req_traslado_prioridad: formData.prioridad,
        req_traslado_centro_costo: formData.centroDeCosto,
        req_traslado_motivo: formData.motivoTrastlado,
        req_traslado_estado: 'Pendiente',
        req_traslado_observaciones: formData.observaciones || '',
        req_traslado_articulos: [...this.sucursalesRowData]
      };

      // Agregar a la lista de datos
      this.datosRequerimientos.push(nuevoRequerimiento);

      // Actualizar tabla principal
      this.rowData = [...this.datosRequerimientos];

      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }

      console.log('Nuevo requerimiento creado:', nuevoRequerimiento);
      this.toastService.success(`¡Requerimiento ${nuevoNumero} creado exitosamente!`);

    } else {
      // EDITAR REQUERIMIENTO EXISTENTE

      // Buscar el índice del requerimiento a actualizar
      const indice = this.datosRequerimientos.findIndex(
        req => req.req_traslado_id === this.requerimientoSeleccionadoData.req_traslado_id
      );

      if (indice !== -1) {
        // Actualizar solo los campos modificables
        this.datosRequerimientos[indice] = {
          ...this.datosRequerimientos[indice],
          req_traslado_articulos: [...this.sucursalesRowData]
        };
        
        // Actualizar tabla principal
        this.rowData = [...this.datosRequerimientos];
        
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', this.rowData);
        }
        
        console.log('Requerimiento actualizado:', this.datosRequerimientos[indice]);
        this.toastService.success('¡Requerimiento actualizado exitosamente!');
      }
    }
    
    // Resetear tracking de cambios después de guardar
    this.requerimientoFormInicial = this.requerimientoForm.value;
    this.formularioModificado = false;
    
    // Limpiar formulario después de guardar
    this.limpiarFormulario();
    this.actualizarEstadoBoton();
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

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    console.log('Filtrar desde:', range.start, 'hasta:', range.end);
  }

  /**
   * Limpia el formulario y resetea el estado
   */
  limpiarFormulario() {
    this.requerimientoForm.reset();
    this.sucursalesRowData = [];
    this.totalSolicitada = 0;
    this.requerimientoSeleccionadoData = null;
    this.requerimientoSeleccionadoId = null;
    this.filaSeleccionada = null;
    this.requerimientoAnulado = false;
    this.requerimientoFormInicial = this.requerimientoForm.value;
    this.formularioModificado = false;
    this.btnTexto = 'Registrar';

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    if (this.gridApiSucursales) {
      this.gridApiSucursales.setGridOption('rowData', []);
    }
  }
}