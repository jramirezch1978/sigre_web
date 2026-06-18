import { Component, OnInit, signal, effect, inject, untracked } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ReporteFinancieroFacade } from 'src/app/modules/contabilidad/application/facades/reporte-financiero.facade';
import { ReporteFinancieroFeedbackEffects } from 'src/app/modules/contabilidad/effects/reporte-financiero-feedback.effect';
import { ReporteFinancieroRow, PatrimonioRow } from 'src/app/modules/contabilidad/domain/models/reporte-financiero.entity';

// Font Awesome Icons
import { faAngleDown, faDownload } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-contabilidad-reporte-reportefinanciero',
  templateUrl: './contabilidad-reporte-reportefinanciero.component.html',
  styleUrls: ['./contabilidad-reporte-reportefinanciero.component.scss'],
  standalone: false,
})
export class ContabilidadReporteReportefinancieroComponent implements OnInit {
  // Font Awesome Icons
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;


  countries = ALL_COUNTRIES;
  botonBuscarHabilitado = false;
  // Rango de fechas
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  tituloDelibro: any;
  columnasGeneradas: ColDef[] = [];
  filasGeneradas: any[] = [];
  filasGeneradasPatrimonio: any[] = [];
  // AG-Grid
  private gridApi!: GridApi;
  compPeriodo: any = 'sin-comparacion';
  periodoCont: any = 'fecha-especifica';
  cantidadPeriodos: number = 1;
  nivelSelect: any = null;
  filtrarRango: any = null;
  // incluirAA= false;
  monedaSelect: any = 'Soles';


