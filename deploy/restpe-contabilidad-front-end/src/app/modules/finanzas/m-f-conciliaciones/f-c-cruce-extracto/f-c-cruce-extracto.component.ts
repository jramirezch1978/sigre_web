import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalController } from '@ionic/angular';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ModalGenerarAjusteComponent } from 'src/app/ui/modal-generar-ajuste/modal-generar-ajuste.component';
import { ModalFiltrosComponent } from 'src/app/ui/modal-filtros/modal-filtros.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalAdjuntarObservacionComponent } from 'src/app/ui/modal-adjuntar-observacion/modal-adjuntar-observacion.component';
import { ObservacionCellRenderComponent } from 'src/app/ui/observacion-cell-render/observacion-cell-render.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CruceExtractoEntity } from 'src/app/modules/finanzas/domain/models/cruce-extracto.entity';
import { MovimientoCruceEntity } from 'src/app/modules/finanzas/domain/models/movimiento-cruce.entity';
import { CruceExtractoFacade } from 'src/app/modules/finanzas/application/facades/cruce-extracto.facade';
import { CruceExtractoFeedbackEffects } from 'src/app/modules/finanzas/effects/cruce-extracto-feedback.effect';

// Font Awesome Icons
import { faHourglassHalf } from '@fortawesome/pro-regular-svg-icons';
import { faChartLineDown, faSackDollar } from '@fortawesome/pro-solid-svg-icons';
import { IconDefinition } from '@fortawesome/fontawesome-svg-core';

import { faChevronsRight, faChevronsLeft, faCirclePlus, faArrowsRotate } from '@fortawesome/pro-solid-svg-icons';
import { faFilter, faLinkSimple, faLinkSlash, faGear, faArrowUpFromBracket, faDownload } from '@fortawesome/pro-regular-svg-icons';
// Font Awesome Icons

// Font Awesome Icons

@Component({
  selector: 'app-f-c-cruce-extracto',
  templateUrl: './f-c-cruce-extracto.component.html',
  styleUrls: ['./f-c-cruce-extracto.component.scss'],
  standalone: false,
})
export class FCCruceExtractoComponent  implements OnInit, OnDestroy {
  private readonly facade = inject(CruceExtractoFacade);
  private readonly feedbackEffects = inject(CruceExtractoFeedbackEffects);
  readonly isLoading = this.facade.isLoading;
  // Font Awesome Icons
  farHourglassHalf = faHourglassHalf;
  fasChartLineDown = faChartLineDown;
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
  cantidaddemovimientos: number=0;
  cantidaddeextractos: number=0;
  mostrartabla: boolean = false;
  filasSeleccionadasMovimientos: any[] = [];
  filasSeleccionadasBancario: any[] = [];
  botonVincularHabilitado: boolean = false;
  botonDesvincularHabilitado: boolean = false;
  habilitarbotoncerrar: boolean = false;
  botonAjusteHabilitado: boolean = false;
  cruceCerrado: boolean = false;
  gridContext: any;
;
    bancosSelect = [
    'BCP',
    'Banco de la Nación',
  ]
  bancoSeleccionado='';
  cards=[
    {nombre:'Total conciliados', valor:'0', icono: faChartLineDown},
    {nombre:'Total pendientes', valor:'0', icono: faHourglassHalf},
    {nombre:'Diferencia', valor:'S/0.00', icono: faSackDollar},
  ]
  colDefs: ColDef[] = [
    { field: 'ce_codigo', headerName: 'Código', flex: 0.5, minWidth: 64},
    { field: 'fecha', headerName: 'Fecha', flex: 0.5, minWidth: 64, filter:true,
      cellRenderer: (params: any) => {
        const banco = params.value;
        return `<div class="flex flex-col leading-none gap-1">
                  <span class="text-xxss">10/11/2025 -</span>
                  <span class="text-xxss">30/11/2025</span>
                </div>`;
      }
    },
    { field: 'ce_banco', headerName: 'Banco', flex: 1, minWidth: 128, filter:true,
      cellRenderer: (params: any) => {
        const banco = params.value;
        return `<div class="flex flex-col leading-none gap-1">
                  <span class="text-xxss">${banco}</span>
                  <span class="text-[#878787] font-normal text-xxss">455-1849356-0-21</span>
                </div>`;
      }
    },
    {
      headerClass: 'centrarencabezado',
      field: 'ce_estado',
      headerName: 'Estado',
      flex: 0.5,
      minWidth: 75,
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
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    }
  ];

