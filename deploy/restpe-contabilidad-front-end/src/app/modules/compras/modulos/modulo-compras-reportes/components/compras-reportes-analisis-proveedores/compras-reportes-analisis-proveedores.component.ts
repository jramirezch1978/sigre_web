import { Component, OnInit, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { SingleSelectFilterComponent } from 'src/app/modules/activos/m-af-reporte/pages/af-r-resumenactivofijo/single-select-filter.component';
import { ReporteAnalisisProveedoresFacade } from 'src/app/modules/compras/application/facades/reporte-analisis-proveedores.facade';
import { AnalisisProveedorDetalleItem, AnalisisProveedorEntity } from 'src/app/modules/compras/domain/models/analisis-proveedor.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-compras-reportes-analisis-proveedores',
  templateUrl: './compras-reportes-analisis-proveedores.component.html',
  styleUrls: ['./compras-reportes-analisis-proveedores.component.scss'],
  standalone: false,
})
export class ComprasReportesAnalisisProveedoresComponent  implements OnInit {
  // Font Awesome Icons
  faRotateRight = faRotateRight;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasDownload = faDownload;

  // Clean Architecture - Facade
  private readonly reporteFacade = inject(ReporteAnalisisProveedoresFacade);
  readonly loading = this.reporteFacade.loading;



  //RANGO DE FECHAS
      startDate: Date | undefined;
      endDate: Date | undefined;
      minDate: Date;
      maxDate: Date;

  private gridApi!: GridApi;
  private gridApiTop!: GridApi;
  mostrartabla: boolean = true;
  filaSeleccionada: AnalisisProveedorEntity | null = null;

  AnalisisProveedorForm!: FormGroup;

  colDefs: ColDef<AnalisisProveedorEntity>[] = [
    { field: 'analisis_proveedor_codigo', headerName: 'Código', minWidth: 85, maxWidth: 100 },
    { field: 'analisis_proveedor_doc_fiscal', headerName: 'Documento fiscal', minWidth: 120, maxWidth: 140 },
    { field: 'analisis_proveedor_razon_social', headerName: 'Razón social', flex: 2, minWidth: 120, filter: true },
    { field: 'analisis_proveedor_tipo_documento', headerName: 'Tipo de documento', flex: 1, minWidth: 140, filter: true },
    { field: 'analisis_proveedor_centro_costo', headerName: 'Centro de costos', flex: 1, minWidth: 140, filter: true },
    { field: 'analisis_proveedor_doc_emitidos', headerName: 'Documentos emitidos', flex: 1, minWidth: 140 },
    { field: 'analisis_proveedor_moneda', headerName: 'Moneda', minWidth: 80, maxWidth: 95, filter: SingleSelectFilterComponent},
    { field: 'analisis_proveedor_ultima_compra', headerName: 'Última compra', minWidth: 100, maxWidth: 120 },
    { field: 'analisis_proveedor_sucursal', headerName: 'Sucursal', minWidth: 95, maxWidth: 115, filter:true},
    { field: 'analisis_proveedor_estado_contable', headerName: 'Estado contable', headerClass: 'centrarencabezado', filter: true, flex: 1, minWidth: 120,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        
        switch(estado) {
          case 'Contabilizado':
            badgeClass = 'bg-green-100 text-green-600';
            break;
          default:
            badgeClass = 'bg-[#F5F5F5] text-text-85';
        }
        
        return `<span class="${badgeClass} px-2 py-[1px] rounded-full text-xxss font-medium">${estado}</span>`;
      }
    }
  ];

  colDefsTop: ColDef<AnalisisProveedorDetalleItem>[] = [
    { field: 'analisis_proveedor_codigo', headerName: 'Código', width: 90 },
    { field: 'analisis_proveedor_razon_social', headerName: 'Razón social', flex: 1, minWidth: 150 },
    { field: 'analisis_proveedor_sucursal', headerName: 'Sucursal', width: 120 },
    { 
      field: 'montoAcumulado', 
      headerName: 'Monto acumulado', 
      filter:true,
      width: 130,
      headerClass: 'derechaencabezado',
      cellStyle: { justifyContent: 'flex-end'},
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      }
    }
  ];

  rowData: AnalisisProveedorEntity[] = [];
  /** Copia maestra sin filtrar para aplicar filtros en cliente. */
  private allRows: AnalisisProveedorEntity[] = [];
  private readonly fechaCampo = 'analisis_proveedor_ultima_compra';
  private readonly tituloReporte = 'Reporte de análisis de proveedores';

  rowDataTop: AnalisisProveedorDetalleItem[] = [];

  defaultColDef = {
    sortable: false,
    filter: false,
    resizable: false
  };

  gridOptions = {
    rowSelection: 'single' as const,
    onRowClicked: (event: any) => {
      this.onRowClicked(event);
    }
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
  constructor(private fb: FormBuilder) {
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

    this.AnalisisProveedorForm = this.fb.group({
      razonSocial: [{value: '', disabled: true}],
      tipoDocumento: [{value: '', disabled: true}],
      moneda: [{value: '', disabled: true}],
      documentosEmitidos: [{value: '', disabled: true}],
      subTotalC: [{value: '', disabled: true}],
      impuestosT: [{value: '', disabled: true}],
      montoTotalCompras: [{value: '', disabled: true}],
      porcPart: [{value: '', disabled: true}],
      centroCosto: [{value: '', disabled: true}],
      sucursalAlmacen: [{value: '', disabled: true}],
      estadoSugerencia: [{value: '', disabled: true}]
    });
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onGridReadyTop(params: GridReadyEvent) {
    this.gridApiTop = params.api;
  }

  mostrarTabla(mostrar: boolean) {
    this.mostrartabla = mostrar;
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
      fileName: `reporte-analisis-proveedores-${new Date().toISOString().slice(0, 10)}.csv`,
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

  onRowClicked(event: any) {
    this.filaSeleccionada = event.data;
    this.llenarFormularioConDatosFila(event.data);
    this.rowDataTop = event.data.analisis_proveedor_detalle || [];
    if (this.gridApiTop) {
      this.gridApiTop.setGridOption('rowData', this.rowDataTop);
    }
  }
  onBtReset(){
    this.reporteFacade.cargarReporte();
  }

  llenarFormularioConDatosFila(proveedor: AnalisisProveedorEntity) {
    this.AnalisisProveedorForm.patchValue({
      razonSocial: proveedor.analisis_proveedor_razon_social,
      tipoDocumento: proveedor.analisis_proveedor_tipo_documento,
      moneda: proveedor.analisis_proveedor_moneda,
      documentosEmitidos: proveedor.analisis_proveedor_doc_emitidos.toString(),
      subTotalC: proveedor.analisis_proveedor_subtotal?.toFixed(2) ?? '',
      impuestosT: proveedor.analisis_proveedor_impuestos?.toFixed(2) ?? '',
      montoTotalCompras: proveedor.analisis_proveedor_monto_total?.toFixed(2) ?? '',
      porcPart: proveedor.analisis_proveedor_porc_participacion?.toFixed(2) ?? '',
      centroCosto: proveedor.analisis_proveedor_centro_costo ?? '',
      sucursalAlmacen: proveedor.analisis_proveedor_sucursal,
      estadoSugerencia: proveedor.analisis_proveedor_estado_contable
    });
  }

}
