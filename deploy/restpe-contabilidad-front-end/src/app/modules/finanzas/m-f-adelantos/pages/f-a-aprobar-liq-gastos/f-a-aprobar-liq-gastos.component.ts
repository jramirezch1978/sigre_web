import { Component, OnInit, inject, computed, effect } from '@angular/core';
import { FormsModule, ReactiveFormsModule, FormGroup, FormBuilder } from '@angular/forms';
import { IonicModule, ModalController } from '@ionic/angular';
import { AgGridAngular } from 'ag-grid-angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ToastService } from 'src/app/ui/services/toast.service';
import { BotonAccionesComponent } from 'src/app/ui/boton-acciones/boton-acciones.component';
import { UiModule } from 'src/app/ui/ui.module';
import { ModalVerActualizacionesComponent } from '../../../../../ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalDetalleComponent } from '../../../../../ui/modal-detalle/modal-detalle.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { AprobarLiqGastosFacade } from 'src/app/modules/finanzas/application/facades/aprobar-liq-gastos.facade';
import { AprobarLiqGastosSyncEffects } from 'src/app/modules/finanzas/effects/aprobar-liq-gastos-sync.effect';
import { AprobarLiqGastosFeedbackEffects } from 'src/app/modules/finanzas/effects/aprobar-liq-gastos-feedback.effect';
import { LiqRendicionEntity } from 'src/app/modules/finanzas/domain/models/liq-rendicion.entity';
import { ValidacionCierre } from 'src/app/modules/finanzas/domain/repositories/iaprobar-liq-gastos.repository';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-f-a-aprobar-liq-gastos',
  templateUrl: './f-a-aprobar-liq-gastos.component.html',
  styleUrls: ['./f-a-aprobar-liq-gastos.component.scss'],
  standalone: false
})
export class FAAprobarLiqGastosComponent implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  //Tipo de cambio para ecuador
  pais = this.countryService.getCountryCode();
  mostrarTipoCambio: boolean = true;

  // Facade
  readonly facade = inject(AprobarLiqGastosFacade);
  readonly loaderActivo = computed(() => this.facade.isLoading());
  // EFFECTS (inyectar para que los constructores registren los effect())
  private readonly _syncEffects = inject(AprobarLiqGastosSyncEffects);
  private readonly _feedbackEffects = inject(AprobarLiqGastosFeedbackEffects);

  // ESTADO DEL COMPONENTE
  LiquidacionForm!: FormGroup;
  // Valores locales y estados
  filaSeleccionada: LiqRendicionEntity | null = null;
  // Mostrar panel izquierdo (lista de liquidaciones) por defecto
  panelLateralVisible = true;
  startDate: Date = new Date();
  endDate: Date = new Date();
  minDate?: Date;
  maxDate?: Date;
  private gridApi!: GridApi;

  // LOCALES (texto de paginación / labels)
  localeText: any = {
    page: 'Página',
    more: 'Más',
    to: 'a',
    of: 'de',
    next: 'Siguiente',
    last: 'Última'
  };

  // Control para deshabilitar botones de acción (Observar / Aprobar)
  accionesDisabled = false;
  cantidadSeleccionadas = 0;

  getRowClass = (params: any) => {
    if (params.data && params.data.lr_estado !== 'Pendiente') {
      return 'row-disabled';
    }
    return '';
  };

  get noHayLiquidacionesSeleccionadas(): boolean {
    return !this.rowData.some(
      (row) => row.lr_seleccionado === true && row.lr_estado === 'Pendiente'
    );
  }

  gridOptions: any = {
    context: { componentParent: this },
    suppressRowClickSelection: false,
    rowSelection: 'single'
  };

  frameworkComponents = {
    BotonAccionesComponent: BotonAccionesComponent
  };

  // DEFINICIÓN DE COLUMNAS
  colDefs: ColDef[] = [
    { headerCheckboxSelection: true, checkboxSelection: (params: any) => params.data && params.data.lr_estado === 'Pendiente', width: 40, headerName: '', pinned: 'left', headerClass: 'header-checkbox-col', cellClass: 'cell-checkbox-col',},
    { field: 'lr_num_liquidacion', headerName: 'Codigo', width: 170, filter: true,},
    { field: 'lr_beneficiario', headerName: 'Beneficiario', width: 170, filter: true,},
    { field: 'lr_tipo_gasto', headerName: 'Tipo de gasto', width: 120, filter: true,},
    { field: 'lr_centro_costo', headerName: 'Centro de costo', width: 140, filter: true,},
    { field: 'lr_monto_adelantado', headerName: 'Monto adelantado', headerClass: 'derechaencabezado', cellStyle: { display: 'flex', justifyContent: 'end' }, width: 130,
      valueFormatter: (params: any) => {
        const moneda = 'S/';
        return `${moneda} ${params.value}.00`;
      }
    },
    { field: 'lr_monto_gastado', headerName: 'Monto gastado', headerClass: 'derechaencabezado', cellStyle: { display: 'flex', justifyContent: 'end' }, width: 120,
      valueFormatter: (params: any) => {
        const moneda = 'S/';
        return `${moneda} ${params.value}.00`;
      }
    },
    { field: 'lr_moneda', headerName: 'Moneda', width: 80, filter: true, },
    { headerClass: 'centrarencabezado', field: 'lr_estado', headerName: 'Estado', width: 100, filter: true,
      cellRenderer: (params: any) => {
        const v = params.value;
        // Estados reales de liquidación: Pendiente(1) / Cerrada(2) / Anulada(0).
        if (v === 'Pendiente') {
          return `<span class="badge-table bg-[#F5F5F5] text-[#1F1F1F]">Pendiente</span>`;
        } else if (v === 'Anulada') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulada</span>`;
        } else if (v === 'Cerrada') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Cerrada</span>`;
        }
        // SOBRA: 'Aprobada'/'Rechazada'/'Observada' no existen en el backend.
        return v || '';
      },
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center'}
    },
  ];

  tipoGastos = [
    { id: 'alimentacion', nombre: 'Alimentación' },
    { id: 'transporte', nombre: 'Transporte' },
    { id: 'hospedaje', nombre: 'Hospedaje' },
    { id: 'materiales', nombre: 'Materiales' },
    { id: 'servicios', nombre: 'Servicios' },
  ];

  centrosCosto = [
    { id: 1, nombre: 'Administración' },
    { id: 2, nombre: 'Ventas' },
    { id: 3, nombre: 'Operaciones' },
    { id: 4, nombre: 'Finanzas' },
    { id: 5, nombre: 'Recursos Humanos' },
  ];

  colaboradores = [
    { dni: '02771568', nombre: 'Vanessa López Castillo', tipoBeneficiario: 'colaborador', centroCosto: 'Administración' },
    { dni: '12345678', nombre: 'Carlos Zapata García', tipoBeneficiario: 'colaborador', centroCosto: 'Ventas' },
    { dni: '87654321', nombre: 'María González López', tipoBeneficiario: 'colaborador', centroCosto: 'Operaciones' },
    { dni: '11111111', nombre: 'Juan Pérez Rodríguez', tipoBeneficiario: 'colaborador', centroCosto: 'Finanzas' },
    { dni: '22222222', nombre: 'Ana Martínez Silva', tipoBeneficiario: 'colaborador', centroCosto: 'Recursos Humanos' },
  ];

  proveedores = [
    { ruc: '20123456789', nombre: 'Transportes XYZ S.A.C.', tipoBeneficiario: 'proveedor', centroCosto: 'Operaciones' },
    { ruc: '20987654321', nombre: 'Servicios Generales Peru', tipoBeneficiario: 'proveedor', centroCosto: 'Administración' },
    { ruc: '20111222333', nombre: 'Insumos Industriales LTDA', tipoBeneficiario: 'proveedor', centroCosto: 'Finanzas' },
  ];

  gastosDisponibles: any[] = [
    { codigo: 'GAST001', descripcion: 'Transporte Terrestre', monto: 150, fechaGasto: '15/12/2025', tipoDocumento: 'Boleta', proveedor: 'Uber', moneda: ' Soles' },
    { codigo: 'GAST002', descripcion: 'Almuerzo de negocios', monto: 100, fechaGasto: '16/12/2025', tipoDocumento: 'Boleta', proveedor: 'Restaurante XYZ', moneda: ' Soles' },
    { codigo: 'GAST003', descripcion: 'Materiales de oficina', monto: 100, fechaGasto: '14/12/2025', tipoDocumento: 'Factura', proveedor: 'Office Depot', moneda: ' Soles' },
    { codigo: 'GAST004', descripcion: 'Hospedaje', monto: 150, fechaGasto: '13/12/2025', tipoDocumento: 'Factura', proveedor: 'Hotel Lima', moneda: ' Soles' },
    { codigo: 'GAST005', descripcion: 'Servicios de telefonía', monto: 100, fechaGasto: '12/12/2025', tipoDocumento: 'Factura', proveedor: 'Claro', moneda: ' Soles' },
  ];

  rowDataGastos: any[] = [
    { codigo: 'GAST001', descripcion: 'Transporte Terrestre', tipoGasto: 'Alimentación', monto: 150, fechaGasto: '15/12/2025', tipoDocumento: 'Boleta', serieNumero: 'B001-567821', proveedor: 'Uber', moneda: ' Soles' },
    { codigo: 'GAST002', descripcion: 'Almuerzo de negocios', tipoGasto: 'Transporte', monto: 100, fechaGasto: '16/12/2025', tipoDocumento: 'Boleta', serieNumero: 'B001-009234', proveedor: 'Restaurante XYZ', moneda: ' Soles' },
    { codigo: 'GAST003', descripcion: 'Materiales de oficina', tipoGasto: 'Materiales', monto: 100, fechaGasto: '14/12/2025', tipoDocumento: 'Factura', serieNumero: 'F001-778211', proveedor: 'Office Depot', moneda: ' Soles' },
    { codigo: 'GAST004', descripcion: 'Hospedaje', tipoGasto: 'Viáticos', monto: 150, fechaGasto: '13/12/2025', tipoDocumento: 'Factura', serieNumero: 'F001-009111', proveedor: 'Hotel Lima', moneda: ' Soles' },
    { codigo: 'GAST005', descripcion: 'Servicios de telefonía', tipoGasto: 'Transporte', monto: 100, fechaGasto: '12/12/2025', tipoDocumento: 'Factura', serieNumero: 'F001-223344', proveedor: 'Claro', moneda: ' Soles' },
  ];

  colDefsGastos: ColDef[] = [
    { field: 'fechaGasto', headerName: 'Fecha de gasto', width: 120,},
    { field: 'descripcion', headerName: 'Descripción', flex: 1, minWidth: 200},
    { field: 'tipoGasto', headerName: 'Tipo de gasto', minWidth: 100, filter: true,},
    { field: 'tipoDocumento', headerName: 'Tipo de Documento', width: 130,},
    { field: 'serieNumero', headerName: 'Serie y n° de documento', width: 170,},
    { field: 'proveedor', headerName: 'Proveedor', flex: 1, minWidth: 160, maxWidth: 160,},
    { field: 'moneda', headerName: 'Moneda', width: 80,
    },
    { field: 'monto', headerName: 'Monto', headerClass: 'derechaencabezado', 
      cellStyle: { display: 'flex', justifyContent: 'end' }, width: 100, type: 'rightAligned',
    },
    { headerName: 'Acciones', field: 'acciones', width: 60, cellRenderer: BotonAccionesComponent,
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
  ];

  private gridApiGastos!: GridApi;

  gridOptionsGastos = {
    context: {
      componentParent: this,
      esEditable: () => false // Siempre deshabilitado en aprobación
    }
  };

  rowData: LiqRendicionEntity[] = [];

  columnTypes = {
    rightAligned: {
      headerClass: 'ag-right-aligned-header',
      cellClass: 'ag-right-aligned-cell'
    }
  };

  constructor(private fb: FormBuilder, private modalController: ModalController, private toastService: ToastService, private countryService: CountryService,) {
    this.LiquidacionForm = this.fb.group({
      fechaDesembolso: new Date().toLocaleDateString('es-PE'),
      codigo: '',
      tipoBeneficiario: '',
      tipoDocumento: '',
      documentoBeneficiario: '',
      nombreBeneficiario: '',
      tipoGasto: '',
      centroCosto: '',
      montoAdelantado: '',
      tipoCambio: '',
      totalGastado: '',
      saldoDevolver: '',
      saldoRegularizar: '',
      montoGastado: '',
      moneda: '',
      // responsable: 'Carlos Zapata',
      estado: '',
      observaciones: '',
      proveedor: ''
    });

    // Deshabilitar todos los campos
    Object.keys(this.LiquidacionForm.controls).forEach(key => {
      this.LiquidacionForm.get(key)?.disable();
    });

    effect(() => {
      const data = this.facade.liquidaciones();
      this.rowData = data.filter(r => r.lr_estado === 'Pendiente');
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
      // Si la fila seleccionada ya no está entre los pendientes, limpiar selección y formulario
      if (
        this.filaSeleccionada &&
        !this.rowData.some(r => r.lr_num_liquidacion === this.filaSeleccionada?.lr_num_liquidacion)
      ) {
        this.filaSeleccionada = null;
        this.cantidadSeleccionadas = 0;
        this.accionesDisabled = false;
        this.LiquidacionForm.reset();
        if (this.gridApi) {
          this.gridApi.deselectAll();
        }
      }
    });
  }

  ngOnInit() {
    this.facade.cargarDatos();
    //Labels de formulario: Tipo de cambio por ahora
    this.configurarLabelsPorPais();
  }

  /** Ionic cachea la página; recarga la bandeja en CADA entrada para reflejar
   *  las liquidaciones recién creadas/cerradas/anuladas. */
  ionViewWillEnter(): void {
    this.facade.cargarDatos();
  }

  configurarLabelsPorPais() {
    if (this.pais === 'EC') {
      this.mostrarTipoCambio = false; // Ocultar tipo de cambio en Ecuador
    }
  }

  onGridReady(params: GridReadyEvent): void {
    this.gridApi = params.api;
    if (this.rowData.length > 0) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }
  isRowSelectable(params: any): boolean {
    // Solo permitir seleccionar filas en estado "Pendiente"
    return params.data && params.data.lr_estado === 'Pendiente';
  }

  onCellClicked(event: any): void {
    // Si el click fue en la columna de checkbox, no interferir con la selección múltiple
    if (event.colDef.checkboxSelection) {
      return;
    }
    const data = event.data;
    this.gridApi.deselectAll();
    event.node.setSelected(true);
  }

  onSelectionChanged(event: any): void {
    const selectedNodes = this.gridApi.getSelectedNodes();

    // Actualizar la propiedad seleccionado en cada fila
    this.rowData.forEach(row => {
      row.lr_seleccionado = selectedNodes.some(node => node.data?.lr_num_liquidacion === row.lr_num_liquidacion);
    });

    this.cantidadSeleccionadas = this.rowData.filter(r => r.lr_seleccionado).length;

    // Si hay una fila seleccionada, cargar sus datos en el formulario
    if (selectedNodes.length > 0) {
      const data = selectedNodes[0].data;
      this.filaSeleccionada = data;

      this.LiquidacionForm.patchValue({
        codigo: data.lr_num_liquidacion,
        fechaDesembolso: data.lr_fecha_desembolso,
        nombreBeneficiario: data.lr_beneficiario,
        tipoGasto: data.lr_tipo_gasto,
        centroCosto: data.lr_centro_costo,
        montoAdelantado: data.lr_monto_adelantado,
        montoGastado: data.lr_monto_gastado,
        moneda: data.lr_moneda || 'Soles',
        estado: data.lr_estado || '',
        tipoCambio: '3.85',
        totalGastado: typeof data.lr_monto_gastado === 'number' ? data.lr_monto_gastado.toFixed(2) : '',
        saldoRegularizar: data.lr_monto_gastado > data.lr_monto_adelantado ? (data.lr_monto_gastado - data.lr_monto_adelantado).toFixed(2) : '',
        saldoDevolver: data.lr_monto_adelantado > data.lr_monto_gastado ? (data.lr_monto_adelantado - data.lr_monto_gastado).toFixed(2) : '',
        observaciones: data.observaciones || '',
        tipoBeneficiario: data.tipoBeneficiario === 'proveedor' ? 'Proveedor' : 'Colaborador',
      });

      // Deshabilitar botones si la liquidación ya está Cerrada o Anulada (estados terminales).
      this.accionesDisabled = ['Cerrada', 'Anulada'].includes(data.lr_estado);
    }
  }

  onBtReset(): void {
    this.startDate = new Date();
    this.endDate = new Date();
  }

  filtrarPorFechas(event: any): void {
    if (event && event.startDate && event.endDate) {
      this.startDate = event.startDate;
      this.endDate = event.endDate;
    }
  }

  onGridReadyGastos(params: GridReadyEvent): void {
    this.gridApiGastos = params.api;
    if ((this.gridApiGastos as any)?.setRowData) {
      try { (this.gridApiGastos as any).setRowData(this.rowDataGastos); } catch (e) { /* ignore */ }
    }
  }

  onCellClickedGasto(event: any): void {
    // Acción al hacer click en celda de gastos
  }

  togglePanelLateral(): void {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  calcularTotalGastos(): number {
    return this.rowDataGastos.reduce((sum, gasto) => sum + (parseFloat(gasto.monto) || 0), 0);
  }

  async botonConfirmarRechazar() {
    if(!this.filaSeleccionada){
      this.toastService.warning('Por favor selecciona una fila para rechazar la liquidación.');
      return;
    }
    
    const detalles = [
      { label: 'Beneficiario', value: this.filaSeleccionada?.lr_beneficiario || '' },
      { label: 'F. de desembolso', value: this.filaSeleccionada?.lr_fecha_desembolso || '' },
      { label: 'Monto adelanto', value: this.filaSeleccionada ? `S/${(this.filaSeleccionada.lr_monto_adelantado || 0).toFixed(2)}` : '' },
      { label: 'Tipo de gasto', value: this.filaSeleccionada?.lr_tipo_gasto || '' },
      { label: 'Total gastado', value: this.filaSeleccionada ? `S/${(this.filaSeleccionada.lr_monto_gastado || 0).toFixed(2)}` : '' }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      componentProps: {
        tituloModal: `Rechazar liquidación de rendición de gastos ${this.filaSeleccionada?.lr_num_liquidacion}`,
        subtitulomodal: 'Detalle de la liquidación',
        detalles: detalles,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo del rechazo:',
        placeholderTextarea: 'Describe el motivo del rechazo o las observaciones.',
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Rechazar',
        textoBotonCancelar: 'Cancelar',
        colorBotonConfirmar: 'danger',
        motivoObligatorio: true
      },
      cssClass: 'promo',
    });

    await modal.present();

    const { data } = await modal.onDidDismiss();

    if (data && data.action === 'confirmar') {
      this.botonRechazar();
      console.log('Motivo de rechazo:', data.motivo);
    }
  }

  async botonConfirmarObservar() {
    if(!this.filaSeleccionada){
      this.toastService.warning('Por favor selecciona una fila para observar la liquidación.');
      return;
    }

    const detalles = [
      { label: 'Beneficiario', value: this.filaSeleccionada?.lr_beneficiario || '' },
      { label: 'F. de desembolso', value: this.filaSeleccionada?.lr_fecha_desembolso || '' },
      { label: 'Monto adelanto', value: this.filaSeleccionada ? `S/${(this.filaSeleccionada.lr_monto_adelantado || 0).toFixed(2)}` : '' },
      { label: 'Tipo de gasto', value: this.filaSeleccionada?.lr_tipo_gasto || '' },
      { label: 'Total gastado', value: this.filaSeleccionada ? `S/${(this.filaSeleccionada.lr_monto_gastado || 0).toFixed(2)}` : '' }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      componentProps: {
        tituloModal: `Observar liquidación de rendición de gastos ${this.filaSeleccionada?.lr_num_liquidacion}`,
        subtitulomodal: 'Detalle de la liquidación',
        detalles: detalles,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo de la observación:',
        placeholderTextarea: 'Describe el motivo de la observación o los cambios necesarios.',
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Observar',
        textoBotonCancelar: 'Cancelar',
        colorBotonConfirmar: 'primary',
        motivoObligatorio: true
      },
      cssClass: 'promo',
    });

    await modal.present();

    const { data } = await modal.onDidDismiss();

    if (data && data.action === 'confirmar') {
      this.botonObservar();
      console.log('Motivo de observación:', data.motivo);
    }
  }

  /** "Rechazar" se mapea a la única acción real de descarte del backend: ANULAR (1→0). */
  botonRechazar(): void {
    if (this.filaSeleccionada) {
      this.facade.actualizar({ ...this.filaSeleccionada, lr_estado: 'Anulada' }, '¡Liquidación anulada exitosamente!');
      this.LiquidacionForm.patchValue({ estado: 'Anulada' });
      this.accionesDisabled = true;
      setTimeout(() => this.facade.cargarDatos(), 300);
    }
  }

  // SOBRA: "Observar" NO existe en el backend de liquidaciones → acción deshabilitada (no se borra).
  botonObservar(): void {
    this.toastService.warning('Observar no está disponible: el backend de liquidaciones no lo soporta.');
    // this.facade.actualizar({ ...this.filaSeleccionada, lr_estado: 'Observada' }, '¡Liquidación observada exitosamente!');
    // this.LiquidacionForm.patchValue({ estado: 'Observada' });
  }

  async botonConfirmar() {
    if (!this.filaSeleccionada?.id) {
      this.toastService.warning('Por favor selecciona una fila para aprobar la liquidación.');
      return;
    }
    // HU-21: la aprobación (cierre) va precedida de la validación de cierre.
    this.facade.validarCierre(this.filaSeleccionada.id).subscribe({
      next: (v) => this.mostrarModalAprobacion(v),
      error: (e) => this.toastService.danger(e?.message || 'No se pudo validar el cierre de la liquidación.'),
    });
  }

  /** Muestra el resultado de la validación de cierre y, si procede, permite aprobar/cerrar. */
  private async mostrarModalAprobacion(v: ValidacionCierre): Promise<void> {
    const fmt = (n?: number) => `S/ ${Number(n ?? 0).toFixed(2)}`;
    const detalles = [
      { label: 'Número de liquidación', value: this.filaSeleccionada?.lr_num_liquidacion || '' },
      { label: 'Solicitud de giro', value: v.solicitudGiroNumero || (v.solicitudGiroId != null ? String(v.solicitudGiroId) : '-') },
      { label: 'Importe neto', value: fmt(v.importeNeto) },
      { label: 'Suma de detalles', value: fmt(v.sumaDetalles) },
      { label: '¿Cuadra?', value: v.cuadrado ? 'Sí' : 'No' },
      { label: '¿Puede cerrar?', value: v.puedeCerrar ? 'Sí' : 'No' },
    ];

    if (!v.puedeCerrar) {
      this.toastService.warning('La liquidación no puede cerrarse: el importe neto no cuadra con la suma de detalles.');
    }

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      componentProps: {
        tituloModal: 'Cerrar liquidación',
        subtitulomodal: 'Validación de cierre',
        detalles: detalles,
        mostrarTextarea: false,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Cerrar',
        textoBotonCancelar: 'Cancelar',
        colorBotonConfirmar: 'primary',
        // Si el backend dice que no puede cerrar, se oculta el botón de confirmar.
        ocultarBotonConfirmar: !v.puedeCerrar,
      },
      cssClass: 'promo',
    });

    await modal.present();
    const { data } = await modal.onDidDismiss();
    if (data && data.action === 'confirmar') {
      this.botonAprobar();
    }
  }

  /** "Aprobar" se mapea a la única acción real de finalización del backend: CERRAR (1→2). */
  botonAprobar(): void {
    if (this.filaSeleccionada) {
      this.facade.actualizar({ ...this.filaSeleccionada, lr_estado: 'Cerrada' }, '¡Liquidación cerrada exitosamente!');
      this.LiquidacionForm.patchValue({ estado: 'Cerrada' });
      this.accionesDisabled = true;
      setTimeout(() => this.facade.cargarDatos(), 300);
    }
  }

  async botonConfirmarMasivamente(): Promise<void> {
    const filasSeleccionadas = this.rowData.filter(
      (row) => row.lr_seleccionado === true && row.lr_estado === 'Pendiente'
    );

    if (filasSeleccionadas.length === 0) {
      this.toastService.warning(
        'Por favor selecciona al menos una liquidación en estado Pendiente para aprobar'
      );
      return;
    }

    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Confirmar aprobación masiva',
        title: `Confirmar aprobación de ${filasSeleccionadas.length} liquidación(es)`,
        message:
          'Por favor, revisa los detalles antes de proceder. Una vez aprobadas, no podrás modificar ni deshacer esta acción',
        btnOkTxt: 'Confirmar',
        btnCancelTxt: 'Cancelar',
      },
    });

    await modal.present();
    const { data } = await modal.onDidDismiss();

    if (data === true) {
      this.aprobarMultiplesLiquidaciones(filasSeleccionadas);
    }
  }

  private aprobarMultiplesLiquidaciones(filasSeleccionadas: LiqRendicionEntity[]): void {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    const fechaAprobacion = `${year}-${month}-${day}`;

    filasSeleccionadas.forEach((fila) => {
      this.facade.actualizar({
        ...fila,
        lr_estado: 'Cerrada', // acción real del backend (cerrar). 'Aprobada' no existe.
        lr_fecha_aprobacion: fechaAprobacion,
        lr_seleccionado: false,
      }, '¡Liquidación cerrada exitosamente!');
    });

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    setTimeout(() => this.facade.cargarDatos(), 300);

    this.filaSeleccionada = null;
    this.cantidadSeleccionadas = 0;
    this.accionesDisabled = false;
  }

  async modalverActualizaciones(): Promise<void> {
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
      { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Registro inicial de la liquidación'},
      { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Cambio de estado de "Borrador" a "Pendiente"'},
      { fechaHora: '13/11/2025 09:00', usuario: 'Carlos Rodríguez', accion: 'Actualización', detalleCambio: 'Agregó documentación de respaldo (3 archivos)'},
      { fechaHora: '13/11/2025 16:45', usuario: 'Ana Martínez', accion: 'Actualización', detalleCambio: 'Cambio de estado de "Pendiente" a "Aprobada"' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones de la Liquidación ' + (this.filaSeleccionada?.lr_num_liquidacion || ''),
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }
}
