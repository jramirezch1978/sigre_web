import { Component, OnInit, inject, signal, effect, untracked, computed } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { AutocompleteCellrendererComponent } from 'src/app/ui/autocomplete-cellrenderer/autocomplete-cellrenderer.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalCuentasContablesComponent } from './components/modal-cuentas-contables/modal-cuentas-contables.component';
import { BotonAccionesComponent } from 'src/app/ui/boton-acciones/boton-acciones.component';
import { TablaContabilidadItem } from 'src/app/modules/contabilidad/domain/models/tablas-contabilidad.entity';
import { TablasContabilidadFacade } from 'src/app/modules/contabilidad/application/facades/tablas-contabilidad.facade';
import { TablasContabilidadFeedbackEffects } from 'src/app/modules/contabilidad/effects/tablas-contabilidad-feedback.effect';
import { SeleccionarCuentaContableFacade } from 'src/app/modules/contabilidad/application/facades/seleccionar-cuenta-contable.facade';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faChevronsLeft, faChevronsRight, faPlusCircle, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-contabilidad-tabla-contabilidad',
  templateUrl: './contabilidad-tabla-contabilidad.component.html',
  styleUrls: ['./contabilidad-tabla-contabilidad.component.scss'],
  standalone: false,
})
export class ContabilidadTablaContabilidadComponent  implements OnInit {
  // Font Awesome Icons
  farSearch = faSearch;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasPlusCircle = faPlusCircle;
  fasRotateRight = faRotateRight;



  panelLateralVisible: boolean = true;
  private gridApiFiltros!: GridApi;
  private gridApi!: GridApi;
  gridContext!: { componentParent: ContabilidadTablaContabilidadComponent };
  filaSeleccionada: any = null;
  filaCuentaSeleccionada: any = null;

  listaformulas = [
    { id: 'totaldoc', nombre: '(Car, Cob, Car, Pag) Total de Doc.'},
    { id: 'precio', nombre: '(D. Ventas,N. Ventas) Precio'},
    { id: 'totaldet', nombre: '(D. Ventas,N. Ventas, D. x pagar, N. x pagar) Total detalle'},
    { id: 'precio', nombre: '(D. x pagar,N. x pagar) Precio'},
    { id: 'totalLetra', nombre: '(L. Cobrar,L. Pagar) Total de letra'},
    { id: 'detalleSol', nombre: '(Liq. SA, Ing, Egr, Cargos, Abono) Total x Doc. detalle de solicitud giro'},
    { id: 'igv19', nombre: 'IGV19'},
  ]
  listaGlosa = [
    { id: 'ncheque', nombre: '(Car, Cob, Car, Pag) Nro. de cheque'},
    { id: 'tipoP', nombre: '(Car, Cob, Car, Pag, Cargos, Abonos) Tipo de pago'},
    { id: 'cuentaB', nombre: '(Car, Cob, Car, Pag, Cargos, Abonos) Cuenta de banco'},
    { id: 'totaldoc', nombre: '(Car, Cob, Car, Pag, Cargos, Abonos) Total de doc.'},
    { id: 'observaciones', nombre: '(Cargos y Abonos) Observaciones'},
    { id: 'formaP', nombre: '(D. Ventas, D. x pagar, N. x pagar) Forma de pago'},
    { id: 'puntoV', nombre: '(D. Ventas) Punto de venta'},
  ]

  // Arreglos para los selects

