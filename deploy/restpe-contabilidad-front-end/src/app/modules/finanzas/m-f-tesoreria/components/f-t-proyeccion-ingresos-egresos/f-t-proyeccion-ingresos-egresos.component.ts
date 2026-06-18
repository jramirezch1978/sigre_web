import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { GridApi, GridReadyEvent, ColDef, ICellRendererParams } from 'ag-grid-community';
import { ModalController } from '@ionic/angular';
import { TwoActionsCellRenderComponent } from './two-actions-cell-render/two-actions-cell-render.component';
import { DetailCellRendererComponent } from './detail-cell-renderer/detail-cell-renderer.component';
import { ModalAjusteProyeccionComponent } from './modal-ajuste-proyeccion/modal-ajuste-proyeccion.component';
import { ModalDetalleDocumentosComponent } from './modal-detalle-documentos/modal-detalle-documentos.component';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ProyeccionIngresosEgresosEntity } from 'src/app/modules/finanzas/domain/models/proyeccion-ingresos-egresos.entity';
import { ProyeccionIngresosEgresosFacade } from 'src/app/modules/finanzas/application/facades/proyeccion-ingresos-egresos.facade';
import { ProyeccionIngresosEgresosFeedbackEffects } from 'src/app/modules/finanzas/effects/proyeccion-ingresos-egresos-feedback.effect';

// Font Awesome Icons
import { faPercentage, faSearch, faCircleInfo as farCircleInfo, faTriangleExclamation as farTriangleExclamation, faCircleCheck as farCircleCheck, faCircleXmark as farCircleXmark } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faArrowTrendDown, faArrowTrendUp, faCircleCheck, faCircleInfo, faCircleXmark, faDollar, faDownload, faRotateRight, faShield, faTriangleExclamation } from '@fortawesome/pro-solid-svg-icons';
import { IconDefinition } from '@fortawesome/fontawesome-svg-core';



@Component({
  selector: 'app-f-t-proyeccion-ingresos-egresos',
  templateUrl: './f-t-proyeccion-ingresos-egresos.component.html',
  styleUrls: ['./f-t-proyeccion-ingresos-egresos.component.scss'],
  standalone: false,
})
export class FTProyeccionIngresosEgresosComponent implements OnInit, OnDestroy {
  private readonly facade = inject(ProyeccionIngresosEgresosFacade);
  private readonly feedbackEffects = inject(ProyeccionIngresosEgresosFeedbackEffects);
  readonly isLoading = this.facade.isLoading;
  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasArrowTrendDown = faArrowTrendDown;
  fasArrowTrendUp = faArrowTrendUp;
  fasCircleCheck = faCircleCheck;
  farCircleCheck = farCircleCheck;
  fasCircleInfo = faCircleInfo;
  farCircleInfo = farCircleInfo;
  fasCircleXmark = faCircleXmark;
  farCircleXmark = farCircleXmark;
  fasDollar = faDollar;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;
  faPercent= faPercentage;
  fasShield = faShield;
  fasTriangleExclamation = faTriangleExclamation;
  farTriangleExclamation = farTriangleExclamation;


  private gridApi!: GridApi;

  // Filtros
  filtroPeriodo: string = 'Semana';
  filtroTipoMovimiento: string = '';
  filtroCategoria: string = '';
  filtroSucursal: string = '';
  filtroMoneda: string = 'Soles';

  // Fecha
  fechaInicio: Date | undefined;
  minDate: Date;
  maxDate: Date;

  // Alerta
  mostrarAlerta: boolean = false;
  tipoAlerta: 'success' | 'warning' | 'danger' | 'info' = 'info';
  mensajeAlerta: string = '';
  mostrarProyeccion: boolean = false;

  // Totales para las cards
  totalIngresos: string = 'S/ 10,050.00';
  totalEgresos: string = 'S/ 10,050.00';
  flujoNeto: string = 'S/ 0.00';
  coberturaEgresos: string = '122.9%';
  ingresosproyectados: string = '75%';
  egresosproyectados: string = '60%';

  // Listas para filtros
  periodosList = [
    { id: 'Semana', nombre: 'Semana' },
    { id: 'Mes', nombre: 'Mes' },
    { id: 'Trimestre', nombre: 'Trimestre' }
  ];

  tiposMovimientoList = [
    { id: 'Ingresos', nombre: 'Ingresos' },
    { id: 'Egresos', nombre: 'Egresos' }
  ];

  categoriasList = [
    { id: 'Ventas', nombre: 'Ventas' },
    { id: 'Cobranzas', nombre: 'Cobranzas' },
    { id: 'Pagos', nombre: 'Pagos proveedores' },
    { id: 'Servicios', nombre: 'Servicios' },
    { id: 'Nómina', nombre: 'Nómina' },
    { id: 'operativo', nombre: 'Operativo' },
    { id: 'financiero', nombre: 'Financiero' },
    { id: 'extraordinario', nombre: 'Extraordinario' },
  ];

