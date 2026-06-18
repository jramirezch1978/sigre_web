import { Component, OnInit, ViewChild, inject, effect, computed } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent, IRichCellEditorParams } from 'ag-grid-community';
import { ModalController } from '@ionic/angular';
import { AccesorioActionsCellComponent } from 'src/app/modules/activos/m-af-tabla/pages/af-o-registroactivos/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { GridExportService } from 'src/app/core/infrastructure/export/grid-export.service';
import { ModalCrearAtfprodComponent } from 'src/app/ui/modal-crear-atfprod/modal-crear-atfprod.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { FacturaProveedorFacade } from 'src/app/modules/compras/application/facades/factura-proveedor.facade';
import { FacturaProveedorFeedbackEffects } from 'src/app/modules/compras/effects/factura-proveedor-feedback.effect';
import { FacturaProveedorSyncEffects } from 'src/app/modules/compras/effects/factura-proveedor-sync.effect';
import { FacturaProveedorEntity } from 'src/app/modules/compras/domain/models/factura-proveedor.entity';
import { IFacturaProveedorRepository } from 'src/app/modules/compras/domain/repositories/ifactura-proveedor.repository';
import { FileUploadComponent } from 'src/app/ui/file-upload/file-upload.component';
import { ProveedorFacade } from 'src/app/modules/compras/application/facades/proveedor.facade';
import { ProveedorEntity } from 'src/app/modules/compras/domain/models/proveedor.entity';
import { AlmacenFacade } from 'src/app/modules/almacen/application/facades/almacen.facade';
import { MaestroProductoEntity } from 'src/app/modules/almacen/domain/models/maestro-producto.entity';
import { ApiClientService } from 'src/app/core/infrastructure/http/api-client.service';
import { catchError, of } from 'rxjs';

type IFacturaProveedor = FacturaProveedorEntity;

// Font Awesome Icons
import { faBook, faSearch as faSearchRegular } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight, faSearch as faSearchSolid } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-compras-operaciones-facturas-proveedores',
  templateUrl: './compras-operaciones-facturas-proveedores.component.html',
  styleUrls: ['./compras-operaciones-facturas-proveedores.component.scss'],
  standalone: false,
})
export class ComprasOperacionesFacturasProveedoresComponent implements OnInit {
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

  // Clean Architecture - Facade
  private readonly facturaProveedorFacade = inject(FacturaProveedorFacade);
  private readonly feedbackEffects = inject(FacturaProveedorFeedbackEffects);
  private readonly syncEffects = inject(FacturaProveedorSyncEffects);
  private readonly proveedorFacade = inject(ProveedorFacade);
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly api = inject(ApiClientService);
  private readonly facturaRepo = inject(IFacturaProveedorRepository);
  private readonly gridExport = inject(GridExportService);

  // Catálogos reales para el registro de Cuentas por Pagar
  conceptosFinancieros: { id: number; nombre: string }[] = [];
  tiposImpuestoCatalogo: { id: number; nombre: string; tasa: number }[] = [];
  centrosCosto: { id: number; nombre: string }[] = [];

  // Señales expuestas desde el store
  readonly isLoadingObtener = computed(() => this.facturaProveedorFacade.loadingObtener());
  readonly isLoadingGuardar = computed(() => this.facturaProveedorFacade.loadingGuardar());
  readonly isLoadingEliminar = computed(() => this.facturaProveedorFacade.loadingEliminar());


  @ViewChild('autocompleteProductos') autocompleteProductos: any;
  @ViewChild(FileUploadComponent) fileUploadComponent!: FileUploadComponent;
  pais = this.countryService.getCountryCode();
  seleccionarvalue: string = '';
  seleccionarvalueretencion: string = '';
  mostrarTipoCambio: boolean = true;

  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  //FECHAS ÚNICAS (SINGLE)
  fechaRegistro: Date = new Date();
  fechaRecepcion: Date | undefined;
  filaSeleccionada: any = null;
  proveedores: ProveedorEntity[] = [];
  /** Proveedor resuelto vía botón Buscar (directo del API por RUC). */
  proveedorSeleccionado: { id?: number; razonSocial?: string; direccion?: string; nroDocumento: string } | null = null;
  tituloFormulario: string = 'Nueva factura';
  modoCreacion: boolean = true;
  tipoSeleccionado: string = 'emision';

  // Labels tropicalizados
  labelSerie: string = 'Serie';

  // Lista de órdenes de compra para el autocomplete
  ordenesCompra: any = [];
  tipoDoc = [
    'RUC',
  ]

  tipoFs = [
    { value: 'emision', nombre: 'De emisión' },
    { value: 'vencimiento', nombre: 'De vencimiento' },
  ]

  // Opciones para el select de régimen de recaudación
  regimenOptions = [
    { value: 'detraccion', label: 'Detracción' },
    { value: 'retencion', label: 'Retención' },
    { value: 'percepcion', label: 'Percepción' }
  ];
  ordenAsociada = [
    { value: 'Compras', label: 'Compras' },
    { value: 'Servicio', label: 'Servicio' },
  ]
  // Opciones para el select de moneda
  monedasOptions = [
    { value: 'Soles', label: 'Soles' },
    { value: 'USD', label: 'Dólares' },
    { value: 'EUR', label: 'Euros' }
  ];
  porcentaje = [
    { value: '5', label: '5%' },
    { value: '7', label: '7%' },
  ]
  // Opciones para el select de condición de pago
  condicionesPagoOptions = [
    { value: 'contado', label: 'Contado' },
    { value: 'credito', label: 'Crédito 30 días' },
    { value: 'mixto', label: 'Mixto' },
    { value: 'otros', label: 'Otros' }
  ];

  // Opciones para el select de tipo de comprobante
  tiposComprobante: any[] = [];
  countries = ALL_COUNTRIES;
  // Flags para mostrar campos condicionales
  showDetraccionFields = false; // Solo se muestra cuando se selecciona detracción
  showMontoOnly = false;
  archivoxml: File | null = null;
  estadoSeleccionado: string = '';
  mostrartabla = true;
  mostrarOrdenAsociada = false;
  private gridApi!: GridApi;
  FacturaProveedorForm!: FormGroup;

