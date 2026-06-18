import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { AccionesEditarComponent } from 'src/app/ui/acciones-editar/acciones-editar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalEditarPeriodoComponent } from '../../modals/modal-editar-periodo/modal-editar-periodo.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ConfiguracionFacade } from '../../../application/facades/configuracion.facade';
import { ConfiguracionEjerciciosFiscalesGridEffects } from '../../../effects/configuracion-ejercicios-fiscales-grid.effect';
import { EjercicioFiscalEntity } from '../../../domain/models/ejercicio-fiscal.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-a-l-ejercicios-y-periodos',
  templateUrl: './a-l-ejercicios-y-periodos.component.html',
  styleUrls: ['./a-l-ejercicios-y-periodos.component.scss'],
  standalone: false,
})
export class ALEjerciciosYPeriodosComponent implements OnInit, OnDestroy {
  // Facades y Effects
  private readonly configuracionFacade = inject(ConfiguracionFacade);
  private readonly ejerciciosGridEffects = inject(ConfiguracionEjerciciosFiscalesGridEffects);

  // Selectores del store
  readonly ejerciciosFiscales = this.configuracionFacade.ejerciciosFiscales;
  readonly loadingEjerciciosFiscales = this.configuracionFacade.loadingEjerciciosFiscales;
  readonly isLoading = this.configuracionFacade.isLoading;

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  // FECHAS ÚNICAS (SINGLE)

  fechaInicio: Date | undefined;
  fechaFin: Date | undefined;

  private gridApi!: GridApi;
  private gridApiDetalle!: GridApi;


  panelLateralVisible = true;
  filaSeleccionada: any = null;
  ejercicioCerrado: boolean = false;

  EjercicioFiscalForm!: FormGroup;
  cargando = false;
  isResetting = false;
  camponuevo: boolean = false;
  modoCreacion: boolean = true;
  periodosGenerados: boolean = false;

  filasGeneradas: any[] = [];
  rowDataActual: any[] = [];

  tipoSeleccionado: string = 'Mensual';



  periocidades = [
    'Mensual',
    'Bimensual',
    'Trimestral',
    'Cuatrimestral',
    'Semestral',
    'Anual',
  ]

  cierres = [
    'Pre-cierre',
    'Cierre definitivo',
  ]



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

  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  get rowData(): EjercicioFiscalEntity[] {
    return this.ejerciciosGridEffects.getRowData();
  }

