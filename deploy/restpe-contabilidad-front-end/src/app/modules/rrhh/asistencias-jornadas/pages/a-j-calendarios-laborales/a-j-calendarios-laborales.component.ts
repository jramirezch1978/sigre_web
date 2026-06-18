import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { RrHhCalendariosLaboralesGridEffects } from 'src/app/modules/rrhh/effects/rr-hh-calendarios-laborales-grid.effect';
import { CalendarioLaboralEntity } from 'src/app/modules/rrhh/domain/models/calendario-laboral.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faGear, faPercent, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { ca, de } from 'date-fns/locale';

@Component({
  selector: 'app-a-j-calendarios-laborales',
  templateUrl: './a-j-calendarios-laborales.component.html',
  styleUrls: ['./a-j-calendarios-laborales.component.scss'],
  standalone: false,
})
export class AJCalendariosLaboralesComponent  implements OnInit, CanComponentDeactivate {
  // Facades y Effects
  private readonly rrHhFacade = inject(RrHhFacade);
  private readonly calendariosGridEffects = inject(RrHhCalendariosLaboralesGridEffects);

  // Selectores del store
  readonly isLoading = this.rrHhFacade.loadingCalendariosLaborales;
  isResetting = false;

  get rowData(): CalendarioLaboralEntity[] {
    return this.calendariosGridEffects.getRowData();
  }

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasGear = faGear;
  fasPercent = faPercent;
  fasRotateRight = faRotateRight;



  private gridApi!: GridApi;
  camponuevo: boolean = false;
  CalendarioForm!: FormGroup;
  filaSeleccionada: any = null; 
  archivo: File | null = null;

  // Fecha
    startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  sucursales = [
    { id: 'La Molina, Lima', nombre: 'La Molina, Lima' },
    { id: 'San Isidro, Lima', nombre: 'San Isidro, Lima' },
    { id: 'San Borja, Lima', nombre: 'San Borja, Lima' },
    { id: 'Santa Isabel, Piura', nombre: 'Santa Isabel, Piura' },
  ];

  tipos=[
    "Feriado nacional",
    "Feriado local",
    "Turno fijo",
    "Turno rotativo",
  ];

  tipoFeriados=[
    "No laborable",
    "Compensable",
  ];

  frecuenciasFeriado=[
    "Fijo",
    "Variable",
  ];

  canales = [
    "Salón",
    "Delivery",
    "Cocina",
  ]

  semana = [
    { value: 1, nombre: 'Lunes' },
    { value: 2, nombre: 'Martes' },
    { value: 3, nombre: 'Miércoles' },
    { value: 4, nombre: 'Jueves' },
    { value: 5, nombre: 'Viernes' },
    { value: 6, nombre: 'Sábado' },
    { value: 7, nombre: 'Domingo' },
  ]

  meses=[
    { value: 1, nombre: 'Enero' },
    { value: 2, nombre: 'Febrero' },
    { value: 3, nombre: 'Marzo' },
    { value: 4, nombre: 'Abril' },
    { value: 5, nombre: 'Mayo' },
    { value: 6, nombre: 'Junio' },
    { value: 7, nombre: 'Julio' },
    { value: 8, nombre: 'Agosto' },
    { value: 9, nombre: 'Septiembre' },
    { value: 10, nombre: 'Octubre' },
    { value: 11, nombre: 'Noviembre' },
    { value: 12, nombre: 'Diciembre' },
  ];

  dias = Array.from({ length: 31 }, (_, i) => i + 1);

  tiposJornada=[
    "Diurna",
    "Nocturna",
    "Mixta",
  ];

  reglaRotacion=[
    "Diaria",
    "Semanal",
    "Mensual",
  ];

  estados=[
    "Activo",
    "Inactivo",
  ];

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

