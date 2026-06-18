import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators,} from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { SeguroFacade } from 'src/app/modules/activos/application/facades/seguro.facade';
import { SeguroFeedbackEffects } from 'src/app/modules/activos/effects/seguro-feedback.effect';
import { SeguroSyncEffects } from 'src/app/modules/activos/effects/seguro-sync.effect';
import { SeguroEntity } from 'src/app/modules/activos/domain/models/seguro.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-activofijo-tabla-seguros',
  templateUrl: './activofijo-tabla-seguros.component.html',
  styleUrls: ['./activofijo-tabla-seguros.component.scss'],
  standalone: false,
})
export class ActivofijoTablaSegurosComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  // ── Clean Architecture ───────────────────────────────────────────────────────
  private readonly seguroFacade = inject(SeguroFacade);
  private readonly _feedbackEffects = inject(SeguroFeedbackEffects);
  private readonly _syncEffects = inject(SeguroSyncEffects);
  readonly isLoading = this.seguroFacade.isLoading;

  gridApi!: GridApi;
  camponuevo: boolean = true;
  estadoSeleccionado: string = 'todos';
  SegurosForm!: FormGroup;
  filaSeleccionada: SeguroEntity | null = null;
  tituloform = '';
  rowData: SeguroEntity[] = [];

  columnTypes = {
    currency: { width: 150 },
    shaded:   { cellClass: 'shaded-class' },
  };
  defaultColDef = {
    resizable: true,
    flex: 1,
    minWidth: 100,
  };

  colDefs: ColDef<SeguroEntity>[] = [
    {
      field: 'seguro_codigo',
      headerName: 'Código',
      headerClass: 'ag-header-hover ag-header-10px',
      width: 100,
    },
    {
      field: 'seguro_nombre',
      headerName: 'Nombre de seguro',
      headerClass: 'ag-header-hover ag-header-10px',
      width: 200,
    },
    {
      field: 'seguro_cat_riesgo',
      headerName: 'Categoría de riesgo',
      filter: true,
      headerClass: 'centrarencabezado',
      width: 130,
      cellRenderer: (params: any) => {
        const estado = params.value;
        if (estado === 'Bajo') {
          return `<span class="badge-table bg-[#FFF0BF] text-[#F2A626]">${estado}</span>`;
        } else if (estado === 'Medio') {
          return `<span class="badge-table bg-[#FFDECC] text-[#FF8947]">${estado}</span>`;
        } else {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">${estado}</span>`;
        }
      },
      cellStyle: {
        textAlign: 'center',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    },
    {
      field: 'seguro_cobertura_base',
      headerName: 'Cobertura Base',
      headerClass: 'ag-header-hover ag-header-10px',
      width: 130,
    },
    {
      field: 'seguro_modalidad_pago',
      headerName: 'Modalidad de Pago',
      headerClass: 'ag-header-hover ag-header-10px',
      width: 130,
    },
    {
      field: 'seguro_estado',
      filter: true,
      headerClass: 'centrarencabezado',
      headerName: 'Estado',
      width: 80,
      cellRenderer: (params: any) => {
        const color =
          params.value === 'Activo'
            ? 'bg-[#DCFDE7] text-[#16A34A]'
            : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
      cellStyle: {
        textAlign: 'center',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    },
  ];

  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController,
    private formValidationService: FormValidationService
  ) {
    effect(() => {
      const items = this.seguroFacade.seguros();
      this.rowData = items;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', items);
      }
    });
  }

  ngOnInit() {
    this.SegurosForm = this.formBuilder.group({
      search: new FormControl(''),
      filtroEstado: new FormControl('todos'),
      codigoTipoSeguro: new FormControl('', [Validators.required]),
      nombre: new FormControl('', [Validators.required]),
      descripcion: new FormControl(''),
      categoriaRiesgo: new FormControl('Bajo', [Validators.required]),
      coberturaBase: new FormControl('', [Validators.required]),
      modalidadPago: new FormControl('Anual', [Validators.required]),
      condicionesGenerales: new FormControl(''),
      deducibleEstandar: new FormControl(''),
      vigenciaEstandar: new FormControl(''),
      estado: new FormControl('Activo', [Validators.required]),
      observaciones: new FormControl(''),
    });

    this.formValidationService.inicializarFormulario(this.SegurosForm);
    this.formValidationService.pausarDeteccion();

    this.seguroFacade.cargarSeguros();

    setTimeout(() => {
      const nuevoCodigo = this.generarNuevoCodigo();
      this.SegurosForm.patchValue({ codigoTipoSeguro: nuevoCodigo });
      this.formValidationService.reanudarDeteccion();
    }, 0);
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

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
    loadingOoo: 'Cargando...',
  };

  async onCellClicked(event: any) {
    if (!event.data) return;

    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      if (this.gridApi) {
        this.gridApi.deselectAll();
        if (this.filaSeleccionada) {
          this.gridApi.forEachNode((node) => {
            if (node.data?.seguro_codigo === this.filaSeleccionada!.seguro_codigo) {
              node.setSelected(true);
            }
          });
        }
      }
      return;
    }

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    this.cargarDatosRegistro(event.data, event.node);
  }

  private cargarDatosRegistro(data: SeguroEntity, node?: any): void {
    this.camponuevo = false;
    this.filaSeleccionada = data;

    if (node && !node.isSelected()) {
      node.setSelected(true);
    }

    this.tituloform = data.seguro_codigo;

    this.SegurosForm.patchValue({
      codigoTipoSeguro: data.seguro_codigo || '',
      nombre: data.seguro_nombre || '',
      descripcion: data.seguro_descripcion || '',
      categoriaRiesgo: data.seguro_cat_riesgo || 'Bajo',
      coberturaBase: data.seguro_cobertura_base || '',
      modalidadPago: data.seguro_modalidad_pago || 'Anual',
      condicionesGenerales: data.seguro_condiciones_generales || '',
      deducibleEstandar: data.seguro_deducible_estandar || '',
      vigenciaEstandar: data.seguro_vigencia_estandar || '',
      estado: data.seguro_estado || 'Activo',
      observaciones: data.seguro_observaciones || '',
    });

    this.formValidationService.resetearEstado();
  }

  async botonNuevaOperacion() {
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;

    this.camponuevo = true;
    this.filaSeleccionada = null;
    this.tituloform = '';
    this.gridApi?.deselectAll();
    this.SegurosForm.reset();

    const nuevoCodigo = this.generarNuevoCodigo();
    this.SegurosForm.patchValue({
      codigoTipoSeguro: nuevoCodigo,
      categoriaRiesgo:  'Bajo',
      modalidadPago:    'Anual',
      estado:           'Activo',
    });

    this.formValidationService.resetearEstado();
  }

  botonGuardar() {
    Object.keys(this.SegurosForm.controls).forEach(key => {
      this.SegurosForm.get(key)?.markAsTouched();
    });

    if (this.SegurosForm.invalid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    const v = this.SegurosForm.value;

    const seguro: SeguroEntity = {
      seguro_codigo: this.camponuevo ? this.generarNuevoCodigo() : this.filaSeleccionada!.seguro_codigo,
      seguro_nombre: v.nombre,
      seguro_cat_riesgo: v.categoriaRiesgo,
      seguro_cobertura_base: v.coberturaBase,
      seguro_modalidad_pago: v.modalidadPago,
      seguro_estado: v.estado,
      seguro_descripcion: v.descripcion || '',
      seguro_condiciones_generales: v.condicionesGenerales || '',
      seguro_deducible_estandar: v.deducibleEstandar || '',
      seguro_vigencia_estandar: v.vigenciaEstandar || '',
      seguro_observaciones: v.observaciones || '',
    };

    if (this.camponuevo) {
      this.seguroFacade.guardarSeguro(seguro);
    } else {
      this.seguroFacade.actualizarSeguro(seguro);
    }

    this.SegurosForm.reset();
    const siguienteCodigo = this.generarNuevoCodigo();
    this.SegurosForm.patchValue({
      codigoTipoSeguro: siguienteCodigo,
      categoriaRiesgo:  'Bajo',
      modalidadPago:    'Anual',
      estado:           'Activo',
    });
    this.filaSeleccionada = null;
    this.camponuevo = true;
    this.tituloform = '';

    this.formValidationService.resetearEstado();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  generarNuevoCodigo(): string {
    const numeros = this.rowData.map(item => {
      const match = item.seguro_codigo.match(/TS-(\d+)/);
      return match ? parseInt(match[1], 10) : 0;
    });
    const maxNumero = Math.max(...numeros, 0);
    const nuevoNumero = (maxNumero + 1).toString().padStart(3, '0');
    return `TS-${nuevoNumero}`;
  }

  puedeGuardar(): boolean {
    if (!this.SegurosForm.valid) return false;
    if (this.camponuevo) return true;
    return this.formValidationService.tieneModificaciones();
  }

  onBtReset() {
    this.seguroFacade.cargarSeguros();
  }

  async modalverActualizaciones() {
    const colDefs = [
      { headerName: 'Fecha y hora',       field: 'fechaHora',     width: 150 },
      { headerName: 'Usuario',            field: 'usuario',       width: 120 },
      { headerName: 'Acción',             field: 'accion',        width: 150, wrapText: true, autoHeight: true, cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' } },
      { headerName: 'Detalle del cambio', field: 'detalleCambio', flex: 1,    wrapText: true, autoHeight: true, cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' } },
    ];

    const rowData = [
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación',      detalleCambio: 'Registro inicial del tipo de seguro' },
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de cobertura base' },
      { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación',      detalleCambio: 'Registro de nuevo tipo de seguro' },
      { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación',      detalleCambio: 'Registro inicial del catálogo de seguros' },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - Tipos de Seguro',
        rowData,
        colDefs,
        anchoModal: '700px',
      },
    });

    await modal.present();
  }
}
