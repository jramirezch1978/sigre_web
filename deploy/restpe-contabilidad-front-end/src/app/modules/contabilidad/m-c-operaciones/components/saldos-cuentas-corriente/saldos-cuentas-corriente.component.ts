import { Component, OnInit, inject } from '@angular/core';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalController } from '@ionic/angular';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ModalDetalleAsientoComponent } from './modal-detalle-asiento/modal-detalle-asiento.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { CuentasCorrienteFacade } from '../../../application/facades/cuentas-corriente.facade';
import { CuentasCorrienteFeedbackEffects } from '../../../effects/cuentas-corriente-feedback.effect';

// Font Awesome Icons
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-saldos-cuentas-corriente',
  templateUrl: './saldos-cuentas-corriente.component.html',
  styleUrls: ['./saldos-cuentas-corriente.component.scss'],
  standalone: false,
})
export class SaldosCuentasCorrienteComponent implements OnInit {

  // Clean Architecture — Facade & Effects
  private readonly cuentasCorrienteFacade  = inject(CuentasCorrienteFacade);
  private readonly feedbackEffects         = inject(CuentasCorrienteFeedbackEffects);
  readonly isLoading                       = this.cuentasCorrienteFacade.isLoading;

  // Font Awesome Icons
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  pais= this.countryService.getCountryCode();
  countries= ALL_COUNTRIES;
  monedasignificado='';
  private gridApi!: GridApi;

  // Rango de fechas
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  // Control de estado de filtros
  hasFilter: boolean = false;
  canExport: boolean = false;

  // Arrays para selectores
  tiposCuentaCorriente = [
    { value: 'proveedores', label: 'Cuentas por cobrar' },
    { value: 'clientes', label: 'Cuentas por pagar' }
  ];

  cuentasContables = [
    { value: '42-103', label: '42-103' },
    { value: '12-101', label: '12-101' }
  ];

  tiposDocumento = [
    { value: 'factura', label: 'Factura' },
    { value: 'boleta', label: 'Boleta' },
    { value: 'notaCredito', label: 'Nota de crédito' },
    { value: 'notaDebito', label: 'Nota de débito' },
    { value: 'reciboHonorarios', label: 'Recibo por honorarios' }
  ];

  tiposTercero = [
    { value: 'cliente', label: 'Cliente' },
    { value: 'proveedor', label: 'Proveedor' }
  ];

  estadosDocumento = [
    { value: 'pendiente', label: 'Pendiente' },
    { value: 'pagado', label: 'Pagado' },
    { value: 'parcial', label: 'Pago parcial' }
  ];

  // Configuración de ag-grid
  columnTypes = {};

  gridOptions = {
    context: {
      componentParent: this,
    },
  };

  //Filtros Autocomplete

  buscarNombreCuenta = [
    { nombre: 'Proveedores cocina' },
    { nombre: 'Proveedores limpieza' },
    { nombre: 'Clientes nacionales' },
    { nombre: 'Clientes internacionales' },
    { nombre: 'Proveedores varios' },
  ];

  buscarNombreTercero = [
    { nombre: 'PROV-003-Pescados & Mariscos del Pacífico S.A.C.' },
    { nombre: 'PROV-001-Distribuidora Lima S.A.' },
    { nombre: 'PROV-002-Carnes Premium E.I.R.L.' },
    { nombre: 'CLI-001-Restaurante El Buen Sabor' },
    { nombre: 'CLI-002-Catering Express S.A.C.' },
  ];

  buscarNroDocumento = [
    { numero: 'FAC-001245' },
    { numero: 'FAC-001246' },
    { numero: 'FAC-001247' },
    { numero: 'BOL-000123' },
    { numero: 'BOL-000124' },
    { numero: 'NC-000045' },
    { numero: 'ND-000012' },
  ];

  localeText = {
    page: 'Página',
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
  };

  // Datos de la tabla - vacío al inicio
  rowData: any[] = [];

  colDefs: ColDef[] = [
    { field: 'cta_cte_razon_social', headerName: 'Razón social', width: 150 },
    { field: 'cta_cte_cuenta_contable', headerName: 'Cuenta contable', width: 140 },
    {
      field: 'cta_cte_nro_asiento',
      headerName: 'N° de asiento',
      width: 140,
      cellRenderer: VistaCellRenderComponent,
    },
    { field: 'cta_cte_doc_referencial', headerName: 'Doc. referencial', width: 120 },
    { field: 'cta_cte_fecha_asiento', headerName: 'Fecha asiento contable', width: 140 },
    { field: 'cta_cte_glosa', headerName: 'Glosa', flex: 1, minWidth: 200 },
    {
      field: 'cta_cte_debito',
      headerName: 'Débito',
      width: 100,
      valueFormatter: (params) => {
        if (params.value === null || params.value === undefined) return '–';
        const value = Number(params.value);
        if (isNaN(value)) return '–';
        return '' + value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
      },
      cellStyle: { textAlign: 'right' },
    },
    {
      field: 'cta_cte_credito',
      headerName: 'Crédito',
      width: 100,
      valueFormatter: (params) => {
        if (params.value === null || params.value === undefined) return '–';
        const value = Number(params.value);
        if (isNaN(value)) return '–';
        return '' + value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
      },
      cellStyle: { textAlign: 'right' },
    },
    {
      field: 'cta_cte_saldo',
      headerName: 'Saldo',
      width: 110,
      valueFormatter: (params) => {
        if (params.value === null || params.value === undefined) return '–';
        const value = Number(params.value);
        if (isNaN(value)) return '–';
        if (value < 0) {
          return '(' + Math.abs(value).toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + ')';
        }
        return '' + value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
      },
      cellStyle: (params) => {
        const style: any = { textAlign: 'right' };
        if (params.value !== null && params.value !== undefined) {
          const value = Number(params.value);
          if (!isNaN(value) && value < 0) {
            style.color = '#DC2626';
          }
        }
        return style;
      },
    },
    { field: 'cta_cte_antiguedad', headerName: 'Antigüedad', width: 90 },
    { field: 'cta_cte_moneda', headerName: 'Moneda', width: 100 },
  ];

