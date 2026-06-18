import { Component, ChangeDetectorRef, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { Subject, forkJoin, of, takeUntil, firstValueFrom } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { ModalController } from '@ionic/angular';
import { ApiClientService } from 'src/app/core/infrastructure/http/api-client.service';
import { StorageService } from 'src/app/core/services/storage.service';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { AccesorioActionsCellComponent } from 'src/app/modules/activos/m-af-tabla/pages/af-o-registroactivos/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { ModalCrearServicioComponent } from 'src/app/ui/modal-crear-servicio/modal-crear-servicio.component';
import { ModalCuotasComponent } from 'src/app/ui/modal-cuotas/modal-cuotas.component';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { OrdenServicioFacade } from '../../../../application/facades/orden-servicio.facade';
import { IOrdenServicioRepository } from '../../../../domain/repositories/iorden-servicio.repository';
import { OrdenServicioEntity } from '../../../../domain/models/orden-servicio.entity';
import { OrdenServicioFeedbackEffects } from '../../../../effects/orden-servicio-feedback.effect';

// Font Awesome Icons
import { faBook, faSearch as faSearchRegular } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCalendar, faChevronsLeft, faChevronsRight, faCirclePlus, faGear, faRotateRight, faSearch as faSearchSolid, faDownload, faEdit} from '@fortawesome/pro-solid-svg-icons';
import { ToastService } from 'src/app/ui/services/toast.service';
import { GridExportService } from 'src/app/core/infrastructure/export/grid-export.service';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';

// Font Awesome Icons





