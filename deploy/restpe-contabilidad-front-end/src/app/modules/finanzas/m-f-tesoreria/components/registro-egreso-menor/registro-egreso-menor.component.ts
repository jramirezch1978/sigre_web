import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef, GridState } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faArrowCircleUp, faCashRegister, faChartLineDown, faCirclePlus, faDownload, faPiggyBank, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { RegistroEgresoMenorEntity } from 'src/app/modules/finanzas/domain/models/registro-egreso-menor.entity';
import { RegistroEgresoMenorFacade } from 'src/app/modules/finanzas/application/facades/registro-egreso-menor.facade';
import { RegistroEgresoMenorFeedbackEffects } from 'src/app/modules/finanzas/effects/registro-egreso-menor-feedback.effect';



@Component({
  selector: 'app-registro-egreso-menor',
  templateUrl: './registro-egreso-menor.component.html',
  styleUrls: ['./registro-egreso-menor.component.scss'],
  standalone: false,
})
export class RegistroEgresoMenorComponent implements OnInit, OnDestroy {
  private readonly facade = inject(RegistroEgresoMenorFacade);
  private readonly feedbackEffects = inject(RegistroEgresoMenorFeedbackEffects);
  readonly isLoading = this.facade.isLoading;
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasArrowCircleUp = faArrowCircleUp;
  fasCashRegister = faCashRegister;
  fasChartLineDown = faChartLineDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasPiggyBank = faPiggyBank;
  fasRotateRight = faRotateRight;



  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  
  pais= this.countryService.getCountryCode();
  private gridApi!: GridApi;
  tipoFormulario: 'egreso' | 'solicitar' | 'registrar' | 'pendiente' | 'cerrar' = 'egreso';
  solicitudEnviada: boolean = false;
  registroSolicitudEnviada: RegistroEgresoMenorEntity | null = null;
  filaSeleccionada: any = null;
  codigoSeleccionado: string = '';
  egresoForm!: FormGroup;
  reposicionSolicitudForm!: FormGroup;
  reposicionRegistroForm!: FormGroup;
  cerrarFondoForm!: FormGroup;
  botonDerechoDisabled: boolean = false;
  reposicionProcesada: boolean = false;
  
  fechaAsignacionSeleccionada: Date | undefined;
  fechaMovimientoSeleccionada: Date | undefined;
  
  cajas = [
    { id: 1, nombre: 'Caja 1' },
    { id: 2, nombre: 'Caja 2' },
    { id: 3, nombre: 'Caja 4' },
    { id: 4, nombre: 'Caja principal' },
  ];
  
  tiposFondo = [
    { id: 1, nombre: 'Caja chica' },
    { id: 2, nombre: 'Fondo fijo' },
  ];
  
  // Información de fondos por caja
  fondosPorCaja: any = {
    'Caja 1': {
      'Caja chica': { montoDisponible: 3000.00, montoMaximo: 300.00 },
      'Fondo fijo': { montoDisponible: 8000.00, montoMaximo: 800.00 }
    },
    'Caja 2': {
      'Caja chica': { montoDisponible: 4000.00, montoMaximo: 400.00 },
      'Fondo fijo': { montoDisponible: 9000.00, montoMaximo: 900.00 }
    },
    'Caja 4': {
      'Caja chica': { montoDisponible: 5000.00, montoMaximo: 500.00 },
      'Fondo fijo': { montoDisponible: 10000.00, montoMaximo: 1000.00 }
    },
    'Caja principal': {
      'Caja chica': { montoDisponible: 6000.00, montoMaximo: 600.00 },
      'Fondo fijo': { montoDisponible: 12000.00, montoMaximo: 1200.00 }
    }
  };
  
  responsables = [
    { id: 1, nombre: 'María García' },
    { id: 2, nombre: 'Juan Pérez' },
  ];
  
  categorias = [
    { id: 1, nombre: 'Papelería' },
    { id: 2, nombre: 'Limpieza' },
    { id: 3, nombre: 'Transporte' },
    { id: 4, nombre: 'Otros' },
  ];
  
