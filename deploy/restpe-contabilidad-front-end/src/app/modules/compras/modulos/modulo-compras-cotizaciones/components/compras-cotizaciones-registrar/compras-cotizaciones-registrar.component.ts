import {
  Component,
  OnInit,
  OnDestroy,
  ViewChild,
  inject,
  effect,
} from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { Subject } from 'rxjs';
import { takeUntil } from 'rxjs/operators';
import { HttpClient } from '@angular/common/http';

// Font Awesome Icons
import {
  faBook as farBook,
  faSearch,
} from '@fortawesome/pro-regular-svg-icons';
// import { faBook as farBook } from '@fortawesome/free-regular-svg-icons';
// import { faSearchRegular } from '@fortawesome/free-regular-svg-icons';
// import {
//   faAngleDown,
//   faChevronsLeft,
//   faChevronsRight,
//   faCirclePlus,
//   faEdit,
//   faGear,
//   faRotateRight,
//   faSearch as faSearchSolid,
//   faCalendar
// } from '@fortawesome/free-solid-svg-icons';
import {
  faAngleDown,
  faSearch as faSearchSolid,
  faChevronsLeft,
  faChevronsRight,
  faGear,
  faRotateRight,
  faCirclePlus,
  faEdit,
  faCalendar,
} from '@fortawesome/pro-solid-svg-icons';

import {
  GridApi,
  ColDef,
  GridReadyEvent,
  RowModelType,
} from 'ag-grid-community';
import { CotizacionFacade } from '@modules/compras/application/facades/cotizacion.facade';
import { ProveedorFacade } from '@modules/compras/application/facades/proveedor.facade';
import { CondicionPagoFacade } from '@modules/compras/application/facades/condicion-pago.facade';
import {
  CotizacionEntity,
  LineaCotizacionEntity,
} from '@modules/compras/domain/models/cotizacion.entity';
import { LoaderComponent } from '@ui/loader/loader.component';
import { ProveedorEntity } from '@modules/compras/domain/models/proveedor.entity';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { ToastService } from '@ui/services/toast.service';
import { CountryService } from '@ui/services/countryservice.service';
import { FormValidationService } from '@ui/services/form-validation.service';
import { AccesorioActionsCellComponent } from '@modules/activos/m-af-tabla/pages/af-o-registroactivos/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { AlmacenFacade } from '@modules/almacen/application/facades/almacen.facade';

interface IArticuloCotizacion {
  articulo_codigo: string;
  articulo_cantidad: number;
  articulo_unidad: string;
  articulo_descripcion: string;
  articulo_precio_unitario: number;
  articulo_subtotal: number;
  articulo_descuento: number;
  articulo_total: number;
  plazo_entrega_dias: number;
}

