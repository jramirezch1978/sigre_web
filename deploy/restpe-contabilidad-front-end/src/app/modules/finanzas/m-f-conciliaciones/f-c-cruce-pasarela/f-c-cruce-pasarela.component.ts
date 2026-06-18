import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalGenerarAjusteComponent } from 'src/app/ui/modal-generar-ajuste/modal-generar-ajuste.component';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ModalFiltrosComponent } from 'src/app/ui/modal-filtros/modal-filtros.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ObservacionCellRenderComponent } from 'src/app/ui/observacion-cell-render/observacion-cell-render.component';
import { ModalAdjuntarObservacionComponent } from 'src/app/ui/modal-adjuntar-observacion/modal-adjuntar-observacion.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CrucePasarelaFacade } from '../../application/facades/cruce-pasarela.facade';
import { CrucePasarelaFeedbackEffects } from '../../effects/cruce-pasarela-feedback.effect';
import { CrucePasarelaEntity } from '../../domain/models/cruce-pasarela.entity';
import { MovimientoPasarelaEntity } from '../../domain/models/movimiento-pasarela.entity';

// Font Awesome Icons
import { faHourglassHalf } from '@fortawesome/pro-regular-svg-icons';
import { faChartLineDown, faCoins, faHandHoldingCircleDollar, faSackDollar, faChevronsRight,
  faChevronsLeft, faCirclePlus, faArrowsRotate
 } from '@fortawesome/pro-solid-svg-icons';
 import { faFilter, faLinkSimple, faLinkSlash, faGear, faArrowUpFromBracket, faDownload } from '@fortawesome/pro-regular-svg-icons';
