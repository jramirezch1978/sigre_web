import { Component, OnInit, inject } from '@angular/core';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { MaestroContableFacade } from 'src/app/modules/contabilidad/application/facades/maestro-contable.facade';
import { MaestroContableFeedbackEffects } from 'src/app/modules/contabilidad/effects/maestro-contable-feedback.effect';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-contabilidad-reporte-maestrocontable',
  templateUrl: './contabilidad-reporte-maestrocontable.component.html',
  styleUrls: ['./contabilidad-reporte-maestrocontable.component.scss'],
  standalone: false,
})
export class ContabilidadReporteMaestrocontableComponent  implements OnInit {
  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  // Clean Architecture — Facade + Effects
  readonly maestroContableFacade   = inject(MaestroContableFacade);
  readonly feedbackEffects          = inject(MaestroContableFeedbackEffects);
  readonly isLoading                = this.maestroContableFacade.isLoading;

  pais= this.countryService.getCountryCode();
  countries= ALL_COUNTRIES;
  entidadtributaria=this.countries.find(c => c.codigo === this.pais)?.entidad || '';
  private gridApi!: GridApi;

  // Rango de fechas
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  estadoSeleccionado: string= 'todos';

  columGenerada: ColDef[] = [];
  filasGeneradas: any[] = [];

  cuentaContableSelect = [
    { codigo: '10101', denominacion: 'Caja General' },
    { codigo: '10102', denominacion: 'Bancos Locales - Cuenta Corriente' },
    { codigo: '10103', denominacion: 'Activos Fijos - Terrenos' },
    { codigo: '10104', denominacion: 'Activos Fijos - Edificios' },
    { codigo: '10105', denominacion: 'Depreción Acumulada - Edificios' },
    { codigo: '4011101', denominacion: 'Impuesto General a las Ventas' },
    { codigo: '4017101', denominacion: 'Impuesto a la Renta' },
    { codigo: '4018101', denominacion: 'Impuesto Temporal a los Activos Netos' },
  ];
  cuentaContableSeleccionada: any = null;

  opcionesTipoMaestro: any[] = [];

  estados=[
    { label: 'Todos los estados', value: 'todos' },
    { label: 'Activo', value: 'activo' },
    { label: 'Inactivo', value: 'inactivo' },
  ]

  tipoSeleccionado: any = null;
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

  // Datos del reporte — provistos por MaestroContableFacade (JSON via repositorio)
  // rowPlanC, rowCentroC, rowImpuesto, rowDetrac y rowConfigC fueron eliminados.
  // generarReporte() los lee directamente desde las señales del store.

