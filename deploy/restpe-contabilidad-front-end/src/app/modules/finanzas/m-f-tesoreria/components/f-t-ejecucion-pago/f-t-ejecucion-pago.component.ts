import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalAsientoContableComponent } from 'src/app/modules/activos/m-af-procesos/pages/af-p-generacionasientosdepreciacion/modal/modal-asiento-contable/modal-asiento-contable.component';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { Observable } from 'rxjs';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';

// Font Awesome Icons
import { faClock, faCreditCard, faPercentage, faChevronsRight, faDownload, faAngleDown, faCirclePlus, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { IconDefinition } from '@fortawesome/fontawesome-svg-core';
import { faSearch, faBook, faCircleXmark } from '@fortawesome/pro-regular-svg-icons';
import { EjecucionPagoEntity } from 'src/app/modules/finanzas/domain/models/ejecucion-pago.entity';
import { EjecucionPagoFacade } from 'src/app/modules/finanzas/application/facades/ejecucion-pago.facade';
import { EjecucionPagoFeedbackEffects } from 'src/app/modules/finanzas/effects/ejecucion-pago-feedback.effect';
import { EjecucionPagoSyncEffects } from 'src/app/modules/finanzas/effects/ejecucion-pago-sync.effect';

interface CanComponentDeactivate {
  canDeactivate: () => Observable<boolean> | Promise<boolean> | boolean;
}

@Component({
  selector: 'app-f-t-ejecucion-pago',
  templateUrl: './f-t-ejecucion-pago.component.html',
  styleUrls: ['./f-t-ejecucion-pago.component.scss'],
  standalone: false,
})
export class FTEjecucionPagoComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  private readonly facade = inject(EjecucionPagoFacade);
  private readonly feedbackEffects = inject(EjecucionPagoFeedbackEffects);
  private readonly syncEffects = inject(EjecucionPagoSyncEffects);
  readonly isLoading = this.facade.isLoading;
  // Font Awesome Icons
  fasClock = faClock;
  fasCreditCard = faCreditCard;
  fasPercentage = faPercentage;
  fasChevronsRight = faChevronsRight;
  farSearch = faSearch;
  fasDownload = faDownload;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  farBook = faBook;
  farCircleXmark = faCircleXmark;
  fasRotateRight = faRotateRight;


  pais= this.countryService.getCountryCode();
  countries= ALL_COUNTRIES;
  entidadtributaria=this.countries.find(c => c.codigo === this.pais)?.entidad || '';

  mostrarTabla: boolean = false;
  startDate: Date = new Date();
  endDate: Date = new Date();
  minDate: Date = new Date(new Date().getFullYear() - 1, 0, 1);
  maxDate: Date = new Date();
  filaSeleccionada: any = [];
  private gridApi!: GridApi;
  pagoForm!: FormGroup;
  fechaPagoInicial?: Date;
  documentoSoporte: string = '';
  tituloboton='Registrar';
  estadoActual: string = ''; // Para controlar la visibilidad de botones
  context: any;
  entesTributarios: any[] =[]

  
  get tituloFormulario(): string {
    if (!this.filaSeleccionada) {
      return 'Registrar nuevo pago';
    }
    return `Información del pago: ${this.filaSeleccionada.ep_codigo || ''}`;
  }
  
  enteDef=[
    { value: '1', label: `${this.entidadtributaria}` },
  ]
  entePer= [
    { value: '1', label: `${this.entidadtributaria}` },
    { value: '2', label: 'AFP' },
    { value: '3', label: 'Municipalidad' }
  ];

  tiposTributoSunat: any= [
  ];

  tiposTributoAfp = [
    { value: 'afp_profuturo', label: 'AFP profuturo' },
    { value: 'prima_afp', label: 'Prima AFP' },
    { value: 'afp_integra', label: 'AFP Integra' }
  ];

  tiposTributoMunicipalidad = [
    { value: 'impuesto_predial', label: 'Impuesto predial' },
    { value: 'impuesto_alcabala', label: 'Impuesto alcabala' }
  ];

  tiposTributo = this.tiposTributoSunat;
  labelTipoTributo: string = 'Tipo de tributo';
  placeholderTipoTributo: string = 'Selecciona el tipo de tributo';

  cuentasBancarias = [
    { value: 'BCP', label: '191-123456-0-01' },
    { value: 'BBVA', label: '0011-0123-0200123456' },
    { value: 'Interbank', label: '200-3001234567' },
    { value: 'Scotiabank', label: '000-1234567' },
  ];

  monedas = [
    { value: 'Soles', label: 'Soles' },
    { value: 'Dolares', label: 'Dólares' }
  ];

  estados = [
    { value: 'Pendiente', label: 'Pendiente' },
    { value: 'Pagado', label: 'Pagado' }
  ];
  
  colDefsPagos: ColDef[] = [
    { field: 'ep_codigo', headerName: 'Código', flex: 1, minWidth: 60 },
    { field: 'ep_enteTributario', headerName: 'Ente tributario', flex: 1, filter: true, minWidth: 75,
      cellRenderer: (params: any) => {
        if (params.value === '1') {
          return this.entidadtributaria;
        } else if (params.value === '2') {
          return 'AFP';
        } else if (params.value === '3') {
          return 'Municipalidad';
        }
        return params.value;
      },
     },
    { field: 'ep_fecha', headerName: 'Fecha', flex: 1, minWidth: 60 },
    { field: 'ep_tipoTributo', headerName: 'Tipo de tributo', flex: 1.5, minWidth: 70, filter: true,
      cellRenderer: (params: any) => {
        // Buscar en todos los arrays de tipos de tributo
        const allTipos = [...this.tiposTributoSunat, ...this.tiposTributoAfp, ...this.tiposTributoMunicipalidad];
        const tipoObj = allTipos.find(t => t.value === params.value);
        return tipoObj ? tipoObj.label : params.value;
      }
    },
    { field: 'ep_periodopago', headerName: 'Periodo de pago', flex: 1, minWidth: 60 },
    { field: 'ep_monto', headerName: 'Monto', flex: 1, minWidth: 60,
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return 'S/ ' + new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
        }
        return '';
      },
      cellStyle: { textAlign: 'right' }
    },
    { field: 'ep_entidad', headerName: 'Entidad', flex: 1, minWidth: 60 },
    { field: 'ep_cuentaBancaria', headerName: 'Cuenta bancaria', flex: 1, minWidth: 120,
      cellRenderer: (params: any) => {
        const cuentaObj = this.cuentasBancarias.find(c => c.value === params.value);
        return cuentaObj ? cuentaObj.label : params.value;
      }
    },
    { field: 'ep_numeroOperacion', headerName: 'N° de operación', flex: 1, minWidth: 70 },
    { field: 'ep_usuario', headerName: 'Usuario', flex: 1.5, minWidth: 150, filter: true },
    { field: 'ep_asientoContable', headerName: 'Asiento contable', flex: 1.5, minWidth: 100, cellRenderer: VistaCellRenderComponent, },
    { 
      headerClass: 'centrarencabezado',
      field: 'ep_estado', 
      headerName: 'Estado', 
      flex: 1, 
      minWidth: 80,
      filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-[#363636]">Pendiente</span>';
        } else if (params.value === 'Pagado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagado</span>';
        } else if (params.value === 'Anulado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulado</span>';
        }
        return params.value;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    },
  ];

  rowDataPagos: EjecucionPagoEntity[] = [];

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
  
  cards=[
      {nombre:'Pagos pendientes', valor:'S/ 10,600.75', icono: faClock},
      {nombre:'Pagos pendientes (%)', valor:'48%', icono: faClock},
      {nombre:'Pagos ejecutados', valor:'S/ 10,000.00', icono: faCreditCard},
      {nombre:'Pagos ejecutados (%)', valor:'52%', icono: faPercentage}

    ]
  
  constructor(
    private modalController: ModalController,
    private countryService: CountryService,
    private fb: FormBuilder,
    private toastService: ToastService,
    private formValidationService: FormValidationService
  ) {
    this.initForm();
    this.context = { componentParent: this };
    effect(() => {
      const pagos = this.facade.pagos();
      this.rowDataPagos = pagos;
      if (this.gridApi) this.gridApi.setGridOption('rowData', this.rowDataPagos);
    });
  }

  ngOnInit() {
    this.cargarEntidad();
    this.obtenerdatospais();
    this.facade.cargarPagos();
  }

  ngOnDestroy() {
    this.facade.resetState();
    this.formValidationService.limpiarFormulario();
  }
  obtenerdatospais(){
    this.countries.find(country => {
      if(country.codigo === this.pais){
        this.tiposTributoSunat = country.tiposTributoSunat;
      }
    });
  }
  cargarEntidad(){
    if(this.pais == 'PE'){
      this.entesTributarios=this.entePer;
    } else{
      this.entesTributarios=this.enteDef;
    }
  }

  initForm() {
    this.pagoForm = this.fb.group({
      enteTributario: ['', Validators.required],
      tipoTributo: ['', Validators.required],
      cuentaBancaria: ['', Validators.required],
      moneda: ['', Validators.required],
      montoTotal: ['', Validators.required],
      numeroOperacion: ['', Validators.required],
      fechaPago: ['', Validators.required],
      estado: ['Pendiente', Validators.required],
      observaciones: ['']
    });
    this.tituloboton='Registrar';
    this.estadoActual = '';
    this.filaSeleccionada = null;
    this.formValidationService.inicializarFormulario(this.pagoForm);

    // Suscribirse a cambios del ente tributario
    this.pagoForm.get('enteTributario')?.valueChanges.subscribe(ente => {
      this.actualizarTiposTributo(ente);
      // Limpiar el tipo de tributo cuando cambia el ente
      this.pagoForm.patchValue({ tipoTributo: '' });
    });
  }

  onBtReset(){
    this.facade.cargarPagos();
  }

  actualizarTiposTributo(ente: string) {
    if (ente === '1') {
      this.tiposTributo = this.tiposTributoSunat;
      this.labelTipoTributo = 'Tipo de tributo';
      this.placeholderTipoTributo = 'Selecciona el tipo de tributo';
    } else if (ente === '2') {
      this.tiposTributo = this.tiposTributoAfp;
      this.labelTipoTributo = 'AFP';
      this.placeholderTipoTributo = 'Selecciona la AFP';
    } else if (ente === '3') {
      this.tiposTributo = this.tiposTributoMunicipalidad;
      this.labelTipoTributo = 'Tipo de impuesto';
      this.placeholderTipoTributo = 'Selecciona el tipo de impuesto';
    } else {
      this.tiposTributo = this.tiposTributoSunat;
      this.labelTipoTributo = 'Tipo de tributo';
      this.placeholderTipoTributo = 'Selecciona el tipo de tributo';
    }
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  async onCellClicked(event: any) {
    const data = event.data;  
    
    // Prevenir selección automática
    event.node.setSelected(false);
    
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;
    
    this.filaSeleccionada = data;
    
    // Seleccionar la fila en la tabla
    this.gridApi.deselectAll();
    event.node.setSelected(true);

    if (this.filaSeleccionada) {
        const fila = this.filaSeleccionada;
        let enteTributario = '';
        let tipoTributo = '';
        let cuentaBancaria = '';
        let moneda = '';
        
        // Actualizar tipos de tributo según el ente tributario PRIMERO
        this.actualizarTiposTributo(fila.ep_enteTributario);
        
        if(this.filaSeleccionada.ep_estado != 'Pendiente'){
          // Si no es pendiente, convertir códigos a labels para mostrar en inputs disabled
          // Obtener el nombre del ente tributario
          if (fila.ep_enteTributario === '1') {
            enteTributario = this.entidadtributaria;
          } else if (fila.ep_enteTributario === '2') {
            enteTributario = 'AFP';
          } else if (fila.ep_enteTributario === '3') {
            enteTributario = 'Municipalidad';
          } else {
            enteTributario = fila.ep_enteTributario;
          }
          
          // Obtener el label del tipo de tributo
          const tipoTributoObj = this.tiposTributo.find((t : any) => t.value === fila.ep_tipoTributo);
          tipoTributo = tipoTributoObj ? tipoTributoObj.label : fila.ep_tipoTributo;
          
          // Obtener el label de la cuenta bancaria
          const cuentaObj = this.cuentasBancarias.find(c => c.value === fila.ep_cuentaBancaria);
          cuentaBancaria = cuentaObj ? cuentaObj.label : fila.ep_cuentaBancaria;
          
          // Obtener el label de la moneda
          const monedaObj = this.monedas.find(m => m.value === fila.ep_moneda);
          moneda = monedaObj ? monedaObj.label : fila.ep_moneda;
        } else {
          // Si es pendiente, usar los valores directamente para los selects
          enteTributario = fila.ep_enteTributario;
          tipoTributo = fila.ep_tipoTributo;
          // ep_cuentaBancaria almacena el número de cuenta (label); buscar el value correspondiente
          const cuentaObj = this.cuentasBancarias.find(c => c.label === fila.ep_cuentaBancaria || c.value === fila.ep_cuentaBancaria);
          cuentaBancaria = cuentaObj ? cuentaObj.value : fila.ep_cuentaBancaria;
          moneda = fila.ep_moneda;
        }
                               
        // Parsear fecha
        const fechaParts = fila.ep_fecha.split('/');
        const fechaPago = new Date(parseInt(fechaParts[2]), parseInt(fechaParts[1]) - 1, parseInt(fechaParts[0]));
        
        // Formatear monto para mostrar en el formulario
        const montoFormateado = typeof fila.ep_monto === 'number' 
          ? fila.ep_monto.toFixed(2) 
          : fila.ep_monto;
        
        // Actualizar primero los campos que no dependen del tipo de tributo (sin emitir eventos)
        this.pagoForm.patchValue({
          enteTributario: enteTributario,
          cuentaBancaria: cuentaBancaria,
          moneda: moneda,
          montoTotal: montoFormateado,
          numeroOperacion: fila.ep_numeroOperacion,
          fechaPago: fechaPago,
          estado: fila.ep_estado,
          observaciones: fila.ep_observaciones || ''
        }, { emitEvent: false });
        
        // Actualizar el tipo de tributo después con un pequeño delay para asegurar que el array se actualizó
        setTimeout(() => {
          this.pagoForm.patchValue({
            tipoTributo: tipoTributo
          }, { emitEvent: false });
          
          setTimeout(() => {
            this.formValidationService.resetearEstado();
          }, 0);
        }, 0);
        
        // Cargar documento soporte si existe
        this.documentoSoporte = fila.ep_documentoSoporte || '';
        
        // Actualizar fecha del calendario
        this.fechaPagoInicial = new Date(fechaPago);
        
        // Actualizar estadoActual para controlar visibilidad de botones
        this.estadoActual = fila.ep_estado;
        
        // Cambiar título del botón según el estado
        if (fila.ep_estado === 'Pendiente') {
          this.tituloboton = 'Ejecutar pago';
        } else if (fila.ep_estado === 'Pagado' || fila.ep_estado === 'Anulado') {
          this.tituloboton = 'Guardar cambios';
        } else {
          this.tituloboton = 'Registrar';
        }
        
        // Si el estado es Pagado, deshabilitar el formulario
        if (fila.ep_estado === 'Pagado' || fila.ep_estado === 'Anulado') {
          this.pagoForm.disable({ emitEvent: false });
        } else {
          this.pagoForm.enable({ emitEvent: false });
          // Si el estado es Pendiente, deshabilitar solo el campo estado
          if (fila.ep_estado === 'Pendiente') {
            this.pagoForm.get('estado')?.disable({ emitEvent: false });
          }
        }
    }
  }

  filtrarPorFechas(event: { startDate: Date; endDate: Date }) {
    console.log('Rango de fechas seleccionado:', event);
    this.startDate = event.startDate;
    this.endDate = event.endDate;
  }

  async modalverConfirmacion() {
    console.log('Descargar archivo TXT para:', this.filaSeleccionada.length, 'filas');
  }

  onFileSelected(event: any): void {
    const file = event.target.files[0];
    if (file) {
      this.documentoSoporte = file.name;
    }
  }

  removeFile() {
    this.documentoSoporte = '';
  }
  async nuevopago(){
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;
    this.pagoForm.reset({
      estado: 'Pendiente'
    });
    this.pagoForm.enable({ emitEvent: false });
    this.filaSeleccionada = null;
    this.gridApi.deselectAll();
    this.documentoSoporte = '';
    this.estadoActual = '';
    this.fechaPagoInicial = undefined;
    this.formValidationService.resetearEstado();
  }
  guardar() {
    if (this.pagoForm.valid) {
      const formValue = this.pagoForm.value;

      // Formatear la fecha
      const fecha = formValue.fechaPago;
      const fechaFormateada = `${fecha.getDate().toString().padStart(2, '0')}/${(fecha.getMonth() + 1).toString().padStart(2, '0')}/${fecha.getFullYear()}`;

      // Convertir nombre de ente tributario a código
      let enteTributarioValue = formValue.enteTributario;
      if (enteTributarioValue === this.entidadtributaria) enteTributarioValue = '1';
      else if (enteTributarioValue === 'AFP') enteTributarioValue = '2';
      else if (enteTributarioValue === 'Municipalidad') enteTributarioValue = '3';

      // Convertir el monto a número
      const montoNumerico = typeof formValue.montoTotal === 'string'
        ? parseFloat(formValue.montoTotal.replace(/,/g, ''))
        : formValue.montoTotal;

      // Mapear cuenta bancaria: value = entidad (banco), label = número de cuenta
      const cuentaSeleccionada = this.cuentasBancarias.find(c => c.value === formValue.cuentaBancaria);
      const entidadBanco = cuentaSeleccionada?.value ?? formValue.cuentaBancaria;
      const numeroCuenta = cuentaSeleccionada?.label ?? formValue.cuentaBancaria;

      if (this.filaSeleccionada) {
        const nuevoEstado = this.estadoActual === 'Pendiente' ? 'Pagado' : formValue.estado;
        const entity: EjecucionPagoEntity = {
          ...this.filaSeleccionada,
          ep_enteTributario: enteTributarioValue,
          ep_fecha: fechaFormateada,
          ep_tipoTributo: formValue.tipoTributo,
          ep_monto: montoNumerico,
          ep_entidad: entidadBanco,
          ep_cuentaBancaria: numeroCuenta,
          ep_numeroOperacion: formValue.numeroOperacion,
          ep_moneda: formValue.moneda,
          ep_documentoSoporte: this.documentoSoporte,
          ep_estado: nuevoEstado,
        };
        this.facade.guardar(entity);
      } else {
        const codigo = `PT-2025-${String(4 + this.facade.pagos().length).padStart(3, '0')}`;
        const entity: EjecucionPagoEntity = {
          ep_codigo: codigo,
          ep_enteTributario: enteTributarioValue,
          ep_fecha: fechaFormateada,
          ep_tipoTributo: formValue.tipoTributo,
          ep_monto: montoNumerico,
          ep_entidad: entidadBanco,
          ep_cuentaBancaria: numeroCuenta,
          ep_numeroOperacion: formValue.numeroOperacion,
          ep_usuario: 'Usuario Actual',
          ep_periodopago: '202603',
          ep_asientoContable: '',
          ep_moneda: formValue.moneda,
          ep_documentoSoporte: this.documentoSoporte,
          ep_observaciones: formValue.observaciones || '',
          ep_estado: formValue.estado,
        };
        this.facade.guardar(entity);
      }

      this.initForm();
      this.filaSeleccionada = null;
      this.estadoActual = '';
      this.fechaPagoInicial = undefined;
      this.documentoSoporte = '';
      if (this.gridApi) this.gridApi.deselectAll();
    } else {
      this.pagoForm.markAllAsTouched();
      this.toastService.warning('Por favor, completa todos los campos requeridos.');
    }
  }

  getFormValidationErrors() {
    const errors: any = {};
    Object.keys(this.pagoForm.controls).forEach(key => {
      const controlErrors = this.pagoForm.get(key)?.errors;
      if (controlErrors) {
        errors[key] = controlErrors;
      }
    });
    return errors;
  }
  async anularPago() {
    if(!this.filaSeleccionada){
      this.toastService.warning('Debe seleccionar un pago para anular');
      return;
    }
    const detallesEjemplo: DetalleItem[] = [
      { label: 'Entidad tributaria', value: `${this.entidadtributaria}` },
      { label: 'Tipo de tributo', value: 'IGV' },
      { label: 'Monto', value: 'S/ 3,000.00' },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Anular pago',
        widthModal: '492px',
        subtitulomodal: 'Motivo de la anulación',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Anular',
        colorBotonConfirmar: 'danger'
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      if (!data.motivo || data.motivo.trim() === '') {
        this.toastService.warning('Debe ingresar el motivo de la anulación');
        setTimeout(() => { this.anularPago(); }, 100);
        return;
      }

      if (this.filaSeleccionada) {
        const fila = this.filaSeleccionada;
        const codigoAnulado = fila.ep_codigo;
        this.facade.anular(codigoAnulado);
        this.estadoActual = 'Anulado';

        // Convertir codes a labels para mostrar correctamente en formulario deshabilitado
        let enteTributarioLabel = fila.ep_enteTributario;
        if (fila.ep_enteTributario === '1') enteTributarioLabel = this.entidadtributaria;
        else if (fila.ep_enteTributario === '2') enteTributarioLabel = 'AFP';
        else if (fila.ep_enteTributario === '3') enteTributarioLabel = 'Municipalidad';

        const allTipos = [...this.tiposTributoSunat, ...this.tiposTributoAfp, ...this.tiposTributoMunicipalidad];
        const tipoObj = allTipos.find((t: any) => t.value === fila.ep_tipoTributo);
        const tipoTributoLabel = tipoObj ? tipoObj.label : fila.ep_tipoTributo;

        const cuentaObj = this.cuentasBancarias.find(c => c.label === fila.ep_cuentaBancaria || c.value === fila.ep_entidad);
        const cuentaBancariaLabel = cuentaObj ? cuentaObj.label : fila.ep_cuentaBancaria;

        const monedaObj = this.monedas.find(m => m.value === fila.ep_moneda);
        const monedaLabel = monedaObj ? monedaObj.label : fila.ep_moneda;

        this.pagoForm.patchValue({
          enteTributario: enteTributarioLabel,
          tipoTributo: tipoTributoLabel,
          cuentaBancaria: cuentaBancariaLabel,
          moneda: monedaLabel,
          estado: 'Anulado'
        }, { emitEvent: false });
        this.pagoForm.disable({ emitEvent: false });

        // Restaurar selección tras que el effect actualice rowData (300ms repo delay + margen)
        setTimeout(() => {
          this.gridApi.forEachNode(node => {
            if (node.data?.ep_codigo === codigoAnulado) {
              node.setSelected(true);
            }
          });
        }, 500);
      }
    }
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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del pago',},
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación del monto total',},
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de actualizaciones del pago ${this.filaSeleccionada?.ep_codigo || ""}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
  
      },
    });

    await modal.present();
  }
  async abrirModal(nroAsiento: string, rowData: any) {
    if (!nroAsiento || nroAsiento === '-') return;

    const detalles: DetalleItem[] = [
      { label: 'Fecha de registro', value: '12/12/2025' },
      { label: 'Fecha contable', value: '12/12/2025' },
      { label: 'Glosa', value: 'Provisión de servicios de internet – Local San Isidro (Mes 11/2025).' },
      { label: 'Total', value: 'S/380.00' },
      { label: 'Duplicado', value: 'No' }
    ];

    const colDefs: ColDef[] = [
      { field: 'cuenta', headerName: 'Cuenta', flex: 1 },
      { field: 'descripcion', headerName: 'Descripción', flex: 2 },
      { field: 'debeS', headerName: 'Debe(S/)', flex: 1, headerClass:'derechaencabezado', cellStyle: {textAlign: 'right',display: 'flex',justifyContent: 'right'}},
      { field: 'haberS', headerName: 'Haber(S/)', flex: 1, headerClass:'derechaencabezado', cellStyle: {textAlign: 'right',display: 'flex',justifyContent: 'right'}},
      { field: 'centroCosto', headerName: 'Centro de costo', flex: 1 },
      { field: 'docReferencial', headerName: 'Doc. referencial', flex: 1 },
      { field: 'tercero', headerName: 'Tercero', flex: 1 }
    ];

    const rowDataTabla = [
      {
        cuenta: '631109',
        descripcion: 'Servicios de internet',
        debeS: 'S/ 380.00',
        haberS: '-',
        centroCosto: 'CC-SI01',
        docReferencial: 'F001-000123',
        tercero: 'Claro Perú'
      },
      {
        cuenta: '421101',
        descripcion: 'Proveedores Nacionales / Cuentas por Pagar Comerciales',
        debeS: '-',
        haberS: 'S/380.00',
        centroCosto: 'CC-SI01',
        docReferencial: 'F001-000123',
        tercero: 'Claro Perú'
      }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Asiento ${nroAsiento}`,
        detalles: detalles,
        subtitulomodal: '',
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        mostrarTabla: true,
        colDefs: colDefs,
        rowData: rowDataTabla,
        mostrarTotal: true, 
        widthModal: '740px',
        itemstotal: [
          { label: 'Total debe (S/)', value: 'S/380.00' },
          { label: 'Total haber (S/)', value: '$112.94' },
        ],
        ocultarBotonConfirmar: true
      }
    });

    await modal.present();
  }

  /**
   * Implementa CanComponentDeactivate para proteger navegación
   */
  canDeactivate(): Observable<boolean> | Promise<boolean> | boolean {
    return this.formValidationService.canDeactivate();
  }

}
