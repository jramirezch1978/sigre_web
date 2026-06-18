import { Component, OnInit, inject, effect } from '@angular/core';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { IconBuildingCellComponent } from 'src/app/ui/icon-building-cell/icon-building-cell.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ReporteTributarioFacade } from '../../application/facades/reporte-tributario.facade';
import { ReporteTributarioFeedbackEffects } from '../../effects/reporte-tributario-feedback.effect';
import { ReporteTributarioDetalleEntity, ReporteTributarioConsolidadoEntity } from '../../domain/models/reporte-tributario.entity';

// Font Awesome Icons
import { faCheckCircle, faClock, faInfoCircle } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCalculator, faCoins, faDownload, faFileInvoiceDollar, faMinusCircle, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-v-r-reporte-tributario-por-periodo',
  templateUrl: './v-r-reporte-tributario-por-periodo.component.html',
  styleUrls: ['./v-r-reporte-tributario-por-periodo.component.scss'],
  standalone: false,
})
export class VRReporteTributarioPorPeriodoComponent  implements OnInit {

  // ── Inyecciones ─────────────────────────────────────────────────────────────
  readonly reporteFacade = inject(ReporteTributarioFacade);
  // Activar efectos de feedback (toasts de error)
  private readonly _feedbackEffects = inject(ReporteTributarioFeedbackEffects);

  // ── Signals expuestos al template ────────────────────────────────────────────
  readonly isLoading = this.reporteFacade.isLoading;
  // Font Awesome Icons
  farCheckCircle = faCheckCircle;
  farClock = faClock;
  farInfoCircle = faInfoCircle;
  fasAngleDown = faAngleDown;
  fasCalculator = faCalculator;
  fasCoins = faCoins;
  fasDownload = faDownload;
  fasFileInvoiceDollar = faFileInvoiceDollar;
  fasMinusCircle = faMinusCircle;
  fasRotateRight = faRotateRight;


  private gridApi!: GridApi;
  pais= this.countryService.getCountryCode();
  countries= ALL_COUNTRIES;
  // Datos para los autocompletes y bindings
  sucursales: any[] = [
    { id: 1, nombre: 'Sucursal Central' },
    { id: 2, nombre: 'Sucursal Norte' },
    { id: 3, nombre: 'Sucursal Sur' }
  ];

  sucursalesSeleccionadas: any[] = [];

  tipoISelect: any = [
  ];

  tipoImpuestoSeleccionado: any[] = [];

  nivelDetalleSeleccionado: string = 'consolidado';

  // Campos de periodo y estado de validación
  periodoInicio: string | null = null;
  periodoFin: string | null = null;
  camposValidos: boolean = false;

  tabActivo: string = 'ventas';

  reporteGenerado: boolean = false;

  // Variables estáticas para el reporte generado
  periodoReporteGenerado: string = 'Diciembre 2025';
  fechaGeneracionReporte: string = '03 de enero 2026 - 16:05';
  fechaVigenciaReporte: string = '08 de enero 2026, 16:05';

  // Configuración tree data
  treeData = true;
  groupDefaultExpanded = 0;

  getDataPath = (data: any) => {
    return data.trib_org_hierarchy || [];
  };

  autoGroupColumnDef: ColDef = {
    headerName: 'Sucursal / Franquicia',
    minWidth: 250,
    flex: 1,
    cellRenderer: 'agGroupCellRenderer',
    valueGetter: (params) => {
      return params.data?.trib_sucursal || params.data?.trib_org_hierarchy?.[0] || '';
    },
    cellRendererParams: {
      suppressCount: true,
      innerRenderer: IconBuildingCellComponent
    }
  };

  // Función para contar documentos por sucursal
  countDocumentsByProvider(sucursal: string): number {
    return this.rowData.filter(item => 
      item.trib_org_hierarchy && 
      item.trib_org_hierarchy[0] === sucursal && 
      item.trib_org_hierarchy.length === 2
    ).length;
  }

  // Función para contar documentos por tipo
  countDocumentsByType(sucursal: string, tipo: string): number {
    return this.rowData.filter(item => 
      item.trib_org_hierarchy && 
      item.trib_org_hierarchy[0] === sucursal && 
      item.trib_org_hierarchy[1] === tipo &&
      item.trib_org_hierarchy.length === 2
    ).length;
  }