  colDefs: ColDef[] = [
    { field: 'ejercicio_fiscal_nombre', headerName: 'Nombre', width: 150 },
    {
      field: 'ejercicio_fiscal_fecha_inicio', headerName: 'Fecha de inicio', width: 100,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate()).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
    },
    {
      field: 'ejercicio_fiscal_fecha_fin', headerName: 'Fecha de fin', width: 100,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate()).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
    },
    { field: 'ejercicio_fiscal_periocidad', headerName: 'Periodicidad', width: 100 },

    {
      field: 'ejercicio_fiscal_estado',
      headerName: 'Estado',
      width: 100,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Abierto') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Abierto</span>`;
        } else if (params.value === 'Cerrado') {
          return `<span class="badge-table bg-[#FFF0BF] text-[#F2A626]">Cerrado</span>`;
        }
        return params.value;
      },
    }
  ];

  rowDataMen = [
    { periodo_fiscal_codigo: 'P-001', periodo_fiscal_nombre: 'Periodo 1', periodo_fiscal_fecha_inicio_detalle: '2025-01-01', periodo_fiscal_fecha_fin_detalle: '2025-01-31', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'P-002', periodo_fiscal_nombre: 'Periodo 2', periodo_fiscal_fecha_inicio_detalle: '2025-02-01', periodo_fiscal_fecha_fin_detalle: '2025-02-28', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'P-003', periodo_fiscal_nombre: 'Periodo 3', periodo_fiscal_fecha_inicio_detalle: '2025-03-01', periodo_fiscal_fecha_fin_detalle: '2025-03-31', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'P-004', periodo_fiscal_nombre: 'Periodo 4', periodo_fiscal_fecha_inicio_detalle: '2025-04-01', periodo_fiscal_fecha_fin_detalle: '2025-04-30', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'P-005', periodo_fiscal_nombre: 'Periodo 5', periodo_fiscal_fecha_inicio_detalle: '2025-05-01', periodo_fiscal_fecha_fin_detalle: '2025-05-31', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'P-006', periodo_fiscal_nombre: 'Periodo 6', periodo_fiscal_fecha_inicio_detalle: '2025-06-01', periodo_fiscal_fecha_fin_detalle: '2025-06-30', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'P-007', periodo_fiscal_nombre: 'Periodo 7', periodo_fiscal_fecha_inicio_detalle: '2025-07-01', periodo_fiscal_fecha_fin_detalle: '2025-07-31', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'P-008', periodo_fiscal_nombre: 'Periodo 8', periodo_fiscal_fecha_inicio_detalle: '2025-08-01', periodo_fiscal_fecha_fin_detalle: '2025-08-31', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'P-009', periodo_fiscal_nombre: 'Periodo 9', periodo_fiscal_fecha_inicio_detalle: '2025-09-01', periodo_fiscal_fecha_fin_detalle: '2025-09-30', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'P-010', periodo_fiscal_nombre: 'Periodo 10', periodo_fiscal_fecha_inicio_detalle: '2025-10-01', periodo_fiscal_fecha_fin_detalle: '2025-10-31', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'P-011', periodo_fiscal_nombre: 'Periodo 11', periodo_fiscal_fecha_inicio_detalle: '2025-11-01', periodo_fiscal_fecha_fin_detalle: '2025-11-30', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'P-012', periodo_fiscal_nombre: 'Periodo 12', periodo_fiscal_fecha_inicio_detalle: '2025-12-01', periodo_fiscal_fecha_fin_detalle: '2025-12-31', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' }
  ];

  rowDataBim = [
    { periodo_fiscal_codigo: 'B-001', periodo_fiscal_nombre: 'Bimestre 1', periodo_fiscal_fecha_inicio_detalle: '2025-01-01', periodo_fiscal_fecha_fin_detalle: '2025-02-28', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'B-002', periodo_fiscal_nombre: 'Bimestre 2', periodo_fiscal_fecha_inicio_detalle: '2025-03-01', periodo_fiscal_fecha_fin_detalle: '2025-04-30', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'B-003', periodo_fiscal_nombre: 'Bimestre 3', periodo_fiscal_fecha_inicio_detalle: '2025-05-01', periodo_fiscal_fecha_fin_detalle: '2025-06-30', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'B-004', periodo_fiscal_nombre: 'Bimestre 4', periodo_fiscal_fecha_inicio_detalle: '2025-07-01', periodo_fiscal_fecha_fin_detalle: '2025-08-31', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'B-005', periodo_fiscal_nombre: 'Bimestre 5', periodo_fiscal_fecha_inicio_detalle: '2025-09-01', periodo_fiscal_fecha_fin_detalle: '2025-10-31', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'B-006', periodo_fiscal_nombre: 'Bimestre 6', periodo_fiscal_fecha_inicio_detalle: '2025-11-01', periodo_fiscal_fecha_fin_detalle: '2025-12-31', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' }

  ];

  rowDataTri = [
    { periodo_fiscal_codigo: 'T-001', periodo_fiscal_nombre: 'Trimestre 1', periodo_fiscal_fecha_inicio_detalle: '2025-01-01', periodo_fiscal_fecha_fin_detalle: '2025-03-31', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'T-002', periodo_fiscal_nombre: 'Trimestre 2', periodo_fiscal_fecha_inicio_detalle: '2025-04-01', periodo_fiscal_fecha_fin_detalle: '2025-06-30', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'T-003', periodo_fiscal_nombre: 'Trimestre 3', periodo_fiscal_fecha_inicio_detalle: '2025-07-01', periodo_fiscal_fecha_fin_detalle: '2025-09-30', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'T-004', periodo_fiscal_nombre: 'Trimestre 4', periodo_fiscal_fecha_inicio_detalle: '2025-10-01', periodo_fiscal_fecha_fin_detalle: '2025-12-31', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' }
  ];

  rowDataCuatri = [
    { periodo_fiscal_codigo: 'C-001', periodo_fiscal_nombre: 'Cuatrimestre 1', periodo_fiscal_fecha_inicio_detalle: '2025-01-01', periodo_fiscal_fecha_fin_detalle: '2025-04-30', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'C-002', periodo_fiscal_nombre: 'Cuatrimestre 2', periodo_fiscal_fecha_inicio_detalle: '2025-05-01', periodo_fiscal_fecha_fin_detalle: '2025-08-31', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'C-003', periodo_fiscal_nombre: 'Cuatrimestre 3', periodo_fiscal_fecha_inicio_detalle: '2025-09-01', periodo_fiscal_fecha_fin_detalle: '2025-12-31', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' }
  ];

  rowDataSem = [
    { periodo_fiscal_codigo: 'S-001', periodo_fiscal_nombre: 'Semestre 1', periodo_fiscal_fecha_inicio_detalle: '2025-01-01', periodo_fiscal_fecha_fin_detalle: '2025-06-30', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
    { periodo_fiscal_codigo: 'S-002', periodo_fiscal_nombre: 'Semestre 2', periodo_fiscal_fecha_inicio_detalle: '2025-07-01', periodo_fiscal_fecha_fin_detalle: '2025-12-31', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' }
  ];

  rowDataAnual = [
    { periodo_fiscal_codigo: 'A-001', periodo_fiscal_nombre: 'Anual 1', periodo_fiscal_fecha_inicio_detalle: '2025-01-01', periodo_fiscal_fecha_fin_detalle: '2025-12-31', periodo_fiscal_cierre: 'Contabilidad, Inventarios, Ventas, Bancos, Activos fijos, Compras', periodo_fiscal_estado: 'Abierto' },
  ];



  colDefsDetalle: ColDef[] = [
    { field: 'periodo_fiscal_codigo', headerName: 'Código', width: 70 },
    { field: 'periodo_fiscal_nombre', headerName: 'Nombre', width: 120 },
    {
      field: 'periodo_fiscal_fecha_inicio_detalle', headerName: 'Fecha de inicio', width: 150,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate()).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
    },

    {
      field: 'periodo_fiscal_fecha_fin_detalle', headerName: 'Fecha de fin', width: 150,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate()).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
    },
    { field: 'periodo_fiscal_cierre', headerName: 'Cierre de módulos', flex: 1, minWidth: 350 },
    {
      field: 'periodo_fiscal_estado',
      headerName: 'Estado',
      width: 100,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Abierto') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Abierto</span>`;
        } else if (params.value === 'Cerrado') {
          return `<span class="badge-table bg-[#FEF3C7] text-[#F2A626]">Cerrado</span>`;
        }
        return params.value;
      },
    },
    {
      field: 'acciones',
      headerName: 'Acciones',
      headerClass: 'centrarencabezado',
      width: 100,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: AccionesEditarComponent,
      cellRendererParams: {
        context: {
          componentParent: this,
          ejercicioCerrado: this.ejercicioCerrado
        }
      }
    },
  ];


  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService,
  ) { }

  ngOnInit() {
    const currentYear = new Date().getFullYear();

    // Crear fechas como strings ISO para evitar problemas de zona horaria
    const startDate = new Date(currentYear, 0, 1);
    const endDate = new Date(currentYear, 11, 31);

    this.fechaInicio = startDate;
    this.fechaFin = endDate;

    this.EjercicioFiscalForm = this.formBuilder.group({
      nombre: ['', Validators.required],
      periocidad: ['', Validators.required],
      estado: [{ value: 'Abierto', disabled: true }],
      cierre: ['', Validators.required],
      fechaInicioInput: [''],
      fechaFinInput: [''],
      periocidadInput: [''],
      cierreInput: ['']
    });

    // Establecer el valor del estado después de crear el formulario
    this.EjercicioFiscalForm.get('estado')?.setValue('Abierto');

    // Inicializar servicio de validación
    this.formValidationService.inicializarFormulario(this.EjercicioFiscalForm);
    this.formValidationService.resetearEstado();

    // Limpiar estado previo para forzar loader en cada entrada
    this.configuracionFacade.clearEjerciciosFiscales();
    
    // Cargar ejercicios fiscales desde el store
    this.configuracionFacade.cargarEjerciciosFiscales();

    // Inicializar estado por defecto como nuevo
    this.camponuevo = true;

    // Cargar datos iniciales por defecto (Mensual)
    this.actualizarRowDataDetalle('Mensual');
  }

  onFechaInicio(date: Date) {
    // Asegurar que la fecha se guarde sin desplazamientos de zona horaria
    const selectedDate = new Date(date);
    selectedDate.setHours(0, 0, 0, 0);
    this.fechaInicio = selectedDate;
  }

  onFechaFin(date: Date) {
    // Asegurar que la fecha se guarde sin desplazamientos de zona horaria
    const selectedDate = new Date(date);
    selectedDate.setHours(0, 0, 0, 0);
    this.fechaFin = selectedDate;
  }

  onBtReset(): void {
    this.isResetting = true;
    this.configuracionFacade.cargarEjerciciosFiscales();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.ejerciciosGridEffects.setGridApi(params.api);
    // Restaurar la fila seleccionada al volver/desplegar la pantalla (por referencia de objeto)
    if (this.filaSeleccionada) {
      const prevData = this.filaSeleccionada;
      setTimeout(() => {
        this.gridApi?.forEachNode((node) => {
          if (node.data === prevData) {
            node.setSelected(true);
          }
        });
      }, 0);
    }
  }

  async onCellClicked(event: any) {
    const data = event.data;
    const clickedNode = event.node;
    if (!data) { return; }

    // Guardar referencia del elemento que tiene el foco
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar cambios ANTES de cualquier operación de grid
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Re-seleccionar la fila anterior por referencia de objeto
      if (this.filaSeleccionada) {
        const prevData = this.filaSeleccionada;
        setTimeout(() => {
          this.gridApi?.deselectAll();
          this.gridApi?.forEachNode((node) => {
            if (node.data === prevData) {
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

    // Usuario confirmó - cargar nuevos datos
    this.filaSeleccionada = data;
    this.modoCreacion = false;
    this.camponuevo = false;

    // Pausar detección para que patchValue/disable/enable no marque el formulario como modificado
    this.formValidationService.pausarDeteccion();

    // Cargar el nombre del ejercicio
    this.EjercicioFiscalForm.patchValue({
      nombre: data?.ejercicio_fiscal_nombre || '',
      periocidad: data?.ejercicio_fiscal_periocidad || '',
      cierre: data?.ejercicio_fiscal_cierre || ''
    });

    // Verificar si el ejercicio está cerrado
    this.ejercicioCerrado = data?.ejercicio_fiscal_estado === 'Cerrado';

    // Deshabilitar o habilitar el formulario según el estado
    if (this.ejercicioCerrado) {
      this.EjercicioFiscalForm.disable();

      // Cargar las fechas en los inputs cuando está cerrado
      if (data.ejercicio_fiscal_fecha_inicio) {
        const fechaInicio = new Date(data.ejercicio_fiscal_fecha_inicio);
        const fechaInicioStr = `${String(fechaInicio.getDate()).padStart(2, '0')}/${String(fechaInicio.getMonth() + 1).padStart(2, '0')}/${fechaInicio.getFullYear()}`;
        this.EjercicioFiscalForm.get('fechaInicioInput')?.setValue(fechaInicioStr);
      }
      if (data.ejercicio_fiscal_fecha_fin) {
        const fechaFin = new Date(data.ejercicio_fiscal_fecha_fin);
        const fechaFinStr = `${String(fechaFin.getDate()).padStart(2, '0')}/${String(fechaFin.getMonth() + 1).padStart(2, '0')}/${fechaFin.getFullYear()}`;
        this.EjercicioFiscalForm.get('fechaFinInput')?.setValue(fechaFinStr);
      }

      // Cargar periodicidad y cierre en los inputs
      if (data.ejercicio_fiscal_periocidad) {
        this.EjercicioFiscalForm.get('periocidadInput')?.setValue(data.ejercicio_fiscal_periocidad);
      }
      if (data.ejercicio_fiscal_cierre) {
        this.EjercicioFiscalForm.get('cierreInput')?.setValue(data.ejercicio_fiscal_cierre);
      }
    } else {
      this.EjercicioFiscalForm.enable();
      // Mantener el estado siempre deshabilitado
      this.EjercicioFiscalForm.get('estado')?.disable();
      // Limpiar los inputs de fecha
      this.EjercicioFiscalForm.get('fechaInicioInput')?.setValue('');
      this.EjercicioFiscalForm.get('fechaFinInput')?.setValue('');
      this.EjercicioFiscalForm.get('periocidadInput')?.setValue('');
      this.EjercicioFiscalForm.get('cierreInput')?.setValue('');
    }

    // Mostrar la tabla de periodos según la periodicidad del ejercicio seleccionado
    if (data && data.ejercicio_fiscal_periocidad) {
      this.tipoSeleccionado = data.ejercicio_fiscal_periocidad;

      // Si el ejercicio tiene periodos guardados, cargarlos. Si no, usar los datos por defecto
      if (data.ejercicio_fiscal_periodos && data.ejercicio_fiscal_periodos.length > 0) {
        this.rowDataActual = data.ejercicio_fiscal_periodos;
        if (this.gridApiDetalle) {
          this.gridApiDetalle.setGridOption('rowData', data.ejercicio_fiscal_periodos);
        }
      } else {
        this.actualizarRowDataDetalle(data.ejercicio_fiscal_periocidad);
      }

      this.periodosGenerados = true;
    }

    // Seleccionar la fila y reanudar la detección de cambios
    setTimeout(() => {
      this.gridApi?.deselectAll();
      clickedNode?.setSelected(true);
      this.formValidationService.reanudarDeteccion();
    }, 0);
  }

  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApiDetalle = params.api;
  }

  onCellClickedDetalle(event: any) {
    if (event.data) {
      console.log('Período seleccionado:', event.data);
    }
  }

  actualizarRowDataDetalle(periocidad: string) {
    let nuevoRowData: any[] = [];
    if (periocidad === 'Mensual') {
      nuevoRowData = this.rowDataMen;
    } else if (periocidad === 'Bimensual') {
      nuevoRowData = this.rowDataBim;
    } else if (periocidad === 'Trimestral') {
      nuevoRowData = this.rowDataTri;
    } else if (periocidad === 'Cuatrimestral') {
      nuevoRowData = this.rowDataCuatri;
    } else if (periocidad === 'Semestral') {
      nuevoRowData = this.rowDataSem;
    } else if (periocidad === 'Anual') {
      nuevoRowData = this.rowDataAnual;
    }
    if (this.gridApiDetalle) {
      this.gridApiDetalle.setGridOption('rowData', nuevoRowData);
    }
  }

  onTipoChange() {
    this.filasGeneradas = [];
  }

  onPeriocidadChange(periocidad: string) {
    this.tipoSeleccionado = periocidad;
    this.actualizarRowDataDetalle(periocidad);
  }

  generarPeriodos() {
    // Validar que el formulario tenga datos
    if (!this.EjercicioFiscalForm.get('nombre')?.value) {
      return;
    }

    // Validar que se haya seleccionado una periodicidad
    if (!this.EjercicioFiscalForm.get('periocidad')?.value) {
      return;
    }

    // Asignar el rowData correcto según la periodicidad seleccionada
    if (this.tipoSeleccionado === 'Mensual') {
      this.rowDataActual = this.rowDataMen;
    } else if (this.tipoSeleccionado === 'Bimensual') {
      this.rowDataActual = this.rowDataBim;
    } else if (this.tipoSeleccionado === 'Trimestral') {
      this.rowDataActual = this.rowDataTri;
    } else if (this.tipoSeleccionado === 'Cuatrimestral') {
      this.rowDataActual = this.rowDataCuatri;
    } else if (this.tipoSeleccionado === 'Semestral') {
      this.rowDataActual = this.rowDataSem;
    } else if (this.tipoSeleccionado === 'Anual') {
      this.rowDataActual = this.rowDataAnual;
    }
    this.periodosGenerados = true;
    if (this.gridApiDetalle) {
      this.gridApiDetalle.setGridOption('rowData', this.rowDataActual);
    }
  }

  guardarEjercicio() {
    // Marcar todos los campos como tocados para mostrar errores
    Object.keys(this.EjercicioFiscalForm.controls).forEach(key => {
      this.EjercicioFiscalForm.get(key)?.markAsTouched();
    });

    // Validar todos los campos obligatorios
    const nombre = this.EjercicioFiscalForm.get('nombre')?.value;
    const periocidad = this.EjercicioFiscalForm.get('periocidad')?.value;

    if (!nombre || !this.fechaInicio || !this.fechaFin || !periocidad ) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    // Validar que se hayan generado los periodos
    if (!this.periodosGenerados || this.rowDataActual.length === 0) {
      this.toastService.warning('Por favor, genera los periodos antes de guardar');
      return;
    }

    const nuevoEjercicio: EjercicioFiscalEntity = {
      ejercicio_fiscal_nombre: nombre,
      ejercicio_fiscal_fecha_inicio: this.fechaInicio ? this.fechaInicio.toISOString().split('T')[0] : '',
      ejercicio_fiscal_fecha_fin: this.fechaFin ? this.fechaFin.toISOString().split('T')[0] : '',
      ejercicio_fiscal_periocidad: this.tipoSeleccionado,
      ejercicio_fiscal_estado: 'Abierto',
      ejercicio_fiscal_periodos: [...this.rowDataActual] // Guardar los periodos generados
    };

    // Obtener datos actuales del effect y agregar nuevo ejercicio
    const currentData = this.ejerciciosGridEffects.getRowData();
    const updatedData = [...currentData, nuevoEjercicio];
    this.ejerciciosGridEffects.setRowData(updatedData);

    // Limpiar formulario primero para registro rápido
    this.camponuevo = false;
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.periodosGenerados = false;
    this.EjercicioFiscalForm.reset();
    this.EjercicioFiscalForm.get('estado')?.setValue('Abierto');
    const currentYear = new Date().getFullYear();
    this.fechaInicio = new Date(currentYear, 0, 1);
    this.fechaFin = new Date(currentYear, 11, 31);

    // Desmarcar en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Limpiar tabla de periodos
    if (this.gridApiDetalle) {
      this.gridApiDetalle.setGridOption('rowData', []);
    }

    // Luego resetear servicio de validación
    this.formValidationService.resetearEstado();

    this.toastService.success('¡Ejercicio fiscal registrado exitosamente!');
  }

  async botonCancelar() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    this.EjercicioFiscalForm.reset();
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.camponuevo = false;
    this.fechaInicio = undefined;
    this.fechaFin = undefined;
    this.periodosGenerados = false;
    
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    if (this.gridApiDetalle) {
      this.gridApiDetalle.setGridOption('rowData', []);
    }
    
    this.formValidationService.resetearEstado();
  }





  async nuevoEjercicioFiscal(): Promise<void> {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Usuario canceló
    }

    // Limpiar formulario
    this.EjercicioFiscalForm.reset();
    this.EjercicioFiscalForm.enable();
    this.EjercicioFiscalForm.get('estado')?.setValue('Abierto');
    this.EjercicioFiscalForm.get('estado')?.disable();

    // Resetear fechas al año actual
    const currentYear = new Date().getFullYear();
    this.fechaInicio = new Date(currentYear, 0, 1);
    this.fechaFin = new Date(currentYear, 11, 31);

    // Resetear estados
    this.camponuevo = true;
    this.modoCreacion = true;
    this.periodosGenerados = false;
    this.ejercicioCerrado = false;
    this.filaSeleccionada = null;

    // Desmarcar fila seleccionada en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Limpiar tabla de periodos
    if (this.gridApiDetalle) {
      this.gridApiDetalle.setGridOption('rowData', []);
    }

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  togglePanelLateral(): void {
    this.panelLateralVisible = !this.panelLateralVisible;

  }

  async modalverActualizaciones(): Promise<void> {
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'historial_actualizacion_fecha_hora', width: 150, },
      { headerName: 'Usuario', field: 'historial_actualizacion_usuario', width: 120, },
      {
        headerName: 'Acción', field: 'historial_actualizacion_accion', width: 150,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
      {
        headerName: 'Detalle del cambio', field: 'historial_actualizacion_detalle_cambio', flex: 1,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
    ];

    const rowData = [
      { historial_actualizacion_fecha_hora: '12/11/2025 10:30', historial_actualizacion_usuario: 'Juan Pérez', historial_actualizacion_accion: 'Creación', historial_actualizacion_detalle_cambio: 'Registro inicial del siniestro'},
      { historial_actualizacion_fecha_hora: '12/11/2025 14:15', historial_actualizacion_usuario: 'María González', historial_actualizacion_accion: 'Actualización', historial_actualizacion_detalle_cambio: 'Cambio de estado de "Reportado" a "En evaluación"'},
      { historial_actualizacion_fecha_hora: '13/11/2025 09:00', historial_actualizacion_usuario: 'Carlos Rodríguez', historial_actualizacion_accion: 'Actualización', historial_actualizacion_detalle_cambio: 'Agregó documentación de respaldo (3 archivos)'},
      { historial_actualizacion_fecha_hora: '13/11/2025 16:45', historial_actualizacion_usuario: 'Ana Martínez', historial_actualizacion_accion: 'Actualización', historial_actualizacion_detalle_cambio: 'Cambio de estado de "En evaluación" a "Aprobado"' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones del ejercicio fiscal ${this.filaSeleccionada?.ejercicio_fiscal_nombre}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }

  // Función que será llamada por AccionesEditarComponent
  onEditar(data: any): void {
    this.abrirModadEditarPeriodo(data);
  }

  async abrirModadEditarPeriodo(data?: any): Promise<void> {
    console.log('Abriendo modal para editar periodo:', data);

    const modal = await this.modalController.create({
      component: ModalEditarPeriodoComponent,
      cssClass: 'promo2',
      componentProps: {
        data: data,
      }
    });

    // Capturar los datos retornados del modal
    modal.onDidDismiss().then((result) => {
      if (result.role === 'guardar' && result.data) {
        console.log('Datos guardados del modal:', result.data);
        // Actualizar la fila en el ag-grid
        this.actualizarFilaEnGrid(data, result.data);
      }
    });

    await modal.present();
  }

  actualizarFilaEnGrid(datosOriginales: any, datosActualizados: any): void {
    // Si hay una fila seleccionada en la tabla principal (ejercicio)
    if (this.filaSeleccionada && this.filaSeleccionada.ejercicio_fiscal_periodos) {
      // Encontrar el período en el array de períodos del ejercicio seleccionado
      const indexPeriodo = this.filaSeleccionada.ejercicio_fiscal_periodos.findIndex(
        (periodo: any) => periodo.periodo_fiscal_codigo === datosOriginales.periodo_fiscal_codigo
      );

      if (indexPeriodo !== -1) {
        // Actualizar el período con los nuevos datos
        this.filaSeleccionada.ejercicio_fiscal_periodos[indexPeriodo] = {
          ...this.filaSeleccionada.ejercicio_fiscal_periodos[indexPeriodo],
          periodo_fiscal_nombre: datosActualizados.modalNombre,
          recordatorioDias: datosActualizados.recordatorioDias,
          periodo_fiscal_cierre: datosActualizados.cierresModulos
        };

        // Notificar al ag-grid de detalles que se actualizó la data
        this.gridApiDetalle?.setGridOption('rowData', this.filaSeleccionada.ejercicio_fiscal_periodos);
      }
    } else {
      // Si no, buscar en el rowDataActual
      const indexPeriodo = this.rowDataActual.findIndex(
        (periodo: any) => periodo.periodo_fiscal_codigo === datosOriginales.periodo_fiscal_codigo
      );

      if (indexPeriodo !== -1) {
        this.rowDataActual[indexPeriodo] = {
          ...this.rowDataActual[indexPeriodo],
          periodo_fiscal_nombre: datosActualizados.modalNombre,
          recordatorioDias: datosActualizados.recordatorioDias,
          periodo_fiscal_cierre: datosActualizados.cierresModulos
        };

        this.gridApiDetalle?.setGridOption('rowData', this.rowDataActual);
      }
    }
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

}
