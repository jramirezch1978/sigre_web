import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent, RowNodeTransaction } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CondicionPagoFacade } from '../../../../application/facades/condicion-pago.facade';
import { CondicionPagoEntity } from '../../../../domain/models/condicion-pago.entity';
import { CondicionPagoFeedbackEffects } from '../../../../effects/condicion-pago-feedback.effect';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';




@Component({
  selector: 'app-compras-tablas-condiciones-de-pago',
  templateUrl: './compras-tablas-condiciones-de-pago.component.html',
  styleUrls: ['./compras-tablas-condiciones-de-pago.component.scss'],
  standalone: false,
})
export class ComprasTablasCondicionesDePagoComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  // Inyección del Facade y Effects
  private readonly condicionPagoFacade = inject(CondicionPagoFacade);
  private readonly feedbackEffects = inject(CondicionPagoFeedbackEffects);

  // Selectores del store para UI reactiva
  readonly condicionesPago = this.condicionPagoFacade.condicionesPago;
  readonly isLoading = this.condicionPagoFacade.isLoading;
  readonly loadingObtener = this.condicionPagoFacade.loadingObtener;
  readonly loadingGuardar = this.condicionPagoFacade.loadingGuardar;
  readonly loadingEliminar = this.condicionPagoFacade.loadingEliminar;
  readonly loadingActualizar = this.condicionPagoFacade.loadingActualizar;

  CondicionesPagoForm!: FormGroup;
  estadoSeleccionado: string = '';
  gridApi!: GridApi;
  camponuevo: boolean = true;
  modoCreacion: boolean = true; // Variable para controlar el modo creación/edición
  filaSeleccionada: any = null;

  // Arrays para selectores
  tiposCondicion = [
    { value: 'Contado', label: 'Contado' },
    { value: 'Crédito', label: 'Crédito' },
    { value: 'Mixto', label: 'Mixto' }
  ];

  periocidadesCuotas = [
    { value: 'Semanal', label: 'Semanal' },
    { value: 'Quincenal', label: 'Quincenal' },
    { value: 'Mensual', label: 'Mensual' }
  ];

  estadosCondicion = [
    { value: 'Activo', label: 'Activo' },
    { value: 'Inactivo', label: 'Inactivo' }
  ];

  columnTypes = {
    currency: {
      width: 150,
    },
    shaded: {
      cellClass: 'shaded-class'
    }
  };


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

    defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  rowData: CondicionPagoEntity[] = [
    { condicion_pago_codigo: "CP-001", condicion_pago_nombre: "Contado", condicion_pago_tipo: "Contado", condicion_pago_plazo: "", condicion_pago_estado: "Activo" },
    { condicion_pago_codigo: "CP-002", condicion_pago_nombre: "15 días", condicion_pago_tipo: "Crédito", condicion_pago_plazo: "15 días", condicion_pago_periodicidad_cuotas: "Mensual", condicion_pago_estado: "Activo" },
    { condicion_pago_codigo: "CP-003", condicion_pago_nombre: "30 días", condicion_pago_tipo: "Crédito", condicion_pago_plazo: "30 días", condicion_pago_periodicidad_cuotas: "Mensual", condicion_pago_estado: "Activo" },
    { condicion_pago_codigo: "CP-004", condicion_pago_nombre: "45 días", condicion_pago_tipo: "Crédito", condicion_pago_plazo: "45 días", condicion_pago_periodicidad_cuotas: "Mensual", condicion_pago_estado: "Activo" },
    { condicion_pago_codigo: "CP-005", condicion_pago_nombre: "60 días", condicion_pago_tipo: "Crédito", condicion_pago_plazo: "60 días", condicion_pago_periodicidad_cuotas: "Mensual", condicion_pago_estado: "Activo" },
    { condicion_pago_codigo: "CP-006", condicion_pago_nombre: "90 días", condicion_pago_tipo: "Crédito", condicion_pago_plazo: "90 días", condicion_pago_periodicidad_cuotas: "Mensual", condicion_pago_estado: "Activo" },
    { condicion_pago_codigo: "CP-007", condicion_pago_nombre: "2 cuotas", condicion_pago_tipo: "Mixto", condicion_pago_plazo: "60 días", condicion_pago_estado: "Activo" },
    { condicion_pago_codigo: "CP-008", condicion_pago_nombre: "3 cuotas", condicion_pago_tipo: "Mixto", condicion_pago_plazo: "90 días", condicion_pago_estado: "Activo" },
    { condicion_pago_codigo: "CP-009", condicion_pago_nombre: "Adelantado", condicion_pago_tipo: "Contado", condicion_pago_plazo: "", condicion_pago_estado: "Activo" },
    { condicion_pago_codigo: "CP-010", condicion_pago_nombre: "Letra 30 días", condicion_pago_tipo: "Crédito", condicion_pago_plazo: "30 días", condicion_pago_periodicidad_cuotas: "Mensual", condicion_pago_estado: "Inactivo" },
  ];

  colDefs: ColDef[] = [
    { field: "condicion_pago_codigo", headerName: "Código", headerClass: 'ag-header-hover ag-header-10px', flex: 1, filter: true },
    { field: "condicion_pago_nombre", headerName: "Nombre", headerClass: 'ag-header-hover ag-header-10px', flex: 1, filter: true },
    { field: "condicion_pago_tipo", headerName: "Tipo de condición", headerClass: 'ag-header-hover ag-header-10px', flex: 1, filter: true },
    { 
      field: "condicion_pago_plazo", 
      headerName: "Plazo", 
      headerClass: 'ag-header-hover ag-header-10px', 
      flex: 1,
      valueFormatter: (params) => {
        return params.value === null || params.value === undefined || params.value === ''
          ? '–'
          : params.value;
      }
    },
    { 
      field: "condicion_pago_cuotas", 
      headerName: "Cuotas", 
      headerClass: 'ag-header-hover ag-header-10px', 
      flex: 1,
      valueFormatter: (params) => {
        return params.value === null || params.value === undefined || params.value === ''
          ? '–'
          : params.value;
      }
    },
    {
      field: "condicion_pago_estado", headerName: "Estado", headerClass: 'centrarencabezado', filter: true, flex: 1,
      cellRenderer: (params: any) => {
        const estado = params.value;
        const estadoClass = estado === 'Activo' ? 'text-green-600 bg-green-100' : 'text-red-600 bg-red-100';
        return `<span class="px-2 py-[1px] rounded-full text-xxss font-medium ${estadoClass}">${estado}</span>`;
      },
      cellStyle: {
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    },
  ];

  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastservice: ToastService,
    private formValidationService: FormValidationService
  ) {
    // Effect para actualizar la tabla cuando cambian los datos del store
    effect(() => {
      const condiciones = this.condicionesPago();
      this.rowData = condiciones;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
        // Re-seleccionar la fila activa si estamos en modo edición
        if (this.filaSeleccionada) {
          const codigoSeleccionado = this.filaSeleccionada.condicion_pago_codigo;
          setTimeout(() => {
            this.gridApi.forEachNode(node => {
              if (node.data?.condicion_pago_codigo === codigoSeleccionado) {
                node.setSelected(true);
              }
            });
          }, 0);
        }
      }
    });
  }

  ngOnInit() {
    this.CondicionesPagoForm = this.formBuilder.group({
      search: new FormControl(''),
      filtroEstado: new FormControl('todos'),
      nombre: new FormControl(''),
      tipoCondicion: new FormControl(''),
      plazopagos: new FormControl(''),
      cuotas: new FormControl(''),
      periocidadCuotas: new FormControl(''),
      descripcion: new FormControl(''),
      estado: new FormControl('Activo'),
    });

    // Listener para cambios de tipo de condición
    this.CondicionesPagoForm.get('tipoCondicion')?.valueChanges.subscribe((tipoNuevo) => {
      console.log('  Tipo de condición cambió a:', tipoNuevo);
      
      if (tipoNuevo === 'Crédito') {
        // Si cambia a crédito y no tiene plazo, asignar valores por defecto
        if (!this.CondicionesPagoForm.get('plazopagos')?.value) {
          this.CondicionesPagoForm.patchValue({
            plazopagos: '30',
            periocidadCuotas: 'Mensual'
          });
          console.log('  Auto-completado: Plazo=30, Periocidad=Mensual');
        }
      } else if (tipoNuevo === 'Mixto') {
        // Si cambia a mixto y no tiene plazo, asignar valor por defecto
        if (!this.CondicionesPagoForm.get('plazopagos')?.value) {
          this.CondicionesPagoForm.patchValue({
            plazopagos: '60'
          });
          console.log('  Auto-completado: Plazo=60');
        }
      } else if (tipoNuevo === 'Contado') {
        // Si cambia a contado, limpiar plazo y periocidad
        this.CondicionesPagoForm.patchValue({
          plazopagos: '',
          periocidadCuotas: '',
          cuotas: ''
        });
        console.log('  Limpiado para CONTADO');
      }
    });

    // Inicializar servicio de validación de formularios
    this.formValidationService.inicializarFormulario(this.CondicionesPagoForm);

    // Registrar callbacks para limpiar formulario después de guardar/actualizar con éxito
    this.feedbackEffects.registrarCallbacks({
      onGuardarExito: () => this.resetearFormularioDespuesDeGuardar(),
      onActualizarExito: () => {
        // Actualizar filaSeleccionada con el objeto nuevo del store
        if (this.filaSeleccionada) {
          const actualizado = this.rowData.find(
            c => c.condicion_pago_codigo === this.filaSeleccionada.condicion_pago_codigo
          );
          if (actualizado) this.filaSeleccionada = actualizado;
        }
        this.formValidationService.resetearEstado();
      }
    });

    // Cargar condiciones de pago usando el facade
    this.cargarCondicionesPagoDesdeStore();
  }

  /**
   * Cargar condiciones de pago desde el store usando el facade
   */
  cargarCondicionesPagoDesdeStore() {
    console.log('  Cargando condiciones de pago desde el store...');
    this.condicionPagoFacade.cargarCondicionesPago();
  }

  async onCellClicked(event: any) {
    if (!event.data) return;

    const data = event.data;

    // Guardar referencia del elemento que tiene el foco actualmente
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Mantener selección anterior
      if (this.filaSeleccionada) {
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
            if (node.data.condicion_pago_codigo === this.filaSeleccionada.condicion_pago_codigo) {
              node.setSelected(true);
            }
          });
          // Restaurar foco si es un input
          if (elementoConFoco && (elementoConFoco.tagName === 'INPUT' || elementoConFoco.tagName === 'ION-INPUT')) {
            elementoConFoco.focus();
          }
        }, 50);
      } else {
        this.gridApi.deselectAll();
      }
      return;
    }

    // Usuario confirmó - proceder con la selección
    if (this.gridApi) {
      this.gridApi.deselectAll();
      // Usar event.node directamente (ya está disponible)
      event.node.setSelected(true);
    }

    this.camponuevo = false;
    this.modoCreacion = false;
    
    // IMPORTANTE: Obtener la referencia EXACTA del objeto en rowData
    const filaEnRowData = this.rowData.find(row => row.condicion_pago_codigo === data.condicion_pago_codigo);
    if (filaEnRowData) {
      this.filaSeleccionada = filaEnRowData;
      console.log(' Referencia correcta del rowData para edición');
    } else {
      this.filaSeleccionada = data;
      console.log('  Usando referencia del evento, no del rowData');
    }
    
    console.log('filaSeleccionada está en rowData?', this.rowData.includes(this.filaSeleccionada));
    
    this.cargarDatosEnFormulario(this.filaSeleccionada);

    // Habilitar TODOS los campos en modo edición para que se puedan editar
    this.CondicionesPagoForm.get('tipoCondicion')?.enable();
    this.CondicionesPagoForm.get('plazopagos')?.enable();
    this.CondicionesPagoForm.get('cuotas')?.enable();
    this.CondicionesPagoForm.get('periocidadCuotas')?.enable();
    this.CondicionesPagoForm.get('nombre')?.enable();
    this.CondicionesPagoForm.get('descripcion')?.enable();
    this.CondicionesPagoForm.get('estado')?.enable();

    // Resetear servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }

  onBtReset() {
      this.cargarCondicionesPagoDesdeStore();
  }

  async botonNuevaCondicion() {
    // Validar cambios antes de limpiar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Usuario canceló, mantener el formulario actual
    }

    // Limpiar estado
    this.camponuevo = true;
    this.modoCreacion = true;
    this.filaSeleccionada = null;

    // Deseleccionar filas de la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Resetear formulario con valores por defecto
    this.CondicionesPagoForm.reset({
      estado: 'Activo',
    });

    // Habilitar todos los campos para nueva condición
    this.CondicionesPagoForm.get('tipoCondicion')?.enable();
    this.CondicionesPagoForm.get('plazopagos')?.enable();
    this.CondicionesPagoForm.get('cuotas')?.enable();
    this.CondicionesPagoForm.get('periocidadCuotas')?.enable();

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

