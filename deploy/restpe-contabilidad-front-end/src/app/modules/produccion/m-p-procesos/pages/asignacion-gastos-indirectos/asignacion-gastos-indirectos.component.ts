import { Component, ElementRef, OnInit, OnDestroy, ViewChild, inject } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { AutocompleteComponent } from 'src/app/ui/autocomplete/autocomplete.component';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ModalDetalleComponent, DetalleItem } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { BotonAccionesComponent } from 'src/app/ui/boton-acciones/boton-acciones.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ProduccionFacade } from 'src/app/modules/produccion/application/facades/produccion.facade';
import { ProduccionAsignacionGridEffects } from 'src/app/modules/produccion/effects/produccion-asignacion-grid.effect';
import { ReglaAsignacionEntity, IProductoElaboradoEntity } from 'src/app/modules/produccion/domain/models/regla-asignacion.entity';
import { IBaseProrrateo, ICentroCosto } from 'src/app/modules/produccion/domain/models/asignacion-gastos-indirectos.models';

// Font Awesome Icons
import { faBook, faEye, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-asignacion-gastos-indirectos',
  templateUrl: './asignacion-gastos-indirectos.component.html',
  styleUrls: ['./asignacion-gastos-indirectos.component.scss'],
  standalone: false,
})
export class AsignacionGastosIndirectosComponent implements OnInit, OnDestroy {
  // Facades y Effects
  private readonly produccionFacade = inject(ProduccionFacade);
  private readonly asignacionGridEffects = inject(ProduccionAsignacionGridEffects);

  // Selectores del store
  readonly isLoading = this.produccionFacade.isLoading;

  get rowData(): ReglaAsignacionEntity[] {
    return this.asignacionGridEffects.getRowData();
  }

  // Font Awesome Icons
  farBook = faBook;
  farEye = faEye;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  @ViewChild('scrollBox', { read: ElementRef }) scrollBox!: ElementRef;
  @ViewChild('autocompleteProductos') autocompleteProductos!: AutocompleteComponent;

  // RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  // ESTADO DEL COMPONENTE
  isResetting = false;
  filaSeleccionada: ReglaAsignacionEntity | null = null;
  selectedRowIndex: number | null = null;
  panelLateralVisible = true;
  cargando = false;
  mostrarBuscadorPrincipal = true;
  botonGuardarHabilitado = false;
  botonInactivarHabilitado = false;
  modoCreacion = true;
  mostrarCampoPorcentaje = false;
  periodoMes: number | null = null;
  periodoAnio: number | null = null;

  // FORMULARIO
  AsignacionGastosForm!: FormGroup;

  // GRID
  private gridApi!: GridApi;
  private gridApiProductos!: GridApi;

  gridOptions = {
    context: {
      componentParent: this,
    }
  };

  gridOptionsProductos = {
    context: {
      componentParent: this,
    }
  };

  rowDataProductos: IProductoElaboradoEntity[] = [];

  // OPCIONES PARA SELECTORES
  periodosContables: any[] = [
    { id: 1, codigo: '202501', nombre: 'Enero 2025' },
    { id: 2, codigo: '202502', nombre: 'Febrero 2025' },
    { id: 3, codigo: '202503', nombre: 'Marzo 2025' },
    { id: 4, codigo: '202504', nombre: 'Abril 2025' },
    { id: 5, codigo: '202505', nombre: 'Mayo 2025' },
    { id: 6, codigo: '202506', nombre: 'Junio 2025' },
    { id: 7, codigo: '202507', nombre: 'Julio 2025' },
    { id: 8, codigo: '202508', nombre: 'Agosto 2025' },
    { id: 9, codigo: '202509', nombre: 'Septiembre 2025' },
    { id: 10, codigo: '202510', nombre: 'Octubre 2025' },
    { id: 11, codigo: '202511', nombre: 'Noviembre 2025' },
    { id: 12, codigo: '202512', nombre: 'Diciembre 2025' },
  ];

