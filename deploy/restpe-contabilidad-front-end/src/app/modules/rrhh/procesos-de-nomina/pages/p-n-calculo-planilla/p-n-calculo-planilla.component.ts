import { Component, OnDestroy, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { Subscription } from 'rxjs';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CalcularConceptoComponent } from '../../modals/calcular-concepto/calcular-concepto.component';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { PlanillaEntity } from 'src/app/modules/rrhh/domain/models/planilla.entity';

// Font Awesome Icons
import { faEye, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { DatosPersonalesEntity } from '@modules/rrhh/domain/models/datos-personales.entity';



@Component({
  selector: 'app-p-n-calculo-planilla',
  templateUrl: './p-n-calculo-planilla.component.html',
  styleUrls: ['./p-n-calculo-planilla.component.scss'],
  standalone: false,
})
export class PNCalculoPlanillaComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farEye = faEye;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  countries = ALL_COUNTRIES;
  informacionForm!: FormGroup;
  ConceptosFijosForm!: FormGroup;
  planillaSeleccionada: string = 'desde';
  mostrarcalculo: boolean = false;
  pais = this.countryService.getCountryCode();
  filaSeleccionada: any = null;
  trabajadorSeleccionado: any = null;
  monedapais: any = 'S/';
  panelLateralVisible: boolean = true;
  tabSeleccionado: string = 'jornadaLaboral';
  private gridApi!: GridApi;
  private readonly rrHhFacade = inject(RrHhFacade);
  readonly isLoading = this.rrHhFacade.loadingCalculoPlanilla;
  isResetting = false;
  private gridApiDetalle!: GridApi;
  private gridApiTributos!: GridApi;
  private gridApiDescuentos!: GridApi;
  private gridApiIngresos!: GridApi;
  private empleadosTimerId?: ReturnType<typeof setInterval>;
  private calculoPlanillaTimerId?: ReturnType<typeof setInterval>;
  private resetTimerId?: ReturnType<typeof setInterval>;
  private readonly pollIntervalMs = 100;
  private readonly maxPollAttempts = 200;
  private jornadaHorasSubscription?: Subscription;
  anioSeleccionado: number|null = null;
  mesSeleccionado: number|null = null;
  startDate: Date = new Date();
  endDate: Date = new Date();
  minDate: Date = new Date(2020, 0, 1);
  maxDate: Date = new Date(2030, 11, 31);
  deshabilitar: boolean = false;
  tipoIngresos = [
    { value: '1', nombre: 'Sueldo' },
    { value: '2', nombre: 'Asignaciones' },
    { value: '3', nombre: 'Propinas' },
    { value: '4', nombre: 'Horas extra' },
    { value: '5', nombre: 'Bono' },
    { value: '6', nombre: 'Comisiones' },
    { value: '7', nombre: 'Otros ingresos' },
    { value: '8', nombre: 'Metas' },
    { value: '9', nombre: 'Recargo al consumo' },
  ]

   sucursales = [
    { id: '1', nombre: 'Miraflores'},
    { id: '2', nombre: 'San Isidro'},
    { id: '3', nombre: 'Surco'},
    { id: '4', nombre: 'Lima Norte'},
    { id: '5', nombre: 'Lima Centro'},
   ]
  periodicidadesPago = [
    { value: 'diaria', label: 'Diaria' },
    { value: 'semanal', label: 'Semanal' },
    { value: 'quincenal', label: 'Quincenal' },
    { value: 'mensual', label: 'Mensual' }
  ];
  tiposPlanilla = [
    { value: 'Sueldo', label: 'Sueldo' },
    { value: 'CTS', label: 'CTS' },
    { value: 'Gratificacion', label: 'Gratificación' }
  ];
  tipoDescuentos = [
    { value: '1', nombre: 'Adelanto de sueldo' },
    { value: '2', nombre: 'Adelanto de gratificación' },
    { value: '3', nombre: 'Préstamo personal' },
  ]
  claseAportes = [
    { value: '1', nombre: 'Essalud' },
    { value: '2', nombre: 'SCTR' },
    { value: '3', nombre: 'Seguro ley de vida' },
  ]
  claseRetencion = [
    { value: '1', nombre: 'AFP' },
    { value: '2', nombre: 'ONP' },
    { value: '3', nombre: 'Renta de 5ta categoría' },
  ]
   estados = [
    'Aprobado',
    'Pendiente',
  ]
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
  columnTypes = {
    rightAligned: {
      headerClass: 'ag-right-aligned-header',
      cellClass: 'ag-right-aligned-cell'
    }
  };
  columnDefs: ColDef[] = [
    { field: 'planilla_codigo', headerName: 'Código',  width:80 , },
    { field: 'planilla_periodo', headerName: 'Periodo', width:80 , filter: true },
    { field: 'planilla_tipo_planilla', headerName: 'Tipo de planilla', width: 110, filter: true,
      valueFormatter: (params: any) => {
        const tipoMap: any = {
          'Sueldo': 'Sueldo',
          'CTS': 'CTS',
          'Gratificación': 'Gratificación'
        };
        return tipoMap[params.value] || params.value;
      }
    },
    { field: 'planilla_fecha_registro', headerName: 'Fecha registro', flex: 1,
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
    { field: 'planilla_sucursal', headerName: 'Sucursal', flex: 1, filter: true },
    { field: 'planilla_calculo_desde', headerName: 'Cálculo desde', flex: 1,
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
      { field: 'planilla_calculo_hasta', headerName: 'Cálculo hasta', flex: 1,
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
      field: 'planilla_empleados_codigos',
      headerName: 'N° trabajadores',
      flex: 1,
      valueGetter: (params: any) => {
        const codigos = params.data?.planilla_empleados_codigos;
        if (Array.isArray(codigos)) {
          return codigos.length;
        }
        return 0;
      }
    },
     { field: 'planilla_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Aprobado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Aprobado</span>'
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-[#363636]">Pendiente</span>'
        } else if (params.value === 'Devuelto') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#BC2626]">Devuelto</span>'
        }
        return params.value;
      }
    }
  ];
  colDefsDetalle: ColDef[] = [
    { field: 'empleado_codigo', headerName: 'Código', width: 80 },
    { field: 'empleado_nombres_apellidos', headerName: 'Nombre trabajador', flex: 1, minWidth: 150 },
    { field: 'empleado_tipo_documento', headerName: 'Tipo de documento', width: 150 },
    { field: 'empleado_documento', headerName: 'N° de documento', width: 150 },
    { field: 'empleado_ingresos', headerName: 'Ingresos', headerClass: 'derechaencabezado', width: 100,
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
    { field: 'empleado_descuentos', headerName: 'Descuentos', headerClass: 'derechaencabezado', width: 100,
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
    { field: 'empleado_aportes', headerName: 'Aportes Trabajados', width: 150, },
    { field: 'empleado_neto', headerName: 'Neto a pagar', headerClass: 'derechaencabezado', width: 100,
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
    { field: 'aporteempleado', headerName: 'Aporte empleado', headerClass: 'derechaencabezado', width: 120,
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
    { field: 'empleado_estado', headerName: 'Estado', width: 100, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', }, filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
        } else if (params.value === 'Inactivo') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Parcial</span>';
        }
        return params.value;
      },
    }
  ];
  colDefsIngresos: ColDef[] = [
    { field: 'planilla_codigo', headerName: 'Código', width: 80, resizable: true, sortable: true },
    { field: 'concepto', headerName: 'Concepto', flex: 1, minWidth: 150, resizable: true, sortable: true },
    { field: 'devengo', headerName: `Devengado (${this.monedapais})`, headerClass: 'derechaencabezado', editable: true,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      valueFormatter: (params: any) => {
        if (params.data) {
          return `${this.monedapais} ${params.value}`;
        }
        return '-';
      }
    },
    { field: 'pagado', headerName: `Pagado (${this.monedapais})`, headerClass: 'derechaencabezado', editable: true,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      valueFormatter: (params: any) => {
        if (params.data) {
          return `${this.monedapais} ${params.value}`;
        }
        return '-';
      }
    }
  ];
  colDefsDescuentos: ColDef[] = [
    { field: 'planilla_codigo', headerName: 'Código', width: 80, resizable: true, sortable: true },
    { field: 'concepto', headerName: 'Concepto', flex: 1, minWidth: 150, resizable: true, sortable: true },
    { field: 'monto', headerName: 'Monto', headerClass: 'derechaencabezado', editable: true,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      valueFormatter: (params: any) => {
        if (params.data) {
          return `${this.monedapais} ${params.value}`;
        }
        return '-';
      }
    },
  ];
  colDefsTributos: ColDef[] = [
    { field: 'planilla_codigo', headerName: 'Código', width: 80, resizable: true, sortable: true },
    { field: 'concepto', headerName: 'Concepto', flex: 1, minWidth: 150, resizable: true, sortable: true },
    { field: 'basecalculo', headerName: `Base de cálculo (${this.monedapais})`, headerClass: 'derechaencabezado', editable: true,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      valueFormatter: (params: any) => {
        if (params.data) {
          return `${this.monedapais} ${params.value}`;
        }
        return '-';
      }
    },
    { field: 'monto', headerName: `Monto (${this.monedapais})`, headerClass: 'derechaencabezado', editable: true,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      valueFormatter: (params: any) => {
        if (params.data) {
          return `${this.monedapais} ${params.value}`;
        }
        return '-';
      }
    }
  ];
  // Todos los trabajadores con su sucursal
  empleados: DatosPersonalesEntity [] = [];
  // Trabajadores filtrados según sucursal seleccionada
  rowDataDetalle: any[] = [];
  rowData: PlanillaEntity[] = [];
  rowDataIngresos: any[] = [];
  rowDataDescuentos: any[] = [
    { planilla_codigo: '0701', concepto: 'ADELANTO', monto: '' },
    { planilla_codigo: '0702', concepto: 'CUOTA INICIAL', monto: '' },
    { planilla_codigo: '0701', concepto: 'OTROS DESCUENTOS NO DEDUCIBLES DE BASE IMPONIB', monto: '', }
  ];
  rowDataTributos: any[] = [
    { planilla_codigo: '0601', concepto: 'COMISIÓN AFP PORCENTUAL', basecalculo: '', monto: '' },
    { planilla_codigo: '0602', concepto: 'CONAFOVICER', basecalculo: '', monto: '' },
    { planilla_codigo: '0605', concepto: 'RENTA QUINTA CATEGORÍA RETENCIONES', basecalculo: '', monto: '' },
    { planilla_codigo: '0606', concepto: 'PRIMA SEGURO AFP', basecalculo: '', monto: '' },
  ];
  rowDataCalcularConcepto: any[] = []
  rowDataCalcularConceptoDef: any[] = [
    { idTrabajador: 'ID-2025-00001', afp: 'ONP', cok: 'M', nombres: 'Alexander Alberto', apellidos: 'Palomeque Aguirre', cuspp: '-', cargo: 'Gerente de administración', sueldo: 1200.00, asigFamiliar: 0.00, totalSoles: 1200.00, Fondo: 0.00, Seg: 0.00, Comision: 0.00, 'Total AfP': 0.00, ONP: 156.00, 'Adelanto Quincena': 0.00, 'Total descuentos': 156.00, 'Saldo Neto Pago Soles': 1044.00, Essalud: 108.00, 'Total aportes': 108.00 },
    { idTrabajador: 'ID-2025-00002', afp: 'Integra', cok: 'M', nombres: 'Rian Eusebio', apellidos: 'Chang Castagirino', cuspp: '6844015FP240', cargo: 'Técnico mecánico', sueldo: 1200.00, asigFamiliar: 0.00, totalSoles: 1200.00, Fondo: 128.48, Seg: 0.00, Comision: 15.48, 'Total AfP': 143.96, ONP: 156.00, 'Adelanto Quincena': 0.00, 'Total descuentos': 299.96, 'Saldo Neto Pago Soles': 900.04, Essalud: 101.70, 'Total aportes': 101.70 },
    { idTrabajador: '', afp: '', cok: '', nombres: '', apellidos: '', cuspp: '', cargo: '', sueldo: 1200.00, asigFamiliar: 0.00, totalSoles: 1200.00, Fondo: 128.48, Seg: 0.00, Comision: 15.48, 'Total AfP': 143.96, ONP: 156.00, 'Adelanto Quincena': 0.00, 'Total descuentos': 299.96, 'Saldo Neto Pago Soles': 900.04, Essalud: 101.70, 'Total aportes': 101.70 },
  ];
  rowDataCalcularConceptoGT: any[] = [
    { idTrabajador: 'ID-2025-00001', nombres: 'Alexander Alberto', apellidos: 'Palomeque Aguirre', cargo: 'Gerente de administración', centroCosto: 'Administración', salario: 3816.30, bonifDecr: 0.350, diasLab: 15, sueldoOrd: 1908.45, bonificacion: 0.00, horasExt: 0.00, totalDevengado: 1908.45, igssLaboral: 0.92, igrAsalariados: 0.00, otrosDescuentos: 0.00, totalPagar: 1907.53 },
    { idTrabajador: 'ID-2025-00002', nombres: 'Rian Eusebio', apellidos: 'Chang Castagirino', cargo: 'Técnico mecánico', centroCosto: 'Logística', salario: 3816.30, bonifDecr: 0.250, diasLab: 15, sueldoOrd: 1908.45, bonificacion: 0.00, horasExt: 0.00, totalDevengado: 1908.45, igssLaboral: 0.92, igrAsalariados: 0.00, otrosDescuentos: 0.00, totalPagar: 1907.53 },
    { idTrabajador: 'ID-2025-00003', nombres: 'Odalucha Manuel', apellidos: 'Espinoza Valladolid', cargo: 'Ayudante de mantenimiento', centroCosto: 'Logística', salario: 3816.30, bonifDecr: 0.00, diasLab: '', sueldoOrd: '', bonificacion: 0.00, horasExt: 0.00, totalDevengado: 0.00, igssLaboral: 0.00, igrAsalariados: 0.00, otrosDescuentos: 0.00, totalPagar: 0.00 },
    { idTrabajador: '', nombres: '', apellidos: '', cargo: '', centroCosto: '', salario: 11470.00, bonifDecr: 750.00, diasLab: '', sueldoOrd: 5725.35, bonificacion: 0.00, horasExt: 385.44, totalDevengado: 3882.64, igssLaboral: 184.36, igrAsalariados: 0.00, otrosDescuentos: 0.00, totalPagar: 3882.64 },
  ]

  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private countryService: CountryService,
    private formValidationService: FormValidationService,
  ) { 
  }

  ngOnInit() {
    this.initializeInformacionForm()
    this.initializeForm();
    this.configurarCalculoTotalHoras();
    this.cargarTablaconeptos();
    this.obtenerdatosdepais();
    this.cargarDatosIngresos();

    this.rrHhFacade.cargarDatosPersonales();
    let empleadosAttempts = 0;
    this.clearEmpleadosTimer();
    this.empleadosTimerId = setInterval(() => {
      empleadosAttempts += 1;
      this.empleados = [...this.rrHhFacade.datosPersonales()];
      if (!this.rrHhFacade.loadingDatosPersonales() || empleadosAttempts >= this.maxPollAttempts) {
        this.clearEmpleadosTimer();
      }
    }, this.pollIntervalMs);

    // Inicializar servicio de validación con ambos formularios
    this.formValidationService.inicializarFormulario(this.ConceptosFijosForm);
    this.formValidationService.resetearEstado();

    this.rrHhFacade.cargarCalculoPlanilla();
    let calculoAttempts = 0;
    this.clearCalculoPlanillaTimer();
    this.calculoPlanillaTimerId = setInterval(() => {
      calculoAttempts += 1;
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.calculoPlanilla();
        if (this.gridApi) {
          // Restaurar fila seleccionada si existe (al volver a la pantalla, por referencia de objeto)
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
        this.clearCalculoPlanillaTimer();
      } else if (calculoAttempts >= this.maxPollAttempts) {
        this.clearCalculoPlanillaTimer();
      }
    }, this.pollIntervalMs);
  }

  ngOnDestroy(): void {
    this.jornadaHorasSubscription?.unsubscribe();
    this.clearEmpleadosTimer();
    this.clearCalculoPlanillaTimer();
    this.clearResetTimer();
    this.formValidationService.limpiarFormulario();
  }
  obtenerdatosdepais() {
    const pais = this.countries.find(c => c.codigo === this.pais);
    if (pais) {
      this.tipoIngresos = pais.tipoIngresos ?? [];
      this.tipoDescuentos = pais.tipoDescuentos ?? [];
      this.claseAportes = pais.claseAportes ?? [];
      this.claseRetencion = pais.claseRetencion ?? [];
    };
    this.countries.find(c => {
      if (c.codigo === this.pais) {
        c.monedapais?.find(tip => {
          this.monedapais = tip.simbolo;
        })
      }
    });
  };
  cargarDatosIngresos() {
    if (this.pais === 'GT') {
      this.rowDataIngresos = [
        {planilla_codigo: '0105', concepto: 'TRABAJO SOBRETIEMPO', devengo: 2500.00, pagado: 2500.00,},
        {planilla_codigo: '0106', concepto: 'Otros ingresos', devengo: 2500.00, pagado: 2500.00,},
      ];
      this.rowDataTributos = [
        { planilla_codigo: '0601', concepto: 'IGSS (Cuota Laboral)', basecalculo: '', monto: '' },
        { planilla_codigo: '0602', concepto: 'Impuesto sobre la renta', basecalculo: '', monto: '' },
      ];
    } else {
      this.rowDataIngresos = [
        {
          planilla_codigo: '0105',
          concepto: 'TRABAJO SOBRETIEMPO (H, EXTRAS 25%)',
          devengo: 2500.00,
          pagado: 2500.00,
        },
        {planilla_codigo: '0106', concepto: 'Otros ingresos', devengo: 2500.00, pagado: 2500.00,},
      ];
      this.rowDataTributos = [
        { planilla_codigo: '0601', concepto: 'COMISIÓN AFP PORCENTUAL', basecalculo: '', monto: '' },
        { planilla_codigo: '0602', concepto: 'CONAFOVICER', basecalculo: '', monto: '' },
        { planilla_codigo: '0605', concepto: 'RENTA QUINTA CATEGORÍA RETENCIONES', basecalculo: '', monto: '' },
        { planilla_codigo: '0606', concepto: 'PRIMA SEGURO AFP', basecalculo: '', monto: '' },
      ];
    }
  }
  private initializeInformacionForm(): void {
    this.informacionForm = this.formBuilder.group({
      periodo: ['', Validators.required],
      tipoPlanilla: ['', Validators.required],
      sucursal: ['', Validators.required],
      periodicidadPago: ['', Validators.required],
      fechaVigenciaDesde: ['', Validators.required],
      fechaVigenciaHasta: ['', Validators.required],
      estadoSelect: ['Pendiente', Validators.required],
    })
  }
  
  periodoSeleccionado(periodo: { month: number, year: number }) {
    const mes = Number(periodo.month);
    const anio = Number(periodo.year);

    this.mesSeleccionado = Number.isFinite(mes) ? mes : null;
    this.anioSeleccionado = Number.isFinite(anio) ? anio : null;

    const mesFormateado = String(mes).padStart(2, '0');
    this.informacionForm.patchValue({
      periodo: `${anio}${mesFormateado}`
    });
  }
  private initializeForm(): void {
    this.ConceptosFijosForm = this.formBuilder.group({
      nombreConcepto: ['', Validators.required],
      categoriaSelect: ['', Validators.required],
      tipoIngresoSelect: [''],
      tipoDescuentoSelect: [''],
      tipoAporteSelect: [''],
      tipoClaseAporteSelect: [''],
      modoSelect: ['', Validators.required],
      montoInput: [''],
      valorInput: [''],
      fechaVigenciaDesde: [{ value: new Date().toLocaleDateString('es-PE'), disabled: true }, Validators.required],
      fechaVigenciaHasta: ['', Validators.required],
      conceptoVigencia: [false],
      aplicableSelect: ['', Validators.required],
      fechaAdquisicion: [''],
      cargo: [''],
      trabajador: [''],
      centroCosto: [''],
      grupoTrabajadores: [''],
      // Controles para Jornada Laboral
      diasLaborados: [''],
      diasSubsidiados: [''],
      diasNoLaborados: [''],
      diasTotal: [''],
      ordinariaH: [''],
      ordinariaM: [''],
      sobretiempoH: [''],
      sobretiempoM: [''],
      totalHoras: [''],
      totalMinutos: [''],
    });
  }
  nuevoCalculo() {
    this.mostrarcalculo = false;
    this.ConceptosFijosForm.reset();
    this.informacionForm.enable();
    this.deshabilitar = false;
    this.conceptosfijosformhabilitado();
    this.gridApi.deselectAll();
    this.informacionForm.reset({
      estadoSelect: 'Pendiente',
    });
    this.mesSeleccionado = null;
    this.anioSeleccionado = null;
    this.filaSeleccionada = null;
    this.trabajadorSeleccionado = null;
    this.rowDataDetalle = [];
    this.tabSeleccionado = 'jornadaLaboral';
  }
  async onCellClicked(event: any) {
    const data = event.data;
    const clickedNode = event.node;
    const elementoConFoco = document.activeElement as HTMLElement | null;

    if (!data) {
      return;
    }

    // Evita validaciones innecesarias cuando se hace clic en la misma fila.
    if (
      this.filaSeleccionada?.planilla_codigo &&
      data.planilla_codigo &&
      this.filaSeleccionada.planilla_codigo === data.planilla_codigo
    ) {
      return;
    }

    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Usuario canceló: restaurar selección anterior por referencia de objeto.
      if (this.gridApi && this.filaSeleccionada) {
        const prevData = this.filaSeleccionada;
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
            if (node.data === prevData) {
              node.setSelected(true);
            }
          });

          if (elementoConFoco && (elementoConFoco.tagName === 'INPUT' || elementoConFoco.tagName === 'TEXTAREA')) {
            setTimeout(() => elementoConFoco.focus(), 100);
          }
        }, 0);
      }
      return;
    }

    this.mostrarcalculo = true;
    this.filaSeleccionada = data;

    // Pausar detección de cambios mientras cargamos datos programáticamente
    this.formValidationService.pausarDeteccion();

    this.ConceptosFijosForm.disable();
    this.cargarTrabajadoresDeCalculoSeleccionado(data);
        
    // Seleccionar automáticamente el primer trabajador
    if (this.rowDataDetalle.length > 0) {
      this.trabajadorSeleccionado = this.rowDataDetalle[0];
      this.cargarDetalleTrabajador(this.rowDataDetalle[0]);
      if (this.gridApiDetalle) {
        this.gridApiDetalle.setGridOption('rowData', this.rowDataDetalle);
        const firstNode = this.gridApiDetalle.getDisplayedRowAtIndex(0);
        firstNode?.setSelected(true);
      }
    }

    const sucursalIds = this.obtenerIdsSucursalDesdeNombres(data.planilla_sucursal);
    this.informacionForm.patchValue({
      periodo: data.planilla_periodo,
      tipoPlanilla: data.planilla_tipo_planilla,
      sucursal: sucursalIds,
      periodicidadPago: data.planilla_periodicidad_pago,
      fechaVigenciaDesde: data.planilla_calculo_desde,
      fechaVigenciaHasta: data.planilla_calculo_hasta,
      estadoSelect: data.planilla_estado ?? 'Pendiente',
    });
    const periodoSeleccionado = String(data.planilla_periodo ?? '');
    this.mesSeleccionado = Number.parseInt(periodoSeleccionado.substring(4, 6), 10) || null;
    this.anioSeleccionado = Number.parseInt(periodoSeleccionado.substring(0, 4), 10) || null;
    this.informacionForm.disable();
    this.deshabilitar = true;

    // Seleccionar la fila por referencia directa al nodo capturado antes del await
    setTimeout(() => {
      this.gridApi?.deselectAll();
      clickedNode?.setSelected(true);
      // Reanudar y actualizar estado inicial con los valores ya cargados
      this.formValidationService.reanudarDeteccion();
    }, 0);
  }
  conceptosfijosformhabilitado(){
    this.informacionForm.get('estadoSelect')?.enable();
      // Habilitar campos de jornada laboral si el estado es Pendiente
      this.ConceptosFijosForm.get('diasLaborados')?.enable();
      this.ConceptosFijosForm.get('diasSubsidiados')?.enable();
      this.ConceptosFijosForm.get('diasNoLaborados')?.enable();
      this.ConceptosFijosForm.get('diasTotal')?.enable();
      this.ConceptosFijosForm.get('ordinariaH')?.enable();
      this.ConceptosFijosForm.get('ordinariaM')?.enable();
      this.ConceptosFijosForm.get('sobretiempoH')?.enable();
      this.ConceptosFijosForm.get('sobretiempoM')?.enable();
      this.ConceptosFijosForm.get('totalHoras')?.enable();
      this.ConceptosFijosForm.get('totalMinutos')?.enable();
  }
  togglePanelLateral(): void {
    this.panelLateralVisible = !this.panelLateralVisible;

  }
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // Restaurar la fila seleccionada al volver a la pantalla (por referencia de objeto)
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

  onBtReset(): void {
    this.isResetting = true;
    this.rrHhFacade.cargarCalculoPlanilla();
    let resetAttempts = 0;
    this.clearResetTimer();
    this.resetTimerId = setInterval(() => {
      resetAttempts += 1;
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.calculoPlanilla();
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.isResetting = false;
        this.clearResetTimer();
      } else if (resetAttempts >= this.maxPollAttempts) {
        this.isResetting = false;
        this.clearResetTimer();
      }
    }, this.pollIntervalMs);
  }

  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApiDetalle = params.api;
  }

  onCellClickedDetalle(event: any) {
    if (event.data) {
      console.log('Trabajador seleccionado:', event.data);
      event.node?.setSelected(true);
      this.trabajadorSeleccionado = event.data;
      this.cargarDetalleTrabajador(event.data);
      this.ConceptosFijosForm.disable();
    }
  }

  private cargarDetalleTrabajador(trabajador: any): void {
    this.ConceptosFijosForm.patchValue({
      diasLaborados: trabajador?.diasLaborados ?? 30,
      diasSubsidiados: trabajador?.diasSubsidiados ?? 0,
      diasNoLaborados: trabajador?.diasNoLaborados ?? 0,
      diasTotal: trabajador?.diasTotal ?? 30,
      ordinariaH: trabajador?.ordinariaH ?? trabajador?.ordinaria ?? '160',
      ordinariaM: trabajador?.ordinariaM ?? trabajador?.ordinaria2 ?? '00',
      sobretiempoH: trabajador?.sobretiempoH ?? trabajador?.sobretiempo ?? '000',
      sobretiempoM: trabajador?.sobretiempoM ?? trabajador?.sobretiempo2 ?? '00',
      totalHoras: trabajador?.totalHoras ?? trabajador?.totalHorasH ?? '160',
      totalMinutos: trabajador?.totalMinutos ?? trabajador?.totalHorasM ?? trabajador?.totalHoras2 ?? '00'
    });
    this.recalcularTotalHoras();
  }

  private configurarCalculoTotalHoras(): void {
    const controls = [
      this.ConceptosFijosForm.get('ordinariaH'),
      this.ConceptosFijosForm.get('ordinariaM'),
      this.ConceptosFijosForm.get('sobretiempoH'),
      this.ConceptosFijosForm.get('sobretiempoM')
    ];

    this.jornadaHorasSubscription?.unsubscribe();
    this.jornadaHorasSubscription = new Subscription();

    controls.forEach((control) => {
      if (!control) {
        return;
      }
      this.jornadaHorasSubscription?.add(
        control.valueChanges.subscribe(() => this.recalcularTotalHoras())
      );
    });

    this.recalcularTotalHoras();
  }

  private recalcularTotalHoras(): void {
    const horasOrdinarias = this.parseNumeroEntero(this.ConceptosFijosForm.get('ordinariaH')?.value);
    const minutosOrdinarios = this.parseNumeroEntero(this.ConceptosFijosForm.get('ordinariaM')?.value);
    const horasSobretiempo = this.parseNumeroEntero(this.ConceptosFijosForm.get('sobretiempoH')?.value);
    const minutosSobretiempo = this.parseNumeroEntero(this.ConceptosFijosForm.get('sobretiempoM')?.value);

    const minutosTotales = minutosOrdinarios + minutosSobretiempo;
    const acarreoHoras = Math.floor(minutosTotales / 60);
    const minutosResultado = minutosTotales % 60;
    const horasResultado = horasOrdinarias + horasSobretiempo + acarreoHoras;

    this.ConceptosFijosForm.patchValue(
      {
        totalHoras: String(horasResultado),
        totalMinutos: String(minutosResultado).padStart(2, '0')
      },
      { emitEvent: false }
    );
  }

  private parseNumeroEntero(valor: any): number {
    const numero = Number.parseInt(String(valor ?? '').trim(), 10);
    return Number.isFinite(numero) && numero >= 0 ? numero : 0;
  }
  onGridReadyIngresos(params: GridReadyEvent) {
    this.gridApiIngresos = params.api;
  }

  onGridReadyDescuentos(params: GridReadyEvent) {
    this.gridApiDescuentos = params.api;
  }
  onGridReadyTributos(params: GridReadyEvent) {
    this.gridApiTributos = params.api;
  }

  onfechaVigenciaDesdeSelected(fecha: Date) {
    console.log('Fecha calcular desde seleccionada:', fecha);
    this.informacionForm.patchValue({
      fechaVigenciaDesde: fecha,
    });
  }

  onfechaVigenciaHastaSelected(fecha: Date) {
    console.log('Fecha calcular hasta seleccionada:', fecha);
    this.informacionForm.patchValue({
     fechaVigenciaHasta: fecha,
    });
  }

  onSucursalSeleccionado(sucursalesSeleccionadas: any[] | null) {
    // app-autocomplete-multi emite IDs, por eso se mapean a nombres antes de filtrar.
    const idsSeleccionados = Array.isArray(sucursalesSeleccionadas)
      ? sucursalesSeleccionadas.map((id) => String(id))
      : [];

    const nombresSucursales = this.sucursales
      .filter((s) => idsSeleccionados.includes(String(s.id)))
      .map((s) => this.normalizarTexto(s.nombre));

    this.rowDataDetalle = this.empleados.filter((empleado) =>
      nombresSucursales.includes(this.normalizarTexto(empleado.empleado_sucursal))
    );

    this.trabajadorSeleccionado = null;

    if (this.gridApiDetalle) {
      this.gridApiDetalle.setGridOption('rowData', this.rowDataDetalle);
      this.gridApiDetalle.deselectAll();
    }
  }

  private cargarTrabajadoresDeCalculoSeleccionado(calculo: PlanillaEntity): void {
    if (Array.isArray(calculo.planilla_empleados_codigos) && calculo.planilla_empleados_codigos.length > 0) {
      const codigos = calculo.planilla_empleados_codigos.map((codigo) => String(codigo));
      this.rowDataDetalle = this.empleados.filter((empleado) => codigos.includes(String(empleado.empleado_codigo)));
      return;
    }

    const sucursalesSeleccionadas = this.obtenerNombresSucursalDesdeTexto(calculo.planilla_sucursal)
      .map((nombre) => this.normalizarTexto(nombre));

    this.rowDataDetalle = this.empleados.filter((empleado) =>
      sucursalesSeleccionadas.includes(this.normalizarTexto(empleado.empleado_sucursal))
    );
  }

  private obtenerNombresSucursalDesdeTexto(valor: string | null | undefined): string[] {
    return String(valor ?? '')
      .split(',')
      .map((texto) => texto.trim())
      .filter(Boolean);
  }

  private obtenerIdsSucursalDesdeNombres(valor: string | null | undefined): string[] {
    const nombresNormalizados = this.obtenerNombresSucursalDesdeTexto(valor).map((nombre) => this.normalizarTexto(nombre));
    return this.sucursales
      .filter((sucursal) => nombresNormalizados.includes(this.normalizarTexto(sucursal.nombre)))
      .map((sucursal) => String(sucursal.id));
  }

  private normalizarTexto(valor: string | null | undefined): string {
    return (valor ?? '').trim().toLowerCase();
  }
  cargarTablaconeptos() {
    if (this.pais == 'GT') {
      this.rowDataCalcularConcepto = this.rowDataCalcularConceptoGT;
    } else {
      this.rowDataCalcularConcepto = this.rowDataCalcularConceptoDef;
    }
  }

  private obtenerTrabajadoresParaModal(): DatosPersonalesEntity[] {
    if (this.rowDataDetalle.length > 0) {
      return [...this.rowDataDetalle];
    }

    const sucursalCalculo = this.normalizarTexto(this.filaSeleccionada?.planilla_sucursal);
    if (sucursalCalculo) {
      return this.empleados.filter((empleado) =>
        this.normalizarTexto(empleado.empleado_sucursal) === sucursalCalculo
      );
    }

    const idsSeleccionados = this.informacionForm.get('sucursal')?.value;
    const sucursalesSeleccionadas = Array.isArray(idsSeleccionados)
      ? this.sucursales
          .filter((sucursal) => idsSeleccionados.map((id: any) => String(id)).includes(String(sucursal.id)))
          .map((sucursal) => this.normalizarTexto(sucursal.nombre))
      : [];

    if (sucursalesSeleccionadas.length > 0) {
      return this.empleados.filter((empleado) =>
        sucursalesSeleccionadas.includes(this.normalizarTexto(empleado.empleado_sucursal))
      );
    }

    return [...this.empleados];
  }

  private construirDataModalCalculo(): any[] {
    const trabajadores = this.obtenerTrabajadoresParaModal();
    return this.pais === 'GT'
      ? this.construirDataModalGuatemala(trabajadores)
      : this.construirDataModalDefecto(trabajadores);
  }

  private construirDataModalDefecto(trabajadores: DatosPersonalesEntity[]): any[] {
    const filas = trabajadores.map((trabajador) => {
      const { nombres, apellidos } = this.separarNombreCompleto(trabajador.empleado_nombres_apellidos);
      const sueldo = this.parseNumeroDecimal(trabajador.empleado_remuneracion);
      const totalDescuentos = trabajador.empleado_descuentos ?? 0;
      const totalAportes = trabajador.empleado_aportes ?? 0;
      const esOnp = this.normalizarTexto(trabajador.empleado_regimen_pensionario) === 'onp';
      const fechaPeriodo = this.generarFechaPeriodo();

      return {
        idTrabajador: trabajador.empleado_codigo,
        afp: trabajador.empleado_regimen_pensionario?.toUpperCase() ?? '-',
        cok: trabajador.empleado_tipo_contrato?.charAt(0).toUpperCase() ?? '-',
        nombres,
        apellidos,
        cuspp: trabajador.empleado_documento ?? '-',
        cargo: trabajador.empleado_cargo,
        sueldo,
        asigFamiliar: 0,
        totalSoles: trabajador.empleado_ingresos ?? sueldo,
        Fondo: esOnp ? 0 : totalDescuentos,
        'Seg.': 0,
        Comision: 0,
        'Total AFP': esOnp ? 0 : totalDescuentos,
        ONP: esOnp ? totalDescuentos : 0,
        'Adelanto Quincena': 0,
        'Total descuentos': totalDescuentos,
        'Saldo Neto Pago Soles': trabajador.empleado_neto ?? 0,
        Essalud: totalAportes,
        'Total aportes': totalAportes,
        fechaRegistro: fechaPeriodo,
      };
    });

    if (filas.length === 0) {
      return filas;
    }

    return [
      ...filas,
      {
        idTrabajador: '',
        afp: '',
        cok: '',
        nombres: 'TOTAL',
        apellidos: '',
        cuspp: '',
        cargo: '',
        sueldo: filas.reduce((suma, fila) => suma + (fila.sueldo ?? 0), 0),
        asigFamiliar: filas.reduce((suma, fila) => suma + (fila.asigFamiliar ?? 0), 0),
        totalSoles: filas.reduce((suma, fila) => suma + (fila.totalSoles ?? 0), 0),
        Fondo: filas.reduce((suma, fila) => suma + (fila.Fondo ?? 0), 0),
        'Seg.': filas.reduce((suma, fila) => suma + (fila['Seg.'] ?? 0), 0),
        Comision: filas.reduce((suma, fila) => suma + (fila.Comision ?? 0), 0),
        'Total AFP': filas.reduce((suma, fila) => suma + (fila['Total AFP'] ?? 0), 0),
        ONP: filas.reduce((suma, fila) => suma + (fila.ONP ?? 0), 0),
        'Adelanto Quincena': 0,
        'Total descuentos': filas.reduce((suma, fila) => suma + (fila['Total descuentos'] ?? 0), 0),
        'Saldo Neto Pago Soles': filas.reduce((suma, fila) => suma + (fila['Saldo Neto Pago Soles'] ?? 0), 0),
        Essalud: filas.reduce((suma, fila) => suma + (fila.Essalud ?? 0), 0),
        'Total aportes': filas.reduce((suma, fila) => suma + (fila['Total aportes'] ?? 0), 0),
      }
    ];
  }

  private construirDataModalGuatemala(trabajadores: DatosPersonalesEntity[]): any[] {
    const filas = trabajadores.map((trabajador) => {
      const salario = this.parseNumeroDecimal(trabajador.empleado_remuneracion);
      const bonificacionDecreto = this.parseNumeroDecimal(trabajador.aporteempleado);
      const horasExtras = `${trabajador.sobretiempoH ?? trabajador.sobretiempo ?? '000'}:${trabajador.sobretiempoM ?? trabajador.sobretiempo2 ?? '00'}`;
      const totalDevengado = trabajador.empleado_ingresos ?? salario;
      const igssLaboral = trabajador.empleado_descuentos ?? 0;
      const aportePatronal = trabajador.empleado_aportes ?? 0;
      const totalPagar = trabajador.empleado_neto ?? 0;
      const fechaPeriodo = this.generarFechaPeriodo();

      return {
        idTrabajador: trabajador.empleado_codigo,
        nombres: trabajador.empleado_nombres_apellidos,
        fechaingreso: fechaPeriodo,
        cargo: trabajador.empleado_cargo,
        centroCosto: trabajador.empleado_centro_costos,
        salario,
        diasLab: trabajador.diasLaborados ?? 0,
        horasExt: horasExtras,
        sueldoOrd: salario,
        bonifDecr: bonificacionDecreto,
        bonificacion: 0,
        totalDevengado,
        igssLaboral,
        israsalariados: 0,
        otrosDescuentos: 0,
        igrAsalariados: aportePatronal,
        totalPagar,
      };
    });

    if (filas.length === 0) {
      return filas;
    }

    return [
      ...filas,
      {
        idTrabajador: '',
        nombres: 'TOTAL',
        fechaingreso: '',
        cargo: '',
        centroCosto: '',
        salario: filas.reduce((suma, fila) => suma + (fila.salario ?? 0), 0),
        diasLab: filas.reduce((suma, fila) => suma + (fila.diasLab ?? 0), 0),
        horasExt: '',
        sueldoOrd: filas.reduce((suma, fila) => suma + (fila.sueldoOrd ?? 0), 0),
        bonifDecr: filas.reduce((suma, fila) => suma + (fila.bonifDecr ?? 0), 0),
        bonificacion: filas.reduce((suma, fila) => suma + (fila.bonificacion ?? 0), 0),
        totalDevengado: filas.reduce((suma, fila) => suma + (fila.totalDevengado ?? 0), 0),
        igssLaboral: filas.reduce((suma, fila) => suma + (fila.igssLaboral ?? 0), 0),
        israsalariados: filas.reduce((suma, fila) => suma + (fila.israsalariados ?? 0), 0),
        otrosDescuentos: filas.reduce((suma, fila) => suma + (fila.otrosDescuentos ?? 0), 0),
        igrAsalariados: filas.reduce((suma, fila) => suma + (fila.igrAsalariados ?? 0), 0),
        totalPagar: filas.reduce((suma, fila) => suma + (fila.totalPagar ?? 0), 0),
      }
    ];
  }

  private separarNombreCompleto(nombreCompleto: string | null | undefined): { nombres: string; apellidos: string } {
    const partes = (nombreCompleto ?? '').trim().split(/\s+/).filter(Boolean);
    if (partes.length <= 1) {
      return { nombres: partes[0] ?? '', apellidos: '' };
    }

    if (partes.length === 2) {
      return { nombres: partes[0], apellidos: partes[1] };
    }

    return {
      nombres: partes.slice(0, partes.length - 2).join(' '),
      apellidos: partes.slice(-2).join(' '),
    };
  }

  private parseNumeroDecimal(valor: string | number | null | undefined): number {
    const numero = Number(valor ?? 0);
    return Number.isFinite(numero) ? numero : 0;
  }

  async abrirCalcularConcepto() {

    if (this.informacionForm.invalid) {
      return;
    }

    const modal = await this.modalController.create({
      component: CalcularConceptoComponent,
      cssClass: 'promo3',
      componentProps: {
        monedaSimbolo: this.monedapais,
        pais: this.pais,
        rowData: this.construirDataModalCalculo(),
        esFilaSeleccionada: !!this.filaSeleccionada,
        periodoDinamico: this.generarPeriodoDinamico()
      }
    });
    await modal.present();

    const { data, role } = await modal.onDidDismiss();
    if (role === 'confirm') {
      console.log('Datos del modal:', data);
      this.guardarCalculoPlanilla();
    } else if (role === 'cancel') {
      console.log('Modal cancelado');
    }
  }

  private generarPeriodoDinamico(): string {
    const meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    
    if (this.mesSeleccionado !== null && this.anioSeleccionado !== null) {
      const nombreMes = meses[this.mesSeleccionado - 1];
      return `${nombreMes} de ${this.anioSeleccionado}`;
    }
    
    return 'Período no seleccionado';
  }

  private generarFechaPeriodo(): string {
    if (this.mesSeleccionado !== null && this.anioSeleccionado !== null) {
      // Usar el primer día del mes seleccionado
      const fecha = new Date(this.anioSeleccionado, this.mesSeleccionado - 1, 1);
      return fecha.toLocaleDateString('es-PE');
    }
    return new Date().toLocaleDateString('es-PE');
  }

  guardarCalculoPlanilla() {
    if (this.informacionForm.invalid) {
      return;
    }

    const trabajadores = this.obtenerTrabajadoresParaModal();

    const sucursalIds = this.informacionForm.get('sucursal')?.value;
    const nombresSucursales = Array.isArray(sucursalIds)
      ? this.sucursales
          .filter((sucursal) => sucursalIds.map((id: any) => String(id)).includes(String(sucursal.id)))
          .map((sucursal) => sucursal.nombre)
      : [];

    const registro: PlanillaEntity = {
      planilla_codigo: this.filaSeleccionada?.planilla_codigo ?? this.generarCodigoCalculo(),
      planilla_periodo: String(this.informacionForm.get('periodo')?.value ?? ''),
      planilla_tipo_planilla: String(this.informacionForm.get('tipoPlanilla')?.value ?? ''),
      planilla_fecha_registro: this.filaSeleccionada?.planilla_fecha_registro ?? this.formatearFechaISO(new Date()),
      planilla_sucursal: nombresSucursales.join(', '),
      planilla_calculo_desde: this.formatearFechaISO(this.informacionForm.get('fechaVigenciaDesde')?.value),
      planilla_calculo_hasta: this.formatearFechaISO(this.informacionForm.get('fechaVigenciaHasta')?.value),
      planilla_estado: String(this.informacionForm.get('estadoSelect')?.value ?? 'Pendiente'),
      planilla_periodicidad_pago: String(this.informacionForm.get('periodicidadPago')?.value ?? ''),
      planilla_empleados_codigos: trabajadores.map((t) => t.empleado_codigo),
    };

    const listaActual = [...this.rowData];
    const indice = listaActual.findIndex((item) => item.planilla_codigo === registro.planilla_codigo);
    if (indice >= 0) {
      listaActual[indice] = registro;
    } else {
      listaActual.unshift(registro);
    }

    this.rowData = [...listaActual];
    this.rrHhFacade.actualizarCalculoPlanilla(this.rowData);

    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }

    if (indice >= 0) {
      this.filaSeleccionada = registro;
      this.rowDataDetalle = [...trabajadores];
      this.trabajadorSeleccionado = this.rowDataDetalle[0] ?? null;
      if (this.trabajadorSeleccionado) {
        this.cargarDetalleTrabajador(this.trabajadorSeleccionado);
      }

      if (this.gridApi) {
        setTimeout(() => {
          this.gridApi?.forEachNode((node) => {
            if (node.data?.planilla_codigo === registro.planilla_codigo) {
              node.setSelected(true);
              this.gridApi?.ensureNodeVisible(node, 'middle');
            }
          });
        }, 0);
      }

      if (this.gridApiDetalle) {
        this.gridApiDetalle.setGridOption('rowData', this.rowDataDetalle);
        this.gridApiDetalle.deselectAll();
        const firstNode = this.gridApiDetalle.getDisplayedRowAtIndex(0);
        firstNode?.setSelected(true);
      }
    } else {
      this.nuevoCalculo();
    }

    this.formValidationService.resetearEstado();
    this.toastService.success(indice >= 0 ? '¡Cálculo de planilla actualizado exitosamente!' : '¡Cálculo de planilla registrado exitosamente!');

  }

  private generarCodigoCalculo(): string {
    const siguiente = this.rowData
      .map((item) => item.planilla_codigo)
      .map((codigo) => Number.parseInt(String(codigo).replace(/\D/g, ''), 10))
      .filter((numero) => Number.isFinite(numero))
      .reduce((maximo, actual) => Math.max(maximo, actual), 0) + 1;

    return `CALC-${String(siguiente).padStart(3, '0')}`;
  }

  private formatearFechaISO(valor: any): string {
    if (!valor) {
      return '';
    }

    const fecha = new Date(valor);
    if (!Number.isNaN(fecha.getTime())) {
      return fecha.toISOString().slice(0, 10);
    }

    const texto = String(valor).trim();
    if (/^\d{4}-\d{2}-\d{2}$/.test(texto)) {
      return texto;
    }

    const partes = texto.split('/');
    if (partes.length === 3) {
      const [dia, mes, anio] = partes;
      return `${anio.padStart(4, '0')}-${mes.padStart(2, '0')}-${dia.padStart(2, '0')}`;
    }

    return texto;
  }

  scrollAPrimeraFila(): void {
    if (this.gridApi) {
      // Seleccionar la primera fila
      this.gridApi.deselectAll();
      const firstRowNode = this.gridApi.getRenderedNodes()[0];
      if (firstRowNode) {
        firstRowNode.setSelected(true);
        // Hacer scroll a la primera fila
        this.gridApi.ensureIndexVisible(0, 'top');
      }
    }
  }

  private clearEmpleadosTimer(): void {
    if (this.empleadosTimerId) {
      clearInterval(this.empleadosTimerId);
      this.empleadosTimerId = undefined;
    }
  }

  private clearCalculoPlanillaTimer(): void {
    if (this.calculoPlanillaTimerId) {
      clearInterval(this.calculoPlanillaTimerId);
      this.calculoPlanillaTimerId = undefined;
    }
  }

  private clearResetTimer(): void {
    if (this.resetTimerId) {
      clearInterval(this.resetTimerId);
      this.resetTimerId = undefined;
    }
  }

}