@Component({
  selector: 'app-compras-cotizaciones-registrar',
  templateUrl: './compras-cotizaciones-registrar.component.html',
  styleUrls: ['./compras-cotizaciones-registrar.component.scss'],
  standalone: false,
})
export class ComprasCotizacionesRegistrarComponent
  implements OnInit, OnDestroy
{
  private readonly destroy$ = new Subject<void>();

  // Font Awesome Icons
  farBook = farBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasEdit = faEdit;
  fasGear = faGear;
  fasRotateRight = faRotateRight;
  fasSearch = faSearchSolid;
  fasCalendar = faCalendar;

  // Inyección de Facade y Services
  private readonly cotizacionFacade = inject(CotizacionFacade);
  private readonly proveedorFacade = inject(ProveedorFacade);
  private readonly condicionPagoFacade = inject(CondicionPagoFacade);
  private readonly almacenFacade = inject(AlmacenFacade);

  // Selectores del store para UI reactiva
  readonly cotizaciones = this.cotizacionFacade.cotizaciones;
  readonly articulos = this.almacenFacade.consultaArticulos;
  readonly isLoading = this.cotizacionFacade.loading;
  readonly loadingObtener = this.cotizacionFacade.loadingObtener;
  readonly loadingGuardar = this.cotizacionFacade.loadingGuardar;
  readonly loadingEliminar = this.cotizacionFacade.loadingEliminar;

  @ViewChild('autocompleteProductos') autocompleteProductos: any;

  pais = this.countryService.getCountryCode();
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  rowModelType: RowModelType = 'serverSide';
  estadoSeleccionado: string = 'todos';
  cotizacionSeleccionada: CotizacionEntity | null = null;
  puedeEditarFormulario: boolean = false;
  mostrartabla = true;
  filaSeleccionada: any = null;
  mostrarCamposDeshabilitados: boolean = false;
  modoCreacion: boolean = true;
  esNuevaCotizacion: boolean = true;
  private gridApi!: GridApi;
  private gridApiArticulos!: GridApi;

  CotizacionForm!: FormGroup;
  habilitarcampos: any;
  frameworkComponents = {
    customLoadingOverlay: LoaderComponent,
  };

  gridOptions = {
    frameworkComponents: this.frameworkComponents,
    loadingOverlayComponent: 'customLoadingOverlay',
  };

  // Columnas de la tabla de cotizaciones
  colDefs: ColDef[] = [
    { field: 'id', headerName: 'ID', width: 60 },
    {
      field: 'fecha',
      headerName: 'Fecha',
      flex: 1,
      minWidth: 90,
      valueFormatter: (params) => {
        if (params.value) {
          return new Date(params.value).toLocaleDateString('es-PE');
        }
        return '';
      },
    },
    {
      field: 'proveedor_razon_social',
      headerName: 'Proveedor',
      flex: 2,
      minWidth: 150,
      filter: true,
    },
    {
      field: 'total',
      headerName: 'Total',
      flex: 1,
      minWidth: 80,
      headerClass: 'derechaencabezado',
      valueFormatter: (params) => {
        if (params.value) {
          return (
            'S/ ' +
            new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(params.value)
          );
        }
        return 'S/ 0.00';
      },
      cellStyle: {
        textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'center',
      },
    },
    {
      field: 'moneda_codigo',
      headerName: 'Moneda',
      flex: 0.8,
      minWidth: 60,
    },
    {
      field: 'flag_estado',
      headerName: 'Estado',
      flex: 1,
      minWidth: 100,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';

        switch (estado) {
          case '1':
            badgeClass = 'badge-primary';
            break;
          case 'SELECCIONADA':
            badgeClass = 'badge-success';
            break;
          case 'DESCARTADA':
            badgeClass = 'badge-danger';
            break;
          case '0':
            badgeClass = 'badge-secondary';
            break;
          default:
            badgeClass = 'badge-info';
        }
        const etiqueta =
          estado === '1' ? 'Registrada' : estado === '0' ? 'Anulada' : estado;
        return `<span class="badge-table ${badgeClass}">${etiqueta}</span>`;
      },
      cellStyle: {
        textAlign: 'center',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    },
  ];

  rowData: CotizacionEntity[] = [];
  columnTypes = {
    default: {
      resizable: false,
      sortable: false,
      filter: false,
      floatingFilter: false,
    },
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
    noRowsToShow: 'No hay datos para mostrar',
  };

  // Columnas de artículos en la cotización
  colDefsArticulos: ColDef[] = [
    { field: 'articulo_codigo', headerName: 'Código', flex: 0.8, minWidth: 80 },
    {
      field: 'articulo_descripcion',
      headerName: 'Descripción',
      flex: 2,
      minWidth: 150,
    },
    {
      field: 'articulo_cantidad',
      headerName: 'Cantidad',
      flex: 0.7,
      minWidth: 70,
      cellStyle: {
        textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'center',
        cursor: 'pointer',
      },
    },
    { field: 'articulo_unidad', headerName: 'Unidad', flex: 0.6, minWidth: 60 },
    {
      field: 'articulo_precio_unitario',
      headerName: 'Precio unitario',
      headerClass: 'derechaencabezado',
      flex: 0.9,
      minWidth: 90,
      valueFormatter: (params) => {
        return params.value
          ? 'S/ ' +
              new Intl.NumberFormat('es-PE', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2,
              }).format(params.value)
          : 'S/ 0.00';
      },
      cellStyle: {
        textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'center',
        cursor: 'pointer',
      },
    },
    {
      field: 'articulo_descuento',
      headerName: 'Descuento',
      headerClass: 'derechaencabezado',
      flex: 0.8,
      minWidth: 80,
      valueFormatter: (params) => {
        return params.value
          ? new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(params.value)
          : '0.00';
      },
      cellStyle: {
        textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'center',
        cursor: 'pointer',
      },
    },
    {
      field: 'plazo_entrega_dias',
      headerName: 'Plazo (días)',
      flex: 0.8,
      minWidth: 80,
    },
    {
      field: 'articulo_total',
      headerName: 'Total',
      headerClass: 'derechaencabezado',
      flex: 0.9,
      minWidth: 85,
      valueFormatter: (params) => {
        return params.value
          ? 'S/ ' +
              new Intl.NumberFormat('es-PE', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2,
              }).format(params.value)
          : 'S/ 0.00';
      },
      cellStyle: {
        textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'center',
      },
    },
    {
      field: 'acciones',
      headerName: 'Acciones',
      flex: 0.8,
      minWidth: 80,
      cellRenderer: AccesorioActionsCellComponent,
      cellRendererParams: {
        onDelete: (eliminarData: any) => this.eliminarAccesorio(eliminarData),
      },
      cellStyle: {
        textAlign: 'center',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    },
  ];

  rowDataArticulos: IArticuloCotizacion[] = [];

  // Datos maestros
  proveedores: ProveedorEntity[] = [];
  //   listaArticulos : any[]= [];
  condicionesPago: any[] = [];

  // Productos para autocomplete
  //   productos = [
  //     {
  //       codigo: 'ART-001',
  //       descripcion: 'Aceite de oliva extra virgen 1L',
  //       unidad: 'Litro',
  //       precioUnitario: 25.5,
  //     },
  //     {
  //       codigo: 'ART-002',
  //       descripcion: 'Sal marina fina 1kg',
  //       unidad: 'Kilogramo',
  //       precioUnitario: 8.75,
  //     },
  //     {
  //       codigo: 'ART-003',
  //       descripcion: 'Pimienta negra molida 500g',
  //       unidad: 'Gramo',
  //       precioUnitario: 18.0,
  //     },
  //     {
  //       codigo: 'ART-004',
  //       descripcion: 'Azúcar blanca refinada 1kg',
  //       unidad: 'Kilogramo',
  //       precioUnitario: 12.3,
  //     },
  //     {
  //       codigo: 'ART-005',
  //       descripcion: 'Harina de trigo todo uso 1kg',
  //       unidad: 'Kilogramo',
  //       precioUnitario: 15.0,
  //     },
  //     {
  //       codigo: 'ART-006',
  //       descripcion: 'Arroz extra largo 1kg',
  //       unidad: 'Kilogramo',
  //       precioUnitario: 10.5,
  //     },
  //   ];

  // Totales
  subtotalGeneral: number = 0;
  descuentoGeneral: number = 0;
  totalGeneral: number = 0;

  // Artículo temporal para agregar a la tabla
  articuloTemporal = {
    codigo: '',
    descripcion: '',
    unidad: '',
    cantidad: 1,
    precio: 0,
    descuento: 0,
    plazo: 0,
  };

  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private simulation: SimulationService,
    private countryService: CountryService,
    private formValidationService: FormValidationService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate(),
    );

    // Effect para sincronizar cotizaciones desde el store
    effect(() => {
      const cotizaciones = this.cotizaciones();
      if (cotizaciones.length > 0) {
        this.rowData = cotizaciones;
      }
    });

    // Suscribirse a cambios de proveedores
    effect(() => {
      const proveedores = this.proveedorFacade.proveedores();
      if (proveedores.length > 0) {
        this.proveedores = proveedores;
      }
    });

    // Suscribirse a cambios de condiciones de pago
    effect(() => {
      const condiciones = this.condicionPagoFacade.condicionesPago();
      if (condiciones.length > 0) {
        this.condicionesPago = condiciones;
      }
    });

    // effect(() => {
    //   const articulos = this.almacenFacade.consultaArticulos();
    //   if (articulos.length > 0) {
    //     this.listaArticulos = articulos;
    //   }
    // });
  }

  ngOnInit() {
    // Inicializar formulario
    this.CotizacionForm = this.formBuilder.group({
      proveedor: ['', Validators.required],
      fecha: ['', Validators.required],
      moneda: ['PEN', Validators.required],
      observaciones: [''],
    });

    // Cargar datos desde simulación
    // this.cargarCotizacionesDesdeSimulacion();
    this.cotizacionFacade.cargarCotizaciones();
    this.proveedorFacade.cargarProveedores();
    this.almacenFacade.cargarConsultaArticulos();
    this.condicionPagoFacade.cargarCondicionesPago();
    this.crearNuevaCotizacion();
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onGridReadyArticulos(params: GridReadyEvent) {
    this.gridApiArticulos = params.api;
  }

  async onCellClicked(event: any) {
    if (!event.data) return;

    this.cotizacionSeleccionada = event.data;
    this.modoCreacion = false;
    this.esNuevaCotizacion = false;
    this.filaSeleccionada = event.data;

    if (this.gridApi) {
      this.gridApi.ensureIndexVisible(event.rowIndex);
    }

    event.node.setSelected(true);

    // Llenar formulario con datos de la cotización
    this.CotizacionForm.patchValue(
      {
        proveedor: event.data.proveedor_razon_social,
        fecha: event.data.fecha,
        moneda: event.data.moneda_codigo,
        observaciones: '',
      },
      { emitEvent: false },
    );

    // Cargar artículos de la cotización
    this.rowDataArticulos = (event.data.lineas || []).map(
      (linea: LineaCotizacionEntity) => ({
        articulo_codigo: linea.articulo_codigo,
        articulo_cantidad: linea.cantidad,
        articulo_unidad: 'Unidad',
        articulo_descripcion: linea.articulo_descripcion,
        articulo_precio_unitario: linea.precio_unitario,
        articulo_subtotal: linea.cantidad * linea.precio_unitario,
        articulo_descuento: linea.descuento || 0,
        articulo_total: linea.cantidad * linea.precio_unitario,
        plazo_entrega_dias: linea.plazo_entrega_dias || 0,
      }),
    );

    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
    }

    this.calcularTotales();
    this.puedeEditarFormulario = true;
  }

  mostrarTabla(valor: boolean) {
    this.mostrartabla = valor;
  }

  onBtReset() {
    this.cotizacionFacade.cargarCotizaciones();
  }

  onProveedorSeleccionado(proveedor: any) {
    this.CotizacionForm.patchValue({
      proveedor: proveedor.proveedor_codigo,
    });
  }

  onProductoSeleccionado(producto: any) {
    // Llenar los campos temporales en lugar de agregar directamente
    this.articuloTemporal = {
      codigo: producto.articulo_codigo,
      descripcion: producto.articulo_nombre,
      unidad: producto.articulo_unidad,
      cantidad: 1,
      precio: 0,
      descuento: 0,
      plazo: 0,
    };
    this.toastService.warning(
      'Producto cargado. Edita los valores y haz clic en Agregar',
    );
  }

  agregarArticuloATabla() {
    // Validar que haya un artículo temporal cargado
    if (!this.articuloTemporal.codigo) {
      this.toastService.danger('Selecciona un producto primero');
      return;
    }

    // Validar que no exista ya en la tabla
    const productoExistente = this.rowDataArticulos.find(
      (item) => item.articulo_codigo === this.articuloTemporal.codigo,
    );
    if (productoExistente) {
      this.toastService.warning('El producto ya existe en la tabla');
      return;
    }

    // Validar cantidad
    if (this.articuloTemporal.cantidad <= 0) {
      this.toastService.danger('La cantidad debe ser mayor a 0');
      return;
    }

    // Crear el artículo para agregar a la tabla
    const subtotal =
      this.articuloTemporal.cantidad * this.articuloTemporal.precio;
    const total = subtotal - this.articuloTemporal.descuento;

    const nuevoArticulo: IArticuloCotizacion = {
      articulo_codigo: this.articuloTemporal.codigo,
      articulo_cantidad: this.articuloTemporal.cantidad,
      articulo_descripcion: this.articuloTemporal.descripcion,
      articulo_unidad: this.articuloTemporal.unidad,
      articulo_precio_unitario: this.articuloTemporal.precio,
      articulo_subtotal: subtotal,
      articulo_descuento: this.articuloTemporal.descuento,
      articulo_total: total,
      plazo_entrega_dias: this.articuloTemporal.plazo,
    };

    // Agregar a la tabla
    this.rowDataArticulos = [...this.rowDataArticulos, nuevoArticulo];
    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
    }

    // Limpiar campos temporales
    this.limpiarArticuloTemporal();
    this.actualizarTotales();
    this.toastService.success('Artículo agregado a la tabla');
  }

  limpiarArticuloTemporal() {
    this.articuloTemporal = {
      codigo: '',
      descripcion: '',
      unidad: '',
      cantidad: 1,
      precio: 0,
      descuento: 0,
      plazo: 0,
    };
    if (this.autocompleteProductos) {
      this.autocompleteProductos.clearSelection();
    }
  }

  private actualizarTotales() {
    this.calcularTotales();
  }

  calcularTotales() {
    this.subtotalGeneral = this.rowDataArticulos.reduce(
      (sum, item) => sum + (item.articulo_subtotal || 0),
      0,
    );
    this.descuentoGeneral = this.rowDataArticulos.reduce(
      (sum, item) => sum + (item.articulo_descuento || 0),
      0,
    );
    this.totalGeneral = this.rowDataArticulos.reduce(
      (sum, item) => sum + (item.articulo_total || 0),
      0,
    );
  }

  guardarCotizacion() {
    if (!this.CotizacionForm.valid) {
      this.toastService.danger(
        'Por favor completa todos los campos requeridos',
      );
      return;
    }

    if (this.rowDataArticulos.length === 0) {
      this.toastService.danger('Debe agregar al menos un artículo');
      return;
    }

    const formValue = this.CotizacionForm.value;
    console.log('Valores cotizacion:  ', formValue);
    // return;
    const nuevaCotizacion: Omit<
      CotizacionEntity,
       'proveedor_razon_social' | 'total' | 'flag_estado'
    > = {
      // const nuevaCotizacion: CotizacionEntity = {
    //   proveedorId: formValue.proveedor,
      proveedorId: 1,
      id: this.modoCreacion ? undefined : this.cotizacionSeleccionada?.id,
      fecha: formValue.fecha,
    //   moneda_id: formValue.moneda,
      moneda_id: 1,
      observaciones: formValue.observaciones || undefined,
      lineas: this.rowDataArticulos.map((art,idx) => ({
        // articuloId: art.articulo_codigo,
        articuloId: idx+1,
        cantidad: art.articulo_cantidad,
        precioUnitario: art.articulo_precio_unitario,
        descuento: art.articulo_descuento,
        plazoEntregaDias: art.plazo_entrega_dias,
      })),
    };

    if (this.modoCreacion) {
      this.cotizacionFacade.guardarCotizacion(nuevaCotizacion);
      this.toastService.success('Cotización registrada exitosamente');
    } else {
    //   this.cotizacionFacade.actualizarCotizacion(nuevaCotizacion);
      this.toastService.success('Cotización actualizada exitosamente');
    }

    this.crearNuevaCotizacion();
  }

  crearNuevaCotizacion() {
    this.modoCreacion = true;
    this.esNuevaCotizacion = true;
    this.puedeEditarFormulario = true;
    this.CotizacionForm.reset({
      moneda: 'PEN',
    });
    this.rowDataArticulos = [];
    this.cotizacionSeleccionada = null;
    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', []);
    }
    this.calcularTotales();
  }

  cancelar() {
    this.crearNuevaCotizacion();
    this.toastService.warning('Operación cancelada');
  }

  seleccionarCotizacionGanadora() {
    if (!this.cotizacionSeleccionada) return;
    this.cotizacionFacade.seleccionarCotizacionGanadora(
      this.cotizacionSeleccionada.id!,
    );
    this.toastService.success('Cotización seleccionada como ganadora');
  }

  descartarCotizacion() {
    if (!this.cotizacionSeleccionada) return;
    this.cotizacionFacade.descartarCotizacion(this.cotizacionSeleccionada.id!);
    this.toastService.success('Cotización descartada');
  }

  anularCotizacion() {
    if (!this.cotizacionSeleccionada) return;
    const motivo = 'Anulada por usuario';
    this.cotizacionFacade.anularCotizacion(
      this.cotizacionSeleccionada.id!,
      motivo,
    );
    this.toastService.success('Cotización anulada');
  }

  eliminarAccesorio(data: any) {
    this.rowDataArticulos = this.rowDataArticulos.filter(
      (item) => item.articulo_codigo !== data.articulo_codigo,
    );
    this.calcularTotales();
    if (this.gridApi) {
      this.gridApi.applyTransaction({ remove: [data] });
    }
  }
}
