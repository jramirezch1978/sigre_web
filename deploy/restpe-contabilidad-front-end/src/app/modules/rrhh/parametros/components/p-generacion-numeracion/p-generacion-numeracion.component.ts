import { Component, OnInit, inject } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { GeneracionNumeracionEntity } from 'src/app/modules/rrhh/domain/models/generacion-numeracion.entity';
import { FormBuilder, FormGroup } from '@angular/forms';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-p-generacion-numeracion',
  templateUrl: './p-generacion-numeracion.component.html',
  styleUrls: ['./p-generacion-numeracion.component.scss'],
  standalone: false,
})
export class PGeneracionNumeracionComponent  implements OnInit, CanComponentDeactivate {
  // Facade
  private readonly rrHhFacade = inject(RrHhFacade);

  // Señal de carga y flag de reset
  readonly isLoading = this.rrHhFacade.loadingGeneracionNumeracion;
  isResetting = false;
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  private gridApi!: GridApi;
  filaSeleccionada: any = null;
  botonNuevoHabilitado: boolean = false;
  
  // Arrays de opciones
  tiposDocumento = [
    { value: 'trabajador', label: 'Trabajador' },
    { value: 'liquidacion', label: 'Liquidación' },
    { value: 'boleta', label: 'Boleta del trabajador' },
    { value: 'contrato', label: 'Contrato' },
    { value: 'planilla', label: 'Planilla' },
    { value: 'contrato', label: 'Vacaciones y licencias' },
    { value: 'asistencias', label: 'Asistencias' }
  ];

  opcionesReinicio = [
    { value: 'no_reinicia', label: 'No reinicia' },
    { value: 'anual', label: 'Anual' },
    { value: 'mensual', label: 'Mensual' }
  ];

  estadosRegistro = [
    { value: 'activo', label: 'Activo' },
    { value: 'inactivo', label: 'Inactivo' }
  ];
  
  // Configuración de AG-Grid
  columnDefs: any[] = [
    { headerName: 'Tipo de documento', field: 'generacion_numeracion_tipo_documento', flex: 1, sortable: true, filter: true },
    { headerName: 'Código configurado', field: 'generacion_numeracion_codigo_configurado', flex: 1, sortable: true, filter: true },
    { headerName: 'Reinicio automático', field: 'generacion_numeracion_reinicio_automatico', flex: 1, sortable: true, filter: true },
    { 
      headerClass: 'centrarencabezado',
      headerName: 'Estado', 
      field: 'generacion_numeracion_estado',
      flex: 1,
      sortable: true,
      filter: true,
      cellRenderer: (params: any) => {
        const estado = params.value;
        if (estado === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
        } else if (estado === 'Inactivo') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>';
        }
        return params.value;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center'},
    }
  ];

  rowData: GeneracionNumeracionEntity[] = [];

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

  configForm!: FormGroup;

  constructor(
    private modalController: ModalController,
    private toastService: ToastService,
    private fb: FormBuilder,
    public formValidationService: FormValidationService
  ) { 
    this.configForm = this.fb.group({
      generacion_numeracion_tipo_documento: [''],
      prefijo: [''],
      serie: [''],
      correlativoActual: [null],
      longitudCorrelativo: [null],
      separador: [''],
      generacion_numeracion_reinicio_automatico: [''],
      generacion_numeracion_estado: ['activo'],
      observaciones: ['']
    });
  }

