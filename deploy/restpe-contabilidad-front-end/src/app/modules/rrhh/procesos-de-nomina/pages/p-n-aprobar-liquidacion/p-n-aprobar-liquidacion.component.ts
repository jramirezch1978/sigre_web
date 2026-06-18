import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent, RowNodeTransaction } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalDetalleCalculoComponent } from '../../modals/modal-detalle-calculo/modal-detalle-calculo.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { LiquidacionEntity } from 'src/app/modules/rrhh/domain/models/liquidacion.entity';

// Font Awesome Icons
import { faInfoCircle as faInfoCircleLight } from '@fortawesome/pro-light-svg-icons';
import { faBook, faEye, faInfoCircle as faInfoCircleRegular, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-p-n-aprobar-liquidacion',
  templateUrl: './p-n-aprobar-liquidacion.component.html',
  styleUrls: ['./p-n-aprobar-liquidacion.component.scss'],
  standalone: false,
})
export class PNAprobarLiquidacionComponent  implements OnInit, CanComponentDeactivate {
  private readonly rrHhFacade = inject(RrHhFacade);
  readonly isLoading = this.rrHhFacade.loadingRegistrarLiquidacion;
  isResetting = false;
  // Font Awesome Icons
  falInfoCircle = faInfoCircleLight;
  farBook = faBook;
  farEye = faEye;
  farInfoCircle = faInfoCircleRegular;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  private gridApi!: GridApi;
  ingresoSeleccionado: string = 'todos';
  camponuevo: boolean = false;
  LiquidacionForm!: FormGroup;
  filaSeleccionada: any = null; 
  deshabilitado = false;
  indemnizacion: boolean = false;
  countries= ALL_COUNTRIES;
  moneda: any = '';
  country= this.countryService.getCountryCode();
  // Fecha
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;  

    ingresos = [
    { label: 'Ingreso', value: 'ingreso' },
    { label: 'Cese', value: 'cese' },
  ];

  trabajadores = [
    { nombre: 'Alexandra Pérez Ramírez', liquidacion_sueldo_basico: 3500, liquidacion_asignacion_familiar: 350, liquidacion_promedio_gratificacion: 280, liquidacion_fecha_inicio: '2023-06-01' },
    { nombre: 'Carlos Zapata Quispe', liquidacion_sueldo_basico: 2900, liquidacion_asignacion_familiar: 290, liquidacion_promedio_gratificacion: 230, liquidacion_fecha_inicio: '2022-06-12' },
    { nombre: 'María Teresa Sánchez Gutierrez', liquidacion_sueldo_basico: 4000, liquidacion_asignacion_familiar: 400, liquidacion_promedio_gratificacion: 320, liquidacion_fecha_inicio: '2015-12-01' },
    { nombre: 'Juan Pérez', liquidacion_sueldo_basico: 2500, liquidacion_asignacion_familiar: 300, liquidacion_promedio_gratificacion: 200, liquidacion_fecha_inicio: '2020-01-15' },
    { nombre: 'María García', liquidacion_sueldo_basico: 2800, liquidacion_asignacion_familiar: 350, liquidacion_promedio_gratificacion: 250, liquidacion_fecha_inicio: '2019-03-22' },
    { nombre: 'Carlos López', liquidacion_sueldo_basico: 3200, liquidacion_asignacion_familiar: 400, liquidacion_promedio_gratificacion: 300, liquidacion_fecha_inicio: '2018-07-10' },
    { nombre: 'Ana Martínez', liquidacion_sueldo_basico: 2700, liquidacion_asignacion_familiar: 320, liquidacion_promedio_gratificacion: 220, liquidacion_fecha_inicio: '2021-05-30' },
    { nombre: 'Luis Fernández', liquidacion_sueldo_basico: 3000, liquidacion_asignacion_familiar: 360, liquidacion_promedio_gratificacion: 280, liquidacion_fecha_inicio: '2017-11-18' }
  ] 
  tipos=[
    "Renuncia",
    "Renuncia con insentivos",
    "Despido o distitución",
    "Cese colectivo",
    "Jubilación",
  ];

  // Configuración de cálculos por tipo de cese (porcentajes sobre sueldo base)
  configuracionLiquidacion: any = {
    'Renuncia': { ctsPorcentaje: 0.25, gratiPorcentaje: 0.5, otrosPorcentaje: 0, vacacionesPorcentaje: 1, bonificacionPorcentaje: 0, descuentoPorcentaje: 0.05 },
    'Renuncia con insentivos': { ctsPorcentaje: 0.50, gratiPorcentaje: 1, otrosPorcentaje: 0.2, vacacionesPorcentaje: 1, bonificacionPorcentaje: 0.3, descuentoPorcentaje: 0.05 },
    'Despido o distitución': { ctsPorcentaje: 0.50, gratiPorcentaje: 1.5, otrosPorcentaje: 0.2, vacacionesPorcentaje: 1, bonificacionPorcentaje: 0.5, descuentoPorcentaje: 0.05 },
    'Cese colectivo': { ctsPorcentaje: 0.50, gratiPorcentaje: 1.5, otrosPorcentaje: 0.3, vacacionesPorcentaje: 1, bonificacionPorcentaje: 0.5, descuentoPorcentaje: 0.05 },
    'Jubilación': { ctsPorcentaje: 1, gratiPorcentaje: 1.5, otrosPorcentaje: 0.5, vacacionesPorcentaje: 1, bonificacionPorcentaje: 1, descuentoPorcentaje: 0.05 }
  };

