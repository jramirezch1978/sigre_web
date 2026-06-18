import { Component, OnInit, inject } from '@angular/core';
import { FormGroup, FormBuilder, FormControl } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { ReportePlanillaEntity } from 'src/app/modules/rrhh/domain/models/reporte-planilla.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';


@Component({
  selector: 'app-cv-reportesdeplanilla',
  templateUrl: './cv-reportesdeplanilla.component.html',
  styleUrls: ['./cv-reportesdeplanilla.component.scss'],
  standalone: false,
})
export class CvReportesdeplanillaComponent implements OnInit {
  // Facade
  private readonly rrHhFacade = inject(RrHhFacade);

  // Selectores del store
  readonly reportesPlanilla = this.rrHhFacade.reportesPlanilla;
  readonly isLoading = this.rrHhFacade.loadingReportesPlanilla;

  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  private gridApi!: GridApi;

  estadoSeleccionado = 'todos';
  periodoSeleccionado = 'mesActual';
  contratoSeleccionado = 'todos';
  sucursalSeleccionada: any = null;
  centrocostoSeleccionado: any = null;

  // Datos para los autocomplete
  sucursales = [
    { id: 1, nombre: 'La Molina, Lima' },
    { id: 2, nombre: 'San Isidro, Lima' },
    { id: 3, nombre: 'San Borja, Lima' },
    { id: 4, nombre: 'Santa Isabel, Piura' },
    { id: 5, nombre: 'CC. Real Plaza, Piura' }
  ];

  centrosCosto = [
    { id: 1, nombre: 'Edificios e instalaciones' },
    { id: 2, nombre: 'Edificios administrativos' },
    { id: 3, nombre: 'Almacenes y bodegas' },
    { id: 4, nombre: 'Equipo de transportes' },
    { id: 5, nombre: 'Maquinaria y equipo' }
  ];

  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  colDefs: ColDef<ReportePlanillaEntity>[] = [
    { field: 'reporte_planilla_numero_documento', headerName: 'N° documento', flex: 1, minWidth: 100 },
    { field: 'reporte_planilla_trabajador', headerName: 'Trabajador', flex: 1.5, minWidth: 121 },
    { field: 'reporte_planilla_periodo', headerName: 'Periodo', flex: 0.5, minWidth: 43, filter: true },
    { field: 'reporte_planilla_contrato', headerName: 'Contrato', flex: 0.8, minWidth: 80, filter: true },
    { field: 'reporte_planilla_sucursal', headerName: 'Sucursal', flex: 1, minWidth: 100, filter: true },
    { field: 'reporte_planilla_centro_costo', headerName: 'Centro de Costo', flex: 1.2, minWidth: 110, filter: true },
    {
      field: 'reporte_planilla_salario_bruto',
      headerName: 'Salario Bruto',
      headerClass: 'derechaencabezado',
      flex: 0.9,
      minWidth: 90,
      cellStyle: {
        textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'end',
      },
    },
    { field: 'reporte_planilla_aumentos', headerName: 'Total de aumentos', flex: 1.2, minWidth: 110, headerClass:'derechaencabezado', filter: true,
      cellStyle: {
        textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'end',
      },
     },
    {
      field: 'reporte_planilla_descuentos_totales',
      headerName: 'Total de descuentos',
      headerClass: 'derechaencabezado',
      flex: 1,
      minWidth: 95,
      cellStyle: {
        textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'end',
      },
    },
    {
      field: 'reporte_planilla_neto_a_pagar',
      headerName: 'Neto a pagar',
      headerClass: 'derechaencabezado',
      flex: 0.9,
      minWidth: 85,
      cellStyle: {
        fontWeight: 'bold',
        textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'end',
      },
    },
    { 
      field: 'reporte_planilla_adelantos', 
      headerName: 'Adelantos', 
      headerClass: 'derechaencabezado',
      flex: 0.8,
      minWidth: 80,
      cellStyle: {
        textAlign: 'end',
        display: 'flex',
        justifyContent: 'end',
        alignItems: 'end',
      },
    },
    // { 
    //   field: 'reporte_planilla_saldo_cta_cte', 
    //   headerName: 'Saldo cta. cte.', 
    //   headerClass: 'derechaencabezado',
    //   flex: 1,
    //   minWidth: 95,
    //   cellStyle: (params: any) => {
    //     const valor = params.value.replace(/[^\d.-]/g, '');
    //     const esNegativo = parseFloat(valor) < 0;
    //     return {
    //       textAlign: 'end',
    //       display: 'flex',
    //       justifyContent: 'end',
    //       alignItems: 'end',
    //       ...(esNegativo && { color: '#EF4444', fontWeight: 'bold', })
    //     };
    //   },
    // },
    { field: 'reporte_planilla_ultima_modificacion', headerName: 'Últ. modif.', flex: 0.9, minWidth: 85 },
    {
      field: 'reporte_planilla_estado',
      headerName: 'Estado',
      headerClass: 'centrarencabezado',
      flex: 0.8,
      minWidth: 80,
      filter: true,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';

        switch (estado) {
          case 'Pendiente':
            badgeClass = 'bg-[#F5F5F5] text-[#363636]';
            break;
          case 'Pagado':
            badgeClass = 'bg-[#DCFDE7] text-[#16A34A]';
            break;
          case 'En revisión':
            badgeClass = 'bg-[#FFDECC] text-[#FF8947]';
            break;
          default:
            badgeClass = 'bg-gray-100 text-gray-600';
        }

        return `<span class="badge-table ${badgeClass}">${estado}</span>`;
      },
      cellStyle: {
        textAlign: 'center',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    },
  ];

  rowData: ReportePlanillaEntity[] = [];

  defaultColDef = {
    sortable: false,
    filter: false,
    resizable: false,
  };

  rowSelection: 'single' | 'multiple' = 'single';

  columnTypes = {
    numberColumn: { filter: false },
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

  constructor(
    private countryService: CountryService,
  ) {
    const today = new Date();
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );
    this.maxDate = today;
  }

  ngOnInit() {
    this.rrHhFacade.cargarReportesPlanilla();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.rowData = [...this.reportesPlanilla()];
      }
    }, 100);
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
  onBtReset() {
    this.rrHhFacade.cargarReportesPlanilla();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.rowData = [...this.reportesPlanilla()];
      }
    }, 100);
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }

  onSucursalSeleccionada(sucursal: any) {
    this.sucursalSeleccionada = sucursal;
    console.log('Sucursal seleccionada:', sucursal);
    // Lógica para filtrar por sucursal
  }

  onCentroCostoSeleccionado(centroCosto: any) {
    this.centrocostoSeleccionado = centroCosto;
    console.log('Centro de costo seleccionado:', centroCosto);
    // Lógica para filtrar por centro de costo
  }

  onRowClicked(event: any) {
    console.log('Fila seleccionada:', event.data);
    // Aquí puedes agregar lógica adicional cuando se seleccione una fila
  }
}
