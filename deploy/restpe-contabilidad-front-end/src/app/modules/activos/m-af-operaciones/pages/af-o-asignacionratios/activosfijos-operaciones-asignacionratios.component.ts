import { Component, OnInit, OnDestroy, ElementRef, ViewChild, effect, inject } from '@angular/core';
import { AutocompleteComponent } from 'src/app/ui/autocomplete/autocomplete.component';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { AccesorioActionsCellComponent } from './cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalAgregarCentroComponent } from './modals/modal-agregar-centro/modal-agregar-centro.component';
import { ModalController } from '@ionic/angular';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { AsignacionRatiosFacade } from '../../../application/facades/asignacion-ratios.facade';
import { ActivoFijoFacade } from '../../../application/facades/activo-fijo.facade';
import { AsignacionRatiosEntity } from '../../../domain/models/asignacion-ratios.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faAngleRight, faArrowDown, faCalendarDays, faChevronLeft, faChevronRight, faChevronsLeft, faChevronsRight, faCirclePlus, faDollar, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-activosfijos-operaciones-asignacionratios',
  templateUrl: './activosfijos-operaciones-asignacionratios.component.html',
  styleUrls: ['./activosfijos-operaciones-asignacionratios.component.scss'],
  standalone: false
})
export class ActivosfijosOperacionesAsignacionratiosComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasAngleRight = faAngleRight;
  fasArrowDown = faArrowDown;
  fasCalendarDays = faCalendarDays;
  fasChevronLeft = faChevronLeft;
  fasChevronRight = faChevronRight;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDollar = faDollar;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  @ViewChild('scrollBox', { read: ElementRef }) scrollBox!: ElementRef;
  @ViewChild('centroCostoAC') centroCostoAC!: AutocompleteComponent;

  modoEdicion: boolean = false;
  documentoSoporte: string = '';
  filaSeleccionada: any = null;
  asignacionForm: FormGroup;
  private gridApi!: GridApi;
  estadoSeleccionado: string = 'todos';
  camponuevo: boolean = false;
  tabSeleccionado: string = 'seleccionActivo';
  panelLateralVisible: boolean = true;
  gridContext!: { componentParent: ActivosfijosOperacionesAsignacionratiosComponent };
  tab2Habilitado: boolean = false;
  tab3Habilitado: boolean = false;
  tab4Habilitado: boolean = false;
  
  valorTotalDepreciado: string = 'S/ 0.00';
  valorRemanenteLibros: string = 'S/ 0.00';
  numeroPeriodos: string = '0';
  
  activos: any[] = [];
  private readonly activoFijoFacade = inject(ActivoFijoFacade);


  private readonly centrosCostosOriginal = [
    { codigo: 'AC01', nombre: 'AC01 - Administración', porcentaje: '10' },
    { codigo: 'AC02', nombre: 'AC02 - Ventas', porcentaje: '10' },
    { codigo: 'AC03', nombre: 'AC03 - Producción', porcentaje: '10' },
    { codigo: 'AC04', nombre: 'AC04 - Logística', porcentaje: '10' },
    { codigo: 'AC05', nombre: 'AC05 - Finanzas', porcentaje: '10' }
  ];
  centrosCostos = [...this.centrosCostosOriginal];

  responsables = [
    { id: '1', nombre: 'Juan Pérez' },
    { id: '2', nombre: 'María García' },
    { id: '3', nombre: 'Carlos López' },
    { id: '4', nombre: 'Ana Martínez' }
  ];

  private gridApiCentrosCosto!: GridApi;
  rowDataCentrosCosto: any[] = [];
  colDefsCentrosCosto: ColDef[] = [
    { 
      field: 'centroCosto', 
      headerName: 'Centro de Costo', 
      width: 200,
      resizable: true, 
      sortable: true,
    },
    { 
      field: 'porcentaje', 
      headerName: '% de Distribución',
      headerClass: 'derechaencabezado', 
      width: 150, 
      resizable: true, 
      editable: true,
      sortable: true,
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
        alignItems: 'center',
      },
      valueFormatter: (param) => {
        return param.value ? `${param.value}%` : '0%';
      }
    },
    { 
      field: 'acciones',
      headerClass: 'centrarencabezado',
      headerName: 'Acciones', 
      width: 100, 
      resizable: true, 
      sortable: false,
      cellRenderer: AccesorioActionsCellComponent,
      cellStyle: {
        textAlign: 'center',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      }
    }
  ];

  private gridApiDepreciacion!: GridApi;
  rowDataDepreciacion: any[] = [];
  colDefsDepreciacion: ColDef[] = [
    { field: 'periodo', headerName: 'Periodo', width: 120, resizable: false },
    { 
      field: 'depreciacionAnual', 
      headerName: 'Depreciación Anual',
      headerClass: 'derechaencabezado', 
      width: 160, 
      resizable: false,
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
        alignItems: 'center',
      }
    },
    { 
      field: 'depreciacionAcumulada', 
      headerName: 'Depreciación Acumulada',
      headerClass: 'derechaencabezado', 
      width: 180, 
      resizable: false,
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
        alignItems: 'center',
      }
    },
    { 
      field: 'valorLibros', 
      headerName: 'Valor en Libros',
      headerClass: 'derechaencabezado', 
      flex: 1, 
      resizable: false,
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
        alignItems: 'center',
      }
    }
  ];

  columnTypes = {};

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
  
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  rowData: AsignacionRatiosEntity[] = [];
  readonly facade = inject(AsignacionRatiosFacade);

  colDefs: ColDef[] = [
    { field: 'ars_cod_configuracion', headerName: 'Código Configuración', width: 150 },
    { field: 'ars_cod_activo', headerName: 'Código de Activo', width: 150 },
    { field: 'ars_metodo', headerName: 'Método', width: 140, filter: true,
      valueFormatter: (params) => {
        const metodos: Record<string, string> = { 'lineal': 'Líneal', 'unidades': 'Decreciente', 'suma': 'Otro parametrizado' };
        return metodos[params.value] || params.value;
      }
    },
    { field: 'ars_tasa_anual', headerClass: 'derechaencabezado', headerName: 'Tasa Anual (%)', width: 140, cellStyle: {  textAlign: 'right', display: 'flex', justifyContent: 'right', },
      valueFormatter: (params) => params.value ? `${params.value}%` : '0%'
    },
    { field: 'ars_fecha_inicio', headerName: 'Fecha de Inicio', width: 140 },
    { 
      field: 'ars_estado',
      headerClass: 'centrarencabezado',
      headerName: 'Acciones', 
      width: 80, 
      filter: true,
      cellRenderer: (params: any) => {
        const color = params.value === 'Activo'
          ? 'bg-[#DCFDE7] text-[#16A34A]'
          : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
      cellStyle: {
        textAlign: 'center',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    }
  ];

  constructor(private fb: FormBuilder, private toastservice:  ToastService, private modalController: ModalController, private formValidationService: FormValidationService) {
    effect(() => { this.rowData = this.facade.asignaciones(); });
    effect(() => {
      const items = this.activoFijoFacade.activosFijos();
      this.activos = items.map((item) => ({
        id: item.activo_fijo_codigo,
        nombre: `${item.activo_fijo_codigo} - ${item.activo_fijo_descripcion}`,
        valorAdquisicion: item.activo_fijo_valor_adquisicion,
        moneda: item.activo_fijo_moneda,
        fechaAdquisicion: item.activo_fijo_fecha_adquisicion,
        vidaUtil: item.activo_fijo_vida_util
      }));
    });
    this.gridContext = { componentParent: this };
    
    this.asignacionForm = this.fb.group({
      activo: ['', Validators.required],
      valorAdquisicion: [{ value: '', disabled: true }, Validators.required],
      moneda: [{ value: '', disabled: true }, Validators.required],
      monedaActivo: [''],
      fechaAdquisicion: [{ value: '', disabled: true }, Validators.required],
      vidaUtil: [{ value: '', disabled: true }, Validators.required],
      tipoDepreciacion: ['', Validators.required],
      metodoDepreciacion: ['', Validators.required],
      ratioAnual: ['', Validators.required],
      fechaInicio: ['', Validators.required],
      valorResidual: ['', Validators.required],
      estado: ['activo', Validators.required],
      observaciones: [''],
      fechaAsignacion: [''],
      normaContable: [''],
      tipoFiscal: [''],
      notasAdicionales: ['']
    });
  }

  ngOnInit() {
    this.facade.cargarAsignaciones();
    this.activoFijoFacade.cargarActivosFijos();
    console.log('Componente Asignación de Ratios de Depreciación inicializado');
    
    // Inicializar servicio de validación de formularios
    this.formValidationService.inicializarFormulario(this.asignacionForm);
    // Resetear estado inicial después de inicializar
    this.formValidationService.resetearEstado();
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  get seleccionActivoValid(): boolean {
    const activo = this.asignacionForm.get('activo');
    const valorAdquisicion = this.asignacionForm.get('valorAdquisicion');
    const moneda = this.asignacionForm.get('moneda');
    const fechaAdquisicion = this.asignacionForm.get('fechaAdquisicion');
    const vidaUtil = this.asignacionForm.get('vidaUtil');

    return !!(activo?.value && valorAdquisicion?.value && moneda?.value && fechaAdquisicion?.value && vidaUtil?.value);
  }

  get metodosDepreciacionValid(): boolean {
    const tipoDepreciacion = this.asignacionForm.get('tipoDepreciacion');
    const metodoDepreciacion = this.asignacionForm.get('metodoDepreciacion');
    const ratioAnual = this.asignacionForm.get('ratioAnual');
    const valorResidual = this.asignacionForm.get('valorResidual');
    const estado = this.asignacionForm.get('estado');
    const fechaInicio = this.asignacionForm.get('fechaInicio');

    return !!(
      tipoDepreciacion?.value && 
      metodoDepreciacion?.value && 
      ratioAnual?.value && 
      valorResidual?.value && 
      fechaInicio?.value && 
      estado?.value
    );
  }

  get centrosCostoValid(): boolean {
    return this.rowDataCentrosCosto.length > 0;
  }

  get simulacionDepreciacionValid(): boolean {
    const normaContable = this.asignacionForm.get('normaContable');
    return !!(
      this.seleccionActivoValid && 
      this.metodosDepreciacionValid && 
      this.centrosCostoValid && 
      normaContable?.value
    );
  }

  nextTab() {
    if(this.tabSeleccionado === 'seleccionActivo'){
      if (this.seleccionActivoValid) {
        this.tab2Habilitado = true;
        this.tabSeleccionado = 'metodosDepreciacion';
      } else {
        this.toastservice.warning('Por favor, selecciona un activo para continuar');
        this.asignacionForm.get('activo')?.markAsTouched();
        this.asignacionForm.get('valorAdquisicion')?.markAsTouched();
        this.asignacionForm.get('moneda')?.markAsTouched();
        this.asignacionForm.get('fechaAdquisicion')?.markAsTouched();
        this.asignacionForm.get('vidaUtil')?.markAsTouched();
      }
    }
    if(this.tabSeleccionado === 'metodosDepreciacion'){
      if (this.metodosDepreciacionValid) {
        this.tab3Habilitado = true;
        this.tabSeleccionado = 'centrosCosto';
      } else {
        this.toastservice.warning('Por favor, selecciona o agrega un centro de costo para continuar');
        this.asignacionForm.get('tipoDepreciacion')?.markAsTouched();
        this.asignacionForm.get('metodoDepreciacion')?.markAsTouched();
        this.asignacionForm.get('ratioAnual')?.markAsTouched();
        this.asignacionForm.get('valorResidual')?.markAsTouched();
        this.asignacionForm.get('fechaInicio')?.markAsTouched();
        this.asignacionForm.get('estado')?.markAsTouched();
      }
    }
    if(this.tabSeleccionado === 'centrosCosto'){
      if (this.centrosCostoValid) {
        this.tab4Habilitado = true;
        this.tabSeleccionado = 'normativaAplicable';
      } else {
        this.toastservice.warning('Por favor, complete todos los campos requeridos');
      }
    }
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    
    // Iniciar en modo creación (formulario vacío)
    // No seleccionar ninguna fila automáticamente
  }

  async onRowClicked(event: any) {
    // Validar cambios antes de cambiar de configuración
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló, deseleccionar todo primero
      if (this.gridApi) {
        this.gridApi.deselectAll();
        // Volver a seleccionar la fila anterior si existía
        if (this.filaSeleccionada) {
          this.gridApi.forEachNode((node) => {
            if (node.data === this.filaSeleccionada) {
              node.setSelected(true);
            }
          });
        }
      }
      return;
    }
    
    this.filaSeleccionada = event.data;
    this.camponuevo = false;
    this.cargarDatosDesdeFilaSeleccionada(event.data);
    
    // Marcar como pristine y untouched
    this.asignacionForm.markAsPristine();
    this.asignacionForm.markAsUntouched();
    
    // Resetear estado de validación después de cargar datos
    setTimeout(() => {
      this.formValidationService.resetearEstado();
    }, 50);
  }

  // NUEVO: Método que carga los datos del activo desde la fila seleccionada
  cargarDatosDesdeFilaSeleccionada(filaData: any) {
    // Buscar el activo en el array usando el codActivo de la fila
    const activoEncontrado = this.activos.find(a => a.id === filaData.ars_cod_activo);
    
    if (activoEncontrado) {
      // Tab 1: Selección del Activo
      this.asignacionForm.patchValue({
        activo: activoEncontrado.id,
        valorAdquisicion: activoEncontrado.valorAdquisicion,
        moneda: activoEncontrado.moneda,
        fechaAdquisicion: activoEncontrado.fechaAdquisicion,
        vidaUtil: activoEncontrado.vidaUtil
      });
    }

    // Tab 2: Métodos de Depreciación
    this.asignacionForm.patchValue({
      tipoDepreciacion: filaData.ars_tipo_depreciacion || '',
      metodoDepreciacion: filaData.ars_metodo || '',
      ratioAnual: filaData.ars_tasa_anual ? parseFloat(filaData.ars_tasa_anual) : '',
      valorResidual: filaData.ars_valor_residual || '',
      estado: filaData.ars_estado === 'Activo' ? 'activo' : 'inactivo'
    });

    // Fecha inicio depreciación
    if (filaData.ars_fecha_inicio) {
      const partes = filaData.ars_fecha_inicio.split('/');
      if (partes.length === 3) {
        const fecha = new Date(parseInt(partes[2]), parseInt(partes[1]) - 1, parseInt(partes[0]));
        this.asignacionForm.patchValue({ fechaInicio: fecha });
      }
    }

    // Tab 3: Centros de Costo
    if (filaData.ars_centros_costo && Array.isArray(filaData.ars_centros_costo)) {
      this.rowDataCentrosCosto = filaData.ars_centros_costo.map((cc: any) => ({
        centroCosto: cc.centroCosto,
        porcentaje: cc.porcentaje
      }));
    }

    // Tab 4: Normativa Aplicable
    this.asignacionForm.patchValue({
      normaContable: filaData.ars_norma_contable || '',
      notasAdicionales: filaData.ars_notas_adicionales || ''
    });

    // Habilitar todas las pestañas
    this.tab2Habilitado = true;
    this.tab3Habilitado = true;
    this.tab4Habilitado = true;
  }

  async botonNuevaAsignacion() {
    // Validar cambios antes de limpiar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    this.camponuevo = true;
    this.filaSeleccionada = null;
    this.asignacionForm.reset();
    this.tabSeleccionado = 'seleccionActivo';
    this.rowDataCentrosCosto = [];
    this.centrosCostos = [...this.centrosCostosOriginal];
    
    // Deseleccionar cualquier fila en el grid
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Resetear estado de validación
    this.formValidationService.resetearEstado();
  }

  async botonCancelar(): Promise<void> {
    // Validar cambios antes de cancelar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Si cancela, deseleccionar la fila
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }
      return; // Cancelar acción
    }

    // Reiniciar el formulario a los valores por defecto
    if (this.asignacionForm) {
      this.asignacionForm.reset();
      
      // Limpiar variables
      this.camponuevo = false;
      this.filaSeleccionada = null;
      this.tabSeleccionado = 'seleccionActivo';
      this.rowDataCentrosCosto = [];
      this.rowDataDepreciacion = [];
      this.centrosCostos = [...this.centrosCostosOriginal];
      this.tab2Habilitado = false;
      this.tab3Habilitado = false;
      this.tab4Habilitado = false;

      // Deseleccionar fila de la tabla
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }

      // Resetear estado del servicio de validación
      this.formValidationService.resetearEstado();
    }
  }

  botonAnular() {
    if (this.filaSeleccionada) {
      console.log('Anulando asignación:', this.filaSeleccionada);
    }
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  seleccionarTab(tab: string) {
    this.tabSeleccionado = tab;
  }

  onActivoSeleccionado(evento: any) {
    console.log('Activo seleccionado:', evento);
    
    if (evento && evento.id) {
      const activoCompleto = this.activos.find(a => a.id === evento.id);
      
      if (activoCompleto) {
        this.asignacionForm.patchValue({
          valorAdquisicion: activoCompleto.valorAdquisicion,
          moneda: activoCompleto.moneda,
          fechaAdquisicion: activoCompleto.fechaAdquisicion,
          vidaUtil: activoCompleto.vidaUtil
        });
        
        this.asignacionForm.get('valorAdquisicion')?.markAsTouched();
        this.asignacionForm.get('moneda')?.markAsTouched();
        this.asignacionForm.get('fechaAdquisicion')?.markAsTouched();
        this.asignacionForm.get('vidaUtil')?.markAsTouched();
      }
    }
  }

  onCentroCostosSeleccionado(evento: any) {
    console.log('Centro de costos seleccionado:', evento);
  }

  onResponsableSeleccionado(evento: any) {
    console.log('Responsable seleccionado:', evento);
  }

  onCellClicked(event: any) {
    this.onRowClicked(event);
  }

  scrollLeft() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: -150, behavior: 'smooth' });
  }

  scrollRight() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: 150, behavior: 'smooth' });
  }

  calcularVidaUtil() {
    const ratio = this.asignacionForm.get('ratioAnual')?.value;
    if (ratio && ratio > 0) {
      const vidaUtil = Math.round(100 / ratio);
      this.asignacionForm.patchValue({ vidaUtil: vidaUtil });
    }
  }

  calcularRatio() {
    const vidaUtil = this.asignacionForm.get('vidaUtil')?.value;
    if (vidaUtil && vidaUtil > 0) {
      const ratio = (100 / vidaUtil).toFixed(2);
      this.asignacionForm.patchValue({ ratioAnual: parseFloat(ratio) });
    }
  }

  onGridReadyCentrosCosto(params: GridReadyEvent) {
    this.gridApiCentrosCosto = params.api;
  }

  onCellClickedCentrosCosto(event: any) {
    console.log('Centro de costo seleccionado:', event.data);
  }

  async botonAgregarCentroCosto() {
    console.log('Abriendo modal agregar centro de costo');
    const modal = await this.modalController.create({
      component: ModalAgregarCentroComponent,
      cssClass: 'promo'
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data) {
      console.log('Datos recibidos del modal:', data);
      const nuevoCentroCosto = {
        centroCosto: data.centroCosto,
        porcentaje: data.porcentajeDistribucion
      };
      this.rowDataCentrosCosto = [...this.rowDataCentrosCosto, nuevoCentroCosto];
    }
  }

  onCentroCostoSeleccionado(evento: any) {
    if (evento && evento.codigo) {
      const nuevoCentroCosto = {
        centroCosto: evento.nombre,
        porcentaje: evento.porcentaje,
        _original: evento
      };
      this.rowDataCentrosCosto = [...this.rowDataCentrosCosto, nuevoCentroCosto];
      this.centrosCostos = this.centrosCostos.filter(c => c.codigo !== evento.codigo);
      this.centroCostoAC?.clearSelection();
    }
  }

  eliminarCentroCosto(centroCosto: any) {
    const index = this.rowDataCentrosCosto.findIndex(item => item === centroCosto);
    if (index > -1) {
      if (centroCosto._original) {
        this.centrosCostos = [...this.centrosCostos, centroCosto._original]
          .sort((a, b) => a.codigo.localeCompare(b.codigo));
      }
      this.rowDataCentrosCosto.splice(index, 1);
      this.rowDataCentrosCosto = [...this.rowDataCentrosCosto];
    }
  }

  onGridReadyDepreciacion(params: GridReadyEvent) {
    this.gridApiDepreciacion = params.api;
  }

  onfechaInicioDepreciacion(date: Date) {
    this.asignacionForm.patchValue({ fechaInicio: date });
    this.asignacionForm.get('fechaInicio')?.markAsTouched();
  }

  simularDepreciacion() {
    console.log('Simulando depreciación...');
    
    this.rowDataDepreciacion = [
      { periodo: 'Año 1', depreciacionAnual: '1,124.86', depreciacionAcumulada: '1,124.86', valorLibros: '3,375.73' },
      { periodo: 'Año 2', depreciacionAnual: '1,124.86', depreciacionAcumulada: '2,249.71', valorLibros: '2,250.87' },
      { periodo: 'Año 3', depreciacionAnual: '1,124.86', depreciacionAcumulada: '3,374.57', valorLibros: '1,126.01' },
      { periodo: 'Año 4', depreciacionAnual: '1,124.86', depreciacionAcumulada: '4,499.42', valorLibros: '1.16' }
    ];
    
    this.valorTotalDepreciado = 'S/ 4,499.42';
    this.valorRemanenteLibros = 'S/ 0.58';
    this.numeroPeriodos = '4';
  }

  botonGuardar(){
    // Validar que el formulario tenga los datos necesarios
    if (!this.asignacionForm.valid || !this.seleccionActivoValid || !this.metodosDepreciacionValid) {
      Object.keys(this.asignacionForm.controls).forEach(key => {
        this.asignacionForm.get(key)?.markAsTouched();
      });
      this.toastservice.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    // Obtener los valores del formulario
    const activoSeleccionado = this.asignacionForm.get('activo')?.value;
    const metodoDepreciacion = this.asignacionForm.get('metodoDepreciacion')?.value;
    const ratioAnual = this.asignacionForm.get('ratioAnual')?.value;
    const fechaInicio = this.asignacionForm.get('fechaInicio')?.value;
    const estado = this.asignacionForm.get('estado')?.value;

    // Generar código de configuración único
    const nuevoCodigo = `CFG-${String(this.rowData.length + 1).padStart(3, '0')}`;

    // Formatear fecha
    let fechaFormateada = '';
    if (fechaInicio) {
      const fecha = new Date(fechaInicio);
      const dia = String(fecha.getDate()).padStart(2, '0');
      const mes = String(fecha.getMonth() + 1).padStart(2, '0');
      const anio = fecha.getFullYear();
      fechaFormateada = `${dia}/${mes}/${anio}`;
    }

    // Buscar el método de depreciación seleccionado
    const nuevoRegistro: AsignacionRatiosEntity = {
      ars_cod_configuracion: nuevoCodigo,
      ars_cod_activo:        activoSeleccionado || '',
      ars_metodo:            metodoDepreciacion || '',
      ars_tasa_anual:        `${ratioAnual}`,
      ars_fecha_inicio:      fechaFormateada,
      ars_estado:            estado === 'activo' ? 'Activo' : 'Inactivo'
    };

    // Guardar mediante facade (reactivo)
    this.facade.guardarAsignacion(nuevoRegistro);

    // Contraer panel lateral si está visible
    if (this.panelLateralVisible) {
      this.panelLateralVisible = false;
    }

    // Resetear el formulario y volver al primer tab
    this.asignacionForm.reset();
    this.asignacionForm.patchValue({ estado: 'activo' });
    this.tabSeleccionado = 'seleccionActivo';
    this.rowDataCentrosCosto = [];
    this.rowDataDepreciacion = [];
    this.tab2Habilitado = false;
    this.tab3Habilitado = false;
    this.tab4Habilitado = false;
    this.camponuevo = false;
    this.filaSeleccionada = null;

    // Deseleccionar filas del grid
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Resetear estado de validación
    this.formValidationService.resetearEstado();

    this.toastservice.success('La configuración se registró con éxito');
    this.panelLateralVisible = true;
  }

  onBtReset() {
    this.facade.cargarAsignaciones();
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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar',},
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385',},
      { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio:   'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380',},
      { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT',},
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - Asignación de Ratios',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      },
    });

    await modal.present();
  }
}