  constructor(private modalController: ModalController, private countryService: CountryService) {
    // Configurar fechas
    this.minDate = new Date(2020, 0, 1);
    this.maxDate = new Date();
    this.startDate = new Date(2025, 0, 1);
    this.endDate = new Date(2025, 0, 31);
  }

  ngOnInit() {
    this.obtenerdatospais();
    this.cuentasCorrienteFacade.cargarDatos();
  }
  obtenerdatospais(){
    this.countries.find((country: any) => {
      if(country.codigo === this.pais){
        this.monedasignificado=country.monedapais[0].value
      }
    });
  }
  onBtReset() {
    this.cuentasCorrienteFacade.cargarDatos();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onCellClicked(event: any) {
    console.log('Celda clickeada:', event);
  }

  onPeriodoSeleccionado(event: any) {
    console.log('Periodo seleccionado:', event);
    this.onFilterChange();
  }

  filtrarPorFechas(event: any) {
    console.log('Rango de fechas seleccionado:', event);
    this.startDate = event.startDate;
    this.endDate = event.endDate;
    this.onFilterChange();
  }

  onFilterChange() {
    // Activar los botones cuando hay al menos un filtro seleccionado
    this.hasFilter = true;
  }

  buscar() {
    console.log('Buscando...');
    this.cuentasCorrienteFacade.cargarDatos();
    // Cargar los datos en la tabla al buscar
    this.rowData = [...this.cuentasCorrienteFacade.items()];
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
    // Deshabilitar Buscar y habilitar Exportar
    this.hasFilter = false;
    this.canExport = true;
  }

  async abrirModalDetalleAsiento(rowData: any) {
    console.log('Abriendo modal de detalle de asiento:', rowData);

    // Datos del asiento para la tabla
    const asientoData = [
      {
        cuenta: '631109',
        descripcion: 'Servicios de internet',
        debeS: 'S/ 380.00',
        haberS: '-',
        centroCosto: 'CC-SI01',
        docReferencial: 'F001- 000123',
        tercero: 'Claro Perú',
      },
      {
        cuenta: '421101',
        descripcion: 'Proveedores Nacionales / Cuentas por Pagar Comerciales',
        debeS: '-',
        haberS: 'S/380.00',
        centroCosto: 'CC-SI01',
        docReferencial: 'F001- 000123',
        tercero: 'Claro Perú',
      },
    ];

    // Definición de columnas para el modal
    const colDefsModal: ColDef[] = [
      {
        field: 'cuenta',
        headerName: 'Cuenta',
        width: 70,
        cellStyle: { fontSize: '11px' },
      },
      {
        field: 'descripcion',
        headerName: 'Descripción',
        width: 358,
        cellStyle: { fontSize: '11px' },
      },
     
      {
        field: 'debeS',
        headerName: 'Debe('+ this.monedasignificado +')',
        width: 70,
        headerClass: 'derechaencabezado',
        cellStyle: {
          textAlign: 'right',
          display: 'flex',
          justifyContent: 'end',
          alignItems: 'center',
        },
      },
    
      {
        field: 'haberS',
        headerName: 'Haber('+ this.monedasignificado +')',
        width: 70,
        headerClass: 'derechaencabezado',
        cellStyle: {
          textAlign: 'right',
          display: 'flex',
          justifyContent: 'end',
          alignItems: 'center',
        },
      },
    //    ...(this.pais != 'EC'
    // ? [{
    //     field: 'debeD',
    //     headerName: 'Debe(USD)',
    //     width: 70,
    //     headerClass: 'derechaencabezado',
    //     cellStyle: {
    //       textAlign: 'right',
    //       display: 'flex',
    //       justifyContent: 'end',
    //       alignItems: 'center',
    //     },
    //   },
    //   {
    //     field: 'haberD',
    //     headerName: 'Haber(USD)',
    //     width: 70,
    //     headerClass: 'derechaencabezado',
    //     cellStyle: {
    //       textAlign: 'right',
    //       display: 'flex',
    //       justifyContent: 'end',
    //       alignItems: 'center',
    //     },
    //   }
    // ]
    // : []),
      {
        field: 'centroCosto',
        headerName: 'Centro de costo',
        width: 90,
        cellStyle: { fontSize: '11px' },
      },
      {
        field: 'docReferencial',
        headerName: 'Doc. referencial',
        width: 90,
        cellStyle: { fontSize: '11px' },
      },
      {
        field: 'tercero',
        headerName: 'Tercero',
        width: 80,
        cellStyle: { fontSize: '11px' },
      },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleAsientoComponent,
      cssClass: 'promo',
      componentProps: {
        nroAsiento: rowData.cta_cte_nro_asiento || 'MN-2025-11-01-003',
        fechaRegistro: rowData.cta_cte_fecha_asiento || '12/12/2025',
        fechaContable: rowData.cta_cte_fecha_asiento || '12/12/2025',
        glosa:
          rowData.cta_cte_glosa ||
          'Provisión de servicios de internet – Local San Isidro (Mes 11/2025).',
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

  buscarDetalle(event: any) {}

  // Método llamado por VistaCellRenderComponent
  abrirModal(value: string, rowData: any) {
    this.abrirModalDetalleAsiento(rowData);
  }
}
