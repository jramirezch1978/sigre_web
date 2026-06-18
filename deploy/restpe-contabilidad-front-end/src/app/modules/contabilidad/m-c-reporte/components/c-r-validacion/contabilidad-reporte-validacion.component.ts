import { Component, OnInit, inject, effect } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ReporteValidacionFacade } from 'src/app/modules/contabilidad/application/facades/reporte-validacion.facade';
import { ReporteValidacionFeedbackEffects } from 'src/app/modules/contabilidad/effects/reporte-validacion-feedback.effect';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-contabilidad-reporte-validacion',
  templateUrl: './contabilidad-reporte-validacion.component.html',
  styleUrls: ['./contabilidad-reporte-validacion.component.scss'],
  standalone:false,
  
})
export class ContabilidadReporteValidacionComponent  implements OnInit {
  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  // Clean Architecture - Facade
  private readonly reporteValidacionFacade = inject(ReporteValidacionFacade);
  private readonly feedbackEffects = inject(ReporteValidacionFeedbackEffects);

  // Señal de carga
  readonly isLoading = this.reporteValidacionFacade.isLoading;

  private gridApi!: GridApi;

  // Rango de fechas
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  estadoSeleccionado: string= 'todos';
  estadoPSeleccionado: string= 'todos';
  estadoVSeleccionado: string= 'todos';
  nivelSeleccionado: string= 'todos';
  libroSeleccionado: string= 'todos';
  origenSeleccionado: string= 'todos';
  monedaSeleccionada: string= 'todos';

  columGenerada: ColDef[] = [];
  context: any;
  filasGeneradas: any[] = [];

  mostrarSinMov: boolean = false;

  opcionesTipoReporte = [
    { label: 'Consistencia de Asientos Contables', value: 'consistencia' },
    { label: 'Consistencia de Pre-Asientos Contables', value: 'consistenciaPre' },
    { label: 'Asientos Descuadrados', value: 'asientosDes' },
    // { label: 'Balance de Comprobación', value: 'balance' },
  ];
  estados=[
    { label: 'Todos los estados', value: 'todos' },
    { label: 'Activo', value: 'activo' },
    { label: 'Pendiente', value: 'pendiente' },
    { label: 'Anulado', value: 'anulado' },
  ];
  estadosV=[
    { label: 'Todos los estados', value: 'todos' },
    { label: 'Correctos', value: 'correctos' },
    { label: 'Observados', value: 'observados' },
    { label: 'Pendientes', value: 'pendientes' },
  ];
  estadosP=[
    { label: 'Todos los estados', value: 'todos' },
    { label: 'Cuadrado', value: 'cuadrado' },
    { label: 'Descuadrado', value: 'descuadrado' },
  ];
  niveles=[
    { label: 'Todos los niveles', value: 'todos' },
    { label: '1', value: '1' },
    { label: '2', value: '2' },
    { label: '3', value: '3' },
    { label: '4', value: '4' },
    { label: '5', value: '5' },
  ];
  libros=[
    { label: 'Todos los libros', value: 'todos' },
    { label: '005 - Libro diario', value: '005' },
    { label: '006 - libro mayor', value: '006' },
    { label: '001 - libro caja', value: '001' },
    { label: '008 - Registro de compras', value: '008' },
    { label: '014 - Registro de ventas', value: '014' },
  ];
  monedas=[
    { label: 'Todas las monedas', value: 'todos' },
    { label: 'Soles', value: 'soles' },
    { label: 'Dólares', value: 'dolares' },
  ];
  origenes=[
    { label: 'Todos los origenes', value: 'todos' },
    { label: 'Manual', value: 'activos' },
    { label: 'Compras', value: 'pendiente' },
    { label: 'Ventas', value: 'ventas' },
    { label: 'Activos fijos', value: 'activof' },
    { label: 'Plantilla', value: 'plantilla' },
    { label: 'TesorerÍa', value: 'tesorería' },
  ];
  usuarios=[
    { id: 0, nombre: 'Todos los usuarios' },
    { id: 1, nombre: 'Juan Pérez' },
    { id: 2, nombre: 'Ernesto Ravello' },
    { id: 3, nombre: 'Layla Sandoval' },
    { id: 4, nombre: 'Jean Pierre Santillán' },

  ];
  centroC=[
    { id: 0, nombre: 'Todos los centros' },
    { id: 1, nombre: 'Administración central' },
    { id: 2, nombre: 'Operaciones - Produccion' },
    { id: 3, nombre: 'Ventas y Marketing' },
  ]

