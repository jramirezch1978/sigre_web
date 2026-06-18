import { Component, OnInit, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent, RowModelType } from 'ag-grid-enterprise';
import { LoaderComponent } from 'src/app/ui/loader/loader.component';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { GridExportService } from 'src/app/core/infrastructure/export/grid-export.service';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ApiClientService } from 'src/app/core/infrastructure/http/api-client.service';
import { AprobarCompraFacade } from 'src/app/modules/compras/application/facades/aprobar-compra.facade';
import { AprobarCompraFeedbackEffects } from 'src/app/modules/compras/effects/aprobar-compra-feedback.effect';
import { AprobarCompraSyncEffects } from 'src/app/modules/compras/effects/aprobar-compra-sync.effect';
import { OrdenCompraEntity } from 'src/app/modules/compras/domain/models/orden-compra.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCheck, faChevronsLeft, faChevronsRight, faGear, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { ModalConfirmationComponent } from '@ui/modal-confirmation/modal-confirmation.component';

// Type alias - preserva el nombre local usado en el componente
type IOrdenCompra = OrdenCompraEntity;


@Component({
  selector: 'app-compras-aprobar-compra',
  templateUrl: './compras-aprobar-compra.component.html',
  styleUrls: ['./compras-aprobar-compra.component.scss'],
  standalone: false,
})
export class ComprasAprobarCompraComponent  implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCheck = faCheck;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasGear = faGear;
  isloading= true;
  fasRotateRight = faRotateRight;


    //Tipo de cambio para ecuador

  pais = this.countryService.getCountryCode();
  mostrarTipoCambio: boolean = true;

  // Inyección del Facade y Effects
  private readonly aprobarCompraFacade = inject(AprobarCompraFacade);
  private readonly gridExport = inject(GridExportService);
  private readonly feedbackEffects = inject(AprobarCompraFeedbackEffects);
  private readonly syncEffects = inject(AprobarCompraSyncEffects);

  // Selectores del store para UI reactiva
  readonly ordenesPendientes = this.aprobarCompraFacade.ordenesPendientes;
  readonly loadingObtener    = this.aprobarCompraFacade.loadingObtener;
  readonly loadingAprobar    = this.aprobarCompraFacade.loadingAprobar;

  titulo='';
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  inhabilitarbotones=false;
  rowModelType: RowModelType = "serverSide";
  estadoSeleccionado: string = 'todos';
  ordenSeleccionada: IOrdenCompra | null = null;
  puedeEditarFormulario: boolean = false;
  mostrartabla=true;
  filasSeleccionadas: IOrdenCompra[] = [];
  private gridApi!: GridApi;
  private gridApiArticulos!: GridApi;
  OrdenesDeCompraForm!: FormGroup;
  archivo: any;

  frameworkComponents = {
  customLoadingOverlay: LoaderComponent,
  };

  gridOptions = {
  frameworkComponents: this.frameworkComponents,
  loadingOverlayComponent: 'customLoadingOverlay',
 };
  colDefs: ColDef[] = [
    { 
      headerName: '', 
      checkboxSelection: true, 
      headerCheckboxSelection: true,
      width: 50,
      maxWidth: 50,
      pinned: 'left'
    },
    { field: 'orden_compra_numero', headerName: 'Nº. Órden de compra', flex: 1, minWidth: 75 },
    { field: 'orden_compra_fecha_registro', headerName: 'Fecha registro', flex: 1, minWidth: 76,
      valueFormatter: (params) => {
        if (params.value) {
          const date = new Date(params.value + 'T00:00:00');
          return date.toLocaleDateString('es-PE');
        }
        return '';
      }
     },
    { field: 'orden_compra_fecha_entrega', headerName: 'Fecha entrega', flex: 1, minWidth: 76,
      valueFormatter: (params) => {
        if (params.value) {
          const date = new Date(params.value + 'T00:00:00');
          return date.toLocaleDateString('es-PE');
        }
        return '';
      }
     },
    { field: 'orden_compra_proveedor', headerName: 'Razón social', flex: 2, minWidth: 140 },
    { field: 'orden_compra_almacen', headerName: 'Almacén', flex: 1, minWidth: 76 },
    { field: 'orden_compra_sucursal', headerName: 'Sucursal', flex: 1, minWidth: 113, filter:true },
    { field: 'orden_compra_moneda', headerName: 'Moneda', flex: 0.8, minWidth: 50 },
    { field: 'orden_compra_total', headerName: 'Total', flex: 1, minWidth: 70,
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
      headerClass: 'centrarencabezado',
      filter:true,
      field: 'orden_compra_estado', 
      headerName: 'Estado', 
      flex: 1, 
      minWidth: 80,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        
        switch(estado) {
          case 'Aprobada':
            badgeClass = 'bg-green-100 text-green-600';
            break;
          case 'Retornada':
            badgeClass = 'bg-[#FFF0BF] text-[#F2A626]';
            break;
          case 'Rechazada':
            badgeClass = 'bg-red-100 text-red-600';
            break;
          default:
            badgeClass = 'bg-[#F5F5F5] text-[#363636';
        }
        return `<span class="badge-table ${badgeClass}">${estado}</span>`;
      },
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  rowData: IOrdenCompra[] = [];
  /** Tipo de fecha del filtro de rango: 'registro' | 'entrega'. */
  tipoFechaFiltro: string = 'registro';
  /** Fuente completa de órdenes pendientes (sin filtrar por fecha). */
  private ordenesFuente: IOrdenCompra[] = [];

  private readonly columnasExport = [
    { header: 'Nº Orden de compra', field: 'orden_compra_numero' },
    { header: 'Fecha registro', field: 'orden_compra_fecha_registro' },
    { header: 'Fecha entrega', field: 'orden_compra_fecha_entrega' },
    { header: 'Razón social', field: 'orden_compra_proveedor' },
    { header: 'Almacén', field: 'orden_compra_almacen' },
    { header: 'Sucursal', field: 'orden_compra_sucursal' },
    { header: 'Moneda', field: 'orden_compra_moneda' },
    { header: 'Total', field: 'orden_compra_total' },
    { header: 'Estado', field: 'orden_compra_estado' },
  ];

  async exportarExcel(): Promise<void> {
    const filas = this.gridExport.obtenerFilas(this.gridApi, this.rowData) as Array<Record<string, unknown>>;
    if (!filas.length) {
      this.toastService.warning('No hay órdenes para exportar');
      return;
    }
    await this.gridExport.exportarExcel(
      `aprobacion-ordenes-compra-${this.gridExport.fechaHoy()}`,
      this.columnasExport,
      filas,
      'Aprobación OC',
    );
  }

  async exportarPdf(): Promise<void> {
    const filas = this.gridExport.obtenerFilas(this.gridApi, this.rowData) as Array<Record<string, unknown>>;
    if (!filas.length) {
      this.toastService.warning('No hay órdenes para exportar');
      return;
    }
    await this.gridExport.exportarPdf(
      'Aprobación de órdenes de compra',
      `aprobacion-ordenes-compra-${this.gridExport.fechaHoy()}`,
      this.columnasExport,
      filas,
    );
  }

  columnTypes = {
    default: {
      resizable: false,
      sortable: false,
      filter: false,
      floatingFilter: false,
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
  // Configuración de la tabla de artículos
  colDefsArticulos: ColDef[] = [
    { field: 'det_orden_compra_codigo', headerName: 'Código', flex: 0.8, minWidth: 80 },
    { field: 'det_orden_compra_cantidad', headerName: 'Cantidad', flex: 0.7, minWidth: 70,
        cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    { 
      headerName: "Unidad",
      field: "det_orden_compra_unidad",
    },
    { headerName: "Centro de costos", field: "centrocostos", editable: false,
      valueFormatter: (params) => this.resolverNombreCentroCosto(params.value) },
    { field: 'det_orden_compra_descripcion', headerName: 'Descripción', flex: 2, minWidth: 150 },
    { field: 'det_orden_compra_precio_unitario', headerName: 'Precio uni.', flex: 0.9, minWidth: 85, valueFormatter: (params) => {
      return params.value ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '0.00';
    }, cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'center' }},
    { field: 'det_orden_compra_subtotal', headerName: 'Subtotal', flex: 0.9, minWidth: 85, valueFormatter: (params) => {
      return params.value ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '0.00';
    }, cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'center' }},
    { field: 'det_orden_compra_impuestos', headerName: 'Impuestos', flex: 0.9, minWidth: 85, valueFormatter: (params) => {
      return params.value ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '0.00';
    }, cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'center' }},
    { field: 'det_orden_compra_total', headerName: 'Total', flex: 0.9, minWidth: 85, valueFormatter: (params) => {
      return params.value ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '0.00';
    }, cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'center' }},
    
  ];

  rowDataArticulos: any[] = [];
  subtotalResumen = 0;
  impuestosResumen = 0;
  totalResumen = 0;
  observacionesSeleccionadas = '';

  proveedores = [
    { id: '1', nombre: 'Carnes Selectas del Sur E.I.R.L' },
    { id: '2', nombre: 'Importadora Vinos del Sur EIRL' },
    { id: '3', nombre: 'Distribuidora Alimentos SAC' },
    { id: '4', nombre: 'Equipamiento Gastronómico SA' },
    { id: '5', nombre: 'Lácteos La Granja SAC' }
  ];

  productos = [
    { codigo: 'ART-001', descripcion: 'Aceite de oliva extra virgen 1L' },
    { codigo: 'ART-002', descripcion: 'Sal marina fina 1kg' },
    { codigo: 'ART-003', descripcion: 'Pimienta negra molida 500g' },
    { codigo: 'ART-004', descripcion: 'Azúcar blanca refinada 1kg' },
    { codigo: 'ART-005', descripcion: 'Harina de trigo todo uso 1kg' },
    { codigo: 'ART-006', descripcion: 'Arroz extra largo 1kg' },
    { codigo: 'ART-007', descripcion: 'Fideos spaghetti 500g' },
    { codigo: 'ART-008', descripcion: 'Tomate en conserva 400g' },
    { codigo: 'ART-009', descripcion: 'Leche evaporada 400ml' },
    { codigo: 'ART-010', descripcion: 'Atún en aceite 170g' }
  ];

  /** Centros de costo (para resolver id -> nombre en el detalle de la orden). */
  centrosCosto: { id: number; nombre: string }[] = [];
  private centroCostoPorId = new Map<string, string>();
  /** Formas/condiciones de pago (para resolver código -> nombre). */
  private condicionPagoPorCodigo = new Map<string, string>();

  constructor(
    private formBuilder: FormBuilder, 
    private modalController: ModalController,
    private toastService: ToastService,
    private countryService: CountryService,
    private api: ApiClientService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Effect para actualizar la tabla cuando cambian las órdenes pendientes del store
    effect(() => {
      const ordenes = this.ordenesPendientes();
      this.ordenesFuente = ordenes;
      this.aplicarFiltroFechas();
    });
  }
  

  ngOnInit() {

    this.OrdenesDeCompraForm = this.formBuilder.group({
      nroordencompra: [''],
      documentoproveedor: [''],
      documentoproveedorinput: [''],
      razonSocial: [''],
      ruc: [''],
      almacen:[''],
      centroCosto: [''],
      direccionFiscal: [''],
      fechaEntrega: [''],
      fechaRegistro: [''],
      fechaAdquisicion:[''],
      sucursal: [''],
      direccionEntrega: [''],
      emitidoPor: [''],
      proveedor: [''],
      moneda: [''],
      tipoCambio: [''],
      condicionPago: [''],
      estado: [{value: '', disabled: true}]
    });
    this.configurarFormularioSegunEstado();
    this.cargarCentrosCosto();
    this.cargarCondicionesPago();
    
    // Cargar órdenes pendientes desde backend (Facade -> UseCases -> Repository)
    this.cargarOrdenesPendientesDesdeStore();
    
    //Labels de formulario: Tipo de cambio por ahora
    this.configurarLabelsPorPais();


  }
  
  /**
   * Carga las órdenes pendientes desde el store usando el facade
   */
  cargarOrdenesPendientesDesdeStore() {
    console.log('  Cargando órdenes pendientes desde el store...');
    this.aprobarCompraFacade.cargarOrdenesPendientes();
  }

  /**
   * @deprecated Usar cargarOrdenesPendientesDesdeStore() en su lugar
   */
  cargarOrdenesPendientes() {
    this.cargarOrdenesPendientesDesdeStore();
  }
  
  async abrirmodalUbicaciones(){
        const modal = await this.modalController.create({
          component: ModalImportarComponent,
          cssClass: 'promo',
          componentProps: {
            titulo: 'Importar ubicaciones',
            descripcionSubir: 'Comparte tu archivo de excel con la información de tus ubicaciones y regístralos automáticamente en la plataforma.',
            buttonName: 'Importar ubicaciones',
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
    
  importar(data:any){
        // Placeholder: aquí se procesaría el archivo (validaciones, parseo, subida, etc.)
        console.log('Importar llamado con:', data);
        // Por ahora solo guardamos el archivo en el estado (ya lo hacemos en modalImportar),
        // y se puede mostrar un toast adicional si se desea.
      }
  mostrarTabla(valor: boolean){
    this.mostrartabla = valor;
  }
  /** Filtro rápido de la lista: busca el texto en todas las columnas visibles. */
  onBuscarLista(event: any): void {
    const valor = (event?.detail?.value ?? event?.target?.value ?? '').toString();
    this.gridApi?.setGridOption('quickFilterText', valor);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    
    // No seleccionar automáticamente ninguna fila
    // El usuario debe seleccionar manualmente las órdenes que desea aprobar
  }

  onGridReadyArticulos(params: GridReadyEvent) {
    this.gridApiArticulos = params.api;
  }

  onCellClicked(event: any) {
    if (!event.data) return;
    
    // Si hacen clic en la columna del checkbox, no hacer nada (AG-Grid lo maneja)
    if (event.column.getColId() === '') return;
    
    // Toggle del checkbox al hacer clic en la fila
    const isSelected = event.node.isSelected();
    event.node.setSelected(!isSelected);
    
    // Si se seleccionó (marcó el checkbox), cargar sus datos en el formulario
    if (!isSelected) {
      this.titulo = event.data.orden_compra_numero;
      this.ordenSeleccionada = event.data;
      this.cargarDatosFormulario();
      console.log('Orden seleccionada y cargada:', event.data);
    } else {
      // Si se deseleccionó, limpiar el formulario solo si es la orden actual
      if (this.ordenSeleccionada?.orden_compra_numero === event.data.orden_compra_numero) {
        this.limpiarDetalleSeleccionado();
        console.log('Orden deseleccionada y formulario limpiado');
      }
    }
  }
  
  private cargarDatosFormulario() {
    if (!this.ordenSeleccionada) return;
    const data=this.ordenSeleccionada;
    // Llenar el formulario con los datos de la orden seleccionada
    this.OrdenesDeCompraForm.patchValue({
      nroordencompra: data.orden_compra_numero || '',
      documentoproveedorinput: data.documentoproveedorinput || '',
      direccionFiscal: data.direccionFiscal || '',
      fechaEntrega: data.orden_compra_fecha_entrega || '',
      almacen:data.orden_compra_almacen || '',
      fechaRegistro: data.orden_compra_fecha_registro || '',
      sucursal: data.orden_compra_sucursal || '',
      centroCosto: this.resolverNombreCentroCosto(this.obtenerCentroCostoDeOrden(data)),
      direccionEntrega: data['direccionEntrega'] || '',
      emitidoPor: data['emitidoPor'] || '',
      proveedor: data.orden_compra_proveedor || '',
      moneda: data.orden_compra_moneda || 'Soles',
      tipoCambio: data.orden_compra_tipo_cambio || '',
      condicionPago: this.resolverNombreCondicionPago(data.orden_compra_condicion_pago),
      estado: data.orden_compra_estado || ''
    });
    // La dirección fiscal proviene del proveedor (se resuelve por su RUC/documento).
    this.resolverDireccionFiscalDesdeProveedor(data);
    this.observacionesSeleccionadas = data.observaciones || '';
    this.subtotalResumen = Number(data['subtotalGeneral'] ?? 0);
    this.impuestosResumen = Number(data['impuestosGenerales'] ?? 0) + Number(data['percepcionGeneral'] ?? 0);
    this.totalResumen = Number(data['totalGeneral'] ?? data.orden_compra_total ?? 0);
    
    // Cargar artículos de la orden seleccionada
    this.cargarArticulosDeOrden();
    
    // Habilitar/Deshabilitar campos según el estado
    this.configurarFormularioSegunEstado();
  }
  
  /**
   * Resuelve la dirección fiscal a partir del proveedor (por su RUC/documento),
   * ya que la orden no la persiste. Si ya viene en la orden, la respeta.
   */
  private resolverDireccionFiscalDesdeProveedor(data: any) {
    if (data?.direccionFiscal) {
      this.OrdenesDeCompraForm.patchValue({ direccionFiscal: data.direccionFiscal });
      return;
    }
    const nroDocumento = String(data?.documentoproveedorinput ?? data?.documentoproveedor ?? '').trim();
    if (!nroDocumento) {
      return;
    }
    this.api.get<any>('/core/relaciones-comerciales', {
      esProveedor: true,
      nroDocumento,
      page: 0,
      size: 20,
    }).subscribe({
      next: (response) => {
        const proveedores = Array.isArray(response)
          ? response
          : Array.isArray(response?.content)
            ? response.content
            : [];
        const proveedor = proveedores.find((p: any) => p.flagEstado === '1') ?? proveedores[0];
        if (proveedor?.direccion) {
          this.OrdenesDeCompraForm.patchValue({ direccionFiscal: proveedor.direccion });
        }
      },
      error: () => { /* sin bloqueo: la dirección queda vacía si no se resuelve */ },
    });
  }

  /** Carga los centros de costo para resolver id -> nombre en el detalle. */
  private cargarCentrosCosto() {
    this.api.get<any>('/contabilidad/centros-costo', { page: 0, size: 1000 }).subscribe({
      next: (response) => {
        const lista = Array.isArray(response)
          ? response
          : Array.isArray(response?.content)
            ? response.content
            : Array.isArray(response?.data)
              ? response.data
              : [];
        this.centroCostoPorId.clear();
        this.centrosCosto = lista
          .filter((c: any) => c?.flagEstado !== '0' && c?.activo !== false)
          .map((c: any) => {
            const desc = c.descCencos ?? c.nombre ?? c.descripcion ?? c.cencos ?? '';
            const nombre = String(desc) || String(c.id);
            this.centroCostoPorId.set(String(c.id), nombre);
            return { id: Number(c.id), nombre };
          });
        // Si ya hay una orden seleccionada, refrescar nombres ahora que llegó el catálogo.
        if (this.ordenSeleccionada) {
          this.OrdenesDeCompraForm.patchValue({
            centroCosto: this.resolverNombreCentroCosto(this.obtenerCentroCostoDeOrden(this.ordenSeleccionada)),
          });
          if (this.gridApiArticulos) {
            this.gridApiArticulos.refreshCells({ force: true });
          }
        }
      },
      error: (err) => console.error('Error cargando centros de costo:', err),
    });
  }

  /** Carga las formas/condiciones de pago para resolver código -> nombre. */
  private cargarCondicionesPago() {
    this.api.get<any>('/core/formas-pago', { page: 0, size: 1000 }).subscribe({
      next: (response) => {
        const formas = Array.isArray(response)
          ? response
          : Array.isArray(response?.content)
            ? response.content
            : Array.isArray(response?.data)
              ? response.data
              : [];
        this.condicionPagoPorCodigo.clear();
        formas
          .filter((f: any) => f?.flagEstado !== '0')
          .forEach((f: any) => {
            const nombre = f.nombre ?? f.codigo ?? String(f.id);
            this.condicionPagoPorCodigo.set(String(f.id), nombre);
            if (f.codigo != null) {
              this.condicionPagoPorCodigo.set(String(f.codigo), nombre);
            }
          });
        if (this.ordenSeleccionada) {
          this.OrdenesDeCompraForm.patchValue({
            condicionPago: this.resolverNombreCondicionPago(this.ordenSeleccionada.orden_compra_condicion_pago),
          });
        }
      },
      error: (err) => console.error('Error cargando condiciones de pago:', err),
    });
  }

  /** Devuelve el nombre de la condición de pago a partir de su código (o el valor original). */
  resolverNombreCondicionPago(valor: any): string {
    if (valor == null || valor === '') {
      return '';
    }
    return this.condicionPagoPorCodigo.get(String(valor)) ?? String(valor);
  }

  /** Devuelve el nombre del centro de costo a partir de su id (o el valor original si no se encuentra). */
  resolverNombreCentroCosto(valor: any): string {
    if (valor == null || valor === '') {
      return '';
    }
    return this.centroCostoPorId.get(String(valor)) ?? String(valor);
  }

  /** Obtiene el centro de costo de la orden (cabecera o primera línea). */
  private obtenerCentroCostoDeOrden(orden: any): any {
    if (orden?.orden_compra_centro_costo) {
      return orden.orden_compra_centro_costo;
    }
    const articulos = (orden?.orden_compra_articulos ?? orden?.articulos ?? []) as any[];
    return articulos.find((a) => a?.centrocostos != null || a?.centrosCostoId != null)?.centrocostos
      ?? articulos.find((a) => a?.centrosCostoId != null)?.centrosCostoId
      ?? '';
  }

  /**
   * Cargar los artículos de la orden seleccionada
   */
  private cargarArticulosDeOrden() {
    if (!this.ordenSeleccionada || !this.ordenSeleccionada.orden_compra_articulos) {
      this.rowDataArticulos = [];
      this.subtotalResumen = 0;
      this.impuestosResumen = 0;
      this.totalResumen = 0;
      if (this.gridApiArticulos) {
        this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
      }
      return;
    }
    
    // Cargar los artículos directamente desde la orden (ya usan det_orden_compra_*)
    this.rowDataArticulos = this.ordenSeleccionada.orden_compra_articulos as any[];
    
    // Actualizar la grilla si existe
    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
    }
    
    console.log('  Artículos de la orden cargados:', this.rowDataArticulos.length);
  }

   configurarLabelsPorPais() {
  if(this.pais === 'EC') {
    this.mostrarTipoCambio = false; // Ocultar tipo de cambio en Ecuador
  }
}

  
  onBtReset() {
      this.cargarOrdenesPendientesDesdeStore();
  }
  
  private configurarFormularioSegunEstado() {
    // Campos que siempre están deshabilitados
    this.OrdenesDeCompraForm.get('nroordencompra')?.disable();
    this.OrdenesDeCompraForm.get('documentoproveedorinput')?.disable();
    this.OrdenesDeCompraForm.get('direccionFiscal')?.disable();
    this.OrdenesDeCompraForm.get('emitidoPor')?.disable();
    this.OrdenesDeCompraForm.get('estado')?.disable();
    this.OrdenesDeCompraForm.get('sucursal')?.disable();
    this.OrdenesDeCompraForm.get('almacen')?.disable();
    this.OrdenesDeCompraForm.get('centroCosto')?.disable();
      this.puedeEditarFormulario = false;
      this.OrdenesDeCompraForm.get('fechaEntrega')?.disable();
      this.OrdenesDeCompraForm.get('fechaRegistro')?.disable();
      this.OrdenesDeCompraForm.get('localentrega')?.disable();
      this.OrdenesDeCompraForm.get('direccionEntrega')?.disable();
      this.OrdenesDeCompraForm.get('proveedor')?.disable();
      this.OrdenesDeCompraForm.get('moneda')?.disable();
      this.OrdenesDeCompraForm.get('tipoCambio')?.disable();
      this.OrdenesDeCompraForm.get('condicionPago')?.disable();
  }

  onCellClickedArticulo(event: any) {
    console.log('Artículo seleccionado:', event.data);
  }

  public async abrirModalRechazarOrden() {
    if (!this.ordenSeleccionada) return;
    
    const detallesEjemplo: DetalleItem[] = [
      { label: 'Número de orden:', value: this.ordenSeleccionada.orden_compra_numero },
      { label: 'Proveedor:', value: this.ordenSeleccionada.orden_compra_proveedor },
      { label: 'Estado:', value: this.ordenSeleccionada.orden_compra_estado },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Rechazar orden de compra',
        subtitulomodal: 'Detalle de la orden de compra',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo del rechazo',
        placeholderTextarea: 'Describe el motivo del rechazo o las observaciones para el emisor.',
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Rechazar',
        colorBotonConfirmar: 'danger'
      }
    });

    await modal.present();
    
    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      const motivo = (data.motivo || '').trim();
      if (!motivo) {
        this.toastService.warning('El motivo del rechazo es obligatorio');
        return;
      }
      this.aprobarCompraFacade.rechazarOrden(this.ordenSeleccionada!.orden_compra_numero, motivo);
      this.limpiarDetalleSeleccionado();
    }
  }

  async abrirModalRetornarOrden(){
    if (!this.ordenSeleccionada) return;
    
    const detallesEjemplo: DetalleItem[] = [
      { label: 'Número de orden:', value: this.ordenSeleccionada.orden_compra_numero },
      { label: 'Proveedor:', value: this.ordenSeleccionada.orden_compra_proveedor },
      { label: 'Estado:', value: this.ordenSeleccionada.orden_compra_estado },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Retornar orden de compra',
        subtitulomodal: 'Detalle de la orden de compra',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo del retorno:',
        placeholderTextarea: 'Describe el motivo de por el que se retorna la orden de compra.',
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Retornar',
        colorBotonConfirmar: 'primary'
      }
    });

    await modal.present();
    
    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      const motivo = (data.motivo || '').trim();
      if (!motivo) {
        this.toastService.warning('El motivo del retorno es obligatorio');
        return;
      }
      this.aprobarCompraFacade.retornarOrden(this.ordenSeleccionada!.orden_compra_numero, motivo);
      this.limpiarDetalleSeleccionado();
    }
  }

  async abrirModalAprobarOrden(){
    if (!this.ordenSeleccionada) return;
    
    const detallesEjemplo: DetalleItem[] = [
      { label: 'Número de orden', value: this.ordenSeleccionada.orden_compra_numero },
      { label: 'Proveedor', value: this.ordenSeleccionada.orden_compra_proveedor },
      { label: 'Estado', value: this.ordenSeleccionada.orden_compra_estado },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        widthModal: '500px',
        tituloModal: 'Aprobar orden de compra',
        subtitulomodal: 'Detalle de la orden de compra',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        tituloTextarea: 'Observación de aprobación',
        placeholderTextarea: 'Agrega una observación para el historial de aprobación (opcional).',
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Aprobar',
        colorBotonConfirmar: 'primary'
      }
    });

    await modal.present();
    
    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      this.aprobarCompraFacade.aprobarOrden(this.ordenSeleccionada!.orden_compra_numero, data.motivo);
      this.limpiarDetalleSeleccionado();
    }
  }

  /**
   * @deprecated Las transiciones de estado ahora las maneja el Facade.
   * Se mantiene por compatibilidad con código existente.
   */
  private actualizarEstadoOrden(nuevoEstado: string) {
    console.warn('actualizarEstadoOrden está deprecado. Usar facade methods directamente.');
  }

   filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    this.aplicarFiltroFechas();
  }

  /** Campo de fecha sobre el que aplica el filtro de rango, según el select. */
  private fechaFiltroField(): string {
    return this.tipoFechaFiltro === 'entrega'
      ? 'orden_compra_fecha_entrega'
      : 'orden_compra_fecha_registro';
  }

  /** Aplica el filtro de rango de fechas sobre la fuente y refresca el grid. */
  aplicarFiltroFechas(): void {
    this.rowData = this.gridExport.filtrarPorRango(
      this.ordenesFuente,
      (o: any) => o?.[this.fechaFiltroField()],
      this.startDate,
      this.endDate,
    );
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  /** Cambió el tipo de fecha (registro/entrega): re-aplica el filtro. */
  onTipoFechaChange(): void {
    this.aplicarFiltroFechas();
  }

  onProveedorSeleccionado(proveedor: any) {
    console.log('Proveedor seleccionado:', proveedor);
    // Aquí puedes realizar acciones adicionales cuando se selecciona un proveedor
  }

  onProductoSeleccionado(producto: any) {
    console.log('Producto seleccionado:', producto);
    // Aquí puedes agregar el producto a la tabla de artículos
    // Por ejemplo: this.agregarProductoATabla(producto);
  }

  crearNuevaOrden() {
    this.ordenSeleccionada = null;
    this.puedeEditarFormulario = true;
    
    // Limpiar el formulario
    this.OrdenesDeCompraForm.reset();
    
    // Establecer valores por defecto
    this.OrdenesDeCompraForm.patchValue({
      razonSocial: 'Restaurant.pe',
      ruc: '20123456789',
      direccionFiscal: 'Av. Principal 123, Lima',
      emitidoPor: 'Usuario Admin',
      estado: 'Pendiente',
      moneda: 'Soles',
      tipoCambio: '3.75',
      condicionPago: '1',
      localentrega: '1'
    });
    
    // Deshabilitar campos fijos
    this.OrdenesDeCompraForm.get('razonSocial')?.disable();
    this.OrdenesDeCompraForm.get('ruc')?.disable();
    this.OrdenesDeCompraForm.get('direccionFiscal')?.disable();
    this.OrdenesDeCompraForm.get('emitidoPor')?.disable();
    this.OrdenesDeCompraForm.get('estado')?.disable();
    
    // Habilitar campos editables
    this.OrdenesDeCompraForm.get('fechaEntrega')?.enable();
    this.OrdenesDeCompraForm.get('fechaRegistro')?.enable();
    this.OrdenesDeCompraForm.get('localentrega')?.enable();
    this.OrdenesDeCompraForm.get('direccionEntrega')?.enable();
    this.OrdenesDeCompraForm.get('proveedor')?.enable();
    this.OrdenesDeCompraForm.get('moneda')?.enable();
    this.OrdenesDeCompraForm.get('tipoCambio')?.enable();
    this.OrdenesDeCompraForm.get('condicionPago')?.enable();
  }

  // Método para manejar el cambio de selección en el grid
  onSelectionChanged(event: any) {
    this.filasSeleccionadas = this.gridApi.getSelectedRows();
    console.log('Filas seleccionadas:', this.filasSeleccionadas);

    if (this.filasSeleccionadas.length === 0) {
      // Sin selección → limpiar formulario y artículos
      this.limpiarDetalleSeleccionado();
    } else {
      const ultimaSeleccionada = this.filasSeleccionadas[this.filasSeleccionadas.length - 1];
      // Si la orden mostrada ya no está entre las seleccionadas, mostrar la última seleccionada
      const ordenMostradaDeseleccionada = this.ordenSeleccionada &&
        !this.filasSeleccionadas.some(f => f.orden_compra_numero === this.ordenSeleccionada!.orden_compra_numero);

      if (!this.ordenSeleccionada || ordenMostradaDeseleccionada ||
          this.ordenSeleccionada.orden_compra_numero !== ultimaSeleccionada.orden_compra_numero) {
        this.titulo = ultimaSeleccionada.orden_compra_numero;
        this.ordenSeleccionada = ultimaSeleccionada;
        this.cargarDatosFormulario();
      }
    }

    // Los botones individuales solo se habilitan si hay exactamente una orden seleccionada
    this.inhabilitarbotones = this.filasSeleccionadas.length !== 1;
  }

  // Método para aprobar múltiples órdenes
  async aprobarOrdenesSeleccionadas() {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Aprobar órdenes de compra',
        title: `Confirmar aprobación de orden(es)`,
        message: `Por favor, revisa los detalles antes de proceder. Una vez aprobados, no podrás <br> modificar ni deshacer esta acción.`,
        btnCancelTxt: 'Cancelar',
        btnOkTxt: 'Aprobar',
      }
    });

    await modal.present();
    
    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      const numerosOrden = this.filasSeleccionadas.map(o => o.orden_compra_numero);
      this.aprobarCompraFacade.aprobarOrdenesMasivo(numerosOrden);
      this.filasSeleccionadas = [];
      this.limpiarDetalleSeleccionado();
      if (this.gridApi) this.gridApi.deselectAll();
      console.log('  Aprobación masiva enviada al facade');
    }
  }

  formatearMonto(valor: number): string {
    return new Intl.NumberFormat('es-PE', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(Number(valor ?? 0));
  }

  private limpiarDetalleSeleccionado() {
    this.ordenSeleccionada = null;
    this.titulo = '';
    this.observacionesSeleccionadas = '';
    this.subtotalResumen = 0;
    this.impuestosResumen = 0;
    this.totalResumen = 0;
    this.OrdenesDeCompraForm.reset();
    this.rowDataArticulos = [];
    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', []);
    }
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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Aprobada', detalleCambio: 'Registro inicial de la orden de compra'},
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Rechazada', detalleCambio: 'Modificación de cantidad de artículo ART-001'},
      { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Retornada', detalleCambio: 'Orden aprobada para proceso'},
      { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Aprobada', detalleCambio: 'Agregado de 3 artículos a la orden' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - Orden de Compra',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });
    
    await modal.present();
  }
  
}
