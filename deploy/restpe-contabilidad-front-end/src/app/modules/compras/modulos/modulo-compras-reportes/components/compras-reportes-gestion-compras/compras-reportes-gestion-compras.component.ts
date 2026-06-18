import { Component, OnInit, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ReporteComprasGestionComprasFacade } from 'src/app/modules/compras/application/facades/reporte-compras-gestion-compras.facade';
import { GestionCompraDetalleItem, GestionCompraEntity } from 'src/app/modules/compras/domain/models/gestion-compra.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faFiles, faHandHoldingDollar, faPerson, faRotateRight, faPercent } from '@fortawesome/pro-solid-svg-icons';



type IGestionCompra = GestionCompraEntity;

type IProductoMasComprado = GestionCompraDetalleItem;

@Component({
  selector: 'app-compras-reportes-gestion-compras',
  templateUrl: './compras-reportes-gestion-compras.component.html',
  styleUrls: ['./compras-reportes-gestion-compras.component.scss'],
  standalone: false,
})
export class ComprasReportesGestionComprasComponent  implements OnInit {
  // Font Awesome Icons
  faRotateRight = faRotateRight; // Reutilizando el icono de búsqueda para el botón de reset
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasFiles = faFiles;
  fasHandHoldingDollar = faHandHoldingDollar;
  fasPerson = faPerson;
  fasPercent = faPercent;
  // Clean Architecture - Facade
  private readonly reporteFacade = inject(ReporteComprasGestionComprasFacade);
  readonly loading = this.reporteFacade.loading;



  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private gridApi!: GridApi;
  private gridApiProductos!: GridApi;
  mostrartabla: boolean = true;
  filaSeleccionada: IGestionCompra | null = null;

  AnalisisOrdenForm!: FormGroup;