  usuarioSeleccionado: any = this.usuarios[0];
  centroCSeleccionado: any = this.centroC[0];


  tipoSeleccionado: any = this.opcionesTipoReporte[0];
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

  // Datos del reporte — provistos por ReporteValidacionFacade (JSON via repositorio)
  // rowBalances = [
  //   { codigo: '1010', descripcion: 'Caja General', nivel: '1', moneda: 'Soles', saldoI: '1500.00', totalD: '1500.00', totalC: '1500.00', saldoF: '12000.00', diferencia: '0.00', estado: 'Cuadrado'},
  //   { codigo: '2010', descripcion: 'Proveedores nacionales', nivel: '2', moneda: 'Soles', saldoI: '1500.00', totalD: '1500.00', totalC: '1500.00', saldoF: '12000.00', diferencia: '0.00', estado: 'Cuadrado'},
  //   { codigo: '3000', descripcion: 'Capital social', nivel: '1', moneda: 'Dólares', saldoI: '1500.00', totalD: '1500.00', totalC: '1500.00', saldoF: '12000.00', diferencia: '2000.00', estado: 'Descuadrado'},
  // ];

  colConst: ColDef[] = [
    { field: 'origen', headerName: 'Origen', width: 80 },
    { field: 'fechaRegistro', headerName: 'Fecha de registro', width: 120},
    { field: 'fechaContable', headerName: 'Fecha contable', width: 120},
    // { field: 'periodoC', headerName: 'Periodo contable', width: 120, minWidth:120 },
    { field: 'nlibro', headerName: 'N° Libro', width: 80},
    { field: 'nasiento', headerName: 'N° Asiento', width: 135, cellRenderer: VistaCellRenderComponent},
    { field: 'glosa', headerName: 'Glosa', flex:1, minWidth:200 },
    { field: 'codcuenta', headerName: 'Codigo de cuenta', width: 120},
    { field: 'desccuenta', headerName: 'Descripción de la cuenta', width: 120},
    { field: 'totalD', headerName: 'Total débitos', width: 120,
      headerClass: 'derechaencabezado',
      cellStyle: { display: 'flex', justifyContent: 'end', alignItems: 'center' },},
    { field: 'totalC', headerName: 'Total créditos', width: 120,
      headerClass: 'derechaencabezado',
      cellStyle: { display: 'flex', justifyContent: 'end', alignItems: 'center' },},
    { field: 'diferencia', headerName: 'Diferencia', width: 100,
      headerClass: 'derechaencabezado',
      cellStyle: { display: 'flex', justifyContent: 'end', alignItems: 'center' },},
    // { field: 'usuario', headerName: 'Usuario', width: 120},
    { field: 'moneda', headerName: 'Moneda', width: 120},
    { field: 'centrodecostos', headerName: 'Centro de costos', width: 120},
    { 
      field: 'estado', 
      headerName: 'Estado', 
      width: 90,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        } else if (params.value === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
        } else if (params.value === 'Anulado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulado</span>';
        }
        return params.value;
      }
    },
    // { field: 'observacion', headerName: 'Observación', width: 120},
  ];
  colConstPre: ColDef[] = [
    { field: 'origen', headerName: 'Origen', width: 80 },
    { field: 'periodoC', headerName: 'Periodo contable', width: 120 },
    { field: 'npasiento', headerName: 'N° Pre-Asiento', width: 120, cellRenderer: VistaCellRenderComponent},
    { field: 'glosa', headerName: 'Glosa', flex:1, minWidth:200 },
    { field: 'totalD', headerName: 'Total débitos', width: 120},
    { field: 'totalC', headerName: 'Total créditos', width: 120},
    { field: 'diferencia', headerName: 'Diferencia', width: 120},
    // { field: 'usuario', headerName: 'Usuario', width: 120},
    { field: 'fecha', headerName: 'Fecha', width: 120},
    { 
      field: 'estado', 
      headerName: 'Estado', 
      width: 130,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        } else if (params.value === 'Correcto') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Correcto</span>';
        } else if (params.value === 'Observado') {
          return '<span class="badge-table bg-[#FFF0BF] text-[#F2A626]">Observado</span>';
        }
        return params.value;
      }
    },
    { field: 'observacion', headerName: 'Observacion', width: 120},
  ];
  colBalances: ColDef[] = [
    { field: 'codigo', headerName: 'Código de la cuenta', width: 120 },
    { field: 'descripcion', headerName: 'Descripción de la cuenta', flex:1, minWidth:200 },
    { field: 'nivel', headerName: 'Nivel', width: 80},
    { field: 'moneda', headerName: 'Moneda', width: 100},
    { field: 'saldoI', headerName: 'Saldo inicial', width: 120},
    { field: 'totalD', headerName: 'Total débitos', width: 120},
    { field: 'totalC', headerName: 'Total créditos', width: 120},
    { field: 'saldoF', headerName: 'Saldo final', width: 120},
    { field: 'diferencia', headerName: 'Diferencia', width: 80},
    { field: 'estado',
      headerClass: 'centrarencabezado',headerName: 'Estado', width: 80, cellRenderer: (params: any) => {
      const color = params.value === 'Cuadrado' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
      return `<span class="badge-table ${color}">${params.value}</span>`;},
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];


  private _reportePendiente = false;

  constructor(
    private toastService:ToastService,
    private modalController: ModalController,
  ) {
    // Configurar fechas
    this.minDate = new Date(2020, 0, 1);
    this.maxDate = new Date();
    this.startDate = new Date(2025, 0, 1);
    this.endDate = new Date(2025, 0, 31);

    // Cuando el loading termina y hay un reporte pendiente, procesar resultados
    effect(() => {
      const loading = this.reporteValidacionFacade.isLoading();
      if (!loading && this._reportePendiente) {
        this._reportePendiente = false;
        this.procesarReporte();
      }
    });
  }

  ngOnInit() {
    // Inicializar columnas según el tipo seleccionado por defecto
    this.inicializarColumnas();
  }
  
  /**
   * Inicializa las columnas de la tabla según el tipo seleccionado
   */
  private inicializarColumnas() {
    if(this.tipoSeleccionado.value == 'consistencia' || this.tipoSeleccionado.value == 'asientosDes'){
      this.columGenerada = this.colConst;
    } else if(this.tipoSeleccionado.value == 'consistenciaPre'){
      this.columGenerada = this.colConstPre;
    }
    // } else if(this.tipoSeleccionado.value == 'balance'){
    //   this.columGenerada = this.colBalances;
    // }
  }

  onBtReset() {
    if (this.gridApi) {
      this.gridApi.showLoadingOverlay();
    }
    this.reporteValidacionFacade.cargarConsistencia();
    this.reporteValidacionFacade.cargarConsistenciaPre();
    this.reporteValidacionFacade.cargarAsientosDes();
  }

  onUsuarioSeleccionado(event: any){
    console.log('Usuario seleccionado', event);
    this.usuarioSeleccionado = event;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onPeriodoSeleccionado(event: any) {
    console.log('Periodo seleccionado:', event);
    
  }

  onCentroCSeleccionado(event: any) {
    console.log('Periodo seleccionado:', event);
    this.centroCSeleccionado = event;
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
    this._reportePendiente = true;

    if (this.tipoSeleccionado.value === 'consistencia') {
      this.reporteValidacionFacade.cargarConsistencia();
    } else if (this.tipoSeleccionado.value === 'asientosDes') {
      this.reporteValidacionFacade.cargarAsientosDes();
    } else if (this.tipoSeleccionado.value === 'consistenciaPre') {
      this.reporteValidacionFacade.cargarConsistenciaPre();
    }
  }

  private procesarReporte() {
    if (this.tipoSeleccionado.value === 'consistencia') {
      this.columGenerada = this.colConst;
      this.filasGeneradas = [...this.reporteValidacionFacade.consistencia()];
    } else if (this.tipoSeleccionado.value === 'asientosDes') {
      this.columGenerada = this.colConst;
      this.filasGeneradas = [...this.reporteValidacionFacade.asientosDes()];
    } else if (this.tipoSeleccionado.value === 'consistenciaPre') {
      this.columGenerada = this.colConstPre;
      this.filasGeneradas = [...this.reporteValidacionFacade.consistenciaPre()];
    }
    this.toastService.success('¡Reporte generado exitosamente!');
  }

  // item = valor de la celda, enviado por VistaCellRenderComponent (ej: 'MN-001', 'PA-001')
  abrirModal(item: string, rowData: any) {
    if (!item || item === '-') return;

    if (item.startsWith('MN')) {
      this.modalAsiento(item, rowData);
    } else if (item.startsWith('PA')) {
      this.modalPreasiento(item, rowData);
    }
  }

  async modalAsiento(nroAsiento: string, rowData: any) {
      const asientoData = rowData.asientoData || [
        {
          cuentaContable: '1510.02',
          descripcion: 'Equipos de cocina - Revalorización',
          debito: 600.00,
          credito: 0.00
        },
        {
          cuentaContable: '3810.01',
          descripcion: 'Revalorización por inflación',
          debito: 0.00,
          credito: 600.00
        }
      ];
  
      const colDefs: ColDef[] = [
        { 
          field: 'cuentaContable', 
          headerName: 'Cuenta contable', 
          width: 130 
        },
        { 
          field: 'descripcion', 
          headerName: 'Descripción', 
          width: 150,
          flex: 1,
        },
        { 
          field: 'debito', 
          headerName: 'Débito', 
          width: 80,
          headerClass: 'centrarencabezado',
          cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
          valueFormatter: (params) => {
            if (params.value !== null && params.value !== undefined) {
              const absValue = Math.abs(params.value);
              const formattedValue = new Intl.NumberFormat('es-PE', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2,
              }).format(absValue);
              
              if (params.value < 0) {
                return `(${formattedValue})`;
              }
              return formattedValue;
            }
            return '-';
          },
        },
        { 
          field: 'credito', 
          headerName: 'Crédito', 
          width: 80,
          headerClass: 'centrarencabezado',
          cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
          valueFormatter: (params) => {
            if (params.value !== null && params.value !== undefined) {
              const absValue = Math.abs(params.value);
              const formattedValue = new Intl.NumberFormat('es-PE', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2,
              }).format(absValue);
              
              if (params.value < 0) {
                return `(${formattedValue})`;
              }
              return formattedValue;
            }
            return '-';
          },
        }
      ];
  
      const modal = await this.modalController.create({
        component: ModalDetalleComponent,
        cssClass: 'promo',
        componentProps: {
          tituloModal: `Asiento Contable: ${nroAsiento}`,
          widthModal: '700px',
          mostrarTabla: true,
          colDefs: colDefs,
          rowData: asientoData,
          mostrarTextarea: false,
          mostrarBotonEliminar: false,
          ocultarBotonConfirmar: true,
          textoBotonCancelar: 'Cerrar'
        }
      });
  
      await modal.present();
    }

    async modalPreasiento(npasiento: string, rowData: any) { 
      const asientoData = rowData.asientoData || [
        {
          cuentaContable: '1510.02',
          descripcion: 'Equipos de cocina - Revalorización',
          debito: 600.00,
          credito: 0.00
        },
        {
          cuentaContable: '3810.01',
          descripcion: 'Revalorización por inflación',
          debito: 0.00,
          credito: 600.00
        }
      ];
  
      const colDefs: ColDef[] = [
        { 
          field: 'cuentaContable', 
          headerName: 'Cuenta contable', 
          width: 130 
        },
        { 
          field: 'descripcion', 
          headerName: 'Descripción', 
          width: 150,
          flex: 1,
        },
        { 
          field: 'debito', 
          headerName: 'Débito', 
          width: 80,
          headerClass: 'centrarencabezado',
          cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
          valueFormatter: (params) => {
            if (params.value !== null && params.value !== undefined) {
              const absValue = Math.abs(params.value);
              const formattedValue = new Intl.NumberFormat('es-PE', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2,
              }).format(absValue);
              
              if (params.value < 0) {
                return `(${formattedValue})`;
              }
              return formattedValue;
            }
            return '-';
          },
        },
        { 
          field: 'credito', 
          headerName: 'Crédito', 
          width: 80,
          headerClass: 'centrarencabezado',
          cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
          valueFormatter: (params) => {
            if (params.value !== null && params.value !== undefined) {
              const absValue = Math.abs(params.value);
              const formattedValue = new Intl.NumberFormat('es-PE', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2,
              }).format(absValue);
              
              if (params.value < 0) {
                return `(${formattedValue})`;
              }
              return formattedValue;
            }
            return '-';
          },
        }
      ];
  
      const modal = await this.modalController.create({
        component: ModalDetalleComponent,
        cssClass: 'promo',
        componentProps: {
          tituloModal: `Pre asiento Contable: ${npasiento}`,
          widthModal: '700px',
          mostrarTabla: true,
          colDefs: colDefs,
          rowData: asientoData,
          mostrarTextarea: false,
          mostrarBotonEliminar: false,
          ocultarBotonConfirmar: true,
          textoBotonCancelar: 'Cerrar'
        }
      });
  
      await modal.present();
    }
}


