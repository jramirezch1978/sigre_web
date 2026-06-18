
import { Component, OnInit, OnDestroy, ViewChild, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Subject, takeUntil } from 'rxjs';
import { ModalController } from '@ionic/angular';
import { ViewWillEnter } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent, IRichCellEditorParams, RowModelType } from 'ag-grid-community';
import { AccesorioActionsCellComponent } from 'src/app/modules/activos/m-af-tabla/pages/af-o-registroactivos/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { LoaderComponent } from 'src/app/ui/loader/loader.component';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalCrearAtfprodComponent } from 'src/app/ui/modal-crear-atfprod/modal-crear-atfprod.component';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { GridExportService } from 'src/app/core/infrastructure/export/grid-export.service';
import { ModalCuotasComponent } from 'src/app/ui/modal-cuotas/modal-cuotas.component';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { OrdenCompraFacade } from '../../../../application/facades/orden-compra.facade';
import { OrdenCompraEntity } from '../../../../domain/models/orden-compra.entity';
import { OrdenCompraFeedbackEffects } from '../../../../effects/orden-compra-feedback.effect';
import { ProveedorFacade } from '../../../../application/facades/proveedor.facade';
import { CondicionPagoFacade } from '../../../../application/facades/condicion-pago.facade';

// Font Awesome Icons
import { faBook, faSearch as faSearchRegular } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faEdit, faGear, faRotateRight, faCalendar, faSearch as faSearchSolid } from '@fortawesome/pro-solid-svg-icons';
import { ProveedorEntity } from '@modules/compras/domain/models/proveedor.entity';
import { ApiClientService } from 'src/app/core/infrastructure/http/api-client.service';
import { StorageService } from 'src/app/core/services/storage.service';

// Font Awesome Icons



interface IArticulo {
  articuloId?: number;
  unidadMedidaId?: number | null;
  tipoImpuesto?: string | null;
  tipoImpuestoId?: number | null;
  igvTasa?: number;
  percepcionTasa?: number;
  descuentoPorcentaje?: number;
  almacenId?: number | null;
  centrosCostoId?: number | null;
  fechaEntrega?: string;
  det_orden_compra_codigo: string;
  det_orden_compra_cantidad: number;
  det_orden_compra_unidad: string;
  det_orden_compra_descripcion: string;
  det_orden_compra_precio_unitario: number;
  det_orden_compra_subtotal: number;
  det_orden_compra_impuestos: number;
  det_orden_compra_total: number;
}

interface SessionUserLike {
  empresaId?: number;
  sucursalId?: number;
  [key: string]: unknown;
}
@Component({
  selector: 'app-compras-operaciones-ordenes-de-compra',
  templateUrl: './compras-operaciones-ordenes-de-compra.component.html',
  styleUrls: ['./compras-operaciones-ordenes-de-compra.component.scss'],
  standalone: false,
})
export class ComprasOperacionesOrdenesDeCompraComponent implements OnInit, OnDestroy, ViewWillEnter {
  private readonly destroy$ = new Subject<void>();
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearchRegular;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasEdit = faEdit;
  fasGear = faGear;
  fasRotateRight = faRotateRight;
  fasSearch = faSearchSolid;
  fasCalendar = faCalendar;

  // Inyección del Facade y Effects
  private readonly ordenCompraFacade = inject(OrdenCompraFacade);
  private readonly feedbackEffects = inject(OrdenCompraFeedbackEffects);
  private readonly proveedorFacade = inject(ProveedorFacade);
  private readonly condicionPagoFacade = inject(CondicionPagoFacade);
  private readonly gridExport = inject(GridExportService);

  // Selectores del store para UI reactiva
  readonly ordenesCompra = this.ordenCompraFacade.ordenesCompra;
  readonly isLoading = this.ordenCompraFacade.loading;
  readonly loadingObtener = this.ordenCompraFacade.loadingObtener;
  readonly loadingGuardar = this.ordenCompraFacade.loadingGuardar;
  readonly loadingEliminar = this.ordenCompraFacade.loadingEliminar;
  readonly loadingActualizar = this.ordenCompraFacade.loadingActualizar;


  // countries= ALL_COUNTRIES;

  @ViewChild('autocompleteProductos') autocompleteProductos: any;

  //Tipo de cambio para ecuador
  pais = this.countryService.getCountryCode();
  mostrarTipoCambio: boolean = true;
  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  titulo = 'OC-2024-0011';
  fechaEntrega: Date | undefined;
  rowModelType: RowModelType = "serverSide";
  estadoSeleccionado: string = 'todos';
  ordenSeleccionada: OrdenCompraEntity | null = null;
  puedeEditarFormulario: boolean = false;
  mostrartabla = true;
  filaSeleccionada: any = null; 
  mostrarCamposDeshabilitados: boolean = false;
  modoCreacion: boolean = true;
  esNuevaOrden: boolean = true;
  private gridApi!: GridApi;
  private gridApiArticulos!: GridApi;
  OrdenesDeCompraForm!: FormGroup;
  habilitarcampos: any;
  archivo: any;
  botoncuotas = 'Editar'
  frameworkComponents = {
    customLoadingOverlay: LoaderComponent,
  };

