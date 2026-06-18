import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { NumTrasladoFacade } from 'src/app/modules/activos/application/facades/num-traslado.facade';
import { NumTrasladoFeedbackEffects } from 'src/app/modules/activos/effects/num-traslado-feedback.effect';
import { NumTrasladoSyncEffects } from 'src/app/modules/activos/effects/num-traslado-sync.effect';
import { NumTrasladoEntity } from 'src/app/modules/activos/domain/models/num-traslado.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-activofijo-tabla-numtraslados',
  templateUrl: './activofijo-tabla-numtraslados.component.html',
  styleUrls: ['./activofijo-tabla-numtraslados.component.scss'],
  standalone: false,
})
export class ActivofijoTablaNumtrasladosComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  private readonly numTrasladoFacade    = inject(NumTrasladoFacade);
  private readonly numTrasladoFeedback  = inject(NumTrasladoFeedbackEffects);
  private readonly numTrasladoSync      = inject(NumTrasladoSyncEffects);
  readonly isLoading                    = this.numTrasladoFacade.isLoading;

  startDate: Date | undefined;
  endDate: Date | undefined;
  selectedDate: Date | undefined;

  //FECHAS ÚNICAS (SINGLE)
  fechaUltimaActualizacion: Date | undefined;
  fechaPeriodoContable: Date | undefined;

  // Periodo contable (mes y año)
  periodoMes: number | null = null;
  periodoAnio: number | null = null;



  gridContext!: { componentParent: ActivofijoTablaNumtrasladosComponent };

  gridApi!: GridApi;
  camponuevo: boolean = true;
  estadoSeleccionado: string = 'todos'
  SecuenciasForm!: FormGroup;
  filaSeleccionada: NumTrasladoEntity | null = null;
  rowData: NumTrasladoEntity[] = [];

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


  selectorsucursal =
    [
      { value: 'principal', nombre: 'Sucursal principal' },
      { value: 'barranco', nombre: 'Sucursal Barranco' },
      { value: 'limanorte', nombre: 'Sucursal Lima norte' },
      { value: 'sanisidro', nombre: 'Sucursal San Isidro' },
      { value: 'miraflores', nombre: 'Sucursal Miraflores' },
      { value: 'surco', nombre: 'Sucursal Surco' },
    ]

  //  Tipado con la misma interfaz
  colDefs: ColDef<NumTrasladoEntity>[] = [
    { field: 'num_traslado_codigo',       headerName: 'Código',            flex: 1 },
    { field: 'num_traslado_sucursal',     headerName: 'Sucursal',          flex: 1 },
    { field: 'num_traslado_periodo_cont', headerName: 'Periodo contable',  flex: 1 },
    { field: 'num_traslado_prefijo',      headerName: 'Prefijo',           flex: 1 },
    { field: 'num_traslado_tipo_doc',     headerName: 'Tipo de Documento', flex: 1 },
    { field: 'num_traslado_ninicial',     headerName: 'Número Inicial',    flex: 1 },
    { field: 'num_traslado_nactual',      headerName: 'Número Actual',     flex: 1 },
    {
      field: 'num_traslado_estado', filter: true,
      headerClass: 'centrarencabezado', headerName: 'Estado', width: 80, cellRenderer: (params: any) => {
        const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  constructor(
    private formBuilder: FormBuilder,
    private toastservice: ToastService,
    private modalController: ModalController,
    private formValidationService: FormValidationService
  ) {
    const today = new Date();
    this.startDate = new Date(today.getFullYear(), today.getMonth(), 1);
    this.endDate = today;
    this.fechaUltimaActualizacion = new Date();

    // Sincronizar store → rowData (Signal effect)
    effect(() => {
      const items = this.numTrasladoFacade.numTraslados();
      this.rowData = items;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', items);
      }
    });
  }

  ngOnInit() {
    this.SecuenciasForm = this.formBuilder.group({


      search: new FormControl(''),
      filtroEstado: new FormControl('todos'),
      codigo: new FormControl(''),
      sucursal: new FormControl(''),
      tipoDoc: new FormControl(''),
      prefijo: new FormControl(''),
      longitud: new FormControl(''),
      ninicial: new FormControl(''),
      nactual: new FormControl(''),
      incremento: new FormControl(''),
      fechaActualizacion: new FormControl(''),
      periodoCont: new FormControl(''),
      rango: new FormControl(''),
      relleno: new FormControl(''),
      reinicio: new FormControl(''),
      formato: new FormControl(''),
      estado: new FormControl('Activo'),
      observaciones: new FormControl(''),
    });

    // Inicializar el servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.SecuenciasForm);
    this.numTrasladoFacade.cargarNumTraslados();
  }

  ngOnDestroy(): void {
    this.formValidationService.limpiarFormulario();
  }

  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  onBtReset() {
    this.numTrasladoFacade.cargarNumTraslados();
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
    loadingOoo: 'Cargando...'
  };

  async onCellClicked(event: any) {
    const data = event.data;

    // Permitir que la fila se seleccione primero
    event.node.setSelected(true);

    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Deseleccionar la fila actual y reseleccionar la anterior
      if (this.filaSeleccionada) {
        this.gridApi.deselectAll();
        this.gridApi.forEachNode((node) => {
          if (node.data.num_traslado_codigo === this.filaSeleccionada!.num_traslado_codigo) {
            node.setSelected(true);
          }
        });
      } else {
        this.gridApi.deselectAll();
      }
      return;
    }

    // Si confirma, cargar datos del registro seleccionado
    this.cargarDatosRegistro(data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: NumTrasladoEntity, node?: any): void {
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
    this.SecuenciasForm.patchValue({
      sucursal:          data.num_traslado_sucursal     || '',
      tipoDoc:           data.num_traslado_tipo_doc      || '',
      prefijo:           data.num_traslado_prefijo       || '',
      longitud:          data.num_traslado_longitud      || '',
      ninicial:          data.num_traslado_ninicial      || '',
      nactual:           data.num_traslado_nactual       || '',
      incremento:        data.num_traslado_incremento    || '',
      periodoCont:       data.num_traslado_periodo_cont  || '',
      rango:             data.num_traslado_rango         || '',
      relleno:           data.num_traslado_relleno       || '',
      reinicio:          data.num_traslado_reinicio      || '',
      formato:           data.num_traslado_formato       || '',
      estado:            data.num_traslado_estado        || '',
      observaciones:     data.num_traslado_observaciones || ''
    });

    // Parsear periodo contable (formato "YYYY-MM") para el month-year-picker
    if (data.num_traslado_periodo_cont) {
      const partes = data.num_traslado_periodo_cont.split('-');
      if (partes.length === 2) {
        this.periodoAnio = parseInt(partes[0], 10);
        this.periodoMes = parseInt(partes[1], 10);
      }
    }

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }
  async botonNuevaSecuencia() {
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Cancelar acción
    }

    this.camponuevo = true;
    this.filaSeleccionada = null; // Limpiar la fila seleccionada
    this.gridApi?.deselectAll(); // Deseleccionar filas en la tabla
    this.SecuenciasForm.reset();
    this.SecuenciasForm.patchValue({
      estado: 'Activo',
    });

    // Establecer fecha de última actualización como hoy
    this.fechaUltimaActualizacion = new Date();

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }
  validarCamposObligatorios(): boolean {
    const formValues = this.SecuenciasForm.value;
    
    // Campos requeridos
    const camposObligatorios =
      formValues.sucursal &&
      formValues.prefijo &&
      formValues.tipoDoc &&
      formValues.longitud &&
      formValues.ninicial &&
      formValues.nactual &&
      formValues.incremento &&
      formValues.rango &&
      formValues.reinicio &&
      formValues.estado &&
      this.periodoMes &&
      this.periodoAnio;
    
    return !!camposObligatorios;
  }

  botonGuardar() {
    // Validar campos obligatorios
    if (!this.validarCamposObligatorios()) {
      this.toastservice.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    const formValues = this.SecuenciasForm.value;

    // Construir entidad
    const entidad: NumTrasladoEntity = {
      num_traslado_codigo:       this.camponuevo ? this.generarNuevoCodigo() : this.filaSeleccionada!.num_traslado_codigo,
      num_traslado_sucursal:     formValues.sucursal,
      num_traslado_periodo_cont: `${this.periodoAnio}-${this.periodoMes?.toString().padStart(2, '0')}`,
      num_traslado_prefijo:      formValues.prefijo,
      num_traslado_tipo_doc:     formValues.tipoDoc,
      num_traslado_ninicial:     formValues.ninicial,
      num_traslado_nactual:      formValues.nactual,
      num_traslado_estado:       formValues.estado,
      num_traslado_longitud:     formValues.longitud    || '',
      num_traslado_incremento:   formValues.incremento  || '',
      num_traslado_rango:        formValues.rango       || '',
      num_traslado_relleno:      formValues.relleno     || '',
      num_traslado_reinicio:     formValues.reinicio    || '',
      num_traslado_formato:      formValues.formato     || '',
      num_traslado_observaciones: formValues.observaciones || ''
    };

    if (this.camponuevo) {
      this.numTrasladoFacade.guardarNumTraslado(entidad);
    } else if (this.filaSeleccionada) {
      this.numTrasladoFacade.actualizarNumTraslado(entidad);
    }

    // Limpiar formulario y resetear estado
    this.SecuenciasForm.reset();
    this.SecuenciasForm.patchValue({ estado: 'Activo' });
    this.filaSeleccionada = null;
    this.camponuevo = true;
    this.fechaPeriodoContable = undefined;
    this.periodoMes = null;
    this.periodoAnio = null;
    this.fechaUltimaActualizacion = new Date();
    this.formValidationService.resetearEstado();
  }

  botonReiniciarSecuencia() {
    if (!this.filaSeleccionada) {
      return;
    }

    // Calcular el siguiente número inicial basado en las secuencias existentes con el mismo prefijo
    const prefijo = this.filaSeleccionada.num_traslado_prefijo;
    const secuenciasMismoPrefijo = this.rowData.filter(item => item.num_traslado_prefijo === prefijo);
    const numerosIniciales = secuenciasMismoPrefijo.map(item => parseInt(item.num_traslado_ninicial, 10) || 0);
    const maxNumeroInicial = Math.max(...numerosIniciales, 0);
    const nuevoNumeroInicial = (maxNumeroInicial + 1).toString();

    // Crear objeto duplicado con número inicial incrementado
    const secuenciaDuplicada: NumTrasladoEntity = {
      num_traslado_codigo:        this.generarNuevoCodigo(),
      num_traslado_sucursal:      this.filaSeleccionada.num_traslado_sucursal,
      num_traslado_periodo_cont:  this.filaSeleccionada.num_traslado_periodo_cont,
      num_traslado_prefijo:       this.filaSeleccionada.num_traslado_prefijo,
      num_traslado_tipo_doc:      this.filaSeleccionada.num_traslado_tipo_doc,
      num_traslado_ninicial:      nuevoNumeroInicial,
      num_traslado_nactual:       this.filaSeleccionada.num_traslado_nactual,
      num_traslado_estado:        this.filaSeleccionada.num_traslado_estado,
      num_traslado_longitud:      this.filaSeleccionada.num_traslado_longitud,
      num_traslado_incremento:    this.filaSeleccionada.num_traslado_incremento,
      num_traslado_rango:         this.filaSeleccionada.num_traslado_rango,
      num_traslado_relleno:       this.filaSeleccionada.num_traslado_relleno,
      num_traslado_reinicio:      this.filaSeleccionada.num_traslado_reinicio,
      num_traslado_formato:       this.filaSeleccionada.num_traslado_formato,
      num_traslado_observaciones: this.filaSeleccionada.num_traslado_observaciones || ''
    };

    this.numTrasladoFacade.guardarNumTraslado(secuenciaDuplicada);
    this.toastservice.success("¡Se reinició secuencia exitosamente!");
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;

    // Iniciar en modo creación (formulario vacío)
    // No seleccionar ninguna fila automáticamente
  }

  // Generar código automático para nuevas secuencias
  generarNuevoCodigo(): string {
    const numeros = this.rowData.map(item => {
      const match = item.num_traslado_codigo.match(/TRA-(\d+)/);
      return match ? parseInt(match[1], 10) : 0;
    });
    const maxNumero = Math.max(...numeros, 0);
    const nuevoNumero = (maxNumero + 1).toString().padStart(3, '0');
    return `TRA-${nuevoNumero}`;
  }

  puedeGuardar(): boolean {
    const formValues = this.SecuenciasForm.value;

    // Campos requeridos según el formulario HTML
    const camposCompletos =
      formValues.sucursal &&
      formValues.prefijo &&
      formValues.tipoDoc &&
      formValues.longitud &&
      formValues.ninicial &&
      formValues.nactual &&
      formValues.incremento &&
      formValues.rango &&
      formValues.reinicio &&
      formValues.estado &&
      this.periodoMes &&
      this.periodoAnio;

    // Si es modo nuevo, solo validar que los campos estén completos
    if (this.camponuevo) {
      return !!camposCompletos;
    }

    // Si es modo edición, solo habilitar cuando hay cambios
    return this.formValidationService.tieneModificaciones();
  }

  // Para modo SINGLE - Manejo de fechas seleccionadas
  onFechaUltimaActualizacionSelected(date: Date) {
    console.log('Fecha actualizacion:', date);
    this.fechaUltimaActualizacion = date;
  }

  onFechaPeriodoSelected(date: Date) {
    console.log('Fecha vencimiento:', date);
    this.fechaPeriodoContable = date;
  }

  onPeriodoContableChange(event: { month: number, year: number }) {
    console.log('Periodo contable:', event);
    this.periodoMes = event.month;
    this.periodoAnio = event.year;
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
}


