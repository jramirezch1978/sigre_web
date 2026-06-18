import { Component, OnInit, inject } from '@angular/core';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalController } from '@ionic/angular';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ModalDetalleAsientoComponent } from '../../../m-c-operaciones/components/saldos-cuentas-corriente/modal-detalle-asiento/modal-detalle-asiento.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { ConsultaCentroCostosFacade } from '../../../application/facades/consulta-centro-costos.facade';
import { ConsultaCentroCostosFeedbackEffects } from '../../../effects/consulta-centro-costos-feedback.effect';

// Font Awesome Icons
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';


@Component({
  selector: 'app-centro-costos-trabaj',
  templateUrl: './centro-costos-trabaj.component.html',
  styleUrls: ['./centro-costos-trabaj.component.scss'],
  standalone: false
})
export class CentroCostosTrabajComponent implements OnInit {

  // Clean Architecture — Facade & Effects
  private readonly consultaCentroCostosFacade = inject(ConsultaCentroCostosFacade);
  private readonly feedbackEffects            = inject(ConsultaCentroCostosFeedbackEffects);
  readonly isLoading                          = this.consultaCentroCostosFacade.isLoading;

  // Font Awesome Icons
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  pais= this.countryService.getCountryCode();
  private gridApi!: GridApi;
  activartoast= false;
  // Control de estados de botones
  botonBuscarHabilitado = false;
  botonExportarHabilitado = false;
  monedapais: any ='S/';
  monedasignificado='' ;
  countries= ALL_COUNTRIES;

  // Filtros seleccionados
  filtrosSeleccionados = {
    periodoContable: null,
    centroCosto: null,
    trabajador: null,
    areaDepartamento: null,
    tipoMovimiento: null,
    moneda: null,
    rangoFechas: null
  };

  // Rango de fechas
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  // Lista de trabajadores para el autocomplete
  trabajadores = [
    { id: 'trab-021', nombre: 'TRAB-021 - Luis Fernández Soto' },
    { id: 'trab-015', nombre: 'TRAB-015 - María González López' },
    { id: 'trab-032', nombre: 'TRAB-032 - Carlos Pérez Ruiz' },
    { id: 'trab-045', nombre: 'TRAB-045 - Ana Martínez Ramos' },
    { id: 'trab-058', nombre: 'TRAB-058 - Roberto Silva Torres' }
  ];
   centroCostos = [
    { id: 'cc-104', nombre: 'CC-104 - Cocina Central' },
    { id: 'cc-110', nombre: 'CC-110 - Logística y Almacén' },
    { id: 'cc-205', nombre: 'CC-205 - Atención en Sala' },
  ];

  areaDepa = [
    { id: 'operacion', nombre: 'Operaciones' },
    { id: 'admin', nombre: 'Administración' },
    { id: 'logistica', nombre: 'Logística' },
    { id: 'cocina', nombre: 'Cocina' },

  ];

  // Lista de centros de costo
  centrosCosto = [
    { id: 'cc-104', nombre: 'CC-104 - Cocina Central' },
    { id: 'cc-110', nombre: 'CC-110 - Logística y Almacén' },
    { id: 'cc-205', nombre: 'CC-205 - Atención en Sala' }
  ];

  // Lista de áreas/departamentos
  areasDepartamento = [
    { id: 'operaciones', nombre: 'Operaciones' },
    { id: 'administracion', nombre: 'Administración' },
    { id: 'logistica', nombre: 'Logística' },
    { id: 'cocina', nombre: 'Cocina' }
  ];

  // Configuración de ag-grid
  columnTypes = {
    precioColumn: {
      valueFormatter: (params: any) => {
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
        return '';
      },
      cellStyle: (params: any) => {
        const style: any = { textAlign: 'right' };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      }
    }
  };
  colDefs: ColDef[] = [];

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

  // Datos que se mostrarán en la tabla (inicialmente vacío)
  rowData: any[] = [];

  constructor(
    private modalController: ModalController, 
    private toastService: ToastService,
    private countryService: CountryService,
    ) {
    // Configurar fechas
    this.minDate = new Date(2020, 0, 1);
    this.maxDate = new Date();
    this.startDate = new Date(2025, 0, 1);
    this.endDate = new Date(2025, 0, 31);
  }

