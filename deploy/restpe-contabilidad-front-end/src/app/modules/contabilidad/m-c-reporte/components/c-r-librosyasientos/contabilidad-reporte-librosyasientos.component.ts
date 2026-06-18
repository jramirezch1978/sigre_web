import { Component, OnInit, inject, effect } from '@angular/core';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ToastService } from 'src/app/ui/services/toast.service';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { LibrosAsientosFacade } from 'src/app/modules/contabilidad/application/facades/libros-asientos.facade';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCreditCard, faDownload, faFileAlt, faList, faRotateRight, faSackDollar, faScaleBalanced } from '@fortawesome/pro-solid-svg-icons';
import { IconDefinition } from '@fortawesome/fontawesome-svg-core';



export interface card{
  title: string,
  cantidad: string,
  icon: IconDefinition,
}

export interface registro{
  formato:string,
  fecha: string,
  total: string,
  archivo: string,
  usuario: string
}
@Component({
  selector: 'app-contabilidad-reporte-librosyasientos',
  templateUrl: './contabilidad-reporte-librosyasientos.component.html',
  styleUrls: ['./contabilidad-reporte-librosyasientos.component.scss'],
  standalone: false,
})
export class ContabilidadReporteLibrosyasientosComponent  implements OnInit {
  private readonly librosAsientosFacade = inject(LibrosAsientosFacade);

  // Señal de carga
  readonly isLoading = this.librosAsientosFacade.isLoading;

  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCreditCard = faCreditCard;
  fasDownload = faDownload;
  fasFileAlt = faFileAlt;
  fasList = faList;
  fasRotateRight = faRotateRight;
  fasSackDollar = faSackDollar;
  fasScaleBalanced = faScaleBalanced;


  private gridApi!: GridApi;

  // Rango de fechas
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  estadoSeleccionado: string= 'todos';
  estadoVSeleccionado: string= 'todos';
  libroSeleccionado: string= 'todos';
  tlibroSeleccionado: string= 'todos';
  comprobanteSeleccionado: string= 'todos';
  origenSeleccionado: string= 'todos';
  monedaSeleccionada: string= 'todos';
  formatoSeleccionado: string= '5.1';
  tArchivoSeleccionado: string= 'txt';
  fechaSeleccionada: string = 'todas';

  columGenerada: ColDef[] = [];
  filasGeneradas: any[] = [];
  filasPinnadas: any[] = [];
  reporteGenerado: boolean = false;
  componenteListo: boolean = false; // Nueva bandera de control
  
  // Propiedades para evitar bucle infinito en getters
  columnasActuales: ColDef[] | (ColDef | any)[] = [];
  datosActuales: any[] = [];

  incluirNul: boolean = false;
  mostrarSin: boolean = false;
  countries= ALL_COUNTRIES;
  entidad= this.countries.find(c => c.codigo === this.countryService.getCountryCode())?.entidad;
  directorio= '';

  registro: registro | null = null;

  opcionesTipoReporte = [
    // { label: 'Asientos contables', value: 'asientos' },
    { label: 'Libro diario', value: 'libroD' },
    { label: 'Libro mayor', value: 'libroM' },
    { label: 'Balance de comprobación', value: 'balanComprob' },
    { label: 'Reportes contables ' + this.entidad , value: 'reportesSunat' },
  ];
  estados=[
    { label: 'Todos los estados', value: 'todos' },
    { label: 'Activos', value: 'activos' },
    { label: 'Pendiente', value: 'pendiente' },
    { label: 'Anulado', value: 'anulado' },
  ];
  estadosV=[
    { label: 'Todos los estados', value: 'todos' },
    { label: 'Correctos', value: 'correctos' },
    { label: 'Observados', value: 'observados' },
    { label: 'Pendientes', value: 'pendientes' },
  ];
  formatos: any[] = [];
  comprobantes=[
    { label: 'Todos los comprobantes', value: 'todos' },
    { label: 'Libro diario', value: 'libroD' },
    { label: 'Registro de compras', value: 'rcompras' },
    { label: 'Registro de ventas', value: 'rventas' },
  ];
  tArchivos=[
    { label: 'TXT', value: 'txt' },
    { label: 'Excel (CSV)', value: 'csv' },
    { label: 'XML', value: 'xml' },
    { label: 'XLS', value: 'xls' },
  ];
  libros:any=[
    // { label: 'Todos los libros', value: 'todos' },
    // { label: 'Libro diario', value: '005' },
    // { label: 'libro mayor', value: '006' },
    // { label: 'libro caja', value: '001' },
    // { label: 'Registro de compras', value: '008' },
    // { label: 'Registro de ventas', value: '014' },
  ];
  tlibros: any= [
    // { label: 'Todos los libros', value: 'todos' },
    // { label: 'Libro diario', value: '005' },
    // { label: 'libro mayor', value: '006' },
    // { label: 'libro caja', value: '001' },
    // { label: 'Registro de compras', value: '008' },
    // { label: 'Registro de ventas', value: '014' },
  ];
  monedas=[
    { label: 'Todas las monedas', value: 'todos' },
    { label: 'Soles', value: 'soles' },
    { label: 'Dólares', value: 'dolares' },
  ];
  fechasDisponibles=[
    { label: 'Todas las fechas', value: 'todas' },
    { label: 'Enero 2025', value: '2025-01' },
    { label: 'Febrero 2025', value: '2025-02' },
    { label: 'Marzo 2025', value: '2025-03' },
    { label: 'Abril 2025', value: '2025-04' },
    { label: 'Mayo 2025', value: '2025-05' },
  ];
  usuarios=[
    { id: 0, nombre: 'Todos los usuarios' },
    { id: 1, nombre: 'J. Pérez' },
    { id: 2, nombre: 'M. Gómez' },
    { id: 3, nombre: 'R. Torres' },
    { id: 4, nombre: 'L. Ruiz' },
    { id: 5, nombre: 'A. Castillo' },
    { id: 6, nombre: 'S. Medina' },
    { id: 7, nombre: 'F. Alvarez' },
    { id: 8, nombre: 'C. Herrera' }
  ];
  centroC=[
    { id: 0, nombre: 'Todos los centros' },
    { id: 1, nombre: 'Edificios e instalaciones' },
    { id: 2, nombre: 'Edificios administrativos' },
    { id: 3, nombre: 'Almacenes y bodegas' },
    { id: 4, nombre: 'Equipo de transportes' },

  ];
  cuentaC=[
    { id: 0, nombre: 'Todas las cuentas', codigo: '-1' },
    { id: 1, nombre: '10023 - Cuentas por Pagar', codigo: '10023' },
    { id: 2, nombre: '10024 - Cuentas por Cobrar', codigo: '10024' },
    { id: 3, nombre: '11023 - Inventario', codigo: '11023' },
    { id: 4, nombre: '12023 - Activos Fijos', codigo: '12023' },
    { id: 5, nombre: '13023 - Depreciación Acumulada', codigo: '13023' },
    { id: 6, nombre: '20023 - Gastos Operativos', codigo: '20023' },
    { id: 7, nombre: '30023 - Ingresos', codigo: '30023' },
    { id: 8, nombre: '40023 - Gastos Administrativos', codigo: '40023' }
  ]

