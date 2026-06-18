import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import { Component, OnInit, inject, effect } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent, RowSelectionOptions, GridState } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormGroup, FormBuilder, FormControl } from '@angular/forms';
import { ModalRecalcularComponent } from '../a-p-cuadrestock/modals/modal-recalcular/modal-recalcular.component';

// Font Awesome Icons
import { faBook, faInfoCircle, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faBox, faChevronsLeft, faChevronsRight, faCog, faDownload, faExchangeAlt, faRotateRight, faSyncAlt } from '@fortawesome/pro-solid-svg-icons';

// Facade
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
import { AlmacenEntity } from '../../../../domain/models/almacen.entity';


interface MovimientoData {
  fecha: string;
  entrada: number | null;
  salida: number | null;
  stock: number;
  documento: string;
  observacion: string;
}

@Component({
  selector: 'app-a-p-cuadrestock',
  templateUrl: './a-p-cuadrestock.component.html',
  styleUrls: ['./a-p-cuadrestock.component.scss'],
  standalone: false,
})
export class APCuadrestockComponent  implements OnInit {
  // Facades
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly cuadreStock = this.almacenFacade.cuadreStock;
  readonly movimientosCuadreStock = this.almacenFacade.movimientosCuadreStock;
  readonly isLoading = this.almacenFacade.loadingCuadreStock;

  // Font Awesome Icons
  farBook = faBook;
  farInfoCircle = faInfoCircle;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasBox = faBox;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasDownload = faDownload;
  fasExchangeAlt = faExchangeAlt;
  fasRotateRight = faRotateRight;
  fasSyncAlt = faSyncAlt;
  fasCog = faCog;



  mostrartabla: boolean = true;
  recalculoForm!: FormGroup;
  
  fechaCorte: Date | undefined;
  startDate: any;
  endDate: any;
  minDate: Date;
  maxDate: Date;

