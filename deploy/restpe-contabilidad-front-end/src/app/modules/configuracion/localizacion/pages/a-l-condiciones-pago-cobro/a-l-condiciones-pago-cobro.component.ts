import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ConfiguracionFacade } from '../../../application/facades/configuracion.facade';
import { ConfiguracionCondicionesPagoCobroGridEffects } from '../../../effects/configuracion-condiciones-pago-cobro-grid.effect';
import { CondicionPagoCobroEntity } from '../../../domain/models/condicion-pago-cobro.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-a-l-condiciones-pago-cobro',
  templateUrl: './a-l-condiciones-pago-cobro.component.html',
  styleUrls: ['./a-l-condiciones-pago-cobro.component.scss'],
  standalone: false
})
export class ALCondicionesPagoCobroComponent implements OnInit, OnDestroy {
  // Inyecciones
  private readonly configuracionFacade = inject(ConfiguracionFacade);
  private readonly condicionesGridEffects = inject(ConfiguracionCondicionesPagoCobroGridEffects);

  // Selectores reactivos del store
  readonly condicionesPagoCobro = this.configuracionFacade.condicionesPagoCobro;
  readonly loadingCondicionesPagoCobro = this.configuracionFacade.loadingCondicionesPagoCobro;
  readonly isLoading = this.configuracionFacade.isLoading;

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  private gridApi!: GridApi;
  filaSeleccionada: any = null;
  cargando = false;
  isResetting = false;
  condicionForm!: FormGroup;
  camponuevo: boolean = false;
  modoCreacion: boolean = true;

  cuentasContables: any[] = [
    { id: '1', codigo: '1011', nombre: '1011 - Caja' },
    { id: '2', codigo: '1041', nombre: '1041 - Cuentas corrientes operativas' },
    { id: '3', codigo: '1211', nombre: '1211 - Facturas por cobrar' },
    { id: '4', codigo: '1212', nombre: '1212 - Letras por cobrar' },
    { id: '5', codigo: '4111', nombre: '4111 - Cuentas por pagar comerciales' },
    { id: '6', codigo: '4211', nombre: '4211 - Remuneraciones por pagar' },
  ];
  periodicidad: any[] = [
    { id: 'Diario', nombre: 'Diaria' },
    { id: 'Semanal', nombre: 'Semanal' },
    { id: 'Quincenal', nombre: 'Quincenal' },
    { id: 'Mensual', nombre: 'Mensual' },
  ]
  tiposAplicacion: any[] = [
    { id: 'Pago', nombre: 'Pago' },
    { id: 'Cobro', nombre: 'Cobro' },
    { id: 'Ambos', nombre: 'Ambos' },
  ];

  modalidades: any[] = [
    { id: 'Contado', nombre: 'Contado' },
    { id: 'Crédito', nombre: 'Crédito' },
    { id: 'Cuotas', nombre: 'Cuotas' },
  ];

  estados: any[] = [
    { id: 'Activo', nombre: 'Activo' },
    { id: 'Inactivo', nombre: 'Inactivo' },
  ];

  columnTypes = {
    default: {
      resizable: false,
      sortable: false,
      filter: false,
      floatingFilter: false,
    }
  };

  colDefs: ColDef[] = [
    { field: 'condicion_pago_cobro_codigo', headerName: 'Código', width: 90 },
    { field: 'condicion_pago_cobro_nombre', headerName: 'Nombre', flex:1, minWidth:150 },
    { field: 'condicion_pago_cobro_aplicacion', headerName: 'Aplicación', width: 100, filter:true },
    { field: 'condicion_pago_cobro_modalidad', headerName: 'Modalidad', width: 100, filter:true, },
    { field: 'condicion_pago_cobro_dias_credito', headerName: 'Días de crédito', width: 130 },
    { field: 'condicion_pago_cobro_num_cuotas', headerName: 'N° cuotas', width: 90 },
    { field: 'condicion_pago_cobro_periodicidad', headerName: 'Periodicidad', width: 110 },
    { field: 'condicion_pago_cobro_cuenta_contable', headerName: 'Cuenta contable', width: 130 },
    { 
      field: 'condicion_pago_cobro_estado', 
      filter:true,
      headerName: 'Estado', 
      width: 100,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FEE2E2] text-[#DC2626]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      }
    }
  ];