  ngOnInit() {
    this.formValidationService.inicializarFormulario(this.configForm);
    this.formValidationService.resetearEstado();

    // Cargar datos desde el JSON
    this.rrHhFacade.cargarGeneracionNumeracion();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.generacionNumeracion();
        clearInterval(interval);
      }
    }, 100);
  }

  // Getters que leen del FormGroup
  get generacion_numeracion_tipo_documento(): string {
    return this.configForm.get('generacion_numeracion_tipo_documento')?.value || '';
  }
  get prefijo(): string {
    return this.configForm.get('prefijo')?.value || '';
  }
  get serie(): string {
    return this.configForm.get('serie')?.value || '';
  }
  get correlativoActual(): number | null {
    return this.configForm.get('correlativoActual')?.value;
  }
  get longitudCorrelativo(): number | null {
    return this.configForm.get('longitudCorrelativo')?.value;
  }
  get separador(): string {
    return this.configForm.get('separador')?.value || '';
  }
  get generacion_numeracion_reinicio_automatico(): string {
    return this.configForm.get('generacion_numeracion_reinicio_automatico')?.value || '';
  }
  get generacion_numeracion_estado(): string {
    return this.configForm.get('generacion_numeracion_estado')?.value || '';
  }
  get observaciones(): string {
    return this.configForm.get('observaciones')?.value || '';
  }

  guardarValoresIniciales() {}

  detectarCambios() {}

  get formularioValido(): boolean {
    const v = this.configForm.value;
    return Boolean(
      v.generacion_numeracion_tipo_documento &&
      v.prefijo &&
      v.correlativoActual !== null &&
      v.generacion_numeracion_reinicio_automatico &&
      v.generacion_numeracion_estado
    );
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }
  
  async onCellClicked(event: any) {
    if (!event.data) return;
    
    // Validar cambios antes de cambiar de numeración
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló, deseleccionar todo primero
      if (this.gridApi) {
        this.gridApi.deselectAll();
        // Volver a seleccionar la fila anterior si existía
        if (this.filaSeleccionada) {
          this.gridApi.forEachNode((node) => {
            if (node.data.generacion_numeracion_codigo_configurado === this.filaSeleccionada?.generacion_numeracion_codigo_configurado) {
              node.setSelected(true);
            }
          });
        }
      }
      return;
    }

    this.filaSeleccionada = event.data;
    this.botonNuevoHabilitado = true;
    
    // Cargar datos en el formulario
    this.cargarDatosFormulario(this.filaSeleccionada);
    this.formValidationService.resetearEstado();
    
    console.log('Fila seleccionada:', this.filaSeleccionada);
  }
  
  cargarDatosFormulario(data: any) {
    // Mapear el tipo de documento del display a su valor
    const tipoDocMap: any = {
      'Contrato': 'contrato',
      'Planilla': 'planilla',
      'Vacaciones': 'contrato',
      'Boleta': 'boleta',
      'Trabajador': 'trabajador',
      'Liquidación': 'liquidacion',
      'Asistencias': 'asistencias'
    };
    
    // Extraer prefijo y correlativo del código configurado
    const codigoParts = data.generacion_numeracion_codigo_configurado.split('-');
    const serie = codigoParts.length > 2 ? codigoParts.slice(1, -1).join('-') : '';
    const correlativoStr = codigoParts[codigoParts.length - 1] || '';
    
    // Mapear reinicio automático
    const reinicioMap: any = {
      'Anual': 'anual',
      'Mensual': 'mensual',
      'No reinicia': 'no_reinicia'
    };

    this.configForm.patchValue({
      generacion_numeracion_tipo_documento: tipoDocMap[data.generacion_numeracion_tipo_documento] || '',
      prefijo: codigoParts[0] || '',
      serie: serie,
      correlativoActual: parseInt(correlativoStr) || 1,
      longitudCorrelativo: correlativoStr.length || 4,
      separador: '-',
      generacion_numeracion_reinicio_automatico: reinicioMap[data.generacion_numeracion_reinicio_automatico] || '',
      generacion_numeracion_estado: data.generacion_numeracion_estado === 'Activo' ? 'activo' : 'inactivo',
      observaciones: ''
    });
  }
  
  onBtReset() {
    this.isResetting = true;
    this.rrHhFacade.cargarGeneracionNumeracion();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.generacionNumeracion();
        this.isResetting = false;
        clearInterval(interval);
      }
    }, 100);
  }
  guardar(){
    if (!this.formularioValido) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    // Mapear el tipo de documento a su display
    const tipoDocDisplay: any = {
      'trabajador': 'Trabajador',
      'liquidacion': 'Liquidación',
      'boleta': 'Boleta',
      'contrato': 'Contrato',
      'planilla': 'Planilla',
      'asistencias': 'Asistencias'
    };

    // Mapear reinicio automático
    const reinicioDisplay: any = {
      'anual': 'Anual',
      'mensual': 'Mensual',
      'no_reinicia': 'No reinicia'
    };

    // Formatear el correlativo con padding de ceros
    const longitudPadding = this.longitudCorrelativo || 6;
    const correlativoFormateado = String(this.correlativoActual || 0).padStart(longitudPadding, '0');

    // Crear el código configurado con el formato: PREFIJO-SERIE-CORRELATIVO
    let codigoConfigurado = this.prefijo;
    if (this.serie) {
      codigoConfigurado += (this.separador || '-') + this.serie;
    }
    codigoConfigurado += (this.separador || '-') + correlativoFormateado;

    // Crear el nuevo numerador
    const nuevoNumerador = {
      generacion_numeracion_tipo_documento: tipoDocDisplay[this.generacion_numeracion_tipo_documento] || this.generacion_numeracion_tipo_documento,
      generacion_numeracion_codigo_configurado: codigoConfigurado,
      generacion_numeracion_reinicio_automatico: reinicioDisplay[this.generacion_numeracion_reinicio_automatico] || this.generacion_numeracion_reinicio_automatico,
      generacion_numeracion_estado: this.generacion_numeracion_estado === 'activo' ? 'Activo' : 'Inactivo'
    };

    // Agregar al inicio del array
    this.rowData = [nuevoNumerador, ...this.rowData];
    
    // Actualizar la tabla
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }

    // Limpiar formulario
    this.limpiarFormulario();
    this.filaSeleccionada = null;
    this.botonNuevoHabilitado = false;
    this.formValidationService.resetearEstado();
    
    this.toastService.success('¡Numerador registrado con éxito!');
  }

  async nuevoNumerador() {
    // Verificar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) {
      return;
    }

    // Deseleccionar la fila en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Limpiar todos los campos del formulario
    this.filaSeleccionada = null;
    this.botonNuevoHabilitado = false;
    this.limpiarFormulario();
    this.formValidationService.resetearEstado();
    
    console.log('Campos limpiados para nuevo numerador');
  }

  async cancelar() {
    // Deseleccionar la fila INMEDIATAMENTE
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) {
      return; // Cancelar acción, ya está deseleccionado
    }

    // Limpiar el formulario
    this.limpiarFormulario();
    this.filaSeleccionada = null;
    this.botonNuevoHabilitado = false;
    this.formValidationService.resetearEstado();
  }

  // Método requerido por CanComponentDeactivate para detectar navegación
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }
  
  limpiarFormulario() {
    this.configForm.reset({
      generacion_numeracion_tipo_documento: '',
      prefijo: '',
      serie: '',
      correlativoActual: null,
      longitudCorrelativo: null,
      separador: '',
      generacion_numeracion_reinicio_automatico: '',
      generacion_numeracion_estado: 'activo',
      observaciones: ''
    });
  }

  async modalverActualizaciones() {
      // Definir las columnas
      const colDefs = [
        { headerName: 'Fecha y hora', field: 'fechaHora', width: 150, },
        { headerName: 'Usuario', field: 'usuario', width: 120, },
        { headerName: 'Acción', field: 'accion', width: 150, },
        { headerName: 'Detalle del cambio', field: 'detalleCambio', flex: 1,
          wrapText: true,
          autoHeight: true,
          cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' }, 
        },
      ];
  
      // Datos de ejemplo
      const rowData = [
        { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar' },
        { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385' },
        { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380 ' },
        { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT' },
      ];
  
      const defaultColDefModal: ColDef = {
        wrapText: true,
        autoHeight: true,
      };
  
      const modal = await this.modalController.create({
        component: ModalVerActualizacionesComponent,
        cssClass: 'promo',
        componentProps: {
          titulo: 'Historial de Actualizaciones - Numeración automática ',
          rowData: rowData,
          colDefs: colDefs,
          defaultColDef: defaultColDefModal,
          anchoModal: '700px',
        },
      });
  
      await modal.present();
    }
}
