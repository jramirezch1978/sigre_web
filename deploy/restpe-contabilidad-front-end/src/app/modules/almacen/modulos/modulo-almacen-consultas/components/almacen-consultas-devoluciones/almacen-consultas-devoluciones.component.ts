import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import { Component, OnInit, ViewChild, inject } from '@angular/core';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { ModalController, ViewWillEnter } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ColDef, GridApi, GridReadyEvent, RowSelectionOptions } from 'ag-grid-enterprise';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCheck, faDollar, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { IconProp } from '@fortawesome/fontawesome-svg-core';

// Facade
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';

interface IProductoDevolucion {
  almacen_codigo: string;
  nombre: string;
  cantComprada: number;
  cantDevolver: number;
  medida: string;
}
interface IProveedor {
  id: number;
  nombre: string;
}
interface IFactura {
  id: number;
  nombre: string;
}


@Component({
  selector: 'app-almacen-consultas-devoluciones',
  templateUrl: './almacen-consultas-devoluciones.component.html',
  styleUrls: ['./almacen-consultas-devoluciones.component.scss'],
  standalone: false,
})
export class AlmacenConsultasDevolucionesComponent implements OnInit, ViewWillEnter {
  // Facades
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  protected readonly facade = this.almacenFacade;

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.isLoading;

  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCheck = faCheck;
  fasDollar = faDollar;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  // RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  devolucionFecha: Date | undefined;
  minDate: Date;
  maxDate: Date;
  today: Date = new Date();

