import { Component, OnInit, ElementRef, ViewChild, HostListener, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { AfiliacionFondosPensionEntity } from 'src/app/modules/rrhh/domain/models/afiliacion-fondos-pension.entity';

// Font Awesome Icons
import { faBook, faInfoCircle, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronLeft, faChevronRight, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { th } from 'date-fns/locale';




@Component({
  selector: 'app-afiliacion-fondos-de-pension',
  templateUrl: './afiliacion-fondos-de-pension.component.html',
  styleUrls: ['./afiliacion-fondos-de-pension.component.scss'],
  standalone: false,
})
export class AfiliacionFondosDePensionComponent implements OnInit {
  // Facade
  private readonly rrHhFacade = inject(RrHhFacade);

  // Selectores del store
  readonly afiliacionFondosPensionStore = this.rrHhFacade.afiliacionFondosPension;
  readonly isLoading = this.rrHhFacade.loadingAfiliacionFondosPension;

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
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  pais= this.countryService.getCountryCode();
  countries= ALL_COUNTRIES; 
  simboloMoneda: string = 'S/';
  @ViewChild('scrollBox', { read: ElementRef }) scrollBox!: ElementRef;


  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  panelLateralVisible: boolean = true;
  tabSeleccionado: string = 'informacion';
  cargando = false;

  // Detectar resolución de pantalla
  isXlScreen: boolean = false;
  is3xlScreen: boolean = false;

  @HostListener('window:resize', ['$event'])
  onResize(event?: any) {
    this.isXlScreen = window.innerWidth >= 1280;
    this.is3xlScreen = window.innerWidth >= 1920;
  }


  fechaAfiliacion: Date | undefined;
  fechaCreacion: Date | undefined;

  modoCreacion: boolean = true;
  modoEdicion: boolean = false;
  filaSeleccionada: any = null;

  // Propiedades para controlar visibilidad de campos
  mostrarAfp: boolean = false;
  mostrarEntidad: boolean = false;
  mostrarTasaAporte: boolean = false;

  private gridApi!: GridApi;
  AfiliacionForm!: FormGroup;

  formularioActivo: boolean = true; // Formulario activo por defecto

  estados = [
    'Activo',
    'Inactivo',
  ];
  fondos = [
    'ONP',
    'AFP',
  ];

  tiposC=[
    'Contrato indeterminado',
    'Contrato a plazo fijo',
    'Locación de servicios',
  ];
  afps = [
    'Integra',
    'Horizonte',
    'Profuturo',
    'Prima',
    'Habitat',
  ];

  tabs = [
    { value: 'informacion', label: 'Información de beneficios' },
    { value: 'afiliacion_fondo_pension_retenciones', label: 'Retenciones' },
    { value: 'afiliacion_fondo_pension_aportes', label: 'Aportes' },
  ];

  beneciciosAsociados: any = []

  retencionesTrabajador: any = []

  afiliacion_fondo_pension_dc_aportes_empleador: any = []

  trabajadores: any[] = [
    { nombre: 'Ernesto Ontonedo', afiliacion_fondo_pension_dc_sucursal: 'Miraflores', afiliacion_fondo_pension_dc_centro_costo: 'Operaciones' },
    { nombre: 'Alex Ortiz', afiliacion_fondo_pension_dc_sucursal: 'Surquillo', afiliacion_fondo_pension_dc_centro_costo: 'Cocina' },
    { nombre: 'Juan fausto', afiliacion_fondo_pension_dc_sucursal: 'Santa Ana', afiliacion_fondo_pension_dc_centro_costo: 'Bar' },
    { nombre: 'Jean Pierre', afiliacion_fondo_pension_dc_sucursal: 'Moquegua', afiliacion_fondo_pension_dc_centro_costo: 'Operaciones' },
    { nombre: 'Diego Falcao', afiliacion_fondo_pension_dc_sucursal: 'Piura', afiliacion_fondo_pension_dc_centro_costo: 'Marketing y ventas' },
    { nombre: 'Maria Ines', afiliacion_fondo_pension_dc_sucursal: 'Talara', afiliacion_fondo_pension_dc_centro_costo: 'RRHH' }
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

  rowData: AfiliacionFondosPensionEntity[] = [];
  isResetting = false;

  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  colDefs: ColDef[] = [
    { field: 'afiliacion_fondo_pension_codigo', headerName: 'Código', width: 80 },
    { field: 'afiliacion_fondo_pension_trabajador', headerName: 'Trabajador', flex: 1, minWidth: 100 },
    { field: 'afiliacion_fondo_pension_contrato_asociado', headerName: 'Tipo de contrato asociado', width: 170, filter: true },
    { field: 'afiliacion_fondo_pension_beneficio_asociado', headerName: 'Beneficio asociado ', width: 160 },
    {
      field: 'afiliacion_fondo_pension_retenciones', headerName: 'Retenciones ', width: 220,
      cellStyle: { wordBreak: 'break-word', whiteSpace: 'normal', lineHeight: '1.5'  },
      autoHeight: true,
    },
    { field: 'afiliacion_fondo_pension_aportes', headerName: 'Aportes', width: 130 },
    {
      field: 'afiliacion_fondo_pension_fecha', headerName: 'Fecha creación', width: 100,
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
    {
      field: 'afiliacion_fondo_pension_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado', filter: true,
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
    this.rrHhFacade.cargarAfiliacionFondosPension();
    this.obtenerdatospais();
    this.initializeForm();
    this.formValidationService.inicializarFormulario(this.AfiliacionForm);
    // Detectar resolución inicial
    this.onResize();
    // Sincronizar rowData desde el store
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.rowData = [...this.afiliacionFondosPensionStore()];
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', this.rowData);
        }
        // Restaurar fila seleccionada si existe (al volver a la pantalla)
        if (this.filaSeleccionada) {
          const codigo = this.filaSeleccionada.afiliacion_fondo_pension_codigo;
          setTimeout(() => {
            this.gridApi?.forEachNode((node) => {
              if (node.data?.afiliacion_fondo_pension_codigo === codigo) {
                node.setSelected(true);
              }
            });
          }, 0);
        }
      }
    }, 100);
  }
  obtenerdatospais(){
    this.countries.find(country => {
      if(country.codigo === this.pais){
        // Lógica para usar los datos del país si es necesario
        this.beneciciosAsociados = country.beneficiosasociados
        this.retencionesTrabajador = country.retencionesaltrabajador
        if(this.pais === 'PE' || this.pais === 'EC' ||this.pais === 'CO'){
        this.retencionesTrabajador.push({value: 4, nombre: 'Otro descuento'})
        }
        else{
        this.retencionesTrabajador.push({value: 3, nombre: 'Otro descuento'})
        }
        this.afiliacion_fondo_pension_dc_aportes_empleador = country.aportesdelempleador
        this.simboloMoneda = country.moneda || 'S/';
      }
    });
  }
  private initializeForm(): void {
    this.AfiliacionForm = this.formBuilder.group({
      fechaEmision: [{ value: this.getFechaActual(), disabled: true }, Validators.required],
      afiliacion_fondo_pension_trabajador: [''],
      afiliacion_fondo_pension_dc_sucursal: [{ value: '', disabled: true }],
      afiliacion_fondo_pension_dc_centro_costo: [{ value: '', disabled: true }],
      afiliacion_fondo_pension_dc_fondo: [''],
      afiliacion_fondo_pension_dc_franquicia: [''],
      afiliacion_fondo_pension_dc_beneficios_asociados: [[]],
      afiliacion_fondo_pension_estado: ['Activo'],
      afiliacion_fondo_pension_retenciones: [[]],
      afiliacion_fondo_pension_dc_tipo_fondo: [''],
      afiliacion_fondo_pension_dc_afp_afiliada: [''],
      afiliacion_fondo_pension_dc_calculo_monto: [''],
      afiliacion_fondo_pension_dc_porcentaje: [''],
      afiliacion_fondo_pension_dc_monto_quinta: [''],
      afiliacion_fondo_pension_dc_monto_cuarta: [''],
      afiliacion_fondo_pension_dc_concepto_desc: [''],
      afiliacion_fondo_pension_dc_monto_otro_desc: [''],
      afiliacion_fondo_pension_dc_aportes_empleador: [[]],
      afiliacion_fondo_pension_dc_empleador_essalud: [''],
      afiliacion_fondo_pension_dc_porcentaje_essalud: [''],
      afiliacion_fondo_pension_dc_entidad_salud_eps: [''],
      afiliacion_fondo_pension_dc_porcentaje_eps: [''],
      afiliacion_fondo_pension_dc_entidad_salud_scrt: [''],
      afiliacion_fondo_pension_dc_porcentaje_scrt: [''],
    });
  }

  getFechaActual(): string {
    const today = new Date();
    const day = String(today.getDate()).padStart(2, '0');
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const year = today.getFullYear();
    return `${year}-${month}-${day}`;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // Restaurar la fila seleccionada al volver a la pantalla
    if (this.filaSeleccionada) {
      const codigo = this.filaSeleccionada.afiliacion_fondo_pension_codigo;
      setTimeout(() => {
        this.gridApi?.forEachNode((node) => {
          if (node.data?.afiliacion_fondo_pension_codigo === codigo) {
            node.setSelected(true);
          }
        });
      }, 0);
    }
  }

  async onCellClicked(event: any) {
    if (!event.data) return;
    const data = event.data;

    // Validar cambios antes de cambiar de registro
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Usuario canceló - restaurar selección anterior
      if (this.gridApi && this.filaSeleccionada) {
        const prevCodigo = this.filaSeleccionada.afiliacion_fondo_pension_codigo;
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
            if (node.data?.afiliacion_fondo_pension_codigo === prevCodigo) {
              node.setSelected(true);
            }
          });
        }, 0);
      }
      return;
    }

    // Usuario confirmó, cargar datos y seleccionar nueva fila
    this.filaSeleccionada = data;
    this.modoCreacion = false;
    this.modoEdicion = true;
    this.formularioActivo = true;
    this.habilitarFormularioEdicion();
    this.cargarDatosEnFormulario(data);

    const selectedCodigo = data.afiliacion_fondo_pension_codigo;
    setTimeout(() => {
      this.gridApi?.deselectAll();
      this.gridApi?.forEachNode((node) => {
        if (node.data?.afiliacion_fondo_pension_codigo === selectedCodigo) {
          node.setSelected(true);
        }
      });
      this.habilitarFormularioEdicion();
      console.log('Formulario actualizado:', this.AfiliacionForm.value);
    }, 50);

    this.formValidationService.resetearEstado();
  }

  onBtReset() {
    this.isResetting = true;
    this.rrHhFacade.cargarAfiliacionFondosPension();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.rowData = [...this.afiliacionFondosPensionStore()];
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', this.rowData);
        }
        this.isResetting = false;
      }
    }, 100);
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  scrollLeft() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: -150, behavior: 'smooth' });
  }

  scrollRight() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: 150, behavior: 'smooth' });
  }

  onTrabajadorSeleccionado(trabajador: any) {
    this.AfiliacionForm.patchValue({
      afiliacion_fondo_pension_trabajador: trabajador.nombre,
      afiliacion_fondo_pension_dc_centro_costo: trabajador.afiliacion_fondo_pension_dc_centro_costo,
      afiliacion_fondo_pension_dc_sucursal: trabajador.afiliacion_fondo_pension_dc_sucursal || ''
    });
  }

  onFondoSeleccionado(fondo: any) {
    this.AfiliacionForm.patchValue({
      afiliacion_fondo_pension_dc_fondo: fondo.nombre
    });
  }

  onFechaAfiliacionSelected(fecha: any) {
    this.AfiliacionForm.patchValue({
      fechaAfiliacion: fecha
    });
  }

  seleccionarBeneficios(event: any) {
    this.AfiliacionForm.patchValue({
      afiliacion_fondo_pension_dc_beneficios_asociados: event
    });
  }

  onFechaEPSSelected(fecha: any) {
    this.AfiliacionForm.patchValue({
      fechaEPS: fecha
    });
  }

  onFechaSCRTSelected(fecha: any) {
    this.AfiliacionForm.patchValue({
      fechaSCRT: fecha
    });
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    this.cargarDatos(range.start, range.end);
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }

  private cargarDatosEnFormulario(datos: any): void {
    const datosCompletos = datos.afiliacion_fondo_pension_datos_completos || {};

    // Obtener valores con fallbacks robustos
    const nombreTrabajador = datosCompletos.afiliacion_fondo_pension_trabajador?.trim() || datos.nombre?.trim() || '';
    const tipoContrato = datosCompletos.afiliacion_fondo_pension_dc_fondo?.trim() || datos.afiliacion_fondo_pension_contrato_asociado?.trim() || '';
    const beneficiosIds = datosCompletos.afiliacion_fondo_pension_dc_beneficios_asociados && Array.isArray(datosCompletos.afiliacion_fondo_pension_dc_beneficios_asociados) && datosCompletos.afiliacion_fondo_pension_dc_beneficios_asociados.length > 0
      ? datosCompletos.afiliacion_fondo_pension_dc_beneficios_asociados
      : this.convertirTextoAIds(datos.afiliacion_fondo_pension_beneficio_asociado, this.beneciciosAsociados);

    // Asegurar que los campos editables estén habilitados antes de patchValue
    const camposEditables = ['afiliacion_fondo_pension_trabajador', 'nombre', 'afiliacion_fondo_pension_dc_fondo', 'afiliacion_fondo_pension_dc_franquicia', 'afiliacion_fondo_pension_dc_beneficios_asociados', 'afiliacion_fondo_pension_estado', 
      'afiliacion_fondo_pension_retenciones', 'afiliacion_fondo_pension_dc_monto_quinta', 'afiliacion_fondo_pension_dc_monto_cuarta', 'afiliacion_fondo_pension_dc_tipo_fondo', 'afiliacion_fondo_pension_dc_afp_afiliada', 'afiliacion_fondo_pension_dc_calculo_monto', 'afiliacion_fondo_pension_dc_porcentaje',
      'afiliacion_fondo_pension_dc_concepto_desc', 'afiliacion_fondo_pension_dc_monto_otro_desc', 'afiliacion_fondo_pension_dc_aportes_empleador', 'afiliacion_fondo_pension_dc_empleador_essalud', 'afiliacion_fondo_pension_dc_porcentaje_essalud',
      'afiliacion_fondo_pension_dc_entidad_salud_eps', 'afiliacion_fondo_pension_dc_porcentaje_eps', 'afiliacion_fondo_pension_dc_entidad_salud_scrt', 'afiliacion_fondo_pension_dc_porcentaje_scrt'];
    
    camposEditables.forEach(campo => {
      this.AfiliacionForm.get(campo)?.enable();
    });

    // Cargar todo el formulario - usando IDs directamente desde datosCompletos
    this.AfiliacionForm.patchValue({
      fechaEmision: datos.afiliacion_fondo_pension_fecha || datos.fechaEmision || null,
      afiliacion_fondo_pension_trabajador: nombreTrabajador,
      nombre: nombreTrabajador,
      afiliacion_fondo_pension_dc_sucursal: datosCompletos.afiliacion_fondo_pension_dc_sucursal || '',
      afiliacion_fondo_pension_dc_centro_costo: datosCompletos.afiliacion_fondo_pension_dc_centro_costo || '',
      afiliacion_fondo_pension_dc_fondo: tipoContrato,
      afiliacion_fondo_pension_dc_franquicia: datosCompletos.afiliacion_fondo_pension_dc_franquicia || '',
      // Pasar los IDs directamente (el autocomplete los espera así)
      afiliacion_fondo_pension_dc_beneficios_asociados: beneficiosIds,
      afiliacion_fondo_pension_estado: datosCompletos.afiliacion_fondo_pension_estado || datos.afiliacion_fondo_pension_estado || 'Activo',

      // Tab Retenciones - también IDs
      afiliacion_fondo_pension_retenciones: datosCompletos.afiliacion_fondo_pension_retenciones && Array.isArray(datosCompletos.afiliacion_fondo_pension_retenciones) && datosCompletos.afiliacion_fondo_pension_retenciones.length > 0
        ? datosCompletos.afiliacion_fondo_pension_retenciones
        : this.convertirTextoAIds(datos.afiliacion_fondo_pension_retenciones, this.retencionesTrabajador),
      afiliacion_fondo_pension_dc_monto_quinta: datosCompletos.afiliacion_fondo_pension_dc_monto_quinta || '',
      afiliacion_fondo_pension_dc_monto_cuarta: datosCompletos.afiliacion_fondo_pension_dc_monto_cuarta || '',
      afiliacion_fondo_pension_dc_tipo_fondo: datosCompletos.afiliacion_fondo_pension_dc_tipo_fondo || '',
      afiliacion_fondo_pension_dc_afp_afiliada: datosCompletos.afiliacion_fondo_pension_dc_afp_afiliada || '',
      afiliacion_fondo_pension_dc_calculo_monto: datosCompletos.afiliacion_fondo_pension_dc_calculo_monto || '',
      afiliacion_fondo_pension_dc_porcentaje: datosCompletos.afiliacion_fondo_pension_dc_porcentaje || '',
      afiliacion_fondo_pension_dc_concepto_desc: datosCompletos.afiliacion_fondo_pension_dc_concepto_desc || '',
      afiliacion_fondo_pension_dc_monto_otro_desc: datosCompletos.afiliacion_fondo_pension_dc_monto_otro_desc || '',

      // Tab Aportes - también IDs
      afiliacion_fondo_pension_dc_aportes_empleador: datosCompletos.afiliacion_fondo_pension_dc_aportes_empleador && Array.isArray(datosCompletos.afiliacion_fondo_pension_dc_aportes_empleador) && datosCompletos.afiliacion_fondo_pension_dc_aportes_empleador.length > 0
        ? datosCompletos.afiliacion_fondo_pension_dc_aportes_empleador
        : this.convertirTextoAIds(datos.afiliacion_fondo_pension_aportes, this.afiliacion_fondo_pension_dc_aportes_empleador),
      afiliacion_fondo_pension_dc_empleador_essalud: datosCompletos.afiliacion_fondo_pension_dc_empleador_essalud || '',
      afiliacion_fondo_pension_dc_porcentaje_essalud: datosCompletos.afiliacion_fondo_pension_dc_porcentaje_essalud || '',
      afiliacion_fondo_pension_dc_entidad_salud_eps: datosCompletos.afiliacion_fondo_pension_dc_entidad_salud_eps || '',
      afiliacion_fondo_pension_dc_porcentaje_eps: datosCompletos.afiliacion_fondo_pension_dc_porcentaje_eps || '',
      afiliacion_fondo_pension_dc_entidad_salud_scrt: datosCompletos.afiliacion_fondo_pension_dc_entidad_salud_scrt || '',
      afiliacion_fondo_pension_dc_porcentaje_scrt: datosCompletos.afiliacion_fondo_pension_dc_porcentaje_scrt || '',
    });

    this.tabSeleccionado = 'informacion';
    console.log('Datos cargados en el formulario:', {
      nombreTrabajador,
      tipoContrato,
      beneficiosIds,
      afiliacion_fondo_pension_estado: datosCompletos.afiliacion_fondo_pension_estado,
      formValue: this.AfiliacionForm.value
    });

    // Pequeño delay para asegurar que el DOM esté actualizado
    setTimeout(() => {
      console.log('Valores después de timeout:', {
        afiliacion_fondo_pension_dc_beneficios_asociados: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_beneficios_asociados')?.value,
        afiliacion_fondo_pension_retenciones: this.AfiliacionForm.get('afiliacion_fondo_pension_retenciones')?.value,
        afiliacion_fondo_pension_dc_aportes_empleador: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_aportes_empleador')?.value
      });
    }, 200);
  }

  // Convierte texto separado por comas a array de IDs
  private convertirTextoAIds(texto: string, catalogo: any[]): number[] {
    if (!texto || texto === '-') return [];
    const nombres = texto.split(',').map(v => v.trim()).filter(v => v);
    const items = catalogo.filter(item => nombres.includes(item.nombre));
    return items.map(item => item.value);
  }

  // Convierte array de IDs a array de objetos
  private convertirIdsAObjetos(ids: number[], catalogo: any[]): any[] {
    if (!Array.isArray(ids) || ids.length === 0) return [];
    if (!catalogo || catalogo.length === 0) return [];
    return catalogo.filter(item => ids.includes(item.value));
  }

  // Convierte array de IDs a string separado por comas
  private convertirIdsATexto(ids: number[], catalogo: any[]): string {
    if (!Array.isArray(ids) || ids.length === 0) return '-';
    const objetos = this.convertirIdsAObjetos(ids, catalogo);
    return objetos.length > 0 ? objetos.map(o => o.nombre).join(', ') : '-';
  }

  private habilitarFormularioEdicion(): void {
    Object.keys(this.AfiliacionForm.controls).forEach(key => {
      const control = this.AfiliacionForm.get(key);
      // Habilitar todos excepto: fechaEmision, sucursal, centroCosto (solo lectura)
      if (key !== 'fechaEmision' && key !== 'afiliacion_fondo_pension_dc_sucursal' && key !== 'afiliacion_fondo_pension_dc_centro_costo') {
        control?.enable();
      } else {
        control?.disable();
      }
    });
    
    console.log('Formulario habilitado para edición');
  }

  private habilitarFormulario(): void {
    Object.keys(this.AfiliacionForm.controls).forEach(key => {
      if (key !== 'fechaEmision' && key !== 'afiliacion_fondo_pension_dc_sucursal' && key !== 'afiliacion_fondo_pension_dc_centro_costo') {
        this.AfiliacionForm.get(key)?.enable();
      }
    });
  }

  async botonNuevo(): Promise<void> {
    // Validar cambios antes de crear nuevo registro
    const puede = await this.formValidationService.validarCambios();
    if (!puede) {
      return; // Canceló la operación
    }
    
    this.modoCreacion = true;
    this.modoEdicion = false;
    this.filaSeleccionada = null;
    this.formularioActivo = true;
    this.fechaAfiliacion = undefined;

    this.AfiliacionForm.reset({
      fechaEmision: this.getFechaActual(),
      afiliacion_fondo_pension_estado: 'Activo',
    });

    this.tabSeleccionado = 'informacion';
    this.habilitarFormulario();
    this.formValidationService.resetearEstado();

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  async botonCancelar(): Promise<void> {
    // Validar cambios antes de cancelar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Si cancela, deseleccionar la fila
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }
      return; // Cancelar acción
    }

    // Reiniciar el formulario a los valores por defecto
    if (this.AfiliacionForm) {
      this.AfiliacionForm.reset({
        fechaEmision: this.getFechaActual(),
        afiliacion_fondo_pension_estado: 'Activo',
      });

      // Limpiar fila seleccionada
      this.filaSeleccionada = null;

      // Deseleccionar fila de la tabla
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }

      // Retornar a modo creación
      this.modoCreacion = true;
      this.modoEdicion = false;
      this.formularioActivo = true;
      this.tabSeleccionado = 'informacion';
      this.habilitarFormulario();

      // Resetear estado del servicio de validación
      this.formValidationService.resetearEstado();
    }
  }

  private generarCodigo(): string {
    const prefix = 'CA-';
    let max = 0;
    this.rowData.forEach((row: any) => {
      if (row.afiliacion_fondo_pension_codigo && row.afiliacion_fondo_pension_codigo.startsWith(prefix)) {
        const num = parseInt(row.afiliacion_fondo_pension_codigo.replace(prefix, ''));
        if (!isNaN(num) && num > max) max = num;
      }
    });
    return `${prefix}${(max + 1).toString().padStart(4, '0')}`;
  }

  guardarEdicion(): void {
    const trabajador = this.AfiliacionForm.get('afiliacion_fondo_pension_trabajador')?.value;
    const fondo = this.AfiliacionForm.get('afiliacion_fondo_pension_dc_fondo')?.value;
    const beneficiosIds = this.AfiliacionForm.get('afiliacion_fondo_pension_dc_beneficios_asociados')?.value || [];

    if (!trabajador || !fondo || beneficiosIds.length === 0) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    if (this.modoCreacion) {
      const trabajador = this.AfiliacionForm.get('afiliacion_fondo_pension_trabajador')?.value;
      const contrato = this.AfiliacionForm.get('afiliacion_fondo_pension_dc_fondo')?.value;
      const beneficiosIds = this.AfiliacionForm.get('afiliacion_fondo_pension_dc_beneficios_asociados')?.value || [];
      const retencionesIds = this.AfiliacionForm.get('afiliacion_fondo_pension_retenciones')?.value || [];
      const aportesIds = this.AfiliacionForm.get('afiliacion_fondo_pension_dc_aportes_empleador')?.value || [];
      const fechaCreacion = new Date();

      const nuevoRegistro = {
        afiliacion_fondo_pension_codigo: this.generarCodigo(),
        afiliacion_fondo_pension_trabajador: trabajador,
        afiliacion_fondo_pension_contrato_asociado: contrato,
        afiliacion_fondo_pension_beneficio_asociado: this.convertirIdsATexto(beneficiosIds, this.beneciciosAsociados),
        afiliacion_fondo_pension_retenciones: this.convertirIdsATexto(retencionesIds, this.retencionesTrabajador),
        afiliacion_fondo_pension_aportes: this.convertirIdsATexto(aportesIds, this.afiliacion_fondo_pension_dc_aportes_empleador),
        afiliacion_fondo_pension_fecha: fechaCreacion.toISOString().substring(0, 10),
        afiliacion_fondo_pension_estado: 'Activo',
        afiliacion_fondo_pension_datos_completos: this.obtenerDatosCompletos()
      };

      this.rowData = [...this.rowData, nuevoRegistro];
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }

      // this.rowData = [nuevoRegistro, ...this.rowData];
      // if (this.gridApi) {
      //   this.gridApi.setGridOption('rowData', this.rowData);

      //   // 2. Seleccionar la nueva fila (por código único)
      //   setTimeout(() => {
      //     const node = this.gridApi.getRowNode(nuevoRegistro.afiliacion_fondo_pension_codigo);
      //     if (node) {
      //       node.setSelected(true);
      //       this.gridApi.ensureNodeVisible(node, 'top');
      //     } else {
      //       // Alternativa: seleccionar por índice 0
      //       this.gridApi.forEachNode((n, idx) => {
      //         if (idx === 0) n.setSelected(true);
      //       });
      //     }
      //   }, 50);
      // }

      this.toastService.success('¡Configuración registrada exitosamente!');
      this.formValidationService.resetearEstado();
      this.botonNuevo();
    } else if (this.modoEdicion && this.filaSeleccionada) {
      const indice = this.rowData.findIndex(row => row.afiliacion_fondo_pension_codigo === this.filaSeleccionada.afiliacion_fondo_pension_codigo);

      if (indice !== -1) {
        const beneficiosIds = this.AfiliacionForm.get('afiliacion_fondo_pension_dc_beneficios_asociados')?.value || [];
        const retencionesIds = this.AfiliacionForm.get('afiliacion_fondo_pension_retenciones')?.value || [];
        const aportesIds = this.AfiliacionForm.get('afiliacion_fondo_pension_dc_aportes_empleador')?.value || [];
        const contrato = this.AfiliacionForm.get('afiliacion_fondo_pension_dc_fondo')?.value;

        this.rowData[indice] = {
          ...this.rowData[indice],
          afiliacion_fondo_pension_contrato_asociado: contrato,
          afiliacion_fondo_pension_beneficio_asociado: this.convertirIdsATexto(beneficiosIds, this.beneciciosAsociados),
          afiliacion_fondo_pension_retenciones: this.convertirIdsATexto(retencionesIds, this.retencionesTrabajador),
          afiliacion_fondo_pension_aportes: this.convertirIdsATexto(aportesIds, this.afiliacion_fondo_pension_dc_aportes_empleador),
          afiliacion_fondo_pension_estado: this.AfiliacionForm.get('afiliacion_fondo_pension_estado')?.value,
          afiliacion_fondo_pension_datos_completos: this.obtenerDatosCompletos()
        };

        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', [...this.rowData]);
        }

        this.toastService.success('¡Cambios realizados exitosamente!');
        this.formValidationService.resetearEstado();
        this.botonNuevo();
      }
    }
  }

  private obtenerDatosCompletos(): any {
    return {
      afiliacion_fondo_pension_trabajador: this.AfiliacionForm.get('afiliacion_fondo_pension_trabajador')?.value || this.AfiliacionForm.get('nombre')?.value || '',
      afiliacion_fondo_pension_dc_sucursal: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_sucursal')?.value,
      afiliacion_fondo_pension_dc_centro_costo: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_centro_costo')?.value,
      afiliacion_fondo_pension_dc_fondo: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_fondo')?.value,
      afiliacion_fondo_pension_dc_franquicia: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_franquicia')?.value || '',
      afiliacion_fondo_pension_dc_beneficios_asociados: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_beneficios_asociados')?.value || [], // IDs
      afiliacion_fondo_pension_estado: this.AfiliacionForm.get('afiliacion_fondo_pension_estado')?.value,

      afiliacion_fondo_pension_retenciones: this.AfiliacionForm.get('afiliacion_fondo_pension_retenciones')?.value || [], // IDs
      afiliacion_fondo_pension_dc_monto_quinta: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_monto_quinta')?.value,
      afiliacion_fondo_pension_dc_monto_cuarta: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_monto_cuarta')?.value,
      afiliacion_fondo_pension_dc_tipo_fondo: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_tipo_fondo')?.value,
      afiliacion_fondo_pension_dc_afp_afiliada: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_afp_afiliada')?.value,
      afiliacion_fondo_pension_dc_calculo_monto: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_calculo_monto')?.value,
      afiliacion_fondo_pension_dc_porcentaje: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_porcentaje')?.value,
      afiliacion_fondo_pension_dc_concepto_desc: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_concepto_desc')?.value,
      afiliacion_fondo_pension_dc_monto_otro_desc: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_monto_otro_desc')?.value,

      afiliacion_fondo_pension_dc_aportes_empleador: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_aportes_empleador')?.value || [], // IDs
      afiliacion_fondo_pension_dc_empleador_essalud: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_empleador_essalud')?.value,
      afiliacion_fondo_pension_dc_porcentaje_essalud: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_porcentaje_essalud')?.value,
      afiliacion_fondo_pension_dc_entidad_salud_eps: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_entidad_salud_eps')?.value,
      afiliacion_fondo_pension_dc_porcentaje_eps: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_porcentaje_eps')?.value,
      afiliacion_fondo_pension_dc_entidad_salud_scrt: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_entidad_salud_scrt')?.value,
      afiliacion_fondo_pension_dc_porcentaje_scrt: this.AfiliacionForm.get('afiliacion_fondo_pension_dc_porcentaje_scrt')?.value,
    };
  }

  async modalverActualizaciones() {
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

    const rowData = [
      { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Se ha creado el grupo 1.00' },
      { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se edito la descripción del grupo' },
      { fechaHora: '13/11/2025 09:00', usuario: 'Carlos Rodríguez', accion: 'Actualización', detalleCambio: 'Se cambió el tipo de flujo' },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de actualizaciones de la planilla ${this.filaSeleccionada.afiliacion_fondo_pension_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }

}