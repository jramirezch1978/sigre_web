import { Component, OnInit, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ReporteComprasSugeridasFacade } from 'src/app/modules/compras/application/facades/reporte-compras-sugeridas.facade';
import { SugerenciaCompraEntity } from 'src/app/modules/compras/domain/models/sugerencia-compra.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faHandHoldingDollar, faPerson, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

type ISugerenciaCompra = SugerenciaCompraEntity;

@Component({
  selector: 'app-compras-reportes-compras-sugeridas',
  templateUrl: './compras-reportes-compras-sugeridas.component.html',
  styleUrls: ['./compras-reportes-compras-sugeridas.component.scss'],
  standalone: false,
})
export class ComprasReportesComprasSugeridasComponent  implements OnInit {
  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasHandHoldingDollar = faHandHoldingDollar;
  fasPerson = faPerson;
  fasRotateRight = faRotateRight;

  // Clean Architecture - Facade
  private readonly reporteFacade = inject(ReporteComprasSugeridasFacade);

  // Señal de loading expuesta al template
  readonly loading = this.reporteFacade.loading;



  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private gridApi!: GridApi;
  mostrartabla: boolean = true;
  filaSeleccionada: ISugerenciaCompra | null = null;

  AnalisisSugerenciasForm!: FormGroup;

  colDefs: ColDef<ISugerenciaCompra>[] = [
    { field: 'sugerencia_compra_codigo', headerName: 'Código', width: 70 },
    { field: 'sugerencia_compra_producto', headerName: 'Producto', flex: 1, minWidth: 150 },
    { field: 'sugerencia_compra_categoria', headerName: 'Categoría', flex: 1, minWidth: 150, filter: true },
    { field: 'sugerencia_compra_almacen', headerName: 'Almacén', flex: 1, minWidth: 150, filter: true },
    { field: 'sugerencia_compra_medida', headerName: 'Medida', width: 70, filter: true },
    { field: 'sugerencia_compra_stock_actual', headerName: 'Stock actual',cellStyle: {justifyContent: 'end'},headerClass: 'derechaencabezado', width: 120 },
    { field: 'sugerencia_compra_prom_consumo', headerName: 'Promedio consumo',cellStyle: {justifyContent: 'end'},headerClass: 'derechaencabezado', width: 120 },
    { field: 'sugerencia_compra_pt_reposicion', headerName: 'Punto de reposición',cellStyle: {justifyContent: 'end'},headerClass: 'derechaencabezado', width: 120 },
    { field: 'sugerencia_compra_fecha_registro', headerName: 'Fecha registro', width: 130,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
     },
    { 
      headerClass: 'centrarencabezado',
      field: 'sugerencia_compra_estado',
      filter:true, 
      headerName: 'Estado', 
      width: 90,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        
        switch(estado) {
          case 'Pendiente':
            badgeClass = 'bg-[#F5F5F5] text-text-85';
            break;
            default:
            badgeClass = 'bg-[#D6E6FF] text-primary';
        }
        
        return `<span class="${badgeClass} px-2 py-[1px] rounded-full text-xxss font-medium">${estado}</span>`;
      },
      cellStyle: {
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    }
  ];

