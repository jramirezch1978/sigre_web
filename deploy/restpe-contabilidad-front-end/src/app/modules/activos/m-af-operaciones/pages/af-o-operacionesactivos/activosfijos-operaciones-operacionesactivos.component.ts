import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalController } from '@ionic/angular';
import { ModalAnularOperacionComponent } from './modal/modal-anular-operacion/modal-anular-operacion.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { filter } from 'rxjs';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { OperacionFacade } from 'src/app/modules/activos/application/facades/operacion.facade';
import { RegistroOperacionActivoFacade } from 'src/app/modules/activos/application/facades/registro-operacion-activo.facade';
import { ActivoFijoFacade } from 'src/app/modules/activos/application/facades/activo-fijo.facade';

// Font Awesome Icons
import { faBook, faCircleXmark, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';



@Component({
  selector: 'app-activosfijos-operaciones-operacionesactivos',
  templateUrl: './activosfijos-operaciones-operacionesactivos.component.html',
  styleUrls: ['./activosfijos-operaciones-operacionesactivos.component.scss'],
  standalone: false,
})
export class ActivosfijosOperacionesOperacionesactivosComponent implements OnInit, OnDestroy {
  readonly facade = inject(OperacionFacade);
  readonly registroOpFacade = inject(RegistroOperacionActivoFacade);
  private readonly activoFijoFacade = inject(ActivoFijoFacade);

  // Font Awesome Icons
  farBook = faBook;
  farCircleXmark = faCircleXmark;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  //FECHAS ÚNICAS (SINGLE)
  fechaOperacionForm: Date | undefined;  
    
  // AG-Grid
  private gridApi!: GridApi;

  // Estado del formulario
  selectedOperacion: any = null;
  disabledAnular: boolean = true;
  disabledValidar: boolean = true;

  operacionesForm!: FormGroup;

  responsableOptions = [
    { value: 'Usuario', label: 'Usuario' },
    { value: 'Entidad', label: 'Entidad' }
  ];

  get mostrarOrdenAsociada(): boolean {
    return this.operacionesForm?.get('tipoOperacion')?.value === 'Revaluación';
  }

  // Archivos
  documentos: Array<{ nombre: string }> = [];
  maxDocumentos: number = 5;

  //Lista de Responsable de Ejecución para el autocomplete
  responsablesList = [
    { id: 'responsable1', nombre: 'Juan Pérez' },
    { id: 'responsable2', nombre: 'Javier Correa' },
    { id: 'responsable3', nombre: 'Haaron Chávez' },
    { id: 'responsable4', nombre: 'Ernestos Ravello' },
    { id: 'responsable5', nombre: 'Alexander Alvarado' },
  ];

  // Lista de activos para el autocomplete
  activosList: any[] = [];

  // Lista de matrices contables para el autocomplete
  matricesContablesList = [
    { id: 'MC-001', nombre: 'MC-001 - Revaluación de Activos Fijos' },
    { id: 'MC-002', nombre: 'MC-002 - Depreciación Extraordinaria' },
    { id: 'MC-003', nombre: 'MC-003 - Mejoras Capitalizables' },
    { id: 'MC-004', nombre: 'MC-004 - Baja de Activos por Obsolescencia' },
  ];

  readonly rowData = this.registroOpFacade.registros;

  colDefs: ColDef[] = [
    { field: 'registro_op_codigo', headerName: 'ID Operación', width: 120 },
    { field: 'registro_op_cod_activo', headerName: 'Cód. Activo', width: 100 },
    { field: 'registro_op_tipo_operacion', headerName: 'Tipo de operación', width: 140, filter: true },
    { field: 'registro_op_fecha', headerName: 'Fecha', width: 100 },
    { field: 'registro_op_responsable', headerName: 'Responsable', width: 120 },
    {
      field: 'registro_op_estado',
      headerName: 'Estado',
      width: 130,
      headerClass: 'centrarencabezado',
      cellStyle: {
        textAlign: 'center',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
      filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Registrado') {
          return '<span class="badge-table bg-[#FFF0BF] text-yellow">Registrado</span>';
        } else if (params.value === 'Validado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Validado</span>';
        } else if (params.value === 'Contabilizado') {
          return '<span class="badge-table bg-[#D6E6FF] text-primary !w-16">Contabilizado</span>';
        } else if (params.value === 'Anulado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulado</span>';
        }
        return params.value;
      },
    },
  ];

  columnTypes = {
    rightAligned: { cellClass: 'text-right' },
  };

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
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  constructor(
    private toastService: ToastService,
    private modalController: ModalController,
    private fb: FormBuilder,
    private formValidationService: FormValidationService
    
  ) {
    effect(() => {
      const items = this.activoFijoFacade.activosFijos();
      this.activosList = items.map((item) => ({
        id: item.activo_fijo_codigo,
        nombre: `${item.activo_fijo_codigo} - ${item.activo_fijo_descripcion}`,
      }));
    });
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
    // Inicializar fecha de operación con hoy por defecto
    this.fechaOperacionForm = today;
  }

  ngOnInit() {
    this.facade.cargarOperaciones();
    this.registroOpFacade.cargarRegistros();
    this.activoFijoFacade.cargarActivosFijos();

    this.operacionesForm = this.fb.group({
      activoCodigo: ['', Validators.required],
      tipoOperacion: ['', Validators.required],
      tipoRevaluacion: [''],
      fuenteRevaluacion: [''],
      factorRevaluacion: [''],
      nuevoValor: [''],
      montoOperacion: ['', Validators.required],
      moneda: ['', Validators.required],
      descripcionMotivo: ['', Validators.required],
      responsableEvaluadorTipo: ['Usuario'],
      responsableEvaluador: [''],
      responsable: [''],
      matrizContable: ['', Validators.required],
      observaciones: [''],
      estado: [''],
    });
  }

  ngOnDestroy() {
    // Cleanup si es necesario
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  async onCellClicked(event: any) {
    const data = event.data;

    // Prevenir selección automática de AG-Grid
    event.node.setSelected(false);

    // Validar si hay cambios sin guardar
    const hayCambios = this.verificarCambios();

    if (hayCambios) {
      const confirmar = await this.confirmarCambiosSinGuardar();
      if (!confirmar) {
        // Mantener selección anterior
        if (this.selectedOperacion) {
          setTimeout(() => {
            this.gridApi.deselectAll();
            this.gridApi.forEachNode((node) => {
              if (node.data.registro_op_codigo === this.selectedOperacion.registro_op_codigo) {
                node.setSelected(true);
              }
            });
          }, 0);
        } else {
          this.gridApi.deselectAll();
        }
        return;
      }
    }

    // Cargar datos del registro seleccionado
    this.cargarDatosRegistro(data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: any, node?: any): void {
    console.log('Fila seleccionada:', data);

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Seleccionar el nodo en AG-Grid
    if (node) {
      node.setSelected(true);
    } else if (this.gridApi) {
      this.gridApi.forEachNode((n) => {
        if (n.data === data) {
          n.setSelected(true);
        }
      });
    }

    this.selectedOperacion = { ...data };

    // Actualizar estado de botones según el estado de la operación
    this.updateButtonStates();

    // Cargar datos en el formulario
    this.loadFormData();
  }

  updateButtonStates() {
    if (this.selectedOperacion?.registro_op_estado === 'Registrado') {
      this.disabledAnular = false;
      this.disabledValidar = false;
      this.operacionesForm.disable();
    } else {
      this.disabledAnular = true;
      this.disabledValidar = true;
      this.operacionesForm.disable();
    }
  }

  loadFormData() {
    if (this.selectedOperacion) {
      const op = this.selectedOperacion;

      this.operacionesForm.patchValue({
        activoCodigo: op.registro_op_cod_activo || '',
        tipoOperacion: op.registro_op_tipo_operacion || '',
        tipoRevaluacion: op.registro_op_tipo_revaluacion || '',
        fuenteRevaluacion: op.registro_op_fuente_revaluacion || '',
        factorRevaluacion: op.registro_op_factor_revaluacion || '',
        nuevoValor: op.registro_op_nuevo_valor || '',
        montoOperacion: op.registro_op_monto || '',
        moneda: op.registro_op_moneda || '',
        descripcionMotivo: op.registro_op_descripcion || '',
        responsableEvaluadorTipo: op.registro_op_responsable_evaluador_tipo || 'Usuario',
        responsableEvaluador: op.registro_op_responsable_evaluador || '',
        responsable: op.registro_op_responsable || '',
        matrizContable: op.registro_op_matriz_contable || '',
        observaciones: op.registro_op_observaciones || '',
        estado: op.registro_op_estado || '',
      });

      if (op.registro_op_fecha) {
        this.fechaOperacionForm = new Date(op.registro_op_fecha + 'T00:00:00');
      }

      if (op.registro_op_documentos) {
        this.documentos = op.registro_op_documentos.map(
          (doc: string) => ({ nombre: doc })
        );
      }
    }
  }

  async nuevaOperacion() {
    // Validar si hay cambios sin guardar
    const hayCambios = this.verificarCambios();

    if (hayCambios) {
      const confirmar = await this.confirmarCambiosSinGuardar();
      if (!confirmar) {
        return; // Cancelar acción
      }
    }

    console.log('Nueva operación');
    // Deseleccionar todas las filas
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    // Limpiar selección y formulario
    this.selectedOperacion = null;
    this.clearForm();
    this.operacionesForm.enable();
    this.disabledAnular = true;
    this.disabledValidar = true;
  }

  clearForm() {
    this.operacionesForm.reset({ responsableEvaluadorTipo: 'Usuario' });
    this.documentos = [];
    this.fechaOperacionForm = new Date();
  }

  onActivoSelected(activo: any) {
    console.log('Activo seleccionado:', activo);
  }
  onSelectResponsable(responsable: any) {
    console.log('Responsable seleccionado:', responsable);
  }
  onMatrizSelected(matriz: any) {
    console.log('Matriz seleccionada:', matriz);
  }

  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (file && this.documentos.length < this.maxDocumentos) {
      this.documentos.push({ nombre: file.name });
    } else if (this.documentos.length >= this.maxDocumentos) {
      this.toastService.danger(
        `Solo puedes subir un máximo de ${this.maxDocumentos} archivos`
      );
    }
    // Resetear el input file
    event.target.value = '';
  }

  removeFile(index: number) {
    this.documentos.splice(index, 1);
  }

  registrarOperacion() {
    const f = this.operacionesForm.value;

    const responsableField = f.tipoOperacion === 'Revaluación' ? f.responsableEvaluador : f.responsable;

    if (!f.activoCodigo || !f.tipoOperacion || !this.fechaOperacionForm ||
        !f.montoOperacion || !f.moneda || !f.descripcionMotivo ||
        !responsableField || !f.matrizContable) {
      this.toastService.warning('Por favor, complete todos los campos requeridos');
      return;
    }

    if (f.tipoOperacion === 'Revaluación') {
      if (!f.tipoRevaluacion || !f.fuenteRevaluacion || !f.factorRevaluacion || !f.nuevoValor) {
        this.toastService.warning('Por favor, complete todos los campos requeridos');
        return;
      }
    }

    if (this.documentos.length === 0) {
      this.toastService.warning('Debe adjuntar al menos un documento de referencia');
      return;
    }

    const nuevaOperacion: any = {
      registro_op_codigo: `OP-${String(this.rowData().length + 1).padStart(3, '0')}`,
      registro_op_cod_activo: f.activoCodigo || '',
      registro_op_activo_nombre: this.activosList.find(a => a.id === f.activoCodigo)?.nombre || '',
      registro_op_tipo_operacion: f.tipoOperacion,
      registro_op_fecha: this.fechaOperacionForm ? this.fechaOperacionForm.toISOString().split('T')[0] : '',
      registro_op_monto: f.montoOperacion,
      registro_op_moneda: f.moneda,
      registro_op_descripcion: f.descripcionMotivo,
      registro_op_responsable: f.tipoOperacion === 'Revaluación' ? f.responsableEvaluador : f.responsable,
      registro_op_matriz_contable: f.matrizContable,
      registro_op_estado: 'Registrado',
      registro_op_observaciones: f.observaciones,
      registro_op_documentos: this.documentos.map(doc => doc.nombre)
    };

    if (f.tipoOperacion === 'Revaluación') {
      nuevaOperacion.registro_op_tipo_revaluacion = f.tipoRevaluacion;
      nuevaOperacion.registro_op_fuente_revaluacion = f.fuenteRevaluacion;
      nuevaOperacion.registro_op_factor_revaluacion = f.factorRevaluacion;
      nuevaOperacion.registro_op_nuevo_valor = f.nuevoValor;
      nuevaOperacion.registro_op_responsable_evaluador = f.responsableEvaluador;
      nuevaOperacion.registro_op_responsable_evaluador_tipo = f.responsableEvaluadorTipo;
    }

    console.log('Registrar operación:', nuevaOperacion);

    this.gridApi.applyTransaction({ add: [nuevaOperacion], addIndex: 0 });
    this.toastService.success('¡Operación registrada exitosamente!');
    this.selectedOperacion = { ...nuevaOperacion };
    this.operacionesForm.disable();
    this.disabledAnular = true;
    this.disabledValidar = true;
    
    // Aquí iría la lógica para registrar en el backend
  }

  anularOperacion() {
    console.log('Anular operación:', this.selectedOperacion);
    this.openAnularModal();
  }

  async openAnularModal() {
    const modal = await this.modalController.create({
      component: ModalAnularOperacionComponent,
      componentProps: {
        operacion: this.selectedOperacion,
      },
      cssClass: 'promo',
    });

    await modal.present();

    const { data } = await modal.onDidDismiss();

    if (data && data.anulada) {
      // Usuario confirmó la anulación
      this.toastService.success('¡Operación anulada exitosamente!');
      console.log('Motivo de anulación:', data.motivo);

      // Actualizar el estado de la operación
      if (this.selectedOperacion) {
        this.selectedOperacion.registro_op_estado = 'Anulado';
        this.updateButtonStates();

        // Actualizar en la tabla también
        const rowNode = this.gridApi.getRowNode(
          this.selectedOperacion.registro_op_codigo
        );
        if (rowNode) {
          rowNode.setDataValue('registro_op_estado', 'Anulado');
        }
      }
    }
  }

  validarOperacion() {
    console.log('Validar operación:', this.selectedOperacion);
    this.openValidarModal();
  }

  async openValidarModal() {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        title: 'Confirmar Validación de Operación',
        message:
          'Por favor, revisa los detalles antes de proceder. Una vez validado, no podrás modificar ni deshacer esta acción.',
        btnCancelTxt: 'Cancelar',
        btnOkTxt: 'Confirmar',
        isDelete: false,
      },
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();

    if (data === true) {
      // Usuario confirmó la validación
      this.toastService.success('¡Se validó la orden exitosamente!');

      // Actualizar el estado de la operación
      if (this.selectedOperacion) {
        this.selectedOperacion.registro_op_estado = 'Validado';
        this.updateButtonStates();

        // Actualizar en la tabla también
        const rowNode = this.gridApi.getRowNode(
          this.selectedOperacion.registro_op_codigo
        );
        if (rowNode) {
          rowNode.setDataValue('registro_op_estado', 'Validado');
        }
      }

      // Limpiar formulario y volver a estado inicial
      this.clearForm();
      this.nuevaOperacion();
    }
  }

  guardarOperacion() {
    const f = this.operacionesForm.value;
    console.log('Guardar cambios en operación:', this.selectedOperacion);
    
    const rowNode = this.gridApi.getRowNode(this.selectedOperacion.registro_op_codigo);
    if (rowNode) {
      rowNode.setData({
        ...this.selectedOperacion,
        registro_op_tipo_operacion: f.tipoOperacion,
        registro_op_fecha: this.fechaOperacionForm ? this.fechaOperacionForm.toISOString().split('T')[0] : this.selectedOperacion.registro_op_fecha,
        registro_op_responsable: f.tipoOperacion === 'Revaluación' ? f.responsableEvaluador : f.responsable
      });
    }
    
    this.toastService.success('¡Operación actualizada exitosamente!');
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

  // Para modo SINGLE - Manejo de fecha seleccionada
  onFechaOperacionForm(date: Date) {
    console.log('Fecha Operación seleccionada:', date);
    this.fechaOperacionForm = date;
  }
   onBtReset() {
      if (this.gridApi) {
        // Mostrar loading y recargar datos
        this.gridApi.showLoadingOverlay();
  
        // Simular recarga de datos
        setTimeout(() => {
          this.gridApi.setGridOption('rowData', [...this.rowData()]);
          this.gridApi.hideOverlay();
          console.log('Tabla refrescada');
        }, 300);
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
        { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar',},
        { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385',},
        { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio:   'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380',},
        { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT',},
      ];
  
      const modal = await this.modalController.create({
        component: ModalVerActualizacionesComponent,
        cssClass: 'promo',
        componentProps: {
          titulo: 'Historial de Actualizaciones - Tipo de Cambio',
          rowData: rowData,
          colDefs: colDefs,
          anchoModal: '700px',
    
        },
      });
  
      await modal.present();
    }

  // Método para verificar si hay cambios en el formulario
  private verificarCambios(): boolean {
    if (!this.selectedOperacion) {
      return this.operacionesForm.dirty || this.documentos.length > 0;
    }
    return false;
  }

  // Método para mostrar modal de confirmación de cambios sin guardar
  private async confirmarCambiosSinGuardar(): Promise<boolean> {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        title: 'Cambios sin guardar',
        message: 'Hay cambios sin guardar. ¿Deseas continuar sin guardar?',
        btnCancelTxt: 'Cancelar',
        btnOkTxt: 'Continuar',
        isDelete: false,
      },
    });

    await modal.present();
    const { data } = await modal.onWillDismiss();
    return data === true;
  }
}