  basesProrrateo: IBaseProrrateo[] = [
    { id: 1, nombre: 'Horas -  Hombre' },
    { id: 2, nombre: 'Horas - Máquina' },
    { id: 3, nombre: 'Unidades producidas' },
    { id: 4, nombre: 'Participación por receta' },
    { id: 5, nombre: 'Costos de insumos' },
    { id: 6, nombre: 'Porcentaje manual' },
  ];

  centrosCosto: ICentroCosto[] = [
    { id: 1, nombre: 'Operaciones', codigo: 'OP-001' },
    { id: 2, nombre: 'Marketing', codigo: 'MK-001' },
    { id: 3, nombre: 'Administración', codigo: 'AD-001' },
    { id: 4, nombre: 'Cocina', codigo: 'CO-001' },
  ];

  cuentasContables: any[] = [
    { id: 1, codigo: '68101', nombre: '68101 - Depreciación del ejercicio' },
    { id: 2, codigo: '21101', nombre: '21101 - Productos terminados' },
    { id: 3, codigo: '60101', nombre: '60101 - Compras' },
    { id: 4, codigo: '40111', nombre: '40111 - Gobierno Nacional' },
  ];

  productosDisponibles: any[] = [
    { id: 1, codigo: 'PROD-001', nombre: 'Hamburguesa clásica', montoTotal: 5000, montoUND: 5000, montoDepreciacion: 1250.00, importeAsigGIF: 10.42 },
    { id: 2, codigo: 'PROD-002', nombre: 'Hamburguesa Royal', montoTotal: 5000, montoUND: 5000, montoDepreciacion: 1250.00, importeAsigGIF: 10.42 },
    { id: 3, codigo: 'PROD-003', nombre: 'Hamburguesa Ontaneda', montoTotal: 5000, montoUND: 5000, montoDepreciacion: 1250.00, importeAsigGIF: 10.42 },
    { id: 4, codigo: 'PROD-004', nombre: 'Hamburguesa doble carne sabor a Chijaukay', montoTotal: 5000, montoUND: 5000, montoDepreciacion: 1250.00, importeAsigGIF: 10.42 },
    { id: 5, codigo: 'PROD-005', nombre: 'Hamburguesa de Pechuga de Pollo', montoTotal: 5000, montoUND: 5000, montoDepreciacion: 1250.00, importeAsigGIF: 10.42 },
    { id: 6, codigo: 'PROD-006', nombre: 'Hamburguesa de Tocino y Huevo', montoTotal: 5000, montoUND: 5000, montoDepreciacion: 1250.00, importeAsigGIF: 10.42 },
  ];

  opcionesGIF: any[] = [
    { value: 'amortizacion', label: 'Amortización' },
    { value: 'depreciacion', label: 'Depreciación' },
    { value: 'alquiler_servicios', label: 'Alquiler de servicios' },
    { value: 'otros', label: 'Otros' },
  ];

