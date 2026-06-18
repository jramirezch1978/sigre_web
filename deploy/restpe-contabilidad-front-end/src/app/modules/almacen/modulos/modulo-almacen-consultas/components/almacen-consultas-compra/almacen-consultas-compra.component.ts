import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ViewWillEnter } from '@ionic/angular';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDollar, faDownload, faHandHoldingDollar, faPerson, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

// Facade
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { PdfExportService } from 'src/app/core/infrastructure/export/pdf-export.service';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
@Component({
  selector: 'app-almacen-consultas-compra',
  templateUrl: './almacen-consultas-compra.component.html',
  styleUrls: ['./almacen-consultas-compra.component.scss'],
  standalone: false,
})
export class AlmacenConsultasCompraComponent implements OnInit, ViewWillEnter {
  // Facades
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);
  private readonly pdfExport = inject(PdfExportService);

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.isLoading;
  protected readonly facade = this.almacenFacade;

  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDollar = faDollar;
  fasDownload = faDownload;
  fasHandHoldingDollar = faHandHoldingDollar;
  fasPerson = faPerson;
  fasRotateRight = faRotateRight;


  selectedOrden: any = null;
  filaSeleccionada: any = null;
  onCellClicked(event: any) {
    this.filaSeleccionada= event.data;
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    if (event && event.node) {
      event.node.setSelected(true);
      this.selectedOrden = event.data;
      // Aquí puedes reflejar los datos en el panel derecho si lo deseas
    }
  }
  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private gridApi!: GridApi;
  private gridApiDetalle!: GridApi;
  informacionForm!: FormGroup;

  // Modo single
  fechaMovimiento: Date | undefined;
  
  numberFormatter = (params: any) => {
    if (params.value == null) return '';
    return params.value.toLocaleString('en-US', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    });
  };

  percentFormatter = (params: any) => {
    if (params.value == null) return '';
    return (
      params.value.toLocaleString('en-US', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
      }) + '%'
    );
  };

  colDefs: ColDef[] = [
    { field: 'orden_compra_codigo', headerName: 'Código', width: 90, sortable: true,},
    { field: 'orden_compra_fecha_emision', headerName: 'Fecha emisión', width: 100, sortable: true,},
    { field: 'orden_compra_fecha_entrega', headerName: 'Fecha entrega', width: 100, sortable: true,},
    { field: 'orden_compra_proveedor', headerName: 'Proveedor', flex: 1, minWidth: 200, sortable: true, filter: true,},
    { field: 'orden_compra_almacen', headerName: 'Almacén', flex: 1, minWidth: 160, sortable: true, filter: true,},
    { field: 'orden_compra_monto_total', headerName: 'Monto total', width: 110, sortable: true,
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
      type: 'rightAligned',
    },
    { field: 'orden_compra_ejecucion', headerName: 'Ejecución', width: 90, sortable: true, type: 'rightAligned',
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
        return style;
      }
    },
    { field: 'orden_compra_estado', headerName: 'Estado', headerClass: 'centrarencabezado', width: 100, sortable: true, filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', },
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return `<span class="badge-table bg-[#F5F5F5] text-[#363636]">Pendiente</span>`;
        } else if (params.value === 'Parcial') {
          return `<span class="badge-table bg-[#FEF3C7] text-[#F59E0B]">Parcial</span>`;
        } else if (params.value === 'Por facturar') {
          return `<span class="badge-table bg-[#FFDECC] text-[#FF8947]">Por facturar</span>`;
        }
        return params.value;
      },
    },
  ];

  colDefsDetalle: ColDef[] = [
    {
      field: 'producto',
      headerName: 'Producto',
      width: 150,
      sortable: true,
    },
    {
      field: 'solicitada',
      headerName: 'Solicitada',
      width: 100,
      sortable: true,
      type: 'rightAligned',
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
    {
      field: 'recibida',
      headerName: 'Recibida',
      width: 100,
      sortable: true,
      type: 'rightAligned',
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
    {
      field: 'pendiente',
      headerName: 'Pendiente',
      width: 100,
      sortable: true,
      type: 'rightAligned',
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

  rowData: any[] = [];
  rowDataDetalle: any[] = [];

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
    this.informacionForm = this.fb.group({
      nombreProducto: new FormControl(''),
    });
  }

  ionViewWillEnter() {
    this.almacenFacade.cargarConsultaOrdenesCompra();
  }

  onBtReset() {
    this.almacenFacade.cargarConsultaOrdenesCompra();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApiDetalle = params.api;
  }

  /** Exporta la lista de órdenes de compra a Excel (ag-grid-enterprise). */
  exportarExcel() {
    // El grid se alimenta del signal facade.consultaOrdenesCompra(), no de this.rowData,
    // por eso se exporta directo del gridApi (que ya tiene las filas del binding).
    if (!this.gridApi) {
      return;
    }
    this.gridApi.exportDataAsExcel({ fileName: 'ordenes-compra.xlsx', sheetName: 'Ordenes de compra' });
  }

  /**
   * PDF: usa el servicio transversal del proyecto (PdfExportService).
   * No hay reporte Jasper dedicado para esta consulta, así que se imprime la
   * vista (el navegador permite "Guardar como PDF"). Sin dependencias nuevas.
   */
  exportarPdf() {
    this.pdfExport.printCurrentPage();
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
  
    onfechaMovimiento(fecha: Date) {
    this.fechaMovimiento = fecha;
  }
}
