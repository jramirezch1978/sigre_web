import { Component, OnInit, inject, effect } from '@angular/core';
import {
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from '@angular/forms';
import {
  ColDef,
  GridApi,
  GridReadyEvent,
} from 'ag-grid-community';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { IconCellComponent } from './components/icon-cell/icon-cell.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalController } from '@ionic/angular';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ClasifActivoFacade } from 'src/app/modules/activos/application/facades/clasif-activo.facade';
import { ClasifActivoFeedbackEffects } from 'src/app/modules/activos/effects/clasif-activo-feedback.effect';
import { ClasifActivoEntity } from 'src/app/modules/activos/domain/models/clasif-activo.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import {  faAngleDown, faCirclePlus, faDownload, faRotateRight , faFolderOpen } from '@fortawesome/pro-solid-svg-icons';

// Font Awesome Icons
interface IClasesActivo {
  id: number;
  nombre: string;
}

@Component({
  selector: 'app-activofijo-tabla-clasifactivos',
  templateUrl: './activofijo-tabla-clasifactivos.component.html',
  styleUrls: ['./activofijo-tabla-clasifactivos.component.scss'],
  standalone: false,
})
export class ActivofijoTablaClasifactivosComponent implements OnInit, CanComponentDeactivate {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  gridApi!: GridApi;
  camponuevo: boolean = true;
  estadoSeleccionado: string = 'todos';
  ActivosForm!: FormGroup;
  filaSeleccionada: ClasifActivoEntity | null = null;
  Subclase = false;

  // ─── Facade & signals ───
  private readonly clasifActivoFacade   = inject(ClasifActivoFacade);
  private readonly feedbackEffects      = inject(ClasifActivoFeedbackEffects);
  readonly isLoading = this.clasifActivoFacade.isLoading;

  // Variables para tracking de cambios del formulario
  private formularioInicial: any = null;
  private formularioModificado: boolean = false;

  // Lista de cuentas contables para el autocomplete
  cuentasContables : any[] = [
    // { codigo: '150100000000', descripcion: 'Caja y Bancos' },
    // { codigo: '150101000000', descripcion: 'Caja Principal' },
    // { codigo: '150102000000', descripcion: 'Caja Chica' },
    // { codigo: '150200000000', descripcion: 'Cuentas por Cobrar' },
    // { codigo: '150201000000', descripcion: 'Clientes Nacionales' },
    // { codigo: '150202000000', descripcion: 'Clientes del Exterior' },
    // ... puedes agregar más cuentas según tu catálogo
  ];

  // Maneja la selección de una cuenta contable desde el autocomplete
  onCuentaSelected(event: any) {
    if (event && event.codigo) {
      // Si es clase
      if (!this.Subclase) {
        this.ActivosForm.patchValue({ cntContable: event.codigo });
      } else {
        // Si es subclase
        this.ActivosForm.patchValue({ cntContable: event.codigo });
      }
    }
  }

  clasesActivo: any[] = [];

  columnTypes = {
    currency: {
      width: 150,
    },
    shaded: {
      cellClass: 'shaded-class',
    },
  };
  // Configuración para Tree Data
  treeData = true;
  groupDefaultExpanded = 0;

  defaultColDef: ColDef = {
    editable: true,
  };
  getDataPath = (data: ClasifActivoEntity) => {
    return data.orgHierarchy || [];
  };
  autoGroupColumnDef: ColDef = {
    headerName: 'Código',
    width: 150, editable: false,
    cellRendererParams: {
      suppressCount: true,
      innerRenderer: IconCellComponent,
    },
  };
  rowData: ClasifActivoEntity[] = [];

  //  Tipado con la misma entidad
  colDefs: ColDef<ClasifActivoEntity>[] = [
    { field: 'clasif_activo_nombre', headerName: 'Clase de activo', headerClass: 'ag-header-hover ag-header-10px', width: 150, editable: false},
    { field: 'clasif_activo_cnt_contable', headerName: 'Cuenta Contable', headerClass: 'ag-header-hover ag-header-10px', width: 120, editable: false},
    { field: 'clasif_activo_met_depreciacion', headerName: 'Metodo depreciación', headerClass: 'ag-header-hover ag-header-10px', width: 150, editable: false},
    { field: 'clasif_activo_tsa_anual', headerName: 'Tasa Anual', headerClass: 'ag-header-hover ag-header-10px', width: 75, editable: false},
    { field: 'clasif_activo_vida_util', headerName: 'Vida Útil', headerClass: 'ag-header-hover ag-header-10px', width: 67, editable: false},
    { field: 'clasif_activo_estado', filter: true, headerClass: 'centrarencabezado', headerName: 'Estado',
      width: 80,
      cellRenderer: (params: any) => {
        const color =
          params.value === 'Activo'
            ? 'bg-[#DCFDE7] text-[#16A34A]'
            : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
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
    private toastservice: ToastService,
    private modalController: ModalController,
    private formValidationService: FormValidationService,
  ) {
    effect(() => {
      const items = this.clasifActivoFacade.clasifsActivo();
      this.rowData = items;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
      this.actualizarClasesParaAutocomplete();
    });
  }

  ngOnInit() {
    this.ActivosForm = this.formBuilder.group({
      search: new FormControl(''),
      filtroEstado: new FormControl('todos'),
      codigo: new FormControl('', [Validators.required]),
      nombre: new FormControl('', [Validators.required]),
      cntContable: new FormControl('', [Validators.required]),
      metDepreciacion: new FormControl('', [Validators.required]),
      descripcion: new FormControl(''),
      tsaAnual: new FormControl('', [Validators.required]),
      vidaUtil: new FormControl('', [Validators.required]),
      estado: new FormControl('Activo', [Validators.required]),
      observaciones: new FormControl(''),
      codigoSub: new FormControl('', [Validators.required]),
      nombreSub: new FormControl('', [Validators.required]),
      descripcionSub: new FormControl(''),
      depreciacionPorc: new FormControl(''),
      vidaUtilEspc: new FormControl(''),
      estadoSub: new FormControl('Activo', [Validators.required]),
      observacionesSub: new FormControl(''),
    });

    // Cargar datos vía facade (JSON + localStorage)
    this.cargarClasesDesdeSimulacion();
    this.cargarCuentasContables();
    // Suscribirse a cambios del formulario para detectar modificaciones
    this.ActivosForm.valueChanges.subscribe(() => {
      this.verificarCambios();
    });

    // Guardar estado inicial del formulario
    this.formularioInicial = this.ActivosForm.value;
  }
  cargarCuentasContables() {
    // Leer directamente desde localStorage para obtener los datos más recientes
    const datosGuardados = localStorage.getItem('plancontable');
    let cuentasLS: any[] = [];
    
    if (datosGuardados) {
      try {
        cuentasLS = JSON.parse(datosGuardados);
      } catch (e) {
        console.error('Error al parsear cuentas contables:', e);
        cuentasLS = [];
      }
    }
    
    console.log(' Cuentas contables cargadas:', cuentasLS.length);
    
    // Mapear cuentas con el formato necesario para el autocomplete
    this.cuentasContables = cuentasLS.map((item: any) => ({
      id: item.codigo,
      codigo: item.codigo,
      descripcion: item.descripcion,
      nombre: `${item.codigo} - ${item.descripcion}`,
      naturaleza: item.naturaleza,
      tipo: item.tipo,
      nivel: item.nivel,
      estado: item.estado,
      ...item
    }));
    
    console.log(' Cuentas contables cargadas para clasificación de activos:', this.cuentasContables.length);
  }
  // Método para verificar si el formulario ha sido modificado
  private verificarCambios(): void {
    if (!this.formularioInicial) {
      this.formularioModificado = false;
      return;
    }
    const valorActual = this.ActivosForm.value;
    this.formularioModificado = JSON.stringify(this.formularioInicial) !== JSON.stringify(valorActual);
  }

  // Método para mostrar modal de confirmación
  private async mostrarModalConfirmacion(): Promise<boolean> {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Continuar sin guardar',
        title: '¿Seguro que quieres continuar sin guardar la información?',
        message: 'Si sales ahora, perderás la información ingresada',
        btnOkTxt: 'Continuar',
        btnCancelTxt: 'Cancelar',
      }
    });

    await modal.present();
    const { data } = await modal.onWillDismiss();
    return data === true;
  }

  // Implementación del guard CanDeactivate
  async canDeactivate(): Promise<boolean> {
    if (this.formularioModificado) {
      return await this.mostrarModalConfirmacion();
    }
    return true;
  }

  localeText = {
    page: 'Página',
    of: 'de',
    to: 'a',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    noRowsToShow: 'No hay filas para mostrar',
    loadingOoo: 'Cargando...',
  };

  onClasesActivoSeleccionado(clasesActivo: any) {
    console.log('Destino seleccionado:', clasesActivo);
  }

  async onCellClicked(event: any) {
    const data = event.data;
    
    // Prevenir selección automática de AG-Grid
    event.node.setSelected(true);

    // Validar si hay cambios sin guardar
    if (this.formularioModificado) {
      const confirmar = await this.mostrarModalConfirmacion();
      
      if (!confirmar) {
        // Mantener selección anterior
        if (this.filaSeleccionada) {
          setTimeout(() => {
            this.gridApi.deselectAll();
            this.gridApi.forEachNode((node) => {
              if (node.data.clasif_activo_codigo === this.filaSeleccionada!.clasif_activo_codigo) {
                node.setSelected(true);
              }
            });
          }, 0);
        } else {
          this.gridApi.deselectAll();
        }
        return;
      }
    }

    // Cargar datos del registro seleccionado
    this.cargarDatosRegistro(data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: ClasifActivoEntity, node?: any): void {
    this.camponuevo = false;
    this.filaSeleccionada = data;
    this.gridApi.deselectAll();

    // Seleccionar el nodo en AG-Grid
    if (node) {
      node.setSelected(true);
    } else {
      this.gridApi.forEachNode((n) => {
        if (n.data === data) {
          n.setSelected(true);
        }
      });
    }

    // Extraer años de clasif_activo_vida_util (ejemplo: "20 años" -> "20")
    let vidaUtilAnios = '';
    if (data.clasif_activo_vida_util && data.clasif_activo_vida_util !== 'Hereda') {
      const match = data.clasif_activo_vida_util.match(/\d+/);
      vidaUtilAnios = match ? match[0] : '';
    }

    // Extraer porcentaje de clasif_activo_tsa_anual (ejemplo: "5%" -> "5")
    let tsaAnualValor = '';
    if (data.clasif_activo_tsa_anual && data.clasif_activo_tsa_anual !== 'Hereda') {
      const match = data.clasif_activo_tsa_anual.match(/\d+/);
      tsaAnualValor = match ? match[0] : '';
    }

    // Determinar si es clase o subclase según orgHierarchy
    const esSubclase = data.orgHierarchy && data.orgHierarchy.length > 1;

    if (esSubclase) {
      // Es una subclase - activar modo subclase
      this.Subclase = true;
      const codigoClasePadre = data.orgHierarchy![0];

      // Llenar los campos del formulario para subclase
      this.ActivosForm.patchValue({
        codigo: codigoClasePadre,
        codigoSub: data.clasif_activo_codigo || '',
        cntContable: data.clasif_activo_cnt_contable || '',
        nombreSub: data.clasif_activo_nombre || '',
        descripcionSub: data.clasif_activo_descripcion || '',
        depreciacionPorc: tsaAnualValor,
        vidaUtilEspc: vidaUtilAnios,
        estadoSub: data.clasif_activo_estado || '',
        observacionesSub: data.clasif_activo_observaciones || '',
      });
    } else {
      // Es una clase - activar modo clase
      this.Subclase = false;

      // Llenar los campos del formulario para clase
      this.ActivosForm.patchValue({
        codigo: data.clasif_activo_codigo || '',
        nombre: data.clasif_activo_nombre || '',
        cntContable: data.clasif_activo_cnt_contable || '',
        metDepreciacion: data.clasif_activo_met_depreciacion || '',
        descripcion: data.clasif_activo_descripcion || '',
        tsaAnual: tsaAnualValor,
        vidaUtil: vidaUtilAnios,
        estado: data.clasif_activo_estado || '',
        observaciones: data.clasif_activo_observaciones || '',
      });
    }

    // Guardar nuevo estado inicial del formulario
    this.formularioInicial = this.ActivosForm.value;
    this.formularioModificado = false;
  }
  async botonNuevaClase() {
    // Validar cambios antes de limpiar
    if (this.formularioModificado) {
      const confirmar = await this.mostrarModalConfirmacion();
      
      if (!confirmar) {
        return; // Cancelar acción
      }
    }

    this.Subclase = false;
    this.camponuevo = true;
    this.filaSeleccionada = null; // Limpiar la fila seleccionada
    this.gridApi?.deselectAll(); // Deseleccionar filas en la tabla
    this.ActivosForm.reset();
    this.ActivosForm.patchValue({
      estado: 'Activo',
    });

    // Actualizar estado inicial del formulario
    this.formularioInicial = this.ActivosForm.value;
    this.formularioModificado = false;
  }
  async botonNuevaSubclase() {
    // Validar cambios antes de limpiar
    if (this.formularioModificado) {
      const confirmar = await this.mostrarModalConfirmacion();
      
      if (!confirmar) {
        return; // Cancelar acción
      }
    }

    this.Subclase = true;
    this.camponuevo = true;
    this.filaSeleccionada = null; // Limpiar la fila seleccionada
    this.gridApi?.deselectAll(); // Deseleccionar filas en la tabla
    this.ActivosForm.reset();
    this.ActivosForm.patchValue({
      estadoSub: 'Activo',
    });

    // Actualizar estado inicial del formulario
    this.formularioInicial = this.ActivosForm.value;
    this.formularioModificado = false;
  }
  botonGuardar() {
    const formValues = this.ActivosForm.value;

    // VALIDACIÓN DE CAMPOS REQUERIDOS
    if (this.Subclase) {
      if (!formValues.codigo?.trim() ||
          !formValues.codigoSub?.trim() ||
          !formValues.nombreSub?.trim() ||
          !formValues.descripcionSub?.trim() ||
          !formValues.depreciacionPorc?.toString().trim() ||
          !formValues.vidaUtilEspc?.toString().trim() ||
          !formValues.estadoSub?.trim()) {
        this.toastservice.warning('Por favor, completa todos los campos requeridos');
        return;
      }
    } else {
      if (!formValues.nombre?.trim() ||
          !formValues.descripcion?.trim() ||
          !formValues.metDepreciacion?.trim() ||
          !formValues.tsaAnual?.toString().trim() ||
          !formValues.vidaUtil?.toString().trim() ||
          !formValues.estado?.trim()) {
        this.toastservice.warning('Por favor, completa todos los campos requeridos');
        return;
      }
    }

    let claseData: ClasifActivoEntity;

    if (this.Subclase) {
      const codigoSubclase = this.camponuevo
        ? this.generarNuevoCodigoSubclase(formValues.codigo)
        : formValues.codigoSub;
      const orgHierarchy = [formValues.codigo, codigoSubclase];
      claseData = {
        clasif_activo_codigo:           codigoSubclase,
        clasif_activo_nombre:           formValues.nombreSub,
        clasif_activo_cnt_contable:     formValues.cntContable || '',
        clasif_activo_met_depreciacion: '-',
        clasif_activo_tsa_anual:        formValues.depreciacionPorc ? formValues.depreciacionPorc + '%' : 'Hereda',
        clasif_activo_vida_util:        formValues.vidaUtilEspc ? formValues.vidaUtilEspc + ' años' : 'Hereda',
        clasif_activo_descripcion:      formValues.descripcionSub || '',
        clasif_activo_observaciones:    formValues.observacionesSub || '',
        clasif_activo_estado:           formValues.estadoSub,
        orgHierarchy,
      };
    } else {
      const codigoClase = this.camponuevo
        ? this.generarNuevoCodigoClase()
        : formValues.codigo;
      claseData = {
        clasif_activo_codigo:           codigoClase,
        clasif_activo_nombre:           formValues.nombre,
        clasif_activo_cnt_contable:     formValues.cntContable,
        clasif_activo_met_depreciacion: formValues.metDepreciacion,
        clasif_activo_tsa_anual:        formValues.tsaAnual + '%',
        clasif_activo_vida_util:        formValues.vidaUtil + ' años',
        clasif_activo_descripcion:      formValues.descripcion || '',
        clasif_activo_observaciones:    formValues.observaciones || '',
        clasif_activo_estado:           formValues.estado,
        orgHierarchy:                   [codigoClase],
      };
    }

    if (this.camponuevo) {
      this.clasifActivoFacade.guardarClasifActivo(claseData);
    } else if (this.filaSeleccionada) {
      this.clasifActivoFacade.actualizarClasifActivo(claseData);
    }

    // Limpiar formulario y resetear estado
    this.ActivosForm.reset();
    this.ActivosForm.patchValue({ estado: 'Activo', estadoSub: 'Activo' });
    this.filaSeleccionada = null;
    this.camponuevo = true;

    this.formularioInicial = this.ActivosForm.value;
    this.formularioModificado = false;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  // Generar código automático para nuevas clases
  generarNuevoCodigoClase(): string {
    const clases = this.rowData.filter(item => item.orgHierarchy && item.orgHierarchy.length === 1);
    const numeros = clases.map(item => {
      const match = item.clasif_activo_codigo.match(/CL(\d+)/);
      return match ? parseInt(match[1], 10) : 0;
    });
    const maxNumero = Math.max(...numeros, 0);
    const nuevoNumero = (maxNumero + 1).toString().padStart(3, '0');
    return `CL${nuevoNumero}`;
  }

  // Generar código automático para nuevas subclases
  generarNuevoCodigoSubclase(codigoClase: string): string {
    const subclases = this.rowData.filter(item =>
      item.orgHierarchy &&
      item.orgHierarchy.length === 2 &&
      item.orgHierarchy[0] === codigoClase
    );
    const numeros = subclases.map(item => {
      const match = item.clasif_activo_codigo.match(/SCL(\d+)/);
      return match ? parseInt(match[1], 10) : 0;
    });
    const maxNumero = Math.max(...numeros, 0);
    const nuevoNumero = (maxNumero + 1).toString().padStart(3, '0');
    return `SCL${nuevoNumero}`;
  }

  onClaseSeleccionada(clase: any) {
    console.log('Clase seleccionada:', clase);
    // Aquí puedes realizar acciones adicionales cuando se selecciona una clase
  }

  puedeGuardar(): boolean {
    const formValues = this.ActivosForm.value;

    if (this.Subclase) {
      // Validar campos obligatorios de subclase
      const camposSubclaseCompletos = 
        formValues.codigo &&
        formValues.codigoSub &&
        formValues.cntContable &&
        formValues.nombreSub &&
        formValues.descripcionSub &&
        formValues.depreciacionPorc &&
        formValues.vidaUtilEspc &&
        formValues.estadoSub;
      
      // Si es modo nuevo, solo validar campos completos
      if (this.camponuevo) {
        return !!camposSubclaseCompletos;
      }
      // Si es modo edición, solo habilitar cuando hay cambios
      return this.formularioModificado;
    } else {
      // Validar campos obligatorios de clase
      const camposClaseCompletos = 
        formValues.cntContable &&
        formValues.nombre &&
        formValues.descripcion &&
        formValues.metDepreciacion &&
        formValues.tsaAnual &&
        formValues.vidaUtil &&
        formValues.estado;
      
      // Si es modo nuevo, solo validar campos completos
      if (this.camponuevo) {
        return !!camposClaseCompletos;
      }
      // Si es modo edición, solo habilitar cuando hay cambios
      return this.formularioModificado;
    }
  }
  onBtReset() {
    if (this.gridApi) {
      this.gridApi.showLoadingOverlay();
      this.clasifActivoFacade.cargarClasifActivos();
    }
  }

  /** Delega la carga al facade (JSON seed + localStorage) */
  cargarClasesDesdeSimulacion() {
    this.clasifActivoFacade.cargarClasifActivos();
  }
  
  /**
   * Actualizar el array de clases para el autocomplete de subclases
   */
  private actualizarClasesParaAutocomplete() {
    const clases = this.rowData.filter(item => item.orgHierarchy && item.orgHierarchy.length === 1);
    this.clasesActivo = clases.map(clase => ({
      codigo: clase.clasif_activo_codigo,
      nombre: `${clase.clasif_activo_codigo} - ${clase.clasif_activo_nombre}`
    }));
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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar',},
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385',},
      { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio:   'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380',},
      { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT',},
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - Tipo de Cambio',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
  
      },
    });

    await modal.present();
  }
}
