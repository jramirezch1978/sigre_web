import { Component, OnInit, OnDestroy, computed, inject, signal, effect, untracked } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { AccesorioActionsCellComponent } from 'src/app/modules/activos/m-af-tabla/pages/af-o-registroactivos/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { GestionAsientosManualesFacade } from 'src/app/modules/contabilidad/application/facades/gestion-asientos-manuales.facade';
import { SeleccionarCuentaContableFacade } from 'src/app/modules/contabilidad/application/facades/seleccionar-cuenta-contable.facade';
import { GestionAsientosManualesFeedbackEffects } from 'src/app/modules/contabilidad/effects/gestion-asientos-manuales-feedback.effect';
import { GestionAsientosManualesSyncEffects } from 'src/app/modules/contabilidad/effects/gestion-asientos-manuales-sync.effect';
import { SeleccionarCuentaContableFeedbackEffects } from 'src/app/modules/contabilidad/effects/seleccionar-cuenta-contable-feedback.effect';
import { AsientoManualItem, CuentaMovimientoItem } from 'src/app/modules/contabilidad/domain/models/gestion-asientos-manual.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faCog, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-gestion-asientos-manual',
  templateUrl: './gestion-asientos-manual.component.html',
  styleUrls: ['./gestion-asientos-manual.component.scss'],
  standalone: false
})
export class GestionAsientosManualComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasCog = faCog;
  fasRotateRight = faRotateRight;


  //RANGO DE FECHAS

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  fechaContable: Date | undefined;

  private gridApi!: GridApi;
  private gridApiCuentas!: GridApi;

  estadoSeleccionado: string = 'todos';
  deRegistro: string = 'Dé registro';
  GestionAsientosManualForm!: FormGroup;
  filaSeleccionada: any;
  panelLateralVisible: boolean = true;
  datosseleccionado = false;
  modoNuevoAsiento = false;
  guardarDeshabilitado = false;
  duplicarDeshabilitado = false;
  fechaDis = false;
  ocultarBuscador = false;
  asientoSeleccionado: any = null;
  estadoAnterior: string = 'Activo';

  // Totales de la tabla de cuentas
  totalDebeSoles: number = 0;
  totalHaberSoles: number = 0;
  totalDebeDolares: number = 0;
  totalHaberDolares: number = 0;

  libros = [
    { id: 'diario', nombre: 'Libro diario' },
    { id: 'compras', nombre: 'Compras' },
    { id: 'ventas', nombre: 'Ventas' },
    { id: 'mayor', nombre: 'Caja y bancos' },
  ];

  monedas = [
    { id: 'Soles', nombre: 'Soles' },
    { id: 'USD', nombre: 'Dólares' },

  ];

  cuentasContables = [
    { id: '631109', nombre: '631109 - Servicios de internert' },
    { id: '635101', nombre: '635101 - Servicios de publicidad' },
    { id: '639901', nombre: '639901 - Manteniento de Equipos' },
    { id: '631101', nombre: '631101 - Energía Eléctrica' },
    { id: '631101', nombre: '631101 - Agua y Desagüe' },
  ];

  // Array para guardar las cuentas disponibles
  readonly cuentasPadre = computed(() =>
    this.cuentaFacade.items().map(cuenta => ({
      id: cuenta.cuenta_contable_codigo,
      nombre: `${cuenta.cuenta_contable_codigo} - ${cuenta.cuenta_contable_descripcion || 'Sin descripción'}`,
      codigo: cuenta.cuenta_contable_codigo,
      descripcion: cuenta.cuenta_contable_descripcion,
      nivel: cuenta.cuenta_contable_nivel,
      tipo: cuenta.cuenta_contable_tipo,
      rTercero: cuenta.cuenta_contable_r_tercero
    }))
  );

  // Propiedad para controlar el valor del buscador y poder limpiarla
  cuentaBuscadorSeleccionada: any = null;

  centrosCostoList = [
    'Administración',
    'Finanzas',
    'Compras',
    'Ventas',
    'Operaciones',
    'Marketing'
  ];

  tercerosList = [
    'Proveedor A',
    'Proveedor B',
    'Banco Continental',
    'SUNAT',
    'Cliente General',
    'Otros'
  ];

  columnTypes = {
    default: {
      resizable: false,
      sortable: false,
      filter: false,
      floatingFilter: false,
    }
  };

  colDefs: ColDef<AsientoManualItem>[] = [
    { field: 'asiento_manual_numero_asiento', headerName: 'Nº de asiento', flex: 1, minWidth: 100 },
    { field: 'asiento_manual_fecha_registro', headerName: 'Fecha registro', flex: 1, minWidth: 110 },
    { field: 'asiento_manual_fecha_contable', headerName: 'Fecha contable', flex: 1, minWidth: 110 },
    { field: 'asiento_manual_glosa', headerName: 'Glosa', flex: 2, minWidth: 150 },
    { field: 'asiento_manual_situacion_contable', headerName: 'Situación contable', filter: true, flex: 1.2, minWidth: 120 },
    {
      field: 'asiento_manual_total', headerName: 'Total', flex: 0.8, minWidth: 80,
      valueFormatter: params => params.value ? `S/ ${params.value.toFixed(2)}` : 'S/ 0.00'
    },
    {
      field: 'asiento_manual_estado',
      headerName: 'Estado',
      headerClass: 'ag-header-hover ag-header-10px centrarencabezado', filter: true,
      flex: 0.8,
      minWidth: 80,
      cellRenderer: (params: any) => {
        const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  // ── Facades & Effects ────────────────────────────────────────────────────
  private readonly gestionFacade   = inject(GestionAsientosManualesFacade);
  private readonly cuentaFacade    = inject(SeleccionarCuentaContableFacade);
  private readonly gestionEffects  = inject(GestionAsientosManualesFeedbackEffects);
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  private readonly gestionSync     = inject(GestionAsientosManualesSyncEffects);
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  private readonly cuentaEffects   = inject(SeleccionarCuentaContableFeedbackEffects);

  // ── Señales computadas ────────────────────────────────────────────────────
  rowData          = signal<AsientoManualItem[]>([]);
  readonly isLoading = computed(() => this.gestionFacade.isLoading());

  // Sincroniza rowData y la tabla cada vez que la facade actualiza los asientos
  private readonly _syncRowData = effect(() => {
    const asientos = this.gestionFacade.asientos();
    untracked(() => {
      this.rowData.set(asientos);
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', asientos);
      }
    });
  });

  colDefsCuentas: ColDef[] = [
    { field: 'cuenta_mov_cuenta', headerName: 'Cuenta', flex: 0.8, minWidth: 80 },
    { field: 'cuenta_mov_descripcion', headerName: 'Descripción', flex: 1.5, minWidth: 120 },
    {
      field: 'cuenta_mov_debe_soles', headerName: 'Debe(S/)', flex: 0.8, minWidth: 80, headerClass: 'derechaencabezado', cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end', },
      valueFormatter: params => params.value ? params.value.toFixed(2) : '0.00', editable: true
    },
    {
      field: 'cuenta_mov_haber_soles', headerName: 'Haber(S/)', flex: 0.8, minWidth: 80, headerClass: 'derechaencabezado', cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end', },
      valueFormatter: params => params.value ? params.value.toFixed(2) : '0.00', editable: true
    },
    {
      field: 'cuenta_mov_debe_dolares', headerName: 'Debe($)', flex: 0.8, minWidth: 80, headerClass: 'derechaencabezado', cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end', },
      valueFormatter: params => params.value ? params.value.toFixed(2) : '0.00', editable: true
    },
    {
      field: 'cuenta_mov_haber_dolares', headerName: 'Haber($)', flex: 0.8, minWidth: 80, headerClass: 'derechaencabezado', cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end', },
      valueFormatter: params => params.value ? params.value.toFixed(2) : '0.00', editable: true
    },
    {
      field: 'cuenta_mov_centro_costo', headerName: 'Centro de costo', flex: 1, minWidth: 100,
      cellEditor: 'agSelectCellEditor',
      cellEditorParams: {
        values: ['Administración', 'Finanzas', 'Compras', 'Ventas', 'Operaciones', 'Marketing']
      },
      editable: true
    },
    { field: 'cuenta_mov_doc_referencial', headerName: 'Doc. referencial', flex: 1, minWidth: 100, editable: true },
    // {
    //   field: 'tercero', headerName: 'Tercero', flex: 1, minWidth: 100,
    //   cellEditor: 'agSelectCellEditor',
    //   cellEditorParams: {
    //     values: ['Proveedor A', 'Proveedor B', 'Banco Continental', 'SUNAT', 'Cliente General', 'Otros']
    //   },
    //   editable: true
    // },
    {
      headerName: 'Acciones', flex: 0.7, minWidth: 70,
      headerClass: 'centrarencabezado',
      cellRenderer: AccesorioActionsCellComponent,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  rowDataCuentas: CuentaMovimientoItem[] = []; // Tabla VACÍA al iniciar

  // Base de datos de movimientos por cuenta contable
  movimientosPorCuenta: { [key: string]: CuentaMovimientoItem[] } = {
    '631109': [
      { cuenta_mov_cuenta: '631109', cuenta_mov_descripcion: 'Servicios de internet', cuenta_mov_debe_soles: 380.00, cuenta_mov_haber_soles: 0, cuenta_mov_debe_dolares: 0, cuenta_mov_haber_dolares: 0, cuenta_mov_centro_costo: 'Administración', cuenta_mov_doc_referencial: 'REC-001'},
    ],
    '635101': [
      { cuenta_mov_cuenta: '635101', cuenta_mov_descripcion: 'Servicios de publicidad', cuenta_mov_debe_soles: 1500.00, cuenta_mov_haber_soles: 0, cuenta_mov_debe_dolares: 0, cuenta_mov_haber_dolares: 445, cuenta_mov_centro_costo: 'Marketing', cuenta_mov_doc_referencial: 'PUB-001'},
    ],
    '639901': [
      { cuenta_mov_cuenta: '639901', cuenta_mov_descripcion: 'Mantenimiento de Equipos', cuenta_mov_debe_soles: 800.00, cuenta_mov_haber_soles: 0, cuenta_mov_debe_dolares: 0, cuenta_mov_haber_dolares: 0, cuenta_mov_centro_costo: 'Operaciones', cuenta_mov_doc_referencial: 'MAN-001' },
    ],
    '631101': [
      { cuenta_mov_cuenta: '631101', cuenta_mov_descripcion: 'Energía Eléctrica', cuenta_mov_debe_soles: 2500.00, cuenta_mov_haber_soles: 0, cuenta_mov_debe_dolares: 0, cuenta_mov_haber_dolares: 0, cuenta_mov_centro_costo: 'Administración', cuenta_mov_doc_referencial: 'EDL-001' },
    ]
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
    loadingOoo: 'Cargando...',
  };
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  treeData = false;
  getDataPath = undefined;
  groupDefaultExpanded = -1;
  autoGroupColumnDef = undefined;

  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  ngOnInit() {
    // Obtener tasa de cambio inicial
    const monedaInicial = 'Soles';
    const tasaCambioInicial = this.obtenerTipoCambio(monedaInicial);

    this.GestionAsientosManualForm = this.formBuilder.group({
      usuario: [{ value: 'Juan Pérez', disabled: true }],
      fechaRegistro: [{ value: new Date().toISOString().split('T')[0], disabled: true }],
      origen: [{ value: ' MN - Manual', disabled: true }],
      fechaContable: [''],
      libro: [''],
      moneda: ['Soles'],
      tasaCambio: [{ value: tasaCambioInicial, disabled: true }],
      estado: ['Activo'],
      situacionContable: [{ value: 'No transferido', disabled: true }],
      glosaContable: ['']
    });

    // Cargar datos desde facade
    this.gestionFacade.cargarDatos();
    this.cuentaFacade.cargarDatos();

    // Registrar callbacks de efectos CRUD
    this.gestionEffects.registrarCallbacks({
      onGuardarExito: () => this.onGuardarExito(),
      onActualizarExito: () => this.onActualizarExito(),
      onAnularExito: () => this.onAnularExito(),
    });

    // Suscribirse a cambios en moneda para actualizar tasa de cambio dinámicamente
    this.GestionAsientosManualForm.get('moneda')?.valueChanges.subscribe((moneda) => {
      if (moneda) {
        const nuevaTasaCambio = this.obtenerTipoCambio(moneda);
        this.GestionAsientosManualForm.patchValue({ tasaCambio: nuevaTasaCambio }, { emitEvent: false });
      }
    });

    // Suscribirse a cambios en situación contable para actualizar tasa cuando es "Transferido"
    this.GestionAsientosManualForm.get('situacionContable')?.valueChanges.subscribe((situacion) => {
      if (situacion === 'Transferido') {
        // Cuando es transferido, actualizar tasa de cambio dinámicamente según la moneda actual
        const monedaActual = this.GestionAsientosManualForm.get('moneda')?.value || 'Soles';
        const tasaCambioDinamica = this.obtenerTipoCambio(monedaActual);
        this.GestionAsientosManualForm.patchValue({ tasaCambio: tasaCambioDinamica }, { emitEvent: false });
      }
    });

    this.formValidationService.inicializarFormulario(this.GestionAsientosManualForm);
  }

  ionViewWillEnter() {
    this.gestionFacade.cargarDatos();
  }



  /**
   * Obtener el tercero según la parametrización de la cuenta
   * Si la cuenta requiere tercero, retorna vacío para que el usuario lo seleccione
   */
  private obtenerTerceroSegunCuenta(cuenta: any): string {
    // Si la cuenta tiene rTercero (requiere tercero) en 'Si', retorna vacío
    if (cuenta.rTercero === 'Si') {
      return ''; // El usuario deberá seleccionar uno
    }
    // Si requiere tercero pero está marcado como "Ninguno", retorna el mismo usuario
    return 'Tú mismo';
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  private async validarCambiosCondicional(): Promise<boolean> {
    // Si NO hay modificaciones, retorna true (permite navegación libre)
    if (!this.formValidationService.tieneModificaciones()) {
      return true;
    }

    // Si hay cambios, muestra modal de confirmación
    return await this.formValidationService.validarCambios();
  }

  /**
   * Implementación del guard CanDeactivate
   * Previene la navegación si hay cambios sin guardar
   */
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  onBtReset() {
    this.gestionFacade.cargarDatos();
    this.gridApi.setGridOption('rowData', [...this.rowData()]);
  }
  esMesFuturo(fecha: string): boolean {
    const fechaIngresada = new Date(fecha);
    const hoy = new Date();

    const mesIngresado = fechaIngresada.getMonth();
    const añoIngresado = fechaIngresada.getFullYear();

    const mesActual = hoy.getMonth();
    const añoActual = hoy.getFullYear();

    return (
      añoIngresado > añoActual ||
      (añoIngresado === añoActual && mesIngresado > mesActual)
    );
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;

    if (this.asientoSeleccionado) {
      // El panel fue cerrado y vuelto a abrir con un asiento activo: restaurar selección visual
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node: any) => {
            if (node.data && node.data.asiento_manual_numero_asiento === this.asientoSeleccionado.asiento_manual_numero_asiento) {
              node.setSelected(true);
              this.gridApi.ensureNodeVisible(node, 'middle');
            }
          });
        }
      }, 150);
    } else if (!this.modoNuevoAsiento) {
      // Primera carga sin estado previo: iniciar en modo creación
      this.iniciarModoCreacion();
    }
    // Si modoNuevoAsiento === true y asientoSeleccionado === null → ya estaba en modo nuevo, no hacer nada
  }

  /**
   * Iniciar el formulario en modo creación sin seleccionar ningún asiento
   */
  private iniciarModoCreacion() {
    // Obtener tasa de cambio inicial para PEN
    const tasaCambioInicial = this.obtenerTipoCambio('Soles');

    // Establecer valores por defecto en el formulario
    this.GestionAsientosManualForm.patchValue({
      usuario: 'Juan Pérez',
      fechaRegistro: new Date().toISOString().split('T')[0],
      origen: ' MN - Manual',
      moneda: 'Soles',
      tasaCambio: tasaCambioInicial,
      estado: 'Activo',
      situacionContable: 'No transferido'
    });

    // Configurar estado del formulario
    this.asientoSeleccionado = null;
    this.datosseleccionado = false;
    this.fechaDis = false;
    this.modoNuevoAsiento = true;
    this.ocultarBuscador = true; // Mostrar buscador para agregar cuentas
    this.guardarDeshabilitado = false;
    this.duplicarDeshabilitado = false;

    // Limpiar tabla de cuentas
    this.rowDataCuentas = [];
    if (this.gridApiCuentas) {
      this.gridApiCuentas.setGridOption('rowData', []);
    }

    // Limpiar totales
    this.totalDebeSoles = 0;
    this.totalHaberSoles = 0;
    this.totalDebeDolares = 0;
    this.totalHaberDolares = 0;

    console.log('  Cuentas disponibles en modo creación:', this.cuentasPadre()?.length || 0);

    // Resetear estado de validación
    this.formValidationService.resetearEstado();
  }

  onGridReadyCuentas(params: GridReadyEvent) {
    this.gridApiCuentas = params.api;
    this.calcularTotales()
  }
  onCellValueChanged(event: any) {
    this.calcularTotales();
  }

  async onCellClicked(event: any) {
    const data = event.data;
    console.log('Asiento seleccionado:', data);

    const puede = await this.validarCambiosCondicional();
    if (!puede) {
      // Si cancela, restaurar la fila anterior
      if (this.asientoSeleccionado && this.gridApi) {
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node: any) => {
            if (node.data.asiento_manual_numero_asiento === this.asientoSeleccionado.asiento_manual_numero_asiento) {
              node.setSelected(true);
            }
          });
        }, 0);
      }
      return;
    }

    this.guardarDeshabilitado = false;
    this.modoNuevoAsiento = false;

    this.asientoSeleccionado = data;
    this.estadoAnterior = data.asiento_manual_estado;

    // Llenar formulario con datos seleccionados
    this.GestionAsientosManualForm.patchValue({
      fechaContable: data.asiento_manual_fecha_contable,
      libro: data.asiento_manual_libro,
      moneda: data.asiento_manual_moneda,
      glosaContable: data.asiento_manual_glosa,
      situacionContable: data.asiento_manual_situacion_contable,
      estado: data.asiento_manual_estado
    });

    // Cargar las cuentas asociadas al asiento
    if (data.asiento_manual_cuentas && Array.isArray(data.asiento_manual_cuentas)) {
      this.rowDataCuentas = [...data.asiento_manual_cuentas];
      if (this.gridApiCuentas) {
        this.gridApiCuentas.setGridOption('rowData', this.rowDataCuentas);
      }
      this.calcularTotales();
    }

    if (data.asiento_manual_estado === 'Activo' && data.asiento_manual_situacion_contable === 'No transferido') {
      this.datosseleccionado = true;
      this.formValidationService.resetearEstado();
    }
    else {
      this.datosseleccionado = false;
    }
    if (data.asiento_manual_estado === 'Activo' && data.asiento_manual_situacion_contable === 'Transferido') {
      // Obtener dinámicamente la tasa de cambio según la moneda del asiento
      const tasaCambioDinamica = this.obtenerTipoCambio(data.asiento_manual_moneda);
      this.GestionAsientosManualForm.patchValue({
        tasaCambio: tasaCambioDinamica
      }, { emitEvent: false });

      this.GestionAsientosManualForm.get('fechaContable')?.disable();
      this.GestionAsientosManualForm.get('moneda')?.disable();
      this.GestionAsientosManualForm.get('libro')?.disable();
      this.GestionAsientosManualForm.get('estado')?.disable();
      this.GestionAsientosManualForm.get('glosaContable')?.disable();
      this.GestionAsientosManualForm.get('tasaCambio')?.disable();
      this.fechaDis = true;
      this.guardarDeshabilitado = true;
      this.ocultarBuscador = false; // No mostrar buscador - está transferido
      // Resetear estado después de deshabilitar campos
      this.formValidationService.resetearEstado();
    }
    else {
      this.GestionAsientosManualForm.get('fechaContable')?.enable();
      this.GestionAsientosManualForm.get('moneda')?.enable();
      this.GestionAsientosManualForm.get('libro')?.enable();
      this.GestionAsientosManualForm.get('estado')?.enable();
      this.GestionAsientosManualForm.get('glosaContable')?.enable();
      this.GestionAsientosManualForm.get('tasaCambio')?.enable();
      this.fechaDis = false
      this.guardarDeshabilitado = false;
      this.ocultarBuscador = false; // No mostrar buscador - está en modo edición de asiento existente
      // Resetear estado después de habilitar campos
      this.formValidationService.resetearEstado();
    }
  }
  llenarFormulario(data: any) {
    if (!data) return;
    this.GestionAsientosManualForm.patchValue({
      monedaF: data.moneda,
      codigo: data.codigo,
      nombreD: data.descripcion,
      nivel: data.nivel,
      cuentaPadre: data.ctaPadre,
      naturaleza: data.naturaleza,
      tipoC: data.tipo,
      permiteM: data.movimiento,
      estado: data.estado,
      rTercero: data.rTercero,
      reqDoc: data.reqDoc,
      reqCentro: data.reqCentro,
      reqSucursal: data.reqSucursal,
      asocImp: data.asocImp,
      afectaC: data.afectaC,
      asociacion: data.asociacion,
      monedap: data.monedap,
      etiqueta: data.etiqueta,
      plantillaV: data.plantillaV,
      mapaN: data.mapaN,
      vigenciaD: data.vigenciaD,
      vigenciaH: data.vigenciaH,
    });
  }

  botonNuevaClase() {
    console.log('Nueva clase');
  }

  botonNuevaSubclase() {
    console.log('Nueva subclase');
  }

  onCuentaContableSeleccionada(cuentaSeleccionada: any) {
    if (!cuentaSeleccionada || !cuentaSeleccionada.id) {
      console.warn('  No se seleccionó ninguna cuenta');
      return;
    }

    // Verificar si la cuenta ya existe en la tabla
    const cuentaYaExiste = this.rowDataCuentas.some(fila => fila.cuenta_mov_cuenta === cuentaSeleccionada.codigo);
    if (cuentaYaExiste) {
      this.toastService.warning(`La cuenta ${cuentaSeleccionada.codigo} ya está en la tabla`);
      return;
    }

    console.log('📌 Cuenta seleccionada:', cuentaSeleccionada.id);

    // Crear nueva fila para agregar a la tabla
    const nuevaCuenta: CuentaMovimientoItem = {
      cuenta_mov_cuenta: cuentaSeleccionada.codigo || '',
      cuenta_mov_descripcion: cuentaSeleccionada.descripcion || '',
      cuenta_mov_debe_soles: 0,
      cuenta_mov_haber_soles: 0,
      cuenta_mov_debe_dolares: 0,
      cuenta_mov_haber_dolares: 0,
      cuenta_mov_centro_costo: '-',
      cuenta_mov_doc_referencial: '',
    };

    // AGREGAR la cuenta a la tabla (no reemplazar)
    this.rowDataCuentas = [...this.rowDataCuentas, nuevaCuenta];

    // Actualizar la tabla si existe
    if (this.gridApiCuentas) {
      this.gridApiCuentas.setGridOption('rowData', this.rowDataCuentas);
    }

    // Recalcular totales
    this.calcularTotales();

    // Limpiar el buscador después de seleccionar (con pequeño delay para asegurar que se procese)
    setTimeout(() => {
      this.cuentaBuscadorSeleccionada = null;
    }, 100);

    console.log(` Cuenta ${cuentaSeleccionada.nombre} agregada a la tabla. Total: ${this.rowDataCuentas.length}`);
    // this.toastService.success(`Cuenta ${cuentaSeleccionada.codigo} agregada (Total: ${this.rowDataCuentas.length})`);
  }

  // Método para calcular los totales de debe y haber
  calcularTotales() {
    let debeSoles = 0;
    let haberSoles = 0;
    let debeDolares = 0;
    let haberDolares = 0;

    this.gridApiCuentas.forEachNode((node: any) => {
      const data = node.data;

      debeSoles += Number(data.cuenta_mov_debe_soles) || 0;
      haberSoles += Number(data.cuenta_mov_haber_soles) || 0;
      debeDolares += Number(data.cuenta_mov_debe_dolares) || 0;
      haberDolares += Number(data.cuenta_mov_haber_dolares) || 0;
    });

    this.totalDebeSoles = debeSoles;
    this.totalHaberSoles = haberSoles;
    this.totalDebeDolares = debeDolares;
    this.totalHaberDolares = haberDolares;
  }


  async onEstadoChange(event: any) {
    const nuevoEstado = event.detail.value;

    if (nuevoEstado === 'Inactivo' && this.datosseleccionado && this.asientoSeleccionado) {
      // Abrir modal de confirmación
      await this.abrirModalInactivar();
    }
  }

  guardar() {
    const fecha = this.GestionAsientosManualForm.value.fechaContable;

    if (this.esMesFuturo(fecha)) {
      this.toastService.warning('El periodo seleccionado no esta abierto');
      return;
    }

    // Validar que la tabla de cuentas tenga datos
    if (!this.rowDataCuentas || this.rowDataCuentas.length === 0) {
      this.toastService.warning('Debe agregar al menos una cuenta contable al asiento');
      return;
    }

    // Validar que los totales cuadren (debe = haber)
    const tolerancia = 0.01;
    const descuadradoSoles = Math.abs(this.totalDebeSoles - this.totalHaberSoles);
    const descuadradoDolares = Math.abs(this.totalDebeDolares - this.totalHaberDolares);

    if (descuadradoSoles > tolerancia || descuadradoDolares > tolerancia) {
      this.toastService.warning('¡El asiento no cuadra: validar los campos Debe y Haber!');
      return;
    }

    const formData = this.GestionAsientosManualForm.getRawValue();
    const fechaActual = new Date();

    if (this.modoNuevoAsiento) {
      // ── CREAR nuevo asiento ──────────────────────────────────────────────
      const nuevoAsiento: AsientoManualItem = {
        asiento_manual_numero_asiento: this.generarNuevoNumeroAsiento(),
        asiento_manual_fecha_registro: this.formatearFecha(fechaActual),
        asiento_manual_fecha_contable: this.formatearFecha(formData.fechaContable),
        asiento_manual_glosa: formData.glosaContable,
        asiento_manual_situacion_contable: formData.situacionContable ?? 'No transferido',
        asiento_manual_total: this.totalDebeSoles + this.totalDebeDolares,
        asiento_manual_estado: formData.estado,
        asiento_manual_libro: formData.libro,
        asiento_manual_moneda: formData.moneda,
        asiento_manual_origen: formData.origen,
        asiento_manual_usuario: formData.usuario,
        asiento_manual_tasa_cambio: formData.tasaCambio,
        asiento_manual_cuentas: [...this.rowDataCuentas],
      };

      this.gestionFacade.guardarAsiento(nuevoAsiento);

    } else {
      // ── ACTUALIZAR asiento existente ─────────────────────────────────────
      if (!this.asientoSeleccionado) {
        this.toastService.warning('No se encontró el asiento a actualizar');
        return;
      }

      const asientoActualizado: AsientoManualItem = {
        ...this.asientoSeleccionado,
        asiento_manual_fecha_contable: this.formatearFecha(formData.fechaContable),
        asiento_manual_glosa: formData.glosaContable,
        asiento_manual_situacion_contable: formData.situacionContable,
        asiento_manual_total: this.totalDebeSoles + this.totalDebeDolares,
        asiento_manual_estado: formData.estado,
        asiento_manual_libro: formData.libro,
        asiento_manual_moneda: formData.moneda,
        asiento_manual_tasa_cambio: formData.tasaCambio,
        asiento_manual_cuentas: [...this.rowDataCuentas],
      };

      this.gestionFacade.actualizarAsiento(asientoActualizado);
    }

    // Resetear servicio de validación después de guardar
    this.formValidationService.resetearEstado();
    this.guardarDeshabilitado = true;
    this.datosseleccionado = true;
  }

  // ── Callbacks de efectos CRUD ────────────────────────────────────────────

  private onGuardarExito(): void {
    this.formValidationService.resetearEstado();
    this.modoNuevoAsiento = false;
    this.ocultarBuscador = false;
  }

  private onActualizarExito(): void {
    this.formValidationService.resetearEstado();
  }

  private onAnularExito(): void {
    this.guardarDeshabilitado = true;
    this.duplicarDeshabilitado = true;
    this.formValidationService.resetearEstado();
  }

  async botonCancelar() {
    const puede = await this.validarCambiosCondicional();
    if (!puede) return;

    this.asientoSeleccionado = null;
    this.datosseleccionado = false;
    this.modoNuevoAsiento = false;
    this.ocultarBuscador = false;
    
    // Limpiar tabla de cuentas
    this.rowDataCuentas = [];
    if (this.gridApiCuentas) {
      this.gridApiCuentas.setGridOption('rowData', []);
    }
    
    // Resetear totales
    this.totalDebeSoles = 0;
    this.totalHaberSoles = 0;
    this.totalDebeDolares = 0;
    this.totalHaberDolares = 0;

    // Deseleccionar filas
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Resetear formulario a valores iniciales
    this.GestionAsientosManualForm.reset({
      usuario: 'Juan Pérez',
      fechaRegistro: new Date().toISOString().split('T')[0],
      origen: ' MN - Manual',
      moneda: 'Soles',
      estado: 'Activo',
      situacionContable: 'No transferido'
    });

    this.formValidationService.resetearEstado();
  }

  async abrirmodalUbicaciones() {
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar asientos contables',
        descripcionSubir: 'Comparte tu archivo de excel con la información de tus ubicaciones y regístralos automáticamente en la plataforma.',
        buttonName: 'Importar asientos contables',
        habilitarperiodo: true,
      }
    });
    await modal.present();
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
      { fechaHora: '20/11/2025 16:01:44', usuario: 'Ana Pérez', accion: 'Actualizacién de estado ', detalleCambio: 'Estado: De "Activo" a "Inactivo" (Actualización especial)'},
      { fechaHora: '12/11/2025 14:40:22', usuario: 'Jorge Gómez', accion: 'Edición de asiento', detalleCambio: 'Cuenta contable: De 631201 (Suministros) a 631109 (Servicios de Internet)'},
      { fechaHora: '13/11/2025 15:15:30', usuario: 'Jorge Gómez', accion: 'Registro del asiento', detalleCambio: 'Se ingresó la cabecera y detalle incial. Totales: Desde S/ 380.00 - Haber S/380.00'},
    ];


    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones del Asiento ${this.asientoSeleccionado?.asiento_manual_numero_asiento}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }
  public async botonduplicar() {
    // Ejemplo de datos que puedes personalizar
    const detallesEjemplo: DetalleItem[] = [
      { label: 'Fecha de registro', value: '12/12/2025' },
      { label: 'Fecha contable', value: '12/12/2025' },
      { label: 'Glosa', value: 'Provisión de servicios de internet – Local San Isidro (Mes 11/2025).' },
      { label: 'Total', value: 'S/380.00' },
      { label: 'Replicado', value: 'No' }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Duplicar asiento ${this.asientoSeleccionado?.asiento_manual_numero_asiento}`,
        subtitulomodal: 'Detalle de asiento:',
        detalles: detallesEjemplo,
        mostrarTextarea: false,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Duplicar',
        colorBotonConfirmar: 'primary',
        botonoutline: 'solid'
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      this.duplicarAsiento();
    }
  }
  public async abrirModalInactivar() {
    if (!this.asientoSeleccionado) return;

    const detallesEjemplo: DetalleItem[] = [
      { label: 'Número de asiento', value: this.asientoSeleccionado.asiento_manual_numero_asiento },
      { label: 'Fecha de registro', value: this.asientoSeleccionado.asiento_manual_fecha_registro },
      { label: 'Fecha contable', value: this.asientoSeleccionado.asiento_manual_fecha_contable },
      { label: 'Glosa', value: this.asientoSeleccionado.asiento_manual_glosa },
      { label: 'Total', value: `S/ ${this.asientoSeleccionado.asiento_manual_total.toFixed(2)}` },
      { label: 'Estado actual', value: 'Activo' }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Inactivar asiento ${this.asientoSeleccionado.asiento_manual_numero_asiento}`,
        subtitulomodal: 'Detalle del asiento:',
        detalles: detallesEjemplo,
        mostrarTextarea: false,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Inactivar',
        colorBotonConfirmar: 'danger'
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      // Confirmar inactivación via facade
      if (this.asientoSeleccionado) {
        this.gestionFacade.anularAsiento(this.asientoSeleccionado.asiento_manual_numero_asiento);
      }
    } else {
      // Cancelar - revertir al estado anterior
      this.GestionAsientosManualForm.patchValue({
        estado: this.estadoAnterior
      }, { emitEvent: false });
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
  onFechaContableSelected(date: Date) {
    console.log('Fecha creacion:', date);
    this.GestionAsientosManualForm.patchValue({
      fechaContable: date
    })
    this.fechaContable = date;
  }

  async botonNuevoAsiento() {
    const puede = await this.validarCambiosCondicional();
    if (!puede) return;

    this.guardarDeshabilitado = false;
    this.duplicarDeshabilitado = false;
    // Resetear el formulario
    this.GestionAsientosManualForm.reset();

    // Obtener tasa de cambio inicial para PEN
    const tasaCambioInicial = this.obtenerTipoCambio('Soles');

    // Establecer valores por defecto
    this.GestionAsientosManualForm.patchValue({
      usuario: 'Juan Pérez',
      fechaRegistro: new Date().toISOString().split('T')[0],
      origen: ' MN - Manual',
      moneda: 'Soles',
      tasaCambio: tasaCambioInicial,
      estado: 'Activo',
      situacionContable: 'No transferido'
    });
    // Habilitar campos editables
    this.GestionAsientosManualForm.get('fechaContable')?.enable();
    this.GestionAsientosManualForm.get('libro')?.enable();
    this.GestionAsientosManualForm.get('moneda')?.enable();
    this.GestionAsientosManualForm.get('estado')?.enable();
    this.GestionAsientosManualForm.get('glosaContable')?.enable();
    this.GestionAsientosManualForm.get('situacionContable')?.enable();
    this.GestionAsientosManualForm.get('situacionContable')?.disable();
    this.GestionAsientosManualForm.get('tasaCambio')?.disable();

    // Suscribirse a cambios de situacionContable para actualizar dinámica de campos
    const situacionContableSub = this.GestionAsientosManualForm.get('situacionContable')?.valueChanges.subscribe((situacion) => {
      if (situacion === 'Transferido') {
        // Deshabilitar moneda cuando es transferido pero mostrar tasa dinámica
        this.GestionAsientosManualForm.get('moneda')?.disable({ emitEvent: false });
        // Actualizar tasa de cambio dinámicamente
        const monedaActual = this.GestionAsientosManualForm.get('moneda')?.value || 'Soles';
        const tasaCambioDinamica = this.obtenerTipoCambio(monedaActual);
        this.GestionAsientosManualForm.patchValue({
          tasaCambio: tasaCambioDinamica
        }, { emitEvent: false });
      } else {
        // Habilitar moneda cuando es "No transferido"
        this.GestionAsientosManualForm.get('moneda')?.enable({ emitEvent: false });
      }
    });

    // Limpiar selección de tabla principal
    this.asientoSeleccionado = null;
    this.datosseleccionado = false;
    this.fechaDis = false;
    this.modoNuevoAsiento = true;
    this.ocultarBuscador = true; // Mostrar buscador - está en modo creación
    // Deseleccionar fila de tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    // Limpiar tabla de cuentas
    this.rowDataCuentas = [];
    if (this.gridApiCuentas) {
      this.gridApiCuentas.setGridOption('rowData', []);
    }
    // Limpiar totales
    this.totalDebeSoles = 0;
    this.totalHaberSoles = 0;
    this.totalDebeDolares = 0;
    this.totalHaberDolares = 0;
    this.formValidationService.resetearEstado();
  }

  // Método para validar si se puede registrar un nuevo asiento
  puedeRegistrar(): boolean {
    const formValues = this.GestionAsientosManualForm.value;

    // Validar campos requeridos
    return !!(
      formValues.fechaContable &&
      formValues.libro &&
      formValues.glosaContable &&
      formValues.estado
    );
  }

  private generarNuevoNumeroAsiento(): string {
    const año = new Date().getFullYear();
    const mes = String(new Date().getMonth() + 1).padStart(2, '0');
    const dia = String(new Date().getDate()).padStart(2, '0');

    // Filtrar solo asientos del mes y año actual (con validación de undefined)
    const asientosMes = this.rowData().filter(a =>
      a.asiento_manual_numero_asiento && a.asiento_manual_numero_asiento.startsWith(`MN-${año}-${mes}-${dia}`)
    );

    // Obtener correlativo mayor
    const maxCorrelativo = asientosMes.reduce((max, asiento) => {
      const partes = asiento.asiento_manual_numero_asiento.split("-");
      const correlativo = Number(partes[4]);
      return Math.max(max, correlativo);
    }, 0);

    const nuevoCorrelativo = String(maxCorrelativo + 1).padStart(3, '0');

    return `MN-${año}-${mes}-${dia}-${nuevoCorrelativo}`;
  }

  duplicarAsiento() {
    if (!this.GestionAsientosManualForm) return;

    const formData = this.GestionAsientosManualForm.getRawValue();

    const nuevoNumeroAsiento = this.generarNuevoNumeroAsiento();

    const nuevoRegistro: AsientoManualItem = {
      asiento_manual_numero_asiento: nuevoNumeroAsiento,
      asiento_manual_fecha_registro: formData.fechaRegistro,
      asiento_manual_fecha_contable: formData.fechaContable,
      asiento_manual_glosa: formData.glosaContable,
      asiento_manual_situacion_contable: formData.situacionContable ?? 'No transferido',
      asiento_manual_total: this.totalDebeSoles + this.totalDebeDolares,
      asiento_manual_estado: formData.estado,
      asiento_manual_libro: formData.libro,
      asiento_manual_moneda: formData.moneda,
      asiento_manual_origen: formData.origen ?? 'MN - Manual',
      asiento_manual_usuario: formData.usuario ?? '',
      asiento_manual_tasa_cambio: formData.tasaCambio ?? '1',
      asiento_manual_cuentas: this.asientoSeleccionado?.asiento_manual_cuentas
        ? [...(this.asientoSeleccionado.asiento_manual_cuentas)]
        : [],
    };

    // Duplicar via facade para persistir y refrescar tabla
    this.gestionFacade.guardarAsiento(nuevoRegistro);
  }

  /**
   * Obtiene el tipo de cambio COMPRA desde localStorage según la moneda seleccionada
   */
  private obtenerTipoCambio(moneda: string): string {
    if (moneda === 'Soles') {
      return '1';
    }

    // Obtener tipos de cambio desde localStorage (simulación)
    const tiposCambio: any[] = JSON.parse(localStorage.getItem('tiposCambio') || '[]');
    const fechaActual = new Date();
    const fechaFormateada = this.formatearFecha(fechaActual);

    // Mapear código de moneda a nombre
    const nombreMoneda = moneda === 'USD' ? 'Dólar' : 'Euro';

    // Buscar tipo de cambio activo para la moneda seleccionada con fecha de vigencia actual
    const tipoCambioEncontrado = tiposCambio.find((tc: any) => {
      return tc.moneda === nombreMoneda && tc.estado === 'Activo' && tc.fechavigencia === fechaFormateada;
    });

    if (tipoCambioEncontrado) {
      return tipoCambioEncontrado.tcCompra.toFixed(5);
    } else {
      // Si no hay tipo de cambio exacto, buscar el más reciente activo
      const tiposCambioMoneda = tiposCambio.filter((tc: any) =>
        tc.moneda === nombreMoneda && tc.estado === 'Activo'
      );

      if (tiposCambioMoneda.length > 0) {
        // Ordenar por fecha de vigencia (más reciente primero)
        tiposCambioMoneda.sort((a: any, b: any) => {
          const fechaA = this.parsearFechaString(a.fechavigencia);
          const fechaB = this.parsearFechaString(b.fechavigencia);
          return fechaB.getTime() - fechaA.getTime();
        });

        return tiposCambioMoneda[0].tcCompra.toFixed(5);
      }
    }

    // Si no se encuentra ningún tipo de cambio, devolver valor por defecto
    return moneda === 'USD' ? '3.75000' : '4.25000';
  }

  /**
   * Convierte un string de fecha DD/MM/YYYY a objeto Date
   */
  private parsearFechaString(fechaString: string): Date {
    if (!fechaString) return new Date();

    const partes = fechaString.split('/');
    if (partes.length === 3) {
      const dia = parseInt(partes[0], 10);
      const mes = parseInt(partes[1], 10) - 1; // Los meses en JS van de 0-11
      const anio = parseInt(partes[2], 10);
      return new Date(anio, mes, dia);
    }

    return new Date();
  }

  /**
   * Formatea una fecha a DD/MM/YYYY
   */
  private formatearFecha(fecha: Date | undefined): string {
    if (!fecha) {
      fecha = new Date();
    }
    const dia = fecha.getDate().toString().padStart(2, '0');
    const mes = (fecha.getMonth() + 1).toString().padStart(2, '0');
    const anio = fecha.getFullYear();
    return `${dia}/${mes}/${anio}`;
  }

}