  tipos = [
    { id: 'administrativo', nombre: 'Administrativo' },
    { id: 'sucursal', nombre: 'Sucursal' },
    { id: 'operativo', nombre: 'Operativo' },
    { id: 'proyecto', nombre: 'Proyecto' }
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
    noRowsToShow: 'No hay datos para mostrar'
  }; 
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };
  
  // ── Facade injections ───────────────────────────────────────────────────
  private readonly tablasFacade = inject(TablasContabilidadFacade);
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  private readonly tablasFeedbackEffects = inject(TablasContabilidadFeedbackEffects);
  /** Reuses existing GESTION_ASIENTOS_MANUAL_PROVIDERS — segunda tabla (cuentas contables) */
  readonly cuentaFacade = inject(SeleccionarCuentaContableFacade);

  // ── Almacén local de ítems por código de documento ──────────────────────
  /** Mapa que almacena los ítems de la tabla derecha por cada código de documento seleccionado */
  private itemsPorCodigo = new Map<string, any[]>();

  // ── Signals ─────────────────────────────────────────────────────────────
  /** Reglas de cuenta contable del documento seleccionado (tabla derecha / main grid) */
  rowData = signal<any[]>([]);

  /** Árbol de tipos de documento contable (panel lateral izquierdo) — poblado desde tablas-contabilidad.json */
  rowDataFiltro = signal<TablaContabilidadItem[]>([]);

  readonly isLoading = computed(() => this.tablasFacade.isLoading());

  /** Sincroniza rowDataFiltro desde el store cuando el facade carga datos del JSON */
  private readonly _syncRowDataFiltro = effect(() => {
    const items = this.tablasFacade.items();
    untracked(() => {
      if (items.length > 0) {
        this.rowDataFiltro.set(items);
        // Poblar el mapa de ítems desde el JSON
        items.forEach(item => {
          if (item.t_contabilidad_items && item.t_contabilidad_items.length > 0) {
            this.itemsPorCodigo.set(item.t_contabilidad_codigo, [...item.t_contabilidad_items]);
          }
        });
      }
    });
  });



  colDefs: ColDef[] = [
    { headerName: 'Ítem', valueGetter: 'node.rowIndex + 1', width: 30 },
    { field: 'cuentaC', headerName: 'Cuenta contable', width: 120, cellStyle:{ cursor: 'pointer'},},
    { field: 'tipo', headerName: 'Tipo', width: 80 },
    { field: 'formula', headerName: 'Fórmula', width: 150, editable: true, cellEditor: AutocompleteCellrendererComponent,
      cellEditorParams: {
        items: this.listaformulas,
        displayKey: 'nombre',
        valueKey: 'id',
        placeholder: 'Buscar Formula...',
      }, cellStyle:{ cursor: 'pointer'},
      valueFormatter: (params) => {
        const item = this.listaformulas.find(f => f.id === params.value);
        return item ? item.nombre : params.value;
      }
     },
    { field: 'glosaCampo', headerName: 'Glosa campo', width: 150, editable: true, cellEditor: AutocompleteCellrendererComponent,
      cellEditorParams: {
        items: this.listaGlosa,
        displayKey: 'nombre',
        valueKey: 'id',
        placeholder: 'Buscar Glosa...',
      }, cellStyle:{ cursor: 'pointer'},
      valueFormatter: (params) => {
        const item = this.listaformulas.find(f => f.id === params.value);
        return item ? item.nombre : params.value;
      } },
    { field: 'glosaT', headerName: 'Glosa texto', width: 150, editable: true },
    { field: 'documentoR', headerName: 'Documento de referencia', editable: true, cellEditor: 'agSelectCellEditor',  width: 150, 
      cellEditorParams: {
      values: [ 'Doc. origen', 'Doc. referencia' ],
      }, cellStyle:{ cursor: 'pointer'},
    },
    { field: 'replicacion', headerName: 'Replicación', width: 120,},
    { headerName: 'Acciones', width: 80, headerClass: 'centrarencabezado', cellRenderer: BotonAccionesComponent,
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' }  }
  ];

  colDefsFiltro: ColDef<TablaContabilidadItem>[] = [
    // {field: 't_contabilidad_codigo', headerName: 'Código', width: 90 },
    {field: 't_contabilidad_descripcion', headerName: 'Descripción', flex: 1 },
    {field: 't_contabilidad_estado', headerName: 'Estado', headerClass: 'centrarencabezado', width: 80, cellEditor: 'agSelectCellEditor',
      editable: (params) => {
        const field = params.colDef.field!;
        const value = (params.data as any)?.[field];

        return value !== null && value !== undefined && value !== '';
      },
      cellEditorParams: {
      values: [ 'Activo', 'Inactivo' ],
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', cursor: 'pointer' }
     },
  ]; 


  columnTypes = {
      currency: {
        width: 150,
      },
      shaded: {
        cellClass: 'shaded-class'
      }
    };
    // Configuración para Tree Data
    treeData = true;
    groupDefaultExpanded = 0;
  
    getDataPath = (data: TablaContabilidadItem) => {
      return data.t_contabilidad_org_hierarchy || [];
    };
    autoGroupColumnDef: ColDef = {
      headerName: 'Código',
      flex: 1,
      cellRendererParams: {
        suppressCount: true,
      }
    };


  constructor(
    private modalController: ModalController,
    private toastService: ToastService,
  ) {}

  ngOnInit() {
    // Contexto de la grilla (si se usa en cellRenderers u otros)
    this.gridContext = { componentParent: this };

    // Carga el árbol de tipos de documento (tabla filtro / panel lateral)
    this.tablasFacade.cargarDatos();
    // Carga el catálogo de cuentas contables (segunda tabla — seleccionar-cuenta-contable.json)
    this.cuentaFacade.cargarDatos();
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  onBtReset() {
    if (this.gridApi) {
      this.gridApi.showLoadingOverlay();
      setTimeout(() => {
        this.gridApi.setGridOption('rowData', [...this.rowData()]);
        this.gridApi.hideOverlay();
      }, 300);
    }
  }

  onGridReadyFiltro(params: GridReadyEvent) {
  this.gridApiFiltros = params.api;
  
  setTimeout(() => {

    // EXPANDIR SOLO EL PRIMER GRUPO
    let firstGroupExpanded = false;

    this.gridApiFiltros.forEachNode(node => {
      if (node.group) {
        if (!firstGroupExpanded) {
          node.setExpanded(true);  
          firstGroupExpanded = true;
        } else {
          node.setExpanded(false);
        }
      }
    });
    if (this.gridApiFiltros && this.rowDataFiltro().length > 0) {
      const firstNode = this.gridApiFiltros.getRowNode('1');
      if (firstNode) {
        firstNode.setSelected(true);
        this.onCellFiltroClicked(firstNode);
      }
    }

  }, 100);
}


  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onCellClicked(event: any) {
    if (event.colDef.field == 'cuentaC') {
      this.filaCuentaSeleccionada = event.data;
      this.abrirModalCuentas( );
    }   
  }
  onCellFiltroClicked(event: any) {
    // Guardar ítems actuales antes de cambiar de selección
    if (this.filaSeleccionada?.t_contabilidad_codigo) {
      this.itemsPorCodigo.set(this.filaSeleccionada.t_contabilidad_codigo, [...this.rowData()]);
    }

    this.filaSeleccionada = event.data;

    // Cargar ítems del nodo seleccionado (o vacío si no tiene)
    const codigo = this.filaSeleccionada?.t_contabilidad_codigo;
    if (codigo) {
      const items = this.itemsPorCodigo.get(codigo) ?? [];
      this.rowData.set(items);
    } else {
      this.rowData.set([]);
    }
  }


  agregarItem() {
    if (!this.filaSeleccionada?.t_contabilidad_codigo) {
      this.toastService.warning('Seleccione un documento en el panel izquierdo');
      return;
    }
    const current = this.rowData();
    if (current.length === 0) {
      this.rowData.set([{ cuentaC: '', tipo: 'Debe', formula: '', glosaCampo: '', glosaT: '', documentoR: '' }]);
    } else {
      const ultimo         = current[current.length - 1];
      const siguienteTipo  = ultimo.tipo === 'Debe' ? 'Haber' : 'Debe';
      const nuevoItem      = { ...ultimo, tipo: siguienteTipo };
      this.rowData.update(rows => [...rows, nuevoItem]);
    }
    // Sincronizar con el mapa
    this.itemsPorCodigo.set(this.filaSeleccionada.t_contabilidad_codigo, [...this.rowData()]);
    this.onBtReset();
  }

  async abrirModalCuentas() {
      const modal = await this.modalController.create({
        component: ModalCuentasContablesComponent,
        cssClass: 'promo',
        componentProps: {},
      });
  
      await modal.present();
      const { data } = await modal.onWillDismiss();
  
      if (data?.ok) {
        // Actualizar la fila en el signal
        this.rowData.update(rows =>
          rows.map(row => row === this.filaCuentaSeleccionada
            ? { ...row, cuentaC: data.cuenta.codigo, descripcionCuenta: data.cuenta.descripcion }
            : row
          )
        );

        // Sincronizar con el mapa
        if (this.filaSeleccionada?.t_contabilidad_codigo) {
          this.itemsPorCodigo.set(this.filaSeleccionada.t_contabilidad_codigo, [...this.rowData()]);
        }
      }
      
      // Refrescar la grilla y deseleccionar
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData()]);
        this.gridApi.deselectAll();
      }

      this.filaCuentaSeleccionada = null;
    }

    eliminarArticulo(data: any) {
      this.rowData.update(rows => rows.filter(r => r !== data));
      this.gridApi.applyTransaction({ remove: [data] });
      // Sincronizar con el mapa
      if (this.filaSeleccionada?.t_contabilidad_codigo) {
        this.itemsPorCodigo.set(this.filaSeleccionada.t_contabilidad_codigo, [...this.rowData()]);
      }
      this.toastService.success('¡Acción realizada exitosamente!');
    }

    
}