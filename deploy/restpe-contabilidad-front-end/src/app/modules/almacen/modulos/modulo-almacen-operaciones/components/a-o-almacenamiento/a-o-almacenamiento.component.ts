import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import {ChangeDetectorRef, Component, OnInit, OnDestroy, inject} from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalController, ViewWillEnter } from '@ionic/angular';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-a-o-almacenamiento',
  templateUrl: './a-o-almacenamiento.component.html',
  styleUrls: ['./a-o-almacenamiento.component.scss'],
  standalone: false,
})
export class AoAlmacenamientoComponent implements OnInit, OnDestroy, CanComponentDeactivate, ViewWillEnter {
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



  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  mostrartabla = true;
  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'a-o-almacenamiento'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }
  private sucursalesGridApi!: GridApi;
  recepcionForm!: FormGroup;
  filaSeleccionada:any=null;
  private almacenamientoSeleccionadaData: any = null;

  // Control de totales
  totalSolicitada: number = 0;
  totalRecibida: number = 0;
  diferencia: number = 0;
  ordenSeleccionada: boolean = false;

  // Array de órdenes de compra aprobadas para el autocomplete (se carga desde localStorage)
  activos: any[] = [];

  //   Inyección del facade de catálogos
  readonly sucursales = this.catalogosFacade.sucursalesActivas;

  sucursalesColDefs: ColDef[] = [
    { 
      headerCheckboxSelection: (params) => !this.filaSeleccionada,
      checkboxSelection: (params) => !this.filaSeleccionada,
      width: 40,
      headerClass: 'centrarencabezadocheck',
    },
    { field: 'codigoArticulo', headerName: 'Código', flex: 1, minWidth: 200 },
    { field: 'descripcion', headerName: 'Descripción', width: 150 },
    { field: 'unidadMedida', headerName: 'Unidad', width: 120 },
    { field: 'cantidadSolicitada', headerName: 'Cantidad solicitada', width: 150, editable: false,},
    { field: 'cantidadEntregada', headerName: 'Cantidad entregada', width: 150, 
      editable: (params) => !this.filaSeleccionada,
      cellEditor: 'agNumberCellEditor',
      valueParser: (params: any) => Number(params.newValue),
    },
    { 
      field: 'diferencia', 
      headerName: 'Diferencia', 
      width: 100, 
      editable: false,
    },
    { field: 'motivoDiferencia', headerName: 'Motivo', width: 150, editable: true }
  ];

  sucursalesRowData: any[] = [];

  columnTypes = {
    default: {
      resizable: false,
      sortable: false,
      filter: false,
      floatingFilter: false,
    }
  };

  // Columnas actualizadas según la imagen
  colDefs: ColDef[] = [
    { field: 'recepcion_fecha', headerName: 'Fecha recepción', width: 110 },
    { field: 'recepcion_orden_compra', headerName: 'Orden de compra', width: 120 },
    { field: 'recepcion_proveedor', headerName: 'Proveedor', flex:1, minWidth: 150, filter: true },
    { field: 'recepcion_cantidad_solicitada', headerName: 'Cantidad solicitada', width: 120 },
    { field: 'recepcion_cantidad_entregada', headerName: 'Cantidad entregada', width: 120 },
    { field: 'recepcion_diferencia', headerName: 'Diferencia', width: 90 },
    { field: 'recepcion_almacen_destino', headerName: 'Almacén destino', width: 170, filter: true },
    { field: 'recepcion_nro_factura', headerName: 'N° factura', width: 70 },
    { field: 'recepcion_nro_guia', headerName: 'N° guía', width: 70 },
    { field: 'recepcion_usuario', headerName: 'Usuario', width: 150 },
    { 
      field: 'recepcion_estado', 
      headerName: 'Estado', filter: true, 
      width: 100,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        let color = '';
        if (params.value === 'Total') {
          color = 'bg-[#DCFDE7] text-[#16A34A]';
        } else if (params.value === 'Parcial') {
          color = 'bg-[#FFF0BF] text-[#F2A626]';
        } else {
          color = 'bg-[#FFE5E5] text-[#D32F2F]';
        }
        return `<span class="badge-table ${color}">${params.value}</span>`;
      }
    }
  ];

  // Datos se cargan desde el store (Clean Architecture)

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
    private formValidationService: FormValidationService,
    private simulation: SimulationService,
    private cdr: ChangeDetectorRef
  ) { 
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  ngOnInit() {
    this.initForm();
    
    // Inicializar el servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.recepcionForm);
    
    // Cargar órdenes de compra aprobadas para el autocomplete
    this.cargarOrdenesAprobadasDesdeSimulacion();

    //   Inicializar catálogos compartidos
    this.catalogosFacade.inicializarCatalogos();
  }

  ionViewWillEnter() {
    this.almacenFacade.cargarRecepcionesAlmacenamiento();
  }

  ngOnDestroy() {
    // Limpiar el tracking del formulario
    this.formValidationService.limpiarFormulario();
  }

  tieneModificaciones(): boolean {
    return this.formValidationService.tieneModificaciones();
  }
  
  /**
   * Obtener la fecha de hoy en formato dd/mm/yyyy
   */
  getFechaHoy(): string {
    const today = new Date();
    const day = String(today.getDate()).padStart(2, '0');
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const year = today.getFullYear();
    return `${day}/${month}/${year}`;
  }
  
  /**
   * Cargar órdenes de compra aprobadas desde localStorage
   */
  cargarOrdenesAprobadasDesdeSimulacion() {
    const ordenesLS = this.simulation.list('ordenCompra') || [];
    console.log('  Órdenes de compra en localStorage:', ordenesLS);
    
    // Obtener órdenes ya recepcionadas
    const recepcionesExistentes = this.simulation.list('recepcionAlmacen') || [];
    const ordenesYaRecepcionadas = recepcionesExistentes.map((r: any) => r.ordenCompra);
    console.log('  Órdenes ya recepcionadas:', ordenesYaRecepcionadas);
    
    // Filtrar solo las órdenes con estado "Aprobado" que NO han sido recepcionadas
    const ordenesAprobadas = ordenesLS.filter((orden: any) => 
      orden.estado === 'Aprobado' && !ordenesYaRecepcionadas.includes(orden.numeroOrden)
    );
    console.log('Órdenes aprobadas disponibles:', ordenesAprobadas.length);
    
    // Mapear a formato del autocomplete y preparar los artículos
    this.activos = ordenesAprobadas.map((orden: any) => ({
      id: orden.numeroOrden,
      nombre: orden.numeroOrden,
      razonSocial: 'Restaurant.pe SAC', // Puede venir de la orden
      ruc: orden.ruc || '20123456789',
      direccionFiscal: orden.direccionFiscal || '',
      emitidoPor: orden.emitidoPor || 'Usuario Admin',
      fechaEntrega: orden.fechaentrega || orden.fechaEntrega || '',
      localEntrega: orden.sucursal || '',
      direccionEntrega: orden.direccionEntrega || '',
      proveedor: orden.proveedor || '',
      moneda: orden.moneda || 'Soles',
      tipoCambio: parseFloat(orden.tipoCambio) || 1.00,
      condicionPago: orden.condicionPago || '',
      nroFactura: '',
      nroGuia: '',
      estado: orden.estado,
      cantidadTotal: 0, // Se calculará desde los artículos
      articulos: (orden.articulos || []).map((art: any) => ({
        codigoArticulo: art.almacen_codigo,
        descripcion: art.descripcion,
        unidadMedida: art.unidad,
        cantidadSolicitada: art.cantidad || 0,
        cantidadEntregada: 0,
        diferencia: art.cantidad || 0,
        motivoDiferencia: '-'
      }))
    }));
    
    console.log('🔧 Órdenes aprobadas mapeadas:', this.activos.length);
  }

  initForm() {
    this.recepcionForm = this.formBuilder.group({
      ordenCompra: ['', Validators.required],
      razonSocial: [{ value: '', disabled: true }],
      ruc: [{ value: '', disabled: true }],
      direccionFiscal: [{ value: '', disabled: true }],
      emitidoPor: [{ value: '', disabled: true }],
      fechaEntrega: [{ value: '', disabled: true }],
      localEntrega: [{ value: '', disabled: true }],
      direccionEntrega: [{ value: '', disabled: true }],
      proveedor: [{ value: '', disabled: true }],
      moneda: [{ value: '', disabled: true }],
      tipoCambio: [{ value: '', disabled: true }],
      condicionPago: [{ value: '', disabled: true }],
      nroFactura: [''],
      nroGuia: [''],
      estado: [{ value: '', disabled: true }]
    });
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    if (this.almacenamientoSeleccionadaData) {
      setTimeout(() => {
        this.gridApi.forEachNode(node => {
          if (node.data === this.almacenamientoSeleccionadaData) {
            node.setSelected(true);
            this.filaSeleccionada = node.data;
          }
        });
      }, 150);
    }
  }

  async onCellClicked(event: any) {
    const data = event.data;
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
    
    // Prevenir selección automática de AG-Grid
    event.node.setSelected(false);

    // Guardar referencia para restaurar selección tras ocultar/mostrar tabla
    this.almacenamientoSeleccionadaData = data;

    // Cargar datos del registro seleccionado (solo lectura, no hay modal)
    this.cargarDatosRegistro(data, event.node);
  }
  
  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: any, node?: any): void {
    this.filaSeleccionada = data;
    this.gridApi.deselectAll();
    this.formValidationService.resetearEstado();

    // Seleccionar el nodo en AG-Grid
    if (node) {
      node.setSelected(true);
    } else {
      this.gridApi.forEachNode((n) => { if (n.data === data) n.setSelected(true); });
    }

    // Resolver número de orden (JSON usa prefijo recepcion_)
    const numeroOrden: string = data.recepcion_orden_compra ?? data.ordenCompra ?? '';

    // Agregar al array activos si no está para que el autocomplete muestre el valor
    if (numeroOrden && !this.activos.some(a => a.id === numeroOrden)) {
      this.activos = [...this.activos, { id: numeroOrden, nombre: numeroOrden }];
    }

    // Forzar CD para que el @Input items del autocomplete reciba el array actualizado
    // ANTES de que patchValue dispare writeValue en el mismo tick
    this.cdr.detectChanges();

    // Buscar datos complementarios en localStorage
    const todasLasOrdenes = this.simulation.list('ordenCompra') || [];
    const ordenLS = todasLasOrdenes.find((o: any) => o.numeroOrden === numeroOrden) ?? null;

    // Habilitar TODOS los controles antes dea patchValue para que los valores se reflejen
    Object.keys(this.recepcionForm.controls).forEach(key =>
      this.recepcionForm.get(key)?.enable({ emitEvent: false })
    );

    // Rellenar formulario combinando datos del JSON + localStorage
    this.recepcionForm.patchValue({
      ordenCompra:      numeroOrden,
      razonSocial:      ordenLS?.proveedor             ?? data.recepcion_proveedor      ?? '',
      ruc:              ordenLS?.documentoproveedorinput ?? data.recepcion_ruc           ?? '',
      direccionFiscal:  ordenLS?.direccionFiscal        ?? '',
      emitidoPor:       ordenLS?.emitidoPor             ?? data.recepcion_usuario        ?? '',
      fechaEntrega:     ordenLS?.fechaEntrega           ?? data.recepcion_fecha          ?? '',
      localEntrega:     ordenLS?.localentrega           ?? data.recepcion_almacen_destino ?? '',
      direccionEntrega: ordenLS?.direccionEntrega       ?? '',
      proveedor:        data.recepcion_proveedor        ?? ordenLS?.proveedor            ?? '',
      moneda:           data.recepcion_moneda           ?? ordenLS?.moneda               ?? '',
      tipoCambio:       ordenLS?.tipoCambio             ?? '',
      condicionPago:    ordenLS?.condicionPago          ?? '',
      nroFactura:       data.recepcion_nro_factura      ?? data.nroFactura               ?? '',
      nroGuia:          data.recepcion_nro_guia         ?? data.nroGuia                  ?? '',
      estado:           data.recepcion_estado           ?? data.estado                   ?? '',
    });

    // Volver a deshabilitar los campos de solo lectura
    const camposReadonly = ['razonSocial','ruc','direccionFiscal','emitidoPor',
      'fechaEntrega','localEntrega','direccionEntrega','proveedor','moneda',
      'tipoCambio','condicionPago','estado'];
    camposReadonly.forEach(key =>
      this.recepcionForm.get(key)?.disable({ emitEvent: false })
    );
    // ordenCompra también readonly al visualizar
    this.recepcionForm.get('ordenCompra')?.disable({ emitEvent: false });

    // Cargar artículos desde localStorage (si existen) o desde la orden
    const recepcionGuardada = (this.simulation.list('recepcionAlmacen') || [])
      .find((r: any) => r.ordenCompra === numeroOrden || r.codigoRecepcion === data.recepcion_codigo);

    if (recepcionGuardada?.articulos?.length) {
      this.sucursalesRowData = recepcionGuardada.articulos;
    } else if (ordenLS?.articulos?.length) {
      this.sucursalesRowData = ordenLS.articulos.map((art: any) => ({
        codigoArticulo:    art.almacen_codigo  ?? art.codigo        ?? '',
        descripcion:       art.descripcion     ?? art.nombre        ?? '',
        unidadMedida:      art.unidad          ?? art.unidadMedida  ?? '',
        cantidadSolicitada: +(art.cantidad     ?? art.cantidadSolicitada ?? 0),
        cantidadEntregada: +(art.cantidadEntregada ?? data.recepcion_cantidad_entregada ?? 0),
        diferencia:        +(art.cantidad ?? 0) - +(art.cantidadEntregada ?? 0),
        motivoDiferencia:  art.motivoDiferencia ?? '-',
      }));
    } else {
      this.sucursalesRowData = [];
    }

    // Totales desde los campos del JSON
    this.totalSolicitada = +(data.recepcion_cantidad_solicitada ?? data.cantidadSolicitada ?? 0);
    this.totalRecibida   = +(data.recepcion_cantidad_entregada  ?? data.cantidadEntregada  ?? 0);
    this.diferencia      = +(data.recepcion_diferencia          ?? data.diferencia         ?? 0);

    // Habilitar botón Confirmar
    this.ordenSeleccionada = true;

    // Refrescar grid de artículos
    setTimeout(() => {
      if (this.sucursalesGridApi) {
        this.sucursalesGridApi.refreshHeader();
        this.sucursalesGridApi.refreshCells({ force: true });
      }
    }, 100);

    this.formValidationService.resetearEstado();
  }

  onSucursalSelected(sucursal: any) {
    console.log('Sucursal seleccionada:', sucursal);
  }

  onCantidadEntregadaChanged(params: any) {
    const cantidadSolicitada = params.data.cantidadSolicitada;
    const cantidadEntregada = params.newValue || 0;
    const diferencia = cantidadSolicitada - cantidadEntregada;
    
    // Actualizar la diferencia en la fila
    params.data.diferencia = diferencia;
    
    // Refrescar la celda de diferencia
    params.api.refreshCells({
      rowNodes: [params.node],
      columns: ['diferencia'],
      force: true
    });
    
    // Recalcular totales
    this.recalcularTotales();
  }

  recalcularTotales() {
    this.totalSolicitada = this.sucursalesRowData.reduce((sum, item) => sum + item.cantidadSolicitada, 0);
    this.totalRecibida = this.sucursalesRowData.reduce((sum, item) => sum + (item.cantidadEntregada || 0), 0);
    this.diferencia = this.totalSolicitada - this.totalRecibida;
  }

  onActivoSeleccionado(evento: any) {
    if (evento && evento.id) {
      // Buscar la orden de compra completa en el array
      const ordenCompleta = this.activos.find(a => a.almacen_codigo === evento.id);
      
      if (ordenCompleta) {
        // Rellenar automáticamente los campos del formulario
        this.recepcionForm.patchValue({
          ordenCompra: ordenCompleta.id,
          razonSocial: ordenCompleta.razonSocial,
          ruc: ordenCompleta.ruc,
          direccionFiscal: ordenCompleta.direccionFiscal,
          emitidoPor: ordenCompleta.emitidoPor,
          fechaEntrega: ordenCompleta.fechaEntrega,
          localEntrega: ordenCompleta.localEntrega,
          direccionEntrega: ordenCompleta.direccionEntrega,
          proveedor: ordenCompleta.proveedor,
          moneda: ordenCompleta.moneda,
          tipoCambio: ordenCompleta.tipoCambio,
          condicionPago: ordenCompleta.condicionPago,
          nroFactura: ordenCompleta.nroFactura,
          nroGuia: ordenCompleta.nroGuia,
          estado: ordenCompleta.estado
        });
        
        // Cargar artículos de la orden
        this.sucursalesRowData = ordenCompleta.articulos || [];
        
        // Refrescar columnas y seleccionar todas las filas por defecto
        setTimeout(() => {
          if (this.sucursalesGridApi) {
            this.sucursalesGridApi.refreshHeader();
            this.sucursalesGridApi.refreshCells({ force: true });
            this.sucursalesGridApi.selectAll();
          }
          // Estado por defecto es Total cuando todas están seleccionadas
          this.recepcionForm.patchValue({ estado: 'Total' });
        }, 100);
        
        // Calcular totales
        this.calcularTotales(ordenCompleta);
        this.ordenSeleccionada = true;
      }
    } else {
      // Si se limpia el autocomplete, resetear totales y tabla
      this.sucursalesRowData = [];
      this.resetearTotales();
    }
  }
  
  calcularTotales(orden: any) {
    // Calcular el total solicitado sumando las cantidades de los artículos
    this.totalSolicitada = this.sucursalesRowData.reduce((sum, item) => sum + item.cantidadSolicitada, 0);
    
    // Calcular el total recibido sumando las cantidades entregadas
    this.totalRecibida = this.sucursalesRowData.reduce((sum, item) => sum + item.cantidadEntregada, 0);
    
    // Calcular la diferencia
    this.diferencia = this.totalSolicitada - this.totalRecibida;
  }

  onBtReset() {
    this.almacenFacade.cargarRecepcionesAlmacenamiento();
  }

  onSucursalesGridReady(params: GridReadyEvent) {
    this.sucursalesGridApi = params.api;
    // Seleccionar todas las filas cuando el grid está listo
    setTimeout(() => {
      this.sucursalesGridApi.selectAll();
    }, 100);
  }

  onArticulosSelectionChanged(event: any) {
    const selectedRows = this.sucursalesGridApi.getSelectedRows();
    const totalRows = this.sucursalesRowData.length;
    
    if (totalRows === 0) return;
    
    // Cambiar estado según la cantidad de filas seleccionadas
    if (selectedRows.length === totalRows) {
      this.recepcionForm.patchValue({ estado: 'Total' });
    } else if (selectedRows.length > 0) {
      this.recepcionForm.patchValue({ estado: 'Parcial' });
    } else {
      this.recepcionForm.patchValue({ estado: 'Pendiente' });
    }
  }

  resetearTotales() {
    this.totalSolicitada = 0;
    this.totalRecibida = 0;
    this.diferencia = 0;
    this.ordenSeleccionada = false;
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
        detalleCambio: 'Estado: De "Activo" a "Inactivo" (autorización especial).'
      },
      {
        fechaHora: '12/11/2025 14:40:22',
        usuario: 'Jorge Gómez',
        accion: 'Edición del asiento',
        detalleCambio: 'Cuenta contable: De 631201 (Suministros) a 631109 (Servicios de Internet).'
      },
      {
        fechaHora: '08/11/2025 14:15:30',
        usuario: 'Jorge Gómez',
        accion: 'Registro del asiento',
        detalleCambio: 'Se ingresó la cabecera y detalle inicial. Totales: Debe S/ 380.00 – Haber S/ 380.00.'
      }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones de OC-2025-000001',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
       
      }
    });
    
    await modal.present();
  }

  confirmarRecepcion() {
    if (this.recepcionForm.valid && this.ordenSeleccionada) {
      const formData = this.recepcionForm.getRawValue();
      
      // Validar que la orden de compra no haya sido utilizada anteriormente
      const recepcionesExistentes = this.simulation.list('recepcionAlmacen') || [];
      const ordenYaUsada = recepcionesExistentes.some((recepcion: any) => 
        recepcion.ordenCompra === formData.ordenCompra
      );
      
      if (ordenYaUsada) {
        this.toastService.danger(`La orden de compra ${formData.ordenCompra} ya ha sido recepcionada anteriormente.`);
        console.log(' Orden de compra ya utilizada:', formData.ordenCompra);
        return;
      }
      
      // Obtener filas seleccionadas de la tabla de artículos
      const articulosSeleccionados = this.sucursalesGridApi ? this.sucursalesGridApi.getSelectedRows() : this.sucursalesRowData;
      
      // Calcular totales basados en artículos seleccionados
      const totalSolicitadaSeleccionados = articulosSeleccionados.reduce((sum: number, item: any) => sum + item.cantidadSolicitada, 0);
      const totalRecibidaSeleccionados = articulosSeleccionados.reduce((sum: number, item: any) => sum + (item.cantidadEntregada || 0), 0);
      const diferenciaSeleccionados = totalSolicitadaSeleccionados - totalRecibidaSeleccionados;
      
      // Generar código de recepción
      const nuevoCodigoNumero = recepcionesExistentes.length > 0
        ? Math.max(...recepcionesExistentes.map((r: any) => parseInt(r.almacen_codigoRecepcion.split('-')[2]) || 0)) + 1
        : 1;
      const nuevoCodigo = `REC-2025-${String(nuevoCodigoNumero).padStart(6, '0')}`;
      
      // Crear objeto de recepción para la tabla
      const nuevaRecepcion = {
        codigoRecepcion: nuevoCodigo,
        fechaRecepcion: this.getFechaHoy(),
        ordenCompra: formData.ordenCompra,
        numeroOrden: formData.ordenCompra, // Número de orden para buscar en localStorage
        proveedor: formData.proveedor,
        cantidadSolicitada: totalSolicitadaSeleccionados,
        cantidadEntregada: totalRecibidaSeleccionados,
        diferencia: diferenciaSeleccionados,
        almacenDestino: formData.localEntrega || 'Almacén principal',
        nroFactura: formData.nroFactura,
        nroGuia: formData.nroGuia,
        usuario: 'Usuario Actual',
        estado: formData.estado,
        moneda: formData.moneda || 'Soles', // Moneda de la orden
        articulos: articulosSeleccionados
      };
      
      // Guardar en localStorage
      this.simulation.save('recepcionAlmacen', nuevaRecepcion);
      console.log('Nueva recepción guardada en localStorage:', nuevaRecepcion);
      
      // Crear registro contable automáticamente
      this.crearRegistroContable(nuevaRecepcion);
      
      // Recargar datos desde el store
      this.almacenFacade.cargarRecepcionesAlmacenamiento();
      
      this.toastService.success('¡Recepción confirmada exitosamente!');
      
      // Limpiar formulario para nueva recepción
      this.nuevaRecepcion();
      
      // Resetear estado del formulario después de guardar
      this.formValidationService.resetearEstado();
    } else {
      this.toastService.warning('Por favor seleccione una orden de compra');
    }
  }

  async nuevaRecepcion() {
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
    this.almacenamientoSeleccionadaData = null;
    this.recepcionForm.reset();
    this.formValidationService.resetearEstado();
    
    // Recargar órdenes aprobadas disponibles (excluye las ya recepcionadas)
    this.cargarOrdenesAprobadasDesdeSimulacion();
    
    // Resetear el formulario completo (incluye campos deshabilitados)
    this.recepcionForm.reset();
    
    // Habilitar el campo ordenCompra para poder seleccionar
    this.recepcionForm.get('ordenCompra')?.enable();
    
    // Limpiar explícitamente cada campo (especialmente los deshabilitados)
    this.recepcionForm.patchValue({
      ordenCompra: '',
      razonSocial: '',
      ruc: '',
      direccionFiscal: '',
      emitidoPor: '',
      fechaEntrega: '',
      localEntrega: '',
      direccionEntrega: '',
      proveedor: '',
      moneda: '',
      tipoCambio: '',
      condicionPago: '',
      nroFactura: '',
      nroGuia: '',
      estado: ''
    });
    
    // Limpiar la tabla de artículos
    this.sucursalesRowData = [];
    
    // Resetear los totales y el estado de orden seleccionada
    this.resetearTotales();
    
    // Limpiar fila seleccionada
    this.filaSeleccionada = null;
    
    // Deseleccionar filas de la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
    
    console.log('Formulario limpiado para nueva recepción');
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    console.log('Filtrar desde:', range.start, 'hasta:', range.end);
  }

  /**
   * Crear registro contable automático cuando se guarda un almacenamiento
   * Genera un asiento contable en "Libro diario" con los datos del almacenamiento
   */
  private crearRegistroContable(recepcion: any) {
    // Obtener registros contables existentes para generar número correlativo
    const registrosContables = this.simulation.list('libroD') || [];
    const nuevoNumero = registrosContables.length + 1;
    
    // Obtener el primer artículo de la recepción
    const primerArticulo = recepcion.articulos && recepcion.articulos.length > 0 
      ? recepcion.articulos[0] 
      : null;
    
    // Buscar el producto completo en el maestro de productos usando el código del artículo
    const productos = this.simulation.list('producto') || [];
    const productoCompleto = productos.find((p: any) => p.almacen_codigo === primerArticulo?.almacen_codigo);
    
    console.log('  Primer artículo de la recepción:', primerArticulo);
    console.log('  Producto completo del maestro:', productoCompleto);
    
    // Extraer centro de costo (puede ser string directo o objeto con id/nombre/almacen_codigo)
    let centroCosto = '';
    if (productoCompleto?.centroC) {
      if (typeof productoCompleto.centroC === 'string') {
        centroCosto = productoCompleto.centroC;
      } else if (productoCompleto.centroC.almacen_codigo) {
        centroCosto = productoCompleto.centroC.almacen_codigo;
      } else if (productoCompleto.centroC.id) {
        centroCosto = productoCompleto.centroC.id;
      } else if (productoCompleto.centroC.nombre) {
        centroCosto = productoCompleto.centroC.nombre;
      }
    }
    
    console.log('🏢 Centro de costo extraído:', centroCosto);
    
    // Crear el registro contable con los datos especificados
    const registroContable = {
      fechaC: recepcion.fechaRecepcion || this.getFechaHoy(), // Fecha contable = fecha de recepción
      nlibro: String(nuevoNumero).padStart(4, '0'), // N° Libro: 0001, 0002, etc.
      nasiento: `AM-${String(nuevoNumero).padStart(4, '0')}`, // N° Asiento: AM-0001, AM-0002, etc.
      glosa: '', // Glosa vacía
      codigoC: primerArticulo?.almacen_codigo || 'PROD-001', // Código del primer producto
      descripcionC: productoCompleto?.producto || primerArticulo?.descripcion || '', // Descripción del producto desde maestro
      centroC: centroCosto, // Centro de costo del producto
      debito: 20.00, // Total débito (ejemplo)
      credito: 20.00, // Total crédito (ejemplo)
      usuario: recepcion.usuario || 'Usuario Actual', // Usuario que registra
      estado: 'Activo', // Estado = Activo
      moneda: recepcion.moneda || 'Soles' // Moneda del almacenamiento
    };
    
    // Guardar el registro contable en localStorage
    this.simulation.save('libroD', registroContable);
    console.log(' Registro contable creado automáticamente:', registroContable);
  }

  /**
   * Implementa CanComponentDeactivate para proteger navegación
   * Solo muestra modal si hay una fila seleccionada (está editando)
   */
  async canDeactivate(): Promise<boolean> {
    if (this.filaSeleccionada) {
      return await this.formValidationService.canDeactivate();
    }
    return true;
  }

}