import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import { Component, OnInit, inject } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent, ValueFormatterParams } from 'ag-grid-community';

// Font Awesome Icons
import { faSearch, faWarehouse } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faList, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

// Facade
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
import { AlmacenEntity } from '../../../../domain/models/almacen.entity';
import { ValorizacionProductoEntity } from '../../../../domain/models/valorizacion-producto.entity';

@Component({
  selector: 'app-almacen-reportes-valorizacion',
  templateUrl: './almacen-reportes-valorizacion.component.html',
  styleUrls: ['./almacen-reportes-valorizacion.component.scss'],
  standalone: false,
})
export class AlmacenReportesValorizacionComponent implements OnInit {
  // Facades
  protected readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.isLoading;
  readonly loadingReporteValorizacion = this.almacenFacade.loadingReporteValorizacion;


  // Font Awesome Icons
  farSearch = faSearch;
  farWarehouse = faWarehouse;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasList = faList;
  fasRotateRight = faRotateRight;


  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'almacen-reportes-valorizacion'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }
  selectedDate: Date | undefined;

  selectedProducto: ValorizacionProductoEntity | null = null;
  onCellClicked(event: any) {
    this.selectedProducto = event.data;
  }

  // Formateador de números con comas
  numberFormatter = (params: ValueFormatterParams) => {
    if (params.value == null) return '';
    return params.value.toLocaleString('en-US', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    });
  };

  colDefs: ColDef[] = [
    { field: 'valorizacion_producto_codigo', headerName: 'Código de producto', width: 130,},
    { field: 'valorizacion_producto_producto', headerName: 'Producto', flex: 1, minWidth: 200,},
    { field: 'valorizacion_producto_categoria', headerName: 'Categoría', width: 140, filter: true},
    { field: 'valorizacion_producto_medida', headerName: 'Medida', width: 100, filter: true},
    { field: 'valorizacion_producto_ultimo_cambio', headerName: 'Últimos cambios', width: 120,},
    { field: 'valorizacion_producto_almacen', headerName: 'Almacén', width: 160, filter: true},
    { field: 'valorizacion_producto_cantidad_stock', headerName: 'Cantidad stock', width: 120, type: 'rightAligned',
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
    { field: 'valorizacion_producto_metodo_valorizacion', headerName: 'Metodo valorizado', width: 130, filter: true
    },
    { field: 'valorizacion_producto_estado', headerName: 'Estado', width: 100, filter: true,
      headerClass:'centrarencabezado',
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>`;
        } else if (params.value === 'Inactivo') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>`;
        }
        return params.value;
      },
      cellStyle: {
        textAlign: 'center',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      }
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

  constructor() {}

  ngOnInit() {
    this.catalogosFacade.inicializarCatalogos();
    
    // Cargar reporte de valorización desde el store
    this.cargarReporteValorizacion();
  }

  /**
   * Cargar reporte de valorización desde el store usando el facade
   */
  cargarReporteValorizacion() {
    console.log('Cargando reporte de valorización desde el store...');
    this.almacenFacade.cargarReporteValorizacion();
  }

  onBtReset() {
    this.cargarReporteValorizacion();
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
  // Para modo SINGLE - Manejo de fecha seleccionada
  filtradoUnico(date: Date) {
    console.log('Fecha:', date);
    this.selectedDate = date;
  }
}