  colPlanC: ColDef[] = [
    { field: 'codigo', headerName: 'Código', width: 80 },
    { field: 'denominacion', headerName: 'Denominación de cuenta', flex:1 },
    { field: 'naturaleza', headerName: 'Naturaleza', width: 100},
    { field: 'nivel', headerName: 'Nivel', width: 80},
    { field: 'fechaC', headerName: 'Fecha de creación', width: 120},
    // { field: 'usuario', headerName: 'Usuario', width: 120},
    { field: 'estado',
      headerClass: 'centrarencabezado',headerName: 'Estado', width: 80, cellRenderer: (params: any) => {
      const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
      return `<span class="badge-table ${color}">${params.value}</span>`;},
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];
  colCentroC: ColDef[] = [
    { field: 'codigo', headerName: 'Código', width: 80 },
    { field: 'denominacion', headerName: 'Denominación de cuenta', flex:1 },
    { field: 'area', headerName: 'Área', width: 100},
    { field: 'responsable', headerName: 'Responsable', width: 100},
    { field: 'fechaC', headerName: 'Fecha de creación', width: 120},
    // { field: 'usuario', headerName: 'Usuario', width: 120},
    { field: 'estado',
      headerClass: 'centrarencabezado',headerName: 'Estado', width: 80, cellRenderer: (params: any) => {
      const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
      return `<span class="badge-table ${color}">${params.value}</span>`;},
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];
  colImpuesto: ColDef[] = [
    { field: 'codigo', headerName: 'Código', width: 80 },
    { field: 'denominacion', headerName: 'Denominación de cuenta', flex:1 },
    { field: 'tasa', headerName: 'Tasa (%)', width: 100},
    { field: 'cuentaC', headerName: 'Cuenta contable asociada', width: 150},
    { field: 'fechaC', headerName: 'Fecha de creación', width: 120},
    // { field: 'usuario', headerName: 'Usuario', width: 120},
    { field: 'estado',
      headerClass: 'centrarencabezado',headerName: 'Estado', width: 80, cellRenderer: (params: any) => {
      const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
      return `<span class="badge-table ${color}">${params.value}</span>`;},
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];
  colDetrac: ColDef[] = [];

  colConfigC: ColDef[] = [
    { field: 'moduloO', headerName: 'Módulo origen', width: 110 },
    { field: 'cuentaD', headerName: 'Cuenta débito', width: 100 },
    { field: 'cuentaC', headerName: 'Cuenta crédito', width: 100},
    { field: 'centroC', headerName: 'Centro de costo', width: 120},
    { field: 'fechaC', headerName: 'Fecha de creación', width: 120},
    // { field: 'usuario', headerName: 'Usuario', width: 120},
    { field: 'estado',
      headerClass: 'centrarencabezado',headerName: 'Estado', width: 80, cellRenderer: (params: any) => {
      const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
      return `<span class="badge-table ${color}">${params.value}</span>`;},
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];


  constructor(
    private toastService:ToastService,
    private countryService: CountryService,
  ) {
    // Configurar fechas
    this.minDate = new Date(2020, 0, 1);
    this.maxDate = new Date();
    this.startDate = new Date(2025, 0, 1);
    this.endDate = new Date(2025, 0, 31);
  }

  ngOnInit() {
    // Cargar datos del maestro contable desde el repositorio (JSON / API)
    this.maestroContableFacade.cargarDatos();

    // Inicializar opciones de tipo maestro según el país
    this.inicializarOpcionesTipoMaestro();
    
    // Inicializar columnas de detracción/retención según el país
    this.inicializarColumnasDetraccion();
    
    // Inicializar columnas según el tipo seleccionado por defecto
    this.inicializarColumnas();
  }

  /**
   * Inicializa las opciones de tipo maestro según el país
   */
  private inicializarOpcionesTipoMaestro() {
    this.opcionesTipoMaestro = [
      { label: 'Plan de cuentas', value: 'planCuentas' },
      { label: 'Centro de costo', value: 'centroCosto' },
      { label: 'Impuestos', value: 'impuestos' },
    ];

    // Solo agregar tipos de detracción/retención si NO es Guatemala
    if (this.pais !== 'GT') {
      this.opcionesTipoMaestro.push({
        label: this.pais === 'CO' || this.pais === 'EC' ? 'Tipos de retención' : 'Tipos de detracción',
        value: 'tiposDet'
      });
    }

    this.opcionesTipoMaestro.push({ label: 'Configuraciones contables', value: 'confg' });
    
    // Establecer el tipo seleccionado por defecto
    this.tipoSeleccionado = this.opcionesTipoMaestro[0];
  }

  /**
   * Inicializa las columnas de detracción/retención según el país
   */
  private inicializarColumnasDetraccion() {
    const columnas: ColDef[] = [
      { field: 'codigo', headerName: 'Código', width: 80 }
    ];

    // Para Colombia, agregar columna de Retenciones de ley
    if (this.pais === 'CO' || this.pais === 'EC') {
      columnas.push(
        { field: 'retencionLey', headerName: 'Retenciones de ley', width: 150 },
        { field: 'nomop', headerName: 'Nombre de operación', flex: 1 },
      );
    }
    if (this.pais !== 'CO' && this.pais !== 'EC') {
      columnas.push(
        { field: 'denominacion', headerName: 'Denominación de cuenta', flex: 1 },
      );
    }

    // Agregar columnas comunes
    columnas.push(
      { field: 'detraccion', headerName: this.pais === 'CO' || this.pais === 'EC' ? 'Retención (%)' : 'Detracción (%)', width: 100 },
      { 
        field: 'cuentaB', 
        headerName: this.pais === 'CO' || this.pais === 'EC' ? 'Cuenta contable' : 'Cuenta bancaria ' + this.entidadtributaria, 
        width: 150 
      },
      { field: 'fechaC', headerName: 'Fecha de creación', width: 120 },
      { 
        field: 'estado',
        headerClass: 'centrarencabezado',
        headerName: 'Estado', 
        width: 80, 
        cellRenderer: (params: any) => {
          const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
          return `<span class="badge-table ${color}">${params.value}</span>`;
        },
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
      }
    );

    this.colDetrac = columnas;
  }
  
  /**
   * Inicializa las columnas de la tabla según el tipo seleccionado
   */
  private inicializarColumnas() {
    switch(this.tipoSeleccionado.value) {
      case 'planCuentas':
        this.columGenerada = this.colPlanC;
        break;
      case 'centroCosto':
        this.columGenerada = this.colCentroC;
        break;
      case 'impuestos':
        this.columGenerada = this.colImpuesto;
        break;
      case 'tiposDet':
        this.columGenerada = this.colDetrac;
        break;
      case 'confg':
        this.columGenerada = this.colConfigC;
        break;
    }
  }

   onBtReset() {
      this.maestroContableFacade.cargarDatos();
  }
  
  

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onPeriodoSeleccionado(event: any) {
    console.log('Periodo seleccionado:', event);
  }

  filtrarPorFechas(event: any) {
    console.log('Rango de fechas seleccionado:', event);
    this.startDate = event.startDate;
    this.endDate = event.endDate;
  }
  onTipoChange() {
    this.filasGeneradas = [];
    this.inicializarColumnas();
  }

  generarReporte() {
      this.maestroContableFacade.cargarDatos();
    if(this.tipoSeleccionado.value == 'planCuentas'){
      this.columGenerada = this.colPlanC;
      this.filasGeneradas = this.maestroContableFacade.planCuentas();
    } else if(this.tipoSeleccionado.value == 'centroCosto'){
      this.columGenerada = this.colCentroC;
      this.filasGeneradas = this.maestroContableFacade.centroCosto();
    } else if(this.tipoSeleccionado.value == 'impuestos'){
      this.columGenerada = this.colImpuesto;
      this.filasGeneradas = this.maestroContableFacade.impuestos();
    } else if(this.tipoSeleccionado.value == 'tiposDet'){
      this.columGenerada = this.colDetrac;
      this.filasGeneradas = this.maestroContableFacade.tiposDetraccion();
    } else if(this.tipoSeleccionado.value == 'confg'){
      this.columGenerada = this.colConfigC;
      this.filasGeneradas = this.maestroContableFacade.configuraciones();
    }
    this.toastService.success('¡Reporte generado exitosamente!')
  }

  onCuentaContableSeleccionada(cuenta: any) {
    this.cuentaContableSeleccionada = cuenta;
    console.log('Cuenta contable seleccionada:', cuenta);
  }


}

