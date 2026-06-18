import { ChangeDetectorRef, Component, ElementRef, OnInit, OnDestroy, ViewChild, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ColDef, GridApi } from 'ag-grid-community';
import { AccesorioActionsCellComponent } from '../af-o-asignacionratios/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { AutocompleteComponent } from 'src/app/ui/autocomplete/autocomplete.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { faCircleXmark, faSearch as faSearchRegular } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faAngleRight, faChevronLeft, faChevronRight, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight, faSearch as faSearchSolid } from '@fortawesome/pro-solid-svg-icons';
import { VentaActivoFacade } from '../../../application/facades/venta-activo.facade';
import { ActivoFijoFacade } from '@modules/activos/application/facades/activo-fijo.facade';


@Component({
  selector: 'app-af-o-ventas-activos',
  templateUrl: './af-o-ventas-activos.component.html',
  styleUrls: ['./af-o-ventas-activos.component.scss'],
  standalone:false,
})
export class AfOVentasActivosComponent  implements OnInit, OnDestroy {
  // Font Awesome Icons
  farCircleXmark = faCircleXmark;
  farSearch = faSearchRegular;
  fasAngleDown = faAngleDown;
  fasAngleRight = faAngleRight;
  fasChevronLeft = faChevronLeft;
  fasChevronRight = faChevronRight;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;
  fasSearch = faSearchSolid;

  @ViewChild('scrollBox', { read: ElementRef }) scrollBox!: ElementRef;
  @ViewChild('activoAC') activoAC!: AutocompleteComponent;

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  tabSeleccionadoDetalle='tipo';
  panelLateralVisible: boolean = true;
  filaSeleccionada: any = null;
  fechaSolicitud: any;
  anularinhabilitado: boolean = true;
  private gridApi!: GridApi;
  selectedRowData: any = null;

  documentoRespaldo: string = '';
  formularioBaja: FormGroup;
  
  // Navigation control - tabs only enabled after explicit navigation
  seleccionTabEnabled: boolean = false;
  resumenTabEnabled: boolean = false;
  
  // View mode control
  isViewingExistingRecord: boolean = false;
  
  // Additional properties
  activoSeleccionado: any = null;
  activoSeleccionadoResumen: any = null;
  tipoDebajaSeleccionado: string = '';
  monedaSeleccionada: string = '';

