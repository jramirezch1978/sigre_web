import { Component, OnInit, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { AccesorioActionsCellComponent } from 'src/app/modules/activos/m-af-tabla/pages/af-o-registroactivos/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { GridExportService } from 'src/app/core/infrastructure/export/grid-export.service';
import { AprobarServicioFacade } from 'src/app/modules/compras/application/facades/aprobar-servicio.facade';
import { AprobarServicioFeedbackEffects } from 'src/app/modules/compras/effects/aprobar-servicio-feedback.effect';
import { AprobarServicioSyncEffects } from 'src/app/modules/compras/effects/aprobar-servicio-sync.effect';
import { OrdenServicioEntity } from 'src/app/modules/compras/domain/models/orden-servicio.entity';
import { IOrdenServicioRepository } from 'src/app/modules/compras/domain/repositories/iorden-servicio.repository';
import { ApiClientService } from 'src/app/core/infrastructure/http/api-client.service';
import { StorageService } from 'src/app/core/services/storage.service';
import { catchError, of } from 'rxjs';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faCheck, faChevronsLeft, faChevronsRight, faGear, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

type IOrdenServicio = OrdenServicioEntity;


@Component({
  selector: 'app-compras-aprobar-servicio',
  templateUrl: './compras-aprobar-servicio.component.html',
  styleUrls: ['./compras-aprobar-servicio.component.scss'],
  standalone: false,
})
export class ComprasAprobarServicioComponent  implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCheck = faCheck;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasGear = faGear;
  fasRotateRight = faRotateRight;
  fasDownload = faDownload;

  // Facade + Effects (Clean Architecture)
  private readonly aprobarServicioFacade = inject(AprobarServicioFacade);
  private readonly _feedbackEffects = inject(AprobarServicioFeedbackEffects);
  private readonly _syncEffects = inject(AprobarServicioSyncEffects);
  private readonly countryService = inject(CountryService);
  private readonly formBuilder = inject(FormBuilder);
  private readonly modalController = inject(ModalController);
  private readonly simulation = inject(SimulationService);
  private readonly toastService = inject(ToastService);
  private readonly gridExport = inject(GridExportService);
  private readonly ordenServicioRepo = inject(IOrdenServicioRepository);
  private readonly api = inject(ApiClientService);
  private readonly storage = inject(StorageService);

  /** Mapa de sucursales (id -> nombre/dirección) para resolver al cargar el detalle. */
  private sucursalesMap = new Map<string, { nombre: string; direccion: string }>();
  /** Centros de costo (id -> nombre) para mostrar el nombre en el detalle. */
  centrosCostos: { id: any; nombre: string }[] = [];
  /** Formas de pago (id -> nombre) para mostrar el nombre de la condición de pago. */
  private condicionesPagoMap = new Map<string, string>();

  // Store selectors
  readonly ordenesPendientes = this.aprobarServicioFacade.ordenesPendientes;
  readonly loadingObtener    = this.aprobarServicioFacade.loadingObtener;
  readonly loadingAprobar    = this.aprobarServicioFacade.loadingAprobar;

    //Tipo de cambio para ecuador
  pais = this.countryService.getCountryCode();
  mostrarTipoCambio: boolean = true;

  titulo='';
  inhabilitarbotones=false;
    //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  fechaRegistro: Date = new Date();
  fechaEntrega: Date | undefined;

  camponuevo = false;
  estadoSeleccionado: string = 'todos';
  filaSeleccionada:any = null;
  ordenSeleccionada: IOrdenServicio | null = null;
  puedeEditarFormulario: boolean = false;
  mostrartabla=true;
  filasSeleccionadas: IOrdenServicio[] = [];
  private gridApi!: GridApi;
  private gridApiArticulos!: GridApi;
  OrdenesDeCompraForm!: FormGroup;
  
  colDefs: ColDef[] = [
    { 
      headerName: '', 
      checkboxSelection: true, 
      headerCheckboxSelection: true,
      width: 50,
      maxWidth: 50,
      pinned: 'left'
    },
    { field: 'orden_servicio_numero', headerName: 'Nº órden de servicio', flex: 1, minWidth: 75 },
    { field: 'orden_servicio_fecha_registro', headerName: 'Fecha registro', flex: 1, minWidth: 76 },
    { field: 'orden_servicio_proveedor', headerName: 'Razón social', flex: 2, minWidth: 140 },
    { field: 'orden_servicio_sucursal', headerName: 'Sucursal', flex: 1, minWidth: 113, filter:true },
    { field: 'orden_servicio_moneda', headerName: 'Moneda', flex: 0.8, minWidth: 50 },
    { field: 'orden_servicio_total', headerName: 'Total', flex: 1, minWidth: 70,
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
      field: 'orden_servicio_estado', 
      headerName: 'Estado', 
      flex: 1, 
      filter:true,
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

  rowData: IOrdenServicio[] = [];
  /** Tipo de fecha del filtro de rango: 'registro' | 'entrega'. */
  tipoFechaFiltro: string = 'registro';
  /** Fuente completa de órdenes pendientes (sin filtrar por fecha). */
  private ordenesFuente: IOrdenServicio[] = [];

  private readonly columnasExport = [
    { header: 'Nº Orden de servicio', field: 'orden_servicio_numero' },
    { header: 'Fecha registro', field: 'orden_servicio_fecha_registro' },
    { header: 'Razón social', field: 'orden_servicio_proveedor' },
    { header: 'Sucursal', field: 'orden_servicio_sucursal' },
    { header: 'Moneda', field: 'orden_servicio_moneda' },
    { header: 'Total', field: 'orden_servicio_total' },
    { header: 'Estado', field: 'orden_servicio_estado' },
  ];

  async exportarExcel(): Promise<void> {
    const filas = this.gridExport.obtenerFilas(this.gridApi, this.rowData) as Array<Record<string, unknown>>;
    if (!filas.length) {
      this.toastService.warning('No hay órdenes para exportar');
      return;
    }
    await this.gridExport.exportarExcel(
      `aprobacion-ordenes-servicio-${this.gridExport.fechaHoy()}`,
      this.columnasExport,
      filas,
      'Aprobación OS',
    );
  }

  async exportarPdf(): Promise<void> {
    const filas = this.gridExport.obtenerFilas(this.gridApi, this.rowData) as Array<Record<string, unknown>>;
    if (!filas.length) {
      this.toastService.warning('No hay órdenes para exportar');
      return;
    }
    await this.gridExport.exportarPdf(
      'Aprobación de órdenes de servicio',
      `aprobacion-ordenes-servicio-${this.gridExport.fechaHoy()}`,
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
    { field: 'det_orden_servicio_codigo', headerName: 'Código', flex: 0.8, minWidth: 80 },
    { field: 'det_orden_servicio_cantidad', headerName: 'Cantidad', flex: 0.7, minWidth: 70 },
    { field: 'det_orden_servicio_descripcion', headerName: 'Descripción', flex: 1, minWidth: 150 },
    { field: 'det_orden_servicio_precio_unitario', headerName: 'Precio uni.', flex: 0.9, minWidth: 85, valueFormatter: (params) => {
      return params.value ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '0.00';
    }},
    {
      headerName: 'Centro de costos',
      field: 'centrocostos',
      flex: 1.2,
      minWidth: 150,
      valueGetter: (params) => {
        const id = params.data?.centrocostos;
        if (!id) return '';
        const cc = this.centrosCostos.find((c) => String(c.id) === String(id));
        return cc ? cc.nombre : String(id);
      },
    },
    { field: 'det_orden_servicio_subtotal', headerName: 'Subtotal', flex: 0.9, minWidth: 85, valueFormatter: (params) => {
      return params.value ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '0.00';
    }},
    { field: 'det_orden_servicio_impuestos', headerName: 'Impuestos', flex: 0.9, minWidth: 85, valueFormatter: (params) => {
      return params.value ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '0.00';
    }},
    { field: 'det_orden_servicio_total', headerName: 'Total', flex: 0.9, minWidth: 85, valueFormatter: (params) => {
      return params.value ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '0.00';
    }},
    { field: 'acciones', headerName: 'Acciones', headerClass: 'centrarencabezado', flex: 0.8, minWidth: 80,
      cellRenderer: AccesorioActionsCellComponent,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  rowDataArticulos: any[] = [];

  constructor() {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Sync rowData con el store cada vez que cambien las órdenes pendientes
    effect(() => {
      const ordenes = this.ordenesPendientes();
      this.ordenesFuente = ordenes;
      this.aplicarFiltroFechas();
    });
  }

  ngOnInit() {
    this.OrdenesDeCompraForm = this.formBuilder.group({
      nroordenservicio: [''],
      documentoproveedorinput: [''],
      razonSocial: ['Restaurant.pe'],
      ruc: ['20123456789'],
      direccionFiscal: [''],
      emitidoPor: [''],
      estado: [''],
      sucursal: [''],
      direccionEntrega: [''],
      moneda: [''],
      tipoCambio: [''],
      condicionPago: [''],
      fechaRegistro: [''],
      autorizadoPor:[''],
      rechazadoPor:[''],
      retornadoPor:[''],
      proveedor: [''],
    });
    this.configurarFormularioSegunEstado();
    this.configurarLabelsPorPais();
    this.cargarOrdenesPendientesDesdeStore();
    this.cargarSucursales();
    this.cargarCentrosCosto();
    this.cargarCondicionesPago();
  }

  /** Carga las formas de pago (GET /core/formas-pago) para mostrar el nombre de la condición de pago. */
  private cargarCondicionesPago(): void {
    this.api
      .get<any>('/core/formas-pago', { page: 0, size: 1000 })
      .pipe(catchError(() => of([])))
      .subscribe((resp) => {
        this.condicionesPagoMap.clear();
        this.extraerLista(resp)
          .filter((f) => f?.flagEstado !== '0')
          .forEach((f) => {
            this.condicionesPagoMap.set(String(f.id), f.nombre ?? f.codigo ?? String(f.id));
          });
        // Reaplica el nombre si ya hay una orden seleccionada
        const actual = this.OrdenesDeCompraForm?.get('condicionPago')?.value;
        if (actual) {
          this.OrdenesDeCompraForm.patchValue({ condicionPago: this.resolverNombreCondicionPago(actual) });
        }
      });
  }

  /** Devuelve el nombre de la condición de pago a partir de su código/id. */
  private resolverNombreCondicionPago(codigo: any): string {
    const clave = String(codigo ?? '').trim();
    if (!clave) return '';
    return this.condicionesPagoMap.get(clave) ?? clave;
  }

  private get empresaId(): number | null {
    const user = this.storage.getUser<{ empresaId?: number }>();
    return user?.empresaId ?? null;
  }

  /** Carga las sucursales de la empresa para resolver nombre/dirección al ver el detalle. */
  private cargarSucursales(): void {
    const empresaId = this.empresaId;
    if (!empresaId) return;
    this.api
      .get<any>(`/core/empresas/${empresaId}/sucursales`, { page: 0, size: 1000 })
      .pipe(catchError(() => of([])))
      .subscribe((resp) => {
        this.sucursalesMap.clear();
        this.extraerLista(resp).forEach((s) => {
          this.sucursalesMap.set(String(s.id), {
            nombre: s.nombre ?? s.codigo ?? String(s.id),
            direccion: s.direccion ?? '',
          });
        });
      });
  }

  /** Carga los centros de costo (GET /contabilidad/centros-costo) para mostrar el nombre en el detalle. */
  private cargarCentrosCosto(): void {
    this.api
      .get<any>('/contabilidad/centros-costo', { page: 0, size: 1000 })
      .pipe(catchError(() => of([])))
      .subscribe((resp) => {
        this.centrosCostos = this.extraerLista(resp)
          .filter((c) => c?.flagEstado !== '0')
          .map((c) => ({
            id: c.id,
            nombre: c.descCencos ?? c.nombre ?? c.centro_costo_nombre ?? c.descripcion ?? c.cencos ?? '',
          }));
        this.gridApiArticulos?.refreshCells({ force: true });
      });
  }

  /** Normaliza respuestas que pueden venir como arreglo o como página { content: [] } */
  private extraerLista(response: any): any[] {
    if (Array.isArray(response)) return response;
    if (Array.isArray(response?.content)) return response.content;
    return [];
  }

  cargarOrdenesPendientesDesdeStore(): void {
    this.aprobarServicioFacade.cargarOrdenesPendientes();
  }

   configurarLabelsPorPais() {
  if(this.pais === 'EC') {
    this.mostrarTipoCambio = false; // Ocultar tipo de cambio en Ecuador
  }
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
  }

  onGridReadyArticulos(params: GridReadyEvent) {
    this.gridApiArticulos = params.api;
  }

  onFechaRegistro(date: Date) {
    this.fechaRegistro = date;
  }

  onFechaEntrega(date: Date) {
    this.fechaEntrega = date;
  }

  onCellClicked(event: any) {
    if (!event.data) return;
    
    this.camponuevo = false;
    this.titulo = event.data.orden_servicio_numero;
    
    // Deseleccionar todas las filas
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Seleccionar la fila actual
    if (event.node) {
      event.node.setSelected(true);
    }
    
    // Establecer los datos de la orden seleccionada
    this.ordenSeleccionada = event.data;
    this.filaSeleccionada = event.data;
    
    // Cargar los datos del formulario y los artículos
    this.cargarDatosFormulario();
  }
  
  private cargarDatosFormulario() {
    if (!this.ordenSeleccionada) return;
    
    // PRIMERO: Habilitar todos los campos para poder actualizarlos
    this.enableAllFormFields();
    
    const data = this.ordenSeleccionada as any;
    
    // SEGUNDO: Llenar los campos del formulario con los datos del resumen (carga inmediata)
    this.OrdenesDeCompraForm.patchValue({
      nroordenservicio: data.orden_servicio_numero || '',
      fechaRegistro: data.orden_servicio_fecha_registro || '',
      direccionFiscal: data.orden_servicio_direccion_fiscal || '',
      direccionEntrega: data.orden_servicio_direccion_entrega || '',
      documentoproveedorinput: data.orden_servicio_numero_documento || '',
      sucursal: data.orden_servicio_sucursal || '',
      rechazadoPor: '',
      retornadoPor: '',
      emitidoPor: '',
      proveedor: data.orden_servicio_proveedor || '',
      moneda: data.orden_servicio_moneda || 'Soles',
      tipoCambio: data.orden_servicio_tipo_cambio || 1,
      condicionPago: data.orden_servicio_condicion_pago || '',
      estado: data.orden_servicio_estado || '',
    });
    
    // TERCERO: Cargar los artículos específicos de la orden seleccionada
    this.cargarArticulosDesdeOrden(this.ordenSeleccionada!);

    // CUARTO: El resumen de la lista no trae RUC, sucursal ni dirección. Se obtiene el
    // detalle completo por id y se completa el formulario (documento fiscal, sucursal,
    // dirección de entrega que proviene de la sucursal, etc.).
    this.completarDesdeDetalle(data.id);

    // QUINTO: Configurar campos según el estado
    this.configurarFormularioSegunEstado();
  }

  /** Obtiene el detalle por id y completa los campos que el resumen no trae. */
  private completarDesdeDetalle(id: any): void {
    if (id === null || id === undefined || id === '') return;
    this.ordenServicioRepo
      .obtenerOrdenServicioPorId(String(id))
      .pipe(catchError(() => of(null)))
      .subscribe((detalle) => {
        if (!detalle) return;
        const suc = (detalle as any).sucursalId
          ? this.sucursalesMap.get(String((detalle as any).sucursalId))
          : undefined;

        this.enableAllFormFields();
        this.OrdenesDeCompraForm.patchValue({
          documentoproveedorinput: detalle.orden_servicio_numero_documento || '',
          proveedor: detalle.orden_servicio_proveedor || '',
          direccionFiscal: detalle.orden_servicio_direccion_fiscal || '',
          sucursal: suc?.nombre || detalle.orden_servicio_sucursal || '',
          direccionEntrega: suc?.direccion || detalle.orden_servicio_direccion_entrega || '',
          moneda: detalle.orden_servicio_moneda || 'Soles',
          tipoCambio: detalle.orden_servicio_tipo_cambio || 1,
          condicionPago: this.resolverNombreCondicionPago(detalle.orden_servicio_condicion_pago),
          fechaRegistro: detalle.orden_servicio_fecha_registro || '',
          estado: detalle.orden_servicio_estado || '',
        });

        const articulos = (detalle.orden_servicio_articulos as any) ?? [];
        if (Array.isArray(articulos) && articulos.length) {
          this.rowDataArticulos = articulos;
          this.gridApiArticulos?.setGridOption('rowData', this.rowDataArticulos);
        }

        this.configurarFormularioSegunEstado();

        // El backend de OS no persiste la dirección fiscal: se resuelve por el RUC del proveedor.
        this.resolverDireccionFiscalDesdeProveedor(
          detalle.orden_servicio_direccion_fiscal,
          detalle.orden_servicio_numero_documento
        );
      });
  }

  /** Resuelve la dirección fiscal a partir del RUC del proveedor (relaciones comerciales). */
  private resolverDireccionFiscalDesdeProveedor(actual?: string, ruc?: string): void {
    if (actual) return;
    const nroDocumento = String(ruc ?? '').trim();
    if (!nroDocumento) return;
    this.api
      .get<any>('/core/relaciones-comerciales', { esProveedor: true, nroDocumento, page: 0, size: 20 })
      .pipe(catchError(() => of(null)))
      .subscribe((response) => {
        const lista = this.extraerLista(response);
        const proveedor = lista.find((p) => p?.flagEstado === '1') ?? lista[0];
        if (proveedor?.direccion) {
          this.OrdenesDeCompraForm.patchValue({ direccionFiscal: proveedor.direccion });
        }
      });
  }

  private enableAllFormFields() {
    this.OrdenesDeCompraForm.get('nroordenservicio')?.enable();
    this.OrdenesDeCompraForm.get('documentoproveedorinput')?.enable();
    this.OrdenesDeCompraForm.get('razonSocial')?.enable();
    this.OrdenesDeCompraForm.get('ruc')?.enable();
    this.OrdenesDeCompraForm.get('direccionFiscal')?.enable();
    this.OrdenesDeCompraForm.get('emitidoPor')?.enable();
    this.OrdenesDeCompraForm.get('estado')?.enable();
    this.OrdenesDeCompraForm.get('sucursal')?.enable();
    this.OrdenesDeCompraForm.get('direccionEntrega')?.enable();
    this.OrdenesDeCompraForm.get('moneda')?.enable();
    this.OrdenesDeCompraForm.get('tipoCambio')?.enable();
    this.OrdenesDeCompraForm.get('condicionPago')?.enable();
    this.OrdenesDeCompraForm.get('fechaRegistro')?.enable();
    this.OrdenesDeCompraForm.get('autorizadoPor')?.enable();
    this.OrdenesDeCompraForm.get('rechazadoPor')?.enable();
    this.OrdenesDeCompraForm.get('retornadoPor')?.enable();
    this.OrdenesDeCompraForm.get('proveedor')?.enable();
  }

  private cargarArticulosDesdeOrden(orden: IOrdenServicio) {
    const articulos = (orden as any).orden_servicio_articulos ?? (orden as any).articulos;
    this.rowDataArticulos = Array.isArray(articulos) ? articulos : [];
    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
    }
  }

  private configurarFormularioSegunEstado() {
    // Campos que siempre están deshabilitados
    this.OrdenesDeCompraForm.disable();
  }

  onCellClickedArticulo(event: any) {
    console.log('Artículo seleccionado:', event.data);
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    this.aplicarFiltroFechas();
  }

  /** Campo de fecha sobre el que aplica el filtro de rango. */
  private fechaFiltroField(): string {
    return 'orden_servicio_fecha_registro';
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
  public async abrirModalRechazarOrden() {
    if (!this.ordenSeleccionada) return;
    
    const detallesEjemplo: DetalleItem[] = [
      { label: 'Número de orden', value: this.ordenSeleccionada.orden_servicio_numero },
      { label: 'Proveedor', value: this.ordenSeleccionada.orden_servicio_proveedor },
      { label: 'Estado', value: this.ordenSeleccionada.orden_servicio_estado },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        widthModal: '500px',
        tituloModal: 'Rechazar orden de servicio',
        subtitulomodal: 'Detalle de la orden de servicio',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo del rechazo:',
        placeholderTextarea: 'Describe el motivo del rechazo o las observaciones para el emisor.',
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Rechazar',
        colorBotonConfirmar: 'danger',
        motivoObligatorio: true,
      }
    });

    await modal.present();
    
    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      this.aprobarServicioFacade.rechazarOrden(this.ordenSeleccionada!.orden_servicio_numero, data.motivo ?? '');
      this.limpiarSeleccion();
    }
  }
  onBtReset() {
    this.cargarOrdenesPendientesDesdeStore();
  }
  async abrirModalRetornarOrden(){
    if (!this.ordenSeleccionada) return;
    
    const detallesEjemplo: DetalleItem[] = [
      { label: 'Número de orden', value: this.ordenSeleccionada.orden_servicio_numero },
      { label: 'Proveedor', value: this.ordenSeleccionada.orden_servicio_proveedor },
      { label: 'Estado', value: this.ordenSeleccionada.orden_servicio_estado },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        widthModal: '500px',
        tituloModal: 'Retornar orden de servicio',
        subtitulomodal: 'Detalle de la orden de servicio',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo del retorno:',
        placeholderTextarea: 'Describe el motivo de por el que se retorna la orden de compra.',
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Retornar',
        colorBotonConfirmar: 'primary',
        motivoObligatorio: true,
      }
    });

    await modal.present();
    
    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      this.aprobarServicioFacade.retornarOrden(this.ordenSeleccionada!.orden_servicio_numero, data.motivo ?? '');
      this.limpiarSeleccion();
    }
  }

  async abrirModalAprobarOrden(){
    if (!this.ordenSeleccionada) return;
    
    const detallesEjemplo: DetalleItem[] = [
      { label: 'Número de orden', value: this.ordenSeleccionada.orden_servicio_numero },
      { label: 'Proveedor', value: this.ordenSeleccionada.orden_servicio_proveedor },
      { label: 'Estado', value: this.ordenSeleccionada.orden_servicio_estado },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        widthModal: '500px',
        tituloModal: 'Aprobar orden de servicio',
        subtitulomodal: 'Detalle de la orden de servicio',
        detalles: detallesEjemplo,
        mostrarTextarea: false,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Aprobar',
        colorBotonConfirmar: 'primary'
      }
    });

    await modal.present();
    
    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      this.aprobarServicioFacade.aprobarOrden(this.ordenSeleccionada!.orden_servicio_numero);
      this.limpiarSeleccion();
    }
  }

  private limpiarSeleccion() {
    this.ordenSeleccionada = null;
    this.filaSeleccionada = null;
    this.titulo = '';
    this.OrdenesDeCompraForm.reset();
    this.rowDataArticulos = [];
    if (this.gridApiArticulos) this.gridApiArticulos.setGridOption('rowData', []);
    if (this.gridApi) this.gridApi.deselectAll();
  }

  crearNuevaOrden() {
    this.ordenSeleccionada = null;
    this.filaSeleccionada = null;
    this.camponuevo = true;
    this.puedeEditarFormulario = true;
    
    // Limpiar el formulario
    this.OrdenesDeCompraForm.reset();
    
    // Limpiar la tabla de artículos
    this.rowDataArticulos = [];
    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', []);
    }
    
    // Establecer valores por defecto
    this.OrdenesDeCompraForm.patchValue({
      razonSocial: 'Restaurant.pe',
      ruc: '20123456789',
      direccionFiscal: 'Av. Principal 123, Lima',
      emitidoPor: 'Usuario Admin',
      estado: 'Pendiente',
      moneda: 'Soles',
      tipoCambio: '3.75',
      condicionPago: '1'
    });
  }

  // Método para manejar el cambio de selección en el grid
  onSelectionChanged(event: any) {
    this.filasSeleccionadas = this.gridApi.getSelectedRows();
    console.log('Filas seleccionadas:', this.filasSeleccionadas);
    if (this.filasSeleccionadas.length > 1) {
      this.inhabilitarbotones=true;
    }
    else{
      this.inhabilitarbotones=false;
    }
    console.log('Aprobar órdenes seleccionadas:', this.inhabilitarbotones);
  }

  // Método para aprobar múltiples órdenes
  async aprobarOrdenesSeleccionadas() {
     const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Aprobar órdenes de servicio',
        title: `Confirmar aprobación de orden(es)`,
        message: `Por favor, revisa los detalles antes de proceder. Una vez aprobados, no podrás <br> modificar ni deshacer esta acción.`,
        btnCancelTxt: 'Cancelar',
        btnOkTxt: 'Aprobar',
      }
    });

    await modal.present();
    
    const { data } = await modal.onWillDismiss();
    if (data == true) {
      const ids = this.filasSeleccionadas.map(o => o.orden_servicio_numero);
      this.aprobarServicioFacade.aprobarOrdenesMasivo(ids);
      this.filasSeleccionadas = [];
      if (this.gridApi) this.gridApi.deselectAll();
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
        { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Aprobado', detalleCambio: 'Registro inicial de la orden de servicio'},
        { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Rechazado', detalleCambio: 'Modificación de cantidad del servicio OS-2024-001'},
        { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Retornado', detalleCambio: 'Orden de servicio aprobada para proceso'},
        { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Aprobado', detalleCambio: 'Agregado de 3 artículos a la orden' }
      ];
  
      const modal = await this.modalController.create({
        component: ModalVerActualizacionesComponent,
        cssClass: 'promo',
        componentProps: {
          titulo: 'Historial de Actualizaciones de la Orden de Servicio',
          rowData: rowData,
          colDefs: colDefs,
          anchoModal: '700px',
        }
      });
      
      await modal.present();
    }
}
