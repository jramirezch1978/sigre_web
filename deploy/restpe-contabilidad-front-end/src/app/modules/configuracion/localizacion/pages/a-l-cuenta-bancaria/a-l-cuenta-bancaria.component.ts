import { Component, OnInit, ViewChild, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalController } from '@ionic/angular';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { AccesorioActionsCellComponent } from 'src/app/modules/activos/m-af-tabla/pages/af-o-registroactivos/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { AutocompleteComponent } from 'src/app/ui/autocomplete/autocomplete.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ConfiguracionFacade } from '../../../application/facades/configuracion.facade';
import { ConfiguracionCuentasBancariasGridEffects } from '../../../effects/configuracion-cuentas-bancarias-grid.effect';
import { CuentaBancariaEntity } from '../../../domain/models/cuenta-bancaria.entity';
import { SucursalEntity } from '../../../domain/models/sucursal.entity';
import { CuentaBancariaService, CuentaBancariaRequest, Opcion } from './cuenta-bancaria.service';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { Subject, Subscription, of } from 'rxjs';
import { debounceTime, distinctUntilChanged, switchMap, catchError } from 'rxjs/operators';

// Font Awesome Icons

@Component({
  selector: 'app-a-l-cuenta-bancaria',
  templateUrl: './a-l-cuenta-bancaria.component.html',
  styleUrls: ['./a-l-cuenta-bancaria.component.scss'],
  standalone: false,
})
export class ALCuentaBancariaComponent implements OnInit, OnDestroy {
  // Inyecciones
  private readonly configuracionFacade = inject(ConfiguracionFacade);
  private readonly cuentasGridEffects = inject(ConfiguracionCuentasBancariasGridEffects);
  private readonly cuentaService = inject(CuentaBancariaService);

  // Catálogos reales del backend para el formulario
  bancos: Opcion[] = [];
  monedasReal: Opcion[] = [];

  // Selectores reactivos del store
  readonly cuentasBancarias = this.configuracionFacade.cuentasBancarias;
  readonly loadingCuentasBancarias = this.configuracionFacade.loadingCuentasBancarias;
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


  

  @ViewChild('sucursalAutocomplete') sucursalAutocomplete!: AutocompleteComponent;

  // RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  
  mostrartabla = true;
  cargando = false;
  botonDesactivado = true;
  private gridApi!: GridApi;
  filaSeleccionada: any = null;
  cuentaBancariaForm!: FormGroup;
  botonguardar='Registrar';
  modoCreacion: boolean = true;

  context = {
    componentParent: this
  }

  tiposCuenta = [
    { id: 'corriente', nombre: 'Corriente' },
    { id: 'ahorros', nombre: 'Ahorros' },
    { id: 'linea', nombre: 'Línea de crédito' },
    { id: 'otros', nombre: 'Otros' }
  ];
  estados = [
    { id: 'activo', nombre: 'Activo' },
    { id: 'inactivo', nombre: 'Inactivo' }
  ];
  monedas = [
     'Soles',
     'Dólares',
  ];

  // Cuentas contables (plan contable detalle real) para el autocomplete
  cuentasContables: Opcion[] = [];
  private todasLasCuentas: any[] = [];
  // Búsqueda server-side de cuentas contables (la tabla tiene miles de filas y no
  // caben en una sola carga; se consulta al backend mientras el usuario escribe).
  private readonly cuentaContableSearch$ = new Subject<string>();
  private cuentaContableSearchSub?: Subscription;

  flujosCaja = [
    { id: 'operativo', nombre: 'Flujo operativo' },
    { id: 'inversion', nombre: 'Flujo de inversión' },
    { id: 'financiamiento', nombre: 'Flujo de financiamiento' }
  ];

  // Mapa de números de cuenta con sus CCI y titulares
  cuentasTitulares: any = {
    '123-1234567-89': { cci: '0002-0002-0002-0002', titular: 'María López' },
    '310-9876543-02': { cci: '0003-0003-0003-0003', titular: 'Carlos Rodríguez' },
    '410-5555555-03': { cci: '0004-0004-0004-0004', titular: 'Ana Martínez' },
    '510-7777777-04': { cci: '0005-0005-0005-0005', titular: 'Pedro Sánchez' }
  };

