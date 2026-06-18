import { Component, ElementRef, OnInit, ViewChild, effect, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalVerActualizacionesComponent } from '../../../../../ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';
import { BotonAccionesComponent } from 'src/app/ui/boton-acciones/boton-acciones.component';
import { GeneracionAsientosSiniestroFacade } from '../../../application/facades/generacion-asientos-siniestro.facade';
import { ActivoSiniestroEntity, GeneracionAsientosSiniestroEntity } from '../../../domain/models/generacion-asientos-siniestro.entity';
import { ActivoFijoFacade } from '../../../application/facades/activo-fijo.facade';
import { ActivoFijoEntity } from '../../../domain/models/activo-fijo.entity';
import { AutocompleteComponent } from 'src/app/ui/autocomplete/autocomplete.component';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronLeft, faChevronRight, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';

/** yyyy-MM-dd → dd/MM/yyyy */
function formatDateDisplay(value: string): string {
  if (!value) return '';
  if (value.includes('-')) {
    const [y, m, d] = value.split('-');
    return `${d}/${m}/${y}`;
  }
  return value;
}

@Component({
  selector: 'app-activofijo-procesos-generacionasientossiniestro',
  templateUrl: './activofijo-procesos-generacionasientossiniestro.component.html',
  styleUrls: ['./activofijo-procesos-generacionasientossiniestro.component.scss'],
  standalone: false
})
export class ActivofijoProcesosGeneracionasientossiniestroComponent implements OnInit {
  // #region Iconos
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronLeft = faChevronLeft;
  fasChevronRight = faChevronRight;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;
  fasCirclePlus = faCirclePlus;
  // #endregion

  // ViewChilds
  @ViewChild('scrollBox', { read: ElementRef }) scrollBox!: ElementRef;
  @ViewChild(AutocompleteComponent) autocomplete!: AutocompleteComponent;

  // #region variables
  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  // filaSeleccionada: any = null; // Almacena la fila que se está editando
  filaSeleccionada: GeneracionAsientosSiniestroEntity | null = null; // Almacena la fila que se está editando

  camponuevo: boolean = false;

  private gridApi!: GridApi;
  private gridApiDetalle!: GridApi;
  estadoSeleccionado='';
  tabSeleccionado: string = 'registro';
  textoBotonGuardar: string = 'Registrar siniestro';
  mostrarTabla: boolean = true;
  soloVista: boolean = false;

  buscarActivo: { nombre: string; activo: ActivoFijoEntity }[] = [];

  tabs = [
    { value: 'registro', label: 'Registro del siniestro' },
    { value: 'evaluacion', label: 'Evaluación de daños' },
    { value: 'reclamo', label: 'Reclamo a la aseguradora' },
    { value: 'recupero', label: 'Gestión del Recupero' }
  ];
  // #endregion

  // #region Facades y FormBuilder
  readonly facade = inject(GeneracionAsientosSiniestroFacade);
  private readonly activoFijoFacade = inject(ActivoFijoFacade);
  private readonly fb = inject(FormBuilder);
  // #endregion

  // region Formulario reactivo

  siniestroForm: FormGroup = this.fb.group({
    registro: this.fb.group({
      codSiniestro: [{ value: this.getCodigoSiniestro(), disabled: true }, Validators.required],
      fechaIncidente: [''],
      causaSiniestro: ['', Validators.required],
      polizaAsociada: ['', Validators.required],
      aseguradora: ['', Validators.required],
      descripcionEvento: [''],
    }),
    evaluacion: this.fb.group({
      fechaEvaluacion: [''],
      evaluadorResponsable: [''],
      porcentajeDano: [''],
      tipoCosto: ['reposicion'],
      montoCosto: [''],
      monedaCosto: ['soles'],
    }),
    reclamo: this.fb.group({
      fechaComunicacion: [''],
      estadoReclamo: [''],
      fechaRespuesta: [''],
      montoSolicitado: [''],
      monedaSolicitado: ['soles'],
    }),
    recupero: this.fb.group({
      fechaRecupero: [''],
      montoIndemnizado: [''],
      monedaIndemnizado: ['soles'],
      estadoFinalActivo: ['Pendiente'],
      tipoRecupero: [''],
      cuentaContableIngreso: [''],
    }),
  });

