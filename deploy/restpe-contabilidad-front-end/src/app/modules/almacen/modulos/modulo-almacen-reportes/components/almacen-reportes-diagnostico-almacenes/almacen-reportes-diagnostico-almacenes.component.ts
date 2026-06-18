import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import { Component, OnInit, inject } from '@angular/core';
import { ViewWillEnter } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent, ValueFormatterParams } from 'ag-grid-community';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

// Facade
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';

@Component({
  selector: 'app-almacen-reportes-diagnostico-almacenes',
  templateUrl: './almacen-reportes-diagnostico-almacenes.component.html',
  styleUrls: ['./almacen-reportes-diagnostico-almacenes.component.scss'],
  standalone: false,
})
export class AlmacenReportesDiagnosticoAlmacenesComponent implements OnInit, ViewWillEnter {
  // Facades
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Selectores del store
  protected readonly almacenFacade = inject(AlmacenFacade);
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.isLoading;


  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'almacen-reportes-diagnostico-almacenes'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }



  // Formateador de números con comas
  numberFormatter = (params: ValueFormatterParams) => {
    if (params.value == null) return '';
    return params.value.toLocaleString('en-US', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    });
  };

  // Formateador de porcentajes
  percentFormatter = (params: ValueFormatterParams) => {
    if (params.value == null) return '';
    return params.value.toLocaleString('en-US', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    }) + '%';
  };

  colDefs: ColDef[] = [
    {  field: 'diagnostico_codigo',  headerName: 'Código', width: 80,},
    {  field: 'diagnostico_almacen',  headerName: 'Almacén', flex:1, minWidth: 130, filter: true},
    {  field: 'diagnostico_ubicacion',  headerName: 'Ubicación', width: 140, filter: true},
    {  field: 'diagnostico_responsable',  headerName: 'Responsable', width: 140, filter: true},
    {  field: 'diagnostico_valor_inventario',  headerName: 'Valor inventario', headerClass: 'derechaencabezado', width: 115, type: 'rightAligned',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right',},
      valueFormatter: this.numberFormatter
    },
    { field: 'diagnostico_ocupacion', headerName: 'Ocupación (%)',headerClass: 'derechaencabezado',width: 100,type: 'rightAligned',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right'},
      valueFormatter: this.percentFormatter
    },
    { field: 'diagnostico_rotacion_inventario', headerName: 'Rotación de inventario',headerClass: 'derechaencabezado',width: 140,type: 'rightAligned',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right',},
      valueFormatter: this.numberFormatter
    },
    { field: 'diagnostico_dias_promedio_inventario', headerName: 'Días promedio inventario',headerClass: 'derechaencabezado',width: 150,type: 'rightAligned',
      cellStyle: {textAlign: 'right',display: 'flex',justifyContent: 'right'},
      valueFormatter: this.numberFormatter
    },
    { field: 'diagnostico_baja_rotacion', headerName: 'Baja rotación (%)',headerClass: 'derechaencabezado',width: 120,filter: true,   
      type: 'rightAligned',
      cellStyle: {textAlign: 'right',display: 'flex',justifyContent: 'right',},
      valueFormatter: this.percentFormatter
    },
    { field: 'diagnostico_costo_almacenamiento', headerName: 'Costo promedio almacen',headerClass: 'derechaencabezado',width: 160,
      type: 'rightAligned',
      cellStyle: {textAlign: 'right',display: 'flex',justifyContent: 'right',},
      valueFormatter: this.numberFormatter
    },
    { field: 'diagnostico_ultimo_cambio', headerName: 'Últimos cambios',width: 120},
    { headerClass: 'centrarencabezado',field: 'diagnostico_condicion', headerName: 'Condición',width: 100,filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Óptima') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Óptima</span>`;
        } else if (params.value === 'Regular') {
          return `<span class="badge-table bg-[#FFDECC] text-[#FF8947]">Regular</span>`;
        } else if (params.value === 'Crítica') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Crítica</span>`;
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
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate()); 
  }

  ngOnInit() {
    this.catalogosFacade.inicializarCatalogos();
  }

  ionViewWillEnter() {
    this.almacenFacade.cargarReporteDiagnosticoAlmacenes();
  }

  onBtReset() {
    this.almacenFacade.cargarReporteDiagnosticoAlmacenes();
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