  panelLateralVisible: boolean = true;
  cargando = false;
  filaSeleccionada: any = null;
  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'a-p-cuadrestock'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }

  // Botones desactivados inicialmente
  botonesDesactivados: boolean = true;
  botonesDesactivados2: boolean = true;
  botonBuscarDeshabilitado: boolean = true;
  botonExportarDeshabilitado: boolean = true;
  filasSeleccionadasCount: number = 0;

  // Variables para validar si se pueden buscar datos
  fechasSeleccionadas: boolean = false;
  almacenSeleccionado: any = null;

  // Facade
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
  defaultColDef = {
    valueFormatter: (params:any) => {
      if (params.colDef.checkboxSelection) return params.value;
      return (params.value === null || params.value === undefined || params.value === '')
        ? '-'
        : params.value;
    }
  };

  rowData: any[] = [];

  colDefs: ColDef[] = [
    { headerCheckboxSelection: true, width: 40, headerName: '', pinned: 'left', headerClass: 'header-checkbox-col', cellClass: 'cell-checkbox-col', checkboxSelection: (params) => params.data?.cuadre_estado == 'Pendiente',},
    { field: 'cuadre_codigo', headerName: 'Codigo producto', width: 130,},
    { field: 'cuadre_unidad_medida', headerName: 'Unidad de medida', width: 130, filter: true},
    { field: 'cuadre_descripcion', headerName: 'Descripción', flex: 1},
    { field: 'cuadre_fecha_corte', headerName: 'Fecha de corte', width: 120, valueFormatter: (params) => {
      if (params.value) {
        return new Date(params.value).toLocaleDateString('es-PE');
      }
      return '-';
    }},
    { field: 'cuadre_stock_actual', headerName: 'Stock actual', width: 100, cellClass: 'text-center', headerClass: 'derechaencabezado', 
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
      },
    },
    { field: 'cuadre_stock_recalculado', headerName: 'Stock recalculado', width: 120, headerClass: 'derechaencabezado',  cellClass: 'text-center',
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
      },
    },
    { field: 'cuadre_diferencia', headerName: 'Diferencia', width: 100, headerClass: 'derechaencabezado',  cellClass: 'text-center',
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
      },
    },
    { field: 'cuadre_estado', headerName: 'Estado', headerClass: 'centrarencabezado', width: 100, filter: true, cellClass: 'text-center',
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center',},
      cellRenderer: (params: any) => {
        if (params.value === 'Finalizado') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Finalizado</span>`;
        } else if (params.value === 'Revertido') {
          return `<span class="badge-table bg-[#FFF0BF] text-[#DC2626]">Revertido</span>`;
        } else if (params.value === 'En ejecución') {
          return `<span class="badge-table bg-[#FEF3C7] text-[#B45309]">En ejecución</span>`;
        } else if (params.value === 'Pendiente') {
          return `<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>`;
        }
        return params.value;
      },
    }
  ];
  
  rowSelection: RowSelectionOptions | 'single' | 'multiple' = {
    mode: 'multiRow',
  };

  initialState: GridState = {};

  // Variables para mostrar en las tarjetas - INICIAN EN 0
  stockActualDisplay: string = '0 kg';
  stockRecalculadoDisplay: string = '0 kg';
  diferenciaDisplay: string = '0 kg';
  productoSeleccionadoNombre: string = 'Producto';

  // Movimientos vacíos al inicio
  movimientosRowData: any[] = [];
  
  // Variable para controlar si se muestran los datos
  mostrarDatos: boolean = false;

  // ARRAY PARA ALMACENAR TODOS LOS MOVIMIENTOS DEL PERIODO
  movimientosPeriodoCompleto: MovimientoData[] = [];

  // Array para productos filtrados que se mostrarán en la tabla izquierda
  productosFiltrados: any[] = [];

  // Historial de recálculos y reversiones
  historialRecalculos: any[] = [];

  movimientosColDefs: ColDef[] = [
    { field: 'fecha', headerName: 'Fecha de movimiento', width: 150 },
    { field: 'entrada', headerName: 'Entrada', width: 100,
      headerClass: 'derechaencabezado', 
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
      }, },
    { field: 'salida', headerName: 'Salida', width: 100,
      headerClass: 'derechaencabezado', 
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
      }, },
    { field: 'stock', headerName: 'Stock', width: 100,
      headerClass: 'derechaencabezado', 
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
      }, },
    { field: 'documento', headerName: 'Documento', width: 120 },
    { field: 'observacion', headerName: 'Observaciones', flex: 1, minWidth: 150 }
  ];

  columnTypes = {
    rightAligned: { cellClass: 'text-right' },
    centered: { cellClass: 'text-center' }
  };

  constructor(
    private fb: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
    
    // Inicializar form primero
    this.initForm();
    
    // Effect para actualizar rowData reactivamente desde el store
    effect(() => {
      this.rowData = this.cuadreStock();
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });

    // Effect para actualizar movimientos reactivamente desde el store
    effect(() => {
      this.movimientosPeriodoCompleto = this.movimientosCuadreStock().map((m: any) => ({
        fecha: m.mov_fecha,
        entrada: m.mov_entrada,
        salida: m.mov_salida,
        stock: m.mov_stock,
        documento: m.mov_documento,
        observacion: m.mov_observacion,
      }));
    });
  }

  ngOnInit() {
    this.catalogosFacade.inicializarCatalogos();
    this.almacenFacade.cargarAlmacenes();
    this.almacenFacade.cargarCuadreStock();
    this.almacenFacade.cargarMovimientosCuadreStock();
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  initForm() {
    this.recalculoForm = this.fb.group({
      fechaCorte: new FormControl(''),
      almacen: new FormControl('')
    });
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onCellClicked(event: any) {
    const data = event.data;
    this.filaSeleccionada = data;
    this.productoSeleccionadoNombre = `Producto: ${data.cuadre_codigo} - ${data.cuadre_descripcion}`;
    this.movimientosRowData = [];
    this.verificarHabilitarBuscar();
  }

  onSelectionChanged(event: any) {
    this.filasSeleccionadasCount = this.gridApi.getSelectedRows().length;
  }

  filtrarPorFechas(range: any) {
    this.startDate = range.start;
    this.endDate = range.end;
    this.fechasSeleccionadas = true;
    this.verificarHabilitarBuscar();
  }

  onAlmacenSeleccionado(almacen: any) {
    console.log('Almacén seleccionado:', almacen);
    this.almacenSeleccionado = almacen;
    this.recalculoForm.patchValue({ almacen: almacen.almacen_codigo });
    this.verificarHabilitarBuscar();
  }

  verificarHabilitarBuscar() {
    // Habilitar botón de buscar solo si hay fechas y almacén
    this.botonBuscarDeshabilitado = !(this.fechasSeleccionadas && this.almacenSeleccionado);
  }

  buscarMovimientos() {
    if (!this.fechasSeleccionadas || !this.almacenSeleccionado) {
      this.toastService.warning('Por favor selecciona un rango de fechas y un almacén');
      return;
    }

    this.cargando = true;

    // Tomar todos los movimientos del store
    const todosMovimientos = this.movimientosCuadreStock();

    // Filtrar por producto seleccionado si hay uno
    const movsFiltrados = this.filaSeleccionada
      ? todosMovimientos.filter((m: any) => m.mov_producto_codigo === this.filaSeleccionada.cuadre_codigo)
      : todosMovimientos;

    // Convertir a formato de la tabla de movimientos
    this.movimientosPeriodoCompleto = movsFiltrados.map((m: any) => ({
      fecha: m.mov_fecha,
      entrada: m.mov_entrada,
      salida: m.mov_salida,
      stock: m.mov_stock,
      documento: m.mov_documento,
      observacion: m.mov_observacion,
    }));

    this.movimientosRowData = [...this.movimientosPeriodoCompleto];

    // Productos del cuadre de stock desde el store
    this.productosFiltrados = this.cuadreStock();
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.productosFiltrados);
    }

    this.botonBuscarDeshabilitado = true;
    this.botonExportarDeshabilitado = false;
    this.botonesDesactivados = false;
    this.mostrarDatos = true;
    this.cargando = false;
  }

  // Método para generar productos filtrados según el rango de fechas y almacén
  // ELIMINADO: ahora los datos vienen del store (cuadreStock / movimientosCuadreStock)

  // Método para ordenar movimientos por fecha
  ordenarMovimientosPorFecha(descendente: boolean = false) {
    this.movimientosPeriodoCompleto.sort((a: any, b: any) => {
      const fechaA = this.convertirFechaString(a.fecha);
      const fechaB = this.convertirFechaString(b.fecha);
      
      if (descendente) {
        return fechaB.getTime() - fechaA.getTime(); // Más reciente primero
      } else {
        return fechaA.getTime() - fechaB.getTime(); // Más antigua primero
      }
    });
  }

  // Método auxiliar para convertir string de fecha a Date
  convertirFechaString(fechaStr: string): Date {
    // Espera formato DD/MM/YYYY
    const partes = fechaStr.split('/');
    if (partes.length === 3) {
      const dia = parseInt(partes[0], 10);
      const mes = parseInt(partes[1], 10) - 1; // Los meses en JS son 0-11
      const año = parseInt(partes[2], 10);
      return new Date(año, mes, dia);
    }
    return new Date(); // Fecha actual como fallback
  }

  // Método auxiliar para formatear fechas según lo que necesite tu API
  formatearFecha(fecha: Date): string {
    if (!fecha) return '';
    
    // Formato ISO: 'YYYY-MM-DD'
    const year = fecha.getFullYear();
    const month = String(fecha.getMonth() + 1).padStart(2, '0');
    const day = String(fecha.getDate()).padStart(2, '0');
    
    return `${year}-${month}-${day}`;
  }

  // ELIMINADO: generarMovimientosPeriodo — los movimientos vienen del store (movimientosCuadreStock)

  calcularTotales() {
    if (this.movimientosPeriodoCompleto.length === 0) {
      this.stockActualDisplay = '0';
      this.stockRecalculadoDisplay = '0';
      this.diferenciaDisplay = '0';
      return;
    }

    const ultimoMovimiento = this.movimientosPeriodoCompleto[this.movimientosPeriodoCompleto.length - 1];
    const um = this.filaSeleccionada?.cuadre_unidad_medida || '';

    const stockActualNum = typeof ultimoMovimiento.stock === 'number'
      ? ultimoMovimiento.stock
      : parseFloat(String(ultimoMovimiento.stock).replace(/[^\d.-]/g, ''));

    const stockRecalculado = this.filaSeleccionada?.cuadre_stock_recalculado ?? stockActualNum;
    const diferencia = this.filaSeleccionada?.cuadre_diferencia ?? (stockRecalculado - stockActualNum);

    this.stockActualDisplay = `${stockActualNum.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })} ${um}`;
    this.stockRecalculadoDisplay = `${Number(stockRecalculado).toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })} ${um}`;
    this.diferenciaDisplay = `${Number(diferencia).toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })} ${um}`;
  }

  onBtReset() {
    if (this.gridApi) {
      this.almacenFacade.cargarCuadreStock();
    }
  }

  confirmarCalculo() {
    this.toastService.success('¡Recálculo confirmado exitosamente!');
  }

  async abrirModalRecalcular() {
    const detalles = [
      { label: 'Fecha de corte', value: `${this.startDate ? this.formatearFechaDisplay(this.startDate) : ''} - ${this.endDate ? this.formatearFechaDisplay(this.endDate) : ''}` },
      { label: 'Almacén', value: this.almacenSeleccionado?.almacen_nombre || 'No especificado' }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Producto: ${this.filaSeleccionada?.cuadre_codigo || ''} - ${this.filaSeleccionada?.cuadre_descripcion || ''}`,
        subtitulomodal: 'Detalle del recálculo',
        detalles: detalles,
        mostrarTextarea: false,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Recalcular',
        colorBotonConfirmar: 'primary'
      }
    });
    
    await modal.present();
    const { data } = await modal.onWillDismiss();
    
    if (data?.action === 'confirmar') {
      // Simular cambio en la diferencia con signo
      const variacion = parseFloat((Math.random() * 2 - 1).toFixed(2));
      const signo = variacion >= 0 ? '+' : '';
      this.diferenciaDisplay = `${signo}${variacion} kg`;
      this.botonesDesactivados2 = false;
      this.botonesDesactivados = true;
      // Registrar en historial
      const ahora = new Date();
      const horaFormato = `${String(ahora.getDate()).padStart(2, '0')}/${String(ahora.getMonth() + 1).padStart(2, '0')}/${ahora.getFullYear()} - ${String(ahora.getHours()).padStart(2, '0')}:${String(ahora.getMinutes()).padStart(2, '0')}`;
      
      this.historialRecalculos.unshift({
        fechaHora: horaFormato,
        usuario: 'Usuario actual',
        accion: 'Recalcular stock',
        detalleCambio: `Fecha de corte: ${this.startDate ? this.formatearFechaDisplay(this.startDate) : ''} - ${this.endDate ? this.formatearFechaDisplay(this.endDate) : ''}. Almacén ${this.almacenSeleccionado?.almacen_nombre || 'N/A'}.`,
        estado: 'Finalizado'
      });
      
      this.toastService.success('¡Recálculo completado exitosamente!');
    }
  }

  formatearFechaDisplay(fecha: any): string {
    if (!fecha) return '';
    const date = new Date(fecha);
    const dia = String(date.getDate()).padStart(2, '0');
    const mes = String(date.getMonth() + 1).padStart(2, '0');
    const año = date.getFullYear();
    return `${dia}/${mes}/${año}`;
  }

  async abrirModalRevertir() {
    const detalles = [
      { label: 'Fecha de corte', value: `${this.startDate ? this.formatearFechaDisplay(this.startDate) : ''} - ${this.endDate ? this.formatearFechaDisplay(this.endDate) : ''}` },
      { label: 'Almacén', value: this.almacenSeleccionado?.almacen_nombre || 'No especificado' }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Producto: ${this.filaSeleccionada?.cuadre_codigo || ''} - ${this.filaSeleccionada?.cuadre_descripcion || ''}`,
        subtitulomodal: 'Detalle de la revisión',
        detalles: detalles,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo de la reversión:',
        placeholderTextarea: 'Describe el motivo de la reversión...',
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Revertir',
        colorBotonConfirmar: 'primary'
      }
    });
    
    await modal.present();
    const { data } = await modal.onWillDismiss();
    
    if (data?.action === 'confirmar') {
      // Resetear todos los valores a 0
      this.stockActualDisplay = '0 kg';
      this.stockRecalculadoDisplay = '0 kg';
      this.diferenciaDisplay = '0 kg';
      
      // Registrar en historial
      const ahora = new Date();
      const horaFormato = `${String(ahora.getDate()).padStart(2, '0')}/${String(ahora.getMonth() + 1).padStart(2, '0')}/${ahora.getFullYear()} - ${String(ahora.getHours()).padStart(2, '0')}:${String(ahora.getMinutes()).padStart(2, '0')}`;
      
      this.historialRecalculos.unshift({
        fechaHora: horaFormato,
        usuario: 'Usuario actual',
        accion: 'Revertir recálculo',
        detalleCambio: `Reversión de recálculo ejecutado. Fecha de corte y almacén originales preservados. Motivo: ${data.motivo || 'No especificado'}`,
        estado: 'Revertido'
      });
      
      this.toastService.success('¡Reversión completada exitosamente!');
    }
  }

  async modalverActualizaciones() {
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 100, },
      { headerName: 'Usuario', field: 'usuario', width: 120, },
      {
        headerName: 'Acción', field: 'accion', width: 120,
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
        field: 'estado',
        width: 90,
        cellClass: 'text-center',
        cellRenderer: (params: any) => {
          const estado = params.value;
          let colorClasses = 'bg-[#F5F5F5] text-[#363636]';
          
          if (estado === 'Finalizado') {
            colorClasses = 'bg-[#DCFDE7] text-[#16A34A]';
          } else if (estado === 'Revertido') {
            colorClasses = 'bg-[#FEF3C7] text-[#B45309]';
          } else if (estado === 'En ejecución') {
            colorClasses = 'bg-[#DBEAFE] text-[#0284C7]';
          }
          
          return `<span class="badge-table ${colorClasses}">${estado}</span>`;
        },
        cellStyle: {
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
        },
      }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de actualizaciones de movimientos ${this.filaSeleccionada?.cuadre_codigo || ''} - ${this.filaSeleccionada?.cuadre_descripcion || ''}`,
        rowData: this.historialRecalculos,
        colDefs: colDefs,
        altoModal: '400px'
      }
    });
    
    await modal.present();
  }

  onFechaCorteSelected(date: Date) {
    console.log('Fecha corte:', date);
    this.fechaCorte = date;
  }
  async abrirModalRecalcularTodos() {
    const modal = await this.modalController.create({
      component: ModalRecalcularComponent,
      cssClass: 'promo2',
      componentProps: {
        
      }
    });
    
    await modal.present();
  }
}