  // Definición de columnas para la tabla de productos
  productosColDefs: ColDef[] = [
    { field: 'factura_proveedor_codigo', headerName: 'Código', flex: 1, minWidth: 80 },
    { field: 'cantidad', headerName: 'Cantidad', flex: 0.8, minWidth: 80, cellClass: 'text-center', editable: true,
      cellStyle:{ cursor: 'pointer'},
     },
    { field: 'descripcion', headerName: 'Descripción', flex: 2, minWidth: 150},
    {
      field: 'conceptoFinancieroNombre', headerName: 'Concepto financiero', flex: 1.3, minWidth: 150,
      editable: true, cellStyle: { cursor: 'pointer' },
      cellEditor: 'agRichSelectCellEditor',
      cellEditorParams: () => ({
        values: this.conceptosFinancieros.map((c) => c.nombre),
        searchType: 'matchAny',
        filterList: true,
        highlightMatch: true,
        valueListMaxHeight: 220,
      } as IRichCellEditorParams),
    },
    {
      field: 'precioUni', headerName: 'Precio unitario', editable: true, cellStyle:{ cursor: 'pointer'}, flex: 1,  minWidth: 100, valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '0.00';
      }
      
    },
    {
      field: 'subtotal', headerName: 'Subtotal', flex: 1, editable: true, cellStyle:{ cursor: 'pointer'}, minWidth: 100, valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '0.00';
      }
    },
    {
      field: 'impuestos', headerName: 'Impuestos', flex: 1, minWidth: 100, editable: true, cellEditor: "agRichSelectCellEditor",
      cellEditorParams: (params: any) => {
        // Convertir el valor actual a array si es string
        let currentValue = params.value;
        if (typeof currentValue === 'string') {
          currentValue = currentValue.split(',').map((imp: string) => imp.trim()).filter((imp: string) => imp);
        } else if (!Array.isArray(currentValue)) {
          currentValue = currentValue ? [currentValue] : [];
        }

        return {
          values: this.opcionesImpuestos,
          multiSelect: true,
          searchType: 'matchAny',
          filterList: true,
          highlightMatch: true,
          valueListMaxHeight: 220,
          value: currentValue
        } as IRichCellEditorParams;
      },
      cellRenderer: (params: any) => {
        if (!params.value) return '';

        // Si el valor es un string con comas, dividirlo
        const impuestos = typeof params.value === 'string'
          ? params.value.split(',').map((imp: any) => imp.trim()).filter((imp: any) => imp)
          : Array.isArray(params.value)
            ? params.value
            : [params.value];

        // Crear badges para cada impuesto con botón X
        const badges = impuestos.map((impuesto: any, index: number) =>
          `<span class="badge-table-2 bg-[#F5F5F5]" style="display: inline-flex; align-items: center; gap: 4px; padding-right: 4px;">
            ${impuesto}
            <span class="badge-close" data-impuesto="${impuesto}" data-row-index="${params.node.rowIndex}" style="cursor: pointer; font-weight: 400 ; font-size: 10px; opacity: 0.6; hover:opacity: 1;">&times;</span>
          </span>`
        ).join('');

        return `<div style="display: flex; flex-direction: row; gap: 4px; align-items: center; height: 100%;">${badges}</div>`;
      },
      cellStyle: { display: 'flex', alignItems: 'center', cursor:'pointer' , padding: '2px 4px' },
      onCellClicked: (params: any) => {
        const target = params.event.target as HTMLElement;
        if (target.classList.contains('badge-close')) {
          const impuestoEliminar = target.getAttribute('data-impuesto');
          this.eliminarImpuesto(params.node.rowIndex, impuestoEliminar);
        }
      }
    },

    {
      field: 'total', headerName: 'Total', flex: 1, minWidth: 100, valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '0.00';
      }
    },
    {
      field: 'acciones',
      headerName: 'Acciones',
      headerClass: 'centrarencabezado',
      flex: 0.8,
      minWidth: 80,
      cellRenderer: AccesorioActionsCellComponent,
      cellRendererParams: {
        context: {
          componentParent: this
        }
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  // Datos de ejemplo para la tabla de productos
  productosData: any[] = [];

  // Variables para totales
  subtotalGeneral: number = 0;
  impuestosGeneral: number = 0;
  totalGeneral: number = 0;

  private gridApiProductos!: GridApi;

  // Lista de productos disponibles
  productos: any[] = [];
  /** Indica que los productos ya se cargaron desde el endpoint real (/core/articulos). */
  private productosCargadosApi = false;

  // Lista de cuentas contables
  cuentasContables: any[] = [];

  // Lista de detracciones
  detracciones: any[] = [];

  // Opciones de impuestos disponibles (extraídas de los productos)
  opcionesImpuestos: string[] = [];

  // Opciones para el autocomplete de tipo de retención (Colombia)
  tipoISelect = [
    { id: '1', nombre: 'ReteFuente declarante (2.5%)' },
    { id: '2', nombre: 'ReteFuente no declarante (3.5%)' },
    { id: '3', nombre: 'ReteICA (0.414%)' },
    { id: '4', nombre: 'ReteIVA (2.85%)' }
  ];

  tipoImpuestoSeleccionado: any[] = [];

  colDefs: ColDef[] = [
    { field: 'factura_proveedor_nro_comprobante', flex: 1, headerName: 'Nº comprobante', },
    { field: 'factura_proveedor_tipo', flex: 0.7, headerName: 'Tipo', filter: true },
    { field: 'factura_proveedor_proveedor', flex: 1.5, headerName: 'Razón social', filter: true },
     // { field: 'factura_proveedor_fecha_registro', flex: 0.8, headerName: 'Fecha de registro', },
    { field: 'factura_proveedor_fecha_emision', flex: 0.8, headerName: 'Fecha de emisión',
      valueFormatter: (params) => {
        if (params.value) {
          const date = new Date(params.value + 'T00:00:00');
          return date.toLocaleDateString('es-PE');
        }
        return '';
      }
     },
    { field: 'factura_proveedor_vencimiento', flex: 0.6, minWidth: 100, headerName: 'Fecha de vencimiento',
      valueFormatter: (params) => {
        if (params.value) {
          const date = new Date(params.value + 'T00:00:00');
          return date.toLocaleDateString('es-PE');
        }
        return '';
      }
     },
    {
      field: 'factura_proveedor_monto_total', flex: 1, headerName: 'Monto total',
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
    { field: 'factura_proveedor_moneda', flex: 0.5, headerName: 'Moneda', filter: true },
    { field: 'factura_proveedor_orden_asociada', flex: 1, headerName: 'Orden asociada' },
    {
      headerClass: 'centrarencabezado',
      field: 'factura_proveedor_estado',
      headerName: 'Estado',
      filter: true,
      flex: 0.7,
      width: 100,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';

        switch (estado) {
          case 'Registrada':
            badgeClass = 'bg-green-100 text-green-600';
            break;
          case 'Anulada':
            badgeClass = 'bg-red-100 text-red-600';
            break;
          default:
            badgeClass = 'bg-[#F5F5F5] text-[#363636]';
        }

        return `<span class="badge-table ${badgeClass}">${estado}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    }
  ];

  rowData: IFacturaProveedor[] = [];
  /** Fuente completa de facturas (sin filtrar por fecha) para aplicar filtros locales. */
  private facturasFuente: IFacturaProveedor[] = [];

  private readonly columnasExport = [
    { header: 'Nº comprobante', field: 'factura_proveedor_nro_comprobante' },
    { header: 'Tipo', field: 'factura_proveedor_tipo' },
    { header: 'Razón social', field: 'factura_proveedor_proveedor' },
    { header: 'Fecha de emisión', field: 'factura_proveedor_fecha_emision' },
    { header: 'Fecha de vencimiento', field: 'factura_proveedor_vencimiento' },
    { header: 'Monto total', field: 'factura_proveedor_monto_total' },
    { header: 'Moneda', field: 'factura_proveedor_moneda' },
    { header: 'Orden asociada', field: 'factura_proveedor_orden_asociada' },
    { header: 'Estado', field: 'factura_proveedor_estado' },
  ];

  async exportarExcel(): Promise<void> {
    const filas = this.gridExport.obtenerFilas(this.gridApi, this.rowData) as Array<Record<string, unknown>>;
    if (!filas.length) {
      this.toastService.warning('No hay facturas para exportar');
      return;
    }
    await this.gridExport.exportarExcel(
      `facturas-proveedores-${this.gridExport.fechaHoy()}`,
      this.columnasExport,
      filas,
      'Facturas',
    );
  }

  async exportarPdf(): Promise<void> {
    const filas = this.gridExport.obtenerFilas(this.gridApi, this.rowData) as Array<Record<string, unknown>>;
    if (!filas.length) {
      this.toastService.warning('No hay facturas para exportar');
      return;
    }
    await this.gridExport.exportarPdf(
      'Facturas de proveedores',
      `facturas-proveedores-${this.gridExport.fechaHoy()}`,
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
  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private simulation: SimulationService,
    private toastService: ToastService,
    private countryService: CountryService,
    private formValidationService: FormValidationService
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Sincronizar rowData con el store via effect
    effect(() => {
      const facturas = this.facturaProveedorFacade.facturas();
      this.facturasFuente = [...facturas];
      this.aplicarFiltroFechas();
    });

    // Effect para sincronizar proveedores desde el store
    effect(() => {
      this.proveedores = this.proveedorFacade.proveedores();
    });

    // Effect para mapear maestro de productos desde el facade (fallback si el endpoint real falla)
    effect(() => {
      const maestro = this.almacenFacade.maestroProductos();
      if (this.productosCargadosApi) {
        return;
      }
      this.productos = maestro.map((item: MaestroProductoEntity) => ({
        id: item.maestro_producto_codigo,
        codigo: item.maestro_producto_codigo,
        nombre: item.maestro_producto_nombre,
        descripcion: item.maestro_producto_nombre,
        producto: item.maestro_producto_nombre,
        unidadMedida: item.maestro_producto_medida || 'UND',
        impuesto: item.maestro_producto_impuesto ? [item.maestro_producto_impuesto] : [],
        precioUnitario: 0,
        demandaProyectada: 0,
        ...item
      }));
    });
  }

  ngOnInit() {
    this.FacturaProveedorForm = this.formBuilder.group({
      proveedor: ['', Validators.required],
      serie: ['', Validators.required],
      numero: ['', Validators.required],
      tipocomprobante: ['', Validators.required],
      fecharegistro: [{value: this.fechaHoyISO(), disabled: true}],
      checkboxOrdenAsociada: [false],
      tipoOrden: ['Compras'],
      ordenAsociada: [''],
      fechaEmision: ['', Validators.required],
      regimenRecaudacion: [''],
      tipoActFiscal: [''],
      nroDetraccion: [''],
      fechaDetraccion: [''],
      fechaEntrega: [''],
      retencionisr: ['5'],
      retencioniva: ['12'],
      retencionisrinput: [''],
      retencionivainput: [''],
      montodetraccion: [''],
      tipocambio: ['3.75'],
      monto: [''],
      documentoproveedor: ['RUC'],
      documentoproveedorinput: ['', Validators.required],
      fechaVencimiento: [''],
      condicionpago: ['contado'],
      moneda: ['Soles', Validators.required],
      centroCostoId: [''],
      cuentaContable: [''],
      subtotal: [''],
      impuesto: [''],
      archivo: [''],
      estado: ['pendiente']
    });
    this.FacturaProveedorForm.get('fecharegistro')?.disable();
    this.FacturaProveedorForm.get('proveedor')?.disable();
    this.FacturaProveedorForm.get('tipocambio')?.disable();

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.FacturaProveedorForm);
    this.formValidationService.resetearEstado();

    // Cargar facturas desde el store (JSON via repositorio)
    this.cargarFacturasDesdeStore();
    // NOTA: No se precarga la lista completa de proveedores. El listado hace un
    // patrón N+1 (1 request por proveedor) que congela la pantalla. Aquí el
    // proveedor se resuelve bajo demanda por RUC en buscarproveedor().
    // Cargar maestro de productos via facade
    this.almacenFacade.cargarMaestroProductos();
    // Cargar bienes/artículos reales desde el core para el detalle
    this.cargarProductosDesdeApi();
    // Cargar órdenes de compra
    this.cargarordenesdecompra();
    // Cargar cuentas contables
    this.cargarCuentasContables();
    // Cargar detracciones
    this.cargarDetracciones();
    // Cargar impuestos registrados
    this.cargarImpuestos();

    // Cargar tipos de comprobante según país (régimen) + catálogo real
    this.cargartiposdecomprobante();
    this.cargarTiposComprobanteApi();

    // Configurar labels según país
    this.configurarLabelsPorPais();

    // Cargar catálogos reales para Cuentas por Pagar
    this.cargarCatalogosCxp();

  }

  /**
   * Carga los catálogos reales necesarios para registrar una cuenta por pagar:
   * conceptos financieros (ms-finanzas) y tipos de impuesto (ms-core-maestros).
   */
  private cargarCatalogosCxp(): void {
    this.api
      .get<any>('/finanzas/conceptos-financieros', { page: 0, size: 200 })
      .pipe(catchError(() => of(null)))
      .subscribe((response) => {
        const lista = Array.isArray(response) ? response : response?.content ?? [];
        this.conceptosFinancieros = lista
          .filter((c: any) => c?.flagEstado !== '0')
          .map((c: any) => ({ id: Number(c.id), nombre: c.nombre ?? c.codigo ?? `Concepto ${c.id}` }));
      });

    this.api
      .get<any[]>('/core/impuestos')
      .pipe(catchError(() => of([])))
      .subscribe((response) => {
        const lista = Array.isArray(response) ? response : [];
        this.tiposImpuestoCatalogo = lista
          .filter((t: any) => t?.flagEstado !== '0')
          .map((t: any) => ({
            id: Number(t.id),
            nombre: t.descImpuesto ?? t.tipoImpuesto ?? `Impuesto ${t.id}`,
            tasa: Number(t.tasaImpuesto ?? 0),
          }));
      });

    // Centros de costo: GET /contabilidad/centros-costo (lista paginada)
    this.api
      .get<any>('/contabilidad/centros-costo', { page: 0, size: 1000 })
      .pipe(catchError(() => of(null)))
      .subscribe((response) => {
        const lista = Array.isArray(response) ? response : response?.content ?? response?.data ?? [];
        this.centrosCosto = lista
          .filter((c: any) => c?.flagEstado !== '0' && c?.activo !== false)
          .map((c: any) => {
            const nombre = c.descCencos ?? c.nombre ?? c.centro_costo_nombre ?? c.descripcion ?? c.cencos ?? '';
            return {
              id: Number(c.id),
              nombre: String(nombre) || `Centro ${c.id}`,
            };
          });
      });
  }

  /** Resuelve el id del centro de costo a partir del nombre mostrado en la grilla. */
  private resolverCentroCostoId(valor: unknown): number | null {
    if (valor == null || valor === '') {
      return null;
    }
    const texto = String(valor).trim().toLowerCase();
    const porNombre = this.centrosCosto.find((c) => c.nombre.trim().toLowerCase() === texto);
    if (porNombre) {
      return porNombre.id;
    }
    const num = Number(valor);
    return Number.isNaN(num) ? null : num;
  }

  /** Resuelve el id del concepto financiero a partir del nombre seleccionado en la grilla. */
  private resolverConceptoFinancieroId(nombre: unknown): number {
    const texto = String(nombre ?? '').trim().toLowerCase();
    const encontrado = this.conceptosFinancieros.find((c) => c.nombre.trim().toLowerCase() === texto);
    return encontrado?.id ?? this.conceptosFinancieros[0]?.id ?? 0;
  }

  /** Resuelve el id del tipo de impuesto a partir del texto de impuestos de la línea. */
  private resolverTipoImpuestoId(impuestos: unknown): number {
    const texto = String(impuestos ?? '').trim().toLowerCase();
    if (texto) {
      const encontrado = this.tiposImpuestoCatalogo.find(
        (t) => texto.includes(t.nombre.trim().toLowerCase()) || (t.tasa > 0 && texto.includes(String(t.tasa)))
      );
      if (encontrado) {
        return encontrado.id;
      }
    }
    return this.tiposImpuestoCatalogo[0]?.id ?? 1;
  }

  private fechaHoyISO(): string {
    const hoy = new Date();
    return `${hoy.getFullYear()}-${String(hoy.getMonth() + 1).padStart(2, '0')}-${String(hoy.getDate()).padStart(2, '0')}`;
  }

  cargartiposdecomprobante() {
    if (this.pais === 'GT' || this.pais === 'CO') {
      this.regimenOptions = [];
      this.regimenOptions = [
        { value: 'retencion', label: 'Retención' },
        { value: 'sinretencion', label: 'Sin retención' }];
      this.FacturaProveedorForm.patchValue({ regimenRecaudacion: 'retencion' });
    }
    if (this.pais === 'EC') {
      this.regimenOptions = [];
      this.regimenOptions = [
        { value: 'sinretencion', label: 'Sin retención' },
        { value: 'detraccion', label: 'Retención' },
      ]
    }
  }

  /**
   * Carga los tipos de comprobante REALES desde el core (/core/tipos-documento).
   * El value de cada opción es el `id` real (docTipoId) que exige el backend de CxP.
   */
  cargarTiposComprobanteApi() {
    this.api
      .get<{ content?: any[] } | any[]>('/core/tipos-documento')
      .subscribe({
        next: (response) => {
          const lista = Array.isArray(response)
            ? response
            : Array.isArray(response?.content)
              ? response.content
              : [];
          const tipos = lista
            .filter((item: any) => item.flagEstado !== '0')
            .map((item: any) => ({
              value: item.id,
              nombre: item.nombre || item.descripcion || '',
              codigo: item.codigo || '',
              sunatCodigo: item.sunatCodigo || '',
            }));
          if (tipos.length) {
            this.tiposComprobante = tipos;
          }
        },
        error: (err) => console.error('Error cargando tipos de comprobante (/core/tipos-documento):', err),
      });
  }

  /**
   * Cargar detracciones desde el SimulationService
   */
  cargarDetracciones() {
    const detraccionesLS = this.simulation.list('detraccion') || [];
    console.log('Detracciones cargadas :', detraccionesLS);

    // Mapear cuentas con el formato necesario para el autocomplete
    this.detracciones = detraccionesLS.map((item: any) => ({
      codigo: item.codigo,
      descripcion: item.descripcion,
      nombre: `${item.codigo} - ${item.descripcion}`,
      porcentaje: item.porcentaje,
      ...item
    }));

    console.log('Detracciones cargadas:', this.detracciones.length);
  }
  /**
   * Cargar impuestos registrados desde el SimulationService
   */
  cargarImpuestos() {
    const impuestosLS = this.simulation.list('impuestos') || [];
    console.log('  Impuestos registrados cargados:', impuestosLS);

    // Extraer nombres de impuestos para el selector
    this.opcionesImpuestos = impuestosLS
      .filter((item: any) => item.estado === 'Activo')
      .map((item: any) => item.porcentaje + ' ' + item.codigoSun);

    console.log(' Opciones de impuestos disponibles:', this.opcionesImpuestos);
  }

  seleccionarcomprobante(event: any) {
    const valorSel = event.detail.value;
    const seleccionado = this.tiposComprobante.find((t) => String(t.value) === String(valorSel));
    const nombre = String(seleccionado?.nombre ?? '').toLowerCase();
    const esFactura = nombre.includes('factura') || valorSel === 'factura' || valorSel === 'especiales';
    this.seleccionarvalue = esFactura ? 'factura' : nombre;
    if (esFactura) {
      this.FacturaProveedorForm.patchValue({ checkboxOrdenAsociada: true });
      this.mostrarOrdenAsociada = true;
    }
    else {
      this.FacturaProveedorForm.patchValue({ checkboxOrdenAsociada: false });
      this.mostrarOrdenAsociada = false;
    }
    console.log('Comprobante seleccionado:', valorSel, nombre);

  }
  cargarordenesdecompra() {
    const comprasLS = this.simulation.list('ordenCompra') || [];
    console.log('  Órdenes de compra cargadas:', comprasLS);

    // Mapear órdenes con el formato necesario para el autocomplete
    this.ordenesCompra = comprasLS.map((item: any) => ({
      numeroOrden: item.codigo || item.numeroOrden,
      proveedor: item.proveedor || '',
      documentoproveedor: item.documentoproveedor || '',
      documentoproveedorinput: item.documentoproveedorinput || '',
      ...item
    }));

    console.log(' Órdenes de compra cargadas:', this.ordenesCompra.length);
  }

  /**
   * Cargar proveedores desde el servicio de simulación
   * @deprecated Usar proveedorFacade.cargarProveedores() con el effect en el constructor
   */
  cargarProveedoresDesdeSimulacion() {
    // Migrado a ProveedorFacade + effect en el constructor
  }

  /**
   * Cargar cuentas contables desde el SimulationService
   */
  cargarCuentasContables() {
    const cuentasLS = this.simulation.list('plancontable') || [];
    console.log('Cuentas contables cargadas desde plan contable:', cuentasLS);

    // Mapear cuentas con el formato necesario para el autocomplete
    this.cuentasContables = cuentasLS.map((item: any) => ({
      codigo: item.codigo,
      descripcion: item.descripcion,
      nombre: `${item.codigo} - ${item.descripcion}`,
      naturaleza: item.naturaleza,
      tipo: item.tipo,
      nivel: item.nivel,
      estado: item.estado,
      ...item
    }));

    console.log(' Cuentas contables cargadas:', this.cuentasContables.length);
  }
  /**
   * @deprecated Usar almacenFacade.cargarMaestroProductos() con el effect en el constructor
   */
  cargarArticuloDesdeSimulacion() {
    // Migrado a AlmacenFacade + effect en el constructor
  }
  /**
   * Cargar facturas desde el store (JSON via repositorio)
   */
  cargarFacturasDesdeStore(): void {
    this.facturaProveedorFacade.cargarFacturas();
  }

  /**
   * Cargar facturas desde el servicio de simulación
   * @deprecated Usar cargarFacturasDesdeStore()
   */
  cargarFacturasDesdeSimulacion() {
    const facturasLS = this.simulation.list('facturaProveedor') || [];
    console.log('Facturas en localStorage:', facturasLS);

    // Ordenar por número de comprobante descendente (más recientes primero)
    this.rowData = [...facturasLS].sort((a, b) => {
      return b.nrocomprobante.localeCompare(a.nrocomprobante);
    });

    // Refrescar la vista de AG-Grid si está disponible
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }

    console.log('  Facturas cargadas en tabla:', this.rowData.length);
  }

  configurarLabelsPorPais() {
    if (this.pais === 'EC') {
      this.labelSerie = 'N° de Documento';
      this.mostrarTipoCambio = false;
    }


    // etc.
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

    // Seleccionar la primera fila por defecto
    // setTimeout(() => {
    //   if (this.gridApi && this.rowData.length > 0) {
    //     const firstNode = this.gridApi.getRowNode('0');
    //     if (firstNode) {
    //       firstNode.setSelected(true);
    //       this.onCellClicked({ data: firstNode.data, node: firstNode });
    //     }
    //   }
    // }, 100);
  }

  async onCellClicked(event: any) {
    const data = event.data;

    // Prevenir selección automática
    event.node.setSelected(false);

    // Guardar referencia del elemento que tiene el foco
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Re-seleccionar la fila anterior si existe
      if (this.filaSeleccionada && this.gridApi) {
        setTimeout(() => {
          this.gridApi.forEachNode((node) => {
            if (node.data === this.filaSeleccionada) {
              node.setSelected(true);
            }
          });
        }, 0);
      }

      // Restaurar foco si es un input
      if (elementoConFoco && elementoConFoco.tagName === 'INPUT') {
        setTimeout(() => elementoConFoco.focus(), 100);
      }
      return;
    }

    // Aplicar nueva selección manualmente
    if (this.gridApi) {
      this.gridApi.forEachNode((node) => {
        if (node.data === data) {
          node.setSelected(true);
        }
      });
    }

    this.modoCreacion = false;
    this.tituloFormulario = 'Factura:';
    if (!data) return;

    console.log('Factura seleccionada:', event.data);
    this.filaSeleccionada = event.data;

    // Deseleccionar otras filas
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    event.node.setSelected(true);

    // Desglosa serie y número desde el nrocomprobante
    const desglosaResult = this.desglosaSerieNumero(event.data.factura_proveedor_nro_comprobante);

    // Llenar formulario con datos de la factura
    this.FacturaProveedorForm.patchValue({
      proveedor: event.data.factura_proveedor_proveedor || '',
      serie: desglosaResult.serie,
      numero: desglosaResult.numero,
      tipocomprobante: event.data.factura_proveedor_doc_tipo_id ?? '',
      fecharegistro: event.data.factura_proveedor_fecha_registro || '',
      checkboxOrdenAsociada: event.data.factura_proveedor_orden_asociada_activa || false,
      tipoOrden: event.data.factura_proveedor_tipo_orden || 'Compras',
      ordenAsociada: event.data.factura_proveedor_orden_asociada || '',
      fechaEmision: event.data.factura_proveedor_fecha_emision || '',
      regimenRecaudacion: event.data.factura_proveedor_regimen_recaudacion || '',
      tipoActFiscal: event.data.factura_proveedor_tipo_act_fiscal || '',
      nroDetraccion: event.data.factura_proveedor_nro_detraccion || '',
      fechaDetraccion: event.data.factura_proveedor_fecha_detraccion || '',
      montodetraccion: event.data.factura_proveedor_monto_detraccion || '',
      tipocambio: event.data.factura_proveedor_tipo_cambio || '3.75',
      monto: event.data.factura_proveedor_monto_total || '',
      documentoproveedor: event.data.factura_proveedor_tipo_documento || 'RUC',
      documentoproveedorinput: event.data.factura_proveedor_nro_documento || '',
      fechaVencimiento: event.data.factura_proveedor_vencimiento || '',
      condicionpago: event.data.factura_proveedor_condicion_pago || 'contado',
      moneda: this.normalizarMonedaOpcion(event.data.factura_proveedor_moneda),
      cuentaContable: event.data.factura_proveedor_cuenta_contable || '',
      estado: event.data.factura_proveedor_estado || 'Registrada'
    });

    // Actualizar checkbox de orden asociada
    this.mostrarOrdenAsociada = event.data.factura_proveedor_orden_asociada_activa || false;

    // Actualizar campos condicionales según régimen de recaudación
    if (event.data.factura_proveedor_regimen_recaudacion) {
      this.onRegimenChange(event.data.factura_proveedor_regimen_recaudacion);
    }

    // Cargar productos desde la factura guardada (fallback inmediato)
    this.cargarDetalleEnGrid(event.data.factura_proveedor_detalle || []);

    // El listado NO trae el detalle (el backend lo omite en el summary): traerlo por id
    const facturaId = event.data.id ?? event.data.factura_proveedor_codigo;
    if (facturaId) {
      this.facturaRepo.obtenerPorCodigo(String(facturaId)).subscribe({
        next: (full: any) => {
          const detalle = full?.factura_proveedor_detalle || [];
          if (detalle.length) {
            this.cargarDetalleEnGrid(detalle);
          }
        },
        error: (err) => console.error('Error obteniendo detalle de la cuenta por pagar:', err),
      });
    }
    if(this.filaSeleccionada.factura_proveedor_estado == 'Anulada'){
      this.FacturaProveedorForm.disable();
    } else {
      this.FacturaProveedorForm.enable();
      this.FacturaProveedorForm.get('fecharegistro')?.disable();
      this.FacturaProveedorForm.get('proveedor')?.disable();
      this.FacturaProveedorForm.get('tipocambio')?.disable();
    }

    console.log('Productos cargados:', this.productosData.length);

    // Resetear servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }

  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      console.log('Archivo seleccionado:', file.name);
    }
  }
  async nuevaFactura() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Usuario canceló
    }

    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.tituloFormulario = 'Nueva factura';

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    this.FacturaProveedorForm.reset({
      fecharegistro: this.formatDate(new Date()),
      tipocambio: '3.75',
      documentoproveedor: 'RUC',
      condicionpago: 'contado',
      moneda: 'Soles',
      estado: 'pendiente'
    });
    this.FacturaProveedorForm.enable();
    this.FacturaProveedorForm.get('fecharegistro')?.disable();
    this.FacturaProveedorForm.get('proveedor')?.disable();
    this.FacturaProveedorForm.get('tipocambio')?.disable();

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  /** Campo de fecha sobre el que aplica el filtro de rango, según el select. */
  private fechaFiltroField(): string {
    return this.tipoSeleccionado === 'vencimiento'
      ? 'factura_proveedor_vencimiento'
      : 'factura_proveedor_fecha_emision';
  }

  /** Aplica el filtro de rango de fechas sobre la fuente y refresca el grid. */
  aplicarFiltroFechas(): void {
    this.rowData = this.gridExport.filtrarPorRango(
      this.facturasFuente,
      (f: any) => f?.[this.fechaFiltroField()],
      this.startDate,
      this.endDate,
    );
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  /** Cambió el tipo de fecha (emisión/vencimiento): re-aplica el filtro. */
  onTipoFechaChange(): void {
    this.aplicarFiltroFechas();
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    this.aplicarFiltroFechas();
  }

  onOrdenSeleccionada(orden: any) {
    console.log('orden seleccionada', orden)
    this.FacturaProveedorForm.patchValue({
      ordenAsociada: orden.numeroOrden,
      documentoproveedor: orden.documentoproveedor,
      documentoproveedorinput: orden.documentoproveedorinput,
      proveedor: orden.proveedor,
      moneda: orden.moneda,
    })

    // Cargar los productos/artículos de la orden seleccionada
    if (orden.articulos && Array.isArray(orden.articulos)) {
      this.productosData = orden.articulos.map((articulo: any) => ({
        codigo: articulo.codigo || '',
        cantidad: articulo.cantidad || 0,
        descripcion: articulo.descripcion || articulo.producto || '',
        precioUni: articulo.precioUni || articulo.precioUnitario || 0,
        subtotal: articulo.subtotal || 0,
        impuestos: articulo.impuestos || articulo.igv || 0,
        total: articulo.total || 0
      }));

      console.log('Productos de la orden cargados:', this.productosData.length);

      // Actualizar la tabla de productos si el grid está listo
      if (this.gridApiProductos) {
        this.gridApiProductos.setGridOption('rowData', this.productosData);
      }

      // Calcular totales
      this.actualizarTotales();
    } else {
      console.warn('La orden no tiene artículos o el formato es incorrecto');
      this.productosData = [];
      if (this.gridApiProductos) {
        this.gridApiProductos.setGridOption('rowData', []);
      }
      this.actualizarTotales();
    }

  }

  /**
   * Maneja la selección de tipos de retención para Colombia
   */
  ontipoImpuestoSeleccionado(event: any) {
    console.log('Tipos de retención seleccionados:', event);
    this.tipoImpuestoSeleccionado = event;
  }

  // Para modo SINGLE - Manejo de fechas seleccionadas
  onFechaEmisionSelected(date: Date) {
    const fechaFormateada = this.formatDate(date);
    this.FacturaProveedorForm.patchValue({ fechaEmision: fechaFormateada });
    console.log('Fecha emisión formateada:', fechaFormateada);
  }

  onFechaVencimientoSelected(date: Date) {
    const fechaFormateada = this.formatDate(date);
    this.FacturaProveedorForm.patchValue({ fechaVencimiento: fechaFormateada });
    console.log('Fecha vencimiento formateada:', fechaFormateada);
  }

  onFechaRecepcionSelected(date: Date) {
    console.log('Fecha recepción:', date);
    this.fechaRecepcion = date;
    const fechaFormateada = this.formatDate(date);
    console.log('Fecha recepción formateada:', fechaFormateada);
  }
  onBtReset() {
      this.facturaProveedorFacade.cargarFacturas();
  }
  onCheckboxOrdenAsociadaChange(event: any) {
    this.mostrarOrdenAsociada = event.detail.checked;
    if (!this.mostrarOrdenAsociada) {
      // Limpiar los valores cuando se desmarca
      this.FacturaProveedorForm.patchValue({
        tipoOrden: '',
        ordenAsociada: ''
      });
    }
  }

  onRegimenChange(value: string) {
    const regimen = value;
    this.showDetraccionFields = value === 'detraccion';
    this.showMontoOnly = value === 'retencion' || value === 'percepcion';
    this.seleccionarvalueretencion = regimen;
    // Limpiar campos cuando cambia la selección
    if (!this.showDetraccionFields) {
      this.FacturaProveedorForm.patchValue({
        tipoActFiscal: '',
        nroDetraccion: '',
        fechaDetraccion: '',
        montodetraccion: ''
      });
    }
    if (!this.showMontoOnly && !this.showDetraccionFields) {
      this.FacturaProveedorForm.patchValue({
        monto: ''
      });
    }
  }
  /** Mapea el texto de moneda del backend (PEN, Soles, USD, Dólares, EUR...) al value del select. */
  private normalizarMonedaOpcion(valor: any): string {
    const m = String(valor ?? '').toUpperCase();
    if (m.includes('EUR')) return 'EUR';
    if (m.includes('USD') || m.includes('DOLAR') || m.includes('DÓLAR')) return 'USD';
    return 'Soles';
  }

  guardarCambios() {
    if (this.FacturaProveedorForm.invalid) {
      this.toastService.warning('Por favor completa todos los campos requeridos');
      return;
    }

    const formData = this.FacturaProveedorForm.getRawValue();

    // Construir las líneas de detalle con los IDs reales que exige el backend de CxP
    const detalle = (this.productosData || []).map((linea: any) => {
      const cantidad = Number(linea.cantidad) || 1;
      const precioUni = Number(linea.precioUni) || 0;
      const monto = Number(linea.subtotal) || cantidad * precioUni;
      return {
        descripcion: linea.descripcion ?? '',
        articuloId: linea.articuloId ?? null,
        cantidad,
        precioUni,
        subtotal: monto,
        monto,
        impuestos: linea.impuestos ?? '',
        conceptoFinancieroId: this.resolverConceptoFinancieroId(linea.conceptoFinancieroNombre),
        centros_costo_id: this.resolverCentroCostoId(formData.centroCostoId ?? linea.centros_costo_id),
        tiposImpuestoId: this.resolverTipoImpuestoId(linea.impuestos),
      };
    });

    if (!detalle.length) {
      this.toastService.warning('Agrega al menos un producto al detalle');
      return;
    }

    // Resolver el proveedor (id) a partir del documento ingresado
    const documento = String(formData.documentoproveedorinput ?? '').trim();
    const proveedorLocal = this.proveedores.find(
      (p) => String(p.proveedor_identificacion_fiscal ?? '').trim() === documento
    );
    const usarSeleccionado =
      !!this.proveedorSeleccionado && String(this.proveedorSeleccionado.nroDocumento ?? '').trim() === documento;
    const proveedorId = usarSeleccionado ? this.proveedorSeleccionado!.id : (proveedorLocal as any)?.id;
    const razonSocialResuelta = usarSeleccionado
      ? this.proveedorSeleccionado!.razonSocial
      : proveedorLocal?.proveedor_razon_social;
    if (!proveedorId) {
      this.toastService.warning('No se encontró el proveedor. Usa "Buscar" para seleccionar uno válido.');
      return;
    }

    const total =
      Number(this.totalGeneral) ||
      Number(formData.monto) ||
      detalle.reduce((acc: number, d: any) => acc + (Number(d.monto) || 0), 0);

    const entidad: any = {
      factura_proveedor_codigo:
        this.filaSeleccionada?.factura_proveedor_codigo ?? this.filaSeleccionada?.codigo ?? '',
      id: this.filaSeleccionada?.id,
      factura_proveedor_nro_comprobante: this.construirNrocomprobante(formData.serie, formData.numero),
      factura_proveedor_serie: formData.serie,
      factura_proveedor_numero: formData.numero,
      factura_proveedor_doc_tipo_id: formData.tipocomprobante,
      factura_proveedor_tipo:
        this.tiposComprobante.find((t) => String(t.value) === String(formData.tipocomprobante))?.nombre ||
        formData.tipocomprobante,
      factura_proveedor_proveedor: formData.proveedor || razonSocialResuelta,
      factura_proveedor_proveedor_id: proveedorId,
      factura_proveedor_nro_documento: documento,
      factura_proveedor_tipo_documento: formData.documentoproveedor,
      factura_proveedor_fecha_emision: formData.fechaEmision,
      factura_proveedor_vencimiento: formData.fechaVencimiento,
      factura_proveedor_moneda: formData.moneda,
      factura_proveedor_monto_total: total,
      factura_proveedor_condicion_pago: formData.condicionpago,
      factura_proveedor_detalle: detalle,
    };

    if (this.filaSeleccionada) {
      this.facturaProveedorFacade.actualizarFactura(entidad);
    } else {
      this.facturaProveedorFacade.guardarFactura(entidad);
    }

    // Recargar el listado real desde el backend y limpiar el formulario
    setTimeout(() => this.facturaProveedorFacade.cargarFacturas(), 700);
    this.limpiarFormulario();
  }

  /**
   * Crear asiento contable automáticamente desde una factura de proveedor
   */
  private crearAsientoContableDesdeFactura(factura: any) {
    const asientosManual = this.simulation.list('asientosManual') || [];

    // Generar número de asiento correlativo
    const numeroAsiento = asientosManual.length + 1;
    const numeroAsientoFormateado = `FC-${new Date().getFullYear()}-${String(numeroAsiento).padStart(4, '0')}`;

    const fechaActual = new Date();
    const monedaSymbol = factura.moneda === 'Soles' ? 'S/' : '$';

    // Calcular totales
    const totalFactura = this.totalGeneral || (factura.subtotal + factura.impuesto);

    // Crear cuentas del asiento
    const cuentas = [];

    // DEBE: Cuenta de compras (subtotal sin IGV)
    cuentas.push({
      cuenta: '60', // Cuenta de compras
      descripcion: `Compras - ${factura.proveedor}`,
      centroCosto: '',
      debeSoles: factura.moneda === 'Soles' ? this.subtotalGeneral : 0,
      haberSoles: 0,
      debeDolares: factura.moneda === 'Dólares' ? this.subtotalGeneral : 0,
      haberDolares: 0
    });

    // DEBE: IGV por pagar (si aplica)
    if (this.impuestosGeneral > 0) {
      cuentas.push({
        cuenta: '40111', // IGV - Cuenta por pagar
        descripcion: 'IGV - Compras',
        centroCosto: '',
        debeSoles: factura.moneda === 'Soles' ? this.impuestosGeneral : 0,
        haberSoles: 0,
        debeDolares: factura.moneda === 'Dólares' ? this.impuestosGeneral : 0,
        haberDolares: 0
      });
    }

    // HABER: Cuenta por pagar al proveedor (total con IGV)
    cuentas.push({
      cuenta: '42', // Cuentas por pagar comerciales
      descripcion: `Cuenta por pagar - ${factura.proveedor}`,
      centroCosto: '',
      debeSoles: 0,
      haberSoles: factura.moneda === 'Soles' ? totalFactura : 0,
      debeDolares: 0,
      haberDolares: factura.moneda === 'Dólares' ? totalFactura : 0
    });

    // Crear el asiento
    const nuevoAsiento = {
      numeroAsiento: numeroAsientoFormateado,
      fechaRegistro: this.formatDate(fechaActual),
      fechaContable: factura.fechaEmision || this.formatDate(fechaActual),
      glosa: `Registro de factura ${factura.nrocomprobante} - ${factura.proveedor}`,
      situacionContable: 'Normal',
      total: factura.subtotal + factura.impuesto,
      estado: 'Activo',
      libro: 'Registro de compras',
      moneda: factura.moneda,
      origen: 'Automático - Factura Proveedor',
      tasaCambio: factura.tipocambio || '',
      cuentas: cuentas,
      fechaCreacion: this.formatDate(fechaActual),
      facturaAsociada: factura.nrocomprobante
    };

    // Guardar asiento en asientosManual
    this.simulation.save('asientosManual', nuevoAsiento);

    // También crear registro en libroD para que aparezca en Libro Diario
    cuentas.forEach((cuenta: any) => {
      const registroLibroDiario = {
        fechaC: factura.fechaEmision || this.formatDate(fechaActual),
        nlibro: '008', // Registro de compras
        nasiento: numeroAsientoFormateado,
        glosa: `Factura ${factura.nrocomprobante} - ${factura.proveedor}`,
        codigoC: cuenta.cuenta,
        descripcionC: cuenta.descripcion,
        centroC: cuenta.centroCosto || '',
        debito: cuenta.debeSoles + cuenta.debeDolares,
        credito: cuenta.haberSoles + cuenta.haberDolares,
        usuario: 'Usuario Actual',
        estado: 'Activo',
        moneda: factura.moneda
      };

      this.simulation.save('libroD', registroLibroDiario);
    });

    console.log(' Asiento contable creado automáticamente:', numeroAsientoFormateado);
  }

  /**
   * Obtener nombre del tipo de comprobante
   */
  private getTipoComprobanteNombre(tipo: string): string {
    const tipos: any = {
      'factura': 'Factura',
      'boleta': 'Boleta',
      'recibo_honorarios': 'Recibo por honorarios'
    };
    return tipos[tipo] || 'Factura';
  }

  /**
   * Limpiar formulario y tabla de productos
   */
  limpiarFormulario() {
    this.filaSeleccionada = null;
    this.FacturaProveedorForm.reset({
      fecharegistro: this.formatDate(new Date()),
      tipocambio: '3.75',
      documentoproveedor: 'RUC',
      condicionpago: 'contado',
      moneda: 'Soles',
      estado: 'pendiente'
    });
    this.limpiarTablaProductos();

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }
  onFechaRegistroSelected(date: Date) {
    console.log('Fecha registro:', date);
    this.fechaRegistro = date;
  }

  onFechaDetraccionSelected(date: Date) {
    const fechaFormateada = this.formatDate(date);
    this.FacturaProveedorForm.patchValue({ fechaDetraccion: fechaFormateada });
    console.log('Fecha detracción formateada:', fechaFormateada);
  }

  /**
   * Desglosa el nrocomprobante en serie y número
   * Ejemplo: 'F001-00012009' → { serie: 'F001', numero: '00012009' }
   */
  private desglosaSerieNumero(nrocomprobante: string): { serie: string; numero: string } {
    if (!nrocomprobante) {
      return { serie: 'F001', numero: '00000001' };
    }

    const partes = nrocomprobante.split('-');
    if (partes.length === 2) {
      return {
        serie: partes[0].trim(),
        numero: partes[1].trim()
      };
    }

    // Si no tiene guión, devolver como número y serie por defecto
    return {
      serie: 'F001',
      numero: nrocomprobante
    };
  }

  /**
   * Construye el nrocomprobante combinando serie y número
   * Ejemplo: ('F001', '00012009') → 'F001-00012009'
   */
  private construirNrocomprobante(serie: string, numero: string): string {
    return `${serie.trim()}-${numero.trim()}`;
  }

  private formatDate(date: Date): string {
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
  }

  /**
   * Convertir fecha string DD/MM/YYYY a objeto Date
   */
  private parseDate(dateStr: string): Date | undefined {
    if (!dateStr) return undefined;
    const parts = dateStr.split('/');
    if (parts.length !== 3) return undefined;

    const day = parseInt(parts[0], 10);
    const month = parseInt(parts[1], 10) - 1; // Los meses en JS van de 0 a 11
    const year = parseInt(parts[2], 10);

    return new Date(year, month, day);
  }

  public async modaanular() {

    const fila = this.filaSeleccionada;
    console.log('Fila seleccionada para anular:', fila);

    const detallesEjemplo: DetalleItem[] = [
      { label: 'N° de comprobante', value: fila.nrocomprobante },
      { label: 'Razón social', value: fila.proveedor },
      { label: 'F. de Emisión', value: fila.fechaEmision },
      { label: 'Fecha de Vencimiento', value: fila.vencimientoencimiento },
      { label: 'Monto total', value: fila.montoTotal },
      { label: 'Orden asociada', value: fila.tipoOrden },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Anular factura',
        subtitulomodal: 'Detalle de la factura:',
        tituloTextarea: 'Motivo de anulación',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        motivoObligatorio: true,
        textoBotonConfirmar: 'Anular',
        colorBotonConfirmar: 'danger'
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      if (!this.filaSeleccionada) {
        return;
      }
      const id = this.filaSeleccionada['id'] ?? this.filaSeleccionada.factura_proveedor_codigo;
      if (!id) {
        this.toastService.danger('No se pudo identificar la factura a anular');
        return;
      }

      this.facturaRepo.eliminar(String(id)).subscribe({
        next: () => {
          this.toastService.success('Factura anulada correctamente');
          this.facturaProveedorFacade.cargarFacturas();
          this.limpiarFormulario();
        },
        error: (err) => {
          this.toastService.danger(err?.message || 'No se pudo anular la factura');
        },
      });
    }
  }

  buscarproveedor() {
    const tipoDoc = this.FacturaProveedorForm.get('documentoproveedor')?.value;
    let numeroDoc = this.FacturaProveedorForm.get('documentoproveedorinput')?.value;

    if (!numeroDoc) {
      this.toastService.warning('Por favor ingresa un número de documento');
      return;
    }
    numeroDoc = String(numeroDoc).trim();

    // 1) Primero buscar en la lista ya cargada (rápido)
    const local = this.proveedores.find(
      (p) => String(p.proveedor_identificacion_fiscal ?? '').trim() === numeroDoc
    );
    if (local) {
      this.aplicarProveedorEncontrado({
        id: (local as any).id,
        razonSocial: local.proveedor_razon_social,
        direccion: local.proveedor_direccion_fiscal,
        nroDocumento: numeroDoc,
      });
      return;
    }

    // 2) Si no está, consultar el API directo por número de documento
    this.api
      .get<{ content?: any[] } | any[]>('/core/relaciones-comerciales', {
        nroDocumento: numeroDoc,
        esProveedor: true,
        page: 0,
        size: 5,
      })
      .subscribe({
        next: (response) => {
          const lista = Array.isArray(response)
            ? response
            : Array.isArray(response?.content)
              ? response.content
              : [];
          const encontrado =
            lista.find((p: any) => String(p.nroDocumento ?? '').trim() === numeroDoc) ?? lista[0];

          if (!encontrado) {
            this.toastService.warning('Proveedor no encontrado', `No se encontró ${tipoDoc}: ${numeroDoc}`);
            return;
          }

          this.aplicarProveedorEncontrado({
            id: encontrado.id,
            razonSocial: encontrado.razonSocial,
            direccion: encontrado.direccion,
            nroDocumento: numeroDoc,
          });
        },
        error: (err) => {
          console.error('Error buscando proveedor:', err);
          this.toastService.warning('No se pudo buscar el proveedor');
        },
      });
  }

  /** Aplica los datos del proveedor encontrado al formulario y lo recuerda para el guardado. */
  private aplicarProveedorEncontrado(prov: {
    id?: number;
    razonSocial?: string;
    direccion?: string;
    nroDocumento: string;
  }) {
    this.proveedorSeleccionado = prov;
    this.FacturaProveedorForm.patchValue({
      proveedor: prov.razonSocial ?? '',
      direccionFiscal: prov.direccion ?? '',
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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial de la factura del proveedor' },
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de la factura asociada' },
      { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Anulación de la factura del proveedor' },
      { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de la factura del proveedor' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones de la factura del proveedor',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

  onGridReadyProductos(params: GridReadyEvent) {
    this.gridApiProductos = params.api;
  }

  onDetraccionSeleccionada(detraccion: any) {
    console.log('Detracción seleccionada:', detraccion);
    this.FacturaProveedorForm.patchValue({
      nroDetraccion: detraccion.porcentaje || '',
    });
    console.log('Detracción seleccionada:', this.FacturaProveedorForm.get('nroDetraccion')?.value);
  }

  onProductoSeleccionado(producto: any) {
    console.log('Producto seleccionado:', producto);

    // Verificar si el producto ya existe en la tabla
    const productoExistente = this.productosData.find(
      item => item.factura_proveedor_codigo === producto.codigo || item.factura_proveedor_codigo === producto.id
    );
    if (productoExistente) {
      console.log('El producto ya está agregado');
      this.limpiarAutocompleteProductos();
      return;
    }

    // Crear nuevo producto para la tabla
    const cantidad = 1;
    const precioUni = producto.precioUnitario || 0;
    const subtotal = cantidad * precioUni;
    const impuestosArr: string[] = Array.isArray(producto.impuesto)
      ? producto.impuesto
      : producto.impuesto
        ? [producto.impuesto]
        : [];
    const impuestos = impuestosArr.join(', ');
    const tasa = this.calcularTasaImpuesto(impuestos);
    const montoImpuesto = +(subtotal * tasa).toFixed(2);
    const total = +(subtotal + montoImpuesto).toFixed(2);

    const nuevoProducto = {
      factura_proveedor_codigo: producto.codigo || producto.id,
      articuloId: producto.articuloId ?? producto.id ?? null,
      cantidad: cantidad,
      descripcion: producto.nombre || producto.descripcion || '',
      precioUni: precioUni,
      subtotal: subtotal,
      impuestos: impuestos,
      montoImpuesto: montoImpuesto,
      total: total
    };

    // Agregar el producto a la tabla
    this.productosData = [...this.productosData, nuevoProducto];

    // Actualizar la tabla
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', this.productosData);
    }

    // Actualizar totales
    this.actualizarTotales();

    // Limpiar el autocomplete después de agregar el producto
    this.limpiarAutocompleteProductos();
  }

  eliminarAccesorio(producto: any) {
    console.log('Eliminar producto:', producto);

    // Filtrar el producto a eliminar
    this.productosData = this.productosData.filter(item => item.codigo !== producto.codigo);

    // Actualizar la tabla
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', this.productosData);
    }

    // Actualizar totales
    this.actualizarTotales();
  }

  /**
   * Eliminar un impuesto específico de un producto
   */
  eliminarImpuesto(rowIndex: number, impuestoEliminar: string | null) {
    if (impuestoEliminar === null || rowIndex < 0 || rowIndex >= this.productosData.length) {
      return;
    }

    const producto = this.productosData[rowIndex];
    console.log('Eliminando impuesto:', impuestoEliminar, 'del producto:', producto);

    // Obtener impuestos actuales
    let impuestos = typeof producto.impuestos === 'string'
      ? producto.impuestos.split(',').map((imp: string) => imp.trim()).filter((imp: string) => imp)
      : Array.isArray(producto.impuestos)
        ? producto.impuestos
        : [];

    // Filtrar el impuesto a eliminar
    impuestos = impuestos.filter((imp: string) => imp !== impuestoEliminar);

    // Actualizar el producto
    this.productosData[rowIndex] = {
      ...producto,
      impuestos: impuestos.join(', ')
    };

    // Actualizar la tabla
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', [...this.productosData]);
    }

    console.log('Impuesto eliminado. Impuestos restantes:', impuestos);
  }

  /** Mapea el detalle al formato de la grilla (resuelve concepto financiero y recalcula montos). */
  private cargarDetalleEnGrid(detalle: any[]) {
    this.productosData = (detalle || []).map((d: any) => {
      const subtotal = Number(d.subtotal) || (Number(d.cantidad) || 0) * (Number(d.precioUni) || 0);
      const tasa = this.calcularTasaImpuesto(d.impuestos);
      const montoImpuesto = d.montoImpuesto != null ? Number(d.montoImpuesto) : +(subtotal * tasa).toFixed(2);
      return {
        ...d,
        subtotal,
        montoImpuesto,
        total: d.total != null ? Number(d.total) : +(subtotal + montoImpuesto).toFixed(2),
        conceptoFinancieroNombre:
          d.conceptoFinancieroNombre ||
          this.conceptosFinancieros.find((c) => c.id === d.conceptoFinancieroId)?.nombre ||
          '',
      };
    });
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', this.productosData);
    }
    // Reflejar en el combo el centro de costo guardado (tomado de la primera línea).
    const centroGuardado = this.productosData.find((l: any) => l.centros_costo_id != null)?.centros_costo_id;
    if (centroGuardado != null) {
      this.FacturaProveedorForm.patchValue({ centroCostoId: Number(centroGuardado) });
    }
    this.actualizarTotales();
  }

  /**
   * Recalcula subtotal/impuesto/total de la línea editada en el detalle.
   * - Si se edita cantidad o precio unitario → subtotal = cantidad * precio.
   * - Siempre recalcula el monto de impuesto y el total a partir del subtotal.
   */
  onCellValueChangedProductos(event: any) {
    const data = event.data;
    const field = event.colDef?.field;
    const cantidad = Number(data.cantidad) || 0;
    const precioUni = Number(data.precioUni) || 0;

    if (field === 'cantidad' || field === 'precioUni') {
      data.subtotal = +(cantidad * precioUni).toFixed(2);
    }

    const subtotal = Number(data.subtotal) || 0;
    const tasa = this.calcularTasaImpuesto(data.impuestos);
    data.montoImpuesto = +(subtotal * tasa).toFixed(2);
    data.total = +(subtotal + data.montoImpuesto).toFixed(2);

    if (this.gridApiProductos) {
      this.gridApiProductos.applyTransaction({ update: [data] });
    }
    this.actualizarTotales();
  }

  /** Obtiene la tasa (en fracción, ej. 0.18) a partir del texto de impuestos de la línea. */
  private calcularTasaImpuesto(impuestos: unknown): number {
    const texto = String(impuestos ?? '').trim();
    if (!texto) {
      return 0;
    }
    const lower = texto.toLowerCase();
    const cat = this.tiposImpuestoCatalogo.find(
      (t) => lower.includes(t.nombre.trim().toLowerCase()) || (t.tasa > 0 && lower.includes(String(t.tasa)))
    );
    if (cat?.tasa) {
      return cat.tasa > 1 ? cat.tasa / 100 : cat.tasa;
    }
    // Fallback: sumar los porcentajes numéricos presentes en el texto (puede haber varios separados por coma)
    let tasaTotal = 0;
    texto.split(',').forEach((parte) => {
      const m = parte.match(/(\d+(\.\d+)?)/);
      if (m) {
        tasaTotal += parseFloat(m[1]);
      }
    });
    return tasaTotal > 0 ? tasaTotal / 100 : 0;
  }

  private actualizarTotales() {
    this.subtotalGeneral = this.productosData.reduce((sum, item) => sum + (Number(item.subtotal) || 0), 0);
    this.impuestosGeneral = this.productosData.reduce((sum, item) => sum + (Number(item.montoImpuesto) || 0), 0);
    this.totalGeneral = this.productosData.reduce((sum, item) => sum + (Number(item.total) || 0), 0);
    console.log('Totales actualizados:', { subtotal: this.subtotalGeneral, impuestos: this.impuestosGeneral, total: this.totalGeneral });
  }

  limpiarTablaProductos() {
    this.productosData = [];
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', this.productosData);
    }
    this.actualizarTotales();
  }

  /**
   * Limpiar el autocomplete de productos
   */
  private limpiarAutocompleteProductos() {
    if (this.autocompleteProductos) {
      // Usar setTimeout para asegurar que se ejecute después del cambio de vista
      setTimeout(() => {
        // Limpiar la selección y el input del autocomplete
        this.autocompleteProductos.clearSelection();
      }, 50);
    }
  }

  /**
   * Cargar bienes/artículos reales desde el core (/core/articulos) para el autocomplete del detalle.
   * Cada ítem queda con `articuloId` para enviarlo en el detalle de la cuenta por pagar.
   */
  cargarProductosDesdeApi() {
    this.api.get<any>('/core/articulos', { page: 0, size: 1000 }).subscribe({
      next: (response) => {
        const articulos = Array.isArray(response)
          ? response
          : Array.isArray(response?.content)
            ? response.content
            : [];
        if (!articulos.length) {
          return;
        }
        this.productos = articulos
          .filter((item: any) => item.flagEstado !== '0')
          .map((item: any) => ({
            ...item,
            id: item.id,
            articuloId: item.id,
            codigo: item.codigo || '',
            nombre: item.nombre || item.descripcion || '',
            descripcion: `${item.codigo || ''} - ${item.nombre || item.descripcion || ''}`.trim(),
            producto: item.nombre || item.descripcion || '',
            unidadMedida: item.unidadMedidaCodigo || item.unidadMedida?.codigo || 'UND',
            precioUnitario: 0,
          }));
        this.productosCargadosApi = true;
      },
      error: (err) => console.error('Error cargando artículos desde /core/articulos:', err),
    });
  }

  /**
   * Cargar productos desde el servicio de simulación
   */
  cargarProductosDesdeSimulacion() {
    const productosLS = this.simulation.list('producto') || [];
    console.log('  Productos cargados desde maestro de productos:', productosLS);

    // Mapear productos con el formato necesario para el autocomplete
    this.productos = productosLS.map((item: any) => ({
      codigo: item.codigo,
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
        // Recargar productos desde simulation para actualizar el autocomplete
        this.cargarProductosDesdeSimulacion();
        console.log(' Productos recargados después de crear nuevo item');

        // Forzar actualización del autocomplete si existe
        if (this.autocompleteProductos) {
          // Crear una nueva referencia del array para forzar detección de cambios
          this.productos = [...this.productos];
          console.log('  Autocomplete de productos actualizado');
        }

        // Agregar automáticamente el producto creado a la tabla de artículos
        console.log('  Agregando producto creado a la tabla:', itemCreado);

        // Verificar si el producto ya existe en la tabla
        const productoExistente = this.productosData.find((item: any) => item.codigo === itemCreado.codigo);
        if (!productoExistente) {
          // Cantidad por defecto
          const cantidad = 1;
          const precioUnitario = itemCreado.precioUnitario || 0;
          const subtotal = cantidad * precioUnitario;
          const impuestos = subtotal * 0.18; // IGV 18%
          const total = subtotal + impuestos;

          // Crear nuevo artículo para la tabla
          const nuevoArticulo: any = {
            codigo: itemCreado.codigo,
            cantidad: cantidad,
            descripcion: itemCreado.descripcion || itemCreado.producto,
            unidad: itemCreado.unidad,
            precioUnitario: precioUnitario,
            subtotal: subtotal,
            impuestos: impuestos,
            total: total
          };

          // Agregar a la tabla
          this.productosData = [...this.productosData, nuevoArticulo];

          // Actualizar grid si existe
          if (this.gridApiProductos) {
            this.gridApiProductos.setGridOption('rowData', this.productosData);
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
        const activoExistente = this.productosData.find((item: any) => item.codigo === itemCreado.codigo);
        if (!activoExistente) {
          // Cantidad por defecto
          const cantidad = 1;
          const precioUnitario = parseFloat(itemCreado.valorAdquisicion) || 0;
          const subtotal = cantidad * precioUnitario;
          const impuestos = subtotal * 0.18; // IGV 18%
          const total = subtotal + impuestos;

          // Crear nuevo artículo para la tabla
          const nuevoArticulo: any = {
            codigo: itemCreado.codigo,
            cantidad: cantidad,
            descripcion: itemCreado.nombre,
            unidad: 'Unidad',
            precioUnitario: precioUnitario,
            subtotal: subtotal,
            impuestos: impuestos,
            total: total
          };

          // Agregar a la tabla
          this.productosData = [...this.productosData, nuevoArticulo];

          // Actualizar grid si existe
          if (this.gridApiProductos) {
            this.gridApiProductos.setGridOption('rowData', this.productosData);
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
  calcularTotales() {
    this.subtotalGeneral = this.productosData.reduce((sum, item) => sum + (item.subtotal || 0), 0);
    // this.impuestosGeneral = this.productosData.reduce((sum, item) => sum + (item.impuestos || 0), 0);
    this.totalGeneral = this.productosData.reduce((sum, item) => sum + (item.total || 0), 0);

    console.log(' Totales calculados - Subtotal:', this.subtotalGeneral, 'Impuestos:', this.impuestosGeneral, 'Total:', this.totalGeneral);
  }

  xmlFile: File | null = null;

  onXmlFileSelected(file: File) {
    this.xmlFile = file;
    console.log('XML seleccionado:', file.name);
  }

  onXmlFileRemoved() {
    this.xmlFile = null;
    console.log('XML removido');
  }

  onXmlFileError(errorMessage: string) {
    console.error('Error al seleccionar XML:', errorMessage);
    this.toastService.warning(errorMessage);
  }
}
