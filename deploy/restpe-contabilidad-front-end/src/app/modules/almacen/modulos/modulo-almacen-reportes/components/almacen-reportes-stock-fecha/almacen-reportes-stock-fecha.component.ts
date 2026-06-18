import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faArrowDown, faArrowUp, faCalculator, faCalendar, faDownload, faFiles, faRotateRight, faWarning } from '@fortawesome/pro-solid-svg-icons';

// Facade
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
import { AlmacenEntity } from '../../../../domain/models/almacen.entity';
import { StockFechaEntity } from '../../../../domain/models/stock-fecha.entity';


@Component({
  selector: 'app-almacen-reportes-stock-fecha',
  templateUrl: './almacen-reportes-stock-fecha.component.html',
  styleUrls: ['./almacen-reportes-stock-fecha.component.scss'],
  standalone: false,
})
export class AlmacenReportesStockFechaComponent implements OnInit {
  // Facades
  protected readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.isLoading;


  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasArrowDown = faArrowDown;
  fasArrowUp = faArrowUp;
  fasCalculator = faCalculator;
  fasCalendar = faCalendar;
  fasDownload = faDownload;
  fasFiles = faFiles;
  fasRotateRight = faRotateRight;
  fasWarning = faWarning;


  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'almacen-reportes-stock-fecha'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }
  informacionForm!: FormGroup;
  selectedProducto: StockFechaEntity | null = null;
  onCellClicked(event: any) {
    this.selectedProducto = event.data;
  }
  colDefs: ColDef[] = [
    { field: 'stock_fecha_codigo', headerName: 'Código', width: 90, sortable: true,},
    { field: 'stock_fecha_producto', headerName: 'Producto', flex: 1, minWidth: 200, sortable: true,},
    { field: 'stock_fecha_categoria', headerName: 'Categoría', width: 150, sortable: true, filter: true,},
    { field: 'stock_fecha_medida', headerName: 'Medida', width: 80, sortable: true,},
    { field: 'stock_fecha_ultimo_movimiento', headerName: 'Fecha último movimiento', width: 170, sortable: true,},
    { field: 'stock_fecha_almacen', headerName: 'Almacén', width: 150, sortable: true, filter: true,},
    {
      field: 'stock_fecha_stock_actual',
      headerName: 'Stock actual',
      headerClass: 'derechaencabezado', 
      width: 120,
      sortable: true,
      cellStyle: (params) => {
        const style: any = { justifyContent: 'end', };
        if (params.value < 0) {
          style.color = '#EF4444'; // Rojo para negativos
        }
        return style;
      },
    },
    {
      field: 'stock_fecha_estado',
      headerName: 'Estado',
      headerClass: 'centradoencabezado',
      width: 90,
      sortable: true,
      filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>`;
        } else if (params.value === 'Inactivo') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>`;
        }
        return params.value;
      },
    },
  ];

  columnTypes = {
    rightAligned: {
      headerClass: 'ag-right-aligned-header',
      cellClass: 'ag-right-aligned-cell',
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

  constructor(private fb: FormBuilder) {
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
    this.almacenFacade.cargarReporteStockFecha();
    this.informacionForm = this.fb.group({
      nombreProducto: new FormControl(''),
    });
  }

  onBtReset() {
    this.almacenFacade.cargarReporteStockFecha();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // Auto-seleccionar la primera fila
    setTimeout(() => {
      const firstNode = this.gridApi.getRowNode('0');
      if (firstNode) {
        firstNode.setSelected(true);
        this.selectedProducto = firstNode.data;
      }
    }, 100);
  }
  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos
    this.cargarDatos(range.start, range.end);
  }

  cargarDatos(start: Date, end: Date) {
    // Recargar datos desde el facade
    this.almacenFacade.cargarReporteStockFecha();
  }
}
