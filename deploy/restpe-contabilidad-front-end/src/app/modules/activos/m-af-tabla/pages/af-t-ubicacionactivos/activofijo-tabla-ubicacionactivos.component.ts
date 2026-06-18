import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ToastService } from 'src/app/ui/services/toast.service';
import { IconUbicCellComponent } from './components/icon-ubic-cell/icon-ubic-cell.component';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { UbicacionActivoFacade } from 'src/app/modules/activos/application/facades/ubicacion-activo.facade';
import { UbicacionActivoFeedbackEffects } from 'src/app/modules/activos/effects/ubicacion-activo-feedback.effect';
import { UbicacionActivoSyncEffects } from 'src/app/modules/activos/effects/ubicacion-activo-sync.effect';
import { UbicacionActivoEntity } from 'src/app/modules/activos/domain/models/ubicacion-activo.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faGear, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-activofijo-tabla-ubicacionactivos',
  templateUrl: './activofijo-tabla-ubicacionactivos.component.html',
  styleUrls: ['./activofijo-tabla-ubicacionactivos.component.scss'],
  standalone: false,
})
export class ActivofijoTablaUbicacionactivosComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasGear = faGear;
  fasRotateRight = faRotateRight;

  // ── Clean Architecture ───────────────────────────────────────────────────────
  private readonly ubicacionFacade      = inject(UbicacionActivoFacade);
  private readonly _feedbackEffects     = inject(UbicacionActivoFeedbackEffects);
  private readonly _syncEffects         = inject(UbicacionActivoSyncEffects);
  readonly isLoading                    = this.ubicacionFacade.isLoading;

  camponuevo: boolean = true;
  gridApi!: GridApi;
  UbicacionActivosForm: FormGroup;
  ubicacionSeleccionada: string = 'todos';
  filaSeleccionada: UbicacionActivoEntity | null = null;
  archivo: any;
  ubicacionesFiltradas: any[] = [];
  ubicaciones: any[] = [];
  rowData: UbicacionActivoEntity[] = [];

  columnTypes = {
    currency: { width: 150 },
    shaded:   { cellClass: 'shaded-class' },
  };
  defaultColDef: ColDef = {
    editable: false,
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

  // Configuración para Tree Data
  treeData = true;
  groupDefaultExpanded = 0;

  getDataPath = (data: UbicacionActivoEntity) => {
    return data.ubic_org_hierarchy || [];
  };

  autoGroupColumnDef: ColDef = {
    headerName: 'Codigo',
    minWidth: 150,
    cellRendererParams: {
      suppressCount: true,
      innerRenderer: IconUbicCellComponent,
    },
  };

  nivelesSelect = [
    { id: '01', nombre: '01' },
    { id: '02', nombre: '02' },
    { id: '03', nombre: '03' },
  ];

  responsables = [
    { id: 'RP001', nombre: 'Juan Pérez' },
    { id: 'RP002', nombre: 'María Garcia' },
    { id: 'RP003', nombre: 'Carlos López' },
    { id: 'RP004', nombre: 'Ana Martínez' },
    { id: 'RP005', nombre: 'Sofia Ramírez' },
    { id: 'RP006', nombre: 'Pedro Sanchez' },
    { id: 'RP007', nombre: 'Miguel Torres' },
    { id: 'RP008', nombre: 'Laura Mendoza' },
    { id: 'RP009', nombre: 'Luis Rodríguez' },
    { id: 'RP010', nombre: 'Gabriela Ortíz' },
    { id: 'RP011', nombre: 'Mónica Silva' },
    { id: 'RP012', nombre: 'Roberto Díaz' },
    { id: 'RP013', nombre: 'Roberto Torres' },
    { id: 'RP014', nombre: 'Fernando Castro' },
  ];

  colDefs: ColDef<UbicacionActivoEntity>[] = [
    { field: 'ubic_nombre',          headerName: 'Nombre de ubicación', headerClass: 'ag-header-hover ag-header-10px', width: 125 },
    { field: 'ubic_nivel',           headerName: 'Nivel',               headerClass: 'ag-header-hover ag-header-10px', width: 50 },
    { field: 'ubic_descripcion',     headerName: 'Descripción',         headerClass: 'ag-header-hover ag-header-10px', flex: 1, minWidth: 200 },
    { field: 'ubic_responsable',     headerName: 'Responsable',         headerClass: 'ag-header-hover ag-header-10px', width: 90 },
    {
      field: 'ubic_estado', filter: true,
      headerClass: 'centrarencabezado', headerName: 'Estado', width: 80,
      cellRenderer: (params: any) => {
        const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    },
  ];

  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService,
  ) {
    this.UbicacionActivosForm = this.formBuilder.group({
      niveljerarquico: new FormControl('01', [Validators.required]),
      ubicacionPadre:  new FormControl('', [Validators.required]),
      codUbicacion:    new FormControl('', [Validators.required]),
      nombreUbicacion: new FormControl('', [Validators.required]),
      descripcion:     new FormControl('', [Validators.required]),
      responsable:     new FormControl('', [Validators.required]),
      estado:          new FormControl('Activo', [Validators.required]),
      observaciones:   new FormControl(''),
      codInterno:      new FormControl(''),
    });

    effect(() => {
      const items = this.ubicacionFacade.ubicaciones();
      this.rowData = items;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', items);
      }
      this.inicializarUbicaciones();
    });
  }

  ngOnInit() {
    this.ubicacionFacade.cargarUbicaciones();

    this.inicializarUbicaciones();

    this.UbicacionActivosForm.get('niveljerarquico')?.valueChanges.subscribe(() => {
      this.filtrarUbicacionesPorNivel();
    });

    this.filtrarUbicacionesPorNivel();
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  async onCellClicked(event: any) {
    const data = event.data;

    event.node.setSelected(true);

    const continuar = await this.formValidationService.validarCambios();

    if (!continuar) {
      if (this.filaSeleccionada) {
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
            if (node.data?.ubic_codigo === this.filaSeleccionada!.ubic_codigo) {
              node.setSelected(true);
            }
          });
        }, 0);
      } else {
        this.gridApi.deselectAll();
      }
      return;
    }

    this.cargarDatosRegistro(data, event.node);
  }

  private cargarDatosRegistro(data: UbicacionActivoEntity, node?: any): void {
    this.camponuevo = false;
    this.filaSeleccionada = data;
    this.gridApi.deselectAll();

    if (node) {
      node.setSelected(true);
    } else {
      this.gridApi.forEachNode((n) => {
        if (n.data === data) n.setSelected(true);
      });
    }

    const responsableMatch = this.responsables.find(r => r.nombre === data.ubic_responsable);

    this.UbicacionActivosForm.patchValue({
      codUbicacion:    data.ubic_codigo          || '',
      ubicacionPadre:  data.ubic_ubicacion_padre || '',
      descripcion:     data.ubic_descripcion     || '',
      nombreUbicacion: data.ubic_nombre          || '',
      responsable:     responsableMatch?.id       || '',
      codInterno:      data.ubic_cod_interno     || '',
      niveljerarquico: data.ubic_nivel           || '',
      estado:          data.ubic_estado          || '',
      observaciones:   data.ubic_observaciones   || '',
    }, { emitEvent: false });

    this.UbicacionActivosForm.get('codUbicacion')?.disable();

    this.formValidationService.inicializarFormulario(this.UbicacionActivosForm);
  }

  inicializarUbicaciones() {
    this.ubicaciones = this.rowData.map((item: UbicacionActivoEntity) => ({
      id:              item.ubic_codigo,
      nombre:          `${item.ubic_codigo} - ${item.ubic_nombre}`,
      codigo:          item.ubic_codigo,
      nivel:           Number(item.ubic_nivel),
      ubicacionPadre:  item.ubic_ubicacion_padre,
    }));
  }

  filtrarUbicacionesPorNivel() {
    const nivelSeleccionado = Number(
      this.UbicacionActivosForm.get('niveljerarquico')?.value
    );

    const ctrlPadre = this.UbicacionActivosForm.get('ubicacionPadre');

    if (!nivelSeleccionado || isNaN(nivelSeleccionado) || nivelSeleccionado <= 1) {
      this.ubicacionesFiltradas = [];
      ctrlPadre?.reset();
      ctrlPadre?.disable({ emitEvent: false });
      return;
    }

    ctrlPadre?.enable({ emitEvent: false });

    const nivelPadre = nivelSeleccionado - 1;
    this.ubicacionesFiltradas = this.ubicaciones.filter(u => u.nivel === nivelPadre);
  }

  async botonNuevaUbicacion() {
    const continuar = await this.formValidationService.validarCambios();
    if (!continuar) return;

    this.camponuevo = true;
    this.filaSeleccionada = null;
    this.gridApi?.deselectAll();
    this.UbicacionActivosForm.reset({ niveljerarquico: '01', estado: 'Activo' }, { emitEvent: false });

    this.UbicacionActivosForm.get('codUbicacion')?.enable();
    this.formValidationService.inicializarFormulario(this.UbicacionActivosForm);
  }

  validarCamposObligatorios(): boolean {
    const form = this.UbicacionActivosForm.getRawValue();

    const basicos = form.nombreUbicacion && form.descripcion &&
                    form.responsable && form.niveljerarquico && form.estado && form.codInterno;

    if (!basicos) return false;

    if (form.niveljerarquico !== '01' && !form.ubicacionPadre) return false;

    return true;
  }

  botonGuardar() {
    if (!this.validarCamposObligatorios()) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    const form = this.UbicacionActivosForm.getRawValue();

    const codigo = this.camponuevo
      ? form.codUbicacion
      : this.filaSeleccionada!.ubic_codigo;

    // Construir jerarquía
    let orgHierarchy: string[] = [];

    if (!this.camponuevo) {
      orgHierarchy = [...(this.filaSeleccionada!.ubic_org_hierarchy ?? [])];
    } else {
      if (form.niveljerarquico === '01') {
        orgHierarchy = [codigo];
      } else {
        const padre = this.rowData.find(r => r.ubic_codigo === form.ubicacionPadre);
        orgHierarchy = padre ? [...(padre.ubic_org_hierarchy ?? []), codigo] : [codigo];
      }
    }

    const responsableNombre = this.responsables.find(r => r.id === form.responsable)?.nombre || form.responsable;

    const registro: UbicacionActivoEntity = {
      ubic_codigo:          codigo,
      ubic_nombre:          form.nombreUbicacion,
      ubic_nivel:           form.niveljerarquico,
      ubic_descripcion:     form.descripcion,
      ubic_responsable:     responsableNombre,
      ubic_ubicacion_padre: form.ubicacionPadre || '',
      ubic_estado:          form.estado,
      ubic_cod_interno:     form.codInterno     || '',
      ubic_observaciones:   form.observaciones  || '',
      ubic_org_hierarchy:   orgHierarchy,
    };

    if (this.camponuevo) {
      this.ubicacionFacade.guardarUbicacion(registro);
    } else {
      this.ubicacionFacade.actualizarUbicacion(registro);
    }

    this.UbicacionActivosForm.reset({ niveljerarquico: '01', estado: 'Activo' }, { emitEvent: false });
    this.camponuevo = true;
    this.filaSeleccionada = null;
    this.gridApi?.deselectAll();
    this.UbicacionActivosForm.get('codUbicacion')?.enable();
    this.formValidationService.limpiarFormulario();
  }

  async abrirmodalUbicaciones() {
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar ubicaciones',
        descripcionSubir: 'Comparte tu archivo de excel con la información de tus ubicaciones y regístralos automáticamente en la plataforma.',
        buttonName: 'Importar ubicaciones',
      },
    });
    await modal.present();

    try {
      const result = await modal.onWillDismiss();
      const data = result?.data;
      if (data && data.archivo) {
        this.archivo = data.archivo;
        try {
          const nombre = data.archivo?.name ?? 'archivo';
          this.toastService.success('Archivo subido', nombre, 3000);
        } catch (e) {
          console.warn('ToastService falló', e);
        }
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
    console.log('Importar llamado con:', data);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  generarNuevoCodigo(): string {
    const codigos = this.rowData.map((item: UbicacionActivoEntity) => {
      const match = item.ubic_codigo.match(/PIS-(\d+)/);
      return match ? parseInt(match[1], 10) : 0;
    });
    const maxNumero = Math.max(...codigos, 0);
    const nuevoNumero = (maxNumero + 1).toString().padStart(3, '0');
    return `PIS-${nuevoNumero}`;
  }

  private expandirNodosPadres(orgHierarchy: string[]): void {
    if (!this.gridApi || orgHierarchy.length <= 1) return;

    this.gridApi.forEachNode((node) => {
      if (node.data && node.data.ubic_org_hierarchy) {
        const nodeHierarchy = node.data.ubic_org_hierarchy;
        const isAncestor = nodeHierarchy.length < orgHierarchy.length &&
          nodeHierarchy.every((code: string, index: number) => code === orgHierarchy[index]);
        if (isAncestor) {
          node.setExpanded(true);
        }
      }
    });
  }

  puedeGuardar(): boolean {
    const formValues = this.UbicacionActivosForm.value;
    const camposCompletos =
      formValues.nombreUbicacion &&
      formValues.descripcion &&
      formValues.responsable &&
      formValues.niveljerarquico &&
      formValues.estado;

    if (this.camponuevo) return !!camposCompletos;
    return this.formValidationService.tieneModificaciones();
  }

  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  onBtReset() {
    this.ubicacionFacade.cargarUbicaciones();
  }

  async modalverActualizaciones() {
    const colDefs = [
      { headerName: 'Fecha y hora',       field: 'fechaHora',     width: 150 },
      { headerName: 'Usuario',            field: 'usuario',       width: 120 },
      { headerName: 'Acción',             field: 'accion',        width: 150, wrapText: true, autoHeight: true, cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' } },
      { headerName: 'Detalle del cambio', field: 'detalleCambio', flex: 1,    wrapText: true, autoHeight: true, cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' } },
    ];

    const rowData = [
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación',      detalleCambio: 'Registro inicial de Edificio Central' },
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de responsable en Piso 1' },
      { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación',      detalleCambio: 'Registro de Edificio Anexo' },
      { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación',      detalleCambio: 'Registro de Planta de Producción' },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - Ubicaciones',
        rowData,
        colDefs,
        anchoModal: '700px',
      },
    });

    await modal.present();
  }

  onUbicacionSeleccionada(ubicacion: any) {
    console.log('Ubicación seleccionada:', ubicacion);
  }

  onResponsableSeleccionado(responsable: any) {
    console.log('Responsable seleccionado:', responsable);
  }
}

