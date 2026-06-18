import { Component, OnInit, inject } from '@angular/core';
import { ViewWillEnter } from '@ionic/angular';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import {


  ColDef,
  GridApi,
  GridReadyEvent,
  ValueFormatterParams,
} from 'ag-grid-enterprise';

// Facade
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
@Component({
  selector: 'app-almacen-consultas-kardex',
  templateUrl: './almacen-consultas-kardex.component.html',
  styleUrls: ['./almacen-consultas-kardex.component.scss'],
  standalone: false,
})
export class AlmacenConsultasKardexComponent implements OnInit, ViewWillEnter {
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
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'kardex'); }
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
    {
      field: 'kardex_codigo',
      headerName: 'Codigo',
      width: 80,
      sortable: true,
    },
    {
      field: 'kardex_nombre',
      headerName: 'Nombre',
      flex: 1, minWidth: 200,
      sortable: true,
    },
    {
      field: 'kardex_categoria',
      headerName: 'Categoría',
      flex: 1, minWidth: 140,
      sortable: true,
      filter: true,
    },
    {
      field: 'kardex_medida',
      headerName: 'Medida',
      width: 100,
      sortable: true,
    },
    {
      field: 'kardex_almacen',
      headerName: 'Almacén',
      flex: 1, minWidth: 160,
      sortable: true,
      filter: true,
    },
    {
      field: 'kardex_stock_inicial',
      headerName: 'Stock inicial',
      width: 120,
      headerClass: 'derechaencabezado', 
      sortable: true,
      cellStyle: {
        justifyContent: 'end',
      },
      type: 'rightAligned',
      valueFormatter: this.numberFormatter,
    },
    {
      field: 'kardex_ingresos',
      headerName: 'Ingresos',
      width: 110,
      headerClass: 'derechaencabezado', 
      sortable: true,
      type: 'rightAligned',
      cellStyle: (params) => {
        const style: any = { justifyContent: 'end', };
        if (params.value < 0) {
          style.color = '#EF4444'; // Rojo para negativos
        }
        return style;
      },
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
    },
    {
      field: 'kardex_salidas',
      headerName: 'Salidas',
      width: 110,
      headerClass: 'derechaencabezado', 
      sortable: true,
      type: 'rightAligned',
      cellStyle: (params) => {
        const style: any = { justifyContent: 'end', };
        if (params.value < 0) {
          style.color = '#EF4444'; // Rojo para negativos
        }
        return style;
      },
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
    },
    {
      field: 'kardex_stock_final',
      headerName: 'Stock final',
      width: 120,
      headerClass: 'derechaencabezado', 
      sortable: true,
      cellStyle: {
        justifyContent: 'end',
      },
      type: 'rightAligned',
      valueFormatter: this.numberFormatter,
    },
    {
      field: 'kardex_costo_promedio',
      headerName: 'Costo promedio',
      width: 120,
      headerClass: 'derechaencabezado', 
      sortable: true,
      cellStyle: {
        justifyContent: 'end',
      },
      type: 'rightAligned',
      valueFormatter: this.numberFormatter,
    },
    {
      field: 'kardex_valor_total',
      headerName: 'Valor total',
      width: 130,
      headerClass: 'derechaencabezado', 
      sortable: true,
      cellStyle: {
        justifyContent: 'end',
      },
      type: 'rightAligned',
      valueFormatter: this.numberFormatter,
    },
    {
      field: 'kardex_fecha_movimiento',
      headerName: 'Fecha de movimiento',
      width: 130,
      sortable: true,
    },
    {
      field: 'kardex_tipo_movimiento',
      headerName: 'Tipo de movimiento',
      width: 130,
      sortable: true,
      filter: true,
    },
    {
      field: 'doc',
      headerName: 'Documento',
      width: 80,
      sortable: false,
      cellRenderer: () => {
        return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="8" height="8" fill="currentColor" style="cursor: pointer; color: #3b82f6;">
            <path d="M320 0c-17.7 0-32 14.3-32 32s14.3 32 32 32h82.7L201.4 265.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L448 109.3V192c0 17.7 14.3 32 32 32s32-14.3 32-32V32c0-17.7-14.3-32-32-32H320zM80 32C35.8 32 0 67.8 0 112V432c0 44.2 35.8 80 80 80H400c44.2 0 80-35.8 80-80V320c0-17.7-14.3-32-32-32s-32 14.3-32 32V432c0 8.8-7.2 16-16 16H80c-8.8 0-16-7.2-16-16V112c0-8.8 7.2-16 16-16H192c17.7 0 32-14.3 32-32s-14.3-32-32-32H80z"/>
          </svg>`;
      },
      headerClass: 'centrarencabezado',
      cellStyle: {
        justifyContent: 'center',
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
    this.maxDate = today;
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );
  }

  ngOnInit() {
    this.catalogosFacade.inicializarCatalogos();
  }

  ionViewWillEnter() {
    this.almacenFacade.cargarConsultaKardex();
  }

  onBtReset() {
    this.almacenFacade.cargarConsultaKardex();
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