  get registroForm(): FormGroup {
    return this.siniestroForm.get('registro') as FormGroup;
  }
  get evaluacionForm(): FormGroup {
    return this.siniestroForm.get('evaluacion') as FormGroup;
  }
  get reclamoForm(): FormGroup {
    return this.siniestroForm.get('reclamo') as FormGroup;
  }
  get recuperoForm(): FormGroup {
    return this.siniestroForm.get('recupero') as FormGroup;
  }
  // #endregion

  // #region Definición de columnas para ag-grid
  rowData: GeneracionAsientosSiniestroEntity[] = [];
  rowDataDetalle: ActivoSiniestroEntity[] = [];

  colDefs: ColDef<GeneracionAsientosSiniestroEntity>[] = [
    { field: 'gas_cod_siniestro', headerName: 'Cód. siniestro', width: 90, },
    { field: 'gas_fecha_incidente', headerName: 'Fecha incidente', width: 110,
      valueFormatter: (params: any) => formatDateDisplay(params.value),
    },
    { field: 'gas_usuario_ejecutor', headerName: 'Usuario ejecutor', flex: 1, minWidth: 150, },
    { headerName: 'Nº de activos', width: 100, type: 'rightAligned',
      cellStyle: { display: 'flex', justifyContent: 'end', alignItems: 'center' },
      valueGetter: (params: any) => {
        const activos = params.data?.gas_activos.length ?? 0;
        return activos;
      }
    },
    { field: 'gas_poliza', headerName: 'Póliza',width: 80, },
    { field: 'gas_aseguradora', headerName: 'Aseguradora', flex: 1, minWidth: 150, filter: true},
    { field: 'gas_estado_reclamo', headerName: 'Estado reclamo', width: 120, filter: true, headerClass: 'centrarencabezado',
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Reportado') {
          return `<span class="badge-table bg-primary-5 text-primary">Reportado</span>`;
        } else if (params.value === 'En evaluación') {
          return `<span class="badge-table bg-[#FFF0BF] text-[#F3A626]">En evaluación</span>`;
        } else if (params.value === 'Aprobado') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Aprobado</span>`;
        } else if (params.value === 'Rechazado') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Rechazado</span>`;
        } else if (params.value === 'Indemnizado') {
          return `<span class="badge-table bg-[#F5F5F5] text-[#363636]">Indemnizado</span>`;
        }
        return '-';
      },
    },
    { field: 'gas_asiento', headerName: 'N° de asiento contable', flex: 1, minWidth: 140,
      cellRenderer: (params: any) => {
        // Si el estado es "Pendiente" o "Baja", no mostrar nada
        if (params.data?.gas_estado_final_activo === 'Pendiente' || params.data?.gas_estado_final_activo === 'Baja') {
          return '-';
        }
        // Si el estado es "Reparado", usar el cell renderer personalizado
        return params.value;
      },
      cellRendererSelector: (params: any) => {
        // Si el estado es "Reparado", usar el componente personalizado
        if (params.data?.gas_estado_final_activo === 'Reparado') {
          return {
            component: VistaCellRenderComponent,
          };
        }
        // Para otros estados (Pendiente, Baja), usar el renderer por defecto
        return undefined;
      },
    },
    { headerClass: 'centrarencabezado', field: 'gas_estado_final_activo', headerName: 'Estado final', width: 120, filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return `<span class="badge-table bg-[#F5F5F5] text-[#1F1F1F]">Pendiente</span>`;
        } else if (params.value === 'Baja') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Baja</span>`;
        } else if (params.value === 'Reparado') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Reparado</span>`;
        }
        return params.value;
      },
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
  ];

  colDefsDetalle: ColDef[] = [
    { field: 'codigo', headerName: 'Código', width: 120,},
    { field: 'descripcion', headerName: 'Descripción', width: 250,},
    { field: 'sucursal', headerName: 'Sucursal', width: 150,},
    { field: 'valor', headerName: 'Valor neto', headerClass: 'derechaencabezado', width: 150,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right',}
    },
    { field: 'depreacumulada', headerName: 'Depreciación Acumulada', headerClass: 'derechaencabezado', width: 150,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', }
    },
    { field: 'vidautil', headerName: 'Vida útil restante', width: 150,},
    { headerName: 'Acciones', headerClass: 'centrarencabezado', width: 100, cellRenderer: BotonAccionesComponent,
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }, 
  ]

  columnTypes = {
    rightAligned: { 
      headerClass: 'ag-right-aligned-header',
      cellClass: 'ag-right-aligned-cell'
    }
  };

  frameworkComponents = {
    BotonAccionesComponent: BotonAccionesComponent
  };

  gridOptions = {
    context: {
      componentParent: this,
    },
    frameworkComponents: this.frameworkComponents
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
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '-'
        : params.value;
    }
  };
  // #endregion

  constructor(private modalController: ModalController, private toastService: ToastService) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    effect(() => {
      this.rowData = [...this.facade.siniestros()];
      // Actualizar código del formulario si no hay fila seleccionada (modo nuevo)
      if (!this.filaSeleccionada) {
        this.registroForm.patchValue({ codSiniestro: this.getCodigoSiniestro() });
      }
    });

    effect(() => {
      const activos = this.activoFijoFacade.activosFijos();
      this.buscarActivo = activos.map(a => ({
        nombre: `${a.activo_fijo_codigo} - ${a.activo_fijo_descripcion}`,
        activo: a
      }));
    });

    effect(() => {
      const result = this.facade.resultGuardar();
      if (result) {
        this.facade.cargarSiniestros();
        this.nuevoSiniestro();
      }
    });
   }

  ngOnInit() {
    this.facade.cargarSiniestros();
    this.activoFijoFacade.cargarActivosFijos();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }
  
  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApiDetalle = params.api;
  }

  // #region Funciones para manejo de formulario y lógica
  
  togglePanelLateral() {
    this.mostrarTabla = !this.mostrarTabla;
  }
  // FUNCIONES DEL SCROLL
  scrollLeft() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: -150, behavior: 'smooth' });
  }

  scrollRight() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: 150, behavior: 'smooth' });
  }

  getCodigoSiniestro(): string {
    const year = new Date().getFullYear();
    const registros = this.rowData ?? [];
    // Buscar el último código del año actual para incrementar el correlativo
    const codigosDelAno = registros
      .map(r => r.gas_cod_siniestro)
      .filter(c => c?.startsWith(`SIN-${year}-`))
      .map(c => parseInt(c.split('-').pop() ?? '0', 10));
    const maxNum = codigosDelAno.length > 0 ? Math.max(...codigosDelAno) : 0;
    return `SIN-${year}-${String(maxNum + 1).padStart(3, '0')}`;
  }

  // Valida si se puede cambiar al tab solicitado.
  onTabChange(nuevoTab: string) {
    const tabAnterior = this.tabSeleccionado;

    // Tabs 2, 3 y 4: solo accesibles si el siniestro ya fue registrado (filaSeleccionada)
    if (nuevoTab !== 'registro' && !this.filaSeleccionada) {
      this.toastService.warning(
        'Siniestro no registrado',
        'Primero debe registrar el siniestro para acceder a esta pestaña.'
      );
      this.tabSeleccionado = '';
      setTimeout(() => this.tabSeleccionado = tabAnterior);
      return;
    }

    this.tabSeleccionado = nuevoTab;
    if (this.tabSeleccionado === 'registro' && !this.filaSeleccionada) {
      this.textoBotonGuardar = 'Registrar siniestro';
    } else {
      this.textoBotonGuardar = 'Guardar';
    }
  }

  validarVista(){
    this.textoBotonGuardar = 'Guardar';
    if(this.filaSeleccionada?.gas_estado_final_activo === 'Baja'){
      this.soloVista = true;
      this.siniestroForm.disable();
    } else if(this.filaSeleccionada?.gas_estado_final_activo === 'Reparado'){
      this.soloVista = true;
      this.siniestroForm.disable();
    } else if(this.filaSeleccionada?.gas_estado_final_activo === 'Pendiente'){
      this.soloVista = false;
      this.siniestroForm.enable();
      this.registroForm.get('codSiniestro')?.disable();
    }
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos
    this.cargarDatos(range.start, range.end);
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }

 onBtReset() {
    this.facade.cargarSiniestros();
  }

  nuevoSiniestro(){
    this.tabSeleccionado = 'registro';
    this.filaSeleccionada = null;
    this.siniestroForm.reset();
    this.registroForm.reset({
      codSiniestro: this.getCodigoSiniestro(),
    });
    this.evaluacionForm.reset({
      tipoCosto: 'reposicion',
      monedaCosto: 'soles',
    });
    this.reclamoForm.reset({
      monedaSolicitado: 'soles',
    });
    this.recuperoForm.reset({
      estadoFinalActivo: 'Pendiente',
      monedaIndemnizado: 'soles',
    });
    this.siniestroForm.enable();
    this.registroForm.get('codSiniestro')?.disable();
    this.soloVista = false;
    this.rowDataDetalle = [];
  }

  onCellClicked(event: any) {
    this.camponuevo = false;
    this.filaSeleccionada = event.data;
    this.llenarFormulario();
    this.cargarActivosSiniestro();
    this.validarVista();
  }

  llenarFormulario() {
    if (this.filaSeleccionada) {
      this.registroForm.patchValue({
        codSiniestro: this.filaSeleccionada.gas_cod_siniestro,
        fechaIncidente: this.filaSeleccionada.gas_fecha_incidente,
        causaSiniestro: this.filaSeleccionada.gas_causa_siniestro,
        polizaAsociada: this.filaSeleccionada.gas_poliza,
        aseguradora: this.filaSeleccionada.gas_aseguradora,
        descripcionEvento: this.filaSeleccionada.gas_descripcion_evento,
      });
      this.evaluacionForm.patchValue({
        fechaEvaluacion: this.filaSeleccionada.gas_fecha_evaluacion,
        evaluadorResponsable: this.filaSeleccionada.gas_evaluador_responsable,
        porcentajeDano: this.filaSeleccionada.gas_porcentaje_dano,
        tipoCosto: this.filaSeleccionada.gas_tipo_costo,
        montoCosto: this.filaSeleccionada.gas_monto_costo,
        monedaCosto: this.filaSeleccionada.gas_moneda_costo || 'soles',
      });
      this.reclamoForm.patchValue({
        fechaComunicacion: this.filaSeleccionada.gas_fecha_comunicacion,
        estadoReclamo: this.filaSeleccionada.gas_estado_reclamo,
        fechaRespuesta: this.filaSeleccionada.gas_fecha_respuesta,
        montoSolicitado: this.filaSeleccionada.gas_monto_solicitado,
        monedaSolicitado: this.filaSeleccionada.gas_moneda_solicitado || 'soles',
      });
      this.recuperoForm.patchValue({
        fechaRecupero: this.filaSeleccionada.gas_fecha_recupero,
        montoIndemnizado: this.filaSeleccionada.gas_monto_indemnizado,
        monedaIndemnizado: this.filaSeleccionada.gas_moneda_indemnizado || 'soles',
        estadoFinalActivo: this.filaSeleccionada.gas_estado_final_activo,
        tipoRecupero: this.filaSeleccionada.gas_tipo_recupero,
        cuentaContableIngreso: this.filaSeleccionada.gas_cuenta_contable_ingreso,
      });
    }
  }

  cargarActivosSiniestro() {
    if (this.filaSeleccionada?.gas_activos) {
      this.rowDataDetalle = this.filaSeleccionada.gas_activos.map(a => ({
        codigo: a.codigo,
        descripcion: a.descripcion,
        sucursal: a.sucursal,
        valor: `S/ ${(parseFloat(a.valor.replace(/[^\d.-]/g, '')) || 0).toFixed(2)}`,
        depreacumulada: `S/ ${(parseFloat(a.depreacumulada.replace(/[^\d.-]/g, '')) || 0).toFixed(2)}`,
        vidautil: `${parseInt(a.vidautil.replace(/[^\d]/g, ''), 10) || 0} años`
      }));
    } else {
      this.rowDataDetalle = [];
    }
  }

  agregarActivo(item: any) {
    if (!item?.activo) return;
    const activo: ActivoFijoEntity = item.activo;
    // Evitar duplicados
    if (this.rowDataDetalle.some(r => r.codigo === activo.activo_fijo_codigo)) {
      this.toastService.warning('El activo ya se encuentra en la lista');
      this.autocomplete?.clearSelection();
      return;
    }
    const nuevo: ActivoSiniestroEntity = {
      codigo: activo.activo_fijo_codigo,
      descripcion: activo.activo_fijo_descripcion,
      sucursal: activo.activo_fijo_ubicacion_fisica ?? '',
      valor: `S/ ${(parseFloat(activo.activo_fijo_valor_neto.toString().replace(/[^\d.-]/g, '')) || 0).toFixed(2)}`,
      depreacumulada: `S/ ${(parseFloat((activo.activo_fijo_depreciacion_acumulada ?? 0).toString().replace(/[^\d.-]/g, '')) || 0).toFixed(2)}`,
      vidautil: `${parseInt((activo.activo_fijo_vida_util ?? 0).toString().replace(/[^\d]/g, ''), 10) || 0} años`
    };
    this.rowDataDetalle = [...this.rowDataDetalle, nuevo];
    this.autocomplete?.clearSelection();
  }

  eliminarArticulo(articulo: ActivoSiniestroEntity) {
    // Filtrar el array para remover el artículo
    this.rowDataDetalle = this.rowDataDetalle.filter(item => item.codigo !== articulo.codigo);
    
    // Actualizar la tabla
    if (this.gridApiDetalle) {
      this.gridApiDetalle.setGridOption('rowData', this.rowDataDetalle);
    }
    
    this.toastService.success('Artículo eliminado correctamente');
  }

  registrarSiniestro() {
    if (this.siniestroForm.invalid) {
      this.toastService.warning('Por favor, complete los campos obligatorios');
      return;
    } 
    if (this.rowDataDetalle.length === 0) {
      this.toastService.warning('Debe agregar al menos un activo afectado');
      return;
    }

    const registro = this.registroForm.getRawValue();
    const evaluacion = this.evaluacionForm.getRawValue();
    const reclamo = this.reclamoForm.getRawValue();
    const recupero = this.recuperoForm.getRawValue();

    const activos = this.rowDataDetalle.map(a => ({
      codigo: a.codigo,
      descripcion: a.descripcion,
      sucursal: a.sucursal,
      valor: `${(parseFloat(a.valor.replace(/[^\d.-]/g, '')) || 0).toFixed(2)}`,
      depreacumulada: `${(parseFloat(a.depreacumulada.replace(/[^\d.-]/g, '')) || 0).toFixed(2)}`,
      vidautil: `${parseInt(a.vidautil.replace(/[^\d]/g, ''), 10) || 0}`,
    }));

    const nuevoSiniestro: GeneracionAsientosSiniestroEntity = {
      gas_cod_siniestro: registro.codSiniestro || `SIN-${new Date().getFullYear()}-${String(this.rowData.length + 1).padStart(3, '0')}`,
      gas_fecha_incidente: registro.fechaIncidente || '',
      gas_causa_siniestro: registro.causaSiniestro || '',
      gas_descripcion_evento: registro.descripcionEvento || '',
      gas_poliza: registro.polizaAsociada || '',
      gas_aseguradora: registro.aseguradora || '',
      gas_usuario_ejecutor: 'Usuario Actual',
      gas_estado_reclamo: reclamo.estadoReclamo || '',
      gas_asiento: '',
      gas_fecha_evaluacion: evaluacion.fechaEvaluacion || '',
      gas_evaluador_responsable: evaluacion.evaluadorResponsable || '',
      gas_porcentaje_dano: evaluacion.porcentajeDano || '',
      gas_tipo_costo: evaluacion.tipoCosto || '',
      gas_monto_costo: evaluacion.montoCosto || '',
      gas_moneda_costo: evaluacion.monedaCosto || 'soles',
      gas_fecha_comunicacion: reclamo.fechaComunicacion || '',
      gas_fecha_respuesta: reclamo.fechaRespuesta || '',
      gas_monto_solicitado: reclamo.montoSolicitado || '',
      gas_moneda_solicitado: reclamo.monedaSolicitado || 'soles',
      gas_fecha_recupero: recupero.fechaRecupero || '',
      gas_monto_indemnizado: recupero.montoIndemnizado || '',
      gas_moneda_indemnizado: recupero.monedaIndemnizado || 'soles',
      gas_estado_final_activo: recupero.estadoFinalActivo || '',
      gas_tipo_recupero: recupero.tipoRecupero || '',
      gas_cuenta_contable_ingreso: recupero.cuentaContableIngreso || '',
      gas_activos: activos,
    };

    this.facade.guardarSiniestro(nuevoSiniestro);
    this.toastService.success('Siniestro registrado exitosamente');
  }
  // #endregion

  // #region Funciones para modales
  async modalverActualizaciones() {
    // Definir las columnas
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 150},
      { headerName: 'Usuario', field: 'usuario', width: 120},
      { headerName: 'Acción', field: 'accion', width: 150},
      {  headerClass:'centrarencabezado', headerName: 'Detalle del cambio', field: 'detalleCambio', flex: 1,
         cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center'} },
    ];

    // Datos de ejemplo
    const rowData = [
      { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Registro inicial del siniestro'},
      { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Cambio de estado de "Reportado" a "En evaluación"'},
      { fechaHora: '13/11/2025 09:00', usuario: 'Carlos Rodríguez', accion: 'Actualización', detalleCambio: 'Agregó documentación de respaldo (3 archivos)'},
      { fechaHora: '13/11/2025 16:45', usuario: 'Ana Martínez', accion: 'Actualización', detalleCambio: 'Cambio de estado de "En evaluación" a "Aprobado"'},
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones del Reclamo SIN-0000000007',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
       
      }
    });
    
    await modal.present();
  }

  // Método llamado por VistaCellRenderComponent al hacer clic en el ojo
  async abrirModal(nroAsiento: string, rowData: any) {
    if (!nroAsiento || nroAsiento === '-') return;

    // Si filaSeleccionada es null (clic directo en el ojo sin seleccionar fila), usar rowData
    const source = this.filaSeleccionada ?? rowData;

    // Datos de ejemplo del asiento contable
    const asientoData = source?.asientoData || [
      { cuentaContable: '1510.02', descripcion: 'Equipos de cocina - Depreciación', debito: 600.00, credito: 0.00},
      { cuentaContable: '3810.01', descripcion: 'Depreciación por equis motivo', debito: 0.00, credito: 600.00},
    ];
    // Definir columnas para la tabla de asientos
    const colDefs: ColDef[] = [
      {  field: 'cuentaContable',  headerName: 'Cuenta contable',  width: 130 },
      {  field: 'descripcion',  headerName: 'Descripción',  width: 150, flex: 1,},
      {  field: 'debito',  headerName: 'Debe',  width: 80, headerClass: 'centrarencabezado',
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        valueFormatter: (params) => {
          if (params.value !== null && params.value !== undefined) {
            const absValue = Math.abs(params.value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);
            
            if (params.value < 0) {
              return `(${formattedValue})`;
            }
            return formattedValue;
          }
          return '-';
        },
      },
      { field: 'credito', headerName: 'Haber', width: 80, headerClass: 'centrarencabezado',
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        valueFormatter: (params) => {
          if (params.value !== null && params.value !== undefined) {
            const absValue = Math.abs(params.value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);
            
            if (params.value < 0) {
              return `(${formattedValue})`;
            }
            return formattedValue;
          }
          return '-';
        },
      }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Asiento Contable: ${nroAsiento}`,
        widthModal: '740px',
        mostrarTabla: true,
        colDefs: colDefs,
        rowData: asientoData,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        ocultarBotonConfirmar: true,
        mostrarTotales: true,
        totalDebe: new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(
          asientoData.reduce((sum: number, item: any) => sum + item.debito, 0)
        ),
        totalHaber: new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(
          asientoData.reduce((sum: number, item: any) => sum + item.credito, 0)
        ),
        textoBotonCancelar: 'Cerrar',
      }
    });

    await modal.present();
  }
  // #endregion
}
