import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { NumActivoFacade } from 'src/app/modules/activos/application/facades/num-activo.facade';
import { NumActivoFeedbackEffects } from 'src/app/modules/activos/effects/num-activo-feedback.effect';
import { NumActivoSyncEffects } from 'src/app/modules/activos/effects/num-activo-sync.effect';
import { NumActivoEntity } from 'src/app/modules/activos/domain/models/num-activo.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';




@Component({
  selector: 'app-activofijo-tabla-numactivos',
  templateUrl: './activofijo-tabla-numactivos.component.html',
  styleUrls: ['./activofijo-tabla-numactivos.component.scss'],
  standalone: false,
})
export class ActivofijoTablaNumactivosComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  private readonly numActivoFacade    = inject(NumActivoFacade);
  private readonly numActivoFeedback  = inject(NumActivoFeedbackEffects);
  private readonly numActivoSync      = inject(NumActivoSyncEffects);
  readonly isLoading                  = this.numActivoFacade.isLoading;

  gridApi!: GridApi;
  camponuevo: boolean = true;
  estadoSeleccionado: string = 'todos'
  SecuenciasForm!: FormGroup;
  filaSeleccionada: NumActivoEntity | null = null;
  rowData: NumActivoEntity[] = [];

  sucursales: string[] = [
    "Sucursal Principal",
    "Sucursal Barranco",
    "Sucursal Lima Norte",
    "Sucursal San Isidro",
    "Sucursal Miraflores",
    "Sucursal Surco"
  ];

  estados: string[] = [
    "Activo", "Inactivo"
  ]

  reinicios: string[] = [
    "Anual", "Mensual", "Manual", "No reiniciar"
  ]

  rellenos: string[] = [
    "Ninguno", "Ceros a la izquierda"
  ]

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


  //  Tipado con la misma interfaz
  colDefs: ColDef<NumActivoEntity>[] = [
    { field: 'num_activo_codigo',   headerName: 'Código',                 headerClass: 'ag-header-hover ag-header-10px', width: 100 },
    { field: 'num_activo_sucursal', headerName: 'Sucursal',               headerClass: 'ag-header-hover ag-header-10px', width: 150 },
    { field: 'num_activo_prefijo',  headerName: 'Prefijo',                headerClass: 'ag-header-hover ag-header-10px', width: 130 },
    { field: 'num_activo_ninicial', headerName: 'N° inicial',             headerClass: 'ag-header-hover ag-header-10px', width: 100 },
    { field: 'num_activo_nactual',  headerName: 'N° actual',              headerClass: 'ag-header-hover ag-header-10px', width: 100 },
    { field: 'num_activo_reinicio', headerName: 'Reinicio de Secuencia',  headerClass: 'ag-header-hover ag-header-10px', width: 150 },
    {
      field: 'num_activo_estado', filter: true,
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
    // Sincronizar store → rowData (Signal effect)
    effect(() => {
      const items = this.numActivoFacade.numActivos();
      this.rowData = items;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', items);
      }
    });
  }

  ngOnInit() {
    this.SecuenciasForm = this.formBuilder.group({
      sucursal: new FormControl('', [Validators.required]),
      prefijo: new FormControl('', [Validators.required]),
      ninicial: new FormControl('', [Validators.required]),
      nactual: new FormControl('', [Validators.required]),
      incremento: new FormControl('', [Validators.required]),
      rango: new FormControl('', [Validators.required]),
      relleno: new FormControl('', [Validators.required]),
      reinicio: new FormControl('', [Validators.required]),
      estado: new FormControl('Activo', [Validators.required]),
      observaciones: new FormControl(''),
    });

    // Inicializar el servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.SecuenciasForm);
    this.numActivoFacade.cargarNumActivos();
  }

  ngOnDestroy(): void {
    this.formValidationService.limpiarFormulario();
  }

  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  onBtReset() {
    this.numActivoFacade.cargarNumActivos();
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

    // Prevenir selección automática de AG-Grid
    event.node.setSelected(true);

    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Mantener selección anterior
      if (this.filaSeleccionada) {
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
            if (node.data.num_activo_codigo === this.filaSeleccionada!.num_activo_codigo) {
              node.setSelected(true);
            }
          });
        }, 0);
      } else {
        this.gridApi.deselectAll();
      }
      return;
    }

    // Cargar datos del registro seleccionado
    this.cargarDatosRegistro(data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: NumActivoEntity, node?: any): void {
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
      sucursal: data.num_activo_sucursal || '',
      prefijo: data.num_activo_prefijo || '',
      ninicial: data.num_activo_ninicial || '',
      nactual: data.num_activo_nactual || '',
      incremento: data.num_activo_incremento || '',
      rango: data.num_activo_rango || '',
      relleno: data.num_activo_formato || '',
      reinicio: data.num_activo_reinicio || '',
      estado: data.num_activo_estado || '',
      observaciones: data.num_activo_observaciones || ''
    });

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

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }
  validarCamposObligatorios(): boolean {
    const formValues = this.SecuenciasForm.value;
    
    // Campos requeridos
    const camposObligatorios =
      formValues.sucursal &&
      formValues.prefijo &&
      formValues.ninicial &&
      formValues.nactual &&
      formValues.incremento &&
      formValues.rango &&
      formValues.relleno &&
      formValues.reinicio &&
      formValues.estado;
    
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
    const entidad: NumActivoEntity = {
      num_activo_codigo: this.camponuevo ? this.generarNuevoCodigo() : this.filaSeleccionada!.num_activo_codigo,
      num_activo_sucursal: formValues.sucursal,
      num_activo_prefijo: formValues.prefijo,
      num_activo_longitud: formValues.longitud || '',
      num_activo_formato: formValues.relleno,
      num_activo_reinicio: formValues.reinicio,
      num_activo_estado: formValues.estado,
      num_activo_ninicial: formValues.ninicial,
      num_activo_nactual: formValues.nactual,
      num_activo_incremento: formValues.incremento,
      num_activo_rango: formValues.rango,
      num_activo_relleno: formValues.relleno,
      num_activo_observaciones: formValues.observaciones || ''
    };

    if (this.camponuevo) {
      this.numActivoFacade.guardarNumActivo(entidad);
    } else if (this.filaSeleccionada) {
      this.numActivoFacade.actualizarNumActivo(entidad);
    }

    // Limpiar formulario y resetear estado
    this.SecuenciasForm.reset();
    this.SecuenciasForm.patchValue({ estado: 'Activo' });
    this.filaSeleccionada = null;
    this.camponuevo = true;
    this.formValidationService.resetearEstado();
  }

  botonReiniciarSecuencia() {
    // 1. Validar que haya una fila seleccionada
    if (!this.filaSeleccionada) {
      return;
    }

    // Generar nuevo código para la secuencia duplicada
    const nuevoCodigo = this.generarNuevoCodigo();

    // Calcular el siguiente número inicial basado en las secuencias existentes con el mismo prefijo
    const prefijo = this.filaSeleccionada.num_activo_prefijo;
    const secuenciasMismoPrefijo = this.rowData.filter(item => item.num_activo_prefijo === prefijo);
    const numerosIniciales = secuenciasMismoPrefijo.map(item => parseInt(item.num_activo_ninicial, 10) || 0);
    const maxNumeroInicial = Math.max(...numerosIniciales, 0);
    const nuevoNumeroInicial = (maxNumeroInicial + 1).toString();

    // Crear objeto duplicado con nuevo código y número inicial incrementado
    const secuenciaDuplicada: NumActivoEntity = {
      num_activo_codigo: nuevoCodigo,
      num_activo_sucursal: this.filaSeleccionada.num_activo_sucursal,
      num_activo_prefijo: this.filaSeleccionada.num_activo_prefijo,
      num_activo_longitud: this.filaSeleccionada.num_activo_longitud,
      num_activo_formato: this.filaSeleccionada.num_activo_formato,
      num_activo_reinicio: this.filaSeleccionada.num_activo_reinicio,
      num_activo_estado: this.filaSeleccionada.num_activo_estado,
      num_activo_ninicial: nuevoNumeroInicial,
      num_activo_nactual: this.filaSeleccionada.num_activo_nactual,
      num_activo_incremento: this.filaSeleccionada.num_activo_incremento,
      num_activo_rango: this.filaSeleccionada.num_activo_rango,
      num_activo_relleno: this.filaSeleccionada.num_activo_relleno,
      num_activo_observaciones: this.filaSeleccionada.num_activo_observaciones || ''
    };

    this.numActivoFacade.guardarNumActivo(secuenciaDuplicada);
    this.toastservice.success("¡Se reinició secuencia correctamente!");
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;

    // Iniciar en modo creación (formulario vacío)
    // No seleccionar ninguna fila automáticamente
  }

  // Generar código automático para nuevas secuencias
  generarNuevoCodigo(): string {
    const numeros = this.rowData.map(item => {
      const match = item.num_activo_codigo.match(/CFG-(\d+)/);
      return match ? parseInt(match[1], 10) : 0;
    });
    const maxNumero = Math.max(...numeros, 0);
    const nuevoNumero = (maxNumero + 1).toString().padStart(3, '0');
    return `CFG-${nuevoNumero}`;
  }

  puedeGuardar(): boolean {
    const formValues = this.SecuenciasForm.value;

    // Campos requeridos según el formulario HTML
    const camposCompletos =
      formValues.sucursal &&
      formValues.prefijo &&
      formValues.ninicial &&
      formValues.nactual &&
      formValues.incremento &&
      formValues.rango &&
      formValues.relleno &&
      formValues.reinicio &&
      formValues.estado;

    // Si es modo nuevo, solo validar que los campos estén completos
    if (this.camponuevo) {
      return !!camposCompletos;
    }

    // Si es modo edición, solo habilitar cuando hay cambios
    return this.formValidationService.tieneModificaciones();
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
      {
        fechaHora: '21/11/2025 09:00',
        usuario: 'Carlos Zapata',
        accion: 'Creación',
        detalleCambio: 'Registro inicial del tipo de cambio para Dólar',
      },
      {
        fechaHora: '21/11/2025 09:05',
        usuario: 'Carlos Zapata',
        accion: 'Actualización',
        detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385',
      },
      {
        fechaHora: '20/11/2025 08:30',
        usuario: 'Carlos Zapata',
        accion: 'Creación',
        detalleCambio:
          'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380',
      },
      {
        fechaHora: '19/11/2025 08:45',
        usuario: 'Carlos Zapata',
        accion: 'Creación',
        detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT',
      },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - Numeradores de activos',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      },
    });

    await modal.present();
  }
}
