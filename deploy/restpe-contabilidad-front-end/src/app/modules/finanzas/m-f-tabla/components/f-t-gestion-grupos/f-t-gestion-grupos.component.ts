import { Component, OnInit, OnDestroy, ViewChild, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef, KeyCreatorParams, ISetFilterParams } from 'ag-grid-community';
import { AccesorioActionsCellComponent } from 'src/app/modules/activos/m-af-tabla/pages/af-o-registroactivos/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { GestionGrupoFacade } from 'src/app/modules/finanzas/application/facades/gestion-grupo.facade';
import { GestionGrupoFeedbackEffects } from 'src/app/modules/finanzas/effects/gestion-grupo-feedback.effect';
import { GestionGrupoSyncEffects } from 'src/app/modules/finanzas/effects/gestion-grupo-sync.effect';
import { GestionGrupoEntity } from 'src/app/modules/finanzas/domain/models/gestion-grupo.entity';
import { ConceptoFinancieroFacade } from 'src/app/modules/finanzas/application/facades/concepto-financiero.facade';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-f-t-gestion-grupos',
  templateUrl: './f-t-gestion-grupos.component.html',
  styleUrls: ['./f-t-gestion-grupos.component.scss'],
  standalone: false,
})
export class FTGestionGruposComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // Facade + Effects
  readonly grupoFacade = inject(GestionGrupoFacade);
  private readonly _feedbackEffects = inject(GestionGrupoFeedbackEffects);
  private readonly _syncEffects = inject(GestionGrupoSyncEffects);
  readonly isLoading = this.grupoFacade.isLoading;
  readonly conceptoFinancieroFacade = inject(ConceptoFinancieroFacade);

  @ViewChild('autocompleteConceptos') autocompleteConceptos: any;
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  //RANGO DE FECHAS

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  fechaInicial: Date | undefined;

  gestionGruposForm!: FormGroup;
  private gridApi!: GridApi;
  private gridApiDetalle!: GridApi;
  cargando = false;
  estadoSeleccionado: string = 'todos';
  naturalezaSeleccionada: string = 'todos';
  tipoSeleccionado: string = 'registro';
  gridContext!: { componentParent: FTGestionGruposComponent };
  filaSeleccionada: any = null;
  archivo: any = null;
  botonguardar: string = 'Registrar grupo';
  disabledBotonNuevo: boolean = true;

  panelLateralVisible = true;
  gruposFiltrados: any[] = [];
  grupos: any[] = [];

  // Arreglos para los selects
  naturalezas = [
    { value: 'todos', nombre: 'Todas las naturalezas contables' },
    { value: 'debito', nombre: 'Débito' },
    { value: 'credito', nombre: 'Crédito' },
  ]

  estados = [
    { value: 'todos', nombre: 'Todos los estados' },
    { value: 'activos', nombre: 'Activos' },
    { value: 'inactivos', nombre: 'Inactivos' },
  ]

  tipoFs = [
    { value: 'registro', nombre: 'De registro' },
    { value: 'modif', nombre: 'De modificación' },
  ]

  nivelesSelect = [
    { id: '01', nombre: '01' },
    { id: '02', nombre: '02' },
    { id: '03', nombre: '03' },
  ];

  estadoSelect = [
    { id: 'activo', nombre: 'Activo' },
    { id: 'inactivo', nombre: 'Inactivo' }
  ];

  naturalezaSelect = [
    { id: 'debito', nombre: 'Débito' },
    { id: 'credito', nombre: 'Crédito' },
  ]

  tipoFSelect = [
    { id: 'ingreso', nombre: 'Ingreso' },
    { id: 'egreso', nombre: 'Egreso' },
  ]

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
  rowData: GestionGrupoEntity[] = [];
  /** Filas mostradas en la grilla (resultado del buscador en cliente). */
  rowDataFiltrada: GestionGrupoEntity[] = [];
  /** Texto del buscador (filtra por código, descripción o estado). */
  busqueda = '';


  conceptosDisponibles: any[] = [];

  rowDataDetalle: any[] = [];

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

  defaultColDef: ColDef = {
    editable: false,
  };
  getDataPath = (data: GestionGrupoEntity) => {
    return data.grupo_org_hierarchy || [];
  };
  autoGroupColumnDef: ColDef = {
    headerName: 'Código y descripción',
    flex: 1, minWidth: 250, filter: "agSetColumnFilter",
    filterParams: {
      treeList: true,
      keyCreator: (params: KeyCreatorParams) =>
        params.value ? params.value.join("#") : null,
    } as ISetFilterParams,
    cellRendererParams: {
      suppressCount: true,
    }
  };


  colDefs: ColDef<GestionGrupoEntity>[] = [
    { field: 'grupo_orden', headerName: 'Orden', width: 90, filter: true },
    // SOBRA: el backend no devuelve estos campos → columnas comentadas, no borradas.
    // { field: 'grupo_tipo_flujo', headerName: 'Tipo de flujo', width: 120, filter: true },
    // { field: 'grupo_naturaleza_contable', headerName: 'Naturaleza contable', width: 130, filter: true },
    // { field: 'grupo_conceptos', headerName: 'Conceptos asociados', width: 150 },
    { field: 'grupo_fecha_creacion', headerName: 'Fecha de creación', width: 100,
      valueFormatter: (params) => {
        // El backend ya envía "dd/MM/yyyy HH:mm:ss"; mostrar solo la parte de fecha.
        if (!params.value) { return ''; }
        return String(params.value).split(' ')[0];
      }

     },
    {
      field: 'grupo_estado', headerClass: 'centrarencabezado', headerName: 'Estado', width: 80, filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', },
      cellRenderer: (params: any) => {
        const color = params.value === 'Activo'
          ? 'bg-[#DCFDE7] text-[#16A34A]'
          : 'bg-[#FEE2E2] text-[#DC2626]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
    }
  ];


  colDefsDetalle: ColDef[] = [
    { field: 'codigo', headerName: 'Código', width: 80 },
    { field: 'descripcion', headerName: 'Descripcion', flex: 1, minWidth: 150 },
    { field: 'tipo', headerName: 'Tipo de movimiento', width: 120 },
    { field: 'categoria', headerName: 'Categoría', width: 90 },
    { field: 'naturalezaC', headerName: 'Naturaleza contable', width: 120 },
    { field: 'cuentaC', headerName: 'Cuenta contable', width: 120 },
    { field: 'origen', headerName: 'Origen', width: 80 },
    { field: 'destino', headerName: 'Destino', width: 80 },
    {
      field: 'estado', headerClass: 'centrarencabezado', headerName: 'Estado', width: 80,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', },
      cellRenderer: (params: any) => {
        const color = params.value === 'Activo'
          ? 'bg-[#DCFDE7] text-[#16A34A]'
          : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
    },
    {
      field: 'acciones', headerClass: 'centrarencabezado', headerName: 'Acciones', width: 100,
      cellRenderer: AccesorioActionsCellComponent,
      cellStyle: {
        textAlign: 'center',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    },
  ];

  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService,
  ) {
    effect(() => {
      this.rowData = this.grupoFacade.grupos();
      this.aplicarFiltro();
      // Mantener la lista de grupos para el autocomplete sincronizada
      this.grupos = this.rowData.map(g => ({ id: g.grupo_codigo, nombre: `${g.grupo_codigo} - ${g.grupo_descripcion}`, nivel: g.grupo_nivel }));
    });

    effect(() => {
      this.conceptosDisponibles = this.conceptoFinancieroFacade.conceptos().map(c => ({
        codigo: c.concepto_codigo,
        descripcion: c.concepto_nombre,
        tipo: c.concepto_tipo_movimiento,
        categoria: c.concepto_categoria,
        naturalezaC: c.concepto_naturaleza_contable,
        cuentaC: c.concepto_cuenta_contable,
        origen: c.concepto_origen,
        destino: c.concepto_destino,
        estado: c.concepto_estado,
      }));
    });

    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  private generateCodigo(): string {
    const nivelValue = this.gestionGruposForm.get('nivel')?.value;
    const grupoPadreValue = this.gestionGruposForm.get('grupoPadre')?.value;

    if (nivelValue === '01') {
      // Nivel 1: buscar el mayor código X.00 y generar el siguiente
      const nivel1Codes = this.rowData
        .filter(r => r.grupo_nivel === '01')
        .map(r => {
          const match = r.grupo_codigo.match(/^(\d+)\.00$/);
          return match ? parseInt(match[1], 10) : 0;
        })
        .filter(n => !isNaN(n));

      const maxCode = nivel1Codes.length > 0 ? Math.max(...nivel1Codes) : 0;
      return `${maxCode + 1}.00`;
    }

    if (nivelValue === '02' && grupoPadreValue) {
      // Nivel 2: buscar hijos del padre y generar siguiente (ej. padre 1.00 -> 1.01, 1.02...)
      const padreBase = grupoPadreValue.replace(/\.00$/, '');
      const nivel2Codes = this.rowData
        .filter(r => r.grupo_nivel === '02' && r.grupo_codigo.startsWith(padreBase + '.'))
        .map(r => {
          const match = r.grupo_codigo.match(/^[\d\.]+\.(\d+)$/);
          return match ? parseInt(match[1], 10) : 0;
        })
        .filter(n => !isNaN(n));

      const maxCode = nivel2Codes.length > 0 ? Math.max(...nivel2Codes) : 0;
      return `${padreBase}.${String(maxCode + 1).padStart(2, '0')}`;
    }

    if (nivelValue === '03' && grupoPadreValue) {
      // Nivel 3: buscar hijos del padre y generar siguiente (ej. padre 1.01 -> 1.01.01, 1.01.02...)
      const nivel3Codes = this.rowData
        .filter(r => r.grupo_nivel === '03' && r.grupo_codigo.startsWith(grupoPadreValue + '.'))
        .map(r => {
          const match = r.grupo_codigo.match(/\.(\d+)$/);
          return match ? parseInt(match[1], 10) : 0;
        })
        .filter(n => !isNaN(n));

      const maxCode = nivel3Codes.length > 0 ? Math.max(...nivel3Codes) : 0;
      return `${grupoPadreValue}.${String(maxCode + 1).padStart(2, '0')}`;
    }

    // Fallback
    return `AUTO-${Date.now().toString().slice(-6)}`;
  }

  ngOnInit() {
    this.grupoFacade.cargarGrupos();
    this.conceptoFinancieroFacade.cargarConceptos();

    // Inicializar formulario con valores por defecto para evitar errores al usarlo
    this.gestionGruposForm = this.formBuilder.group({
      // Backend (GrupoCodigoFlujoCajaRequest) exige: codigo + orden. nombre(=descripcion) opcional.
      codigo: ['', Validators.required],
      descripcion: ['', Validators.required],
      orden: [null, Validators.required],
      estado: ['activo'],
      fechaCreacion: [{ value: new Date().toISOString().split('T')[0], disabled: true }],
      // SOBRA: el backend (grupo_codigo_flujo_caja) NO modela estos campos. Se conservan los controles
      // (sin Validators.required) para no romper referencias; la UI queda comentada en el HTML.
      nivel: ['01'],
      grupoPadre: [''],
      tipoFlujo: [''],
      naturalezaFlujo: [''],
    });

    // Preparar lista de grupos a partir de los datos existentes
    // (se actualiza dinámicamente desde el effect del facade)
    this.grupos = this.rowData.map(g => ({ id: g.grupo_codigo, nombre: `${g.grupo_codigo} - ${g.grupo_descripcion}`, nivel: g.grupo_nivel }));

    // Cuando cambie el nivel seleccionado, actualizar los grupos disponibles para el autocomplete
    const nivelControl = this.gestionGruposForm.get('nivel');
    if (nivelControl) {
      nivelControl.valueChanges.subscribe((nivel: string) => {
        this.updateGruposFiltrados(nivel);
        // Resetear grupo padre al cambiar de nivel
        const padreControl = this.gestionGruposForm.get('grupoPadre');
        if (padreControl) { padreControl.setValue(''); }
      });
    }

    // Suscribirse a cambios del formulario para detectar modificaciones
    this.gestionGruposForm.valueChanges.subscribe(() => {
      this.verificarCambiosEnFormulario();
    });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.gestionGruposForm);

    // Contexto de la grilla (si se usa en cellRenderers u otros)
    this.gridContext = { componentParent: this };
  }

  /**
   * Actualiza `gruposFiltrados` en base al `nivel` seleccionado.
   * - Si el nivel es '01' (nivel 1) no hay grupo padre.
   * - Si el nivel es '02' (nivel 2) muestra sólo los grupos de nivel '01' (ej. 1.00, 2.00, ...).
   * - Si el nivel es '03' muestra sólo los grupos de nivel '02' (ej. 1.01, 1.02, 2.01, ...).
   */
  updateGruposFiltrados(nivelSeleccionado: string | null) {
    if (!nivelSeleccionado) {
      this.gruposFiltrados = [];
      return;
    }

    // si es nivel 01 no mostrar opciones (no tiene padre)
    if (nivelSeleccionado === '01') {
      this.gruposFiltrados = [];
      return;
    }

    // calcular nivel padre como string con dos dígitos: '01', '02', ...
    const nivelNum = parseInt(nivelSeleccionado, 10);
    const nivelPadreNum = nivelNum - 1;
    const nivelPadre = nivelPadreNum < 10 ? `0${nivelPadreNum}` : `${nivelPadreNum}`;

    // filtrar por propiedad `nivel` de los grupos preparados
    this.gruposFiltrados = this.grupos.filter(g => g.nivel === nivelPadre);
  }

  onGrupoSeleccionado(grupo: any) {
    console.log('Grupo seleccionado:', grupo);
  }

  onConceptoFinancieroSeleccionado(concepto: any) {
    // Verificar si ya está en la tabla
    const yaExiste = this.rowDataDetalle.find(c => c.codigo === concepto.codigo);
    if (yaExiste) {
      this.toastService.warning('El concepto ya está agregado al grupo');
      return;
    }

    // Agregar a la tabla
    this.rowDataDetalle = [...this.rowDataDetalle, concepto];

    if (this.gridApiDetalle) {
      this.gridApiDetalle.setGridOption('rowData', this.rowDataDetalle);
    }

    // Limpiar el autocomplete después de agregar
    setTimeout(() => {
      if (this.autocompleteConceptos) {
        this.autocompleteConceptos.clearSelection();
      }
    }, 100);
  }

  eliminarAccesorio(concepto: any) {
    if (!concepto || !concepto.codigo) {
      return;
    }

    // Buscar el índice del concepto a eliminar
    const index = this.rowDataDetalle.findIndex(c => c.codigo === concepto.codigo);
    
    if (index !== -1) {
      // Eliminar el concepto del array
      this.rowDataDetalle.splice(index, 1);
      
      // Actualizar la vista del grid
      if (this.gridApiDetalle) {
        this.gridApiDetalle.setGridOption('rowData', this.rowDataDetalle);
      }
      
      console.log('Concepto eliminado:', concepto);
    }
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.aplicarFiltro();
  }

  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApiDetalle = params.api;
  }

  async onCellClicked(event: any) {
    const data = event?.data;
    if (!data) { return; }

    // Prevenir selección automática (patrón Case 1B del servicio)
    event.node.setSelected(false);

    const elementoConFoco = document.activeElement as HTMLElement;
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Restaurar selección anterior
      if (this.filaSeleccionada) {
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
            if (node.data.grupo_codigo === this.filaSeleccionada.grupo_codigo) {
              node.setSelected(true);
            }
          });
          if (elementoConFoco && elementoConFoco.tagName === 'INPUT') {
            setTimeout(() => elementoConFoco.focus(), 100);
          }
        }, 0);
      } else {
        this.gridApi.deselectAll();
      }
      return;
    }

    this.cargarDatosFilaSeleccionada(data, event.node);
  }

  private cargarDatosFilaSeleccionada(data: any, node: any): void {
    this.botonguardar = 'Guardar grupo';
    console.log('Cell clicked', data);
    this.filaSeleccionada = data;
    this.gridApi.deselectAll();

    // Seleccionar el nodo en AG-Grid
    if (node) {
      node.setSelected(true);
    }
    // Determinar el grupo padre a partir de grupo_org_hierarchy (si existe)
    let grupoPadreValue = '';
    try {
      const hierarchy: string[] = data.grupo_org_hierarchy || [];
      // Si hay más de un elemento, el penúltimo es el padre
      if (hierarchy.length > 1) {
        const padreStr = hierarchy[hierarchy.length - 2];
        // Extraer solo el código (antes del primer espacio)
        grupoPadreValue = padreStr ? padreStr.split(' ')[0] : '';
      }
    } catch (e) {
      console.warn('Error al calcular grupoPadre desde grupo_org_hierarchy', e);
    }

    // Rellenar el formulario con los valores del registro seleccionado
    if (this.gestionGruposForm) {
      const nivelValue = data.grupo_nivel ?? this.gestionGruposForm.get('nivel')?.value;

      // Normalizar y mapear valores para que coincidan con los ids de los selects
      const normalize = (s: string) => (
        s ? s.normalize('NFD').replace(/\p{Diacritic}/gu, '').toLowerCase() : s
      );

      const mapTipo = (tipo: string) => {
        if (!tipo) { return '' }
        const t = normalize(tipo);
        if (t.includes('ingres')) return 'ingreso';
        if (t.includes('egres')) return 'egreso';
        if (t.includes('transfer')) return 'transferencia';
        return t;
      };

      const mapNaturaleza = (nat: string) => {
        if (!nat) { return '' }
        const n = normalize(nat);
        if (n.includes('deb')) return 'debito';
        if (n.includes('cre')) return 'credito';
        return n;
      };

      const mapEstado = (est: string) => {
        if (!est) { return this.gestionGruposForm.get('estado')?.value || ''; }
        const e = normalize(est);
        if (e.includes('activ')) return 'activo';
        if (e.includes('inactiv')) return 'inactivo';
        return e;
      };

      // Primero establecer el nivel para que el listener actualice gruposFiltrados
      this.gestionGruposForm.get('nivel')?.setValue(nivelValue, { emitEvent: true });
      // Forzar actualización de grupos filtrados (por si no se ha actualizado aún)
      this.updateGruposFiltrados(nivelValue);

      // Determinar valor para grupoPadre: buscar en gruposFiltrados por id
      const padreId = grupoPadreValue || '';
      const existePadre = this.gruposFiltrados.some(g => g.id === padreId);
      const grupoPadreFinal = existePadre ? padreId : padreId;

      // Ahora parchear el resto de campos
      this.gestionGruposForm.patchValue({
        codigo: data.grupo_codigo ?? '',
        descripcion: data.grupo_descripcion ?? '',
        orden: data.grupo_orden ?? null,
        estado: mapEstado(data.grupo_estado),
        // SOBRA: campos no soportados por el backend (controles conservados).
        grupoPadre: grupoPadreFinal || this.gestionGruposForm.get('grupoPadre')?.value,
        tipoFlujo: mapTipo(data.grupo_tipo_flujo) || this.gestionGruposForm.get('tipoFlujo')?.value,
        naturalezaFlujo: mapNaturaleza(data.grupo_naturaleza_contable) || this.gestionGruposForm.get('naturalezaFlujo')?.value,
      });
      
      // Establecer fechaCreacion por separado ya que está disabled.
      // El backend envía "dd/MM/yyyy HH:mm:ss" → convertir a "yyyy-MM-dd" para el input type="date".
      const fechaCtrl = this.gestionGruposForm.get('fechaCreacion');
      if (fechaCtrl) {
        fechaCtrl.setValue(this.toFechaInput(data.grupo_fecha_creacion) || new Date().toISOString().split('T')[0]);
      }

      // Resetear tracking tras cargar datos
      this.formValidationService.resetearEstado();
    }

    // Mostrar panel lateral para edición
    this.panelLateralVisible = true;
    
    // Cargar conceptos del grupo seleccionado
    this.rowDataDetalle = (data.grupo_detalle as any[]) || [];
    if (this.gridApiDetalle) {
      this.gridApiDetalle.setGridOption('rowData', this.rowDataDetalle);
    }

    // Actualizar estado del botón
    this.disabledBotonNuevo = false;
  }
  /** Normaliza una fecha del backend ("dd/MM/yyyy HH:mm:ss" o ISO) a "yyyy-MM-dd" para input type="date". */
  private toFechaInput(value: any): string {
    if (!value) { return ''; }
    const s = String(value).trim().split(' ')[0]; // quitar hora si viene
    if (s.includes('/')) {
      const [d, m, y] = s.split('/');
      if (d && m && y) { return `${y}-${m.padStart(2, '0')}-${d.padStart(2, '0')}`; }
    }
    return s.length >= 10 ? s.slice(0, 10) : s; // ya viene en ISO
  }

  /** Buscador: filtra por código, descripción o estado (en cliente). */
  onBuscar(): void {
    this.aplicarFiltro();
  }

  /** Aplica el filtro de `busqueda` sobre `rowData` y actualiza la grilla. */
  private aplicarFiltro(): void {
    const t = (this.busqueda ?? '').trim().toLowerCase();
    this.rowDataFiltrada = !t
      ? [...this.rowData]
      : this.rowData.filter((g) =>
          `${g.grupo_codigo ?? ''} ${g.grupo_descripcion ?? ''} ${g.grupo_estado ?? ''}`
            .toLowerCase()
            .includes(t)
        );
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowDataFiltrada);
    }
  }

  /** Exporta la grilla de grupos a Excel (.xlsx). */
  exportarExcel(): void {
    this.gridApi?.exportDataAsExcel({ fileName: 'grupos-flujo-caja.xlsx', sheetName: 'Grupos flujo caja' });
  }

  onBtReset(): void {
    this.grupoFacade.cargarGrupos();
  }

  async botonNuevoGrupo() {
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) { return; }

    this.gridApi.deselectAll();
    this.botonguardar = 'Registrar grupo';
    if (this.gestionGruposForm) {
      this.gestionGruposForm.reset({
        estado: 'activo',
        nivel: '01',
        fechaCreacion: new Date().toISOString().split('T')[0]
      });
      this.filaSeleccionada = null;
      this.rowDataDetalle = [];
      if (this.gridApiDetalle) {
        this.gridApiDetalle.setGridOption('rowData', []);
      }
      this.formValidationService.resetearEstado();
      this.disabledBotonNuevo = true;
    }
  }

  botonGuardar() {
    if (!this.gestionGruposForm) {
      this.toastService.danger('Formulario no inicializado');
      return;
    }

    // El código ahora lo ingresa el usuario (backend lo exige y debe ser único).
    const codigoCtrl = this.gestionGruposForm.get('codigo');

    // Validar campos requeridos por el backend: código, descripción (=nombre), orden y estado.
    const camposIncompletos: string[] = [];
    const codigo = codigoCtrl;
    const descripcion = this.gestionGruposForm.get('descripcion');
    const orden = this.gestionGruposForm.get('orden');
    const estado = this.gestionGruposForm.get('estado');

    if (!codigo || !codigo.value) { camposIncompletos.push('Código del grupo'); }
    if (!descripcion || !descripcion.value) { camposIncompletos.push('Descripción'); }
    if (orden == null || orden.value == null || orden.value === '') { camposIncompletos.push('Orden'); }
    if (!estado || !estado.value) { camposIncompletos.push('Estado'); }
    // SOBRA: el backend no modela nivel/grupo padre/tipo de flujo/naturaleza → validación comentada.
    // const nivel = this.gestionGruposForm.get('nivel');
    // const grupoPadre = this.gestionGruposForm.get('grupoPadre');
    // const tipoFlujo = this.gestionGruposForm.get('tipoFlujo');
    // const naturalezaFlujo = this.gestionGruposForm.get('naturalezaFlujo');

    if (camposIncompletos.length > 0) {
      this.toastService.danger(`Campos faltantes: ${camposIncompletos.join(', ')}`);
      return;
    }

    const v = this.gestionGruposForm.getRawValue();

    const displayEstado = (e: string) => e === 'activo' ? 'Activo' : e === 'inactivo' ? 'Inactivo' : (e || 'Activo');

    // SOBRA: helpers para campos no soportados por el backend (se conservan comentados).
    // const displayTipo = (t: string) => t === 'ingreso' ? 'Ingreso' : t === 'egreso' ? 'Egreso' : t;
    // const displayNaturaleza = (n: string) => n === 'debito' ? 'Débito' : n === 'credito' ? 'Crédito' : n;
    // const makeHierarchy = (): string[] => {
    //   if (!v.codigo) { return []; }
    //   if (v.nivel === '01') { return [`${v.codigo} - ${v.descripcion}`]; }
    //   const padreId = v.grupoPadre;
    //   const padre = this.grupos.find((g: any) => g.id === padreId);
    //   const padreNombre = padre ? padre.nombre : (padreId ?? '');
    //   return [padreNombre, `${v.codigo} - ${v.descripcion}`].filter(Boolean);
    // };

    const payload: Partial<GestionGrupoEntity> = {
      grupo_id: this.filaSeleccionada?.grupo_id,
      grupo_codigo: v.codigo,
      grupo_descripcion: v.descripcion,
      grupo_orden: v.orden != null && v.orden !== '' ? Number(v.orden) : undefined,
      grupo_estado: displayEstado(v.estado),
      grupo_fecha_creacion: v.fechaCreacion ?? '',
      // SOBRA: el backend no guarda estos campos (se mantienen en el modelo, no se envían).
      // grupo_tipo_flujo: displayTipo(v.tipoFlujo),
      // grupo_naturaleza_contable: displayNaturaleza(v.naturalezaFlujo),
      // grupo_conceptos: '',
      // grupo_nivel: v.nivel,
      // grupo_org_hierarchy: makeHierarchy(),
    };

    if (this.filaSeleccionada && this.filaSeleccionada.grupo_codigo) {
      this.grupoFacade.actualizarGrupo(this.filaSeleccionada.grupo_codigo, payload);
    } else {
      this.grupoFacade.guardarGrupo(payload);
    }

    // Limpiar formulario después de guardar
    this.gridApi.deselectAll();
    this.botonguardar = 'Registrar grupo';
    this.gestionGruposForm.reset({
      estado: 'activo',
      nivel: '01',
      fechaCreacion: new Date().toISOString().split('T')[0]
    });
    this.filaSeleccionada = null;
    this.rowDataDetalle = [];
    if (this.gridApiDetalle) {
      this.gridApiDetalle.setGridOption('rowData', []);
    }
    this.formValidationService.resetearEstado();
    this.disabledBotonNuevo = true;
  }
  onTipoSeleccionado(tipo: any) {
    console.log('Tipo seleccionado:', tipo);
  }

  async modalImportar() {
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar centros de costos',
        descripcionSubir: 'Comparte tu archivo de excel con la información de tus centros de costos y regístralos automáticamente en la plataforma.',
        buttonName: 'Importar centros de costos',
      }
    });
    await modal.present();

    try {
      const result = await modal.onWillDismiss();
      const data = result?.data;
      if (data && data.archivo) {
        // Guardar archivo en el componente padre
        this.archivo = data.archivo;
        // Mostrar toast indicando que el archivo fue subido
        try {
          const nombre = data.archivo?.name ?? 'archivo';
          this.toastService.success('Archivo subido', nombre, 3000);
        } catch (e) {
          console.warn('ToastService falló', e);
        }
        // Llamar al método importar para procesar el archivo
        try { this.importar(data); } catch (e) {
          this.toastService.danger('Importacion fallida');
        }
      }
    } catch (e) {
      console.warn('Error al obtener resultado del modal', e);
      this.toastService.danger('Error al obtener resultado del modal');
    }
  }

  importar(data: any) {
    // Placeholder: aquí se procesaría el archivo (validaciones, parseo, subida, etc.)
    console.log('Importar llamado con:', data);
    // Por ahora solo guardamos el archivo en el estado (ya lo hacemos en modalImportar),
    // y se puede mostrar un toast adicional si se desea.
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

  async modalverActualizaciones() {
    // Definir las columnas
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 150, },
      { headerName: 'Usuario', field: 'usuario', width: 120, },
      {
        headerName: 'Acción', field: 'accion', width: 150,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
      {
        headerName: 'Detalle del cambio', field: 'detalleCambio', flex: 1,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
    ];

    // Datos de ejemplo
    const rowData = [
      { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Se ha creado el grupo 1.00' },
      { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se edito la descripción del grupo' },
      { fechaHora: '13/11/2025 09:00', usuario: 'Carlos Rodríguez', accion: 'Actualización', detalleCambio: 'Se cambió el tipo de flujo' },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones del grupo 1.00',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

  onFechaSeleccionada(date: Date) {
    // Actualizar el formulario con la fecha (en caso de que se seleccione algo)
    // Aunque fechaCreacion esté deshabilitado, actualizamos por si acaso
    console.log('Fecha seleccionada:', date);
    if (this.gestionGruposForm && date) {
      const fechaCtrl = this.gestionGruposForm.get('fechaCreacion');
      if (fechaCtrl) {
        fechaCtrl.setValue(date);
      }
    }
  }

  /**
   * Verifica si hay cambios reales en el formulario (excluyendo valores por defecto)
   * y actualiza el estado del botón "Nuevo grupo"
   */
  private verificarCambiosEnFormulario(): void {
    if (!this.gestionGruposForm) {
      this.disabledBotonNuevo = true;
      return;
    }

    const nivel = this.gestionGruposForm.get('nivel')?.value;
    const grupoPadre = this.gestionGruposForm.get('grupoPadre')?.value;
    const descripcion = this.gestionGruposForm.get('descripcion')?.value;
    const tipoFlujo = this.gestionGruposForm.get('tipoFlujo')?.value;
    const naturalezaFlujo = this.gestionGruposForm.get('naturalezaFlujo')?.value;

    // Verificar si algún campo ha sido modificado respecto al valor por defecto
    const hayDatosIngresados = 
      (nivel && nivel !== '01') ||
      (grupoPadre && grupoPadre.trim() !== '') ||
      (descripcion && descripcion.trim() !== '') ||
      (tipoFlujo && tipoFlujo.trim() !== '') ||
      (naturalezaFlujo && naturalezaFlujo.trim() !== '');

    // Habilitar botón si hay una fila seleccionada o si hay datos ingresados
    this.disabledBotonNuevo = !this.filaSeleccionada && !hayDatosIngresados;
  }

  /**
   * Verifica si todos los campos requeridos del formulario están completos
   */
  get formularioCompleto(): boolean {
    if (!this.gestionGruposForm) {
      return false;
    }

    // Campos requeridos por el backend (grupo_codigo_flujo_caja): código, descripción, orden, estado.
    const codigo = this.gestionGruposForm.get('codigo');
    const descripcion = this.gestionGruposForm.get('descripcion');
    const orden = this.gestionGruposForm.get('orden');
    const estado = this.gestionGruposForm.get('estado');

    const codigoValido = codigo && codigo.value && String(codigo.value).trim() !== '';
    const descripcionValida = descripcion && descripcion.value && String(descripcion.value).trim() !== '';
    const ordenValido = orden && orden.value != null && String(orden.value) !== '';
    const estadoValido = estado && estado.value;

    return !!(codigoValido && descripcionValida && ordenValido && estadoValido);
  }

  async canDeactivate(): Promise<boolean> {
    return true;
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }
}


