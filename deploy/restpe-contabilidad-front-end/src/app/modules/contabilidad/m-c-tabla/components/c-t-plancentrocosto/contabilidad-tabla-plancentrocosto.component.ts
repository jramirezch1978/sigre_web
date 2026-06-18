import { Component, OnInit, OnDestroy, inject, computed, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef, RowClickedEvent } from 'ag-grid-community';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { ModalNuevoTipoComponent } from './modals/modal-nuevo-tipo/modal-nuevo-tipo.component';
import { ModalEditarFactorComponent } from './modals/modal-editar-factor/modal-editar-factor.component';
import { CentroCostoEntity } from 'src/app/modules/contabilidad/domain/models/centro-costo.entity';
import { CentroCostoFacade } from 'src/app/modules/contabilidad/application/facades/plan-centro-costos.facade';
import { CentroCostoFeedbackEffects } from 'src/app/modules/contabilidad/effects/centro-costo-feedback.effect';
import { CentroCostoSyncEffects } from 'src/app/modules/contabilidad/effects/centro-costo-sync.effect';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faBars, faCirclePlus, faCog, faRotateRight } from '@fortawesome/pro-solid-svg-icons';






@Component({
  selector: 'app-contabilidad-tabla-plancentrocosto',
  templateUrl: './contabilidad-tabla-plancentrocosto.component.html',
  styleUrls: ['./contabilidad-tabla-plancentrocosto.component.scss'],
  standalone: false,
})
export class ContabilidadTablaPlancentrocostoComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasBars = faBars;
  fasCirclePlus = faCirclePlus;
  fasCog = faCog;
  fasRotateRight = faRotateRight;


  //RANGO DE FECHAS

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  centroCostosForm!: FormGroup;
  private gridApi!: GridApi;
  estadoSeleccionado: string = 'todos';
  naturalezaSeleccionada: string = 'creacion';
  tipoSeleccionado: string = 'todos';
  camponuevo: boolean = false;
  tabSeleccionado: string = 'identificacion';
  gridContext!: { componentParent: ContabilidadTablaPlancentrocostoComponent };
  filaSeleccionada: any = null;
  filaPreviamenteSeleccionada: any = null;
  archivo: any = null;
  mostrarInputFactor: boolean = false;




  // Arreglos para los selects

  tipos: any[] = [];

  clasificacionSelect = [
    'Administrativo',
    'Operativo',
    'Sucursal',
    'Proyecto',
    'Otro',
  ]


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

  // Application layer (Clean Architecture – Facade + Effects)
  readonly centroCostoFacade = inject(CentroCostoFacade);
  readonly feedbackEffects = inject(CentroCostoFeedbackEffects);
  readonly syncEffects = inject(CentroCostoSyncEffects);

  /** Flag de carga reactivo desde el store */
  readonly isLoading = computed(() => this.centroCostoFacade.isLoading());

  // Tabla de centros de costo - Se carga desde el repositorio (JSON assets)
  rowData: CentroCostoEntity[] = [];

  colDefs: ColDef[] = [
    { field: 'centro_costo_codigo', headerName: 'Código', width: 80 },
    { field: 'centro_costo_nombre', headerName: 'Nombre', width: 200 },
    { field: 'centro_costo_factor', headerName: 'Factor (%)', width: 200, headerClass: 'derechaencabezado', cellStyle: { justifyContent: 'flex-end'}, valueFormatter: (p) => p.value != null ? `${p.value}%` : '' },
    { field: 'centro_costo_clasificacion', headerName: 'Tipo', filter: true, width: 120 },
    { field: 'centro_costo_usuarior', headerName: 'Usuario que registra', width: 200 },
    {
      field: 'centro_costo_fecha_creacion', headerName: 'Fecha de creación', width: 120,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '-';
      },
    },
    {
      field: 'centro_costo_fecha_modificacion', headerName: 'Última modificación', width: 120,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '-';
      },
    },
    {
      field: "centro_costo_estado", headerName: "Estado", headerClass: 'ag-header-hover ag-header-10px centrarencabezado', filter: true, width: 90,
      cellRenderer: (params: any) => {
        const estado = params.value;
        const estadoClass = estado === 'Activo' ? 'text-green-600 bg-green-100' : 'text-red-600 bg-red-100';
        return `<span class="px-2 py-[1px] rounded-full text-xxss font-medium ${estadoClass}">${estado}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }

    },
  ];

  columnTypes = {};


  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Sincronizar rowData con el store via signal effect
    effect(() => {
      const centros = this.centroCostoFacade.centrosCosto();
      this.rowData = [...centros].sort((a, b) => {
        const codigoA = parseInt(a.centro_costo_codigo.split('-')[1]) || 0;
        const codigoB = parseInt(b.centro_costo_codigo.split('-')[1]) || 0;
        return codigoB - codigoA;
      });
      this.actualizarTabla();
    });

    // Registrar callbacks de post-éxito en feedbackEffects
    this.feedbackEffects.registrarCallbacks({
      onGuardarExito: () => this.botonNuevaCuenta(),
      onActualizarExito: () => this.botonNuevaCuenta(),
    });
  }

  // Arrays para los autocompletes de cuentas contables
  cuentasCargo: any[] = [
    { id: '63111', nombre: '63111 – Gastos de Ss x terc.' },
    { id: '63121', nombre: '63121 – Remuneraciones' },
    { id: '65111', nombre: '65111 – Seguros' }
  ];

  cuentasAbono: any[] = [
    { id: '90111', nombre: '90111 – Cuenta puente de gastos' },
    { id: '90211', nombre: '90211 – Cuenta de distribución' },
    { id: '79111', nombre: '79111 – Cargas imputables' }
  ];



  ngOnInit() {
    // Inicializar formulario con valores por defecto para evitar errores al usarlo
    this.centroCostosForm = this.formBuilder.group({
      fechaC: [{ value: this.getFechaHoy(), disabled: true }],
      nombre: ['', Validators.required],
      descripcion: ['', Validators.required],
      clasificacion: ['', Validators.required],
      estado: ['Activo', Validators.required],
      cuentaCargo: [''],
      cuentaAbono: [''],
      factor: [0, [Validators.min(0), Validators.max(100)]]
    });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.centroCostosForm);

    // Contexto de la grilla (si se usa en cellRenderers u otros)
    this.gridContext = { componentParent: this };

    // Cargar centros de costo desde el repositorio (JSON assets)
    this.cargarCentrosCostoDesdeRepositorio();

    // Cargar clasificaciones de activos desde SimulationService
    // this.cargarClasificacionesActivos();

    // Suscribirse a los cambios en tiempo real
    // this.simulation.storageChanges().subscribe((changes) => {
    //   if (changes['clasificacionActivos']) {
    //     this.actualizarClasificacionesEnAutocomplete(changes['clasificacionActivos']);
    //   }
    // });
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

  // // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  getFechaHoy(): string {
    return new Date().toISOString().substring(0, 10);
  }
    /**
   * Carga los centros de costo desde el repositorio (JSON assets — simulación de API REST).
   * Reemplaza a cargarCentrosCostoDesdeSimulacion().
   */
  cargarCentrosCostoDesdeRepositorio(): void {
    this.centroCostoFacade.cargarCentrosCosto();
  }
  onBtReset() {
    this.cargarCentrosCostoDesdeRepositorio();
  }

  onFirstDataRendered(params: any) {
    // No seleccionar automáticamente la primera fila
    // El usuario debe seleccionar manualmente o crear uno nuevo
  }

  onSelectionChanged(params: any) {
    const selected = params.api.getSelectedNodes();
    if (selected.length) {
      const nuevaFila = selected[0].data;

      // Si es la misma fila, no hacer nada
      if (this.filaSeleccionada && this.filaSeleccionada.centro_costo_codigo === nuevaFila.centro_costo_codigo) {
        return;
      }

      // Validar cambios antes de cambiar de fila
      this.validarCambiosCondicional().then((puede) => {
        if (!puede) {
          // Si cancela, restaurar la fila anterior
          if (this.filaPreviamenteSeleccionada && this.gridApi) {
            setTimeout(() => {
              this.gridApi.deselectAll();
              this.gridApi.forEachNode((node: any) => {
                if (node.data.centro_costo_codigo === this.filaPreviamenteSeleccionada.centro_costo_codigo) {
                  node.setSelected(true);
                }
              });
            }, 0);
          }
          return;
        }

        // Permitir el cambio de fila
        this.filaPreviamenteSeleccionada = nuevaFila;
        this.filaSeleccionada = nuevaFila;
        this.llenarFormulario(this.filaSeleccionada);
        this.formValidationService.resetearEstado();
      });
    } else {
      this.filaSeleccionada = null;
    }
  }


  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  private llenarFormulario(data: any) {
    if (!data) return;
    this.centroCostosForm.patchValue({
      fechaC: data.centro_costo_fecha_creacion,
      nombre: data.centro_costo_nombre,
      descripcion: data.centro_costo_descripcion,
      clasificacion: data.centro_costo_clasificacion,
      estado: data.centro_costo_estado,
      cuentaCargo: data.centro_costo_cuenta_cargo || '',
      cuentaAbono: data.centro_costo_cuenta_abono || '',
      factor: data.centro_costo_factor || 0
    });
  }

  botonGuardar() {
    // Validar que el formulario sea válido
    if (this.centroCostosForm.invalid) {
      this.toastService.warning('¡Por favor, completa todos los campos requeridos!');
      return;
    }

    // Obtener valores del formulario
    const formValues = this.centroCostosForm.getRawValue();

    // Datos en memoria (rowData ya contiene los centros cargados)
    const centrosExistentes = this.rowData;

    // Si hay una fila seleccionada, actualizar; si no, crear nueva
    if (this.filaSeleccionada) {
      // Actualizar centro de costo existente
      const centroActualizado = {
        ...this.filaSeleccionada,
        centro_costo_nombre: formValues.nombre,
        centro_costo_descripcion: formValues.descripcion,
        centro_costo_clasificacion: formValues.clasificacion,
        centro_costo_estado: formValues.estado,
        centro_costo_cuenta_cargo: formValues.cuentaCargo,
        centro_costo_cuenta_abono: formValues.cuentaAbono,
        centro_costo_factor: formValues.factor || 0,
        centro_costo_fecha_modificacion: this.getFechaHoy()
      };

      // Buscar el índice del centro a actualizar en memoria
      const indice = this.rowData.findIndex((c: CentroCostoEntity) => c.centro_costo_codigo === this.filaSeleccionada.centro_costo_codigo);

      if (indice !== -1) {
        this.centroCostoFacade.actualizarCentroCosto(centroActualizado);
      }
    } else {
      // Crear nuevo centro de costo con código autogenerado
      const nuevoCodigoNumero = centrosExistentes.length > 0
        ? Math.max(...centrosExistentes.map((r: CentroCostoEntity) => parseInt(r.centro_costo_codigo.split('-')[1]) || 0)) + 1
        : 1;
      const nuevoCodigo = `CC-${String(nuevoCodigoNumero).padStart(3, '0')}`;

      const nuevoCentro: CentroCostoEntity = {
        centro_costo_codigo: nuevoCodigo,
        centro_costo_nombre: formValues.nombre,
        centro_costo_clasificacion: formValues.clasificacion,
        centro_costo_usuarior: 'Usuario Actual',
        centro_costo_fecha_creacion: this.getFechaHoy(),
        centro_costo_fecha_modificacion: this.getFechaHoy(),
        centro_costo_estado: formValues.estado,
        centro_costo_descripcion: formValues.descripcion,
        centro_costo_cuenta_cargo: formValues.cuentaCargo,
        centro_costo_cuenta_abono: formValues.cuentaAbono,
        centro_costo_factor: formValues.factor || 0
      };

      // Persistir via repositorio y actualizar rowData en memoria
      this.centroCostoFacade.guardarCentroCosto(nuevoCentro);
    }

    // Nota: toast y limpieza de formulario manejados por CentroCostoFeedbackEffects via callbacks
  }

  async botonCancelar() {
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return;
    }

    this.camponuevo = false;
    this.botonNuevaCuenta();
  }

  botonNuevaCuenta() {
    // Reiniciar el formulario a los valores por defecto
    if (this.centroCostosForm) {
      this.centroCostosForm.reset();
      // usar id esperado por los selects 
      this.centroCostosForm.patchValue({ estado: 'Activo' });
      this.centroCostosForm.patchValue({ fechaC: this.getFechaHoy() });
      this.filaSeleccionada = null;
      this.filaPreviamenteSeleccionada = null;
      this.gridApi?.deselectAll();
      this.formValidationService.resetearEstado();

      // Resetear el flag para mostrar el link de reorganizar
      this.mostrarInputFactor = false;
    }

    // Deseleccionar todas las filas de la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  onTipoSeleccionado(tipo: any) {
    console.log('Tipo seleccionado:', tipo);
  }

  async modalImportar() {
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar centros de costos',
        descripcionSubir: 'Comparte tu archivo de excel con la información de tus centros de costos y regístralos automáticamente en la plataforma.',
        buttonName: 'Importar centros de costos',
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
    console.log('Cargar datos entre', start, 'y', end);
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
      { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Se ha creado el grupo 1.00' },
      { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se edito la descripción del grupo' },
      { fechaHora: '13/11/2025 09:00', usuario: 'Carlos Rodríguez', accion: 'Actualización', detalleCambio: 'Se cambió el tipo de flujo' },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones de centro de costo ${this.filaSeleccionada?.centro_costo_codigo || ''}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });
    await modal.present();
  }

  // ========== MODALES Y FUNCIONALIDADES ==========

  /**
   * Abrir modal para crear nuevo tipo de centro de costo
   */
  async abrirModalNuevoTipo() {
    const modal = await this.modalController.create({
      component: ModalNuevoTipoComponent,
      cssClass: 'custom-modal-small'
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();

    if (data && data.action === 'guardar') {
      const nuevoTipo = data.nuevoTipo.trim();

      // Verificar si ya existe
      if (this.clasificacionSelect.includes(nuevoTipo)) {
        this.toastService.warning('Este tipo ya existe');
        return;
      }

      // Agregar el nuevo tipo
      this.clasificacionSelect.push(nuevoTipo);

      // Seleccionar automáticamente el nuevo tipo en el formulario
      this.centroCostosForm.patchValue({ clasificacion: nuevoTipo });

      this.toastService.success('Tipo agregado exitosamente');
    }
  }

  /**
   * Abrir modal para editar factor de un centro de costo
   */
  async abrirModalEditarFactor() {
    // Usar los centros de costo en memoria (rowData)
    const centrosExistentes = [...this.rowData];

    const modal = await this.modalController.create({
      component: ModalEditarFactorComponent,
      componentProps: {
        centrosCosto: centrosExistentes
      },
      cssClass: 'custom-modal-small'
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();

    // Si se cerró el modal (con o sin guardar), mostrar el input de factor
    if (data) {
      // Ocultar el link de "Reorganizar porcentajes"
      this.mostrarInputFactor = true;

      if (data.action === 'guardar') {
        const centroActualizado = data.centro;

        // Actualizar factor en memoria y via repositorio
        const index = this.rowData.findIndex((c: CentroCostoEntity) => c.centro_costo_codigo === centroActualizado.centro_costo_codigo);

      if (index !== -1) {
          const centroConFactor: CentroCostoEntity = {
            ...this.rowData[index],
            centro_costo_factor: centroActualizado.centro_costo_factor,
            centro_costo_fecha_modificacion: this.getFechaHoy()
          };

          this.centroCostoFacade.actualizarCentroCosto(centroConFactor);
        }
      }

      // Calcular el factor restante para el nuevo centro de costo
      const factorRestante = this.calcularFactorRestante();
      this.centroCostosForm.patchValue({ factor: factorRestante });
    }
  }

  /**
   * Calcular el factor restante basado en los centros de costo en memoria
   */
  calcularFactorRestante(): number {
    const sumaFactores = this.rowData.reduce((sum: number, centro: CentroCostoEntity) => sum + (centro.centro_costo_factor || 0), 0);
    const restante = 100 - sumaFactores;
    return restante > 0 ? restante : 0;
  }

  /**
   * Actualiza el AG-Grid con el rowData en memoria
   */
  private actualizarTabla(): void {
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', [...this.rowData]);
    }
  }

  /**
   * Método para manejar la selección de cuenta de cargo
   */
  onCuentaCargoSeleccionada(cuenta: any) {
    console.log('Cuenta de cargo seleccionada:', cuenta);
  }

  /**
   * Método para manejar la selección de cuenta de abono
   */
  onCuentaAbonoSeleccionada(cuenta: any) {
    console.log('Cuenta de abono seleccionada:', cuenta);
  }

  /**
   * Verificar si hay centros de costo creados
   */
  tieneCentrosCosto(): boolean {
    return this.rowData && this.rowData.length > 0;
  }

  /**
   * Cargar clasificaciones de activos desde localStorage para el autocomplete
   */
  // cargarClasificacionesActivos() {
  //   // Leer directamente desde localStorage para obtener los datos más recientes
  //   const datosGuardados = localStorage.getItem('clasificacionActivos');
  //   let clasificaciones: any[] = [];

  //   if (datosGuardados) {
  //     try {
  //       clasificaciones = JSON.parse(datosGuardados);
  //     } catch (e) {
  //       console.error('Error al parsear clasificaciones:', e);
  //       clasificaciones = [];
  //     }
  //   }

  //   this.actualizarClasificacionesEnAutocomplete(clasificaciones);
  // }

  /**
   * Actualizar el array de tipos (clasificaciones) en el autocomplete
   * Solo toma las clasificaciones principales (clases, no subclases)
   */
  // private actualizarClasificacionesEnAutocomplete(clasificaciones: any[]) {
  //   // Filtrar solo las clases principales (que tienen orgHierarchy con length 1)
  //   const clasesPrincipales = clasificaciones.filter((item: any) => {
  //     return item.orgHierarchy && item.orgHierarchy.length === 1;
  //   });

  //   // Mapear al formato que espera el autocomplete
  //   this.tipos = clasesPrincipales.map((clase: any) => ({
  //     id: clase.codigo,
  //     nombre: `${clase.codigo} - ${clase.nombre}`
  //   }));

  //   console.log('Clasificaciones cargadas en autocomplete:', this.tipos);
  // }
}
