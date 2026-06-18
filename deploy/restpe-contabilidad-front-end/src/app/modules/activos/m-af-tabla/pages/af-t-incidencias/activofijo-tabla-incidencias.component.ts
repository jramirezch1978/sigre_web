import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

import { IncidenciaFacade } from 'src/app/modules/activos/application/facades/incidencia.facade';
import { IncidenciaFeedbackEffects } from 'src/app/modules/activos/effects/incidencia-feedback.effect';
import { IncidenciaEntity } from 'src/app/modules/activos/domain/models/incidencia.entity';
import { SimulationService } from 'src/app/simulation/simulation.service';

@Component({
  selector: 'app-activofijo-tabla-incidencias',
  templateUrl: './activofijo-tabla-incidencias.component.html',
  styleUrls: ['./activofijo-tabla-incidencias.component.scss'],
  standalone: false,
})
export class ActivofijoTablaIncidenciasComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // ── Facade & Store ──────────────────────────────────────────────────────────
  private readonly incidenciaFacade    = inject(IncidenciaFacade);
  private readonly feedbackEffects     = inject(IncidenciaFeedbackEffects);
  readonly isLoading                   = this.incidenciaFacade.isLoading;

  // ── Icons ───────────────────────────────────────────────────────────────────
  farBook        = faBook;
  farSearch      = faSearch;
  fasAngleDown   = faAngleDown;
  fasCirclePlus  = faCirclePlus;
  fasDownload    = faDownload;
  fasRotateRight = faRotateRight;

  // ── Grid ─────────────────────────────────────────────────────────────────────
  gridApi!: GridApi;

  // ── Estado local ─────────────────────────────────────────────────────────────
  camponuevo: boolean = true;
  estadoSeleccionado: string = 'todos';
  IncidenciasForm!: FormGroup;
  filaSeleccionada: IncidenciaEntity | null = null;

  // ── Datos auxiliares ─────────────────────────────────────────────────────────
  rowData: IncidenciaEntity[] = [];

  cuentasContables: {id:string, nombre:string}[] = [];
  todasLasCuentas: any[] = [];

  tipoImpacto = [
    'Físico',
    'Contable',
    'Ubicación'
  ]
  gravedad = [
    'Leve',
    'Moderada',
    'Crítica',
  ]
  estados = [
    'Activo',
    'Inactivo'
  ]


  columnTypes = {
    currency: { width: 150 },
    shaded:   { cellClass: 'shaded-class' },
  };
  defaultColDef = {
    resizable: true,
    flex: 1,
    minWidth: 100,
  };

  colDefs: ColDef<IncidenciaEntity>[] = [
    { field: 'incidencia_codigo',       headerName: 'Código',          headerClass: 'ag-header-hover ag-header-10px', flex: 0.8, minWidth: 80 },
    { field: 'incidencia_descripcion',  headerName: 'Descripción',     headerClass: 'ag-header-hover ag-header-10px', flex: 2,   minWidth: 150 },
    { field: 'incidencia_tipo_impacto', headerName: 'Tipo de Impacto', headerClass: 'ag-header-hover ag-header-10px', flex: 1,   minWidth: 100 },
    {
      field: 'incidencia_gravedad', headerName: 'Gravedad',
      headerClass: 'centrarencabezado', flex: 0.9, minWidth: 90,
      cellRenderer: (params: any) => {
        const gravedad = params.value;
        let gravedadClass = '';
        switch (gravedad) {
          case 'Leve':     gravedadClass = 'text-green-600 bg-green-100';  break;
          case 'Moderada': gravedadClass = 'text-[#F2A626] bg-[#FFF0BF]'; break;
          case 'Grave':    gravedadClass = 'text-warning bg-warning-10';   break;
          case 'Crítica':  gravedadClass = 'text-red-600 bg-red-100';      break;
          default:         gravedadClass = 'text-gray-600 bg-gray-100';    break;
        }
        return `<span class="badge-table ${gravedadClass}">${gravedad}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    },
    {
      field: 'incidencia_cta_contable', headerName: 'Cuenta Contable',
      headerClass: 'ag-header-hover ag-header-10px', flex: 1.2, minWidth: 110,
      cellRenderer: (params: any) => {
        const v = params.value;
        return `<span>${v === '' || v == null ? 'N/A' : v}</span>`;
      },
    },
    {
      field: 'incidencia_estado', headerName: 'Estado',
      headerClass: 'centrarencabezado', filter: true, flex: 0.8, minWidth: 80,
      cellRenderer: (params: any) => {
        const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    },
  ];

  constructor(
    private formBuilder: FormBuilder,
    private toastservice: ToastService,
    private modalController: ModalController,
    private formValidationService: FormValidationService,
    private simulation: SimulationService,
  ) {
    // Sincronizar store → rowData (Signal effect)
    effect(() => {
      const items = this.incidenciaFacade.incidencias();
      this.rowData = items;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', items);
      }
    });
  }

  ngOnInit() {
    this.todasLasCuentas = this.simulation.list('plancontable') || [];
    this.cuentasContables = this.todasLasCuentas.map((item) => ({
      id: item.codigo,
      nombre: `${item.codigo} - ${item.descripcion}`,
    }));

    this.IncidenciasForm = this.formBuilder.group({
      search:        new FormControl(''),
      filtroEstado:  new FormControl('todos'),
      codigo:        new FormControl('', [Validators.required]),
      descripcion:   new FormControl('', [Validators.required]),
      tipoImpacto:   new FormControl('Físico',   [Validators.required]),
      gravedad:      new FormControl('Moderada', [Validators.required]),
      ctaContable:   new FormControl('',         [Validators.required]),
      requiereAval:  new FormControl(false),
      estado:        new FormControl('Activo',   [Validators.required]),
      observaciones: new FormControl(''),
    });

    // Inicializar servicio de validación de formularios
    this.formValidationService.inicializarFormulario(this.IncidenciasForm);

    // Cargar lista desde el repositorio
    this.incidenciaFacade.cargarIncidencias();

    // Inicializar en modo creación con código automático
    setTimeout(() => {
      const nuevoCodigo = this.generarNuevoCodigo();
      this.IncidenciasForm.patchValue({ codigo: nuevoCodigo });
      this.formValidationService.resetearEstado();
    }, 0);
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
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
    if (!event.data) return;
    
    // Validar cambios antes de cambiar de incidencia
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló, deseleccionar todo primero
      if (this.gridApi) {
        this.gridApi.deselectAll();
        // Volver a seleccionar la fila anterior si existía
        if (this.filaSeleccionada) {
          this.gridApi.forEachNode((node) => {
            if (node.data === this.filaSeleccionada) {
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
    this.cargarDatosRegistro(event.data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: IncidenciaEntity, node?: any): void {
    this.camponuevo = false;
    this.filaSeleccionada = data;

    if (node && !node.isSelected()) {
      node.setSelected(true);
    }

    this.IncidenciasForm.patchValue({
      codigo:        data.incidencia_codigo        || '',
      descripcion:   data.incidencia_descripcion   || '',
      tipoImpacto:   data.incidencia_tipo_impacto  || '',
      gravedad:      data.incidencia_gravedad       || '',
      ctaContable:   data.incidencia_cta_contable  || '',
      requiereAval:  data.incidencia_requiere_aval ?? false,
      estado:        data.incidencia_estado        || '',
      observaciones: data.incidencia_observaciones || '',
    });

    this.formValidationService.resetearEstado();
  }
  async botonNuevaIncidencia() {
    // Validar cambios antes de limpiar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    this.camponuevo = true;
    this.filaSeleccionada = null; // Limpiar la fila seleccionada
    this.gridApi?.deselectAll(); // Deseleccionar filas en la tabla
    this.IncidenciasForm.reset();
    
    // Generar código automático
    const nuevoCodigo = this.generarNuevoCodigo();
    
    // Solo establecer valores por defecto
    this.IncidenciasForm.patchValue({
      codigo: nuevoCodigo,
      estado: 'Activo',
      tipoImpacto: 'Físico',
      gravedad: 'Moderada',
      requiereAval: false
    });
    
    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }

  // Método para manejar la selección de cuenta contable
  onCuentaSelected(cuenta: any) {
    this.IncidenciasForm.patchValue({
      ctaContable: cuenta.codigo
    });
  }

  botonGuardar() {
    if (!this.validarCamposObligatorios()) {
      this.toastservice.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    if (!this.camponuevo && !this.filaSeleccionada) {
      this.toastservice.danger('No hay registro seleccionado para editar.');
      return;
    }

    const formValues = this.IncidenciasForm.value;

    const codigo = this.camponuevo
      ? this.generarNuevoCodigo()
      : this.filaSeleccionada!.incidencia_codigo;

    const registro: IncidenciaEntity = {
      incidencia_codigo:        codigo,
      incidencia_descripcion:   formValues.descripcion,
      incidencia_tipo_impacto:  formValues.tipoImpacto,
      incidencia_gravedad:      formValues.gravedad,
      incidencia_cta_contable:  formValues.ctaContable,
      incidencia_requiere_aval: formValues.requiereAval ?? false,
      incidencia_estado:        formValues.estado,
      incidencia_observaciones: formValues.observaciones,
    };

    if (this.camponuevo) {
      this.incidenciaFacade.guardarIncidencia(registro);
    } else {
      this.incidenciaFacade.actualizarIncidencia(registro);
    }

    // Reset form a modo creación
    const nuevoCodigo = this.generarNuevoCodigo();
    this.IncidenciasForm.reset({
      codigo:       nuevoCodigo,
      tipoImpacto:  'Físico',
      gravedad:     'Moderada',
      estado:       'Activo',
      requiereAval: false,
    });

    this.filaSeleccionada = null;
    this.camponuevo = true;
    this.formValidationService.resetearEstado();
  }

  // Generar código automático para nuevas incidencias
  generarNuevoCodigo(): string {
    const lista = this.incidenciaFacade.incidencias() || [];

    const nums = lista.map((item: IncidenciaEntity) => {
      const match = item.incidencia_codigo.match(/IN-AF-(\d+)/);
      return match ? parseInt(match[1], 10) : 0;
    });

    const max = Math.max(...nums, 0);
    return `IN-AF-${(max + 1).toString().padStart(3, '0')}`;
  }

  validarCamposObligatorios(): boolean {
    const formValues = this.IncidenciasForm.value;
    
    // Campos siempre requeridos
    const camposObligatorios =
      formValues.descripcion &&
      formValues.tipoImpacto &&
      formValues.gravedad &&
      formValues.ctaContable &&
      formValues.estado;
    
    return !!camposObligatorios;
  }

  puedeGuardar(): boolean {
    const formValues = this.IncidenciasForm.value;

    // Campos siempre requeridos (sin código porque se genera automáticamente)
    const camposBasicosCompletos =
      formValues.descripcion &&
      formValues.tipoImpacto &&
      formValues.gravedad &&
      formValues.ctaContable &&
      formValues.estado;

    // Si es modo nuevo, solo validar que los campos estén completos
    if (this.camponuevo) {
      return !!camposBasicosCompletos;
    }

    // Si es modo edición, solo habilitar cuando hay cambios
    return this.formValidationService.tieneModificaciones();
  }
  onBtReset() {
    this.incidenciaFacade.cargarIncidencias();
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
        detalleCambio: 'Registro inicial del tipo de cambio para Dólar'
      },
      {
        fechaHora: '21/11/2025 09:05',
        usuario: 'Carlos Zapata',
        accion: 'Actualización',
        detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385'
      },
      {
        fechaHora: '20/11/2025 08:30',
        usuario: 'Carlos Zapata',
        accion: 'Creación',
        detalleCambio: 'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380'
      },
      {
        fechaHora: '19/11/2025 08:45',
        usuario: 'Carlos Zapata',
        accion: 'Creación',
        detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT'
      }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - Incidencias',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

}