  localeText = {
    page: 'Página',
    of: 'de',
    to: 'a',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    noRowsToShow: 'No hay filas para mostrar',
    loadingOoo: 'Cargando...'
  };
  columnTypes = {
    currency: { 
        width: 150,
    },
    shaded: {
        cellClass: 'shaded-class'
    }
  };
  defaultColDef = {
    resizable: true,
    flex: 1,
    minWidth: 100,
  };
  rowDataCompleto: LiquidacionEntity[] = [];
  
  rowData: LiquidacionEntity[] = [];

  private mapRegistrarAAprobar(item: LiquidacionEntity): LiquidacionEntity {
    return {
      liquidacion_codigo: item.liquidacion_codigo,
      liquidacion_trabajador: item.liquidacion_trabajador,
      liquidacion_fecha_inicio: item.liquidacion_fecha_inicio,
      liquidacion_estado: item.liquidacion_estado,
      liquidacion_sueldo_basico: item.liquidacion_sueldo_basico,
      liquidacion_asignacion_familiar: item.liquidacion_asignacion_familiar,
      liquidacion_promedio_gratificacion: item.liquidacion_promedio_gratificacion,
      liquidacion_fecha_cese: item.liquidacion_fecha_cese,
      liquidacion_tipo_cese: item.liquidacion_tipo_cese,
      liquidacion_cts_total: item.liquidacion_cts_total,
      liquidacion_gratificacion_total: item.liquidacion_gratificacion_total,
      liquidacion_otros_beneficios: item.liquidacion_otros_beneficios,
      liquidacion_vacaciones_total: item.liquidacion_vacaciones_total,
      liquidacion_bonificacion_extraordinaria: item.liquidacion_bonificacion_extraordinaria,
      liquidacion_descuento_rr: item.liquidacion_descuento_rr,
      liquidacion_total_pagar: item.liquidacion_total_pagar,
      liquidacion_observaciones: item.liquidacion_observaciones,
    };
  }

