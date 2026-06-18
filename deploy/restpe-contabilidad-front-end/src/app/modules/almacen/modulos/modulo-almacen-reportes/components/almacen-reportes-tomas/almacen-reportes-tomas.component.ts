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
import { TomaInventarioEntity } from '../../../../domain/models/toma-inventario.entity';





@Component({
  selector: 'app-almacen-reportes-tomas',
  templateUrl: './almacen-reportes-tomas.component.html',
  styleUrls: ['./almacen-reportes-tomas.component.scss'],
  standalone: false,
})
export class AlmacenReportesTomasComponent implements OnInit {
  // Facades
  protected readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;

  readonly isLoading = this.almacenFacade.loadingReporteTomas;


  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'almacen-reportes-tomas'); }
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
    { field: 'toma_inventario_codigo', headerName: 'Código', width: 80, },
    { field: 'toma_inventario_producto', headerName: 'Producto', minWidth: 100, flex: 1, },
    { field: 'toma_inventario_observacion', headerName: 'Observación', minWidth: 120, flex: 1, },
    { field: 'toma_inventario_categoria', headerName: 'Categoría', width: 100, filter: true },
    { field: 'toma_inventario_medida', headerName: 'Medida', width: 80, },
    {
      field: 'toma_inventario_stock_fisico', headerName: 'Stock físico', headerClass: 'derechaencabezado', width: 90, type: 'rightAligned',
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
      },
      valueFormatter: this.numberFormatter
    },
    {
      field: 'toma_inventario_stock_sistema', headerName: 'Stock del sistema', headerClass: 'derechaencabezado', width: 120, type: 'rightAligned',
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
      },
      valueFormatter: this.numberFormatter
    },
    {
      field: 'toma_inventario_diferencia', headerName: 'Diferencia (Cantidad)', headerClass: 'derechaencabezado', width: 160, type: 'rightAligned',
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
      },
    },
    {
      field: 'toma_inventario_diferencia_valor', headerName: 'Diferencia en valor', headerClass: 'derechaencabezado', width: 120, type: 'rightAligned',
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
      },
      valueFormatter: this.numberFormatter
    },
    { field: 'toma_inventario_tipo_diferencia', headerName: 'Tipo de diferencia', width: 120, filter: true },
    { field: 'toma_inventario_almacen', headerName: 'Almacén', width: 150, filter: true },
    { field: 'toma_inventario_persona_responsable', headerName: 'Persona responsable', width: 160, filter: true },
    { field: 'toma_inventario_ultimo_cambio', headerName: 'Últimos cambio', width: 100, },
    {
      headerClass: 'centrarencabezado', field: 'toma_inventario_condicion', headerName: 'Condición', width: 90, filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Aprobado') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Aprobado</span>`;
        } else if (params.value === 'Pendiente') {
          return `<span class="badge-table bg-text-5 text-text'85">Pendiente</span>`;
        } else if (params.value === 'Ajustado') {
          return `<span class="badge-table bg-primary-5 text-primary">Ajustado</span>`;
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
    this.almacenFacade.cargarReporteTomas();
  }

  onBtReset() {
    if (this.gridApi) {
      this.almacenFacade.cargarReporteTomas();
    }
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