botonGuardar() {
  const formValues = this.CondicionesPagoForm.getRawValue();
  const tipoCondicion = formValues.tipoCondicion;
  let camposFaltantes = [];

  console.log('=== VALIDACIÓN INICIO ===');
  console.log('Modo creación:', this.modoCreacion);
  console.log('filaSeleccionada:', this.filaSeleccionada);

  // Validar nombre siempre
  if (!formValues.nombre || !formValues.nombre.trim()) {
    camposFaltantes.push('Nombre');
  }

  // Validar tipo siempre
  if (!formValues.tipoCondicion || !formValues.tipoCondicion.trim()) {
    camposFaltantes.push('Tipo de condición');
  }

  // Validación según el tipo seleccionado
  if (tipoCondicion === 'Crédito') {
    if (!formValues.plazopagos || !formValues.plazopagos.toString().trim()) {
      camposFaltantes.push('Plazo de pagos');
    }
    if (!formValues.periocidadCuotas || !formValues.periocidadCuotas.toString().trim()) {
      camposFaltantes.push('Periocidad de cuotas');
    }
  } else if (tipoCondicion === 'Mixto') {
    if (!formValues.plazopagos || !formValues.plazopagos.toString().trim()) {
      camposFaltantes.push('Plazo de pagos');
    }
  }

  if (camposFaltantes.length > 0) {
    console.log('  VALIDACIÓN FALLÓ. Campos faltantes:', camposFaltantes);
    this.toastservice.warning('Por favor, completa todos los campos requeridos');
    return;
  }

  console.log('  VALIDACIÓN PASÓ');

  // Convertir periocidad de cuotas a días automáticamente
  const periocidadADias = (periocidad: string) => {
    switch(periocidad?.toLowerCase()) {
      case 'semanal': return '7 días';
      case 'quincenal': return '15 días';
      case 'mensual': return '30 días';
      default: return formValues.plazopagos ? formValues.plazopagos + ' días' : '0 días';
    }
  };

  const plazoFinal = tipoCondicion === 'Contado' 
    ? '' 
    : (tipoCondicion === 'Crédito' && formValues.periocidadCuotas 
        ? periocidadADias(formValues.periocidadCuotas)
        : (formValues.plazopagos ? formValues.plazopagos + ' días' : '0 días'));

  // Crear la entidad CondicionPagoEntity
  const condicionPago: CondicionPagoEntity = {
    condicion_pago_codigo: this.modoCreacion ? '' : this.filaSeleccionada?.condicion_pago_codigo || '',
    condicion_pago_nombre: formValues.nombre || '',
    condicion_pago_tipo: tipoCondicion || 'Contado',
    condicion_pago_plazo: plazoFinal,
    condicion_pago_cuotas: (tipoCondicion === 'Contado' || tipoCondicion === 'Mixto') ? '' : (formValues.cuotas || '1'),
    condicion_pago_periodicidad_cuotas: tipoCondicion === 'Contado' ? '' : (formValues.periocidadCuotas || ''),
    condicion_pago_descripcion: formValues.descripcion || '',
    condicion_pago_estado: formValues.estado || 'Activo'
  };

  // Determinar si es edición o creación
  if (!this.modoCreacion && this.filaSeleccionada) {
    console.log('  EDITANDO REGISTRO:', condicionPago.condicion_pago_codigo);
    this.condicionPagoFacade.actualizarCondicionPago(condicionPago);
  } else {
    console.log('  CREANDO NUEVO REGISTRO');
    this.condicionPagoFacade.guardarCondicionPago(condicionPago);
  }

  console.log('=== GUARDADO INICIADO ===');
}
  refrescarVista() {
    this.cargarCondicionesPagoDesdeStore();
  }

  /** Resetea el formulario a estado limpio después de un guardado/actualización exitoso */
  private resetearFormularioDespuesDeGuardar(): void {
    this.filaSeleccionada = null;
    this.camponuevo = true;
    this.modoCreacion = true;

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    this.CondicionesPagoForm.reset({ estado: 'Activo' });
    this.formValidationService.resetearEstado();
  }

  ngOnDestroy(): void {
    this.formValidationService.limpiarFormulario();
  }



  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // Seleccionar la primera fila por defecto
    // setTimeout(() => {
    //   const firstNode = this.gridApi.getDisplayedRowAtIndex(0);
    //   if (firstNode) {
    //     firstNode.setSelected(true);
    //     this.filaSeleccionada = firstNode.data;
    //     this.camponuevo = false;
    //     this.cargarDatosEnFormulario(firstNode.data);
    //   }
    // }, 100);
  }

  private cargarDatosEnFormulario(data: any) {
    console.log('  CARGANDO DATOS EN FORMULARIO...');
    console.log('Datos originales de la fila:', data);

    // Convertir el label al value del tipo de condición
    let tipoValue = data.condicion_pago_tipo;
    const tipoEncontrado = this.tiposCondicion.find(t => 
      t.value.toLowerCase() === data.condicion_pago_tipo.toLowerCase() ||
      t.label.toLowerCase() === data.condicion_pago_tipo.toLowerCase()
    );
    if (tipoEncontrado) {
      tipoValue = tipoEncontrado.value;
      console.log('Tipo encontrado:', tipoEncontrado.label, '→ value:', tipoValue);
    } else {
      console.log('  Tipo NO encontrado:', data.condicion_pago_tipo);
    }

    // Extraer periocidad del plazo o usar la almacenada
    const diasAPeriodicidad = (plazo: string) => {
      if (!plazo) return 'Mensual'; // Por defecto
      if (plazo.includes('7')) return 'Semanal';
      if (plazo.includes('15')) return 'Quincenal';
      if (plazo.includes('30')) return 'Mensual';
      return 'Mensual';
    };

    const extraerNumero = (valor: string) => {
      if (!valor) return '';
      const match = valor.toString().match(/\d+/);
      return match ? match[0] : '';
    };

    const plazoExtraido = extraerNumero(data.condicion_pago_plazo);
    console.log('Plazo original:', data.condicion_pago_plazo, '→ Extraído:', plazoExtraido);
    
    // Para crédito, extraer la periocidad del plazo si no está guardada
    let periocidadCarga = data.condicion_pago_periodicidad_cuotas || '';
    if (tipoValue === 'Crédito' && !periocidadCarga && data.condicion_pago_plazo) {
      periocidadCarga = diasAPeriodicidad(data.condicion_pago_plazo);
      console.log('Periocidad extraída del plazo:', periocidadCarga);
    } else if (tipoValue === 'Crédito' && !periocidadCarga) {
      periocidadCarga = 'Mensual'; // Por defecto para crédito
      console.log('Periocidad por defecto para crédito: Mensual');
    }
    
    console.log('Periocidad a cargar:', periocidadCarga);

    this.CondicionesPagoForm.patchValue({
      nombre: data.condicion_pago_nombre || '',
      tipoCondicion: tipoValue,
      plazopagos: plazoExtraido || (tipoValue === 'Crédito' ? '30' : ''),
      cuotas: data.condicion_pago_cuotas || '',
      periocidadCuotas: periocidadCarga,
      descripcion: data.condicion_pago_descripcion || '',
      estado: data.condicion_pago_estado || '',
    });

    console.log('  Valores cargados en el formulario:', this.CondicionesPagoForm.value);
  }

  private deshabilitarCamposSegunTipo(tipo: string) {
    const periocidadControl = this.CondicionesPagoForm.get('periocidadCuotas');

    // Solo mostrar/ocultar validaciones según el tipo - NO deshabilitar campos
    // Todos los campos permanecen habilitados para edición

    // Periocidad solo se habilita en crédito y solo en creación
    if (tipo === 'Crédito') {
      if (periocidadControl) periocidadControl.enable();
    } else {
      if (periocidadControl) periocidadControl.disable();
    }
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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial de la condición de pago "30 días" con tipo Crédito' },
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de la condición de pago "60 días' },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - Lista de Condiciones de Pago',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

}