  ngOnInit() {
    this.obtenerdatospais();
    this.incializartablas();
    this.consultaCentroCostosFacade.cargarDatos();
  }
  incializartablas(){
    this.colDefs = [
      { field: 'cc_trab_cod_ceco', headerName: 'Cód. CECO', width: 80 },
      { field: 'cc_trab_descripcion', headerName: 'Descripción', width: 150 },
      { field: 'cc_trab_cod_trabajador', headerName: 'Cód. trabajador', width: 110 },
      { field: 'cc_trab_nombre', headerName: 'Nombre', width: 140 },
      { field: 'cc_trab_usuario_registro', headerName: 'Usuario registro', width: 110 },
      { field: 'cc_trab_area_departamento', headerName: 'Área / Depa.', width: 100 },
      { field: 'cc_trab_cuenta_contable', headerName: 'Cuenta contable', width: 120 },
      { field: 'cc_trab_glosa_contable', headerName: 'Glosa contable', flex:1,minWidth:200 },
      { field: 'cc_trab_fecha_contable', headerName: 'Fecha contable', width: 110 },
      { 
        field: 'cc_trab_doc_origen', 
        headerName: 'Doc. origen', 
        width: 130,
        // cellRenderer: VistaCellRenderComponent 
      },
    ];
    this.colDefs.push(
      { field: 'cc_trab_moneda_s', headerName: 'Moneda ('+ this.monedasignificado +')', headerClass:"derechaencabezado", width: 100, type: 'precioColumn',
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
        valueFormatter: (params: any) => {
          if(params.value){
            return `${this.monedapais} ${params.value}`;
          }
          return '-'
        }
      },
    )
    

    if(this.pais!='EC'){

      this.colDefs.push(
        { field: 'cc_trab_moneda_d', headerName: 'Moneda (USD)', headerClass:"derechaencabezado", width: 100, type: 'precioColumn',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          valueFormatter: (params: any) => {
            if(params.value){
              return `$ ${params.value}`;
            }
            return '-'
          }
        }
      )
    }
  }
  obtenerdatospais(){
    this.countries.find((country: any) => {
      if(country.codigo === this.pais){
        this.monedasignificado=country.monedapais[0].value
      }
    });
  }
  /**
   * Verifica si al menos un filtro está seleccionado
   */
  private verificarFiltros(): void {
    const alMenosUnFiltroSeleccionado = Object.values(this.filtrosSeleccionados).some(valor => valor !== null);
    this.botonBuscarHabilitado = alMenosUnFiltroSeleccionado;
  }

  onBtReset() {
    this.consultaCentroCostosFacade.cargarDatos();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onCellClicked(event: any) {
    console.log('Celda clickeada:', event);
  }

  onPeriodoSeleccionado(event: any) {
    console.log('Periodo seleccionado:', event);
    this.filtrosSeleccionados.periodoContable = event;
    this.verificarFiltros();
  }

  onCentroCostoSeleccionado(event: any) {
    console.log('Centro de costo seleccionado:', event);
    this.filtrosSeleccionados.centroCosto = event.detail.value;
    this.verificarFiltros();
  }

  onTrabajadorSeleccionado(event: any) {
    console.log('Trabajador seleccionado:', event);
    this.filtrosSeleccionados.trabajador = event;
    this.verificarFiltros();
  }

  onAreaDepartamentoSeleccionado(event: any) {
    console.log('Área/Departamento seleccionado:', event);
    this.filtrosSeleccionados.areaDepartamento = event.detail.value;
    this.verificarFiltros();
  }

  onTipoMovimientoSeleccionado(event: any) {
    console.log('Tipo de movimiento seleccionado:', event);
    this.filtrosSeleccionados.tipoMovimiento = event.detail.value;
    this.verificarFiltros();
  }

  onMonedaSeleccionada(event: any) {
    console.log('Moneda seleccionada:', event);
    this.filtrosSeleccionados.moneda = event.detail.value;
    this.verificarFiltros();
  }

  onAreaSeleccionada(event: any) {
    console.log('Área/Departamento seleccionado:', event);
  }

  filtrarPorFechas(event: any) {
    console.log('Rango de fechas seleccionado:', event);
    this.startDate = event.startDate;
    this.endDate = event.endDate;
    this.filtrosSeleccionados.rangoFechas = event;
    this.verificarFiltros();
  }

  buscar() {
    if (!this.botonBuscarHabilitado) {
      return;
    }

    console.log('Buscando con filtros:', this.filtrosSeleccionados);
    if(this.activartoast === false){
      this.toastdanger();
      this.activartoast=true;
    }
    else if(this.activartoast=== true){
    // Mostrar loading
    this.consultaCentroCostosFacade.cargarDatos();
    // Simular búsqueda con los datos
    setTimeout(() => {
      // Cargar los datos en la tabla
      this.rowData = [...this.consultaCentroCostosFacade.items()];
            
      // Habilitar el botón de exportar después de la búsqueda exitosa
      this.botonExportarHabilitado = true;
    }, 500);
    
  }
  }

  async modalverActualizaciones() {
    // Definir las columnas
    const colDefs: ColDef[] = [
      {  headerName: 'Fecha y hora',  field: 'fechaHora', width: 150 },
      {  headerName: 'Usuario',  field: 'usuario', width: 120 },
      {  headerName: 'Acción',  field: 'accion', width: 150 },
      {  headerClass:'centrarencabezado', headerName: 'Detalle del cambio',
         cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center'},
         field: 'detalleCambio', flex: 1 },
    ];

    // Datos de actualizaciones de centros de costo
    const rowData = [
      { fechaHora: '15/11/2025 09:15', usuario: 'Luis Fernández', accion: 'Asignación', detalleCambio: 'Asignado a CC-104 - Cocina Central' },
      { fechaHora: '16/11/2025 14:30', usuario: 'María González', accion: 'Reasignación', detalleCambio: 'Reasignado de CC-104 a CC-110 - Logística y Almacén' },
      { fechaHora: '17/11/2025 10:00', usuario: 'Carlos Pérez', accion: 'Ajuste', detalleCambio: 'Ajuste de horas en CC-110 - Logística y Almacén' },
      { fechaHora: '18/11/2025 08:45', usuario: 'Ana Martínez', accion: 'Actualización', detalleCambio: 'Cambio de moneda de asignación en CC-205'  }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones de Centros de Costo',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
       
      }
    });
    
