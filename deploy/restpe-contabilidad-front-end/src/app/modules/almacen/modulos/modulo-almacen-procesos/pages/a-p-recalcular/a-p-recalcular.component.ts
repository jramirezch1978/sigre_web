import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, FormControl,} from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent, GridState, RowSelectionOptions,} from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChartLine, faChevronsLeft, faChevronsRight, faDisplayChartUpCircleDollar, faDownload, faHandHoldingDollar, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

// Facade
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
import { AlmacenEntity } from '../../../../domain/models/almacen.entity';



@Component({
  selector: 'app-a-p-recalcular',
  templateUrl: './a-p-recalcular.component.html',
  styleUrls: ['./a-p-recalcular.component.scss'],
  standalone: false,
})
export class APRecalcularComponent implements OnInit {
  // Facades
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  
  // Estado de loading local (este componente usa datos hardcodeados)
  isLoading = false;


  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChartLine = faChartLine;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasDisplayChartUpCircleDollar = faDisplayChartUpCircleDollar;
  fasDownload = faDownload;
  fasHandHoldingDollar = faHandHoldingDollar;
  fasRotateRight = faRotateRight;


  mostrartabla: boolean = true;
  recalculoForm!: FormGroup;
  botonesHabilitados: boolean = false;

  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  btnDisabled=false;
  cargando = false;
  recalculando = false;
  filaSeleccionada: any = null;
  filasSeleccionadasCount: number = 0;
  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'a-p-recalcular'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }
  private gridApiDetalle!: GridApi;

  // Variables para las cartas
  stockActualCalculado: number = 0;
  stockRecalculadoCalculado: number = 0;
  diferenciaCalculada: number = 0;

  // Template para cuando no hay datos en la tabla de movimientos
  overlayNoRowsTemplate =
    '<span style="padding: 10px; font-size: 10px; color: #666;">No hay datos para mostrar.</span>';

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
  defaultColDef = {
    valueFormatter: (params: any) => {
      if (params.colDef.checkboxSelection) return params.value;
      return params.value === null ||
        params.value === undefined ||
        params.value === ''
        ? '-'
        : params.value;
    },
  };

  rowData: any[] = [
    { almacen_codigo: 'PR005', descripcion: 'Pollo', almacen: 'Almacen principal', categoria: 'Proteinas', unidadMedida: 'Kilogramos', fechaProceso: '20/12/2025', precioPromedioActual: 18.5, precioPromedioRecalculado: 19.2, diferencia: 0.7, estado: 'Recalculado',},
    { almacen_codigo: 'PR004', descripcion: 'Carne', almacen: 'Almacen centro', categoria: 'Proteinas', unidadMedida: 'Kilogramos', fechaProceso: '20/12/2025', precioPromedioActual: 25.0, precioPromedioRecalculado: 24.5, diferencia: -0.5, estado: 'Recalculado',},
    { almacen_codigo: 'PR003', descripcion: 'Papa amarilla', almacen: 'Almacen sur', categoria: 'Tubérculos', unidadMedida: 'Kilogramos', fechaProceso: '20/12/2025', precioPromedioActual: 3.5, precioPromedioRecalculado: 3.8, diferencia: 0.3, estado: 'Pendiente',},
    { almacen_codigo: 'PR002', descripcion: 'Arroz blanco', almacen: 'Almacen surco', categoria: 'Cereales', unidadMedida: 'Kilogramos', fechaProceso: '20/12/2025', precioPromedioActual: 4.2, precioPromedioRecalculado: 4.2, diferencia: 0.0, estado: 'Pendiente',},
    { almacen_codigo: 'PR001', descripcion: 'Aceite vegetal', almacen: 'Almacen centro', categoria: 'Aceites', unidadMedida: 'Litros', fechaProceso: '20/12/2025', precioPromedioActual: 12.5, precioPromedioRecalculado: 11.8, diferencia: -0.7, estado: 'Recalculado',},
  ];

  colDefs: ColDef[] = [
    { field: '', 
      headerCheckboxSelection: true,
      checkboxSelection: (params) => params.data?.estado != 'Recalculado',
      headerName: '', 
      width: 50, 
      minWidth: 50,
      pinned: 'left',
      headerClass: 'centrarencabezadocheck', 
      cellStyle: { justifyContent: 'center' }, 
    },
    { field: 'almacen_codigo', headerName: 'Código producto', width: 130,},
    { field: 'descripcion', headerName: 'Descripción', flex: 1, minWidth: 120},
    { field: 'almacen', headerName: 'Almacén', width: 140, filter: true,},
    { field: 'categoria', headerName: 'Categoría', width: 120, filter: true,},
    { field: 'unidadMedida', headerName: 'Unidad de medida', width: 140,},
    { field: 'fechaProceso', headerName: 'Fecha de proceso', width: 120, cellClass: 'text-center',},
    { field: 'precioPromedioActual', headerName: 'Precio promedio actual', width: 160, headerClass: 'ag-right-aligned-header', cellClass: 'text-right',
      valueFormatter: (params: any) => {
        return params.value ? `S/ ${params.value.toFixed(2)}` : 'S/ 0.00';
      },
      cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end',},
    },
    { field: 'precioPromedioRecalculado', headerName: 'Precio promedio recalculado', headerClass: 'ag-right-aligned-header', width: 180, cellClass: 'text-right',
      valueFormatter: (params: any) => {
        return params.value ? `S/ ${params.value.toFixed(2)}` : 'S/ 0.00';
      },
      cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end',
      },
    },
    { field: 'diferencia', headerName: 'Diferencia', width: 120, headerClass: 'ag-right-aligned-header', cellClass: 'text-right',
      cellRenderer: (params: any) => {
        const valor = params.value;
        let colorClasses = 'text-gray-600';
        let prefijo = '-';

        if (valor > 0) {
          colorClasses = 'text-[#6DC560] font-semibold';
          prefijo = '+';
        } else if (valor < 0) {
          colorClasses = 'text-[#EF4444] font-semibold';
        }

        return `<span class="${colorClasses}">${prefijo}S/ ${Math.abs(
          valor
        ).toFixed(2)}</span>`;
      },
      cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end',
      },
    },
    { field: 'estado', headerName: 'Estado', headerClass: 'centrarencabezado', width: 120, filter: true, cellClass: 'text-center',
      cellRenderer: (params: any) => {
        const estado = params.value;
        const colorClasses =
          estado === 'Recalculado'
            ? 'bg-[#DCFDE7] text-[#16A34A]'
            : 'bg-[#F5F5F5] text-[#363636]';
        return `<span class="badge-table ${colorClasses}">${estado}</span>`;
      },
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center',
      },
    },
  ];

  rowSelection: RowSelectionOptions | 'single' | 'multiple' = {
    mode: 'multiRow',
  };

  initialState: GridState = {};

  // Inicializar sin datos para mostrar el mensaje
  movimientosRowData: any[] = [];

  movimientosColDefs: ColDef[] = [
    { field: 'almacen_codigo', headerName: 'Codigo producto', width: 130,},
    { field: 'descripcion', headerName: 'Descripción', flex: 1, minWidth: 120},
    { field: 'stockActual', headerName: 'Stock actual', width: 120, cellClass: 'text-center',},
    { field: 'unidadMedida', headerName: 'Unidad de medida', width: 150, cellClass: 'text-center',},
    { field: 'precioPromedioActual', headerName: 'Precio promedio actual', width: 180, headerClass: 'ag-right-aligned-header',
      valueFormatter: (params: any) => {
        return params.value ? `S/${params.value.toFixed(2)}` : 'S/0.00';
      },
      cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end',
      },
    },
    { field: 'precioPromedioRecalculado', headerName: 'Precio promedio recalculado', width: 200, headerClass: 'ag-right-aligned-header',
      valueFormatter: (params: any) => { return params.value ? `S/${params.value.toFixed(2)}` : 'S/0.00';
      },
      cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end',
      },
    },
    { field: 'movimientos', headerName: 'Movimientos', width: 120, cellClass: 'text-center',},
    { field: 'valorInventarioActual', headerName: 'Valor inventario actual', width: 180,headerClass: 'ag-right-aligned-header',
      valueFormatter: (params: any) => {
        return params.value ? `S/${params.value.toFixed(2)}` : 'S/0.00';
      },
      cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end',
      },
    },
    { field: 'valorInventarioRecalculado', headerName: 'Valor inventario recalculado', width: 200, headerClass: 'ag-right-aligned-header',
      valueFormatter: (params: any) => {
        return params.value ? `S/${params.value.toFixed(2)}` : 'S/0.00';
      },
      cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end',
      },
    },
    { field: 'diferencia', headerName: 'Diferencia', width: 150, headerClass: 'ag-right-aligned-header',
      cellRenderer: (params: any) => {
        const valor = params.value;
        let colorClasses = 'text-gray-600';
        let prefijo = '-';

        if (valor > 0) {
          colorClasses = 'text-[#6DC560] font-semibold';
          prefijo = '+ ';
        } else if (valor < 0) {
          colorClasses = 'text-danger font-semibold';
        }

        return `<span class="${colorClasses}">${prefijo}S/${Math.abs(
          valor
        ).toFixed(2)}</span>`;
      },
      cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end',
      },
    },
  ];

  columnTypes = {
    rightAligned: { cellClass: 'text-right' },
    centered: { cellClass: 'text-center' },
  };

  // Facade

  constructor(
    private fb: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController
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
    this.initForm();
    
    // Simular carga inicial
    this.isLoading = true;
    setTimeout(() => {
      this.isLoading = false;
    }, 500);
  }

  initForm() {
    this.recalculoForm = this.fb.group({
      // Campos para cuando NO hay selección
      almacen_codigo: new FormControl({ value: '', disabled: true }),
      descripcion: new FormControl({ value: '', disabled: true }),
      unidadMedida: new FormControl({ value: '', disabled: true }),
      precioPromActual: new FormControl({ value: '', disabled: true }),
      precioPromRecalculado: new FormControl({ value: '', disabled: true }),
      moneda: new FormControl({ value: '', disabled: true }),
    });
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    if (this.filaSeleccionada) {
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node: any) => {
            if (node.data && node.data.almacen_codigo === this.filaSeleccionada?.almacen_codigo) {
              node.setSelected(true);
              this.gridApi.ensureNodeVisible(node, 'middle');
            }
          });
        }
      }, 150);
    }
  }
  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApiDetalle = params.api;
  }

  onSelectionChanged(): void {
    if (this.gridApi) {
      this.filasSeleccionadasCount = this.gridApi.getSelectedRows().length;
    }
  }

  onCellClicked(event: any) {
    const data = event.data;
    this.filaSeleccionada = data;
    this.gridApi.deselectAll();
    event.node.setSelected(true);
    this.filasSeleccionadasCount = 1;

    this.recalculoForm.patchValue({
      almacen_codigo: data.almacen_codigo || '',
      descripcion: data.descripcion || '',
      unidadMedida: data.unidadMedida || '',
      precioPromActual: data.precioPromedioActual || 0,
      precioPromRecalculado: data.precioPromedioRecalculado || 0,
      moneda: 'Soles',
    });

    if (data.estado === 'Recalculado') {
      // Cargar tabla secundaria con el detalle del producto recalculado
      this.cargarMovimientosProducto(data.almacen_codigo);

      // Actualizar las cartas con los valores del producto
      const movimiento = this.movimientosRowData[0];
      if (movimiento) {
        this.stockActualCalculado = movimiento.precioPromedioActual || 0;
        this.stockRecalculadoCalculado = movimiento.precioPromedioRecalculado || 0;
        this.diferenciaCalculada = movimiento.precioPromedioRecalculado - movimiento.precioPromedioActual;
      } else {
        this.stockActualCalculado = data.precioPromedioActual || 0;
        this.stockRecalculadoCalculado = data.precioPromedioRecalculado || 0;
        this.diferenciaCalculada = data.diferencia || 0;
      }

      this.botonesHabilitados = true;
      this.btnDisabled = true;
    } else {
      // Resetear las cartas a ceros para productos pendientes
      this.stockActualCalculado = 0;
      this.stockRecalculadoCalculado = 0;
      this.diferenciaCalculada = 0;

      // Limpiar la tabla de movimientos
      this.movimientosRowData = [];
      this.botonesHabilitados = false;
      this.btnDisabled = false;
    }
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

  onBtReset() {
    if (this.gridApi) {
      this.isLoading = true;

      setTimeout(() => {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.isLoading = false;
      }, 300);
    }
  }

  onBtResetDetalle() {
    if (this.gridApiDetalle) {
      this.gridApiDetalle.showLoadingOverlay();

      setTimeout(() => {
        this.gridApiDetalle.setGridOption('rowData', [...this.movimientosRowData]);
        this.gridApiDetalle.hideOverlay();
      }, 300);
    }
  }

  private delay(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  async recalcularConDados() {
    if (!this.filaSeleccionada) {
      this.toastService.success(
        'Por favor, selecciona un producto de la tabla'
      );
      return;
    }

    this.onBtResetDetalle();

    this.recalculando = true;

    // Simular proceso de recálculo
    await this.delay(300);

    const precioActual = this.filaSeleccionada.precioPromedioActual || 0;
    // Variación entre -2.00 y +2.00 soles
    const variacion = parseFloat((Math.random() * 4 - 2).toFixed(2));
    const precioRecalculado = parseFloat((precioActual + variacion).toFixed(2));
    const diferencia = variacion;

    // AHORA SÍ actualizar las cards
    this.stockActualCalculado = precioActual;
    this.stockRecalculadoCalculado = precioRecalculado;
    this.diferenciaCalculada = diferencia;

    // Actualizar fila
    this.filaSeleccionada.precioPromedioRecalculado = precioRecalculado;
    this.filaSeleccionada.diferencia = diferencia;

    // Actualizar formulario solo si es Pendiente
    if (this.filaSeleccionada.estado === 'Pendiente') {
      this.recalculoForm.patchValue({
        unidadMedida: this.filaSeleccionada.unidadMedida,
        precioPromActual: precioActual.toFixed(2),
        precioPromRecalculado: precioRecalculado.toFixed(2),
        moneda: 'Soles',
      });
    }

    // Actualizar tabla principal
    if (this.gridApi) {
      this.gridApi.applyTransaction({ update: [this.filaSeleccionada] });
    }

    // AHORA SÍ cargar movimientos y agregar el recálculo
    this.cargarMovimientosProducto(this.filaSeleccionada.almacen_codigo);
    this.agregarMovimientoRecalculo(diferencia);

    this.recalculando = false;
    this.botonesHabilitados = true;
  }

  // Método para cargar movimientos de un producto específico
  cargarMovimientosProducto(codigoProducto: string) {
    // Simulación de datos de movimientos por producto
    const movimientosPorProducto: { [key: string]: any[] } = {
      PR002: [
        {
          almacen_codigo: 'PR002', 
          descripcion: 'Arroz blanco',
          stockActual: 200,
          unidadMedida: 'Kilogramos',
          precioPromedioActual: 10.0,
          precioPromedioRecalculado: 15.0,
          movimientos: 18,
          valorInventarioActual: 2000.0,
          valorInventarioRecalculado: 2500.0,
          diferencia: 500.0,
        },
      ],
      PR001: [
        {
          almacen_codigo: 'PR001', 
          descripcion: 'Aceite vegetal',
          stockActual: 150,
          unidadMedida: 'Litros',
          precioPromedioActual: 12.5,
          precioPromedioRecalculado: 11.8,
          movimientos: 25,
          valorInventarioActual: 1875.0,
          valorInventarioRecalculado: 1770.0,
          diferencia: -105.0,
        },
      ],
      PR003: [
        {
          almacen_codigo: 'PR003', 
          descripcion: 'Papa amarilla',
          stockActual: 300,
          unidadMedida: 'Kilogramos',
          precioPromedioActual: 3.5,
          precioPromedioRecalculado: 3.8,
          movimientos: 32,
          valorInventarioActual: 1050.0,
          valorInventarioRecalculado: 1140.0,
          diferencia: 90.0,
        },
      ],
      PR004: [
        {
          almacen_codigo: 'PR004', 
          descripcion: 'Carne',
          stockActual: 180,
          unidadMedida: 'Kilogramos',
          precioPromedioActual: 25.0,
          precioPromedioRecalculado: 24.5,
          movimientos: 15,
          valorInventarioActual: 4500.0,
          valorInventarioRecalculado: 4410.0,
          diferencia: -90.0,
        },
      ],
      PR005: [
        {
          almacen_codigo: 'PR005', 
          descripcion: 'Pollo',
          stockActual: 220,
          unidadMedida: 'Kilogramos',
          precioPromedioActual: 18.5,
          precioPromedioRecalculado: 19.2,
          movimientos: 28,
          valorInventarioActual: 4070.0,
          valorInventarioRecalculado: 4224.0,
          diferencia: 154.0,
        },
      ],
    };

    // Obtener movimientos del producto o array vacío si no existe
    this.movimientosRowData = movimientosPorProducto[codigoProducto] || [];
  }

  // Método para agregar un movimiento de recálculo
  agregarMovimientoRecalculo(variacion: number) {
    if (this.movimientosRowData.length === 0) return;

    // Actualizar el registro existente con los nuevos valores recalculados
    const movimiento = this.movimientosRowData[0];
    movimiento.precioPromedioRecalculado = this.stockRecalculadoCalculado;
    movimiento.valorInventarioRecalculado =
      movimiento.stockActual * this.stockRecalculadoCalculado;
    movimiento.diferencia =
      movimiento.valorInventarioRecalculado - movimiento.valorInventarioActual;

    // Forzar actualización de la tabla
    this.movimientosRowData = [...this.movimientosRowData];
  }

  async recalcularProductosSeleccionados() {
    // VALIDACIÓN: Verificar que hay filas seleccionadas
    if (!this.gridApi) {
      this.toastService.success('Error al acceder a la tabla');
      return;
    }

    const nodosSeleccionados = this.gridApi.getSelectedRows();

    // Si no hay filas seleccionadas, mostrar mensaje y salir
    if (nodosSeleccionados.length === 0) {
      this.toastService.success(
        'Por favor, selecciona al menos un producto para recalcular'
      );
      return;
    }

    this.onBtResetDetalle();
    this.recalculando = true;

    await this.delay(300);

    const productosActualizados = nodosSeleccionados.map((producto) => {
      const precioActual = producto.precioPromedioActual || 0;
      const variacion = parseFloat((Math.random() * 4 - 2).toFixed(2));

      return {
        ...producto,
        precioPromedioRecalculado: parseFloat(
          (precioActual + variacion).toFixed(2)
        ),
        diferencia: variacion,
      };
    });

    if (this.gridApi) {
      this.gridApi.applyTransaction({ update: productosActualizados });
    }

    // Si solo hay un producto seleccionado, actualizar el panel derecho
    if (productosActualizados.length === 1) {
      const producto = productosActualizados[0];
      this.filaSeleccionada = producto;

      // AHORA SÍ actualizar las cards
      this.stockActualCalculado = producto.precioPromedioActual;
      this.stockRecalculadoCalculado = producto.precioPromedioRecalculado;
      this.diferenciaCalculada = producto.diferencia;

      // Actualizar formulario
      this.recalculoForm.patchValue({
        unidadMedida: producto.unidadMedida || '',
        precioPromActual: producto.precioPromedioActual,
        precioPromRecalculado: producto.precioPromedioRecalculado,
        moneda: 'Soles',
      });

      // AHORA SÍ cargar movimientos y agregar el recálculo
      this.cargarMovimientosProducto(producto.almacen_codigo);
      this.agregarMovimientoRecalculo(producto.diferencia);
    }

    this.botonesHabilitados = true;
    this.recalculando = false;
    
  }
  confirmacionRecalculo(){
    // Si hay una fila seleccionada, cambiar su estado a Recalculado
    if (this.filaSeleccionada) {
      // Actualizar el objeto filaSeleccionada
      this.filaSeleccionada = {
        ...this.filaSeleccionada,
        estado: 'Recalculado'
      };

      // Buscar y actualizar en rowData
      const indexProducto = this.rowData.findIndex(p => p.almacen_codigo === this.filaSeleccionada.almacen_codigo);
      if (indexProducto !== -1) {
        this.rowData[indexProducto] = {
          ...this.rowData[indexProducto],
          estado: 'Recalculado'
        };
      }

      // Actualizar la tabla
      if (this.gridApi) {
        this.gridApi.applyTransaction({ update: [this.filaSeleccionada] });
      }

      this.toastService.success('¡Producto recalculado correctamente!');
      this.onBtReset();
    } else {
      this.toastService.success('No hay producto seleccionado para recalcular');
    }
    
    this.btnDisabled = true;
  }

  async modalverActualizaciones() {
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
      {
        headerName: 'Estado',
        headerClass: 'centrarencabezado',
        field: 'estado',
        width: 70,
        cellClass: 'text-center',
        cellRenderer: (params: any) => {
          const estado = params.value;
          const colorClasses =
            estado === 'Recalculado'
              ? 'bg-[#DCFDE7] text-[#16A34A]'
              : 'bg-[#FEF3C7] text-[#B45309]';
          return `<span class="badge-table ${colorClasses}">${estado}</span>`;
        },
        cellStyle: {
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
        },
      },
    ];

    const rowData = [
      {
        fechaHora: '29/11/2025 14:30',
        usuario: 'Pablo Campos',
        accion: 'Creación',
        detalleCambio: 'Registro inicial del recálculo',
        estado: 'Pendiente',
      },
      {
        fechaHora: '29/11/2025 14:25',
        usuario: 'Pablo Campos',
        accion: 'Modificación',
        detalleCambio: 'Se realizó el recálculo del precio promedioS',
        estado: 'Recalculado',
      },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de actualizaciones de ${this.filaSeleccionada?.almacen_codigo} - ${this.filaSeleccionada?.descripcion}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      },
    });

    await modal.present();
  }
}