  rowData: ISugerenciaCompra[] = [];
  /** Copia maestra (ordenada) sin filtrar para aplicar filtros en cliente. */
  private allRows: ISugerenciaCompra[] = [];
  private readonly fechaCampo = 'sugerencia_compra_fecha_registro';
  private readonly tituloReporte = 'Reporte de compras sugeridas';

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
      // Ordenar de mayor a menor por código (PROD-010 → PROD-001)
      this.allRows = [...registros].sort((a, b) =>
        b.sugerencia_compra_codigo.localeCompare(a.sugerencia_compra_codigo, undefined, { numeric: true })
      );
      this.aplicarFiltros();
      // Seleccionar primera fila por defecto al cargar
      if (registros.length > 0 && !this.filaSeleccionada) {
        setTimeout(() => this.seleccionarPrimeraFila(), 100);
      }
    });
  }

  ngOnInit() {
    this.reporteFacade.cargarReporte();
    this.AnalisisSugerenciasForm = this.fb.group({
      fechaRegistro: [{value: '', disabled: true}],
      nombreProducto: [{value: '', disabled: true}],
      consumoPromedio: [{value: '', disabled: true}],
      puntoReposicion: [{value: '', disabled: true}],
      cantidadOptimaSugerida: [{value: '', disabled: true}],
      proveedorSugerido: [{value: '', disabled: true}],
      moneda: [{value: '', disabled: true}],
      precioPromedioHistorico: [{value: '', disabled: true}],
      condicionPagoProveedor: [{value: '', disabled: true}],
      descuentoPromedio: [{value: '', disabled: true}],
      costoTotalEstimado: [{value: '', disabled: true}],
      sucursalAlmacen: [{value: '', disabled: true}],
      estadoSugerencia: [{value: '', disabled: true}]
    });
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
      fileName: `reporte-compras-sugeridas-${new Date().toISOString().slice(0, 10)}.csv`,
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

  onBtReset() {
    this.reporteFacade.cargarReporte();
  }
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  seleccionarPrimeraFila() {
    if (!this.gridApi || this.rowData.length === 0) return;
    const primerNodo = this.gridApi.getDisplayedRowAtIndex(0);
    if (primerNodo) {
      primerNodo.setSelected(true);
      this.filaSeleccionada = primerNodo.data;
      this.llenarFormularioConDatosFila(primerNodo.data);
    }
  }

  mostrarTabla(mostrar: boolean) {
    this.mostrartabla = mostrar;
  }

  onRowClicked(event: any) {
    this.filaSeleccionada = event.data;
    this.llenarFormularioConDatosFila(event.data);
    // Actualizar el grid para aplicar los estilos de selección
    this.gridApi.redrawRows();
  }

  llenarFormularioConDatosFila(sugerencia: ISugerenciaCompra) {
    // Calcular cantidad óptima sugerida basada en punto de reposición y stock actual
    const cantidadOptima = Math.max(0, sugerencia.sugerencia_compra_pt_reposicion - sugerencia.sugerencia_compra_stock_actual);
    
    // Calcular precio promedio histórico (simulado basado en categoría)
    const precioPromedio = this.calcularPrecioPromedio(sugerencia.sugerencia_compra_categoria);
    
    // Calcular costo total estimado
    const costoTotal = cantidadOptima * precioPromedio;
    
    this.AnalisisSugerenciasForm.patchValue({
      fechaRegistro: sugerencia.sugerencia_compra_fecha_registro,
      nombreProducto: sugerencia.sugerencia_compra_producto,
      consumoPromedio: sugerencia.sugerencia_compra_prom_consumo.toString(),
      puntoReposicion: sugerencia.sugerencia_compra_pt_reposicion.toString(),
      cantidadOptimaSugerida: cantidadOptima.toString(),
      proveedorSugerido: this.obtenerProveedorSugerido(sugerencia.sugerencia_compra_categoria),
      moneda: 'Soles',
      precioPromedioHistorico: precioPromedio.toFixed(2),
      condicionPagoProveedor: this.obtenerCondicionPago(sugerencia.sugerencia_compra_categoria),
      descuentoPromedio: this.calcularDescuentoPromedio(sugerencia.sugerencia_compra_categoria).toString(),
      costoTotalEstimado: costoTotal.toFixed(2),
      sucursalAlmacen: sugerencia.sugerencia_compra_almacen,
      estadoSugerencia: sugerencia.sugerencia_compra_estado
    });
  }

  private calcularPrecioPromedio(categoria: string): number {
    const precios: { [key: string]: number } = {
      'Carnes': 28.50,
      'Lácteos': 42.00,
      'Vegetales': 6.50,
      'Mariscos': 85.00,
      'Aceites': 25.00,
      'Bebidas': 35.00
    };
    return precios[categoria] || 20.00;
  }

  private obtenerProveedorSugerido(categoria: string): string {
    const proveedores: { [key: string]: string } = {
      'Carnes': 'Distribuidora San Martin SAC',
      'Lácteos': 'Lácteos La Granja SAC',
      'Vegetales': 'Productos Frescos Lima EIRL',
      'Mariscos': 'Pescados y Mariscos SAC',
      'Aceites': 'Importadora Global SAC',
      'Bebidas': 'Vinos y Licores del Sur'
    };
    return proveedores[categoria] || 'Proveedor General SAC';
  }

  private obtenerCondicionPago(categoria: string): string {
    const condiciones: { [key: string]: string } = {
      'Carnes': 'Crédito 15 días',
      'Lácteos': 'Contado',
      'Vegetales': 'Crédito 7 días',
      'Mariscos': 'Contado',
      'Aceites': 'Crédito 30 días',
      'Bebidas': 'Crédito 45 días'
    };
    return condiciones[categoria] || 'Crédito 15 días';
  }

  private calcularDescuentoPromedio(categoria: string): number {
    const descuentos: { [key: string]: number } = {
      'Carnes': 5,
      'Lácteos': 3,
      'Vegetales': 2,
      'Mariscos': 8,
      'Aceites': 4,
      'Bebidas': 10
    };
    return descuentos[categoria] || 3;
  }

}