  // Función para calcular totales por sucursal
  calculateTotalByProvider(sucursal: string, field: string): string {
    const total = this.rowData
      .filter(item => 
        item.trib_org_hierarchy && 
        item.trib_org_hierarchy[0] === sucursal && 
        item.trib_org_hierarchy.length === 2
      )
      .reduce((sum, item) => sum + ((item as any)[field] || 0), 0);
    
    return new Intl.NumberFormat('es-PE', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(total);
  }

  // Función para calcular totales por tipo
  calculateTotalByType(sucursal: string, tipo: string, field: string): string {
    const total = this.rowData
      .filter(item => 
        item.trib_org_hierarchy && 
        item.trib_org_hierarchy[0] === sucursal && 
        item.trib_org_hierarchy[1] === tipo &&
        item.trib_org_hierarchy.length === 2
      )
      .reduce((sum, item) => sum + ((item as any)[field] || 0), 0);
    
    return new Intl.NumberFormat('es-PE', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(total);
  }

  // Función para aplicar clases CSS a las filas
  getRowClass = (params: any) => {
    if (params.data && params.data.trib_es_sucursal) {
      return 'row-main-category';
    }
    if (params.data && params.data.trib_es_tipo) {
      return 'row-total';
    }
    return '';
  };

  // Configuración ag-grid
  // Arrays que se muestran en la tabla (inicialmente vacíos)
  rowDataVentas: ReporteTributarioDetalleEntity[] = [];
  rowDataCompras: ReporteTributarioDetalleEntity[] = [];
  rowDataConsolidado: ReporteTributarioConsolidadoEntity[] = [];

  // Totales que se muestran en los cards
  totalBaseImponible: number = 0;
  totalDebitosFiscales: number = 0;
  totalCreditosFiscales: number = 0;
  totalImpuestoNeto: number = 0;

  totalBaseImponibleFmt: string = 'S/0.00';
  totalDebitosFiscalesFmt: string = 'S/0.00';
  totalCreditosFiscalesFmt: string = 'S/0.00';
  totalImpuestoNetoFmt: string = 'S/0.00';

  get rowData(): any[] {
    return this.tabActivo === 'ventas' ? this.rowDataVentas : this.rowDataCompras;
  }

  // Columnas para vista consolidada
  colDefsConsolidado: ColDef[] = [
    { field: 'trib_sucursal', headerName: 'Sucursal / Franquicia', flex: 1, minWidth: 150 },
    { field: 'trib_tipo_impuesto', headerName: 'Tipo de impuesto', flex: 1, minWidth: 120 },
    { field: 'trib_base_imponible', headerName: 'Base imponible', flex: 1, minWidth: 120, headerClass: 'ag-right-aligned-header',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `S/(${formattedValue})`;
          }
            return `S/${formattedValue}`;
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
    { field: 'trib_tasa_porcentaje', headerName: 'Tasa %', flex: 1, minWidth: 80, headerClass: 'ag-right-aligned-header',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return params.value + '%';
        }
        return '';
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'end', };
        return style;
      }
    },
    { field: 'trib_debito_fiscal', headerName: 'Débito fiscal', flex: 1, minWidth: 120, headerClass: 'ag-right-aligned-header',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `S/(${formattedValue})`;
          }
            return `S/${formattedValue}`;
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
    { field: 'trib_creditos_fiscales', headerName: 'Créditos fiscales', flex: 1, minWidth: 120, headerClass: 'ag-right-aligned-header',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `S/(${formattedValue})`;
          }
            return `S/${formattedValue}`;
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
    { field: 'trib_impuesto_neto_pagar', headerName: 'Impuesto neto por pagar', flex: 1, minWidth: 140, headerClass: 'ag-right-aligned-header',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `S/(${formattedValue})`;
          }
            return `S/${formattedValue}`;
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
    }
  ];

  colDefs: ColDef[] = [
    { field: 'trib_tipo', headerName: 'Tipo', width: 100, minWidth: 80 },
    { field: 'trib_serie', headerName: 'Serie - Número', width: 150, minWidth: 130 },
    { field: 'trib_fecha', headerName: 'Fecha', width: 100, minWidth: 90 },
    { field: 'trib_ruc', headerName: 'RUC cliente', width: 120, minWidth: 110 },
    { field: 'trib_cliente', headerName: 'Cliente', width: 180, minWidth: 150 },
    { field: 'trib_impuesto', headerName: 'Impuesto', width: 100, minWidth: 80 },
    { field: 'trib_base_imponible', headerName: 'Base imponible', width: 140, minWidth: 120, headerClass: 'ag-right-aligned-header',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `S/(${formattedValue})`;
          }
            return `S/${formattedValue}`;
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
    { field: 'trib_debito_fiscal', headerName: 'Débito fiscal', width: 180, minWidth: 150, headerClass: 'ag-right-aligned-header',
      cellRenderer: (params: any) => {
        if (params.data && params.data.trib_es_sucursal) {
          const baseTotal = this.calculateTotalByProvider(params.data.trib_org_hierarchy[0], 'trib_base_imponible');
          return `<span class="text-xxs";">Base: <strong>S/${baseTotal}</strong></span>`;
        }
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          if (params.value < 0) {
            return `S/(${formattedValue})`;
          }
          return `S/${formattedValue}`;
        }
        return 'S/';
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'end', };
        if (params.value < 0) {
          style.color = '#EF4444'; // Rojo para negativos
        }
        return style;
      }
    },
    { field: 'trib_total', headerName: 'Total', width: 150, minWidth: 130, headerClass: 'ag-right-aligned-header',
      cellRenderer: (params: any) => {
        if (params.data && params.data.trib_es_sucursal) {
          const impuestoTotal = this.calculateTotalByProvider(params.data.trib_org_hierarchy[0], 'trib_debito_fiscal');
          return `<span class="text-xxs";">Impuesto: <strong>S/${impuestoTotal}</strong></span>`;
        }
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          if (params.value < 0) {
            return `S/(${formattedValue})`;
          }
          return `S/${formattedValue}`;
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
    }
  ];

  columnTypes = {};

  gridOptions = {
    context: {
      componentParent: this,
    },
  };

  localeText = {
    page: 'Página',
    more: 'más',
    to: 'a',
    of: 'de',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    loadingOoo: 'Cargando...',
    noRowsToShow: 'No hay datos para mostrar',
  };

  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null ||
        params.value === undefined ||
        params.value === ''
        ? '–'
        : params.value;
    },
    suppressMovable: true,
    sortable: true,
    resizable: true,
    wrapHeaderText: true,
    autoHeaderHeight: true,
  };

  constructor(private countryService: CountryService) {
    // Sincronizar signals del store con los arrays del grid
    effect(() => {
      this.rowDataVentas = this.reporteFacade.ventas();
    });
    effect(() => {
      this.rowDataCompras = this.reporteFacade.compras();
    });
    effect(() => {
      const consolidado = this.reporteFacade.consolidado();
      this.rowDataConsolidado = consolidado;

      // Recalcular totales para los cards cuando llegan datos
      if (consolidado.length > 0) {
        this.totalBaseImponible = consolidado.reduce((s, r) => s + (r.trib_base_imponible || 0), 0);
        this.totalDebitosFiscales = consolidado.reduce((s, r) => s + (r.trib_debito_fiscal || 0), 0);
        this.totalCreditosFiscales = consolidado.reduce((s, r) => s + (r.trib_creditos_fiscales || 0), 0);
        this.totalImpuestoNeto = consolidado.reduce((s, r) => s + (r.trib_impuesto_neto_pagar || 0), 0);

        const fmt = (v: number) => new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(v);
        this.totalBaseImponibleFmt = `S/${fmt(this.totalBaseImponible)}`;
        this.totalDebitosFiscalesFmt = `S/${fmt(this.totalDebitosFiscales)}`;
        this.totalCreditosFiscalesFmt = `S/${fmt(this.totalCreditosFiscales)}`;
        this.totalImpuestoNetoFmt = `S/${fmt(this.totalImpuestoNeto)}`;
      }
    });
  }

  ngOnInit() {
    this.obtenerdatospais();
  }
  obtenerdatospais(){
    this.countries.find((country) => {
      if (country.codigo === this.pais) {
        this.tipoISelect = country.tipoISelect;
      }
    });
  }
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.gridApi.sizeColumnsToFit();
  }

  onBtReset() {
    if (this.gridApi) {
      this.gridApi.setFilterModel(null);
      this.gridApi.refreshCells();
    }
  }

  onsucursalesSeleccionadas(event: any) {
    this.sucursalesSeleccionadas = event || [];
    this.validarCampos();
  }

  ontipoImpuestoSeleccionado(event: any) {
    this.tipoImpuestoSeleccionado = event || [];
    this.validarCampos();
  }

  onPeriodoInicioChange(event: {month: any, year: number}) {
    const monthNum = this.getMonthNumber(event.month);
    if (monthNum !== null && event.year) {
      this.periodoInicio = `${String(monthNum).padStart(2, '0')}/${event.year}`;
    } else {
      this.periodoInicio = null;
    }
    this.validarCampos();
  }

  onPeriodoFinChange(event: {month: any, year: number}) {
    const monthNum = this.getMonthNumber(event.month);
    if (monthNum !== null && event.year) {
      this.periodoFin = `${String(monthNum).padStart(2, '0')}/${event.year}`;
    } else {
      this.periodoFin = null;
    }
    this.validarCampos();
  }

  getMonthNumber(monthValue: any): number | null {
    if (monthValue === null || monthValue === undefined) return null;
    // If it's already a number or numeric string, parse it
    const num = parseInt(String(monthValue), 10);
    if (!isNaN(num) && num >= 1 && num <= 12) return num;

    // Map common Spanish month names to numbers
    const m = String(monthValue).toLowerCase();
    const map: Record<string, number> = {
      'enero': 1, 'ene': 1,
      'febrero': 2, 'feb': 2,
      'marzo': 3, 'mar': 3,
      'abril': 4, 'abr': 4,
      'mayo': 5, 'may': 5,
      'junio': 6, 'jun': 6,
      'julio': 7, 'jul': 7,
      'agosto': 8, 'ago': 8,
      'septiembre': 9, 'setiembre': 9, 'sep': 9, 'set': 9,
      'octubre': 10, 'oct': 10,
      'noviembre': 11, 'nov': 11,
      'diciembre': 12, 'dic': 12
    };
    return map[m] || null;
  }

  validarCampos() {
    const tieneSucursales = Array.isArray(this.sucursalesSeleccionadas) && this.sucursalesSeleccionadas.length > 0;
    const tienePeriodoInicio = this.periodoInicio !== null && this.periodoInicio !== '';
    const tieneTipoImpuesto = Array.isArray(this.tipoImpuestoSeleccionado) && this.tipoImpuestoSeleccionado.length > 0;

    this.camposValidos = !!(tieneSucursales && tienePeriodoInicio && tieneTipoImpuesto);
  }

  cambiarTab(tab: string) {
    this.tabActivo = tab;
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
    // Si cambiamos de tab y estamos en modo detallado, asegúrate de expandir solo el primer top-level
    if (this.nivelDetalleSeleccionado === 'detallado') {
      setTimeout(() => this.expandFirstTopLevel(), 200);
    }
  }

  onNivelDetalleChange(value: string) {
    this.nivelDetalleSeleccionado = value;
    // Si cambiamos a detallado y ya existe la grilla con datos, expandir solo la primera fila de nivel 0
    if (value === 'detallado') {
      setTimeout(() => this.expandFirstTopLevel(), 100);
    }
  }

  expandFirstTopLevel() {
    if (!this.gridApi) return;
    // Dejar un pequeño retraso para asegurar que la grilla procesó los datos
    setTimeout(() => {
      let firstFound = false;
      this.gridApi.forEachNode((node: any) => {
        const isTopLevel = node && node.level === 0 && (node.group === true || node.data?.esSucursal === true || (node.data && Array.isArray(node.data.orgHierarchy) && node.data.orgHierarchy.length === 1));
        if (isTopLevel) {
          try {
            if (!firstFound) {
              node.setExpanded(true);
              firstFound = true;
            } else {
              node.setExpanded(false);
            }
          } catch (e) {
            // algunos nodos pueden no soportar setExpanded, ignorar
            // console.warn('expandFirstTopLevel error', e, node);
          }
        }
      });
    }, 150);
  }

  generarReporte() {
    if (!this.camposValidos) {
      return;
    }

    // Delegar la carga de datos al facade (los effects sincronizan los rowData)
    this.reporteFacade.cargarReporte();

    this.reporteGenerado = true;
    // Después de generar, deshabilitar el botón Generar Reporte
    this.camposValidos = false;

    // Refrescar la grilla si existe
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }

    // Si estamos en modo detallado, expandir solo la primera fila top-level
    if (this.nivelDetalleSeleccionado === 'detallado') {
      setTimeout(() => this.expandFirstTopLevel(), 200);
    }
  }

}
