import { Component, ElementRef, OnInit, ViewChild, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridOptions, GridReadyEvent, RowNodeTransaction } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalAgregarEquipamientoComponent } from '../../modals/modal-agregar-equipamiento/modal-agregar-equipamiento.component';
import { AccionesEyeCellrendererComponent } from 'src/app/ui/acciones-eye-cellrenderer/acciones-eye-cellrenderer.component';
import { DocumentCellrendererComponent } from 'src/app/ui/document-cellrenderer/document-cellrenderer.component';
import { ModalVerDocumentoComponent } from '../../modals/modal-ver-documento/modal-ver-documento.component';
import { ModalRenovarContratoComponent } from '../../modals/modal-renovar-contrato/modal-renovar-contrato.component';
import { ModalCambiarPuestoComponent } from '../../modals/modal-cambiar-puesto/modal-cambiar-puesto.component';
import { ModalSancionComponent } from '../../modals/modal-sancion/modal-sancion.component';
import { AcciEditEliminarComponent } from 'src/app/ui/acci-edit-eliminar/acci-edit-eliminar.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { DatosPersonalesEntity } from 'src/app/modules/rrhh/domain/models/datos-personales.entity';
import { SunatService } from 'src/app/core/infrastructure/sunat/sunat.service';

// Font Awesome Icons
import { faBook, faInfoCircle, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronLeft, faChevronRight, faChevronsLeft, faChevronsRight, faCirclePlus, faCloudArrowUp, faDownload, faEdit, faPlusCircle, faRotateRight, faSearch as fasSearchIcon, faXmark } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-m-p-datos-personales',
  templateUrl: './m-p-datos-personales.component.html',
  styleUrls: ['./m-p-datos-personales.component.scss'],
  standalone: false,
})
export class MPDatosPersonalesComponent  implements OnInit {
  // Facade
  private readonly facade = inject(RrHhFacade);
  private readonly sunatService = inject(SunatService);

  // Selectores del store
  readonly isLoading = this.facade.loadingDatosPersonales;

  // Font Awesome Icons
  farBook = faBook;
  farInfoCircle = faInfoCircle;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronLeft = faChevronLeft;
  fasChevronRight = faChevronRight;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasCloudArrowUp = faCloudArrowUp;
  fasDownload = faDownload;
  fasSearch = fasSearchIcon;
  fasEdit = faEdit;
  fasPlusCircle = faPlusCircle;
  fasRotateRight = faRotateRight;
  fasXmark = faXmark;


  countries= ALL_COUNTRIES;
  pais= this.countryService.getCountryCode();
  ubicacionpais= this.countries.find(ubi => ubi.codigo === this.pais)?.divisionesterritoriales || [];
  regimensalud='';
  @ViewChild('scrollBox', { read: ElementRef }) scrollBox!: ElementRef;
  logoPreview: string | null = null;
  selectedFileName: string = '';
  documentoIdentidad: File | null = null;
  curriculumVitae: File | null = null;
  contrato: File | null = null;
  tabSeleccionadoDetalle: string = 'general';
  panelLateralVisible: boolean = true;
  camponuevo: boolean = false;
  filaSeleccionada: any = null;

  private gridApi!: GridApi;
  private gridApiHistorial!: GridApi;
  private gridApiEquipamiento!: GridApi;

  // Configuración del calendario de rango
  startDate: Date = new Date(new Date().getFullYear(), new Date().getMonth(), 1);
  endDate: Date = new Date();
  minDate: Date = new Date(2020, 0, 1);
  maxDate: Date = new Date();

  datosEmpleadoForm!: FormGroup;

  columnTypes = {
    currency: { 
        width: 150,
    },
    shaded: {
        cellClass: 'shaded-class'
    }
  };
  gridOptions: GridOptions = {
    defaultColDef: {
      resizable: true,
      sortable: true,
      filter: true
    },
    pagination: true,
    paginationPageSize: 10,
    domLayout: 'autoHeight'
  };
  localeText = {
    page: 'Página',
    of: 'de',
    to: 'a',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    noRowsToShow: 'No hay filas para mostrar',
    loadingOoo: 'Cargando...'
  };
  getRowClass = (params: any) => {
    const data = params.data;
    if (data.tipoAccion == 'Sanción') {
      return 'row-parcial-blink';
    }
    return '';
  };
  
  // Arrays para ubicación con jerarquía: País > Departamento > Provincia > Distrito
  paises: any[] = [
    { nombre: 'Perú',
      departamentos: [
        { nombre: 'Piura',
          provincias: [
            { nombre: 'Piura',
              distritos: ['Piura', 'Catacaos', 'Veintiséis de Octubre']},
            { nombre: 'Sullana',
              distritos: ['Sullana', 'Bellavista', 'Marcavelica']}
          ]},
        { nombre: 'Lima',
          provincias: [
            { nombre: 'Lima',
              distritos: ['Miraflores', 'San Isidro', 'Barranco', 'Surco', 'San Borja']},
            { nombre: 'Barranca',
              distritos: ['Barranca', 'Supe', 'Huacho', 'Végueta']},
            { nombre: 'Cañete',
              distritos: ['Cañete', 'San Vicente', 'Chincha Alta']}
          ]},
        { nombre: 'Arequipa',
          provincias: [
            { nombre: 'Arequipa',
              distritos: ['Arequipa', 'Cercado', 'Mariscal Castilla', 'Paucarpata']},
            { nombre: 'Islay',
              distritos: ['Mollendo', 'Matarani', 'Cocachacra']}
          ]},
        { nombre: 'Cusco',
          provincias: [
            { nombre: 'Cusco',
              distritos: ['Cusco', 'San Sebastián', 'San Blas', 'Wanchaq']}
          ]}
      ]},
    { nombre: 'Argentina',
      departamentos: [
        { nombre: 'Buenos Aires',
          provincias: [
            { nombre: 'Buenos Aires',
              distritos: ['La Plata', 'Berazategui', 'Quilmes']}
          ]}
      ]},
    { nombre: 'Chile',
      departamentos: [
        { nombre: 'Santiago',
          provincias: [
            { nombre: 'Santiago',
              distritos: ['Santiago Centro', 'Providencia', 'Las Condes']}
          ]}
      ]}
  ];

