import { Component, OnInit, inject, effect, computed } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { SingleSelectFilterComponent } from 'src/app/modules/activos/m-af-reporte/pages/af-r-resumenactivofijo/single-select-filter.component';
import { ReporteComprasFacade } from 'src/app/modules/compras/application/facades/reporte-compras.facade';
import { CompraProcesadaEntity } from 'src/app/modules/compras/domain/models/compra-procesada.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

type ICompraProceada = CompraProcesadaEntity;

@Component({
  selector: 'app-compras-reportes-reporte-de-compras',
  templateUrl: './compras-reportes-reporte-de-compras.component.html',
  styleUrls: ['./compras-reportes-reporte-de-compras.component.scss'],
  standalone: false,
})
export class ComprasReportesReporteDeComprasComponent  implements OnInit {
  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  faRotateRight= faRotateRight;

  // Clean Architecture - Facade
  private readonly reporteFacade = inject(ReporteComprasFacade);

  // Señal de loading expuesta al template
  readonly loading = this.reporteFacade.loading;



     //RANGO DE FECHAS
      startDate: Date | undefined;
      endDate: Date | undefined;
      minDate: Date;
      maxDate: Date;

  private gridApi!: GridApi;

  colDefs: ColDef<ICompraProceada>[] = [
    { field: 'compra_procesada_nro_documento', headerName: 'Nº documento', flex: 1, minWidth: 90 },
    { field: 'compra_procesada_fecha_emision', headerName: 'Fecha de emisión', flex: 1, minWidth: 90 },
    { field: 'compra_procesada_ruc_nit', headerName: 'Documento fiscal', flex: 1, minWidth: 90 },
    { field: 'compra_procesada_proveedor', headerName: 'Razón social', filter: true, flex: 1, minWidth: 90 },
    { field: 'compra_procesada_sucursal', headerName: 'Sucursal', flex: 1, filter:true, minWidth: 90 },
    { field: 'compra_procesada_centro_costo', headerName: 'Centro de costo', filter:true ,flex: 1, minWidth: 90 },
    { field: 'compra_procesada_tipo_documento', headerName: 'Tipo documento', flex: 1, filter:true, minWidth: 90 },
    { field: 'compra_procesada_comprobante', headerName: 'Comprobante', flex: 1, minWidth: 90 },
    { field: 'compra_procesada_fecha_registro', headerName: 'Fecha de registro', flex: 1, minWidth: 90 },
    { field: 'compra_procesada_moneda', headerName: 'Moneda', flex: 1, minWidth: 90, filter: SingleSelectFilterComponent},
    { field: 'compra_procesada_base_imponible', headerName: 'Base imponible', width: 100, headerClass: 'derechaencabezado', valueFormatter: (params) => params.value != null ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '', cellStyle: { justifyContent: 'end' }},
    { field: 'compra_procesada_valor_inafecto', headerName: 'Valor inafecto', width: 100, headerClass: 'derechaencabezado', valueFormatter: (params) => params.value != null ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '', cellStyle: { justifyContent: 'end' }},
    { field: 'compra_procesada_valor_adq_no_gravadas', headerName: 'Valor adq. no gravadas', width: 110, headerClass: 'derechaencabezado', valueFormatter: (params) => params.value != null ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '', cellStyle: { justifyContent: 'end' }},
    { field: 'compra_procesada_igv', headerName: 'IGV', width: 80, headerClass: 'derechaencabezado', valueFormatter: (params) => params.value != null ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '', cellStyle: { justifyContent: 'end' }},
    { field: 'compra_procesada_icbper', headerName: 'Otros gastos ICBPER', width: 120, headerClass: 'derechaencabezado', valueFormatter: (params) => params.value != null ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(params.value) : '', cellStyle: { justifyContent: 'end' }},
    {  field: 'compra_procesada_monto_total',  headerName: 'Importe total',  width: 100, headerClass: 'derechaencabezado',
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
    { field: 'compra_procesada_tipo_cambio', headerName: 'Tipo de cambio', width: 100, headerClass: 'derechaencabezado', valueFormatter: (params) => params.value != null ? new Intl.NumberFormat('es-PE', { minimumFractionDigits: 3, maximumFractionDigits: 3 }).format(params.value) : '', cellStyle: { justifyContent: 'end' }},
    {  headerClass: 'centrarencabezado', field: 'compra_procesada_estado',  filter:true, headerName: 'Estado',  width: 90,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        
        switch(estado) {
          case 'Contabilizado':
            badgeClass = 'bg-green-100 text-green-600';
            break;
          case 'Registrado':
            badgeClass = 'bg-[#FFDECC] text-[#FF8947]';
            break;
          default:
            badgeClass = 'bg-[#F5F5F5] text-text-85';
        }
        
        return `<span class="${badgeClass} px-2 py-[1px] rounded-full text-xxss font-medium">${estado}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  rowData: ICompraProceada[] = [];
  /** Copia maestra sin filtrar para aplicar filtros en cliente. */
  private allRows: ICompraProceada[] = [];
  private readonly fechaCampo = 'compra_procesada_fecha_emision';
  private readonly tituloReporte = 'Reporte de compras';

  defaultColDef = {
    sortable: false,
    filter: false,
    resizable: false
  };

  columnTypes = {
    numberColumn: { filter: false }
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

    // Sincronizar rowData con el store via effect
    effect(() => {
      const registros = this.reporteFacade.registros();
      this.allRows = [...registros];
      this.aplicarFiltros();
    });
  }

  

  ngOnInit() {
    this.reporteFacade.cargarReporte();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }
  onBtReset(){
    this.reporteFacade.cargarReporte();
  }
  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    this.aplicarFiltros();
  }

  /** Aplica el filtro de rango de fechas (cliente) sobre la copia maestra. */
  private aplicarFiltros() {
    let filas = [...this.allRows];
    if (this.startDate && this.endDate && this.fechaCampo) {
      const inicio = this.aMedianoche(this.startDate).getTime();
      const fin = this.aMedianoche(this.endDate).getTime();
      filas = filas.filter((fila) => {
        const fecha = this.parsearFecha((fila as any)[this.fechaCampo]);
        if (!fecha) {
          return true;
        }
        const t = this.aMedianoche(fecha).getTime();
        return t >= inicio && t <= fin;
      });
    }
    this.rowData = filas;
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  /** Exporta la grilla actual a CSV (compatible con Excel). */
  exportarCsv() {
    this.gridApi?.exportDataAsCsv({
      fileName: `reporte-compras-${new Date().toISOString().slice(0, 10)}.csv`,
    });
  }

  /** Exporta la grilla actual a PDF mediante la vista de impresión del navegador. */
  exportarPdf() {
    const encabezados = this.colDefs.map((c) => c.headerName ?? '');
    const campos = this.colDefs.map((c) => (c as { field?: string }).field ?? '');
    const filasHtml = this.rowData
      .map((fila) => {
        const celdas = campos
          .map((campo) => `<td style="border:1px solid #ccc;padding:4px;">${(fila as any)[campo] ?? ''}</td>`)
          .join('');
        return `<tr>${celdas}</tr>`;
      })
      .join('');
    const ventana = window.open('', '_blank');
    if (!ventana) {
      return;
    }
    ventana.document.write(`
      <html>
        <head>
          <title>${this.tituloReporte}</title>
          <style>
            body{font-family:Arial,sans-serif;font-size:11px;padding:16px;}
            h2{font-size:14px;}
            table{border-collapse:collapse;width:100%;}
            th{border:1px solid #ccc;padding:4px;background:#f3f4f6;text-align:left;}
          </style>
        </head>
        <body>
          <h2>${this.tituloReporte}</h2>
          <table>
            <thead><tr>${encabezados.map((h) => `<th>${h}</th>`).join('')}</tr></thead>
            <tbody>${filasHtml}</tbody>
          </table>
          <script>window.onload = function(){ window.print(); };</script>
        </body>
      </html>
    `);
    ventana.document.close();
  }

  private parsearFecha(valor: string | undefined): Date | null {
    if (!valor) {
      return null;
    }
    if (valor.includes('/')) {
      const [d, m, y] = valor.split('/');
      if (d && m && y) {
        return new Date(Number(y), Number(m) - 1, Number(d));
      }
    }
    const iso = new Date(valor);
    return isNaN(iso.getTime()) ? null : iso;
  }

  private aMedianoche(fecha: Date): Date {
    return new Date(fecha.getFullYear(), fecha.getMonth(), fecha.getDate());
  }

}
