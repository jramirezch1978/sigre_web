import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { PlanillaEntity } from 'src/app/modules/rrhh/domain/models/planilla.entity';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-p-n-aprobar-planilla',
  templateUrl: './p-n-aprobar-planilla.component.html',
  styleUrls: ['./p-n-aprobar-planilla.component.scss'],
  standalone: false,
})
export class PNAprobarPlanillaComponent implements OnInit {
  // Facade
  private readonly rrHhFacade = inject(RrHhFacade);
  readonly isLoading = this.rrHhFacade.loadingCalculoPlanilla;
  isResetting = false;

  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  countries = ALL_COUNTRIES;
  informacionForm!: FormGroup;
  ConceptosFijosForm!: FormGroup;
  planillaSeleccionada: string = 'desde';
  pais = this.countryService.getCountryCode();
  filaSeleccionada: any = null;
  trabajadorSeleccionado: any = null;
  mostrarListaTrabajadores: boolean = false;
  monedapais: any = 'S/';
  panelLateralVisible: boolean = true;
  tabSeleccionado: string = 'jornadaLaboral';
  private gridApi!: GridApi;
  private gridApiDetalle!: GridApi;
  private gridApiTributos!: GridApi;
  private gridApiDescuentos!: GridApi;
  private gridApiIngresos!: GridApi;
  private empleados: any[] = [];
  startDate: Date = new Date();
  endDate: Date = new Date();
  minDate: Date = new Date(2020, 0, 1);
  maxDate: Date = new Date(2030, 11, 31);