  usuarioSeleccionado: any = this.usuarios[0];
  centroCSeleccionado: any = this.centroC[0];
  cuentaCSeleccionada: any = this.cuentaC[0];
  tipoSeleccionado: any = this.opcionesTipoReporte[0];

  cardSelect : card[] = [];

  cardAsientos=[
    {title:'Total de débitos', cantidad: 'S/ 0.00', icon: faSackDollar},
    {title:'Total de créditos', cantidad: 'S/ 0.00', icon: faCreditCard},
    {title:'Diferencia (Débitos - Créditos)', cantidad: 'S/ 0.00', icon: faScaleBalanced},
    {title:'N° de asientos procesados', cantidad: '00', icon: faList},
  ];
  cardLibroM=[
    {title:'Total de débitos del periodo', cantidad: 'S/ 0.00', icon: faSackDollar},
    {title:'Total de créditos del periodo', cantidad: 'S/ 0.00', icon: faCreditCard},
    {title:'Total de saldos', cantidad: 'S/ 0.00', icon: faFileAlt},
  ];
  cardLibroD=[
    {title:'Total de débitos del periodo', cantidad: 'S/ 0.00', icon: faSackDollar},
    {title:'Total de créditos del periodo', cantidad: 'S/ 0.00', icon: faCreditCard},
    {title:'Diferencia (Débitos - Créditos)', cantidad: 'S/ 0.00', icon: faFileAlt},
    {title:'N° de asientos listados', cantidad: '00', icon: faList},
  ]

  // Configuración de ag-grid
  columnTypes = {};

