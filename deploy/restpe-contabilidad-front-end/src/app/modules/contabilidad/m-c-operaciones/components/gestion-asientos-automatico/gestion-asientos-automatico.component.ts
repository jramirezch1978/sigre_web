import { Component, OnInit, computed, effect, inject } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { AccesorioActionsCellComponent } from 'src/app/modules/activos/m-af-tabla/pages/af-o-registroactivos/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { AsientoAutomaticoItem, CuentaMovimientoAutomaticoItem } from 'src/app/modules/contabilidad/domain/models/gestion-asientos-automatico.entity';
import { GestionAsientosAutomaticoFacade } from 'src/app/modules/contabilidad/application/facades/gestion-asientos-automatico.facade';
import { SeleccionarCuentaContableFacade } from 'src/app/modules/contabilidad/application/facades/seleccionar-cuenta-contable.facade';
import { GestionAsientosAutomaticosFeedbackEffects } from 'src/app/modules/contabilidad/effects/gestion-asientos-automaticos-feedback.effect';
import { SeleccionarCuentaContableFeedbackEffects } from 'src/app/modules/contabilidad/effects/seleccionar-cuenta-contable-feedback.effect';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faGear, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
@Component({
  selector: 'app-gestion-asientos-automatico',
  templateUrl: './gestion-asientos-automatico.component.html',
  styleUrls: ['./gestion-asientos-automatico.component.scss'],
  standalone: false
})
export class GestionAsientosAutomaticoComponent implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasGear = faGear;
  fasRotateRight = faRotateRight;

  // ── Facades & Effects ────────────────────────────────────────────────────
  private readonly gestionFacade   = inject(GestionAsientosAutomaticoFacade);
  private readonly cuentaFacade    = inject(SeleccionarCuentaContableFacade);
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  private readonly gestionEffects  = inject(GestionAsientosAutomaticosFeedbackEffects);
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  private readonly cuentaEffects   = inject(SeleccionarCuentaContableFeedbackEffects);

  // ── Señales reactivas ─────────────────────────────────────────────────────
  rowData: AsientoAutomaticoItem[] = [];
  readonly isLoading = computed(() => this.gestionFacade.isLoading());

  pais= this.countryService.getCountryCode();
  countries= ALL_COUNTRIES
  private gridApi!: GridApi;
  private gridApiCuentas!: GridApi;
  estadoSeleccionado: string = 'todos';
  filaSeleccionada: any = null;
  GestionAsientosAutomaticoForm!: FormGroup;
  mostrartabla: boolean = true;
  datosseleccionado = false;
  mostrarRevertir = false;
  mostrarGuardar = true;
  mostrarDuplicar = false;
  calendarioDeshabilitado = false;
  asientoSeleccionado: AsientoAutomaticoItem | null = null;
  estadoAnterior: string = 'Activo';
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  fechaContableSelected: Date | undefined;
  monedasignificado: string = '';
  libros = [
    { id: 'Diario', nombre: 'Diario' },
    { id: 'Mayor', nombre: 'Mayor' },
    { id: 'Compras', nombre: 'Compras' },
    { id: 'Ventas', nombre: 'Ventas' }
  ];

  monedas = [
    { id: 'Soles', nombre: 'Soles' },
    { id: 'USD', nombre: 'Dólares' },

  ];

  // Cuentas contables derivadas desde el catálogo del facade
  get cuentasContables() {
    return this.cuentaFacade.items().map(c => ({
      id: c.cuenta_contable_codigo,
      nombre: `${c.cuenta_contable_codigo} - ${c.cuenta_contable_descripcion}`
    }));
  }

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

  colDefs: ColDef<AsientoAutomaticoItem>[] = [
    { field: 'asiento_auto_numero_asiento', headerName: 'Nº de asiento', flex: 1, minWidth: 100 },
    { field: 'asiento_auto_fecha_registro', headerName: 'Fecha registro', flex: 1, minWidth: 110 },
    { field: 'asiento_auto_fecha_contable', headerName: 'Fecha contable', flex: 1, minWidth: 110 },
    { field: 'asiento_auto_glosa', headerName: 'Glosa', flex: 2, minWidth: 150 },
    { field: 'asiento_auto_situacion_contable', headerName: 'Situación contable', flex: 1.2, minWidth: 120, filter: true },
    {
      field: 'asiento_auto_total', headerName: 'Total', flex: 0.8, minWidth: 80, headerClass: 'derechaencabezado',
      valueFormatter: params => params.value ? `S/ ${params.value.toFixed(2)}` : 'S/ 0.00',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' }
    },
    {
      field: 'asiento_auto_estado',
      headerName: 'Estado',
      headerClass: 'centrarencabezado',
      flex: 0.8,
      minWidth: 80, filter: true,
      cellRenderer: (params: any) => {
        const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  colDefsCuentas: ColDef[] = [];

  rowDataCuentas: CuentaMovimientoAutomaticoItem[] = [];

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
    private router: Router,
    private countryService: CountryService,
    private formValidationService: FormValidationService) {

    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Sincronizar rowData y la grid cada vez que la facade actualice los asientos (igual que facturación)
    effect(() => {
      const asientos = this.gestionFacade.items() as AsientoAutomaticoItem[];
      this.rowData = asientos;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', asientos);
      }
    });
  }

  ngOnInit() {
    this.obtenerdatospais();
    this.inicializartabla();

    // Cargar datos desde facades
    this.gestionFacade.cargarDatos();
    this.cuentaFacade.cargarDatos();

    this.GestionAsientosAutomaticoForm = this.formBuilder.group({
      usuario: [{ value: 'Juan Pérez', disabled: true }],
      fechaRegistro: [{ value: new Date().toISOString().split('T')[0], disabled: true }],
      origen: [{ value: 'Manual', disabled: true }],
      fechaContable: [{ value: 'Manual', disabled: true }],
      libro: [''],
      moneda: ['Soles'],
      tasaCambio: [{ value: '3.75', disabled: true }],
      estado: ['Activo'],
      situacionContable: [{ value: 'No transferido', disabled: true }],
      glosaContable: ['']
    });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.GestionAsientosAutomaticoForm);
  }

  // // Implementación del guard CanDeactivate usando el servicio
  // async canDeactivate(): Promise<boolean> {
  //   return await this.formValidationService.canDeactivate();
  // }
  obtenerdatospais(){
    this.countries.find((country: any) => {
      if(country.codigo === this.pais){
        this.monedasignificado=country.monedapais[0].value
      }
    });
  }
  inicializartabla(){
    this.colDefsCuentas = [
      { field: 'cuenta_mov_auto_cuenta', headerName: 'Cuenta', flex: 0.8, minWidth: 80 },
      { field: 'cuenta_mov_auto_descripcion', headerName: 'Descripción', flex: 1.5, minWidth: 120 },
      {
        field: 'cuenta_mov_auto_debe_soles', headerName: 'Debe('+ this.monedasignificado + ')', flex: 0.8, minWidth: 80, headerClass: 'derechaencabezado',
        valueFormatter: params => params.value ? params.value.toFixed(2) : '0.00', editable: true,
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' }
      },
      {
        field: 'cuenta_mov_auto_haber_soles', headerName: 'Haber('+ this.monedasignificado + ')', flex: 0.8, minWidth: 80, headerClass: 'derechaencabezado',
        valueFormatter: params => params.value ? params.value.toFixed(2) : '0.00', editable: true,
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' }
      },
      ...(
        this.pais === 'EC' ? [] : [
        {
          field: 'cuenta_mov_auto_debe_dolares', headerName: 'Debe($)', flex: 0.8, minWidth: 80, headerClass: 'derechaencabezado',
          valueFormatter: (params: any) => params.value ? params.value.toFixed(2) : '0.00', editable: true,
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' }
        },
        {
          field: 'cuenta_mov_auto_haber_dolares', headerName: 'Haber($)', flex: 0.8, minWidth: 80, headerClass: 'derechaencabezado',
          valueFormatter: (params: any) => params.value ? params.value.toFixed(2) : '0.00', editable: true,
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' }
        },
      ]
      ),
      {
        field: 'cuenta_mov_auto_centro_costo', headerName: 'Centro de costo', flex: 1, minWidth: 100,
        cellEditor: 'agSelectCellEditor',
        cellEditorParams: {
          values: ['Administración', 'Finanzas', 'Compras', 'Ventas', 'Operaciones', 'Marketing']
        },
        editable: true
      },
      { field: 'cuenta_mov_auto_doc_referencial', headerName: 'Doc. referencial', flex: 1, minWidth: 100, editable: true },
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
  }
  onBtReset() {
    if (this.gridApi) {
      // Mostrar loading y recargar datos
      this.gridApi.showLoadingOverlay();

      // Recargar datos desde facade (el effect sincroniza automáticamente)
      this.gestionFacade.cargarDatos();
      setTimeout(() => {
        this.gridApi.hideOverlay();
      }, 400);
    }
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;

    setTimeout(() => {
      if (!this.gridApi) return;

      if (this.asientoSeleccionado) {
        // Restaurar selección visual cuando el grid se recrea (toggle del panel)
        this.gridApi.deselectAll();
        this.gridApi.forEachNode((node: any) => {
          if (node.data && node.data.asiento_auto_numero_asiento === this.asientoSeleccionado!.asiento_auto_numero_asiento) {
            node.setSelected(true);
            this.gridApi.ensureNodeVisible(node, 'middle');
          }
        });
      } else if (this.rowData.length > 0) {
        // Primera carga: seleccionar la primera fila por defecto
        const firstNode = this.gridApi.getRowNode('0');
        if (firstNode) {
          firstNode.setSelected(true);
          this.onCellClicked({ data: this.rowData[0] });
        }
      }
    }, 150);
  }

  onGridReadyCuentas(params: GridReadyEvent) {
    this.gridApiCuentas = params.api;
  }

  onCellClicked(event: any) {
    const data: AsientoAutomaticoItem = event.data;
    console.log('Asiento seleccionado:', data);

    this.asientoSeleccionado = data;
    this.estadoAnterior = data.asiento_auto_estado;

    // Cargar cuentas de movimiento del asiento seleccionado
    this.rowDataCuentas = data.asiento_auto_cuentas ? [...data.asiento_auto_cuentas] : [];
    if (this.gridApiCuentas) {
      this.gridApiCuentas.setGridOption('rowData', this.rowDataCuentas);
    }

    // Actualizar fecha contable en el calendario
    this.fechaContableSelected = data.asiento_auto_fecha_contable
      ? new Date(data.asiento_auto_fecha_contable + 'T00:00:00')
      : undefined;

    // Llenar formulario con datos seleccionados
    this.GestionAsientosAutomaticoForm.patchValue({
      usuario: data.asiento_auto_usuario,
      fechaRegistro: data.asiento_auto_fecha_registro,
      origen: data.asiento_auto_origen,
      fechaContable: data.asiento_auto_fecha_contable,
      libro: data.asiento_auto_libro,
      moneda: data.asiento_auto_moneda,
      tasaCambio: data.asiento_auto_tasa_cambio,
      estado: data.asiento_auto_estado,
      situacionContable: data.asiento_auto_situacion_contable,
      glosaContable: data.asiento_auto_glosa
    });

    // Deshabilitar campos si está transferido
    if (data.asiento_auto_estado === 'Activo' && data.asiento_auto_situacion_contable === 'Transferido') {
      this.GestionAsientosAutomaticoForm.get('fechaContable')?.disable();
      this.GestionAsientosAutomaticoForm.get('moneda')?.disable();
      this.GestionAsientosAutomaticoForm.get('libro')?.disable();
      this.GestionAsientosAutomaticoForm.get('estado')?.disable();
      this.GestionAsientosAutomaticoForm.get('glosaContable')?.disable();
      this.GestionAsientosAutomaticoForm.get('fechaRegistro')?.disable();
      this.GestionAsientosAutomaticoForm.get('origen')?.disable();
      this.calendarioDeshabilitado = true;

      // Asiento transferido: solo Revertir activo
      this.mostrarRevertir = true;
      this.datosseleccionado = false;
      this.mostrarGuardar = false;
      this.mostrarDuplicar = false;
    }
    // Revertir: No transferido + Activo
    else if (data.asiento_auto_estado === 'Activo' && data.asiento_auto_situacion_contable === 'No transferido') {
      this.GestionAsientosAutomaticoForm.get('fechaContable')?.disable();
      this.GestionAsientosAutomaticoForm.get('moneda')?.disable();
      this.GestionAsientosAutomaticoForm.get('libro')?.disable();
      this.GestionAsientosAutomaticoForm.get('estado')?.enable();
      this.GestionAsientosAutomaticoForm.get('glosaContable')?.enable();
      this.GestionAsientosAutomaticoForm.get('fechaRegistro')?.disable();
      this.GestionAsientosAutomaticoForm.get('origen')?.disable();
      this.calendarioDeshabilitado = true;

      this.mostrarRevertir = false;
      this.datosseleccionado = true;
      this.mostrarGuardar = true;
      this.mostrarDuplicar = true;
    }
    else {
      // Otros estados
      this.GestionAsientosAutomaticoForm.get('fechaContable')?.disable();
      this.GestionAsientosAutomaticoForm.get('moneda')?.disable();
      this.GestionAsientosAutomaticoForm.get('libro')?.disable();
      this.GestionAsientosAutomaticoForm.get('estado')?.disable();
      this.GestionAsientosAutomaticoForm.get('glosaContable')?.disable();
      this.GestionAsientosAutomaticoForm.get('fechaRegistro')?.disable();
      this.GestionAsientosAutomaticoForm.get('origen')?.disable();
      this.calendarioDeshabilitado = true;

      this.datosseleccionado = false;
      this.mostrarRevertir = true;
      this.mostrarGuardar = false;
      this.mostrarDuplicar = false;
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
    console.log('Fecha contable seleccionada:', date);
    this.fechaContableSelected = date;
    this.GestionAsientosAutomaticoForm.patchValue({ fechaContable: date });
  }
  botonNuevaClase() {
    console.log('Nueva clase');
  }

  botonNuevaSubclase() {
    console.log('Nueva subclase');
  }

  onCuentaContableSeleccionada(cuenta: any) {
    console.log('Cuenta seleccionada:', cuenta);
    // Lógica para agregar cuenta a la tabla
  }

  async onEstadoChange(event: any) {
    const nuevoEstado = event.detail.value;

    if (nuevoEstado === 'Inactivo' && this.datosseleccionado && this.asientoSeleccionado) {
      // Abrir modal de confirmación
      await this.abrirModalInactivar();
    }
  }

  guardar() {
    if (!this.filaSeleccionada){
      this.toastService.warning('Por favor selecciona un asiento para guardar los cambios');
      return;
    }
    this.botonguardar()
  }
  async abrirmodalUbicaciones() {
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar ubicaciones',
        descripcionSubir: 'Comparte tu archivo de excel con la información de tus ubicaciones y regístralos automáticamente en la plataforma.',
        buttonName: 'Importar ubicaciones',
      }
    });
    await modal.present();
  }
  async modalverActualizaciones() {
    // Definir las columnas
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 150, },
      { headerName: 'Usuario', field: 'usuario', width: 120, },
      { headerName: 'Acción', field: 'accion', width: 150, wrapText: true, autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
      { headerName: 'Detalle del cambio', field: 'detalleCambio', flex: 1, wrapText: true, autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
    ];

    // Datos de ejemplo
    const rowData = [
      { fechaHora: '12/11/2025 14:40:22', usuario: 'Carlos Zapata', accion: 'Duplicar', detalleCambio: 'Se ha duplicado el asiento MN-2025-12-01-020'},
      { fechaHora: '12/11/2025 14:40:22', usuario: 'Carlos Zapata', accion: 'Edición de asiento', detalleCambio: 'Se ajusta la glosa para identificar que los insumos son para producción.'},
      { fechaHora: '08/11/2025 14:15:30', usuario: 'Jorgue Gómez', accion: 'Registro de asiento', detalleCambio: 'El asiento no se creó con el registro de la factura F001-002334'},

    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones del Asiento ${this.asientoSeleccionado?.asiento_auto_numero_asiento}`,
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
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Duplicar asiento MN-2025-11-01-003',
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
      console.log('Almacén eliminado. Motivo:', data.motivo);
      this.router.navigate(['/contabilidad/operaciones/gestion-asientos-manual']);
    }
  }
  public async abrirModalInactivar() {
    if (!this.asientoSeleccionado) return;

    const detallesEjemplo: DetalleItem[] = [
      { label: 'Número de asiento', value: this.asientoSeleccionado.asiento_auto_numero_asiento },
      { label: 'Fecha de registro', value: this.asientoSeleccionado.asiento_auto_fecha_registro },
      { label: 'Fecha contable', value: this.asientoSeleccionado.asiento_auto_fecha_contable },
      { label: 'Glosa', value: this.asientoSeleccionado.asiento_auto_glosa },
      { label: 'Total', value: `S/ ${this.asientoSeleccionado.asiento_auto_total.toFixed(2)}` },
      { label: 'Estado actual', value: 'Activo' }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Inactivar asiento ${this.asientoSeleccionado.asiento_auto_numero_asiento}`,
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
      // Confirmar inactivación - mantener el estado Inactivo
      this.toastService.success('¡Asiento inactivado exitosamente!');

      // Actualizar el estado en la tabla
      if (this.asientoSeleccionado) {
        this.asientoSeleccionado.asiento_auto_estado = 'Inactivo';
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }
    } else {
      // Cancelar - revertir al estado anterior
      this.GestionAsientosAutomaticoForm.patchValue({
        estado: this.estadoAnterior
      }, { emitEvent: false });
    }
  }
  public async botonrevertir() {
    // Ejemplo de datos que puedes personalizar
    const detallesEjemplo: DetalleItem[] = [
      { label: 'Fecha de registro', value: '12/12/2025' },
      { label: 'Fecha contable', value: '12/12/2025' },
      { label: 'Glosa', value: 'Provisión de servicios de internet - Local San Isidro (Mes 11/2025).' },
      { label: 'Total', value: 'S/380.00' },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Reverso de asiento ${this.filaSeleccionada.asiento_auto_numero_asiento}`,
        subtitulomodal: 'Detalle de asiento:',
        tituloTextarea: 'Motivo de reversión:',
        placeholderTextarea: 'Agrega el motivo de la reversión',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Revertir',
        colorBotonConfirmar: 'primary',
        botonoutline: 'solid'
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      console.log('Almacén eliminado. Motivo:', data.motivo);
      // Aquí puedes agregar la lógica para eliminar el almacén
    }
  }
  public async botonguardar() {
    // Ejemplo de datos que puedes personalizar
    const detallesEjemplo: DetalleItem[] = [
      { label: 'Fecha de registro', value: '12/12/2025' },
      { label: 'Fecha contable', value: '12/12/2025' },
      { label: 'Glosa', value: 'Provisión de servicios de internet – Local San Isidro (Mes 11/2025).' },
      { label: 'Total', value: 'S/380.00' },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Cambios de asiento ${this.filaSeleccionada.asiento_auto_numero_asiento}`,
        subtitulomodal: 'Detalle de asiento:',
        tituloTextarea: 'Motivo de cambio:',
        placeholderTextarea: 'Agrega el motivo del cambio',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Guardar cambios',
        colorBotonConfirmar: 'primary',
        botonoutline: 'solid'

      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      console.log('Cambios guardados. Motivo:', data.motivo);
      this.toastService.success('¡Cambios guardados exitosamente!');
    }
  }

  async abrirModalAnular() {
    if (!this.asientoSeleccionado) {
      this.toastService.warning('Por favor selecciona un asiento para anular');
      return;
    }

    const detallesEjemplo = [
      { label: 'Número de asiento', value: this.asientoSeleccionado.asiento_auto_numero_asiento },
      { label: 'Total', value: `S/ ${this.asientoSeleccionado.asiento_auto_total.toFixed(2)}` },
      { label: 'Fecha de registro', value: this.asientoSeleccionado.asiento_auto_fecha_registro },
      { label: 'Estado', value: this.asientoSeleccionado.asiento_auto_estado },
      { label: 'Fecha contable', value: this.asientoSeleccionado.asiento_auto_fecha_contable },
      { label: 'Glosa', value: this.asientoSeleccionado.asiento_auto_glosa },

    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Anular asiento ${this.asientoSeleccionado.asiento_auto_numero_asiento}`,
        subtitulomodal: 'Detalle del asiento:',
        detalles: detallesEjemplo,
        tituloTextarea: 'Motivo de anulación:',
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Anular',
        colorBotonConfirmar: 'danger',
        motivoObligatorio: true
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      // Actualizar estado a 'Inactivo'
      const currentRows = [...this.rowData];
      const index = currentRows.findIndex(item => item.asiento_auto_numero_asiento === this.asientoSeleccionado!.asiento_auto_numero_asiento);

      if (index !== -1) {
        currentRows[index] = { ...currentRows[index], asiento_auto_estado: 'Inactivo' };
        this.rowData = currentRows;
        this.asientoSeleccionado!.asiento_auto_estado = 'Inactivo';

        // Actualizar la tabla
        this.gridApi.setGridOption('rowData', [...this.rowData]);

        // Mantener la fila seleccionada visualmente después de actualizar
        setTimeout(() => {
          const nodoSeleccionado = this.gridApi.getRowNode(index.toString());
          if (nodoSeleccionado) {
            nodoSeleccionado.setSelected(true);
          }
        }, 100);

        // Actualizar el formulario
        this.GestionAsientosAutomaticoForm.patchValue({
          estado: 'Inactivo'
        });

        this.toastService.success('¡Acción realizada con éxito!');
      }
    }
  }
}