  monedas = [
    { id: 'Soles', nombre: 'Soles' },
    { id: 'Dólares', nombre: 'Dólares' },
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
  
  context = {
    componentParent: this
  };
  
  defaultColDef = {
    valueFormatter: (params: any) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '-'
        : params.value;
    }
  };
  
  rowData: RegistroEgresoMenorEntity[] = [];
  
  colDefs: ColDef[] = [
    { field: 'rem_codigo', headerName: 'Código', width: 110, minWidth: 110 },
    { field: 'rem_tipoFondo', headerName: 'Tipo de fondo', width: 120, filter: true, minWidth: 120 },
    { field: 'rem_responsable', headerName: 'Responsable', width: 130, minWidth: 130, filter:true },
    { field: 'rem_fecha', headerName: 'Fecha', width: 110, minWidth: 110 },
    { field: 'rem_tipoMovimiento', headerName: 'Tipo de movimiento', width: 150, minWidth: 150 },
    { field: 'rem_categoria', headerName: 'Categoría', width: 120, filter: true, minWidth: 120 },
    { field: 'rem_montoAsignado', headerName: 'Monto asignado', width: 140,
      minWidth: 140,
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
            return `S/ (${formattedValue})`;
          }
          return `S/ ${formattedValue}`;
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
    { field: 'rem_moneda', headerName: 'Moneda', width: 100, minWidth: 100 },
    { 
      field: 'rem_asientoContable', 
      headerName: 'Asiento contable', 
      width: 130, 
      minWidth: 130,
      cellRenderer: VistaCellRenderComponent
    },
    { 
      field: 'rem_estado', 
      headerName: 'Estado',
      headerClass: 'centrarencabezado', 
      width: 110, 
      minWidth: 110,
      filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center'},
      cellRenderer: (params: any) => {
        if (params.value === 'Aprobado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Aprobado</span>';
        } else if (params.value === 'Repuesto') {
          return '<span class="badge-table bg-[#D6E6FF] text-[#3B82F6]">Repuesto</span>';
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-[363636]">Pendiente</span>';
        } else if (params.value === 'Rechazado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Rechazado</span>';
        } else if (params.value === 'Cerrado') {
          return '<span class="badge-table bg-[#FFDECC] text-[#FF8947]">Cerrado</span>';
        }
        
        
        return params.value;
      },
    },
  ];
  
  initialState: GridState = {};
  
