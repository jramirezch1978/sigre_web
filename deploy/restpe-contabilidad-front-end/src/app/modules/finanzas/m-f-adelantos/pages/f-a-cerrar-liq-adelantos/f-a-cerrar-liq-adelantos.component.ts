import { Component, OnInit, inject, computed, effect } from '@angular/core';
import { FormGroup, FormBuilder } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalVerActualizacionesComponent } from '../../../../../ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalDetalleComponent } from '../../../../../ui/modal-detalle/modal-detalle.component';
import { BotonAccionesComponent } from 'src/app/ui/boton-acciones/boton-acciones.component';
import { DetalleItem } from 'src/app/ui/modal-registrar-ingresos/modal-registrar-ingresos.component';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { CerrarLiqAdelantosFacade } from 'src/app/modules/finanzas/application/facades/cerrar-liq-adelantos.facade';
import { CerrarLiqAdelantosEntity } from 'src/app/modules/finanzas/domain/models/cerrar-liq-adelantos.entity';
import { ValidacionCierre } from 'src/app/modules/finanzas/domain/repositories/icerrar-liq-adelantos.repository';
import { CerrarLiqAdelantosSyncEffects } from 'src/app/modules/finanzas/effects/cerrar-liq-adelantos-sync.effect';
import { CerrarLiqAdelantosFeedbackEffects } from 'src/app/modules/finanzas/effects/cerrar-liq-adelantos-feedback.effect';

// Font Awesome Icons
import { faBook, faSearch as faSearchRegular } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faDownload, faRotateRight, faSearch as faSearchSolid } from '@fortawesome/pro-solid-svg-icons';

// Font Awesome Icons

