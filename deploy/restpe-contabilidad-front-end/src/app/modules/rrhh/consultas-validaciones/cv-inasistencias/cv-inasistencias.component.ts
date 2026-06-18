import { Component, OnInit, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-cv-inasistencias',
  templateUrl: './cv-inasistencias.component.html',
  styleUrls: ['./cv-inasistencias.component.scss'],
  standalone: false,
})
export class CvInasistenciasComponent implements OnInit {
  // Facade
  private readonly rrHhFacade = inject(RrHhFacade);

  // Selectores del store
  readonly inasistenciasStore = this.rrHhFacade.inasistencias;
  readonly isLoading = this.rrHhFacade.loadingInasistencias;

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  pais= this.countryService.getCountryCode();
  countries= ALL_COUNTRIES;
  textoDescansoMedico: string = '';
  // RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  inasistenciasForm!: FormGroup;
  private gridApi!: GridApi;
  estadoSeleccionado: string = 'todos';
  tipoSeleccionado: string = 'todos';
  inasistenciaSeleccionada: string = 'todos';
  centrocostos: string = 'todos';
  sucursalSeleccionada: string = '';
  usoDocumentoSeleccionado: string = '';
  naturalezaSeleccionada: string = '';
  gridContext!: { componentParent: CvInasistenciasComponent };
  filaSeleccionada: any = null;
  archivo: any;

  disabledValidar: boolean = true;
  valoresIniciales: any = {}; // Para detectar cambios en los campos editables

    inasistencias = [
    { label: 'Inasistencias', value: 'Inasistencias' },
    { label: 'Injustificada', value: 'Injustificada' },
    { label: 'Justificada', value: 'Justificada' },
    { label: 'Descanso médico', value: 'Descanso médico' },
  ];
  tiposJustificacion: any = [];
  tiposIncidencia: any = [];