  get rowData(): CondicionPagoCobroEntity[] {
    return this.condicionesGridEffects.getRowData();
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
    private formValidationService: FormValidationService
  ) { }

  ngOnInit() {
    this.inicializarFormulario();
    
    // Inicializar servicio de validación
    this.formValidationService.inicializarFormulario(this.condicionForm);
    
    this.camponuevo = true;
    this.modoCreacion = true;
    this.limpiarFormulario();
    this.suscribirCambiosModalidad();
    
    // Limpiar estado previo para forzar loader en cada entrada
    this.configuracionFacade.clearCondicionesPagoCobro();
    
    // Cargar condiciones de pago/cobro desde el JSON
    this.configuracionFacade.cargarCondicionesPagoCobro();
    
    // Resetear servicio después de la inicialización
    this.formValidationService.resetearEstado();
  }

  suscribirCambiosModalidad() {
    this.condicionForm.get('modalidad')?.valueChanges.subscribe(modalidad => {
      if (modalidad === 'Contado') {
        this.condicionForm.get('interesFinanciero')?.setValue('');
        this.condicionForm.get('porcentajeCuota')?.setValue('');
        this.condicionForm.get('interesFinancieroCuotas')?.setValue('');
      }
    });
  }

  mostrarInteresFinanciero(): boolean {
    return this.condicionForm.get('modalidad')?.value === 'Crédito';
  }
  mostrarOpcionescategoria(): boolean {
    return this.condicionForm.get('modalidad')?.value === 'Cuotas';
  }
  mostrarOpcionescredito(): boolean {
    return this.condicionForm.get('modalidad')?.value === 'Crédito';
  }
  inicializarFormulario() {
    this.condicionForm = this.fb.group({
      codigo: [{ value: '', disabled: true }],
      nombre: ['', Validators.required],
      tipoAplicacion: ['', Validators.required],
      modalidad: ['', Validators.required],
      diasCredito: [''],
      numCuotas: [''],
      periodicidad: [''],
      porcentajeCuota: [''],
      interesFinanciero: [''],
      interesFinancieroCuotas: [''],
      cuentaContable: ['', Validators.required],
      estado: ['Activo', Validators.required]
    });
  }

