import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { FrecuenciaCalendariosEntity } from 'src/app/modules/rrhh/domain/models/frecuencia-calendarios.entity';

// Font Awesome Icons
import { faBook, faCalendar, faInfoCircle, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-p-frecuencia-calendarios',
  templateUrl: './p-frecuencia-calendarios.component.html',
  styleUrls: ['./p-frecuencia-calendarios.component.scss'],
  standalone: false,
})
export class PFrecuenciaCalendariosComponent  implements OnInit {
  // Facade
  private readonly rrHhFacade = inject(RrHhFacade);

  // Señal de carga y flag de reset
  readonly isLoading = this.rrHhFacade.loadingFrecuenciaCalendarios;
  isResetting = false;
  // Font Awesome Icons
  farBook = faBook;
  farCalendar = faCalendar;
  farInfoCircle = faInfoCircle;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  private gridApi!: GridApi;
  
  mostrarpanelizquierdo: boolean = true;
  
  // Control del modo del formulario
  modoFormulario: 'creacion' | 'edicion' | 'visualizacion' = 'creacion';
  registroSeleccionado: any = null;
  
  // Fechas para configuración Mensual
  mensualFechaInicio: Date | null = null;
  mensualFechaFin: Date | null = null;
  mensualDiaPago: Date | null = null;

  // Fechas para configuración Semanal (4 semanas)
  semanalSemana1 = { inicio: null as Date | null, fin: null as Date | null, pago: null as Date | null };
  semanalSemana2 = { inicio: null as Date | null, fin: null as Date | null, pago: null as Date | null };
  semanalSemana3 = { inicio: null as Date | null, fin: null as Date | null, pago: null as Date | null };
  semanalSemana4 = { inicio: null as Date | null, fin: null as Date | null, pago: null as Date | null };

  // Fechas para configuración Quincenal (2 quincenas)
  quincenalQuincena1 = { inicio: null as Date | null, fin: null as Date | null, pago: null as Date | null };
  quincenalQuincena2 = { inicio: null as Date | null, fin: null as Date | null, pago: null as Date | null };
  
  frecuenciasPago = [
    { value: 'Semanal', label: 'Semanal' },
    { value: 'Quincenal', label: 'Quincenal' },
    { value: 'Mensual', label: 'Mensual' },
    { value: 'Personalizado', label: 'Personalizado' }
  ];
  
  // Configuración del calendario de rango
  startDate: Date = new Date(new Date().getFullYear(), new Date().getMonth(), 1);
  endDate: Date = new Date();
  minDate: Date = new Date(2020, 0, 1);
  maxDate: Date = new Date();

  // Configuración de AG-Grid
  columnDefs: any[] = [
    { headerName: 'Código', field: 'frecuencia_calendario_codigo', flex: 1, sortable: true, filter: true },
    { headerName: 'Nombre',  field: 'frecuencia_calendario_nombre', flex: 2, sortable: true, filter: true
    },
    { headerName: 'Frecuencia de pago', field: 'frecuencia_calendario_frecuencia_pago', flex: 1, sortable: true, filter: true },
    { headerName: 'Regla de pago', field: 'frecuencia_calendario_regla_pago', flex: 1, sortable: true, filter: true },
    { 
      headerClass:'centrarencabezado',
      headerName: 'Estado', 
      field: 'frecuencia_calendario_estado',
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
      }];

