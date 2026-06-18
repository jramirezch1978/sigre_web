import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import { Component, OnInit, inject } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent, ValueFormatterParams } from 'ag-grid-community';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

// Facade
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
import { AlmacenEntity } from '../../../../domain/models/almacen.entity';
import { StockMinimoEntity } from '../../../../domain/models/stock-minimo.entity';



interface IStockMinimo {
  almacen_codigo: string;
  producto: string;
  categoria: string;
  almacen: string;
  medida: string;
  stockActual: number;
  nivelMinimo: number;
  diferencia: number;
  proveedorP: string;
  fechaCompra: string;
  fechaVenta: string;
  vendedorResp: string;
  estado: string;
}

@Component({
  selector: 'app-almacen-reportes-stock-minimo',
  templateUrl: './almacen-reportes-stock-minimo.component.html',
  styleUrls: ['./almacen-reportes-stock-minimo.component.scss'],
  standalone: false,
})
export class AlmacenReportesStockMinimoComponent implements OnInit {
  // Facades
  protected readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.isLoading;
  readonly loadingReporteStockMinimo = this.almacenFacade.loadingReporteStockMinimo;


  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'almacen-reportes-stock-minimo'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }
  selectedDate: Date | undefined;
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  // Formateador de números con comas
  numberFormatter = (params: ValueFormatterParams) => {
    if (params.value == null) return '';
    return params.value.toLocaleString('en-US', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    });
  };

  colDefs: ColDef[] = [
    { field: 'stock_minimo_codigo', headerName: 'Código', width: 80,},
    { field: 'stock_minimo_producto', headerName: 'Producto', minWidth: 200, flex: 1,},
    { field: 'stock_minimo_categoria', headerName: 'Categoría', width: 120, filter: true},
    { field: 'stock_minimo_almacen', headerName: 'Almacén', width: 160, filter: true},
    { field: 'stock_minimo_medida', headerName: 'Medida', width: 80, filter: true},
    { field: 'stock_minimo_stock_actual', headerName: 'Stock actual', headerClass: 'derechaencabezado', width: 100, type: 'rightAligned',
       cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
      },
      valueFormatter: this.numberFormatter
    },
    { field: 'stock_minimo_nivel_minimo', headerName: 'Nivel mínimo', headerClass: 'derechaencabezado', width: 100, type: 'rightAligned',
       cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
      },
      valueFormatter: this.numberFormatter
    },
    { field: 'stock_minimo_diferencia', headerName: 'Diferencia', headerClass: 'derechaencabezado', width: 100, type: 'rightAligned',
       cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
      },
      valueFormatter: this.numberFormatter
    },
    { field: 'stock_minimo_proveedor_principal', headerName: 'Proveedor principal', width: 150, filter: true
    },
    { field: 'stock_minimo_fecha_compra', headerName: 'Fecha compra', width: 100,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
    },
    { field: 'stock_minimo_fecha_venta', headerName: 'Fecha venta', width: 100,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
    },
    { field: 'stock_minimo_vendedor_responsable', headerName: 'Vendedor responsable', width: 160, filter: true
    },
    { headerClass: 'centrarencabezado', field: 'stock_minimo_estado', headerName: 'Estado', width: 100, filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Normal') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Normal</span>`;
        } else if (params.value === 'Bajo') {
          return `<span class="badge-table bg-[#FFDECC] text-[#FF8947]">Bajo</span>`;
        } else if (params.value === 'Crítico') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Crítico</span>`;
        }
        return params.value;
      },
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
  ];

  columnTypes = {
    rightAligned: { 
      headerClass: 'ag-right-aligned-header',
      cellClass: 'ag-right-aligned-cell'
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

  constructor() { 
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
    
    // Cargar reporte de stock mínimo desde el store
    this.cargarReporteStockMinimo();
  }

  /**
   * Cargar reporte de stock mínimo desde el store usando el facade
   */
  cargarReporteStockMinimo() {
    console.log('  Cargando reporte de stock mínimo desde el store...');
    this.almacenFacade.cargarReporteStockMinimo();
  }

   onBtReset() {
    this.cargarReporteStockMinimo();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }
  // Para modo SINGLE - Manejo de fecha seleccionada
  filtradoUnico(date: Date) {
    console.log('Fecha:', date);
    this.selectedDate = date;
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos
  }
}