  private mapAprobarARegistrar(item: LiquidacionEntity): LiquidacionEntity {
    return {
      liquidacion_codigo: item.liquidacion_codigo,
      liquidacion_trabajador: item.liquidacion_trabajador,
      liquidacion_fecha_inicio: item.liquidacion_fecha_inicio,
      liquidacion_estado: item.liquidacion_estado,
      liquidacion_sueldo_basico: item.liquidacion_sueldo_basico,
      liquidacion_asignacion_familiar: item.liquidacion_asignacion_familiar,
      liquidacion_promedio_gratificacion: item.liquidacion_promedio_gratificacion,
      liquidacion_fecha_cese: item.liquidacion_fecha_cese,
      liquidacion_tipo_cese: item.liquidacion_tipo_cese,
      liquidacion_cts_total: item.liquidacion_cts_total,
      liquidacion_gratificacion_total: item.liquidacion_gratificacion_total,
      liquidacion_otros_beneficios: item.liquidacion_otros_beneficios,
      liquidacion_vacaciones_total: item.liquidacion_vacaciones_total,
      liquidacion_bonificacion_extraordinaria: item.liquidacion_bonificacion_extraordinaria,
      liquidacion_descuento_rr: item.liquidacion_descuento_rr,
      liquidacion_total_pagar: item.liquidacion_total_pagar,
      liquidacion_observaciones: item.liquidacion_observaciones,
      aguinaldo: 0,
      bono14: 0,
      vacaciones: 0,
      indemnizacion: 0,
      trabajadorSelect: 'No',
    };
  }

  
  //  Tipado con la misma interfaz
  colDefs: ColDef<LiquidacionEntity>[] = [
    { field: 'liquidacion_codigo', headerName: 'Cód. de liquidación', width: 130 },
    { field: 'liquidacion_fecha_inicio', headerName: 'Fecha de ingreso', width: 130,
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${day}/${month}/${year}`;
      }
    },
    { field: 'liquidacion_fecha_cese', headerName: 'Fecha de cese', width: 130,
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${day}/${month}/${year}`;
      }
    },
    { field: 'liquidacion_trabajador', headerName: 'Trabajador', width: 180 },
    { field: 'liquidacion_tipo_cese', headerName: 'Tipo de cese', width: 150, filter: true },
    { field: 'liquidacion_total_pagar', headerName: 'Total a pagar', headerClass:'derechaencabezado', width: 130,
      cellStyle: {textAlign: 'right',display: 'flex',justifyContent: 'right'},
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        // Formatear con separador de miles y dos decimales
        return `S/ ${params.value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
      }
    },
    { field: 'liquidacion_estado', headerName: 'Estado', width: 120, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Aprobada') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Aprobada</span>';
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#FFF0BF] text-[#F2A626]">Pendiente</span>';
        } else if (params.value === 'En revisión') {
          return '<span class="badge-table bg-[#FFF0BF] text-[#F2A626]">En revisión</span>';
        } else if (params.value === 'Devuelto') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Devuelto</span>';
        }
        return params.value;
      }
    }
  ];
  
    constructor(
      private formBuilder: FormBuilder,
      private toastService: ToastService,
      private modalController: ModalController,
      private formValidationService: FormValidationService,
      private countryService: CountryService,
    ) {
      this.minDate = new Date(2020, 0, 1);
      this.maxDate = new Date();
    }

  ngOnInit() {
    this.obtenerdaatosdepais();
    
    // Aplicar filtro inicial
    this.filtrarPorEstado();

    // Cargar liquidaciones desde el registro de liquidación
    this.rrHhFacade.cargarRegistrarLiquidacion();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowDataCompleto = this.rrHhFacade.registrarLiquidacion();
        this.filtrarPorEstado();
        clearInterval(timer);
      }
    }, 100);
    
    this.LiquidacionForm = this.formBuilder.group({
      liquidacion_trabajador: ['', Validators.required],
      liquidacion_sueldo_basico: [{value: '', disabled: true}],
      liquidacion_asignacion_familiar: [{value: '', disabled: true}],
      liquidacion_promedio_gratificacion: [{value: '', disabled: true}],
      liquidacion_fecha_inicio: [{ value: '', disabled: true }],
      liquidacion_fecha_cese: [{value: '', disabled: true  }],
      liquidacion_tipo_cese: [{ value: '', disabled: true }],
      indemnizacion: [{ value: false, disabled: true }],
      liquidacion_cts_total: [{ value: '', disabled: true }],
      aguinaldo: [{ value: '', disabled: true }],
      liquidacion_gratificacion_total: [{ value: '', disabled: true }],
      liquidacion_otros_beneficios: [{ value: '', disabled: true }],
      liquidacion_vacaciones_total: [{ value: '', disabled: true }],
      liquidacion_bonificacion_extraordinaria: [{ value: '', disabled: true }],
      liquidacion_descuento_rr: [{ value: '', disabled: true }],
      liquidacion_total_pagar: [{ value: '', disabled: true }],
      liquidacion_estado: [{ value: '', disabled: true }],
      liquidacion_observaciones: [{ value: '', disabled: true }],
    });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.LiquidacionForm);

    // Listener para cambios en tipoC y otros campos para recalcular total
    this.LiquidacionForm.get('liquidacion_tipo_cese')?.valueChanges.subscribe(() => {
      this.llenarCamposLiquidacion();
    });

    // Listeners para actualizar el total cuando se modifiquen los campos de liquidación
    ['liquidacion_cts_total', 'liquidacion_gratificacion_total', 'liquidacion_otros_beneficios', 'liquidacion_vacaciones_total', 'liquidacion_bonificacion_extraordinaria', 'liquidacion_descuento_rr'].forEach(campo => {
      this.LiquidacionForm.get(campo)?.valueChanges.subscribe(() => {
        this.calcularTotal();
      });
    });
  }
  obtenerdaatosdepais(){
    this.countries.find(c => {
      if(c.codigo === this.country){
        c.monedapais?.find(tip => {
          this.moneda = tip.simbolo;
        })
      }
    })   
  }

  // Función para filtrar registros por estado "En revisión"
  filtrarPorEstado(): void {
    this.rowData = this.rowDataCompleto
      .filter(item => item.liquidacion_estado === 'En revisión')
      .map(item => this.mapRegistrarAAprobar(item));
    // Actualizar la tabla si ya existe la grid
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', [...this.rowData]);
    }
  }

    filtrarPorFechas(range: { start: Date; end: Date }): void {
    this.startDate = range.start;
    this.endDate = range.end;
  }


  onFechaCSelected(fecha: Date) {
    this.LiquidacionForm.patchValue({ liquidacion_fecha_cese: fecha });
  }
  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  onTrabajadorSeleccionado(trabajador: any) {
    // Buscar el trabajador en el array para obtener sus datos
    const empleado = this.trabajadores.find(t => t.nombre === trabajador.nombre);
    
    if (empleado) {
      this.LiquidacionForm.patchValue({
        liquidacion_trabajador: empleado.nombre,
        liquidacion_sueldo_basico: empleado.liquidacion_sueldo_basico,
        liquidacion_asignacion_familiar: empleado.liquidacion_asignacion_familiar,
        liquidacion_promedio_gratificacion: empleado.liquidacion_promedio_gratificacion,
        liquidacion_fecha_inicio: empleado.liquidacion_fecha_inicio
      });
    }
  }

  // Llenar campos de liquidación según el tipo de cese seleccionado
  llenarCamposLiquidacion() {
    const tipoC = this.LiquidacionForm.get('liquidacion_tipo_cese')?.value;
    const sueldoB = this.LiquidacionForm.get('liquidacion_sueldo_basico')?.value || 0;

    if (!tipoC || !sueldoB) return;

    const config = this.configuracionLiquidacion[tipoC];
    if (!config) return;

    // Calcular valores según el tipo de cese
    const CTST = sueldoB * config.ctsPorcentaje;
    const gratiT = sueldoB * config.gratiPorcentaje;
    const otrosB = sueldoB * config.otrosPorcentaje;
    const vacacionesT = sueldoB * config.vacacionesPorcentaje;
    const bonifE = sueldoB * config.bonificacionPorcentaje;
    const desctRr = sueldoB * config.descuentoPorcentaje;

    // Llenar los campos sin disparar el valueChanges infinitamente
    this.LiquidacionForm.patchValue({
      liquidacion_cts_total: Math.round(CTST * 100) / 100,
      liquidacion_gratificacion_total: Math.round(gratiT * 100) / 100,
      liquidacion_otros_beneficios: Math.round(otrosB * 100) / 100,
      liquidacion_vacaciones_total: Math.round(vacacionesT * 100) / 100,
      liquidacion_bonificacion_extraordinaria: Math.round(bonifE * 100) / 100,
      liquidacion_descuento_rr: Math.round(desctRr * 100) / 100
    }, { emitEvent: false });

    // Calcular el total
    this.calcularTotal();
  }

  // Calcular el total a pagar
  calcularTotal() {
    const CTST = parseFloat(this.LiquidacionForm.get('liquidacion_cts_total')?.value) || 0;
    const gratiT = parseFloat(this.LiquidacionForm.get('liquidacion_gratificacion_total')?.value) || 0;
    const otrosB = parseFloat(this.LiquidacionForm.get('liquidacion_otros_beneficios')?.value) || 0;
    const vacacionesT = parseFloat(this.LiquidacionForm.get('liquidacion_vacaciones_total')?.value) || 0;
    const bonifE = parseFloat(this.LiquidacionForm.get('liquidacion_bonificacion_extraordinaria')?.value) || 0;
    const desctRr = parseFloat(this.LiquidacionForm.get('liquidacion_descuento_rr')?.value) || 0;

    const total = CTST + gratiT + otrosB + vacacionesT + bonifE - desctRr;
    
    // Actualizar el total sin disparar validación
    this.LiquidacionForm.get('liquidacion_total_pagar')?.setValue(Math.round(total * 100) / 100, { emitEvent: false });
  }

  async onCellClicked(event: any) {
    const data = event?.data;
    
    // Seleccionar la fila ANTES de validar, así se ve marcada mientras el modal está abierto
    event.node.setSelected(true);

    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló - NO cambiar de fila, mantener actual
      // La fila nueva ya fue seleccionada, así que deseleccionarla
      event.node.setSelected(false);
      
      // Si hay fila anterior, asegurarse que esté seleccionada
      if (this.filaSeleccionada) {
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
            if (node.data.liquidacion_codigo === this.filaSeleccionada.liquidacion_codigo) {
              node.setSelected(true);
            }
          });
        }, 0);
      } else {
        this.gridApi.deselectAll();
      }
      return;
    }

    // Usuario confirmó - cambiar de fila (ya está seleccionada)
    // Cargar datos del registro seleccionado
    this.cargarDatosRegistro(data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: any, node?: any): void {
    this.camponuevo = false;
    this.filaSeleccionada = data;

    // Seleccionar el nodo en AG-Grid sin deseleccionar primero
    if (node) {
      // Si viene el nodo, ya está seleccionado, solo mantenerlo
      // No hacer deselectAll() para evitar que parpadee
    } else {
      // Si no viene el nodo, buscar y seleccionar
      this.gridApi.deselectAll();
      this.gridApi.forEachNode((n) => {
        if (n.data === data) {
          n.setSelected(true);
        }
      });
    }

    // Llenar los campos del formulario con los datos de la fila
    this.LiquidacionForm.patchValue({
      liquidacion_trabajador: data.liquidacion_trabajador || '',               
      liquidacion_fecha_inicio: data.liquidacion_fecha_inicio || '',
      liquidacion_estado: data.liquidacion_estado || 'En revisión',
      liquidacion_sueldo_basico: data.liquidacion_sueldo_basico || 0,
      liquidacion_asignacion_familiar: data.liquidacion_asignacion_familiar || 0,
      liquidacion_promedio_gratificacion: data.liquidacion_promedio_gratificacion || 0,
      liquidacion_fecha_cese: data.liquidacion_fecha_cese || '',
      liquidacion_tipo_cese: data.liquidacion_tipo_cese || '',
      liquidacion_cts_total: data.liquidacion_cts_total || 0,
      liquidacion_gratificacion_total: data.liquidacion_gratificacion_total || 0,
      liquidacion_otros_beneficios: data.liquidacion_otros_beneficios || 0,
      liquidacion_vacaciones_total: data.liquidacion_vacaciones_total || 0,
      liquidacion_bonificacion_extraordinaria: data.liquidacion_bonificacion_extraordinaria || 0,
      liquidacion_descuento_rr: data.liquidacion_descuento_rr || 0,
      liquidacion_total_pagar: data.liquidacion_total_pagar || 0,
      liquidacion_observaciones: data.liquidacion_observaciones || ''
    });

    // Deshabilitar todos los campos del formulario
    this.LiquidacionForm.disable();
    this.deshabilitado = true;

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }

  async botonNuevaLiquidacion(){
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Cancelar acción
    }

    this.camponuevo = true;
    this.filaSeleccionada = null; 
    this.gridApi?.deselectAll(); 
    this.LiquidacionForm.reset();
 
    // Habilitar todos los campos para edición
    this.LiquidacionForm.enable();
    this.deshabilitado = false;
    
    // Establecer estado como "En revisión" y deshabilitarlo
    this.LiquidacionForm.patchValue({
      liquidacion_estado:'En revisión',
      liquidacion_fecha_cese: new Date(),
    });
    
    // Deshabilitar campos específicos que se auto-calculan
    this.LiquidacionForm.get('liquidacion_sueldo_basico')?.disable();
    this.LiquidacionForm.get('liquidacion_asignacion_familiar')?.disable();
    this.LiquidacionForm.get('liquidacion_promedio_gratificacion')?.disable();
    this.LiquidacionForm.get('liquidacion_fecha_inicio')?.disable();
    this.LiquidacionForm.get('liquidacion_total_pagar')?.disable();
    this.LiquidacionForm.get('liquidacion_estado')?.disable();

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }
  botonGuardar(){
    const formValues = this.LiquidacionForm.value;
    
    // Generar código automático para nuevos permisos
    const codigo = this.camponuevo ? this.generarNuevoCodigo() : this.filaSeleccionada?.liquidacion_codigo;
    
    // Crear objeto con los datos del formulario
    const permisoData: LiquidacionEntity = {
      liquidacion_codigo: codigo,
      liquidacion_trabajador: formValues.liquidacion_trabajador,
      liquidacion_fecha_inicio: formValues.liquidacion_fecha_inicio,
      liquidacion_estado: 'En revisión',
      liquidacion_sueldo_basico: formValues.liquidacion_sueldo_basico,
      liquidacion_asignacion_familiar: formValues.liquidacion_asignacion_familiar,
      liquidacion_promedio_gratificacion: formValues.liquidacion_promedio_gratificacion,
      liquidacion_fecha_cese: formValues.liquidacion_fecha_cese,
      liquidacion_tipo_cese: formValues.liquidacion_tipo_cese,
      liquidacion_cts_total: formValues.liquidacion_cts_total,
      liquidacion_gratificacion_total: formValues.liquidacion_gratificacion_total,
      liquidacion_otros_beneficios: formValues.liquidacion_otros_beneficios,
      liquidacion_vacaciones_total: formValues.liquidacion_vacaciones_total,
      liquidacion_bonificacion_extraordinaria: formValues.liquidacion_bonificacion_extraordinaria,
      liquidacion_descuento_rr: formValues.liquidacion_descuento_rr,
      liquidacion_total_pagar: formValues.liquidacion_total_pagar,
      liquidacion_observaciones: formValues.liquidacion_observaciones
    };

    let res: RowNodeTransaction | undefined;
    
    // Si es una nueva liquidación (camponuevo = true)
    if (this.camponuevo) {
      this.rowDataCompleto.unshift(this.mapAprobarARegistrar(permisoData));
      // Agregar al inicio del array rowData
      this.rowData.unshift(permisoData);
      
      // Agregar a la tabla en la parte superior (index: 0)
      res = this.gridApi.applyTransaction({
        add: [permisoData],
        addIndex: 0
      })!;
      this.toastService.success("¡Liquidación creada exitosamente!");
    } 
    // Si es edición (camponuevo = false y hay una fila seleccionada)
    else if (this.filaSeleccionada) {
      const indexCompleto = this.rowDataCompleto.findIndex(
        item => item.liquidacion_codigo === this.filaSeleccionada.liquidacion_codigo
      );
      if (indexCompleto !== -1) {
        this.rowDataCompleto[indexCompleto] = this.mapAprobarARegistrar(permisoData);
      }
      // Actualizar los valores de la fila seleccionada
      Object.assign(this.filaSeleccionada, permisoData);
      
      res = this.gridApi.applyTransaction({
        update: [this.filaSeleccionada]
      })!;
      this.toastService.success("¡Se guardaron cambios exitosamente!");
    }
    
    // Limpiar formulario y resetear estado
    this.LiquidacionForm.reset();
    this.LiquidacionForm.patchValue({
      liquidacion_estado: 'En revisión',
    });
    this.filaSeleccionada = null;
    this.camponuevo = false;
    this.rrHhFacade.actualizarRegistrarLiquidacion([...this.rowDataCompleto]);
    this.filtrarPorEstado();

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }
  
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    
    // Seleccionar automáticamente la primera liquidación al cargar
    if (this.rowData && this.rowData.length > 0) {
      setTimeout(() => {
        const firstRow = this.rowData[0];
        this.cargarDatosRegistro(firstRow);
      }, 100);
    }
  }

  // Generar código automático para nuevas operaciones
  generarNuevoCodigo(): string {
    const numeros = this.rowData.map(item => {
      const match = (item.liquidacion_codigo ?? '').match(/LIQ-?(\d+)/);
      return match ? parseInt(match[1], 10) : 0;
    });
    const maxNumero = Math.max(...numeros, 0);
    const nuevoNumero = (maxNumero + 1).toString().padStart(3, '0');
    return `LIQ${nuevoNumero}`;
  }


  onBtReset() {
    this.isResetting = true;
    this.rrHhFacade.cargarRegistrarLiquidacion();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowDataCompleto = this.rrHhFacade.registrarLiquidacion();
        this.filtrarPorEstado();
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

   async modalverActualizaciones() {
    // Definir las columnas
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora',width: 150},
      { headerName: 'Usuario', field: 'usuario',width: 120},
      { headerName: 'Acción', field: 'accion',width: 150},
      { headerName: 'Detalle del cambio', field: 'detalleCambio', flex: 1,
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
        titulo: 'Historial de Actualizaciones - '+this.filaSeleccionada.liquidacion_codigo,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
       
      }
    });
    
    await modal.present();
  }

  botonAprobar() {
    if (!this.filaSeleccionada) {
      return;
    }

    // Actualizar el estado a "Aprobada"
    this.filaSeleccionada.liquidacion_estado = 'Aprobada';
    
    // Actualizar en el array completo
    const index = this.rowDataCompleto.findIndex(item => item.liquidacion_codigo === this.filaSeleccionada.liquidacion_codigo);
    if (index !== -1) {
      this.rowDataCompleto[index].liquidacion_estado = 'Aprobada';
    }

    // Actualizar el formulario
    this.LiquidacionForm.patchValue({
      liquidacion_estado: 'Aprobada'
    });

    this.rrHhFacade.actualizarRegistrarLiquidacion([...this.rowDataCompleto]);
    this.toastService.success('¡Liquidación aprobada exitosamente!');
    
    // Aplicar filtro nuevamente para remover el registro de la tabla
    setTimeout(() => {
      this.filtrarPorEstado();
      this.filaSeleccionada = null;
      this.LiquidacionForm.reset();
    }, 300);
  }

  async botonDevolver() {
    if (!this.filaSeleccionada) {
      return;
    }

    // Detalles para el modal con formato de miles y decimales
    const detallesEjemplo = [
      { label: 'Trabajador', value: this.filaSeleccionada.liquidacion_trabajador },
      { label: 'Sueldo base', value: `S/ ${(this.filaSeleccionada.liquidacion_sueldo_basico ?? 0).toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}` },
      { label: 'Total a pagar', value: `S/ ${(this.filaSeleccionada.liquidacion_total_pagar ?? 0).toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}` },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Devolver liquidación ${this.filaSeleccionada.liquidacion_codigo}`,
        subtituloModal: 'Detalle de liquidación',
        widthModal: '492px',
        tituloTextaera: 'Motivo de devolución',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Devolver',
        colorBotonConfirmar: 'primary',
        motivoObligatorio: true,
      }
    });
    await modal.present();

    const { data } = await modal.onDidDismiss();
    // Log para depuración del resultado recibido
    console.log('Modal devolver data:', data);
    // Solo si el usuario confirma y hay motivo
    if (data && data.action === 'confirmar' && data.motivo) {
      this.filaSeleccionada.liquidacion_estado = 'Devuelto';
      
      // Actualizar en el array completo
      const index = this.rowDataCompleto.findIndex(item => item.liquidacion_codigo === this.filaSeleccionada.liquidacion_codigo);
      if (index !== -1) {
        this.rowDataCompleto[index].liquidacion_estado = 'Devuelto';
      }
      
      this.LiquidacionForm.patchValue({ liquidacion_estado: 'Devuelto' });
      this.rrHhFacade.actualizarRegistrarLiquidacion([...this.rowDataCompleto]);
      this.toastService.success('¡Liquidación devuelta exitosamente!');
      
      // Aplicar filtro nuevamente para remover el registro de la tabla
      setTimeout(() => {
        this.filtrarPorEstado();
        this.filaSeleccionada = null;
        this.LiquidacionForm.reset();
      }, 300);
    }
  }
  onIndemnizacionChange(event : any) {
    this.indemnizacion = event.detail.checked;
    console.log(event.detail.checked);
  }
  async modalDetalleCTS(){
    const dataCTS = [
      { concepto: 'CTS trunca (Meses)', baseM: '3500.00', formula: 'Base = 12 + meses', meses: 3, dias: '-', monto: '2916.67', isTotal: false },
      { concepto: 'CTS trunca (Días)', baseM: '3500.00', formula: 'Base ÷ 12 ÷ 30 × días', meses: 0, dias: 15, monto: '1750.00', isTotal: false },
      { concepto: 'Total CTS', baseM: 0, formula: '-', meses: '-', dias: '-', monto: '4666.67', isTotal: false },
      { concepto: 'Total vacaciones a pagar', baseM: 0, formula: '-', meses: '-', dias: '-', monto: '4666.67', isTotal: true }
    ];
    
    const modal = await this.modalController.create({
      component: ModalDetalleCalculoComponent,
      cssClass: 'promo',
      componentProps: {
        tituloTabla1: 'Detalle de cálculo de CTS trunca',
        rowData1: dataCTS
      }
    });
    
    await modal.present();
  }

  async modalDetalleGrati(){
    const dataGrati = [
      { concepto: 'Gratificación trunca (Meses)', baseM: '3500.00', formula: 'Base ÷ 6 × meses', meses: 5, dias: '-', monto: '1458.33', isTotal: false },
      { concepto: 'Gratificación trunca (Días)', baseM: '3500.00', formula: 'Base ÷ 6 ÷ 30 × días', meses: '-', dias: 15, monto: '1750.00', isTotal: false },
      { concepto: 'Total Gratificación', baseM: 0, formula: '-', meses: '-', dias: '-', monto: '3208.33', isTotal: true }
    ];
    
    const modal = await this.modalController.create({
      component: ModalDetalleCalculoComponent,
      cssClass: 'promo',
      componentProps: {
        tituloTabla1: 'Detalle de cálculo de gratificación trunca',
        rowData1: dataGrati
      }
    });
    
    await modal.present();
  }

  async modalDetalleVac(){
    const dataFondoPensiones = [
      { detalle: 'Fondo de pensión', porcentaje: 10.00, monto: 573.11, isTotal: false },
      { detalle: 'Comisión fija', porcentaje: 1.69, monto: 12.39, isTotal: false },
      { detalle: 'Prima de seguro', porcentaje: 1.37, monto: 10.03, isTotal: false },
      { detalle: 'AFP PROFUTURO FLUJО', porcentaje: 13.06, monto: 595.48, isTotal: false }
    ];

    const dataVacaciones = [
      { concepto: 'Vacaciones truncas (Meses)', baseM: '3500.00', formula: 'Base = 12 + meses', meses: 10, dias: '-', monto: '573.11', isTotal: false },
      { concepto: 'Vacaciones truncas (Días)', baseM: '3500.00', formula: 'Base = 12 + 30 + días', meses: '-', dias: 29, monto: '564.44', isTotal: false },
      { concepto: 'Total vacaciones', baseM: '-', formula: '-', meses: '-', dias: '-', monto: '573.11', isTotal: false },
      { concepto: 'Descuento provisional (AFP)', formula: '13.06% x total', monto: 0, valor: '-595.48', isTotal: false },
      { concepto: 'Total vacaciones a pagar', baseM: 0, formula: '-', monto: 0, valor: '635.63', isTotal: true }
    ];

    const colDefsFondoPensiones = [
      { field: 'detalle', headerName: 'Detalle', width: 200 },
      { field: 'porcentaje', headerName: 'Porcentaje', width: 120, valueFormatter: (params: any) => params.value ? `${params.value.toFixed(2)}%` : '-' },
      { field: 'monto', headerName: 'Monto', width: 120, valueFormatter: (params: any) => params.value ? `S/${params.value.toFixed(2)}` : '-' }
    ];
    
    const modal = await this.modalController.create({
      component: ModalDetalleCalculoComponent,
      cssClass: 'promo',
      componentProps: {
        mostrarTabla1: true,
        tituloTabla1: 'Detalle de fondo de pensiones',
        rowData1: dataFondoPensiones,
        colDefs1: colDefsFondoPensiones,
        mostrarTabla2: true,
        tituloTabla2: 'Detalle de cálculo de vacaciones truncas',
        rowData2: dataVacaciones
      }
    });
    
    await modal.present();
  }
    async abrirModalAguinaldo() {
    const dataAguinaldo = [
      { concepto: 'Aguinaldo', promedio: 'Q 3,816.90', formula: 'Promedio de salario ordinario /365 * días laborados', meses: 4, dias: '-', monto: 'Q 324.18', isTotal: false },
      { concepto: 'Total del bono', baseM: 0, formula: '-', meses: '-', dias: '-', monto: 'Q 324.18', isTotal: false },
      { concepto: 'Total de bono a pagar', baseM: 0, formula: '-', meses: '-', dias: '-', monto: 'Q 324.18', isTotal: true }
    ];
    const coldefAguinaldo = [
      { field: 'concepto', headerName: 'Concepto', flex: 2 },
      { headerClass: 'derechaencabezado', field: 'promedio', headerName: 'Promedio salario ordinario', flex: 1 ,
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
      },
      { field: 'formula', headerName: 'Fórmula base', flex: 3 },
      { headerClass: 'derechaencabezado' , field: 'monto', headerName: 'Monto', flex: 1,
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' } 
       },
    ];
    const modal = await this.modalController.create({
      component: ModalDetalleCalculoComponent,
      cssClass: 'promo',
      componentProps: {
        tituloTabla1: 'Detalle de cálculo de aguinaldo',
        rowData1: dataAguinaldo,
        colDefs1: coldefAguinaldo,
    }
    });
    modal.present();
  }
  async abrirModalBono() {
    const dataAguinaldo = [
      { concepto: 'Bono 14', promedio: 'Q 3,816.90', formula: 'Promedio de salario ordinario /365 * días laborados', meses: 4, dias: '-', monto: 'Q 1,924.14', isTotal: false },
      { concepto: 'Total del bono', baseM: 0, formula: '-', meses: '-', dias: '-', monto: 'Q 1,924.14', isTotal: false },
      { concepto: 'Total de bono a pagar', baseM: 0, formula: '-', meses: '-', dias: '-', monto: 'Q 1,924.14', isTotal: true }
    ];
    const coldefAguinaldo = [
      { field: 'concepto', headerName: 'Concepto', flex: 2 },
      { headerClass: 'derechaencabezado', field: 'promedio', headerName: 'Promedio salario ordinario', flex: 1 ,
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
      },
      { field: 'formula', headerName: 'Fórmula base', flex: 3 },
      { headerClass: 'derechaencabezado' , field: 'monto', headerName: 'Monto', flex: 1,
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' } 
       },
    ];
    const modal = await this.modalController.create({
      component: ModalDetalleCalculoComponent,
      cssClass: 'promo',
      componentProps: {
        tituloTabla1: 'Detalle de bono 14',
        rowData1: dataAguinaldo,
        colDefs1: coldefAguinaldo,
    }
    });
    modal.present();
  }
  async abrirModalVacaciones() {
    const dataAguinaldo = [
      { concepto: 'Vacaciones truncas', promedio: 'Q 3,816.90', formula: 'Promedio de salario ordinario /30 * (días de vacaciones - días tomados)', meses: 4, dias: '-', monto: 'Q 890.61', isTotal: false },
      { concepto: 'Total vacaciones', baseM: 0, formula: '-', meses: '-', dias: '-', monto: 'Q 890.61', isTotal: false },
      { concepto: 'Total vacaciones a pagar', baseM: 0, formula: '-', meses: '-', dias: '-', monto: 'Q 890.61', isTotal: true }
    ];
    const coldefAguinaldo = [
      { field: 'concepto', headerName: 'Concepto', flex: 2 },
      { headerClass: 'derechaencabezado', field: 'promedio', headerName: 'Promedio salario ordinario', flex: 1 ,
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
      },
      { field: 'formula', headerName: 'Fórmula base', flex: 3 },
      { headerClass: 'derechaencabezado' , field: 'monto', headerName: 'Monto', flex: 1,
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' } 
       },
    ];
    const modal = await this.modalController.create({
      component: ModalDetalleCalculoComponent,
      cssClass: 'promo',
      componentProps: {
        tituloTabla1: 'Detalle de cálculo de vacaciones',
        rowData1: dataAguinaldo,
        colDefs1: coldefAguinaldo,
        mostrardatos: true,
        datos1: 'Total vacaciones:',
        datos2: 'Días tomados:',
        dato1cantidad: '15',
        dato2cantidad: '8',
    }
    });
    modal.present();
  }
  async abrirModalIndemnizacion(){
    const dataAguinaldo = [
      { concepto: 'Indemnización', promedio: 'Q 3,816.90', formula: '(Promedio salario ordinario * 14 salarios /  12 meses / 365 días) * días laborados', meses: 4, dias: '-', monto: 'Q 324.18', isTotal: false },
      { concepto: 'Total indemnización', baseM: 0, formula: '-', meses: '-', dias: '-', monto: 'Q 324.18', isTotal: false },
      { concepto: 'Total indemnización a pagar', baseM: 0, formula: '-', meses: '-', dias: '-', monto: 'Q 324.18', isTotal: true }
    ];
    const coldefAguinaldo = [
      { field: 'concepto', headerName: 'Concepto', flex: 2 },
      { headerClass: 'derechaencabezado', field: 'promedio', headerName: 'Promedio salario ordinario', flex: 1 ,
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
      },
      { field: 'formula', headerName: 'Fórmula base', flex: 3 },
      { headerClass: 'derechaencabezado' , field: 'monto', headerName: 'Monto', flex: 1,
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' } 
       },
    ];
    const modal = await this.modalController.create({
      component: ModalDetalleCalculoComponent,
      cssClass: 'promo',
      componentProps: {
        tituloTabla1: 'Detalle de cálculo de vacaciones',
        rowData1: dataAguinaldo,
        colDefs1: coldefAguinaldo,
        mostrardatos: true,
        datos1: 'Total vacaciones:',
        datos2: 'Días tomados:',
        dato1cantidad: '15',
        dato2cantidad: '8',
      },
    });
    modal.present();
  }
}