  departamentos: any = [];
  provincias: any = [];
  distritos: any = [];

  cargos = [
    { value: 'cocinero', nombre: 'Cocinero' },
    { value: 'mesero', nombre: 'Mesero' },
    { value: 'administrador', nombre: 'Administrador' },
    { value: 'bartender', nombre: 'Bartender' },
    { value: 'chef', nombre: 'Chef' },
    { value: 'ayudante_cocina', nombre: 'Ayudante de cocina' },
  ];
  // Arrays para selects de formulario
  tiposDocumento: any = [];

  estados=[
    'Activo',
    'Inactivo'
  ]
  generos = [
    { value: 'masculino', label: 'Masculino' },
    { value: 'femenino', label: 'Femenino' }
  ];

  tiposContrato = [
    { value: 'temporada', label: 'De temporada' },
    { value: 'exportacion_no_tradicional', label: 'De exportación no tradicional' },
    { value: 'extranjero_dl_689', label: 'De extranjero - Decreto Legislativo 689' },
    { value: 'domicilio', label: 'A domicilio' },
    { value: 'futbolistas', label: 'Futbolistas profesionales' },
    { value: 'migrante_andino', label: 'Migrante andino' },
    { value: 'otros', label: 'Otros no previstos' },
    { value: 'plazo_determinado_dl_728', label: 'A plazo determinado, Decreto Legislativo 728' },
    { value: 'tiempo_parcial', label: 'A tiempo parcial' },
    { value: 'inicio_incremento', label: 'Por inicio o incremento de actividades' },
    { value: 'necesidad_mercado', label: 'Por necesidad del mercado' },
    { value: 'reconversion', label: 'Por reconversión empresarial' },
    { value: 'ocasional', label: 'Ocasional' },
    { value: 'suplencia', label: 'De suplencia' },
    { value: 'emergencia', label: 'De emergencia' }
  ];

  jornadasLaborales = [
    { value: 'trabajo_maximo', label: 'Trabajo máximo' },
    { value: 'atipica_acumulativa', label: 'Atípica o acumulativa' },
    { value: 'horario_nocturno', label: 'Horario nocturno' }
  ];

  modalidades = [
    { value: 'presencial', label: 'Presencial' },
    { value: 'remoto', label: 'Remoto' },
    { value: 'hibrido', label: 'Híbrido' }
  ];

  regimenesSalud = [
    { value: 'essalud_regular', label: 'EsSalud regular' },
    { value: 'essalud_regular_eps', label: 'EsSalud regular y EPS' }
  ];

  regimenesPensionarios = [
    { value: 'onp', label: 'Sistema nacional de pensiones / ONP' },
    { value: 'integra', label: 'Integra' },
    { value: 'horizonte', label: 'Horizonte' },
    { value: 'profuturo', label: 'Profuturo' },
    { value: 'prima', label: 'Prima' },
    { value: 'habitat', label: 'Hábitat' }
  ];

  monedas = [
    { value: 'soles', label: 'Soles' },
    { value: 'dolares', label: 'Dólares' }
  ];

  periodicidadesPago = [
    { value: 'diaria', label: 'Diaria' },
    { value: 'semanal', label: 'Semanal' },
    { value: 'quincenal', label: 'Quincenal' },
    { value: 'mensual', label: 'Mensual' }
  ];

  formasDePago = [
    { value: 'cheque', label: 'Cheque' },
    { value: 'transferencia', label: 'Transferencia' },
    { value: 'efectivo', label: 'Efectivo' }
  ];
  
  centrosCostos = [
    { codigo: 'AC01', nombre: 'AC01 - Administración', porcentaje: '10%' },
    { codigo: 'AC02', nombre: 'AC02 - Ventas', porcentaje: '10%' },
    { codigo: 'AC03', nombre: 'AC03 - Producción', porcentaje: '10%' },
    { codigo: 'AC04', nombre: 'AC04 - Logística', porcentaje: '10%' },
    { codigo: 'AC05', nombre: 'AC05 - Finanzas', porcentaje: '10%' }
  ];

  sucursales = [
    { codigo: 'SUC-001', nombre: 'Lima Centro' },
    { codigo: 'SUC-002', nombre: 'Lima Norte' },
    { codigo: 'SUC-003', nombre: 'Miraflores' },
    { codigo: 'SUC-004', nombre: 'San Isidro' },
    { codigo: 'SUC-005', nombre: 'Surco' }
  ];
  
