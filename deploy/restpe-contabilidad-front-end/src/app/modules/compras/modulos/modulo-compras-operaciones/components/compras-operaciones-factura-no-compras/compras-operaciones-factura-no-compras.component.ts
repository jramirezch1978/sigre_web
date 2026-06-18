import { Component, OnInit, ViewChild, inject, effect, computed } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalDetalleComponent, DetalleItem } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { forkJoin, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { AutocompleteComponent } from 'src/app/ui/autocomplete/autocomplete.component';
import { FacturaNoCompraFacade } from 'src/app/modules/compras/application/facades/factura-no-compra.facade';
import { FacturaNoCompraFeedbackEffects } from 'src/app/modules/compras/effects/factura-no-compra-feedback.effect';
import { FacturaNoCompraSyncEffects } from 'src/app/modules/compras/effects/factura-no-compra-sync.effect';
import { FacturaNoCompraEntity } from 'src/app/modules/compras/domain/models/factura-no-compra.entity';
import { ApiClientService } from 'src/app/core/infrastructure/http/api-client.service';
import { StorageService } from 'src/app/core/services/storage.service';
import { GridExportService } from 'src/app/core/infrastructure/export/grid-export.service';

type IFacturaNoCompra = FacturaNoCompraEntity;

@Component({
  selector: 'app-compras-operaciones-factura-no-compras',
  templateUrl: './compras-operaciones-factura-no-compras.component.html',
  styleUrls: ['./compras-operaciones-factura-no-compras.component.scss'],
  standalone: false,
})
export class ComprasOperacionesFacturaNoComprasComponent  implements OnInit {
  @ViewChild('autocompleteProductos') autocompleteProductos!: AutocompleteComponent;

  // Clean Architecture - Facade
  private readonly facturaNoCompraFacade = inject(FacturaNoCompraFacade);
  private readonly feedbackEffects = inject(FacturaNoCompraFeedbackEffects);
  private readonly syncEffects = inject(FacturaNoCompraSyncEffects);
  private readonly api = inject(ApiClientService);
  private readonly storage = inject(StorageService);
  private readonly gridExport = inject(GridExportService);

  // Señales expuestas desde el store
  readonly isLoadingObtener = computed(() => this.facturaNoCompraFacade.loadingObtener());
  readonly isLoadingGuardar = computed(() => this.facturaNoCompraFacade.loadingGuardar());
  readonly isLoadingEliminar = computed(() => this.facturaNoCompraFacade.loadingEliminar());

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  //Tipo de cambio para ecuador

  pais = this.countryService.getCountryCode();
  mostrarTipoCambio: boolean = true;

  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  filaseleccionada: any
  tipoSeleccionado: string = 'registro';
  estadoSeleccionado: string = '';
  mostrartabla = true;
  facturaAnulada: boolean = false;
  private gridApi!: GridApi;
  FacturaNoCompraForm!: FormGroup;
  documentoSoporte: string = '';
  modoEdicion: boolean = false;
  modoCreacion: boolean = true;
  
  proveedores: any[] = [];
  sucursales: any[] = [];
  centrosCosto: any[] = [];
  cuentasContables: any[] = [];
  
  monedas = [
    { value: 'Soles', label: 'Soles' },
    { value: 'USD', label: 'Dólares' },
    { value: 'EUR', label: 'Euros' }
  ];
  
  estados = [
    { value: 'pendiente', label: 'Pendiente' },
    { value: 'registrada', label: 'Aprobada' }
  ];

    tipoFs = [
    { value: 'registro', nombre: 'De registro' },
    { value: 'vencimiento', nombre: 'Vencimiento' },
  ]
  
  tipocambio: any[] = [];
  colDefs: ColDef[] = [
    { field: 'factura_no_compra_codigo', headerName: 'Código', flex: 1, minWidth: 100 },
    { field: 'factura_no_compra_fecha_registro', headerName: 'Fecha de registro', flex: 1, minWidth: 90,
      valueFormatter: (params) => {
        if (params.value) {
          const date = new Date(params.value + 'T00:00:00');
          return date.toLocaleDateString('es-PE');
        }
        return '';
      }
     },
    { field: 'factura_no_compra_tipo_gasto', headerName: 'Tipo de gasto', flex: 1.2, minWidth: 110,filter:true },
    { field: 'factura_no_compra_proveedor', headerName: 'Razón social', flex: 2, minWidth: 150,filter:true },
    { field: 'factura_no_compra_vencimiento', headerName: 'Vencimiento', flex: 1, minWidth: 100,
      valueFormatter: (params) => {
        if (params.value) {
          const date = new Date(params.value + 'T00:00:00');
          return date.toLocaleDateString('es-PE');
        }
        return '';
      }
     },
    { field: 'factura_no_compra_responsable', headerName: 'Responsable', flex: 1.5, minWidth: 120 },
    { field: 'factura_no_compra_monto_total', headerName: 'Monto total', flex: 1, minWidth: 100, 
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
      field: 'factura_no_compra_estado',
      filter:true, 
      headerName: 'Estado', 
      flex: 1, 
      minWidth: 100,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        
        switch(estado) {
          case 'Aprobada':
            badgeClass = 'bg-green-100 text-green-600';
            break;
          case 'Anulado':
            badgeClass = 'bg-red-100 text-red-600';
            break;
          case 'Registrado':
            badgeClass = 'bg-[#D6E6FF] text-[#3B82F6]';
            break;
          default:
            badgeClass = 'bg-[#F5F5F5] text-[#363636]';
        }
        
        return `<span class="badge-table ${badgeClass}">${estado}</span>`;
      },
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' },
    }
  ];

  // Columnas para la tabla de productos
  productosColDefs: ColDef[] = [
    { field: 'codigo', headerName: 'Codigo', flex: 1, minWidth: 80 },
    { field: 'cantidad', headerName: 'Cantidad', flex: 0.8, minWidth: 80, cellClass: 'text-center', editable: true },
    { field: 'descripcion', headerName: 'Descripcion', flex: 2, minWidth: 150 },
    { field: 'precioUni', headerName: 'Precio unitario', flex: 1, minWidth: 100, editable: true,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '0.00';
      }
    },
    { field: 'subtotal', headerName: 'Subtotal', flex: 1, minWidth: 100, 
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '0.00';
      }
    },
    { field: 'impuestos', headerName: 'Impuestos', flex: 1, minWidth: 100, 
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '0.00';
      }
    },
    { field: 'total', headerName: 'Total', flex: 1, minWidth: 100, 
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '0.00';
      }
    }
  ];

  // Datos de la tabla de productos
  productosData: any[] = [];
  private gridApiProductos!: GridApi;

  // Totales generales
  subtotalGeneral: number = 0;
  impuestosGeneral: number = 0;
  totalGeneral: number = 0;

  // Catalogo real cargado desde API.
  productos: any[] = [];

  rowData: IFacturaNoCompra[] = [];
  /** Fuente completa (sin filtrar por fecha). */
  private facturasFuente: IFacturaNoCompra[] = [];

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
    private formValidationService: FormValidationService,
    private countryService: CountryService,
    private toastService: ToastService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Sincronizar rowData con el store via effect
    effect(() => {
      const facturas = this.facturaNoCompraFacade.facturas();
      this.facturasFuente = [...facturas].reverse();
      this.aplicarFiltroFechas();
    });
  }

  ngOnInit() {

    this.FacturaNoCompraForm = this.formBuilder.group({
      fecharegistro: [{value: this.fechaHoyISO(), disabled: true}],
      proveedor: ['', Validators.required],
      serieNumero: ['', Validators.required],
      fechaEmision: [null, Validators.required],
      fechaVencimiento: [null, Validators.required],
      sucursal: ['', Validators.required],
      centroCosto: [''],
      moneda: ['', Validators.required],
      tipogasto: ['', Validators.required],
      tipoCambio: [{value: '3.5', disabled: true}],
      descripcionDetallada: [''],
      documentoproveedor: ['dni'],
      documentoproveedorinput: [''],
      cuentaContable: ['', Validators.required],
      numdocumento: [''],
      autorizacion: [''],
      subtotal: [''],
      impuesto: [''],
      totalAjuste: [''],
      archivo: ['', Validators.required],
      estado: ['pendiente']
    });
    
    // Inicializar FormValidationService
    this.formValidationService.inicializarFormulario(this.FacturaNoCompraForm);
    this.formValidationService.resetearEstado();

    //Labels de formulario: Tipo de cambio por ahora
    this.configurarLabelsPorPais();

    this.cargarCatalogos();
    this.cargarFacturasDesdeStore();
  }

  private cargarCatalogos(): void {
    const user = this.storage.getUser<{ empresaId?: number }>();
    const sucursales$ = user?.empresaId
      ? this.api.get<any>(`/core/empresas/${user.empresaId}/sucursales`, { page: 0, size: 1000 }).pipe(
          map((response) => this.extraerLista(response)),
          catchError(() => of([]))
        )
      : of([]);

    forkJoin({
      proveedores: this.api.get<any>('/core/relaciones-comerciales', { esProveedor: true, page: 0, size: 1000 }).pipe(
        map((response) => this.extraerLista(response)),
        catchError(() => of([]))
      ),
      sucursales: sucursales$,
      centrosCosto: of([]),
      conceptos: this.api.get<any>('/finanzas/conceptos-financieros', { page: 0, size: 200 }).pipe(
        map((response) => this.extraerLista(response)),
        catchError(() => of([]))
      ),
      cuentas: this.api.get<any>('/core/plan-contable-det', { size: 200 }).pipe(
        map((response) => this.extraerLista(response)),
        catchError(() => of([]))
      ),
      servicios: this.api.get<any>('/compras/maestros/servicios-catalogo', { page: 0, size: 1000 }).pipe(
        map((response) => this.extraerLista(response)),
        catchError(() => of([]))
      ),
    }).subscribe({
      next: ({ proveedores, sucursales, centrosCosto, conceptos, cuentas, servicios }) => {
        this.proveedores = proveedores
          .filter((item: any) => item.flagEstado !== '0')
          .map((item: any) => ({
            id: String(item.id),
            nombre: item.razonSocial ?? item.nombre ?? String(item.id),
            nroDocumento: item.nroDocumento ?? '',
          }));
        this.sucursales = sucursales
          .filter((item: any) => item.flagEstado !== '0')
          .map((item: any) => ({ id: String(item.id), nombre: item.nombre ?? item.codigo ?? String(item.id) }));
        this.centrosCosto = centrosCosto.map((item: any) => ({
          id: String(item.id),
          nombre: item.nombre ?? item.codigo ?? String(item.id),
        }));
        this.tipocambio = conceptos
          .filter((item: any) => item.flagEstado !== '0' && item.activo !== false)
          .map((item: any) => ({ value: String(item.id), nombre: item.nombre ?? item.codigo ?? String(item.id) }));
        this.cuentasContables = cuentas
          .filter((item: any) => item.flagEstado !== '0')
          .map((item: any) => ({
            id: String(item.id),
            nombre: `${item.cntaCtbl ?? item.codigo ?? item.id} - ${item.nombre ?? item.descCnta ?? ''}`.trim(),
          }));
        const catalogoDetalle = servicios.length ? servicios : conceptos;
        this.productos = catalogoDetalle
          .filter((item: any) => item.flagEstado !== '0')
          .map((item: any) => ({
            id: item.id,
            codigo: item.codigo ?? item.servicio ?? String(item.id),
            descripcion: item.descripcion ?? item.nombre ?? item.servicio ?? String(item.id),
            precio: Number(item.tarifaEstd ?? item.precio ?? item.valorUnitario ?? 0),
          }));
      },
      error: () => this.toastService.warning('No se pudieron cargar todos los catalogos de la factura.'),
    });
  }

  private extraerLista(response: any): any[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response.content;
    }
    if (Array.isArray(response?.data)) {
      return response.data;
    }
    if (Array.isArray(response?.data?.content)) {
      return response.data.content;
    }
    return [];
  }
  
  private fechaHoyISO(): string {
    const hoy = new Date();
    return `${hoy.getFullYear()}-${String(hoy.getMonth() + 1).padStart(2, '0')}-${String(hoy.getDate()).padStart(2, '0')}`;
  }
  
  cargarFacturasDesdeStore(): void {
    this.facturaNoCompraFacade.cargarFacturas();
  }

  configurarLabelsPorPais() {
  if(this.pais === 'EC') {
    this.mostrarTipoCambio = false; // Ocultar tipo de cambio en Ecuador
  }
}


  puedeGuardar(): boolean {
    return this.FacturaNoCompraForm.valid && this.FacturaNoCompraForm.dirty;
  }

  mostrarTabla(valor: boolean){
    this.mostrartabla = valor;
  }
  
  async nuevafactura() {
    // Validar cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    this.limpiarFormulario();
  }

  limpiarFormulario() {
    // Limpiar el formulario
    this.FacturaNoCompraForm.reset();
    // Mantener tipoCambio con su valor desabilitado
    this.FacturaNoCompraForm.patchValue({
      tipoCambio: '3.5'
    }, { emitEvent: false });
    this.productosData = [];
    this.calcularTotales();
    this.documentoSoporte = '';
    this.FacturaNoCompraForm.get('archivo')?.setValue('');
    this.filaseleccionada = null;
    
    // Limpiar el autocomplete de productos
    if (this.autocompleteProductos) {
      this.autocompleteProductos.clearSelection();
    }
    
    // Refrescar la grilla de productos
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', []);
    }
    
    // Establecer modo creación
    this.modoEdicion = false;
    this.modoCreacion = true;
    this.facturaAnulada = false;
    // Rehabilitar campos del formulario
    this.FacturaNoCompraForm.enable({ emitEvent: false });
    this.FacturaNoCompraForm.get('fecharegistro')?.disable({ emitEvent: false });
    this.FacturaNoCompraForm.get('tipoCambio')?.disable({ emitEvent: false });
    
    // Deseleccionar filas en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    this.FacturaNoCompraForm.reset({
      fecharegistro: this.fechaHoyISO(),
      estado: 'pendiente'
    });
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }
  /** Filtro rápido de la lista: busca el texto en todas las columnas visibles. */
  onBuscarLista(event: any): void {
    const valor = (event?.detail?.value ?? event?.target?.value ?? '').toString();
    this.gridApi?.setGridOption('quickFilterText', valor);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  async onCellClicked(event: any) {
    if (!event.data) return;
    
    const nuevaSeleccion = event.data;
    
    // Si es la misma fila, no hacer nada
    if (this.filaseleccionada && this.filaseleccionada.factura_no_compra_codigo === nuevaSeleccion.factura_no_compra_codigo) {
      return;
    }
    
    // Guardar elemento con foco
    const elementoConFoco = document.activeElement as HTMLElement;
    
    // Validar cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló, deseleccionar y volver a seleccionar la anterior
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
          if (this.filaseleccionada) {
            this.gridApi.forEachNode((node) => {
              if (node.data && node.data.factura_no_compra_codigo === this.filaseleccionada.factura_no_compra_codigo) {
                node.setSelected(true);
              }
            });
          }
        }
        // Restaurar foco
        if (elementoConFoco && elementoConFoco.tagName === 'INPUT') {
          elementoConFoco.focus();
        }
      }, 0);
      return;
    }
    
    // Usuario confirmó, cargar nueva selección
    this.filaseleccionada = nuevaSeleccion;
    
    // Establecer modo edición
    this.modoEdicion = true;
    this.modoCreacion = false;

    // Resolver IDs desde los nombres almacenados para autocompletes
    const proveedorId = this.proveedores.find(p => p.nombre === this.filaseleccionada.factura_no_compra_proveedor)?.id
      || this.filaseleccionada.factura_no_compra_proveedor;
    const sucursalId = this.sucursales.find(c => c.nombre === this.filaseleccionada.factura_no_compra_sucursal
      || c.id === this.filaseleccionada.factura_no_compra_sucursal)?.id
      || this.filaseleccionada.factura_no_compra_sucursal;
    const centroCostoId = this.centrosCosto.find(c => c.id === this.filaseleccionada.factura_no_compra_centro_costo
      || c.nombre === this.filaseleccionada.factura_no_compra_centro_costo)?.id
      || this.filaseleccionada.factura_no_compra_centro_costo;
    const cuentaContableId = this.cuentasContables.find(c => c.id === this.filaseleccionada.factura_no_compra_cuenta_contable
      || c.nombre === this.filaseleccionada.factura_no_compra_cuenta_contable)?.id
      || this.filaseleccionada.factura_no_compra_cuenta_contable;
    const tipoGastoValue = this.tipocambio.find(t => t.nombre === this.filaseleccionada.factura_no_compra_tipo_gasto)?.value
      || this.filaseleccionada.factura_no_compra_tipo_gasto;

    
    this.FacturaNoCompraForm.patchValue({
      fecharegistro: this.filaseleccionada.factura_no_compra_fecha_registro,
      proveedor: proveedorId,
      serieNumero: this.filaseleccionada.factura_no_compra_serie_numero || this.filaseleccionada.factura_no_compra_codigo,
      numdocumento: this.filaseleccionada.factura_no_compra_serie_numero || this.filaseleccionada.factura_no_compra_codigo,
      fechaEmision: this.filaseleccionada.factura_no_compra_fecha_emision,
      fechaVencimiento: this.filaseleccionada.factura_no_compra_vencimiento,
      sucursal: sucursalId,
      centroCosto: centroCostoId,
      moneda: this.filaseleccionada.factura_no_compra_moneda || 'Soles',
      tipogasto: tipoGastoValue,
      tipoCambio: '3.5',
      descripcionDetallada: this.filaseleccionada.factura_no_compra_descripcion_detallada || '',
      documentoproveedor: 'dni',
      documentoproveedorinput: this.filaseleccionada.factura_no_compra_doc_fiscal || '',
      cuentaContable: cuentaContableId,
      subtotal: '',
      impuesto: '',
      totalAjuste: this.filaseleccionada.factura_no_compra_monto_total,
      archivo: this.filaseleccionada.factura_no_compra_archivo_adjunto || 'archivo_existente.pdf'
    }, { emitEvent: false });
    
    // Resetear servicio después de cargar datos
    this.formValidationService.resetearEstado();

    // Bloquear formulario si la factura está anulada
    const esAnulada = this.filaseleccionada.factura_no_compra_estado === 'Anulado';
    this.facturaAnulada = esAnulada;
    if (esAnulada) {
      this.FacturaNoCompraForm.disable({ emitEvent: false });
    } else {
      // Rehabilitar excepto campos que siempre están disabled
      this.FacturaNoCompraForm.enable({ emitEvent: false });
      this.FacturaNoCompraForm.get('fecharegistro')?.disable({ emitEvent: false });
      this.FacturaNoCompraForm.get('tipoCambio')?.disable({ emitEvent: false });
    }

    // Cargar productos de la fila seleccionada
    const productos = this.filaseleccionada.factura_no_compra_productos || [];
    this.productosData = [...productos];
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', this.productosData);
    }
    this.calcularTotales();
  }

  onFileSelected(event: any) {
    // Si el evento viene directamente de app-file-upload, suele ser el File o un objeto con el archivo
    const file = event?.name ? event : (event?.target?.files ? event.target.files[0] : event);
    
    if (file) {
      this.documentoSoporte = file.name;
      this.FacturaNoCompraForm.get('archivo')?.setValue(file.name);
      this.FacturaNoCompraForm.get('archivo')?.updateValueAndValidity();
      console.log('Archivo seleccionado:', file.name);
    }
  }

  removeFile() {
    this.documentoSoporte = '';
    this.FacturaNoCompraForm.get('archivo')?.setValue('');
    this.FacturaNoCompraForm.get('archivo')?.updateValueAndValidity();
    console.log('Archivo removido');
  }

  async anularFactura() {
    if (!this.filaseleccionada) {
      this.toastService.warning('Selecciona una factura para anular');
      return;
    }

    // Preparar detalles de la factura para el modal
    const detalles: DetalleItem[] = [
      { label: 'Código:', value: this.filaseleccionada.factura_no_compra_codigo },
      { label: 'F. de registro:', value: this.filaseleccionada.factura_no_compra_fecha_registro },
      { label: 'Tipo:', value: this.filaseleccionada.factura_no_compra_tipo_gasto },
      { label: 'Proveedor:', value: this.filaseleccionada.factura_no_compra_proveedor },
      { label: 'Usuario ejecutor:', value: 'Usuario Actual' }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Anular factura',
        subtitulomodal: 'Detalle de la factura:',
        detalles: detalles,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo de anulación',
        placeholderTextarea: 'Describe el motivo de la eliminación',
        motivoObligatorio: true,
        textoBotonConfirmar: 'Anular',
        textoBotonCancelar: 'Cancelar',
        colorBotonConfirmar: 'danger',
        widthModal: '550px'
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();

    if (data?.action === 'confirmar') {
      this.facturaNoCompraFacade.eliminarFactura(this.filaseleccionada.id ?? this.filaseleccionada.factura_no_compra_codigo);
      this.limpiarFormulario();
    }
  }

  guardarFactura() {
    if (this.FacturaNoCompraForm.invalid) {
      const labels: { [key: string]: string } = {
        proveedor: 'Razon social',
        serieNumero: 'Serie/Numero',
        fechaEmision: 'Fecha de emision',
        fechaVencimiento: 'Fecha de vencimiento',
        sucursal: 'Sucursal',
        moneda: 'Moneda',
        tipogasto: 'Tipo de gasto',
        cuentaContable: 'Cuenta contable',
        archivo: 'Archivo adjunto'
      };

      const faltantes = Object.keys(this.FacturaNoCompraForm.controls)
        .filter(key => this.FacturaNoCompraForm.get(key)?.invalid)
        .map(key => labels[key] || key);

      this.toastService.warning('Faltan completar: ' + faltantes.join(', '));
      return;
    }

    const formValue = this.FacturaNoCompraForm.getRawValue();
    const fechaEmision = this.normalizarFechaFormulario(formValue.fechaEmision);
    const fechaVencimiento = this.normalizarFechaFormulario(formValue.fechaVencimiento);

    if (fechaVencimiento < fechaEmision) {
      this.toastService.warning('La fecha de vencimiento no puede ser menor a la fecha de emision.');
      return;
    }

    if (!this.productosData.length) {
      this.toastService.warning('Agrega al menos un detalle para registrar la factura.');
      return;
    }

    if (!formValue.centroCosto) {
      this.toastService.warning('No se puede registrar: el backend no expone el catalogo de centros de costo requerido por Finanzas.');
      return;
    }

    const nombreProveedor = this.proveedores.find(p => p.id === formValue.proveedor)?.nombre || formValue.proveedor;
    const nombreTipoGasto = this.tipocambio.find(t => t.value === formValue.tipogasto)?.nombre || formValue.tipogasto;
    const nombreSucursal = this.sucursales.find(c => c.id === formValue.sucursal)?.nombre || formValue.sucursal;
    const nombreCentroCosto = this.centrosCosto.find(c => c.id === formValue.centroCosto)?.nombre || formValue.centroCosto;
    const estadoMap: { [key: string]: string } = {
      'pendiente': 'Pendiente',
      'registrada': 'Registrado',
      'aprobada': 'Aprobada',
      'anulado': 'Anulado'
    };
    const estadoFinal = estadoMap[formValue.estado] || formValue.estado || 'Pendiente';

    const factura: IFacturaNoCompra = {
      id: this.filaseleccionada?.id,
      factura_no_compra_codigo: this.filaseleccionada?.factura_no_compra_codigo || formValue.serieNumero,
      factura_no_compra_serie_numero: formValue.serieNumero,
      factura_no_compra_fecha_registro: formValue.fecharegistro,
      factura_no_compra_fecha_emision: fechaEmision,
      factura_no_compra_doc_fiscal: formValue.documentoproveedorinput || '',
      factura_no_compra_tipo_gasto: nombreTipoGasto,
      factura_no_compra_proveedor: nombreProveedor,
      factura_no_compra_proveedor_id: Number(formValue.proveedor),
      factura_no_compra_vencimiento: fechaVencimiento,
      factura_no_compra_responsable: 'Usuario Actual',
      factura_no_compra_monto_total: this.totalGeneral,
      factura_no_compra_estado: estadoFinal,
      factura_no_compra_sucursal: nombreSucursal,
      factura_no_compra_sucursal_id: Number(formValue.sucursal),
      factura_no_compra_centro_costo: nombreCentroCosto,
      factura_no_compra_centros_costo_id: Number(formValue.centroCosto),
      factura_no_compra_moneda: formValue.moneda,
      factura_no_compra_cuenta_contable: formValue.cuentaContable,
      factura_no_compra_concepto_financiero_id: Number(formValue.tipogasto),
      factura_no_compra_descripcion_detallada: formValue.descripcionDetallada || '',
      factura_no_compra_archivo_adjunto: formValue.archivo || '',
      factura_no_compra_productos: [...this.productosData]
    } as any;

    if (this.modoEdicion) {
      this.facturaNoCompraFacade.actualizarFactura(factura);
    } else {
      this.facturaNoCompraFacade.guardarFactura(factura);
    }

    this.formValidationService.resetearEstado();
    this.limpiarFormulario();
  }

  private normalizarFechaFormulario(value: unknown): string {
    if (value instanceof Date) {
      return value.toISOString().slice(0, 10);
    }
    return String(value ?? '').slice(0, 10);
  }

  onProveedorSeleccionado(proveedor: any) {
    this.FacturaNoCompraForm.patchValue({
      proveedor: proveedor.id,
      documentoproveedorinput: proveedor.nroDocumento ?? ''
    });
  }

  onSucursalSeleccionada(sucursal: any) {
    this.FacturaNoCompraForm.patchValue({
      sucursal: sucursal.id
    });
  }

  onCentroCostoSeleccionado(centroCosto: any) {
    this.FacturaNoCompraForm.patchValue({
      centroCosto: centroCosto.id
    });
  }

  onCuentaContableSeleccionada(cuenta: any) {
    this.FacturaNoCompraForm.patchValue({ cuentaContable: cuenta.id });
  }


  // Para modo SINGLE - Manejo de fechas seleccionadas
  onFechaEmisionSelected(date: Date) {
    this.FacturaNoCompraForm.patchValue({ fechaEmision: date });
  }

  onFechaVencimientoSelected(date: Date) {
    this.FacturaNoCompraForm.patchValue({ fechaVencimiento: date });
  }
  onBtReset() {
    this.cargarFacturasDesdeStore();
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    this.aplicarFiltroFechas();
  }

  /** Campo de fecha sobre el que aplica el filtro de rango, según el select. */
  private fechaFiltroField(): string {
    return this.tipoSeleccionado === 'vencimiento'
      ? 'factura_no_compra_vencimiento'
      : 'factura_no_compra_fecha_registro';
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

  /** Cambió el tipo de fecha (registro/vencimiento): re-aplica el filtro. */
  onTipoFechaChange(): void {
    this.aplicarFiltroFechas();
  }

  // Métodos para la tabla de productos
  onGridReadyProductos(params: GridReadyEvent) {
    this.gridApiProductos = params.api;
  }

  onProductoSeleccionado(producto: any) {
    if (!producto) return;

    // Verificar si el producto ya existe en la lista
    const productoExistente = this.productosData.find(item => item.codigo === producto.codigo);
    
    if (productoExistente) {
      // Si existe, incrementar cantidad
      productoExistente.cantidad += 1;
      productoExistente.subtotal = productoExistente.cantidad * productoExistente.precioUni;
      productoExistente.impuestos = productoExistente.subtotal * 0.18;
      productoExistente.total = productoExistente.subtotal + productoExistente.impuestos;
    } else {
      // Si no existe, agregarlo
      const nuevoProducto = {
        codigo: producto.codigo,
        cantidad: 1,
        descripcion: producto.descripcion,
        precioUni: producto.precio || 0,
        subtotal: producto.precio || 0,
        impuestos: (producto.precio || 0) * 0.18,
        total: (producto.precio || 0) * 1.18
      };
      
      this.productosData = [...this.productosData, nuevoProducto];
    }

    // Actualizar la tabla
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', this.productosData);
    }

    // Recalcular totales
    this.calcularTotales();

    // Limpiar autocomplete para mostrar el placeholder
    setTimeout(() => {
      if (this.autocompleteProductos) {
        this.autocompleteProductos.clearSelection();
      }
    });
  }

  abrirModalNuevoProducto() {
    // Aquí puedes agregar la lógica para abrir un modal
  }

  eliminarProducto(producto: any) {
    this.productosData = this.productosData.filter(item => item.codigo !== producto.codigo);
    
    // Actualizar la tabla
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', this.productosData);
    }

    // Recalcular totales
    this.calcularTotales();
  }

  calcularTotales() {
    this.subtotalGeneral = this.productosData.reduce((sum, item) => sum + (item.subtotal || 0), 0);
    this.impuestosGeneral = this.productosData.reduce((sum, item) => sum + (item.impuestos || 0), 0);
    this.totalGeneral = this.productosData.reduce((sum, item) => sum + (item.total || 0), 0);
  }

  onProductoCellValueChanged(event: any) {
    const row = event.data;
    row.cantidad = Math.max(Number(row.cantidad) || 0, 0);
    row.precioUni = Math.max(Number(row.precioUni) || 0, 0);
    row.subtotal = row.cantidad * row.precioUni;
    row.impuestos = row.subtotal * 0.18;
    row.total = row.subtotal + row.impuestos;
    this.productosData = [...this.productosData];
    this.gridApiProductos?.setGridOption('rowData', this.productosData);
    this.calcularTotales();
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
          { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del plan de abastecimiento'},
          { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de cantidad sugerida de artículo ART-001'},
          { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Anulación', detalleCambio: 'Plan validado y aprobado para ejecución'},
          { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Agregado de 5 artículos al plan' }
        ];
    
        const modal = await this.modalController.create({
          component: ModalVerActualizacionesComponent,
          cssClass: 'promo',
          componentProps: {
            titulo: 'Historial de Actualizaciones de la factura que no pertenece a gastos',
            rowData: rowData,
            colDefs: colDefs,
            anchoModal: '700px',
          }
        });
        
        await modal.present();
      }
}
