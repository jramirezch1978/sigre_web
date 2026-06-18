import { Component, OnInit, inject, effect } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { SingleSelectFilterComponent } from 'src/app/modules/activos/m-af-reporte/pages/af-r-resumenactivofijo/single-select-filter.component';
import { ReporteComprasIngresarFacade } from 'src/app/modules/compras/application/facades/reporte-compras-ingresar.facade';
import { CompraPorIngresarEntity } from 'src/app/modules/compras/domain/models/compra-por-ingresar.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



type ICompraPorIngresar = CompraPorIngresarEntity;

@Component({
  selector: 'app-compras-reportes-compras-ingresar',
  templateUrl: './compras-reportes-compras-ingresar.component.html',
  styleUrls: ['./compras-reportes-compras-ingresar.component.scss'],
  standalone: false,
})
export class ComprasReportesComprasIngresarComponent  implements OnInit {
  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  faRotateRight= faRotateRight;
  // Clean Architecture - Facade
  private readonly reporteFacade = inject(ReporteComprasIngresarFacade);

  // Señales expuestas desde el store
  readonly loading = this.reporteFacade.loading;

   //RANGO DE FECHAS
      startDate: Date | undefined;
      endDate: Date | undefined;
      minDate: Date;
      maxDate: Date;

  private gridApi!: GridApi;

  colDefs: ColDef<ICompraPorIngresar>[] = [
    { field: 'compra_ingresar_nro_orden', headerName: 'Nº orden', width: 80 },
    { field: 'compra_ingresar_fecha_emision', headerName: 'Fecha de emisión', width: 120 },
    { field: 'compra_ingresar_fecha_recepcion', headerName: 'Fecha de recepción', width: 120 },
    { field: 'compra_ingresar_doc_fiscal', headerName: 'Documento fiscal', width: 120},
    { field: 'compra_ingresar_proveedor', headerName: 'Razón social', width: 140, filter:true},
    { field: 'compra_ingresar_moneda', headerName: 'Moneda', flex: 1, minWidth: 80, filter: SingleSelectFilterComponent},
    { field: 'compra_ingresar_sucursal', headerName: 'Sucursal', flex: 1, minWidth: 80, filter:true},
    { 
      field: 'compra_ingresar_monto_total', 
      headerName: 'Monto total', 
      flex: 1,
      minWidth: 100,
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
    { field: 'compra_ingresar_recepcionado', headerName: 'Recepcionado', flex: 1, minWidth: 100, headerClass: 'derechaencabezado', cellStyle: { justifyContent: 'end' } },
    { field: 'compra_ingresar_cantidad', headerName: 'Cantidad', width: 80, headerClass: 'derechaencabezado', cellStyle: { justifyContent: 'end' } },
    { field: 'compra_ingresar_ingresado', headerName: 'Ingresado', flex: 1, minWidth: 120, headerClass: 'derechaencabezado', cellStyle: { justifyContent: 'end' } },
    { field: 'compra_ingresar_diferencia', headerName: 'Diferencia', flex: 1, minWidth: 120, headerClass: 'derechaencabezado', cellStyle: { justifyContent: 'end' } },
    { field: 'compra_ingresar_usuario_receptor', headerName: 'Usuario receptor', width: 150, filter:true },
    { 
      headerClass: 'centrarencabezado',
      field: 'compra_ingresar_estado',
      filter:true, 
      headerName: 'Estado', 
      width: 100,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        
        switch(estado) {
          case 'Completo':
            badgeClass = 'bg-green-100 text-green-600';
            break;
          case 'Incompleto':
            badgeClass = 'bg-[#FFDECC] text-[#FF8947]';
            break;
          default:
            badgeClass = 'bg-[#F5F5F5] text-text-85';
        }
        
        return `<span class="${badgeClass} px-2 py-[1px] rounded-full text-xxss font-medium">${estado}</span>`;
      },
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  rowData: ICompraPorIngresar[] = [];
  /** Copia maestra sin filtrar para aplicar filtros en cliente. */
  private allRows: ICompraPorIngresar[] = [];
  private readonly fechaCampo = 'compra_ingresar_fecha_emision';
  private readonly tituloReporte = 'Reporte de compras por ingresar';

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
      fileName: `reporte-compras-por-ingresar-${new Date().toISOString().slice(0, 10)}.csv`,
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
