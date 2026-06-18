import { Component, OnInit, inject, effect } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { SingleSelectFilterComponent } from 'src/app/modules/activos/m-af-reporte/pages/af-r-resumenactivofijo/single-select-filter.component';
import { ReporteComprasTransitoFacade } from 'src/app/modules/compras/application/facades/reporte-compras-transito.facade';
import { CompraTransitoEntity } from 'src/app/modules/compras/domain/models/compra-transito.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



type ICompraTransito = CompraTransitoEntity;

@Component({
  selector: 'app-compras-reportes-compras-transito',
  templateUrl: './compras-reportes-compras-transito.component.html',
  styleUrls: ['./compras-reportes-compras-transito.component.scss'],
  standalone: false,
})
export class ComprasReportesComprasTransitoComponent  implements OnInit {
  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  // Clean Architecture - Facade
  private readonly reporteFacade = inject(ReporteComprasTransitoFacade);

  // Señales expuestas desde el store
  readonly loading = this.reporteFacade.loading;

  //RANGO DE FECHAS
      startDate: Date | undefined;
      endDate: Date | undefined;
      minDate: Date;
      maxDate: Date;

  private gridApi!: GridApi;

  colDefs: ColDef<ICompraTransito>[] = [
    { field: 'compra_transito_nro_orden', headerName: 'Nº orden', width: 100},
    { field: 'compra_transito_fecha_emision', headerName: 'Fecha de emisión', width: 120 },
    { field: 'compra_transito_ruc_nit', headerName: 'Documento fiscal', width: 110},
    { field: 'compra_transito_proveedor', headerName: 'Razón social', flex: 1, minWidth: 160, filter:true},
    { field: 'compra_transito_moneda', headerName: 'Moneda', width: 90, filter: SingleSelectFilterComponent},
    { 
      field: 'compra_transito_monto_total', 
      headerName: 'Monto total', 
      width: 100,
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
    { field: 'compra_transito_sucursal', headerName: 'Sucursal', width: 100, filter:true},
    { field: 'compra_transito_tipo_doc', headerName: 'Tipo documento', width: 120,filter:true },
    { field: 'compra_transito_solicitado', headerName: 'Solicitado', width: 100, headerClass: 'derechaencabezado', cellStyle: { justifyContent: 'end' } },
    { field: 'compra_transito_cantidad', headerName: 'Cantidad', width: 100, headerClass: 'derechaencabezado', cellStyle: { justifyContent: 'end' } },
    { field: 'compra_transito_recepcionado', headerName: 'Recepcionado', width: 100, headerClass: 'derechaencabezado', cellStyle: { justifyContent: 'end' } },
    { field: 'compra_transito_pendiente', headerName: 'Pendiente', width: 100, headerClass: 'derechaencabezado', cellStyle: { justifyContent: 'end' } },
    { field: 'compra_transito_fecha_entrega', headerName: 'Fecha de entrega', width: 120, headerClass: 'derechaencabezado', cellStyle: { justifyContent: 'end' } },
    { 
      field: 'compra_transito_porcentaje_total', 
      headerClass: 'derechaencabezado',
      headerName: '% total', 
      width: 80,
      valueFormatter: (params) => {
        return params.value ? `${params.value}%` : '0%';
      },
      cellStyle: { justifyContent: 'end' }
    },
    { field: 'compra_transito_dias', headerName: 'Días', width: 50, headerClass: 'derechaencabezado', cellStyle: { justifyContent: 'end' } },
    { 
      headerClass: 'centrarencabezado',
      field: 'compra_transito_estado',
      filter:true, 
      headerName: 'Estado', 
      width: 90,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        
        switch(estado) {
          case 'Completo':
            badgeClass = 'bg-green-100 text-green-600';
            break;
          case 'Parcial':
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

  rowData: ICompraTransito[] = [];
  /** Copia maestra sin filtrar para aplicar filtros en cliente. */
  private allRows: ICompraTransito[] = [];
  private readonly fechaCampo = 'compra_transito_fecha_emision';
  private readonly tituloReporte = 'Reporte de compras en tránsito';

  defaultColDef = {
    sortable: false,
    filter: false,
    resizable: false
  };

  columnTypes = {
    numberColumn: { filter: false }
  };

  getRowClass = (params: any) => {
    if (params.data && params.data.compra_transito_estado == 'Parcial') {
      return 'row-parcial-blink';
    }
    return '';
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

    // Sync rowData con el store cada vez que cambien los registros del reporte
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
  onBtReset() {
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
      fileName: `reporte-compras-transito-${new Date().toISOString().slice(0, 10)}.csv`,
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
