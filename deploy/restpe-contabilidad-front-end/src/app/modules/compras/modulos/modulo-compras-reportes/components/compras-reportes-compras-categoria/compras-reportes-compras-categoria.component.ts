import { Component, OnInit, inject, effect } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ReporteComprasCategoriaFacade } from 'src/app/modules/compras/application/facades/reporte-compras-categoria.facade';
import { CompraPorCategoriaEntity } from 'src/app/modules/compras/domain/models/compra-por-categoria.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



type ICompraPorCategoria = CompraPorCategoriaEntity;

@Component({
  selector: 'app-compras-reportes-compras-categoria',
  templateUrl: './compras-reportes-compras-categoria.component.html',
  styleUrls: ['./compras-reportes-compras-categoria.component.scss'],
  standalone: false,
})
export class ComprasReportesComprasCategoriaComponent  implements OnInit {
  // Font Awesome Icons
  faRotateRight = faRotateRight;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;

  // Clean Architecture - Facade
  private readonly reporteFacade = inject(ReporteComprasCategoriaFacade);
  readonly loading = this.reporteFacade.loading;



   //RANGO DE FECHAS
      startDate: Date | undefined;
      endDate: Date | undefined;
      minDate: Date;
      maxDate: Date;

  private gridApi!: GridApi;

  colDefs: ColDef<ICompraPorCategoria>[] = [
    { field: 'compra_categoria_categoria', headerName: 'Categoría', flex: 1, minWidth: 120,filter: true },
    { field: 'compra_categoria_subcategoria', headerName: 'Subcategoría', flex: 1, minWidth: 120,filter: true },
    { field: 'compra_categoria_producto', headerName: 'Producto', flex: 1, minWidth: 120 },
    { field: 'compra_categoria_codigo', headerName: 'Código', width: 100 },
    { field: 'compra_categoria_doc_fiscal', headerName: 'Documento fiscal', width: 140 },
    { field: 'compra_categoria_razon_social', headerName: 'Razón social', flex: 1, minWidth: 120,filter: true},
    { field: 'compra_categoria_moneda', headerName: 'Moneda', width: 100, filter: true },
    { field: 'compra_categoria_centro_costo', headerName: 'Centro de costo', flex: 1, minWidth: 120,filter: true},
    { field: 'compra_categoria_medida', headerName: 'Medida (KG)', width: 100 },
    { field: 'compra_categoria_cantidad_comprada', headerName: 'Cantidad comprada', width: 120,headerClass: 'derechaencabezado', cellStyle: { justifyContent: 'end' } ,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      }
    },
    { field: 'compra_categoria_monto_total', headerName: 'Monto total compras', width: 140, headerClass: 'derechaencabezado', cellStyle: { justifyContent: 'end' },
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      }
    },
    { field: 'compra_categoria_precio_promedio', headerName: 'Precio promedio x 1', width: 140, headerClass: 'derechaencabezado', cellStyle: { justifyContent: 'end' },
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      }
    },
    { field: 'compra_categoria_participacion', headerName: 'Participación', width: 120, headerClass: 'derechaencabezado', cellStyle: { justifyContent: 'end' },
      valueFormatter: (params) => {
        return params.value ? `${params.value}%` : '0%';
      }
    },
    { field: 'compra_categoria_ultima_compra', headerName: 'Última compra', width: 120 },
    { field: 'compra_categoria_sucursal', headerName: 'Sucursal', width: 140, filter: true },
    { headerClass: 'centrarencabezado', field: 'compra_categoria_estado', headerName: 'Estado',filter: true, width: 100,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        
        switch(estado) {
          case 'Completo':
            badgeClass = 'bg-green-100 text-green-600';
            break;
          case 'Pendiente':
            badgeClass = 'bg-[#F5F5F5] text-text-85|';
            break;
          default:
            badgeClass = 'bg-[#F5F5F5] text-text-85';
        }
        
        return `<span class="${badgeClass} px-2 py-[1px] rounded-full text-xxss font-medium">${estado}</span>`;
      },
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  rowData: ICompraPorCategoria[] = [];
  /** Copia maestra sin filtrar para aplicar filtros en cliente. */
  private allRows: ICompraPorCategoria[] = [];
  private readonly fechaCampo = 'compra_categoria_ultima_compra';
  private readonly tituloReporte = 'Reporte de compras por categoría';

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

   filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    this.aplicarFiltros();
  }
  onBtReset(){
    this.reporteFacade.cargarReporte();
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
      fileName: `reporte-compras-categoria-${new Date().toISOString().slice(0, 10)}.csv`,
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
