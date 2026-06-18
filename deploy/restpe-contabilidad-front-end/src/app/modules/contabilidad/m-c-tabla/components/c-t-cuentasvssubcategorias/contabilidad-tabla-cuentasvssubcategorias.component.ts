import { Component, OnInit, inject, computed, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CuentaVsSubcategoriaFacade } from 'src/app/modules/contabilidad/application/facades/cuenta-vs-subcategoria.facade';
import { CuentaVsSubcategoriaFeedbackEffects } from 'src/app/modules/contabilidad/effects/cuenta-vs-subcategoria-feedback.effect';
import { CuentaVsSubcategoriaSyncEffects } from 'src/app/modules/contabilidad/effects/cuenta-vs-subcategoria-sync.effect';
import { CuentaVsSubcategoriaEntity } from 'src/app/modules/contabilidad/domain/models/cuenta-vs-subcategoria.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCog, faRotateRight } from '@fortawesome/pro-solid-svg-icons';


@Component({
  selector: 'app-contabilidad-tabla-cuentasvssubcategorias',
  templateUrl: './contabilidad-tabla-cuentasvssubcategorias.component.html',
  styleUrls: ['./contabilidad-tabla-cuentasvssubcategorias.component.scss'],
  standalone: false,
})
export class ContabilidadTablaCuentasvssubcategoriasComponent implements OnInit {
  
  //#region Iconos Font Awesome
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCog = faCog;
  fasRotateRight = faRotateRight;

  //#endregion

  //#region Variables para manejo de grilla y formulario
  
  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  fechaVigenciaDesde: Date | undefined;
  fechaVigenciaHasta: Date | undefined;

  relacionForm!: FormGroup;
  private gridApi!: GridApi;
  tabSeleccionado: string = 'identificacion';
  gridContext!: { componentParent: ContabilidadTablaCuentasvssubcategoriasComponent };
  filaSeleccionada: any = null;
  seleccion: any = null;
  archivo: any = null;

  private readonly cuentaFacade = inject(CuentaVsSubcategoriaFacade);
  private readonly feedbackEffects = inject(CuentaVsSubcategoriaFeedbackEffects);
  private readonly syncEffects = inject(CuentaVsSubcategoriaSyncEffects);

  readonly isLoading = computed(() => this.cuentaFacade.isLoading());

  // Arreglos para los selects

  tipoCSelect = [
    { id: 'Gasto / Compra', nombre: 'Gasto / Compra' },
    { id: 'Ingreso / Venta', nombre: 'Ingreso / Venta' },
  ]



  cuentas = [
    { codigo: '16111', nombre: '16111 - Terrenos' },
    { codigo: '16121', nombre: '16121 - Edificaciones' },
    { codigo: '16131', nombre: '16131 - Maquinarias y equipos' },
    { codigo: '16141', nombre: '16141 - Unidades de transporte' },
    { codigo: '16151', nombre: '16151 - Muebles y enseres' },
    { codigo: '16161', nombre: '16161 - Equipos diversos' },
    { codigo: '16171', nombre: '16171 - Herramientas y unidades de reemplazo' },
    { codigo: '65111', nombre: '65111 - Costo neto de enajenación de activos' },
    { codigo: '75111', nombre: '75111 - Enajenación de activos inmovilizados' },
    { codigo: '39111', nombre: '39111 - Depreciación acumulada - Edificaciones' },
    { codigo: '39131', nombre: '39131 - Depreciación acumulada - Maquinarias' },
    { codigo: '39151', nombre: '39151 - Depreciación acumulada - Muebles' }
  ];

  reglasSelect = [
    { id: 'Recargo de consumo', nombre: 'Recargo de consumo' },
    { id: 'Comisiones', nombre: 'Comisiones' },
    { id: 'Diferencia por tipo de cambio', nombre: 'Diferencia por tipo de cambio' },
    { id: 'Otros', nombre: 'Otros' },
  ];

