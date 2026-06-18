import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ViewWillEnter } from '@ionic/angular';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faImage, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

// Facade
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';

@Component({
  selector: 'app-almacen-consultas-articulo',
  templateUrl: './almacen-consultas-articulo.component.html',
  styleUrls: ['./almacen-consultas-articulo.component.scss'],
  standalone: false,
})
export class AlmacenConsultasArticuloComponent implements OnInit, ViewWillEnter {
  // Facades
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.isLoading;
  protected readonly facade = this.almacenFacade;

  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasImage = faImage;
  fasRotateRight = faRotateRight;


  selectedArticulo: any = null;

  onCellClicked(event: any) {
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    if (event && event.node) {
      event.node.setSelected(true);
      this.selectedArticulo = event.data;
    }
  }

     //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'almacen-consultas-articulo'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }
  informacionForm!: FormGroup;

  numberFormatter = (params: any) => {
    if (params.value == null) return '';
    return params.value.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
  };

  colDefs: ColDef[] = [
    { field: 'articulo_codigo', headerName: 'Codigo', width: 150, sortable: true},
    { field: 'articulo_nombre', headerName: 'Nombre', width: 150, sortable: true},
    { field: 'articulo_codigo_barras', headerName: 'Código de barras', width: 110, sortable: true,},
    { field: 'articulo_medida', headerName: 'Medida', width: 80, sortable: true,},
    { field: 'articulo_categoria', headerName: 'Categoría', width: 100, sortable: true, filter: true},
    { field: 'articulo_stock_actual', headerName: 'Stock actual', width: 110, sortable: true, type: 'rightAligned', valueFormatter: this.numberFormatter, cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center',},},
    { field: 'articulo_precio_venta', headerName: 'Precio venta', width: 110, sortable: true, type: 'rightAligned', valueFormatter: this.numberFormatter, cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center',},},
    { field: 'articulo_estado', headerName: 'Estado', headerClass: 'centrarencabezado', width: 80, sortable: true, filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', },
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>`;
        } else if (params.value === 'Inactivo') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>`;
        }
        return params.value;
      }
    },
  ];

  rowData: any[] = [];

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

  constructor(private fb: FormBuilder) { 
     const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  ngOnInit() {
    this.catalogosFacade.inicializarCatalogos();
    this.informacionForm = this.fb.group({
      nombreProducto: new FormControl('')
    });
  }

  ionViewWillEnter() {
    this.almacenFacade.cargarConsultaArticulos();
  }

  onBtReset() {
    this.almacenFacade.cargarConsultaArticulos();
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

  formatearFecha(fecha: string | Date | undefined): string {
    if (!fecha) return '-';
    
    const date = typeof fecha === 'string' ? new Date(fecha) : fecha;
    const dia = String(date.getDate()).padStart(2, '0');
    const mes = String(date.getMonth() + 1).padStart(2, '0');
    const anio = date.getFullYear();
    
    return `${dia}/${mes}/${anio}`;
  }

}
