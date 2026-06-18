import { Component, OnInit, ViewChild, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { AccionesHerramientasCellRenderComponent } from 'src/app/ui/acciones-herramientas-cell-render/acciones-herramientas-cell-render.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { ProcesosEspecialesEntity } from 'src/app/modules/rrhh/domain/models/procesos-especiales.entity';
import { filter } from 'rxjs';

// Font Awesome Icons
import { faBook, faSearch, faScrewdriverWrench } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDollarSign, faDownload, faRotateRight, faUsers } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-p-n-procesos-especiales',
  templateUrl: './p-n-procesos-especiales.component.html',
  styleUrls: ['./p-n-procesos-especiales.component.scss'],
  standalone: false,
})
export class PNProcesosEspecialesComponent implements OnInit {
  private readonly rrHhFacade = inject(RrHhFacade);
  readonly isLoading = this.rrHhFacade.loadingProcesosEspeciales;
  isResetting = false;
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDollarSign = faDollarSign;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;
  fasUsers = faUsers;
  farScrewdriverWrench = faScrewdriverWrench;


  @ViewChild('autocompleteCuentas') autocompleteCuentas: any;
  pais = this.countryService.getCountryCode();
  countries = ALL_COUNTRIES;
  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  fechaInicial: Date | undefined;
  panelLateralVisible: boolean = true;

  EjecucionForm!: FormGroup;
  private gridApi!: GridApi;
  private detalleGridApi!: GridApi;
  gridContext!: { componentParent: PNProcesosEspecialesComponent };
  detalleContext!: { componentParent: PNProcesosEspecialesComponent};
  filaSeleccionada: any = null;
  cuentasFiltradas: any[] = []
  context: any;
  mesSeleccionadoC: number | null = null;
  anioSeleccionadoC: number | null = null;

  // Array de centros de costos
  centrosCostos = [
    { proceso_especial_codigo: 'Administración', nombre: 'Administración' },
    { proceso_especial_codigo: 'Ventas', nombre: 'Ventas' },
    { proceso_especial_codigo: 'Producción', nombre: 'Producción' },
    { proceso_especial_codigo: 'Logística', nombre: 'Logística' },
    { proceso_especial_codigo: 'Finanzas', nombre: 'Finanzas' }
  ];

  sucursales = [
    { id: '0', nombre: 'Todas las sucursales' },
    { id: '1', nombre: 'La Molina, Lima' },
    { id: '2', nombre: 'San Isidro, Lima' },
    { id: '3', nombre: 'San Borja, Lima' },
    { id: '4', nombre: 'Santa Isabel, Piura' },
  ];

  tipoB: any = []

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

  cuentas = [
    { proceso_especial_codigo: 'EMP-004', nombre: 'Juan Pérez', montoTotal: '2,000.00', proceso_especial_estado: 'Ajustado' },
    { proceso_especial_codigo: 'EMP-003', nombre: 'Maria López', montoTotal: '1,500.00', proceso_especial_estado: 'Calculado' },
    { proceso_especial_codigo: 'EMP-002', nombre: 'Roberto Mendoza', montoTotal: '1,500.00', proceso_especial_estado: 'Calculado' },
    { proceso_especial_codigo: 'EMP-001', nombre: 'Layla Sandoval', montoTotal: '1,500.00', proceso_especial_estado: 'Calculado' }
  ];


  rowData: ProcesosEspecialesEntity[] = [];