  //  Tipado con la misma entidad
  colDefs: ColDef<CalendarioLaboralEntity>[] = [
    { field: 'calendario_laboral_codigo', headerName: 'Código', width: 110 },
    { field: 'calendario_laboral_sucursal', headerName: 'Sucursal', width: 140},
    { field: 'calendario_laboral_fecha', headerName: 'Fecha de registro', width: 120,
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate() +1).padStart(2, '0');
        return `${day}/${month}/${year}`;
      }
    },
    { field: 'calendario_laboral_tipo', headerName: 'Tipo', width: 160, filter: true, },
    { field: 'calendario_laboral_descripcion', headerName: 'Descripción', flex: 1, minWidth: 180 },
    { field: 'calendario_laboral_tipo_feriado', headerName: 'Tipo de feriado', width: 120 },
    { field: 'calendario_laboral_frecuencia_feriado', headerName: 'Frecuencia', width: 100 },
    { field: 'calendario_laboral_aplica_remuneracion',  headerName: 'Aplica remuneración',  width: 130,
      cellRenderer: (params: any) => {
        return params.value === true ? 'Si' : 'No';
      }
    },
    { field: 'calendario_laboral_estado', headerName: 'Estado', headerClass: 'centrarencabezado', width: 90, filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
        } else if (params.value === 'Inactivo') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>';
        }
        return params.value;
      }
    }
  ];
  
    constructor(
      private formBuilder: FormBuilder,
      private toastService: ToastService,
      private modalController: ModalController,
      private formValidationService: FormValidationService
    ) {
      this.minDate = new Date(2020, 0, 1);
      this.maxDate = new Date();
    }

  ngOnInit() {
    // Cargar calendarios laborales desde el JSON a través de la capa de infraestructura
    this.rrHhFacade.cargarCalendariosLaborales();

    this.CalendarioForm = this.formBuilder.group({
      calendario_laboral_fecha: [ {value: this.getFechaHoy(), disabled: true}],
      calendario_laboral_codigo: [''],
      calendario_laboral_sucursal: ['', Validators.required],
      calendario_laboral_tipo: ['', Validators.required],
      calendario_laboral_dias_seleccionados: [''],
      calendario_laboral_canal: [''],
      calendario_laboral_detalle: [''],
      calendario_laboral_tipo_feriado: [''],
      calendario_laboral_frecuencia_feriado: [''],
      calendario_laboral_mes_fijo: [''],
      calendario_laboral_dia_fijo: [''],
      calendario_laboral_fecha_feriado: [''],
      calendario_laboral_descripcion: ['', Validators.required],
      calendario_laboral_aplica_remuneracion: [false],
      calendario_laboral_estado: ['Activo', Validators.required],
      calendario_laboral_hora_inicio: [''],
      calendario_laboral_hora_fin: [''],
      calendario_laboral_descanso: [''],
      calendario_laboral_tipo_jornada: [''],
      calendario_laboral_recargo_he: [''],
      calendario_laboral_regla_remuneracion: [''],
      });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.CalendarioForm);
    
    // Establecer camponuevo en true para que el botón sea "Registrar" al entrar
    this.camponuevo = true;
    
    // Escuchar cambios en el tipo para validación dinámica
    this.CalendarioForm.get('calendario_laboral_tipo')?.valueChanges.subscribe((tipo) => {
      this.actualizarValidacionesDinamicas(tipo);
    });

    // Aplicar validaciones iniciales segun el tipo actual (si hubiese valor precargado)
    this.actualizarValidacionesDinamicas(this.CalendarioForm.get('calendario_laboral_tipo')?.value);
  }

  getFechaHoy(): string {
    return new Date().toISOString().substring(0, 10);
  }

  private actualizarValidacionesDinamicas(tipo: string) {
    const diasSelControl = this.CalendarioForm.get('calendario_laboral_dias_seleccionados');
    const canalControl = this.CalendarioForm.get('calendario_laboral_canal');
    const detalleControl = this.CalendarioForm.get('calendario_laboral_detalle');
    const tipoFControl = this.CalendarioForm.get('calendario_laboral_tipo_feriado');
    const frecuenciaFControl = this.CalendarioForm.get('calendario_laboral_frecuencia_feriado');
    const mesFControl = this.CalendarioForm.get('calendario_laboral_mes_fijo');
    const diaFControl = this.CalendarioForm.get('calendario_laboral_dia_fijo');
    const fechaFControl = this.CalendarioForm.get('calendario_laboral_fecha_feriado');
    const horaIControl = this.CalendarioForm.get('calendario_laboral_hora_inicio');
    const horaFControl = this.CalendarioForm.get('calendario_laboral_hora_fin');
    const descansoControl = this.CalendarioForm.get('calendario_laboral_descanso');
    const tipoJControl = this.CalendarioForm.get('calendario_laboral_tipo_jornada');
    const recargoHEControl = this.CalendarioForm.get('calendario_laboral_recargo_he');
    const reglaRControl = this.CalendarioForm.get('calendario_laboral_regla_remuneracion');

    // Limpiar validaciones y valores previos
    [diasSelControl, canalControl, detalleControl, tipoFControl, frecuenciaFControl, mesFControl, diaFControl, fechaFControl, horaIControl, horaFControl, descansoControl, tipoJControl, recargoHEControl, reglaRControl]
      .forEach(control => {
        control?.clearAsyncValidators();
        control?.setValidators([]);
        control?.updateValueAndValidity({ emitEvent: false });
      });

    // Aplicar validaciones según el tipo
    if (tipo === 'Feriado nacional' || tipo === 'Feriado local') {
      tipoFControl?.setValidators([Validators.required]);
      frecuenciaFControl?.setValidators([Validators.required]);
      // Validaciones según frecuencia
      const frecuencia = this.CalendarioForm.get('calendario_laboral_frecuencia_feriado')?.value;
      if (frecuencia === 'Fijo') {
        mesFControl?.setValidators([Validators.required]);
        diaFControl?.setValidators([Validators.required]);
      } else if (frecuencia === 'Variable') {
        fechaFControl?.setValidators([Validators.required]);
      }
    } else if (tipo === 'Turno fijo' || tipo === 'Turno rotativo') {
      horaIControl?.setValidators([Validators.required]);
      horaFControl?.setValidators([Validators.required]);
      descansoControl?.setValidators([Validators.required]);
      tipoJControl?.setValidators([Validators.required]);
      canalControl?.setValidators([Validators.required]);
      detalleControl?.setValidators([Validators.required]);
    }

    // Solo turno fijo requiere recargo HE (turno rotativo no lo muestra)
    if (tipo === 'Turno fijo') {
      recargoHEControl?.setValidators([Validators.required]);
      canalControl?.setValidators([Validators.required]);
      detalleControl?.setValidators([Validators.required]);
    }

    if (tipo === 'Turno rotativo') {
      diasSelControl?.setValidators([Validators.required]);
      canalControl?.setValidators([Validators.required]);
      reglaRControl?.setValidators([Validators.required]);
    }

    // Actualizar validaciones
    [diasSelControl, canalControl, tipoFControl, frecuenciaFControl, mesFControl, diaFControl, fechaFControl, horaIControl, horaFControl, descansoControl, tipoJControl, recargoHEControl, reglaRControl]
      .forEach(control => control?.updateValueAndValidity({ emitEvent: false }));
  }
  
  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  onFechaFSelected(date: any) {
    this.CalendarioForm.patchValue({ calendario_laboral_fecha_feriado: date });
  }

  async onCellClicked(event: any) {
    const data = event.data;
    
    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló: deshacer la selección automática de AG-Grid
      event.node.setSelected(false);
      // La fila anterior se mantiene seleccionada
      return;
    }

    // Usuario confirmó, cambiar a la nueva fila seleccionada
    this.gridApi.deselectAll();
    
    // Cargar datos del registro seleccionado
    this.cargarDatosRegistro(data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: any, node?: any): void {
    this.camponuevo = false;
    this.filaSeleccionada = data;
    this.gridApi.deselectAll();

    // Seleccionar el nodo en AG-Grid
    if (node) {
      node.setSelected(true);
    } else {
      this.gridApi.forEachNode((n) => {
        if (n.data === data) {
          n.setSelected(true);
        }
      });
    }

    // Llenar los campos del formulario con los datos de la fila
    this.CalendarioForm.patchValue({
      calendario_laboral_fecha: data.calendario_laboral_fecha || this.getFechaHoy(),
      calendario_laboral_codigo: data.calendario_laboral_codigo || '',               
      calendario_laboral_sucursal: data.calendario_laboral_sucursal || '',                   
      calendario_laboral_tipo: data.calendario_laboral_tipo || '',
      calendario_laboral_dias_seleccionados: data.calendario_laboral_dias_seleccionados || [],           
      calendario_laboral_canal: data.calendario_laboral_canal || '',
      calendario_laboral_detalle: data.calendario_laboral_detalle || '',
      calendario_laboral_tipo_feriado: data.calendario_laboral_tipo_feriado || '',
      calendario_laboral_frecuencia_feriado: data.calendario_laboral_frecuencia_feriado || '',
      calendario_laboral_mes_fijo: data.calendario_laboral_mes_fijo || '',
      calendario_laboral_dia_fijo: data.calendario_laboral_dia_fijo || '',
      calendario_laboral_fecha_feriado: data.calendario_laboral_fecha_feriado || '',
      calendario_laboral_descripcion: data.calendario_laboral_descripcion || '',
      calendario_laboral_estado: data.calendario_laboral_estado || 'Activo',  
      calendario_laboral_aplica_remuneracion: data.calendario_laboral_aplica_remuneracion || false, 
      calendario_laboral_hora_inicio: data.calendario_laboral_hora_inicio || '',
      calendario_laboral_hora_fin: data.calendario_laboral_hora_fin || '',
      calendario_laboral_descanso: data.calendario_laboral_descanso || '',
      calendario_laboral_tipo_jornada: data.calendario_laboral_tipo_jornada || '',
      calendario_laboral_recargo_he: data.calendario_laboral_recargo_he || '',
      calendario_laboral_regla_remuneracion: data.calendario_laboral_regla_remuneracion || ''
    });

    this.CalendarioForm.get('calendario_laboral_fecha')?.disable();

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }
  async botonNuevaOperacion(){
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló: mantener estado actual y fila seleccionada si existía
      return;
    }

    // Usuario confirmó, ahora sí deseleccionar y limpiar
    this.gridApi?.deselectAll();
    
    this.camponuevo = true;
    this.filaSeleccionada = null; // Limpiar la fila seleccionada
    this.CalendarioForm.reset(
      { calendario_laboral_fecha: this.getFechaHoy() }
    );

    this.CalendarioForm.get('calendario_laboral_fecha')?.disable();
    
    // Generar código automático
    const nuevoCodigo = this.generarNuevoCodigo();
    
    // Solo establecer código automático y estado, los demás quedan con placeholder
    this.CalendarioForm.patchValue({
      calendario_laboral_codigo: nuevoCodigo,
      calendario_laboral_estado: 'Activo',
      calendario_laboral_aplica_remuneracion: false
    });

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }
  botonGuardar(){
    // Validar que el formulario esté completo antes de proceder
    if (this.CalendarioForm.invalid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      // Marcar todos los campos como touched para mostrar los errores
      const camposFaltantes: string[] = [];
      Object.keys(this.CalendarioForm.controls).forEach(key => {
        const control = this.CalendarioForm.get(key);
        control?.markAsTouched();
        if (control?.invalid) {
          camposFaltantes.push(key);
        }
      });
      console.warn('Campos incompletos o inválidos:', camposFaltantes);

      return;
    }

    const formValues = this.CalendarioForm.value;
    
    // Generar código automático para nuevas operaciones
    const codigo = this.camponuevo ? this.generarNuevoCodigo() : this.filaSeleccionada?.calendario_laboral_codigo;
    
    // Crear objeto con los datos del formulario
    const operacionData: CalendarioLaboralEntity = {
      calendario_laboral_codigo: codigo,
      calendario_laboral_sucursal: formValues.calendario_laboral_sucursal,
      calendario_laboral_fecha: this.getFechaHoy(),
      calendario_laboral_tipo: formValues.calendario_laboral_tipo,
      calendario_laboral_dias_seleccionados: formValues.calendario_laboral_dias_seleccionados,
      calendario_laboral_canal: formValues.calendario_laboral_canal,
      calendario_laboral_detalle: formValues.calendario_laboral_detalle,
      calendario_laboral_frecuencia_feriado: formValues.calendario_laboral_frecuencia_feriado,
      calendario_laboral_mes_fijo: formValues.calendario_laboral_mes_fijo,
      calendario_laboral_dia_fijo: formValues.calendario_laboral_dia_fijo,
      calendario_laboral_fecha_feriado: formValues.calendario_laboral_fecha_feriado,
      calendario_laboral_descripcion: formValues.calendario_laboral_descripcion,
      calendario_laboral_tipo_feriado: formValues.calendario_laboral_tipo_feriado,
      calendario_laboral_aplica_remuneracion: formValues.calendario_laboral_aplica_remuneracion,
      calendario_laboral_estado: formValues.calendario_laboral_estado,
      calendario_laboral_hora_inicio: formValues.calendario_laboral_hora_inicio,
      calendario_laboral_hora_fin: formValues.calendario_laboral_hora_fin,
      calendario_laboral_descanso: formValues.calendario_laboral_descanso,
      calendario_laboral_tipo_jornada: formValues.calendario_laboral_tipo_jornada,
      calendario_laboral_recargo_he: formValues.calendario_laboral_recargo_he,
      calendario_laboral_regla_remuneracion: formValues.calendario_laboral_regla_remuneracion
    };

    if (this.camponuevo) {
      // Agregar al inicio del array a través del effect
      const currentData = this.calendariosGridEffects.getRowData();
      this.calendariosGridEffects.setRowData([operacionData, ...currentData]);
      console.log('Nueva operación agregada');
      this.toastService.success('¡Registro realizado exitosamente!');
    } 
    // Si es edición (camponuevo = false y hay una fila seleccionada)
    else if (this.filaSeleccionada) {
      const currentData = this.calendariosGridEffects.getRowData();
      const index = currentData.findIndex((item: CalendarioLaboralEntity) => item.calendario_laboral_codigo === this.filaSeleccionada.calendario_laboral_codigo);
      if (index !== -1) {
        const updatedData = [...currentData];
        updatedData[index] = operacionData;
        this.filaSeleccionada = operacionData;
        this.calendariosGridEffects.setRowData(updatedData);
      }
      console.log('Operación actualizada');
      this.toastService.success('¡Registro actualizado exitosamente!');
    }
    
    // Limpiar formulario y mantener estado para nuevo registro
    this.CalendarioForm.reset();
    this.CalendarioForm.patchValue({
      naturaleza: 'Aumento',
      tipoCalculo: 'Depreciación',
      calendario_laboral_estado: 'Activo',
      afectaContabilidad: false
    });
    this.filaSeleccionada = null;
    this.camponuevo = true; // Mantener en true para seguir registrando nuevos

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  async cancelar(): Promise<void> {
    // Validar si hay cambios sin guardar PRIMERO
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló la cancelación, mantener estado actual
      return;
    }
    
    // Usuario confirma cancelación, ahora deseleccionar y limpiar
    this.gridApi?.deselectAll();
    
    this.camponuevo = true;
    this.filaSeleccionada = null;
    this.CalendarioForm.reset();
    this.CalendarioForm.patchValue({
      calendario_laboral_estado: 'Activo',
      calendario_laboral_aplica_remuneracion: false
    });
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }
  
  
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.calendariosGridEffects.setGridApi(params.api);
  }

  // Generar código automático para nuevas operaciones
  generarNuevoCodigo(): string {
    const numeros = this.calendariosGridEffects.getRowData().map(item => {
      const match = item.calendario_laboral_codigo.match(/CT-(\d+)/);
      return match ? parseInt(match[1], 10) : 0;
    });
    const maxNumero = Math.max(...numeros, 0);
    const nuevoNumero = (maxNumero + 1).toString().padStart(3, '0');
    return `CT-${nuevoNumero}`;
  }

  onSucursalSeleccionada(sucursal: any) {
    console.log('Sucursal seleccionada:', sucursal);
  }

  onDiasSeleccionados(dias: any) {
    console.log('Días seleccionados:', dias);
    this.CalendarioForm.patchValue({ calendario_laboral_dias_seleccionados: dias });
  }

  onBtReset() {
    this.isResetting = true;
    this.rrHhFacade.cargarCalendariosLaborales();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.isResetting = false;
      }
    }, 100);
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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar'},
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385'},
      { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380'},
      { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - '+this.filaSeleccionada.calendario_laboral_codigo,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
       
      }
    });
    
    await modal.present();
  }

  botonduplicar(){
    if (!this.filaSeleccionada) {
      this.toastService.warning('Por favor, selecciona un registro para duplicar.');
      return;
    }

    this.camponuevo = true;

    // Crear una copia de la fila seleccionada sin el código
    const datosDuplicados = { ...this.filaSeleccionada };
    delete datosDuplicados.calendario_laboral_codigo;

    // Generar nuevo código automático
    const nuevoCodigo = this.generarNuevoCodigo();

    // Rellenar el formulario con los datos duplicados y el nuevo código
    this.CalendarioForm.patchValue({
      ...datosDuplicados,
      calendario_laboral_codigo: nuevoCodigo
    });

    // Deseleccionar cualquier fila en la tabla
    this.gridApi.deselectAll();

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }

  async abrirmodalImportar() {
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar feriados',
        descripcionSubir:
          'Comparte tu archivo de excel con la información de tus conceptos y regístralos automáticamente en la plataforma.',
        buttonName: 'Importar feriados',
      },
    });
    await modal.present();

    try {
      const result = await modal.onWillDismiss();
      const data = result?.data;
      if (data && data.archivo) {
        // Guardar archivo en el componente padre
        this.archivo = data.archivo;
        // Mostrar toast indicando que el archivo fue subido
        try {
          const nombre = data.archivo?.name ?? 'archivo';
          this.toastService.success('Archivo subido', nombre, 3000);
        } catch (e) {
          console.warn('ToastService falló', e);
        }
        // Llamar al método importar para procesar el archivo
        try {
          this.importar(data);
        } catch (e) {
          this.toastService.danger('Importacion fallida');
        }
      }
    } catch (e) {
      console.warn('Error al obtener resultado del modal', e);
      this.toastService.danger('Error al obtener resultado del modal');
    }
  }

  importar(data: any) {
    // Placeholder: aquí se procesaría el archivo (validaciones, parseo, subida, etc.)
    console.log('Importar llamado con:', data);
    // Por ahora solo guardamos el archivo en el estado (ya lo hacemos en modalImportar),
    // y se puede mostrar un toast adicional si se desea.
  }

}
