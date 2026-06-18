import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { OperacionFacade } from 'src/app/modules/activos/application/facades/operacion.facade';
import { OperacionFeedbackEffects } from 'src/app/modules/activos/effects/operacion-feedback.effect';
import { OperacionSyncEffects } from 'src/app/modules/activos/effects/operacion-sync.effect';
import { OperacionEntity } from 'src/app/modules/activos/domain/models/operacion.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { SimulationService } from 'src/app/simulation/simulation.service';



@Component({
  selector: 'app-activofijo-tabla-operaciones',
  templateUrl: './activofijo-tabla-operaciones.component.html',
  styleUrls: ['./activofijo-tabla-operaciones.component.scss'],
  standalone: false,
})
export class ActivofijoTablaOperacionesComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  // Inyección del Facade y Effects
  private readonly operacionFacade   = inject(OperacionFacade);
  private readonly operacionFeedback = inject(OperacionFeedbackEffects);
  private readonly operacionSync     = inject(OperacionSyncEffects);
  readonly isLoading                 = this.operacionFacade.isLoading;

  private gridApi!: GridApi;
  camponuevo: boolean = true;
  estadoSeleccionado: string = '';
  OperacionesForm!: FormGroup;
  filaSeleccionada: OperacionEntity | null = null;
  rowData: OperacionEntity[] = [];

  // Array de cuentas contables para el autocomplete
  cuentasContables: { id: string; nombre: string }[] = [];
  private todasLasCuentas: any[] = [];

  centrosCosto = [
    { id: 'RRHH', nombre: 'Recursos Humanos' },
    { id: 'oficina', nombre: 'Oficina Administrativa' },
    { id: 'marketing', nombre: 'Marketing' },
    { id: 'operaciones', nombre: 'Operaciones' },
    { id: 'producción', nombre: 'Área de Producción' },
    { id: 'centrosoporte', nombre: 'Centro de Soporte' }
  ];


  columnTypes = {
    currency: {
      width: 150,
    },
    shaded: {
      cellClass: 'shaded-class'
    }
  };
  defaultColDef = {
    resizable: true,
    flex: 1,
    minWidth: 100,
  };

  // Tipado con OperacionEntity
  colDefs: ColDef<OperacionEntity>[] = [
    { field: 'operacion_codigo',       headerName: 'Código',          headerClass: 'ag-header-hover ag-header-10px', flex: 0.8, minWidth: 80 },
    { field: 'operacion_descripcion',  headerName: 'Descripción',     headerClass: 'ag-header-hover ag-header-10px', flex: 2,   minWidth: 150 },
    { field: 'operacion_naturaleza',   headerName: 'Naturaleza',      headerClass: 'ag-header-hover ag-header-10px', flex: 1,   minWidth: 90 },
    { field: 'operacion_tipo_calculo', headerName: 'Tipo de Cálculo', headerClass: 'ag-header-hover ag-header-10px', flex: 1.2, minWidth: 110 },
    { field: 'operacion_cta_contable', headerName: 'Cuenta Contable', headerClass: 'ag-header-hover ag-header-10px', flex: 1.2, minWidth: 110 },
    {
      field: 'operacion_estado', filter: true,
      headerClass: 'centrarencabezado', headerName: 'Estado', flex: 0.8, minWidth: 80,
      cellRenderer: (params: any) => {
        const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  constructor(
    private formBuilder: FormBuilder,
    private toastservice: ToastService,
    private modalController: ModalController,
    private formValidationService: FormValidationService,
    private simulation: SimulationService,
  ) {
    // Sincronizar store → rowData (Signal effect)
    effect(() => {
      const items = this.operacionFacade.operaciones();
      this.rowData = items;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', items);
      }
    });
  }

  ngOnInit() {
    this.todasLasCuentas = this.simulation.list('plancontable') || [];
    this.cuentasContables = this.todasLasCuentas.map((item) => ({
      id: item.codigo,
      nombre: `${item.codigo} - ${item.descripcion}`,
    }));

    this.OperacionesForm = this.formBuilder.group({
      search: new FormControl(''),
      filtroEstado: new FormControl('todos'),
      codOperacion: new FormControl('', [Validators.required]),
      descripcion: new FormControl('', [Validators.required]),
      naturaleza: new FormControl('Aumento', [Validators.required]),
      tipoCalculo: new FormControl('Depreciación', [Validators.required]),
      metodoCalculo: new FormControl(''),
      ctaContable: new FormControl('', [Validators.required]),
      centroCosto: new FormControl('', [Validators.required]),
      estado: new FormControl('Activo', [Validators.required]),
      afectaContabilidad: new FormControl(false),
      observaciones: new FormControl(''),
      });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.OperacionesForm);

    // Suscribirse a cambios en tipoCalculo para limpiar metodoCalculo
    this.OperacionesForm.get('tipoCalculo')?.valueChanges.subscribe(() => {
      this.OperacionesForm.patchValue({ metodoCalculo: '' }, { emitEvent: false });
    });

    // Cargar datos desde el repositorio
    this.operacionFacade.cargarOperaciones();
  }

  ngOnDestroy(): void {
    this.formValidationService.limpiarFormulario();
  }

  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }
   localeText = {
    page: 'Página',
    of: 'de',
    to: 'a',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    noRowsToShow: 'No hay filas para mostrar',
    loadingOoo: 'Cargando...'
  };

  async onCellClicked(event: any) {
    if (!event.data) return;
    
    // Validar cambios antes de cambiar de operación
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló, deseleccionar todo primero
      if (this.gridApi) {
        this.gridApi.deselectAll();
        // Volver a seleccionar la fila anterior si existía
        if (this.filaSeleccionada) {
          this.gridApi.forEachNode((node) => {
            if (node.data.operacion_codigo === this.filaSeleccionada!.operacion_codigo) {
              node.setSelected(true);
            }
          });
        }
      }
      return;
    }
    
    // Deseleccionar la fila anterior
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Usuario confirmó, aplicar nueva selección
    this.cargarDatosRegistro(event.data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: OperacionEntity, node?: any): void {
    this.camponuevo = false;
    this.filaSeleccionada = data;

    // Seleccionar el nodo en AG-Grid (si no está ya seleccionado)
    if (node && !node.isSelected()) {
      node.setSelected(true);
    }

    // Llenar los campos del formulario con los datos de la fila
    this.OperacionesForm.patchValue({
      codOperacion:       data.operacion_codigo              || '',
      descripcion:        data.operacion_descripcion         || '',
      naturaleza:         data.operacion_naturaleza          || '',
      tipoCalculo:        data.operacion_tipo_calculo        || '',
      metodoCalculo:      data.operacion_metodo_calculo      || '',
      estado:             data.operacion_estado              || '',
      ctaContable:        data.operacion_cta_contable        || '',
      centroCosto:        data.operacion_centro_costo        || '',
      afectaContabilidad: data.operacion_afecta_contabilidad || false,
      observaciones:      data.operacion_observaciones       || ''
    });

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }
  async botonNuevaOperacion(){
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Cancelar acción
    }

    this.camponuevo = true;
    this.filaSeleccionada = null; // Limpiar la fila seleccionada
    this.gridApi?.deselectAll(); // Deseleccionar filas en la tabla
    this.OperacionesForm.reset();
    
    // Generar código automático
    const nuevoCodigo = this.generarNuevoCodigo();
    
    // Solo establecer código automático y estado, los demás quedan con placeholder
    this.OperacionesForm.patchValue({
      codOperacion: nuevoCodigo,
      estado: 'Activo',
      afectaContabilidad: false
    });

    // Resetear estado del servicio de validación
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

    // Pausar detección de cambios mientras se limpia
    this.formValidationService.pausarDeteccion();

    // Reiniciar el formulario
    this.OperacionesForm.reset({
      estado: 'Activo',
      afectaContabilidad: false,
      naturaleza: 'Aumento',
      tipoCalculo: 'Depreciación'
    });

    // Generar código automático
    const nuevocodigo = this.generarNuevoCodigo();
    this.OperacionesForm.patchValue({
      codOperacion: nuevocodigo
    });

    // Limpiar variables
    this.camponuevo = true;
    this.filaSeleccionada = null;

    // Deseleccionar fila de la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Reanudar detección de cambios
    this.formValidationService.reanudarDeteccion();

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }
  botonGuardar() {
    // Validar campos obligatorios
    if (!this.validarCamposObligatorios()) {
      this.toastservice.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    const formValues = this.OperacionesForm.value;

    // Construir entidad
    const entidad: OperacionEntity = {
      operacion_codigo:              this.camponuevo ? this.generarNuevoCodigo() : this.filaSeleccionada!.operacion_codigo,
      operacion_descripcion:         formValues.descripcion,
      operacion_naturaleza:          formValues.naturaleza,
      operacion_tipo_calculo:        formValues.tipoCalculo,
      operacion_metodo_calculo:      formValues.metodoCalculo || '',
      operacion_cta_contable:        formValues.ctaContable,
      operacion_estado:              formValues.estado,
      operacion_centro_costo:        formValues.centroCosto        || '',
      operacion_afecta_contabilidad: formValues.afectaContabilidad || false,
      operacion_observaciones:       formValues.observaciones      || ''
    };

    if (this.camponuevo) {
      this.operacionFacade.guardarOperacion(entidad);
    } else if (this.filaSeleccionada) {
      this.operacionFacade.actualizarOperacion(entidad);
    }

    // Limpiar formulario y resetear estado manteniendo modo creación
    this.OperacionesForm.reset();
    this.OperacionesForm.patchValue({
      naturaleza: 'Aumento',
      tipoCalculo: 'Depreciación',
      estado: 'Activo',
      afectaContabilidad: false
    });
    this.filaSeleccionada = null;
    this.camponuevo = true;

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }
  
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  // Generar código automático para nuevas operaciones
  generarNuevoCodigo(): string {
    const numeros = this.rowData.map(item => {
      const match = item.operacion_codigo.match(/RN-AF-(\d+)/);
      return match ? parseInt(match[1], 10) : 0;
    });
    const maxNumero = Math.max(...numeros, 0);
    const nuevoNumero = (maxNumero + 1).toString().padStart(3, '0');
    return `RN-AF-${nuevoNumero}`;
  }

  onCuentaSeleccionada(cuenta: any) {
    console.log('Cuenta contable seleccionada:', cuenta);
  }

  onCentroCostoSeleccionado(centro: any) {
    console.log('Centro de costo seleccionado:', centro);
  }

  validarCamposObligatorios(): boolean {
    const formValues = this.OperacionesForm.value;
    const tipoCalculo = formValues.tipoCalculo;
    
    // Solo validar campos sin valor por defecto
    const camposObligatorios = 
      formValues.descripcion && 
      formValues.ctaContable && 
      formValues.centroCosto;
    
    if (!camposObligatorios) {
      return false;
    }
    
    // Si el tipo de cálculo es Depreciación o Revaluación, también se requiere metodoCalculo
    if (tipoCalculo === 'Depreciación' || tipoCalculo === 'Revaluación') {
      return !!formValues.metodoCalculo;
    }
    
    return true;
  }

  puedeGuardar(): boolean {
    const formValues = this.OperacionesForm.value;
    const tipoCalculo = formValues.tipoCalculo;
    
    // Solo validar campos sin valor por defecto
    const camposObligatorios = 
      formValues.descripcion && 
      formValues.ctaContable && 
      formValues.centroCosto;
    
    if (!camposObligatorios) {
      return false;
    }
    
    // Si el tipo de cálculo es Depreciación o Revaluación, también se requiere metodoCalculo
    if (tipoCalculo === 'Depreciación' || tipoCalculo === 'Revaluación') {
      if (!formValues.metodoCalculo) {
        return false;
      }
    }
    
    // Si es modo nuevo, solo validar que los campos estén completos
    if (this.camponuevo) {
      return true;
    }
    
    // Si es modo edición, solo habilitar cuando hay cambios
    return this.formValidationService.tieneModificaciones();
  }
  onBtReset() {
    this.operacionFacade.cargarOperaciones();
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
      {
        fechaHora: '21/11/2025 09:00',
        usuario: 'Carlos Zapata',
        accion: 'Creación',
        detalleCambio: 'Registro inicial del tipo de cambio para Dólar'
      },
      {
        fechaHora: '21/11/2025 09:05',
        usuario: 'Carlos Zapata',
        accion: 'Actualización',
        detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385'
      },
      {
        fechaHora: '20/11/2025 08:30',
        usuario: 'Carlos Zapata',
        accion: 'Creación',
        detalleCambio: 'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380'
      },
      {
        fechaHora: '19/11/2025 08:45',
        usuario: 'Carlos Zapata',
        accion: 'Creación',
        detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT'
      }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - ' + (this.filaSeleccionada?.operacion_codigo || ''),
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
       
      }
    });
    
    await modal.present();
  }

}
