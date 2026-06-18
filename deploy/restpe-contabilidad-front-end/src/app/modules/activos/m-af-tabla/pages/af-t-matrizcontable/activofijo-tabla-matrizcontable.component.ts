import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import {
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from '@angular/forms';
import { ModalController } from '@ionic/angular';
import {
  ColDef,
  GridApi,
  GridReadyEvent,
} from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

import { MatrizContableFacade } from 'src/app/modules/activos/application/facades/matriz-contable.facade';
import { MatrizContableFeedbackEffects } from 'src/app/modules/activos/effects/matriz-contable-feedback.effect';
import { MatrizContableEntity } from 'src/app/modules/activos/domain/models/matriz-contable.entity';
import { ClasifActivoFacade } from 'src/app/modules/activos/application/facades/clasif-activo.facade';
import { CentroCostoFacade } from 'src/app/modules/contabilidad/application/facades/plan-centro-costos.facade';

@Component({
  selector: 'app-activofijo-tabla-matrizcontable',
  templateUrl: './activofijo-tabla-matrizcontable.component.html',
  styleUrls: ['./activofijo-tabla-matrizcontable.component.scss'],
  standalone: false,
})
export class ActivofijoTablaMatrizcontableComponent
  implements OnInit, OnDestroy, CanComponentDeactivate
{
  // ── Facade & Store ──────────────────────────────────────────────────────────
  private readonly matrizFacade        = inject(MatrizContableFacade);
  private readonly feedbackEffects     = inject(MatrizContableFeedbackEffects);
  private readonly clasifActivoFacade  = inject(ClasifActivoFacade);
  private readonly centroCostoFacade   = inject(CentroCostoFacade);
  readonly isLoading                   = this.matrizFacade.isLoading;

  // ── Icons ───────────────────────────────────────────────────────────────────
  farBook        = faBook;
  farSearch      = faSearch;
  fasAngleDown   = faAngleDown;
  fasCirclePlus  = faCirclePlus;
  fasDownload    = faDownload;
  fasRotateRight = faRotateRight;


  startDate: Date | undefined;
  endDate: Date | undefined;
  selectedDate: Date | undefined;

  gridApi!: GridApi;
  camponuevo: boolean = true;
  estadoSeleccionado: string = 'todos';
  ConfiguracionForm!: FormGroup;
  filaSeleccionada: MatrizContableEntity | null = null;

  rowData: MatrizContableEntity[] = [];

  columnTypes = {
    currency: {
      width: 150,
    },
    shaded: {
      cellClass: 'shaded-class',
    },
  };
  defaultColDef = {
    resizable: true,
    flex: 1,
    minWidth: 100,
  };

  costo: any[] = [];

  subclases: any[] = [];

  colDefs: ColDef<MatrizContableEntity>[] = [
    { field: 'matriz_contable_codigo',           headerName: 'Código Subclase',               headerClass: 'ag-header-hover ag-header-10px', width: 100 },
    { field: 'matriz_contable_nombre',           headerName: 'Nombre Subclase',               headerClass: 'ag-header-hover ag-header-10px', width: 150 },
    { field: 'matriz_contable_cta_activo',       headerName: 'Cuenta Activo Fijo',            headerClass: 'ag-header-hover ag-header-10px', width: 120 },
    { field: 'matriz_contable_cta_depreciacion', headerName: 'Cuenta Depreciación Acumulada', headerClass: 'ag-header-hover ag-header-10px', width: 200 },
    { field: 'matriz_contable_cta_gasto',        headerName: 'Cuenta Gasto Depreciación',     headerClass: 'ag-header-hover ag-header-10px', width: 160 },
    { field: 'matriz_contable_centro_costo',     headerName: 'Centro de Costo',               headerClass: 'ag-header-hover ag-header-10px', width: 100 },
    {
      field: 'matriz_contable_estado', filter: true, headerClass: 'centrarencabezado', headerName: 'Estado',
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
    private toastservice: ToastService,
    private modalController: ModalController,
    private formValidationService: FormValidationService,
  ) {
    // Sincronizar store → rowData (Signal effect)
    effect(() => {
      const items = this.matrizFacade.matrizContable();
      this.rowData = items;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', items);
      }
    });

    // Sincronizar subclases desde clasificación de activos
    effect(() => {
      const clasifs = this.clasifActivoFacade.clasifsActivo();
      this.subclases = clasifs
        .filter(item => item.orgHierarchy && item.orgHierarchy.length > 1)
        .map(item => ({
          id: item.clasif_activo_codigo,
          codigo: item.clasif_activo_codigo,
          nombre: `${item.clasif_activo_codigo} - ${item.clasif_activo_nombre}`,
          nombreSubclase: item.clasif_activo_nombre,
        }));
    });

    // Sincronizar centros de costo
    effect(() => {
      const centros = this.centroCostoFacade.centrosCosto();
      this.costo = centros.map(c => ({
        id: c.centro_costo_codigo,
        codigo: c.centro_costo_codigo,
        nombre: `${c.centro_costo_codigo} - ${c.centro_costo_nombre}`,
        nombreCentro: c.centro_costo_nombre,
      }));
    });
  }

  ngOnInit() {
    this.ConfiguracionForm = this.formBuilder.group({
      search: new FormControl(''),
      filtroEstado: new FormControl('todos'),
      codigo: new FormControl('', [Validators.required]),
      nombre: new FormControl('', [Validators.required]),
      cuentaAct: new FormControl('', [Validators.required]),
      cuentaDep: new FormControl('', [Validators.required]),
      cuentaGasto: new FormControl('', [Validators.required]),
      centroCosto: new FormControl('', [Validators.required]),
      venta: new FormControl('', [Validators.required]),
      acumulado: new FormControl('', [Validators.required]),
      fechaVigencia: new FormControl('', [Validators.required]),
      estado: new FormControl('Activo', [Validators.required]),
      observaciones: new FormControl(''),
    });

    const today = new Date();
    this.startDate = new Date(today.getFullYear(), today.getMonth(), 1);
    this.endDate = today;

    // Inicializar servicio de validación de formularios
    this.formValidationService.inicializarFormulario(this.ConfiguracionForm);
    this.formValidationService.resetearEstado();

    // Cargar lista desde el repositorio
    this.matrizFacade.cargarMatrizContable();

    // Cargar clasificación de activos para llenar subclases
    this.clasifActivoFacade.cargarClasifActivos();

    // Cargar centros de costo
    this.centroCostoFacade.cargarCentrosCosto();
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  // Implementación del guard CanDeactivate
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  onBtReset() {
    this.matrizFacade.cargarMatrizContable();
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

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    
    // Iniciar en modo creación (formulario vacío)
    // No seleccionar ninguna fila automáticamente
  }

  onSubClaseSeleccionada(subclase: any) {
    this.ConfiguracionForm.patchValue({
      codigo: subclase.codigo,
      nombre: subclase.nombreSubclase,
    });
  }


  async onCellClicked(event: any) {
    const data = event.data;

    event.node.setSelected(true);

    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      if (this.filaSeleccionada) {
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
            if (node.data?.matriz_contable_codigo === this.filaSeleccionada!.matriz_contable_codigo) {
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

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: MatrizContableEntity, node?: any): void {
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

    this.ConfiguracionForm.patchValue({
      codigo: data.matriz_contable_codigo || '',
      nombre: data.matriz_contable_nombre || '',
      cuentaAct: data.matriz_contable_cta_activo || '',
      cuentaDep: data.matriz_contable_cta_depreciacion || '',
      cuentaGasto: data.matriz_contable_cta_gasto || '',
      centroCosto: data.matriz_contable_centro_costo || '',
      venta: data.matriz_contable_venta || '',
      acumulado: data.matriz_contable_acumulado || '',
      fechaVigencia: data.matriz_contable_fecha_vigencia || '',
      estado: data.matriz_contable_estado || '',
      observaciones: data.matriz_contable_observaciones || '',
    });

    // Actualizar fecha para el calendario
    if (data.matriz_contable_fecha_vigencia) {
      const partes = data.matriz_contable_fecha_vigencia.split('/');
      if (partes.length === 3) {
        this.selectedDate = new Date(+partes[2], +partes[1] - 1, +partes[0]);
      }
    } else {
      this.selectedDate = undefined;
    }

    this.formValidationService.resetearEstado();
  }
  async botonNuevaConfiguracion() {
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) return;

    this.camponuevo = true;
    this.filaSeleccionada = null;
    this.gridApi?.deselectAll();
    this.ConfiguracionForm.reset();
    this.ConfiguracionForm.patchValue({ estado: 'Activo' });
    this.selectedDate = undefined;

    this.formValidationService.resetearEstado();
  }

  botonGuardar() {
    if (this.ConfiguracionForm.invalid) {
      this.toastservice.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    const formValues = this.ConfiguracionForm.value;

    const registro: MatrizContableEntity = {
      matriz_contable_codigo: formValues.codigo,
      matriz_contable_nombre: formValues.nombre,
      matriz_contable_cta_activo: formValues.cuentaAct,
      matriz_contable_cta_depreciacion: formValues.cuentaDep,
      matriz_contable_cta_gasto:  formValues.cuentaGasto,
      matriz_contable_centro_costo: formValues.centroCosto,
      matriz_contable_venta:  formValues.venta,
      matriz_contable_acumulado:  formValues.acumulado,
      matriz_contable_fecha_vigencia: formValues.fechaVigencia
        ? (formValues.fechaVigencia instanceof Date
            ? formValues.fechaVigencia.toLocaleDateString()
            : formValues.fechaVigencia)
        : '',
      matriz_contable_estado:           formValues.estado,
      matriz_contable_observaciones:    formValues.observaciones,
    };

    if (this.camponuevo) {
      this.matrizFacade.guardarMatriz(registro);
    } else {
      this.matrizFacade.actualizarMatriz(registro);
    }

    // Reset form a modo creación
    this.ConfiguracionForm.reset({ estado: 'Activo' });
    this.selectedDate = undefined;
    this.filaSeleccionada = null;
    this.camponuevo = true;
    this.formValidationService.resetearEstado();
  }

  // Para modo SINGLE - Manejo de fecha seleccionada
  filtradoUnico(date: Date) {
    console.log('Fecha:', date);
    this.selectedDate = date;
    this.ConfiguracionForm.patchValue({
      fechaVigencia: date,
    });
  }
  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }

  onCostoSeleccionado(costo: any) {
    if (costo) {
      this.ConfiguracionForm.patchValue({
        centroCosto: costo.codigo,
      });
    }
  }

  puedeGuardar(): boolean {
    if (this.camponuevo) {
      return this.ConfiguracionForm.valid;
    }
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
