import { Component, OnInit, effect, inject } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalAsientoContableComponent } from '../af-p-generacionasientosdepreciacion/modal/modal-asiento-contable/modal-asiento-contable.component';
import { ModalController } from '@ionic/angular';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { GeneracionDevengoAseguradoresFacade } from '../../../application/facades/generacion-devengo-aseguradores.facade';
import { GeneracionDevengoAseguradoresEntity } from '../../../domain/models/generacion-devengo-aseguradores.entity';
import { PolizaSeguroFacade } from '../../../application/facades/poliza-seguro.facade';
import { PolizaSeguroEntity } from '../../../domain/models/poliza-seguro.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCalculator, faCalendar, faCalendarDays, faChevronsLeft, faChevronsRight, faCirclePlus, faCog, faDollarSign, faDownload, faList, faPercent, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';



@Component({
  selector: 'app-activofijo-procesos-generaciondevengoaseguradores',
  templateUrl:
    './activofijo-procesos-generaciondevengoaseguradores.component.html',
  styleUrls: [
    './activofijo-procesos-generaciondevengoaseguradores.component.scss',
  ],
  standalone: false,
})
export class ActivofijoProcesosGeneraciondevengoaseguradoresComponent
  implements OnInit
{
  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCalculator = faCalculator;
  fasCalendar = faCalendar;
  fasCalendarDays = faCalendarDays;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasCog = faCog;
  fasDollarSign = faDollarSign;
  fasDownload = faDownload;
  fasList = faList;
  fasPercent = faPercent;
  fasRotateRight = faRotateRight;

  //RANGO DE FECHAS

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  fechaActual: Date = new Date();

  devengoForm!: FormGroup;

  valido = true;

  filaSeleccionada: any = null;
  private gridApi!: GridApi;
  context: any;
  mostrarTabla: boolean = true;
  mesSeleccionado: number | null = null;
  anioSeleccionado: number | null = null;
  modoNuevoCalculo: boolean = false;
  calculoEjecutado: boolean = false;
  mostrarBotones: boolean = false;
  fechaEjecucion: Date = new Date();
  mesDSeleccionado: number = new Date().getMonth() + 1;
  anioDSeleccionado: number = new Date().getFullYear();

  polizas = [
    { id: 'todo', nombre: 'Todo riesgo' },
    { id: 'incendio', nombre: 'Incendio' },
    { id: 'robo', nombre: 'Robo' },
    { id: 'responsabilidad', nombre: 'Responsabilidad civil' },
    { id: 'otro', nombre: 'Otro' },
  ];

  fuenteD = [
    { id: 'vigente', nombre: 'Pólizas vigentes' },
    { id: 'todas', nombre: 'Todas las pólizas' },
  ];

  tiposC = [
    { id: 'lineal', nombre: 'Lineal (Mensual)' },
    { id: 'proporcional', nombre: 'Proporcional según cobertura' },
  ];

  librosC = [
    { id: 'principal', nombre: 'Principal' },
    { id: 'tributario', nombre: 'Tributario' },
  ];
  centrosCostos = [
    {
      id: 'rrhh',
      nombre: 'Recursos Humanos',
      descripcion: 'Departamento de RRHH',
    },
    {
      id: 'oficinaadmi',
      nombre: 'Oficina Administrativa',
      descripcion: 'Área administrativa',
    },
    {
      id: 'marketing',
      nombre: 'Marketing',
      descripcion: 'Área de marketing y publicidad',
    },
    {
      id: 'operaciones',
      nombre: 'Operaciones',
      descripcion: 'Departamento de operaciones',
    },
    {
      id: 'logistica',
      nombre: 'Área de producción',
      descripcion: 'Área de producción',
    },
    {
      id: 'centrosoporte',
      nombre: 'Centro de soporte',
      descripcion: 'Departamento financiero',
    },
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
    noRowsToShow: 'No hay datos para mostrar',
  };
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  // Datos de la tabla
  readonly facade = inject(GeneracionDevengoAseguradoresFacade);
  private readonly polizaSeguroFacade = inject(PolizaSeguroFacade);
  rowData: GeneracionDevengoAseguradoresEntity[] = [];

  // Definición de columnas
  colDefs: ColDef<GeneracionDevengoAseguradoresEntity>[] = [
    { field: 'gda_codigo', headerName: 'Código', flex: 0.6, minWidth: 70 },
    { field: 'gda_periodo', headerName: 'Periodo', flex: 0.5, minWidth: 70 },
    { field: 'gda_fecha_ejecucion', headerName: 'Fecha ejecución', flex: 0.8, minWidth: 90,},
    { field: 'gda_usuario', headerName: 'Usuario ejecutador', flex: 1.4, minWidth: 150,},
    { field: 'gda_seguros', headerName: 'Seguros', flex: 0.5, minWidth: 70, cellClass: 'text-right',
      valueGetter: (params) => params.data?.gda_polizas?.length || 0,},
    { field: 'gda_devengado_mes', headerName: 'Devengo total del mes', flex: 1.1, minWidth: 130, cellClass: 'text-right',
      valueGetter: (params) => (params.data?.gda_polizas || []).reduce((sum: number, p: any) => sum + (p.montoD || 0), 0),
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return 'S/ ' + new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value);
        }
        return '';
      },
    },
    { field: 'gda_asiento', headerName: 'N° de asiento contable', flex: 1, minWidth: 130,
      cellRenderer: (params: any) => {
        // Si el estado es "Pendiente", no mostrar nada
        if (params.data?.gda_estado === 'Pendiente') {
          return '-';
        }
        // Si el estado es "Contabilizado", usar el cell renderer personalizado
        return params.value;
      },
      cellRendererSelector: (params: any) => {
        // Si el estado es "Contabilizado", usar el componente personalizado
        if (params.data?.gda_estado === 'Contabilizado') {
          return {
            component: VistaCellRenderComponent,
          };
        }
        // Para otros estados, usar el renderer por defecto
        return undefined;
      },
    },
    { field: 'gda_estado', headerName: 'Estado', flex: 0.7, minWidth: 100, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center',},
      cellRenderer: (params: any) => {
        if (params.value === 'Contabilizado') {
          return `<span class="badge-table bg-[#D6E6FF] text-primary">Contabilizado</span>`;
        }
        if (params.value === 'Pendiente') {
          return `<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>`;
        }
        return params.value;
      },
    },
  ];

  // Tipos de columnas
  columnTypes = {
    rightAligned: { cellClass: 'text-right' },
    centered: { cellClass: 'text-center' },
  };

  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );

    // Configurar context para AG-Grid
    this.context = { componentParent: this };

    effect(() => {
      this.rowData = [...this.facade.devengoItems()].reverse();
      this.modoNuevoCalculo = this.rowData.length === 0;
    });
  }

  ngOnInit() {
    this.facade.cargarDevengo();
    this.polizaSeguroFacade.cargarPolizas();

    this.devengoForm = this.formBuilder.group({
      razonSocial: [ { value: 'Importadora Vinos del Sur EIRL', disabled: true },],
      fechaE: [{ value: this.fechaActual, disabled: true }],
      tipoP: ['', Validators.required],
      fuenteD: ['', Validators.required],
      libroC: ['', Validators.required],
      centroC: [''],
      periodoC: [{ value: this.getPeriodoActual(), disabled: true }],
      usuario: [{ value: 'Alessandra Ontaneda Herradura', disabled: true }],
      usuarioEjec: [{ value: 'Alessandra Ontaneda Herradura', disabled: true }],
      periodoDevengo: [`${this.anioDSeleccionado}${String(this.mesDSeleccionado).padStart(2, '0')}`, Validators.required],
      tipoCalculo: ['', Validators.required],
      prefijo: [''],
      observaciones: [''],
    });
  }

  private getPeriodoActual(): string {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    return `${year}${month}`;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onCellClicked(event: any) {
    const data = event.data;
    if (!data) return;

    // Si es la misma fila, no hacer nada
    if (this.filaSeleccionada && this.filaSeleccionada.gda_codigo === data.gda_codigo) return;

    this.filaSeleccionada = data;
    this.llenarFormulario(data);
  }

  private llenarFormulario(data: GeneracionDevengoAseguradoresEntity) {
    if (!data) return;

    this.devengoForm.patchValue({
      periodoC: data.gda_periodo || '',
      fechaE: data.gda_fecha_ejecucion ? new Date(data.gda_fecha_ejecucion) : this.fechaActual,
      tipoP: data.gda_tipo_poliza || '',
      fuenteD: data.gda_fuente_datos || '',
      tipoCalculo: data.gda_tipo_calculo || '',
      libroC: data.gda_libro_contable || '',
      centroC: data.gda_centro_costo || '',
      periodoDevengo: data.gda_periodo_devengo || '',
      prefijo: data.gda_prefijo || '',
      observaciones: data.gda_observaciones || '',
      usuarioEjec: data.gda_usuario || '',
    });

    this.anioDSeleccionado = parseInt(data.gda_periodo_devengo.substring(0, 4), 10);
    this.mesDSeleccionado = parseInt(data.gda_periodo_devengo.substring(4, 6), 10);

    this.devengoForm.disable();

    this.rowDataActivos = data.gda_polizas || [];
    this.mostrarBotones = data.gda_estado !== 'Contabilizado';
    this.calculoEjecutado = true;
  }

  // AG-Grid para Activos
  private gridApiActivos!: GridApi;

  rowDataActivos: any[] = [];

  colDefsActivos: ColDef[] = [
    { field: 'codigo', headerName: 'Código', flex: 0.7, minWidth: 90 },
    { field: 'activo', headerName: 'Activo', flex: 1, minWidth: 100 },
    { field: 'aseguradora', headerName: 'Aseguradora', flex: 0.9, minWidth: 100,},
    { field: 'tipopoliza', headerName: 'Tipo de póliza', flex: 0.9, minWidth: 100,},
    { field: 'fechaI', headerName: 'Fecha inicio', flex: 0.9, minWidth: 100 },
    { field: 'fechaV', headerName: 'Fecha vencimiento', flex: 1, minWidth: 110,},
    { field: 'prima', headerName: 'Prima (S/)', flex: 0.9, minWidth: 100, cellClass: 'text-right', headerClass: 'ag-right-aligned-header',
      cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end',
      },
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value);
        }
        return '-';
      },
    },
    { field: 'montoD', headerName: 'Monto devengado mes (S/)', flex: 1.2, minWidth: 140, cellClass: 'text-right', headerClass: 'ag-right-aligned-header',
      cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end',},
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value);
        }
        return '-';
      },
    },
    { field: 'saldo', headerName: 'Saldo x devengar (S/)', flex: 1.1, minWidth: 130, cellClass: 'text-right', headerClass: 'ag-right-aligned-header',
      cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end',},
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value);
        }
        return '-';
      },
    },
    { field: 'estado', headerName: 'Estado', flex: 1, minWidth: 120, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center',},
      cellRenderer: (params: any) => {
        if (params.value === 'Vence en 30 días') {
          return '<span class="badge-table bg-[#FFF0BF] text-yellow !w-20">Vence en 30 días</span>';
        } else if (params.value === 'Vigente') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Vigente</span>';
        } else if (params.value === 'Vencida') {
          return '<span class="badge-table bg-warning-10 text-warning">Vencida</span>';
        } else if (params.value === 'Cancelada') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Cancelada</span>';
        } else if (params.value === 'Vigente en 7 días') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85 !w-20">Vigente en 7 días</span>';
        } else if (params.value === 'En siniestro') {
          return '<span class="badge-table bg-[#D6E6FF] text-primary">En siniestro</span>';
        }
        return params.value;
      },
    },
  ];

  onGridReadyActivos(params: GridReadyEvent) {
    this.gridApiActivos = params.api;
  }

  togglePanelLateral() {
    this.mostrarTabla = !this.mostrarTabla;
  }

  onMonthYearChange(event: { month: number; year: number }) {
    this.mesSeleccionado = event.month;
    this.anioSeleccionado = event.year;
    console.log('Mes y año seleccionado:', event);
    // Aquí puedes agregar la lógica para filtrar los datos
  }

  onMonthYearChangeDev(event: { month: number; year: number }) {
    this.mesDSeleccionado = event.month;
    this.anioDSeleccionado = event.year;
    this.devengoForm.patchValue({ 
      periodoDevengo: `${this.anioDSeleccionado}${String(this.mesDSeleccionado).padStart(2, '0')}` 
    });
  }

  nuevoCalculo() {
    this.devengoForm.enable();
    this.mesDSeleccionado = new Date().getMonth() + 1;
    this.anioDSeleccionado = new Date().getFullYear();
    this.devengoForm.reset({
      razonSocial: 'Importadora Vinos del Sur EIRL',
      fechaE: this.fechaActual,
      periodoC: '202511',
      usuario: 'Alessandra Ontaneda Herradura',
      usuarioEjec: 'Alessandra Ontaneda Herradura',
      periodoDevengo: `${this.anioDSeleccionado}${String(this.mesDSeleccionado).padStart(2, '0')}`,
    });
    // Campos siempre deshabilitados
    this.devengoForm.get('razonSocial')?.disable();
    this.devengoForm.get('fechaE')?.disable();
    this.devengoForm.get('periodoC')?.disable();
    this.devengoForm.get('usuario')?.disable();
    this.devengoForm.get('usuarioEjec')?.disable();

    this.filaSeleccionada = null;
    this.calculoEjecutado = false;
    this.mostrarBotones = false;
    this.mostrarTabla = false;
    if (this.gridApi) this.gridApi.deselectAll();
  }

  ejecutarCalculoDevengo() {
    if (this.devengoForm.invalid) {
      this.toastService.warning('Por favor, complete todos los campos requeridos antes de ejecutar el cálculo.');
      return;
    }
    this.calculoEjecutado = true;
    this.mostrarBotones = true;
    this.toastService.success('¡Cálculo de devengo realizado exitosamente!');

    // Mapear pólizas desde PolizaSeguroFacade a la estructura de la tabla secundaria
    const polizas = this.polizaSeguroFacade.polizas();
    this.rowDataActivos = polizas.map((p: PolizaSeguroEntity) => ({
      codigo: p.poliza_codigo,
      activo: p.poliza_activo || '',
      aseguradora: p.poliza_aseguradora || '',
      tipopoliza: p.poliza_tipo_seguro || '',
      fechaI: p.poliza_fecha_inicio || '',
      fechaV: p.poliza_fecha_vencimiento || '',
      prima: p.poliza_prima_total || 0,
      montoD: (p.poliza_prima_total || 0) / 12,
      saldo: (p.poliza_prima_total || 0) - ((p.poliza_prima_total || 0) / 12),
      estado: p.poliza_estado || '',
    }));
  }

  confirmarCalculo() {
    const form = this.devengoForm.getRawValue();

    const periodo = form.periodoC || '';
    const anio = periodo.substring(0, 4);
    const mes = periodo.substring(4, 6);

    const nuevoRegistro: GeneracionDevengoAseguradoresEntity = {
      gda_codigo: periodo ? `DEVP-${anio}-${mes}` : `DEVP-${new Date().getFullYear()}-${String(new Date().getMonth() + 1).padStart(2, '0')}`,
      gda_periodo: form.periodoC || '',
      gda_fecha_ejecucion: this.formatDate(this.fechaEjecucion),
      gda_usuario: form.usuarioEjec || 'Alessandra Ontaneda Herradura',
      gda_tipo_poliza: form.tipoP || '',
      gda_fuente_datos: form.fuenteD || '',
      gda_tipo_calculo: form.tipoCalculo || '',
      gda_libro_contable: form.libroC || '',
      gda_centro_costo: form.centroC || '',
      gda_periodo_devengo: form.periodoDevengo || '',
      gda_prefijo: form.prefijo || '',
      gda_observaciones: form.observaciones || '',
      gda_seguros: this.rowDataActivos.length,
      gda_devengado_mes: 'S/ ' + new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(
        this.rowDataActivos.reduce((sum: number, p: any) => sum + (p.montoD || 0), 0)
      ),
      gda_asiento: this.getAsientoContable(),
      gda_estado: 'Contabilizado',
      gda_polizas: this.rowDataActivos,
    };

    this.facade.guardarItem(nuevoRegistro);
    this.toastService.success('¡Devengado guardado exitosamente!');

    this.calculoEjecutado = false;
    this.mostrarBotones = false;
    this.filaSeleccionada = null;
    this.rowDataActivos = [];
    this.mostrarTabla = true;
    this.devengoForm.reset({
      periodoC: `${anio}${mes}`,
      fechaE: this.fechaActual,
      periodoDevengo: `${this.anioDSeleccionado}${String(this.mesDSeleccionado).padStart(2, '0')}`,
      usuario: 'Alessandra Ontaneda Herradura',
      usuarioEjec: 'Alessandra Ontaneda Herradura',
    });
  }

  private getAsientoContable(): string {
    const periodo = this.devengoForm.get('periodoC')?.value || '';
    const anio = periodo.substring(0, 4);
    const mes = periodo.substring(4, 6);
    const prefijo = `ASC-${anio}-${mes}-`;
    const existentes = this.facade.devengoItems()
      .map(item => item.gda_asiento)
      .filter(asiento => asiento?.startsWith(prefijo))
      .map(asiento => parseInt(asiento!.replace(prefijo, ''), 10))
      .filter(n => !isNaN(n));
    const siguiente = existentes.length > 0 ? Math.max(...existentes) + 1 : 1;
    const count = String(siguiente).padStart(3, '0');
    return `${prefijo}${count}`;
  }

  private formatDate(date: Date): string {
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();
    return `${year}-${month}-${day}`;
  }

  cancelarCalculo() {
    this.calculoEjecutado = false;
    this.mostrarBotones = false;
    this.mostrarTabla = true;
    this.filaSeleccionada = null;
    this.gridApi?.deselectAll();
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

  ejecutarValidacion() {
    if (this.devengoForm.invalid) {
      this.toastService.warning('Por favor, complete todos los campos requeridos antes de ejecutar el cálculo.');
      return;
    }
    if (this.valido == true) {
      this.toastService.success('¡Validación exitosa!');
    } else {
      this.toastService.danger(
        'No existen polizas vigentes para este periodo.',
        '',
        12000
      );
    }
  }

  onCentroCostosSeleccionado(centroCostos: any) {
    console.log('Centro de costos seleccionado:', centroCostos);
  }
  async openAsiento(nroAsientoCont: string, rowData?: any) {
    const modal = await this.modalController.create({
      component: ModalAsientoContableComponent,
      cssClass: 'promo',
      componentProps: {
        nroAsiento: nroAsientoCont,
        asientoData: rowData || [],
      },
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
      { field: 'cuentaContable', headerName: 'Cuenta contable', width: 130 },
      { field: 'descripcion', headerName: 'Descripción', width: 150, flex: 1, },
      { field: 'debito', headerName: 'Debe', width: 80, headerClass: 'centrarencabezado',
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
  onFechaEjecucion(fecha: Date) {
    this.fechaEjecucion = fecha;
  }
  onBtReset() {
    this.facade.cargarDevengo();
  }
}
