import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { AccionesCellRenderComponent } from 'src/app/ui/acciones-cell-render/acciones-cell-render.component';
import { ModalDetalleCuentaComponent } from 'src/app/ui/modal-detalle-cuenta/modal-detalle-cuenta.component';
import { DiferenciaCellRendererComponent } from './cell-renderers/diferencia-cell-renderer/diferencia-cell-renderer.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ConciliacionFacade } from '../../application/facades/conciliacion.facade';
import { ConciliacionFeedbackEffects } from '../../effects/conciliacion-feedback.effect';
import { ConciliacionEntity } from '../../domain/models/conciliacion.entity';

// Font Awesome Icons
import { faChartLineDown, faDisplayChartUpCircleDollar, faHandHoldingCircleDollar, faSackDollar, faTriangleExclamation, faDownload, faAngleDown } from '@fortawesome/pro-solid-svg-icons';
import { IconDefinition } from '@fortawesome/fontawesome-svg-core';

@Component({
  selector: 'app-f-c-conciliaciones',
  templateUrl: './f-c-conciliaciones.component.html',
  styleUrls: ['./f-c-conciliaciones.component.scss'],
  standalone: false,
})
export class FCConciliacionesComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  fasChartLineDown = faChartLineDown;
  fasDisplayChartUpCircleDollar = faDisplayChartUpCircleDollar;
  fasHandHoldingCircleDollar = faHandHoldingCircleDollar;
  fasSackDollar = faSackDollar;
  fasTriangleExclamation = faTriangleExclamation;
  fasDownload = faDownload;
  fasAngleDown = faAngleDown;


  mostrarTabla: boolean = false;
  busquedaRealizada: boolean = false;
  bancoSeleccionado: string = '';
  monedaSeleccionada: string = '';
  estadoSeleccionado: string = '';
  usuarioSeleccionado: string = '';
  cuentasSeleccionadas: string[] = [];
  saldoMinimo: number | null = null;
  saldoMaximo: number | null = null;

  cards=[
    {nombre:'Total cuentas Cerradas', valor:'S/105000.00', icono: faChartLineDown},
    {nombre:'Total cuentas En proceso', valor:'S/50.00', icono: faSackDollar},
    {nombre:'Errores de coincidencia', valor:'S/40.00', icono: faDisplayChartUpCircleDollar},
    {nombre:'Total de ajustes', valor:'S/60.00', icono: faHandHoldingCircleDollar},
    {nombre:'Cuentas en riesgo', valor:'S/500.00', icono: faTriangleExclamation},
  ]

  private gridApi!: GridApi;

  colDefs: ColDef[] = [
    { field: 'con_banco', headerName: 'Banco', flex: 1, minWidth: 100, filter: true },
    { field: 'con_cuenta', headerName: 'Cuenta', flex: 1.5, minWidth: 150, filter: true },
    { field: 'con_moneda', headerName: 'Moneda', flex: 0.8, minWidth: 80, filter: true },
    { field: 'con_ult_conciliacion', headerName: 'Ult. conciliación', flex: 1, minWidth: 100, filter: true },
    { field: 'con_saldo_contable', headerName: 'Saldo contable', headerClass:'derechaencabezado', flex: 1, minWidth: 110,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
        }
        return '';
      },
    },
    { field: 'con_saldo_bancario', headerName: 'Saldo bancario',headerClass:'derechaencabezado', flex: 1, minWidth: 110,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
        }
        return '';
      },
      
    },
    { field: 'con_diferencia', headerName: 'Diferencia', flex: 1, minWidth: 100, 
      cellRenderer: DiferenciaCellRendererComponent,
      cellRendererParams: {
        valueFormatter: (value: number) => {
          if (value !== null && value !== undefined) {
            const absValue = Math.abs(value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);
            
            // Si es negativo, mostrar entre paréntesis
            if (value < 0) {
              return `(${formattedValue})`;
            }
            return formattedValue;
          }
          return '';
        }
      },
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'flex-end', alignItems: 'center' }
    },
    { field: 'con_mov_conciliados', headerName: 'Mov. conciliados', flex: 1, minWidth: 100, cellStyle: { textAlign: 'center' } },
    { field: 'con_mov_pendientes', headerName: 'Mov. pendientes', flex: 1, minWidth: 100, cellStyle: { textAlign: 'center' } },
    { field: 'con_usuario', headerName: 'Usuario', flex: 1, minWidth: 100, filter: true },
    { field: 'con_estado', headerName: 'Estado', flex: 1, minWidth: 100, headerClass: 'centrarencabezado', filter: true,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        
        switch(estado) {
          case 'Cerrado':
            badgeClass = 'bg-green-100 text-green-600';
            break;
          case 'En proceso':
            badgeClass = 'bg-[#FFF0BF] text-[#F2A626]';
            break;
          default:
            badgeClass = 'bg-[#F5F5F5] text-[#363636]';
        }
        
        return `<div class="badge-table ${badgeClass}"><span>${estado}</span></div>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
    { field: 'acciones', headerName: 'Acciones', flex: 0.8, minWidth: 80, headerClass: 'centrarencabezado', 
      cellRenderer: AccionesCellRenderComponent,
      cellRendererParams: {
        isEyeDisabled: (data: any) => false, // El icono "eye" siempre habilitado
        isBookDisabled: (data: any) => data.con_estado === 'Cerrado' // El icono "book" deshabilitado cuando estado es "Cerrado"
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  rowData: ConciliacionEntity[] = [];

  columnTypes = {
    default: {
      resizable: false,
      sortable: false,
      filter: false,
      floatingFilter: false,
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

  bancos = [
    { value: 'todos', label: 'Todos' },
    { value: 'bcp', label: 'BCP' },
    { value: 'interbank', label: 'Interbank' },
    { value: 'bbva', label: 'BBVA' },
    { value: 'scotiabank', label: 'Scotiabank' },
    { value: 'pichincha', label: 'Banco Pichincha' }
  ];

  monedas = [
    { value: 'Soles', label: 'Soles' },
    { value: 'usd', label: 'Dólares' },
    { value: 'eur', label: 'Euros' }
  ];

  estados = [
    { value: 'todos', label: 'Todos' },
    { value: 'cerrrado', label: 'Cerrado' },
    { value: 'proceso', label: 'En proceso' }
  ];

  cuentasBancarias = [
    { codigo: '001', nombre: 'BCP - Cuenta Corriente Soles - 191-1234567-0-00' },
    { codigo: '002', nombre: 'Interbank - Cuenta Corriente Dólares - 200-3001234567' },
    { codigo: '003', nombre: 'BBVA - Cuenta Corriente Soles - 0011-0123-0100123456' },
    { codigo: '004', nombre: 'Scotiabank - Cuenta Ahorro Soles - 000-1234567' }
  ];

  usuarios = [
    { codigo: '001', nombre: 'Carlos López' },
    { codigo: '002', nombre: 'Verónica Losano' },
    { codigo: '003', nombre: 'Ana Sánchez' },
    { codigo: '004', nombre: 'Roberto Martínez' }
  ];
  getRowClass = (params: any) => {
    const data = params.data;
    if (data.con_saldo_contable !== data.con_saldo_bancario) {
      return 'row-parcial-blink';
    }
    return '';
  };
  private readonly facade = inject(ConciliacionFacade);
  private readonly feedbackEffects = inject(ConciliacionFeedbackEffects);
  readonly isLoading = this.facade.isLoading;

  constructor(
    private modalController: ModalController,
    private toastService: ToastService
  ) {
    effect(() => {
      const conciliaciones = this.facade.conciliaciones();
      if (conciliaciones.length > 0) {
        this.rowData = conciliaciones;
        if (this.gridApi) this.gridApi.setGridOption('rowData', this.rowData);
      }
    });
  }

  ngOnInit() {}

  ngOnDestroy() {
    this.facade.resetState();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  // Verificar si hay al menos un filtro seleccionado
  tieneFiltrosSeleccionados(): boolean {
    return !!(this.bancoSeleccionado || this.cuentasSeleccionadas.length > 0 || 
        this.monedaSeleccionada || this.usuarioSeleccionado || 
        this.estadoSeleccionado || this.saldoMinimo !== null || this.saldoMaximo !== null);
  }

  // Verificar si el botón Buscar debe estar habilitado
  puedeHacerBusqueda(): boolean {
    return this.tieneFiltrosSeleccionados() && !this.busquedaRealizada;
  }

  // Verificar si el botón Exportar debe estar habilitado
  puedeExportar(): boolean {
    return this.busquedaRealizada;
  }
  
  async abrirModalDetalleCuenta(rowData?: any) {
    console.log('Abriendo modal de detalle cuenta con datos:', rowData);
    
    // Verificar si existen diferencias
    const existendiferencias = rowData && rowData.con_saldo_contable !== rowData.con_saldo_bancario;
    
    const modal = await this.modalController.create({
      component: ModalDetalleCuentaComponent,
      cssClass: 'promo2',
      componentProps: {
        cuentaData: rowData,
        existendiferencias: existendiferencias
      }
    });

    await modal.present();
  }
  abrirModalLibro(rowData?: any) {
    console.log('Abriendo modal de libro con datos:', rowData);
    // Mostrar toast de éxito
    this.toastService.success('Reporte de diferencias generado exitosamente');
    // Aquí puedes agregar la lógica para abrir el modal del libro cuando lo crees
  }

  buscar() {
    if (!this.tieneFiltrosSeleccionados()) {
      console.warn('Por favor, seleccione al menos un filtro');
      return;
    }
    this.busquedaRealizada = true;
    this.mostrarTabla = true;
    this.facade.cargarConciliaciones();
  }

}