    await modal.present();
  }

  // Método llamado por VistaCellRenderComponent
  abrirModal(value: string, rowData: any) {
    this.abrirModalDetalleAsiento(rowData);
  }

  async abrirModalDetalleAsiento(rowData: any) {
    console.log('Abriendo modal de detalle de asiento:', rowData);

    // Datos del asiento para la tabla
    const asientoData = [
      { cuenta: '631109', descripcion: 'Servicios de internet', debeS: 'S/ 380.00', haberS: '-', centroCosto: 'CC-SI01', docReferencial: 'F001- 000123', tercero: 'Claro Perú' },
      { cuenta: '421101', descripcion: 'Proveedores Nacionales / Cuentas por Pagar Comerciales', debeS: '-', haberS: 'S/380.00', centroCosto: 'CC-SI01', docReferencial: 'F001- 000123', tercero: 'Claro Perú' },
    ];

    // Definición de columnas para el modal
    const colDefsModal: ColDef[] = [
      { field: 'cuenta', headerName: 'Cuenta', width: 70, cellStyle: { fontSize: '11px' }, },
      { field: 'descripcion', headerName: 'Descripción', width: 358, cellStyle: { fontSize: '11px' }, },
      { field: 'debeS', headerName: 'Debe(S/)', width: 70, headerClass: 'centrarencabezado', cellStyle: { textAlign: 'right', fontSize: '11px' }, },
      { field: 'haberS', headerName: 'Haber(S/)', width: 70, headerClass: 'centrarencabezado', cellStyle: { textAlign: 'right', fontSize: '11px' }, },
      { field: 'centroCosto', headerName: 'Centro de costo', width: 90, cellStyle: { fontSize: '11px' }, },
      { field: 'docReferencial', headerName: 'Doc. referencial', width: 90, cellStyle: { fontSize: '11px' }, },
      { field: 'tercero', headerName: 'Tercero', width: 80, cellStyle: { fontSize: '11px' }, },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleAsientoComponent,
      cssClass: 'promo',
      componentProps: {
        nroAsiento: rowData.cc_trab_doc_origen || 'MN-2025-11-01-003',
        fechaRegistro: rowData.cc_trab_fecha_contable || '12/12/2025',
        fechaContable: rowData.cc_trab_fecha_contable || '12/12/2025',
        glosa: rowData.cc_trab_glosa_contable || 'Provisión de servicios de internet – Local San Isidro (Mes 11/2025).',
        total: 'S/380.00',
        duplicado: 'No',
        asientoData: asientoData,
        colDefs: colDefsModal,
        totalDebeS: 'S/380.00',
        totalHaberS: 'S/380.00',
        totalDebeD: '$112.94',
        totalHaberD: '$112.94',
      },
    });

    await modal.present();
  }
  toastdanger(){
    this.toastService.warning('No se encontraron movimientos para los filtros seleccionados')
  }

}