  periodicidadesPago = [
    { value: 'diaria', label: 'Diaria' },
    { value: 'semanal', label: 'Semanal' },
    { value: 'quincenal', label: 'Quincenal' },
    { value: 'mensual', label: 'Mensual' }
  ];

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
    { field: 'planilla_codigo', headerName: 'Código', width: 80 },
    { field: 'planilla_periodo', headerName: 'Periodo', width: 80, filter: true },
    {
      field: 'planilla_fecha_registro', headerName: 'Fecha registro', flex: 1,
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
    {
      field: 'planilla_calculo_desde', headerName: 'Cálculo desde', flex: 1,
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
      field: 'planilla_calculo_hasta', headerName: 'Cálculo hasta', flex: 1,
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
      field: 'planilla_empleados_codigos', headerName: 'N° trabajadores', flex: 1,
      valueGetter: (params: any) => Array.isArray(params.data?.planilla_empleados_codigos)
        ? params.data.planilla_empleados_codigos.length
        : 0,
    },
    {
      field: 'planilla_estado', headerName: 'Estado', width: 90, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Aprobado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Aprobado</span>';
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-[#363636]">Pendiente</span>';
        } else if (params.value === 'Devuelto') {
          return '<span class="badge-table bg-[#FFE6EA] text-[#C41E3A]">Devuelto</span>';
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
    {
      field: 'devengo', headerName: `Devengado (${this.monedapais})`, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      valueFormatter: (params: any) => {
        if (params.data) {
          return `${this.monedapais} ${params.value}`;
        }
        return '-';
      }
    },
    {
      field: 'pagado', headerName: `Pagado (${this.monedapais})`, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
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
    {
      field: 'monto', headerName: 'Monto', headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
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
    {
      field: 'basecalculo', headerName: `Base de cálculo (${this.monedapais})`, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      valueFormatter: (params: any) => {
        if (params.data) {
          return `${this.monedapais} ${params.value}`;
        }
        return '-';
      }
    },
    {
      field: 'monto', headerName: `Monto (${this.monedapais})`, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      valueFormatter: (params: any) => {
        if (params.data) {
          return `${this.monedapais} ${params.value}`;
        }
        return '-';
      }
    }
  ];

  trabajadoresTodos = [
    { planilla_codigo: 'ID-2025-001', idSucursal: '1', nombretrabajador: 'Alexander Palomeque Aguirre', tipoDoc: 'DNI', nDoc: '70314956', ingresos: 1800.00, descuentos: -150.00, aportes: 1800.00, neto: 1800.00, aporteempleado: 1800.00, planilla_estado: 'Activo' },
    { planilla_codigo: 'ID-2025-002', idSucursal: '1', nombretrabajador: 'María García López', tipoDoc: 'DNI', nDoc: '70314957', ingresos: 2500.00, descuentos: -200.00, aportes: 820.00, neto: 2100.00, aporteempleado: 820.00, planilla_estado: 'Activo' },
    { planilla_codigo: 'ID-2025-003', idSucursal: '2', nombretrabajador: 'Carlos Rodríguez Pérez', tipoDoc: 'DNI', nDoc: '70314958', ingresos: 2200.00, descuentos: -180.00, aportes: 900.00, neto: 1820.00, aporteempleado: 900.00, planilla_estado: 'Activo' },
  ];

  rowDataDetalle: any[] = [];
  rowData: PlanillaEntity[] = [];
  private calculoPlanillaData: PlanillaEntity[] = [];

  rowDataIngresos: any[] = [
    { planilla_codigo: '0105', concepto: 'TRABAJO SOBRETIEMPO (H, EXTRAS 25%)', devengo: 2500.00, pagado: 2500.00 },
    { planilla_codigo: '0106', concepto: 'Otros ingresos', devengo: 2500.00, pagado: 2500.00 },
  ];

  rowDataDescuentos: any[] = [
    { planilla_codigo: '0701', concepto: 'ADELANTO', monto: '' },
    { planilla_codigo: '0702', concepto: 'CUOTA INICIAL', monto: '' },
  ];

  rowDataTributos: any[] = [
    { planilla_codigo: '0601', concepto: 'COMISIÓN AFP PORCENTUAL', basecalculo: '', monto: '' },
    { planilla_codigo: '0602', concepto: 'CONAFOVICER', basecalculo: '', monto: '' },
  ];

  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private countryService: CountryService,
  ) { }

  ngOnInit() {
    this.initializeInformacionForm();
    this.initializeForm();
    this.cargarDatosPersonales();
    this.cargarPendientesDesdeCalculoPlanilla();
  }

  private cargarDatosPersonales(): void {
    this.rrHhFacade.cargarDatosPersonales();
    let intentos = 0;
    const timer = setInterval(() => {
      intentos += 1;
      this.empleados = [...this.rrHhFacade.datosPersonales()];
      if (!this.rrHhFacade.loadingDatosPersonales() || intentos >= 200) {
        clearInterval(timer);
      }
    }, 100);
  }

  private cargarPendientesDesdeCalculoPlanilla(): void {
    this.rrHhFacade.cargarCalculoPlanilla();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.calculoPlanillaData = [...this.rrHhFacade.calculoPlanilla()];
        this.refrescarListaPendientes();
        clearInterval(timer);
      }
    }, 100);
  }

  private mapearCalculoAAprobar(calculo: PlanillaEntity): PlanillaEntity {
    return {
      planilla_codigo: calculo.planilla_codigo,
      planilla_periodo: calculo.planilla_periodo,
      planilla_fecha_registro: calculo.planilla_fecha_registro,
      planilla_sucursal: calculo.planilla_sucursal,
      planilla_calculo_desde: calculo.planilla_calculo_desde,
      planilla_calculo_hasta: calculo.planilla_calculo_hasta,
      planilla_estado: calculo.planilla_estado,
      planilla_empleados_codigos: calculo.planilla_empleados_codigos,
    };
  }

  private refrescarListaPendientes(): void {
    const codigoSeleccionado = this.filaSeleccionada?.planilla_codigo ?? null;

    this.rowData = this.calculoPlanillaData
      .filter((item) => item.planilla_estado === 'Pendiente')
      .map((item) => this.mapearCalculoAAprobar(item));

    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', [...this.rowData]);
    }