  motivo=[
    {value: 'tecnologica', label: 'Tecnológica'},
    {value: 'dañado', label: 'Dañado'},
    {value: 'finvidautil', label: 'Fin vida útil'},
    {value: 'bajorendimiento', label: 'Bajo rendimiento'},
  ]
  tipodesiniestro=[
    {value: 'robo', label: 'Robo'},
    {value: 'incendio', label: 'Incendio'},
    {value: 'inundación', label: 'Inundación'},
    {value: 'accidente', label: 'Accidente'},
    {value: 'otro', label: 'Otro'},
  ]
  tipodoc=[
    {value: 'factura', label: 'Factura'},
    {value: 'boleta', label: 'Boleta'},
    {value: 'contrato', label: 'Contrato'},
    {value: 'otro', label: 'Otro'},
  ]
  colDefs: ColDef[] = [
    { field: 'venta_activo_codigo_baja', headerName: 'Cód. de baja', flex: 1, minWidth: 120 },
    { field: 'venta_activo_tipo_debaja', headerName: 'Tipo de baja', flex: 1.2, minWidth: 130 },
    { field: 'venta_activo_fecha_baja', headerName: 'Fecha de baja', flex: 1, minWidth: 110 },
    { headerName: 'Nº de activos fijos', flex: 1.3, minWidth: 140,
      valueGetter: (params) => {
        const activos = params.data?.venta_activo_activos;
        return activos ? activos.length : 0;
      },
     },
    { field: 'venta_activo_valor_neto_contable', headerName: 'Valor neto contable', flex: 1.3, minWidth: 150, headerClass: 'derechaencabezado', cellStyle: { display: 'flex', justifyContent: 'end', alignItems: 'center' }, 
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', { 
          style: 'currency', 
          currency: 'PEN',
          minimumFractionDigits: 2 
        }).format(params.value) : 'S/ 0.00';
      }
    },
    {
      headerClass: 'centrarencabezado',
      field: 'venta_activo_estado', 
      filter:true,
      headerName: 'Estado', 
      flex: 1, 
      minWidth: 80,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        
        switch(estado) {
          case 'Contabilizado':
            badgeClass = 'bg-[#D6E6FF] text-[#3B82F6]';
            break;
          default:
            badgeClass = 'bg-[#FEE2E2] text-[#DC2626]';
        }
        return `<span class="badge-table ${badgeClass}">${estado}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }

    }
  ];
  tipodebaja=[
    {value: 'obsolencia', label: 'Obsolescencia'},
    {value: 'siniestro', label: 'Siniestro'},
    {value: 'venta', label: 'Venta'},
  ]
  moneda=[
    {value: 'Soles', label: 'Soles'},
    {value: 'usd', label: 'Dólares'},
  ]
  private readonly ventaActivoFacade     = inject(VentaActivoFacade);
  readonly rowData                        = this.ventaActivoFacade.ventasActivos;
  readonly isLoadingVentasActivos         = this.ventaActivoFacade.isLoading;
  private readonly activoFijoFacade = inject(ActivoFijoFacade);
  // Lista de activos disponibles para agregar (cargados desde el JSON vía ActivoFijoFacade)
  readonly activosDisponibles = this.activoFijoFacade.activosFijos;
  columnTypes = {
    nonEditableColumn: { editable: false }
  };

  localeText = {
    page: 'Página',
    more: 'Más',
    to: 'a',
    of: 'de',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    loadingOoo: 'Cargando...',
    selectAll: 'Seleccionar todo',
    searchOoo: 'Buscar...',
    blanks: 'En blanco',
    noRowsToShow: 'No hay datos para mostrar',
  };
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '-'
        : String(params.value);
    }
  };

  cuentasContables : any = [];

  constructor(
    private modalController: ModalController, 
    private toastService: ToastService,
    private formBuilder: FormBuilder,
    private formValidationService: FormValidationService
  ) { 
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
    
    this.formularioBaja = this.createFormGroup();
  }

  ngOnInit() {
    this.ventaActivoFacade.cargarVentasActivos();
    this.activoFijoFacade.cargarActivosFijos();
    this.cargarCuentasContables();
    
    // Inicializar servicio de validación de formularios
    this.formValidationService.inicializarFormulario(this.formularioBaja);
    // Resetear estado inicial después de inicializar
    this.formValidationService.resetearEstado();
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  onBtReset() {
    this.ventaActivoFacade.cargarVentasActivos();
  }

  createFormGroup(): FormGroup {
    return this.formBuilder.group({
      // Campos básicos
      tipoDebaja: ['', [Validators.required]],
      fechaBaja: ['', [Validators.required]],
      moneda: ['', [Validators.required]],
      cuentaContable: ['', [Validators.required]],
      estado: [{ value: 'En proceso', disabled: true }],
      
      // Campos para venta
      valorVenta: [''],
      tipoDocumentoComprador: ['DNI'],
      numeroDocumentoComprador: [''],
      nombreComprador: [''],
      tipoDocumentoVenta: [''],
      numeroDocumentoVenta: [''],
      
      // Campos para siniestro
      tipoSiniestro: [''],
      partePolicial: [''],
      montoIndemnizacion: [''],
      descripcionSiniestro: [''],
      
      // Campos para obsolescencia
      motivoObsolescencia: [''],
      descripcionObsolescencia: [''],
      
      // Campos para donación
      tipoDocumentoBeneficiario: ['DNI'],
      numeroDocumentoBeneficiario: [''],
      nombreBeneficiario: [''],
      documentoRespaldo: [''],
      descripcionDonacion: ['']
    });
  }

  cargarCuentasContables() {
    // Leer directamente desde localStorage para obtener los datos más recientes
    const datosGuardados = localStorage.getItem('plancontable');
    let cuentasLS: any[] = [];
    
    if (datosGuardados) {
      try {
        cuentasLS = JSON.parse(datosGuardados);
      } catch (e) {
        console.error('Error al parsear cuentas contables:', e);
        cuentasLS = [];
      }
    }
    
    console.log(' Cuentas contables cargadas:', cuentasLS.length);
    
    // Mapear cuentas con el formato necesario para el autocomplete
    this.cuentasContables = cuentasLS.map((item: any) => ({
      id: item.codigo,
      codigo: item.codigo,
      descripcion: item.descripcion,
      nombre: `${item.codigo} - ${item.descripcion}`,
      naturaleza: item.naturaleza,
      tipo: item.tipo,
      nivel: item.nivel,
      estado: item.estado,
      ...item
    }));
    
    console.log(' Cuentas contables cargadas para clasificación de activos:', this.cuentasContables.length);
  }
  onGridReady(params: any) {
    this.gridApi = params.api;
  }

  async onCellClicked(params: any) {
    // Validar cambios antes de cambiar de baja
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló, deseleccionar todo primero
      if (this.gridApi) {
        this.gridApi.deselectAll();
        // Volver a seleccionar la fila anterior si existía
        if (this.selectedRowData) {
          this.gridApi.forEachNode((node) => {
            if (node.data === this.selectedRowData) {
              node.setSelected(true);
            }
          });
        }
      }
      return;
    }
    
    this.selectedRowData = params.data;
    this.anularinhabilitado = false;
    
    // Fill form with selected row data
    this.fillFormWithRowData(params.data);
    
    // Set view mode
    this.isViewingExistingRecord = true;
    
    // Disable formulario cuando se visualiza un registro existente
    this.formularioBaja.disable();
    
    // Habilitar todas las pestañas para poder ver la información
    this.seleccionTabEnabled = true;
    // Para tipo venta, resumen solo se habilita al seleccionar un activo de la tabla
    const tipoDebaja = params.data?.venta_activo_tipo_debaja?.toLowerCase();
    this.resumenTabEnabled = tipoDebaja !== 'venta';
    this.tabSeleccionadoDetalle = 'tipo';
    
    // Marcar como pristine y untouched
    this.formularioBaja.markAsPristine();
    this.formularioBaja.markAsUntouched();
    
    // Resetear estado de validación después de cargar datos
    setTimeout(() => {
      this.formValidationService.resetearEstado();
    }, 50);
  }
   scrollLeft() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: -150, behavior: 'smooth' });
  }

  scrollRight() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: 150, behavior: 'smooth' });
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

  colDefsActivosSeleccionados: ColDef[] = [
    { field: 'activo_fijo_codigo', headerName: 'Código', flex: 1, minWidth: 100 },
    { field: 'activo_fijo_descripcion', headerName: 'Descripción', flex: 2, minWidth: 150 },
    { field: 'activo_fijo_valor_adquisicion', headerName: 'Valor original', flex: 1.2, minWidth: 120,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', { 
          style: 'currency', 
          currency: 'PEN',
          minimumFractionDigits: 2 
        }).format(params.value) : 'S/ 0.00';
      }
    },
    { field: 'activo_fijo_depreciacion_acumulada', headerName: 'Depreciación acumulada', flex: 1.3, minWidth: 130,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', { 
          style: 'currency', 
          currency: 'PEN',
          minimumFractionDigits: 2 
        }).format(params.value) : 'S/ 0.00';
      }
    },
    { field: 'activo_fijo_valor_neto_libros', headerName: 'Valor neto contable', flex: 1.3, minWidth: 130,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', { 
          style: 'currency', 
          currency: 'PEN',
          minimumFractionDigits: 2 
        }).format(params.value) : 'S/ 0.00';
      }
    },
    { 
      field: 'accion', 
      headerName: 'Acción', 
      headerClass: 'centrarencabezado',
      flex: 0.8, 
      minWidth: 80,
      cellRenderer: AccesorioActionsCellComponent,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  rowDataActivosSeleccionados: any[] = [];

  onGridReadyActivosSeleccionados(params: any) {
    console.log('Grid de activos seleccionados listo');
  }
  
  private readonly cdr = inject(ChangeDetectorRef);

  onCellClickedActivosSeleccionados(params: any) {
    const tipoDebaja = this.formularioBaja.get('tipoDebaja')?.value;
    if (tipoDebaja === 'venta' && params.data) {
      this.activoSeleccionadoResumen = params.data;
      this.resumenTabEnabled = true;
      this.cdr.detectChanges();
      this.tabSeleccionadoDetalle = 'resumen';
    }
  }

  colDefsAsiento: ColDef[] = [
    { field: 'cuenta', headerName: 'Cuenta', flex: 1, minWidth: 80 },
    { field: 'descripcion', headerName: 'Descripción', flex: 2, minWidth: 150 },
    { field: 'debe', headerName: 'Debe(S/)', flex: 1, minWidth: 100,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', { 
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      }
    },
    { field: 'haber', headerName: 'Haber(S/)', flex: 1, minWidth: 100,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', { 
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      }
    },
    { field: 'centroCosto', headerName: 'Centro de costo', flex: 1.2, minWidth: 120 },
    { field: 'docReferencial', headerName: 'Doc. referencial', flex: 1.2, minWidth: 120 }
  ];

  rowDataAsiento = [
    { 
      cuenta: '16131', 
      descripcion: 'Maquinarias y equipos de explotación', 
      debe: 0.00, 
      haber: 25000.00, 
      centroCosto: 'CC-001 Producción', 
      docReferencial: 'BJ-2024-001' 
    },
    { 
      cuenta: '39131', 
      descripcion: 'Depreciación acumulada - Maquinarias', 
      debe: 15000.00, 
      haber: 0.00, 
      centroCosto: 'CC-001 Producción', 
      docReferencial: 'BJ-2024-001' 
    },
    { 
      cuenta: '10111', 
      descripcion: 'Caja y bancos', 
      debe: 12000.00, 
      haber: 0.00, 
      centroCosto: 'CC-002 Administración', 
      docReferencial: 'VTA-2024-001' 
    },
    { 
      cuenta: '65631', 
      descripcion: 'Pérdida por baja de activo fijo', 
      debe: 2000.00, 
      haber: 0.00, 
      centroCosto: 'CC-001 Producción', 
      docReferencial: 'BJ-2024-001' 
    }
  ];

  onGridReadyAsiento(params: any) {
    console.log('Grid de asiento contable listo');
  }

  onCellClickedAsiento(params: any) {
    console.log('Entrada contable seleccionada:', params.data);
  }

  eliminarActivoSeleccionado(rowIndex: number) {
    this.rowDataActivosSeleccionados.splice(rowIndex, 1);
    console.log('Activo eliminado del índice:', rowIndex);
  }

  // Update form validators dynamically based on tipo de baja
  updateFormValidators(): void {
    console.log('🔧 updateFormValidators llamado');
    // Clear all validators first except basic fields
    Object.keys(this.formularioBaja.controls).forEach(key => {
      if (!['tipoDebaja', 'fechaBaja', 'moneda', 'cuentaContable'].includes(key)) {
        this.formularioBaja.get(key)?.clearValidators();
      }
    });

    const tipoDebaja = this.formularioBaja.get('tipoDebaja')?.value;
    console.log('  Tipo de baja actual:', tipoDebaja);
    
    switch (tipoDebaja) {
      case 'venta':
        console.log(' Asignando validadores para VENTA');
        const ventaFields = ['valorVenta', 'numeroDocumentoComprador', 'nombreComprador', 'tipoDocumentoVenta', 'numeroDocumentoVenta'];
        ventaFields.forEach(field => {
          const control = this.formularioBaja.get(field);
          console.log(`  Campo ${field}: existe=${!!control}`);
          control?.setValidators([Validators.required]);
          control?.updateValueAndValidity();
        });
        break;
      case 'siniestro':
        this.formularioBaja.get('tipoSiniestro')?.setValidators([Validators.required]);
        this.formularioBaja.get('partePolicial')?.setValidators([Validators.required]);
        this.formularioBaja.get('montoIndemnizacion')?.setValidators([Validators.required]);
        break;
      case 'obsolencia':
        this.formularioBaja.get('motivoObsolescencia')?.setValidators([Validators.required]);
        this.formularioBaja.get('descripcionObsolescencia')?.setValidators([Validators.required]);
        break;
      case 'donacion':
        this.formularioBaja.get('numeroDocumentoBeneficiario')?.setValidators([Validators.required]);
        this.formularioBaja.get('nombreBeneficiario')?.setValidators([Validators.required]);
        this.formularioBaja.get('descripcionDonacion')?.setValidators([Validators.required]);
        break;
    }

    // Update validity for all controls
    Object.keys(this.formularioBaja.controls).forEach(key => {
      this.formularioBaja.get(key)?.updateValueAndValidity();
    });
    console.log(' Validadores actualizados');
  }

  // Check if campos básicos are complete
  areCamposBasicosComplete(): boolean {
    const basicControls = ['tipoDebaja', 'fechaBaja', 'moneda', 'cuentaContable'];
    return basicControls.every(control => {
      const formControl = this.formularioBaja.get(control);
      return formControl && formControl.valid && formControl.value;
    });
  }

  // Check if specific fields for current tipo de baja are complete
  isCurrentTipoDebajaFieldsComplete(): boolean {
    const tipoDebaja = this.formularioBaja.get('tipoDebaja')?.value;
    
    switch (tipoDebaja) {
      case 'venta':
        return this.isVentaFieldsComplete();
      case 'siniestro':
        return this.isSiniestroFieldsComplete();
      case 'obsolencia':
        return this.isObsolescenciaFieldsComplete();
      case 'donacion':
        return this.isDonacionFieldsComplete();
      default:
        return false;
    }
  }

  // Check if specific fields for 'venta' are complete
  isVentaFieldsComplete(): boolean {
    const ventaControls = ['valorVenta', 'numeroDocumentoComprador', 'nombreComprador', 'tipoDocumentoVenta', 'numeroDocumentoVenta'];
    const results: any = {};
    ventaControls.forEach(control => {
      const formControl = this.formularioBaja.get(control);
      const hasValue = formControl?.value !== null && formControl?.value !== undefined && formControl?.value !== '';
      results[control] = {
        value: formControl?.value,
        valid: formControl?.valid,
        hasValidators: formControl?.hasValidator(Validators.required),
        errors: formControl?.errors,
        hasValue: hasValue,
        complete: formControl && formControl.valid && hasValue
      };
    });
    console.log('  Validación detallada campos venta:', results);
    const isComplete = ventaControls.every(control => {
      const formControl = this.formularioBaja.get(control);
      const hasValue = formControl?.value !== null && formControl?.value !== undefined && formControl?.value !== '';
      return formControl && formControl.valid && hasValue;
    });
    console.log(' Venta completa:', isComplete);
    return isComplete;
  }

  // Check if specific fields for 'siniestro' are complete
  isSiniestroFieldsComplete(): boolean {
    const siniestroControls = ['tipoSiniestro', 'partePolicial', 'montoIndemnizacion'];
    return siniestroControls.every(control => {
      const formControl = this.formularioBaja.get(control);
      return formControl && formControl.valid && formControl.value;
    });
  }

  // Check if specific fields for 'obsolescencia' are complete
  isObsolescenciaFieldsComplete(): boolean {
    const obsolescenciaControls = ['motivoObsolescencia', 'descripcionObsolescencia'];
    return obsolescenciaControls.every(control => {
      const formControl = this.formularioBaja.get(control);
      return formControl && formControl.valid && formControl.value;
    });
  }

  // Check if specific fields for 'donacion' are complete
  isDonacionFieldsComplete(): boolean {
    const donacionControls = ['numeroDocumentoBeneficiario', 'nombreBeneficiario', 'descripcionDonacion'];
    const formValid = donacionControls.every(control => {
      const formControl = this.formularioBaja.get(control);
      return formControl && formControl.valid && formControl.value;
    });
    return formValid && !!this.documentoRespaldo;
  }

  // Check if tipo de baja tab is complete (for internal validation)
  isTipoBajaComplete(): boolean {
    return this.areCamposBasicosComplete() && this.isCurrentTipoDebajaFieldsComplete();
  }
  
  // Check if seleccion tab should be enabled (for all tipos de baja)
  isSeleccionTabEnabled(): boolean {
    return this.seleccionTabEnabled;
  }
  
  // Check if seleccion tab is complete
  isSeleccionComplete(): boolean {
    return this.rowDataActivosSeleccionados.length > 0;
  }
  
  // Check if current tab allows navigation to next
  canNavigateToNextTab(): boolean {
    if (this.tabSeleccionadoDetalle === 'tipo') {
      return this.isTipoBajaComplete();
    } else if (this.tabSeleccionadoDetalle === 'seleccion') {
      return this.isSeleccionComplete();
    }
    return true;
  }
  
  // Check if resumen tab should be accessible (only for venta)
  isResumenTabEnabled(): boolean {
    const tipoDebaja = this.formularioBaja.get('tipoDebaja')?.value;
    return tipoDebaja === 'venta' && this.resumenTabEnabled;
  }
  
  // Get button text based on current tab and disposal type
  getButtonText(): string {
    const tipoDebaja = this.formularioBaja.get('tipoDebaja')?.value;
    
    if (this.tabSeleccionadoDetalle === 'tipo') {
      return 'Siguiente';
    }
    
    if (this.tabSeleccionadoDetalle === 'seleccion') {
      // Si es venta, mostrar Siguiente para ir a resumen
      // Si no es venta, mostrar Finalizar
      return tipoDebaja === 'venta' ? 'Siguiente' : 'Finalizar';
    }
    
    // En el tab de resumen (solo venta llega aquí)
    return 'Finalizar';
  }
  
  // Get validation message for incomplete fields
  getValidationMessage(): string {
    if (this.tabSeleccionadoDetalle === 'tipo') {
      if (!this.areCamposBasicosComplete()) {
        return 'Complete los campos básicos: Tipo de baja, Fecha de baja, Moneda y Cuenta contable';
      }

      const tipoDebaja = this.formularioBaja.get('tipoDebaja')?.value;
      switch (tipoDebaja) {
        case 'venta':
          if (!this.isCurrentTipoDebajaFieldsComplete()) {
            return 'Complete todos los campos requeridos para la venta: Valor, datos del comprador y documento';
          }
          break;
        case 'siniestro':
          if (!this.isCurrentTipoDebajaFieldsComplete()) {
            return 'Complete todos los campos requeridos para el siniestro: Tipo, parte policial y monto';
          }
          break;
        case 'obsolencia':
          if (!this.isCurrentTipoDebajaFieldsComplete()) {
            return 'Complete todos los campos requeridos para obsolescencia: Motivo y descripción';
          }
          break;
        case 'donacion':
          if (!this.isCurrentTipoDebajaFieldsComplete()) {
            return 'Complete todos los campos requeridos para donación: Datos del beneficiario, documento de respaldo y descripción';
          }
          break;
      }
    } else if (this.tabSeleccionadoDetalle === 'seleccion') {
      if (!this.isSeleccionComplete()) {
        return 'Debe seleccionar al menos un activo fijo';
      }
    }
    return '';
  }

  // Check if current tab is the last one
  isLastTab(): boolean {
    const tipoDebaja = this.formularioBaja.get('tipoDebaja')?.value;
    if (this.tabSeleccionadoDetalle === 'resumen') return true;
    if (this.tabSeleccionadoDetalle === 'seleccion' && tipoDebaja !== 'venta') return true;
    return false;
  }

  // Navigate to next tab
  navegarSiguienteTab(): void {
    if (this.tabSeleccionadoDetalle === 'tipo') {
      if (this.isTipoBajaComplete()) {
        this.seleccionTabEnabled = true;
        this.tabSeleccionadoDetalle = 'seleccion';
      } else {
        const message = this.getValidationMessage();
        this.toastService.warning(message || 'Complete todos los campos requeridos');
        // Marcar campos básicos como touched
        ['tipoDebaja', 'fechaBaja', 'moneda', 'cuentaContable'].forEach(c => this.formularioBaja.get(c)?.markAsTouched());
        // Marcar campos específicos del tipo de baja
        const tipoDebaja = this.formularioBaja.get('tipoDebaja')?.value;
        if (tipoDebaja === 'venta') {
          ['valorVenta', 'numeroDocumentoComprador', 'nombreComprador', 'tipoDocumentoVenta', 'numeroDocumentoVenta'].forEach(c => this.formularioBaja.get(c)?.markAsTouched());
        } else if (tipoDebaja === 'siniestro') {
          ['tipoSiniestro', 'partePolicial', 'montoIndemnizacion'].forEach(c => this.formularioBaja.get(c)?.markAsTouched());
        } else if (tipoDebaja === 'obsolencia') {
          ['motivoObsolescencia', 'descripcionObsolescencia'].forEach(c => this.formularioBaja.get(c)?.markAsTouched());
        } else if (tipoDebaja === 'donacion') {
          ['numeroDocumentoBeneficiario', 'nombreBeneficiario', 'descripcionDonacion'].forEach(c => this.formularioBaja.get(c)?.markAsTouched());
        }
      }
    } else if (this.tabSeleccionadoDetalle === 'seleccion') {
      if (this.isSeleccionComplete()) {
        const tipoDebaja = this.formularioBaja.get('tipoDebaja')?.value;
        if (tipoDebaja === 'venta') {
          this.toastService.warning('Seleccione un activo de la tabla para ver el resumen');
        } else {
          this.finalizarProceso();
        }
      } else {
        this.toastService.warning('Debe seleccionar al menos un activo fijo');
      }
    } else if (this.tabSeleccionadoDetalle === 'resumen') {
      this.finalizarProceso();
    }
  }
  async abrirModalAnular() {
        
      const detallesEjemplo = [
        { label: 'Código de baja:', value: this.selectedRowData?.venta_activo_codigo_baja || 'No seleccionado' },
        { label: 'Tipo de baja:', value: this.selectedRowData?.venta_activo_tipo_debaja || 'No seleccionado' },
        { label: 'Fecha de baja:', value: this.selectedRowData?.venta_activo_fecha_baja || 'No seleccionado' },
        { label: 'N° de activos fijos:', value: this.selectedRowData?.venta_activo_activos ? this.selectedRowData.venta_activo_activos.length : 'No seleccionado' },
        { label: 'Valor neto contable:', value: this.selectedRowData?.venta_activo_valor_neto_contable ? `S/ ${this.selectedRowData.venta_activo_valor_neto_contable.toFixed(2)}` : 'No seleccionado' },
        { label: 'Estado:', value: this.selectedRowData?.venta_activo_estado || 'No seleccionado' },
      ];
  
      const modal = await this.modalController.create({
        component: ModalDetalleComponent,
        cssClass: 'promo',
        componentProps: {
          tituloModal: 'Anular baja de activo fijo',
          subtitulomodal: 'Detalle de la baja a anular',
          detalles: detallesEjemplo,
          tituloTextarea: 'Motivo de anulación',
          mostrarTextarea: true,
          mostrarBotonEliminar: true,
          textoBotonConfirmar: 'Anular',
          colorBotonConfirmar: 'danger'
        }
      });
  
      await modal.present();
      
      const { data } = await modal.onWillDismiss();
      if (data && data.action === 'confirmar') {
        // Confirmar inactivación - mantener el estado Inactivo
        this.toastService.success('¡Proceso anulado exitosamente!');
      }
    }
  // Navigate to previous tab
  navegarAnteriorTab(): void {
    if (this.tabSeleccionadoDetalle === 'seleccion') {
      this.tabSeleccionadoDetalle = 'tipo';
    } else if (this.tabSeleccionadoDetalle === 'resumen') {
      this.tabSeleccionadoDetalle = 'seleccion';
    }
  }
  
  // Check if anterior button should be shown
  shouldShowAnteriorButton(): boolean {
    return !this.isViewingExistingRecord && (this.tabSeleccionadoDetalle === 'seleccion' || this.tabSeleccionadoDetalle === 'resumen');
  }
  
  // Check if navigation buttons should be shown
  shouldShowNavigationButtons(): boolean {
    // No mostrar si está viendo un registro existente
    if (this.isViewingExistingRecord) {
      return false;
    }
    // No mostrar si el estado es Contabilizado
    if (this.selectedRowData?.estado === 'Contabilizado') {
      return false;
    }
    return true;
  }
  
  // Finalize the disposal process
  finalizarProceso(): void {
    // Calcular valor neto contable desde los activos seleccionados
    const valorNetoContable = this.rowDataActivosSeleccionados.reduce(
      (sum: number, a: any) => sum + (a.activo_fijo_valor_neto_libros || 0), 0
    );

    // Crear el nuevo registro con estado Contabilizado
    const nuevoRegistro: any = {
      venta_activo_codigo_baja: `BJ-${new Date().getFullYear()}-${String(this.rowData().length + 1).padStart(3, '0')}`,
      venta_activo_tipo_debaja: this.getTipoDebajaLabel(this.formularioBaja.get('tipoDebaja')?.value),
      venta_activo_fecha_baja: new Date().toLocaleDateString('es-ES', { day: '2-digit', month: '2-digit', year: 'numeric' }),
      venta_activo_valor_neto_contable: valorNetoContable,
      venta_activo_estado: 'Contabilizado',
      venta_activo_moneda: this.formularioBaja.get('moneda')?.value || '',
      venta_activo_cuenta_contable: this.formularioBaja.get('cuentaContable')?.value || '',
      venta_activo_activos: this.rowDataActivosSeleccionados.map((a: any) => ({
        activo_fijo_codigo: a.activo_fijo_codigo,
        activo_fijo_descripcion: a.activo_fijo_descripcion,
        activo_fijo_valor_adquisicion: a.activo_fijo_valor_adquisicion,
        activo_fijo_depreciacion_acumulada: a.activo_fijo_depreciacion_acumulada,
        activo_fijo_valor_neto_libros: a.activo_fijo_valor_neto_libros,
      }))
    };

    // Agregar campos según tipo de baja
    const tipoDebaja = this.formularioBaja.get('tipoDebaja')?.value;
    switch (tipoDebaja) {
      case 'venta':
        nuevoRegistro.venta_activo_valor_venta = this.formularioBaja.get('valorVenta')?.value;
        nuevoRegistro.venta_activo_tipo_doc_comprador = this.formularioBaja.get('tipoDocumentoComprador')?.value;
        nuevoRegistro.venta_activo_nro_doc_comprador = this.formularioBaja.get('numeroDocumentoComprador')?.value;
        nuevoRegistro.venta_activo_nombre_comprador = this.formularioBaja.get('nombreComprador')?.value;
        nuevoRegistro.venta_activo_tipo_doc_venta = this.formularioBaja.get('tipoDocumentoVenta')?.value;
        nuevoRegistro.venta_activo_nro_doc_venta = this.formularioBaja.get('numeroDocumentoVenta')?.value;
        break;
      case 'siniestro':
        nuevoRegistro.venta_activo_tipo_siniestro = this.formularioBaja.get('tipoSiniestro')?.value;
        nuevoRegistro.venta_activo_parte_policial = this.formularioBaja.get('partePolicial')?.value;
        nuevoRegistro.venta_activo_monto_indemnizacion = this.formularioBaja.get('montoIndemnizacion')?.value;
        nuevoRegistro.venta_activo_descripcion_siniestro = this.formularioBaja.get('descripcionSiniestro')?.value;
        break;
      case 'obsolencia':
        nuevoRegistro.venta_activo_motivo_obsolescencia = this.formularioBaja.get('motivoObsolescencia')?.value;
        nuevoRegistro.venta_activo_descripcion_obsolescencia = this.formularioBaja.get('descripcionObsolescencia')?.value;
        break;
    }
    
    // Agregar al inicio del array
    const datosActualizados = [nuevoRegistro, ...this.rowData()];
    
    // Actualizar grid y seleccionar la fila
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', datosActualizados);
      
      // Esperar un ciclo para que el grid se actualice y luego seleccionar la fila
      setTimeout(() => {
        this.gridApi.forEachNode((node) => {
          if (node.data.venta_activo_codigo_baja === nuevoRegistro.venta_activo_codigo_baja) {
            node.setSelected(true);
            this.gridApi.ensureIndexVisible(node.rowIndex!, 'top');
          }
        });
      }, 100);
    }
    
    // Marcar como registro existente y seleccionar
    this.isViewingExistingRecord = true;
    this.selectedRowData = nuevoRegistro;
    this.filaSeleccionada = nuevoRegistro;
    this.anularinhabilitado = false;
    
    // Deshabilitar el formulario (solo Anular estará habilitado)
    this.formularioBaja.disable();
    
    // Volver al tab tipo después de finalizar
    this.tabSeleccionadoDetalle = 'tipo';
    
    // Resetear estado de validación
    this.formValidationService.resetearEstado();

    this.toastService.success('¡Baja registrada exitosamente!');
  }
  
  // Helper para obtener el label del tipo de baja
  private getTipoDebajaLabel(value: string): string {
    const tipo = this.tipodebaja.find(t => t.value === value);
    return tipo ? tipo.label : value;
  }
  
  async nuevotipodebaja(){
    // Validar cambios antes de limpiar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    // Clear selected row data
    this.selectedRowData = null;
    this.filaSeleccionada = null;
    this.anularinhabilitado = true;
    
    // Set to creation mode (not viewing existing record)
    this.isViewingExistingRecord = false;
    
    // Reset formulario
    this.resetFormulario();
    
    // Resetear estado de validación
    this.formValidationService.resetearEstado();
  }

  async botonCancelar(): Promise<void> {
    // Validar cambios antes de cancelar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Si cancela, deseleccionar la fila
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }
      return; // Cancelar acción
    }

    // Reiniciar el formulario a los valores por defecto
    if (this.formularioBaja) {
      this.resetFormulario();
      
      // Limpiar variables
      this.selectedRowData = null;
      this.filaSeleccionada = null;
      this.anularinhabilitado = true;
      this.isViewingExistingRecord = false;

      // Deseleccionar fila de la tabla
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }

      // Resetear estado del servicio de validación
      this.formValidationService.resetearEstado();
    }
  }
  // Fill form with selected row data
  fillFormWithRowData(rowData: any): void {
    // Map tipoBaja to form value
    const tipoMap: any = {
      'Venta': 'venta',
      'Obsolescencia': 'obsolencia', 
      'Siniestro': 'siniestro',
      'Daño total': 'dano_total'
    };
    
    const tipoDebaja = tipoMap[rowData.venta_activo_tipo_debaja] || '';
    this.tipoDebajaSeleccionado = tipoDebaja;
    let fecha: Date | null = null;
    
    // Parse fecha DD/MM/YYYY
    if (rowData.venta_activo_fecha_baja) {
      const fechaParts = rowData.venta_activo_fecha_baja.split('/');
      if (fechaParts.length === 3) {
        fecha = new Date(parseInt(fechaParts[2]), parseInt(fechaParts[1]) - 1, parseInt(fechaParts[0]));
        this.fechaSolicitud = fecha;
      }
    }
    
    // Campos básicos
    this.formularioBaja.patchValue({
      tipoDebaja: tipoDebaja,
      fechaBaja: fecha,
      moneda: rowData.venta_activo_moneda || '',
      cuentaContable: rowData.venta_activo_cuenta_contable || '',
      estado: rowData.venta_activo_estado || ''
    });

    // Campos según tipo de baja
    switch (tipoDebaja) {
      case 'venta':
        this.formularioBaja.patchValue({
          valorVenta: rowData.venta_activo_valor_venta || '',
          tipoDocumentoComprador: rowData.venta_activo_tipo_doc_comprador || 'DNI',
          numeroDocumentoComprador: rowData.venta_activo_nro_doc_comprador || '',
          nombreComprador: rowData.venta_activo_nombre_comprador || '',
          tipoDocumentoVenta: rowData.venta_activo_tipo_doc_venta || '',
          numeroDocumentoVenta: rowData.venta_activo_nro_doc_venta || ''
        });
        break;
      case 'siniestro':
        this.formularioBaja.patchValue({
          tipoSiniestro: rowData.venta_activo_tipo_siniestro || '',
          partePolicial: rowData.venta_activo_parte_policial || '',
          montoIndemnizacion: rowData.venta_activo_monto_indemnizacion || '',
          descripcionSiniestro: rowData.venta_activo_descripcion_siniestro || ''
        });
        break;
      case 'obsolencia':
        this.formularioBaja.patchValue({
          motivoObsolescencia: rowData.venta_activo_motivo_obsolescencia || '',
          descripcionObsolescencia: rowData.venta_activo_descripcion_obsolescencia || ''
        });
        break;
    }
    
    // Update validators for the selected tipo de baja
    this.updateFormValidators();
    
    // Cargar activos asociados a la baja
    if (rowData.venta_activo_activos && Array.isArray(rowData.venta_activo_activos)) {
      this.rowDataActivosSeleccionados = rowData.venta_activo_activos.map((a: any) => ({
        activo_fijo_codigo: a.activo_fijo_codigo,
        activo_fijo_descripcion: a.activo_fijo_descripcion,
        activo_fijo_valor_adquisicion: a.activo_fijo_valor_adquisicion,
        activo_fijo_depreciacion_acumulada: a.activo_fijo_depreciacion_acumulada,
        activo_fijo_valor_neto_libros: a.activo_fijo_valor_neto_libros,
      }));
    } else {
      this.rowDataActivosSeleccionados = [];
    }
  }
  
  // Reset form data and navigation state
  resetFormulario(): void {
    // Reset form
    this.formularioBaja.reset({
      fechaBaja: null,
      estado: 'En proceso',
      tipoDocumentoComprador: 'DNI',
      tipoDocumentoBeneficiario: 'DNI',
    });
    
    // Enable all controls first (in case they were disabled)
    this.formularioBaja.enable();
    this.formularioBaja.get('estado')?.disable();
    
    // Clear validators for specific tipo de baja fields
    Object.keys(this.formularioBaja.controls).forEach(key => {
      if (!['tipoDebaja', 'fechaBaja', 'moneda', 'cuentaContable'].includes(key)) {
        this.formularioBaja.get(key)?.clearValidators();
        this.formularioBaja.get(key)?.updateValueAndValidity();
      }
    });
    
    // Reset additional properties
    this.tipoDebajaSeleccionado = '';
    this.monedaSeleccionada = '';
    this.activoSeleccionado = null;
    this.documentoRespaldo = '';
    this.fechaSolicitud = null;
    
    // Clear selected assets table
    this.rowDataActivosSeleccionados = [];
    
    // Reset navigation state
    this.seleccionTabEnabled = false;
    this.resumenTabEnabled = false;
    this.tabSeleccionadoDetalle = 'tipo';
    
    // Reset view mode
    this.isViewingExistingRecord = false;
    
    console.log('Formulario reiniciado');
  }
  
  // Handle tipo de baja selection
  onTipoDebajaSelected(event: any): void {
    this.tipoDebajaSeleccionado = event.detail.value;
    this.formularioBaja.get('tipoDebaja')?.setValue(event.detail.value);
    this.updateFormValidators();
  }
  
  // Handle moneda selection
  onMonedaSelected(event: any): void {
    this.monedaSeleccionada = event.detail.value;
    this.formularioBaja.get('moneda')?.setValue(event.detail.value);
  }
  
  // Handle fecha solicitud (updated method)
  onFechaSolicitud(fecha: Date): void {
    this.fechaSolicitud = fecha;
    this.formularioBaja.get('fechaBaja')?.setValue(fecha);
    console.log('Fecha de baja seleccionada:', fecha);
  }
  
  // Handle activo selection from autocomplete
  onActivoSeleccionado(activo: any): void {
    if (!activo) return;
    
    // Verificar si el activo ya está en la lista
    const yaExiste = this.rowDataActivosSeleccionados.some((a: any) => a.activo_fijo_codigo === activo.activo_fijo_codigo);
    
    if (yaExiste) {
      this.toastService.warning('Este activo ya ha sido agregado');
      this.activoAC?.clearSelection();
      return;
    }
    
    // Agregar el activo a la tabla con datos reales
    const nuevoActivo = {
      activo_fijo_codigo: activo.activo_fijo_codigo,
      activo_fijo_descripcion: activo.activo_fijo_descripcion,
      activo_fijo_valor_adquisicion: activo.activo_fijo_valor_adquisicion,
      activo_fijo_depreciacion_acumulada: activo.activo_fijo_depreciacion_acumulada,
      activo_fijo_valor_neto_libros: activo.activo_fijo_valor_neto_libros,
    };
    
    this.rowDataActivosSeleccionados = [...this.rowDataActivosSeleccionados, nuevoActivo];
    this.activoAC?.clearSelection();
    this.toastService.success('Activo agregado correctamente');
  }

  onCuentaContableSeleccionada(cuenta: any) {
    this.formularioBaja.get('cuentaContable')?.setValue(cuenta.codigo || cuenta.value);
    console.log('Cuenta contable seleccionada:', cuenta);
  }
   togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      this.documentoRespaldo = file.name;
      console.log('Archivo seleccionado:', file.name);
    }
  }

  removeFile() {
    this.documentoRespaldo = '';
    console.log('Archivo removido');
  }

  // Método para buscar comprador por DNI/RUC
  buscarComprador() {
    const tipoDocumento = this.formularioBaja.get('tipoDocumentoComprador')?.value;
    const numeroDocumento = this.formularioBaja.get('numeroDocumentoComprador')?.value;
    
    console.log('Buscando comprador:', { tipoDocumento, numeroDocumento });
    
    if (!numeroDocumento || numeroDocumento.toString().trim() === '') {
      return;
    }

    // Generar un nombre automáticamente basado en el número ingresado
    let nombreGenerado = '';
    
    if (tipoDocumento === 'DNI') {
      // Para DNI generar nombre de persona
      const nombres = ['Juan Carlos', 'María Elena', 'Pedro Luis', 'Ana Sofia', 'Carlos Alberto', 'Rosa María'];
      const apellidos = ['García López', 'Rodríguez Pérez', 'Martinez Ruiz', 'Fernández Torres', 'González Vargas', 'Díaz Morales'];
      
      const indiceNombre = parseInt(numeroDocumento.toString().slice(-1)) % nombres.length;
      const indiceApellido = parseInt(numeroDocumento.toString().slice(-2, -1)) % apellidos.length;
      
      nombreGenerado = `${nombres[indiceNombre]} ${apellidos[indiceApellido]}`;
    } else if (tipoDocumento === 'RUC') {
      // Para RUC generar nombre de empresa
      const tiposEmpresa = ['EMPRESA', 'COMERCIAL', 'CORPORACIÓN', 'INDUSTRIAS', 'SERVICIOS', 'GRUPO'];
      const nombresEmpresa = ['DEMO', 'EJEMPLO', 'MODELO', 'PRUEBA', 'TEST', 'MUESTRA'];
      const sufijos = ['S.A.C.', 'S.R.L.', 'E.I.R.L.', 'S.A.', 'S.A.A.', 'LTDA.'];
      
      const indiceTipo = parseInt(numeroDocumento.toString().slice(-1)) % tiposEmpresa.length;
      const indiceNombre = parseInt(numeroDocumento.toString().slice(-2, -1)) % nombresEmpresa.length;
      const indiceSufijo = parseInt(numeroDocumento.toString().slice(-3, -2)) % sufijos.length;
      
      nombreGenerado = `${tiposEmpresa[indiceTipo]} ${nombresEmpresa[indiceNombre]} ${sufijos[indiceSufijo]}`;
    }
    
    // Establecer el nombre generado en el formulario
    this.formularioBaja.get('nombreComprador')?.setValue(nombreGenerado);
    
    console.log('Nombre generado:', nombreGenerado);
  }

  // Método para buscar beneficiario por DNI/RUC (para donaciones)
  buscarBeneficiario() {
    const tipoDocumento = this.formularioBaja.get('tipoDocumentoBeneficiario')?.value;
    const numeroDocumento = this.formularioBaja.get('numeroDocumentoBeneficiario')?.value;
    
    console.log('Buscando beneficiario:', { tipoDocumento, numeroDocumento });
    
    if (!numeroDocumento || numeroDocumento.toString().trim() === '') {
      return;
    }

    // Generar un nombre automáticamente para beneficiarios
    let nombreGenerado = '';
    
    if (tipoDocumento === 'DNI') {
      const nombres = ['Roberto José', 'Carmen Isabel', 'Miguel Angel', 'Lucía Patricia', 'Fernando David', 'Gloria Elena'];
      const apellidos = ['Mendoza Silva', 'Castillo Herrera', 'Vega Campos', 'Ramos Jiménez', 'Flores Delgado', 'Navarro Cruz'];
      
      const indiceNombre = parseInt(numeroDocumento.toString().slice(-1)) % nombres.length;
      const indiceApellido = parseInt(numeroDocumento.toString().slice(-2, -1)) % apellidos.length;
      
      nombreGenerado = `${nombres[indiceNombre]} ${apellidos[indiceApellido]}`;
    } else if (tipoDocumento === 'RUC') {
      const organizaciones = ['FUNDACIÓN', 'ASOCIACIÓN', 'ONG', 'INSTITUCIÓN', 'CENTRO', 'COMUNIDAD'];
      const propósitos = ['CARIDAD', 'ESPERANZA', 'SOLIDARIDAD', 'AYUDA SOCIAL', 'BIENESTAR', 'DESARROLLO'];
      const sufijos = ['TOTAL', 'PERUANA', 'NACIONAL', 'REGIONAL', 'LOCAL', 'COMUNITARIA'];
      
      const indiceOrg = parseInt(numeroDocumento.toString().slice(-1)) % organizaciones.length;
      const indiceProp = parseInt(numeroDocumento.toString().slice(-2, -1)) % propósitos.length;
      const indiceSuf = parseInt(numeroDocumento.toString().slice(-3, -2)) % sufijos.length;
      
      nombreGenerado = `${organizaciones[indiceOrg]} ${propósitos[indiceProp]} ${sufijos[indiceSuf]}`;
    }
    
    // Establecer el nombre generado en el formulario
    this.formularioBaja.get('nombreBeneficiario')?.setValue(nombreGenerado);
    
    console.log('Nombre beneficiario generado:', nombreGenerado);
  }
}