@Component({
  selector: 'app-compras-operaciones-ordenes-de-servicio',
  templateUrl: './compras-operaciones-ordenes-de-servicio.component.html',
  styleUrls: ['./compras-operaciones-ordenes-de-servicio.component.scss'],
  standalone: false,
})
export class ComprasOperacionesOrdenesDeServicioComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  private readonly destroy$ = new Subject<void>();
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearchRegular;
  fasAngleDown = faAngleDown;
  fasCalendar = faCalendar;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasGear = faGear;
  fasRotateRight = faRotateRight;
  fasSearch = faSearchSolid;
  fasDownload = faDownload;
  fasEdit= faEdit;

  // Inyección del Facade y Effects
  private readonly ordenServicioFacade = inject(OrdenServicioFacade);
  private readonly ordenServicioRepo = inject(IOrdenServicioRepository);
  private readonly feedbackEffects = inject(OrdenServicioFeedbackEffects);
  private readonly api = inject(ApiClientService);
  private readonly storage = inject(StorageService);

  // Identificadores resueltos contra el backend (actores secundarios)
  private proveedorSeleccionadoId: number | null = null;
  private sucursalSeleccionadaId: number | null = null;

  // Selectores del store para UI reactiva
  readonly ordenesServicio = this.ordenServicioFacade.ordenesServicio;
  readonly isLoading = this.ordenServicioFacade.loading;
  readonly loadingObtener = this.ordenServicioFacade.loadingObtener;
  readonly loadingGuardar = this.ordenServicioFacade.loadingGuardar;
  readonly loadingEliminar = this.ordenServicioFacade.loadingEliminar;
  readonly loadingActualizar = this.ordenServicioFacade.loadingActualizar;

  //Tipo de cambio para ecuador

  pais = this.countryService.getCountryCode();
  countries= ALL_COUNTRIES
  mostrarTipoCambio: boolean = true;
  monedapais =  this.countries.find(c => c.codigo === this.pais)?.monedapais?.[0]?.simbolo || 'S/';

  titulo='OS-2024-0011';
    //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  fechaRegistro: Date = new Date();
  fechaEntrega: Date | undefined;
  habilitarseccion: any = null;
  camponuevo = true;
  estadoSeleccionado: string = 'todos';
  filaSeleccionada:any = null;
  ordenSeleccionada: OrdenServicioEntity | null = null;
  puedeEditarFormulario: boolean = false;
  mostrartabla=true;
  botoncuotas='Editar';
  mostrarCamposDeshabilitados: boolean = false;
  private gridApi!: GridApi;
  private gridApiArticulos!: GridApi;
  OrdenesDeServicioForm!: FormGroup;
  subTotal: number = 0.00;
  impuestos: number = 0.00;
  totalGeneral: number = 0.00;

  /** Centros de costo cargados desde /contabilidad/centros-costo (solo nombre visible). */
  centrosCostos: { id: any; nombre: string }[] = [];
  
  colDefs: ColDef[] = [
    { field: 'orden_servicio_numero', headerName: 'Nº órd. com.', flex: 1, minWidth: 75, filter: true },
    { field: 'orden_servicio_fecha_registro', headerName: 'Fecha registro', flex: 1, minWidth: 70,
      valueFormatter: (params) => {
        if (params.value) {
          const date = new Date(params.value + 'T00:00:00');
          return date.toLocaleDateString('es-PE');
        }
        return '';
      }
     },
    { field: 'orden_servicio_proveedor', headerName: 'Proveedor', flex: 2, minWidth: 14, filter: true },
    { field: 'orden_servicio_sucursal', headerName: 'Sucursal', flex: 1, minWidth: 113, filter:true },
    { field: 'orden_servicio_moneda', headerName: 'Moneda', flex: 0.8, minWidth: 50,
      valueFormatter: (params) => {
        if (params.value === 'dolares') return 'Dólares';
        if (params.value === 'soles') return 'Soles';
        return params.value;
      },
     },
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
            badgeClass = 'bg-[#FFDECC] text-[#FF8947]';
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

  rowData: OrdenServicioEntity[] = [];
  /** Tipo de fecha del filtro de rango: 'registro' | 'entrega'. */
  tipoFechaFiltro: string = 'registro';
  /** Fuente completa de órdenes (sin filtrar por fecha). */
  private ordenesFuente: OrdenServicioEntity[] = [];

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
    { 
      field: 'det_orden_servicio_cantidad', 
      headerName: 'Cantidad', 
      flex: 0.7, 
      minWidth: 70, 
      editable: true,
      headerClass: 'derechaencabezado', 
      cellStyle: { cursor: 'pointer', display: 'flex', justifyContent: 'right' }
    },
    { field: 'det_orden_servicio_descripcion', headerName: 'Descripción', flex: 2, minWidth: 150 },
    {
      field: 'centrocostos',
      headerName: 'Centro de costo',
      flex: 1.4,
      minWidth: 170,
      editable: () => this.puedeEditarFormulario,
      cellStyle: { cursor: 'pointer' },
      cellEditor: 'agRichSelectCellEditor',
      cellEditorParams: () => ({ values: this.centrosCostos.map((c) => c.nombre) }),
      valueGetter: (params) => {
        const id = params.data?.centrocostos;
        const cc = this.centrosCostos.find((c) => String(c.id) === String(id));
        return cc ? cc.nombre : '';
      },
      valueSetter: (params) => {
        const cc = this.centrosCostos.find((c) => c.nombre === params.newValue);
        params.data.centrocostos = cc ? String(cc.id) : '';
        return true;
      }
    },
    { 
      field: 'det_orden_servicio_precio_unitario', 
      headerName: 'Precio unitario', 
      flex: 0.9, 
      minWidth: 85, 
      editable: true,
      headerClass: 'derechaencabezado', 
      cellStyle: { cursor: 'pointer', display: 'flex', justifyContent: 'right' }, 
      valueFormatter: (params) => {
        return params.value ? `${this.monedapais} ${new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value)}` : `${this.monedapais} 0.00`;
      }
    },
    { 
      field: 'det_orden_servicio_subtotal', 
      headerName: 'Subtotal', 
      flex: 0.9,
      headerClass: 'derechaencabezado', 
      cellStyle: { cursor: 'pointer', display: 'flex', justifyContent: 'right' }, 
      minWidth: 85, 
      valueFormatter: (params) => {
        return params.value ? `${this.monedapais} ${new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value)}` : `${this.monedapais} 0.00`;
      }
    },
    { 
      field: 'det_orden_servicio_impuestos', 
      headerName: 'Impuestos', 
      flex: 0.9,
      headerClass: 'derechaencabezado', 
      cellStyle: { cursor: 'pointer', display: 'flex', justifyContent: 'right' }, 
      minWidth: 85, 
      valueFormatter: (params) => {
        return params.value ? `${this.monedapais} ${new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value)}` : `${this.monedapais} 0.00`;
      }
    },
    { 
      field: 'det_orden_servicio_total', 
      headerName: 'Total', 
      flex: 0.9, 
      minWidth: 85,
      headerClass: 'derechaencabezado', 
      cellStyle: { cursor: 'pointer', display: 'flex', justifyContent: 'right' }, 
      valueFormatter: (params) => {
        return params.value ? `${this.monedapais} ${new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value)}` : `${this.monedapais} 0.00`;
      }
    },
    { 
      headerName: 'Acciones', 
      headerClass: 'centrarencabezado',
      width: 80,
      cellRenderer: AccesorioActionsCellComponent,
      cellRendererParams: {
        context: {
          componentParent: this
        }
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  rowDataArticulos: any[] = [];

  // Catálogos cargados desde el backend (actores secundarios)
  proveedores: Array<{ id: string; doc: string; nombre: string; direccion: string }> = [];
  sucursales: Array<{ id: string; nombre: string; direccion: string }> = [];
  condicionesPago: Array<{ codigo: string; nombre: string }> = [];
  productos: Array<{ id: number; codigo: string; descripcion: string; precioUnitario: number; tipoImpuestoId: number | null }> = [];

  private readonly gridExport = inject(GridExportService);

  private readonly columnasExport = [
    { header: 'Nº Orden de servicio', field: 'orden_servicio_numero' },
    { header: 'Fecha registro', field: 'orden_servicio_fecha_registro' },
    { header: 'Proveedor', field: 'orden_servicio_proveedor' },
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
      `ordenes-servicio-${this.gridExport.fechaHoy()}`,
      this.columnasExport,
      filas,
      'Órdenes de servicio',
    );
  }

  async exportarPdf(): Promise<void> {
    const filas = this.gridExport.obtenerFilas(this.gridApi, this.rowData) as Array<Record<string, unknown>>;
    if (!filas.length) {
      this.toastService.warning('No hay órdenes para exportar');
      return;
    }
    await this.gridExport.exportarPdf(
      'Órdenes de servicio',
      `ordenes-servicio-${this.gridExport.fechaHoy()}`,
      this.columnasExport,
      filas,
    );
  }

  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private formValidationService: FormValidationService,
    private countryService: CountryService,
    private simulation: SimulationService,
    private toastService: ToastService,
    private cdr: ChangeDetectorRef
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Effect para actualizar la tabla cuando cambian los datos del store
    effect(() => {
      const ordenes = this.ordenesServicio();
      this.ordenesFuente = ordenes;
      this.aplicarFiltroFechas();
    });
  }

  ngOnInit() {
    this.OrdenesDeServicioForm = this.formBuilder.group({
      nroordeservicio: [''],
      documentoproveedor: ['RUC'],
      documentoproveedorinput: [''],
      razonSocial: [''],
      ruc: [''],
      proveedor: [''],
      direccionFiscal: [''],
      emitidoPor: ['Usuario Admin'],
      estado: ['Pendiente'],
      sucursal: [''],
      fechaEntrega: [''],
      direccionEntrega: [''],
      moneda: [''],
      tipoCambio: [''],
      condicionPago: [''],
      fechaRegistro: [this.fechaHoyISO()],
      aprobadaPor:[''],
      rechazadaPor:[''],
      retornadoPor:[''],
    });
    this.OrdenesDeServicioForm.get('nroordeservicio')?.disable();
    this.OrdenesDeServicioForm.get('fechaRegistro')?.disable();
    this.OrdenesDeServicioForm.get('ruc')?.disable();
    this.OrdenesDeServicioForm.get('direccionFiscal')?.disable();
    this.OrdenesDeServicioForm.get('emitidoPor')?.disable();
    this.OrdenesDeServicioForm.get('estado')?.disable();
    this.OrdenesDeServicioForm.get('tipoCambio')?.disable();
    
    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.OrdenesDeServicioForm);
    this.formValidationService.resetearEstado();

    //Labels de formulario: Tipo de cambio por ahora
    this.configurarLabelsPorPais();

    // Suscribirse a cambios en el campo moneda para actualizar tipo de cambio automáticamente
    // Solo se dispara cuando el USUARIO cambia el campo (no al cargar datos con emitEvent:false)
    this.OrdenesDeServicioForm.get('moneda')?.valueChanges
      .pipe(takeUntil(this.destroy$))
      .subscribe(moneda => {
        if (moneda) {
          this.actualizarTipoCambio(moneda);
        }
      });

    // Cargar órdenes de servicio desde el store
    this.cargarOrdenesServicioDesdeStore();

    // Cargar catálogos (actores secundarios) desde el backend
    this.cargarCatalogos();

    // Centros de costo desde el backend
    this.cargarCentrosCosto();
  }

  /** Identificador de la empresa en sesión */
  private get empresaId(): number | null {
    const user = this.storage.getUser<{ empresaId?: number }>();
    return user?.empresaId ?? null;
  }

  /**
   * Carga los catálogos necesarios para generar una orden de servicio:
   * sucursales, formas de pago (condición de pago) y servicios.
   */
  private cargarCatalogos(): void {
    const empresaId = this.empresaId;
    const sucursales$ = empresaId
      ? this.api
          .get<any>(`/core/empresas/${empresaId}/sucursales`, { page: 0, size: 1000 })
          .pipe(catchError(() => of([])))
      : of([]);

    forkJoin({
      sucursales: sucursales$,
      formasPago: this.api.get<any>('/core/formas-pago', { page: 0, size: 1000 }).pipe(catchError(() => of([]))),
      servicios: this.api
        .get<any>('/compras/maestros/servicios-catalogo', { page: 0, size: 1000 })
        .pipe(catchError(() => of([]))),
    }).subscribe(({ sucursales, formasPago, servicios }) => {
      this.sucursales = this.extraerLista(sucursales)
        .filter((s) => s?.flagEstado !== '0')
        .map((s) => ({ id: String(s.id), nombre: s.nombre ?? s.codigo ?? String(s.id), direccion: s.direccion ?? '' }));

      this.condicionesPago = this.extraerLista(formasPago)
        .filter((f) => f?.flagEstado !== '0')
        .map((f) => ({ codigo: String(f.id), nombre: f.nombre ?? f.codigo ?? String(f.id) }));

      this.productos = this.extraerLista(servicios)
        .filter((sv) => sv?.flagEstado !== '0')
        .map((sv) => ({
          id: Number(sv.id),
          codigo: sv.servicio ?? String(sv.id),
          descripcion: sv.descripcion ?? sv.servicio ?? '',
          precioUnitario: Number(sv.tarifaEstd ?? 0),
          tipoImpuestoId: sv.tipoImpuestoDefaultId ?? null,
        }));

      this.cdr.markForCheck();
    });
  }

  /** Normaliza respuestas que pueden venir como arreglo o como página { content: [] } */
  private extraerLista(response: any): any[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response.content;
    }
    return [];
  }

  ngOnDestroy() {
    this.destroy$.next();
    this.destroy$.complete();
    // Limpiar el tracking del formulario al destruir el componente
    this.formValidationService.limpiarFormulario();
  }

  async canDeactivate(): Promise<boolean> {
    // Validar si hay cambios sin guardar antes de permitir la navegación
    return await this.formValidationService.canDeactivate();
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

  /**
   * Cargar órdenes de servicio desde el store
   */
  cargarOrdenesServicioDesdeStore(): void {
    this.ordenServicioFacade.cargarOrdenesServicio();
  }

  onGridReadyArticulos(params: GridReadyEvent) {
    this.gridApiArticulos = params.api;
    
    // Agregar listener para cuando termina la edición
    this.gridApiArticulos.addEventListener('cellEditingStopped', (event: any) => {
      console.log('Edición detenida');
      console.log('Campo:', event.colDef?.field);
      console.log('Valor anterior:', event.oldValue);
      console.log('Valor nuevo:', event.newValue);
      
      // Esperar a que AG-Grid actualice el dato
      setTimeout(() => {
        this.onCellValueChanged(event);
      }, 50);
    });

    // Agregar listener alternativo para cambios de valor
    this.gridApiArticulos.addEventListener('cellValueChanged', (event: any) => {
      console.log('Valor cambiado');
      this.onCellValueChanged(event);
    });
  }

  onFechaRegistro(date: Date) {
    this.fechaRegistro = date;
  }
  /** Carga los centros de costo desde el backend (GET /contabilidad/centros-costo). */
  private cargarCentrosCosto() {
    this.api.get<any>('/contabilidad/centros-costo', { page: 0, size: 1000 }).subscribe({
      next: (response) => {
        const lista = Array.isArray(response)
          ? response
          : Array.isArray(response?.content)
            ? response.content
            : Array.isArray(response?.data?.content)
              ? response.data.content
              : Array.isArray(response?.data)
                ? response.data
                : [];
        this.centrosCostos = lista
          .filter((c: any) => c?.flagEstado !== '0' && c?.activo !== false)
          .map((c: any) => {
            const nombre = c.descCencos ?? c.nombre ?? c.centro_costo_nombre ?? c.descripcion ?? c.cencos ?? '';
            return { id: c.id, nombre: String(nombre) || String(c.id) };
          });
      },
      error: (err) => {
        console.error('Error cargando centros de costo:', err);
        this.centrosCostos = [];
      },
    });
  }

  onFechaEntrega(date: Date) {
    this.fechaEntrega = date;
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
      if (this.ordenSeleccionada && this.gridApi) {
        setTimeout(() => {
          this.gridApi.forEachNode((node) => {
            if (node.data === this.ordenSeleccionada) {
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
    
    this.camponuevo = false;
    this.titulo = data.orden_servicio_numero;
    this.ordenSeleccionada = event.data;
    this.filaSeleccionada = event.data; // Asegura que filaSeleccionada se asigne correctamente
    this.habilitarseccion = this.ordenSeleccionada?.orden_servicio_estado;
    if (!this.ordenSeleccionada) return;

    // La lista solo trae el resumen (para evitar N+1). Se carga el detalle
    // completo (líneas, RUC, direcciones, etc.) bajo demanda al seleccionar.
    const ordenId = (this.ordenSeleccionada as any)['id'];
    if (ordenId != null) {
      try {
        const detalle = await firstValueFrom(
          this.ordenServicioRepo.obtenerOrdenServicioPorId(String(ordenId))
        );
        if (detalle) {
          // Se fusiona en la misma referencia para conservar la selección del grid.
          Object.assign(this.ordenSeleccionada, detalle);
        }
      } catch {
        // Si falla, se continúa con los datos del resumen disponibles.
      }
    }

    // Recuperar identificadores resueltos desde el backend para la edición
    this.proveedorSeleccionadoId = Number(this.ordenSeleccionada['proveedorId']) || null;
    this.sucursalSeleccionadaId = Number(this.ordenSeleccionada['sucursalId']) || null;
    
    // Convertir fecha de entrega de string a Date — soporta YYYY-MM-DD y DD/MM/YYYY
    if (this.ordenSeleccionada.orden_servicio_fecha_entrega) {
      try {
        const raw = this.ordenSeleccionada.orden_servicio_fecha_entrega as string;
        let fechaDate: Date;
        if (/^\d{4}-\d{2}-\d{2}$/.test(raw)) {
          const [anio, mes, dia] = raw.split('-');
          fechaDate = new Date(+anio, +mes - 1, +dia);
        } else {
          const [dia, mes, anio] = raw.split('/');
          fechaDate = new Date(+anio, +mes - 1, +dia);
        }
        this.fechaEntrega = fechaDate;
      } catch {
        this.fechaEntrega = undefined;
      }
    } else {
      this.fechaEntrega = undefined;
    }

    // Formatear fecha de entrega según estado
    // Pendiente/Retornada → d/M/YYYY (es-PE) para el calendario
    // Aprobada/Rechazada  → YYYY-MM-DD para ion-input type="date"
    const estadoOrden = this.ordenSeleccionada.orden_servicio_estado;
    const fechaEntregaRaw = this.ordenSeleccionada.orden_servicio_fecha_entrega as string;
    let fechaEntregaFormateada = fechaEntregaRaw || '';
    if (fechaEntregaRaw) {
      let fechaObj: Date;
      if (/^\d{4}-\d{2}-\d{2}$/.test(fechaEntregaRaw)) {
        const [a, m, d] = fechaEntregaRaw.split('-');
        fechaObj = new Date(+a, +m - 1, +d);
      } else {
        const [d, m, a] = fechaEntregaRaw.split('/');
        fechaObj = new Date(+a, +m - 1, +d);
      }
      if (estadoOrden === 'Pendiente' || estadoOrden === 'Retornada') {
        fechaEntregaFormateada = fechaObj.toLocaleDateString('es-PE');
      } else {
        fechaEntregaFormateada = fechaEntregaRaw;
      }
    }
    
      // Llenar los campos del formulario con los datos de la fila
      this.OrdenesDeServicioForm.patchValue({
        nroordeservicio: this.ordenSeleccionada.orden_servicio_numero || '',
        documentoproveedor: this.ordenSeleccionada.orden_servicio_tipo_documento || 'RUC',
        documentoproveedorinput: this.ordenSeleccionada.orden_servicio_numero_documento || '',
        proveedor: this.ordenSeleccionada.orden_servicio_proveedor || 'A',
        aprobadaPor: this.ordenSeleccionada.orden_servicio_estado === 'Aprobada' ? 'Usuario Gerente' : '',
        rechazadaPor: this.ordenSeleccionada.orden_servicio_estado === 'Rechazada' ? 'Usuario Admin' : '',
        retornadoPor: this.ordenSeleccionada.orden_servicio_estado === 'Retornada' ? 'Usuario Supervisor' : '',
        sucursal: this.ordenSeleccionada.orden_servicio_sucursal || '',
        direccionFiscal: this.ordenSeleccionada.orden_servicio_direccion_fiscal || '',
        fechaRegistro: this.aInputDate(this.ordenSeleccionada.orden_servicio_fecha_registro) || this.fechaHoyISO(),
        fechaEntrega: fechaEntregaFormateada,
        direccionEntrega: this.ordenSeleccionada.orden_servicio_direccion_entrega || '',
        moneda: this.ordenSeleccionada.orden_servicio_moneda || 'Soles',
        tipoCambio: this.ordenSeleccionada.orden_servicio_tipo_cambio || '3.75',
        condicionPago: this.ordenSeleccionada.orden_servicio_condicion_pago || '',
        estado: this.ordenSeleccionada.orden_servicio_estado || ''
      });

      // La dirección fiscal no la persiste el backend de OS: se resuelve por el RUC del proveedor.
      this.resolverDireccionFiscalDesdeProveedor();

      // Cargar artículos reales desde la orden
      this.rowDataArticulos = (this.ordenSeleccionada.orden_servicio_articulos as any[]) || [];
      if (this.gridApiArticulos) {
        this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
      }
      
      // Actualizar totales con los artículos cargados
      this.actualizarTotales();
      
      // Configurar campos según el estado
      this.configurarFormularioSegunEstado(this.ordenSeleccionada.orden_servicio_estado);
      
      // Resetear servicio de validación después de cargar datos
      this.formValidationService.resetearEstado();
  }

  private configurarFormularioSegunEstado(estado: string) {
    // Si es Aprobada o Rechazada, mostrar campos deshabilitados
    if (estado === 'Aprobada' || estado === 'Rechazada') {
      this.mostrarCamposDeshabilitados = true;
      this.puedeEditarFormulario = false;
      // Deshabilitar todos los campos
      Object.keys(this.OrdenesDeServicioForm.controls).forEach(key => {
        this.OrdenesDeServicioForm.get(key)?.disable();
      });
    } else {
      // Si es Pendiente o Retornada, mostrar componentes normales
      this.mostrarCamposDeshabilitados = false;
      this.puedeEditarFormulario = true;
      
      // Habilitar campos editables
      this.OrdenesDeServicioForm.get('sucursal')?.enable();
      this.OrdenesDeServicioForm.get('direccionEntrega')?.enable();
      this.OrdenesDeServicioForm.get('moneda')?.enable();
      this.OrdenesDeServicioForm.get('condicionPago')?.enable();
      this.OrdenesDeServicioForm.get('documentoproveedor')?.enable();
      this.OrdenesDeServicioForm.get('documentoproveedorinput')?.enable();
      // Deshabilitar campos que siempre están deshabilitados
      this.OrdenesDeServicioForm.get('proveedor')?.disable();
      this.OrdenesDeServicioForm.get('nroordeservicio')?.disable();
      this.OrdenesDeServicioForm.get('razonSocial')?.disable();
      this.OrdenesDeServicioForm.get('ruc')?.disable();
      this.OrdenesDeServicioForm.get('direccionFiscal')?.disable();
      this.OrdenesDeServicioForm.get('fechaRegistro')?.disable();
      this.OrdenesDeServicioForm.get('emitidoPor')?.disable();
      this.OrdenesDeServicioForm.get('tipoCambio')?.disable();
      this.OrdenesDeServicioForm.get('estado')?.disable();
    }
  }

  onCellClickedArticulo(event: any) {
    console.log('Artículo seleccionado:', event.data);
    // Actualizar totales en caso de que se haya editado algún valor
    setTimeout(() => {
      this.actualizarTotales();
    }, 100);
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    this.aplicarFiltroFechas();
  }
  onBtReset() {
    this.ordenServicioFacade.cargarOrdenesServicio();
  }

  /** Campo de fecha sobre el que aplica el filtro de rango, según el select. */
  private fechaFiltroField(): string {
    return this.tipoFechaFiltro === 'entrega'
      ? 'orden_servicio_fecha_entrega'
      : 'orden_servicio_fecha_registro';
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
      { label: 'Número de orden:', value: this.ordenSeleccionada.orden_servicio_numero },
      { label: 'Proveedor:', value: this.ordenSeleccionada.orden_servicio_proveedor },
      { label: 'Estado:', value: this.ordenSeleccionada.orden_servicio_estado },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Rechazar orden de servicio',
        subtitulomodal: 'Detalle de la orden de servicio',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo del rechazo:',
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

  async abrirModalRetornarOrden(){
    if (!this.ordenSeleccionada) return;
    
    const detallesEjemplo: DetalleItem[] = [
      { label: 'Número de orden:', value: this.ordenSeleccionada.orden_servicio_numero },
      { label: 'Proveedor:', value: this.ordenSeleccionada.orden_servicio_proveedor },
      { label: 'Estado:', value: this.ordenSeleccionada.orden_servicio_estado },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Devolver orden de servicio',
        subtitulomodal: 'Detalle de la orden de servicio',
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
      this.actualizarEstadoOrden('Retornada');
    }
  }

  async abrirModalAprobarOrden(){
    if (!this.ordenSeleccionada) return;
    
    const detallesEjemplo: DetalleItem[] = [
      { label: 'Número de orden:', value: this.ordenSeleccionada.orden_servicio_numero },
      { label: 'Proveedor:', value: this.ordenSeleccionada.orden_servicio_proveedor },
      { label: 'Estado:', value: this.ordenSeleccionada.orden_servicio_estado },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
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
      this.actualizarEstadoOrden('Aprobada');
    }
  }

  private actualizarEstadoOrden(nuevoEstado: string) {
    if (!this.ordenSeleccionada) return;

    // Actualizar el estado en el array rowData
    const index = this.rowData.findIndex(orden => orden.orden_servicio_numero === this.ordenSeleccionada!.orden_servicio_numero);
    if (index !== -1) {
      (this.rowData[index] as any).orden_servicio_estado = nuevoEstado;
      this.ordenSeleccionada.orden_servicio_estado = nuevoEstado;
      
      // Actualizar el formulario
      this.OrdenesDeServicioForm.patchValue({ estado: nuevoEstado });
      
      // Refrescar la tabla
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }
      
      console.log(`Orden ${this.ordenSeleccionada.orden_servicio_numero} actualizada a estado: ${nuevoEstado}`);
    }
  }

  async crearNuevaOrden() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    this.ordenSeleccionada = null;
    this.filaSeleccionada = null;
    this.camponuevo = true;
    this.puedeEditarFormulario = true;
    this.mostrarCamposDeshabilitados = false;
    this.titulo = '';
    this.proveedorSeleccionadoId = null;
    this.sucursalSeleccionadaId = null;
    
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    // Limpiar la tabla de artículos
    this.rowDataArticulos = [];
    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
    }
    
    // Actualizar totales a 0
    this.actualizarTotales();
    
    // Limpiar el formulario
    this.OrdenesDeServicioForm.reset(
      {
        fechaRegistro: this.fechaHoyISO(),
        estado: 'Pendiente',
        moneda: 'Soles',
        tipoCambio: '3.75',
      }
    );
    
    
    // Deshabilitar campos fijos
    this.OrdenesDeServicioForm.get('razonSocial')?.disable();
    this.OrdenesDeServicioForm.get('ruc')?.disable();
    this.OrdenesDeServicioForm.get('direccionFiscal')?.disable();
    this.OrdenesDeServicioForm.get('emitidoPor')?.disable();
    this.OrdenesDeServicioForm.get('estado')?.disable();
    this.OrdenesDeServicioForm.get('fechaRegistro')?.disable();
    this.OrdenesDeServicioForm.get('tipoCambio')?.disable();
    this.OrdenesDeServicioForm.get('fechaRegistro')?.disable();
    
    // Habilitar campos editables  
    this.OrdenesDeServicioForm.get('documentoproveedorinput')?.enable();
    this.OrdenesDeServicioForm.get('autorizadoPor')?.enable();
    this.OrdenesDeServicioForm.get('rechazadaPor')?.enable();
    this.OrdenesDeServicioForm.get('retornadoPor')?.enable();
    this.OrdenesDeServicioForm.get('proveedor')?.enable();
    this.OrdenesDeServicioForm.get('moneda')?.enable();
    this.OrdenesDeServicioForm.get('condicionPago')?.enable();
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  onProveedorSeleccionado(proveedor: any) {
    console.log('Proveedor seleccionado:', proveedor);
    // Aquí puedes agregar lógica adicional cuando se selecciona un proveedor
  }

  onSucursalSeleccionada(sucursal: any) {
    console.log('Sucursal seleccionada:', sucursal);
    this.sucursalSeleccionadaId = Number(sucursal?.id) || null;
    this.OrdenesDeServicioForm.patchValue({
      sucursal: sucursal.id,
      direccionEntrega: sucursal.direccion
    });
  }

  onProductoSeleccionado(producto: any) {
    console.log('Producto/Servicio seleccionado:', producto);

    // Verificar si el servicio ya existe en la tabla
    const productoExistente = this.rowDataArticulos.find(
      item => item.det_orden_servicio_codigo === producto.codigo
    );
    if (productoExistente) {
      console.log('El servicio ya está agregado a la orden');
      return;
    }

    // Cantidad por defecto
    const cantidad = 1;
    const precioUnitario = Number(producto.precioUnitario) || 0;
    const subtotal = cantidad * precioUnitario;
    const impuestos = Number((subtotal * 0.18).toFixed(2)); // IGV 18%
    const total = subtotal + impuestos;

    // Crear nueva línea de servicio para la tabla (modelo det_orden_servicio_*)
    const nuevoArticulo: any = {
      servicioId: producto.id ?? null,
      tipoImpuestoId: producto.tipoImpuestoId ?? null,
      centrocostos: '',
      det_orden_servicio_codigo: producto.codigo,
      det_orden_servicio_cantidad: cantidad,
      det_orden_servicio_descripcion: producto.descripcion,
      det_orden_servicio_precio_unitario: precioUnitario,
      det_orden_servicio_subtotal: subtotal,
      det_orden_servicio_impuestos: impuestos,
      det_orden_servicio_total: total,
    };

    // Agregar la línea a la tabla
    this.rowDataArticulos = [...this.rowDataArticulos, nuevoArticulo];

    // Actualizar la tabla
    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
    }

    // Actualizar totales
    this.actualizarTotales();

    console.log('Servicio agregado a la orden');
  }

  private actualizarTotales() {
    // Recalcular cada línea si tiene cantidad y precio
    this.rowDataArticulos.forEach(articulo => {
      const cantidadNum = parseFloat(String(articulo.det_orden_servicio_cantidad)) || 0;
      const precioNum = parseFloat(String(articulo.det_orden_servicio_precio_unitario)) || 0;
      if (cantidadNum && precioNum) {
        articulo.det_orden_servicio_subtotal = Number((cantidadNum * precioNum).toFixed(2));
        articulo.det_orden_servicio_impuestos = Number((articulo.det_orden_servicio_subtotal * 0.18).toFixed(2));
        articulo.det_orden_servicio_total = Number(
          (articulo.det_orden_servicio_subtotal + articulo.det_orden_servicio_impuestos).toFixed(2)
        );
      }
    });

    // Calcular los totales generales
    const subtotalGeneral = this.rowDataArticulos.reduce((sum, item) => sum + (item.det_orden_servicio_subtotal || 0), 0);
    const impuestosGeneral = this.rowDataArticulos.reduce((sum, item) => sum + (item.det_orden_servicio_impuestos || 0), 0);
    const totalGeneral = this.rowDataArticulos.reduce((sum, item) => sum + (item.det_orden_servicio_total || 0), 0);
    
    // Asignar a las propiedades para que se muestren en la vista
    this.subTotal = Number(subtotalGeneral.toFixed(2));
    this.impuestos = Number(impuestosGeneral.toFixed(2));
    this.totalGeneral = Number(totalGeneral.toFixed(2));
    
    // Forzar detección de cambios
    this.cdr.markForCheck();
    
    console.log('Totales actualizados:', {
      subTotal: this.subTotal,
      impuestos: this.impuestos,
      totalGeneral: this.totalGeneral
    });
  }

  /**
   * Manejador para cambios en las celdas editables de la tabla
   * Recalcula subtotal, impuestos y total cuando se modifican cantidad o precio
   */
  onCellValueChanged(event: any) {
    try {
      const articulo = event.data as any;
      if (!articulo) {
        console.warn('Sin datos');
        return;
      }

      const campo = event.colDef?.field;
      console.log(`Campo modificado: ${campo}`);

      // Si cambió cantidad o precio unitario, recalcular
      if (campo === 'det_orden_servicio_cantidad' || campo === 'det_orden_servicio_precio_unitario') {
        // Convertir a números garantizadamente
        const cantidadNum = parseFloat(String(articulo.det_orden_servicio_cantidad)) || 0;
        const precioNum = parseFloat(String(articulo.det_orden_servicio_precio_unitario)) || 0;

        articulo.det_orden_servicio_cantidad = cantidadNum;
        articulo.det_orden_servicio_precio_unitario = precioNum;

        // Calcular valores
        articulo.det_orden_servicio_subtotal = Number((cantidadNum * precioNum).toFixed(2));
        articulo.det_orden_servicio_impuestos = Number((articulo.det_orden_servicio_subtotal * 0.18).toFixed(2));
        articulo.det_orden_servicio_total = Number(
          (articulo.det_orden_servicio_subtotal + articulo.det_orden_servicio_impuestos).toFixed(2)
        );

        // Actualizar la fila en la tabla
        if (this.gridApiArticulos) {
          const index = this.rowDataArticulos.findIndex(
            item => item.det_orden_servicio_codigo === articulo.det_orden_servicio_codigo
          );
          if (index !== -1) {
            this.rowDataArticulos[index] = articulo;
          }
          this.gridApiArticulos.applyTransaction({ update: [articulo] });
        }
      }

      // Actualizar totales generales
      this.actualizarTotales();
    } catch (error) {
      console.error('Error:', error);
    }
  }

  eliminarAccesorio(articulo: any) {
    console.log('Eliminar línea:', articulo);

    // Filtrar la línea a eliminar
    this.rowDataArticulos = this.rowDataArticulos.filter(
      item => item.det_orden_servicio_codigo !== articulo.det_orden_servicio_codigo
    );
    
    // Actualizar la tabla
    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
    }
    
    // Actualizar totales
    this.actualizarTotales();
    
    console.log('Producto eliminado de la orden');
  }

  // Función para guardar y editar ordenes de servicio
  botonGuardar() {
    // Validar que el formulario esté completo antes de proceder
    if (this.OrdenesDeServicioForm.invalid) {
      this.toastService.warning('¡Por favor, completa todos los campos requeridos!');
      // Marcar todos los campos como touched para mostrar los errores
      Object.keys(this.OrdenesDeServicioForm.controls).forEach(key => {
        this.OrdenesDeServicioForm.get(key)?.markAsTouched();
      });
      return;
    }

    // Validar que haya al menos un artículo en la orden
    if (this.rowDataArticulos.length === 0) {
      this.toastService.warning('¡Por favor, agrega al menos un artículo a la orden!');
      return;
    }

    const formValues = this.OrdenesDeServicioForm.getRawValue();
    
    // Generar número de orden automático para nuevas operaciones
    const nroOrden = this.camponuevo ? this.generarNuevaOrden() : (this.ordenSeleccionada?.orden_servicio_numero || this.generarNuevaOrden());
    
    // Calcular totales de artículos
    const totales = this.calcularTotalesOrden(this.rowDataArticulos);
    
    // Resolver identificadores de los actores secundarios
    const sucursalId =
      this.sucursalSeleccionadaId ??
      (Number(formValues.sucursal) > 0 ? Number(formValues.sucursal) : null);
    const formaPagoId = Number(formValues.condicionPago) > 0 ? Number(formValues.condicionPago) : null;

    // Validaciones de integridad antes de enviar al backend
    if (!this.proveedorSeleccionadoId) {
      this.toastService.warning('¡Busca y selecciona un proveedor válido antes de guardar!');
      return;
    }
    if (!sucursalId) {
      this.toastService.warning('¡Selecciona una sucursal válida antes de guardar!');
      return;
    }
    const lineasSinServicio = this.rowDataArticulos.some(a => !a.servicioId);
    if (lineasSinServicio) {
      this.toastService.warning('¡Hay servicios sin identificar. Selecciónalos desde el catálogo!');
      return;
    }

    // La fecha de entrega no puede ser anterior a la de registro/emisión
    const emisionISO = this.normalizarFechaIso(formValues.fechaRegistro);
    const entregaISO = this.normalizarFechaIso(formValues.fechaEntrega);
    if (entregaISO && emisionISO && entregaISO < emisionISO) {
      this.toastService.warning('La fecha de entrega no puede ser anterior a la fecha de registro.');
      return;
    }

    // Crear objeto con los datos de la orden (entidad de dominio enriquecida con ids)
    const ordenData: OrdenServicioEntity = {
      ...(this.ordenSeleccionada ?? {}),
      proveedorId: this.proveedorSeleccionadoId,
      sucursalId,
      formaPagoId,
      orden_servicio_numero: this.camponuevo ? '' : (this.ordenSeleccionada?.orden_servicio_numero || ''),
      orden_servicio_fecha_registro: this.normalizarFechaIso(formValues.fechaRegistro),
      orden_servicio_fecha_entrega: this.normalizarFechaIso(formValues.fechaEntrega),
      orden_servicio_proveedor: formValues.proveedor,
      orden_servicio_tipo_documento: formValues.documentoproveedor,
      orden_servicio_numero_documento: formValues.documentoproveedorinput,
      orden_servicio_direccion_fiscal: formValues.direccionFiscal,
      orden_servicio_direccion_entrega: formValues.direccionEntrega,
      orden_servicio_sucursal: formValues.sucursal,
      orden_servicio_moneda: formValues.moneda,
      orden_servicio_tipo_cambio: formValues.tipoCambio,
      orden_servicio_condicion_pago: formValues.condicionPago,
      orden_servicio_total: totales.total,
      orden_servicio_estado: formValues.estado,
      orden_servicio_articulos: this.rowDataArticulos as any
    } as any;

    // Persistir contra el backend a través del facade
    if (!this.camponuevo && this.ordenSeleccionada?.['id']) {
      this.ordenServicioFacade.actualizarOrdenServicio(ordenData);
      this.toastService.success('¡Orden de servicio actualizada exitosamente!');
    } else {
      this.ordenServicioFacade.guardarOrdenServicio(ordenData);
      this.toastService.success('¡Orden de servicio registrada exitosamente!');
    }

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
    // Limpiar formulario y volver a crear nueva orden
    this.crearNuevaOrden();
  }

  /** Convierte fechas en formato d/M/YYYY o YYYY-MM-DD a ISO YYYY-MM-DD */
  private normalizarFechaIso(value: string | undefined | null): string {
    if (!value) {
      return '';
    }
    const raw = String(value).trim();
    if (/^\d{4}-\d{2}-\d{2}/.test(raw)) {
      return raw.slice(0, 10);
    }
    const match = raw.match(/^(\d{1,2})\/(\d{1,2})\/(\d{4})$/);
    if (match) {
      const [, dia, mes, anio] = match;
      return `${anio}-${mes.padStart(2, '0')}-${dia.padStart(2, '0')}`;
    }
    return raw;
  }

  private calcularTotalesOrden(articulos: any[]): { subtotal: number; impuestos: number; total: number } {
    let subtotal = 0;
    let impuestos = 0;

    articulos.forEach(articulo => {
      subtotal += articulo.det_orden_servicio_subtotal || 0;
      impuestos += articulo.det_orden_servicio_impuestos || 0;
    });

    return {
      subtotal,
      impuestos,
      total: subtotal + impuestos
    };
  }

  // Generar número de orden automático para nuevas operaciones
  private generarNuevaOrden(): string {
    const numeros = this.rowData.map(item => {
      const match = item.orden_servicio_numero.match(/OS-(\d{4})/);
      return match ? parseInt(match[1], 10) : 0;
    });
    const maxNumero = Math.max(...numeros, 0);
    const nuevoNumero = (maxNumero + 1).toString().padStart(4, '0');
    return `OS-${nuevoNumero}`;
  }

  // async abrirmodalcuotas(){
  //     // Verificar si hay una orden seleccionada o se está creando una nueva
  //     const modal = await this.modalController.create({
  //         component: ModalCuotasComponent,
  //         cssClass: 'promo',
  //         componentProps: {
  //         }
  //       });
        
  //       await modal.present();
        
  //       // Esperar la respuesta del modal
  //       const { data } = await modal.onWillDismiss();
        
  //       if (data && data.action === 'guardar') {
  //         console.log(' Cuotas guardadas exitosamente:', data.data);
          
  //       }
  //   }

    
  async abrirmodalcuotas() {
    // Verificar si hay una orden seleccionada o se está creando una nueva
    const ordenId = this.ordenSeleccionada?.orden_servicio_numero || this.titulo || 'Nueva Orden de Compra';


    // Buscar si ya existe configuración de cuotas para esta orden
    const cuotasExistentes = this.simulation.list('cuotasOrdenCompra') || [];
    const cuotasOrden = cuotasExistentes.find((c: any) => c.ordenCompraId === ordenId);


    // Obtener la condición de pago seleccionada
    const codigoCondicion = this.OrdenesDeServicioForm.get('condicionPago')?.value;
    let nombreCondicion = '';
    
    if (codigoCondicion) {
      const condicion = this.condicionesPago.find(c => c.codigo === codigoCondicion);
      nombreCondicion = condicion?.nombre || '';
    }

    // Obtener el monto total de la orden
    const montoTotal = this.ordenSeleccionada?.orden_servicio_total || this.totalGeneral || 0;
    console.log('Monto total enviado al modal:', montoTotal);

    const modal = await this.modalController.create({
      component: ModalCuotasComponent,
      cssClass: 'promo',
      componentProps: {
        ordenCompraId: ordenId,
        cuotasExistentes: cuotasOrden || null,
        condicionPago: nombreCondicion,
        montoTotal: montoTotal,
        titulo: 'Configuración de cuotas'
      }
    });

    await modal.present();

    // Esperar la respuesta del modal
    const { data } = await modal.onWillDismiss();

    if (data && data.action === 'guardar') {

      // Actualizar el botón para mostrar que ya hay cuotas configuradas
      this.botoncuotas = 'Editar';

      // Opcional: Guardar la referencia de cuotas en la orden de compra actual
      if (this.ordenSeleccionada) {
        const ordenesLS = this.simulation.list('ordenCompra') || [];
        const indiceOrden = ordenesLS.findIndex((o: any) => o.orden_servicio_numero === this.ordenSeleccionada?.orden_servicio_numero);

        if (indiceOrden !== -1) {
          ordenesLS[indiceOrden].cuotasConfiguracion = data.data;
          this.simulation.replace('ordenCompra', ordenesLS);
        }
      }
    } else {
      console.log('Modal cerrado sin guardar');
    }
  }

  /**
   * Resuelve la dirección fiscal a partir del proveedor (por su RUC/documento),
   * ya que el backend de la orden de servicio no la persiste. Si ya viene, la respeta.
   */
  private resolverDireccionFiscalDesdeProveedor() {
    const actual = this.OrdenesDeServicioForm.get('direccionFiscal')?.value;
    if (actual) {
      return;
    }
    const nroDocumento = String(this.OrdenesDeServicioForm.get('documentoproveedorinput')?.value ?? '').trim();
    if (!nroDocumento) {
      return;
    }
    this.api
      .get<any>('/core/relaciones-comerciales', { esProveedor: true, nroDocumento, page: 0, size: 20 })
      .pipe(catchError(() => of(null)))
      .subscribe((response) => {
        const lista = this.extraerLista(response);
        const proveedor = lista.find((p) => p?.flagEstado === '1') ?? lista[0];
        if (proveedor?.direccion) {
          this.OrdenesDeServicioForm.patchValue({ direccionFiscal: proveedor.direccion });
        }
      });
  }

  buscarproveedor() {
    let documento = this.OrdenesDeServicioForm.get('documentoproveedorinput')?.value;
    
    console.log('Documento ingresado para búsqueda:', documento, 'Tipo:', typeof documento);
    
    // Convertir a string si no es string (para manejar números)
    if (documento !== null && documento !== undefined) {
      documento = String(documento).trim();
    }
    
    // Validar que documento no esté vacío
    if (!documento || documento === '') {
      this.toastService.warning('¡Por favor, ingresa un documento para buscar el proveedor!');
      return;
    }

    // Buscar proveedor por documento contra el backend (relaciones comerciales)
    this.api
      .get<any>('/core/relaciones-comerciales', {
        esProveedor: true,
        nroDocumento: documento,
        page: 0,
        size: 20,
      })
      .pipe(catchError(() => of(null)))
      .subscribe((response) => {
        const lista = this.extraerLista(response);
        const proveedorEncontrado = lista.find((p) => p?.flagEstado === '1') ?? lista[0];

        if (proveedorEncontrado) {
          this.proveedorSeleccionadoId = Number(proveedorEncontrado.id) || null;
          this.OrdenesDeServicioForm.patchValue({
            proveedor: proveedorEncontrado.razonSocial ?? '',
            razonSocial: proveedorEncontrado.razonSocial ?? '',
            direccionFiscal: proveedorEncontrado.direccion ?? '',
          });
          this.toastService.success(`¡Proveedor encontrado: ${proveedorEncontrado.razonSocial}!`);
        } else {
          this.proveedorSeleccionadoId = null;
          this.toastService.warning('¡No se encontró proveedor con ese documento!');
          this.OrdenesDeServicioForm.patchValue({
            proveedor: '',
            razonSocial: '',
            direccionFiscal: '',
          });
        }
      });
  }

  /** Resuelve el nombre de la condición de pago a partir del código guardado en el formulario */
  get condicionPagoNombre(): string {
    const codigo = this.OrdenesDeServicioForm?.get('condicionPago')?.value;
    const condicion = this.condicionesPago.find(c => c.codigo === codigo);
    return condicion?.nombre || codigo || '';
  }

  /**
   * Actualiza el tipo de cambio según la moneda seleccionada
   * Obtiene el tipo de cambio activo más reciente desde localStorage
   */
  actualizarTipoCambio(moneda: string) {
    // Si es Soles, tipo de cambio fijo 1.00
    if (moneda === 'soles') {
      this.OrdenesDeServicioForm.patchValue({ tipoCambio: 1 });
      return;
    }
    // Mapear código de moneda al nombre usado en localStorage
    const mapeoMonedas: Record<string, string> = {
      'USD': 'Dólar',
      'Dólares': 'Dólar',
      'dolares': 'Dólar',
      'EUR': 'Euro',
      'Euros': 'Euro',
    };
    const nombreMoneda = mapeoMonedas[moneda];

    // Si la moneda no está en el mapeo, no buscar TC
    if (!nombreMoneda) {
      this.OrdenesDeServicioForm.patchValue({ tipoCambio: '' }, { emitEvent: false });
      return;
    }

    // Para otras monedas, buscar en localStorage
    const tiposCambio = this.simulation.list('tipoCambio') || [];

    const fechaActual = new Date();
    const fechaFormateada = this.formatDate(fechaActual);

    // Buscar tipo de cambio activo para la moneda con fecha actual
    const tipoCambioEncontrado = tiposCambio.find((tc: any) =>
      tc.moneda === nombreMoneda && tc.estado === 'Activo' && tc.fechavigencia === fechaFormateada
    );
    if (tipoCambioEncontrado) {
      const valorTC = tipoCambioEncontrado.tcventa.toFixed(5);
      this.OrdenesDeServicioForm.patchValue({ tipoCambio: valorTC });
    } else {
      // No hay TC para la fecha actual: buscar el más reciente activo
      const tiposCambioMoneda = tiposCambio.filter((tc: any) =>
        tc.moneda === nombreMoneda && tc.estado === 'Activo'
      );

      if (tiposCambioMoneda.length > 0) {
        tiposCambioMoneda.sort((a: any, b: any) => {
          const fechaA = this.parsearFechaString(a.fechavigencia);
          const fechaB = this.parsearFechaString(b.fechavigencia);
          return fechaB.getTime() - fechaA.getTime();
        });

        const tcMasReciente = tiposCambioMoneda[0];
        const valorTC = tcMasReciente.tcventa.toFixed(5);
        this.OrdenesDeServicioForm.patchValue({ tipoCambio: valorTC });
        this.toastService.warning(`¡Usando tipo de cambio del ${tcMasReciente.fechavigencia}!`);
      } else {
        this.OrdenesDeServicioForm.patchValue({ tipoCambio: '' });
        this.toastService.warning(`¡No hay tipo de cambio activo registrado para ${nombreMoneda}!`);
      }
    }
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

  private formatDate(date: Date): string {
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
  }

  /** Fecha de hoy en formato yyyy-MM-dd (requerido por <ion-input type="date">). */
  private fechaHoyISO(): string {
    const d = new Date();
    const mes = String(d.getMonth() + 1).padStart(2, '0');
    const dia = String(d.getDate()).padStart(2, '0');
    return `${d.getFullYear()}-${mes}-${dia}`;
  }

  /** Convierte un valor de fecha (dd/MM/yyyy, ISO o Date) a yyyy-MM-dd para el input date. */
  private aInputDate(valor: any): string {
    if (!valor) {
      return '';
    }
    if (valor instanceof Date) {
      const mes = String(valor.getMonth() + 1).padStart(2, '0');
      const dia = String(valor.getDate()).padStart(2, '0');
      return `${valor.getFullYear()}-${mes}-${dia}`;
    }
    const texto = String(valor).trim();
    const m = texto.match(/^(\d{1,2})\/(\d{1,2})\/(\d{4})/);
    if (m) {
      return `${m[3]}-${m[2].padStart(2, '0')}-${m[1].padStart(2, '0')}`;
    }
    // Si ya viene ISO (yyyy-MM-dd...), recorta a la parte de fecha.
    const iso = texto.match(/^(\d{4}-\d{2}-\d{2})/);
    return iso ? iso[1] : texto;
  }
  async abrirModalCrearServicio() {
    const modal = await this.modalController.create({
      component: ModalCrearServicioComponent,
      cssClass: 'promo2',
      componentProps: {
        productos: this.productos
      }
    });
    modal.present();
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
        { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial de la orden de servicio con estado Pendiente' },
        { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de la orden de servicio'},
        { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de orden de servicio - Fuente: SUNAT' },
      ];
  
      const modal = await this.modalController.create({
        component: ModalVerActualizacionesComponent,
        cssClass: 'promo',
        componentProps: {
          titulo: 'Historial de Actualizaciones de Orden de Servicio',
          rowData: rowData,
          colDefs: colDefs,
          anchoModal: '700px',
         
        }
      });
      
      await modal.present();
    }
}