import { IconDefinition } from '@fortawesome/fontawesome-svg-core';
@Component({
  selector: 'app-f-c-cruce-pasarela',
  templateUrl: './f-c-cruce-pasarela.component.html',
  styleUrls: ['./f-c-cruce-pasarela.component.scss'],
  standalone: false,
})
export class FCCrucePasarelaComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farHourglassHalf = faHourglassHalf;
  fasChartLineDown = faChartLineDown;
  fasCoins = faCoins;
  fasHandHoldingCircleDollar = faHandHoldingCircleDollar;
  fasSackDollar = faSackDollar;
  fasChevronsRight = faChevronsRight;
  fasChevronsLeft = faChevronsLeft;
  fasCirclePlus = faCirclePlus;
  farFilter = faFilter;
  farLinkSimple = faLinkSimple;
  farLinkSlash = faLinkSlash;
  farGear = faGear;
  fasArrowsRotate = faArrowsRotate;
  farArrowUpFromBracket = faArrowUpFromBracket;
  farDownload = faDownload;

  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private gridApi!: GridApi;
  private gridApiMovimientos!: GridApi;
  private gridApiBancario!: GridApi;
  cantidaddemovimientos: number = 0;
  cantidaddeextractos: number = 0;
  mostrartabla: boolean = false;
  filasSeleccionadasMovimientos: any[] = [];
  filasSeleccionadasBancario: any[] = [];
  botonVincularHabilitado: boolean = false;
  botonDesvincularHabilitado: boolean = false;
  habilitarbotoncerrar: boolean = false;
  botonAjusteHabilitado: boolean = false;
  botonCruceAutomaticoHabilitado: boolean = true;
  filtrosAplicados: boolean = false;
  cruceCerrado: boolean = false;

  bancosSelect = [
    'Yape',
    'Mercado Pago',
    'Niubiz',
  ]
  bancoSeleccionado: string = '';
  cards = [
    { nombre: 'Total conciliados', valor: '0', icono: faChartLineDown },
    { nombre: 'Total pendientes', valor: '0', icono: faHourglassHalf },
    { nombre: 'Monto conciliado', valor: '0', icono: faCoins },
    { nombre: 'Monto pendiente', valor: '0', icono: faHandHoldingCircleDollar },
    { nombre: 'Monto total', valor: '0', icono: faSackDollar },
  ]
  colDefs: ColDef[] = [
    { field: 'cp_codigo', headerName: 'Código', flex: 0.5, minWidth: 64 },
    {
      field: 'fecha', headerName: 'Fecha', flex: 0.5, minWidth: 64, filter: true,
      cellRenderer: (params: any) => {
        const banco = params.value;
        return `<div class="flex flex-col leading-none gap-1">
                  <span class="text-xxss">10/11/2025 -</span>
                  <span class="text-xxss">30/11/2025</span>
                </div>`;
      }
    },
    { field: 'cp_banco', headerName: 'Banco', flex: 1, minWidth: 132, filter: true, },
    {
      headerClass: 'centrarencabezado',
      field: 'cp_estado',
      headerName: 'Estado',
      flex: 0.5,
      minWidth: 60,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';

        switch (estado) {
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
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    }
  ];

  rowData: CrucePasarelaEntity[] = [];
  colDefsMovimientos: ColDef[] = [
    { field: '', checkboxSelection: true, headerCheckboxSelection: true, headerName: '', flex: 0.5, minWidth: 23 },
    { field: 'mp_fecha', headerName: 'Fecha', flex: 1, minWidth: 40, filter: true },
    { field: 'mp_descripcion', headerName: 'Descripción', flex: 2, minWidth: 80, },
    { field: 'mp_cliente', headerName: 'Cliente', flex: 1, minWidth: 46, filter: true },
    { field: 'mp_comprobante', headerName: 'Nº de comprobante', flex: 1, minWidth: 46},
    {
      field: 'mp_monto', headerName: 'Monto', headerClass: 'derechaencabezado', flex: 1, minWidth: 60, cellRenderer: VistaCellRenderComponent,
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);

          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `S/ (${formattedValue})`;
          }
          return `S/ ${formattedValue}`;
        }
        return '';
      },
      cellStyle: (params) => {
        const style: any = { textAlign: 'right', display: 'flex', justifyContent: 'right' };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { field: 'mp_usuario', headerName: 'Usuario', flex: 1, minWidth: 46},
    {
      field: 'mp_estado', headerName: 'Estado', headerClass: 'centrarencabezado',flex: 1, minWidth: 56, filter: true,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';

        switch (estado) {
          case 'Conciliado':
            badgeClass = 'bg-green-100 text-green-600';
            break;
          default:
            badgeClass = 'bg-[#F5F5F5] text-[#363636]';
        }

        return `<div class="badge-table ${badgeClass}"><span>${estado}</span></div>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    },
  ];
  
  rowDataMovimientosOriginal: MovimientoPasarelaEntity[] = [];
  rowDataMovimientos: MovimientoPasarelaEntity[] = [];
  
  colDefsBancario: ColDef[] = [
    { field: '', checkboxSelection: true, headerCheckboxSelection: true, headerName: '', flex: 0.5, minWidth: 23 },
    { field: 'fecha', headerName: 'Fecha', flex: 1, minWidth: 40,filter: true },
    { field: 'id', headerName: 'ID trans.', flex: 1, minWidth: 40 },
    { field: 'comprobante', headerName: 'Nº de comprobante', flex: 1, minWidth: 46 },
    { field: 'cliente', headerName: 'Cliente', flex: 1, minWidth: 46, filter: true },
    {
      field: 'monto', headerName: 'Monto',headerClass: 'derechaencabezado', flex: 1, minWidth: 60, 
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);

          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `S/ (${formattedValue})`;
          }
          return `S/ ${formattedValue}`;
        }
        return '';
      },
      cellStyle: (params) => {
        const style: any = { textAlign: 'right',display: 'flex', justifyContent: 'right' };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { 
      field: 'comision', headerName: 'Comisión',headerClass:'derechaencabezado', flex:1, minWidth: 65,
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          if (params.value < 0) {
            return `S/ (${formattedValue})`;
          }
          return `S/ ${formattedValue}`;
        }
        return '';
      },
      cellStyle: (params) => {
        const style: any = { textAlign: 'right',display: 'flex', justifyContent: 'right' };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { 
      field: 'neto', headerName: 'Neto', headerClass:'derechaencabezado',flex: 1, minWidth: 46,
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          if (params.value < 0) {
            return `S/ (${formattedValue})`;
          }
          return `S/ ${formattedValue}`;
        }
        return '';
      },
      cellStyle: (params) => {
        const style: any = { textAlign: 'right', display: 'flex', justifyContent: 'right' };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    {
      field: 'estado', headerName: 'Estado', flex: 1, minWidth: 56, headerClass: 'centrarencabezado',filter: true,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';

        switch (estado) {
          case 'Conciliado':
            badgeClass = 'bg-green-100 text-green-600';
            break;
          default:
            badgeClass = 'bg-[#F5F5F5] text-[#363636]';
        }

        return `<div class="badge-table ${badgeClass}"><span>${estado}</span></div>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    },
    {
      field: 'acciones', headerName: 'Acciones', flex: 0.5, minWidth: 60, headerClass: 'centrarencabezado',
      cellRenderer: ObservacionCellRenderComponent,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    },
  ]
  rowDataBancario: any = []

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
    { codigo: '001', nombre: 'BCP' },
    { codigo: '002', nombre: 'Banco Internacional del Perú (Interbank)' },
    { codigo: '003', nombre: 'Banco Continental (BBVA)' },
    { codigo: '004', nombre: 'Scotiabank Perú' },
    { codigo: '005', nombre: 'Banco Pichincha' },
    { codigo: '006', nombre: 'Banco de Comercio' },
    { codigo: '007', nombre: 'Banco Interamericano de Finanzas (BanBif)' },
    { codigo: '008', nombre: 'Banco GNB Perú' },
    { codigo: '009', nombre: 'Banco Falabella' },
    { codigo: '010', nombre: 'Banco Ripley' },
    { codigo: '011', nombre: 'Banco Santander Perú' },
    { codigo: '012', nombre: 'Citibank Perú' },
    { codigo: '013', nombre: 'Banco Azteca' },
    { codigo: '014', nombre: 'Bank of China' },
    { codigo: '015', nombre: 'Banco Cencosud' }
  ];

  // Configuración de columnas para el modal de ajuste de pasarela
  colDefsMovimientosAjustarModalPasarela: ColDef[] = [
    { field: 'fecha', headerName: 'Fecha', flex: 0.8 },
    { field: 'pasarela', headerName: 'Pasarela', flex: 0.8 },
    { field: 'comprobante', headerName: 'Nº de comprobante', flex: 1.2 },
    { field: 'cliente', headerName: 'Cliente', flex: 1.5 },
    { field: 'monto', headerName: 'Monto', flex: 1,
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
        }
        return '';
      },
      cellStyle: { textAlign: 'right' }
    },
    { field: 'comision', headerName: 'Monto', flex: 1,
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
        return '';
      },
      cellStyle: (params) => {
        const style: any = { textAlign: 'right' };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      }
    },
    { field: 'neto', headerName: 'Monto', flex: 1,
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
        }
        return '';
      },
      cellStyle: { textAlign: 'right' }
    },
  ];

  colDefsAsientoModalPasarela: ColDef[] = [
    { field: 'cuenta', headerName: 'Cuenta', flex: 1 },
    { field: 'descripcion', headerName: 'Descripción', flex: 2},
    { field: 'debe', headerName: 'Debe', flex: 1,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', { 
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '-';
      },
    },
    { field: 'haber', headerName: 'Haber', flex: 1,
      valueFormatter: (params) => {
        return params.value ? new Intl.NumberFormat('es-PE', { 
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        }).format(params.value) : '-';
      }
     },
  ];

  rowDataMovimientosAjustarModalPasarela: any[] = [];

  // Configuración de selectores para el modal de ajuste de pasarela
  tiposAjustePasarela = [
    { value: 'comision-pasarela', label: 'Comisión de pasarela' },
    { value: 'ajuste-pago', label: 'Ajuste de pago' },
    { value: 'diferencia-comision', label: 'Diferencia de comisión' },
    { value: 'otros-ajustes', label: 'Otros ajustes' }
  ];

  cuentasContablesPasarela = [
    { value: '6591003', label: '6591003 - Gastos por comisión Niubiz' },
    { value: '4011102', label: '4011102 - IGV - Servicios pasarela' },
    { value: '10410002', label: '10410002 - BBVA - Cuenta receptor pasarela' },
    { value: '1212001', label: '1212001 - Cuentas por cobrar - clientes' },
    { value: '6591004', label: '6591004 - Gastos por comisión Mercado Pago' },
    { value: '6591005', label: '6591005 - Gastos por comisión Yape' }
  ];

  private readonly facade = inject(CrucePasarelaFacade);
  private readonly feedbackEffects = inject(CrucePasarelaFeedbackEffects);
  readonly isLoading = this.facade.isLoading;

  constructor(private modalController: ModalController, private toastService: ToastService) {
    const today = new Date();
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
    this.maxDate = today;

    effect(() => {
      const cruces = this.facade.cruces();
      this.rowData = cruces;
      if (this.gridApi) this.gridApi.setGridOption('rowData', this.rowData);
    });

    effect(() => {
      const movimientos = this.facade.movimientos();
      if (movimientos.length > 0) {
        this.rowDataMovimientosOriginal = movimientos;
        this.rowDataMovimientos = [...movimientos];
        this.cantidaddemovimientos = movimientos.length;
        const totalPendientes = movimientos.filter(m => m.mp_estado === 'Pendiente').length;
        const montoTotal = movimientos.reduce((sum, m) => sum + m.mp_monto, 0);
        this.cards[1].valor = totalPendientes.toString();
        this.cards[3].valor = `S/${montoTotal.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
        this.cards[4].valor = `S/${montoTotal.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
        if (this.gridApiMovimientos) this.gridApiMovimientos.setGridOption('rowData', this.rowDataMovimientos);
      }
    });
  }

  ngOnInit() {
    this.facade.cargarCruces();
    this.facade.cargarMovimientos();
  }

  ngOnDestroy() {
    this.facade.resetState();
  }

  onBancoSeleccionado(banco: any) {
    console.log('Banco seleccionado:', banco);
  }

  async abrirModalObservacion(data: any) {
    const modal = await this.modalController.create({
      component: ModalAdjuntarObservacionComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Adjuntar observación',
        observacionActual: data.observacion || '',
        placeholder: 'Escriba aquí su observación...'
      }
    });
    await modal.present();
    const { data: result, role } = await modal.onWillDismiss();
    if (role === 'aplicar' && result) {
      data.observacion = result.observacion;
      this.gridApiBancario.refreshCells({ force: true });
    }
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  mostrarTabla(valor: boolean) {
    this.mostrartabla = valor;
    console.log('Mostrar tabla:', this.mostrartabla);
  }
  onCellClicked(event: any) {
    if (!event.data) return;
    console.log('Celda clickeada:', event.data);
  }

  onSelectionChangedMovimientos(event: any) {
    if (this.gridApiMovimientos) {
      this.filasSeleccionadasMovimientos = this.gridApiMovimientos.getSelectedRows();
      console.log('=== Movimientos del Sistema - Selección Múltiple ===');
      console.log('Total de filas seleccionadas:', this.filasSeleccionadasMovimientos.length);
      console.log('Datos:', this.filasSeleccionadasMovimientos);
      this.verificarCondicionesVinculacion();
      this.verificarCondicionesDesvinculacion();
    }
  }
  cruceautomatico() {
    if (this.rowDataBancario.length === 0) {
      console.log('No hay datos en el extracto bancario para conciliar.');
      return;
    }
    console.log('=== Iniciando Cruce Automático ===');

    // Crear copias de los arrays para trabajar con ellos
    let movimientosConciliados = 0;
    let bancariosConciliados = 0;

    // Recorrer movimientos del sistema
    this.rowDataMovimientos = this.rowDataMovimientos.map(movimiento => {
      // Buscar coincidencia en extracto bancario
      const coincidencia = this.rowDataBancario.find((bancario: any) =>
        bancario.fecha === movimiento.mp_fecha &&
        // bancario.banco === movimiento.banco &&
        // movimiento.mp_descripcion === bancario.descripcion &&
        // bancario.tipo === movimiento.mp_usuario &&
        bancario.monto === movimiento.mp_monto
      );

      if (coincidencia) {
        movimientosConciliados++;
        return { ...movimiento, mp_estado: 'Conciliado' };
      }
      return { ...movimiento, mp_estado: 'Pendiente' };
    });

    // Recorrer extracto bancario y actualizar estados
    this.rowDataBancario = this.rowDataBancario.map((bancario: any) => {
      // Buscar coincidencia en movimientos del sistema
      const coincidencia = this.rowDataMovimientos.find(movimiento =>
        movimiento.mp_fecha === bancario.fecha &&
        // movimiento.banco === bancario.banco &&
        // movimiento.mp_usuario === bancario.tipo &&
        movimiento.mp_monto === bancario.monto &&
        // movimiento.mp_descripcion === bancario.descripcion &&
        movimiento.mp_estado === 'Conciliado'
      );

      if (coincidencia) {
        bancariosConciliados++;
        return { ...bancario, estado: 'Conciliado' };
      }
      return { ...bancario, estado: 'Pendiente' };
    });

    // Actualizar las grids
    if (this.gridApiMovimientos) {
      this.gridApiMovimientos.setGridOption('rowData', this.rowDataMovimientos);
    }
    if (this.gridApiBancario) {
      this.gridApiBancario.setGridOption('rowData', this.rowDataBancario);
    }

    // Actualizar cards
    this.cards[0].valor = movimientosConciliados.toString();
    const pendientes = this.rowDataMovimientos.length - movimientosConciliados;
    this.cards[1].valor = pendientes.toString();

    // Deshabilitar el botón de cruce automático después de usarlo
    this.botonCruceAutomaticoHabilitado = false;
    
    // Habilitar cerrar conciliación solo si no hay pendientes
    this.habilitarbotoncerrar = pendientes === 0;

    console.log('Movimientos conciliados:', movimientosConciliados);
    console.log('Movimientos pendientes:', pendientes);
    console.log('Extractos bancarios conciliados:', bancariosConciliados);
    console.log('=== Cruce Automático Completado ===');
  }
  limpiar(){
    this.bancoSeleccionado='';
    this.filtrosAplicados = false;
    this.botonCruceAutomaticoHabilitado = true;
    this.habilitarbotoncerrar = false;
    
    // Restaurar todos los datos originales (como al inicio)
    this.rowDataMovimientos = [...this.rowDataMovimientosOriginal];
    this.cantidaddemovimientos = this.rowDataMovimientos.length;
    
    // Calcular valores originales para las cards
    const totalPendientes = this.rowDataMovimientos.filter(m => m.mp_estado === 'Pendiente').length;
    const montoTotal = this.rowDataMovimientos.reduce((sum, m) => sum + m.mp_monto, 0);
    
    // Restaurar valores en las cards
    this.cards[1].valor = totalPendientes.toString();
    this.cards[3].valor = `S/${montoTotal.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
    this.cards[4].valor = `S/${montoTotal.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
    
    // Actualizar la grid
    if (this.gridApiMovimientos) {
      this.gridApiMovimientos.setGridOption('rowData', this.rowDataMovimientos);
    }
    
    const today = new Date();
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );
    this.maxDate = today;
  }
  
  aplicarFiltros(){
    console.log('Aplicando filtros:', this.bancoSeleccionado);
    this.filtrosAplicados = true;
    
    // Restaurar desde los datos originales y filtrar
    this.rowDataMovimientos = [...this.rowDataMovimientosOriginal];
    
    // Filtrar los datos por la pasarela seleccionada
    if (this.bancoSeleccionado) {
      this.rowDataMovimientos = this.rowDataMovimientos.filter(item => 
        item.mp_pasarela.toLowerCase() === this.bancoSeleccionado.toLowerCase()
      );
    }
    
    // Actualizar la cantidad de movimientos
    this.cantidaddemovimientos = this.rowDataMovimientos.length;
    
    // Calcular total pendientes (solo contar los que están en estado Pendiente)
    const totalPendientes = this.rowDataMovimientos.filter(m => m.mp_estado === 'Pendiente').length;
    
    // Calcular monto pendiente (sumar montos de los pendientes)
    const montoPendiente = this.rowDataMovimientos
      .filter(m => m.mp_estado === 'Pendiente')
      .reduce((sum, m) => sum + m.mp_monto, 0);
    
    // Calcular monto total (sumar todos los montos)
    const montoTotal = this.rowDataMovimientos.reduce((sum, m) => sum + m.mp_monto, 0);
    
    // Actualizar las cards
    this.cards[1].valor = totalPendientes.toString(); // Total pendientes
    this.cards[3].valor = `S/${montoPendiente.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`; // Monto pendiente
    this.cards[4].valor = `S/${montoTotal.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`; // Monto total
    
    // Actualizar la grid
    if (this.gridApiMovimientos) {
      this.gridApiMovimientos.setGridOption('rowData', this.rowDataMovimientos);
    }
  }
  get botonAplicarDeshabilitado(): boolean {
    return this.bancoSeleccionado === '';
  }
  desvincularseleccionados() {
    console.log('=== Iniciando Desvinculación Manual ===');

    // Validar que hay selecciones en ambas tablas
    if (this.filasSeleccionadasMovimientos.length === 0) {
      console.log('Error: No hay movimientos del sistema seleccionados');
      return;
    }

    if (this.filasSeleccionadasBancario.length === 0) {
      console.log('Error: No hay registros de extracto bancario seleccionados');
      return;
    }

    console.log('Movimientos seleccionados:', this.filasSeleccionadasMovimientos.length);
    console.log('Extractos bancarios seleccionados:', this.filasSeleccionadasBancario.length);

    let desvinculacionesExitosas = 0;

    // Recorrer cada movimiento seleccionado
    this.filasSeleccionadasMovimientos.forEach(movimiento => {
      // Buscar coincidencia en los bancarios seleccionados
      const bancarioCoincidente = this.filasSeleccionadasBancario.find(bancario =>
        bancario.fecha === movimiento.mp_fecha &&
        bancario.monto === movimiento.mp_monto &&
        movimiento.mp_estado === 'Conciliado' &&
        bancario.estado === 'Conciliado'
      );

      if (bancarioCoincidente) {
        console.log('✓ Registro conciliado encontrado para desvincular:', {
          fecha: movimiento.mp_fecha,
          monto: movimiento.mp_monto,
          descripcionMov: movimiento.mp_descripcion,
          descripcionBanc: bancarioCoincidente.descripcion
        });

        // Actualizar el estado en rowDataMovimientos a Pendiente
        const indexMov = this.rowDataMovimientos.findIndex(m =>
          m.mp_fecha === movimiento.mp_fecha &&
          m.mp_monto === movimiento.mp_monto &&
          m.mp_descripcion === movimiento.mp_descripcion
        );

        if (indexMov !== -1) {
          this.rowDataMovimientos[indexMov].mp_estado = 'Pendiente';
        }

        // Actualizar el estado en rowDataBancario a Pendiente
        const indexBanc = this.rowDataBancario.findIndex((b: any) =>
          b.fecha === bancarioCoincidente.fecha &&
          b.monto === bancarioCoincidente.monto &&
          b.descripcion === bancarioCoincidente.descripcion
        );

        if (indexBanc !== -1) {
          this.rowDataBancario[indexBanc].estado = 'Pendiente';
        }

        desvinculacionesExitosas++;
      } else {
        console.log('✗ No se puede desvincular (no conciliado o sin coincidencia):', {
          fecha: movimiento.mp_fecha,
          monto: movimiento.mp_monto,
          estado: movimiento.mp_estado,
          descripcion: movimiento.mp_descripcion
        });
      }
    });

    // Actualizar las grids
    if (this.gridApiMovimientos) {
      this.gridApiMovimientos.setGridOption('rowData', this.rowDataMovimientos);
      this.gridApiMovimientos.deselectAll();
    }
    if (this.gridApiBancario) {
      this.gridApiBancario.setGridOption('rowData', this.rowDataBancario);
      this.gridApiBancario.deselectAll();
    }

    // Actualizar contadores
    const totalConciliados = this.rowDataMovimientos.filter(m => m.mp_estado === 'Conciliado').length;
    const totalPendientes = this.rowDataMovimientos.length - totalConciliados;

    this.cards[0].valor = totalConciliados.toString();
    this.cards[1].valor = totalPendientes.toString();
    
    // Deshabilitar cerrar conciliación si hay pendientes
    this.habilitarbotoncerrar = totalPendientes === 0;

    // Limpiar selecciones
    this.filasSeleccionadasMovimientos = [];
    this.filasSeleccionadasBancario = [];
    this.botonDesvincularHabilitado = false;

    console.log(`=== Desvinculación Completada: ${desvinculacionesExitosas} registros desvinculados ===`);
  }

  vincular() {
    console.log('=== Iniciando Vinculación Manual ===');

    // Validar que hay selecciones en ambas tablas
    if (this.filasSeleccionadasMovimientos.length === 0) {
      console.log('Error: No hay movimientos del sistema seleccionados');
      return;
    }

    if (this.filasSeleccionadasBancario.length === 0) {
      console.log('Error: No hay registros de extracto bancario seleccionados');
      return;
    }

    console.log('Movimientos seleccionados:', this.filasSeleccionadasMovimientos.length);
    console.log('Extractos bancarios seleccionados:', this.filasSeleccionadasBancario.length);

    let vinculacionesExitosas = 0;

    // Recorrer cada movimiento seleccionado
    this.filasSeleccionadasMovimientos.forEach(movimiento => {
      // Buscar coincidencia en los bancarios seleccionados
      const bancarioCoincidente = this.filasSeleccionadasBancario.find(bancario =>
        bancario.fecha === movimiento.mp_fecha &&
        bancario.monto === movimiento.mp_monto
      );

      if (bancarioCoincidente) {
        console.log('✓ Coincidencia encontrada:', {
          fecha: movimiento.mp_fecha,
          monto: movimiento.mp_monto,
          descripcionMov: movimiento.mp_descripcion,
          descripcionBanc: bancarioCoincidente.descripcion
        });

        // Actualizar el estado en rowDataMovimientos
        const indexMov = this.rowDataMovimientos.findIndex(m =>
          m.mp_fecha === movimiento.mp_fecha &&
          m.mp_monto === movimiento.mp_monto &&
          m.mp_descripcion === movimiento.mp_descripcion
        );

        if (indexMov !== -1) {
          this.rowDataMovimientos[indexMov].mp_estado = 'Conciliado';
        }

        // Actualizar el estado en rowDataBancario
        const indexBanc = this.rowDataBancario.findIndex((b: any) =>
          b.fecha === bancarioCoincidente.fecha &&
          b.monto === bancarioCoincidente.monto &&
          b.descripcion === bancarioCoincidente.descripcion
        );

        if (indexBanc !== -1) {
          this.rowDataBancario[indexBanc].estado = 'Conciliado';
        }

        vinculacionesExitosas++;
      } else {
        console.log('✗ Sin coincidencia para movimiento:', {
          fecha: movimiento.mp_fecha,
          monto: movimiento.mp_monto,
          descripcion: movimiento.mp_descripcion
        });
      }
    });

    // Actualizar las grids
    if (this.gridApiMovimientos) {
      this.gridApiMovimientos.setGridOption('rowData', this.rowDataMovimientos);
      this.gridApiMovimientos.deselectAll();
    }
    if (this.gridApiBancario) {
      this.gridApiBancario.setGridOption('rowData', this.rowDataBancario);
      this.gridApiBancario.deselectAll();
    }

    // Actualizar contadores
    const totalConciliados = this.rowDataMovimientos.filter(m => m.mp_estado === 'Conciliado').length;
    const totalPendientes = this.rowDataMovimientos.length - totalConciliados;

    this.cards[0].valor = totalConciliados.toString();
    this.cards[1].valor = totalPendientes.toString();
    
    // Habilitar cerrar conciliación solo si no hay pendientes
    this.habilitarbotoncerrar = totalPendientes === 0;

    // Limpiar selecciones
    this.filasSeleccionadasMovimientos = [];
    this.filasSeleccionadasBancario = [];
    this.botonVincularHabilitado = false;
    this.botonDesvincularHabilitado = false;

    console.log(`=== Vinculación Completada: ${vinculacionesExitosas} registros vinculados ===`);
  }
  ajustecontable() {
    this.abrirModalGenerarAjuste();
    console.log('Ajuste contable ejecutado');
  }

  onSelectionChangedBancario(event: any) {
    if (this.gridApiBancario) {
      this.filasSeleccionadasBancario = this.gridApiBancario.getSelectedRows();
      console.log('=== Extracto Bancario - Selección Múltiple ===');
      console.log('Total de filas seleccionadas:', this.filasSeleccionadasBancario.length);
      console.log('Datos:', this.filasSeleccionadasBancario);
      this.verificarCondicionesVinculacion();
      this.verificarCondicionesDesvinculacion();
      this.verificarCondicionesAjuste();
    }
  }

  verificarCondicionesVinculacion() {
    // Validar que hay selecciones en ambas tablas
    if (this.filasSeleccionadasMovimientos.length === 0 || this.filasSeleccionadasBancario.length === 0) {
      this.botonVincularHabilitado = false;
      return;
    }

    // Verificar si existe al menos una coincidencia válida (fecha y monto iguales Y ambos con estado Pendiente)
    let hayCoincidencia = false;

    for (const movimiento of this.filasSeleccionadasMovimientos) {
      const coincidencia = this.filasSeleccionadasBancario.find(bancario =>
        bancario.fecha === movimiento.mp_fecha &&
        bancario.monto === movimiento.mp_monto &&
        movimiento.mp_estado === 'Pendiente' &&
        bancario.estado === 'Pendiente'
      );

      if (coincidencia) {
        hayCoincidencia = true;
        break;
      }
    }

    this.botonVincularHabilitado = hayCoincidencia;
    console.log('Botón vincular habilitado:', this.botonVincularHabilitado);
  }

  verificarCondicionesDesvinculacion() {
    // Validar que hay selecciones en ambas tablas
    if (this.filasSeleccionadasMovimientos.length === 0 || this.filasSeleccionadasBancario.length === 0) {
      this.botonDesvincularHabilitado = false;
      return;
    }

    // Verificar si existe al menos una coincidencia válida (fecha, monto iguales Y estado Conciliado)
    let hayCoincidenciaConciliada = false;

    for (const movimiento of this.filasSeleccionadasMovimientos) {
      const coincidencia = this.filasSeleccionadasBancario.find(bancario =>
        bancario.fecha === movimiento.mp_fecha &&
        bancario.monto === movimiento.mp_monto &&
        movimiento.mp_estado === 'Conciliado' &&
        bancario.estado === 'Conciliado'
      );

      if (coincidencia) {
        hayCoincidenciaConciliada = true;
        break;
      }
    }

    this.botonDesvincularHabilitado = hayCoincidenciaConciliada;
    console.log('Botón desvincular habilitado:', this.botonDesvincularHabilitado);
  }

  verificarCondicionesAjuste() {
    // El botón de ajuste solo se habilita cuando se selecciona exactamente 1 registro de la tabla bancario
    this.botonAjusteHabilitado = this.filasSeleccionadasBancario.length > 0;
    console.log('Botón ajuste contable habilitado:', this.botonAjusteHabilitado);
  }

  onGridReadyMovimientos(params: GridReadyEvent) {
    this.gridApiMovimientos = params.api;
  }

  onGridReadyBancario(params: GridReadyEvent) {
    this.gridApiBancario = params.api;
  }
  async abrirmodalUbicaciones() {
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar ubicaciones',
        descripcionpaso2: 'El sistema te permite adjuntar documentos en los formatos .TXT, .CSV, .XLS, .XML.',
        buttonName: 'Importar documento',
        nombreselector: 'Banco',
        placeholderselector: 'Selecciona un banco',
        habilitarselector: true,
      }
    });
    await modal.present();

    const result = await modal.onWillDismiss();
    const data = result?.data;
    if (data && data.archivo) {
      // Guardar archivo en el componente padre
      console.log('se sube archivo', data.archivo);
      // Mostrar toast indicando que el archivo fue subido
      this.rowDataBancario = [
        { fecha: '10/11/2025', id: 'TXN-2025-001', comprobante: 'B001-00234', cliente: 'Juan Pérez García', monto: 850.00, comision: -12.75, neto: 837.25, estado: 'Pendiente' },
        { fecha: '10/11/2025', id: 'TXN-2025-002', comprobante: 'F001-00095', cliente: 'Transportes Norte SAC', monto: 1450.00, comision: -21.75, neto: 1428.25, estado: 'Pendiente' },
        { fecha: '10/11/2025', id: 'TXN-2025-003', comprobante: 'B001-00235', cliente: 'María López Sánchez', monto: 140.00, comision: -2.10, neto: 137.90, estado: 'Pendiente' },
        { fecha: '10/11/2025', id: 'TXN-2025-004', comprobante: 'B001-00236', cliente: 'Carlos Ramírez Torres', monto: 340.00, comision: -5.10, neto: 334.90, estado: 'Pendiente' },
        { fecha: '10/11/2025', id: 'TXN-2025-005', comprobante: 'F001-00096', cliente: 'Grupo Inversiones ABC', monto: 2450.00, comision: -36.75, neto: 2413.25, estado: 'Pendiente' },
        { fecha: '10/11/2025', id: 'TXN-2025-006', comprobante: 'B001-00238', cliente: 'Roberto Silva Campos', monto: 175.00, comision: -2.63, neto: 172.37, estado: 'Pendiente' },
        { fecha: '10/11/2025', id: 'TXN-2025-007', comprobante: 'B001-00239', cliente: 'Patricia Mendoza Cruz', monto: 425.50, comision: -6.38, neto: 419.12, estado: 'Pendiente' },
        { fecha: '10/11/2025', id: 'TXN-2025-008', comprobante: 'F001-00097', cliente: 'Eventos Corporativos SAC', monto: 1800.00, comision: -27.00, neto: 1773.00, estado: 'Pendiente' },
        { fecha: '10/11/2025', id: 'TXN-2025-009', comprobante: 'B001-00240', cliente: 'Luis Gutiérrez Ramos', monto: 220.00, comision: -3.30, neto: 216.70, estado: 'Pendiente' },
      ]
      this.cantidaddeextractos = this.rowDataBancario.length;
    }
  }
  async abrirModalFiltros() {
    const Modal = await this.modalController.create({
      component: ModalFiltrosComponent,
      cssClass: 'promo2',
    })
    await Modal.present();
  }
  
  async abrirModalGenerarAjuste() {
    // Preparar los datos de los movimientos seleccionados para el modal
    this.rowDataMovimientosAjustarModalPasarela = this.filasSeleccionadasBancario.map(item => ({
      fecha: item.mp_fecha,
      pasarela: this.bancoSeleccionado || 'Pasarela',
      comprobante: item.mp_comprobante,
      cliente: item.mp_cliente,
      monto: item.mp_monto,
      comision: item.comision,
      neto: item.neto
    }));

    const modal = await this.modalController.create({
      component: ModalGenerarAjusteComponent,
      cssClass: 'promo',
      componentProps: {
        totalDebe: 'S/0.00',
        totalHaber: 'S/0.00',
        colDefsMovimientosAjustar: this.colDefsMovimientosAjustarModalPasarela,
        colDefsAsiento: this.colDefsAsientoModalPasarela,
        rowDataMovimientosAjustar: this.rowDataMovimientosAjustarModalPasarela,
        tiposAjuste: this.tiposAjustePasarela,
        cuentasContables: this.cuentasContablesPasarela,
        labelTipoAjuste: 'Cuenta de gasto',
        labelCuentaDebito: 'Cuenta de crédito fiscal',
        labelCuentaCredito: 'Cuenta banco receptor',
        mostrarObservaciones: false
      }
    });

    await modal.present();
    
    const { data, role } = await modal.onWillDismiss();
    
    if (role === 'aplicar' && data?.ajusteGenerado) {
      // Actualizar el estado de los registros seleccionados a "Conciliado"
      this.filasSeleccionadasBancario.forEach(seleccionado => {
        const index = this.rowDataBancario.findIndex((item: any) => 
          item.mp_fecha === seleccionado.fecha &&
          item.mp_comprobante === seleccionado.comprobante &&
          item.mp_cliente === seleccionado.cliente
        );
        
        if (index !== -1) {
          this.rowDataBancario[index].estado = 'Conciliado';
        }
      });
      
      // Actualizar la grid
      if (this.gridApiBancario) {
        this.gridApiBancario.setGridOption('rowData', this.rowDataBancario);
        this.gridApiBancario.deselectAll();
      }
      
      // Limpiar selección
      this.filasSeleccionadasBancario = [];
      this.botonAjusteHabilitado = false;
    }
  }

  // Método que será llamado desde VistaCellRenderComponent
  // abrirModal(monto: string, rowData: any) {
  //   console.log('Abriendo modal de ajuste para monto:', monto);
  //   console.log('Datos de la fila:', rowData);
  //   this.abrirModalGenerarAjuste();
  // }
  onRowClicked(event: any) {
    console.log('Fila clickeada:', event.data);
    const data = event.data;
    if (data.cp_estado === 'Cerrado') {
      this.cruceCerrado = true;
      this.rowDataMovimientos = [
        { mp_fecha: '10/11/2025', mp_pasarela: 'Yape', mp_descripcion: 'Pago por delivery - Orden #12345', mp_cliente: 'Juan Pérez García', mp_comprobante: 'B001-00234', mp_monto: 850.00, mp_usuario: 'clopez', mp_estado: 'Conciliado' },
        { mp_fecha: '10/11/2025', mp_pasarela: 'Mercado Pago', mp_descripcion: 'Pago adelantado - Evento corporativo', mp_cliente: 'Transportes Norte SAC', mp_comprobante: 'F001-00095', mp_monto: 1450.00, mp_usuario: 'vlosano', mp_estado: 'Conciliado' },
        { mp_fecha: '10/11/2025', mp_pasarela: 'Yape', mp_descripcion: 'Pago por consumo en local', mp_cliente: 'María López Sánchez', mp_comprobante: 'B001-00235', mp_monto: 140.00, mp_usuario: 'asanchez', mp_estado: 'Conciliado' },
        { mp_fecha: '10/11/2025', mp_pasarela: 'Niubiz', mp_descripcion: 'Pago tarjeta de crédito - Mesa 15', mp_cliente: 'Carlos Ramírez Torres', mp_comprobante: 'B001-00236', mp_monto: 340.00, mp_usuario: 'vlosano', mp_estado: 'Conciliado' },
        { mp_fecha: '10/11/2025', mp_pasarela: 'Mercado Pago', mp_descripcion: 'Pago por catering empresarial', mp_cliente: 'Grupo Inversiones ABC', mp_comprobante: 'F001-00096', mp_monto: 2450.00, mp_usuario: 'asanchez', mp_estado: 'Conciliado' },
        { mp_fecha: '10/11/2025', mp_pasarela: 'Yape', mp_descripcion: 'Pago por delivery - Orden #12346', mp_cliente: 'Ana Torres Vega', mp_comprobante: 'B001-00237', mp_monto: 95.50, mp_usuario: 'clopez', mp_estado: 'Conciliado' },
      ]
      this.rowDataBancario = [
        { fecha: '10/11/2025', id: 'TXN-2025-001', comprobante: 'B001-00234', cliente: 'Juan Pérez García', monto: 850.00, comision: -12.75, neto: 837.25, estado: 'Conciliado' },
        { fecha: '10/11/2025', id: 'TXN-2025-002', comprobante: 'F001-00095', cliente: 'Transportes Norte SAC', monto: 1450.00, comision: -21.75, neto: 1428.25, estado: 'Conciliado' },
        { fecha: '10/11/2025', id: 'TXN-2025-003', comprobante: 'B001-00235', cliente: 'María López Sánchez', monto: 140.00, comision: -2.10, neto: 137.90, estado: 'Conciliado' },
        { fecha: '10/11/2025', id: 'TXN-2025-004', comprobante: 'B001-00236', cliente: 'Carlos Ramírez Torres', monto: 340.00, comision: -5.10, neto: 334.90, estado: 'Conciliado' },
        { fecha: '10/11/2025', id: 'TXN-2025-005', comprobante: 'F001-00096', cliente: 'Grupo Inversiones ABC', monto: 2450.00, comision: -36.75, neto: 2413.25, estado: 'Conciliado' },
        { fecha: '10/11/2025', id: 'TXN-2025-006', comprobante: 'B001-00237', cliente: 'Ana Torres Vega', monto: 95.50, comision: -1.43, neto: 94.07, estado: 'Conciliado' },
      ]
      this.habilitarbotoncerrar = true;
      this.cantidaddeextractos = this.rowDataBancario.length;
    } else {
      this.cruceCerrado = false;
      console.log('El cruce no está cerrado. No se pueden mostrar los movimientos conciliados.');
      this.rowDataMovimientos = [
        { mp_fecha: '10/11/2025', mp_pasarela: 'Yape', mp_descripcion: 'Pago por delivery - Orden #12345', mp_cliente: 'Juan Pérez García', mp_comprobante: 'B001-00234', mp_monto: 850.00, mp_usuario: 'clopez', mp_estado: 'Conciliado' },
        { mp_fecha: '10/11/2025', mp_pasarela: 'Mercado Pago', mp_descripcion: 'Pago adelantado - Evento corporativo', mp_cliente: 'Transportes Norte SAC', mp_comprobante: 'F001-00095', mp_monto: 1450.00, mp_usuario: 'vlosano', mp_estado: 'Conciliado' },
        { mp_fecha: '10/11/2025', mp_pasarela: 'Yape', mp_descripcion: 'Pago por consumo en local', mp_cliente: 'María López Sánchez', mp_comprobante: 'B001-00235', mp_monto: 140.00, mp_usuario: 'asanchez', mp_estado: 'Conciliado' },
        { mp_fecha: '10/11/2025', mp_pasarela: 'Niubiz', mp_descripcion: 'Pago tarjeta de crédito - Mesa 15', mp_cliente: 'Carlos Ramírez Torres', mp_comprobante: 'B001-00236', mp_monto: 340.00, mp_usuario: 'vlosano', mp_estado: 'Pendiente' },
        { mp_fecha: '10/11/2025', mp_pasarela: 'Mercado Pago', mp_descripcion: 'Pago por catering empresarial', mp_cliente: 'Grupo Inversiones ABC', mp_comprobante: 'F001-00096', mp_monto: 2450.00, mp_usuario: 'asanchez', mp_estado: 'Pendiente' },
        { mp_fecha: '10/11/2025', mp_pasarela: 'Yape', mp_descripcion: 'Pago por delivery - Orden #12346', mp_cliente: 'Ana Torres Vega', mp_comprobante: 'B001-00237', mp_monto: 95.50, mp_usuario: 'clopez', mp_estado: 'Pendiente' },
      ];
      this.rowDataBancario = [
        { fecha: '10/11/2025', id: 'TXN-2025-001', comprobante: 'B001-00234', cliente: 'Juan Pérez García', monto: 850.00, comision: -12.75, neto: 837.25, estado: 'Conciliado' },
        { fecha: '10/11/2025', id: 'TXN-2025-002', comprobante: 'F001-00095', cliente: 'Transportes Norte SAC', monto: 1450.00, comision: -21.75, neto: 1428.25, estado: 'Conciliado' },
        { fecha: '10/11/2025', id: 'TXN-2025-003', comprobante: 'B001-00235', cliente: 'María López Sánchez', monto: 140.00, comision: -2.10, neto: 137.90, estado: 'Conciliado' },
        { fecha: '10/11/2025', id: 'TXN-2025-004', comprobante: 'B001-00236', cliente: 'Carlos Ramírez Torres', monto: 340.00, comision: -5.10, neto: 334.90, estado: 'Pendiente' },
        { fecha: '10/11/2025', id: 'TXN-2025-005', comprobante: 'F001-00096', cliente: 'Grupo Inversiones ABC', monto: 2450.00, comision: -36.75, neto: 2413.25, estado: 'Pendiente' },
        { fecha: '10/11/2025', id: 'TXN-2025-006', comprobante: 'B001-00237', cliente: 'Ana Torres Vega', monto: 95.50, comision: -1.43, neto: 94.07, estado: 'Pendiente' },
      ];
      this.cantidaddeextractos = this.rowDataBancario.length;
      this.habilitarbotoncerrar = false;
    }
  }
  nuevocruce() {
    this.cruceCerrado = false;
    this.rowDataBancario = [];
    this.rowDataMovimientos = [
      { mp_fecha: '10/11/2025', mp_pasarela: 'Yape', mp_descripcion: 'Pago por delivery - Orden #12345', mp_cliente: 'Juan Pérez García', mp_comprobante: 'B001-00234', mp_monto: 850.00, mp_usuario: 'clopez', mp_estado: 'Pendiente' },
      { mp_fecha: '10/11/2025', mp_pasarela: 'Mercado Pago', mp_descripcion: 'Pago adelantado - Evento corporativo', mp_cliente: 'Transportes Norte SAC', mp_comprobante: 'F001-00095', mp_monto: 1450.00, mp_usuario: 'vlosano', mp_estado: 'Pendiente' },
      { mp_fecha: '10/11/2025', mp_pasarela: 'Yape', mp_descripcion: 'Pago por consumo en local', mp_cliente: 'María López Sánchez', mp_comprobante: 'B001-00235', mp_monto: 140.00, mp_usuario: 'asanchez', mp_estado: 'Pendiente' },
      { mp_fecha: '10/11/2025', mp_pasarela: 'Niubiz', mp_descripcion: 'Pago tarjeta de crédito - Mesa 15', mp_cliente: 'Carlos Ramírez Torres', mp_comprobante: 'B001-00236', mp_monto: 340.00, mp_usuario: 'vlosano', mp_estado: 'Pendiente' },
      { mp_fecha: '10/11/2025', mp_pasarela: 'Mercado Pago', mp_descripcion: 'Pago por catering empresarial', mp_cliente: 'Grupo Inversiones ABC', mp_comprobante: 'F001-00096', mp_monto: 2450.00, mp_usuario: 'asanchez', mp_estado: 'Pendiente' },
      { mp_fecha: '10/11/2025', mp_pasarela: 'Yape', mp_descripcion: 'Pago por delivery - Orden #12346', mp_cliente: 'Ana Torres Vega', mp_comprobante: 'B001-00237', mp_monto: 95.50, mp_usuario: 'clopez', mp_estado: 'Pendiente' },
    ];
    this.cantidaddeextractos = this.rowDataBancario.length;
    this.gridApi.deselectAll();
    console.log('Nuevo cruce iniciado');
  }

  guardarCruce() {
    console.log('Guardando cruce...');
    
    // Mostrar toast de éxito
    this.toastService.success('¡Cruce guardado exitosamente!');
    
    // Mantener los botones deshabilitados
    this.habilitarbotoncerrar = true;
    
    console.log('Cruce guardado correctamente');
  }

  cerrarConciliacion() {
    console.log('Intentando cerrar conciliación...');
    
    // Verificar que no haya pendientes
    const totalPendientes = this.rowDataMovimientos.filter(m => m.mp_estado === 'Pendiente').length;
    
    if (totalPendientes > 0) {
      console.log('No se puede cerrar: hay', totalPendientes, 'movimientos pendientes');
      this.toastService.danger('No se puede cerrar la conciliación. Aún hay movimientos pendientes.');
      return;
    }
    
    // Cerrar la conciliación
    this.cruceCerrado = true;
    
    // Mostrar toast de éxito
    this.toastService.success('¡Conciliación cerrada exitosamente!');
    
    // Deshabilitar todos los botones excepto Exportar
    this.botonVincularHabilitado = false;
    this.botonDesvincularHabilitado = false;
    this.botonAjusteHabilitado = false;
    this.botonCruceAutomaticoHabilitado = false;
    this.habilitarbotoncerrar = false;
    
    console.log('Conciliación cerrada correctamente');
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos
    this.cargarDatos(range.start, range.end);
  }
  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }
  async abrirModal() {
        // Obtener los datos de la fila para mostrar en el detalle
    
        const detalleOrdenGiro = [
          { label: 'Fecha de solicitud', value: '-'},
          { label: 'Fecha de aprobación', value: '-'},
          { label: 'Glosa', value:'Liquidación de gastos por comisión de servicio, en el que el colaborador usó auto propio para trasladarse de Piura a Chiclayo.' },
          { label: 'Total', value: 'S/1200' },
        ];
    
        const colDefs: ColDef[] = [
          { field: 'cuenta', headerName: 'Cuenta', width: 70 },
          { field: 'descripcion', headerName: 'Descripción', width: 150, flex: 1 },
          {
            field: 'debe',
            headerName: 'Debe(S/)',
            width: 90,
            headerClass: 'derechaencabezado',
            cellStyle: { textAlign: 'right' },
            valueFormatter: (params) => {
              if (params.value !== null && params.value !== undefined && params.value !== '') {
                const value = typeof params.value === 'string' ? parseFloat(params.value) : params.value;
                return new Intl.NumberFormat('es-PE', {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2,
                }).format(value);
              }
              return '-';
            },
          },
          {
            field: 'haber',
            headerName: 'Haber(S/)',
            width: 90,
            headerClass: 'derechaencabezado',
            cellStyle: { textAlign: 'right' },
            valueFormatter: (params) => {
              if (params.value !== null && params.value !== undefined && params.value !== '') {
                const value = typeof params.value === 'string' ? parseFloat(params.value) : params.value;
                return new Intl.NumberFormat('es-PE', {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2,
                }).format(value);
              }
              return '-';
            },
          },
          { field: 'tercero', headerName: 'Tercero', width: 130 }
        ];
    
        // Datos de ejemplo para la tabla contable
        const rowDataTabla = [
          { cuenta: '63112', descripcion: 'Combustible para viajar', debe: '', haber: '', tercero: '' },
          { cuenta: '63131', descripcion: 'Alojamiento - ' , debe: '', haber: '', tercero: '' }
        ];
    
        const modal = await this.modalController.create({
          component: ModalDetalleComponent,
          cssClass: 'promo',
          componentProps: {
            tituloModal: `Asiento contable AS-2025-09-001`,
            detalles: detalleOrdenGiro,
            mostrarTabla: true,
            colDefs: colDefs,
            rowData: rowDataTabla,
            mostrarTextarea: false,
            mostrarBotonEliminar: false,
            textoBotonCancelar: 'Cerrar',
            ocultarBotonConfirmar: true
          }
        });
    
        await modal.present();
      }
}
