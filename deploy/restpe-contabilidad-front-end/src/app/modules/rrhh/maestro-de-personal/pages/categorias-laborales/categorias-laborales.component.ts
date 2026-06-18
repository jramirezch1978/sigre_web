import { Component, OnInit, OnDestroy, ViewChild, inject } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { AutocompleteComponent } from 'src/app/ui/autocomplete/autocomplete.component';

// Font Awesome Icons
import { faTimesCircle } from '@fortawesome/pro-light-svg-icons';
import { faBook, faInfoCircle, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { CategoriaLaboralEntity } from 'src/app/modules/rrhh/domain/models/categoria-laboral.entity';
import { DatosPersonalesEntity } from 'src/app/modules/rrhh/domain/models/datos-personales.entity';



@Component({
  selector: 'app-categorias-laborales',
  templateUrl: './categorias-laborales.component.html',
  styleUrls: ['./categorias-laborales.component.scss'],
  standalone: false,
})
export class CategoriasLaboralesComponent implements OnInit {
  // Font Awesome Icons
  falTimesCircle = faTimesCircle;
  farBook = faBook;
  farInfoCircle = faInfoCircle;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  // Facade y selectores del store
  private readonly rrHhFacade = inject(RrHhFacade);
  readonly isLoading = this.rrHhFacade.loadingCategoriasLaborales;


  @ViewChild(AutocompleteComponent) autocomplete!: AutocompleteComponent;
  
  pais= this.countryService.getCountryCode();
  countries= ALL_COUNTRIES;
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  fechaCreacion: Date | undefined;
  fechaVigenciaHasta: Date | undefined;

  tabSeleccionado: string = 'datos';
  CatLaboralesForm!: FormGroup;
  private gridApi!: GridApi;
  filaSeleccionada: any = null;
  tipoSeleccionado: string = 'Creación';
  
  // Propiedades para controlar el flujo
  modoCreacion: boolean = true; // Por defecto en modo creación
  modoEdicion: boolean = false; // Por defecto en modo edición desactivado
  formularioActivo: boolean = true; // Formulario activo por defecto
  trabajadoresAsociados: any[] = []; // Lista de trabajadores agregados

  trabajadores: DatosPersonalesEntity[] = [];

  tabs = [
    { value: 'datos', label: 'Datos Generales' },
    { value: 'trabajadores', label: 'Trabajadores asociados' },
  ];

  tipoFs = [
    { value: 'creacion', categoria_laboral_nombre: 'Creación' },
    { value: 'vigencia', categoria_laboral_nombre: 'Vigencia' },
  ]
  contratos = [
    'Contrato indeterminado','Contrato a plazo fijo','Contrato eventual','Convenio de prácticas','Locación de servicios',
  ]
  tipos: any = [];

  categoria_laboral_retenciones: any=  [
]
  empleadores: any = []
  estados = [
    'Activo','Inactivo'
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
  rowData: CategoriaLaboralEntity[] = [];
  isResetting = false;

  colDefs: ColDef[] = [
    { field: 'categoria_laboral_codigo', headerName: 'Código', width: 80 },
    { field: 'categoria_laboral_nombre', headerName: 'Nombre / Descripción', flex: 1, minWidth: 150 },
    { field: 'categoria_laboral_tipo', headerName: 'Tipo contrato asociado', width: 150, filter: true },
    // { field: 'categoria_laboral_beneficio', headerName: 'Beneficio asociado', width: 160 },
    // { field: 'categoria_laboral_retenciones', headerName: 'Retenciones', width: 150 },
    // { field: 'categoria_laboral_aportes', headerName: 'Aportes', width: 150 },
    { field: 'categoria_laboral_fecha_creacion', headerName: 'Fecha creación', width: 100,
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
    { field: 'categoria_laboral_vigencia', headerName: 'Vigencia hasta', width: 100,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return 'Indefinido';
      }
     },
    {
      field: 'categoria_laboral_estado', headerName: 'Estado', width: 100, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', },
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
        } else if (params.value === 'Inactivo') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>';
        }
        return params.value;
      },
    },

  ];


  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService,
    private countryService: CountryService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  ngOnInit() {
    // this.obtenerdatosdepais();
    this.initializeForm();
    // Cargar categorías laborales desde el JSON a través de la capa de infraestructura
    this.rrHhFacade.cargarCategoriasLaborales();
    // Cargar empleados para el autocomplete de trabajadores
    this.rrHhFacade.cargarDatosPersonales();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = [...this.rrHhFacade.categoriasLaborales()];
        this.trabajadores = this.rrHhFacade.datosPersonales();
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', this.rowData);
        }
        clearInterval(interval);
      }
    }, 100);
  }

  /**
   * Cargar beneficios asociados desde la configuración del país GT
   */
  // private cargarBeneficiosAsociados(): void {
  //   const paisGT = this.countries.find(c => c.categoria_laboral_codigo === 'GT');
  //   if (paisGT && paisGT.beneficiosasociados) {
  //     console.log(' Beneficios asociados cargados para GT:', this.tipos);
  //   } else {
  //     console.warn('  No se encontraron beneficios asociados para GT');
  //     this.tipos = [];
  //   }
  // }
  incializardataporpais(){
    if(this.pais==='PE'){
      this.rowData = [
      { categoria_laboral_codigo: 'CA-005', categoria_laboral_nombre: 'Servicios profesionales', categoria_laboral_tipo: 'Locación de servicios', categoria_laboral_beneficio: 'No aplica', categoria_laboral_retenciones: 'Renta 4ta', categoria_laboral_aportes: '-', categoria_laboral_fecha_creacion: '2025-06-01', categoria_laboral_vigencia: '', categoria_laboral_estado: 'Inactivo' },
      { categoria_laboral_codigo: 'CA-004', categoria_laboral_nombre: 'Prácticas', categoria_laboral_tipo: 'Convenio de prácticas', categoria_laboral_beneficio: 'Subvención, Seguro FOLA', categoria_laboral_retenciones: '-', categoria_laboral_aportes: 'Seguro practicante', categoria_laboral_fecha_creacion: '2025-06-01', categoria_laboral_vigencia: '2026-02-28', categoria_laboral_estado: 'Activo' },
      { categoria_laboral_codigo: 'CA-003', categoria_laboral_nombre: 'Eventual', categoria_laboral_tipo: 'Contrato eventual', categoria_laboral_beneficio: 'Vacaciones proporcionales', categoria_laboral_retenciones: 'Renta 5ta', categoria_laboral_aportes: '-', categoria_laboral_fecha_creacion: '2025-06-01', categoria_laboral_vigencia: '2025-06-30', categoria_laboral_estado: 'Activo' },
      { categoria_laboral_codigo: 'CA-002', categoria_laboral_nombre: 'Temporal', categoria_laboral_tipo: 'Contrato a plazo fijo', categoria_laboral_beneficio: 'Vacaciones, CTS, Gratificaciones', categoria_laboral_retenciones: 'Renta 5ta, AFP/ONP', categoria_laboral_aportes: 'Essalud, SCTR', categoria_laboral_fecha_creacion: '2025-06-01', categoria_laboral_vigencia: '2025-11-30', categoria_laboral_estado: 'Activo' },
      { categoria_laboral_codigo: 'CA-001', categoria_laboral_nombre: 'Indefinido', categoria_laboral_tipo: 'Contrato indeterminado', categoria_laboral_beneficio: 'Vacaciones, CTS, Gratificación', categoria_laboral_retenciones: 'Renta 5ta, AFP/ONP', categoria_laboral_aportes: 'Essalud', categoria_laboral_fecha_creacion: '2025-06-01', categoria_laboral_vigencia: '', categoria_laboral_estado: 'Activo' }
      ];
    }
    else if(this.pais==='GT'){
      this.rowData = []
      this.rowData = [
      { categoria_laboral_codigo: 'CA-005', categoria_laboral_nombre: 'Servicios profesionales', categoria_laboral_tipo: 'Locación de servicios', categoria_laboral_beneficio: 'Bono 14', categoria_laboral_retenciones: 'IGSS', categoria_laboral_aportes: '-', categoria_laboral_fecha_creacion: '2025-06-01', categoria_laboral_vigencia: '', categoria_laboral_estado: 'Inactivo' },
      { categoria_laboral_codigo: 'CA-004', categoria_laboral_nombre: 'Prácticas', categoria_laboral_tipo: 'Convenio de prácticas', categoria_laboral_beneficio: 'Vacaciones', categoria_laboral_retenciones: '-', categoria_laboral_aportes: 'IGSS 12.67%', categoria_laboral_fecha_creacion: '2025-06-01', categoria_laboral_vigencia: '2026-02-28', categoria_laboral_estado: 'Activo' },
      { categoria_laboral_codigo: 'CA-003', categoria_laboral_nombre: 'Eventual', categoria_laboral_tipo: 'Contrato eventual', categoria_laboral_beneficio: 'Bono 14', categoria_laboral_retenciones: 'IGSS laboral', categoria_laboral_aportes: '-', categoria_laboral_fecha_creacion: '2025-06-01', categoria_laboral_vigencia: '2025-06-30', categoria_laboral_estado: 'Activo' },
      { categoria_laboral_codigo: 'CA-002', categoria_laboral_nombre: 'Temporal', categoria_laboral_tipo: 'Contrato a plazo fijo', categoria_laboral_beneficio: 'Bono 14, Aguinaldo, Gratificaciones', categoria_laboral_retenciones: 'IGSS', categoria_laboral_aportes: 'IGSS asalariados, IGSS 12.67%', categoria_laboral_fecha_creacion: '2025-06-01', categoria_laboral_vigencia: '2025-11-30', categoria_laboral_estado: 'Activo' },
      { categoria_laboral_codigo: 'CA-001', categoria_laboral_nombre: 'Indefinido', categoria_laboral_tipo: 'Contrato indeterminado', categoria_laboral_beneficio: 'Bono 14, Aguinaldo, Gratificación', categoria_laboral_retenciones: 'IGSS', categoria_laboral_aportes: 'IGSS asalariados', categoria_laboral_fecha_creacion: '2025-06-01', categoria_laboral_vigencia: '', categoria_laboral_estado: 'Activo' }
      ];
    }
  }
  // obtenerdatosdepais(){
  //   this.countries.find(c => {
  //     if(c.categoria_laboral_codigo === this.pais){
  //       this.categoria_laboral_retenciones = c.retencionesaltrabajador || [];
  //       this.empleadores = c.aportesdelempleador || [];
  //       this.tipos = c.beneficiosasociados;
  //     }
  //   });
  // };
  private initializeForm(): void {
    this.fechaCreacion = new Date();
    this.CatLaboralesForm = this.formBuilder.group({
      fechaCreacion: [{ value: this.fechaCreacion.toLocaleDateString('es-PE'), disabled: true }],
      nombres: ['', [Validators.required, Validators.minLength(3)]],
      contrato: ['', Validators.required],
      beneficios: [''],
      categoria_laboral_retenciones: [''],
      empleador: [''],
      categoria_laboral_vigencia: [''],
      conceptoVigencia: [false],
      categoria_laboral_estado: [{value: 'Activo', disabled: true}],
      trabajador: [''],
    });
    // Inicializar validación de cambios
    this.formValidationService.inicializarFormulario(this.CatLaboralesForm);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // No seleccionar ninguna fila por defecto para mantener el estado de nuevo registro
  }

  async onCellClicked(event: any) {
    if (event.data) {
      // Validar cambios antes de cambiar de registro
      const puede = await this.formValidationService.validarCambios();
      if (!puede) {
        return; // Canceló la operación
      }
      
      this.filaSeleccionada = event.data;
      this.modoCreacion = false;
      this.modoEdicion = true;
      this.formularioActivo = true;
      this.cargarDatosEnFormulario(event.data);
      this.habilitarFormularioEdicion();
      this.formValidationService.resetearEstado();
    }
  }

  onBtReset() {
    this.isResetting = true;
    this.rrHhFacade.cargarCategoriasLaborales();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = [...this.rrHhFacade.categoriasLaborales()];
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', this.rowData);
        }
        clearInterval(interval);
        this.isResetting = false;
      }
    }, 100);
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

  onFechaVigenciaHastaSelected(fecha: Date) {
    this.fechaVigenciaHasta = fecha;
    console.log('Fecha Vigencia Hasta seleccionada:', this.fechaVigenciaHasta);
  }

  onConceptoVigenciaChange(event: any) {
    const isChecked = event.detail.checked;
    console.log('Vigencia indefinida:', isChecked);
    if (isChecked) {
      // Si se activa la vigencia indefinida, limpiar la fecha
      this.CatLaboralesForm.get('categoria_laboral_vigencia')?.reset();
    }
  }

  parsearFecha(fechaStr: string): Date {
    const partes = fechaStr.split('-');
    return new Date(
      parseInt(partes[0]),
      parseInt(partes[1]) - 1,
      parseInt(partes[2]),
    );
  }

  // Método para cargar datos en el formulario cuando se selecciona una fila
  private cargarDatosEnFormulario(datos: any): void {
    const esIndefinido = !datos.categoria_laboral_vigencia || datos.categoria_laboral_vigencia === 'Indefinido';

    // Formatear fecha de creación
    let fechaCreacionStr = '';
    if (datos.categoria_laboral_fecha_creacion) {
      const fecha = this.parsearFecha(datos.categoria_laboral_fecha_creacion);
      fechaCreacionStr = fecha.toLocaleDateString('es-PE');
    }

    this.CatLaboralesForm.patchValue({
      fechaCreacion: fechaCreacionStr,
      nombres: datos.categoria_laboral_nombre,
      contrato: datos.categoria_laboral_tipo,
      beneficios: datos.categoria_laboral_beneficio,
      categoria_laboral_retenciones: datos.categoria_laboral_retenciones,
      empleador: datos.categoria_laboral_aportes,
      categoria_laboral_vigencia: esIndefinido ? null : this.parsearFecha(datos.categoria_laboral_vigencia),
      categoria_laboral_estado: datos.categoria_laboral_estado,
      conceptoVigencia: esIndefinido,
    });

    // Cargar trabajadores asociados desde los códigos del JSON
    const codigos: string[] = datos.categoria_laboral_trabajadores || [];
    this.trabajadoresAsociados = this.trabajadores.filter(t => codigos.includes(t.empleado_codigo));
  }

  // Método para habilitar formulario en modo edición
  private habilitarFormularioEdicion(): void {
    Object.keys(this.CatLaboralesForm.controls).forEach(key => {
      const control = this.CatLaboralesForm.get(key);
      // Mantener deshabilitados: fechaCreación, contrato (solo lectura en edición)
      if (key !== 'fechaCreacion' && key !== 'contrato') {
        control?.enable();
      } else {
        control?.disable();
      }
    });
  }

  // Método para habilitar el formulario
  private habilitarFormulario(): void {
    Object.keys(this.CatLaboralesForm.controls).forEach(key => {
      const control = this.CatLaboralesForm.get(key);
      if (key !== 'fechaCreacion' && key !== 'categoria_laboral_estado') {
        control?.enable();
      }
    });
  }

  // Método para crear nueva categoría
  async crearNuevaCategoria(): Promise<void> {
    // Validar cambios antes de crear nuevo registro
    const puede = await this.formValidationService.validarCambios();
    if (!puede) {
      return; // Canceló la operación
    }
    
    this.filaSeleccionada = null;
    this.modoCreacion = true;
    this.modoEdicion = false;
    this.formularioActivo = true;
    this.resetearFormulario();
    this.habilitarFormulario();
    this.formValidationService.resetearEstado();
    
    // Limpiar la selección del grid
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  // Método para resetear el formulario
  private resetearFormulario(): void {
    this.fechaCreacion = new Date();
    this.fechaVigenciaHasta = undefined;
    this.CatLaboralesForm.reset({
      fechaCreacion: { value: this.fechaCreacion.toLocaleDateString('es-PE'), disabled: true },
      nombres: '',
      contrato: '',
      beneficios: '',
      categoria_laboral_retenciones: '',
      empleador: '',
      categoria_laboral_vigencia: '',
      conceptoVigencia: false,
      categoria_laboral_estado: {value: 'Activo', disabled: true},
      trabajador: '',
    });
  }

  // Método para guardar la nueva categoría
  guardarNuevaCategoria(): void {
    // Validar que el formulario sea válido
    if (!this.CatLaboralesForm.valid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }
    
    // Validar campos obligatorios
    const nombre = this.CatLaboralesForm.get('nombres')?.value?.trim();
    const tipoContrato = this.CatLaboralesForm.get('contrato')?.value;
    const esIndefinido = this.CatLaboralesForm.get('conceptoVigencia')?.value;
    
    if (!nombre) {
      this.toastService.warning('Por favor, completa el campo Nombres/Descripción');
      return;
    }
    
    if (!tipoContrato) {
      this.toastService.warning('Por favor, selecciona un Tipo de contrato asociado');
      return;
    }
    
    if (!esIndefinido && !this.fechaVigenciaHasta) {
      this.toastService.warning('Por favor, selecciona una Vigencia hasta o marca vigencia indefinida');
      return;
    }

    // Determinar la vigencia
    let vigencia = '';
    if (esIndefinido) {
      vigencia = '';
    } else if (this.fechaVigenciaHasta) {
      const day = String(this.fechaVigenciaHasta.getDate()).padStart(2, '0');
      const month = String(this.fechaVigenciaHasta.getMonth() + 1).padStart(2, '0');
      const year = this.fechaVigenciaHasta.getFullYear();
      vigencia = `${year}-${month}-${day}`;
    }

    // Crear un nuevo registro
    // Generar código incrementando desde el último código existente
    let ultimoCodigo = 0;
    if (this.rowData.length > 0) {
      // Encontrar el código más alto
      this.rowData.forEach(row => {
        const numeroActual = parseInt(row.categoria_laboral_codigo.split('-')[1]);
        if (numeroActual > ultimoCodigo) {
          ultimoCodigo = numeroActual;
        }
      });
    }
    
    const nuevoRegistro = {
      categoria_laboral_codigo: `CA-${String(ultimoCodigo + 1).padStart(4, '0')}`,
      categoria_laboral_nombre: this.CatLaboralesForm.get('nombres')?.value || '',
      categoria_laboral_tipo: this.CatLaboralesForm.get('contrato')?.value?.toString() || '',
      categoria_laboral_beneficio: this.CatLaboralesForm.get('beneficios')?.value?.toString() || '',
      categoria_laboral_retenciones: this.CatLaboralesForm.get('categoria_laboral_retenciones')?.value?.toString() || '',
      categoria_laboral_aportes: this.CatLaboralesForm.get('empleador')?.value?.toString() || '',
      categoria_laboral_fecha_creacion: new Date().toISOString().split('T')[0],
      categoria_laboral_vigencia: vigencia,
      categoria_laboral_estado: 'Activo'
    };

    // Agregar el nuevo registro al inicio de la tabla (último registrado arriba)
    this.rowData.unshift(nuevoRegistro);

    // Actualizar la tabla
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', [...this.rowData]);
    }

    // Mostrar mensaje de éxito
    this.toastService.success('¡Categoría laboral registrada exitosamente!');

    // Limpiar formulario y volver a modo creación
    this.trabajadoresAsociados = [];
    this.resetearFormulario();
    this.habilitarFormulario();
    this.filaSeleccionada = null;
    this.modoCreacion = true;
    this.modoEdicion = false;
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    this.formValidationService.resetearEstado();
  }

  // Método para guardar cambios en modo edición
  guardarEdicion(): void {
    if (!this.filaSeleccionada) {
      this.toastService.warning('No hay registro seleccionado');
      return;
    }
    
    // Actualizar el estado de la fila seleccionada
    const nuevoEstado = this.CatLaboralesForm.get('categoria_laboral_estado')?.value;
    
    if (!nuevoEstado) {
      this.toastService.warning('Por favor selecciona un estado');
      return;
    }
    
    // Encontrar el índice de la fila en rowData
    const indice = this.rowData.findIndex(row => row.categoria_laboral_codigo === this.filaSeleccionada.categoria_laboral_codigo);
    
    if (indice !== -1) {
      // Actualizar el estado en el rowData
      this.rowData[indice].categoria_laboral_estado = nuevoEstado;
      this.filaSeleccionada.categoria_laboral_estado = nuevoEstado;
      
      // Refrescar la tabla
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }
      
      // Mostrar mensaje de éxito
      this.toastService.success('¡Cambios realizados exitosamente!');

      // Mantener la selección y los datos en el formulario
      this.gridApi?.refreshCells({ force: true });
      this.formValidationService.resetearEstado();
    }
  }

  async modalverActualizaciones() {
    // Definir las columnas
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 150 },
      { headerName: 'Usuario', field: 'usuario', width: 120 },
      { headerName: 'Acción', field: 'accion', width: 150 },
      {
        headerName: 'Detalle del cambio',
        field: 'detalleCambio', flex: 1
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
        titulo: `"Historial de actualizaciones de la categoría laboral ${this.filaSeleccionada.categoria_laboral_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

  seleccionarTrabajador(trabajador: any): void {
    if (!trabajador) return;
    
    // Validar si el trabajador ya está en la lista
    const existe = this.trabajadoresAsociados.find(t => t.empleado_codigo === trabajador.empleado_codigo);
    if (existe) {
      this.toastService.warning('El trabajador ya está agregado a la categoría');
      return;
    }
    
    // Agregar trabajador a la lista
    this.trabajadoresAsociados.push(trabajador);
    
    // Limpiar el autocomplete
    setTimeout(() => {
      this.autocomplete?.clearSelection();
    }, 0);
  }

  eliminarTrabajador(trabajador: any): void {
    this.trabajadoresAsociados = this.trabajadoresAsociados.filter(t => t.empleado_codigo !== trabajador.empleado_codigo);
  }

}
