import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import { Component, OnInit, inject } from '@angular/core';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import {
  ColDef,
  GridApi,
  GridReadyEvent,
  ValueFormatterParams,
} from 'ag-grid-community';

// Facade
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
import { AlmacenEntity } from '../../../../domain/models/almacen.entity';
import { HistorialVencimientoEntity } from '../../../../domain/models/historial-vencimiento.entity';

@Component({
  selector: 'app-almacen-reportes-historial-vencimiento',
  templateUrl: './almacen-reportes-historial-vencimiento.component.html',
  styleUrls: ['./almacen-reportes-historial-vencimiento.component.scss'],
  standalone: false,
})
export class AlmacenReportesHistorialVencimientoComponent implements OnInit {
  // Facades
  protected readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.isLoading;


  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  startDate: Date | undefined;
  endDate: Date | undefined;
  selectedDate: Date | undefined;
  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'almacen-reportes-historial-vencimiento'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }

  // Formateador de números con comas
  numberFormatter = (params: ValueFormatterParams) => {
    if (params.value == null) return '';
    return params.value.toLocaleString('en-US', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    });
  };

  colDefs: ColDef[] = [
    { field: 'historial_vencimiento_fecha_registro', headerName: 'Fecha registro', width: 110,},
    { field: 'historial_vencimiento_codigo', headerName: 'Código de producto', width: 125,},
    { field: 'historial_vencimiento_producto', headerName: 'Producto', minWidth: 200, flex: 1,},
    { field: 'historial_vencimiento_unidad_medida', headerName: 'Unidad de medida', width: 130, filter: true,},
    { field: 'historial_vencimiento_categoria', headerName: 'Categoría', width: 130, filter: true,},
    { field: 'historial_vencimiento_almacen', headerName: 'Almacén', width: 150, filter: true,},
    { field: 'historial_vencimiento_tipo_movimiento', headerName: 'Tipo movimiento', width: 120, filter: true,},
    { field: 'historial_vencimiento_documento_origen', headerName: 'Documento origen', width: 130, filter: true,},
    { field: 'historial_vencimiento_entrada_salida', headerName: 'Entrada / Salida', width: 140, type: 'rightAligned', 
      valueFormatter: (params) => {   
        if (params.value !== null && params.value !== undefined) {     const absValue = Math.abs(params.value);     const formattedValue = new Intl.NumberFormat('es-PE', {
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
          style.color = '#EF4444'; // Rojo para salidas (negativos)
        } else if (params.value > 0) {
          style.color = '#16A34A'; // Verde para entradas (positivos)
        }
        return style;
      },
    },
    { field: 'historial_vencimiento_saldo_final', headerName: 'Saldo final', width: 120, type: 'rightAligned',
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
    { field: 'historial_vencimiento_costo_unitario', headerName: 'Costo unitario', width: 130, type: 'rightAligned',
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
    { field: 'historial_vencimiento_costo_total_movimiento', headerName: 'Costo total movimiento', width: 180, type: 'rightAligned',
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
    { field: 'historial_vencimiento_costo_promedio', headerName: 'Costo promedio', width: 130, type: 'rightAligned',
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

  constructor() {
    const today = new Date();
    this.startDate = new Date(today.getFullYear(), today.getMonth(), 1);
    this.endDate = today;
  }

  ngOnInit() {
    this.catalogosFacade.inicializarCatalogos();
    this.almacenFacade.cargarReporteHistorialVencimiento();
  }

  onBtReset() {
    this.almacenFacade.cargarReporteHistorialVencimiento();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  // Para modo SINGLE - Manejo de fecha seleccionada
  filtradoUnico(date: Date) {
    console.log('Fecha:', date);
    this.selectedDate = date;
  }
  cargarDatos(start: Date, end: Date) {
    // Recargar datos desde el facade
    this.almacenFacade.cargarReporteHistorialVencimiento();
  }
}