  sucursalesList = [
    { id: '1', nombre: 'Local centro' },
    { id: '2', nombre: 'Local norte' },
    { id: '3', nombre: 'Local sur' }
  ];

  monedasList = [
    { id: 'Soles', nombre: 'Soles' },
    { id: 'Dólares', nombre: 'Dólares' }
  ];

  // Configuración ag-grid
  rowData: ProyeccionIngresosEgresosEntity[] = [];
  
  colDefs: ColDef[] = [
    { 
      field: 'pie_sucursal', 
      headerName: 'Sucursal', 
      width: 130,
      cellRenderer: 'agGroupCellRenderer',
      cellRendererParams: {
        suppressCount: true,
        checkbox: false
      }
    },
    { field: 'pie_periodo', headerName: 'Periodo', width: 150 },
    {
      field: 'pie_saldoInicial',
      headerName: 'Saldo inicial',
      width: 120,
      headerClass: 'derechaencabezado',
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
        const style: any = { justifyContent: 'end', };
        if (params.value < 0) {
          style.color = '#EF4444'; // Rojo para negativos
        }
        return style;
      }
    },
    {
      field: 'pie_ingresos',
      headerName: 'Ingresos',
      width: 120,
      headerClass: 'derechaencabezado',
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
        const style: any = { justifyContent: 'end', };
        if (params.value < 0) {
          style.color = '#EF4444'; // Rojo para negativos
        }
        return style;
      }
    },
    {
      field: 'pie_egresos',
      headerName: 'Egresos',
      width: 120,
      headerClass: 'derechaencabezado',
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
        const style: any = { justifyContent: 'end', };
        return style;
      }
    },
    {
      field: 'pie_saldoFinal',
      headerName: 'Saldo final',
      width: 120,
      headerClass: 'derechaencabezado',
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
        const style: any = { justifyContent: 'end', };
        if (params.value < 0) {
          style.color = '#EF4444'; // Rojo para negativos
        }
        return style;
      }
    },
    {
      field: 'pie_variacion',
      headerName: 'Variación (%)',
      width: 100,
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `(${formattedValue}%)`;
          }
          return `${formattedValue}%`;
        }
        return '';
      },
      cellStyle: (params) => {
        const style: any = {  };
        if (params.value < 0) {
          style.color = '#EF4444'; // Rojo para negativos
        }
        return style;
      }
    },
    {
      field: 'pie_estado',
      headerName: 'Estado',
      width: 110,
      headerClass: 'centrarencabezado',
      cellStyle: { justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Superavit') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Superávit</span>';
        } else if (params.value === 'Déficit') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Déficit</span>';
        } else if (params.value === 'Equilibrado') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Equilibrado</span>';
        }
        return params.value;
      }
    },
    {
      field: 'acciones',
      headerClass: 'centrarencabezado',
      headerName: 'Acciones',
      width: 100,
      cellStyle: { justifyContent: 'center', alignItems: 'center' },
      cellRenderer: TwoActionsCellRenderComponent,
      sortable: false,
      filter: false
    }
  ];

  gridOptions = {
    context: {
      componentParent: this,
    },
    detailCellRenderer: DetailCellRendererComponent,
    detailRowHeight: 155,
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

  getRowClass = (params: any) => {
    const data = params.data;
    if (data.pie_estado === 'Déficit') {
      return 'bg-[#FFF5F5]';
    }
    return '';
  };

  // Getter para obtener el ícono de alerta basado en el tipo
  get alertaIcon(): IconDefinition {
    switch (this.tipoAlerta) {
      case 'success':
        return this.fasCircleCheck;
      case 'warning':
        return this.fasTriangleExclamation;
      case 'danger':
        return this.fasCircleXmark;
      case 'info':
      default:
        return this.fasCircleInfo;
    }
  }

  constructor(
    private modalController: ModalController,
    private toastService: ToastService
  ) {
    this.minDate = new Date(2020, 0, 1);
    this.maxDate = new Date();
    effect(() => {
      const proyecciones = this.facade.proyecciones();
      this.rowData = proyecciones;
      if (this.gridApi) this.gridApi.setGridOption('rowData', this.rowData);
    });
  }

  ngOnInit() {
    this.fechaInicio = new Date();
  }

  ngOnDestroy() {
    this.facade.resetState();
  }

  onFilterChange() {
    console.log('Filtros cambiados');
  }

  onFechaSelected(fecha: Date) {
    this.fechaInicio = fecha;
    console.log('Fecha seleccionada:', fecha);
  }

  generarProyeccion() {
    console.log('Generando proyección...');
    this.mostrarProyeccion = true;
    this.facade.cargarProyecciones();
    this.mostrarAlerta = true;
    this.tipoAlerta = 'info';
    this.mensajeAlerta = 'Es conforme con los estándares considerados para las proyecciones.';
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.gridApi.sizeColumnsToFit();
  }

  // Métodos llamados por TwoActionsCellRenderComponent
  async abrirModalDetalle(rowData: ProyeccionIngresosEgresosEntity) {
    console.log('Abriendo modal de detalle para:', rowData);

    // Preparar datos de ingresos para la tabla
    const ingresosData: any[] = [];
    if (rowData.pie_detalleIngresos) {
      rowData.pie_detalleIngresos.forEach((item: any) => {
        ingresosData.push({
          tipo: 'Venta',
          descripcion: item.dc_concepto,
          cliente: '-',
          fecha: '14/01/2025',
          moneda: 'Soles',
          monto: item.dc_monto,
          estado: 'Pagado'
        });
      });
    }

    // Preparar datos de egresos para la tabla
    const egresosData: any[] = [];
    if (rowData.pie_detalleEgresos) {
      rowData.pie_detalleEgresos.forEach((item: any) => {
        egresosData.push({
          tipo: 'Pago',
          descripcion: item.dc_concepto,
          proveedor: '-',
          fecha: '14/01/2025',
          moneda: 'Soles',
          monto: item.dc_monto,
          estado: 'Pagado'
        });
      });
    }

    // Columnas para ingresos
    const colDefsIngresos: ColDef[] = [
      { field: 'tipo', headerName: 'Tipo', width: 100 },
      { field: 'descripcion', headerName: 'Descripción', flex: 1, minWidth: 150 },
      { field: 'cliente', headerName: 'Cliente', width: 100 },
      { field: 'fecha', headerName: 'Fecha', width: 120 },
      { field: 'moneda', headerName: 'Moneda', width: 100 },
      {
        field: 'monto',
        headerName: 'Monto',
        headerClass: 'derechaencabezado',
        width: 120,
        cellStyle: { justifyContent: 'end',}
      },
      { 
        field: 'pie_estado', 
        cellStyle: { justifyContent: 'center' },
        headerClass: 'centrarencabezado',
        headerName: 'Estado', 
        width: 100,
        cellRenderer: (params: any) => {
          if (params.value === 'Pagado') {
            return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagado</span>';
          } else if (params.value === 'Parcial') {
            return '<span class="badge-table bg-[#FEF3C7] text-[#F59E0B]">Parcial</span>';
          }
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        }
      }
    ];

    // Columnas para egresos
    const colDefsEgresos: ColDef[] = [
      { field: 'tipo', headerName: 'Tipo', width: 100 },
      { field: 'descripcion', headerName: 'Descripción', flex: 1, minWidth: 150 },
      { field: 'proveedor', headerName: 'Proveedor', width: 100 },
      { field: 'fecha', headerName: 'Fecha', width: 120 },
      { field: 'moneda', headerName: 'Moneda', width: 100 },
      {
        field: 'monto',
        headerName: 'Monto',
        headerClass: 'derechaencabezado',
        width: 120,
        cellStyle: { textAlign: 'right' }
      },
      { 
        field: 'pie_estado', 
        headerName: 'Estado',
        cellStyle: { justifyContent: 'center' },
        headerClass: 'centrarencabezado', 
        width: 100,
        cellRenderer: (params: any) => {
          if (params.value === 'Pagado') {
            return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagado</span>';
          } else if (params.value === 'Parcial') {
            return '<span class="badge-table bg-[#FEF3C7] text-[#F59E0B]">Parcial</span>';
          }
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        }
      }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleDocumentosComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Detalle de documentos - ${rowData.pie_sucursal}`,
        sucursal: rowData.pie_sucursal,
        periodo: rowData.pie_periodo,
        saldoInicial: rowData.pie_saldoInicial,
        saldoFinal: rowData.pie_saldoFinal,
        variacion: rowData.pie_variacion,
        ingresosData: ingresosData,
        egresosData: egresosData,
        colDefsIngresos: colDefsIngresos,
        colDefsEgresos: colDefsEgresos
      }
    });

    await modal.present();
  }

  async abrirModalEliminar(rowData: ProyeccionIngresosEgresosEntity) {
    const modal = await this.modalController.create({
      component: ModalAjusteProyeccionComponent,
      cssClass: 'promo',
      componentProps: {
        sucursal: rowData?.pie_sucursal || '',
        periodo: rowData?.pie_periodo || ''
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      console.log('Ajuste confirmado:', data.data);
      // Implementar lógica de ajuste
      // data.data contiene: tipoAjuste, categoria, monto, motivoAjuste
      this.toastService.success('¡Ajuste realizado exitosamente!');
    }
  }

}