@Component({
  selector: 'app-f-a-cerrar-liq-adelantos',
  templateUrl: './f-a-cerrar-liq-adelantos.component.html',
  styleUrls: ['./f-a-cerrar-liq-adelantos.component.scss'],
  standalone: false
})
export class FACerrarLiqAdelantosComponent implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearchRegular;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;
  fasSearch = faSearchSolid;



  
  //Tipo de cambio para ecuador

  pais = this.countryService.getCountryCode();
  mostrarTipoCambio: boolean = true;


  // Facade
  readonly facade = inject(CerrarLiqAdelantosFacade);
  readonly loaderActivo = computed(() => this.facade.isLoading());
  // EFFECTS (inyectar para que los constructores registren los effect())
  private readonly _syncEffects = inject(CerrarLiqAdelantosSyncEffects);
  private readonly _feedbackEffects = inject(CerrarLiqAdelantosFeedbackEffects);

  // ESTADO DEL COMPONENTE
  LiquidacionForm!: FormGroup;
  filaSeleccionada: CerrarLiqAdelantosEntity | null = null;
  mostrarBuscadorPrincipal = true;
  panelLateralVisible = true;
  revertirDeshabilitado = true;
  cerrarDeshabilitado = false;
  /** Catálogo de monedas (id→nombre) para resolver la columna Moneda. */
  monedas: { id: number; nombre: string }[] = [];
  context: any;
  // FECHAS
  startDate: Date = new Date();
  endDate: Date = new Date();
  minDate: Date = new Date('2025-01-01');
  maxDate: Date = new Date();

  // LOCALES
  localeText: any = {
    page: 'Página',
    more: 'Más',
    to: 'a',
    of: 'de',
    next: 'Siguiente',
    last: 'Última',
    first: 'Primera',
    previous: 'Anterior',
  };

  // GRID
  private gridApi!: GridApi;
   frameworkComponents = {
      BotonAccionesComponent: BotonAccionesComponent,
      VistaCellRenderComponent: VistaCellRenderComponent
    };

  gridOptions = {
    context: {
      componentParent: this,
    },
    suppressRowClickSelection: false,
    rowSelection: 'single'
  };

  // DEFINICIÓN DE COLUMNAS
  colDefs: ColDef[] = [
    {
      field: 'cla_num_liquidacion',
      headerName: 'N° liquidación',
      width: 120,
    },
    {
      field: 'cla_fecha_aprobacion',
      headerName: 'Fecha aprobación',
      width: 140,
    },
    /* SOBRA: el backend (GET /liquidaciones) no entrega estos campos → columnas comentadas, no borradas.
    {
      field: 'cla_fecha_cierre',
      headerName: 'Fecha cierre',
      width: 120,
    },
    {
      field: 'cla_tipo_beneficiario',
      headerName: 'Tipo de beneficiario',
      width: 160,
      filter: true,
    },
    */
    /* SOBRA: la creación (#3) no captura proveedor → Beneficiario quedaría vacío. Comentado, no borrado.
    {
      field: 'cla_beneficiario',
      headerName: 'Beneficiario',
      width: 160,
      filter: true,
      valueFormatter: (p: any) => p.value || '—',
    },
    */
    {
      field: 'cla_moneda',
      headerName: 'Moneda',
      width: 100,
      filter: true,
      // El backend no rellena monedaCodigo → resolvemos el nombre por id con el catálogo.
      valueGetter: (p: any) => this.monedas.find(m => m.id === p.data?.cla_moneda_id)?.nombre ?? (p.data?.cla_moneda || '—'),
    },
    {
      field: 'cla_monto_adelantado',
      headerName: 'Monto adelanto',
      width: 130,
      headerClass: 'derechaencabezado',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Determinar símbolo de moneda
          const moneda = params.data?.moneda || 'Soles';
          const simbolo = moneda === 'Dólares' ? '$' : 'S/';
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `${simbolo}(${formattedValue})`;
          }
          return `${simbolo}${formattedValue}`;
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
  
    {
      field: 'cla_total_gastado',
      headerName: 'Total gastado',
      width: 100,
      headerClass: 'derechaencabezado',
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
      },
      cellRendererSelector: (params: any) => {
        // Si el estado es "Aprobada", usar el componente personalizado
        if (params.data?.estado === 'Cerrada') {
          return {
            component: VistaCellRenderComponent,
          };
        }
        // Para otros estados, usar el renderer por defecto
        return undefined;
      },
    
    },
    /* SOBRA: el backend no entrega responsable ni centro de costo en el listado → comentado, no borrado.
    {
      field: 'cla_responsable',
      headerName: 'Responsable',
      flex:1, minWidth: 150,
    },
    {
      field: 'cla_centro_costo',
      headerName: 'Centro de costo',
      flex:1, minWidth: 150,
      filter: true,
    },
    */
    {
      field: 'cla_observaciones',
      headerName: 'Observación',
      flex: 1, minWidth: 180,
      filter: true,
      valueFormatter: (p: any) => p.value || '—',
    },

    {
      headerClass: 'centrarencabezado',
      field: 'cla_estado',
      headerName: 'Estado',
      width: 100,
      filter: true,
      cellRenderer: (params: any) => {
        // Estados reales de liquidación: Pendiente(1) / Cerrada(2) / Anulada(0).
        if (params.value === 'Pendiente') {
          return `<span class="badge-table bg-[#F5F5F5] text-[#1F1F1F]">Pendiente</span>`;
        } else if (params.value === 'Cerrada') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Cerrada</span>`;
        } else if (params.value === 'Anulada') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulada</span>`;
        }
        // SOBRA: 'Revertida' no existe en el backend (no hay endpoint de reversión).
        return params.value;
      },
      cellStyle: {
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center'
      }
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
    { codigo: 'GAST001', descripcion: 'Combustible para viaje Piura – Chiclayo', monto: 250.00, fechaGasto: '15/12/2025', tipoDocumento: 'Boleta', serieDocumento: 'B001-567821', proveedor: 'Grifo Primax – Piura', moneda: 'Soles' },
    { codigo: 'GAST002', descripcion: 'Estadía por una noche durante comisión de servicio', monto: 220.00, fechaGasto: '15/12/2025', tipoDocumento: 'Boleta', serieDocumento: 'B001-009234', proveedor: 'Hotel Costa del Sol – Chiclayo', moneda: 'Soles' },
    { codigo: 'GAST003', descripcion: 'Cena durante comisión de servicio', monto: 130.00, fechaGasto: '15/12/2025', tipoDocumento: 'Boleta', serieDocumento: 'B001-778211', proveedor: 'Restaurante El Rincón del Norte', moneda: 'Soles' },
  ];

  colDefsGastos: ColDef[] = [
    { 
      field: 'fechaGasto', 
      headerName: 'Fecha del gasto', 
      width: 120,
    },
    { 
      field: 'descripcion', 
      headerName: 'Descripción', 
      flex:1, minWidth: 200,
    },
    { 
      field: 'tipoDocumento', 
      headerName: 'Tipo de documento', 
      width: 150,
    },
    { 
      field: 'serieDocumento', 
      headerName: 'Serie y n° de documento', 
      width: 180,
    },
    { 
      field: 'proveedor', 
      headerName: 'Proveedor', 
      width: 200,
    },
    { 
      field: 'moneda', 
      headerName: 'Moneda', 
      width: 90,
    },
    { 
      field: 'monto', 
      headerName: 'Monto', 
      width: 100,
      type: 'rightAligned',
      headerClass: 'derechaencabezado',
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
    {
      field: 'acciones',
      headerName: 'Acciones',
      headerClass: 'centrarencabezado',
      width: 90,
      cellRenderer: BotonAccionesComponent,
      cellStyle: (params) => {
        const style: any = { justifyContent: 'center', };
        return style;
      }
    },
  ];

  private gridApiGastos!: GridApi;
  
  rowData: CerrarLiqAdelantosEntity[] = [];

  columnTypes = {
    rightAligned: {
      headerClass: 'ag-right-aligned-header',
      cellClass: 'ag-right-aligned-cell'
    }
  };
  
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  constructor(private fb: FormBuilder, private modalController: ModalController, private toastService: ToastService, private countryService: CountryService) {
    this.LiquidacionForm = this.fb.group({
      fechaDesembolso: new Date().toLocaleDateString('es-PE'),
      fechaCierre: '',
      numLiquidacion: '',
      tipoBeneficiario: '',
      tipoDocumento: '',
      documentoBeneficiario: '',
      nombreBeneficiario: '',
      tipoGasto: '',
      centroCosto: '',
      montoAdelantado: '',
      tipoCambio: '3.85',
      totalGastado: '',
      saldoDevolver: '',
      saldoRegularizar: '',
      montoGastado: '',
      moneda: 'Soles',
      responsable: 'Carlos Zapata',
      estado: 'Pendiente',
      observaciones: '',
      proveedor: ''
    });
    

    // Deshabilitar todos los campos
    Object.keys(this.LiquidacionForm.controls).forEach(key => {
      this.LiquidacionForm.get(key)?.disable();
    });

    // Pre-llenar filaSeleccionada
    this.filaSeleccionada = null;
    this.context = { componentParent: this };

    effect(() => {
      const data = this.facade.liquidaciones();
      this.rowData = data;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });
  }

  ngOnInit() {
    this.facade.cargarDatos();
    this.cargarMonedas();
    //Labels de formulario: Tipo de cambio por ahora
    this.configurarLabelsPorPais();
  }

  /** Ionic cachea la página; recarga la bandeja en CADA entrada para reflejar
   *  las liquidaciones recién cerradas/anuladas. */
  ionViewWillEnter(): void {
    this.facade.cargarDatos();
    this.cargarMonedas();
  }

  /** Catálogo de monedas para resolver el nombre por id en la columna Moneda. */
  private cargarMonedas(): void {
    this.facade.listarMonedas().subscribe({
      next: (m) => { this.monedas = m; this.gridApi?.refreshCells({ force: true }); },
      error: () => (this.monedas = []),
    });
  }

   configurarLabelsPorPais() {
  if(this.pais === 'EC') {
    this.mostrarTipoCambio = false; // Ocultar tipo de cambio en Ecuador
  }
}


  onGridReady(params: GridReadyEvent): void {
    this.gridApi = params.api;
    if (this.rowData.length > 0) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
    if (this.filaSeleccionada) {
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node: any) => {
            if (node.data && node.data.cla_num_liquidacion === this.filaSeleccionada?.cla_num_liquidacion) {
              node.setSelected(true);
              this.gridApi.ensureNodeVisible(node, 'middle');
            }
          });
        }
      }, 150);
    }
  }

  onCellClicked(event: any): void {
    const data = event.data;
    this.gridApi.deselectAll();
    event.node.setSelected(true);
  }

  onSelectionChanged(event: any): void {
    const selectedNodes = this.gridApi.getSelectedNodes();
    
    // Actualizar la propiedad seleccionado en cada fila
    this.rowData.forEach(row => {
      row.cla_seleccionado = selectedNodes.some(node => node.data?.cla_num_liquidacion === row.cla_num_liquidacion);
    });

    // Si hay una fila seleccionada, cargar sus datos en el formulario; si no, ocultar el formulario
    if (selectedNodes.length > 0) {
      const data = selectedNodes[0].data;
      this.filaSeleccionada = data;
      // Habilitar/deshabilitar botones según el estado
      const estado = data.cla_estado;
      this.cerrarDeshabilitado = estado === 'Cerrada';
      this.revertirDeshabilitado = estado !== 'Pendiente';
      const diff = data.cla_monto_adelantado - data.cla_monto_gastado;
      this.LiquidacionForm.patchValue({
        numLiquidacion: data.cla_num_liquidacion,
        fechaDesembolso: data.cla_fecha_desembolso,
        fechaCierre: data.cla_fecha_cierre || '',
        tipoBeneficiario: data.cla_tipo_beneficiario,
        tipoDocumento: data.cla_tipo_documento,
        documentoBeneficiario: data.cla_documento_beneficiario,
        nombreBeneficiario: data.cla_beneficiario,
        tipoGasto: data.cla_tipo_gasto,
        centroCosto: data.cla_centro_costo,
        montoAdelantado: data.cla_monto_adelantado,
        montoGastado: data.cla_monto_gastado,
        moneda: data.cla_moneda,
        responsable: data.cla_responsable,
        estado: data.cla_estado,
        totalGastado: data.cla_monto_gastado.toFixed(2),
        saldoDevolver: diff > 0 ? diff.toFixed(2) : '0.00',
        saldoRegularizar: diff < 0 ? Math.abs(diff).toFixed(2) : '0.00',
        observaciones: data.cla_observaciones,
        proveedor: data.cla_tipo_beneficiario === 'Proveedor' ? data.cla_proveedor : '',
      });
    } else {
      this.filaSeleccionada = null;
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
    this.gridApiGastos.setGridOption('rowData', this.rowDataGastos);
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

  botonConfirmarCerrar() {
    if (!this.filaSeleccionada?.id) {
      this.toastService.warning('Selecciona una liquidación para cerrar.');
      return;
    }
    // HU-22: el cierre va precedido de la validación de cierre.
    this.facade.validarCierre(this.filaSeleccionada.id).subscribe({
      next: (v) => this.mostrarModalCierre(v),
      error: (e) => this.toastService.danger(e?.message || 'No se pudo validar el cierre de la liquidación.'),
    });
  }

  /** Muestra el resultado de la validación de cierre y, si procede, cierra la liquidación. */
  private async mostrarModalCierre(v: ValidacionCierre): Promise<void> {
    const fmt = (n?: number) => `S/ ${Number(n ?? 0).toFixed(2)}`;
    const detalles = [
      { label: 'Número de liquidación', value: this.filaSeleccionada?.cla_num_liquidacion || '' },
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
        tituloModal: `Cerrar liquidación ${this.filaSeleccionada?.cla_num_liquidacion}`,
        subtitulomodal: 'Validación de cierre',
        detalles: detalles,
        mostrarTextarea: false,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Cerrar liquidación',
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
      this.botonCerrar();
    }
  }

  async botonConfirmarRevertir() {
    const detalles = [
      { label: 'Beneficiario', value: this.filaSeleccionada?.cla_beneficiario || '' },
      { label: 'Total gastado', value: `${this.filaSeleccionada?.cla_moneda === 'Soles' ? 'S/' : '$'}${this.filaSeleccionada?.cla_total_gastado?.toFixed(2) || '0.00'}` },
      { label: 'Orden de compra', value: 'OC-2025-000002' },
      { label: 'F. de emisión', value: this.filaSeleccionada?.cla_fecha_aprobacion || '' },
      { label: 'Monto adelanto', value: `${this.filaSeleccionada?.cla_moneda === 'Soles' ? 'S/' : '$'}${this.filaSeleccionada?.cla_monto_adelantado?.toFixed(2) || '0.00'}` },
      { label: 'F. de cierre', value: this.filaSeleccionada?.cla_fecha_cierre || new Date().toLocaleDateString('es-PE') }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      componentProps: {
        tituloModal: `Revertir cierre de liquidación ${this.filaSeleccionada?.cla_num_liquidacion}`,
        subtitulomodal: 'Detalle de la liquidación',
        detalles: detalles,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo del reverso:',
        placeholderTextarea: 'Describe el motivo del reverso de la liquidación',
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Revertir',
        textoBotonCancelar: 'Cancelar',
        colorBotonConfirmar: 'primary',
        motivoObligatorio: true
      },
      cssClass: 'promo',
    });

    await modal.present();

    const { data } = await modal.onDidDismiss();

    if (data && data.action === 'confirmar') {
      this.botonRevertir();
      console.log('Motivo de reversión:', data.motivo);
    }
  }

  botonCerrar(): void {
    if (this.filaSeleccionada) {
      const fechaCierre = new Date().toLocaleDateString('es-PE');
      this.facade.actualizar({ ...this.filaSeleccionada, cla_estado: 'Cerrada', cla_fecha_cierre: fechaCierre }, '¡Liquidación cerrada exitosamente!');
      this.LiquidacionForm.patchValue({ estado: 'Cerrada', fechaCierre });
      this.cerrarDeshabilitado = true;
      this.revertirDeshabilitado = true;
      setTimeout(() => this.facade.cargarDatos(), 300);
    }
  }

  // SOBRA: "Revertir cierre" NO tiene endpoint en el backend de liquidaciones → deshabilitado (no se borra).
  botonRevertir(): void {
    this.toastService.warning('Revertir cierre no está disponible: el backend de liquidaciones no lo soporta.');
    // if (this.filaSeleccionada) {
    //   this.facade.actualizar({ ...this.filaSeleccionada, cla_estado: 'Revertida' }, '¡Liquidación revertida exitosamente!');
    //   this.LiquidacionForm.patchValue({ estado: 'Revertida' });
    //   this.revertirDeshabilitado = true;
    // }
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
      { fechaHora: '13/11/2025 16:45', usuario: 'Ana Martínez', accion: 'Actualización', detalleCambio: 'Cambio de estado de "Pendiente" a "Cerrada"' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones de la Liquidación ' + (this.filaSeleccionada?.cla_num_liquidacion || ''),
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }
  
  // Método para compatibilidad con VistaMonedaCellRenderComponent
  async abrirModal(value: any, rowData: any) {
    // Generar un número de asiento basado en los datos
    const numeroAsiento = `AS-2025-${rowData.cla_num_liquidacion?.split('-')[2] || '001'}`;
    await this.abrirModalAsiento(numeroAsiento, rowData);
  }

  async abrirModalAsiento(numeroAsiento: string, rowData: any) {
        const detalleAsiento: DetalleItem[] = [
          { label: 'Fecha de registro', value: '15/11/2025' },
          { label: 'Fecha contable', value: '15/11/2025' },
          { label: 'Glosa', value: 'Liquidación de gastos por comisión de servicio, en el que el colaborador usó auto propio para trasladarse de Piura a Chiclayo. ' },
          { label: 'Total', value: 'S/600.00' }
        ];
    
        const asientoData = [
          {
            cuentaContable: '101101',
            descripcion: rowData.cuentaIngreso,
            debe: rowData.montoTotal,
            haber: '-',
            tercero:'Grifo Primax - Piura'
          },
          {
            cuentaContable: '701101',
            descripcion: 'Ventas - Salón',
            debe: '-',
            haber: '',
            tercero:'Grifo Primax - Piura'
          }
        ];
    
        const colDefsAsiento: ColDef[] = [
          { field: 'cuentaContable', headerName: 'Cuenta contable', width: 130 },
          { field: 'descripcion', headerName: 'Descripción', flex: 1, minWidth: 150 },
          {
            field: 'debe',
            headerName: 'Debe (S/)',
            width: 100,
            headerClass: 'centrarencabezado',
            cellStyle: { textAlign: 'right' }
          },
          {
            field: 'haber',
            headerName: 'Haber (S/)',
            width: 100,
            headerClass: 'centrarencabezado',
            cellStyle: { textAlign: 'right' }
          },
          {
            field: 'tercero',
            headerName: 'Tercero',
            width: 100,
          }
        ];
    
        const modal = await this.modalController.create({
          component: ModalDetalleComponent,
          cssClass: 'promo',
          componentProps: {
            tituloModal: `Información del asiento contable ${numeroAsiento}`,
            subtitulomodal: '',
            detalles: detalleAsiento,
            mostrarTextarea: false,
            mostrarBotonEliminar: false,
            textoBotonCancelar: 'Cerrar',
            mostrarTabla: true,
            colDefs: colDefsAsiento,
            rowData: asientoData
          }
        });
    
        await modal.present();
      }
}
