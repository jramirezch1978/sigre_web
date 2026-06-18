import { Component, OnInit, inject, computed, effect } from '@angular/core';
import { ModalController } from '@ionic/angular';
import {
  ColDef,
  GridApi,
  GridReadyEvent,
  GridState,
  RowSelectionOptions,
} from 'ag-grid-community';
import { FormGroup, FormBuilder, FormControl, Validators } from '@angular/forms';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import {
  DetalleItem,
  ModalDetalleComponent,
} from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { TipoDeCambioEntity } from 'src/app/modules/contabilidad/domain/models/tipo-de-cambio.entity';
import { TipoDeCambioFacade } from 'src/app/modules/contabilidad/application/facades/tipo-de-cambio.facade';
import { TipoDeCambioFeedbackEffects } from 'src/app/modules/contabilidad/effects/tipo-de-cambio-feedback.effect';
import { TipoDeCambioSyncEffects } from 'src/app/modules/contabilidad/effects/tipo-de-cambio-sync.effect';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';

// Font Awesome Icons
import { faInfoCircle } from '@fortawesome/pro-light-svg-icons';
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-contabilidad-tabla-tipodecambio',
  templateUrl: './contabilidad-tabla-tipodecambio.component.html',
  styleUrls: ['./contabilidad-tabla-tipodecambio.component.scss'],
  standalone: false,
})
export class ContabilidadTablaTipodecambioComponent implements OnInit {
  // Font Awesome Icons
  falInfoCircle = faInfoCircle;
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  pais = this.countryService.getCountryCode();
  countries = ALL_COUNTRIES;
  entidadtributaria = this.countries.find(c => c.codigo === this.pais)?.entidad || '';
  fechaCreacion: Date | undefined;
  fechaVigencia: Date | undefined;

  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  estadoSeleccionado = 'todos';
  busqueda = '';
  private gridApi!: GridApi;
  filaSeleccionada: any = null; // Almacena la fila que se está editando
  camponuevo: boolean = false;// true = crear nuevo, false = editar existente
  tipodeCambioForm!: FormGroup;
  estadoAnterior: string = 'Activo';
  estado: string = '';
  inactivacionConfirmada: boolean = false; // Se activa cuando el usuario confirma la inactivación desde el modal

  // ── Clean Architecture injections ─────────────────────────────────────────
  readonly tipoDeCambioFacade    = inject(TipoDeCambioFacade);
  readonly feedbackEffects       = inject(TipoDeCambioFeedbackEffects);
  readonly syncEffects           = inject(TipoDeCambioSyncEffects);
  readonly isLoading             = computed(() => this.tipoDeCambioFacade.isLoading());

  // Validador personalizado para máximo 5 decimales
  private maxDecimalsValidator(maxDecimals: number) {
    return (control: any) => {
      if (!control.value) {
        return null;
      }
      const value = control.value.toString();
      const parts = value.split('.');
      if (parts.length === 2 && parts[1].length > maxDecimals) {
        return { maxDecimals: { requiredDecimals: maxDecimals, actualDecimals: parts[1].length } };
      }
      return null;
    };
  }

  constructor(
    private modalController: ModalController,
    private formBuilder: FormBuilder,
    private toastservice: ToastService,
    private formValidationService: FormValidationService,
    private countryService: CountryService,
  ) {
    const today = new Date();
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );
    this.maxDate = today;

    // Inicializar formulario reactivo con validaciones y fecha de hoy por defecto
    const fechaHoy = today.toISOString().split('T')[0]; // Formato YYYY-MM-DD para input type="date"

    this.tipodeCambioForm = this.formBuilder.group({
      fechaCreacion: [fechaHoy, Validators.required],
      fechaVigencia: ['', Validators.required],
      moneda: ['', Validators.required],
      tcCompra: ['', [Validators.required, Validators.min(0), this.maxDecimalsValidator(5)]],
      tcVenta: ['', [Validators.required, Validators.min(0), this.maxDecimalsValidator(5)]],
      fuente: ['', Validators.required],
      estado: ['Activo', Validators.required]
    });

    // Sincronizar rowData reactivamente desde el facade (aplicando el buscador)
    effect(() => {
      this.rowData = this.filtrar(this.tipoDeCambioFacade.items());
    });