  rowData: CruceExtractoEntity[] = [];
  colDefsMovimientos: ColDef[] = [
    { field: '', checkboxSelection: true, headerCheckboxSelection: true,headerName: '', flex: 0.5, minWidth: 23 },
    { field: 'mc_fecha', headerName: 'Fecha', flex: 1, minWidth: 40,filter:true },
    { field: 'mc_banco', headerName: 'Banco', flex: 1, minWidth: 40,filter:true},
    { field: 'mc_tipo', headerName: 'Tipo', flex: 1, minWidth: 46,filter:true },
    { field: 'mc_descripcion', headerName: 'Descripción', flex: 2, minWidth: 80,
      cellRenderer: (params: any) => {
        const descripcion = params.value;
        return `<div class="flex flex-col leading-none gap-1">
                  <span class="text-xxss">${descripcion}</span>
                  <span class="text-[#878787] font-normal text-xxss">455-1849356-0-21</span>
                </div>`;
      }
     },
    { field: 'mc_monto', headerName: 'Monto', headerClass: 'derechaencabezado', flex: 1, minWidth: 60, 
      cellRenderer: VistaCellRenderComponent,
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
        const style: any = { textAlign: 'right',
          display: 'flex',
          justifyContent: 'right'};
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { field: 'mc_estado', headerName: 'Estado',headerClass:'centrarencabezado', flex: 1, minWidth: 56, filter:true, 
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        
        switch(estado) {
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
  rowDataMovimientos: MovimientoCruceEntity[] = [];
  colDefsBancario: ColDef[] = [
    { field: '', checkboxSelection: true, headerCheckboxSelection: true,headerName: '', flex: 0.5, minWidth: 23 },
    { field: 'mc_fecha', headerName: 'Fecha', flex: 1, minWidth: 40 },
    // { field: 'banco', headerName: 'Banco', flex: 1, minWidth: 40, 
    { field: 'mc_tipo', headerName: 'Tipo', flex: 1, minWidth: 46 },
    { field: 'mc_descripcion', headerName: 'Descripción', flex: 2, minWidth: 80,
      cellRenderer: (params: any) => {
        const banco = params.value;
        return `<div class="flex flex-col leading-none gap-1">
                  <span class="text-xxss">${banco}</span>
                  <span class="text-[#878787] font-normal text-xxss">455-1849356-0-21</span>
                </div>`;
      }
     },
    { field: 'mc_monto', headerName: 'Monto', headerClass: 'derechaencabezado', flex: 1, minWidth: 60,
      // cellRenderer: VistaCellRenderComponent,
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
        const style: any = { textAlign: 'right',  display: 'flex',
          justifyContent: 'right'};
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { field: 'mc_estado', headerName: 'Estado', flex: 1, minWidth: 56,headerClass: 'centrarencabezado',
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        
        switch(estado) {
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
    { field: 'acciones', headerName: 'Acciones', flex: 0.5, minWidth: 60,headerClass: 'centrarencabezado',
      cellRenderer: ObservacionCellRenderComponent,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    },    
  ];
  rowDataBancario: MovimientoCruceEntity[] = []

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
    noRowsToShow: ''
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

  // Configuración de columnas para el modal de ajuste
  colDefsMovimientosAjustarModal: ColDef[] = [
    { field: 'fecha', headerName: 'Fecha', flex: 1 },
    { field: 'descripcion', headerName: 'Descripción', flex: 2},
    { field: 'referencia', headerName: 'Referencia', flex: 1},
    { field: 'monto', headerName: 'Monto', flex: 1,
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
      },
     },
  ];

  colDefsAsientoModal: ColDef[] = [
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

  rowDataMovimientosAjustarModal: any[] = [];

  constructor(private modalController: ModalController, private toastService: ToastService) {
    this.gridContext = { componentParent: this };
    this.cantidaddemovimientos = this.rowDataMovimientos.length;
     this.cantidaddemovimientos = this.rowDataMovimientos.length;
    const today = new Date();
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );
    this.maxDate = today;
    effect(() => {
      const cruces = this.facade.cruces();
      this.rowData = cruces;
      if (this.gridApi) this.gridApi.setGridOption('rowData', this.rowData);
    });
    effect(() => {
      const movimientos = this.facade.movimientos();
      if (movimientos.length > 0) {
        this.rowDataMovimientos = movimientos;
        this.cantidaddemovimientos = movimientos.length;
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
  
  mostrarTabla(valor: boolean){
    this.mostrartabla = valor;
    console.log('Mostrar tabla:', this.mostrartabla);
  }
  onCellClicked(event: any){
    if (!event.data) return;
    console.log('Celda clickeada:', event.data);
  }
  limpiar(){
    this.bancoSeleccionado='';
  }
  onSelectionChangedMovimientos(event: any) {
    if (this.gridApiMovimientos) {
      this.filasSeleccionadasMovimientos = this.gridApiMovimientos.getSelectedRows();
      console.log('=== Movimientos del Sistema - Selección Múltiple ===');
      console.log('Total de filas seleccionadas:', this.filasSeleccionadasMovimientos.length);
      console.log('Datos:', this.filasSeleccionadasMovimientos);
      this.verificarCondicionesVinculacion();
      this.verificarCondicionesDesvinculacion();
      this.verificarCondicionesAjuste();
    }
  }

  get botonAplicarDeshabilitado(): boolean {
    return this.bancoSeleccionado === '';
  }
  cruceautomatico(){
    if(this.rowDataBancario.length===0){
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
      const coincidencia = this.rowDataBancario.find((bancario:any) => 
        bancario.mc_fecha === movimiento.mc_fecha &&
        // bancario.mc_banco === movimiento.mc_banco &&
        movimiento.mc_descripcion === bancario.mc_descripcion &&
        bancario.mc_tipo === movimiento.mc_tipo &&
        bancario.mc_monto === movimiento.mc_monto
      );
      
      if (coincidencia) {
        movimientosConciliados++;
        return { ...movimiento, mc_estado: 'Conciliado' };
      }
      return { ...movimiento, mc_estado: 'Pendiente' };
    });
    
    // Recorrer extracto bancario y actualizar estados
    this.rowDataBancario = this.rowDataBancario.map((bancario:any) => {
      // Buscar coincidencia en movimientos del sistema
      const coincidencia = this.rowDataMovimientos.find(movimiento => 
        movimiento.mc_fecha === bancario.mc_fecha &&
        // movimiento.mc_banco === bancario.mc_banco &&
        movimiento.mc_tipo === bancario.mc_tipo &&
        movimiento.mc_monto === bancario.mc_monto &&
        movimiento.mc_descripcion === bancario.mc_descripcion &&
        movimiento.mc_estado === 'Conciliado'
      );
      
      if (coincidencia) {
        bancariosConciliados++;
        return { ...bancario, mc_estado: 'Conciliado' };
      }
      return { ...bancario, mc_estado: 'Pendiente' };
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
    
    console.log('Movimientos conciliados:', movimientosConciliados);
    console.log('Movimientos pendientes:', pendientes);
    console.log('Extractos bancarios conciliados:', bancariosConciliados);
    console.log('=== Cruce Automático Completado ===');
    
    // Habilitar botones de Guardar y Cerrar conciliación
    this.habilitarbotoncerrar = true;
    
    // Mostrar toast de éxito
    this.toastService.success('¡Cruce automático realizado con éxito!');
  }
  
  desvincularseleccionados(){
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
        bancario.mc_fecha === movimiento.mc_fecha &&
        bancario.mc_monto === movimiento.mc_monto &&
        movimiento.mc_estado === 'Conciliado' &&
        bancario.mc_estado === 'Conciliado'
      );
      
      if (bancarioCoincidente) {
        console.log('✓ Registro conciliado encontrado para desvincular:', {
          fecha: movimiento.mc_fecha,
          monto: movimiento.mc_monto,
          descripcionMov: movimiento.mc_descripcion,
          descripcionBanc: bancarioCoincidente.descripcion
        });
        
        // Actualizar el estado en rowDataMovimientos a Pendiente
        const indexMov = this.rowDataMovimientos.findIndex(m => 
          m.mc_fecha === movimiento.mc_fecha &&
          m.mc_monto === movimiento.mc_monto &&
          m.mc_descripcion === movimiento.mc_descripcion
        );
        
        if (indexMov !== -1) {
          this.rowDataMovimientos[indexMov].mc_estado = 'Pendiente';
        }
        
        // Actualizar el estado en rowDataBancario a Pendiente
        const indexBanc = this.rowDataBancario.findIndex((b: any) => 
          b.mc_fecha === bancarioCoincidente.fecha &&
          b.mc_monto === bancarioCoincidente.monto &&
          b.mc_descripcion === bancarioCoincidente.descripcion
        );
        
        if (indexBanc !== -1) {
          this.rowDataBancario[indexBanc].mc_estado = 'Pendiente';
        }
        
        desvinculacionesExitosas++;
      } else {
        console.log('✗ No se puede desvincular (no conciliado o sin coincidencia):', {
          fecha: movimiento.mc_fecha,
          monto: movimiento.mc_monto,
          estado: movimiento.mc_estado,
          descripcion: movimiento.mc_descripcion
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
    const totalConciliados = this.rowDataMovimientos.filter(m => m.mc_estado === 'Conciliado').length;
    const totalPendientes = this.rowDataMovimientos.length - totalConciliados;
    
    this.cards[0].valor = totalConciliados.toString();
    this.cards[1].valor = totalPendientes.toString();
    
    // Limpiar selecciones
    this.filasSeleccionadasMovimientos = [];
    this.filasSeleccionadasBancario = [];
    this.botonDesvincularHabilitado = false;
    
    console.log(`=== Desvinculación Completada: ${desvinculacionesExitosas} registros desvinculados ===`);
  }
  
  vincular(){
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
        bancario.mc_fecha === movimiento.mc_fecha &&
        bancario.mc_monto === movimiento.mc_monto
      );
      
      if (bancarioCoincidente) {
        console.log('✓ Coincidencia encontrada:', {
          fecha: movimiento.mc_fecha,
          monto: movimiento.mc_monto,
          descripcionMov: movimiento.mc_descripcion,
          descripcionBanc: bancarioCoincidente.descripcion
        });
        
        // Actualizar el estado en rowDataMovimientos
        const indexMov = this.rowDataMovimientos.findIndex(m => 
          m.mc_fecha === movimiento.mc_fecha &&
          m.mc_monto === movimiento.mc_monto &&
          m.mc_descripcion === movimiento.mc_descripcion
        );
        
        if (indexMov !== -1) {
          this.rowDataMovimientos[indexMov].mc_estado = 'Conciliado';
        }
        
        // Actualizar el estado en rowDataBancario
        const indexBanc = this.rowDataBancario.findIndex((b: any) => 
          b.mc_fecha === bancarioCoincidente.fecha &&
          b.mc_monto === bancarioCoincidente.monto &&
          b.mc_descripcion === bancarioCoincidente.descripcion
        );
        
        if (indexBanc !== -1) {
          this.rowDataBancario[indexBanc].mc_estado = 'Conciliado';
        }
        
        vinculacionesExitosas++;
      } else {
        console.log('✗ Sin coincidencia para movimiento:', {
          fecha: movimiento.mc_fecha,
          monto: movimiento.mc_monto,
          descripcion: movimiento.mc_descripcion
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
    const totalConciliados = this.rowDataMovimientos.filter(m => m.mc_estado === 'Conciliado').length;
    const totalPendientes = this.rowDataMovimientos.length - totalConciliados;
    
    this.cards[0].valor = totalConciliados.toString();
    this.cards[1].valor = totalPendientes.toString();
    
    // Limpiar selecciones
    this.filasSeleccionadasMovimientos = [];
    this.filasSeleccionadasBancario = [];
    this.botonVincularHabilitado = false;
    this.botonDesvincularHabilitado = false;
    
    console.log(`=== Vinculación Completada: ${vinculacionesExitosas} registros vinculados ===`);
  }
  ajustecontable(){
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
    // El botón Vincular se activa cuando hay al menos una selección en cada tabla Y el cruce no está cerrado
    this.botonVincularHabilitado = !this.cruceCerrado && this.filasSeleccionadasMovimientos.length > 0 && this.filasSeleccionadasBancario.length > 0;
    console.log('Botón vincular habilitado:', this.botonVincularHabilitado);
  }
  
  verificarCondicionesDesvinculacion() {
    // Validar que hay selecciones en ambas tablas Y el cruce no está cerrado
    if (this.cruceCerrado || this.filasSeleccionadasMovimientos.length === 0 || this.filasSeleccionadasBancario.length === 0) {
      this.botonDesvincularHabilitado = false;
      return;
    }
    
    // Verificar si existe al menos una coincidencia válida (fecha, monto iguales Y estado Conciliado)
    let hayCoincidenciaConciliada = false;
    
    for (const movimiento of this.filasSeleccionadasMovimientos) {
      const coincidencia = this.filasSeleccionadasBancario.find(bancario => 
        bancario.mc_fecha === movimiento.mc_fecha &&
        bancario.mc_monto === movimiento.mc_monto &&
        movimiento.mc_estado === 'Conciliado' &&
        bancario.mc_estado === 'Conciliado'
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
    // El botón de ajuste solo se habilita cuando se selecciona al menos 1 registro de la tabla bancario
    // Y NO hay ninguna selección en movimientos del sistema Y el cruce no está cerrado
    this.botonAjusteHabilitado = !this.cruceCerrado && this.filasSeleccionadasBancario.length > 0 && this.filasSeleccionadasMovimientos.length === 0;
    console.log('Botón ajuste contable habilitado:', this.botonAjusteHabilitado);
  }
  
  onGridReadyMovimientos(params: GridReadyEvent){
    this.gridApiMovimientos = params.api;
  }
  
  onGridReadyBancario(params: GridReadyEvent){
    this.gridApiBancario = params.api;
  }
  async abrirModalFiltros() {
      const Modal = await this.modalController.create({
        component: ModalFiltrosComponent,
        cssClass: 'promo2',
      })
      await Modal.present();
    }
  async abrirmodalUbicaciones(){
        const modal = await this.modalController.create({
          component: ModalImportarComponent,
          cssClass: 'promo',
          componentProps: {
            titulo: 'Importar reporte bancario',
            descripcionpaso2: 'El sistema te permite adjuntar documentos en los formatos .TXT, .CSV, .XLS, .XML.',
            buttonName: 'Importar documento',
            nombreselector:'Banco',
            placeholderselector:'Selecciona un banco',
            habilitarselector:true,
            descripcionSubir: '',
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
              {mc_fecha:'10/11/2025', mc_tipo:'Pago', mc_descripcion:'Pago factura F001-00089 - Distribuidora Alimentos SAC', mc_monto:-850.00, mc_estado:'Pendiente'},
              {mc_fecha:'10/11/2025', mc_tipo:'Depósito', mc_descripcion:'Cobranza factura F001-0095 Clientes Trasnportes Norte', mc_monto:1450.00, mc_estado:'Pendiente'},
              {mc_fecha:'10/11/2025', mc_tipo:'Cobranza', mc_descripcion:'Transferencia recibida - Adelanto cliente varios', mc_monto:140.00, mc_estado:'Pendiente'},
              {mc_fecha:'10/11/2025', mc_tipo:'Cheque', mc_descripcion:'Pago servicios generales - Luz y agua', mc_monto:140.00, mc_estado:'Pendiente'},
              {mc_fecha:'10/11/2025', mc_tipo:'Depósito', mc_descripcion:'Pago combustible - Grifo Central', mc_monto:450.00, mc_estado:'Pendiente'},
              {mc_fecha:'10/11/2025', mc_tipo:'Depósito', mc_descripcion:'Cheque N° 001234 - oficial', mc_monto:780.00, mc_estado:'Pendiente'},
              {mc_fecha:'10/11/2025', mc_tipo:'Depósito', mc_descripcion:'Envío estado de cuenta', mc_monto:-5.50, mc_estado:'Pendiente'},
              {mc_fecha:'10/11/2025', mc_tipo:'Depósito', mc_descripcion:'Intereses deudores', mc_monto:-0.57, mc_estado:'Pendiente'},
              {mc_fecha:'10/11/2025', mc_tipo:'Depósito', mc_descripcion:'Comisión mantenimiento', mc_monto:-35.00, mc_estado:'Pendiente'},
            ]
            this.cantidaddeextractos = this.rowDataBancario.length;
          }
      }
  async abrirModalGenerarAjuste() {
    // Preparar los datos de los movimientos seleccionados para el modal
    this.rowDataMovimientosAjustarModal = this.filasSeleccionadasBancario.map((item, index) => {
      // Generar una referencia automática basada en el tipo de movimiento
      let referencia = '-';
      const desc = item.mc_descripcion?.toLowerCase() || '';
      
      if (desc.includes('intereses')) {
        referencia = `INT-${String(index + 2222).padStart(4, '0')}`;
      } else if (desc.includes('comisión')) {
        referencia = `COM-${String(index + 1000).padStart(4, '0')}`;
      } else if (desc.includes('mantenimiento')) {
        referencia = `MAN-${String(index + 3000).padStart(4, '0')}`;
      } else if (desc.includes('itf') || desc.includes('impuesto')) {
        referencia = `ITF-${String(index + 5000).padStart(4, '0')}`;
      } else {
        referencia = `MOV-${String(index + 1000).padStart(4, '0')}`;
      }
      
      return {
        fecha: item.mc_fecha,
        descripcion: item.mc_descripcion,
        referencia: referencia,
        monto: item.mc_monto
      };
    });

    const modal = await this.modalController.create({
      component: ModalGenerarAjusteComponent,
      cssClass: 'promo',
      componentProps: {
        totalDebe:'S/0.00',
        totalHaber:'S/0.00',
        colDefsMovimientosAjustar: this.colDefsMovimientosAjustarModal,
        colDefsAsiento: this.colDefsAsientoModal,
        rowDataMovimientosAjustar: this.rowDataMovimientosAjustarModal
      }
    });

    await modal.present();
    
    const { data, role } = await modal.onWillDismiss();
    
    if (role === 'aplicar' && data?.ajusteGenerado) {
      // Actualizar el estado de los registros seleccionados a "Conciliado"
      this.filasSeleccionadasBancario.forEach(seleccionado => {
        const index = this.rowDataBancario.findIndex((item: any) => 
          item.mc_fecha === seleccionado.mc_fecha &&
          item.mc_monto === seleccionado.mc_monto &&
          item.mc_descripcion === seleccionado.mc_descripcion
        );
        
        if (index !== -1) {
          this.rowDataBancario[index].mc_estado = 'Conciliado';
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
  
  onRowClicked(event: any){
    console.log('Fila clickeada:', event.data);
    const data = event.data;
    
    // Verificar si el cruce está cerrado
    this.cruceCerrado = data.ce_estado === 'Cerrado';
    
    if(data.ce_estado === 'Cerrado'){
      // Si está cerrado, desactivar todos los botones de edición
      this.botonVincularHabilitado = false;
      this.botonDesvincularHabilitado = false;
      this.botonAjusteHabilitado = false;
      
    this.rowDataMovimientos =[
      {mc_fecha:'10/11/2025', mc_banco:'BCP', mc_tipo:'Pago', mc_descripcion:'Pago factura F001-00089 - Distribuidora Alimentos SAC', mc_monto:-850.00, mc_estado:'Conciliado'},
      {mc_fecha:'10/11/2025', mc_banco:'Interbank', mc_tipo:'Depósito', mc_descripcion:'Cobranza factura F001-0095 Clientes Trasnportes Norte', mc_monto:1450.00, mc_estado:'Conciliado'},
      {mc_fecha:'10/11/2025', mc_banco:'BCP', mc_tipo:'Cobranza', mc_descripcion:'Transferencia recibida - Adelanto cliente varios', mc_monto:140.00, mc_estado:'Conciliado'},
      {mc_fecha:'10/11/2025', mc_banco:'BCP', mc_tipo:'Cheque', mc_descripcion:'Pago servicios generales - Luz y agua', mc_monto:140.00, mc_estado:'Conciliado'},
      {mc_fecha:'10/11/2025', mc_banco:'BCP', mc_tipo:'Depósito', mc_descripcion:'Pago combustible - Grifo Central', mc_monto:450.00, mc_estado:'Conciliado'},
      {mc_fecha:'10/11/2025', mc_banco:'BCP', mc_tipo:'Depósito', mc_descripcion:'Pago a proveedor servicio de hosting', mc_monto:-5.50, mc_estado:'Conciliado'},
    ]
    this.rowDataBancario =[
      {mc_fecha:'10/11/2025', mc_tipo:'Pago', mc_descripcion:'Pago factura F001-00089 - Distribuidora Alimentos SAC', mc_monto:-850.00, mc_estado:'Conciliado'},
      {mc_fecha:'10/11/2025', mc_tipo:'Depósito', mc_descripcion:'Cobranza factura F001-0095 Clientes Trasnportes Norte', mc_monto:1450.00, mc_estado:'Conciliado'},
      {mc_fecha:'10/11/2025', mc_tipo:'Cobranza', mc_descripcion:'Transferencia recibida - Adelanto cliente varios', mc_monto:140.00, mc_estado:'Conciliado'},
      {mc_fecha:'10/11/2025', mc_tipo:'Cheque', mc_descripcion:'Pago servicios generales - Luz y agua', mc_monto:140.00, mc_estado:'Conciliado'},
      {mc_fecha:'10/11/2025', mc_tipo:'Depósito', mc_descripcion:'Pago combustible - Grifo Central', mc_monto:450.00, mc_estado:'Conciliado'},
      {mc_fecha:'10/11/2025', mc_tipo:'Depósito', mc_descripcion:'Cheque N° 001234 - oficial', mc_monto:780.00, mc_estado:'Conciliado'},
    ]
    this.habilitarbotoncerrar=true;
    this.cantidaddeextractos = this.rowDataBancario.length;
    } else {  
      console.log('El cruce no está cerrado. No se pueden mostrar los movimientos conciliados.');
      this.rowDataMovimientos =[
          {mc_fecha:'10/11/2025', mc_banco:'BCP', mc_tipo:'Pago', mc_descripcion:'Pago factura F001-00089 - Distribuidora Alimentos SAC', mc_monto:-850.00, mc_estado:'Conciliado'},
          {mc_fecha:'10/11/2025', mc_banco:'Interbank', mc_tipo:'Depósito', mc_descripcion:'Cobranza factura F001-0095 Clientes Trasnportes Norte', mc_monto:1450.00, mc_estado:'Conciliado'},
          {mc_fecha:'10/11/2025', mc_banco:'BCP', mc_tipo:'Cobranza', mc_descripcion:'Transferencia recibida - Adelanto cliente varios', mc_monto:140.00, mc_estado:'Conciliado'},
          {mc_fecha:'10/11/2025', mc_banco:'BCP', mc_tipo:'Cheque', mc_descripcion:'Pago servicios generales - Luz y agua', mc_monto:140.00, mc_estado:'Pendiente'},
          {mc_fecha:'10/11/2025', mc_banco:'BCP', mc_tipo:'Depósito', mc_descripcion:'Pago combustible - Grifo Central', mc_monto:450.00, mc_estado:'Pendiente'},
          {mc_fecha:'10/11/2025', mc_banco:'BCP', mc_tipo:'Depósito', mc_descripcion:'Pago a proveedor servicio de hosting', mc_monto:-5.50, mc_estado:'Pendiente'},
      ];
      this.rowDataBancario =[
        {mc_fecha:'10/11/2025', mc_tipo:'Pago', mc_descripcion:'Pago factura F001-00089 - Distribuidora Alimentos SAC', mc_monto:-850.00, mc_estado:'Conciliado'},
        {mc_fecha:'10/11/2025', mc_tipo:'Depósito', mc_descripcion:'Cobranza factura F001-0095 Clientes Trasnportes Norte', mc_monto:1450.00, mc_estado:'Conciliado'},
        {mc_fecha:'10/11/2025', mc_tipo:'Cobranza', mc_descripcion:'Transferencia recibida - Adelanto cliente varios', mc_monto:140.00, mc_estado:'Conciliado'},
        {mc_fecha:'10/11/2025', mc_tipo:'Cheque', mc_descripcion:'Pago servicios generales - Luz y agua', mc_monto:140.00, mc_estado:'Pendiente'},
        {mc_fecha:'10/11/2025', mc_tipo:'Depósito', mc_descripcion:'Pago combustible - Grifo Central', mc_monto:450.00, mc_estado:'Pendiente'},
        {mc_fecha:'10/11/2025', mc_tipo:'Depósito', mc_descripcion:'Cheque N° 001234 - oficial', mc_monto:780.00, mc_estado:'Pendiente'},
      ];  
      this.cantidaddeextractos = this.rowDataBancario.length;
      this.habilitarbotoncerrar=false;
    }
  }
  nuevocruce(){
    this.rowDataBancario = [];
    this.rowDataMovimientos=[
      {mc_fecha:'10/11/2025', mc_banco:'BCP', mc_tipo:'Pago', mc_descripcion:'Pago factura F001-00089 - Distribuidora Alimentos SAC', mc_monto:-850.00, mc_estado:'Pendiente'},
      {mc_fecha:'10/11/2025', mc_banco:'Interbank', mc_tipo:'Depósito', mc_descripcion:'Cobranza factura F001-0095 Clientes Trasnportes Norte', mc_monto:1450.00, mc_estado:'Pendiente'},
      {mc_fecha:'10/11/2025', mc_banco:'BCP', mc_tipo:'Cobranza', mc_descripcion:'Transferencia recibida - Adelanto cliente varios', mc_monto:140.00, mc_estado:'Pendiente'},
      {mc_fecha:'10/11/2025', mc_banco:'BCP', mc_tipo:'Cheque', mc_descripcion:'Pago servicios generales - Luz y agua', mc_monto:140.00, mc_estado:'Pendiente'},
      {mc_fecha:'10/11/2025', mc_banco:'BCP', mc_tipo:'Depósito', mc_descripcion:'Pago combustible - Grifo Central', mc_monto:450.00, mc_estado:'Pendiente'},
      {mc_fecha:'10/11/2025', mc_banco:'BCP', mc_tipo:'Depósito', mc_descripcion:'Pago a proveedor servicio de hosting', mc_monto:-5.50, mc_estado:'Pendiente'},
    ];
    this.cantidaddeextractos = this.rowDataBancario.length;
    this.gridApi.deselectAll();
    console.log('Nuevo cruce iniciado');
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