  colDefs: ColDef<IGestionCompra>[] = [
    { field: 'gestion_compra_fecha_compra', headerName: 'Fecha compra', width: 110 },
    { field: 'gestion_compra_nro_orden', headerName: 'Nº orden', width: 120 },
    { field: 'gestion_compra_doc_fiscal', headerName: 'Documento fiscal', width: 130 },
    { field: 'gestion_compra_razon_social', headerName: 'Razón social', flex: 1, minWidth: 120,filter: true},
    { field: 'gestion_compra_producto', headerName: 'Producto', flex: 1, minWidth: 150 },
    { field: 'gestion_compra_categoria', headerName: 'Categoría de producto', width: 160, filter: true },
    { field: 'gestion_compra_medida', headerName: 'Unidad de medida', width: 120 },
    { field: 'gestion_compra_cantidad', headerName: 'Cantidad comprada', width: 130, headerClass: 'derechaencabezado', cellStyle: { display: 'flex', justifyContent: 'flex-end' } },
    { 
      field: 'gestion_compra_precio_venta', 
      headerName: 'Precio venta', 
      width: 130,
      headerClass: 'derechaencabezado',
      cellStyle: { display: 'flex', justifyContent: 'flex-end' },
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      }
    },
    { field: 'gestion_compra_condicion', headerName: 'Condición', width: 150, filter: true },
    { 
      field: 'gestion_compra_estado', 
      headerName: 'Estado',
      headerClass: 'centrarencabezado',
      cellStyle: {
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      }, 
      width: 120,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        
        switch(estado) {
          case 'Pendiente':
            badgeClass = 'bg-[#F5F5F5] text-text-85';
            break;
          default:
            badgeClass = 'bg-[#DCFDE7] text-[#16A34A]';
        }
        
        return `<span class="${badgeClass} px-2 py-[1px] rounded-full text-xxss font-medium">${estado}</span>`;
      }
    }
  ];

  colDefsProductos: ColDef<IProductoMasComprado>[] = [
    { field: 'codigo', headerName: 'Código', width: 120 },
    { field: 'cantidad', headerName: 'Cantidad comprada', width: 120, headerClass: 'derechaencabezado', cellStyle: { display: 'flex', justifyContent: 'flex-end' } },
    { field: 'producto', headerName: 'Producto', width: 250 },
    { 
      field: 'montoAcumulado', 
      headerName: 'Monto acumulado', 
      width: 150,
      headerClass: 'derechaencabezado',
      cellStyle: { display: 'flex', justifyContent: 'flex-end' },
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '0.00';
      }
    }
  ];

  rowData: IGestionCompra[] = [];
  /** Copia maestra sin filtrar para aplicar filtros en cliente. */
  private allRows: IGestionCompra[] = [];

  rowDataProductos: IProductoMasComprado[] = [];

  defaultColDef = {
    sortable: false,
    filter: false,
    resizable: false
  };

  gridOptions = {
    rowSelection: 'single' as const,
    onRowClicked: (event: any) => {
      this.onRowClicked(event);
    },
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
    this.AnalisisOrdenForm = this.fb.group({
      nombreProducto: [{value: '', disabled: true}],
      precioPorUnidad: [{value: '', disabled: true}],
      diasCredito: [{value: '', disabled: true}],
      fechaVencimiento: [{value: '', disabled: true}],
      razonSoc: [{value: '', disabled: true}],
      moneda: [{value: '', disabled: true}],
      sucursalAlmacen: [{value: '', disabled: true}],
      estadoPago: [{value: '', disabled: true}]
    });
    this.onBtReset(); // Cargar datos iniciales en la tabla
    
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onGridReadyProductos(params: GridReadyEvent) {
    this.gridApiProductos = params.api;
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

    if (this.startDate && this.endDate) {
      const inicio = this.aMedianoche(this.startDate);
      const fin = this.aMedianoche(this.endDate);
      filas = filas.filter((fila) => {
        const fecha = this.parsearFecha(fila.gestion_compra_fecha_compra);
        if (!fecha) {
          return true;
        }
        const t = this.aMedianoche(fecha).getTime();
        return t >= inicio.getTime() && t <= fin.getTime();
      });
    }

    this.rowData = filas;
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  /** Exporta la grilla actual a CSV (compatible con Excel). */
  exportarCsv() {
    if (!this.gridApi) {
      return;
    }
    this.gridApi.exportDataAsCsv({
      fileName: `reporte-gestion-compras-${new Date().toISOString().slice(0, 10)}.csv`,
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
          <title>Reporte de Gestión de Compras</title>
          <style>
            body{font-family:Arial,sans-serif;font-size:11px;padding:16px;}
            h2{font-size:14px;}
            table{border-collapse:collapse;width:100%;}
            th{border:1px solid #ccc;padding:4px;background:#f3f4f6;text-align:left;}
          </style>
        </head>
        <body>
          <h2>Reporte de Gestión de Compras al detalle</h2>
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

  mostrarTabla(mostrar: boolean) {
    this.mostrartabla = mostrar;
  }

  onRowClicked(event: any) {
    this.filaSeleccionada = event.data;
    this.llenarFormularioConDatosFila(event.data);
    this.rowDataProductos = event.data.gestion_compra_detalle || [];
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', this.rowDataProductos);
    }
    this.gridApi.redrawRows();
  }

  llenarFormularioConDatosFila(compra: IGestionCompra) {
    // Calcular días de crédito basado en la condición
    const diasCredito = this.extraerDiasCredito(compra.gestion_compra_condicion);
    
    // Calcular fecha de vencimiento si es crédito
    const fechaVencimiento = this.calcularFechaVencimiento(compra.gestion_compra_fecha_compra, diasCredito);
    
    this.AnalisisOrdenForm.patchValue({
      nombreProducto: compra.gestion_compra_producto,
      precioPorUnidad: compra.gestion_compra_precio_venta.toFixed(2),
      diasCredito: diasCredito.toString(),
      fechaVencimiento: fechaVencimiento,
      razonSoc: compra.gestion_compra_razon_social,
      moneda: 'Soles', // Valor por defecto
      sucursalAlmacen: 'Lima Centro', // Valor por defecto
      estadoPago: compra.gestion_compra_estado
    });
  }

  private extraerDiasCredito(condicion: string): number {
    if (condicion.includes('Contado')) {
      return 0;
    }
    const match = condicion.match(/\d+/);
    return match ? parseInt(match[0]) : 0;
  }

  private calcularFechaVencimiento(fechaCompra: string, diasCredito: number): string {
    if (diasCredito === 0) {
      return fechaCompra; // Si es contado, la fecha de vencimiento es la misma
    }
    
    const [dia, mes, año] = fechaCompra.split('/');
    const fecha = new Date(parseInt(año), parseInt(mes) - 1, parseInt(dia));
    fecha.setDate(fecha.getDate() + diasCredito);
    
    return `${fecha.getDate().toString().padStart(2, '0')}/${(fecha.getMonth() + 1).toString().padStart(2, '0')}/${fecha.getFullYear()}`;
  }

}