  // DEFINICIÓN DE COLUMNAS GRID PRINCIPAL
  colDefs: ColDef[] = [
    { field: 'regla_asignacion_gif_codigo', headerName: 'Código', width: 110 },
    { field: 'regla_asignacion_gif_centro_costo', headerName: 'Centro de costo', flex: 1, filter: true, minWidth: 150 },
    { field: 'regla_asignacion_gif_periodo_cont', headerName: 'Periodo contable', width: 120, filter: true },
    { field: 'regla_asignacion_gif_base_prorrateo', headerName: 'Base de prorrateo', flex: 1 },
    { field: 'regla_asignacion_gif_cantidad_productos', headerName: 'Cantidad prod.', width: 110 },
    { field: 'regla_asignacion_gif_depreciacion', headerName: 'Depreciación', width: 110, 
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
          return `S/(${formattedValue})`;
        }
          return `S/${formattedValue}`;
      }
      return '';
    },
    cellStyle: (params) => {
      const style: any = { justifyContent: 'end', };
      if (params.value < 0) {
        style.color = '#EF4444'; // Rojo para negativos
      }
      return style;
    } },
    { field: 'regla_asignacion_gif_fecha_creacion', headerName: 'Fecha de creación', width: 130 },
    {
      field: 'regla_asignacion_gif_estado',
      filter: true,
      headerName: 'Estado',
      headerClass: 'centrarencabezado',
      width: 80,
      cellRenderer: (params: any) => {
        const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  // DEFINICIÓN DE COLUMNAS TABLA PRODUCTOS
  colDefsProductos: ColDef[] = [
    { field: 'producto_elaborado_codigo', headerName: 'Código', width: 110, editable: false },
    { field: 'producto_elaborado_nombre_producto', headerName: 'Nombre de producto', flex: 1, minWidth: 200, editable: false },
    { field: 'producto_elaborado_base_prorrateo', headerName: 'Base de prorrateo', flex: 1, minWidth: 180, editable: false },
    { 
      field: 'producto_elaborado_cantidad_total', 
      headerName: 'Cant. total', 
      headerClass: 'derechaencabezado',
      width: 100, 
      editable: true,
      cellStyle: { justifyContent: 'end' }
    },
    { 
      field: 'producto_elaborado_monto_total', 
      headerName: 'Monto total', 
      width: 110, 
      editable: false,
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
            return `S/(${formattedValue})`;
          }
          return `S/${formattedValue}`;
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
      field: 'producto_elaborado_monto_unitario', 
      headerName: 'Monto x UND', 
      width: 110, 
      editable: false,
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
            return `S/(${formattedValue})`;
          }
          return `S/${formattedValue}`;
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
      field: 'producto_elaborado_importe_asignado_gif', 
      headerName: 'Importe asig. de GIF', 
      headerClass: 'derechaencabezado',
      width: 140, 
      editable: false,
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
          return `${formattedValue}`;
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
      field: 'producto_elaborado_estado',
      headerName: 'Estado',
      headerClass: 'centrarencabezado',
      width: 90,
      editable: false,
      cellRenderer: (params: any) => {
        const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
    {
      field: 'accion',
      headerName: 'Acción',
      headerClass: 'centrarencabezado',
      width: 80,
      editable: false,
      cellRenderer: BotonAccionesComponent,
      cellRendererParams: {
        onDeleteClick: this.eliminarProducto.bind(this)
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
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

  constructor(
    private toastService: ToastService,
    private modalController: ModalController,
    private formBuilder: FormBuilder,
    private formValidationService: FormValidationService
  ) {
    this.minDate = new Date(2020, 0, 1);
    this.maxDate = new Date();
    this.startDate = new Date(2025, 0, 1);
    this.endDate = new Date(2025, 0, 31);
  }

  ngOnInit() {
    this.inicializarFormulario();
    
    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.AsignacionGastosForm);
    this.formValidationService.resetearEstado();
    
    this.botonNuevaRegla();

    // Cargar reglas de asignación desde el JSON a través de la capa de infraestructura
    this.produccionFacade.cargarReglasAsignacion();
  }

  inicializarFormulario() {
    // Generar fecha de hoy formateada
    const today = new Date();
    const fechaFormateada = today.toLocaleDateString('es-PE');
    
    this.AsignacionGastosForm = this.formBuilder.group({
      fechaCreacion: [{ value: fechaFormateada, disabled: true }, Validators.required],
      periodoCont: ['', Validators.required],
      centroCosto: [''],
      baseProrrateo: ['', Validators.required],
      cuentaContableOrigen: ['', Validators.required],
      cuentaContableDestino: ['', Validators.required],
      montoDep: ['', Validators.required],
      montoDistribuir: [{ value: '', disabled: true }],
      porcentaje: [''],
      gifPeriodo: ['depreciacion', Validators.required],
      numeroAsiento: [''],
      estado: ['Activo']
    });

    // Escuchar cambios en baseProrrateo para mostrar/ocultar campo porcentaje
    this.AsignacionGastosForm.get('baseProrrateo')?.valueChanges.subscribe(value => {
      this.mostrarCampoPorcentaje = value === 'Porcentaje manual';
      if (this.mostrarCampoPorcentaje) {
        this.AsignacionGastosForm.get('porcentaje')?.setValidators([Validators.required]);
      } else {
        this.AsignacionGastosForm.get('porcentaje')?.clearValidators();
        this.AsignacionGastosForm.get('porcentaje')?.setValue('');
      }
      this.AsignacionGastosForm.get('porcentaje')?.updateValueAndValidity();
    });
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  onPeriodoChange(event: { month: number; year: number }) {
    this.periodoMes = event.month;
    this.periodoAnio = event.year;
    const periodoFormateado = `${event.year}${event.month.toString().padStart(2, '0')}`;
    this.AsignacionGastosForm.patchValue({
      periodoCont: periodoFormateado
    });
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.asignacionGridEffects.setGridApi(params.api);
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

  onGridReadyProductos(params: GridReadyEvent) {
    this.gridApiProductos = params.api;
  }

  onBtReset() {
    this.isResetting = true;
    this.produccionFacade.cargarReglasAsignacion();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

  filtrarPorFechas(event: any) {
    console.log('Rango de fechas seleccionado:', event);
    this.startDate = event.startDate;
    this.endDate = event.endDate;
  }

  async onCellClicked(event: any) {
    if (!event.data) return;

    const clickedNode = event.node;

    // Validar cambios antes de cambiar de regla
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Usuario canceló - restaurar fila anterior por referencia de objeto
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
      return;
    }

    // Usuario confirmó - cargar datos y seleccionar la nueva fila
    this.filaSeleccionada = event.data;
    this.cargarDatosRegistro(event.data);
    setTimeout(() => {
      this.gridApi?.deselectAll();
      clickedNode?.setSelected(true);
    }, 0);
  }

  onSelectionChanged(event: any) {
    // Este método ya no es necesario para la lógica de selección
    // pero lo mantenemos para posibles usos futuros
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: any): void {
    this.modoCreacion = false;
    this.filaSeleccionada = data;
    if (data.regla_asignacion_gif_periodo_cont) {
      const periodo = data.regla_asignacion_gif_periodo_cont.toString();
      this.periodoAnio = parseInt(periodo.substring(0, 4));
      this.periodoMes = parseInt(periodo.substring(4, 6));
    }

    // Cargar datos en el formulario
    this.AsignacionGastosForm.patchValue({
      fechaCreacion: data.regla_asignacion_gif_fecha_creacion,
      periodoCont: data.regla_asignacion_gif_periodo_cont,
      centroCosto: data.regla_asignacion_gif_centro_costo || '',
      baseProrrateo: data.regla_asignacion_gif_base_prorrateo,
      cuentaContableOrigen: data.regla_asignacion_gif_cuenta_contable_origen || '',
      cuentaContableDestino: data.regla_asignacion_gif_cuenta_contable_destino || '',
      montoDep: data.regla_asignacion_gif_monto_depreciacion || '',
      porcentaje: data.regla_asignacion_gif_porcentaje || '',
      numeroAsiento: data.regla_asignacion_gif_numero_asiento || '',
      estado: data.regla_asignacion_gif_estado
    });

    // Cargar productos elaborados en la tabla
    this.rowDataProductos = data.regla_asignacion_gif_productos_elaborados || [];
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', this.rowDataProductos);
    }

    // Habilitar botones según el estado
    this.botonGuardarHabilitado = data.regla_asignacion_gif_estado === 'Activo';
    this.botonInactivarHabilitado = data.regla_asignacion_gif_estado === 'Activo';
    
    // Resetear servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }

  async botonNuevaRegla() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    this.modoCreacion = true;
    // Limpiar selección
    this.filaSeleccionada = null;
    this.selectedRowIndex = null;
    this.periodoMes = null;
    this.periodoAnio = null;
    
    if (this.gridApi) {
      this.gridApi.deselectAll();
      this.gridApi.redrawRows();
    }

    // Limpiar formulario con fecha actual
    const today = new Date();
    const fechaFormateada = today.toLocaleDateString('es-PE');
    
    this.AsignacionGastosForm.reset({
      fechaCreacion: fechaFormateada,
      periodoCont: '',
      centroCosto: '',
      baseProrrateo: '',
      cuentaContableOrigen: '',
      cuentaContableDestino: '',
      montoDep: '',
      porcentaje: '',
      numeroAsiento: '',
      estado: 'Activo'
    });

    // Limpiar tabla de productos
    this.rowDataProductos = [];
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', []);
    }

    // Habilitar botón guardar
    this.botonGuardarHabilitado = true;
    this.botonInactivarHabilitado = false;
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();

    console.log('Crear nueva regla de asignación');
  }

  async botonCancelar() {
    // Validar cambios antes de cancelar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Si cancela, deseleccionar la fila
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }
      return; // Cancelar acción
    }
    
    // Limpiar todo
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.selectedRowIndex = null;
    this.periodoMes = null;
    this.periodoAnio = null;
    
    const today = new Date();
    const fechaFormateada = today.toLocaleDateString('es-PE');
    
    this.AsignacionGastosForm.reset({
      fechaCreacion: fechaFormateada,
      periodoCont: '',
      centroCosto: '',
      baseProrrateo: '',
      cuentaContableOrigen: '',
      cuentaContableDestino: '',
      montoDep: '',
      porcentaje: '',
      numeroAsiento: '',
      estado: 'Activo'
    });

    this.rowDataProductos = [];
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', []);
    }

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    this.botonGuardarHabilitado = true;
    this.botonInactivarHabilitado = false;
    
    this.formValidationService.resetearEstado();
  }

  guardarRegla() {
    if (this.AsignacionGastosForm.invalid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    const formValue = this.AsignacionGastosForm.value;

    if (!this.modoCreacion && this.filaSeleccionada) {
      // Editar regla existente
      const rowData = this.asignacionGridEffects.getRowData();
      const index = rowData.findIndex(r => r.regla_asignacion_gif_codigo === this.filaSeleccionada!.regla_asignacion_gif_codigo);
      
      if (index !== -1) {
        // Actualizar datos en el array
        const updatedData = [...rowData];
        updatedData[index] = {
          ...updatedData[index],
          regla_asignacion_gif_periodo_cont: formValue.periodoCont,
          regla_asignacion_gif_centro_costo: formValue.centroCosto || '',
          regla_asignacion_gif_base_prorrateo: formValue.baseProrrateo,
          regla_asignacion_gif_cuenta_contable_origen: formValue.cuentaContableOrigen,
          regla_asignacion_gif_cuenta_contable_destino: formValue.cuentaContableDestino,
          regla_asignacion_gif_monto_depreciacion: formValue.montoDep,
          regla_asignacion_gif_porcentaje: formValue.porcentaje || null,
          regla_asignacion_gif_numero_asiento: formValue.numeroAsiento || '',
          regla_asignacion_gif_depreciacion: formValue.montoDep,
          regla_asignacion_gif_cantidad_productos: this.rowDataProductos.length,
          regla_asignacion_gif_productos_elaborados: [...this.rowDataProductos],
        };

        // Actualizar fila seleccionada
        this.filaSeleccionada = updatedData[index];

        // Refrescar grid via effect
        this.asignacionGridEffects.setRowData(updatedData);
        setTimeout(() => {
          this.gridApi?.forEachNode((node) => {
            if (node.data.regla_asignacion_gif_codigo === this.filaSeleccionada?.regla_asignacion_gif_codigo) {
              node.setSelected(true);
            }
          });
        }, 100);
      }

      this.toastService.success('¡Regla de asignación actualizada exitosamente!');
      
      // Marcar como pristine después de guardar edición
      this.AsignacionGastosForm.markAsPristine();
      
      // Resetear servicio de validación
      this.formValidationService.resetearEstado();
    } else {
      // Crear nueva regla
      const currentRowData = this.asignacionGridEffects.getRowData();
      const nuevoCodigoNumero = currentRowData.length + 1;
      const codigoFormateado = `GAF-2025-${nuevoCodigoNumero.toString().padStart(3, '0')}`;
      
      // Generar número de asiento contable automáticamente
      const numeroAsientoGenerado = this.generarNumeroAsiento();

      const nuevaRegla: ReglaAsignacionEntity = {
        regla_asignacion_gif_codigo: codigoFormateado,
        regla_asignacion_gif_fecha_creacion: formValue.fechaCreacion,
        regla_asignacion_gif_periodo_cont: formValue.periodoCont,
        regla_asignacion_gif_centro_costo: formValue.centroCosto || '',
        regla_asignacion_gif_base_prorrateo: formValue.baseProrrateo,
        regla_asignacion_gif_cuenta_contable_origen: formValue.cuentaContableOrigen,
        regla_asignacion_gif_cuenta_contable_destino: formValue.cuentaContableDestino,
        regla_asignacion_gif_monto_depreciacion: formValue.montoDep,
        regla_asignacion_gif_porcentaje: formValue.porcentaje || null,
        regla_asignacion_gif_numero_asiento: numeroAsientoGenerado,
        regla_asignacion_gif_depreciacion: formValue.montoDep,
        regla_asignacion_gif_cantidad_productos: this.rowDataProductos.length,
        regla_asignacion_gif_estado: 'Activo',
        regla_asignacion_gif_productos_elaborados: [...this.rowDataProductos],
      };

      // Agregar al array via effect
      this.asignacionGridEffects.setRowData([nuevaRegla, ...currentRowData]);

      this.toastService.success('¡Regla de asignación registrada exitosamente!');
      
      // Limpiar para registro rápido
      this.modoCreacion = true;
      this.filaSeleccionada = null;
      this.selectedRowIndex = null;
      this.periodoMes = null;
      this.periodoAnio = null;
      
      if (this.gridApi) {
        this.gridApi.deselectAll();
        this.gridApi.redrawRows();
      }

      const today = new Date();
      const fechaFormateada = today.toLocaleDateString('es-PE');
      
      this.AsignacionGastosForm.reset({
        fechaCreacion: fechaFormateada,
        periodoCont: '',
        centroCosto: '',
        baseProrrateo: '',
        cuentaContableOrigen: '',
        cuentaContableDestino: '',
        montoDep: '',
        porcentaje: '',
        numeroAsiento: '',
        estado: 'Activo'
      });

      this.rowDataProductos = [];
      if (this.gridApiProductos) {
        this.gridApiProductos.setGridOption('rowData', []);
      }

      this.botonGuardarHabilitado = true;
      this.botonInactivarHabilitado = false;
      
      // Resetear servicio de validación
      this.formValidationService.resetearEstado();
    }
  }

  // Método para verificar si se puede guardar (formulario válido y modificado)
  puedeGuardar(): boolean {
    return this.AsignacionGastosForm.valid && this.AsignacionGastosForm.dirty;
  }

  async inactivarRegla() {
    if (!this.filaSeleccionada) {
      this.toastService.warning('Seleccione una regla para inactivar');
      return;
    }

    const detalles: DetalleItem[] = [
      { label: 'Código', value: this.filaSeleccionada.regla_asignacion_gif_codigo },
      { label: 'Periodo contable', value: this.filaSeleccionada.regla_asignacion_gif_periodo_cont },
      { label: 'Base de prorrateo', value: this.filaSeleccionada.regla_asignacion_gif_base_prorrateo },
      { label: 'Centro de costo', value: this.filaSeleccionada.regla_asignacion_gif_centro_costo || '-' },
      { label: 'Estado actual', value: 'Activo' }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Inactivar regla ${this.filaSeleccionada.regla_asignacion_gif_codigo}`,
        subtitulomodal: 'Detalle de la regla:',
        detalles: detalles,
        mostrarTextarea: false,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Inactivar',
        colorBotonConfirmar: 'danger'
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      this.toastService.success('Regla inactivada exitosamente');
      // Actualizar estado en el grid
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }
    }
  }

  async verAsientoContable() {
    const numeroAsiento = this.AsignacionGastosForm.get('numeroAsiento')?.value;
    if (!numeroAsiento) return;

    const colDefs = [
      { field: 'cuentaContable', headerName: 'Cuenta contable', width: 120 },
      { field: 'descripcion', headerName: 'Descripción', flex: 1 },
      { field: 'debe', headerName: 'Debe (S/)', width: 100, headerClass: 'centrarencabezado', cellStyle: { textAlign: 'right' } },
      { field: 'haber', headerName: 'Haber (S/)', width: 100, headerClass: 'centrarencabezado', cellStyle: { textAlign: 'right' } },
    ];
    
    const rowData = [
      { cuentaContable: '121101', descripcion: 'Clientes nacionales', debe: '5,500.00', haber: '-' },
      { cuentaContable: '101101', descripcion: 'Caja y Bancos – Interbank', debe: '-', haber: '5,500.00' },
    ];

    const detalles = [
      { label: 'Fecha de registro', value: '05/11/2025' },
      { label: 'Origen', value: 'Producción' },
      { label: 'Sucursal', value: 'Sucursal Principal' },
      { label: 'Estado', value: 'Registrado' },
      { label: 'Total Debe (S/)', value: '5,500.00' },
      { label: 'Total Haber (S/)', value: '5,500.00' },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Información del asiento contable ${numeroAsiento}`,
        subtitulomodal: 'Detalle del asiento',
        detalles: detalles,
        mostrarTabla: true,
        colDefs: colDefs,
        rowData: rowData,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        textoBotonCancelar: 'Cerrar',
      }
    });

    await modal.present();
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
      { fechaHora: '20/11/2025 16:01:44', usuario: 'Ana Pérez', accion: 'Actualización de estado', detalleCambio: 'Estado: De "Activo" a "Inactivo"'},
      { fechaHora: '12/11/2025 14:40:22', usuario: 'Jorge Gómez', accion: 'Edición de regla', detalleCambio: 'Base de prorrateo: De "Horas - Máquina" a "Unidades producidas"'},
      { fechaHora: '13/11/2025 15:15:30', usuario: 'Jorge Gómez', accion: 'Registro de regla', detalleCambio: 'Se ingresó la regla inicial con 4 productos elaborados'},
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones de ${this.filaSeleccionada?.regla_asignacion_gif_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }

  agregarProducto(producto: any) {
    if (!producto) return;

    // Verificar si el producto ya existe en la lista
    const existe = this.rowDataProductos.some(p => p.producto_elaborado_codigo === producto.codigo);
    if (existe) {
      this.toastService.warning('El producto ya está en la lista');
      return;
    }

    // Agregar el producto a la tabla con todos sus campos
    const nuevoProducto: IProductoElaboradoEntity = {
      producto_elaborado_codigo: producto.codigo,
      producto_elaborado_nombre_producto: producto.nombre,
      producto_elaborado_base_prorrateo: this.AsignacionGastosForm.get('baseProrrateo')?.value || 'Horas - Máquina',
      producto_elaborado_cantidad_total: 100,
      producto_elaborado_monto_total: producto.montoTotal || 5000,
      producto_elaborado_monto_unitario: producto.montoUND || 5000,
      producto_elaborado_monto_depreciacion: producto.montoDepreciacion || 1250.00,
      producto_elaborado_importe_asignado_gif: producto.importeAsigGIF || 10.42,
      producto_elaborado_estado: 'Activo'
    };

    this.rowDataProductos = [...this.rowDataProductos, nuevoProducto];

    // Actualizar el grid
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', this.rowDataProductos);
    }

    // Limpiar el autocomplete después del toast
    setTimeout(() => {
      if (this.autocompleteProductos) {
        this.autocompleteProductos.clearSelection();
      }
    }, 100);
  }

  eliminarProducto(params: any) {
    const codigo = params.data.producto_elaborado_codigo;
    
    // Eliminar el producto de la lista
    this.rowDataProductos = this.rowDataProductos.filter(p => p.producto_elaborado_codigo !== codigo);
    
    // Actualizar el grid
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', this.rowDataProductos);
    }
    
    this.toastService.success('Producto eliminado exitosamente');
  }

  // Generar número de asiento contable automático
  private generarNumeroAsiento(): string {
    const año = new Date().getFullYear();
    // Buscar el mayor número de asiento existente para el año actual
    let maxNumero = 0;
    
    this.rowData.forEach(regla => {
      if (regla.regla_asignacion_gif_numero_asiento) {
        // Extraer el número del formato ASC-2025-000148
        const match = regla.regla_asignacion_gif_numero_asiento.match(/ASC-(\d{4})-(\d+)/);
        if (match && match[1] === año.toString()) {
          const numero = parseInt(match[2]);
          if (numero > maxNumero) {
            maxNumero = numero;
          }
        }
      }
    });
    
    // Generar el siguiente número
    const siguienteNumero = maxNumero + 1;
    return `ASC-${año}-${siguienteNumero.toString().padStart(6, '0')}`;
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }
}