  gridOptions = {
    frameworkComponents: this.frameworkComponents,
    loadingOverlayComponent: 'customLoadingOverlay',
  };
  centrosC: any[] = [];
  colDefs: ColDef[] = [
    { field: 'orden_compra_numero', headerName: 'Nº Órden de compra', width:150, filter: true },
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
    { field: 'orden_compra_proveedor', headerName: 'Proveedor', flex: 2, minWidth: 140, filter: true },
    { field: 'orden_compra_almacen', headerName: 'Almacen', flex: 1, minWidth: 113 },
    { field: 'orden_compra_sucursal', headerName: 'Sucursal', width:150, filter: true },
    { field: 'orden_compra_moneda', headerName: 'Moneda', flex: 0.8, minWidth: 50,
      valueFormatter: (params) => {
        if (params.value === 'USD') return 'Dólares';
        if (params.value === 'PEN') return 'Soles';
        return params.value;
      },
     },
    {
      field: 'orden_compra_total', headerName: 'Total', flex: 1, minWidth: 70,
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
            return `( ${formattedValue})`;
          }
          return ` ${formattedValue}`;
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
      field: 'orden_compra_estado',
      filter: true,
      headerName: 'Estado',
      flex: 1,
      minWidth: 80,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';

        switch (estado) {
          case 'Aprobada':
            badgeClass = 'bg-green-100 text-green-600';
            break;
          case 'Retornada':
            badgeClass = 'bg-[#FFDECC] text-[#FF8947]';
            break;
          case 'Rechazada':
            badgeClass = 'bg-red-100 text-red-600';
            break;
          default:
            badgeClass = 'bg-[#F5F5F5] text-[#363636]';
        }
        return `<span class="badge-table ${badgeClass}">${estado}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];
  rowData: OrdenCompraEntity[] = [];
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
    { field: 'det_orden_compra_descripcion', headerName: 'Descripción', flex: 2, minWidth: 150 },
    {
      field: 'det_orden_compra_cantidad', headerName: 'Cantidad', flex: 0.7, minWidth: 70,
      editable: (params) => this.puedeEditarFormulario,
      valueParser: (params) => this.parsearNumeroEditable(params.newValue),
      cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'center', cursor: 'pointer' }
    },
    // {
    //   headerName: "Unidad",
    //   field: "det_orden_compra_unidad",
    //   editable: (params) => this.puedeEditarFormulario,
    //   cellStyle:{ cursor: 'pointer'},
    //   cellEditor: "agRichSelectCellEditor",
    //   cellEditorParams: {
    //     values: ["Corriente", "Kilogramo", "Litro", "Unidad", "Metro", "Caja"],
    //   } as IRichCellEditorParams,
    // },
    { field: 'det_orden_compra_unidad', headerName: 'Unidad', editable: false, width: 150,
      cellStyle:{ cursor: 'default'},
    },
    {
      field: 'det_orden_compra_precio_unitario', headerName: 'Precio unitario', headerClass: 'derechaencabezado', editable: (params) => this.puedeEditarFormulario, flex: 0.9, minWidth: 85, valueParser: (params) => this.parsearNumeroEditable(params.newValue), valueFormatter: (params) => {
        return params.value ? 'S/ ' + new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : 'S/ 0.00';
      }, cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'center', cursor: 'pointer' }
    },
    {
      field: 'det_orden_compra_subtotal', headerName: 'Subtotal',  headerClass: 'derechaencabezado', flex: 0.9, minWidth: 85, valueFormatter: (params) => {
        return params.value ? 'S/ ' + new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : 'S/ 0.00';
      }, cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    {
      field: 'det_orden_compra_impuestos', headerName: 'Impuestos',  headerClass: 'derechaencabezado', flex: 0.9, minWidth: 85, valueFormatter: (params) => {
        return params.value ? 'S/ ' + new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : 'S/ 0.00';
      }, cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    {
      field: 'det_orden_compra_total', headerName: 'Total', headerClass: 'derechaencabezado', flex: 0.9, minWidth: 85, valueFormatter: (params) => {
        return params.value ? 'S/ ' + new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : 'S/ 0.00';
      }, cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    {
      field: 'acciones',
      headerName: 'Acciones',
      headerClass: 'centrarencabezado',
      flex: 0.8,
      minWidth: 80,
      cellRenderer: AccesorioActionsCellComponent,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
      // cellRenderer: (params: any) => {
      //   return `<div class="flex items-center justify-center gap-1">
      //     <button class="btn-edit-articulo text-blue-600 hover:text-blue-800">
      //       <i class="fas fa-edit text-xxs"></i>
      //     </button>
      //     <button class="btn-delete-articulo text-red-600 hover:text-red-800">
      //       <i class="fas fa-trash text-xxs"></i>
      //     </button>
      //   </div>`;
      // }
    }
  ];
  rowDataArticulos: IArticulo[] = [];
  sucursales: any[] = [];
  almacenes: any[] = [];
  proveedores: ProveedorEntity[] = [];
  condicionesPago: any[] = [];
  /** Nombre de la condición de pago para la vista deshabilitada (no el código). */
  condicionPagoNombre: string = '';
  /** Tipo de fecha del filtro de rango: '0' = registro, '1' = entrega. */
  tipoFechaFiltro: string = '0';
  /** Fuente completa de órdenes (sin filtrar por fecha) para filtros locales. */
  private ordenesFuente: any[] = [];
  monedas: any[] = [];
  impuestos: any[] = [];
  // Variables para cálculos
  subtotalGeneral: number = 0;
  impuestosGenerales: number = 0;
  totalGeneral: number = 0;
  productos: any[] = [];
  proveedorSeleccionadoActual: ProveedorEntity | null = null;
  private ultimaBusquedaProductos = '';
  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private countryService: CountryService,
    private formValidationService: FormValidationService,
    private api: ApiClientService,
    private storageService: StorageService
  ) {

    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Effect para actualizar la tabla cuando cambian los datos del store
    effect(() => {
      const ordenes = this.ordenesCompra();
      this.ordenesFuente = ordenes;
      this.aplicarFiltroFechas();
    });

    // Effect para sincronizar proveedores desde el store
    effect(() => {
      this.proveedores = this.proveedorFacade.proveedores();
    });

    // Las condiciones de pago se cargan desde /core/formas-pago (cargarFormasPagoApi),
    // porque el backend de la OC guarda forma_pago_id → core.forma_pago(id).
    // Antes se usaba core.condiciones-pago, cuyo código no es un forma_pago_id válido
    // y provocaba DATA_INTEGRITY_ERROR (FK) al guardar.
  }

  ngOnInit() {
    this.OrdenesDeCompraForm = this.formBuilder.group({
      ruc: ['', Validators.required],
      fechaRegistro: [{ value: this.fechaHoyISO(), disabled: true }, Validators.required],
      fechaEntrega: '',
      direccionEntrega: '',
      direccionFiscal: '',
      observaciones: '',
      emitidoPor: '',
      estado: '',
      centrocosto: '',
      moneda: '',
      almacen: [''],
      documentoproveedor: '',
      documentoproveedorinput: '',
      tipoCambio: '',
      condicionPago: '',
      localentrega: '',
      proveedor: ['']
    });

    this.cargarSucursalesDesdeApi();
    this.cargarAlmacenesDesdeApi();
    this.cargarMonedasDesdeApi();
    this.cargarImpuestosDesdeApi();
    this.cargarCentroCostos();
    // No se cargan todos los proveedores (causaba N+1 y lag al renderizar);
    // el proveedor se resuelve por RUC con buscarproveedor() (API directa).
    this.cargarFormasPagoApi();
    this.cargarProductosDesdeApi();
    this.cargarOrdenesDesdeApi();
    
    this.configurarLabelsPorPais();
    this.formValidationService.inicializarFormulario(this.OrdenesDeCompraForm);

    this.OrdenesDeCompraForm.get('moneda')?.valueChanges
      .pipe(takeUntil(this.destroy$))
      .subscribe(moneda => {
        if (moneda) {
          this.actualizarTipoCambio(moneda);
        }
      });
    this.crearNuevaOrden(false);
    this.formValidationService.resetearEstado();
  }
  // docpais(): void{
  //  const country = this.countries.find(
  //   c => c.codigo === this.countryService.getCountryCode()
  //   );
  //   this.countries.find(c => {
  //     if(c.codigo === country?.codigo){
  //       c.personalidadfiscal?.find(tip => {
  //         if(tip.id === 'empresa'){
  //            this.idfiscal=tip.nombre;
  //            console.log('el tipo de doc es:', tip.nombre);
  //       }
  //       })
  //     }
  //   }) 

  ionViewWillEnter() {
    this.cargarAlmacenesDesdeApi();
    this.cargarOrdenesDesdeApi();

    // Si hay una orden seleccionada, recargarla para actualizar su estado
    if (this.ordenSeleccionada && this.ordenSeleccionada.orden_compra_numero) {
      const ordenActualizada = this.rowData.find((o: any) => o.orden_compra_numero === this.ordenSeleccionada?.orden_compra_numero);
      if (ordenActualizada) {
        console.log(' Orden actualizada encontrada, recargando datos...');
        // Simular clic para recargar todos los datos de la orden
        this.onCellClicked({
          data: ordenActualizada,
          node: { setSelected: () => { } }
        });
      }
    }
  }

  /**
   * Verifica si hay datos de un plan de abastecimiento para cargar en la orden
   */
  verificarDatosDesdePlanAbastecimiento() {
    this.toastService.warning('La generación desde plan aún debe integrarse por endpoint, no por almacenamiento local');
  }

  configurarLabelsPorPais() {
  if(this.pais === 'EC') {
    this.mostrarTipoCambio = false; // Ocultar tipo de cambio en Ecuador
  }
}

  async abrirmodalImportar() {
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar órdenes de compra',
        descripcionSubir: 'Comparte tu archivo de excel con la información de tus ubicaciones y regístralos automáticamente en la plataforma.',
        buttonName: 'Importar órdenes de compra',
        habilitarformatonumerico: true,
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
  mostrarTabla(valor: boolean) {
    this.mostrartabla = valor;
  }
  /** Filtro rápido de la lista: busca el texto en todas las columnas visibles. */
  onBuscarLista(event: any): void {
    const valor = (event?.detail?.value ?? event?.target?.value ?? '').toString();
    this.gridApi?.setGridOption('quickFilterText', valor);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;

    // No seleccionar automáticamente la primera fila
    // El formulario inicia en modo "Nueva orden de compra"
  }
  onGridReadyArticulos(params: GridReadyEvent) {
    this.gridApiArticulos = params.api;
  }
  async onCellClicked(event: any) {
    if (!event.data) return;

    // Guardar referencia de la fila anterior seleccionada
    const filaAnterior = this.filaSeleccionada;
    
    // Buscar el nodo anterior iterando sobre los nodos visibles
    let nodoAnterior: any = null;
    if (filaAnterior && this.gridApi) {
      this.gridApi.forEachNode((node: any) => {
        if (node.data && node.data.orden_compra_numero === filaAnterior.orden_compra_numero) {
          nodoAnterior = node;
        }
      });
    }

    // Guardar referencia del elemento con foco
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar cambios antes de cambiar de orden
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Usuario canceló - reseleccionar la fila anterior
      console.log('  Usuario canceló - reseleccionando fila anterior');
      
      // Deseleccionar todo
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }
      
      // Reseleccionar la fila anterior si existe
      if (nodoAnterior && filaAnterior) {
        nodoAnterior.setSelected(true);
        console.log('  Fila anterior reseleccionada:', filaAnterior.orden_compra_numero);
      }
      
      // Restaurar foco
      setTimeout(() => {
        if (elementoConFoco && elementoConFoco.focus) {
          elementoConFoco.focus();
        }
      }, 100);
      return;
    }

    this.botoncuotas = 'Editar';

    // Continuar con la carga de datos
    this.titulo = event.data.orden_compra_numero;
    this.modoCreacion = false;
    this.esNuevaOrden = false;
    this.filaSeleccionada = event.data;
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    this.ordenSeleccionada = event.data;
    event.node.setSelected(true);

    // Convertir fecha de entrega de string a Date si existe
    // Soporta formato ISO (YYYY-MM-DD) y formato local (DD/MM/YYYY)
    if (event.data.orden_compra_fecha_entrega) {
      try {
        const raw = event.data.orden_compra_fecha_entrega as string;
        let fechaDate: Date;
        if (/^\d{4}-\d{2}-\d{2}$/.test(raw)) {
          // Formato ISO: YYYY-MM-DD
          const [anio, mes, dia] = raw.split('-');
          fechaDate = new Date(+anio, +mes - 1, +dia);
        } else {
          // Formato local: DD/MM/YYYY
          const [dia, mes, anio] = raw.split('/');
          fechaDate = new Date(+anio, +mes - 1, +dia);
        }
        this.fechaEntrega = fechaDate;
        console.log(' Fecha de entrega cargada:', this.fechaEntrega);
      } catch (error) {
        console.log(' Error al parsear fecha:', event.data.orden_compra_fecha_entrega);
        this.fechaEntrega = undefined;
      }
    } else {
      this.fechaEntrega = undefined;
    }

    // Llenar el formulario con TODOS los datos REALES de la orden guardada
    console.log(' Datos de la orden seleccionada:', event.data);
    
    // Resolver el CÓDIGO de moneda (PEN/USD/…) que usa el select, a partir del
    // valor guardado en la orden (puede venir como nombre 'Soles'/'Dólares' o código).
    const monedaFormulario = this.resolverCodigoMoneda(event.data.orden_compra_moneda);
    // Nombre de la condición de pago (para la vista deshabilitada).
    const codCondicion = event.data.orden_compra_condicion_pago;
    this.condicionPagoNombre = this.condicionesPago.find((c: any) => String(c.codigo) === String(codCondicion))?.nombre
      ?? String(codCondicion ?? '');
    
    // Buscar el VALUE del almacén por su nombre o códigos alternativos
    const almacenEncontrado = this.almacenes.find((a: any) => 
      a.nombre === event.data.orden_compra_almacen || 
      a.codigo === event.data.orden_compra_almacen ||
      a.value === event.data.orden_compra_almacen
    );
    const almacenValue = almacenEncontrado ? almacenEncontrado.value : '';
    
    // Buscar el ID de la sucursal por su nombre o ID alternativo
    const sucursalEncontrada = this.sucursales.find((s: any) => 
      s.nombre === event.data.orden_compra_sucursal || 
      s.id === event.data.orden_compra_sucursal
    );
    const sucursalId = sucursalEncontrada ? sucursalEncontrada.id : '';

    // Formatear fecha de entrega según estado
    // Pendiente/Retornada → d/M/YYYY (es-PE, ej: 12/1/2026) para el calendario
    // Aprobada/Rechazada  → YYYY-MM-DD para el ion-input type="date"
    const estadoOrden = event.data.orden_compra_estado;
    const fechaEntregaRaw = event.data.orden_compra_fecha_entrega as string;
    let fechaEntregaFormateada = fechaEntregaRaw || '';
    if (fechaEntregaRaw) {
      // Obtener un objeto Date unificado desde cualquier formato
      let fechaObj: Date;
      if (/^\d{4}-\d{2}-\d{2}$/.test(fechaEntregaRaw)) {
        const [a, m, d] = fechaEntregaRaw.split('-');
        fechaObj = new Date(+a, +m - 1, +d);
      } else {
        const [d, m, a] = fechaEntregaRaw.split('/');
        fechaObj = new Date(+a, +m - 1, +d);
      }
      if (estadoOrden === 'Pendiente' || estadoOrden === 'Retornada') {
        // Formato d/M/YYYY para el campo de texto del calendario
        fechaEntregaFormateada = fechaObj.toLocaleDateString('es-PE');
      } else {
        // Formato YYYY-MM-DD para ion-input type="date"
        fechaEntregaFormateada = event.data.orden_compra_fecha_entrega;
      }
    }
    
    // Habilitar todos los controles antes de patchValue para que los autocompletes
    // puedan escribir su valor (writeValue falla si el control está deshabilitado)
    Object.keys(this.OrdenesDeCompraForm.controls).forEach(key => {
      this.OrdenesDeCompraForm.get(key)?.enable({ emitEvent: false });
    });

    // emitEvent: false para que el valueChanges de 'moneda' no dispare actualizarTipoCambio
    // y no sobreescriba el tipoCambio real guardado en la orden
    this.OrdenesDeCompraForm.patchValue({
      nroordencompra: event.data.orden_compra_numero || '',
      documentoproveedor: event.data.documentoproveedor || 'DNI',
      documentoproveedorinput: event.data.documentoproveedorinput || '',
      proveedor: event.data.orden_compra_proveedor || '',
      localentrega: sucursalId,
      almacen: almacenValue,
      centrocosto: event.data.orden_compra_centro_costo
        ? (isNaN(Number(event.data.orden_compra_centro_costo))
            ? event.data.orden_compra_centro_costo
            : Number(event.data.orden_compra_centro_costo))
        : '',
      direccionFiscal: event.data.direccionFiscal || '',
      fechaRegistro: event.data.orden_compra_fecha_registro || '',
      fechaEntrega: fechaEntregaFormateada,
      direccionEntrega: event.data.direccionEntrega || '',
      moneda: monedaFormulario,
      tipoCambio: event.data.orden_compra_tipo_cambio || '3.75000',
      condicionPago: event.data.orden_compra_condicion_pago || '',
      estado: event.data.orden_compra_estado || 'Pendiente'
    }, { emitEvent: false });

    // Cargar artículos REALES desde la orden guardada (NO hardcodeados)
    this.rowDataArticulos = event.data.orden_compra_articulos || event.data.articulos || [];
    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
    }

    // Calcular totales con los artículos cargados
    this.calcularTotales();

    // Habilitar/Deshabilitar campos según el estado
    this.configurarFormularioSegunEstado(event.data.orden_compra_estado);

    // Resetear estado de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }
  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
    this.formValidationService.limpiarFormulario();
  }

  onBtReset() {
      this.ordenCompraFacade.cargarOrdenesCompra();
  }

  private configurarFormularioSegunEstado(estado: string) {
    this.habilitarcampos = estado;

    // Si es Aprobado o Rechazado, mostrar campos deshabilitados
    if (estado === 'Aprobada' || estado === 'Rechazada') {
      this.mostrarCamposDeshabilitados = true;
      this.puedeEditarFormulario = false;
      // Deshabilitar todos los campos
      Object.keys(this.OrdenesDeCompraForm.controls).forEach(key => {
        this.OrdenesDeCompraForm.get(key)?.disable();
      });
    } else {
      // Si es Pendiente o Retornada, mostrar componentes normales
      this.mostrarCamposDeshabilitados = false;
      this.puedeEditarFormulario = true;

      // Habilitar campos editables
      this.OrdenesDeCompraForm.get('fechaEntrega')?.enable();
      this.OrdenesDeCompraForm.get('localentrega')?.enable();
      this.OrdenesDeCompraForm.get('direccionEntrega')?.enable();
      this.OrdenesDeCompraForm.get('almacen')?.enable();
      this.OrdenesDeCompraForm.get('moneda')?.enable();
      this.OrdenesDeCompraForm.get('direccionFiscal')?.enable();
      this.OrdenesDeCompraForm.get('tipoCambio')?.enable();
      this.OrdenesDeCompraForm.get('condicionPago')?.enable();
      this.OrdenesDeCompraForm.get('documentoproveedor')?.enable();
      this.OrdenesDeCompraForm.get('documentoproveedorinput')?.enable();

      // Deshabilitar campos que siempre están deshabilitados
      this.OrdenesDeCompraForm.get('nroordencompra')?.disable();
      this.OrdenesDeCompraForm.get('fechaRegistro')?.disable();
      this.OrdenesDeCompraForm.get('proveedor')?.enable();
      this.OrdenesDeCompraForm.get('estado')?.disable();
    }
  }
  
  onCellClickedArticulo(event: any) {
  }
  onCellValueChangedArticulo(event: any) {
    if (!event?.data) return;

    const lineaActualizada = this.recalcularLineaArticulo(event.data);
    this.rowDataArticulos = this.rowDataArticulos.map((item) =>
      item.det_orden_compra_codigo === event.data.det_orden_compra_codigo ? lineaActualizada : item
    );

    if (this.gridApiArticulos) {
      this.gridApiArticulos.applyTransaction({ update: [lineaActualizada] });
    }

    this.actualizarTotales();
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
      this.actualizarEstadoOrden('Rechazada');
    }
  }
  cargarCentroCostos() {
    // Centros de costo: GET /contabilidad/centros-costo (lista paginada)
    this.api.get<any>('/contabilidad/centros-costo', { page: 0, size: 1000 }).subscribe({
      next: (response) => {
        this.centrosC = this.mapearCentrosCosto(response);
      },
      error: (err) => {
        console.error('Error cargando centros de costo:', err);
        this.centrosC = [];
      },
    });
  }

  /** Normaliza la respuesta de /contabilidad/centros-costo a [{ id, nombre }] activos. */
  private mapearCentrosCosto(response: any): { id: any; nombre: string }[] {
    const lista = Array.isArray(response)
      ? response
      : Array.isArray(response?.content)
        ? response.content
        : Array.isArray(response?.data)
          ? response.data
          : [];
    return lista
      .filter((c: any) => c?.flagEstado !== '0' && c?.activo !== false)
      .map((c: any) => {
        const nombre = c.descCencos ?? c.nombre ?? c.centro_costo_nombre ?? c.descripcion ?? c.cencos ?? '';
        return {
          id: c.id,
          nombre: String(nombre) || String(c.id),
        };
      });
  }
  async abrirModalRetornarOrden() {
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
        colorBotonConfirmar: 'solid'
      }
    });
    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      this.actualizarEstadoOrden('Retornada');
    }
  }
  async abrirModalCrearProductoActivoFijo() {
    const modal = await this.modalController.create({
      component: ModalCrearAtfprodComponent,
      cssClass: 'promo2',
      componentProps: {
      }
    });
    await modal.present();

    const { data, role } = await modal.onWillDismiss();
    console.log('  Modal cerrado con role:', role, 'data:', data);

    if (data && data.action === 'created') {
      const tipoCreado = data.tipo; // 'producto' o 'activoFijo'
      const itemCreado = data.data;

      console.log(`  Tipo creado: ${tipoCreado}`, itemCreado);

      if (tipoCreado === 'producto') {
        this.cargarProductosDesdeApi();
        console.log('Productos recargados después de crear nuevo item');

        // Forzar actualización del autocomplete si existe
        if (this.autocompleteProductos) {
          // Crear una nueva referencia del array para forzar detección de cambios
          this.productos = [...this.productos];
          console.log('  Autocomplete de productos actualizado');
        }

        // Agregar automáticamente el producto creado a la tabla de artículos
        console.log('  Agregando producto creado a la tabla:', itemCreado);

        // Verificar si el producto ya existe en la tabla
        const productoExistente = this.rowDataArticulos.find((item: any) => item.det_orden_compra_codigo === itemCreado.codigo);
        if (!productoExistente) {
          // Cantidad por defecto
          const cantidad = 1;
          const precioUnitario = itemCreado.precioUnitario || 0;
          const subtotal = cantidad * precioUnitario;
          const impuestos = subtotal * 0.18; // IGV 18%
          const total = subtotal + impuestos;

          // Crear nuevo artículo para la tabla
          const nuevoArticulo: IArticulo = {
            det_orden_compra_codigo: itemCreado.codigo,
            det_orden_compra_cantidad: cantidad,
            det_orden_compra_descripcion: itemCreado.descripcion || itemCreado.producto,
            det_orden_compra_unidad: itemCreado.unidad,
            det_orden_compra_precio_unitario: precioUnitario,
            det_orden_compra_subtotal: subtotal,
            det_orden_compra_impuestos: impuestos,
            det_orden_compra_total: total
          };

          // Agregar a la tabla
          this.rowDataArticulos = [...this.rowDataArticulos, nuevoArticulo];

          // Actualizar grid si existe
          if (this.gridApiArticulos) {
            this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
          }

          // Recalcular totales
          this.calcularTotales();

          console.log(' Producto agregado a la tabla automáticamente');
        } else {
          console.log('  El producto ya existe en la tabla');
        }

      } else if (tipoCreado === 'activoFijo') {
        // Agregar automáticamente el activo fijo creado a la tabla de artículos
        console.log('  Agregando activo fijo creado a la tabla:', itemCreado);

        // Verificar si el activo fijo ya existe en la tabla
        const activoExistente = this.rowDataArticulos.find((item: any) => item.det_orden_compra_codigo === itemCreado.codigo);
        if (!activoExistente) {
          // Cantidad por defecto
          const cantidad = 1;
          const precioUnitario = parseFloat(itemCreado.valorAdquisicion) || 0;
          const subtotal = cantidad * precioUnitario;
          const impuestos = subtotal * 0.18; // IGV 18%
          const total = subtotal + impuestos;

          // Crear nuevo artículo para la tabla
          const nuevoArticulo: IArticulo = {
            det_orden_compra_codigo: itemCreado.codigo,
            det_orden_compra_cantidad: cantidad,
            det_orden_compra_descripcion: itemCreado.nombre,
            det_orden_compra_unidad: 'Unidad',
            det_orden_compra_precio_unitario: precioUnitario,
            det_orden_compra_subtotal: subtotal,
            det_orden_compra_impuestos: impuestos,
            det_orden_compra_total: total
          };

          // Agregar a la tabla
          this.rowDataArticulos = [...this.rowDataArticulos, nuevoArticulo];

          // Actualizar grid si existe
          if (this.gridApiArticulos) {
            this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
          }

          // Recalcular totales
          this.calcularTotales();

          console.log(' Activo fijo agregado a la tabla automáticamente');
        } else {
          console.log('  El activo fijo ya existe en la tabla');
        }
      }
    }
  }
  onCentroCSeleccionado(centroC: any) {
    // Guardar el ID del centro de costos (lo espera el backend como centrosCostoId)
    this.OrdenesDeCompraForm.patchValue({
      centrocosto: centroC?.id ?? null
    });
  }
  private actualizarEstadoOrden(nuevoEstado: string) {
    if (!this.ordenSeleccionada) return;
    // Actualizar el estado en el array rowData
    const index = this.rowData.findIndex(orden => orden.orden_compra_numero === this.ordenSeleccionada!.orden_compra_numero);
    if (index !== -1) {
      (this.rowData[index] as any).orden_compra_estado = nuevoEstado;
      this.ordenSeleccionada.orden_compra_estado = nuevoEstado;

      // Actualizar el formulario
      this.OrdenesDeCompraForm.patchValue({ estado: nuevoEstado });

      // Refrescar la tabla
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }

      this.configurarFormularioSegunEstado(nuevoEstado);

      console.log(`Orden ${this.ordenSeleccionada.orden_compra_numero} actualizada a estado: ${nuevoEstado}`);
    }
  }
  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    this.aplicarFiltroFechas();
  }

  /** Campo de fecha sobre el que aplica el filtro de rango, según el select. */
  private fechaFiltroField(): string {
    return this.tipoFechaFiltro === '1'
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

  onFechaEntrega(date: Date) {
    this.fechaEntrega = date;
    // Guardar en formato DD/MM/YYYY con ceros (toLocaleDateString no rellena ceros,
    // lo que generaba fechas inválidas como 2026-7-6 al convertir a ISO).
    const fechaFormateada = this.formatearFecha(date);
    this.OrdenesDeCompraForm.patchValue({
      fechaEntrega: fechaFormateada
    });
    console.log(' Fecha de entrega seleccionada:', fechaFormateada, date);
  }
  onSucursalSeleccionada(sucursal: any) {
    console.log(' Sucursal seleccionada:', sucursal);
    // Guardar el ID de la sucursal (que es la clave para el autocomplete)
    const idSucursal = sucursal.id || '';
    const nombreSucursal = sucursal.nombre || '';
    this.OrdenesDeCompraForm.patchValue({
      localentrega: idSucursal,
      direccionEntrega: sucursal.direccionEntrega || ''
    });
    console.log('  Sucursal guardada - ID:', idSucursal, 'Nombre:', nombreSucursal);
  }
  onAlmacenSeleccionado(almacen: any) {
    console.log(' Almacén seleccionado:', almacen);
    // Guardar el VALUE/CODE del almacén (que es la clave para el autocomplete)
    const valueAlmacen = almacen.value || almacen.codigo || '';
    const nombreAlmacen = almacen.nombre || '';
    this.OrdenesDeCompraForm.patchValue({
      almacen: valueAlmacen
    });
    console.log('  Almacén guardado - Value:', valueAlmacen, 'Nombre:', nombreAlmacen);
  }
  actualizarTipoCambio(moneda: string) {
    const monedaSeleccionada = this.monedas.find((item) => item.codigo === moneda || String(item.id) === String(moneda));
    if (!monedaSeleccionada) {
      this.OrdenesDeCompraForm.patchValue({ tipoCambio: '' }, { emitEvent: false });
      return;
    }

    if (monedaSeleccionada.codigo === 'PEN') {
      this.OrdenesDeCompraForm.patchValue({ tipoCambio: 1 });
      return;
    }

    this.api.get<any[]>('/core/tipos-cambio', {
      monedaId: monedaSeleccionada.id,
      page: 0,
      size: 100
    }).subscribe({
      next: (response) => {
        const responseData: any = response;
        const tiposCambio = Array.isArray(responseData)
          ? responseData
          : Array.isArray(responseData?.content)
            ? responseData.content
            : [];
        const activo = [...tiposCambio].sort((a: any, b: any) =>
          String(b.fecha ?? '').localeCompare(String(a.fecha ?? ''))
        )[0];

        if (!activo) {
          this.OrdenesDeCompraForm.patchValue({ tipoCambio: '' }, { emitEvent: false });
          this.toastService.warning(`No hay tipo de cambio disponible para ${monedaSeleccionada.codigo}`);
          return;
        }

        this.OrdenesDeCompraForm.patchValue({
          tipoCambio: Number(activo.venta ?? activo.tipoCambioVenta ?? 0).toFixed(5)
        }, { emitEvent: false });
      },
      error: () => {
        this.OrdenesDeCompraForm.patchValue({ tipoCambio: '' }, { emitEvent: false });
        this.toastService.warning(`No se pudo obtener tipo de cambio para ${monedaSeleccionada.codigo}`);
      }
    });
  }
  /**
   * Formatea una fecha a formato DD/MM/YYYY
   */
  private formatearFecha(fecha: Date): string {
    const dia = fecha.getDate().toString().padStart(2, '0');
    const mes = (fecha.getMonth() + 1).toString().padStart(2, '0');
    const anio = fecha.getFullYear();
    return `${dia}/${mes}/${anio}`;
  }

  /** Devuelve la fecha de hoy en formato YYYY-MM-DD (requerido por input[type=date]) */
  private fechaHoyISO(): string {
    const hoy = new Date();
    return `${hoy.getFullYear()}-${String(hoy.getMonth() + 1).padStart(2, '0')}-${String(hoy.getDate()).padStart(2, '0')}`;
  }

  /** Convierte DD/MM/YYYY → YYYY-MM-DD para input[type=date] */
  private fechaAInputDate(fecha: string): string {
    if (!fecha) return '';
    // Si ya viene en formato YYYY-MM-DD, devolver tal cual
    if (/^\d{4}-\d{2}-\d{2}$/.test(fecha)) return fecha;
    // Convertir DD/MM/YYYY (rellenando ceros: el backend exige ISO yyyy-MM-dd)
    const partes = fecha.split('/');
    if (partes.length !== 3) return '';
    const dia = partes[0].padStart(2, '0');
    const mes = partes[1].padStart(2, '0');
    const anio = partes[2];
    return `${anio}-${mes}-${dia}`;
  }

  /**
   * Parsear fecha en formato DD/MM/YYYY a Date
   */
  private parsearFechaString(fechaStr: string): Date {
    if (!fechaStr) return new Date();
    const partes = fechaStr.split('/');
    if (partes.length !== 3) return new Date();
    return new Date(
      parseInt(partes[2]),
      parseInt(partes[1]) - 1,
      parseInt(partes[0])
    );
  }
  calcularTotales() {
    this.subtotalGeneral = this.rowDataArticulos.reduce((sum, item) => sum + (item.det_orden_compra_subtotal || 0), 0);
    this.impuestosGenerales = this.rowDataArticulos.reduce((sum, item) => sum + (item.det_orden_compra_impuestos || 0), 0);
    this.totalGeneral = this.rowDataArticulos.reduce((sum, item) => sum + (item.det_orden_compra_total || 0), 0);

    console.log(' Totales calculados - Subtotal:', this.subtotalGeneral, 'Impuestos:', this.impuestosGenerales, 'Total:', this.totalGeneral);
  }
  onProductoSeleccionado(producto: any) {
    const productoExistente = this.rowDataArticulos.find(item => item.det_orden_compra_codigo === producto.codigo);
    if (productoExistente) {
      this.toastService.warning('El producto ya está agregado a la orden');
      if (this.autocompleteProductos) {
        this.autocompleteProductos.clearSelection();
      }
      return;
    }

    const proveedorId = Number(this.proveedorSeleccionadoActual?.id ?? 0);
    const monedaSeleccionada = this.monedas.find((item) => item.codigo === this.OrdenesDeCompraForm.get('moneda')?.value);
    const sucursalId = Number(this.OrdenesDeCompraForm.get('localentrega')?.value || this.storageService.getUser<SessionUserLike>()?.sucursalId || 0);
    const impuestoDefault = this.impuestos.find((item) => Number(item.tasaImpuesto ?? item.tasa ?? 0) > 0) ?? this.impuestos[0];

    const agregarArticulo = (datosArticulo?: any) => {
      const cantidad = 1;
      const precioUnitario = Number(datosArticulo?.precioPactado ?? producto.precioUnitario ?? 0);
      const tasaImpuesto = Number(impuestoDefault?.tasaImpuesto ?? impuestoDefault?.tasa ?? 0);
      const nuevoArticulo: IArticulo & Record<string, unknown> = this.recalcularLineaArticulo({
        articuloId: producto.articuloId ?? producto.id,
        unidadMedidaId: datosArticulo?.unidadMedidaId ?? producto.unidadMedidaId ?? producto.unidadMedida?.id ?? null,
        almacenId: datosArticulo?.almacenTacitoId ?? null,
        tipoImpuesto: this.resolverTipoImpuestoCodigo(impuestoDefault),
        tipoImpuestoId: impuestoDefault?.id ?? null,
        igvTasa: tasaImpuesto,
        percepcionTasa: 0,
        descuentoPorcentaje: 0,
        fechaEntrega: this.fechaAInputDate(this.OrdenesDeCompraForm.getRawValue().fechaEntrega || this.fechaHoyISO()),
        det_orden_compra_codigo: producto.codigo,
        det_orden_compra_cantidad: cantidad,
        det_orden_compra_descripcion: producto.nombreArticulo || producto.descripcion,
        det_orden_compra_unidad: datosArticulo?.unidadMedidaDescripcion || producto.unidad,
        det_orden_compra_precio_unitario: precioUnitario,
        det_orden_compra_subtotal: 0,
        det_orden_compra_impuestos: 0,
        det_orden_compra_total: 0
      } as IArticulo & Record<string, unknown>);
      this.rowDataArticulos = [...this.rowDataArticulos, nuevoArticulo];
      if (this.gridApiArticulos) {
        this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
      }
      this.actualizarTotales();
      setTimeout(() => this.autocompleteProductos?.clearSelection(), 100);
    };

    if (!proveedorId || !monedaSeleccionada?.id || !sucursalId) {
      agregarArticulo();
      return;
    }

    this.api.get<any>('/compras/ordenes-compra/datos-articulo', {
      articuloId: producto.articuloId ?? producto.id,
      proveedorId,
      monedaId: monedaSeleccionada.id,
      sucursalId,
      fechaEmision: this.OrdenesDeCompraForm.getRawValue().fechaRegistro || this.fechaHoyISO()
    }).subscribe({
      next: (response) => agregarArticulo(response),
      error: () => agregarArticulo()
    });
  }
  private actualizarTotales() {
    this.subtotalGeneral = this.rowDataArticulos.reduce((sum, item) => sum + (item.det_orden_compra_subtotal || 0), 0);
    this.impuestosGenerales = this.rowDataArticulos.reduce((sum, item) => sum + (item.det_orden_compra_impuestos || 0), 0);
    this.totalGeneral = this.rowDataArticulos.reduce((sum, item) => sum + (item.det_orden_compra_total || 0), 0);

    console.log(' Totales - Subtotal:', this.subtotalGeneral.toFixed(2), 'Impuestos:', this.impuestosGenerales.toFixed(2), 'Total:', this.totalGeneral.toFixed(2));
  }
  buscarProductos(texto: string) {
    const termino = String(texto ?? '').trim();
    this.ultimaBusquedaProductos = termino;

    if (termino.length < 2) {
      this.cargarProductosDesdeApi();
      return;
    }

    const pareceCodigo = /^[A-Za-z0-9\\-_.]+$/.test(termino) && /\d/.test(termino);
    this.api.get<any>('/core/articulos', {
      codigo: pareceCodigo ? termino : undefined,
      nombre: pareceCodigo ? undefined : termino,
      page: 0,
      size: 50
    }).subscribe({
      next: (response) => {
        const articulos = Array.isArray(response)
          ? response
          : Array.isArray(response?.content)
            ? response.content
            : [];

        this.productos = articulos
          .filter((item: any) => item.flagEstado !== '0')
          .map((item: any) => ({
            ...item,
            articuloId: item.id,
            codigo: item.codigo || '',
            descripcion: `${item.codigo || ''} - ${item.nombre || item.descripcion || ''}`.trim(),
            nombreArticulo: item.nombre || item.descripcion || '',
            producto: item.nombre || item.descripcion || '',
            unidad: item.unidadMedidaCodigo || item.unidadMedida?.codigo || 'UND',
            unidadMedida: item.unidadMedidaCodigo || item.unidadMedida?.codigo || 'UND',
            precioUnitario: 0,
            stockActual: 0
          }));
      },
      error: (err) => {
        console.error('Error buscando artículos:', err);
        this.productos = [];
      }
    });
  }
  private recalcularLineaArticulo(linea: IArticulo & Record<string, unknown>): IArticulo & Record<string, unknown> {
    const cantidad = this.parsearNumeroEditable(linea.det_orden_compra_cantidad);
    const precioUnitario = this.parsearNumeroEditable(linea.det_orden_compra_precio_unitario);
    const tasaImpuesto = this.parsearNumeroEditable(linea['igvTasa'] ?? this.obtenerTasaImpuesto(linea['tipoImpuestoId']));
    const subtotal = cantidad * precioUnitario;
    const impuestos = subtotal * (tasaImpuesto / 100);
    const total = subtotal + impuestos;

    return {
      ...linea,
      igvTasa: tasaImpuesto,
      percepcionTasa: this.parsearNumeroEditable(linea['percepcionTasa']),
      descuentoPorcentaje: this.parsearNumeroEditable(linea['descuentoPorcentaje']),
      det_orden_compra_cantidad: cantidad,
      det_orden_compra_precio_unitario: precioUnitario,
      det_orden_compra_subtotal: subtotal,
      det_orden_compra_impuestos: impuestos,
      det_orden_compra_total: total
    };
  }

  private obtenerTasaImpuesto(tipoImpuestoId: unknown): number {
    const impuesto = this.impuestos.find((item) => Number(item.id) === Number(tipoImpuestoId));
    return Number(impuesto?.tasaImpuesto ?? impuesto?.tasa ?? 0);
  }

  private resolverTipoImpuestoCodigo(impuesto: any): string | null {
    const codigo = String(impuesto?.codigo ?? '').trim();
    if (codigo) {
      return codigo;
    }

    const descripcion = String(impuesto?.descripcion ?? impuesto?.nombre ?? '').trim().toLowerCase();
    if (descripcion.includes('grav')) {
      return 'GRAVADO';
    }
    if (descripcion.includes('exoner')) {
      return 'EXONERADO';
    }
    if (descripcion.includes('inafect')) {
      return 'INAFECTO';
    }

    return null;
  }

  private parsearNumeroEditable(valor: unknown): number {
    const numero = Number(valor);
    return Number.isFinite(numero) && numero >= 0 ? numero : 0;
  }
  async crearNuevaOrden(validarCambios: boolean = true) {
    // Validar cambios si es necesario
    if (validarCambios) {
      const confirmar = await this.formValidationService.validarCambios();
      if (!confirmar) {
        return; // Usuario canceló
      }
    }

    this.botoncuotas = 'Editar';
    this.ordenSeleccionada = null;
    this.filaSeleccionada = null;
    this.modoCreacion = true;
    this.esNuevaOrden = true;
    this.puedeEditarFormulario = true;
    this.mostrarCamposDeshabilitados = false;
    this.titulo = 'Nueva Orden de Compra';
    
    // Resetear fecha de entrega del calendario
    this.fechaEntrega = undefined;

    // Deseleccionar todas las filas de la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Limpiar la tabla de artículos
    this.rowDataArticulos = [];
    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
    }

    // Resetear totales
    this.subtotalGeneral = 0;
    this.impuestosGenerales = 0;
    this.totalGeneral = 0;

    // Limpiar el formulario completamente
    this.OrdenesDeCompraForm.reset({
      fechaRegistro: this.fechaHoyISO(),
      documentoproveedor: 'RUC',
      emitidoPor: 'Usuario Admin',
      estado: 'Pendiente',
    });

    // Deshabilitar campos fijos
    this.OrdenesDeCompraForm.get('proveedor')?.disable();
    this.OrdenesDeCompraForm.get('razonSocial')?.disable();
    this.OrdenesDeCompraForm.get('ruc')?.disable();
    this.OrdenesDeCompraForm.get('nroordencompra')?.disable();
    this.OrdenesDeCompraForm.get('fechaRegistro')?.disable();
    this.OrdenesDeCompraForm.get('emitidoPor')?.disable();
    this.OrdenesDeCompraForm.get('tipoCambio')?.disable();
    this.OrdenesDeCompraForm.get('estado')?.disable();

    // Habilitar TODOS los campos editables para nueva orden
    this.OrdenesDeCompraForm.get('documentoproveedor')?.enable();
    this.OrdenesDeCompraForm.get('documentoproveedorinput')?.enable();
    this.OrdenesDeCompraForm.get('fechaEntrega')?.enable();
    this.OrdenesDeCompraForm.get('localentrega')?.enable();
    this.OrdenesDeCompraForm.get('almacen')?.enable();
    this.OrdenesDeCompraForm.get('direccionFiscal')?.enable();
    this.OrdenesDeCompraForm.get('direccionEntrega')?.enable();
    this.OrdenesDeCompraForm.get('moneda')?.enable();
    this.OrdenesDeCompraForm.get('condicionPago')?.enable();

    // Resetear estado de validación
    this.formValidationService.resetearEstado();
  }
  async cancelar() {
    // Validar cambios antes de cancelar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló - se queda en la orden actual
      console.log('  Usuario canceló la acción de cancelar');
      return;
    }

    // Usuario confirmó - crear nueva orden
    console.log('  Usuario confirmó - creando nueva orden');
    this.crearNuevaOrden(false);
  }
  guardarCambios() {
    if (this.OrdenesDeCompraForm.invalid) {
      this.OrdenesDeCompraForm.markAllAsTouched();
      this.toastService.danger('Por favor completa todos los campos requeridos');
      return;
    }

    const formData = this.OrdenesDeCompraForm.getRawValue();

    // Validación: debe existir un proveedor seleccionado
    if (!this.proveedorSeleccionadoActual?.id) {
      this.toastService.warning('Busca y selecciona un proveedor válido por su documento.');
      return;
    }

    // Validación: al menos una línea de detalle
    if (!this.rowDataArticulos.length) {
      this.toastService.warning('Agrega al menos un artículo a la orden de compra.');
      return;
    }

    // Validación: fecha de entrega no puede ser anterior a la de emisión/registro
    const emisionISO = (formData.fechaRegistro || this.fechaHoyISO()).substring(0, 10);
    const entregaISO = this.fechaAInputDate(formData.fechaEntrega || '');
    if (entregaISO && emisionISO && entregaISO < emisionISO) {
      this.toastService.warning('La fecha de entrega no puede ser anterior a la fecha de registro.');
      return;
    }

    const monedaSeleccionada = this.monedas.find((item) => item.codigo === formData.moneda);
    const sucursalSeleccionada = this.sucursales.find((s: any) => String(s.id) === String(formData.localentrega));
    const almacenSeleccionado = this.almacenes.find((a: any) => String(a.value) === String(formData.almacen));

    const payload: OrdenCompraEntity = {
      ...(this.ordenSeleccionada ?? {}),
      proveedorId: this.proveedorSeleccionadoActual?.id,
      sucursalId: sucursalSeleccionada?.id,
      monedaId: monedaSeleccionada?.id,
      orden_compra_numero: this.ordenSeleccionada?.orden_compra_numero || '',
      orden_compra_fecha_registro: formData.fechaRegistro || this.fechaHoyISO(),
      orden_compra_fecha_entrega: this.fechaAInputDate(formData.fechaEntrega || ''),
      orden_compra_proveedor: formData.proveedor || '',
      documentoproveedor: formData.documentoproveedor || 'RUC',
      documentoproveedorinput: formData.documentoproveedorinput || '',
      direccionFiscal: formData.direccionFiscal || '',
      direccionEntrega: formData.direccionEntrega || '',
      orden_compra_almacen: String(almacenSeleccionado?.value ?? formData.almacen ?? ''),
      orden_compra_sucursal: String(sucursalSeleccionada?.id ?? formData.localentrega ?? ''),
      orden_compra_centro_costo: formData.centrocosto || '',
      orden_compra_moneda: monedaSeleccionada?.codigo || formData.moneda || '',
      orden_compra_tipo_cambio: String(formData.tipoCambio || ''),
      orden_compra_condicion_pago: String(formData.condicionPago || ''),
      observaciones: formData.observaciones || '',
      flagImportacion: false,
      flagSolicitaDua: false,
      orden_compra_total: this.rowDataArticulos.reduce((sum, item) => sum + (item.det_orden_compra_total || 0), 0),
      orden_compra_estado: this.ordenSeleccionada?.orden_compra_estado || 'Pendiente',
      orden_compra_articulos: this.rowDataArticulos.map((item: any) => ({
        ...item,
        unidadMedidaId: item.unidadMedidaId ?? null,
        tipoImpuesto: item.tipoImpuesto ?? null,
        igvTasa: item.igvTasa ?? this.obtenerTasaImpuesto(item.tipoImpuestoId),
        percepcionTasa: item.percepcionTasa ?? 0,
        descuentoPorcentaje: item.descuentoPorcentaje ?? 0,
        fechaEntrega: item.fechaEntrega ?? this.fechaAInputDate(formData.fechaEntrega || ''),
        almacenId: item.almacenId ?? almacenSeleccionado?.id ?? null,
        // El centro de costo se toma del combobox del formulario y se aplica a todas las líneas.
        centrosCostoId: formData.centrocosto || item.centrosCostoId || null,
        centrocostos: formData.centrocosto || item.centrosCostoId || null,
      })),
    };

    if (this.ordenSeleccionada?.['id']) {
      this.ordenCompraFacade.actualizarOrdenCompra(payload);
      this.toastService.success('¡Cambios guardados exitosamente!');
    } else {
      this.ordenCompraFacade.guardarOrdenCompra(payload);
      this.toastService.success('¡Orden creada exitosamente!');
    }

    this.formValidationService.resetearEstado();
    this.ordenCompraFacade.cargarOrdenesCompra();
    this.crearNuevaOrden(false);
  }

  /**
   * Anula la orden de compra seleccionada (baja lógica vía /anular).
   */
  async anularOrden() {
    const orden = this.ordenSeleccionada;
    if (!orden?.['id'] && !orden?.orden_compra_numero) {
      this.toastService.warning('Selecciona una orden de compra para anular');
      return;
    }

    const estado = String(orden?.orden_compra_estado ?? '').toLowerCase();
    if (estado === 'rechazada' || estado === 'cerrada') {
      this.toastService.warning('La orden no se puede anular en su estado actual');
      return;
    }

    const confirmar = window.confirm(
      `¿Confirmas anular la orden de compra ${orden?.orden_compra_numero ?? ''}? Esta acción no se puede deshacer.`
    );
    if (!confirmar) {
      return;
    }

    const identificador = orden?.['id'] ? String(orden['id']) : String(orden?.orden_compra_numero ?? '');
    this.ordenCompraFacade.eliminarOrdenCompra(identificador);
    this.toastService.success('Solicitud de anulación enviada');
    this.ordenCompraFacade.cargarOrdenesCompra();
    this.crearNuevaOrden(false);
  }

  buscarproveedor() {
    const tipoDoc = this.OrdenesDeCompraForm.get('documentoproveedor')?.value;
    let numeroDoc = this.OrdenesDeCompraForm.get('documentoproveedorinput')?.value;

    if (!numeroDoc) {
      this.toastService.warning('Por favor, ingresa un número de documento');
      return;
    }

    numeroDoc = String(numeroDoc).trim();

    this.api.get<any>('/core/relaciones-comerciales', {
      esProveedor: true,
      nroDocumento: numeroDoc,
      page: 0,
      size: 20,
    }).subscribe({
      next: (response) => {
        const proveedores = Array.isArray(response)
          ? response
          : Array.isArray(response?.content)
            ? response.content
            : [];
        const proveedorActivo = proveedores.find((p: any) => p.flagEstado === '1');

        if (!proveedorActivo) {
          this.proveedorSeleccionadoActual = null;
          this.toastService.warning(
            'Proveedor no encontrado',
            `No se encontró ${tipoDoc}: ${numeroDoc} o el proveedor está inactivo`
          );
          return;
        }

        this.proveedorSeleccionadoActual = {
          id: proveedorActivo.id,
          proveedor_codigo: String(proveedorActivo.id ?? proveedorActivo.nroDocumento ?? ''),
          proveedor_razon_social: proveedorActivo.razonSocial ?? '',
          proveedor_identificacion_fiscal: proveedorActivo.nroDocumento ?? '',
          proveedor_estado: 'Activo',
          proveedor_direccion_fiscal: proveedorActivo.direccion ?? '',
        } as ProveedorEntity;

        this.OrdenesDeCompraForm.patchValue({
          proveedor: proveedorActivo.razonSocial ?? '',
          direccionFiscal: proveedorActivo.direccion ?? ''
        });
      },
      error: () => {
        this.proveedorSeleccionadoActual = null;
        this.toastService.danger('No se pudo consultar el proveedor en backend');
      }
    });
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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar'},
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385'},
      { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380'},
      { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - Tipo de Cambio',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

  /**
   * Cargar almacenes desde JSON
   */
  cargarAlmacenesDesdeApi() {
    this.api.get<any>('/almacen/almacenes', { page: 0, size: 1000 }).subscribe({
      next: (data) => {
        const almacenes = Array.isArray(data)
          ? data
          : Array.isArray(data?.content)
            ? data.content
            : [];
        this.almacenes = almacenes
          .filter((item: any) => item.flagEstado !== '0')
          .map((item: any) => ({
          id: item.id,
          value: item.id,
          nombre: item.nombre,
          codigo: item.codigo,
          ...item
        }));
      },
      error: (err) => console.error('Error cargando almacenes:', err)
    });
  }

  cargarProductosDesdeApi() {
    this.api.get<any>('/core/articulos', { page: 0, size: 1000 }).subscribe({
      next: (response) => {
        const articulos = Array.isArray(response)
          ? response
          : Array.isArray(response?.content)
            ? response.content
            : [];
        this.productos = articulos
          .filter((item: any) => item.flagEstado !== '0')
          .map((item: any) => ({
            ...item,
            articuloId: item.id,
            codigo: item.codigo || '',
            descripcion: `${item.codigo || ''} - ${item.nombre || item.descripcion || ''}`.trim(),
            nombreArticulo: item.nombre || item.descripcion || '',
            producto: item.nombre || item.descripcion || '',
            unidad: item.unidadMedidaCodigo || item.unidadMedida?.codigo || 'UND',
            unidadMedida: item.unidadMedidaCodigo || item.unidadMedida?.codigo || 'UND',
            precioUnitario: 0,
            stockActual: 0
          }));

        if (this.ultimaBusquedaProductos.trim().length >= 2) {
          this.buscarProductos(this.ultimaBusquedaProductos);
        }
      },
      error: (err) => console.error('Error cargando artículos desde endpoint:', err)
    });
  }

  /**
   * Cargar condiciones de pago desde el store
   * @deprecated Reemplazado por CondicionPagoFacade vía effect()
   */
  cargarCondicionesPagoDesdeSimulacion() {
    this.condicionPagoFacade.cargarCondicionesPago();
  }

  /**
   * Cargar órdenes desde el store usando el facade
   */
  cargarOrdenesDesdeApi() {
    this.ordenCompraFacade.cargarOrdenesCompra();
  }

  private readonly columnasExport = [
    { header: 'Nº Orden de compra', field: 'orden_compra_numero' },
    { header: 'Fecha registro', field: 'orden_compra_fecha_registro' },
    { header: 'Fecha entrega', field: 'orden_compra_fecha_entrega' },
    { header: 'Proveedor', field: 'orden_compra_proveedor' },
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
      `ordenes-compra-${this.gridExport.fechaHoy()}`,
      this.columnasExport,
      filas,
      'Órdenes de compra',
    );
  }

  async exportarPdf(): Promise<void> {
    const filas = this.gridExport.obtenerFilas(this.gridApi, this.rowData) as Array<Record<string, unknown>>;
    if (!filas.length) {
      this.toastService.warning('No hay órdenes para exportar');
      return;
    }
    await this.gridExport.exportarPdf(
      'Órdenes de compra',
      `ordenes-compra-${this.gridExport.fechaHoy()}`,
      this.columnasExport,
      filas,
    );
  }

  /**
   * Valida si la condición de pago permite mostrar el botón de cuotas
   * Solo muestra para condiciones de pago: Mixta o Crédito
   * No muestra para: Al Contado
   */
  isCondicionPagoWithCuotas(): boolean {
    const condicionPago = this.OrdenesDeCompraForm.get('condicionPago')?.value;
    if (!condicionPago) return false;
    
    // Encontrar la condición de pago seleccionada
    const condicion = this.condicionesPago.find(c => c.codigo === condicionPago);
    if (!condicion) return false;
    
    // Verificar si es Al Contado (case-insensitive)
    const nombreLower = condicion.nombre?.toLowerCase().trim() || '';
    const esAlContado = nombreLower === 'al contado' || 
                        nombreLower === 'contado' || 
                        nombreLower.includes('contado');
    
    
    // NO mostrar cuotas si es Al Contado
    return !esAlContado;
  }

  async abrirmodalcuotas() {
    // Verificar si hay una orden seleccionada o se está creando una nueva
    const ordenId = this.ordenSeleccionada?.orden_compra_numero || this.titulo || 'Nueva Orden de Compra';


    // Obtener la condición de pago seleccionada
    const codigoCondicion = this.OrdenesDeCompraForm.get('condicionPago')?.value;
    let nombreCondicion = '';
    
    if (codigoCondicion) {
      const condicion = this.condicionesPago.find(c => c.codigo === codigoCondicion);
      nombreCondicion = condicion?.nombre || '';
    }

    // Obtener el monto total de la orden
    const montoTotal = this.ordenSeleccionada?.orden_compra_total || this.totalGeneral || 0;
    console.log('Monto total enviado al modal:', montoTotal);

    const modal = await this.modalController.create({
      component: ModalCuotasComponent,
      cssClass: 'promo',
      componentProps: {
        ordenCompraId: ordenId,
        cuotasExistentes: null,
        condicionPago: nombreCondicion,
        montoTotal: montoTotal,
        titulo: 'Configuración de cuotas'
      }
    });

    await modal.present();

    // Esperar la respuesta del modal
    const { data } = await modal.onWillDismiss();

    if (data && data.action === 'guardar') {
      this.botoncuotas = 'Editar';
    }
  }

  /**
   * Carga las formas de pago reales (core.forma_pago). El combo usa el id como `codigo`
   * porque el backend de la OC persiste forma_pago_id → core.forma_pago(id).
   */
  private cargarFormasPagoApi() {
    this.api.get<any>('/core/formas-pago', { page: 0, size: 1000 }).subscribe({
      next: (response) => {
        const formas = Array.isArray(response)
          ? response
          : Array.isArray(response?.content)
            ? response.content
            : [];
        this.condicionesPago = formas
          .filter((item: any) => item.flagEstado !== '0')
          .map((item: any) => ({
            id: item.id,
            codigo: String(item.id),
            nombre: item.nombre ?? item.codigo ?? String(item.id),
            tipo: item.tipo ?? ''
          }));
      },
      error: (err) => console.error('Error cargando formas de pago:', err)
    });
  }

  /**
   * Devuelve el código de moneda (PEN/USD/EUR…) tal como lo espera el <ion-select>,
   * a partir del valor guardado en la orden, que puede venir como nombre ('Soles',
   * 'Dólares') o como código. Hace match contra la lista real de monedas y, si no
   * encuentra, usa sinónimos conocidos.
   */
  private resolverCodigoMoneda(valor: any): string {
    const norm = (s: any) => String(s ?? '')
      .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
      .trim().toLowerCase();
    const v = norm(valor);
    if (!v) {
      return '';
    }
    // Match directo por código o por nombre en la lista cargada.
    const encontrado = this.monedas.find((m: any) => norm(m.codigo) === v || norm(m.nombre) === v);
    if (encontrado) {
      return encontrado.codigo;
    }
    // Sinónimos: soles → PEN, dólares → USD.
    if (v.includes('sol') || v === 'pen' || v === 's/' || v === 's/.') {
      return this.monedas.find((m: any) => norm(m.codigo) === 'pen' || norm(m.nombre).includes('sol'))?.codigo ?? String(valor ?? '');
    }
    if (v.includes('dolar') || v === 'usd' || v === '$') {
      return this.monedas.find((m: any) => norm(m.codigo) === 'usd' || norm(m.nombre).includes('dolar'))?.codigo ?? String(valor ?? '');
    }
    return String(valor ?? '');
  }

  private cargarMonedasDesdeApi() {
    this.api.get<any>('/core/monedas', { page: 0, size: 1000 }).subscribe({
      next: (response) => {
        const monedas = Array.isArray(response)
          ? response
          : Array.isArray(response?.content)
            ? response.content
            : [];
        const normalizar = (v: any) => String(v ?? '')
          .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
          .trim().toLowerCase();
        const ordenCanonico = ['PEN', 'USD', 'EUR'];

        const mapeadas = monedas
          .filter((item: any) => item.flagEstado !== '0' && item.activa !== false)
          .map((item: any) => ({
            id: item.id,
            codigo: item.codigo,
            nombre: item.nombre,
            display: `${item.codigo} - ${item.nombre}`
          }))
          // Si hay nombres duplicados, conserva primero el de código estándar (PEN/USD/EUR).
          .sort((a: any, b: any) => {
            const ia = ordenCanonico.indexOf(String(a.codigo ?? '').toUpperCase());
            const ib = ordenCanonico.indexOf(String(b.codigo ?? '').toUpperCase());
            return (ia === -1 ? 99 : ia) - (ib === -1 ? 99 : ib);
          });

        // Evita opciones repetidas en el combo (por código o por nombre duplicado en el maestro).
        const vistosCodigo = new Set<string>();
        const vistosNombre = new Set<string>();
        this.monedas = mapeadas.filter((item: any) => {
          const claveCodigo = String(item.codigo ?? '').toUpperCase();
          const claveNombre = normalizar(item.nombre);
          if (vistosCodigo.has(claveCodigo) || vistosNombre.has(claveNombre)) {
            return false;
          }
          vistosCodigo.add(claveCodigo);
          vistosNombre.add(claveNombre);
          return true;
        });
      },
      error: (err) => console.error('Error cargando monedas:', err)
    });
  }

  private cargarSucursalesDesdeApi() {
    const user = this.storageService.getUser<SessionUserLike>();
    if (!user?.empresaId) {
      return;
    }

    this.api.get<any>(`/core/empresas/${user.empresaId}/sucursales`, { page: 0, size: 1000 }).subscribe({
      next: (response) => {
        const sucursales = Array.isArray(response)
          ? response
          : Array.isArray(response?.content)
            ? response.content
            : [];
        this.sucursales = sucursales
          .filter((item: any) => item.flagEstado !== '0')
          .map((item: any) => ({
            id: item.id,
            codigo: item.codigo,
            nombre: item.nombre,
            direccionEntrega: item.direccion ?? ''
          }));
      },
      error: (err) => console.error('Error cargando sucursales:', err)
    });
  }

  private cargarImpuestosDesdeApi() {
    this.api.get<any>('/core/impuestos', { page: 0, size: 1000 }).subscribe({
      next: (response) => {
        const impuestos = Array.isArray(response)
          ? response
          : Array.isArray(response?.content)
            ? response.content
            : [];
        this.impuestos = impuestos.filter((item: any) => item.flagEstado !== '0');
      },
      error: (err) => console.error('Error cargando impuestos:', err)
    });
  }

}
