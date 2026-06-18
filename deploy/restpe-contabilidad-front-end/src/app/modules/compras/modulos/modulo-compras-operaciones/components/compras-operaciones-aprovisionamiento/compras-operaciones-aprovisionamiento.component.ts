import { Component, OnInit, ViewChild, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { de, te } from 'date-fns/locale';
import { AccesorioActionsCellComponent } from 'src/app/modules/activos/m-af-tabla/pages/af-o-registroactivos/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { StockWarningCellComponent } from './cell-renderers/stock-warning-cell/stock-warning-cell.component';
import { CantidadInfoCellComponent } from './cell-renderers/cantidad-info-cell/cantidad-info-cell.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { AprovisionamientoFacade } from '../../../../application/facades/aprovisionamiento.facade';
import { ArticuloPlanEntity, PlanAbastecimientoEntity } from '../../../../domain/models/plan-abastecimiento.entity';
import { AprovisionamientoFeedbackEffects } from '../../../../effects/aprovisionamiento-feedback.effect';
import { AlmacenFacade } from 'src/app/modules/almacen/application/facades/almacen.facade';
import { AlmacenEntity } from 'src/app/modules/almacen/domain/models/almacen.entity';
import { MaestroProductoEntity } from 'src/app/modules/almacen/domain/models/maestro-producto.entity';
import { OrdenCompraDraftTransferService } from '../../../../application/facades/orden-compra-draft-transfer.service';
import { GridExportService } from 'src/app/core/infrastructure/export/grid-export.service';

// Font Awesome Icons
import { faBook, faInfoCircle, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faGear, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-compras-operaciones-aprovisionamiento',
  templateUrl: './compras-operaciones-aprovisionamiento.component.html',
  styleUrls: ['./compras-operaciones-aprovisionamiento.component.scss'],
  standalone: false,
})
export class ComprasOperacionesAprovisionamientoComponent implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farInfoCircle = faInfoCircle;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasGear = faGear;
  fasRotateRight = faRotateRight;

  // Inyección del Facade y Effects
  private readonly aprovisionamientoFacade = inject(AprovisionamientoFacade);
  private readonly feedbackEffects = inject(AprovisionamientoFeedbackEffects);
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly ordenCompraDraftTransfer = inject(OrdenCompraDraftTransferService);
  private readonly gridExport = inject(GridExportService);
  /** Fuente completa de planes (sin filtrar por fecha). */
  private planesFuente: PlanAbastecimientoEntity[] = [];

  // Selectores del store para UI reactiva
  readonly planes = this.aprovisionamientoFacade.planes;
  readonly isLoading = this.aprovisionamientoFacade.loading;
  readonly loadingObtener = this.aprovisionamientoFacade.loadingObtener;
  readonly loadingGuardar = this.aprovisionamientoFacade.loadingGuardar;
  readonly loadingActualizar = this.aprovisionamientoFacade.loadingActualizar;
  readonly loadingEliminar = this.aprovisionamientoFacade.loadingEliminar;

  pais = this.countryService.getCountryCode();
  countries = ALL_COUNTRIES;
  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  filaselccionada: any;
  seleccionarestado: string = 'En revisión';
  botonesguardar: boolean = true; // Debe iniciar en true para modo creación
  //FECHA ÚNICA (SINGLE)
  selectedDate: Date | undefined;
  estadoSeleccionado: string = 'todos';
  mostrartabla = true;
  private gridApi!: GridApi;
  private gridApiArticulos!: GridApi;
  PlanAbastecimientoForm!: FormGroup;

  @ViewChild('autocompleteProductos') autocompleteProductos: any;

  tiposPlan=[
    { id: 'Insumos', nombre: 'Insumos' },
    { id: 'Bebidas', nombre: 'Bebidas'},
    { id: 'Materiales', nombre: 'Materiales'},
    { id: 'Servicios', nombre: 'Servicios'},
  ]

  tipoplan = [
    { value: 'mensual', nombre: 'Mensual' },
    { value: 'semanal', nombre: 'Semanal' },
    { value: 'personalizado', nombre: 'Personalizado' },
  ];
  colDefs: ColDef[] = [
    { field: 'plan_abastecimiento_numero', headerName: 'N° de plan', flex: 1, minWidth: 90,filter: true },
    { field: 'plan_abastecimiento_responsable', headerName: 'Responsable', flex: 1.5, minWidth: 120, filter: true },
    { field: 'plan_abastecimiento_fecha', headerName: 'Fecha', flex: 1, minWidth: 90 },
    { field: 'plan_abastecimiento_periodo', headerName: 'Periodo', flex: 1, minWidth: 90, filter: true  },
    { field: 'plan_abastecimiento_tipo', headerName: 'Tipo de plan', flex: 1, minWidth: 100, filter: true },
    { field: 'plan_abastecimiento_almacen', headerName: 'Almacén', flex: 1.2, minWidth: 110,filter: true },
    { field: 'plan_abastecimiento_numero_items', headerName: 'Nº ítems', flex: 0.8, minWidth: 70,
      headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center' }
     },
    {
      headerClass: 'centrarencabezado',
      field: 'plan_abastecimiento_estado',
      headerName: 'Estado',
      flex: 1,
      minWidth: 90,
      filter: true,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';

        switch (estado) {
          case 'Validado':
            badgeClass = 'bg-green-100 text-green-600';
            break;
          case 'Cerrado':
            badgeClass = 'bg-[#FFF0BF] text-[#F2A626]';
            break;
          default:
            badgeClass = 'bg-[#F5F5F5] text-[#363636]';
        }

        return `<span class="badge-table ${badgeClass}">${estado}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    }
  ];

  // Tabla de planes - Se carga desde el store
  rowData: PlanAbastecimientoEntity[] = [];

  planSeleccionado: PlanAbastecimientoEntity | null = null;
  puedeEditar: boolean = true;
  esNuevoPlan: boolean = true; // true = creando nuevo, false = editando existente
  modoCreacion: boolean = true; // Variable para controlar el modo creación/edición

  columnTypes = {
    default: {
      resizable: false,
      sortable: false,
      filter: false,
      floatingFilter: false,
    }
  };
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

  // Configuración de la tabla de artículos del plan
  colDefsArticulos: ColDef<ArticuloPlanEntity>[] = [
    { field: 'det_plan_abast_codigo', headerName: 'Código', flex: 0.8, minWidth: 70 },
    { field: 'det_plan_abast_descripcion', headerName: 'Descripción', flex: 2, minWidth: 150 },
    { field: 'det_plan_abast_unidad_medida', headerName: 'Unidad de medida', flex: 1, minWidth: 90, },
    {
      field: 'det_plan_abast_stock_actual',
      headerName: 'Stock actual',
      flex: 0.9,
      minWidth: 80,
      headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center' },
      cellRenderer: StockWarningCellComponent
    },
    { field: 'det_plan_abast_chp', headerName: 'CHP', flex: 0.7, width: 60,
      headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center' }
     },
    { field: 'det_plan_abast_demanda_proyectada', headerName: 'Demanda Proyectada', flex: 1, minWidth: 90,
      headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center' }
     },
    { field: 'det_plan_abast_cantidad_sugerida', headerName: 'Cantidad sugerida', flex: 1, minWidth: 90,
      headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center' }
     },
    {
      field: 'det_plan_abast_cantidad_final_planificada',
      headerName: 'Cantidad final planificada',
      flex: 1.1,
      minWidth: 100,
      headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center', cursor: 'pointer' },
      editable: true,
      cellRenderer: CantidadInfoCellComponent
    },
    {
      headerName: 'Acciones',
      flex: 0.8,
      minWidth: 70,
      headerStyle: { textAlign: 'center' },
      cellRenderer: AccesorioActionsCellComponent,
      cellRendererParams: {
        context: {
          componentParent: this
        }
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  // Tabla de artículos del plan - Inicialmente vacía
  rowDataArticulos: ArticuloPlanEntity[] = [];

  totalItems: number = 0;
  totalUnidades: number = 0;

  productos: any[] = [
    // { id: 'ART-001', nombre: 'Aceite de oliva extra virgen 1L', unidadMedida: 'Unidad', stockActual: 150, chp: 200, demandaProyectada: 300 },
    // { id: 'ART-002', nombre: 'Sal marina fina 1kg', unidadMedida: 'Kilogramo', stockActual: 80, chp: 120, demandaProyectada: 200 },
    // { id: 'ART-003', nombre: 'Pimienta negra molida 500g', unidadMedida: 'Unidad', stockActual: 45, chp: 60, demandaProyectada: 100 },
    // { id: 'ART-004', nombre: 'Azúcar blanca refinada 1kg', unidadMedida: 'Kilogramo', stockActual: 200, chp: 250, demandaProyectada: 400 },
    // { id: 'ART-005', nombre: 'Harina de trigo todo uso 1kg', unidadMedida: 'Kilogramo', stockActual: 120, chp: 180, demandaProyectada: 280 },
    // { id: 'ART-006', nombre: 'Arroz extra largo 1kg', unidadMedida: 'Kilogramo', stockActual: 90, chp: 150, demandaProyectada: 250 },
    // { id: 'ART-007', nombre: 'Fideos spaghetti 500g', unidadMedida: 'Unidad', stockActual: 60, chp: 100, demandaProyectada: 180 },
    // { id: 'ART-008', nombre: 'Tomate en conserva 400g', unidadMedida: 'Unidad', stockActual: 40, chp: 80, demandaProyectada: 150 },
    // { id: 'ART-009', nombre: 'Leche evaporada 400ml', unidadMedida: 'Unidad', stockActual: 100, chp: 140, demandaProyectada: 220 },
    // { id: 'ART-010', nombre: 'Atún en aceite 170g', unidadMedida: 'Unidad', stockActual: 70, chp: 110, demandaProyectada: 190 }
  ];

  sucursales: any[] = [
    { value: 'sucursal-piura', nombre: 'Sucursal Piura' },
    { value: 'sucursal-trujillo', nombre: 'Centro de producción' },
    { value: 'sucursal-lima', nombre: 'Sucursal Trujillo' },
    { value: 'centro-produccion', nombre: 'Sucursal sullana' }
  ];

  almacenes: any[] = [];

  constructor(
    private formBuilder: FormBuilder,
    private toastSuccess: ToastService,
    private modalController: ModalController,
    private router: Router,
    private countryService: CountryService,
    private formValidationService: FormValidationService
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Effect para actualizar la tabla cuando cambian los datos del store
    effect(() => {
      const planes = this.planes();
      this.planesFuente = planes;
      this.aplicarFiltroFechas();
    });

    // Effect para mapear almacenes desde el facade
    effect(() => {
      const almacenes = this.almacenFacade.almacenes();
      this.almacenes = almacenes.map((item: AlmacenEntity, index: number) => ({
        id: index + 1,
        nombre: item.almacen_nombre,
        value: item.almacen_nombre,
        codigo: item.almacen_codigo || `ALM-${String(index + 1).padStart(3, '0')}`,
        ...item
      }));
    });

    // Effect para mapear maestro de productos desde el facade
    effect(() => {
      const maestro = this.almacenFacade.maestroProductos();
      this.productos = maestro.map((item: MaestroProductoEntity) => ({
        codigo: item.maestro_producto_codigo,
        descripcion: item.maestro_producto_nombre,
        producto: item.maestro_producto_nombre,
        unidadMedida: item.maestro_producto_medida || 'UND',
        stockActual: 0,
        chp: 0,
        demandaProyectada: 0,
        ...item
      }));
    });
  }

  ngOnInit() {
    // Obtener fecha actual en formato dd/MM/yyyy
    const today = new Date();
    const fechaActual = `${today.getDate().toString().padStart(2, '0')}/${(today.getMonth() + 1).toString().padStart(2, '0')}/${today.getFullYear()}`;

    this.PlanAbastecimientoForm = this.formBuilder.group({
      fechaRegistro: [fechaActual],
      periodoPlan: [''],
      tipoPlan: [[]],
      periodo: ['', Validators.required],
      responsable: [''],
      almacen: ['', Validators.required],
      sucursal: ['', Validators.required],
      proveedor: [''],
      documentoproveedor: ['dni'],
      documentoproveedorinput: [''],
      numeroplan: [''],
      estado: [{value:'En revisión', disabled: true}],
    });
    this.PlanAbastecimientoForm.get('numeroplan')?.disable();
    this.PlanAbastecimientoForm.get('fechaRegistro')?.disable();

    // Inicializar totales
    this.actualizarTotales();

    // Inicializar servicio de validación de formularios
    this.formValidationService.inicializarFormulario(this.PlanAbastecimientoForm);

    // Cargar almacenes via facade
    this.almacenFacade.cargarAlmacenes();
    // Cargar máestro de productos via facade
    this.almacenFacade.cargarMaestroProductos();
    // Cargar planes desde el store (JSON via facade)
    this.cargarPlanesDesdeStore();

    // Establecer estado inicial del formulario como guardado (sin cambios pendientes)
    // Esto evita que el modal de confirmación aparezca al inicio
    this.formValidationService.resetearEstado();
  }


  mostrarTabla(valor: boolean) {
    this.mostrartabla = valor;
  }

  /** Filtro rápido de la lista: busca el texto en todas las columnas visibles. */
  onBuscarLista(event: any): void {
    const valor = (event?.detail?.value ?? event?.target?.value ?? '').toString();
    this.gridApi?.setGridOption('quickFilterText', valor);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  /**
   * Carga planes de abastecimiento desde el store (repositorio JSON)
   */
  cargarPlanesDesdeStore(): void {
    this.aprovisionamientoFacade.cargarPlanes();
  }

  onGridReadyArticulos(params: GridReadyEvent) {
    this.gridApiArticulos = params.api;
  }

  getRowClass = (params: any) => {
    if (params.data && params.data.stockActual < params.data.cantidadSugerida) {
      return 'row-parcial-blink';
    }
    return '';
  };
  async onCellClicked(event: any) {
    if (!event.data) return;

    const data = event.data;

    // Prevenir selección automática
    event.node.setSelected(false);

    // Guardar referencia del elemento que tiene el foco actualmente
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Mantener selección anterior
      if (this.planSeleccionado) {
        setTimeout(() => {
          this.gridApi.forEachNode((node) => {
            if (node.data === this.planSeleccionado) {
              node.setSelected(true);
            }
          });
          // Restaurar foco si es un input
          if (elementoConFoco && (elementoConFoco.tagName === 'INPUT' || elementoConFoco.tagName === 'ION-INPUT')) {
            elementoConFoco.focus();
          }
        }, 0);
      } else {
        this.gridApi.deselectAll();
      }
      return;
    }

    // Usuario confirmó - proceder con la selección
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    event.node.setSelected(true);

    this.planSeleccionado = data;
    this.filaselccionada = data;
    this.esNuevoPlan = false; // Está editando un plan existente
    this.modoCreacion = false;

    console.log('Plan seleccionado:', this.planSeleccionado);

    if (!this.planSeleccionado) return;

    this.seleccionarestado = this.planSeleccionado.plan_abastecimiento_estado;

    // Controlar edición según estado
    if (this.planSeleccionado.plan_abastecimiento_estado === 'Validado' || this.planSeleccionado.plan_abastecimiento_estado === 'Cerrado') {
      this.botonesguardar = false;
      this.puedeEditar = false;
    } else {
      this.botonesguardar = true;
      this.puedeEditar = true;
    }

    // Llenar formulario con datos REALES del plan
    this.PlanAbastecimientoForm.patchValue({
      numeroplan: this.planSeleccionado.plan_abastecimiento_numero,
      fechaRegistro: this.planSeleccionado.plan_abastecimiento_fecha,
      periodo: this.planSeleccionado.plan_abastecimiento_periodo,
      tipoPlan: this.planSeleccionado.plan_abastecimiento_tipo ? this.planSeleccionado.plan_abastecimiento_tipo.split(',') : [],
      almacen: this.planSeleccionado.plan_abastecimiento_almacen,
      responsable: this.planSeleccionado.plan_abastecimiento_responsable,
      estado: this.planSeleccionado.plan_abastecimiento_estado
    });

    // Deshabilitar/Habilitar campos según el estado
    if (this.planSeleccionado.plan_abastecimiento_estado === 'Validado' || this.planSeleccionado.plan_abastecimiento_estado === 'Cerrado') {
      // Deshabilitar todos los campos excepto los que ya están deshabilitados
      this.PlanAbastecimientoForm.get('periodo')?.disable();
      this.PlanAbastecimientoForm.get('tipoPlan')?.disable();
      this.PlanAbastecimientoForm.get('almacen')?.disable();
      this.PlanAbastecimientoForm.get('sucursal')?.disable();
      this.PlanAbastecimientoForm.get('responsable')?.disable();
    } else {
      // Habilitar campos editables cuando está en revisión
      this.PlanAbastecimientoForm.get('periodo')?.enable();
      this.PlanAbastecimientoForm.get('tipoPlan')?.enable();
      this.PlanAbastecimientoForm.get('almacen')?.enable();
      this.PlanAbastecimientoForm.get('sucursal')?.enable();
      this.PlanAbastecimientoForm.get('responsable')?.enable();
    }

    // Cargar artículos REALES del plan guardado
    this.rowDataArticulos = this.planSeleccionado.plan_abastecimiento_articulos || [];
    console.log('Artículos cargados:', this.rowDataArticulos.length);

    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
    }
    this.actualizarTotales();

    // Resetear servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }

  onBtReset() {
      this.cargarPlanesDesdeStore()
  }
  onCellClickedArticulo(event: any) {
    console.log('Artículo seleccionado:', event.data);
  }
  buscarproveedor() {
    const documento = this.PlanAbastecimientoForm.get('documentoproveedorinput')?.value;
    console.log('Buscando proveedor con documento:', documento);
    // Aquí puedes agregar la lógica para buscar el proveedor por documento
  }

  guardar() {
    if (this.PlanAbastecimientoForm.invalid) {
      // Validar y mostrar qué campos faltan
      const camposFaltantes: string[] = [];
      
      const camposRequeridos = [
        { nombre: 'Período', control: 'periodo' },
        { nombre: 'Almacén', control: 'almacen' },
        { nombre: 'Sucursal', control: 'sucursal' }
      ];

      camposRequeridos.forEach(({ nombre, control }) => {
        const campo = this.PlanAbastecimientoForm.get(control);
        if (!campo?.value || campo?.value === '') {
          camposFaltantes.push(nombre);
        }
      });

      const mensaje = camposFaltantes.length > 0 
        ? `Complete los campos: ${camposFaltantes.join(', ')}`
        : 'Complete todos los campos requeridos';
      
      this.toastSuccess.warning(mensaje);
      return;
    }

    const formData = this.PlanAbastecimientoForm.getRawValue();

    if (this.planSeleccionado) {
      // Actualizar plan existente
      const planActualizado: PlanAbastecimientoEntity = {
        ...this.planSeleccionado,
        plan_abastecimiento_periodo: formData.periodo,
        plan_abastecimiento_tipo: Array.isArray(formData.tipoPlan) ? formData.tipoPlan.join(',') : formData.tipoPlan,
        plan_abastecimiento_almacen: formData.almacen,
        plan_abastecimiento_sucursal: formData.sucursal,
        plan_abastecimiento_responsable: formData.responsable || 'Usuario Actual',
        plan_abastecimiento_numero_items: this.totalItems,
        plan_abastecimiento_articulos: this.rowDataArticulos
      };

      this.aprovisionamientoFacade.actualizarPlan(planActualizado);
      console.log(' Plan actualizado via facade');
    } else {
      // Crear nuevo plan
      const planes = this.planes();
      const nuevoNumero = planes.length > 0
        ? Math.max(...planes.map((p: any) => parseInt(p.plan_abastecimiento_numero.split('-')[2]) || 0)) + 1
        : 1;
      const nuevoCodigo = `PA-${new Date().getFullYear()}-${String(nuevoNumero).padStart(3, '0')}`;

      const nuevoPlan: PlanAbastecimientoEntity = {
        plan_abastecimiento_numero: nuevoCodigo,
        plan_abastecimiento_responsable: formData.responsable || 'Usuario Actual',
        plan_abastecimiento_fecha: formData.fechaRegistro,
        plan_abastecimiento_periodo: formData.periodo,
        plan_abastecimiento_tipo: Array.isArray(formData.tipoPlan) ? formData.tipoPlan.join(',') : formData.tipoPlan,
        plan_abastecimiento_almacen: formData.almacen,
        plan_abastecimiento_sucursal: formData.sucursal,
        plan_abastecimiento_numero_items: this.totalItems,
        plan_abastecimiento_estado: 'En revisión',
        plan_abastecimiento_articulos: this.rowDataArticulos
      };

      this.aprovisionamientoFacade.guardarPlan(nuevoPlan);
      console.log(' Nuevo plan guardado via facade');
    }

    // Recargar datos
    this.cargarPlanesDesdeStore();

    // Refrescar tabla
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }

    // Resetear el servicio de validación ANTES de limpiar formulario
    // Esto evita que aparezca el modal de confirmación al llamar a resetearFormularioSinValidacion()
    this.formValidationService.resetearEstado();

    // Limpiar formulario sin mostrar modal de validación
    this.resetearFormularioSinValidacion();
  }

  validarPlan() {
    if (!this.planSeleccionado) {
      this.toastSuccess.warning('Debes seleccionar un plan');
      return;
    }

    if (this.planSeleccionado.plan_abastecimiento_estado !== 'En revisión') {
      this.toastSuccess.warning('Solo se pueden validar planes en revisión');
      return;
    }

    // Actualizar el plan seleccionado con estado Validado via facade
    const planValidado: PlanAbastecimientoEntity = {
      ...this.planSeleccionado!,
      plan_abastecimiento_estado: 'Validado'
    };

    this.aprovisionamientoFacade.actualizarPlan(planValidado);

    // Recargar datos
    this.cargarPlanesDesdeStore();

    // Refrescar tabla
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }

    // Actualizar estado local
    this.seleccionarestado = 'Validado';
    this.botonesguardar = false;
    this.puedeEditar = false;

    this.toastSuccess.success('¡Plan validado exitosamente!');
  }

  onProductoSeleccionado(producto: any) {
    // Verificar si puede editar (solo en estado "En revisión")
    if (!this.puedeEditar) {
      this.toastSuccess.warning('No puedes agregar productos a un plan validado');
      return;
    }

    console.log('Producto seleccionado:', producto);

    // Verificar si el producto ya existe en la tabla
    const productoExistente = this.rowDataArticulos.find(item => item.det_plan_abast_codigo === producto.codigo);
    if (productoExistente) {
      this.toastSuccess.warning('El producto ya está agregado al plan');
      return;
    }

    // Calcular cantidad sugerida (demanda proyectada - stock actual + CHP)
    const cantidadSugerida = Math.max(0, producto.demandaProyectada - producto.stockActual + producto.chp);

    // Crear nuevo artículo para la tabla
    const nuevoArticulo: ArticuloPlanEntity = {
      det_plan_abast_codigo: producto.codigo,
      det_plan_abast_descripcion: producto.descripcion || producto.producto,
      det_plan_abast_unidad_medida: producto.unidadMedida,
      det_plan_abast_stock_actual: producto.stockActual,
      det_plan_abast_chp: producto.chp,
      det_plan_abast_demanda_proyectada: producto.demandaProyectada,
      det_plan_abast_cantidad_sugerida: cantidadSugerida,
      det_plan_abast_cantidad_final_planificada: cantidadSugerida // Inicialmente igual a la cantidad sugerida
    };

    // Agregar el producto a la tabla
    this.rowDataArticulos = [...this.rowDataArticulos, nuevoArticulo];

    // Actualizar la tabla
    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
    }

    // Actualizar totales
    this.actualizarTotales();

    // LIMPIAR el autocomplete después de agregar el producto
    setTimeout(() => {
      if (this.autocompleteProductos) {
        this.autocompleteProductos.clearSelection();
      }
    }, 100);

  }

  private actualizarTotales() {
    this.totalItems = this.rowDataArticulos.length;
    this.totalUnidades = this.rowDataArticulos.reduce((sum, item) => sum + item.det_plan_abast_cantidad_final_planificada, 0);
  }

  eliminarAccesorio(articulo: ArticuloPlanEntity) {
    console.log('Eliminar artículo:', articulo);

    // Filtrar el artículo a eliminar
    this.rowDataArticulos = this.rowDataArticulos.filter(item => item.det_plan_abast_codigo !== articulo.det_plan_abast_codigo);

    // Actualizar la tabla
    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
    }

    // Actualizar totales
    this.actualizarTotales();

    this.toastSuccess.success('Producto eliminado del plan');
  }

  onTipoPlanSelect( tipo:any){
    this.PlanAbastecimientoForm.patchValue({ tipoPlan: tipo });
  }

  onSucursalSeleccionada(sucursal: any) {
    this.PlanAbastecimientoForm.patchValue({ sucursal: sucursal.nombre });
    console.log('Valor del formulario actualizado con sucursal:', this.PlanAbastecimientoForm.value); 
  }

  onAlmacenSeleccionado(almacen: any) {
    console.log('Almacén seleccionado:', almacen);
    this.PlanAbastecimientoForm.patchValue({
      almacen: almacen.nombre
    });
    console.log('Valor del formulario actualizado con almacén:', this.PlanAbastecimientoForm.value);
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    this.aplicarFiltroFechas();
  }

  /** Aplica el filtro de rango de fechas (por fecha del plan) y refresca el grid. */
  aplicarFiltroFechas(): void {
    this.rowData = this.gridExport.filtrarPorRango(
      this.planesFuente,
      (p: any) => p?.['plan_abastecimiento_fecha'],
      this.startDate,
      this.endDate,
    );
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  // Para modo SINGLE - Manejo de fecha seleccionada
  filtradoUnico(date: Date) {
    console.log('Fecha:', date);
    this.selectedDate = date;
  }

  // Manejo del período contable seleccionado
  onPeriodoSeleccionado(evento: { month: number, year: number }) {
    const periodoValue = `${evento.year}${evento.month.toString().padStart(2, '0')}`;
    console.log('Período seleccionado:', periodoValue);
    this.PlanAbastecimientoForm.patchValue({ periodoPlan: periodoValue });
  }

  async confirmarordencompra() {
    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Generar orden de compra',
        subtitulomodal: 'Detalle del plan de abastecimiento',
        detalles: [
          { label: 'Número de plan', value: this.planSeleccionado?.plan_abastecimiento_numero || '' },
          { label: 'Responsable', value: this.planSeleccionado?.plan_abastecimiento_responsable || '' },
          { label: 'Estado', value: this.planSeleccionado?.plan_abastecimiento_estado || '' },
        ],
        textoBotonConfirmar: 'Generar orden',
        colorBotonConfirmar: 'primary',
        botonoutline: 'solid',
        mostrarTextarea: false,

      }
    });
    await modal.present();
    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      this.iragenerarordencompra();
    }
  }

  async iragenerarordencompra() {
    if (!this.planSeleccionado) {
      this.toastSuccess.warning('Debes seleccionar un plan de abastecimiento');
      return;
    }

    if (this.planSeleccionado.plan_abastecimiento_estado !== 'Validado') {
      this.toastSuccess.warning('Solo puedes generar órdenes de compra desde planes validados');
      return;
    }

    // Preparar datos para transferir a la pantalla de órdenes de compra
    const datosParaOrden = {
      planOrigen: this.planSeleccionado.plan_abastecimiento_numero,
      almacen: this.planSeleccionado.plan_abastecimiento_almacen,
      sucursal: (this.planSeleccionado as any).sucursal,
      articulos: this.rowDataArticulos.map(art => ({
        codigo: art.det_plan_abast_codigo,
        descripcion: art.det_plan_abast_descripcion,
        unidad: art.det_plan_abast_unidad_medida,
        unidadMedida: art.det_plan_abast_unidad_medida,
        cantidad: art.det_plan_abast_cantidad_final_planificada,
        precioUnitario: 0,
        subtotal: 0,
        impuestos: 0,
        total: 0
      }))
    };

    this.ordenCompraDraftTransfer.setPendingDraft(datosParaOrden);
    console.log('➡️ Datos del plan transferidos para orden de compra:', datosParaOrden);
    console.log('  Total artículos transferidos:', datosParaOrden.articulos.length);

    // Navegar a órdenes de compra
    this.router.navigate(['/compras/operaciones/ordenes-compra']);
  }

  async nuevoplan() {
    // Validar cambios antes de limpiar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Usuario canceló, mantener el formulario actual
    }

    // Deseleccionar filas
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    this.filaselccionada = null;
    this.planSeleccionado = null;
    this.esNuevoPlan = true; // Está creando un nuevo plan
    this.modoCreacion = true;
    this.botonesguardar = true;
    this.puedeEditar = true;
    this.seleccionarestado = 'En revisión';

    // Limpiar formulario
    const today = new Date();
    const fechaActual = `${today.getDate().toString().padStart(2, '0')}/${(today.getMonth() + 1).toString().padStart(2, '0')}/${today.getFullYear()}`;

    this.PlanAbastecimientoForm.reset();
    this.PlanAbastecimientoForm.patchValue({
      fechaRegistro: fechaActual,
      estado: 'En revisión'
    });

    // Habilitar campos editables para nuevo plan
    this.PlanAbastecimientoForm.get('periodo')?.enable();
    this.PlanAbastecimientoForm.get('tipoPlan')?.enable();
    this.PlanAbastecimientoForm.get('almacen')?.enable();
    this.PlanAbastecimientoForm.get('sucursal')?.enable();
    this.PlanAbastecimientoForm.get('responsable')?.enable();

    // Limpiar la tabla de artículos
    this.rowDataArticulos = [];
    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
    }
    this.actualizarTotales();

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();

    console.log('  Nuevo plan inicializado');
  }

  /**
   * Resetea el formulario a modo creación sin validar cambios
   * Se usa después de guardar exitosamente para evitar modal de confirmación
   */
  private resetearFormularioSinValidacion() {
    // Deseleccionar filas
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    this.planSeleccionado = null;
    this.esNuevoPlan = true;
    this.modoCreacion = true;
    this.botonesguardar = true;
    this.puedeEditar = true;
    this.seleccionarestado = 'En revisión';

    // Limpiar formulario
    const today = new Date();
    const fechaActual = `${today.getDate().toString().padStart(2, '0')}/${(today.getMonth() + 1).toString().padStart(2, '0')}/${today.getFullYear()}`;

    this.PlanAbastecimientoForm.reset();
    this.PlanAbastecimientoForm.patchValue({
      fechaRegistro: fechaActual,
      estado: 'En revisión'
    });

    // Habilitar campos editables para nuevo plan
    this.PlanAbastecimientoForm.get('periodo')?.enable();
    this.PlanAbastecimientoForm.get('tipoPlan')?.enable();
    this.PlanAbastecimientoForm.get('almacen')?.enable();
    this.PlanAbastecimientoForm.get('sucursal')?.enable();
    this.PlanAbastecimientoForm.get('responsable')?.enable();

    // Limpiar la tabla de artículos
    this.rowDataArticulos = [];
    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
    }
    this.actualizarTotales();

    console.log('  Formulario reseteado después de guardar');
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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del plan de abastecimiento'},
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de cantidad sugerida de artículo ART-001'},
      { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Validación', detalleCambio: 'Plan validado y aprobado para ejecución'},
      { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Agregado de 5 artículos al plan' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - Plan de Abastecimiento',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }

}