  // Sucursales reales (ms-core-maestros, id numérico) para el select de Sucursal.
  sucursales: Opcion[] = [];
  private sucursalesCompletas: SucursalEntity[] = [];

  sucursalesColDefs: ColDef[] = [
    { field: 'sucursal_codigo', headerName: 'Código', width: 80 },
    { field: 'sucursal_nombre', headerName: 'Nombre', minWidth: 120, flex: 1 },
    { field: 'sucursal_direccion', headerName: 'Dirección', minWidth: 150, flex: 1 },
    { field: 'sucursal_ciudad', headerName: 'Ciudad', width: 100 },
    { field: 'sucursal_fecha_creacion', headerName: 'Fecha de creación', width: 110 },
    { field: 'sucursal_usuario_responsable', headerName: 'Usuario responsable', minWidth: 120, flex: 1 },
    { field: 'sucursal_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      }},
    { headerClass: 'centrarencabezado', headerName: 'Acciones',   width: 70, cellRenderer: AccesorioActionsCellComponent,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' } }
  ];

  sucursalesRowData: any[] = [];

  columnTypes = {
    default: {
      resizable: false,
      sortable: false,
      filter: false,
      floatingFilter: false,
    }
  };

  colDefs: ColDef[] = [
    { field: 'cuenta_bancaria_fecha_creacion', headerName: 'Fecha de creación', width: 130,
      cellRenderer: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '-';
      }
     },
    { field: 'cuenta_bancaria_entidad', headerName: 'Entidad financiera', width: 120, filter:true },
    { field: 'cuenta_bancaria_tipo_cuenta', headerName: 'Tipo de cuenta', width: 140, filter:true},
    { field: 'cuenta_bancaria_moneda', headerName: 'Moneda', width: 80, filter:true },
    { field: 'cuenta_bancaria_numero_cuenta', headerName: 'N° de cuenta', width: 130 },
    { field: 'cuenta_bancaria_cci', headerName: 'CCI', width: 150 },
    { field: 'cuenta_bancaria_cuenta_contable', headerName: 'Cuenta Contable', flex: 1, minWidth: 130, filter:true},
    { field: 'cuenta_bancaria_saldo_contable', headerName: 'Saldo contable', width: 120, filter: true,
      cellStyle: { textAlign: 'right' },
      valueFormatter: (params: any) => (params.value != null && params.value !== '') ? Number(params.value).toFixed(2) : '-' },
    {
      field: 'cuenta_bancaria_estado',
      headerName: 'Estado', 
      filter:true,
      width: 100,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        const color = params.value === 'activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      }
    },
  ];

  busqueda = '';

  get rowData(): CuentaBancariaEntity[] {
    const all = this.cuentasGridEffects.getRowData();
    const t = (this.busqueda ?? '').trim().toLowerCase();
    if (!t) { return all; }
    return all.filter((c) =>
      `${c.cuenta_bancaria_numero_cuenta} ${c.cuenta_bancaria_cci} ${c.cuenta_bancaria_titular} ${c.cuenta_bancaria_entidad} ${c.cuenta_bancaria_moneda} ${c.cuenta_bancaria_tipo_cuenta}`
        .toLowerCase().includes(t));
  }

  /** Buscador (filtra la grilla en cliente). */
  onBuscar(): void {
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  /** Exporta la grilla a Excel (.xlsx). El backend no expone PDF para esta tabla. */
  exportarExcel(): void {
    this.gridApi?.exportDataAsExcel({ fileName: 'cuentas-bancarias.xlsx', sheetName: 'Cuentas bancarias' });
  }

  getRowId = (params: any) => String(params.data.cuenta_bancaria_id);

  localeText = {
    page: 'Página',
    of: 'de',
    to: 'a',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    noRowsToShow: 'No hay datos para mostrar',
    loadingOoo: 'Cargando...',
  };

  constructor(
    private modalController: ModalController, 
    private toastService: ToastService, 
    private formBuilder: FormBuilder,
    private formValidationService: FormValidationService,
    private simulation: SimulationService,
  ) { 

    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    this.cuentaBancariaForm = this.formBuilder.group({
      fechaCreacion: [{ value: this.getFechaHoy(), disabled: true }],
      codigo: ['', Validators.required],
      bancoId: [null, Validators.required],
      tipoCuenta: ['', Validators.required],
      moneda: [null, Validators.required],
      numeroCuenta: ['', Validators.required],
      cci: [''],
      saldoContable: [0, Validators.required],
      // SOBRA: 'titular' no lo persiste el backend (CuentaBancariaRequest). Se comenta, no se borra.
      // titular: [''],
      descripcion: [''],
      cuentaContable: [null, Validators.required],
      // SOBRA: 'flujoCaja' no lo persiste el backend (CuentaBancariaRequest). Se comenta, no se borra.
      // flujoCaja: [''],
      // FALTA: 'correlativoCheque' es opcional en CuentaBancariaRequest (no @NotNull). Se agrega.
      correlativoCheque: [null],
      // Sucursal asociada (opcional; backend banco_cnta.sucursal_id es nullable).
      sucursalId: [null],
      estado: ['activo', Validators.required],
      // SOBRA: 'entidad' no lo persiste el backend (CuentaBancariaRequest). Se comenta, no se borra.
      // entidad: [''],
    });

    // SOBRA: las sucursales venían de un JSON mock (id = código string). Ahora se cargan reales
    // (id numérico) desde /core/sucursales en ngOnInit, para poder persistir la FK sucursal_id.
    // effect(() => {
    //   const items = this.configuracionFacade.sucursales();
    //   this.sucursalesCompletas = items;
    //   this.sucursales = items.map(s => ({ id: s.sucursal_codigo, nombre: s.sucursal_nombre }));
    // });
  }

  ngOnInit() {
    // Catálogos reales del backend para el formulario
    this.cuentaService.listarBancos().subscribe({ next: (b) => (this.bancos = b), error: () => (this.bancos = []) });
    this.cuentaService.listarMonedas().subscribe({ next: (m) => (this.monedasReal = m), error: () => (this.monedasReal = []) });
    this.cuentaService.buscarPlanContable('').subscribe({
      next: (c) => (this.cuentasContables = c),
      error: () => (this.cuentasContables = []),
    });

    // Sucursales reales (id numérico) para el select de Sucursal.
    this.cuentaService.listarSucursales().subscribe({
      next: (s) => (this.sucursales = s),
      error: () => (this.sucursales = []),
    });

    // Cada tecla en el autocomplete de cuenta contable consulta al backend (con
    // debounce) para buscar sobre TODO el plan contable, no solo las primeras filas.
    this.cuentaContableSearchSub = this.cuentaContableSearch$
      .pipe(
        debounceTime(250),
        distinctUntilChanged(),
        switchMap((q) =>
          this.cuentaService.buscarPlanContable(q ?? '').pipe(catchError(() => of([] as Opcion[])))
        )
      )
      .subscribe((c) => (this.cuentasContables = c));

    // Inicializar servicio de validación
    this.formValidationService.inicializarFormulario(this.cuentaBancariaForm);
    
    // Limpiar estado previo para forzar loader en cada entrada
    this.configuracionFacade.clearCuentasBancarias();
    
    // Cargar cuentas bancarias desde el JSON
    this.configuracionFacade.cargarCuentasBancarias();

    // SOBRA: carga de sucursales mock (JSON). Reemplazada por listarSucursales() real arriba.
    // this.configuracionFacade.cargarSucursales();
    
    this.formValidationService.resetearEstado();
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
    this.cuentaContableSearchSub?.unsubscribe();
  }

  /** Dispara la búsqueda server-side de cuentas contables al escribir en el autocomplete. */
  onBuscarCuentaContable(q: string): void {
    this.cuentaContableSearch$.next(q ?? '');
  }

  getFechaHoy(): string {
    return new Date().toISOString().substring(0, 10);
  }

  /**
   * Normaliza la fecha de creación del backend a `YYYY-MM-DD`, que es lo que
   * espera el `<ion-input type="date">`. Acepta ISO, `yyyy-mm-dd hh:mm` o
   * `dd/mm/yyyy`. Devuelve '' si no hay valor.
   */
  private formatearFechaCreacion(valor: any): string {
    if (!valor) return '';
    const s = String(valor).trim();
    const dmy = s.match(/^(\d{2})\/(\d{2})\/(\d{4})/);
    if (dmy) return `${dmy[3]}-${dmy[2]}-${dmy[1]}`;
    const ymd = s.match(/^(\d{4}-\d{2}-\d{2})/);
    if (ymd) return ymd[1];
    const d = new Date(s);
    if (!isNaN(d.getTime())) {
      const dia = String(d.getDate()).padStart(2, '0');
      const mes = String(d.getMonth() + 1).padStart(2, '0');
      return `${d.getFullYear()}-${mes}-${dia}`;
    }
    return '';
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Aquí iría la lógica para filtrar los datos
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.cuentasGridEffects.setGridApi(params.api);
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

    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Usuario canceló - restaurar fila anterior por referencia de objeto
      if (this.gridApi && this.filaSeleccionada) {
        const prevData = this.filaSeleccionada;
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((n) => {
            if (n.data === prevData) {
              n.setSelected(true);
            }
          });
        }, 0);
      }
      return;
    }

