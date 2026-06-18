import { Component, OnDestroy, OnInit, inject } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent, RowNodeTransaction } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalDetalleCalculoComponent } from '../../modals/modal-detalle-calculo/modal-detalle-calculo.component';
import { ro } from 'date-fns/locale';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';

// Font Awesome Icons
import { faInfoCircle as faInfoCircleLight } from '@fortawesome/pro-light-svg-icons';
import { faBook, faEye, faInfoCircle as faInfoCircleRegular, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { LiquidacionEntity } from 'src/app/modules/rrhh/domain/models/liquidacion.entity';
import { DatosPersonalesEntity } from '@modules/rrhh/domain/models/datos-personales.entity';

// Font Awesome Icons


@Component({
  selector: 'app-p-n-registrar-liquidacion',
  templateUrl: './p-n-registrar-liquidacion.component.html',
  styleUrls: ['./p-n-registrar-liquidacion.component.scss'],
  standalone: false,
})
export class PNRegistrarLiquidacionComponent implements OnInit, OnDestroy, CanComponentDeactivate {
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
  countries = ALL_COUNTRIES;
  tipoSeleccionado: string = 'De ingreso';
  camponuevo: boolean = false;
  pais = this.countryService.getCountryCode();
  moneda: any = '';
  LiquidacionForm!: FormGroup;
  filaSeleccionada: any = null;
  deshabilitado = false;
  country = this.countryService.getCountryCode();
  indemnizacion: boolean = false;
  // Fecha  
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  inactivarTrabajador = [
    'Sí',
    'No'
  ]
    tipoFs = [
    { value: 'ingreso', nombre: 'De ingreso' },
    { value: 'cese', nombre: 'De cese' },
  ]

  trabajadores: DatosPersonalesEntity[] = [];
  private datosPersonalesTimerId?: ReturnType<typeof setInterval>;
  
  tipos: any = [
    // "Renuncia",
    // "Renuncia con insentivos",
    // "Despido o distitución",
    // "Cese colectivo",
    // "Jubilación",
  ]; 

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
  rowData: LiquidacionEntity[] = [
    { liquidacion_codigo: 'LIQ004', liquidacion_trabajador: 'Alexandra Pérez Ramírez', liquidacion_fecha_inicio: '2023-06-01', liquidacion_estado: 'En revisión', liquidacion_sueldo_basico: 3500.00, liquidacion_asignacion_familiar: 350.00, liquidacion_promedio_gratificacion: 280.00, liquidacion_fecha_cese: '2025-09-30', liquidacion_tipo_cese: 'Jubilación', liquidacion_cts_total: 8750, liquidacion_gratificacion_total: 1960, liquidacion_otros_beneficios: 500, liquidacion_vacaciones_total: 5833, liquidacion_bonificacion_extraordinaria: 1000, liquidacion_descuento_rr: 200, liquidacion_total_pagar: 31000, liquidacion_observaciones: 'Liquidación por jubilación' },
    { liquidacion_codigo: 'LIQ003', liquidacion_trabajador: 'Alexandra Pérez Ramírez', liquidacion_fecha_inicio: '2023-01-01', liquidacion_estado: 'Aprobada', liquidacion_sueldo_basico: 3200.00, liquidacion_asignacion_familiar: 320.00, liquidacion_promedio_gratificacion: 250.00, liquidacion_fecha_cese: '2023-12-26', liquidacion_tipo_cese: 'Despido o destitución', liquidacion_cts_total: 4800, liquidacion_gratificacion_total: 833, liquidacion_otros_beneficios: 300, liquidacion_vacaciones_total: 2667, liquidacion_bonificacion_extraordinaria: 500, liquidacion_descuento_rr: 100, liquidacion_total_pagar: 15200, liquidacion_observaciones: 'Liquidación por despido' },
    { liquidacion_codigo: 'LIQ002', liquidacion_trabajador: 'Carlos Zapata Quispe', liquidacion_fecha_inicio: '2022-06-12', liquidacion_estado: 'Aprobada', liquidacion_sueldo_basico: 2900.00, liquidacion_asignacion_familiar: 290.00, liquidacion_promedio_gratificacion: 230.00, liquidacion_fecha_cese: '2023-12-31', liquidacion_tipo_cese: 'Renuncia con incentivos', liquidacion_cts_total: 5075, liquidacion_gratificacion_total: 1438, liquidacion_otros_beneficios: 600, liquidacion_vacaciones_total: 3833, liquidacion_bonificacion_extraordinaria: 800, liquidacion_descuento_rr: 150, liquidacion_total_pagar: 15240, liquidacion_observaciones: 'Renuncia con indemnización' },
    { liquidacion_codigo: 'LIQ001', liquidacion_trabajador: 'María Teresa Sánchez Gutierrez', liquidacion_fecha_inicio: '2015-12-01', liquidacion_estado: 'Aprobada', liquidacion_sueldo_basico: 4000.00, liquidacion_asignacion_familiar: 400.00, liquidacion_promedio_gratificacion: 320.00, liquidacion_fecha_cese: '2025-12-01', liquidacion_tipo_cese: 'Jubilación', liquidacion_cts_total: 20000, liquidacion_gratificacion_total: 6667, liquidacion_otros_beneficios: 1500, liquidacion_vacaciones_total: 10000, liquidacion_bonificacion_extraordinaria: 2000, liquidacion_descuento_rr: 500, liquidacion_total_pagar: 49000, liquidacion_observaciones: 'Liquidación después de 10 años' }
  ];


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
    { field: 'liquidacion_total_pagar', headerName: 'Total a pagar', headerClass: 'derechaencabezado', width: 130,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        return `${this.moneda} ${params.value.toFixed(2)}`;
      }
    },
    { field: 'liquidacion_estado', headerName: 'Estado', width: 120, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Aprobada') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Aprobada</span>';
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
    this.cargarTrabajadores();
    this.LiquidacionForm = this.formBuilder.group({
      liquidacion_trabajador: ['', Validators.required],
      liquidacion_sueldo_basico: [{ value: '', disabled: true }],
      liquidacion_asignacion_familiar: [{ value: '', disabled: true }],
      liquidacion_promedio_gratificacion: [{ value: '', disabled: true }],
      liquidacion_fecha_inicio: [{ value: this.getFechaHoy(), disabled: true }],
      liquidacion_fecha_cese: ['', Validators.required],
      liquidacion_tipo_cese: ['', Validators.required],
      liquidacion_cts_total: [''],
      liquidacion_gratificacion_total: [''],
      aguinaldo: [''],
      bono14: [''],
      vacaciones: [''],
      indemnizacion: [''],
      liquidacion_otros_beneficios: [''],
      liquidacion_vacaciones_total: [''],
      liquidacion_bonificacion_extraordinaria: [''],
      liquidacion_descuento_rr: [''],
      liquidacion_total_pagar: [{ value: '', disabled: true }],
      liquidacion_estado: [{ value: 'En revisión', disabled: true }],
      liquidacion_observaciones: [''],
      trabajadorSelect: ['No'],
    });
    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.LiquidacionForm);

    // Listeners para actualizar el total cuando se modifiquen los campos de liquidación
    ['liquidacion_cts_total', 'liquidacion_gratificacion_total', 'liquidacion_otros_beneficios', 'liquidacion_vacaciones_total', 'liquidacion_bonificacion_extraordinaria', 'liquidacion_descuento_rr'].forEach(campo => {
      this.LiquidacionForm.get(campo)?.valueChanges.subscribe(() => {
        this.calcularTotal();
      });
    });

    this.rrHhFacade.cargarRegistrarLiquidacion();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.registrarLiquidacion();
        if (this.gridApi) { this.gridApi.setGridOption('rowData', [...this.rowData]); }
        clearInterval(timer);
      }
    }, 100);
  }

  ngOnDestroy(): void {
    if (this.datosPersonalesTimerId) {
      clearInterval(this.datosPersonalesTimerId);
      this.datosPersonalesTimerId = undefined;
    }
  }

  private cargarTrabajadores(): void {
    this.rrHhFacade.cargarDatosPersonales();
    let intentos = 0;

    if (this.datosPersonalesTimerId) {
      clearInterval(this.datosPersonalesTimerId);
    }

    this.datosPersonalesTimerId = setInterval(() => {
      intentos += 1;
      this.trabajadores = [...this.rrHhFacade.datosPersonales()];

      if (!this.rrHhFacade.loadingDatosPersonales() || intentos >= 200) {
        if (this.datosPersonalesTimerId) {
          clearInterval(this.datosPersonalesTimerId);
          this.datosPersonalesTimerId = undefined;
        }
      }
    }, 100);
  }
  getFechaHoy(): string {
    return new Date().toISOString().substring(0, 10);
  }
  obtenerdaatosdepais() {
    this.countries.find(c => {
      if (c.codigo === this.country) {
        this.tipos = c.tiposdecese || [];
        c.monedapais?.find(tip => {
          this.moneda = tip.simbolo;
        })
      }
    })
  }
  filtrarPorFechas(range: { start: Date; end: Date }): void {
    this.startDate = range.start;
    this.endDate = range.end;
  }
  
  onFechaCSelected(fecha: Date) {
    this.LiquidacionForm.patchValue({ liquidacion_fecha_cese: fecha });
    this.llenarCamposLiquidacion();
  }

  private obtenerValorTipoCese(tipoCese: string | null | undefined): string {
    const valor = String(tipoCese ?? '').trim();
    if (!valor) {
      return '';
    }

    const opcionPorValor = this.tipos.find((tipo: any) => String(tipo.value) === valor);
    if (opcionPorValor) {
      return String(opcionPorValor.value);
    }

    const opcionPorLabel = this.tipos.find(
      (tipo: any) => String(tipo.label).trim() === valor
    );

    return opcionPorLabel ? String(opcionPorLabel.value) : valor;
  }

  private obtenerLabelTipoCese(tipoCese: string | null | undefined): string {
    const valor = String(tipoCese ?? '').trim();
    if (!valor) {
      return '';
    }

    const opcionPorValor = this.tipos.find((tipo: any) => String(tipo.value) === valor);
    if (opcionPorValor) {
      return String(opcionPorValor.label);
    }

    return valor;
  }

  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  private prepararFormularioNuevo(): void {
    this.LiquidacionForm.reset();
    this.LiquidacionForm.enable();
    this.deshabilitado = false;
    this.indemnizacion = false;
    this.LiquidacionForm.patchValue({
      liquidacion_estado: 'En revisión',
      liquidacion_fecha_inicio: this.getFechaHoy(),
      trabajadorSelect: 'No',
    });

    this.LiquidacionForm.get('liquidacion_sueldo_basico')?.disable();
    this.LiquidacionForm.get('liquidacion_asignacion_familiar')?.disable();
    this.LiquidacionForm.get('liquidacion_promedio_gratificacion')?.disable();
    this.LiquidacionForm.get('liquidacion_fecha_inicio')?.disable();
    this.LiquidacionForm.get('liquidacion_total_pagar')?.disable();
    this.LiquidacionForm.get('liquidacion_estado')?.disable();
  }

  onTrabajadorSeleccionado(trabajador: any) {
    // El autocomplete puede enviar el objeto completo o solo el nombre del trabajador.
    let empleado: DatosPersonalesEntity | undefined;

    if (typeof trabajador === 'string') {
      empleado = this.trabajadores.find(
        (item) => item.empleado_nombres_apellidos === trabajador
      );
    } else if (trabajador?.empleado_codigo) {
      empleado = this.trabajadores.find(
        (item) => item.empleado_codigo === trabajador.empleado_codigo
      );
    } else if (trabajador?.empleado_nombres_apellidos) {
      empleado = this.trabajadores.find(
        (item) => item.empleado_nombres_apellidos === trabajador.empleado_nombres_apellidos
      );
    }

    if (empleado) {
      const sueldoBasico = Number.parseFloat(String(empleado.empleado_remuneracion ?? 0)) || 0;
      const asignacionFamiliar = Number(empleado.liquidacion_asignacion_familiar ?? 0);
      const promedioGratificacion = Number(empleado.liquidacion_promedio_gratificacion ?? 0);
      this.LiquidacionForm.patchValue({
        liquidacion_trabajador: empleado.empleado_nombres_apellidos,
        liquidacion_sueldo_basico: Number(sueldoBasico.toFixed(2)),
        liquidacion_asignacion_familiar: Number(asignacionFamiliar.toFixed(2)),
        liquidacion_promedio_gratificacion: Number(promedioGratificacion.toFixed(2)),
        liquidacion_fecha_inicio: empleado.empleado_fecha_inicio
      });
      
      // Formatear los campos del DOM después de un ciclo de cambio
      setTimeout(() => this.formatearCamposNumericos(), 100);
      
      // Si ya hay fecha de cese seleccionada, calcular liquidación
      if (this.LiquidacionForm.get('liquidacion_fecha_cese')?.value) {
        this.llenarCamposLiquidacion();
      }
    }
  }

  // Llenar campos de liquidación según el tipo de cese seleccionado
  llenarCamposLiquidacion() {
    const sueldoB = this.LiquidacionForm.get('liquidacion_sueldo_basico')?.value || 0;

    if ( !sueldoB) return;

    

    // Calcular valores según el tipo de cese
    const CTST = sueldoB * 0.25;
    const gratiT = sueldoB * 1;
    const otrosB = sueldoB * 0;
    const vacacionesT = sueldoB * 1;
    const bonifE = sueldoB * 0.5;
    const desctRr = sueldoB * 0.5;

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
    
    // Formatear campos después de actualizar
    setTimeout(() => this.formatearCamposNumericos(), 50);
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
    
    // Formatear el campo del total
    setTimeout(() => {
      const totalControl = this.LiquidacionForm.get('liquidacion_total_pagar');
      if (totalControl && totalControl.value) {
        const valor = parseFloat(totalControl.value);
        if (!isNaN(valor)) {
          totalControl.setValue(valor.toFixed(2), { emitEvent: false });
        }
      }
    }, 10);
  }

  async onCellClicked(event: any) {
    const data = event.data;

    // Prevenir selección automática de AG-Grid
    event.node.setSelected(false);

    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Mantener selección anterior
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

    // Cargar datos del registro seleccionado
    this.cargarDatosRegistro(data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: any, node?: any): void {
    this.camponuevo = false;
    this.filaSeleccionada = data;
    this.gridApi.deselectAll();

    // Seleccionar el nodo en AG-Grid
    if (node) {
      node.setSelected(true);
    } else {
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
      liquidacion_tipo_cese: this.obtenerValorTipoCese(data.liquidacion_tipo_cese),
      liquidacion_cts_total: data.liquidacion_cts_total || 0,
      liquidacion_gratificacion_total: data.liquidacion_gratificacion_total || 0,
      liquidacion_otros_beneficios: data.liquidacion_otros_beneficios || 0,
      liquidacion_vacaciones_total: data.liquidacion_vacaciones_total || 0,
      liquidacion_bonificacion_extraordinaria: data.liquidacion_bonificacion_extraordinaria || 0,
      liquidacion_descuento_rr: data.liquidacion_descuento_rr || 0,
      liquidacion_total_pagar: data.liquidacion_total_pagar || 0,
      liquidacion_observaciones: data.liquidacion_observaciones || '',
      aguinaldo: data.aguinaldo || 0,
      bono14: data.bono14 || 0,
      vacaciones: data.vacaciones || 0,
      indemnizacion: data.indemnizacion || 0,
      trabajadorSelect: data.trabajadorSelect || 'No'
    });

    // Deshabilitar todos los campos del formulario
    const estado = data.liquidacion_estado;
    if(estado == 'Aprobada'){
      this.LiquidacionForm.disable();
    } else {
      this.LiquidacionForm.enable();
      // Deshabilitar campos específicos que se auto-calculan
    this.LiquidacionForm.get('liquidacion_sueldo_basico')?.disable();
    this.LiquidacionForm.get('liquidacion_asignacion_familiar')?.disable();
    this.LiquidacionForm.get('liquidacion_promedio_gratificacion')?.disable();
    this.LiquidacionForm.get('liquidacion_fecha_inicio')?.disable();
    this.LiquidacionForm.get('liquidacion_total_pagar')?.disable();
    this.LiquidacionForm.get('liquidacion_estado')?.disable();
    }
    
    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }

  async botonNuevaLiquidacion() {
    console.log('🟢 INICIO botonNuevaLiquidacion');
    
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      console.log('  Usuario canceló');
      return; // Cancelar acción
    }

    console.log(' Usuario confirmó, activando modo nuevo');
    this.camponuevo = true;
    console.log('camponuevo después de asignar true:', this.camponuevo);
    
    this.filaSeleccionada = null;
    this.gridApi?.deselectAll();
    this.prepararFormularioNuevo();

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
    
    console.log('🟢 FIN botonNuevaLiquidacion - camponuevo:', this.camponuevo);
  }
  botonGuardar() {
    
    if (this.LiquidacionForm.invalid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    // Validar campos obligatorios específicos
    const trabajador = this.LiquidacionForm.get('liquidacion_trabajador')?.value;
    const fechaC = this.LiquidacionForm.get('liquidacion_fecha_cese')?.value;
    const tipoC = this.LiquidacionForm.get('liquidacion_tipo_cese')?.value;

    console.log('Valores obligatorios:', { trabajador, fechaC, tipoC });

    if (!trabajador || !fechaC || !tipoC) {
      console.log('  Falta algún campo obligatorio');
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    // Obtener valores usando getRawValue para incluir campos deshabilitados
    const formValues = this.LiquidacionForm.getRawValue();
    console.log('Form values completos:', formValues);

    // Generar código automático para nuevos permisos
    const codigo = !this.filaSeleccionada ? this.generarNuevoCodigo() : this.filaSeleccionada?.liquidacion_codigo;
    console.log('Código generado:', codigo);

    const toNumber = (value: any): number => {
      if (typeof value === 'number') return value;
      const limpio = String(value ?? '').replace(/,/g, '').trim();
      const numero = Number.parseFloat(limpio);
      return Number.isFinite(numero) ? numero : 0;
    };

    const toDateString = (value: any): string => {
      if (!value) return '';
      if (value instanceof Date) {
        const y = value.getFullYear();
        const m = String(value.getMonth() + 1).padStart(2, '0');
        const d = String(value.getDate()).padStart(2, '0');
        return `${y}-${m}-${d}`;
      }
      return String(value);
    };

    // Crear objeto con los datos del formulario
    const liquidacionData: LiquidacionEntity = {
      liquidacion_codigo: codigo,
      liquidacion_trabajador: String(formValues.liquidacion_trabajador ?? ''),
      liquidacion_fecha_inicio: toDateString(formValues.liquidacion_fecha_inicio),
      liquidacion_estado: this.filaSeleccionada?.liquidacion_estado || 'En revisión',
      liquidacion_sueldo_basico: toNumber(formValues.liquidacion_sueldo_basico),
      liquidacion_asignacion_familiar: toNumber(formValues.liquidacion_asignacion_familiar),
      liquidacion_promedio_gratificacion: toNumber(formValues.liquidacion_promedio_gratificacion),
      liquidacion_fecha_cese: toDateString(formValues.liquidacion_fecha_cese),
      liquidacion_tipo_cese: this.obtenerLabelTipoCese(formValues.liquidacion_tipo_cese),
      liquidacion_cts_total: toNumber(formValues.liquidacion_cts_total),
      liquidacion_gratificacion_total: toNumber(formValues.liquidacion_gratificacion_total),
      liquidacion_otros_beneficios: toNumber(formValues.liquidacion_otros_beneficios),
      liquidacion_vacaciones_total: toNumber(formValues.liquidacion_vacaciones_total),
      liquidacion_bonificacion_extraordinaria: toNumber(formValues.liquidacion_bonificacion_extraordinaria),
      liquidacion_descuento_rr: toNumber(formValues.liquidacion_descuento_rr),
      liquidacion_total_pagar: toNumber(formValues.liquidacion_total_pagar),
      liquidacion_observaciones: String(formValues.liquidacion_observaciones ?? ''),
      aguinaldo: toNumber(formValues.aguinaldo),
      bono14: toNumber(formValues.bono14),
      vacaciones: toNumber(formValues.vacaciones),
      indemnizacion: toNumber(formValues.indemnizacion),
      trabajadorSelect: String(formValues.trabajadorSelect ?? 'No'),
    };

    console.log('Datos de liquidación creados:', liquidacionData);

    // Si NO hay fila seleccionada, es una NUEVA liquidación
    if (!this.filaSeleccionada) {
      console.log(' CREAR NUEVA - filaSeleccionada es null');
      console.log('rowData ANTES, length:', this.rowData.length);
      
      // Agregar al inicio del array rowData
      this.rowData = [liquidacionData, ...this.rowData];
      
      console.log('rowData DESPUÉS, length:', this.rowData.length);
      console.log('Primer elemento:', this.rowData[0]);

      // Actualizar la tabla completamente
      if (this.gridApi) {
        console.log(' gridApi existe, actualizando tabla...');
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        console.log('setGridOption ejecutado');
      } else {
        console.error('  gridApi NO existe');
      }
      this.toastService.success("¡Liquidación creada exitosamente!");
    }
    // Si HAY fila seleccionada, es EDICIÓN
    else {
      console.log('  EDITAR - filaSeleccionada existe');
      
      // Actualizar los valores de la fila seleccionada
      Object.assign(this.filaSeleccionada, liquidacionData);

      if (this.gridApi) {
        this.gridApi.applyTransaction({
          update: [this.filaSeleccionada]
        });
        this.gridApi.refreshCells();
      }
      this.toastService.success("¡Se guardaron cambios exitosamente!");
    }

    this.rrHhFacade.actualizarRegistrarLiquidacion(this.rowData);

    console.log('Limpiando formulario...');
    if (!this.filaSeleccionada) {
      // En creación nueva sí se limpia el formulario.
      this.prepararFormularioNuevo();
      this.filaSeleccionada = null;
      this.camponuevo = false;
      this.formValidationService.resetearEstado();
    } else {
      // En edición se mantiene el formulario con los datos guardados.
      this.camponuevo = false;
      this.formValidationService.resetearEstado();
    }
    console.log('🔵 FIN botonGuardar');
  }
  onIndemnizacionChange(event: any) {
    this.indemnizacion = event.detail.checked;
    console.log(event.detail.checked);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  // Generar código automático para nuevas operaciones
  generarNuevoCodigo(): string {
    const numeros = this.rowData.map(item => {
      // Buscar tanto LIQ-001 como LIQ001
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
        this.rowData = this.rrHhFacade.registrarLiquidacion();
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

  async modalverActualizaciones() {
    // Definir las columnas
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 150},
      { headerName: 'Usuario', field: 'usuario', width: 120},
      { headerName: 'Acción', field: 'accion', width: 150},
      { headerName: 'Detalle del cambio', field: 'detalleCambio', flex: 1,
        wrapText: true,
        autoHeight: true,
      cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
    ];

    // Datos de ejemplo
    const rowData = [
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial de la liquidación' },
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de la fecha de cese'},
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de actualizaciones de la liquidación ${this.filaSeleccionada?.liquidacion_codigo || ''}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

  async modalDetalleCTS() {
    const dataCTS = [
      { concepto: 'CTS trunca (Meses)', baseM: '3500.00', formula: 'Base = 12 + meses', meses: 3, dias: '-', monto: '2916.67', isTotal: false },
      { concepto: 'CTS trunca (Días)', baseM: '3500.00', formula: 'Base ÷ 12 ÷ 30 × días', meses: '-', dias: 15, monto: '1750.00', isTotal: false },
      { concepto: 'Total CTS', baseM: '-', formula: '-', meses: '-', dias: '-', monto: '4666.67', isSemibold: true },
      { concepto: 'Total vacaciones a pagar', baseM: '-', formula: '-', meses: '-', dias: '-', monto: '4666.67', isTotal: true }
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

  async modalDetalleGrati() {
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

  async modalDetalleVac() {
    const dataFondoPensiones = [
      { detalle: 'Fondo de pensión', porcentaje: 10.00, monto: 573.11, isTotal: false },
      { detalle: 'Comisión fija', porcentaje: 1.69, monto: 12.39, isTotal: false },
      { detalle: 'Prima de seguro', porcentaje: 1.37, monto: 10.03, isTotal: false },
      { detalle: 'AFP PROFUTURO FLUJО', porcentaje: 13.06, monto: 595.48, isTotal: false }
    ];

    const dataVacaciones = [
      { concepto: 'Vacaciones truncas (Meses)', baseM: '3500.00', formula: 'Base = 12 + meses', meses: 10, dias: '-', monto: '573.11', isTotal: false },
      { concepto: 'Vacaciones truncas (Días)', baseM: '3500.00', formula: 'Base = 12 + 30 + días', meses: '-', dias: 29, monto: '564.44', isTotal: false },
      { concepto: 'Total vacaciones', baseM: '-', formula: '-', meses: '-', dias: '-', monto: '731.11', isSemibold: true },
      { concepto: 'Descuento provisional (AFP)', baseM: '-', formula: '13.06% x total', meses: '-', dias: '-', monto: '-95.48', isLightBlue: true },
      { concepto: 'Total vacaciones a pagar', baseM: '-', formula: '-', meses: '-', dias: '-', monto: '635.63', isTotal: true }
    ];

    const colDefsFondoPensiones = [
      { field: 'detalle', headerName: 'Detalle', width: 200 },
      { field: 'porcentaje',headerClass: 'derechaencabezado', cellClass: 'justify-end', headerName: 'Porcentaje', width: 120, valueFormatter: (params: any) => params.value ? `${params.value.toFixed(2)}%` : '-' },
      { field: 'monto',headerClass: 'derechaencabezado', cellClass: 'justify-end', headerName: 'Monto', width: 120, valueFormatter: (params: any) => params.value ? `S/${params.value.toFixed(2)}` : '-' }
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
      {
        headerClass: 'derechaencabezado', field: 'promedio', headerName: 'Promedio salario ordinario', flex: 1,
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
      },
      { field: 'formula', headerName: 'Fórmula base', flex: 3 },
      {
        headerClass: 'derechaencabezado', field: 'monto', headerName: 'Monto', flex: 1,
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
      {
        headerClass: 'derechaencabezado', field: 'promedio', headerName: 'Promedio salario ordinario', flex: 1,
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
      },
      { field: 'formula', headerName: 'Fórmula base', flex: 3 },
      {
        headerClass: 'derechaencabezado', field: 'monto', headerName: 'Monto', flex: 1,
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
      {
        headerClass: 'derechaencabezado', field: 'promedio', headerName: 'Promedio salario ordinario', flex: 1,
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
      },
      { field: 'formula', headerName: 'Fórmula base', flex: 3 },
      {
        headerClass: 'derechaencabezado', field: 'monto', headerName: 'Monto', flex: 1,
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
  async abrirModalIndemnizacion() {
    const dataAguinaldo = [
      { concepto: 'Indemnización', promedio: 'Q 3,816.90', formula: '(Promedio salario ordinario * 14 salarios /  12 meses / 365 días) * días laborados', meses: 4, dias: '-', monto: 'Q 324.18', isTotal: false },
      { concepto: 'Total indemnización', baseM: 0, formula: '-', meses: '-', dias: '-', monto: 'Q 324.18', isTotal: false },
      { concepto: 'Total indemnización a pagar', baseM: 0, formula: '-', meses: '-', dias: '-', monto: 'Q 324.18', isTotal: true }
    ];
    const coldefAguinaldo = [
      { field: 'concepto', headerName: 'Concepto', flex: 2 },
      {
        headerClass: 'derechaencabezado', field: 'promedio', headerName: 'Promedio salario ordinario', flex: 1,
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
      },
      { field: 'formula', headerName: 'Fórmula base', flex: 3 },
      {
        headerClass: 'derechaencabezado', field: 'monto', headerName: 'Monto', flex: 1,
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

  // Método para formatear campos numéricos a 2 decimales
  private formatearCamposNumericos() {
    const camposNumericos = [
      'liquidacion_sueldo_basico',
      'liquidacion_asignacion_familiar',
      'liquidacion_promedio_gratificacion',
      'liquidacion_cts_total',
      'liquidacion_gratificacion_total',
      'liquidacion_otros_beneficios',
      'liquidacion_vacaciones_total',
      'liquidacion_bonificacion_extraordinaria',
      'liquidacion_descuento_rr',
      'aguinaldo',
      'bono14',
      'vacaciones',
      'indemnizacion',
      'liquidacion_total_pagar'
    ];

    camposNumericos.forEach(campo => {
      const control = this.LiquidacionForm.get(campo);
      if (control && control.value !== null && control.value !== undefined && control.value !== '') {
        const valor = parseFloat(control.value);
        if (!isNaN(valor)) {
          control.setValue(valor.toFixed(2), { emitEvent: false });
        }
      }
    });
  }
}

