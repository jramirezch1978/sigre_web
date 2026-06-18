import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { ConfiguracionFacade } from '../../../application/facades/configuracion.facade';
import { ConfiguracionCanalesPagoCobroGridEffects } from '../../../effects/configuracion-canales-pago-cobro-grid.effect';
import { CanalPagoCobroEntity } from '../../../domain/models/canal-pago-cobro.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-a-l-canal-pago-cobro',
  templateUrl: './a-l-canal-pago-cobro.component.html',
  styleUrls: ['./a-l-canal-pago-cobro.component.scss'],
  standalone: false
})
export class ALCanalPagoCobroComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  // Inyección del Facade y Effects
  private readonly configuracionFacade = inject(ConfiguracionFacade);
  private readonly canalesGridEffects = inject(ConfiguracionCanalesPagoCobroGridEffects);
  
  // Selectores del store
  readonly canalesPagoCobro = this.configuracionFacade.canalesPagoCobro;
  readonly loadingCanales = this.configuracionFacade.loadingCanalesPagoCobro;
  readonly isLoading = this.configuracionFacade.isLoading;

    // RANGO DE FECHAS

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private gridApi!: GridApi;
  filaSeleccionada: any = null;
  cargando = false;
  isResetting = false;
  canalForm!: FormGroup;
  camponuevo: boolean = false;
  modoCreacion: boolean = true;
  fechaCreacion: Date | undefined;
  countries= ALL_COUNTRIES;

  cuentasBancarias: any[] = [
    { id: '1', codigo: '104-001', nombre: 'BCP - Cuenta corriente soles' },
    { id: '2', codigo: '104-002', nombre: 'BCP - Cuenta corriente dólares' },
    { id: '3', codigo: '104-003', nombre: 'BBVA - Cuenta corriente soles' },
    { id: '4', codigo: '104-004', nombre: 'BBVA - Cuenta corriente dólares' },
    { id: '5', codigo: '104-005', nombre: 'Interbank - Cuenta corriente soles' },
    { id: '6', codigo: '104-006', nombre: 'Scotiabank - Cuenta corriente soles' },
  ];

  cuentasContables=[
    { id: '1010', codigo: '1010', nombre: 'Caja principal soles' },
    { id: '1011', codigo: '1011', nombre: 'Caja chica dólares' },
  ]

  entidadesFinancieras: any[] = [
    { id: '1', nombre: 'BCP' },
    { id: '2', nombre: 'BBVA' },
    { id: '3', nombre: 'Interbank' },
    { id: '4', nombre: 'Scotiabank' },
    { id: '5', nombre: 'Banco de la Nación' },
    { id: '6', nombre: 'Caja Piura' },
    { id: '7', nombre: 'Niubiz' },
  ];

  medios: any[] = []; 

  columnTypes = {
    default: {
      resizable: false,
      sortable: false,
      filter: false,
      floatingFilter: false,
    }
  };

  colDefs: ColDef[] = [
    { field: 'canal_pago_cobro_medio_pago_cobro', headerName: 'Medio de pago/cobro', width: 130, filter: true},
    { field: 'canal_pago_cobro_canal', headerName: 'Canal', width: 90, filter: true },
    { field: 'canal_pago_cobro_nombre', headerName: 'Nombre', width: 130 },
    { field: 'canal_pago_cobro_entidad_bancaria', headerName: 'Entidad bancaria', width: 120, filter: true },
    { field: 'canal_pago_cobro_cuenta_bancaria', headerName: 'Cuenta bancaria', width: 130 },
    { field: 'canal_pago_cobro_moneda', headerName: 'Moneda', width: 90, filter: true },
    { field: 'canal_pago_cobro_cuenta_contable', headerName: 'Cuenta contable', width: 120 },
    { 
      field: 'canal_pago_cobro_estado', 
      headerName: 'Estado', filter: true, 
      width: 100,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      }
    }
  ];

  /**
   * @summary Getter para acceder a rowData desde el template
   * @description El rowData está gestionado por ConfiguracionCanalesPagoCobroGridEffects
   */
  get rowData(): CanalPagoCobroEntity[] {
    return this.canalesGridEffects.getRowData();
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
    loadingOoo: 'Cargando...',
  };

  constructor(
    private fb: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService,
    private countryService: CountryService,
  ) {
        const today = new Date();
        this.maxDate = today;
        this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
   }

  ngOnInit() {
    this.inicializarFormulario();
    // Inicializar servicio de validación
    this.formValidationService.inicializarFormulario(this.canalForm);
    this.camponuevo = true;
    this.modoCreacion = true;
    this.limpiarFormulario();
    // Resetear el servicio después de la inicialización para que no detecte el reset como cambio
    this.formValidationService.resetearEstado();
    this.cargarmediosdepago();
    
    // Limpiar estado previo para forzar loader en cada entrada
    this.configuracionFacade.clearCanalesPagoCobro();
    
    // Cargar canales de pago/cobro desde el JSON
    this.configuracionFacade.cargarCanalesPagoCobro();
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    console.log('Filtrar por fechas:', range);
    // Aquí iría la lógica para filtrar los datos
  }
  cargarmediosdepago(){
    this.countries.find(c => {
      if (c.codigo === this.countryService.getCountryCode()) {
        c.formaspago?.forEach((medio: any) => {
          this.medios.push({ id: medio.value, nombre: medio.nombre });
        });
      }
    });
  }
  inicializarFormulario() {
    this.canalForm = this.fb.group({
      tipoCuenta: ['', Validators.required],
      medio: ['', Validators.required],
      entidadFinanciera: [''],
      cuentaBancaria: [''],
      nombreCanal: ['', Validators.required],
      moneda: ['', Validators.required],
      cuentaContable: ['', Validators.required],
      descripcion: ['', Validators.required],
      estado: ['Activo', Validators.required],
      fechaCreacion: [{ value: new Date().toISOString().split('T')[0], disabled: true }],
    });
  }

  cargarDatosFormulario(data: any) {
    // Mapear los valores de texto a IDs
    const entidadId = this.entidadesFinancieras.find(e => e.nombre === data.canal_pago_cobro_entidad_bancaria)?.id || data.canal_pago_cobro_entidad_bancaria;
    const cuentaContableId = this.cuentasContables.find(c => c.codigo === data.canal_pago_cobro_cuenta_contable)?.id || data.canal_pago_cobro_cuenta_contable;
    const cuentaBancariaId = this.cuentasBancarias.find(c => c.codigo === data.canal_pago_cobro_cuenta_bancaria)?.id || data.canal_pago_cobro_cuenta_bancaria;
    const medioId = this.medios.find(m => m.nombre === data.canal_pago_cobro_medio_pago_cobro)?.id || data.canal_pago_cobro_medio_pago_cobro;
    
    this.canalForm.patchValue({
      tipoCuenta: data.canal_pago_cobro_canal || '',
      medio: medioId,
      entidadFinanciera: entidadId,
      cuentaBancaria: cuentaBancariaId,
      nombreCanal: data.canal_pago_cobro_nombre || '',
      moneda: data.canal_pago_cobro_moneda || '',
      cuentaContable: cuentaContableId,
      descripcion: data.canal_pago_cobro_descripcion || '',
      estado: data.canal_pago_cobro_estado || 'Activo',
      fechaCreacion: data.canal_pago_cobro_fecha_creacion || new Date().toISOString().split('T')[0]
    });
    
    // Marcar como pristine después de cargar para que no se habilite el botón inmediatamente
    this.canalForm.markAsPristine();
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  limpiarFormulario() {
    this.camponuevo = false;
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    
    this.canalForm.reset({
      estado: 'Activo',
      fechaCreacion: new Date().toISOString().split('T')[0]
    });
    this.canalForm.markAsPristine();
    this.canalForm.markAsUntouched();
    
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    this.formValidationService.resetearEstado();
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // Registrar la API de la grilla en el effect
    this.canalesGridEffects.setGridApi(params.api);
  }

  async onCellClicked(event: any) {
    const data = event.data;
    const node = event.node;
    if (!data) { return; }

    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Usuario canceló - mantener selección anterior
      if (this.gridApi) {
        this.gridApi.deselectAll();
        // Volver a seleccionar la fila anterior si existía
        if (this.filaSeleccionada) {
          this.gridApi.forEachNode((node) => {
            if (node.data.canal_pago_cobro_id === this.filaSeleccionada.canal_pago_cobro_id) {
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
    this.filaSeleccionada = data;
    this.camponuevo = false;
    this.modoCreacion = false;
    this.cargarDatosFormulario(data);
    setTimeout(() => node.setSelected(true), 0);
    
    console.log('Canal seleccionado:', data);
  }

  onCuentaBancariaSeleccionada(cuenta: any) {
    console.log('Cuenta bancaria seleccionada:', cuenta);
  }

   onCuentaContableSeleccionada(cuenta: any) {
    console.log('Cuenta contable seleccionada:', cuenta);
  }

  onEntidadFinancieraSeleccionada(entidad: any) {
    console.log('Entidad financiera seleccionada:', entidad);
    this.canalForm.patchValue({ entidadFinanciera: entidad.nombre });
  }

  onBtReset(): void {
    this.isResetting = true;
    this.configuracionFacade.cargarCanalesPagoCobro();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

  onMedioSelected(event: any) {
    const medio = event.detail.value;
    const entidadFinanciera = this.canalForm.get('entidadFinanciera');
    const cuentaBancaria = this.canalForm.get('cuentaBancaria');

    if (medio === 'efectivo') {
      // Si es efectivo, no requerimos estos campos
      entidadFinanciera?.setValidators([]);
      cuentaBancaria?.setValidators([]);
      // Limpiar valores si es efectivo
      entidadFinanciera?.setValue('');
      cuentaBancaria?.setValue('');
    } else {
      // Si no es efectivo, son requeridos
      entidadFinanciera?.setValidators([Validators.required]);
      cuentaBancaria?.setValidators([Validators.required]);
    }

    // Actualizar la validación
    entidadFinanciera?.updateValueAndValidity();
    cuentaBancaria?.updateValueAndValidity();
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

  async botonNuevoCanal() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    this.camponuevo = true;
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.limpiarFormulario();
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  botonGuardar() {
    if (this.canalForm.invalid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }
      const formValues = this.canalForm.getRawValue();
      
      if (this.camponuevo) {
        // Crear nuevo registro con ID único
        const nuevoId = this.rowData.length > 0 ? Math.max(...this.rowData.map(r => r.canal_pago_cobro_id || 0)) + 1 : 1;
        const nuevoRegistro = {
          canal_pago_cobro_id: nuevoId,
          canal_pago_cobro_fecha_creacion: formValues.fechaCreacion,
          canal_pago_cobro_medio_pago_cobro: formValues.medio,
          canal_pago_cobro_canal: formValues.tipoCuenta,
          canal_pago_cobro_nombre: formValues.nombreCanal,
          canal_pago_cobro_entidad_bancaria: formValues.medio === 'Efectivo' ? 'N/A' : (formValues.entidadFinanciera || 'N/A'),
          canal_pago_cobro_cuenta_bancaria: formValues.medio === 'Efectivo' ? 'N/A' : (formValues.cuentaBancaria || 'N/A'),
          canal_pago_cobro_moneda: formValues.moneda,
          canal_pago_cobro_cuenta_contable: formValues.cuentaContable,
          canal_pago_cobro_descripcion: formValues.descripcion,
          canal_pago_cobro_usuario_responsable: 'Usuario Actual', // Aquí deberías poner el usuario logueado
          canal_pago_cobro_estado: formValues.estado
        };

        // Agregar a la tabla a través del effect
        const currentData = this.canalesGridEffects.getRowData();
        this.canalesGridEffects.setRowData([nuevoRegistro, ...currentData]);

        this.toastService.success('¡Canal registrado exitosamente!');
        console.log('Nuevo registro creado:', nuevoRegistro);
        
        // Limpiar formulario primero para registro rápido
        this.camponuevo = true;
        this.modoCreacion = true;
        this.filaSeleccionada = null;
        this.limpiarFormulario();
        
        // Desmarcar en la tabla
        if (this.gridApi) {
          this.gridApi.deselectAll();
        }
        
        // Resetear servicio de validación
        this.formValidationService.resetearEstado();
        
      } else {
        // Actualizar registro existente
        if (this.filaSeleccionada) {
          const index = this.rowData.findIndex(row => row.canal_pago_cobro_id === this.filaSeleccionada.canal_pago_cobro_id);
          
          if (index !== -1) {
            this.rowData[index] = {
              ...this.rowData[index],
              canal_pago_cobro_medio_pago_cobro: formValues.medio,
              canal_pago_cobro_canal: formValues.tipoCuenta,
              canal_pago_cobro_nombre: formValues.nombreCanal,
              canal_pago_cobro_entidad_bancaria: formValues.medio === 'Efectivo' ? 'N/A' : (formValues.entidadFinanciera || 'N/A'),
              canal_pago_cobro_cuenta_bancaria: formValues.medio === 'Efectivo' ? 'N/A' : (formValues.cuentaBancaria || 'N/A'),
              canal_pago_cobro_moneda: formValues.moneda,
              canal_pago_cobro_cuenta_contable: formValues.cuentaContable,
              canal_pago_cobro_estado: formValues.estado
            };

            // Actualizar la grid
            if (this.gridApi) {
              this.gridApi.setGridOption('rowData', [...this.rowData]);
            }

            this.toastService.success('¡Cambios guardados exitosamente!');
            console.log('Registro actualizado:', this.rowData[index]);
            
            // Marcar como pristine para deshabilitar el botón
            this.canalForm.markAsPristine();
            
            // Resetear servicio de validación
            this.formValidationService.resetearEstado();
          }
        }
      }
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
      { historial_actualizacion_fecha_hora: '19/10/2025 14:30', historial_actualizacion_usuario: 'Ana Gómez', historial_actualizacion_accion: 'Creación', historial_actualizacion_detalle_cambio: 'Registro inicial del canal de pago'},
      { historial_actualizacion_fecha_hora: '20/10/2025 10:15', historial_actualizacion_usuario: 'Juan Pérez', historial_actualizacion_accion: 'Actualización', historial_actualizacion_detalle_cambio: 'Cambio de cuenta contable asociada' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones del Canal',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });
    
    await modal.present();
  }

}