  // Configuración del AG-Grid para historial de cambios
  columnDefsHistorial: ColDef[] = [
    { headerName: 'Fecha', field: 'fecha', width: 120,
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate() +1).padStart(2, '0');
        return `${day}/${month}/${year}`;
      }
    },
    { headerName: 'Tipo de acción', field: 'tipoAccion', width: 150},
    { headerName: 'Cargo anterior', field: 'cargoAnterior', minWidth: 150, flex: 1},
    { headerName: 'Nuevo cargo', field: 'nuevoCargo', minWidth: 150, flex: 1},
    { headerName: 'Remuneración', field: 'empleado_remuneracion', width: 130, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center' },
      valueFormatter: (params: any) => {
        if (params.value){
          return `S/ ${parseFloat(params.value).toFixed(2)}`;
        } else{
          return '-';
        };
      },
    },
    { headerName: 'Documento asociado', field: 'documentoAsociado' , width: 180,
      cellRenderer: DocumentCellrendererComponent
    },
    { headerName: 'Acciones', width: 80, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
       cellRenderer: AccionesEyeCellrendererComponent, }
  ];

  rowDataHistorial: any[] = [];
  
  // Configuración del AG-Grid para equipamiento
  columnDefsEquipamiento: ColDef[] = [
    {  headerName: 'Fecha de asignación',  field: 'fechaAsignacion', width: 130,
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate() +1).padStart(2, '0');
        return `${day}/${month}/${year}`;
      }
    },
    {  headerName: 'Tipo de elemento',  field: 'tipoElemento', width: 130, filter: true},
    {  headerName: 'Descripción',  field: 'descripcion', minWidth: 250, flex: 1 },
    {  headerName: 'Cantidad',  field: 'cantidad', width: 100,},
    {  headerName: 'Responsable de entrega',  field: 'responsableEntrega', width: 200,},
    {  headerName: 'Estado',  field: 'empleado_estado', width: 100, filter: true,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        
        switch(estado) {
          case 'Asignado':
            badgeClass = 'bg-green-100 text-green-600';
            break;
          case 'Devuelto':
            badgeClass = 'bg-blue-100 text-blue-600';
            break;
          case 'En mantenimiento':
            badgeClass = 'bg-yellow-100 text-yellow-600';
            break;
          default:
            badgeClass = 'bg-[#F5F5F5] text-[#363636]';
        }
        
        return `
        <div class="badge-table ${badgeClass}"> 
        <span class="">${estado}</span>
        </div>`;
      }
    },
    { headerName: 'Documento asociado', field: 'documentoAsociado' , width: 150,
      cellRenderer: DocumentCellrendererComponent
    },
    {  headerName: 'Acciones', width: 80, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: AcciEditEliminarComponent,
    }
  ];

  rowDataEquipamiento: any[] = [];

  // Configuración del AG-Grid
  columnDefs: ColDef[] = [
    { headerName: 'Cód. de empleado', field: 'empleado_codigo', width: 100},
    { headerName: 'Nombres y apellidos', field: 'empleado_nombres_apellidos', minWidth: 150, flex: 1},
    { headerName: 'Tipo de documento', field: 'empleado_tipo_documento', width: 100,
      cellStyle: { textTransform: 'uppercase'},
    },
    { headerName: 'Documento', field: 'empleado_documento', width: 100},
    { headerName: 'Fecha de inicio', field: 'empleado_fecha_inicio', width: 100,
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate() +1).padStart(2, '0');
        return `${day}/${month}/${year}`;
      }
    },
    { headerName: 'Fecha de fin', field: 'empleado_fecha_fin', width: 100,
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate() +1).padStart(2, '0');
        return `${day}/${month}/${year}`;
      }
    },
    { headerName: 'Tipo de contrato', field: 'empleado_tipo_contrato', width: 100},
    { headerName: 'Cargo', field: 'empleado_cargo', width: 100, filter: true},
    { headerName: 'Sucursal', field: 'empleado_sucursal', width: 130, filter: true},
    { headerName: 'Estado', field: 'empleado_estado', width: 90, headerClass: 'centrarencabezado' ,filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
        } else if (params.value === 'Inactivo') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>';
        }
        return params.value;
      },
    }
  ];

  rowData: DatosPersonalesEntity[] = [];
  isResetting = false;

  get cuentasBancariasControl() {
    return this.datosEmpleadoForm.get('cuentasBancarias');
  }

  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController,
    private formValidationService: FormValidationService,
    private countryService: CountryService,

  ) {
    this.docpais();
    this.inicializarFormulario();
  }

  ngOnInit() {
    this.ubicaciongeografica();
    this.cargarEquipamiento();
    // this.cargarHistorial();

    // Inicializar el servicio de validación con el formulario
    this.formValidationService.inicializarFormulario(this.datosEmpleadoForm);

    // Cargar datos personales desde el JSON a través de la capa de infraestructura
    this.facade.cargarDatosPersonales();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.rowData = [...this.facade.datosPersonales()];
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', this.rowData);
        }
        // Restaurar fila seleccionada si existe (al volver a la pantalla)
        if (this.filaSeleccionada) {
          const codigo = this.filaSeleccionada.empleado_codigo;
          setTimeout(() => {
            this.gridApi?.forEachNode((node) => {
              if (node.data?.empleado_codigo === codigo) {
                node.setSelected(true);
              }
            });
          }, 0);
        }
      }
    }, 100);
  }
 
  togglePanel(){
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  onPaisChange(event: any) {
    const paisSeleccionado = event.detail.value;
    const pais = this.paises.find((p: any) => p.nombre === paisSeleccionado);
    
    if (pais) {
      this.departamentos = pais.departamentos;
      this.provincias = [];
      this.distritos = [];
      this.datosEmpleadoForm.get('empleado_departamento')?.reset();
      this.datosEmpleadoForm.get('empleado_provincia')?.reset();
      this.datosEmpleadoForm.get('empleado_distrito')?.reset();
    }
  }

  onDepartamentoChange(event: any){
    const departamentoSeleccionado = event.detail.value;
    const departamento = this.departamentos.find((d: any) => d.nombre === departamentoSeleccionado);
    
    if (departamento) {
      this.provincias = departamento.provincias;
      this.distritos = [];
      this.datosEmpleadoForm.get('empleado_provincia')?.reset();
      this.datosEmpleadoForm.get('empleado_distrito')?.reset();
    }
  }

  onProvinciaChange(event: any) {
    const provinciaSeleccionada = event.detail.value;
    const provincia = this.provincias.find((p: any) => p.nombre === provinciaSeleccionada);
    
    if (provincia) {
      this.distritos = provincia.distritos;
      this.datosEmpleadoForm.get('empleado_distrito')?.reset();
    }
  }
  ubicaciongeografica(){
    if(this.pais === 'PE'){
      this.departamentos= this.countries.find(c => c.codigo === this.pais)?.departamentos || [];
        console.log('departamento seleccionado', this.datosEmpleadoForm.get('empleado_departamento')?.value);
      if(this.datosEmpleadoForm.get('empleado_departamento')?.value === this.departamentos[0]?.value){
      }
    }
  }
  docpais(){
   const country = this.countries.find(
    c => c.codigo === this.countryService.getCountryCode()
    );
    this.countries.find(c => {
      if(c.codigo === country?.codigo){
        c.personalidadfiscal?.find(tip => {
          this.tiposDocumento.push({value: tip.value, label: tip.nombre , numero: tip.numero})
        })
        this.regimensalud= country?.regimendesalud || '';
        this.jornadasLaborales= [];
        this.jornadasLaborales= country?.jornadasLaborales || [];
        this.regimenesSalud= [];
        this.regimenesSalud= country?.regimenesdesalud || [];
      }
    })    
  }
  private inicializarFormulario() {
    this.datosEmpleadoForm = this.formBuilder.group({
      // Datos personales
      empleado_codigo: [''], 
      empleado_tipo_documento: [this.tiposDocumento[0]?.value, Validators.required],
      empleado_documento: ['',Validators.required],
      empleado_nombres_apellidos: ['', Validators.required],
      empleado_fecha_nacimiento: ['', Validators.required],
      empleado_sexo: ['', Validators.required],
      empleado_nacionalidad: ['', Validators.required],
      
      // Ubicación
      empleado_pais: [''],
      empleado_departamento: [''],
      empleado_provincia: [''],
      empleado_distrito: [''],
      empleado_direccion: [''],
      
      // Contacto privado
      empleado_telefono_privado: [''],
      empleado_correo_privado: [''],
      
      // Contacto de emergencia
      empleado_contacto_emergencia_nombre: [''],
      empleado_contacto_emergencia_telefono: [''],
      
      // Información del empleado
      empleado_tipo_contrato: [''],
      empleado_sucursal: [''],
      empleado_jornada: [''],
      empleado_modalidad: [''],
      empleado_cargo: [''],
      empleado_centro_costos: [''],
      empleado_fecha_inicio: [''],
      empleado_fecha_fin: [''],
      empleado_estado: ['Activo'],
      
      // Beneficios y remuneración
      empleado_regimen_salud: [''],
      empleado_regimen_pensionario: [''],
      empleado_moneda: ['soles'],
      empleado_remuneracion: [''],
      empleado_periodicidad_pago: [''],
      
      // Carga familiar
      cargaFamiliar: ['No'],
      
      // Forma de pago
      formaPago: [''],
      
      // Cuentas bancarias (FormArray)
      cuentasBancarias: this.formBuilder.array([])
    });
  }

  filtrarPorFechas(event: any) {
    console.log('Rango de fechas seleccionado:', event);
    // Aquí puedes implementar la lógica de filtrado
  }
  onCentroCostoSeleccionado(evento: any) {
    if (evento && evento.nombre) {
      this.datosEmpleadoForm.patchValue({
        empleado_centro_costos: evento.nombre
      });
    }
  }

  onSucursalSeleccionada(evento: any) {
    if (evento && evento.nombre) {
      this.datosEmpleadoForm.patchValue({
        empleado_sucursal: evento.nombre
      });
    }
  }

  cargarDatos() {
    // Datos de ejemplo con campos obligatorios completos
    this.rowData = [
      { empleado_codigo: 'EMP-003', empleado_nombres_apellidos: 'Carlos Rodríguez Díaz', empleado_tipo_documento: 'dni', empleado_documento: '45678901', empleado_fecha_nacimiento: '1985-05-15', empleado_sexo: 'masculino', empleado_nacionalidad: 'Perú', empleado_pais: 'Perú', empleado_departamento: 'Lima', empleado_provincia: 'Lima', empleado_distrito: 'Miraflores', empleado_direccion: 'Av. Larco 123, Miraflores', empleado_telefono_privado: '987654321', empleado_correo_privado: 'carlos@email.com', empleado_contacto_emergencia_nombre: 'Ana Rodríguez', empleado_contacto_emergencia_telefono: '987654322', empleado_fecha_inicio: '2023-06-01', empleado_fecha_fin: '2026-06-01', empleado_tipo_contrato: 'Indefinido', empleado_cargo: 'Chef', empleado_sucursal: 'Lima Centro', empleado_jornada: 'trabajo_maximo', empleado_modalidad: 'presencial', empleado_centro_costos: 'AC03 - Producción', empleado_regimen_salud: 'essalud_regular', empleado_regimen_pensionario: 'integra', empleado_moneda: 'soles', empleado_remuneracion: '2500.00', empleado_periodicidad_pago: 'mensual', empleado_estado: 'Activo' },
      { empleado_codigo: 'EMP-002', empleado_nombres_apellidos: 'María López Sánchez', empleado_tipo_documento: 'dni', empleado_documento: '87654321', empleado_fecha_nacimiento: '1990-08-22', empleado_sexo: 'femenino', empleado_nacionalidad: 'Perú', empleado_pais: 'Perú', empleado_departamento: 'Lima', empleado_provincia: 'Lima', empleado_distrito: 'San Isidro', empleado_direccion: 'Calle Los Pinos 456, San Isidro', empleado_telefono_privado: '987654323', empleado_correo_privado: 'maria@email.com', empleado_contacto_emergencia_nombre: 'Juan López', empleado_contacto_emergencia_telefono: '987654324', empleado_fecha_inicio: '2022-03-10', empleado_fecha_fin: '2024-03-10', empleado_tipo_contrato: 'Plazo fijo', empleado_cargo: 'Mesera', empleado_sucursal: 'Lima Norte', empleado_jornada: 'atipica_acumulativa', empleado_modalidad: 'presencial', empleado_centro_costos: 'AC02 - Ventas', empleado_regimen_salud: 'essalud_regular_eps', empleado_regimen_pensionario: 'prima', empleado_moneda: 'soles', empleado_remuneracion: '1800.00', empleado_periodicidad_pago: 'quincenal', empleado_estado: 'Inactivo' },
      { empleado_codigo: 'EMP-001', empleado_nombres_apellidos: 'Juan Pérez García', empleado_tipo_documento: 'dni', empleado_documento: '12345678', empleado_fecha_nacimiento: '1988-03-10', empleado_sexo: 'masculino', empleado_nacionalidad: 'Perú', empleado_pais: 'Perú', empleado_departamento: 'Lima', empleado_provincia: 'Lima', empleado_distrito: 'Surco', empleado_direccion: 'Av. Paseo de la República 789, Surco', empleado_telefono_privado: '987654325', empleado_correo_privado: 'juan@email.com', empleado_contacto_emergencia_nombre: 'Patricia García', empleado_contacto_emergencia_telefono: '987654326', empleado_fecha_inicio: '2023-01-15', empleado_fecha_fin: '2025-12-31', empleado_tipo_contrato: 'Indefinido', empleado_cargo: 'Cocinero', empleado_sucursal: 'Lima Centro', empleado_jornada: 'trabajo_maximo', empleado_modalidad: 'presencial', empleado_centro_costos: 'AC03 - Producción', empleado_regimen_salud: 'essalud_regular', empleado_regimen_pensionario: 'horizonte', empleado_moneda: 'soles', empleado_remuneracion: '2200.00', empleado_periodicidad_pago: 'mensual', empleado_estado: 'Activo' },
    ];
  }

  cargarHistorial() {
    // Datos de ejemplo para el historial de cambios
    this.rowDataHistorial = [
      { fecha: '2024-01-15', tipoAccion: 'Cambio de puesto', cargoAnterior: 'Ayudante de cocina', nuevoCargo: 'Cocinero', empleado_remuneracion: '1800.00', documentoAsociado: 'carta de ascenso'},
      { fecha: '2023-07-01', tipoAccion: 'Sanción', cargoAnterior: '-', nuevoCargo: '-', empleado_remuneracion: '', documentoAsociado: 'memorando'},
      { fecha: '2023-03-10', tipoAccion: 'Renovación', cargoAnterior: '-', nuevoCargo: 'Ayudante de cocina', empleado_remuneracion: '1025.00', documentoAsociado: 'contrato'},
    ];
  }

  agregarAlHistorial(tipoAccion: string, datos: any) {
    const hoy = new Date().toISOString().split('T')[0];
    let nuevoRegistro: any = {
      fecha: hoy,
      tipoAccion: tipoAccion,
    };

    // Procesar datos según el tipo de acción
    switch(tipoAccion) {
      case 'Renovación':
        nuevoRegistro = {
          ...nuevoRegistro,
          cargoAnterior: '-',
          nuevoCargo: datos.empleado_cargo || '-',
          empleado_remuneracion: datos.empleado_remuneracion || '',
          documentoAsociado: datos.doct || 'contrato'
        };
        break;
      case 'Cambio de puesto':
        nuevoRegistro = {
          ...nuevoRegistro,
          cargoAnterior: this.filaSeleccionada?.empleado_cargo || 'Maquetador',
          nuevoCargo: datos.nuevoCargo || '-',
          empleado_remuneracion: datos.empleado_remuneracion || '',
          documentoAsociado: datos.doct || 'carta de cambio'
        };
        break;
      case 'Sanción':
        nuevoRegistro = {
          ...nuevoRegistro,
          cargoAnterior: '-',
          nuevoCargo: '-',
          empleado_remuneracion: '',
          documentoAsociado: datos.doct || 'memorando'
        };
        break;
    }

    // Agregar el nuevo registro al inicio del historial
    this.rowDataHistorial = [nuevoRegistro, ...this.rowDataHistorial];
    
    // Actualizar la vista de AG-Grid
    this.gridApiHistorial?.applyTransaction({ add: [nuevoRegistro], addIndex: 0 });
    
    console.log('Registro agregado al historial:', nuevoRegistro);
  }

  cargarEquipamiento() {
    // Datos de ejemplo para el equipamiento asignado al empleado
    this.rowDataEquipamiento = [
      { fechaAsignacion: '2024-03-15', tipoElemento: 'Uniforme', descripcion: 'Uniforme de cocina completo (chaqueta, pantalón, gorro)', cantidad: 2, responsableEntrega: 'Carlos Zapata', empleado_estado: 'Asignado'},
      { fechaAsignacion: '2024-03-15', tipoElemento: 'Calzado', descripcion: 'Zapatos antideslizantes negros talla 42', cantidad: 1, responsableEntrega: 'Carlos Zapata', empleado_estado: 'Asignado'},
      { fechaAsignacion: '2024-03-20', tipoElemento: 'Herramientas', descripcion: 'Juego de cuchillos profesionales', cantidad: 1, responsableEntrega: 'Ana Méndez', empleado_estado: 'Asignado'},
      { fechaAsignacion: '2024-02-10', tipoElemento: 'Uniforme', descripcion: 'Delantal de cocina', cantidad: 1, responsableEntrega: 'Carlos Zapata', empleado_estado: 'Devuelto'},
    ];
  }
  
  scrollLeft() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: -150, behavior: 'smooth' });
  }

  scrollRight() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: 150, behavior: 'smooth' });
  }
  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      // Validar que sea una imagen
      if (file.type.startsWith('image/')) {
        this.selectedFileName = file.name;
        
        // Leer el archivo y crear una vista previa
        const reader = new FileReader();
        reader.onload = (e: any) => {
          this.logoPreview = e.target.result;
        };
        reader.readAsDataURL(file);
        console.log('Archivo seleccionado:', file.name);
      } else {
        console.error('Por favor selecciona un archivo de imagen válido (JPG, PNG)');
        // Aquí podrías mostrar un toast de error
      }
    }
  }
  onTipoContratoSeleccionado(tipo:any){

  }

  removeImage() {
    this.logoPreview = null;
    this.selectedFileName = '';
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
        { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: `Se ha creado el registro del empleado ${this.filaSeleccionada.empleado_codigo}`,},
        { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Se ha actualizado el correo del empleado',},
        { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio:   'Se actualizó el historial laboral del emplado',},
      ];
      
      const modal = await this.modalController.create({
        component: ModalVerActualizacionesComponent,
        cssClass: 'promo',
        componentProps: {
          titulo: `Historial de actualizaciones del empleado ${this.filaSeleccionada.empleado_codigo}`,
          rowData: rowData,
          colDefs: colDefs,
          anchoModal: '700px',
    
        },
      });
      
      await modal.present();
    }

  // Métodos para el componente de carga de documentos
  onDocumentoIdentidadSelected(file: File) {
    this.documentoIdentidad = file;
    console.log('Documento de identidad seleccionado:', file.name);
    // Aquí puedes agregar lógica adicional como subir el archivo al servidor
  }

  onDocumentoIdentidadRemoved() {
    this.documentoIdentidad = null;
    console.log('Documento de identidad removido');
  }

  onCurriculumSelected(file: File) {
    this.curriculumVitae = file;
    console.log('Curriculum vitae seleccionado:', file.name);
    // Aquí puedes agregar lógica adicional como subir el archivo al servidor
  }

  onCurriculumRemoved() {
    this.curriculumVitae = null;
    console.log('Curriculum vitae removido');
  }

  onContratoSelected(file: File) {
    this.contrato = file;
    console.log('Contrato seleccionado:', file.name);
    // Aquí puedes agregar lógica adicional como subir el archivo al servidor
  }

  onContratoRemoved() {
    this.contrato = null;
    console.log('Contrato removido');
  }

  showFileError(errorMessage: string) {
    console.error('Error de archivo:', errorMessage);
    // Aquí puedes mostrar un toast o mensaje de error al usuario
    // Por ejemplo: this.toastService.showError(errorMessage);
  }

  onBtReset() {
    this.isResetting = true;
    this.facade.cargarDatosPersonales();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.rowData = [...this.facade.datosPersonales()];
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', this.rowData);
        }
        this.isResetting = false;
      }
    }, 100);
  }
  
  async abrirmodalequipamiento(data: any, modo: boolean) {
    const modal= await this.modalController.create({
      component: ModalAgregarEquipamientoComponent,
      cssClass: 'promo2',
      componentProps: {
        esEdicion: modo,
        data: data,
      },
    })
    await modal.present();
    
    // Capturar datos del modal cuando se cierra
    const { data: resultado } = await modal.onDidDismiss();
    console.log('Resultado del modal equipamiento:', resultado);
    if (resultado) {
      if (modo) {
        // Edición: actualizar el registro
        const index = this.rowDataEquipamiento.findIndex((item: any) => item.fechaAsignacion === data.fechaAsignacion);
        if (index !== -1) {
          this.rowDataEquipamiento[index] = resultado;
          // Forzar actualización del grid
          this.rowDataEquipamiento = [...this.rowDataEquipamiento];
          console.log('Equipamiento actualizado:', resultado);
        }
      } else {
        // Creación: agregar nuevo registro
        this.rowDataEquipamiento = [...this.rowDataEquipamiento, resultado];
        console.log('Equipamiento agregado:', resultado);
      }
    } else {
      console.log('No se retornaron datos del modal');
    }
  }

  async onVerDocumento(data: any) {
    // Aquí puedes abrir un modal con el documento o descargarlo
    const modal = await this.modalController.create({
      component: ModalVerDocumentoComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `${data.documentoAsociado}`,
      },
    });

    await modal.present();
  }

  onVerDetalle(data: any) {
    if (data.tipoAccion == 'Renovación') {
      this.ModalRenovarContrato(data);
    } else if (data.tipoAccion == 'Cambio de puesto') {
      this.ModalCambioPuesto(data);
    } else if (data.tipoAccion == 'Sanción') {
      this.ModalRegistrarSancion(data);
    }

  }

  async ModalRenovarContrato(data: any) {
    // Lógica para abrir el modal 
    const modal= await this.modalController.create({
      component: ModalRenovarContratoComponent,
      cssClass: 'promo2',
      componentProps: {
        data: data,
        tipos: this.tiposContrato,
      },
    })
    await modal.present();
    
    // Capturar datos del modal cuando se cierra
    const { data: resultado } = await modal.onDidDismiss();
    if (resultado) {
      this.agregarAlHistorial('Renovación', resultado);
    }
  }

  async ModalCambioPuesto(data: any) {
    // Lógica para abrir el modal 
    const modal= await this.modalController.create({
      component: ModalCambiarPuestoComponent,
      cssClass: 'promo2',
      componentProps: {
        data: data,
        cargos: this.cargos,
        centrosCostos: this.centrosCostos,
      },
    })
    await modal.present();
    
    // Capturar datos del modal cuando se cierra
    const { data: resultado } = await modal.onDidDismiss();
    if (resultado) {
      this.agregarAlHistorial('Cambio de puesto', resultado);
    }
  }

  async ModalRegistrarSancion(data: any) {
    // Lógica para abrir el modal 
    const modal= await this.modalController.create({
      component: ModalSancionComponent,
      cssClass: 'promo2',
      componentProps: {
        data: data,
      },
    })
    await modal.present();
    
    // Capturar datos del modal cuando se cierra
    const { data: resultado } = await modal.onDidDismiss();
    if (resultado) {
      this.agregarAlHistorial('Sanción', resultado);
    }
  }

  onEditar(data: any) {
    this.abrirmodalequipamiento( data, true);
  }

  oneliminar(data: any) {
    console.log('Eliminar empleado', data);
    // Aquí puedes implementar la lógica para eliminar el equipamiento 
  }