    if (this.rowData.length === 0) {
      this.limpiarSeleccionYFormulario();
      return;
    }

    const filaASeleccionar = this.rowData.find((item) => item.planilla_codigo === codigoSeleccionado) ?? this.rowData[0];
    this.cargarFilaPlanilla(filaASeleccionar);

    if (this.gridApi) {
      setTimeout(() => {
        this.gridApi?.forEachNode((node) => {
          if (node.data?.planilla_codigo === filaASeleccionar.planilla_codigo) {
            node.setSelected(true);
          }
        });
      }, 0);
    }
  }

  private limpiarSeleccionYFormulario(): void {
    this.filaSeleccionada = null;
    this.trabajadorSeleccionado = null;
    this.mostrarListaTrabajadores = false;
    this.rowDataDetalle = [];
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    this.informacionForm.patchValue({
      planilla_periodo: '',
      planilla_sucursal: '',
      periodicidadPago: '',
      calcularDesde: '',
      calcularHasta: '',
      estadoSelect: '',
    });
  }

  private initializeInformacionForm(): void {
    this.informacionForm = this.formBuilder.group({
      planilla_periodo: [{value:'', disabled: true}, Validators.required],
      planilla_sucursal: [{value:'', disabled: true}, Validators.required],
      periodicidadPago: [{value:'', disabled: true}, Validators.required],
      calcularDesde: [{value:'', disabled: true}, Validators.required],
      calcularHasta: [{value:'', disabled: true}, Validators.required],
      estadoSelect: [{value:'', disabled: true}, Validators.required],
    });
  }

  private initializeForm(): void {
    this.ConceptosFijosForm = this.formBuilder.group({
      diasLaborados: [''],
      diasSubsidiados: [''],
      diasNoLaborados: [''],
      diasTotal: [''],
      ordinaria: [''],
      ordinaria2: [''],
    });
  }

  onCellClicked(event: any) {
    const data = event.data;
    const clickedNode = event.node;
    console.log('Celda clickeada:', event.data);
    this.gridApi?.deselectAll();
    clickedNode?.setSelected(true);
    this.cargarFilaPlanilla(data);
  }

  private cargarFilaPlanilla(data: any): void {
    this.filaSeleccionada = data;
    this.mostrarListaTrabajadores = true;

    const calculoSeleccionado = this.calculoPlanillaData.find(
      (item) => item.planilla_codigo === data.planilla_codigo
    );

    this.cargarTrabajadoresDeCalculoSeleccionado(calculoSeleccionado);

    if (this.rowDataDetalle.length > 0) {
      this.trabajadorSeleccionado = this.rowDataDetalle[0];
      this.cargarDetalleTrabajador(this.trabajadorSeleccionado);
      if (this.gridApiDetalle) {
        this.gridApiDetalle.setGridOption('rowData', this.rowDataDetalle);
        const firstNode = this.gridApiDetalle.getDisplayedRowAtIndex(0);
        firstNode?.setSelected(true);
      }
    } else {
      this.trabajadorSeleccionado = null;
      this.limpiarDetalleInferior();
    }

    this.informacionForm.patchValue({
      planilla_periodo: data.planilla_periodo,
      planilla_sucursal: data.planilla_sucursal,
      periodicidadPago: calculoSeleccionado?.planilla_periodicidad_pago ?? 'mensual',
      calcularDesde: data.planilla_calculo_desde,
      calcularHasta: data.planilla_calculo_hasta,
      estadoSelect: data.planilla_estado ?? 'Pendiente',
    });
    this.informacionForm.disable();
    this.ConceptosFijosForm.disable();
  }

  private cargarTrabajadoresDeCalculoSeleccionado(calculo?: PlanillaEntity): void {
    if (!calculo) {
      this.rowDataDetalle = [];
      return;
    }

    if (Array.isArray(calculo.planilla_empleados_codigos) && calculo.planilla_empleados_codigos.length > 0) {
      const codigos = calculo.planilla_empleados_codigos.map((codigo) => String(codigo));
      this.rowDataDetalle = this.empleados.filter((empleado) => codigos.includes(String(empleado.empleado_codigo)));
      if (this.rowDataDetalle.length > 0) {
        return;
      }
    }

    const sucursalesSeleccionadas = String(calculo.planilla_sucursal ?? '')
      .split(',')
      .map((item) => item.trim().toLowerCase())
      .filter(Boolean);

    this.rowDataDetalle = this.empleados.filter((empleado) =>
      sucursalesSeleccionadas.includes(String(empleado.empleado_sucursal ?? '').trim().toLowerCase())
    );
  }

  togglePanelLateral(): void {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.gridApi.setGridOption('rowData', [...this.rowData]);
    // Restaurar la fila seleccionada al volver/desplegar la pantalla (por referencia de objeto)
    if (this.filaSeleccionada) {
      const prevData = this.filaSeleccionada;
      setTimeout(() => {
        this.gridApi?.forEachNode((node) => {
          if (node.data?.planilla_codigo === prevData.planilla_codigo) {
            node.setSelected(true);
          }
        });
      }, 0);
    } else if (this.rowData.length > 0) {
      const firstNode = this.gridApi.getDisplayedRowAtIndex(0);
      if (firstNode) {
        firstNode.setSelected(true);
        this.cargarFilaPlanilla(firstNode.data);
      }
    }
  }

  onBtReset(): void {
    this.isResetting = true;
    this.rrHhFacade.cargarCalculoPlanilla();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.calculoPlanillaData = [...this.rrHhFacade.calculoPlanilla()];
        this.refrescarListaPendientes();
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApiDetalle = params.api;
    this.gridApiDetalle.setGridOption('rowData', this.rowDataDetalle);

    if (this.rowDataDetalle.length > 0) {
      const primerTrabajador = this.trabajadorSeleccionado ?? this.rowDataDetalle[0];
      this.trabajadorSeleccionado = primerTrabajador;
      this.cargarDetalleTrabajador(primerTrabajador);

      setTimeout(() => {
        this.gridApiDetalle?.forEachNode((node) => {
          if (node.data?.empleado_codigo === primerTrabajador.empleado_codigo) {
            node.setSelected(true);
          }
        });
      }, 0);
    }
  }

  onCellClickedDetalle(event: any) {
    if (event.data) {
      console.log('Trabajador seleccionado:', event.data);
      event.node?.setSelected(true);
      this.trabajadorSeleccionado = event.data;
      this.cargarDetalleTrabajador(event.data);
    }
  }

  private cargarDetalleTrabajador(trabajador: any): void {
    this.ConceptosFijosForm.patchValue({
      diasLaborados: trabajador?.diasLaborados ?? 30,
      diasSubsidiados: trabajador?.diasSubsidiados ?? 0,
      diasNoLaborados: trabajador?.diasNoLaborados ?? 0,
      diasTotal: trabajador?.diasTotal ?? 30,
      ordinaria: trabajador?.ordinariaH ?? trabajador?.ordinaria ?? '160',
      ordinaria2: trabajador?.ordinariaM ?? trabajador?.ordinaria2 ?? '00',
    });

    this.rowDataIngresos = [
      {
        planilla_codigo: '0101',
        concepto: 'Ingresos trabajador',
        devengo: Number(trabajador?.empleado_ingresos ?? trabajador?.ingresos ?? 0),
        pagado: Number(trabajador?.empleado_neto ?? trabajador?.neto ?? 0),
      },
    ];

    this.rowDataDescuentos = [
      {
        planilla_codigo: '0701',
        concepto: 'Descuentos trabajador',
        monto: Number(trabajador?.empleado_descuentos ?? trabajador?.descuentos ?? 0),
      },
    ];

    this.rowDataTributos = [
      {
        planilla_codigo: '0601',
        concepto: 'Aportes trabajador',
        basecalculo: Number(trabajador?.empleado_aportes ?? trabajador?.aportes ?? 0),
        monto: Number(trabajador?.aporteempleado ?? 0),
      },
    ];

    this.gridApiIngresos?.setGridOption('rowData', this.rowDataIngresos);
    this.gridApiDescuentos?.setGridOption('rowData', this.rowDataDescuentos);
    this.gridApiTributos?.setGridOption('rowData', this.rowDataTributos);
  }

  private limpiarDetalleInferior(): void {
    this.ConceptosFijosForm.patchValue({
      diasLaborados: '',
      diasSubsidiados: '',
      diasNoLaborados: '',
      diasTotal: '',
      ordinaria: '',
      ordinaria2: '',
    });

    this.rowDataIngresos = [];
    this.rowDataDescuentos = [];
    this.rowDataTributos = [];

    this.gridApiIngresos?.setGridOption('rowData', this.rowDataIngresos);
    this.gridApiDescuentos?.setGridOption('rowData', this.rowDataDescuentos);
    this.gridApiTributos?.setGridOption('rowData', this.rowDataTributos);
  }

  onGridReadyIngresos(params: GridReadyEvent) {
    this.gridApiIngresos = params.api;
  }

  onCellClickedIngresos(event: any) {
    console.log('Ingreso seleccionado:', event.data);
  }

  onGridReadyDescuentos(params: GridReadyEvent) {
    this.gridApiDescuentos = params.api;
  }

  onCellClickedDescuentos(event: any) {
    console.log('Descuento seleccionado:', event.data);
  }

  onGridReadyTributos(params: GridReadyEvent) {
    this.gridApiTributos = params.api;
  }

  onCellClickedTributos(event: any) {
    console.log('Tributo seleccionado:', event.data);
  }

  async aprobarPlanilla() {
    if (!this.filaSeleccionada) {
      this.toastService.warning('Por favor, selecciona un cálculo de planilla');
      return;
    }

    if (this.filaSeleccionada.planilla_estado !== 'Pendiente') {
      this.toastService.warning('Solo puedes aprobar planillas pendientes');
      return;
    }

    const index = this.calculoPlanillaData.findIndex(
      (item) => item.planilla_codigo === this.filaSeleccionada.planilla_codigo
    );
    if (index !== -1) {
      this.calculoPlanillaData[index] = {
        ...this.calculoPlanillaData[index],
        planilla_estado: 'Aprobado',
      };
      this.rrHhFacade.actualizarCalculoPlanilla(this.calculoPlanillaData);
      this.refrescarListaPendientes();
      this.toastService.success('¡Planilla aprobada exitosamente!');
    }
  }

  async devolverPlanilla() {
    const detallesEjemplo: DetalleItem[] = [
          { label: 'Periodo', value: '' },
          { label: 'Fecha registro', value:'' },
          { label: 'Sucursal', value:'' },
          { label: 'N° de trabajadores', value:'' },
        ];
    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo2',
      componentProps: {
        tituloModal: 'Devolver cálculo de planilla',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        motivoObligatorio: true,
        colorBotonConfirmar: 'primary',
        textoBotonConfirmar: 'Devolver',
        tituloTextarea: 'Motivo de devolución',
      }
    });

    await modal.present();
    const { data } = await modal.onWillDismiss();

    if (data && data.motivo) {
      const index = this.calculoPlanillaData.findIndex(
        (item) => item.planilla_codigo === this.filaSeleccionada.planilla_codigo
      );
      if (index !== -1) {
        this.calculoPlanillaData[index] = {
          ...this.calculoPlanillaData[index],
          planilla_estado: 'Devuelto',
        };
        this.rrHhFacade.actualizarCalculoPlanilla(this.calculoPlanillaData);
        this.refrescarListaPendientes();
        this.toastService.success('¡Planilla devuelta exitosamente!');
      }
    }
  }
}