    // Registrar callbacks de feedback: limpiar formulario tras operación exitosa
    this.feedbackEffects.registrarCallbacks({
      onGuardarExito: () => this.botonNuevoTipodeCambio(),
      onActualizarExito: () => this.botonNuevoTipodeCambio(),
      onEliminarExito: () => this.inicializarModoCreacion(),
    });
  }
  localeText = {
    page: 'Página',
    to: 'a',
    of: 'de',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    loadingOoo: 'Cargando...',
    noRowsToShow: 'No hay datos para mostrar',
  };
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  botonGuardarDeshabilitado: boolean = false;

  // Tabla de tipos de cambio - Se carga desde localStorage
  rowData: any[] = [];

  colDefs: ColDef[] = [
    { field: 'tipo_cambio_fecha_registro', headerName: 'Fecha registro', width: 95 },
    { field: 'tipo_cambio_fecha_vigencia', headerName: 'Fecha vigencia', width: 95 },
    {
      field: 'tipo_cambio_moneda',
      headerName: 'Moneda',
      width: 90,
    },
    { field: 'tipo_cambio_tc_compra', headerName: 'Tipo de cambio compra', width: 160 },

    { field: 'tipo_cambio_tc_venta', headerName: 'Tipo de cambio venta', width: 160, },
    {
      field: 'tipo_cambio_estado', headerClass: 'centrarencabezado', filter: true, headerName: 'Estado', width: 90,
      cellRenderer: (params: any) => {
        const color =
          params.value === 'Activo'
            ? 'bg-[#DCFDE7] text-[#16A34A]'
            : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    },
  ];

  columnTypes = {};

  monedas = [
    { id: 'Dolar', nombre: 'Dólar' },
    { id: 'Euro', nombre: 'Euro' },
  ];

  fuentes = [
    { id: this.entidadtributaria, nombre: this.entidadtributaria },
    { id: 'externa', nombre: 'Externa' },
  ];

  ngOnInit() {
    // Establecer fecha de creación como fecha actual y deshabilitar el campo
    const fechaActual = new Date();
    const fechaFormateada = fechaActual.toISOString().split('T')[0];
    this.tipodeCambioForm.patchValue({
      fechaCreacion: fechaFormateada,
      fechaVigencia: ''
    });
    this.tipodeCambioForm.get('fechaCreacion')?.disable({ emitEvent: false });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.tipodeCambioForm);

    // Cargar tipos de cambio desde la capa de dominio
    this.tipoDeCambioFacade.cargarItems();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  /** Buscador: filtra por moneda, fecha, montos o estado (en cliente). */
  onBuscar(): void {
    this.rowData = this.filtrar(this.tipoDeCambioFacade.items());
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  private filtrar(items: TipoDeCambioEntity[]): TipoDeCambioEntity[] {
    const t = (this.busqueda ?? '').trim().toLowerCase();
    if (!t) { return [...items]; }
    return items.filter((i) =>
      `${i.tipo_cambio_fecha_registro} ${i.tipo_cambio_fecha_vigencia} ${i.tipo_cambio_moneda} ${i.tipo_cambio_tc_compra} ${i.tipo_cambio_tc_venta} ${i.tipo_cambio_estado}`
        .toLowerCase().includes(t));
  }

  /** Exporta la grilla a Excel (.xlsx). El backend no expone PDF para esta tabla. */
  exportarExcel(): void {
    this.gridApi?.exportDataAsExcel({ fileName: 'tipos-de-cambio.xlsx', sheetName: 'Tipos de cambio' });
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
  async modalverAprobar() {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Confirmar Aprobación',
        title: 'Confirmar Aprobación de Traslado(s)',
        message:
          'Por favor, revisa los detalles antes de proceder. Una vez aprobados, no podrás modificar ni deshacer esta acción.',
        btnOkTxt: 'Confirmar',
        btnCancelTxt: 'Cancelar',
      },
    });

    await modal.present();
  }

  onFirstDataRendered(params: any) {
    // Inicializar en modo creación por defecto sin seleccionar ninguna fila
    this.inicializarModoCreacion();
  }

  private inicializarModoCreacion() {
    this.camponuevo = true;
    this.filaSeleccionada = null;

    // Configurar formulario para nuevo tipo de cambio
    const fechaActual = new Date();
    const fechaFormateada = fechaActual.toISOString().split('T')[0];

    this.tipodeCambioForm.reset({
      fechaCreacion: fechaFormateada,
      fechaVigencia: '',
      moneda: '',
      tcCompra: '',
      tcVenta: '',
      fuente: '',
      estado: 'Activo'
    });

    this.estadoAnterior = 'Activo';
    this.inactivacionConfirmada = false;
    this.botonGuardarDeshabilitado = false;

    // Asegurar que la fecha de creación esté deshabilitada
    this.tipodeCambioForm.get('fechaCreacion')?.disable({ emitEvent: false });

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  async botonNuevoTipodeCambio() {
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Cancelar acción
    }

    this.camponuevo = true;
    this.filaSeleccionada = null;

    // Limpiar formulario y establecer fecha de creación actual
    const fechaActual = new Date();
    const fechaFormateada = fechaActual.toISOString().split('T')[0]; // Formato YYYY-MM-DD

    this.tipodeCambioForm.reset({
      fechaCreacion: fechaFormateada,
      fechaVigencia: '',
      moneda: '',
      tcCompra: '',
      tcVenta: '',
      fuente: '',
      estado: 'Activo'
    });

    this.estadoAnterior = 'Activo';
    this.tipodeCambioForm.enable();
    this.tipodeCambioForm.get('fechaCreacion')?.disable({ emitEvent: false });

    // Deseleccionar filas de la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    this.botonGuardarDeshabilitado = false;

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }
  async onCellClicked(event: any) {
    const data = event.data;

    // Prevenir selección automática
    event.node.setSelected(false);

    // Guardar referencia del elemento que tiene el foco actualmente
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Mantener selección anterior
      if (this.filaSeleccionada) {
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
            if (node.data.tipo_cambio_fecha_registro === this.filaSeleccionada.tipo_cambio_fecha_registro) {
              node.setSelected(true);
            }
          });

          // Restaurar el foco al campo que estaba activo
          if (elementoConFoco && elementoConFoco.tagName === 'INPUT') {
            setTimeout(() => {
              elementoConFoco.focus();
            }, 100);
          }
        }, 0);
      } else {
        this.gridApi.deselectAll();
      }
      return;
    }

    // Cargar datos del tipo de cambio seleccionado
    this.cargarDatosTipoCambio(data);
  }

  private cargarDatosTipoCambio(data: any) {
    this.camponuevo = false;
    this.filaSeleccionada = data;
    this.gridApi.deselectAll();

    // Seleccionar el nodo en AG-Grid
    this.gridApi.forEachNode((node) => {
      if (node.data === data) {
        node.setSelected(true);
      }
    });

    // Cargar datos en el formulario (fechas ya están en formato DD/MM/YYYY)
    this.tipodeCambioForm.patchValue({
      fechaCreacion: this.reformatearFecha(data.tipo_cambio_fecha_registro),
      fechaVigencia: this.parsearFecha(data.tipo_cambio_fecha_vigencia),
      moneda: data.tipo_cambio_moneda === 'Dólar' ? 'Dolar' : 'Euro',
      tcCompra: data.tipo_cambio_tc_compra.toFixed(5),
      tcVenta: data.tipo_cambio_tc_venta.toFixed(5),
      fuente: this.entidadtributaria,
      estado: data.tipo_cambio_estado
    });

    const fechaVigencia: Date = this.tipodeCambioForm.get('fechaVigencia')?.value;
    const hoy = new Date();

    // Normalizar horas
    fechaVigencia.setHours(0, 0, 0, 0);
    hoy.setHours(0, 0, 0, 0);

    // Deshabilitar todo
    this.tipodeCambioForm.disable();

    if (fechaVigencia >= hoy) {
      this.tipodeCambioForm.get('tcCompra')?.enable();
      this.tipodeCambioForm.get('tcVenta')?.enable();
    }

    // Estado siempre habilitado
    this.tipodeCambioForm.get('estado')?.enable();
    
    this.estadoAnterior = data.tipo_cambio_estado;
    this.inactivacionConfirmada = false; // Resetear al seleccionar una fila

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  parsearFecha(fechaStr: string): Date {
    const partes = fechaStr.split('/');
    return new Date(
      parseInt(partes[2]),
      parseInt(partes[1]) - 1,
      parseInt(partes[0])
    );
  }
  reformatearFecha(fechaStr: string) {
    const partes = fechaStr.split('/');
    const dia = partes[0].padStart(2, '0');
    const mes = partes[1].padStart(2, '0');
    const anio = partes[2];
    return `${anio}-${mes}-${dia}`;
  }


  onFechaCreacion(date: Date) {
    this.tipodeCambioForm.patchValue({ fechaCreacion: date });
  }

  onFechaVigencia(date: Date) {
    this.tipodeCambioForm.patchValue({ fechaVigencia: date });
  }

  // Método para formatear TC a 5 decimales
  onTCInput(event: any, campo: 'tcCompra' | 'tcVenta') {
    let valor = event.target.value;

    // Permitir solo números y punto decimal
    valor = valor.replace(/[^0-9.]/g, '');

    // Evitar múltiples puntos
    const partes = valor.split('.');
    if (partes.length > 2) {
      valor = partes[0] + '.' + partes.slice(1).join('');
    }

    // Limitar a 5 decimales
    if (partes.length === 2 && partes[1].length > 5) {
      valor = partes[0] + '.' + partes[1].substring(0, 5);
    }

    // Actualizar el formulario
    this.tipodeCambioForm.patchValue({ [campo]: valor });
  }

  botonGuardar() {
    // Validar formulario
    if (this.tipodeCambioForm.invalid) {
      this.tipodeCambioForm.markAllAsTouched();
      this.toastservice.warning('Por favor, completa todos los campos requeridos.');
      return;
    }

    // getRawValue() incluye los controles deshabilitados (p. ej. tcCompra/tcVenta
    // y fechaCreacion en tipos de cambio vencidos); con .value llegarían undefined.
    const formValue = this.tipodeCambioForm.getRawValue();

    // Validar que TC Compra y TC Venta sean números válidos
    const tcCompraNum = parseFloat(formValue.tcCompra);
    const tcVentaNum = parseFloat(formValue.tcVenta);

    if (isNaN(tcCompraNum) || isNaN(tcVentaNum)) {
      this.toastservice.warning(
        'Debe ingresar la tasa de cambio de compra y venta.'
      );
      return;
    }

    // Formatear fechas (usar fecha actual si no están definidas)
    const fechaRegistroFormateada = typeof formValue.fechaCreacion === 'string'
      ? formValue.fechaCreacion
      : this.formatearFecha(formValue.fechaCreacion || new Date());
    const fechaVigenciaFormateada = this.formatearFecha(
      formValue.fechaVigencia || new Date()
    );
    const monedaNombre =
      this.monedas.find((m) => m.id === formValue.moneda)?.nombre ||
      'Dólar';

    // Obtener todos los tipos de cambio existentes
    const tiposExistentes = this.tipoDeCambioFacade.items();

    if (this.camponuevo) {
      // MODO CREAR NUEVO
      // Validar si ya existe un tipo de cambio activo con la misma fecha de vigencia y moneda
      const existeRegistro = tiposExistentes.some(
        (registro: any) =>
          registro.tipo_cambio_fecha_vigencia === fechaVigenciaFormateada &&
          registro.tipo_cambio_moneda === monedaNombre &&
          registro.tipo_cambio_estado === 'Activo'
      );

      if (existeRegistro) {
        this.toastservice.danger(
          'Tienes un tipo de cambio activo en esta fecha.'
        );
        return;
      }

      // Crear nuevo registro
      const nuevoRegistro: TipoDeCambioEntity = {
        tipo_cambio_fecha_registro: fechaRegistroFormateada,
        tipo_cambio_fecha_vigencia: fechaVigenciaFormateada,
        tipo_cambio_moneda: monedaNombre,
        tipo_cambio_tc_compra: parseFloat(tcCompraNum.toFixed(5)),
        tipo_cambio_tc_venta: parseFloat(tcVentaNum.toFixed(5)),
        tipo_cambio_estado: formValue.estado,
      };

      // Guardar mediante facade (Clean Architecture)
      this.tipoDeCambioFacade.guardarItem(nuevoRegistro);
    } else {
      // MODO EDITAR EXISTENTE
      // Buscar el índice del tipo de cambio a actualizar
      const indice = tiposExistentes.findIndex(
        (t: any) => t.tipo_cambio_fecha_registro === this.filaSeleccionada.tipo_cambio_fecha_registro &&
          t.tipo_cambio_moneda === this.filaSeleccionada.tipo_cambio_moneda
      );

      if (indice !== -1) {
        const updatedItem = {
          ...tiposExistentes[indice],
          tipo_cambio_fecha_vigencia: fechaVigenciaFormateada,
          tipo_cambio_moneda: monedaNombre,
          tipo_cambio_tc_compra: parseFloat(tcCompraNum.toFixed(5)),
          tipo_cambio_tc_venta: parseFloat(tcVentaNum.toFixed(5)),
          tipo_cambio_estado: formValue.estado,
        };

        // Actualizar mediante facade (Clean Architecture)
        this.tipoDeCambioFacade.actualizarItem(updatedItem);
      }
    }

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  async botonCancelar() {
    // Validar cambios antes de limpiar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Cancelar acción
    }

    this.camponuevo = false;
    this.botonNuevoTipodeCambio();
  }

  formatearFecha(fecha: Date): string {
    const dia = fecha.getDate().toString().padStart(2, '0');
    const mes = (fecha.getMonth() + 1).toString().padStart(2, '0');
    const anio = fecha.getFullYear();
    return `${dia}/${mes}/${anio}`;
  }

  async onEstadoChange(event: any) {
    const nuevoEstado = event.detail.value;

    if (
      nuevoEstado === 'Inactivo' &&
      this.estadoAnterior === 'Activo' &&
      this.filaSeleccionada
    ) {
      const confirmar = await this.abrirModalInactivar();

      if (!confirmar) {
        // Revertir cambio de estado
        this.tipodeCambioForm.patchValue({ estado: this.estadoAnterior }, { emitEvent: false });
      }
    }
  }

  async abrirModalInactivar(): Promise<boolean> {
    if (!this.filaSeleccionada) return false;

    const formValue = this.tipodeCambioForm.value;
    const fuenteNombre =
      this.fuentes.find((f) => f.id === formValue.fuente)?.nombre ||
      'SUNAT';

    const detallesEjemplo: DetalleItem[] = [
      {
        label: 'Fecha de creación:',
        value: this.filaSeleccionada.tipo_cambio_fecha_registro,
      },
      { label: 'TC Compra:', value: this.filaSeleccionada.tipo_cambio_tc_compra.toString() },
      {
        label: 'Fecha de vigencia:',
        value: this.filaSeleccionada.tipo_cambio_fecha_vigencia,
      },
      { label: 'TC Venta:', value: this.filaSeleccionada.tipo_cambio_tc_venta.toString() },
      { label: 'Moneda:', value: this.filaSeleccionada.tipo_cambio_moneda },
      { label: 'Fuente:', value: fuenteNombre },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Inactivar tipo de cambio',
        subtitulomodal: 'Detalle del tipo de cambio:',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo de inactividad:',
        placeholderTextarea: 'Describe el motivo de la inactividad.',
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Inactivar',
        colorBotonConfirmar: 'danger',
      },
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      // Confirmar inactivación
      // this.toastservice.success('¡Registro exitoso!');

      // Actualizar el estado en la tabla
      if (this.filaSeleccionada) {
        this.filaSeleccionada.estado = 'Inactivo';
        this.estadoAnterior = 'Inactivo';
        this.inactivacionConfirmada = true; // Habilitar edición de campos del formulario
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }

      return true;
    } else {
      // Cancelar - revertir al estado anterior
      return false;
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
      { fechaHora: '21/11/2025 09:00', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar' },
      { fechaHora: '21/11/2025 09:05', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385' },
      { fechaHora: '20/11/2025 08:30', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380 ' },
      { fechaHora: '19/11/2025 08:45', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT' },
    ];

    const defaultColDefModal: ColDef = {
      wrapText: true,
      autoHeight: true,
    };

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - Tipo de Cambio',
        rowData: rowData,
        colDefs: colDefs,
        defaultColDef: defaultColDefModal,
        anchoModal: '700px',
      },
    });

    await modal.present();
  }

  async eliminar(): Promise<void> {
    if (!this.filaSeleccionada?.id) {
      this.toastservice.warning('Selecciona un tipo de cambio para eliminar');
      return;
    }

    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) {
      return;
    }

    this.tipoDeCambioFacade.eliminarItem(this.filaSeleccionada.id);
    this.formValidationService.resetearEstado();
  }

  onBtReset() {
    this.tipoDeCambioFacade.cargarItems();
  }

}
