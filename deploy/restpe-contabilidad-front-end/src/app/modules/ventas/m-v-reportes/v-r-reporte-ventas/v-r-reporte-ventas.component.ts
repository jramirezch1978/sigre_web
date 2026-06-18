import { Component, OnInit, inject, effect } from '@angular/core';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { EntradaSalidaCellRendererComponent } from 'src/app/ui/entrada-salida-cell-renderer/entrada-salida-cell-renderer.component';
import { AccionesVerDescImpComponent } from 'src/app/ui/acciones-ver-desc-imp/acciones-ver-desc-imp.component';
import { ReporteVentasFacade } from '../../application/facades/reporte-ventas.facade';
import { ReporteVentasFeedbackEffects } from '../../effects/reporte-ventas-feedback.effect';
import { ReporteVentasEntity } from '../../domain/models/reporte-ventas.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faDollarSign, faChartLine, faPercent, faFileInvoice, faExclamationCircle, faRotateRight, faDownload } from '@fortawesome/pro-solid-svg-icons';



export interface card{
  title: string,
  cantidad: string,
  icon: string,
}

export interface registro{
  formato:string,
  fecha: string,
  total: string,
  archivo: string,
  usuario: string
}

@Component({
  selector: 'app-v-r-reporte-ventas',
  templateUrl: './v-r-reporte-ventas.component.html',
  styleUrls: ['./v-r-reporte-ventas.component.scss'],
  standalone: false,
})
export class VRReporteVentasComponent  implements OnInit {

  // ── Inyecciones ─────────────────────────────────────────────────────────────
  readonly reporteFacade = inject(ReporteVentasFacade);
  private readonly _feedbackEffects = inject(ReporteVentasFeedbackEffects);

  // ── Signals expuestos al template ────────────────────────────────────────────
  readonly isLoading = this.reporteFacade.isLoading;

  // Font Awesome Icons
  fasChartLine = faChartLine;
  fasDollarSign = faDollarSign;
  fasExclamationCircle = faExclamationCircle;
  fasFileInvoice = faFileInvoice;
  fasPercent = faPercent;
  fasRotateRight = faRotateRight;
  fasDownload = faDownload;
  farSearch = faSearch;




  private gridApi!: GridApi;

  estadoSeleccionado: string= 'todos';
  canalSeleccionado: string= 'todos';
  turnoSeleccionado: string= 'todos';
  cajaSeleccionada: string= 'todos';
  tipoSeleccionado: string= '';

  filasGeneradas: ReporteVentasEntity[] = [];
  reporteGenerado: boolean = false;

  countries= ALL_COUNTRIES;
  entidad: string='';
  simboloMoneda: string='S/';

  cajas=[
    { label: 'Todas las cajas', value: 'todos' },
    { label: 'Caja principal', value: 'caja1' },
    { label: 'Caja segundo piso', value: 'caja2' },
    { label: 'Caja terraza', value: 'caja3' },
  ];
  canales=[
    { label: 'Todos los canales', value: 'todos' },
    { label: 'Por salón', value: 'salon' },
    { label: 'Por venta rápida', value: 'ventar' },
    { label: 'Por delivery', value: 'delivery' },
    { label: 'Por reservación', value: 'reserva' },
  ];
  turnos=[
    { label: 'Todos los turnos', value: 'todos' },
    { label: 'Turno día', value: 'dia' },
    { label: 'Turno noche', value: 'noche' },
  ];
  estados=[
    { label: 'Todos los estados', value: 'todos' },
    { label: 'Activos', value: 'activos' },
    { label: 'Anulado', value: 'anulado' },
  ];
  comprobantes=[
    { label: 'Boleta', value: 'boleta' },
    { label: 'Factura', value: 'factura' },
    { label: 'Nota de venta', value: 'nventa' },
  ];

  // Configuración de ag-grid
  columnTypes = {};

  gridOptions = {
    context: {
      componentParent: this,
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
    noRowsToShow: 'No hay datos para mostrar'
  };
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };




  columnDefs: ColDef<ReporteVentasEntity>[] = [
    { field: 'rventas_fecha_ht', headerName: 'Fecha', width: 120, cellRenderer: EntradaSalidaCellRendererComponent },
    { field: 'rventas_mesa', headerName: 'Mesa', width: 80},
    { field: 'rventas_caja', headerName: 'Caja', width: 80},
    { field: 'rventas_cliente', headerName: 'Cliente', width: 160},
    { field: 'rventas_documento', headerName: 'Documento', width: 140 },
    { field: 'rventas_numero_documento', headerName: 'N° documento', width: 140 },
    { field: 'rventas_pagos', headerName: 'Pagos', width: 140, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center',},
      cellRenderer: (params: any) => {
        return `<span><span class="font-bold">Efectivo </span>${this.simboloMoneda} ${params.value}</span>`;
      }
     },
    { headerName: 'Total venta', width: 120, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center',},
      cellRenderer: (params: any) => {
        const pagos = params.data?.rventas_pagos ?? '0.00';
        const propina = params.data?.rventas_propina ?? '0.00';

        return `
          <div class="text-right leading-tight">
            <span class="font-bold">
              ${this.simboloMoneda} ${pagos}
            </span><br/>
            <div class="flex items-center gap-1">
              <span class="font-bold"> Propina</span>
              <span class="font-normal"> ${this.simboloMoneda} ${propina} </span>
            </div>
          </div>
        `;
      }
    },
    { field: 'rventas_tipo', headerName: 'Tipo de venta', width: 120,},
    { field: 'rventas_canal', headerName: 'Canal de venta', width: 120,},
    { field: 'rventas_estado', headerName: 'Estado', width: 90, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
        } else if (params.value === 'Anulado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulado</span>';
        }
        return params.value;
      }
    },
    { headerName: 'Acciones', width: 100, headerClass: 'centrarencabezado',
      cellStyle: {
        textAlign: 'center',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
      cellRenderer: AccionesVerDescImpComponent}

  ];


  constructor(
    private countryService: CountryService,
  ) {
    // Sincronizar signal del store con el array del grid
    effect(() => {
      this.filasGeneradas = this.reporteFacade.registros();
    });
  }

  ngOnInit() {}

  onComprobanteSeleccionado(value: any) {
    this.tipoSeleccionado = value;
  }
  onBtReset() {
    this.reporteFacade.cargarReporte();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  generarReporte() {
    this.reporteFacade.cargarReporte();
    this.reporteGenerado = true;
  }

}