    // Usuario confirmó, cargar datos y seleccionar la nueva fila
    this.cargarDatosCuenta(data);
    this.botonguardar = 'Guardar';
    this.modoCreacion = false;
    setTimeout(() => {
      this.gridApi?.deselectAll();
      clickedNode?.setSelected(true);
    }, 0);
  }

  private cargarDatosCuenta(data: any): void {
    this.filaSeleccionada = data;
    
    // Tipo de cuenta: el backend guarda un código de 1 letra (C/A/L/O); el form usa
    // ids 'corriente'/'ahorros'/'linea'/'otros'. Mapear por id, nombre o inicial.
    const tipoBackend = (data.cuenta_bancaria_tipo_cuenta ?? '').toString();
    const tipoCuentaId =
      this.tiposCuenta.find(t => t.id === tipoBackend)?.id
      ?? this.tiposCuenta.find(t => t.nombre === tipoBackend)?.id
      ?? this.tiposCuenta.find(t => t.id.charAt(0).toUpperCase() === tipoBackend.charAt(0).toUpperCase())?.id
      ?? '';

    // Estado: el grid muestra 'Activo'/'Inactivo'; el form usa ids 'activo'/'inactivo'.
    const estadoId = (data.cuenta_bancaria_estado ?? '').toString().toLowerCase().startsWith('inact')
      ? 'inactivo'
      : 'activo';


    // Llenar el formulario con los datos reales (ids) de la fila seleccionada
    this.cuentaBancariaForm.patchValue({
      fechaCreacion: this.formatearFechaCreacion(data.cuenta_bancaria_fecha_creacion),
      codigo: data.cuenta_bancaria_codigo ?? '',
      bancoId: data.cuenta_bancaria_banco_id ?? null,
      // SOBRA: 'entidad' comentado (no se persiste en backend).
      // entidad: data.cuenta_bancaria_entidad,
      tipoCuenta: tipoCuentaId,
      moneda: data.cuenta_bancaria_moneda_id ?? null,
      numeroCuenta: data.cuenta_bancaria_numero_cuenta,
      cci: data.cuenta_bancaria_cci,
      saldoContable: data.cuenta_bancaria_saldo_contable ?? 0,
      // SOBRA: 'titular' comentado (no se persiste en backend).
      // titular: data.cuenta_bancaria_titular,
      descripcion: data.cuenta_bancaria_descripcion || '',
      cuentaContable: data.cuenta_bancaria_plan_contable_det_id ?? null,
      // SOBRA: 'flujoCaja' comentado (no se persiste en backend).
      // flujoCaja: data.cuenta_bancaria_flujo_caja,
      // FALTA: 'correlativoCheque' (opcional). El backend aún no lo devuelve en el GET; se mapeará cuando esté en el response.
      correlativoCheque: (data.cuenta_bancaria_correlativo_cheque ?? null),
      sucursalId: data.cuenta_bancaria_sucursal_id ?? null,
      estado: estadoId,
    });

    const sucursalId = data.cuenta_bancaria_sucursales?.id;
    const sucursalData = this.sucursalesCompletas.find(s => s.sucursal_codigo === sucursalId);

    const nuevaSucursal = {
      sucursal_codigo: sucursalData?.sucursal_codigo || sucursalId || '',
      sucursal_nombre: sucursalData?.sucursal_nombre || data.cuenta_bancaria_sucursales?.nombre || '',
      sucursal_direccion: sucursalData?.sucursal_direccion || '',
      sucursal_ciudad: sucursalData?.sucursal_ciudad || '',
      sucursal_fecha_creacion: sucursalData?.sucursal_fecha_creacion || '',
      sucursal_usuario_responsable: sucursalData?.sucursal_usuario_responsable || '',
      sucursal_estado: sucursalData?.sucursal_estado || 'Activo'
    };

    // Agregar a la tabla
    this.sucursalesRowData = [nuevaSucursal];

    
    // Resetear estado después de cargar datos
    this.formValidationService.resetearEstado();
  }
  
  onBtReset(): void {
    this.configuracionFacade.cargarCuentasBancarias();
  }

  onCuentaContableSelected(cuenta: any) {
    this.cuentaBancariaForm.patchValue({ cuentaContable: cuenta.id });
  }

  onCCIChanged() {
    this.buscarTitularPorCuenta();
  }

  // Método para buscar el titular basado en número de cuenta y CCI
  buscarTitularPorCuenta() {
    const numeroCuenta = this.cuentaBancariaForm.get('numeroCuenta')?.value;
    const cci = this.cuentaBancariaForm.get('cci')?.value;
    
    if (numeroCuenta && this.cuentasTitulares[numeroCuenta]) {
      const dataCuenta = this.cuentasTitulares[numeroCuenta];
      
      // Si hay CCI, validar que coincida
      if (cci && dataCuenta.cci !== cci) {
        this.toastService.warning('El CCI no coincide con el número de cuenta');
        return;
      }
      
      // Autocompleta el CCI y el titular
      this.cuentaBancariaForm.patchValue({ 
        cci: dataCuenta.cci,
        titular: dataCuenta.titular 
      });
    } else if (numeroCuenta && !this.cuentasTitulares[numeroCuenta]) {
      // Si el número de cuenta no está en el registro, limpiar titular
      this.cuentaBancariaForm.patchValue({ 
        titular: '',
        cci: ''
      });
    }
  }

  onFlujoCajaSelected(flujo: any) {
    this.cuentaBancariaForm.patchValue({ flujoCaja: flujo.id });
  }

  onSucursalSelected(sucursal: any) {
    if (!sucursal) return;

    // Verificar si la sucursal ya está en la tabla
    const yaExiste = this.sucursalesRowData.some(s => s.sucursal_codigo === sucursal.id);
    
    if (yaExiste) {
      this.toastService.warning('Esta sucursal ya ha sido agregada');
      // Limpiar el autocomplete
      setTimeout(() => {
        if (this.sucursalAutocomplete) {
          this.sucursalAutocomplete.clearSelection();
        }
      }, 0);
      return;
    }

    // Buscar datos completos de la sucursal desde el JSON
    const sucursalData = this.sucursalesCompletas.find(s => s.sucursal_codigo === sucursal.id);

    // Crear nuevo registro para la tabla
    const nuevaSucursal = {
      sucursal_codigo: sucursalData?.sucursal_codigo || sucursal.id,
      sucursal_nombre: sucursalData?.sucursal_nombre || sucursal.nombre,
      sucursal_direccion: sucursalData?.sucursal_direccion || '',
      sucursal_ciudad: sucursalData?.sucursal_ciudad || '',
      sucursal_fecha_creacion: sucursalData?.sucursal_fecha_creacion || '',
      sucursal_usuario_responsable: sucursalData?.sucursal_usuario_responsable || '',
      sucursal_estado: sucursalData?.sucursal_estado || 'Activo'
    };

    // Agregar a la tabla
    this.sucursalesRowData = [nuevaSucursal, ...this.sucursalesRowData];
    
    // Limpiar el autocomplete para permitir búsqueda rápida (con setTimeout para asegurar que se ejecute después del ciclo de cambios)
    setTimeout(() => {
      if (this.sucursalAutocomplete) {
        this.sucursalAutocomplete.clearSelection();
      }
    }, 0);
    
    // this.toastService.success(`Sucursal "${sucursal.nombre}" agregada correctamente`);
  }

  async modalverActualizaciones() {
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
      { historial_actualizacion_fecha_hora: '12/11/2025 10:30', historial_actualizacion_usuario: 'Juan Pérez', historial_actualizacion_accion: 'Creación', historial_actualizacion_detalle_cambio: 'Registro inicial de la cuenta bancaria'},
      { historial_actualizacion_fecha_hora: '12/11/2025 14:15', historial_actualizacion_usuario: 'María González', historial_actualizacion_accion: 'Actualización', historial_actualizacion_detalle_cambio: 'Cambio de estado de "Inactivo" a "Activo"' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones de Cuenta Bancaria',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
       
      }
    });
    
    await modal.present();
  }
  guardarcambios() {
    if (this.cuentaBancariaForm.invalid) {
      this.toastService.warning('Completa los campos requeridos: código, banco, tipo, moneda, n° cuenta, saldo y cuenta contable');
      return;
    }

    const f = this.cuentaBancariaForm.getRawValue();
    // tipo_cta_bco es un código de 1 carácter en el backend → inicial del tipo
    // (corriente→C, ahorros→A, linea→L, otros→O).
    const tipoCtaBcoCodigo = (f.tipoCuenta || '').toString().charAt(0).toUpperCase() || 'C';

    const body: CuentaBancariaRequest = {
      codigo: (f.codigo || '').trim(),
      bancoId: Number(f.bancoId),
      planContableDetId: Number(f.cuentaContable),
      monedaId: f.moneda != null && f.moneda !== '' ? Number(f.moneda) : undefined,
      tipoCtaBco: tipoCtaBcoCodigo,
      descripcion: f.descripcion || '',
      // FALTA (opcional): correlativoCheque. Solo se envía si el usuario lo ingresó.
      correlativoCheque: f.correlativoCheque != null && f.correlativoCheque !== '' ? Number(f.correlativoCheque) : undefined,
      saldoContable: Number(f.saldoContable ?? 0),
      nroCci: f.cci || '',
      nroCuenta: f.numeroCuenta || '',
      sucursalId: f.sucursalId != null && f.sucursalId !== '' ? Number(f.sucursalId) : null,
    };

    const esEdicion = this.botonguardar === 'Guardar' && !!this.filaSeleccionada?.cuenta_bancaria_id;
    const obs = esEdicion
      ? this.cuentaService.actualizar(this.filaSeleccionada.cuenta_bancaria_id, body)
      : this.cuentaService.crear(body);

    obs.subscribe({
      next: () => {
        this.toastService.success(esEdicion ? '¡Cuenta bancaria actualizada!' : '¡Cuenta bancaria registrada!');
        this.limpiarFormulario();
        this.formValidationService.resetearEstado();
        this.configuracionFacade.cargarCuentasBancarias();
      },
      error: (e) => this.toastService.danger(e?.message || 'Error al guardar la cuenta bancaria'),
    });
  }

  async nuevoConcepto() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }

    this.limpiarFormulario();
  }

  async botonCancelar(): Promise<void> {
    // Validar cambios antes de cancelar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Cancelar acción
    }

    // Limpiar el formulario
    this.limpiarFormulario();
  }

  private limpiarFormulario(): void {
    // Limpiar la tabla de sucursales, dejando solo los encabezados
    this.botonguardar = 'Registrar';
    this.modoCreacion = true;
    this.sucursalesRowData = [];
    this.filaSeleccionada = null;
    
    // Resetear el formulario con la fecha actual y estado por defecto
    this.cuentaBancariaForm.reset({
      fechaCreacion: this.getFechaHoy(),
      estado: 'activo'
    });
    
    // Desmarcar fila seleccionada en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }
  
  async eliminar(): Promise<void> {
    if (!this.filaSeleccionada?.cuenta_bancaria_id) {
      this.toastService.warning('Selecciona una cuenta bancaria para eliminar');
      return;
    }

    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) {
      return;
    }

    this.cuentaService.eliminar(this.filaSeleccionada.cuenta_bancaria_id).subscribe({
      next: () => {
        this.toastService.success('¡Cuenta bancaria eliminada!');
        this.limpiarFormulario();
        this.formValidationService.resetearEstado();
        this.configuracionFacade.cargarCuentasBancarias();
      },
      error: (e) => this.toastService.danger(e?.message || 'Error al eliminar la cuenta bancaria'),
    });
  }

  eliminarAccesorio(sucursal: any) {
    if (!sucursal) return;
    const existe = this.sucursalesRowData.some(
      item => item.sucursal_codigo === sucursal.sucursal_codigo
    );
    if (!existe) {
      this.toastService.warning('La sucursal no existe');
      return;
    }
    this.sucursalesRowData = this.sucursalesRowData.filter(
      item => item.sucursal_codigo !== sucursal.sucursal_codigo
    );
  }

}