  rowData: FrecuenciaCalendariosEntity[] = [];

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
      nombreConfiguracion: [''],
      frecuenciaPagoSeleccionada: [''],
      reglaPagoFeriado: [''],
      estadoPago: [''],
      periodoMes: [null],
      periodoAnio: [null]
    });
  }

  ngOnInit() {
    this.formValidationService.inicializarFormulario(this.configForm);
    this.formValidationService.resetearEstado();

    // Cargar datos desde el JSON
    this.rrHhFacade.cargarFrecuenciaCalendarios();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.frecuenciaCalendarios();
        clearInterval(interval);
      }
    }, 100);
  }
  
  onBtReset() {
    this.isResetting = true;
    this.rrHhFacade.cargarFrecuenciaCalendarios();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.frecuenciaCalendarios();
        this.isResetting = false;
        clearInterval(interval);
      }
    }, 100);
  }

  /**
   * Verifica si todos los campos obligatorios están completos
   */
  get frecuenciaPagoSeleccionada(): string {
    return this.configForm.get('frecuenciaPagoSeleccionada')?.value || '';
  }

  get nombreConfiguracion(): string {
    return this.configForm.get('nombreConfiguracion')?.value || '';
  }

  get estadoPago(): string {
    return this.configForm.get('estadoPago')?.value || '';
  }

  get reglaPagoFeriado(): string {
    return this.configForm.get('reglaPagoFeriado')?.value || '';
  }

  get periodoMes(): number | null {
    return this.configForm.get('periodoMes')?.value;
  }

  get periodoAnio(): number | null {
    return this.configForm.get('periodoAnio')?.value;
  }

  get formularioCompleto(): boolean {
    const v = this.configForm.value;
    return !!(v.nombreConfiguracion && 
              v.frecuenciaPagoSeleccionada && 
              v.estadoPago && 
              v.reglaPagoFeriado &&
              v.periodoMes && 
              v.periodoAnio);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }
  
  /**
   * Maneja la selección de una fila en la tabla
   */
  async onCellClicked(event: any) {
    const data = event.data;
    
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      if (this.gridApi) {
        this.gridApi.deselectAll();
        if (this.registroSeleccionado) {
          this.gridApi.forEachNode((node) => {
            if (node.data.frecuencia_calendario_codigo === this.registroSeleccionado?.frecuencia_calendario_codigo) {
              node.setSelected(true);
            }
          });
        }
      }
      return;
    }
    
    this.cargarDatosEnFormulario(data);
  }
  
  /**
   * Carga los datos de una fila seleccionada en el formulario
   */
  cargarDatosEnFormulario(fila: any) {
    this.registroSeleccionado = fila;
    this.modoFormulario = 'edicion';
    
    // Mapear regla de pago (de texto a valor)
    const reglaPago = fila.frecuencia_calendario_regla_pago || '';
    let reglaPagoValor = 'anterior';
    if (reglaPago.includes('anterior')) {
      reglaPagoValor = 'anterior';
    } else if (reglaPago.includes('posterior')) {
      reglaPagoValor = 'posterior';
    } else if (reglaPago.includes('Mantener') || reglaPago.includes('mantener')) {
      reglaPagoValor = 'mantener';
    }
    
    this.configForm.patchValue({
      nombreConfiguracion: fila.frecuencia_calendario_nombre || '',
      estadoPago: fila.frecuencia_calendario_estado || '',
      frecuenciaPagoSeleccionada: fila.frecuencia_calendario_frecuencia_pago || '',
      reglaPagoFeriado: reglaPagoValor,
      periodoMes: 1,
      periodoAnio: 2026
    });
    
    // Generar fechas según la frecuencia
    if (this.frecuenciaPagoSeleccionada && this.frecuenciaPagoSeleccionada !== 'Personalizado') {
      this.generarFechasAutomaticas();
    }
    
    // Resetear servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }
  
  /**
   * Maneja el cambio de periodo desde el month-year-picker
   */
  onPeriodoChange(event: {month: number, year: number}) {
    this.configForm.patchValue({
      periodoMes: event.month,
      periodoAnio: event.year
    });
    
    // Si ya hay una frecuencia seleccionada, regenerar las fechas
    if (this.frecuenciaPagoSeleccionada && this.frecuenciaPagoSeleccionada !== 'Personalizado') {
      this.generarFechasAutomaticas();
    }
  }
  
  /**
   * Maneja el cambio de frecuencia de pago y genera fechas automáticas
   */
  onFrecuenciaChange() {
    if (this.frecuenciaPagoSeleccionada === 'Personalizado') {
      // No generar fechas para personalizado
      this.limpiarFechas();
      return;
    }
    
    // Solo generar fechas si ya se seleccionó un periodo
    if (this.periodoMes && this.periodoAnio) {
      this.generarFechasAutomaticas();
    }
  }
  
  /**
   * Genera fechas automáticas según el periodo y frecuencia seleccionada
   */
  generarFechasAutomaticas() {
    if (!this.periodoMes || !this.periodoAnio) return;
    
    const año = this.periodoAnio;
    const mes = this.periodoMes - 1; // Los meses en Date van de 0-11
    
    // Usar setTimeout para asegurar que la vista se actualice
    setTimeout(() => {
      switch (this.frecuenciaPagoSeleccionada) {
        case 'Mensual':
          this.generarFechasMensual(año, mes);
          break;
        case 'Quincenal':
          this.generarFechasQuincenal(año, mes);
          break;
        case 'Semanal':
          this.generarFechasSemanal(año, mes);
          break;
      }
    }, 100);
  }
  
  /**
   * Genera fechas para frecuencia mensual
   */
  generarFechasMensual(año: number, mes: number) {
    // Primer día del mes
    this.mensualFechaInicio = new Date(año, mes, 1);
    
    // Último día del mes
    this.mensualFechaFin = new Date(año, mes + 1, 0);
    
    // Día de pago: último día del mes
    this.mensualDiaPago = new Date(año, mes + 1, 0);

  }
  
  /**
   * Genera fechas para frecuencia quincenal
   */
  generarFechasQuincenal(año: number, mes: number) {
    // Primera quincena: del 1 al 15
    this.quincenalQuincena1.inicio = new Date(año, mes, 1);
    this.quincenalQuincena1.fin = new Date(año, mes, 15);
    this.quincenalQuincena1.pago = new Date(año, mes, 15);

    // Segunda quincena: del 16 al último día
    const ultimoDia = new Date(año, mes + 1, 0).getDate();
    this.quincenalQuincena2.inicio = new Date(año, mes, 16);
    this.quincenalQuincena2.fin = new Date(año, mes + 1, 0);
    this.quincenalQuincena2.pago = new Date(año, mes, ultimoDia);
    
  }
  
  /**
   * Genera fechas para frecuencia semanal (4 semanas)
   */
  generarFechasSemanal(año: number, mes: number) {
    const ultimoDia = new Date(año, mes + 1, 0).getDate();
    let diaActual = 1;

    // Semana 1
    this.semanalSemana1.inicio = new Date(año, mes, diaActual);
    diaActual = Math.min(diaActual + 6, ultimoDia);
    this.semanalSemana1.fin = new Date(año, mes, diaActual);
    this.semanalSemana1.pago = new Date(año, mes, diaActual);
    diaActual++;

    // Semana 2
    if (diaActual <= ultimoDia) {
      this.semanalSemana2.inicio = new Date(año, mes, diaActual);
      diaActual = Math.min(diaActual + 6, ultimoDia);
      this.semanalSemana2.fin = new Date(año, mes, diaActual);
      this.semanalSemana2.pago = new Date(año, mes, diaActual);
      diaActual++;
    }

    // Semana 3
    if (diaActual <= ultimoDia) {
      this.semanalSemana3.inicio = new Date(año, mes, diaActual);
      diaActual = Math.min(diaActual + 6, ultimoDia);
      this.semanalSemana3.fin = new Date(año, mes, diaActual);
      this.semanalSemana3.pago = new Date(año, mes, diaActual);
      diaActual++;
    }

    // Semana 4
    if (diaActual <= ultimoDia) {
      this.semanalSemana4.inicio = new Date(año, mes, diaActual);
      this.semanalSemana4.fin = new Date(año, mes, ultimoDia);
      this.semanalSemana4.pago = new Date(año, mes, ultimoDia);
    }
    
  }
  
  /**
   * Limpia todas las fechas generadas
   */
  limpiarFechas() {
    this.mensualFechaInicio = null;
    this.mensualFechaFin = null;
    this.mensualDiaPago = null;
    
    this.semanalSemana1 = { inicio: null, fin: null, pago: null };
    this.semanalSemana2 = { inicio: null, fin: null, pago: null };
    this.semanalSemana3 = { inicio: null, fin: null, pago: null };
    this.semanalSemana4 = { inicio: null, fin: null, pago: null };
    
    this.quincenalQuincena1 = { inicio: null, fin: null, pago: null };
    this.quincenalQuincena2 = { inicio: null, fin: null, pago: null };
  }
  
  /**
   * Limpia todo el formulario completo
   */
  limpiarFormulario() {
    // Limpiar fechas
    this.limpiarFechas();
    
    // Deseleccionar todas las filas de la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Resetear modo
    this.modoFormulario = 'creacion';
    this.registroSeleccionado = null;

    // Resetear el formulario reactivo
    this.configForm.reset({
      nombreConfiguracion: '',
      frecuenciaPagoSeleccionada: '',
      reglaPagoFeriado: '',
      estadoPago: 'Activo',
      periodoMes: null,
      periodoAnio: null
    });
  }
  
  /**
   * Inicia el modo de creación de una nueva configuración
   */
  async nuevaConfiguracion() {
    // Verificar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) {
      return;
    }
    
    this.limpiarFormulario();
    this.modoFormulario = 'creacion';
    this.formValidationService.resetearEstado();
  }
  
  registrar(){
    if(!this.formularioCompleto){
      this.toastService.warning('Por favor, completa todos los campos obligatorios');
      return;
    }
    
    // Generar código automático para el nuevo registro
    const numeroRegistro = this.rowData.length + 1;
    const codigoNuevo = `NOM-${numeroRegistro.toString().padStart(3, '0')}`;
    
    // Mapear el valor de la regla de pago a texto descriptivo
    let reglaPagoTexto = '';
    switch(this.reglaPagoFeriado) {
      case 'anterior':
        reglaPagoTexto = 'Pagar día hábil anterior';
        break;
      case 'posterior':
        reglaPagoTexto = 'Pagar día hábil posterior';
        break;
      case 'mantener':
        reglaPagoTexto = 'Mantener fecha';
        break;
      default:
        reglaPagoTexto = 'N/A';
    }
    
    // Crear el nuevo registro
    const nuevoRegistro = {
      frecuencia_calendario_codigo: codigoNuevo,
      frecuencia_calendario_nombre: this.nombreConfiguracion,
      frecuencia_calendario_frecuencia_pago: this.frecuenciaPagoSeleccionada,
      frecuencia_calendario_regla_pago: reglaPagoTexto,
      frecuencia_calendario_estado: this.estadoPago
    };
        
    // Agregar al inicio de la tabla
    this.rowData = [nuevoRegistro, ...this.rowData];
        
    this.toastService.success('¡Configuración registrada exitosamente!');
    // Limpiar el formulario después de guardar
    this.limpiarFormulario();
    this.formValidationService.resetearEstado();
  }
  
  guardar() {
    if(!this.formularioCompleto){
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }
    
    if (!this.registroSeleccionado) {
      this.toastService.danger('No hay ningún registro seleccionado para actualizar');
      return;
    }
    
    // Mapear el valor de la regla de pago a texto descriptivo
    let reglaPagoTexto = '';
    switch(this.reglaPagoFeriado) {
      case 'anterior':
        reglaPagoTexto = 'Pagar día hábil anterior';
        break;
      case 'posterior':
        reglaPagoTexto = 'Pagar día hábil posterior';
        break;
      case 'mantener':
        reglaPagoTexto = 'Mantener fecha';
        break;
      default:
        reglaPagoTexto = 'N/A';
    }
    
    // Buscar el índice del registro en el array
    const index = this.rowData.findIndex(row => row.frecuencia_calendario_codigo === this.registroSeleccionado.frecuencia_calendario_codigo);
    
    if (index !== -1) {
      // Actualizar el registro existente manteniendo el código
      this.rowData[index] = {
        frecuencia_calendario_codigo: this.registroSeleccionado.frecuencia_calendario_codigo,
        frecuencia_calendario_nombre: this.nombreConfiguracion,
        frecuencia_calendario_frecuencia_pago: this.frecuenciaPagoSeleccionada,
        frecuencia_calendario_regla_pago: reglaPagoTexto,
        frecuencia_calendario_estado: this.estadoPago
      };
      
      // Forzar actualización de la tabla
      this.rowData = [...this.rowData];
      
      this.toastService.success('¡Cambios guardados exitosamente!');
      // Limpiar el formulario después de guardar
      this.limpiarFormulario();
      this.formValidationService.resetearEstado();
    } else {
      this.toastService.danger('No se pudo encontrar el registro para actualizar');
    }
  }
  
  /**
   * Cancela la edición o creación y limpia el formulario
   */
  async cancelar() {
    // Verificar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) {
      return;
    }
    
    this.limpiarFormulario();
    this.formValidationService.resetearEstado();
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
            { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar',},
            { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385',},
            { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio:   'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380',},
            { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT',},
          ];
      
          const modal = await this.modalController.create({
            component: ModalVerActualizacionesComponent,
            cssClass: 'promo',
            componentProps: {
              titulo: 'Historial de actualizaciones de configuración de nómina NOM-004',
              rowData: rowData,
              colDefs: colDefs,
              anchoModal: '700px',
        
            },
          });
      
          await modal.present();
  }

}