async onCellClicked(event: any) {
    const data = event.data;
    if (!data) return;

    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios({
      titulo: 'Cambios sin guardar',
      mensaje: '¿Deseas continuar sin guardar los cambios realizados?',
      submensaje: 'Si continúas, perderás toda la información modificada del empleado actual',
      btnConfirmar: 'Continuar',
      btnCancelar: 'Cancelar'
    });

    if (!confirmar) {
      // Restaurar selección anterior
      if (this.filaSeleccionada) {
        const prevCodigo = this.filaSeleccionada.empleado_codigo;
        setTimeout(() => {
          this.gridApi?.deselectAll();
          this.gridApi?.forEachNode((node) => {
            if (node.data?.empleado_codigo === prevCodigo) {
              node.setSelected(true);
            }
          });
        }, 0);
      }
      return;
    }

    // Cargar datos del registro seleccionado
    this.cargarDatosRegistro(data);
    this.cargarHistorial();
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: any): void {
    this.camponuevo = false;
    this.filaSeleccionada = data;

    console.log('Datos seleccionados:', data);
    console.log('FormGroup antes de patchValue:', this.datosEmpleadoForm.value);

    // Pausar detección de cambios mientras se cargan datos
    this.formValidationService.pausarDeteccion();

    // Seleccionar el nodo en AG-Grid usando setTimeout para evitar referencias obsoletas
    const selectedCodigo = data.empleado_codigo;
    setTimeout(() => {
      this.gridApi?.deselectAll();
      this.gridApi?.forEachNode((n) => {
        if (n.data?.empleado_codigo === selectedCodigo) {
          n.setSelected(true);
        }
      });
    }, 0);

    // Llenar los campos del formulario con los datos de la fila
    this.datosEmpleadoForm.patchValue({
      empleado_codigo: data.empleado_codigo || '',
      empleado_tipo_documento: data.empleado_tipo_documento || 'DNI',
      empleado_documento: data.empleado_documento || '',
      empleado_nombres_apellidos: data.empleado_nombres_apellidos || '',
      empleado_fecha_nacimiento: data.empleado_fecha_nacimiento || '',
      empleado_sexo: data.empleado_sexo || '',
      empleado_nacionalidad: data.empleado_nacionalidad || '',
      empleado_pais: data.empleado_pais || 'Perú',
      empleado_departamento: data.empleado_departamento || 'Lima',
      empleado_provincia: data.empleado_provincia || '',
      empleado_distrito: data.empleado_distrito || '',
      empleado_direccion: data.empleado_direccion || '',
      empleado_telefono_privado: data.empleado_telefono_privado || '',
      empleado_correo_privado: data.empleado_correo_privado || '',
      empleado_contacto_emergencia_nombre: data.empleado_contacto_emergencia_nombre || '',
      empleado_contacto_emergencia_telefono: data.empleado_contacto_emergencia_telefono || '',
      empleado_tipo_contrato: data.empleado_tipo_contrato || '',
      empleado_jornada: data.empleado_jornada || '',
      empleado_modalidad: data.empleado_modalidad || '',
      empleado_cargo: data.empleado_cargo || '',
      empleado_centro_costos: data.empleado_centro_costos || '',
      empleado_fecha_inicio: data.empleado_fecha_inicio || '',
      empleado_fecha_fin: data.empleado_fecha_fin || '',
      empleado_regimen_salud: data.empleado_regimen_salud || '',
      empleado_regimen_pensionario: data.empleado_regimen_pensionario || '',
      empleado_moneda: data.empleado_moneda || 'soles',
      empleado_remuneracion: data.empleado_remuneracion || '',
      empleado_periodicidad_pago: data.empleado_periodicidad_pago || ''
    });
    
    console.log('FormGroup después de patchValue:', this.datosEmpleadoForm.value);

    // Reanudar detección de cambios y resetear estado
    this.formValidationService.reanudarDeteccion();
  }
  async botonNuevoEmpleado(){
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios({
      titulo: 'Nuevo empleado',
      mensaje: '¿Deseas crear un nuevo registro de empleado?',
      submensaje: 'Si continúas, se borrarán los cambios del empleado actual',
      btnConfirmar: 'Crear nuevo',
      btnCancelar: 'Cancelar'
    });
    
    if (!confirmar) {
      return; // Cancelar acción
    }

    this.camponuevo = true;
    this.filaSeleccionada = null; // Limpiar la fila seleccionada
    this.gridApi?.deselectAll(); // Deseleccionar filas en la tabla
    this.datosEmpleadoForm.reset({
      empleado_tipo_documento: this.tiposDocumento[0]?.value,
      empleado_pais: 'Perú',
      empleado_departamento: 'Lima',
      empleado_moneda: 'soles'
    });

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }
  buscarEmpleado() {
    const documento = this.datosEmpleadoForm.get('empleado_documento')?.value;
    if (!documento) return;

    this.sunatService.consultarDni(documento).subscribe({
      next: (res) => {
        this.datosEmpleadoForm.patchValue({
          empleado_nombres_apellidos: res.nombreCompleto,
          // empleado_fecha_nacimiento: res.fechaNacimiento,
          // empleado_sexo: res.sexo,
          // empleado_nacionalidad: res.nacionalidad,
        });
        this.toastService.success('Datos encontrados correctamente');
      },
      error: () => {
        this.toastService.warning('No se encontraron datos para el documento ingresado');
      }
    });
  }

  botonGuardar(){
    // Validar que el formulario sea válido
    if (this.datosEmpleadoForm.invalid) {
      this.toastService.warning("Por favor, completa todos los campos requeridos");
      console.log('Formulario inválido:', this.datosEmpleadoForm.errors);
      return;
    }

    const formValues = this.datosEmpleadoForm.value;
    
    // Crear objeto con los datos del formulario
    const empleadoData = {
      empleado_codigo: this.filaSeleccionada?.empleado_codigo || this.generarNuevoCodigo(),
      empleado_tipo_documento: formValues.empleado_tipo_documento,
      empleado_documento: formValues.empleado_documento,
      empleado_nombres_apellidos: formValues.empleado_nombres_apellidos,
      empleado_fecha_nacimiento: formValues.empleado_fecha_nacimiento,
      empleado_sexo: formValues.empleado_sexo,
      empleado_nacionalidad: formValues.empleado_nacionalidad,
      empleado_pais: formValues.empleado_pais,
      empleado_departamento: formValues.empleado_departamento,
      empleado_provincia: formValues.empleado_provincia,
      empleado_distrito: formValues.empleado_distrito,
      empleado_direccion: formValues.empleado_direccion,
      empleado_telefono_privado: formValues.empleado_telefono_privado,
      empleado_correo_privado: formValues.empleado_correo_privado,
      empleado_contacto_emergencia_nombre: formValues.empleado_contacto_emergencia_nombre,
      empleado_contacto_emergencia_telefono: formValues.empleado_contacto_emergencia_telefono,
      empleado_tipo_contrato: formValues.empleado_tipo_contrato,
      empleado_jornada: formValues.empleado_jornada,
      empleado_modalidad: formValues.empleado_modalidad,
      empleado_cargo: formValues.empleado_cargo,
      empleado_centro_costos: formValues.empleado_centro_costos,
      empleado_fecha_inicio: formValues.empleado_fecha_inicio,
      empleado_fecha_fin: formValues.empleado_fecha_fin,
      empleado_regimen_salud: formValues.empleado_regimen_salud,
      empleado_regimen_pensionario: formValues.empleado_regimen_pensionario,
      empleado_moneda: formValues.empleado_moneda,
      empleado_remuneracion: formValues.empleado_remuneracion,
      empleado_periodicidad_pago: formValues.empleado_periodicidad_pago,
      empleado_estado: 'Activo',
      empleado_sucursal: 'Principal' // Por defecto
    };

    let res: RowNodeTransaction | undefined;
    
    // Si es una nueva operación (camponuevo = true O no hay fila seleccionada)
    if (this.camponuevo || !this.filaSeleccionada) {
      // Agregar al inicio del array rowData
      this.rowData.unshift(empleadoData);
      
      // Agregar a la tabla en la parte superior (index: 0)
      res = this.gridApi.applyTransaction({
        add: [empleadoData],
        addIndex: 0
      })!;
      console.log('Nuevo empleado agregado:', empleadoData);
      this.toastService.success("¡Empleado creado exitosamente!");
    } 
    // Si hay una fila seleccionada, es edición
    else if (this.filaSeleccionada) {
      // Actualizar los valores de la fila seleccionada
      Object.assign(this.filaSeleccionada, empleadoData);
      
      res = this.gridApi.applyTransaction({
        update: [this.filaSeleccionada]
      })!;
      console.log('Empleado actualizado');
      this.toastService.success("¡Se guardaron cambios exitosamente!");
    }
    
    // Limpiar formulario y resetear estado
    this.datosEmpleadoForm.reset();
    this.datosEmpleadoForm.patchValue({
      empleado_tipo_documento: this.tiposDocumento[0]?.value,
      empleado_pais: 'Perú',
      empleado_departamento: 'Lima',
      empleado_moneda: 'soles'
    });
    this.filaSeleccionada = null;
    this.camponuevo = false;

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }
  
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // Restaurar la fila seleccionada al volver a la pantalla
    if (this.filaSeleccionada) {
      const codigo = this.filaSeleccionada.empleado_codigo;
      setTimeout(() => {
        this.gridApi?.forEachNode((node) => {
          if (node.data?.empleado_codigo === codigo) {
            node.setSelected(true);
          }
        });
      }, 0);
    }
  }

  onGridHistorialReady(params: GridReadyEvent) {
    this.gridApiHistorial = params.api;
  }

  onGridEquipamientoReady(params: GridReadyEvent) {
    this.gridApiEquipamiento = params.api;
  }

  // Generar código automático para nuevas operaciones
  generarNuevoCodigo(): string {
    const numeros = this.rowData
      .filter(item => item && item.empleado_codigo) // Filtrar items con codigoEmpleado
      .map(item => {
        const match = item.empleado_codigo.match(/EMP-(\d+)/);
        return match ? parseInt(match[1], 10) : 0;
      });
    const maxNumero = numeros.length > 0 ? Math.max(...numeros) : 0;
    const nuevoNumero = (maxNumero + 1).toString().padStart(3, '0');
    return `EMP-${nuevoNumero}`;
  }

  // Manejar selección de fecha de nacimiento
  onFechaNacimientoSelected(date: Date): void {
    if (date) {
      this.datosEmpleadoForm.patchValue({
        empleado_fecha_nacimiento: date
      });
      this.datosEmpleadoForm.get('empleado_fecha_nacimiento')?.markAsTouched();
    }
  }

  // Manejar selección de fecha de inicio
  onFechaInicioSelected(date: Date): void {
    if (date) {
      this.datosEmpleadoForm.patchValue({
        empleado_fecha_inicio: date
      });
      this.datosEmpleadoForm.get('empleado_fecha_inicio')?.markAsTouched();
    }
  }

  // Manejar selección de fecha de fin
  onFechaFinSelected(date: Date): void {
    if (date) {
      this.datosEmpleadoForm.patchValue({
        empleado_fecha_fin: date
      });
      this.datosEmpleadoForm.get('empleado_fecha_fin')?.markAsTouched();
    }
  }
}
