import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import { Component, OnInit, inject, effect } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent, ValueFormatterParams } from 'ag-grid-community';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

// Facade
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
import { AlmacenEntity } from '../../../../domain/models/almacen.entity';
import { ProductoVendidoEntity } from '../../../../domain/models/producto-vendido.entity';



@Component({
  selector: 'app-almacen-reportes-vendidos-zona',
  templateUrl: './almacen-reportes-vendidos-zona.component.html',
  styleUrls: ['./almacen-reportes-vendidos-zona.component.scss'],
  standalone: false,
})
export class AlmacenReportesVendidosZonaComponent implements OnInit {
  // Facades
  protected readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.isLoading;
  readonly loadingReporteVendidos = this.almacenFacade.loadingReporteVendidos;


  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'almacen-reportes-vendidos-zona'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }
  selectedDate: Date | undefined;
  
  // Propiedad local para ag-grid (para evitar problemas con signals)
  rowData: ProductoVendidoEntity[] = [];

  // Formateador de números con comas
  numberFormatter = (params: ValueFormatterParams) => {
    if (params.value == null) return '';
    return params.value.toLocaleString('en-US', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    });
  };

  colDefs: ColDef[] = [
    { field: 'producto_vendido_fecha', headerName: 'Fecha venta', width: 100,},
    { field: 'producto_vendido_codigo', headerName: 'Código', width: 80,},
    { field: 'producto_vendido_producto', headerName: 'Producto', width: 200,},
    { field: 'producto_vendido_categoria', headerName: 'Categoría', width: 120, filter: true},
    { field: 'producto_vendido_almacen', headerName: 'Almacén', width: 140, filter: true},
    { field: 'producto_vendido_medida', headerName: 'Medida', width: 90, filter: true},
    { field: 'producto_vendido_cantidad_vendida', headerName: 'Cantidad vendida', headerClass: 'derechaencabezado', width: 120, type: 'rightAligned',
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
      },
      valueFormatter: this.numberFormatter
    },
    { field: 'producto_vendido_precio_unitario', headerName: 'Precio unitario', headerClass: 'derechaencabezado', width: 130, type: 'rightAligned',
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
      },
      valueFormatter: this.numberFormatter
    },
    { field: 'producto_vendido_costo_unitario', headerName: 'Costo unitario', headerClass: 'derechaencabezado', width: 130, type: 'rightAligned',
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
      },
      valueFormatter: this.numberFormatter
    },
    { field: 'producto_vendido_ingreso_total', headerName: 'Ingreso total', headerClass: 'derechaencabezado', width: 130, type: 'rightAligned',
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
      },
      valueFormatter: this.numberFormatter
    },
    { field: 'producto_vendido_costo_total', headerName: 'Costo total', headerClass: 'derechaencabezado', width: 130, type: 'rightAligned',
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
      },
      valueFormatter: this.numberFormatter
    },
    { field: 'producto_vendido_margen', headerName: 'Margen bruto', headerClass: 'derechaencabezado', width: 110, type: 'rightAligned',
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
      },
      cellRenderer: (params: any) => {
        return `${params.value} %`;
      }
    },
    { field: 'producto_vendido_cliente_tipo', headerName: 'Cliente (Tipo)', width: 150, filter: true},
    { field: 'producto_vendido_vendedor_responsable', headerName: 'Vendedor responsable', width: 160, filter: true},
    { headerClass: 'centrarencabezado', field: 'producto_vendido_estado', headerName: 'Estado', width: 100, filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>`;
        } else if (params.value === 'Inactivo') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>`;
        }
        return params.value;
      },
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
  ];

  columnTypes = {
    rightAligned: { headerClass: 'ag-right-aligned-header',
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
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );
    this.maxDate = today;
    
    // Effect para monitorear cambios en los datos
    effect(() => {
      const datos = this.almacenFacade.reporteVendidos();
      
      // Convertir a array plano para ag-grid
      this.rowData = datos ? [...datos] : [];
      
      if (datos && datos.length > 0) {
      }
    });
   }

  ngOnInit() {
    this.catalogosFacade.inicializarCatalogos();
    
    // Cargar reporte de productos vendidos desde el store
    this.cargarReporteVendidos();
    
    // Debug: log data changes
  }

  /**
   * Cargar reporte de productos vendidos desde el store usando el facade
   */
  cargarReporteVendidos() {
    this.almacenFacade.cargarReporteVendidos();
  }

    onBtReset() {
    this.cargarReporteVendidos();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
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
}
