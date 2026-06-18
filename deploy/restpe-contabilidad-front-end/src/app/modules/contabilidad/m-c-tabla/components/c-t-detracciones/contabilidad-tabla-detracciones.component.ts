import { Component, OnInit, OnDestroy, inject, computed, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { DetraccionEntity } from 'src/app/modules/contabilidad/domain/models/detraccion.entity';
import { DetraccionFacade } from 'src/app/modules/contabilidad/application/facades/detraccion.facade';
import { DetraccionFeedbackEffects } from 'src/app/modules/contabilidad/effects/detraccion-feedback.effect';
import { DetraccionSyncEffects } from 'src/app/modules/contabilidad/effects/detraccion-sync.effect';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faCog, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-contabilidad-tabla-detracciones',
  templateUrl: './contabilidad-tabla-detracciones.component.html',
  styleUrls: ['./contabilidad-tabla-detracciones.component.scss'],
  standalone: false,
})
export class ContabilidadTablaDetraccionesComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasCog = faCog;
  fasRotateRight = faRotateRight;

  // Capa de aplicación – Clean Architecture (Facade + Effects)
  private readonly detraccionFacade = inject(DetraccionFacade);
  private readonly feedbackEffects = inject(DetraccionFeedbackEffects);
  private readonly syncEffects = inject(DetraccionSyncEffects);
  isLoading = computed(() => this.detraccionFacade.isLoading());

  pais = this.countryService.getCountryCode();
  countries = ALL_COUNTRIES;
  entidadtributaria = this.countries.find(c => c.codigo === this.pais)?.entidad || '';
  titulodetraccion = this.pais === 'CO' || this.pais === 'EC' ? 'retención' : 'detracción';
  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  fechaVigenciaDesde: Date | undefined;
  fechaVigenciaHasta: Date | undefined;

  detraccionForm!: FormGroup;
  private gridApi!: GridApi;
  camponuevo: boolean = false;
  filaSeleccionada: any = null;
  filaPreviamenteSeleccionada: any = null;
  archivo: any = null;

  // Arreglos para los selects

  cuentas = [
    { id: 'Activo disponible y exigible', nombre: 'Activo disponible y exigible' },
    { id: 'Activo realizable', nombre: 'Activo realizable' },
    { id: 'Activo inmovilizado', nombre: 'Activo inmovilizado' },
    { id: 'Pasivo', nombre: 'Pasivo' },
    { id: 'Patrimonio neto', nombre: 'Patrimonio neto' },
    { id: 'Ingresos', nombre: 'Ingresos' },
    { id: 'Gastos', nombre: 'Gastos' },
    { id: 'Cuentas de orden', nombre: 'Cuentas de orden' }
  ];

  retencionesSelect: Array<{ label: string, value: string }> = [];

  estadoSelect = [
    { id: 'Activo', nombre: 'Activo' },
    { id: 'Inactivo', nombre: 'Inactivo' }
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
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  // Tabla de detracciones - Se carga desde el repositorio (JSON assets)
  rowData: DetraccionEntity[] = [];

  colDefs: ColDef[] = [];

  columnTypes = {};

  private inicializarColumnas() {
    const columnas: ColDef[] = [
      { field: 'detraccion_codigo', headerName: 'Código', width: 100 }
    ];
    if (this.pais === 'EC') {
      columnas.push({ field: 'detraccion_codigo_anexo', headerName: 'Código del anexo', flex: 1 });
    }
    // Solo agregar columna de Retenciones de ley para Colombia o Ecuador
    if (this.pais === 'CO' || this.pais === 'EC') {
      columnas.push({ field: 'detraccion_retencion_de_ley', headerName: 'Retenciones de ley', flex: 1 });
    }

    // Solo agregar columna de tipo de operación si NO es Colombia
    if (this.pais !== 'CO' && this.pais !== 'EC') {
      columnas.push(
        { field: 'detraccion_codigo_sun', headerName: 'Código ' + this.entidadtributaria, width: 150 },
        { field: 'detraccion_nombre_op', headerName: 'Nombre de operación', flex: 1, minWidth: 150 });
    }
    if (this.pais === 'CO' || this.pais === 'EC') {
      columnas.push(
        { field: 'detraccion_nombre_retencion', headerName: 'Nombre de retención', flex: 1 });
    }
    // Agregar columnas comunes
    columnas.push(
      { field: 'detraccion_porcentaje', headerName: 'Porcentaje', headerClass: 'derechaencabezado', width: 120, 
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' } },
      { field: 'detraccion_cuenta_c', headerName: 'Cuenta contable asociada', width: 150 },
      { field: 'detraccion_vigente', headerName: 'Vigente desde', width: 130,
        valueFormatter: (params: any) => {
          if (params.value) {
            const date = new Date(params.value);
            const day = String(date.getDate() + 1).padStart(2, '0');
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const year = date.getFullYear();
            return `${day}/${month}/${year}`;
          }
          return '';
        }
      },
      { field: "detraccion_estado", headerName: "Estado", headerClass: 'ag-header-hover ag-header-10px centrarencabezado', filter: true, width: 80,
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        cellRenderer: (params: any) => {
          const estado = params.value;
          const estadoClass = estado === 'Activo' ? 'text-green-600 bg-green-100' : 'text-red-600 bg-red-100';
          return `<span class="px-2 py-[1px] rounded-full text-xxss font-medium ${estadoClass}">${estado}</span>`;
        },
      }
    );

    this.colDefs = columnas;
  }

  /**
   * Inicializa las opciones de retenciones según el país
   */
  private inicializarRetenciones() {
    if (this.pais === 'CO') {
      // Opciones solo para Colombia
      this.retencionesSelect = [
        { label: 'ReteFuente', value: 'retefuente' },
        { label: 'ReteIVA', value: 'reteiva' },
        { label: 'ReteICA', value: 'reteica' }
      ];
    } else if (this.pais === 'EC') {
      // Opciones solo para Ecuador
      this.retencionesSelect = [
        { label: 'Retención de IR', value: 'reteir' },
        { label: 'Retención de IVA', value: 'reteiva' }
      ];
    } else {
      // Para otros países, array vacío
      this.retencionesSelect = [];
    }
  }


  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService,
    private simulation: SimulationService,
    private countryService: CountryService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Sincronizar rowData desde el store reactivamente
    effect(() => {
      const detracciones = this.detraccionFacade.detracciones();
      this.rowData = [...detracciones].sort((a, b) => {
        const codigoA = parseInt(a.detraccion_codigo.replace('TD-', '')) || 0;
        const codigoB = parseInt(b.detraccion_codigo.replace('TD-', '')) || 0;
        return codigoB - codigoA;
      });
      if (this.gridApi) this.gridApi.setGridOption('rowData', [...this.rowData]);
    });

    // Registrar callbacks de éxito para refrescar el formulario
    this.feedbackEffects.registrarCallbacks({
      onGuardarExito: () => this.botonNuevaCuenta(),
      onActualizarExito: () => this.mantenerFilaSeleccionada()
    });
  }

  ngOnInit() {
    // Inicializar columnas según el país
    this.inicializarColumnas();

    // Inicializar retenciones según el país
    this.inicializarRetenciones();

    // Actualizar formulario para reflejar los campos del HTML
    this.detraccionForm = this.formBuilder.group({
      fechaC: [{ value: this.getFechaHoy(), disabled: true }],
      codigoSun: ['', Validators.required],
      nombreOp: ['', Validators.required],
      porcentaje: ['', [Validators.required, Validators.min(0), Validators.max(100)]],
      cuentaC: ['', Validators.required],
      vigenciaD: ['', Validators.required],
      codigoanexo: [''],
      vigenciaH: [''],
      observacion: [''],
      estado: ['Activo', Validators.required]
    });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.detraccionForm);

    // Cargar detracciones desde el repositorio (a través del facade)
    this.detraccionFacade.cargarDetracciones();
    this.cargarCuentasContables();
  }
  cargarCuentasContables() {
    const cuentasLS = this.simulation.list('plancontable') || [];
    console.log('Cuentas contables cargadas en detracciones:', cuentasLS);

    // Mapear cuentas con el formato necesario para el autocomplete
    this.cuentas = cuentasLS.map((item: any) => ({
      id: item.codigo,
      codigo: item.codigo,
      descripcion: item.descripcion || item.nombreOp || '',
      nombre: `${item.codigo} - ${item.descripcion || item.nombreOp || ''}`,
      naturaleza: item.naturaleza,
      tipo: item.tipo,
      nivel: item.nivel,
      estado: item.estado,
      ...item
    }));

    console.log('Cuentas contables cargadas para detracciones:', this.cuentas.length);
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  private async validarCambiosCondicional(): Promise<boolean> {
    // Si NO hay modificaciones, retorna true (permite navegación libre)
    if (!this.formValidationService.tieneModificaciones()) {
      return true;
    }

    // Si hay cambios, muestra modal de confirmación
    return await this.formValidationService.validarCambios();
  }

  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  limitarPorcentaje(event: any): void {
    let valor = event.target.value;

    // Si está vacío, permitir
    if (!valor || valor === '') {
      return;
    }

    // Convertir a número
    let numValor = parseInt(valor, 10);

    // Validar que sea un número válido
    if (isNaN(numValor)) {
      event.target.value = '';
      return;
    }

    // Limitar a máximo 100
    if (numValor > 100) {
      event.target.value = '100';
      return;
    }

    // Limitar a máximo 3 dígitos (0-100)
    if (valor.toString().length > 3) {
      event.target.value = valor.toString().slice(0, 3);
      return;
    }

    // Asegurar que sea un número positivo
    if (numValor < 0) {
      event.target.value = '0';
    }
  }

  formatearFecha(fecha: Date): string {
    const dia = String(fecha.getDate()).padStart(2, '0');
    const mes = String(fecha.getMonth() + 1).padStart(2, '0');
    const anio = fecha.getFullYear();
    return `${anio}-${mes}-${dia}`;
  }
  parsearFecha(fechaStr: string): Date {
    const partes = fechaStr.split('-');
    return new Date(
      parseInt(partes[0]),
      parseInt(partes[1]) - 1,
      parseInt(partes[2]),
    );
  }

  getFechaHoy(): string {
    return new Date().toISOString().substring(0, 10);
  }

  async onCellClicked(event: any) {
    const data = event.data;

    // Si es la misma fila, no hacer nada
    if (this.filaSeleccionada && this.filaSeleccionada.detraccion_codigo === data.detraccion_codigo) {
      return;
    }

    // Prevenir selección automática
    event.node.setSelected(false);

    // Validar cambios antes de cambiar de fila
    const puede = await this.validarCambiosCondicional();

    if (!puede) {
      // Si cancela, restaurar la fila anterior
      if (this.filaPreviamenteSeleccionada && this.gridApi) {
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node: any) => {
            if (node.data.detraccion_codigo === this.filaPreviamenteSeleccionada.detraccion_codigo) {
              node.setSelected(true);
            }
          });
        }, 0);
      }
      return;
    }

    // Permitir el cambio de fila
    this.filaPreviamenteSeleccionada = data;
    this.cargarDatosDetraccion(data);
  }

  private cargarDatosDetraccion(data: any) {
    this.filaSeleccionada = data;
    this.camponuevo = false;

    if (!this.gridApi) return;

    this.gridApi.deselectAll();

    // Seleccionar el nodo en AG-Grid
    this.gridApi.forEachNode((node) => {
      if (node.data === data) {
        node.setSelected(true);
      }
    });

    this.llenarFormulario(data);
  }

  private llenarFormulario(data: any) {
    if (!data) return;

    // detraccion_fecha_creacion ya viene en formato YYYY-MM-DD
    const fechaFormateada = data.detraccion_fecha_creacion || this.getFechaHoy();

    // Parsear fechas de vigencia para los calendarios
    this.fechaVigenciaDesde = data.detraccion_vigente ? this.parsearFecha(data.detraccion_vigente) : undefined;
    this.fechaVigenciaHasta = data.detraccion_vigencia_h ? this.parsearFecha(data.detraccion_vigencia_h) : undefined;

    this.detraccionForm.patchValue({
      fechaC: fechaFormateada,
      codigoSun: data.detraccion_codigo_sun,
      nombreOp: data.detraccion_nombre_op,
      porcentaje: typeof data.detraccion_porcentaje === 'string' ? data.detraccion_porcentaje.replace('%', '') : data.detraccion_porcentaje,
      cuentaC: data.detraccion_cuenta_c,
      vigenciaD: this.fechaVigenciaDesde ? this.formatearFecha(this.fechaVigenciaDesde) : '',
      vigenciaH: this.fechaVigenciaHasta ? this.formatearFecha(this.fechaVigenciaHasta) : '',
      observacion: data.detraccion_observacion,
      estado: data.detraccion_estado
    });

    // Resetear servicio de validación después de llenar el formulario
    this.formValidationService.resetearEstado();
  }

  onBtReset() {
    this.detraccionFacade.cargarDetracciones();
  }


  async botonNuevaCuenta() {
    // Validar cambios antes de limpiar
    const puede = await this.validarCambiosCondicional();

    if (!puede) {
      return; // Cancelar acción
    }

    this.camponuevo = true;
    this.filaSeleccionada = null;
    this.filaPreviamenteSeleccionada = null;

    // Limpiar formulario
    this.detraccionForm.reset({
      fechaC: this.getFechaHoy(),
      codigoSun: '',
      nombreOp: '',
      porcentaje: '',
      cuentaC: '',
      vigenciaD: '',
      vigenciaH: '',
      observacion: '',
      estado: 'Activo'
    });

    // Limpiar fechas
    this.fechaVigenciaDesde = undefined;
    this.fechaVigenciaHasta = undefined;

    // Deseleccionar filas de la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  botonGuardar() {
    // Validar formulario
    if (this.detraccionForm.invalid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    // Usar filaSeleccionada para determinar si es nuevo o actualización
    // Esto es consistente con el HTML que usa filaSeleccionada para el texto del botón
    if (!this.filaSeleccionada) {
      // Crear nueva detracción
      this.crearDetraccion();
    } else {
      // Actualizar detracción existente
      this.actualizarDetraccion();
    }
  }

  private crearDetraccion() {
    const nuevoCodigo = this.generarCodigoDetraccion();
    const fechaC = this.detraccionForm.get('fechaC')?.value;

    const nuevaDetraccion: DetraccionEntity = {
      detraccion_codigo: nuevoCodigo,
      detraccion_codigo_sun: this.detraccionForm.get('codigoSun')?.value,
      detraccion_nombre_op: this.detraccionForm.get('nombreOp')?.value,
      detraccion_porcentaje: Number(this.detraccionForm.get('porcentaje')?.value),
      detraccion_cuenta_c: this.detraccionForm.get('cuentaC')?.value,
      detraccion_vigente: this.fechaVigenciaDesde ? this.formatearFecha(new Date(this.fechaVigenciaDesde)) : '',
      detraccion_vigencia_h: this.fechaVigenciaHasta ? this.formatearFecha(new Date(this.fechaVigenciaHasta)) : '',
      detraccion_observacion: this.detraccionForm.get('observacion')?.value || '',
      detraccion_estado: this.detraccionForm.get('estado')?.value,
      detraccion_fecha_creacion: fechaC || this.getFechaHoy()
    };

    // La facade orquesta el caso de uso, el store y los effects (toast + callbacks)
    this.detraccionFacade.guardarDetraccion(nuevaDetraccion);
    this.formValidationService.resetearEstado();
  }

  private actualizarDetraccion() {
    if (!this.filaSeleccionada) {
      this.toastService.warning('No hay detracción seleccionada');
      return;
    }

    const detraccionActualizada: DetraccionEntity = {
      ...this.filaSeleccionada,
      detraccion_codigo_sun: this.detraccionForm.get('codigoSun')?.value,
      detraccion_nombre_op: this.detraccionForm.get('nombreOp')?.value,
      detraccion_porcentaje: Number(this.detraccionForm.get('porcentaje')?.value),
      detraccion_cuenta_c: this.detraccionForm.get('cuentaC')?.value,
      detraccion_vigente: this.fechaVigenciaDesde
        ? this.formatearFecha(new Date(this.fechaVigenciaDesde))
        : this.filaSeleccionada.detraccion_vigente,
      detraccion_vigencia_h: this.fechaVigenciaHasta
        ? this.formatearFecha(new Date(this.fechaVigenciaHasta))
        : this.filaSeleccionada.detraccion_vigencia_h,
      detraccion_observacion: this.detraccionForm.get('observacion')?.value || '',
      detraccion_estado: this.detraccionForm.get('estado')?.value
    };

    // La facade orquesta el caso de uso, el store y los effects (toast + callbacks)
    this.detraccionFacade.actualizarDetraccion(detraccionActualizada);
    this.formValidationService.resetearEstado();
  }

  private generarCodigoDetraccion(): string {
    // Generar código basado en el rowData actual en memoria
    const codigos = this.rowData
      .map(d => d.detraccion_codigo)
      .filter(cod => cod.startsWith('TD-'))
      .map(cod => parseInt(cod.replace('TD-', '')))
      .filter(num => !isNaN(num));

    const maxCodigo = codigos.length > 0 ? Math.max(...codigos) : 0;
    return `TD-${String(maxCodigo + 1).padStart(3, '0')}`;
  }

  private mantenerFilaSeleccionada() {
    if (!this.filaSeleccionada) return;

    const codigoSeleccionado = this.filaSeleccionada.detraccion_codigo;

    // Buscar la fila actualizada en el rowData
    const filaActualizada = this.rowData.find(
      d => d.detraccion_codigo === codigoSeleccionado
    );

    if (filaActualizada) {
      this.filaSeleccionada = filaActualizada;
      this.filaPreviamenteSeleccionada = filaActualizada;
      this.llenarFormulario(filaActualizada);

      // Re-seleccionar la fila en la tabla
      if (this.gridApi) {
        this.gridApi.deselectAll();
        this.gridApi.forEachNode((node: any) => {
          if (node.data.detraccion_codigo === codigoSeleccionado) {
            node.setSelected(true);
          }
        });
      }
    }
  }

  private limpiarFormulario() {
    this.camponuevo = true;
    this.filaSeleccionada = null;

    this.detraccionForm.reset({
      fechaC: this.getFechaHoy(),
      codigoSun: '',
      nombreOp: '',
      porcentaje: '',
      cuentaC: '',
      vigenciaD: '',
      vigenciaH: '',
      observacion: '',
      estado: 'Activo'
    });

    this.fechaVigenciaDesde = undefined;
    this.fechaVigenciaHasta = undefined;

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    this.formValidationService.resetearEstado();
  }
  onTipoSeleccionado(tipo: any) {
    console.log('Tipo seleccionado:', tipo);
  }

  async modalImportar() {
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar detracciones',
        nombreOpSubir: 'Comparte tu archivo de excel con la información de tus tipos de detracciones y regístralas automáticamente en la plataforma.',
        buttonName: 'Importar tipos de detracciones',
      }
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
        try { this.importar(data); } catch (e) {
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

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos
    this.cargarDatos(range.start, range.end);
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }


  onFechaVigenciaDesdeSelected(fecha: Date) {
    this.fechaVigenciaDesde = fecha;
    // Actualizar el FormControl para que pase la validación
    this.detraccionForm.patchValue({ vigenciaD: this.formatearFecha(fecha) });
    console.log('Fecha Vigencia Desde seleccionada:', this.fechaVigenciaDesde);
  }
  onFechaVigenciaHastaSelected(fecha: Date) {
    this.fechaVigenciaHasta = fecha;
    // Actualizar el FormControl
    this.detraccionForm.patchValue({ vigenciaH: this.formatearFecha(fecha) });
    console.log('Fecha Vigencia Hasta seleccionada:', this.fechaVigenciaHasta);
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
      { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: `Se ha creado la detracción ${this.filaSeleccionada?.detraccion_codigo || ''}` },
      { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: `Se editó el porcentaje de la detracción a ${this.filaSeleccionada?.detraccion_porcentaje || ''}` },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones de detracción ${this.filaSeleccionada?.detraccion_codigo || ''}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

  /**
   * @deprecated La carga inicial se realiza a través de DetraccionFacade.cargarDetracciones().
   * Se mantiene únicamente como fallback de compatibilidad con datos de localStorage.
   */
  cargarDetraccionesDesdeSimulacion() {
    const detraccionesLS = this.simulation.list('detraccion') || [];
    console.log('Detracciones en localStorage:', detraccionesLS);

    // Ordenar por código descendente (los más recientes primero)
    this.rowData = [...detraccionesLS].sort((a, b) => {
      const codigoA = parseInt(a.detraccion_codigo.replace('TD-', '')) || 0;
      const codigoB = parseInt(b.detraccion_codigo.replace('TD-', '')) || 0;
      return codigoB - codigoA; // Descendente
    });

    // Refrescar la vista de AG-Grid si está disponible
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }

    console.log('Detracciones cargadas en tabla:', this.rowData.length);
  }
}