  accionesCorrectivas = [
    { label: 'Corregida', value: 'corregida' },
    { label: 'Eliminada', value: 'eliminada' },
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

  rowData: any[] = [];
  isResetting = false;

  colDefs: ColDef[] = [
    { field: 'inasistencia_trabajador', headerName: 'Trabajador', flex:1, minWidth: 250 },
    // { field: 'tipo', headerName: 'Tipo', width: 120, filter: true },
    { field: 'inasistencia_fecha_inasistencia', headerName: 'Fecha de inasistencia', width: 130,
      valueFormatter: (params) => {
        if (params.value) {
          const date = new Date(params.value + 'T00:00:00');
          return date.toLocaleDateString('es-PE');
        }
        return '';
      }
     },
    { field: 'inasistencia_sucursal', headerName: 'Sucursal', width: 180, filter: true },
    { field: 'inasistencia_centro_costo', headerName: 'Centro de Costo', width: 180, filter: true },
    { field: 'inasistencia_ultima_modificacion', headerName: 'Última modiicación', width: 120,
      valueFormatter: (params) => {
        if (params.value) {
          const date = new Date(params.value + 'T00:00:00');
          return date.toLocaleDateString('es-PE');
        }
        return '';
      }
     },
    { 
      field: "inasistencia_estado", 
      headerName: "Estado", 
      headerClass: 'ag-header-hover ag-header-10px centrarencabezado', 
      filter: true,
      width: 120,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let estadoClass = '';
        
        if (estado === 'Justificada') {
          return '<span class="badge-table bg-[#FFDECC] text-[#FF8947]">Justificada</span>';
        } else if (estado === 'Injustificada') {
          estadoClass = 'text-yellow colorcelda';
        } else if (estado === 'Descanso méd.' || estado === 'Incapacidad Médica' || estado === 'Suspensiones del IGSS') {
          estadoClass = 'text-primary bg-[#D6E6FF]';
        }
        
        return `<span class="px-2 py-[1px] rounded-full text-xxss font-medium ${estadoClass}">${estado}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
  ];

  columnTypes = {};

  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController,
    private countryService: CountryService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Inicializar formulario
    this.inasistenciasForm = this.formBuilder.group({
      inasistencia_trabajador: [{ value: '', disabled: true }],
      inasistencia_sucursal: [{ value: '', disabled: true }],
      centroCosto: [{ value: '', disabled: true }],
      tipoJustificacion: ['permisos'],
      fechaInasistencia: [''],
      fechaModificacion: [''],
      tipoIncidencia: [''],
      accionCorrectiva: [''],
      observaciones: [''],
      estadoRegistro: [{ value: '', disabled: true }]
    });

    this.gridContext = { componentParent: this };
  }

  ngOnInit() {
    this.obtenerdatosdepais();
    // Cargar datos desde el JSON vía infraestructura
    this.rrHhFacade.cargarInasistencias();
    // Una vez cargados, aplicar lógica de país y seleccionar primera fila
    const check = setInterval(() => {
      const datos = this.inasistenciasStore();
      if (datos.length > 0) {
        clearInterval(check);
        this.inicializarDatosPorPais();
      }
    }, 100);
    
    // Monitorear cambios solo en campos editables
    this.inasistenciasForm.get('tipoIncidencia')?.valueChanges.subscribe(() => {
      this.actualizarEstadoBoton();
    });
    this.inasistenciasForm.get('accionCorrectiva')?.valueChanges.subscribe(() => {
      this.actualizarEstadoBoton();
    });
    this.inasistenciasForm.get('observaciones')?.valueChanges.subscribe(() => {
      this.actualizarEstadoBoton();
    });
  }

  private actualizarEstadoBoton() {
    // Habilitar el botón si hay cambios en cualquiera de los campos editables
    const tipoIncidencia = this.inasistenciasForm.get('tipoIncidencia')?.value;
    const accionCorrectiva = this.inasistenciasForm.get('accionCorrectiva')?.value;
    const observaciones = this.inasistenciasForm.get('observaciones')?.value;
    
    const hayCambios = 
      tipoIncidencia !== this.valoresIniciales.tipoIncidencia ||
      accionCorrectiva !== this.valoresIniciales.accionCorrectiva ||
      observaciones !== this.valoresIniciales.observaciones;
    
    this.disabledValidar = !hayCambios;
  }
   onBtReset() {
    this.isResetting = true;
    this.rrHhFacade.cargarInasistencias();
    const check = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(check);
        this.inicializarDatosPorPais();
        this.isResetting = false;
      }
    }, 100);
  }
  obtenerdatosdepais() {
    this.countries.find(c => {
      if (c.codigo === this.pais) {
        this.tiposJustificacion = c.tiposjustificacion;
        this.tiposIncidencia = c.tiposIncidencia;
      }
    });
  };

  inicializarDatosPorPais() {
    // Definir texto de descanso médico según el país
    if (this.pais === 'GT') {
      this.textoDescansoMedico = 'Suspensiones del IGSS';
    } else if (this.pais === 'CO') {
      this.textoDescansoMedico = 'Incapacidad Médica';
    } else {
      this.textoDescansoMedico = 'Descanso méd.';
    }

    // Mapear datos del store aplicando texto de país
    this.rowData = this.inasistenciasStore().map((item: any) => ({
      ...item,
      inasistencia_estado: item.inasistencia_estado === 'Descanso méd.' ? this.textoDescansoMedico : item.inasistencia_estado
    }));
  }
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onCellClicked(event: any) {
    this.filaSeleccionada = event.data;
    this.cargarDatosFormulario(this.filaSeleccionada);
  }

  private cargarDatosFormulario(fila: any) {
    if (!fila) return;

    console.log('estado de inasistencia:', fila.inasistencia_estado);
    // Llenar el formulario (campos deshabilitados ya están configurados en el constructor)
    this.inasistenciasForm.patchValue({
      inasistencia_trabajador: fila.inasistencia_trabajador || '',
      inasistencia_sucursal: fila.inasistencia_sucursal || '',
      centroCosto: fila.inasistencia_centro_costo || '',
      estadoRegistro: fila.inasistencia_estado || '',
      tipoIncidencia: fila.inasistencia_estado,
      fechaInasistencia: fila.inasistencia_fecha_inasistencia ? new Date(fila.inasistencia_fecha_inasistencia) : '',
      fechaModificacion: fila.inasistencia_ultima_modificacion ? new Date(fila.inasistencia_ultima_modificacion) : '',
      accionCorrectiva: '',
      observaciones: ''
    });

    // Guardar valores iniciales para detectar cambios
    this.valoresIniciales = {
      tipoIncidencia: '',
      accionCorrectiva: '',
      observaciones: ''
    };

    this.actualizarEstadoBoton();
  }

botonGuardar() {
  if (!this.filaSeleccionada) return;

  const tipoIncidencia = this.inasistenciasForm.get('tipoIncidencia')?.value;
  const accionCorrectiva = this.inasistenciasForm.get('accionCorrectiva')?.value;
  const observaciones = this.inasistenciasForm.get('observaciones')?.value;

  // Actualizar el estado según el tipo de incidencia seleccionado
  if (tipoIncidencia) {
    this.filaSeleccionada.inasistencia_estado = tipoIncidencia;
  }

  // Si hay acción correctiva, toma prioridad sobre el tipo de incidencia
  if (accionCorrectiva === 'corregida') {
    this.filaSeleccionada.inasistencia_estado = 'Correcta';
  } else if (accionCorrectiva === 'eliminada') {
    this.filaSeleccionada.inasistencia_estado = 'Eliminada';
  }

  // Guardar las observaciones si las hay
  if (observaciones) {
    this.filaSeleccionada.observaciones = observaciones;
  }

  // Actualizar la fecha de última modificación
  const hoy = new Date();
  this.inasistenciasForm.patchValue({ fechaModificacion: hoy });

  // Refrescar la tabla para mostrar los cambios
  if (this.gridApi) {
    this.gridApi.applyTransaction({ update: [this.filaSeleccionada] });
  }

  // Actualizar los valores iniciales para deshabilitar el botón nuevamente
  this.valoresIniciales = {
    tipoIncidencia: tipoIncidencia,
    accionCorrectiva: accionCorrectiva,
    observaciones: observaciones
  };

  this.actualizarEstadoBoton();
  this.toastService.success('¡Cambios guardados exitosamente!');
}

  importar(data: any) {
    console.log('Importar llamado con:', data);
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    console.log('Filtrar por fechas:', range);
    // Aquí iría la lógica para filtrar los datos
  }

  onFechaInasistencia(date: Date) {
    this.inasistenciasForm.patchValue({ fechaInasistencia: date });
  }

  onFechaModificacion(date: Date) {
    this.inasistenciasForm.patchValue({ fechaModificacion: date });
  }
   onResponsableSeleccionado(event: any){
    console.log('Responsable seleccionado', event);
    // aplicar filtro a tus datos / guardar en variables del componente
  }

  onDescansoMedicoSelected(file: File) {
    console.log('Archivo de descanso médico seleccionado:', file);
    // Aquí puedes manejar el archivo:
    // - Subirlo a un servidor
    // - Guardarlo en una variable
    // - Mostrar preview, etc.
  }

  onDescansoMedicoRemoved() {
    console.log('Archivo de descanso médico removido');
    // Limpiar cualquier dato relacionado
  }

  showFileError(errorMessage: string) {
    this.toastService.danger('Error al subir archivo', errorMessage);
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
        { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar', },
        { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385', },
        { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380', },
        { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT', },
      ];
  
      const modal = await this.modalController.create({
        component: ModalVerActualizacionesComponent,
        cssClass: 'promo',
        componentProps: {
          titulo: 'Historial de Actualizaciones - 001-TRA',
          rowData: rowData,
          colDefs: colDefs,
          anchoModal: '700px',
  
        },
      });
  
      await modal.present();
    }
}