  localeText = {
    page: 'Página',
    of: 'de',
    to: 'a',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    noRowsToShow: 'No hay filas para mostrar',
    loadingOoo: 'Cargando...'
  };
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '-'
        : params.value;
    }
  };

  // Configuración para Tree Data
  treeData = true;
  groupDefaultExpanded = 2;
  getDataPath = (data: ReporteFinancieroRow) => data.orgHierarchy;

  autoGroupColumnDef: ColDef = {};

  autoGroupColumnDefNiveles: ColDef = {
    headerName: 'Código y descripción de cuenta',
    minWidth: 400,
    flex: 1,
    sortable: false,
    comparator: (a, b) => 0,
    cellRendererParams: {
      suppressCount: true,
    },
  };

  // Función para aplicar clases CSS a las filas
  getRowClass = (params: any) => {
    if (!params.data) {
      return '';
    }
    if (params.data.isTotal) {
      return 'row-total';
    }
    if (params.data.isMainCategory) {
      return 'row-main-category';
    }
    if (params.data.isSubCategory) {
      return 'row-sub-category';
    }
    return '';
  };

  tiposReporte: any[]=[
    // "Situación financiera (Balance general)",
    // "Estado de resultados",
    // "Estado de flujos de efectivos",
    // "Estado de cambios en el patrimonio",
  ]
  tipoSeleccionado: any;

  get tituloLibro(): string {
    const tipoEncontrado = this.tiposReporte.find(tipo => tipo.value === this.tipoSeleccionado);
    return tipoEncontrado ? tipoEncontrado.label : '';
  }

  niveles=[
    "Nivel 1",
    "Nivel 2",
    "Nivel 3",
    "Nivel 4",
    "Nivel 5",
  ]
  monedas=[
    "Soles",
    "Dólares",
  ]

  colDefs: ColDef[] = [
    { headerName: 'Saldo Actual', field: 'saldoActual', width: 150, headerClass: 'derechaencabezado',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `(S/ ${formattedValue})`;
          }
          return `S/ ${formattedValue}`;
        }
        return '';
      },
      cellStyle: {textAlign: 'right',display: 'flex', justifyContent: 'right', },
    },
    { headerName: 'Saldo Comparativo', field: 'saldoComparativo', width: 150, headerClass: 'derechaencabezado',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `(S/ ${formattedValue})`;
          }
          return `S/ ${formattedValue}`;
        }
        return '';
      },
      cellStyle: {textAlign: 'right',display: 'flex', justifyContent: 'right', },
    },
    { headerName: 'Variación', field: 'variacion', width: 150, headerClass: 'derechaencabezado',
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
        const style: any = { textAlign: 'right', display: 'flex', justifyContent: 'right', };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { headerName: 'Variación %', field: 'variacionPct', width: 120, headerClass: 'derechaencabezado',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `(S/ ${formattedValue})`;
          }
          return `S/ ${formattedValue}`;
        }
        return '';
      },
      cellStyle: (params) => {
        const style: any = { textAlign: 'right', display: 'flex', justifyContent: 'right', };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { headerName: 'Moneda', field: 'moneda', width: 100,},
  ];
  colDefsFlujos: ColDef[] = [
    { headerName: 'Monto Actual', field: 'saldoActual', width: 150,
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
        }
        return '';
      },
      cellStyle: { textAlign: 'right' },
    },
    { headerName: 'Monto Comparativo', field: 'saldoComparativo', width: 150,
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
        }
        return '';
      },
      cellStyle: { textAlign: 'right' },
    },
    { headerName: 'Variación', field: 'variacion', width: 150,
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
        const style: any = { textAlign: 'right' };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { headerName: 'Moneda', field: 'moneda', width: 100,},
  ];
  colDefsPatrimonio: ColDef[] = [
  { headerName: '', field: 'concepto', pinned: 'left', minWidth: 200, flex: 1 ,headerClass: 'header-primera' , cellClass: 'col-primera'
  },
  { headerName: 'Total capital social', field: 'capital',width: 200,
    valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
        }else if (params.value == null){return '-'}
        return '';
      },
  },
  { headerName: 'Total reservas', field: 'reservas',width: 200,
    valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
        }else if (params.value == null){return '-'}
        return '';
      },
  },
  { headerName: 'Total resultados acumulados', field: 'resultados',width: 200,
    valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
        }else if (params.value == null){return '-'}
        return '';
      },
  },
  { headerName: 'Total ajustes al patrimonio', field: 'ajustes',width: 200,
    valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
        }else if (params.value == null){return '-'}
        return '';
      },
  },
  { headerName: 'Variación total del patrimonio neto', field: 'variacion',width: 200,
    valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
        }else if (params.value == null){return '-'}
        return '';
      },
  },
];


  rowData = signal<ReporteFinancieroRow[]>([]);

  rowDataResultados = signal<ReporteFinancieroRow[]>([]);

  rowDataFlujos = signal<ReporteFinancieroRow[]>([]);

  rowDataPatrimonio = signal<PatrimonioRow[]>([]);


  private readonly reporteFacade   = inject(ReporteFinancieroFacade);
  private readonly _reporteEffects = inject(ReporteFinancieroFeedbackEffects);
  readonly isLoading = this.reporteFacade.isLoading;

  constructor(
    private toastService:ToastService,
    private countryService: CountryService,
  ) {
    // Configurar fechas
    this.minDate = new Date(2020, 0, 1);
    this.maxDate = new Date();
    this.startDate = new Date(2025, 0, 1);
    this.endDate = new Date(2025, 0, 31);

    // Sincronizar signals del facade con signals del componente
    effect(() => {
      const data       = this.reporteFacade.rowData();
      const resultados = this.reporteFacade.rowDataResultados();
      const flujos     = this.reporteFacade.rowDataFlujos();
      const patrimonio = this.reporteFacade.rowDataPatrimonio();
      untracked(() => {
        this.rowData.set(data);
        this.rowDataResultados.set(resultados);
        this.rowDataFlujos.set(flujos);
        this.rowDataPatrimonio.set(patrimonio);
      });
    });
  }

  ngOnInit() {
    this.librofinancierosporpais();
    this.cuentacontableporpais();
    this.actualizarColumnasSegunTipo();
  }
  librofinancierosporpais(){
    const country = this.countries.find(
    c => c.codigo === this.countryService.getCountryCode()
    );
    this.tiposReporte= country?.librosfinancieros || [];
    this.tipoSeleccionado=this.tiposReporte[0]?.value
  }
  // Método para actualizar columnas según el tipo de reporte
  actualizarColumnasSegunTipo() {
  this.tituloDelibro='';
    console.log('Tipo de reporte seleccionado:', this.tipoSeleccionado);
    if (!this.tipoSeleccionado) return;

    if (this.tipoSeleccionado == '4') {
      this.autoGroupColumnDef = {};
    }

    if (this.tipoSeleccionado === '1' || 
        this.tipoSeleccionado === '2') {
      this.autoGroupColumnDef = this.autoGroupColumnDefNiveles;
      this.generarColumnasSegunComparacion();
    } else if (this.tipoSeleccionado === '3') {
      this.autoGroupColumnDef = this.autoGroupColumnDefNiveles;
      this.generarColumnasSegunComparacion(true); // true para flujos
    } else {
      // Configuración por defecto si no coincide con los anteriores
      this.columnasGeneradas = this.colDefsPatrimonio;
    }
    this.filasGeneradas=[];


    // Si el grid ya está creado, actualizar las columnas
    if (this.gridApi) {
      this.gridApi.setGridOption('columnDefs', this.columnasGeneradas);
    }
  }

  onCompararPeriodoChange() {
    console.log('Comparación de periodo cambió:', this.compPeriodo);
    this.actualizarColumnasSegunTipo();
  }
  onCantidadPeriodosChange() {
    console.log('Cantidad de periodos cambió:', this.cantidadPeriodos);
    this.actualizarColumnasSegunTipo();
  }

  generarColumnasSegunComparacion(esFlujos: boolean = false) {
    const columnas: ColDef[] = [];
    const fechaActual = new Date().toLocaleDateString('es-PE', { day: '2-digit', month: '2-digit', year: 'numeric' });

    // Función helper para crear columnas de monto
    const crearColumnaMonto = (headerName: string, field: string) => ({
      headerName: headerName,
      field: field,
      width: 150,
      headerClass: 'derechaencabezado',
      valueFormatter: (params: any) => {
        if (params.value !== null && params.value !== undefined) {
          return new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
        }
        return '';
      },
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
    });

    // Función helper para crear columna de variación
    const crearColumnaVariacion = () => ({
      headerName: 'Variación %',
      field: 'variacionPct',
      width: 120,
      headerClass: 'derechaencabezado',
      valueFormatter: (params: any) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = absValue.toFixed(2);
          if (params.value < 0) {
            return `(${formattedValue})%`;
          }
          return formattedValue + '%';
        }
        return '';
      },
      cellStyle: (params: any) => {
        const style: any = { textAlign: 'right', display: 'flex', justifyContent: 'right' };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    });

    if (this.compPeriodo === 'sin-comparacion') {
      // Solo columna actual
      const nombreColumna = esFlujos ? 'Monto Actual' : 'Saldo Actual';
      columnas.push(crearColumnaMonto(`Al ${fechaActual}`, 'saldoActual'));
      
    } else if (this.compPeriodo === 'periodo-anterior') {
      // Columna actual + anterior + variación
      const cantPeriodos = this.cantidadPeriodos || 1;
      columnas.push(crearColumnaMonto(`Al ${fechaActual}`, 'saldoActual'));
      for (let i = 0; i < cantPeriodos; i++) {
        const day= new Date().getDate().toString().padStart(2,'0');
        const year = new Date().getFullYear() - i;

        columnas.push(crearColumnaMonto(`Al 31/01/${year}`, `periodo${i}`));
      }
      
      // Solo agregar variación si es 1 periodo
      if (cantPeriodos === 1) {
        columnas.push(crearColumnaVariacion());
      }
      
    } else if (this.compPeriodo === 'mismo-periodo-año-anterior') {
      // Múltiples periodos
      const cantPeriodos = this.cantidadPeriodos || 1;
      
      for (let i = 0; i < cantPeriodos; i++) {
        const year = new Date().getFullYear() - i;
        const day= new Date().getDate().toString().padStart(2,'0');
        columnas.push(crearColumnaMonto(`Al ${day}/01/${year}`, `periodo${i}`));
      }
      
      // Solo agregar variación si es 1 periodo
      if (cantPeriodos === 1) {
        columnas.push(crearColumnaVariacion());
      }
    }

    this.columnasGeneradas = columnas;
  }
  
  onPeriodoSeleccionado(event: any) {
    console.log('Periodo seleccionado:', event);
    
    let periodoValue = '';
    
    // El evento viene como {month: number, year: number}
    if (event && typeof event === 'object' && event.month && event.year) {
      const year = event.year;
      const month = String(event.month).padStart(2, '0');
      periodoValue = `${year}${month}`;
    } else if (event instanceof Date) {
      const year = event.getFullYear();
      const month = String(event.getMonth() + 1).padStart(2, '0');
      periodoValue = `${year}${month}`;
    } else if (typeof event === 'string') {
      periodoValue = event;
    }
    
    if (periodoValue) {
      this.periodoCont = periodoValue ;
      console.log('Periodo guardado en formulario:', periodoValue);
    } else {
      console.warn('No se pudo procesar el evento del período:', event);
    }
  }
  onPeriodoCompSeleccionado(event: any) {
    console.log('Periodo seleccionado:', event);
    
    let periodoValue = '';
    
    // El evento viene como {month: number, year: number}
    if (event && typeof event === 'object' && event.month && event.year) {
      const year = event.year;
      const month = String(event.month).padStart(2, '0');
      periodoValue = `${year}${month}`;
    } else if (event instanceof Date) {
      const year = event.getFullYear();
      const month = String(event.getMonth() + 1).padStart(2, '0');
      periodoValue = `${year}${month}`;
    } else if (typeof event === 'string') {
      periodoValue = event;
    }
    
    if (periodoValue) {
      this.compPeriodo = periodoValue ;
      console.log('Periodo guardado en formulario:', periodoValue);
    } else {
      console.warn('No se pudo procesar el evento del período:', event);
    }

  }

  onPeriodoMensualSeleccionado(event: any) {
    console.log('Periodo mensual seleccionado:', event);
    if (event && typeof event === 'object' && event.month && event.year) {
      const year = event.year;
      const month = String(event.month).padStart(2, '0');
      const periodoValue = `${year}${month}`;
      console.log('Periodo mensual procesado:', periodoValue);
      // Aquí puedes guardar o procesar el periodo mensual según tu lógica
    }
  }

  onPeriodoTrimestralSeleccionado(event: any) {
    console.log('Periodo trimestral seleccionado:', event);
    if (event && typeof event === 'object') {
      console.log(`Trimestre ${event.quarter} del año ${event.year}`);
      console.log(`Meses: ${event.startMonth} a ${event.endMonth}`);
      // Aquí puedes guardar o procesar el periodo trimestral según tu lógica
    }
  }

  onPeriodoSemestralSeleccionado(event: any) {
    console.log('Periodo semestral seleccionado:', event);
    if (event && typeof event === 'object') {
      console.log(`Semestre ${event.semester} del año ${event.year}`);
      console.log(`Meses: ${event.startMonth} a ${event.endMonth}`);
      // Aquí puedes guardar o procesar el periodo semestral según tu lógica
    }
  }

  onPeriodoAnualSeleccionado(event: any) {
    console.log('Periodo anual seleccionado:', event);
    if (event) {
      console.log(`Año seleccionado: ${event}`);
      // Aquí puedes guardar o procesar el año según tu lógica
    }
  }


  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }


  filtrarPorFechas(event: any) {
    console.log('Rango de fechas seleccionado:', event);
    this.startDate = event.startDate;
    this.endDate = event.endDate;
  }
  cuentacontableporpais() {
    this.reporteFacade.cargarDatos(this.countryService.getCountryCode() ?? 'PE');
  }
  generarReporte() {
    this.reporteFacade.cargarDatos(this.countryService.getCountryCode() ?? 'PE');
    if(this.nivelSelect == "Nivel 1"){
      this.groupDefaultExpanded = 1;
    } else if(this.nivelSelect == "Nivel 2"){
      this.groupDefaultExpanded = 2;
    } else if(this.nivelSelect == "Nivel 3"){
      this.groupDefaultExpanded = 3;
    }  else if(this.nivelSelect == "Nivel 4"){
      this.groupDefaultExpanded = 4;
    }  else if(this.nivelSelect == "Nivel 5"){
      this.groupDefaultExpanded = 5;
    } 

    // Filtrar datos según el tipo de reporte seleccionado
    let datosFiltrados = this.filtrarDatosPorTipoReporte();

    // Si hay un grid, actualizar los datos
    if (this.gridApi) {
      this.gridApi.showLoadingOverlay();
      setTimeout(() => {
        this.gridApi.setGridOption('rowData', datosFiltrados);
        this.gridApi.hideOverlay();
        this.toastService.success('¡Reporte generado exitosamente!');
      }, 300);
    }
  }

// Método para filtrar datos según el tipo de reporte
private filtrarDatosPorTipoReporte(): ReporteFinancieroRow[] {
  if (!this.tipoSeleccionado) return [];

  switch(this.tipoSeleccionado) {
    case '1':
      return this.filasGeneradas = this.rowData()
    
    case '2':
      // Aquí deberías tener datos específicos para el estado de resultados
      return this.filasGeneradas = this.rowDataResultados()
    
    case '3':
      // Aquí deberías tener datos específicos para flujos de efectivo
      return this.filasGeneradas = this.rowDataFlujos()
    
    case '4':
      // Aquí deberías tener datos específicos para cambios en patrimonio
      return this.filasGeneradasPatrimonio = this.rowDataPatrimonio() as any
    
    default:
      return [];
  }
}

}
