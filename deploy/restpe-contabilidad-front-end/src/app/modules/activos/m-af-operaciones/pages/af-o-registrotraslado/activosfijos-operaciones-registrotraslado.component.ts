import { Component, OnInit, OnDestroy, inject, computed } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { AccesorioActionsCellComponent } from '../../../m-af-tabla/pages/af-o-registroactivos/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { RegistroTrasladoFacade } from '../../../application/facades/registro-traslado.facade';
import { ActivoFijoFacade } from '../../../application/facades/activo-fijo.facade';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-activosfijos-operaciones-registrotraslado',
  templateUrl: './activosfijos-operaciones-registrotraslado.component.html',
  styleUrls: ['./activosfijos-operaciones-registrotraslado.component.scss'],
  standalone: false,
})
export class ActivosfijosOperacionesRegistrotrasladoComponent
  implements OnInit, OnDestroy, CanComponentDeactivate
{
  // Font Awesome Icons
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
  //FECHAS ÚNICAS (SINGLE)
  fechaProgramada: Date | undefined;
  fechaAprobacion: Date | undefined;
  fechaEjecuciom: Date | undefined;

  registroTrasladoForm: FormGroup;
  private gridApi!: GridApi;

  // Facade – fuente de datos reactiva
  private readonly registroTrasladoFacade = inject(RegistroTrasladoFacade);
  private readonly activoFijoFacade = inject(ActivoFijoFacade);

  /** Listado de traslados proveniente del JSON + SimulationService vía RegistroTrasladoRepositoryImpl */
  readonly rowData           = this.registroTrasladoFacade.traslados;
  readonly isLoadingTraslados = this.registroTrasladoFacade.isLoading;

  filaSeleccionada: any = null; // Almacena la fila que se está editando
  estadoSeleccionado: string = 'todos';
  camponuevo: boolean = true;
  tabSeleccionado: string = 'datosGenerales';
  panelLateralVisible: boolean = true;
  gridContext!: {
    componentParent: ActivosfijosOperacionesRegistrotrasladoComponent;
  };


  // Array de rersponsables para el autocomplete
  responsables = [
    { nombre: 'Rodrigo Hernández' },
    { nombre: 'Juan Pérez' },
    { nombre: 'María García' },
    { nombre: 'Carlos López' },
  ];

  // Array de destinos para el autocomplete
  destinos = [
    { nombre: 'Sucursal Central' },
    { nombre: 'Sucurrsal Norte' },
    { nombre: 'Sucursal Sur' },
    { nombre: 'Sucursal Este' },
  ];

  solicitantes = [
    { nombre: 'Rodrigo Hernández' },
    { nombre: 'Juan Pérez' },
    { nombre: 'María García' },
    { nombre: 'Carlos López' },
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
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  colDefs: ColDef[] = [
    { field: 'registro_traslado_codigo', headerName: 'N° de traslado', width: 100 },
    { field: 'registro_traslado_f_solicitud', headerName: 'Fecha de Solicitud', width: 120,
         valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
     },
    { field: 'registro_traslado_solicitante', headerName: 'Solicitante', width: 120 },
    { field: 'registro_traslado_origen', headerName: 'Origen', width: 130 },
    { field: 'registro_traslado_destino', headerName: 'Destino', width: 130 },
    { headerName: 'N° de activos', width: 100,
      valueGetter: (params) => {
        const activos = params.data?.registro_traslado_activos;
        return Array.isArray(activos) ? activos.length : '–';
      }
     },
    { field: 'registro_traslado_estado', headerName: 'Estado', headerClass: 'centrarencabezado', width: 90, filter: true,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let estadoClass = '';
        switch (estado) {
          case 'Pendiente':
            estadoClass = 'text-gray-600 bg-gray-100';
            break;
          case 'Aprobado':
            estadoClass = 'text-green-600 bg-green-100';
            break;
          case 'Recepcionado':
            estadoClass = 'text-[#3B82F6] bg-[#D6E6FF]';
            break;
          case 'Rechazado':
            estadoClass = 'text-red-600 bg-red-100';
            break;
          default:
            estadoClass = 'text-gray-600 bg-gray-100';
            break;
        }
        return `<span class="badge-table ${estadoClass}">${estado}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center',},
    },
  ];

  columnTypes = {};

  // AG-Grid para datos generales
  private gridApiActivos!: GridApi;

  // Datos iniciales vacíos - se llenarán cuando se seleccione único responsable
  rowDataActivos: any[] = [];

  // Lista de activos disponibles para agregar (cargados desde el JSON vía ActivoFijoFacade)
  readonly activosDisponibles = this.activoFijoFacade.activosFijos;

  colDefsActivos: ColDef[] = [
    { field: 'activo_fijo_codigo', headerName: 'Código', width: 80 },
    { field: 'activo_fijo_descripcion', headerName: 'Descripción', flex: 1, minWidth: 200 },
    { field: 'activo_fijo_responsable', headerName: 'Responsable', width: 100 },
    { field: 'activo_fijo_centro_costos', headerName: 'Centro de Costo', width: 130 },
    { field: 'nuevoResponsable', headerName: 'Nuevo Responsable', width: 150,
      editable: (params) => {
        // Solo editable si NO está marcado "Único responsable"
        return !this.registroTrasladoForm.get('unicoResponsable')?.value;
      },
      cellEditor: 'agTextCellEditor',
      cellClass: (params) => {
        // Aplicar clase disabled cuando está marcado "Único responsable"
        return this.registroTrasladoForm.get('unicoResponsable')?.value 
          ? 'nuevo-responsable-cell cell-disabled' 
          : 'nuevo-responsable-cell';
      },
      cellStyle: (params) => {
        const isDisabled = this.registroTrasladoForm.get('unicoResponsable')?.value;
        return {
          textAlign: 'left',
          display: 'flex',
          alignItems: 'center',
          paddingLeft: '8px',
          backgroundColor: isDisabled ? '#f5f5f5' : '',
          cursor: isDisabled ? 'not-allowed' : 'text',
          opacity: isDisabled ? 0.6 : 1,
        };
      },
      valueSetter: (params: any) => {
        // Solo permitir edición si NO está marcado "Único responsable"
        if (this.registroTrasladoForm.get('unicoResponsable')?.value) {
          return false;
        }
        const newVal = (params.newValue ?? '').toString().trim();
        if (params.data.nuevoResponsable !== newVal) {
          params.data.nuevoResponsable = newVal;
          return true;
        }
        return false;
      },
    },
    { field: 'acciones', headerClass: 'centrarencabezado', headerName: 'Acciones', width: 100,
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
    private toastService: ToastService,
    private modalController: ModalController,
    private formValidationService: FormValidationService,
    private simulation: SimulationService,
  ) {
    const today = new Date();
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );
    this.maxDate = today;
    
    this.registroTrasladoForm = this.formBuilder.group({
      motivoTraslado: ['', Validators.required],
      fechaSolicitud: [{ value: this.getFechaHoy(), disabled: true,}, Validators.required],
      unicoResponsable: [false],
      responsable: [''],
      activoSeleccionado: [''],
      destino: ['', Validators.required],
      solicitante: ['', Validators.required],
      fechaProgramada: ['', Validators.required],
      observaciones: [''],
      aprobacion: [''],
      fechaAprobacion: [''],
      ejecucion: [''],
      fechaEjecucion: [''],
    });

    this.gridContext = { componentParent: this };

    // Suscribirse a cambios en el checkbox de único responsable
    this.registroTrasladoForm.get('unicoResponsable')?.valueChanges.subscribe((value) => {
      this.onUnicoResponsableChange(value);
    });
  }

  ngOnInit() {
    // Cargar traslados desde el repositorio (RegistroTrasladoRepositoryImpl → JSON + SimulationService)
    this.registroTrasladoFacade.cargarTraslados();
    // Cargar activos fijos disponibles desde el JSON
    this.activoFijoFacade.cargarActivosFijos();

    this.formValidationService.inicializarFormulario(this.registroTrasladoForm);
    this.refrescarVista();
    
    setTimeout(() => {
      if (this.camponuevo) {
        this.formValidationService.resetearEstado();
      }
    }, 100);
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  getFechaHoy(): string {
    const today = new Date();
    const dia = today.getDate().toString().padStart(2, '0');
    const mes = (today.getMonth() + 1).toString().padStart(2, '0');
    const anio = today.getFullYear();
    return `${dia}/${mes}/${anio}`;
  }

   formatearFecha(fecha: Date): string {
    const dia = fecha.getDate().toString().padStart(2, '0');
    const mes = (fecha.getMonth() + 1).toString().padStart(2, '0');
    const anio = fecha.getFullYear();
    return `${anio}-${mes}-${dia}`;
  } 

  /**
   * Valida los campos mínimos de la pestaña "Datos Generales".
   * - motivoTraslado, fechaSolicitud siempre requeridos
   * - si unicoResponsable es true, entonces responsable es requerido
   */
  get datosGeneralesValid(): boolean {
    const motivo = this.registroTrasladoForm.get('motivoTraslado');
    const fecha = this.registroTrasladoForm.get('fechaSolicitud');
    const unico = this.registroTrasladoForm.get('unicoResponsable');
    const responsable = this.registroTrasladoForm.get('responsable');

    if (!motivo || !fecha || !unico) return false;

    // Validar que los campos tengan valor (no solo que sean válidos)
    const motivoValue = motivo.value?.toString().trim();
    const fechaValue = fecha.value;

    if (!motivoValue || !fechaValue) return false;

    // Si está marcado único responsable, validar que haya un responsable seleccionado
    if (unico.value === true) {
      const responsableValue = responsable?.value?.toString().trim();
      return !!responsableValue;
    }

    return true;
  }

  /** Intenta avanzar a la siguiente pestaña sólo si los datos generales son válidos */
  nextTab() {
    if (this.datosGeneralesValid) {
      this.tabSeleccionado = 'ubicaciontraslado';
    } else {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      // marcar campos como tocados para mostrar validaciones en UI si las hay
      this.registroTrasladoForm.get('motivoTraslado')?.markAsTouched();
      this.registroTrasladoForm.get('fechaSolicitud')?.markAsTouched();
      if (this.registroTrasladoForm.get('unicoResponsable')?.value === true) {
        this.registroTrasladoForm.get('responsable')?.markAsTouched();
      }
    }
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  async onCellClicked(event: any) {
    const data = event.data;
    
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      if (this.gridApi && this.filaSeleccionada) {
        this.gridApi.deselectAll();
        this.gridApi.forEachNode((node) => {
          if (node.data === this.filaSeleccionada) {
            node.setSelected(true);
          }
        });
      } else {
        // Si no hay fila previa seleccionada, deseleccionar la que se acaba de marcar
        this.gridApi?.deselectAll();
      }
      return;
    }
    
    this.gridApi?.deselectAll();
    this.cargarDatosRegistro(data);
  }

  /**
   * Carga los datos de un registro en el formulario
   */
  private cargarDatosRegistro(data: any) {
    this.camponuevo = false;
    this.filaSeleccionada = data;
    this.gridApi.deselectAll();
    
    // Seleccionar el nodo en AG-Grid
    this.gridApi.forEachNode((node) => {
      if (node.data === data) {
        node.setSelected(true);
      }
    });
    
    // Completar el formulario con los datos de la fila seleccionada
    this.completarFormularioConFila(data);
    
  }

  /**
   * Completa los campos del formulario con los datos de la fila seleccionada
   */
  completarFormularioConFila(data: any) {
  if (!data) return;

  const parseFecha = (fechaStr: string): string | undefined => {
    if (!fechaStr) return undefined;

    // Formato yyyy-mm-dd → dd/mm/yyyy para display
    if (fechaStr.includes('-')) {
      const partes = fechaStr.split('-');
      if (partes.length === 3) {
        return `${partes[2]}/${partes[1]}/${partes[0]}`;
      }
    }

    // Formato dd/mm/yyyy → mantener tal cual
    const partes = fechaStr.split('/');
    if (partes.length === 3) {
      return fechaStr;
    }
    return undefined;
  };

  const solicitanteEncontrado = this.solicitantes.find(
    (s) => s.nombre === data.registro_traslado_solicitante
  );

  const destinoEncontrado = this.destinos.find(
    (d) => d.nombre === data.registro_traslado_destino
  );

  this.registroTrasladoForm.patchValue({
    fechaSolicitud: parseFecha(data.registro_traslado_f_solicitud) || '',
    solicitante: solicitanteEncontrado ? solicitanteEncontrado.nombre : '',
    destino: destinoEncontrado ? destinoEncontrado.nombre : '',
    motivoTraslado: data.registro_traslado_motivo,
    observaciones: data.registro_traslado_observaciones || '',
    aprobacion: data.registro_traslado_aprobacion || '',
    ejecucion: data.registro_traslado_ejecucion || '',
  });

  // Cargar fechas en los calendarios
  if (data.registro_traslado_f_programada) {
    this.fechaProgramada = new Date(data.registro_traslado_f_programada + 'T00:00:00');
    this.registroTrasladoForm.patchValue({ fechaProgramada: this.fechaProgramada });
  } else {
    this.fechaProgramada = undefined;
  }

  if (data.registro_traslado_f_aprobacion) {
    this.fechaAprobacion = new Date(data.registro_traslado_f_aprobacion + 'T00:00:00');
    this.registroTrasladoForm.patchValue({ fechaAprobacion: this.fechaAprobacion });
  } else {
    this.fechaAprobacion = undefined;
  }

  if (data.registro_traslado_f_ejecucion) {
    this.fechaEjecuciom = new Date(data.registro_traslado_f_ejecucion + 'T00:00:00');
    this.registroTrasladoForm.patchValue({ fechaEjecucion: this.fechaEjecuciom });
  } else {
    this.fechaEjecuciom = undefined;
  }

  // Cargar los activos asociados al traslado en la tabla secundaria
  this.rowDataActivos = (data.registro_traslado_activos || []).map((activo: any) => ({
    ...activo,
    nuevoResponsable: '',
  }));

  this.formValidationService.resetearEstado();
  this.tabSeleccionado = 'datosGenerales';
}


  async botonNuevoTraslado() {
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return;
    }
    
    this.camponuevo = true;
    this.gridApi.deselectAll();
    this.filaSeleccionada = null;
    this.registroTrasladoForm.reset();
    this.registroTrasladoForm.patchValue({ 
      fechaSolicitud: this.getFechaHoy(),
      unicoResponsable: false 
    });
    
    this.fechaProgramada = undefined;
    this.fechaAprobacion = undefined;
    this.fechaEjecuciom = undefined;
    this.rowDataActivos = [];
    
    this.formValidationService.resetearEstado();
    this.tabSeleccionado = 'datosGenerales';
  }
  validarCamposObligatorios(): boolean {
    const formValues = this.registroTrasladoForm.value;
    const destino = formValues.destino;
    const solicitante = formValues.solicitante;
    const fechaProgramada = formValues.fechaProgramada;
    const aprobacion = formValues.aprobacion;
    const fechaAprobacion = formValues.fechaAprobacion;
    const ejecucion = formValues.ejecucion;
    const fechaEjecucion = formValues.fechaEjecucion;

    return !!destino && !!solicitante && !!fechaProgramada && !!aprobacion && !!fechaAprobacion && !!ejecucion && !!fechaEjecucion;
  }

  //////////
  botonGuardar() {
    if (!this.validarCamposObligatorios()) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    const formValues = this.registroTrasladoForm.value;
    const destino = formValues.destino;
    const solicitante = formValues.solicitante;

    if (this.camponuevo) {
      // CREAR NUEVO REGISTRO
      // Generar código automático para ntraslado
      const numeros = this.rowData()
        .map(r => {
          const partes = r.registro_traslado_codigo?.split('-');
          return partes && partes.length > 1 ? parseInt(partes[1]) : 0;
        })
        .filter(n => !isNaN(n) && n > 0);
      
      const ultimoNumero = numeros.length > 0 ? Math.max(...numeros) : 0;
      const nuevoNumero = String(ultimoNumero + 1).padStart(3, '0');
      const nuevoTraslado = `TRA-${nuevoNumero}`;

      // Buscar nombres de solicitante y destino
      const solicitanteNombre = this.solicitantes.find(s => s.nombre === solicitante)?.nombre || '';
      const destinoNombre = this.destinos.find(d => d.nombre === destino)?.nombre || '';

      const fechaSolicitudStr = this.getFechaHoy()

      const nuevoRegistro = {
        registro_traslado_codigo:      nuevoTraslado,
        registro_traslado_f_solicitud: fechaSolicitudStr,
        registro_traslado_solicitante: solicitanteNombre,
        registro_traslado_origen:      'Sucursal San Isidro',
        registro_traslado_destino:     destinoNombre,
        registro_traslado_n_activos:   String(this.rowDataActivos.length),
        registro_traslado_estado:      'Pendiente',
        registro_traslado_motivo:      'Text',
        registro_traslado_activos:     this.rowDataActivos.map(({ nuevoResponsable, ...rest }) => rest),
      };
      this.simulation.save('traslados', nuevoRegistro);
      this.refrescarVista();
      
      this.toastService.success('¡Traslado registrado exitosamente!');
    } else {
      // EDITAR REGISTRO EXISTENTE
      if (this.filaSeleccionada) {
        const solicitanteNombre = this.solicitantes.find(s => s.nombre === solicitante)?.nombre || '';
        const destinoNombre = this.destinos.find(d => d.nombre === destino)?.nombre || '';
        
        // Actualizar la fila seleccionada
        this.filaSeleccionada.registro_traslado_solicitante = solicitanteNombre;
        this.filaSeleccionada.registro_traslado_destino     = destinoNombre;
        this.filaSeleccionada.registro_traslado_n_activos   = String(this.rowDataActivos.length);
        this.filaSeleccionada.registro_traslado_activos     = this.rowDataActivos.map(({ nuevoResponsable, ...rest }: any) => rest);
        
        // Refrescar la tabla
        this.gridApi.applyTransaction({ update: [this.filaSeleccionada] });
        
        this.toastService.success('¡Traslado actualizado exitosamente!');
      }
    }

    // Limpiar formulario y preparar para nuevo registro
    this.registroTrasladoForm.reset();
    this.registroTrasladoForm.patchValue({ 
      fechaSolicitud: this.getFechaHoy(),
      unicoResponsable: false 
    });
    this.fechaProgramada = undefined;
    this.fechaAprobacion = undefined;
    this.fechaEjecuciom = undefined;
    this.rowDataActivos = [];
    
    // Mantener en modo creación para siguiente registro
    this.camponuevo = true;
    this.filaSeleccionada = null;
    this.tabSeleccionado = 'datosGenerales';
    
    this.formValidationService.resetearEstado();
  }
  refrescarVista() {
    // Recarga datos desde el repositorio (JSON seed + SimulationService)
    this.registroTrasladoFacade.cargarTraslados();
  }
  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  onGridReadyActivos(params: GridReadyEvent) {
    this.gridApiActivos = params.api;
  }

  onCellClickedActivo(event: any) {
    console.log('Datos generales clicked', event);
  }

  /**
   * Maneja el cambio del checkbox "Único responsable"
   */
  onUnicoResponsableChange(value: boolean) {
    if (value) {
      // Cuando se marca, vaciar todos los valores de "nuevoResponsable" en la tabla
      this.rowDataActivos = this.rowDataActivos.map(activo => ({
        ...activo,
        nuevoResponsable: ''
      }));
    } else {
      // Limpiar el campo de responsable cuando se desmarca
      this.registroTrasladoForm.patchValue({ responsable: '' });
    }
    
    // Refrescar la tabla para aplicar el estado disabled en la columna "Nuevo Responsable"
    if (this.gridApiActivos) {
      this.gridApiActivos.refreshCells({ force: true });
    }
  }
  
  /**
   * Maneja la selección de un activo desde el autocomplete
   */
  onActivoSeleccionado(activo: any) {
    if (!activo) return;
    
    // Verificar si el activo ya está en la lista
    const yaExiste = this.rowDataActivos.some(a => a.activo_fijo_codigo === activo.activo_fijo_codigo);
    
    if (yaExiste) {
      this.toastService.warning('Este activo ya ha sido agregado');
      // Limpiar el autocomplete incluso si ya existe
      setTimeout(() => {
        this.registroTrasladoForm.patchValue({ activoSeleccionado: '' });
      }, 100);
      return;
    }
    
    // Agregar el activo a la tabla
    const nuevoActivo = {
      activo_fijo_codigo: activo.activo_fijo_codigo,
      activo_fijo_descripcion: activo.activo_fijo_descripcion,
      activo_fijo_responsable: activo.activo_fijo_responsable,
      activo_fijo_centro_costos: activo.activo_fijo_centro_costos,
      nuevoResponsable: '',
    };
    
    this.rowDataActivos = [...this.rowDataActivos, nuevoActivo];
    
    // Limpiar el autocomplete con un pequeño delay para asegurar que se vacíe
    setTimeout(() => {
      this.registroTrasladoForm.patchValue({ activoSeleccionado: '' });
    }, 100);
    
    this.toastService.success('Activo agregado correctamente');
  }

  eliminarAccesorio(accesorio: any) {
    console.log('Eliminar accesorio', accesorio);
  }
  onResponsableSeleccionado(responsable: any) {
    console.log('Responsable seleccionado:', responsable);
    this.registroTrasladoForm.patchValue({
      responsable: responsable?.nombre || ''
    });
  }
  
  onResponsableAprobacionSeleccionado(responsable: any) {
    console.log('Responsable de aprobación seleccionado:', responsable);
    this.registroTrasladoForm.patchValue({
      aprobacion: responsable?.nombre || ''
    });
  }
  
  onResponsableEjecucionSeleccionado(responsable: any) {
    console.log('Responsable de ejecución seleccionado:', responsable);
    this.registroTrasladoForm.patchValue({
      ejecucion: responsable?.nombre || ''
    });
  }
  
  onSolicitanteSeleccionado(solicitante: any) {
    console.log('Solicitante seleccionado:', solicitante);
    this.registroTrasladoForm.patchValue({
      solicitante: solicitante?.nombre || ''
    });
  }
  
  onDestinoSeleccionado(destino: any) {
    console.log('Destino seleccionado:', destino);
    this.registroTrasladoForm.patchValue({
      destino: destino?.nombre || ''
    });
  }

  onCentroCostosSeleccionado(centroCostos: any) {
    console.log('Centro de costos seleccionado:', centroCostos);
  }
  onFechaProgramadaSelected(date: Date) {
    console.log('Fecha Programada:', date);
    this.fechaProgramada = date;
    this.registroTrasladoForm.patchValue({ fechaProgramada: date });
  }
  onFechaAprobacionSelected(date: Date) {
    console.log('Fecha Aprobacion:', date);
    this.fechaAprobacion = date;
    this.registroTrasladoForm.patchValue({ fechaAprobacion: date });
  }
  onFechaEjecucionSelected(date: Date) {
    console.log('Fecha Ejecucion:', date);
    this.fechaEjecuciom = date;
    this.registroTrasladoForm.patchValue({ fechaEjecucion: date });
  }

  onBtReset() {
    // Recarga datos desde el repositorio, lo que activa isLoadingTraslados()
    this.registroTrasladoFacade.cargarTraslados();
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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación',      detalleCambio: 'Registro inicial del traslado desde Sucursal San Isidro hacia Sucursal Central' },
      { fechaHora: '21/11/2025 10:15', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación del destino: de Sucursal Central a Almacén Principal' },
      { fechaHora: '21/11/2025 11:30', usuario: 'Luis Gracia',   accion: 'Aprobación',    detalleCambio: 'Traslado aprobado por el responsable de área' },
      { fechaHora: '21/11/2025 14:00', usuario: 'Juan Pérez',    accion: 'Ejecución',      detalleCambio: 'Traslado ejecutado — 10 activos transferidos correctamente' },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - Traslado de activo',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
  
      },
    });

    await modal.present();
  }

  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }}