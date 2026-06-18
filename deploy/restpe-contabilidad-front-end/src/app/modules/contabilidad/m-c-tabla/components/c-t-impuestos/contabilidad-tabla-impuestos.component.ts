import { Component, OnInit, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef, RowClickedEvent } from 'ag-grid-community';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { TablaImpuestoFacade } from 'src/app/modules/contabilidad/application/facades/tabla-impuesto.facade';
import { TablaImpuestoFeedbackEffects } from 'src/app/modules/contabilidad/effects/tabla-impuesto-feedback.effect';
import { TablaImpuestoSyncEffects } from 'src/app/modules/contabilidad/effects/tabla-impuesto-sync.effect';
import { TablaImpuestoEntity } from 'src/app/modules/contabilidad/domain/models/tabla-impuesto.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faCog, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-contabilidad-tabla-impuestos',
  templateUrl: './contabilidad-tabla-impuestos.component.html',
  styleUrls: ['./contabilidad-tabla-impuestos.component.scss'],
  standalone: false,
})
export class ContabilidadTablaImpuestosComponent implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasCog = faCog;
  fasRotateRight = faRotateRight;


  // RANGO DE FECHAS

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  // FECHAS ÚNICAS (SINGLE)
  fechaOperacionForm: Date | undefined;
  fechaVigenciaDesde: Date | undefined;
  fechaVigenciaHasta: Date | undefined;

  impuestosForm!: FormGroup;
  private gridApi!: GridApi;
  camponuevo: boolean = false;
  filaSeleccionada: any = null;
  archivo: any = null;
  private ignorarValidacion: boolean = false;

  // ── Clean Architecture injections ─────────────────────────────────────────
  readonly tablaImpuestoFacade    = inject(TablaImpuestoFacade);
  readonly feedbackEffects        = inject(TablaImpuestoFeedbackEffects);
  readonly syncEffects            = inject(TablaImpuestoSyncEffects);
  readonly isLoading              = this.tablaImpuestoFacade.isLoading;

  // Arreglos para los selects

  impuestos = [
    { value: 'IGV', nombre: 'IGV' },
    { value: 'IVA', nombre: 'IVA' },
    { value: 'ISRL', nombre: 'ISRL' },
    { value: 'ICBPER', nombre: 'ICBPER' },
    { value: 'OTROS', nombre: 'OTROS' },
  ];

  cuentas: any[] = [];

  estadoSelect = [
    { id: 'Activo', nombre: 'Activo' },
    { id: 'Inactivo', nombre: 'Inactivo' }
  ];

  aplicableSelect = [
    { id: 'compras', nombre: 'Compras' },
    { id: 'ventas', nombre: 'Ventas' },
  ];

  rowData: any[] = [];

  rowDataOriginal = [...this.rowData];


  colDefs: ColDef[] = [
    { field: 'impuesto_codigo', headerName: 'Código', width: 80 },
    { field: 'impuesto_tipo', headerName: 'Tipo', filter: true, width: 80 },
    { field: 'impuesto_descripcion', headerName: 'Descripción', flex: 1 },
    {
      field: 'impuesto_porcentaje',
      headerName: 'Porcentaje',
      headerClass: 'derechaencabezado',
      width: 80,
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
        alignItems: 'center',
      }
    },
    { field: 'impuesto_cuenta_c', headerName: 'Cuenta contable asociada', width: 120 },
    { field: 'impuesto_vigente', headerName: 'Vigente desde', width: 100 },
    {
      field: "impuesto_estado", headerName: "Estado", headerClass: 'ag-header-hover ag-header-10px centrarencabezado', filter: true, width: 90,
      cellRenderer: (params: any) => {
        const estado = params.value;
        const estadoClass = estado === 'Activo' ? 'text-green-600 bg-green-100' : 'text-red-600 bg-red-100';
        return `<span class="px-2 py-[1px] rounded-full text-xxss font-medium ${estadoClass}">${estado}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
  ];

  columnTypes = {};

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

  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService,
    private simulation: SimulationService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
    // Inicializar fecha de creación con hoy por defecto
    this.fechaOperacionForm = today;

    // Sincronizar rowData reactivamente desde el facade
    effect(() => {
      this.rowData = this.tablaImpuestoFacade.items();
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });

    // Registrar callbacks de feedback
    this.feedbackEffects.registrarCallbacks({
      onGuardarExito:    () => this.limpiarFormulario(),
      onActualizarExito: () => this.formValidationService.resetearEstado(),
    });
  }

  ngOnInit() {
    // Cargar impuestos desde la capa de dominio (JSON vía repositorio)
    this.tablaImpuestoFacade.cargarItems();

    // Cargar cuentas contables
    this.cargarCuentasContables();

    // Actualizar formulario para reflejar los campos del HTML
    this.impuestosForm = this.formBuilder.group({
      razonSocial: [''],
      usuarioR: [''],
      fechaC: [{ value: this.getFechaHoy(), disabled: true }],
      tipoImpuesto: ['', Validators.required],
      descripcion: ['', Validators.required],
      porcentaje: ['', [Validators.required, Validators.min(0), Validators.max(100)]],
      aplicable: ['', Validators.required],
      cuentaC: ['', Validators.required],
      vigenciaD: ['', Validators.required],
      vigenciaH: [''],
      observacion: [''],
      estado: ['Activo', Validators.required]
    });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.impuestosForm);
  }

  /**
   * Cargar cuentas contables desde el SimulationService
   */
  cargarCuentasContables() {
    const cuentasLS = this.simulation.list('plancontable') || [];

    // Mapear cuentas con el formato necesario para el autocomplete
    this.cuentas = cuentasLS.map((item: any) => ({
      id: item.codigo,
      codigo: item.codigo,
      descripcion: item.descripcion,
      nombre: `${item.codigo} - ${item.descripcion}`,
      naturaleza: item.naturaleza,
      tipo: item.tipo,
      nivel: item.nivel,
      estado: item.estado,
      ...item
    }));
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onAplicableSeleccionado(aplicable: any) {
    this.impuestosForm.patchValue({
      aplicable: aplicable
    })
  }

  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }
  getFechaHoy(): string {
    return new Date().toLocaleDateString('es-PE');
  }

  formatearFecha(fecha: Date): string {
    const dia = String(fecha.getDate()).padStart(2, '0');
    const mes = String(fecha.getMonth() + 1).padStart(2, '0');
    const anio = fecha.getFullYear();
    return `${dia}/${mes}/${anio}`;
  }

  private parsearFechaDDMMYYYY(fechaStr: string): Date | undefined {
    if (!fechaStr) return undefined;
    const partes = fechaStr.split('/');
    if (partes.length !== 3) return undefined;
    return new Date(
      parseInt(partes[2]),
      parseInt(partes[1]) - 1,
      parseInt(partes[0])
    );
  }

  onBtReset() {
    this.tablaImpuestoFacade.cargarItems();
  }

  onFirstDataRendered(params: any) {
    // No seleccionar automáticamente la primera fila
    // El formulario inicia en modo "Nuevo impuesto"
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

  async onCellClicked(event: any) {
    const data = event.data;

    // Prevenir selección automática
    event.node.setSelected(false);

    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Mantener selección anterior
      if (this.filaSeleccionada) {
        setTimeout(() => {
          if (this.gridApi) {
            this.gridApi.deselectAll();
            this.gridApi.forEachNode((node) => {
              if (node.data.impuesto_codigo === this.filaSeleccionada.impuesto_codigo) {
                node.setSelected(true);
              }
            });
          }
        }, 0);
      } else {
        if (this.gridApi) {
          this.gridApi.deselectAll();
        }
      }
      return;
    }

    // Cargar datos del impuesto seleccionado
    this.cargarDatosImpuesto(data);
  }

  private cargarDatosImpuesto(data: any) {
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

    // Parsear aplicable: siempre convertir a array para el autocomplete-multi
    let aplicableValue: string[] = [];
    if (Array.isArray(data.impuesto_aplicable)) {
      aplicableValue = data.impuesto_aplicable;
    } else if (typeof data.impuesto_aplicable === 'string' && data.impuesto_aplicable.trim()) {
      aplicableValue = data.impuesto_aplicable.split(',').map((s: string) => s.trim());
    }

    // Parsear fechas de vigencia para los calendarios
    this.fechaVigenciaDesde = this.parsearFechaDDMMYYYY(data.impuesto_vigente);
    this.fechaVigenciaHasta = this.parsearFechaDDMMYYYY(data.impuesto_vigencia_h);

    this.impuestosForm.patchValue({
      fechaC: data.impuesto_fecha_creacion,
      tipoImpuesto: data.impuesto_tipo,
      descripcion: data.impuesto_descripcion,
      porcentaje: data.impuesto_porcentaje?.replace('%', ''),
      aplicable: aplicableValue,
      cuentaC: data.impuesto_cuenta_c,
      vigenciaD: this.fechaVigenciaDesde ? this.formatearFecha(this.fechaVigenciaDesde) : '',
      vigenciaH: this.fechaVigenciaHasta ? this.formatearFecha(this.fechaVigenciaHasta) : '',
      observacion: data.impuesto_observacion,
      estado: data.impuesto_estado
    });

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  async botonNuevoImpuesto() {
    // Validar cambios antes de limpiar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Cancelar acción
    }

    this.camponuevo = true;
    this.filaSeleccionada = null;

    // Limpiar formulario
    this.impuestosForm.reset({
      fechaC: this.getFechaHoy(),
      tipoImpuesto: '',
      descripcion: '',
      porcentaje: '',
      aplicable: '',
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

  async botonCancelar() {
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return;
    }

    this.camponuevo = false;
    this.filaSeleccionada = null;
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    this.formValidationService.resetearEstado();
  }

  botonGuardar() {
    // Validar formulario
    if (this.impuestosForm.invalid) {
      this.impuestosForm.markAllAsTouched();
      this.toastService.warning('Por favor, completa todos los campos requeridos.');
      return;
    }

    const formValue = this.impuestosForm.value;

    // Generar código automático si es nuevo
    const codigo = this.filaSeleccionada
      ? this.filaSeleccionada.impuesto_codigo
      : `IMP-${String(this.rowData.length + 1).padStart(3, '0')}`;

    // Formatear porcentaje
    const porcentajeFormateado = `${formValue.porcentaje}%`;

    // Formatear aplicable
    const aplicableFormateado = Array.isArray(formValue.aplicable)
      ? formValue.aplicable.join(', ')
      : formValue.aplicable;

    // Formatear fecha de vigencia
    const vigenciaDesdeFormateada = this.fechaVigenciaDesde
      ? this.formatearFecha(this.fechaVigenciaDesde)
      : formValue.vigenciaD;

    const vigenciaHastaFormateada = this.fechaVigenciaHasta
      ? this.formatearFecha(this.fechaVigenciaHasta)
      : formValue.vigenciaH;

    if (this.filaSeleccionada) {
      // EDITAR registro existente
      const index = this.rowData.findIndex(item => item.impuesto_codigo === this.filaSeleccionada.impuesto_codigo);
      if (index !== -1) {
        const updatedItem: TablaImpuestoEntity = {
          ...this.rowData[index],
          impuesto_tipo: formValue.tipoImpuesto,
          impuesto_descripcion: formValue.descripcion,
          impuesto_porcentaje: porcentajeFormateado,
          impuesto_aplicable: aplicableFormateado,
          impuesto_cuenta_c: formValue.cuentaC,
          impuesto_vigente: vigenciaDesdeFormateada,
          impuesto_vigencia_h: vigenciaHastaFormateada,
          impuesto_observacion: formValue.observacion,
          impuesto_estado: formValue.estado
        };

        this.tablaImpuestoFacade.actualizarItem(updatedItem);
      }
    } else {
      // CREAR nuevo registro
      const nuevoRegistro: TablaImpuestoEntity = {
        impuesto_codigo: codigo,
        impuesto_tipo: formValue.tipoImpuesto,
        impuesto_codigo_sun: formValue.tipoImpuesto,
        impuesto_descripcion: formValue.descripcion,
        impuesto_porcentaje: porcentajeFormateado,
        impuesto_aplicable: aplicableFormateado,
        impuesto_cuenta_c: formValue.cuentaC,
        impuesto_vigente: vigenciaDesdeFormateada,
        impuesto_vigencia_h: vigenciaHastaFormateada,
        impuesto_usuario_r: 'Eduardo Jiménez López',
        impuesto_fecha_creacion: this.getFechaHoy(),
        impuesto_observacion: formValue.observacion,
        impuesto_estado: formValue.estado
      };

      // Guardar mediante facade (Clean Architecture)
      this.tablaImpuestoFacade.guardarItem(nuevoRegistro);
      // Toast + limpiarFormulario son disparados por TablaImpuestoFeedbackEffects
    }

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }
  refrescarVista() {
    this.tablaImpuestoFacade.cargarItems();
  }
  private limpiarFormulario() {
    this.filaSeleccionada = null;
    this.camponuevo = true;

    // Limpiar formulario
    this.impuestosForm.reset({
      fechaC: this.getFechaHoy(),
      tipoImpuesto: '',
      descripcion: '',
      porcentaje: '',
      aplicable: '',
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
  }

  onTipoSeleccionado(tipo: any) {
    console.log('Tipo seleccionado:', tipo);
  }


  importar(data: any) {
    console.log('Importar llamado con:', data);
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    this.cargarDatos(range.start, range.end);
  }

  cargarDatos(start: Date, end: Date) {
    console.log('Cargar datos entre', start, 'y', end);
  }

  onFechaVigenciaDesdeSelected(fecha: Date) {
    this.fechaVigenciaDesde = fecha;
    this.impuestosForm.patchValue({ vigenciaD: this.formatearFecha(fecha) });
  }

  onFechaVigenciaHastaSelected(fecha: Date) {
    this.fechaVigenciaHasta = fecha;
    this.impuestosForm.patchValue({ vigenciaH: this.formatearFecha(fecha) });
  }

  // Manejo de fecha de creación (igual que fechaOperacionForm del primer ejemplo)
  onFechaOperacionForm(date: Date) {
    this.fechaOperacionForm = date;
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
      this.toastService.danger('Error al obtener resultado del modal');
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
      { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Se ha creado el grupo 1.00' },
      { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se edito la descripción del grupo' },
      { fechaHora: '13/11/2025 09:00', usuario: 'Carlos Rodríguez', accion: 'Actualización', detalleCambio: 'Se cambió el tipo de flujo' },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones de impuesto ${this.filaSeleccionada?.impuesto_codigo || ''}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }
}