  // Estado de la UI
  filaSeleccionada: any = null;
  mostrartabla: boolean = true;
  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'almacen-consultas-devoluciones'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }
  panelLateralVisible: boolean = true;
  monedapais: any ='S/';
  tipoSeleccionado: string = 'devol';


  devolucionForm!: FormGroup;

   tipoFs=[
    { value: 'devol', nombre: 'Devolución'},
    { value: 'registro', nombre: 'Registro'},

  ]

  @ViewChild('autocompleteProductos') autocompleteProductos: any;

    cards = [
      { id: 1, nombre: 'Porcentaje de devoluciones sobre el total de compras', valor: '90%', icono: this.fasCheck },
      { id: 2, nombre: 'Valor total devuelto entre', desde:'01/01/2025', hasta:'31/01/2025' , valor: 'S/999.999.00', icono: this.fasDollar },
    ]

  // Configuración de tabla principal
  colDefs: ColDef[] = [
    { field: 'devolucion_codigo', headerName: 'Código', width: 90, sortable: true,
    },
    { field: 'devolucion_producto', headerName: 'Producto', flex: 1, minWidth: 150, sortable: true,
    },
    { field: 'devolucion_fecha', headerName: 'Fecha devolución', width: 120,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() ).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      } 
    },
     { field: 'devolucion_almacen', headerName: 'Almacén', width: 100, sortable: true, filter: true},
     { field: 'devolucion_medida', headerName: 'Medida', width: 60, sortable: true},
    { field: 'devolucion_tipo_documento', headerName: 'Tipo de documento', width: 120, sortable: true},
    { field: 'devolucion_cantidad', headerName: 'Devolución', width: 100, sortable: true, headerClass: 'derechaencabezado',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `(${formattedValue})`;
          }
          return formattedValue;
        }
        return '';
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'end', };
        if (params.value < 0) {
          style.color = '#EF4444'; // Rojo para negativos
        }
        return style;
      }
    },
    { field: 'devolucion_saldo', headerName: 'Saldo', width: 100, sortable: true, headerClass: 'derechaencabezado',
      valueFormatter: (params: any) => {
        if(params.value !== null && params.value !== undefined) {
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
          return `S/ ${formattedValue}`;
        }
        return '-';
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'end', };
        if (params.value < 0) {
          style.color = '#EF4444'; // Rojo para negativos
        }
        return style;
      }
    },
    { field: 'devolucion_estado', headerName: 'Estado', headerClass: 'centrarencabezado', width: 80, sortable: true, filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Registrado') {
          return `<span class="badge-table bg-[#FFF0BF] text-[#F2A626]">Registrado</span>`;
        } else if (params.value === 'Aprobado') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Aprobado</span>`;
        } else if (params.value === 'Anulado') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulado</span>`;
        }
        return params.value;
      },
      cellStyle: {
        textAlign: 'center',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    },
  ];

  // Configuración de tabla de artículos
  colDefsArticulos: ColDef[] = [
    { headerCheckboxSelection: true, checkboxSelection: true, width: 40, headerName: '', pinned: 'left', headerClass: 'header-checkbox-col', cellClass: 'cell-checkbox-col'},
    { field: 'almacen_codigo', headerName: 'Código', width: 80, sortable: true},
    { field: 'nombre', headerName: 'Nombre de producto', width: 220},
    { field: 'cantComprada', headerName: 'Cant. c.', width: 70, headerClass: 'centrarencabezado', cellClass: 'centrarencabezado',},
    { field: 'cantDevolver', headerName: 'Cant. d.', width: 70, headerClass: 'centrarencabezado', cellClass: 'centrarencabezado', editable: true, cellEditor: 'agNumberCellEditor',
      cellEditorParams: {
        min: 0,
      },
      onCellValueChanged: (event: any) => {
        if (event.newValue > event.data.cantComprada) {
          event.data.cantDevolver = event.data.cantComprada;
          this.gridApiArticulos?.refreshCells({ rowNodes: [event.node] });
        }
        this.actualizarTotales();
      },
    },
    { field: 'medida', headerName: 'Med.', width: 60, headerClass: 'centrarencabezado', cellClass: 'centrarencabezado',},
  ];
    rowSelection: RowSelectionOptions | 'single' | 'multiple' = {
      mode: 'multiRow',
    };

  // Datos de tabla de artículos
  rowDataArticulos: IProductoDevolucion[] = [];
  private gridApiArticulos: GridApi | undefined;

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
    noRowsToShow: 'No hay datos para mostrar',
  };

  // Opciones de búsqueda - se cargan desde localStorage
  proveedores: IProveedor[] = [];

  facturas: IFactura[] = [
    { id: 1, nombre: 'F-2025-00001' },
    { id: 2, nombre: 'F-2025-00002' },
    { id: 3, nombre: 'F-2025-00003' },
  ];

  solicitantes: IFactura[] = [
    { id: 1, nombre: 'F-2025-00001' },

  ];

  // Variables para el formulario de devolución
  proveedorBusqueda: string = '';
  facturaBusqueda: string = '';
  motivoDevolucion: string = '';
  almacenSeleccionado: string = '';
  estadoDevolucion: string = 'Pendiente';
  facturaSeleccionada: string = '';
  productosFactura: IProductoDevolucion[] = [];

  // Totales
  totalProductos: number = 0;
  totalUnidades: number = 0;

  constructor(
    private fb: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );
  }

  ngOnInit() {
    this.catalogosFacade.inicializarCatalogos();
    const fechaActual = `${this.today.getDate().toString().padStart(2, '0')}/${(this.today.getMonth() + 1).toString().padStart(2, '0')}/${this.today.getFullYear()}`;

    this.devolucionForm = this.fb.group({
      almacen_codigo: [''],
      proveedor: [''],
      producto: [''],
      ordenCompra: [''],
      ordenAsociada: [''],
      fechaRegistro: [''],
      unidadMedida: [''],
      tipoDoc: [''],
      cantidadDevolver: [''],
      precioUnitario: [''],
      saldo: [''],
      estado: [''],
      fechaDevolucion: [''],
      almacen: [''],
    });

    this.devolucionForm.get('proveedor')?.disable();
    this.devolucionForm.get('almacen')?.disable();
    this.devolucionForm.get('fechaRegistro')?.disable();
    this.devolucionForm.get('almacen_codigo')?.disable();
    this.devolucionForm.get('producto')?.disable();
    this.devolucionForm.get('')?.disable();
    this.devolucionForm.get('ordenCompra')?.disable();
    this.devolucionForm.get('ordenAsociada')?.disable();
    this.devolucionForm.get('unidadMedida')?.disable();
    this.devolucionForm.get('tipoDoc')?.disable();
    this.devolucionForm.get('cantidadDevolver')?.disable();
    this.devolucionForm.get('precioUnitario')?.disable();
    this.devolucionForm.get('saldo')?.disable();
    this.devolucionForm.get('estado')?.disable();
    this.devolucionForm.get('fechaDevolucion')?.disable();

    // Cargar datos desde localStorage
    this.cargarProveedoresDesdeStorage();
  }

  ionViewWillEnter() {
    this.almacenFacade.cargarConsultaDevoluciones();
  }

  /**
   * Carga los proveedores desde localStorage (key: 'proveedor')
   */
  cargarProveedoresDesdeStorage() {
    const datosGuardados = localStorage.getItem('proveedor');
    if (datosGuardados) {
      try {
        const proveedoresData = JSON.parse(datosGuardados);
        if (Array.isArray(proveedoresData) && proveedoresData.length > 0) {
          this.proveedores = proveedoresData.map((p: any, index: number) => ({
            id: p.id || index + 1,
            nombre: p.razonSocial || p.nombre || p.razon_social || ''
          })).filter((p: IProveedor) => p.nombre);
        }
      } catch (e) {
        console.error('Error al parsear proveedores:', e);
      }
    }

    // Si no hay proveedores, cargar datos de ejemplo
    if (this.proveedores.length === 0) {
      this.proveedores = [
        { id: 1, nombre: 'ABARROTES ANDINOS S.A.' },
        { id: 2, nombre: 'AHORRA MAS GO S.A.' },
        { id: 3, nombre: 'CASTAGNINO PRODUCTS S.A.' },
      ];
    }
  }

  mostrarTabla(valor: boolean) {
    this.mostrartabla = valor;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // Seleccionar la primera fila automáticamente cuando haya datos
    setTimeout(() => {
      const data = this.facade.consultaDevoluciones();
      if (data && data.length > 0) {
        this.gridApi.forEachNode((node: any) => {
          if (node.rowIndex === 0) {
            node.setSelected(true);
            this.filaSeleccionada = node.data;
            this.cargarDatosParaEdicion(node.data);
          }
        });
      }
    }, 100);
  }

  onCellClicked(event: any) {
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    if (!event.data) return;

    this.filaSeleccionada = event.data;
    event.node.setSelected(true);
    
    // Cargar datos en el panel de visualización
    this.cargarDatosParaEdicion(event.data);
  }

  /**
   * Carga los datos de una devolución seleccionada para visualización
   */
  cargarDatosParaEdicion(devolucion: any) {
    // Normalizar campos del JSON (prefijo devolucion_) al modelo del componente
    const normalizado = {
      codigo:           devolucion.devolucion_codigo       || devolucion.almacen_codigo  || '',
      proveedor:        devolucion.devolucion_proveedor    || devolucion.proveedor        || '',
      producto:         devolucion.devolucion_producto     || devolucion.producto         || '',
      almacen:          devolucion.devolucion_almacen      || devolucion.almacen          || '',
      medida:           devolucion.devolucion_medida       || devolucion.medida           || '',
      unidadMedida:     devolucion.devolucion_unidad_medida|| devolucion.unidadMedida     || devolucion.devolucion_medida || '',
      tipoDoc:          devolucion.devolucion_tipo_documento || devolucion.tipoDoc        || '',
      cantidadDevolver: devolucion.devolucion_cantidad_devolver ?? devolucion.devolucion_cantidad ?? devolucion.cantidadDevolver ?? devolucion.devolucion ?? 0,
      precioUnitario:   devolucion.devolucion_precio_unitario  ?? devolucion.devolucion_monto      ?? devolucion.precioUnitario  ?? devolucion.monto ?? 0,
      saldo:            devolucion.devolucion_saldo        ?? devolucion.saldo            ?? 0,
      estado:           devolucion.devolucion_estado       || devolucion.estado           || '',
      fechaDevolucion:  devolucion.devolucion_fecha        || devolucion.fechaDevolucion  || '',
      fechaRegistro:    devolucion.devolucion_fecha_registro || devolucion.fechaRegistro  || '',
      ordenAsociada:    devolucion.devolucion_orden_asociada || devolucion.ordenAsociada  || '',
      ordenCompra:      devolucion.devolucion_guia         || devolucion.guia             || devolucion.ordenCompra || '',
    };

    // Actualizar filaSeleccionada con datos normalizados para el panel derecho
    this.filaSeleccionada = { ...devolucion, ...normalizado };

    // Actualizar devolucionFecha para el campo de fecha de devolución
    if (normalizado.fechaDevolucion) {
      this.devolucionFecha = new Date(normalizado.fechaDevolucion);
    }

    // Actualizar el formulario con los datos de la devolución
    this.devolucionForm.patchValue({
      almacen_codigo:   normalizado.codigo,
      proveedor:        normalizado.proveedor,
      producto:         normalizado.producto,
      almacen:          normalizado.almacen,
      unidadMedida:     normalizado.unidadMedida,
      tipoDoc:          normalizado.tipoDoc,
      estado:           normalizado.estado,
      fechaDevolucion:  normalizado.fechaDevolucion,
      saldo:            normalizado.saldo,
      ordenCompra:      normalizado.ordenCompra,
      ordenAsociada:    normalizado.ordenAsociada,
      cantidadDevolver: normalizado.cantidadDevolver,
      precioUnitario:   normalizado.precioUnitario,
      fechaRegistro:    normalizado.fechaRegistro || new Date().toLocaleDateString('es-PE'),
    });
  }

  formatearFecha(fecha: Date): string {
    const dia = fecha.getDate().toString().padStart(2, '0');
    const mes = (fecha.getMonth() + 1).toString().padStart(2, '0');
    const anio = fecha.getFullYear();
    return `${anio}-${mes}-${dia}`;
  }

  parsearFecha(fechaStr: string): Date {
    const partes = fechaStr.split('-');
    return new Date(
      parseInt(partes[0]),
      parseInt(partes[1]) - 1,
      parseInt(partes[2]),
    );
  }

  onFechaDevolucion(date: Date) {
    this.devolucionFecha = date;
    this.devolucionForm.patchValue({ fechaDevolucion: this.formatearFecha(date) });
  }
  // FUNCIONES DE CREACIÓN ELIMINADAS - SOLO VISUALIZACIÓN
  // async abrirModalAnular() { ... }
  // registrarDevolucion() { ... }
  // nuevoRegistro() { ... }

  private actualizarTotales() {
    this.totalProductos = this.productosFactura.length;
    this.totalUnidades = this.productosFactura.reduce((sum, item) => sum + item.cantDevolver, 0);
  }

  registrarDevolucion() {
    // FUNCIÓN ELIMINADA - SOLO VISUALIZACIÓN
  }

  generarCodigoDevolucion(): string {
    // FUNCIÓN ELIMINADA - SOLO VISUALIZACIÓN
    return '';
  }

  nuevoRegistro() {
    // FUNCIÓN ELIMINADA - SOLO VISUALIZACIÓN
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    this.cargarDatos(range.start, range.end);
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }

  onBtReset() {
    this.almacenFacade.cargarConsultaDevoluciones();
  }

  onGridReadyArticulos(params: GridReadyEvent) {
    this.gridApiArticulos = params.api;
  }

  onCellClickedArticulo(event: any) {
    // Método para manejar clics en la tabla de artículos
    console.log('Artículo seleccionado:', event.data);
  }
  onProveedorSeleccionado(proveedor: IProveedor) {
    if (!proveedor) return;
    this.proveedorBusqueda = proveedor.nombre;
    // Limpiar factura si cambias de proveedor
    this.facturaSeleccionada = '';
    this.almacenSeleccionado = '';
    this.estadoDevolucion = 'Pendiente';
    this.productosFactura = [];
    this.rowDataArticulos = [];
    this.actualizarTotales();
    console.log('Proveedor seleccionado:', proveedor.nombre);
  }

  onFacturaSeleccionado(factura: IFactura) {
    if (!factura) return;

    // Validar que solo sea la factura F-2025-00001
    if (factura.nombre !== 'F-2025-00001') {
      console.warn('Solo se permite trabajar con la factura F-2025-00001');
      alert('Solo puedes registrar devoluciones para la factura F-2025-00001');
      return;
    }

    this.facturaSeleccionada = factura.nombre;
    this.almacenSeleccionado = 'Almacén Alvarado';

    // Cargar los 3 productos de la factura F-2025-00001
    this.productosFactura = [
      { almacen_codigo: 'PROD-001', nombre: 'Harina de Trigo Nicolini 10KG', cantComprada: 10, cantDevolver: 8, medida: 'UND' },
      { almacen_codigo: 'PROD-002', nombre: 'Leche Gloria 420g', cantComprada: 10, cantDevolver: 8, medida: 'UND' },
      { almacen_codigo: 'PROD-003', nombre: 'Mantequilla Chesumore 100g', cantComprada: 10, cantDevolver: 8, medida: 'UND' }
    ];

    // Actualizar el grid de artículos
    this.rowDataArticulos = [...this.productosFactura];
    if (this.gridApiArticulos) {
      this.gridApiArticulos.setGridOption('rowData', this.rowDataArticulos);
    }
    this.actualizarTotales();
    console.log('Factura F-2025-00001 seleccionada con 3 productos');
  }


  getRowClass = (params: any) => {
    // Método para aplicar estilos a las filas
    return '';
  }

  obtenerdaatosdepais(){
    // Función comentada - se necesitan definir las propiedades: countries, country, moneda
    // this.countries.find(c => {
    //   if(c.almacen_codigo === this.country){
    //     c.monedapais?.find(tip => {
    //       this.moneda = tip.simbolo;
    //     })
    //   }
    // })   
  }
}