  get tituloFormulario(): string {
    const codigo = this.codigoSeleccionado ? `: ${this.codigoSeleccionado}` : '';
    if (this.tipoFormulario === 'egreso') {
      return `Egreso menor${codigo}`;
    } else if (this.tipoFormulario === 'solicitar') {
      return `Solicitar reposición${codigo}`;
    } else if (this.tipoFormulario === 'registrar') {
      return `Reposición${codigo}`;
    } else if (this.tipoFormulario === 'cerrar') {
      return `Cerrar fondo${codigo}`;
    }
    return '';
  }
  
  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController,
    private countryService: CountryService,
    private formValidationService: FormValidationService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
    effect(() => {
      const movimientos = this.facade.movimientos();
      this.rowData = movimientos;
      if (this.gridApi) this.gridApi.setGridOption('rowData', this.rowData);
    });
  }

  ngOnInit() {
    this.facade.cargarMovimientos();
    this.initForms();
  }

  ngOnDestroy() {
    this.facade.resetState();
    this.formValidationService.limpiarFormulario();
  }
  
  initForms() {
    // Formulario de egreso menor
    this.egresoForm = this.formBuilder.group({
      caja: ['', Validators.required],
      responsableCaja: ['', Validators.required],
      tipoFondo: ['', Validators.required],
      montoDisponible: [''],
      montoMaximo: [''],
      responsable: ['', Validators.required],
      fechaMovimiento: ['', Validators.required],
      categoriaGasto: ['', Validators.required],
      descripcion: ['', Validators.required],
      moneda: ['', Validators.required],
      tipoCambio: [{value: '3.36', disabled: true}],
      montoTotal: ['', Validators.required],
      nComprobante: ['', Validators.required],
      archivoAdjunto: ['', Validators.required],
      observaciones: ['']
    });
    
    // Formulario de solicitar reposición
    this.reposicionSolicitudForm = this.formBuilder.group({
      tipoFondo: ['', Validators.required],
      caja: ['', Validators.required],
      montoSolicitado: ['', Validators.required],
      responsable: ['', Validators.required],
      observaciones: ['']
    });
    
    // Formulario de registrar reposición
    this.reposicionRegistroForm = this.formBuilder.group({
      tipoFondo: ['', Validators.required],
      caja: ['', Validators.required],
      montoRepuesto: ['', Validators.required],
      nComprobante: ['', Validators.required],
      archivoAdjunto: ['', Validators.required],
      observaciones: ['']
    });
    
    // Formulario de cerrar fondo
    this.cerrarFondoForm = this.formBuilder.group({
      tipoFondo: ['', Validators.required],
      caja: ['', Validators.required],
      responsable: ['', Validators.required],
      motivoCierre: ['', Validators.required]
    });
    
    this.fechaAsignacionSeleccionada = new Date();
    this.fechaMovimientoSeleccionada = undefined;
    
    // Listener para cuando cambie el tipo de fondo
    this.egresoForm.get('tipoFondo')?.valueChanges.subscribe(() => {
      this.actualizarMontosFondo();
    });
    
    // Listener para cuando cambie la caja
    this.egresoForm.get('caja')?.valueChanges.subscribe(() => {
      this.actualizarMontosFondo();
    });
    
    // Inicializar servicio de validación con el formulario por defecto
    this.inicializarValidacionFormulario();
  }
  
  /** Obtiene el formulario activo según tipoFormulario */
  private obtenerFormularioActivo(): FormGroup {
    switch (this.tipoFormulario) {
      case 'solicitar': return this.reposicionSolicitudForm;
      case 'registrar': return this.reposicionRegistroForm;
      case 'cerrar': return this.cerrarFondoForm;
      default: return this.egresoForm;
    }
  }
  
  /** Inicializa el servicio de validación con el formulario activo */
  private inicializarValidacionFormulario(): void {
    this.formValidationService.inicializarFormulario(this.obtenerFormularioActivo());
  }
  
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }
  
  onFirstDataRendered(params: any) {
    params.api.sizeColumnsToFit();
  }
  
  onBtReset() {
    this.facade.cargarMovimientos();
  }
  
  filtrarPorFechas(event: any) {
    // Implementar filtro de fechas
  }
  
  onFechaAsignacionSelected(fecha: Date) {
    this.fechaAsignacionSeleccionada = fecha;
    this.egresoForm.patchValue({ fechaAsignacion: fecha });
  }
  
  onFechaMovimientoSelected(fecha: Date) {
    this.fechaMovimientoSeleccionada = fecha;
    this.egresoForm.patchValue({ fechaMovimiento: fecha });
  }
  
  async onCellClicked(event: any) {
    // Si hace click en la columna de asiento contable, no cargar datos
    if (event.column.getColId() === 'asientoContable') {
      return;
    }
    
    const rowData = event.data;
    if (!rowData) return;
    
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;
    
    // Resetear variables de estado antes de cargar nuevos datos
    this.solicitudEnviada = false;
    this.reposicionProcesada = false;
    this.registroSolicitudEnviada = null;
    
    // Deshabilitar botón derecho si el estado es Cerrado
    this.botonDerechoDisabled = rowData.rem_estado === 'Cerrado' || rowData.rem_estado === 'Repuesto';
    
    // Determinar qué formulario mostrar según el tipo de movimiento
    if (rowData.rem_tipoMovimiento === 'Egreso') {
      this.tipoFormulario = 'egreso';
      this.cargarDatosEgreso(rowData);
    } else if (rowData.rem_tipoMovimiento === 'Reposición') {
      if (rowData.rem_estado === 'Pendiente' || rowData.rem_estado === 'Rechazado') {
        this.tipoFormulario = 'solicitar';
        this.cargarDatosSolicitudReposicion(rowData);
      } else if (rowData.rem_estado === 'Repuesto') {
        this.tipoFormulario = 'registrar';
        this.cargarDatosRegistroReposicion(rowData);
      }
    } else if (rowData.rem_tipoMovimiento === 'Cierre') {
      this.tipoFormulario = 'cerrar';
      this.cargarDatosCerrarFondo(rowData);
    }
    
    // Re-inicializar validación con el nuevo formulario activo
    this.inicializarValidacionFormulario();
  }
  
  // Método llamado por VistaCellRenderComponent al hacer clic en el ojo
  abrirModal(value: string, rowData: any) {
    this.filaSeleccionada = rowData;
    this.verAsientoContable();
  }
  
  // Actualizar montos cuando se selecciona caja y tipo de fondo
  actualizarMontosFondo() {
    const caja = this.egresoForm.get('caja')?.value;
    const tipoFondo = this.egresoForm.get('tipoFondo')?.value;
    
    if (caja && tipoFondo && this.fondosPorCaja[caja] && this.fondosPorCaja[caja][tipoFondo]) {
      const info = this.fondosPorCaja[caja][tipoFondo];
      this.egresoForm.patchValue({
        montoDisponible: this.formatearMonto(info.montoDisponible, 'Soles'),
        montoMaximo: this.formatearMonto(info.montoMaximo, 'Soles')
      });
    } else {
      this.egresoForm.patchValue({
        montoDisponible: '',
        montoMaximo: ''
      });
    }
  }
  
  // Métodos para cargar datos en formularios
  cargarDatosEgreso(data: RegistroEgresoMenorEntity) {
    this.egresoForm.enable();
    this.codigoSeleccionado = data.rem_codigo;
    const fechaParts = data.rem_fecha.split('/');
    const fecha = new Date(parseInt(fechaParts[2]), parseInt(fechaParts[1]) - 1, parseInt(fechaParts[0]));
    
    this.fechaMovimientoSeleccionada = fecha;
    
    this.egresoForm.patchValue({
      caja: data.rem_caja,
      responsableCaja: data.rem_responsableCaja,
      tipoFondo: data.rem_tipoFondo,
      responsable: data.rem_responsable,
      categoriaGasto: data.rem_categoria,
      descripcion: data.rem_descripcion,
      moneda: data.rem_moneda,
      montoTotal: data.rem_montoAsignado,
      nComprobante: data.rem_nComprobante,
      archivoAdjunto: data.rem_archivoAdjunto,
      observaciones: data.rem_observaciones
    }, { emitEvent: false });
    this.actualizarMontosFondo();
    this.formValidationService.resetearEstado();
  }
  
  cargarDatosSolicitudReposicion(data: RegistroEgresoMenorEntity) {
    this.reposicionSolicitudForm.enable();
    this.codigoSeleccionado = data.rem_codigo;
    this.reposicionSolicitudForm.patchValue({
      tipoFondo: data.rem_tipoFondo,
      caja: data.rem_caja,
      montoSolicitado: data.rem_montoAsignado,
      responsable: data.rem_responsable
    });
    
    if (data.rem_estado === 'Pendiente') {
      this.solicitudEnviada = true;
      this.reposicionProcesada = false;
      this.registroSolicitudEnviada = data;
      this.reposicionSolicitudForm.disable();
    } else if (data.rem_estado === 'Rechazado') {
      this.solicitudEnviada = true;
      this.reposicionProcesada = true;
      this.registroSolicitudEnviada = data;
      this.reposicionSolicitudForm.disable();
    }
    this.formValidationService.resetearEstado();
  }
  
  cargarDatosRegistroReposicion(data: RegistroEgresoMenorEntity) {
    this.reposicionRegistroForm.enable();
    this.codigoSeleccionado = data.rem_codigo;
    this.reposicionRegistroForm.patchValue({
      tipoFondo: data.rem_tipoFondo,
      caja: data.rem_caja,
      montoRepuesto: data.rem_montoAsignado,
      nComprobante: data.rem_nComprobante,
      archivoAdjunto: data.rem_archivoAdjunto,
      observaciones: data.rem_observaciones
    });
    this.formValidationService.resetearEstado();
  }
  
  cargarDatosCerrarFondo(data: RegistroEgresoMenorEntity) {
    this.cerrarFondoForm.enable();
    this.codigoSeleccionado = data.rem_codigo;
    this.cerrarFondoForm.patchValue({
      tipoFondo: data.rem_tipoFondo,
      caja: data.rem_caja,
      responsable: data.rem_responsable,
      motivoCierre: data.rem_motivoCierre
    });
    this.formValidationService.resetearEstado();
  }
  
  // Acciones del menú
  async accionNuevoEgreso() {
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;
    
    this.tipoFormulario = 'egreso';
    this.codigoSeleccionado = '';
    this.egresoForm.reset();
    this.fechaAsignacionSeleccionada = new Date();
    this.fechaMovimientoSeleccionada = undefined;
    this.gridApi.deselectAll();
    this.inicializarValidacionFormulario();
  }
  
  async accionSolicitarReposicion() {
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;
    
    this.tipoFormulario = 'solicitar';
    this.codigoSeleccionado = '';
    this.solicitudEnviada = false;
    this.reposicionProcesada = false;
    this.registroSolicitudEnviada = null;
    this.reposicionSolicitudForm.reset();
    this.reposicionSolicitudForm.enable();
    this.gridApi.deselectAll();
    this.inicializarValidacionFormulario();
  }
  
  async accionRegistrarReposicion() {
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;
    
    this.tipoFormulario = 'registrar';
    this.codigoSeleccionado = '';
    this.reposicionRegistroForm.reset();
    this.gridApi.deselectAll();
    this.inicializarValidacionFormulario();
  }
  
  async accionCerrarFondo() {
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;
    
    this.tipoFormulario = 'cerrar';
    this.codigoSeleccionado = '';
    this.cerrarFondoForm.reset();
    this.gridApi.deselectAll();
    this.inicializarValidacionFormulario();
  }
  
  // Métodos de botones
  botonRegistrar() {
    if (this.egresoForm.invalid) {
      this.toastService.danger('Por favor, complete todos los campos requeridos.');
      return;
    }
    
    const esNuevo = !this.codigoSeleccionado;
    const anioActual = new Date().getFullYear();
    const numeroAsiento = Math.floor(Math.random() * 9000) + 1000;
    
    if (esNuevo) {
      // Nuevo registro: crear y limpiar formulario
      const nuevoRegistro: RegistroEgresoMenorEntity = {
        rem_codigo: 'EG-' + String(Math.floor(Math.random() * 90000) + 10000),
        rem_tipoFondo: this.egresoForm.value.tipoFondo,
        rem_caja: this.egresoForm.value.caja,
        rem_responsableCaja: this.egresoForm.value.responsableCaja,
        rem_responsable: this.egresoForm.value.responsable,
        rem_fecha: this.formatearFecha(this.fechaMovimientoSeleccionada!),
        rem_tipoMovimiento: 'Egreso',
        rem_categoria: this.egresoForm.value.categoriaGasto,
        rem_descripcion: this.egresoForm.value.descripcion,
        rem_montoAsignado: this.egresoForm.value.montoTotal,
        rem_moneda: this.egresoForm.value.moneda,
        rem_nComprobante: this.egresoForm.value.nComprobante,
        rem_archivoAdjunto: this.egresoForm.value.archivoAdjunto,
        rem_observaciones: this.egresoForm.value.observaciones,
        rem_asientoContable: `MN-${anioActual}-${numeroAsiento}`,
        rem_estado: 'Aprobado'
      };
      
      this.rowData = [nuevoRegistro, ...this.rowData];
      this.gridApi.setGridOption('rowData', this.rowData);
      
      this.toastService.success('¡Egreso menor registrado exitosamente!');
      this.codigoSeleccionado = '';
      this.egresoForm.reset();
      this.fechaAsignacionSeleccionada = new Date();
      this.fechaMovimientoSeleccionada = undefined;
      this.gridApi.deselectAll();
      this.formValidationService.resetearEstado();
    } else {
      // Edición: actualizar registro existente y mantener selección
      const index = this.rowData.findIndex(r => r.rem_codigo === this.codigoSeleccionado);
      if (index !== -1) {
        this.rowData[index] = {
          ...this.rowData[index],
          rem_tipoFondo: this.egresoForm.value.tipoFondo,
          rem_caja: this.egresoForm.value.caja,
          rem_responsableCaja: this.egresoForm.value.responsableCaja,
          rem_responsable: this.egresoForm.value.responsable,
          rem_fecha: this.formatearFecha(this.fechaMovimientoSeleccionada!),
          rem_categoria: this.egresoForm.value.categoriaGasto,
          rem_descripcion: this.egresoForm.value.descripcion,
          rem_montoAsignado: this.egresoForm.value.montoTotal,
          rem_moneda: this.egresoForm.value.moneda,
          rem_nComprobante: this.egresoForm.value.nComprobante,
          rem_archivoAdjunto: this.egresoForm.value.archivoAdjunto,
          rem_observaciones: this.egresoForm.value.observaciones,
        };
        this.gridApi.setGridOption('rowData', this.rowData);
      }
      
      this.toastService.success('¡Egreso menor actualizado exitosamente!');
      this.formValidationService.resetearEstado();
      
      // Mantener la fila seleccionada
      const codigo = this.codigoSeleccionado;
      setTimeout(() => {
        this.gridApi.forEachNode((node) => {
          if (node.data.rem_codigo === codigo) {
            node.setSelected(true);
          }
        });
      }, 100);
    }
  }
  
  botonEnviarSolicitud() {
    if (this.reposicionSolicitudForm.invalid) {
      this.toastService.danger('Por favor, complete todos los campos requeridos.');
      return;
    }
    
    const nuevoRegistro: RegistroEgresoMenorEntity = {
      rem_codigo: 'EG-' + String(Math.floor(Math.random() * 90000) + 10000),
      rem_tipoFondo: this.reposicionSolicitudForm.value.tipoFondo,
      rem_caja: this.reposicionSolicitudForm.value.caja,
      rem_responsable: this.reposicionSolicitudForm.value.responsable,
      rem_fecha: this.formatearFecha(new Date()),
      rem_tipoMovimiento: 'Reposición',
      rem_categoria: '-',
      rem_montoAsignado: this.reposicionSolicitudForm.value.montoSolicitado,
      rem_moneda: 'Soles',
      rem_asientoContable: '',
      rem_estado: 'Pendiente'
    };
    
    this.rowData = [nuevoRegistro, ...this.rowData];
    this.gridApi.setGridOption('rowData', this.rowData);
    
    this.registroSolicitudEnviada = nuevoRegistro;
    this.solicitudEnviada = true;
    this.codigoSeleccionado = nuevoRegistro.rem_codigo;
    this.reposicionSolicitudForm.disable();
    this.formValidationService.resetearEstado();
    
    // Seleccionar la fila recién creada
    setTimeout(() => {
      this.gridApi.forEachNode((node) => {
        if (node.data.rem_codigo === nuevoRegistro.rem_codigo) {
          node.setSelected(true);
        }
      });
    }, 100);
    
    this.toastService.success('¡Solicitud de reposición enviada exitosamente!');
  }
  
  botonRegistrarReposicion() {
    if (this.reposicionRegistroForm.invalid) {
      this.toastService.danger('Por favor, complete todos los campos requeridos.');
      return;
    }
    
    const anioActual = new Date().getFullYear();
    const numeroAsiento = Math.floor(Math.random() * 9000) + 1000;
    
    const nuevoRegistro: RegistroEgresoMenorEntity = {
      rem_codigo: 'EG-' + String(Math.floor(Math.random() * 90000) + 10000),
      rem_tipoFondo: this.reposicionRegistroForm.value.tipoFondo,
      rem_caja: this.reposicionRegistroForm.value.caja,
      rem_responsable: '-',
      rem_fecha: this.formatearFecha(new Date()),
      rem_tipoMovimiento: 'Reposición',
      rem_categoria: '-',
      rem_montoAsignado: this.reposicionRegistroForm.value.montoRepuesto,
      rem_moneda: 'Soles',
      rem_nComprobante: this.reposicionRegistroForm.value.nComprobante,
      rem_archivoAdjunto: this.reposicionRegistroForm.value.archivoAdjunto,
      rem_observaciones: this.reposicionRegistroForm.value.observaciones,
      rem_asientoContable: `MN-${anioActual}-${numeroAsiento}`,
      rem_estado: 'Repuesto'
    };
    
    this.rowData = [nuevoRegistro, ...this.rowData];
    this.gridApi.setGridOption('rowData', this.rowData);
    
    this.toastService.success('¡Reposición registrada exitosamente!');
    this.codigoSeleccionado = nuevoRegistro.rem_codigo;
    this.reposicionRegistroForm.reset();
    this.formValidationService.resetearEstado();
    
    // Seleccionar la fila recién creada
    // setTimeout(() => {
    //   this.gridApi.forEachNode((node) => {
    //     if (node.data.rem_codigo === nuevoRegistro.rem_codigo) {
    //       node.setSelected(true);
    //     }
    //   });
    // }, 100);
  }
  
  botonCerrarFondo() {
    if (this.cerrarFondoForm.invalid) {
      this.toastService.danger('Por favor, complete todos los campos requeridos.');
      return;
    }
    
    const nuevoRegistro: RegistroEgresoMenorEntity = {
      rem_codigo: 'EG-' + String(Math.floor(Math.random() * 90000) + 10000),
      rem_tipoFondo: this.cerrarFondoForm.value.tipoFondo,
      rem_caja: this.cerrarFondoForm.value.caja,
      rem_responsable: this.cerrarFondoForm.value.responsable,
      rem_fecha: this.formatearFecha(new Date()),
      rem_tipoMovimiento: 'Cierre',
      rem_categoria: '-',
      rem_montoAsignado: 0,
      rem_moneda: 'Soles',
      rem_motivoCierre: this.cerrarFondoForm.value.motivoCierre,
      rem_asientoContable: '',
      rem_estado: 'Cerrado'
    };
    
    this.rowData = [nuevoRegistro, ...this.rowData];
    this.gridApi.setGridOption('rowData', this.rowData);
    
    this.toastService.success('¡Fondo cerrado exitosamente!');
    this.codigoSeleccionado = nuevoRegistro.rem_codigo;
    this.cerrarFondoForm.reset();
    this.formValidationService.resetearEstado();
    
    // Seleccionar la fila recién creada
    // setTimeout(() => {
    //   this.gridApi.forEachNode((node) => {
    //     if (node.data.rem_codigo === nuevoRegistro.rem_codigo) {
    //       node.setSelected(true);
    //     }
    //   });
    // }, 100);
  }
  
  botonRechazar() {
    this.abrirModalRechazar();
  }

  async abrirModalRechazar() {
    if (!this.registroSolicitudEnviada) return;

    const detallesEjemplo = [
      { label: 'Tipo de fondo', value: this.registroSolicitudEnviada.rem_tipoFondo },
      { label: 'Caja', value: this.registroSolicitudEnviada.rem_caja || '-' },
      { label: 'Monto solicitado', value: this.formatearMonto(this.registroSolicitudEnviada.rem_montoAsignado, 'Soles') },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Rechazar solicitud',
        subtitulomodal: 'Detalle de solicitud',
        detalles: detallesEjemplo,
        widthModal: '522px',
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Rechazar',
        colorBotonConfirmar: 'danger',
        motivoObligatorio: true,
        tituloTextarea: 'Motivo de rechazo'
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      if (this.registroSolicitudEnviada) {
        const codigoRechazado = this.registroSolicitudEnviada.rem_codigo;
        this.registroSolicitudEnviada.rem_estado = 'Rechazado';
        this.gridApi.setGridOption('rowData', this.rowData);
        
        // Mantener la fila seleccionada después del rechazo
        this.codigoSeleccionado = codigoRechazado;
        this.solicitudEnviada = true;
        this.reposicionProcesada = true;
        this.registroSolicitudEnviada.rem_estado = 'Rechazado';
        
        // Mantener el formulario deshabilitado con los datos cargados
        this.reposicionSolicitudForm.disable();
        
        // Seleccionar la fila rechazada
        setTimeout(() => {
          this.gridApi.forEachNode((node) => {
            if (node.data.rem_codigo === codigoRechazado) {
              node.setSelected(true);
            }
          });
        }, 100);
        
        this.toastService.success('¡La acción se realizó con éxito!');
      }
    }
  }
  
  botonReponer() {
    if (this.registroSolicitudEnviada) {
      // Cambiar el estado de Pendiente a Repuesto
      this.registroSolicitudEnviada.rem_estado = 'Repuesto';
      
      // Actualizar la tabla
      this.gridApi.setGridOption('rowData', this.rowData);
      
      // Marcar que la reposición ya fue procesada
      this.reposicionProcesada = true;
      
      // No resetear el formulario ni cambiar solicitudEnviada
      // El formulario permanece con los datos y los botones deshabilitados
      // La fila permanece seleccionada
      
      this.toastService.success('¡Solicitud repuesta exitosamente!');
    }
  }
  
  async modalverActualizaciones() {
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 150 },
      { headerName: 'Usuario', field: 'usuario', width: 120 },
      { headerName: 'Acción', field: 'accion', width: 150 },
      {  headerClass:'centrarencabezado', headerName: 'Detalle del cambio',
         cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center'},
         field: 'detalleCambio', flex: 1 },
    ];
    
    const rowData = [
      { fechaHora: '16/01/2025 10:30', usuario: 'Eduardo Jimenez', accion: 'Creación', detalleCambio: 'Se registró el egreso menor' },
      { fechaHora: '16/01/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se aprobó el egreso' },
    ];
    
    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de actualizaciones del  egreso ${this.codigoSeleccionado}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });
    
    await modal.present();
  }
  
  formatearFecha(fecha: Date): string {
    const dia = String(fecha.getDate()).padStart(2, '0');
    const mes = String(fecha.getMonth() + 1).padStart(2, '0');
    const anio = fecha.getFullYear();
    return `${dia}/${mes}/${anio}`;
  }
  
  formatearMonto(monto: number, moneda: string): string {
    const simbolo = moneda === 'Soles' ? 'S/' : '$';
    const montoFormateado = new Intl.NumberFormat('es-PE', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    }).format(monto);
    return `${simbolo} ${montoFormateado}`;
  }

    async verAsientoContable() {
  
      const colDefs: ColDef[] = [
        { field: 'cuentaContable', headerName: 'Cuenta Contable', width: 120 },
        { field: 'descripcion', headerName: 'Descripción', flex: 1 },
        { field: 'debe', headerName: 'Debe (S/)', width: 100, headerClass: 'centrarencabezado', cellStyle: { textAlign: 'right' } },
        { field: 'haber', headerName: 'Haber (S/)', width: 100, headerClass: 'centrarencabezado', cellStyle: { textAlign: 'right' } },
      ];
      
      const rowData = [
        { cuentaContable: '421101', descripcion: 'Proveedores nacionales', debe: '-', haber: '5,500.00' },
        { cuentaContable: '101101', descripcion: 'Caja y Bancos – Interbank', debe: '5,500.00', haber: '-' },
      ];
  
      const detalles = [
        { label: 'Fecha de registro', value: '05/11/2025' },
        { label: 'Origen', value: 'Tesorería' },
        { label: 'Sucursal', value: 'Sucursal Principal' },
        { label: 'Estado', value: 'Registrado' },
        { label: 'Total Debe (S/)', value: '5,500.00' },
        { label: 'Total Haber (S/)', value: '5,500.00' },
      ];
  
      const modal = await this.modalController.create({
        component: ModalDetalleComponent,
        cssClass: 'promo',
        componentProps: {
          tituloModal: `Información del asiento contable ${this.filaSeleccionada.rem_asientoContable}`,
          subtitulomodal: 'Detalle del asiento',
          detalles: detalles,
          mostrarTabla: true,
          colDefs: colDefs,
          rowData: rowData,
          mostrarTextarea: false,
          mostrarBotonEliminar: false,
          textoBotonCancelar: 'Cerrar',
        }
      });
  
      await modal.present();
    }
}