  cargarDatosFormulario(data: any) {
    this.condicionForm.patchValue({
      codigo: data.condicion_pago_cobro_codigo || '',
      nombre: data.condicion_pago_cobro_nombre || '',
      tipoAplicacion: data.condicion_pago_cobro_aplicacion || '',
      modalidad: data.condicion_pago_cobro_modalidad || '',
      diasCredito: data.condicion_pago_cobro_dias_credito && data.condicion_pago_cobro_dias_credito !== '-' ? data.condicion_pago_cobro_dias_credito : '',
      numCuotas: data.condicion_pago_cobro_num_cuotas && data.condicion_pago_cobro_num_cuotas !== '-' ? data.condicion_pago_cobro_num_cuotas : '',
      periodicidad: data.condicion_pago_cobro_periodicidad && data.condicion_pago_cobro_periodicidad !== '-' ? data.condicion_pago_cobro_periodicidad : '',
      porcentajeCuota: data.porcentajeCuota || '',
      interesFinanciero: data.interesFinanciero || '',
      interesFinancieroCuotas: data.interesFinancieroCuotas || '',
      cuentaContable: data.condicion_pago_cobro_cuenta_contable || '',
      estado: data.condicion_pago_cobro_estado || 'Activo'
    });
    
    // Resetear servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }

  limpiarFormulario() {
    this.condicionForm.reset({
      estado: 'Activo'
    });
    this.condicionForm.markAsPristine();
    this.condicionForm.markAsUntouched();
    this.camponuevo = false;
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.formValidationService.resetearEstado();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.condicionesGridEffects.setGridApi(params.api);
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
            if (node.data.condicion_pago_cobro_codigo === this.filaSeleccionada.condicion_pago_cobro_codigo) {
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
    
    console.log('Condición seleccionada:', data);
  }

  onCuentaContableSeleccionada(cuenta: any) {
    console.log('Cuenta contable seleccionada:', cuenta);
  }

  onBtReset(): void {
    this.isResetting = true;
    this.configuracionFacade.cargarCondicionesPagoCobro();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

  async botonNuevaCondicion() {
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

  async botonCancelar() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    this.limpiarFormulario();
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  validarCamposObligatorios(): string[] {
    const formValues = this.condicionForm.getRawValue();
    const camposFaltantes: string[] = [];
    
    // Campos siempre obligatorios
    if (!formValues.nombre) camposFaltantes.push('nombre');
    if (!formValues.tipoAplicacion) camposFaltantes.push('tipoAplicacion');
    if (!formValues.modalidad) camposFaltantes.push('modalidad');
    if (!formValues.cuentaContable) camposFaltantes.push('cuentaContable');
    if (!formValues.estado) camposFaltantes.push('estado');
    
    // Campos condicionalmente obligatorios según la modalidad
    const modalidad = formValues.modalidad;
    if (modalidad === 'Crédito' && !formValues.diasCredito) {
      camposFaltantes.push('diasCredito');
    }
    if (modalidad === 'Cuotas') {
      if (!formValues.numCuotas) camposFaltantes.push('numCuotas');
      if (!formValues.periodicidad) camposFaltantes.push('periodicidad');
    }
    
    return camposFaltantes;
  }

  botonGuardar() {
    // Validar campos obligatorios
    const camposObligatorios = this.validarCamposObligatorios();
    if (camposObligatorios.length > 0) {
      const nombresAmigables: { [key: string]: string } = {
        'nombre': 'Nombre',
        'tipoAplicacion': 'Tipo de aplicación',
        'modalidad': 'Modalidad',
        'diasCredito': 'Días de crédito',
        'numCuotas': 'N° de cuotas',
        'periodicidad': 'Periodicidad de cuotas',
        'cuentaContable': 'Cuenta contable',
        'estado': 'Estado'
      };
      const camposFormateados = camposObligatorios.map(campo => nombresAmigables[campo] || campo).join(', ');
      this.toastService.warning(`Por favor, completa todos los campos requeridos`);
      return;
    }

    if (this.condicionForm.valid) {
      const formValues = this.condicionForm.getRawValue(); // Usa getRawValue() para obtener campos disabled
      const modalidad = formValues.modalidad;
      
      // Generar código automático si es modo creación
      const codigo = this.modoCreacion ? this.generarCodigoAutomatico() : formValues.codigo;
      
      // Preparar datos para la tabla
      const nuevaCondicion = {
        condicion_pago_cobro_codigo: codigo,
        condicion_pago_cobro_nombre: formValues.nombre,
        condicion_pago_cobro_aplicacion: formValues.tipoAplicacion,
        condicion_pago_cobro_modalidad: formValues.modalidad,
        condicion_pago_cobro_dias_credito: modalidad === 'Crédito' ? formValues.diasCredito : '-',
        condicion_pago_cobro_num_cuotas: modalidad === 'Cuotas' ? formValues.numCuotas : '-',
        condicion_pago_cobro_periodicidad: modalidad === 'Cuotas' ? formValues.periodicidad : '-',
        interesFinanciero: formValues.interesFinanciero || '-',
        condicion_pago_cobro_cuenta_contable: formValues.cuentaContable,
        condicion_pago_cobro_estado: formValues.estado
      };
      
      if (this.modoCreacion) {
        // Agregar nueva condición a la tabla (al inicio)
        const currentData = this.condicionesGridEffects.getRowData();
        this.condicionesGridEffects.setRowData([nuevaCondicion, ...currentData]);
        
        // Ir a la primera página para mostrar el nuevo registro
        if (this.gridApi) {
          this.gridApi.paginationGoToFirstPage();
        }
        
        this.toastService.success('¡Condición registrada exitosamente!');
        console.log('Nueva condición agregada:', nuevaCondicion);
        
        // Limpiar formulario para registro rápido
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
        // Editar condición existente
        const currentData = this.condicionesGridEffects.getRowData();
        const index = currentData.findIndex(item => item === this.filaSeleccionada);
        
        if (index !== -1) {
          const updatedData = [...currentData];
          updatedData[index] = nuevaCondicion;
          this.condicionesGridEffects.setRowData(updatedData);
          this.filaSeleccionada = nuevaCondicion;
          
          // Re-seleccionar la fila editada
          if (this.gridApi) {
            setTimeout(() => {
              this.gridApi.forEachNode((node) => {
                if (node.data === nuevaCondicion) {
                  node.setSelected(true);
                }
              });
            }, 100);
          }
          
          this.toastService.success('¡Cambios guardados exitosamente!');
          console.log('Condición actualizada:', nuevaCondicion);
        }
        
        // Marcar como pristine después de guardar edición
        this.condicionForm.markAsPristine();
        
        // Resetear servicio de validación
        this.formValidationService.resetearEstado();
      }
    }
  }

  puedeGuardar(): boolean {
    return this.condicionForm.valid;
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
      { historial_actualizacion_fecha_hora: '18/10/2025 09:20', historial_actualizacion_usuario: 'Carlos López', historial_actualizacion_accion: 'Creación', historial_actualizacion_detalle_cambio: 'Registro inicial de la condición de pago'},
      { historial_actualizacion_fecha_hora: '19/10/2025 16:45', historial_actualizacion_usuario: 'Ana Gómez', historial_actualizacion_accion: 'Actualización', historial_actualizacion_detalle_cambio: 'Modificación de cuenta contable asociada' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones de Condición',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });
    
    await modal.present();
  }

  // Generar código automático basado en la modalidad
  private generarCodigoAutomatico(): string {
    const formValues = this.condicionForm.getRawValue();
    const modalidad = formValues.modalidad;
    
    let prefijo = '';
    
    // Determinar prefijo según la modalidad
    switch(modalidad) {
      case 'Contado':
        prefijo = 'CTD';
        break;
      case 'Crédito':
        prefijo = 'CRD';
        break;
      case 'Cuotas':
        prefijo = 'CTA';
        break;
      default:
        prefijo = 'CND';
    }
    
    // Buscar el mayor número para este prefijo
    let maxNumero = 0;
    const currentData = this.condicionesGridEffects.getRowData();
    currentData.forEach(item => {
      if (item.condicion_pago_cobro_codigo && item.condicion_pago_cobro_codigo.startsWith(prefijo)) {
        const match = item.condicion_pago_cobro_codigo.match(new RegExp(`${prefijo}-(\\d+)`));
        if (match) {
          const numero = parseInt(match[1]);
          if (numero > maxNumero) {
            maxNumero = numero;
          }
        }
      }
    });
    
    // Si la modalidad es Crédito, incluir los días de crédito
    if (modalidad === 'Crédito' && formValues.diasCredito) {
      return `${prefijo}-${formValues.diasCredito}`;
    }
    
    // Para Cuotas, incluir el número de cuotas
    if (modalidad === 'Cuotas' && formValues.numCuotas) {
      const siguienteNumero = maxNumero + 1;
      return `${prefijo}-${formValues.numCuotas}C-${siguienteNumero.toString().padStart(2, '0')}`;
    }
    
    // Para Contado, solo el prefijo
    if (modalidad === 'Contado') {
      return prefijo;
    }
    
    // Caso por defecto: prefijo + número secuencial
    const siguienteNumero = maxNumero + 1;
    return `${prefijo}-${siguienteNumero.toString().padStart(3, '0')}`;
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }
}