  gridOptions = {
    context: {
      componentParent: this,
    },
    suppressRowTransform: true,
    getRowStyle: (params: any) => {
      if (params.node.rowPinned && params.data) {
        if (params.data._tipoFila === 'total-principal') {
          return { background: '#CEE0FD', fontWeight: '600', border: 1 }; // primary-10
        } else if (params.data._tipoFila === 'calculos-totales') {
          return { background: '#ECF4FF', fontWeight: '500', border: 0 }; // primary-5
        } else if (params.data._tipoFila === 'total-final') {
          return { background: '#ECF4FF', fontWeight: '500', border: 0 }; // primary-5
        }
      }
      return undefined;
    },
    getRowHeight: (params: any) => {
      if (params.node.rowPinned && params.data && params.data._tipoFila === 'calculos-totales') {
        return undefined; // Usar altura por defecto, el rowSpan manejará la expansión
      }
      return undefined;
    }
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
  dataReporte:registro ={formato:'5.1 - Libro diario', fecha: '15/11/2025, 12:48', total: '317', archivo: 'SUNAT_5_1_diario_202511_1763228883179.txt', usuario: 'Javier Correa'}

  rowAsiento = [
    { fechaC: '30/10/2025', nlibro: '005', nasiento: 'MN-2025-11-01-001', glosa: 'Factura 4587', codigoC: '1010', descripcionC: 'Caja general', centroC: 'CC001', totalD: 1500.00, totalC: 1500.00, estado: 'Activo', usuario: 'Juan Pérez', moneda: 'Soles'},
    { fechaC: '29/10/2025', nlibro: '006', nasiento: 'MN-2025-11-01-001', glosa: 'Recepción de mercadería', codigoC: '2010', descripcionC: 'Proveedores', centroC: 'CC001', totalD: 1500.00, totalC: 1500.00, estado: 'Pendiente', usuario: 'Juan Pérez', moneda: 'Soles'},
    { fechaC: '30/10/2025', nlibro: '001', nasiento: 'MN-2025-11-01-001', glosa: 'Ajuste de fin de mes', codigoC: '1010', descripcionC: 'Caja general', centroC: 'CC002', totalD: 1500.00, totalC: 1500.00, estado: 'Activo', usuario: 'Juan Pérez', moneda: 'Soles'},
    { fechaC: '31/10/2025', nlibro: '008', nasiento: 'MN-2025-11-01-001', glosa: 'Pago de planilla', codigoC: '3010', descripcionC: 'Ventas', centroC: 'CC003', totalD: 1500.00, totalC: 1500.00, estado: 'Pendiente', usuario: 'Juan Pérez', moneda: 'Soles'},
    { fechaC: '30/10/2025', nlibro: '014', nasiento: 'MN-2025-11-01-001', glosa: 'Depósito bancario', codigoC: '4100', descripcionC: 'Ventas', centroC: 'CC004', totalD: 1500.00, totalC: 1500.00, estado: 'Anulado', usuario: 'Juan Pérez', moneda: 'Soles'}
  ];
  rowLibroM: any[] = [];
  rowLibroD: any[] = [];
  rowBalanceComprob: any[] = [];

  colAsiento: ColDef[] = [
    { field: 'fechaC', headerName: 'Fecha contable', width: 140 },
    { field: 'nlibro', headerName: 'N° Libro', width: 60},
    { field: 'nasiento', headerName: 'N° Asiento', width: 120},
    { field: 'glosa', headerName: 'Glosa', width: 180},
    { field: 'codigoC', headerName: 'Código de cuenta', width: 120 },
    { field: 'descripcionC', headerName: 'Descripción de la cuenta', flex:1, minWidth:200 },
    { field: 'centroC', headerName: 'Centro de costo', width: 120,},
    { field: 'totalD', headerName: 'Total débitos', width: 120, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right',}
    },
    { field: 'totalC', headerName: 'Total créditos', width: 120, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right',}  
    },
    { field: 'estado', headerName: 'Estado', width: 90, headerClass: 'centrarencabezado',
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
    { field: 'usuario', headerName: 'Usuario', width: 120},
    { field: 'moneda', headerName: 'Moneda', width: 80},
  ];
  colLibroM: ColDef[] = [
    { field: 'codigoC', headerName: 'Código de la cuenta', width: 170 },
    { field: 'descripcionC', headerName: 'Descripción de cuenta', width:200 },
    { field: 'fechaC', headerName: 'Fecha contable', width: 120},
    { field: 'nasiento', headerName: 'N° Asiento', width: 120},
    { field: 'glosa', headerName: 'Glosa', minWidth: 200},
    { field: 'saldoInicial', headerName: 'Saldo inicial', width: 70},
    { field: 'centroC', headerName: 'Centro de costo', width: 120},
    { field: 'debito', headerName: 'Débito', width: 80},
    { field: 'credito', headerName: 'Crédito', width: 80},
    { field: 'saldo', headerName: 'Saldo acumulado', width: 120},
    { field: 'moneda', headerName: 'Moneda', width: 120},
    { field: 'usuario', headerName: 'Usuario', width: 120},
  ];
  colLibroD: ColDef[] = [
    { field: 'fechaC', headerName: 'Fecha Contable', width: 140 },
    { field: 'nlibro', headerName: 'N° Libro', width: 80},
    { field: 'nasiento', headerName: 'N° documento', width: 170},
    { field: 'glosa', headerName: 'Razón social', flex:1, minWidth:200},
    { field: 'codigoC', headerName: 'Código de Cuenta', width: 140 },
    { field: 'descripcionC', headerName: 'Descripción de la cuenta', width: 200 },
    { field: 'debito', headerName: 'Debe', width: 120, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right',}
    },
    { field: 'credito', headerName: 'Haber', width: 120, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right',}  
    },
    { field: 'estado', headerName: 'Estado', width: 100, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        } else if (params.value === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
        } else if (params.value === 'Pagada') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagada</span>';
        } else if (params.value === 'Anulado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulado</span>';
        }
        return params.value;
      }
    },
  ];
  colBalanceComprob: (ColDef | any)[] = [
    { field: 'codigo', headerName: 'Código', width: 80,
      colSpan: (params: any) => {
        if (params.data && params.data._tipoFila === 'calculos-totales') {
          return 1;
        }
        return 1;
      },
      rowSpan: (params: any) => {
        if (params.data && params.data._tipoFila === 'calculos-totales') {
          return 3;
        }
        return 1;
      },
      cellStyle: (params: any) => {
        if (params.data && params.data._tipoFila === 'calculos-totales') {
          return { display: 'none' };
        }
        return {};
      }
    },
    { field: 'denominacion', headerName: 'Denominación de cuenta', flex: 1, minWidth: 200,
      colSpan: (params: any) => {
        if (params.data && params.data._tipoFila === 'calculos-totales') {
          return 1;
        }
        return 1;
      },
      rowSpan: (params: any) => {
        if (params.data && params.data._tipoFila === 'calculos-totales') {
          return 3;
        }
        return 1;
      },
      cellClassRules: { 'cell-span': (params: any) => params.data && params.data._tipoFila === 'calculos-totales'},
      cellStyle: (params: any) => {
        if (params.data && params.data._tipoFila === 'calculos-totales') {
          return { textAlign: 'left', paddingLeft: '16px', display: 'flex', alignItems: 'center', fontSize: '10px', fontWeight: '600', backgroundColor: '#ffffff'};
        }
        if (params.data && params.data._tipoFila === 'total-principal') {
          return {
            backgroundColor: '#ffffff'
          };
        }
        else{
          return {
            backgroundColor: '#ffffff'
          };
        }
        return {};
      }
    },
    { headerName: 'Movimientos', headerClass: 'centrarencabezado grupo-columna-border',
      children: [
        { field: 'movDebe', headerName: 'Debe', width: 120, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
          valueFormatter: (params: any) => {
            if (params.value) {
              return params.value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }
            return '';
          }
        },
        { field: 'movHaber', headerName: 'Haber', width: 120, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
          valueFormatter: (params: any) => {
            if (params.value) {
              return params.value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }
            return '';
          }
        }
      ]
    },
    { headerName: 'Saldos', headerClass: 'centrarencabezado grupo-columna-border',
      children: [
        { field: 'saldoDeudor', headerName: 'Deudor', width: 120, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
          valueFormatter: (params: any) => {
            if (params.value) {
              return params.value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }
            return '';
          }
        },
        { field: 'saldoAcreedor', headerName: 'Acreedor', width: 120, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
          valueFormatter: (params: any) => {
            if (params.value) {
              return params.value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }
            return '';
          }
        }
      ]
    },
    { headerName: 'Inventario', headerClass: 'centrarencabezado grupo-columna-border',
      children: [
        { field: 'inventarioActivo', headerName: 'Activo', width: 120, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
          valueFormatter: (params: any) => {
            if (params.value) {
              return params.value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }
            return '';
          }
        },
        { field: 'inventarioPasivo', headerName: 'Pasivo', width: 120, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
          valueFormatter: (params: any) => {
            if (params.value) {
              return params.value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }
            return '';
          }
        }
      ]
    },
    { headerName: 'EE.GG.PP Función',  headerClass: 'centrarencabezado grupo-columna-border',
      children: [
        { field: 'eePerdidas', headerName: 'Pérdidas', width: 120, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
          valueFormatter: (params: any) => {
            if (params.value) {
              return params.value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }
            return '';
          }
        },
        { field: 'eeGanancias', headerName: 'Ganancias', width: 120, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'
          },
          valueFormatter: (params: any) => {
            if (params.value) {
              return params.value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }
            return '';
          }
        }
      ]
    },
    { headerName: 'Transf. y cancel', headerClass: 'centrarencabezado grupo-columna-border',
      children: [
        { field: 'transfCargo', headerName: 'Cargo', width: 120, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
          valueFormatter: (params: any) => {
            if (params.value) {
              return params.value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }
            return '';
          }
        },
        { field: 'transfAbono', headerName: 'Abono', width: 120, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
          valueFormatter: (params: any) => {
            if (params.value) {
              return params.value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }
            return '';
          }
        }
      ]
    },
    { headerName: 'Saldos', headerClass: 'centrarencabezado grupo-columna-border',
      children: [
        { field: 'saldo2Deudor', headerName: 'Deudor', width: 120, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
          valueFormatter: (params: any) => {
            if (params.value) {
              return params.value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }
            return '';
          }
        },
        { field: 'saldo2Acreedor', headerName: 'Acreedor', width: 120, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
          valueFormatter: (params: any) => {
            if (params.value) {
              return params.value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }
            return '';
          }
        }
      ]
    },
    { headerName: 'EE.GG.PP Natural', headerClass: 'centrarencabezado grupo-columna-border',
      children: [
        { field: 'eeNaturalPerdidas', headerName: 'Pérdidas', width: 120, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
          valueFormatter: (params: any) => {
            if (params.value) {
              return params.value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }
            return '';
          }
        },
        { field: 'eeNaturalGanancias', headerName: 'Ganancias', width: 120, headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
          valueFormatter: (params: any) => {
            if (params.value) {
              return params.value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }
            return '';
          }
        }
      ]
    }
  ];

  constructor(
    private toastService : ToastService,
    private simulation: SimulationService,
    private countryService: CountryService, 
  ) {
    // Configurar fechas
    this.minDate = new Date(2020, 0, 1);
    this.maxDate = new Date();
    this.startDate = new Date(2025, 0, 1);
    this.endDate = new Date(2025, 0, 31);
    // Poblar arrays locales desde el facade de libros y asientos
    effect(() => {
      this.rowLibroM = this.librosAsientosFacade.libroMayor();
    });
    effect(() => {
      this.rowLibroD = this.librosAsientosFacade.libroDiario();
    });
    effect(() => {
      this.rowBalanceComprob = this.librosAsientosFacade.balanceComprobacion();
    });
    // Cuando el loading termina y hay un reporte pendiente, procesar resultados
    effect(() => {
      const loading = this.librosAsientosFacade.isLoading();
      if (!loading && this._reportePendiente) {
        this._reportePendiente = false;
        this.procesarReporte();
      }
    });
  }

  ngOnInit() {
    
    try {
      // Inicializar formatos según el país
      this.inicializarFormatos();
      
      // Inicializar propiedades críticas primero
      this.cardSelect = this.cardLibroD;
      
      // Actualizar columnas y datos para evitar bucle en getters
      this.actualizarColumnasYDatos();
      
      // Marcar componente como listo
      this.componenteListo = true;
      
      // Cargar datos de forma segura con timeout para no bloquear el render
      setTimeout(() => {
        this.cargarEntidad();
        this.librocontablesporpais();
      }, 100);
    } catch (error) {
    }
  }
  
  /**
   * Inicializar formatos según el país
   */
  private inicializarFormatos() {
    const pais = this.countryService.getCountryCode();
    
    this.formatos = [
      { label: 'Libro Diario', value: '5.1' },
      // { label: 'Libro diario simplificado', value: '5.3' },
    ];
    
    // Solo agregar Libro de inventarios si es Guatemala
    if (pais === 'GT') {
      this.formatos.push({ label: 'Libro de inventarios', value: '6.1' });
    }
    
    this.formatos.push(
      { label: 'Libro mayor', value: '6.1' },
      { label: 'Registro de compras', value: '8.1' },
      { label: 'Registro de ventas', value: '14.1' }
    );
  }
  librocontablesporpais(){
    const country = this.countries.find(
    c => c.codigo === this.countryService.getCountryCode()
    );
    this.tlibros= country?.libroscontables || [];
    
    // Filtrar para excluir "libro mayor" y "libro diario"
    const librosCompletos = country?.libroscontables || [];
    this.libros = librosCompletos.filter((libro: any) => {
      const labelLower = libro.label?.toLowerCase() || '';
      return !labelLower.includes('libro mayor') && !labelLower.includes('libro diario');
    });
  }
  cargarEntidad() {
    const country = this.countries.find(
    c => c.codigo === this.countryService.getCountryCode()
    );
    this.entidad = country?.entidad || '';
    return this.entidad;
  }
  onBtReset() {
    if (this.gridApi) {
      this.gridApi.showLoadingOverlay();
    }
    // Recargar datos desde el facade según el tipo seleccionado
    this.librosAsientosFacade.cargarLibroMayor();
    this.librosAsientosFacade.cargarLibroDiario();
    this.librosAsientosFacade.cargarBalanceComprobacion();
  }

  onUsuarioSeleccionado(event: any){
    this.usuarioSeleccionado = event;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onPeriodoSeleccionado(event: any) {
    
  }

  onCentroCSeleccionado(event: any) {
    this.centroCSeleccionado = event;
  }

  onCuentaCSeleccionada(event: any) {
    this.cuentaCSeleccionada = event;
  }

  filtrarPorFechas(event: any) {
    this.startDate = event.startDate;
    this.endDate = event.endDate;
  }

  /**
   * Actualizar columnas y datos actuales - Reemplaza los getters para evitar bucle infinito
   */
  private actualizarColumnasYDatos() {
    if (this.reporteGenerado) {
      this.columnasActuales = this.columGenerada;
      this.datosActuales = this.filasGeneradas;
    } else {
      // Determinar columnas según el tipo seleccionado
      if (!this.tipoSeleccionado || !this.tipoSeleccionado.value) {
        this.columnasActuales = this.colLibroD;
      } else {
        switch (this.tipoSeleccionado.value) {
          case 'asientos':
            this.columnasActuales = this.colAsiento;
            break;
          case 'libroM':
            this.columnasActuales = this.colLibroM;
            break;
          case 'libroD':
            this.columnasActuales = this.colLibroD;
            break;
          case 'balanComprob':
            this.columnasActuales = this.colBalanceComprob;
            break;
          default:
            this.columnasActuales = this.colLibroD;
        }
      }
      // Array vacío hasta que se genere el reporte
      this.datosActuales = [];
    }
  }

  onTipoChange() {
    // Validar que tipoSeleccionado existe
    if (!this.tipoSeleccionado || !this.tipoSeleccionado.value) {
      return;
    }
    
    this.columGenerada = [];
    this.filasGeneradas = [];
    this.filasPinnadas = [];
    this.reporteGenerado = false;
    
    // Actualizar columnas y datos
    this.actualizarColumnasYDatos();
    
    // Forzar la actualización de la grilla
    if (this.gridApi) {
      setTimeout(() => {
        this.gridApi.setGridOption('rowData', this.datosActuales);
        this.gridApi.setGridOption('columnDefs', this.columnasActuales);
      }, 0);
    }
    
    // if(this.tipoSeleccionado.value == 'asientos'){
    //   this.cardSelect = this.cardAsientos;
    // }
     if(this.tipoSeleccionado.value == 'libroM'){
      // Resetear los valores por defecto de las cards de Libro Mayor
      this.cardLibroM[0].cantidad = 'S/ 0.00';
      this.cardLibroM[1].cantidad = 'S/ 0.00';
      this.cardLibroM[2].cantidad = 'S/ 0.00';
      this.cardSelect= this.cardLibroM;
    } else if(this.tipoSeleccionado.value == 'libroD'){
      // Resetear los valores por defecto de las cards de Libro Diario
      this.cardLibroD[0].cantidad = 'S/ 0.00';
      this.cardLibroD[1].cantidad = 'S/ 0.00';
      this.cardLibroD[2].cantidad = 'S/ 0.00';
      this.cardLibroD[3].cantidad = '00';
      this.cardSelect= this.cardLibroD;
    } else if(this.tipoSeleccionado.value == 'reportesSunat'){
      this.cardSelect=[];
    }

  }

  private _reportePendiente = false;

  generarReporte() {
    try {
      // Validar que exista tipoSeleccionado
      if (!this.tipoSeleccionado || !this.tipoSeleccionado.value) {
        return;
      }

      // Limpiar filas flotantes antes de calcular el nuevo reporte
      this.filasPinnadas = [];
      this._reportePendiente = true;

      // Cargar datos según el tipo seleccionado desde su propio JSON
      if(this.tipoSeleccionado.value == 'libroM'){
        this.librosAsientosFacade.cargarLibroMayor();
      } else if(this.tipoSeleccionado.value == 'libroD'){
        this.librosAsientosFacade.cargarLibroDiario();
      } else if(this.tipoSeleccionado.value == 'balanComprob'){
        this.librosAsientosFacade.cargarBalanceComprobacion();
      } else if(this.tipoSeleccionado.value == 'reportesSunat'){
        this._reportePendiente = false;
        this.columGenerada = [];
        this.filasGeneradas = [];
        this.registro = this.dataReporte;
        this.reporteGenerado = true;
        this.actualizarColumnasYDatos();
        this.toastService.success('¡Reporte generado exitosamente!');
      }
    } catch (error) {
    }
  }

  /**
   * Procesar el reporte cuando los datos ya fueron cargados por el facade
   */
  private procesarReporte() {
    if (!this.tipoSeleccionado || !this.tipoSeleccionado.value) return;

    if(this.tipoSeleccionado.value == 'libroM'){
      this.columGenerada = this.colLibroM;
      this.filasGeneradas = [...this.librosAsientosFacade.libroMayor()];
      this.actualizarTotalesLibroMayor();
    } else if(this.tipoSeleccionado.value == 'libroD'){
      // Inicializar con los datos del JSON (libro diario base)
      let datosLibroDiario: any[] = [...this.librosAsientosFacade.libroDiario()];
      
      // Cargar datos de asientos manuales y agregarlos
      const asientosManual = this.simulation.list('asientosManual') || [];
      if (asientosManual.length > 0) {
        const filasAsientosManual: any[] = [];
        asientosManual.forEach((asiento: any) => {
          if (asiento.cuentas && Array.isArray(asiento.cuentas)) {
            asiento.cuentas.forEach((cuenta: any) => {
              filasAsientosManual.push({
                fechaC: asiento.fechaContable || '',
                nlibro: this.obtenerCodigoLibro(asiento.libro),
                nasiento: asiento.numeroAsiento || '',
                glosa: asiento.glosa || '',
                codigoC: cuenta.cuenta || '',
                descripcionC: cuenta.descripcion || '',
                centroC: cuenta.centroCosto || '',
                debito: (cuenta.debeSoles || 0) + (cuenta.debeDolares || 0),
                credito: (cuenta.haberSoles || 0) + (cuenta.haberDolares || 0),
                usuario: 'Juan Pérez',
                estado: asiento.estado || 'Activo',
                moneda: asiento.moneda || 'Soles'
              });
            });
          }
        });
        datosLibroDiario = [...datosLibroDiario, ...filasAsientosManual];
      }
      
      // Cargar también los registros de almacenamiento desde localStorage
      const registrosAlmacenamiento = this.simulation.list('libroD') || [];
      
      if (registrosAlmacenamiento.length > 0) {
        datosLibroDiario = [...datosLibroDiario, ...registrosAlmacenamiento];
      }

      // Cargar detracciones desde localStorage
      const detracciones = this.simulation.list('detracciones') || [];

      if (detracciones.length > 0) {
        // Filtrar solo las detracciones con estado "Pagada"
        const detraccionesPagadas = detracciones.filter((detraccion: any) => detraccion.estado === 'Pagada');

        // Mapear detracciones al formato de Libro Diario
        const detraccionesFormato = detraccionesPagadas.map((detraccion: any) => ({
          fechaC: detraccion.fechapago || '',
          nlibro: '005', // Libro diario
          nasiento: detraccion.codigo || '',
          glosa: detraccion.proveedor || '',
          codigoC: detraccion.RUCproveedor || '',
          descripcionC: detraccion.proveedor || '',
          centroC: 'CC001',
          debito: this.parsearImporte(detraccion.importe),
          credito: 0,
          usuario: detraccion.responsable || '',
          estado: detraccion.estado || 'Pagada'
        }));

        // Combinar con el Libro Diario existente
        datosLibroDiario = [...datosLibroDiario, ...detraccionesFormato];
      }

      //   Cargar aplicaciones de pago desde localStorage
      const aplicacionesPago = this.simulation.list('aplicacionPago') || [];

      if (aplicacionesPago.length > 0) {
        // Filtrar solo las aplicaciones con estado "Aplicado"
        const aplicacionesAplicadas = aplicacionesPago.filter((aplicacion: any) => aplicacion.estado === 'Aplicado');

        // Mapear aplicaciones al formato de Libro Diario
        const aplicacionesFormato = aplicacionesAplicadas.map((aplicacion: any) => ({
          fechaC: aplicacion.fechaAnticipo || '',
          nlibro: '005', // Libro diario
          nasiento: aplicacion.numeroAsiento || '',
          glosa: `Pago aplicado - ${aplicacion.proveedor}`,
          codigoC: aplicacion.ctaContablePago || '4211',
          descripcionC: `Pago ${aplicacion.medioPago} - ${aplicacion.serieNumDoc}`,
          centroC: 'CC001',
          debito: aplicacion.montoTotal || aplicacion.montoAnticipado || 0,
          credito: aplicacion.montoTotal || aplicacion.montoAnticipado || 0,
          usuario: 'Sistema',
          estado: 'Activo' // Estado del asiento contable, no del pago
        }));

        // Combinar con el Libro Diario existente
        datosLibroDiario = [...datosLibroDiario, ...aplicacionesFormato];
      }
      
      // Aplicar filtros según los criterios seleccionados
      let datosFiltrados = this.aplicarFiltrosLibroDiario(datosLibroDiario);
      
      this.columGenerada = this.colLibroD;
      this.filasGeneradas = datosFiltrados;
      this.actualizarTotalesLibroDiario();
    } else if(this.tipoSeleccionado.value == 'balanComprob'){
      this.columGenerada = this.colBalanceComprob;
      this.filasGeneradas = [...this.librosAsientosFacade.balanceComprobacion()];
      this.calcularFilasTotales();
    }
    this.reporteGenerado = true;
    
    // Actualizar columnas y datos después de generar el reporte
    this.actualizarColumnasYDatos();
    
    this.toastService.success('¡Reporte generado exitosamente!');
  }

  /**
   * Obtener código de libro según el nombre
   */
  private obtenerCodigoLibro(nombreLibro: string): string {
    const mapeoLibros: { [key: string]: string } = {
      'Libro diario': '005',
      'libro mayor': '006',
      'libro caja': '001',
      'Caja y bancos': '001',
      'Compras': '008',
      'Ventas': '014'
    };

    return mapeoLibros[nombreLibro] || '005';
  }

  /**
   * Aplicar filtros al Libro Diario según los criterios seleccionados
   */
  aplicarFiltrosLibroDiario(datos: any[]): any[] {
    let datosFiltrados = [...datos];

    // Filtrar por Estado del Asiento
    if (this.estadoSeleccionado && this.estadoSeleccionado !== 'todos') {
      datosFiltrados = datosFiltrados.filter(registro => {
        const estadoRegistro = registro.estado?.toLowerCase() || '';
        return estadoRegistro === this.estadoSeleccionado.toLowerCase();
      });
    }

    // Filtrar por Moneda
    if (this.monedaSeleccionada && this.monedaSeleccionada !== 'todos') {
      datosFiltrados = datosFiltrados.filter(registro => {
        const monedaRegistro = registro.moneda?.toLowerCase() || 'soles';
        return monedaRegistro === this.monedaSeleccionada.toLowerCase();
      });
    }

    // Filtrar por Tipo de Comprobante
    if (this.comprobanteSeleccionado && this.comprobanteSeleccionado !== 'todos') {
      datosFiltrados = datosFiltrados.filter(registro => {
        const nlibro = registro.nlibro || '';
        if (this.comprobanteSeleccionado === 'libroD') return nlibro === '005';
        if (this.comprobanteSeleccionado === 'rcompras') return nlibro === '008';
        if (this.comprobanteSeleccionado === 'rventas') return nlibro === '014';
        return true;
      });
    }

    // Filtrar por Fecha
    if (this.fechaSeleccionada && this.fechaSeleccionada !== 'todas') {
      datosFiltrados = datosFiltrados.filter(registro => {
        const fechaRegistro = registro.fechaC || '';
        if (!fechaRegistro) return false;
        
        // Extraer mes y año de la fecha (formato: DD/MM/YYYY)
        const partes = fechaRegistro.split('/');
        if (partes.length === 3) {
          const mes = partes[1];
          const anio = partes[2];
          const fechaComparar = `${anio}-${mes}`;
          return fechaComparar === this.fechaSeleccionada;
        }
        return false;
      });
    }

    return datosFiltrados;
  }

  /**
   * Actualizar totales de las cards del Libro Diario
   */
  actualizarTotalesLibroDiario() {
    let totalDebitos = 0;
    let totalCreditos = 0;

    this.filasGeneradas.forEach(row => {
      totalDebitos += Number(row.debito) || 0;
      totalCreditos += Number(row.credito) || 0;
    });

    const diferencia = totalDebitos - totalCreditos;

    // Actualizar las cards
    this.cardLibroD[0].cantidad = `S/ ${totalDebitos.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`;
    this.cardLibroD[1].cantidad = `S/ ${totalCreditos.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`;
    this.cardLibroD[2].cantidad = `S/ ${diferencia.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`;
    this.cardLibroD[3].cantidad = String(this.filasGeneradas.length);

    // Actualizar la referencia para que Angular detecte el cambio
    this.cardSelect = [...this.cardLibroD];
  }

  actualizarTotalesLibroMayor() {
    let totalDebitos = 0;
    let totalCreditos = 0;

    this.filasGeneradas.forEach(row => {
      totalDebitos += Number(row.debito) || 0;
      totalCreditos += Number(row.credito) || 0;
    });

    // Actualizar los valores de las cards
    this.cardLibroM[0].cantidad = `S/ ${totalDebitos.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`;
    this.cardLibroM[1].cantidad = `S/ ${totalCreditos.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`;
    
    // Actualizar la referencia para que Angular detecte el cambio
    this.cardSelect = [...this.cardLibroM];
  }

  carpetaSeleccionada(event: any) {
    const files = event.target.files;

    if (files.length > 0) {
      // Esto NO devuelve la ruta completa, solo el nombre del directorio raíz.
      const ruta = files[0].webkitRelativePath.split('/')[0];
      this.directorio = ruta;
    }
  }

  /**
   * Parsear importe de formato string a número
   */
  private parsearImporte(importe: string): number {
    if (!importe) return 0;
    // Remover "S/.", espacios y convertir a número
    const valor = importe.replace(/[^0-9.]/g, '');
    return parseFloat(valor) || 0;
  }

  /**
   * Calcular filas de totales para mostrar en el pie de la tabla
   */
  calcularFilasTotales() {
    if (this.tipoSeleccionado?.value === 'balanComprob') {
      // Calcular totales para Balance de Comprobación
      const totales = this.filasGeneradas.reduce((acc, row) => {
        acc.movDebe += row.movDebe || 0;
        acc.movHaber += row.movHaber || 0;
        acc.saldoDeudor += row.saldoDeudor || 0;
        acc.saldoAcreedor += row.saldoAcreedor || 0;
        acc.inventarioActivo += row.inventarioActivo || 0;
        acc.inventarioPasivo += row.inventarioPasivo || 0;
        acc.eePerdidas += row.eePerdidas || 0;
        acc.eeGanancias += row.eeGanancias || 0;
        acc.transfCargo += row.transfCargo || 0;
        acc.transfAbono += row.transfAbono || 0;
        acc.saldo2Deudor += row.saldo2Deudor || 0;
        acc.saldo2Acreedor += row.saldo2Acreedor || 0;
        acc.eeNaturalPerdidas += row.eeNaturalPerdidas || 0;
        acc.eeNaturalGanancias += row.eeNaturalGanancias || 0;
        return acc;
      }, {
        movDebe: 0, movHaber: 0,
        saldoDeudor: 0, saldoAcreedor: 0,
        inventarioActivo: 0, inventarioPasivo: 0,
        eePerdidas: 0, eeGanancias: 0,
        transfCargo: 0, transfAbono: 0,
        saldo2Deudor: 0, saldo2Acreedor: 0,
        eeNaturalPerdidas: 0, eeNaturalGanancias: 0
      });

      // Primera fila: Totales principales
      this.filasPinnadas = [
        {
          codigo: '',
          denominacion: '',
          movDebe: totales.movDebe,
          movHaber: totales.movHaber,
          saldoDeudor: totales.saldoDeudor,
          saldoAcreedor: totales.saldoAcreedor,
          inventarioActivo: totales.inventarioActivo,
          inventarioPasivo: totales.inventarioPasivo,
          eePerdidas: totales.eePerdidas,
          eeGanancias: totales.eeGanancias,
          transfCargo: totales.transfCargo,
          transfAbono: totales.transfAbono,
          saldo2Deudor: totales.saldo2Deudor,
          saldo2Acreedor: totales.saldo2Acreedor,
          eeNaturalPerdidas: totales.eeNaturalPerdidas,
          eeNaturalGanancias: totales.eeNaturalGanancias,
          _isPinnedRow: true,
          _tipoFila: 'total-principal'
        },
        // Segunda fila: Cálculos totales
        {
          codigo: '',
          denominacion: 'Cálculos totales',
          movDebe: '',
          movHaber: '',
          saldoDeudor: '',
          saldoAcreedor: '',
          inventarioActivo: totales.inventarioActivo,
          inventarioPasivo: totales.inventarioPasivo,
          eePerdidas: totales.eePerdidas,
          eeGanancias: totales.eeGanancias,
          transfCargo: totales.transfCargo,
          transfAbono: totales.transfAbono,
          saldo2Deudor: totales.saldo2Deudor,
          saldo2Acreedor: totales.saldo2Acreedor,
          eeNaturalPerdidas: totales.eeNaturalPerdidas,
          eeNaturalGanancias: totales.eeNaturalGanancias,
          _isPinnedRow: true,
          _tipoFila: 'calculos-totales'
        },
        // Tercera fila: Totales finales
        {
          codigo: '',
          denominacion: '',
          movDebe: '',
          movHaber: '',
          saldoDeudor: '',
          saldoAcreedor: '',
          inventarioActivo: totales.inventarioActivo,
          inventarioPasivo: totales.inventarioPasivo,
          eePerdidas: totales.eePerdidas,
          eeGanancias: totales.eeGanancias,
          transfCargo: totales.transfCargo,
          transfAbono: totales.transfAbono,
          saldo2Deudor: totales.saldo2Deudor,
          saldo2Acreedor: totales.saldo2Acreedor,
          eeNaturalPerdidas: totales.eeNaturalPerdidas,
          eeNaturalGanancias: totales.eeNaturalGanancias,
          _isPinnedRow: true,
          _tipoFila: 'total-final'
        }
      ];
    } else {
      this.filasPinnadas = [];
    }
  }

}