import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ViewWillEnter } from '@ionic/angular';

// Font Awesome Icons
import { faCalendar, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCheck, faDollar, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

// Facade
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';



@Component({
  selector: 'app-almacen-consultas-prestamos',
  templateUrl: './almacen-consultas-prestamos.component.html',
  styleUrls: ['./almacen-consultas-prestamos.component.scss'],
  standalone: false,
})
export class AlmacenConsultasPrestamosComponent implements OnInit, ViewWillEnter {
  // Facades
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  protected readonly facade = this.almacenFacade;

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.isLoading;

  // Font Awesome Icons
  farCalendar = faCalendar;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCheck = faCheck;
  fasDollar = faDollar;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'almacen-consultas-prestamos'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }
  informacionForm!: FormGroup;

  numberFormatter = (params: any) => {
    if (params.value == null) return '';
    return params.value.toLocaleString('en-US', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    });
  };

  colDefs: ColDef[] = [
    { field: 'prestamo_codigo', headerName: 'Código', width: 90, sortable: true,},
    { field: 'prestamo_usuario_responsable', headerName: 'Usuario responsable', width: 160, sortable: true,},
    { field: 'prestamo_producto', headerName: 'Producto', width: 180, sortable: true,},
    { field: 'prestamo_fecha_entrega', headerName: 'Fecha entrega', width: 100, sortable: true,},
    { field: 'prestamo_almacen_origen', headerName: 'Almacén origen', width: 130, sortable: true, filter: true,},
    { field: 'prestamo_almacen_destino', headerName: 'Almacén destino', width: 130, sortable: true, filter: true,},
    { field: 'prestamo_medida', headerName: 'Medida', width: 80, sortable: true,},
    {
      field: 'prestamo_cantidad_entregada',
      headerName: 'Cantidad entregada',
      width: 120,
      sortable: true,
      headerClass: 'derechaencabezado',
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
      }
    },
    {
      field: 'prestamo_cantidad_devuelta',
      headerName: 'Cantidad devuelta',
      width: 120,
      sortable: true,
      headerClass: 'derechaencabezado',
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
      }
    },
    {
      field: 'prestamo_saldo_pendiente',
      headerName: 'Saldo pendiente',
      width: 120,
      sortable: true,
      headerClass: 'derechaencabezado',
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
      }
    },
    {
      field: 'prestamo_estado',
      headerName: 'Estado',
      width: 100,
      sortable: true,
      headerClass: 'centrarencabezado',
      filter: true,
      cellStyle: {
        justifyContent: 'center',
      },
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>`;
        } else if (params.value === 'Parcial') {
          return `<span class="badge-table bg-[#FEF3C7] text-[#D97706]">Parcial</span>`;
        } else if (params.value === 'Retornado') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Retornado</span>`;
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
    this.informacionForm = this.fb.group({
      nombreProducto: new FormControl(''),
    });
  }

  ionViewWillEnter() {
    this.almacenFacade.cargarConsultaPrestamos();
  }
  onBtReset() {
    this.almacenFacade.cargarConsultaPrestamos();
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