  rubrosSelect = [
    { id: 'Bar', nombre: 'Bar' },
    { id: 'Restaurante', nombre: 'Restaurante' },
    { id: 'Delivery', nombre: 'Delivery' },
    { id: 'Otros', nombre: 'Otros' },
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
  rowData: CuentaVsSubcategoriaEntity[] = [];


  colDefs: ColDef[] = [
    { field: 'cuenta_sub_codigo', headerName: 'Código', width: 80 },
    { field: 'cuenta_sub_subcategoria', headerName: 'Subcategoría', flex: 1 },
    { field: 'cuenta_sub_categoria', headerName: 'Categoría', flex: 1 },
    { field: 'cuenta_sub_tipo_c', headerName: 'Tipo', width: 100, filter: true },
    { field: 'cuenta_sub_cuenta_c', headerName: 'Cuenta contable asociada', width: 120 },
    {
      field: 'cuenta_sub_fecha_m', headerName: 'Última modificación', width: 100,
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
      field: "cuenta_sub_estado", headerName: "Estado", headerClass: 'ag-header-hover ag-header-10px centrarencabezado', filter: true, width: 90,
      cellRenderer: (params: any) => {
        const estado = params.value;
        const estadoClass = estado === 'Vinculado' ? 'text-primary bg-[#D6E6FF]' : 'text-warning bg-warning-10';
        return `<span class="px-2 py-[1px] rounded-full text-xxss font-semibold ${estadoClass}">${estado}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }

    },
  ];

  columnTypes = {};

  //#endregion

  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Sincronizar rowData con el store
    effect(() => {
      this.rowData = this.cuentaFacade.items();
    });

    // Registrar callbacks del feedback
    this.feedbackEffects.registrarCallbacks({
      onActualizarExito: () => this.formValidationService.resetearEstado()
    });
  }

  ngOnInit() {
    // Actualizar formulario para reflejar los campos del HTML
    this.relacionForm = this.formBuilder.group({
      codigo: [''],
      categoria: [{ value: '', disabled: true }],
      subcategoria: [{ value: '', disabled: true }],
      fechaC: [{ value: this.getFechaHoy(), disabled: true }],
      fechaM: [{ value: this.getFechaHoy(), disabled: true }],
      tipoC: [{value: '', disabled: true}, Validators.required],
      cuentaC: [{value: '', disabled: true}, Validators.required],
      cuentaE: [{value: '', disabled: true}],
      cuentaI: [{value: '', disabled: true}],
      regla: [{value: '', disabled: true}, Validators.required],
      rubro: [{value: '', disabled: true}, Validators.required],
      estado: [{ value: 'Por vincular', disabled: true }],
    });

    // Contexto de la grilla (si se usa en cellRenderers u otros)
    this.gridContext = { componentParent: this };

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.relacionForm);

    // Cargar datos desde el repositorio
    this.cuentaFacade.cargarItems();
  }

  //#region Métodos para manejo de grilla y formulario

  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  getFechaHoy(): string {
    return new Date().toISOString().substring(0, 10);
  }

  async onCellClicked(event: any) {
    this.seleccion = event.node;
    const data = event.data;

    // Prevenir selección automática
    event.node.setSelected(false);

    // Guardar referencia del elemento que tiene el foco actualmente
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Mantener selección anterior
      if (this.filaSeleccionada) {
        setTimeout(() => {
          if (this.gridApi) {
            this.gridApi.deselectAll();
            this.gridApi.forEachNode((node) => {
              if (node.data.cuenta_sub_codigo === this.filaSeleccionada.cuenta_sub_codigo) {
                node.setSelected(true);
              }
            });
          }

          // Restaurar el foco al campo que estaba activo
          if (elementoConFoco && elementoConFoco.tagName === 'INPUT') {
            setTimeout(() => {
              elementoConFoco.focus();
            }, 100);
          }
        }, 0);
      } else {
        if (this.gridApi) {
          this.gridApi.deselectAll();
        }
      }
      return;
    }

    // Cargar datos de la relación seleccionada
    this.cargarDatosRelacion(data);
  }

  private cargarDatosRelacion(data: any) {
    this.filaSeleccionada = data;
    if (!this.gridApi) return;

    this.gridApi.deselectAll();

    // Seleccionar el nodo en AG-Grid
    this.gridApi.forEachNode((node) => {
      if (node.data === data) {
        node.setSelected(true);
      }
    });

    this.llenarFormulario(data);

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }


  private llenarFormulario(data: any) {
    if (!data) return;
    this.relacionForm.patchValue({
      codigo: data.cuenta_sub_codigo,
      subcategoria: data.cuenta_sub_subcategoria,
      categoria: data.cuenta_sub_categoria,
      fechaC: data.cuenta_sub_fecha_c,
      fechaM: data.cuenta_sub_fecha_m,
      tipoC: data.cuenta_sub_tipo_c,
      cuentaC: data.cuenta_sub_cuenta_c,
      cuentaE: data.cuenta_sub_cuenta_e,
      cuentaI: data.cuenta_sub_cuenta_i,
      regla: data.cuenta_sub_regla,
      rubro: data.cuenta_sub_rubro,
      estado: data.cuenta_sub_estado,
    });

    if (data.cuenta_sub_fecha_m == '') {
      this.relacionForm.patchValue({
        fechaM: this.getFechaHoy(),
      })
    }

    // Habilitar campos para edición
    this.relacionForm.get('tipoC')?.enable();
    this.relacionForm.get('cuentaC')?.enable();
    this.relacionForm.get('cuentaE')?.enable();
    this.relacionForm.get('cuentaI')?.enable();
    this.relacionForm.get('regla')?.enable();
    this.relacionForm.get('rubro')?.enable();

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  onBtReset() {
    this.cuentaFacade.cargarItems();
  }

  gridOptions = {
    getRowId: (params: any) => params.data.cuenta_sub_codigo
  };

  async botonCancelar() {
    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Cancelar acción
    }
    this.relacionForm.reset({
      fechaC: this.getFechaHoy(),
      fechaM: this.getFechaHoy(),
    });
    this.relacionForm.disable();
    this.filaSeleccionada = null;
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  botonGuardar() {
    if (this.relacionForm.invalid) {
      this.relacionForm.markAllAsTouched();
      this.toastService.warning('Por favor, completa todos los campos requeridos.');
      return;
    }

    if (this.seleccion) {

      const validacion =
        this.relacionForm.get('cuentaC')?.value &&
          this.relacionForm.get('tipoC')?.value &&
          this.relacionForm.get('regla')?.value &&
          this.relacionForm.get('rubro')?.value
          ? 'Vinculado'
          : 'Por vincular';

      const nuevosValores: Partial<CuentaVsSubcategoriaEntity> = {
        cuenta_sub_tipo_c: this.relacionForm.get('tipoC')?.value,
        cuenta_sub_cuenta_c: this.relacionForm.get('cuentaC')?.value,
        cuenta_sub_cuenta_e: this.relacionForm.get('cuentaE')?.value,
        cuenta_sub_cuenta_i: this.relacionForm.get('cuentaI')?.value,
        cuenta_sub_regla: this.relacionForm.get('regla')?.value,
        cuenta_sub_rubro: this.relacionForm.get('rubro')?.value,
        cuenta_sub_fecha_m: this.getFechaHoy(),
        cuenta_sub_estado: validacion
      };

      const entidadActualizada: CuentaVsSubcategoriaEntity = {
        ...this.seleccion.data,
        ...nuevosValores
      };

      // Actualizar visualmente en la grilla y persistir en el facade
      this.seleccion.setData(entidadActualizada);
      this.cuentaFacade.actualizarItem(entidadActualizada);
    }

    this.formValidationService.resetearEstado();
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

  //#endregion

  //#region Modales

  async modalImportar() {
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar categorías',
        descripcionSubir: 'Comparte tu archivo de excel con la información de tus categorías y regístralas automáticamente en la plataforma.',
        buttonName: 'Importar categorías',
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

    const defaultColDefModal: ColDef = {
      wrapText: true,
      autoHeight: true,
    };

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones de subcategoría ${this.filaSeleccionada?.cuenta_sub_codigo || ''}`,
        rowData: rowData,
        colDefs: colDefs,
        defaultColDef: defaultColDefModal,
        anchoModal: '700px',
        altoModal: '300px'
      }
    });

    await modal.present();
  }
  //#endregion
}