  colDefs: ColDef[] = [
    { field: 'proceso_especial_codigo', headerName: 'Código', width: 80 },
    { field: 'proceso_especial_tipo', headerName: 'Tipo de beneficio', width: 120, filter: true,
        cellRenderer: (params: any) => {
      const tipoValue = params.value;
      const componentParent = params.context?.componentParent;
      
      if (tipoValue && componentParent?.tipoB && Array.isArray(componentParent.tipoB)) {
        const found = componentParent.tipoB.find((t: any) => t.value === tipoValue);
        if (found) {
          return found.label || found.nombre;
        }
      }
      
      return tipoValue || '';
    }
     },
    { field: 'proceso_especial_periodo', headerName: 'Periodo', width: 100, },
    { field: 'proceso_especial_sucursal', headerName: 'Sucursal', width: 250, filter: true,
      valueFormatter: (params: any) => {
        const sucursal = this.sucursales.find(s => s.id == params.value);
        return sucursal ? sucursal.nombre : params.value || '';
      },
      filterValueGetter: (params: any) => {
        const sucursal = this.sucursales.find(s => s.id == params.data?.proceso_especial_sucursal);
        return sucursal ? sucursal.nombre : params.data?.proceso_especial_sucursal || '';
      }
    },
    { field: 'proceso_especial_num_trabajadores', headerName: 'N° de trabajadores', width: 120, },
    {
      field: 'proceso_especial_fecha', headerName: 'Fecha de ejecución', width: 130,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
    },
    {
      field: 'proceso_especial_monto_total', headerName: 'Monto total', width: 120, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
      valueFormatter: (params: any) => {
        if (params.value) {
          return `S/ ${params.value}`;
        }
        return '-';
      }
    },
    {
      field: 'proceso_especial_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Anulado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulado</span>';
        } else if (params.value === 'Ejecutado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Ejecutado</span>';
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        }
        return params.value;
      }
    }
  ];

  colDefsDetalle: ColDef[] = [
    { field: 'proceso_especial_codigo', headerName: 'Código', width: 100 },
    { field: 'nombre', headerName: 'Nombre', minWidth: 150, flex: 1 },
    { field: 'proceso_especial_centro_costo', headerName: 'Centro de costo', width: 140 },
    {
      field: 'montoTotal', headerName: 'Monto total', headerClass: 'derechaencabezado', width: 130,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
      valueFormatter: (params: any) => {
        if (params.value) {
          return `S/ ${params.value}`;
        }
        return '-';
      }
    },
    {
      field: 'proceso_especial_estado', headerName: 'Estado', width: 110, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Ajustado') {
          return '<span class="badge-table bg-[#FFF0BF] text-[#F2A626]">Ajustado</span>';
        } else if (params.value === 'Calculado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Calculado</span>';
        }
        return params.value;
      }
    }, { headerName: 'Acciones', width: 100, headerClass: 'centrarencabezado', cellRenderer: AccionesHerramientasCellRenderComponent, }
  ];


  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService,
    private countryService: CountryService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  ngOnInit() {
    const hoy = new Date().toISOString().split('T')[0];
    // Inicializar formulario 
    this.EjecucionForm = this.formBuilder.group({
      proceso_especial_sucursal: ['', Validators.required],
      proceso_especial_periodo: ['', Validators.required],
      proceso_especial_tipo: ['', Validators.required],
      fechaE: [{ value: hoy, disabled: true }, Validators.required],
      proceso_especial_centro_costo: [''],
      proceso_especial_num_trabajadores: [''],
      proceso_especial_monto_total: [''],
      proceso_especial_observaciones: [''],
      proceso_especial_estado: ['Pendiente'],

    });
    this.obtenerdaatosdepais();
    this.gridContext = { componentParent: this };
    this.detalleContext = { componentParent: this };  
    this.formValidationService.inicializarFormulario(this.EjecucionForm);
    // this.context = { componentParent: this };
    
    // Escuchar cambios en el formulario para actualizar el estado del botón
    this.EjecucionForm.valueChanges.subscribe(() => {
      this.actualizarEstadoBoton();
    });

    this.rrHhFacade.cargarProcesosEspeciales();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.procesosEspeciales();
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', [...this.rowData]);
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
        clearInterval(timer);
      }
    }, 100);
  }
  obtenerdaatosdepais() {
    this.countries.find(c => {
      if (c.codigo === this.pais) {
        this.tipoB = c.beneficiosasociados;
      }
    })
  }
  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }
  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Lógica para filtrar datos
  }
  formatearFecha(fecha: string): string {
    if (!fecha) return '-';

    const [año, mes, dia] = fecha.split('-');
    return `${dia}/${mes}/${año}`;
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }
  onCentroCostoSeleccionado(centroCosto: any) {
    console.log('Centro de costo seleccionado:', centroCosto);
    // Ya se actualiza automáticamente por el formControlName con valueKey="proceso_especial_codigo"
  }
  onMonthYearChangePeriodoC(event: { month: number; year: number }) {
    this.mesSeleccionadoC = event.month;
    this.anioSeleccionadoC = event.year;

    // Formato año+mes: 202602
    const mesStr = String(event.month).padStart(2, '0');
    const periodo = `${event.year}${mesStr}`;
    this.EjecucionForm.get('proceso_especial_periodo')?.setValue(periodo);
  }

  onPeriodoSeleccionado(event: any) {
    console.log('Periodo seleccionado:', event);

  }

  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
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
  onDetalleGridReady(params: GridReadyEvent) {
    this.detalleGridApi = params.api;
    // Pasar el contexto del componente al grid para que los cellRenderers puedan acceder a los métodos
    this.detalleGridApi.setGridOption('context', { componentParent: this });
  }

  async onCellClicked(event: any) {
    const data = event?.data;
    if (!data) { return; }

    const clickedNode = event.node;

    // Guardar referencia del elemento que tiene el foco
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar si hay cambios sin guardar usando el servicio
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

          // Restaurar el foco al campo que estaba activo
          if (elementoConFoco && elementoConFoco.tagName === 'INPUT') {
            setTimeout(() => {
              elementoConFoco.focus();
            }, 100);
          }
        }, 0);
      }
      return;
    }

    // Usuario confirmó - cargar datos y seleccionar la nueva fila
    this.formValidationService.pausarDeteccion();
    this.cargarDatosletra(data, clickedNode);
    this.cuentasFiltradas = this.cuentas;
    setTimeout(() => {
      this.gridApi?.deselectAll();
      clickedNode?.setSelected(true);
      this.formValidationService.reanudarDeteccion();
    }, 0);
  }

  // Método para cargar datos en el formulario
  private cargarDatosletra(data: any, node?: any): void {
    this.filaSeleccionada = data;

    // Extraer mes y año del periodo (YYYYMM)
    if (data.proceso_especial_periodo && data.proceso_especial_periodo.length === 6) {
      this.anioSeleccionadoC = parseInt(data.proceso_especial_periodo.substring(0, 4), 10);
      this.mesSeleccionadoC = parseInt(data.proceso_especial_periodo.substring(4, 6), 10);
      this.EjecucionForm.get('proceso_especial_periodo')?.setValue(data.proceso_especial_periodo);
    } else {
      this.anioSeleccionadoC = null;
      this.mesSeleccionadoC = null;
      this.EjecucionForm.get('proceso_especial_periodo')?.setValue('');
    }

    // Buscar el id/value del tipo de beneficio a partir del label
    // let tipoValue = data.proceso_especial_tipo;
    // if (this.tipoB && Array.isArray(this.tipoB)) {
    //   const found = this.tipoB.find((t: any) => t.label === data.proceso_especial_tipo);
    //   if (found) tipoValue = found.value;
    // }
    let tipoParaFormulario = data.proceso_especial_tipo;
     if (data.proceso_especial_estado === 'Anulado' || data.proceso_especial_estado === 'Ejecutado') {
    // Para estados Ejecutado/Anulado: Convertir ID a NOMBRE para mostrarlo
    if (this.tipoB && Array.isArray(this.tipoB)) {
      const found = this.tipoB.find((t: any) => t.value === data.proceso_especial_tipo);
      if (found) {
        tipoParaFormulario = found.label || found.nombre;
      }
    }
  }

    this.EjecucionForm.patchValue({
      proceso_especial_sucursal: data.proceso_especial_sucursal,
      proceso_especial_tipo: tipoParaFormulario,
      fechaE: data.proceso_especial_fecha,
      proceso_especial_num_trabajadores: data.proceso_especial_num_trabajadores || 0,
      proceso_especial_monto_total: data.proceso_especial_monto_total || '',
      proceso_especial_observaciones: data.proceso_especial_observaciones || '',
      proceso_especial_estado: data.proceso_especial_estado,
    });

    // Solo deshabilitar todos los controles si el estado es 'Anulado'.
    if (data.proceso_especial_estado === 'Anulado' || data.proceso_especial_estado === 'Ejecutado') {
      Object.keys(this.EjecucionForm.controls).forEach(key => {
        this.EjecucionForm.get(key)?.disable();
      });
    } else {
      // Habilitar todos los campos, excepto fechaE
      Object.keys(this.EjecucionForm.controls).forEach(key => {
        if (key === 'fechaE') {
          this.EjecucionForm.get(key)?.disable();
        } else {
          this.EjecucionForm.get(key)?.enable();
        }
      });
    }
    this.formValidationService.resetearEstado();
    
    // Actualizar estado del botón "Nueva ejecución de beneficio"
    this.actualizarEstadoBoton();
  }

  async botonNuevoCalculo() {
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Cancelar acción
    }

    // Reiniciar el formulario a los valores por defecto
    if (this.EjecucionForm) {
      // Obtener fecha de hoy en formato YYYY-MM-DD
      const hoy = new Date().toISOString().split('T')[0];

      this.EjecucionForm.reset({
        fechaE: hoy,
        proceso_especial_estado: 'Pendiente',
      });
      // Limpiar periodo seleccionado para el picker
      this.mesSeleccionadoC = null;
      this.anioSeleccionadoC = null;

      Object.keys(this.EjecucionForm.controls).forEach(key => {
        if (key === 'fechaE') {
          this.EjecucionForm.get(key)?.disable();
        } else {
          this.EjecucionForm.get(key)?.enable();
        }
      });

      // // Deshabilitar campos que no se editan por defecto
      // this.EjecucionForm.get('fechaE')?.disable();

      this.filaSeleccionada = null;

      // Deseleccionar fila de la tabla
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }

      // Resetear estado del servicio de validación
      this.formValidationService.resetearEstado();
      this.cuentasFiltradas = [];
      
      // Actualizar estado del botón
      this.actualizarEstadoBoton();
    }
  }

  /**
   * Actualiza el estado del botón "Nueva ejecución de beneficio"
   * Se habilita si: hay una fila seleccionada O si hay al menos un campo del formulario relleno
   */
  private actualizarEstadoBoton(): void {
    const tieneFilaSeleccionada = !!this.filaSeleccionada;
    const tieneFormulaRelleno = this.tieneCamposRellenos();
    
  }

  /**
   * Verifica si al menos un campo del formulario tiene un valor
   */
  private tieneCamposRellenos(): boolean {
    if (!this.EjecucionForm) return false;
    
    const controls = this.EjecucionForm.getRawValue();
    return Object.values(controls).some(valor => valor && valor !== '');
  }

  botonGuardarBorrador() {
    // Validar que el formulario sea válido
    if (this.EjecucionForm.invalid) {
      const camposConError: string[] = [];
      Object.keys(this.EjecucionForm.controls).forEach(key => {
        const control = this.EjecucionForm.get(key);
        if (control && control.invalid) {
          let label = this.formatFieldName(key);
          if (key === 'proceso_especial_tipo') label = label.toUpperCase();
          camposConError.push(label);
        }
      });
      console.log('Campos con error:', camposConError);
      this.toastService.danger(`Por favor, complete todos los campos requeridos: ${camposConError.join(', ')}`);
      return;
    }

    const formValue = this.EjecucionForm.getRawValue();
    const codigo = this.filaSeleccionada ? this.filaSeleccionada.proceso_especial_codigo : `EJ-${String(this.rowData.length + 1).padStart(5, '0')}`;

    // Obtener el label del tipo de beneficio
    let tipoLabel = formValue.proceso_especial_tipo;
    if (this.tipoB && Array.isArray(this.tipoB)) {
      const found = this.tipoB.find((t: any) => t.value === formValue.proceso_especial_tipo);
      if (found) tipoLabel = found.label;
    }

    // Usar la fecha de ejecución del formulario
    const fechaEjecucion = formValue.fechaE || this.EjecucionForm.get('fechaE')?.value || '';

    // Crear objeto con estado Pendiente
    const provisonGasto = {
      proceso_especial_codigo: codigo || '',
      proceso_especial_tipo: formValue.proceso_especial_tipo || '',
      proceso_especial_periodo: formValue.proceso_especial_periodo || '',
      proceso_especial_sucursal: this.capitalizeFirstLetter(formValue.proceso_especial_sucursal) || '',
      proceso_especial_centro_costo: formValue.proceso_especial_centro_costo || '',
      proceso_especial_num_trabajadores: formValue.proceso_especial_num_trabajadores || 0,
      proceso_especial_fecha: fechaEjecucion,
      proceso_especial_monto_total: formValue.proceso_especial_monto_total || '0.00',
      proceso_especial_observaciones: formValue.proceso_especial_observaciones || '',
      proceso_especial_estado: 'Pendiente',
    };

    if (this.filaSeleccionada) {
      // EDITAR: Actualizar provision existente
      const index = this.rowData.findIndex(item => item.proceso_especial_codigo === this.filaSeleccionada.proceso_especial_codigo);

      if (index !== -1) {
        this.rowData[index] = provisonGasto;
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.toastService.success('¡Borrador guardado exitosamente!');
      }
    } else {
      // AGREGAR: Crear nueva provision
      this.rowData.unshift(provisonGasto);
      this.gridApi.setGridOption('rowData', [...this.rowData]);
      this.toastService.success('¡Borrador creado exitosamente!');
    }

    this.limpiarFormulario();
    this.cuentasFiltradas = [];
    // this.togglePanelLateral();
    this.formValidationService.resetearEstado();
  }

  botonConfirmarEjecucion() {
    // Validar que el formulario sea válido
    if (this.EjecucionForm.invalid) {
      const camposConError: string[] = [];
      Object.keys(this.EjecucionForm.controls).forEach(key => {
        const control = this.EjecucionForm.get(key);
        if (control && control.invalid) {
          camposConError.push(this.formatFieldName(key));
        }
      });
      console.log('Campos con error:', camposConError);
      this.toastService.danger(`Por favor, complete todos los campos requeridos: ${camposConError.join(', ')}`);
      return;
    }

    const formValue = this.EjecucionForm.getRawValue();
    const codigo = this.filaSeleccionada ? this.filaSeleccionada.proceso_especial_codigo : `EJ-${String(this.rowData.length + 1).padStart(5, '0')}`;

    // Obtener el label del tipo de beneficio
    let tipoLabel = formValue.proceso_especial_tipo;
    if (this.tipoB && Array.isArray(this.tipoB)) {
      const found = this.tipoB.find((t: any) => t.value === formValue.proceso_especial_tipo);
      if (found) tipoLabel = found.label;
    }

    // Usar la fecha de ejecución del formulario
    const fechaEjecucion = formValue.fechaE || this.EjecucionForm.get('fechaE')?.value || '';

    // Crear objeto con estado Ejecutado
    const provisonGasto = {
      proceso_especial_codigo: codigo || '',
      proceso_especial_tipo: formValue.proceso_especial_tipo || '', 
      proceso_especial_periodo: formValue.proceso_especial_periodo || '',
      proceso_especial_sucursal: this.capitalizeFirstLetter(formValue.proceso_especial_sucursal) || '',
      proceso_especial_centro_costo: formValue.proceso_especial_centro_costo || '',
      proceso_especial_num_trabajadores: formValue.proceso_especial_num_trabajadores || 0,
      proceso_especial_fecha: fechaEjecucion,
      proceso_especial_monto_total: formValue.proceso_especial_monto_total || '0.00',
      proceso_especial_observaciones: formValue.proceso_especial_observaciones || '',
      proceso_especial_estado: 'Ejecutado',
    };

    if (this.filaSeleccionada) {
      // EDITAR: Cambiar estado de Pendiente a Ejecutado
      const index = this.rowData.findIndex(item => item.proceso_especial_codigo === this.filaSeleccionada.proceso_especial_codigo);

      if (index !== -1) {
        this.rowData[index] = provisonGasto;
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.toastService.success('¡Ejecución confirmada exitosamente!');
      }
    } else {
      // AGREGAR: Crear nueva provision con estado Ejecutado
      this.rowData.unshift(provisonGasto);
      this.gridApi.setGridOption('rowData', [...this.rowData]);
      this.toastService.success('¡Ejecución registrada exitosamente!');
    }

    this.limpiarFormulario();
    this.cuentasFiltradas = [];
    // No abrir/cerrar el panel lateral aquí
    this.formValidationService.resetearEstado();
  }

  // Método para limpiar y resetear el formulario
  private limpiarFormulario(): void {
    const hoy = new Date().toISOString().split('T')[0];

    this.EjecucionForm.reset({
      fechaE: hoy,
      proceso_especial_estado: 'Pendiente',
    });

    // Limpiar periodo seleccionado para el picker
    this.mesSeleccionadoC = null;
    this.anioSeleccionadoC = null;

    this.cuentasFiltradas = [];
    if (this.detalleGridApi) {
      this.detalleGridApi.setGridOption('rowData', []);
    }

    this.filaSeleccionada = null;

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  private capitalizeFirstLetter(value: string): string {
    if (!value) return value;
    return value.charAt(0).toUpperCase() + value.slice(1);
  }

  private fieldLabelMap: { [key: string]: string } = {
    proceso_especial_sucursal: 'Sucursal',
    proceso_especial_periodo: 'Periodo',
    proceso_especial_tipo: 'Tipo',
    proceso_especial_centro_costo: 'Centro de costo',
    fechaE: 'Fecha de ejecución',
    proceso_especial_num_trabajadores: 'N° de trabajadores',
    proceso_especial_monto_total: 'Monto total',
    proceso_especial_observaciones: 'Observaciones'
  };

  private formatFieldName(key: string): string {
    return this.fieldLabelMap[key] ?? this.capitalizeFirstLetter(key);
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
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
      { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Se ha creado el grupo 1.00' },
      { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se edito la descripción del grupo' },
      { fechaHora: '13/11/2025 09:00', usuario: 'Carlos Rodríguez', accion: 'Actualización', detalleCambio: 'Se cambió el tipo de flujo' },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones de la letra ${this.filaSeleccionada.proceso_especial_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();

    // Manejar la respuesta cuando se cierre el modal
    const { data } = await modal.onWillDismiss();
    if (data) {
      console.log('Modal cerrado con datos:', data);
    }
  }

  onBtReset() {
    this.isResetting = true;
    this.rrHhFacade.cargarProcesosEspeciales();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.procesosEspeciales();
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

  botonGenerarP() {
    this.cuentasFiltradas = this.cuentas;
  }

  async botonAnular() {
    if (!this.filaSeleccionada) return;

    // Formatear periodo a AAAA/MM
    let periodoFormateado = '-';
    if (this.filaSeleccionada.proceso_especial_periodo && this.filaSeleccionada.proceso_especial_periodo.length === 6) {
      periodoFormateado = `${this.filaSeleccionada.proceso_especial_periodo.substring(0, 4)}${this.filaSeleccionada.proceso_especial_periodo.substring(4, 6)}`;
    }

    // Formatear monto
    let montoFormateado = '-';
    if (this.filaSeleccionada.proceso_especial_monto_total) {
      montoFormateado = `S/ ${this.filaSeleccionada.proceso_especial_monto_total}`;
    }

    // Formatear tipo de beneficio (label)
    let tipoLabel = this.filaSeleccionada.proceso_especial_tipo;
    if (this.tipoB && Array.isArray(this.tipoB)) {
      const found = this.tipoB.find((t: any) => t.value === this.filaSeleccionada.proceso_especial_tipo || t.label === this.filaSeleccionada.proceso_especial_tipo);
      if (found) tipoLabel = found.label;
    }

    const detallesEjemplo = [
      { label: 'Tipo de beneficio', value: tipoLabel },
      { label: 'Periodo', value: periodoFormateado },
      { label: 'Monto Total', value: montoFormateado },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Anular ejecución ${this.filaSeleccionada.proceso_especial_codigo}`,
        subtituloModal: 'Detalle de la ejecucion',
        widthModal: '492px',
        tituloTextaera: 'Motivo de la anulación',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Anular',
        colorBotonConfirmar: 'danger',
        motivoObligatorio: true,
      }
    });

    await modal.present();

    const { data, role } = await modal.onWillDismiss();

    // Verificar si se confirmó la acción
    if (data && data.action === 'confirmar') {
      // Actualizar el estado de la letra a 'Anulado'
      this.filaSeleccionada.proceso_especial_estado = 'Anulado';

      // Encontrar y actualizar la fila en la tabla principal
      const index = this.rowData.findIndex(item => item.proceso_especial_codigo === this.filaSeleccionada.proceso_especial_codigo);
      if (index !== -1) {
        this.rowData[index].proceso_especial_estado = 'Anulado';
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }

      // Mostrar mensaje de éxito
      this.toastService.success('¡La acción se realizó con éxito!');
      console.log('Motivo de anulación:', data.motivo);
    } else if (role === 'backdrop' || role === 'escape') {
      // Modal cerrado sin confirmación
      console.log('Anulación cancelada');
    }
  }
  async abrirModalAcciones(value: any, rowData: any) {

    // Tomar el monto de la fila seleccionada (puede venir como string con coma o número)
    let montoActual = '0.00';
    if (rowData && rowData.montoTotal) {
      // Si viene como string con coma, quitar comas y convertir a número
      if (typeof rowData.montoTotal === 'string') {
        montoActual = rowData.montoTotal.replace(/,/g, '');
      } else {
        montoActual = rowData.montoTotal.toString();
      }
    }

    // Función para formatear a miles
    function formatMiles(valor: any) {
      let num = Number(valor);
      if (isNaN(num)) num = 0;
      return num.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }

    const detalle = [
      { label: 'Monto actual', value: `S/ ${formatMiles(montoActual)}` },
    ];

    // El valor del input debe ser el monto sin formato (para que el usuario lo pueda editar correctamente)
    const detalleInput = { label: 'Monto ajustado', value: montoActual };

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        iconoModal: this.farScrewdriverWrench,
        tituloModal: `Ajuste manual`,
        detalles: detalle,
        detalleInput: detalleInput,
        subtitulomodal: '',
        widthModal: '480px',
        mostrarTextarea: true,
        tituloTextarea: 'Motivo de ajuste',
        textoBotonConfirmar: 'Confirmar ajuste',
        colorBotonConfirmar: 'primary',
        motivoObligatorio: true,
      }
    });

    await modal.present();

    // Esperar el cierre del modal y actualizar el estado si se confirma
    const { data, role } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      // Cambiar el estado de la fila seleccionada a 'Ajustado'
      if (rowData) {
        rowData.proceso_especial_estado = 'Ajustado';
        // Buscar y actualizar la fila en la tabla principal
        const index = this.cuentas.findIndex(item => item.proceso_especial_codigo === rowData.proceso_especial_codigo);
        if (index !== -1) {
          this.cuentas[index].proceso_especial_estado = 'Ajustado';
          if (this.detalleGridApi) {
            this.detalleGridApi.setGridOption('rowData', [...this.cuentas]);
          }
        }
      }
      this.toastService.success('¡Monto ajustado exitosamente!');
    }
  }
}
