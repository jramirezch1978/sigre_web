import { Component, OnInit, OnDestroy, ElementRef, ViewChild, inject, effect,} from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { Observable, Subject } from 'rxjs';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { ActivosfijosOperacionesRegistroactivosCrearAccesorioComponent } from './modals/af-o-registroactivos-crear-accesorio/activosfijos-operaciones-registroactivos-crear-accesorio.component';
import { ActivosfijosOperacionesRegistroactivosCrearAdaptacionComponent } from './modals/af-o-registroactivos-crear-adaptacion/activosfijos-operaciones-registroactivos-crear-adaptacion.component';
import { ActivosfijosOperacionesRegistroactivosCrearIncidenciaComponent } from './modals/af-o-registroactivos-crear-incidencia/activosfijos-operaciones-registroactivos-crear-incidencia.component';
import { AfORegistroactivosRegistrarTrasladoComponent } from './modals/af-o-registroactivos-registrar-traslado/af-o-registroactivos-registrar-traslado.component';
import { AfORegistroactivosRevaluarComponent } from './modals/af-o-registroactivos-revaluar/af-o-registroactivos-revaluar.component';
import { AfORegistroactivosBajaComponent } from './modals/af-o-registroactivos-baja/af-o-registroactivos-baja.component';
import { AccesorioActionsCellComponent } from './cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { AlertComponent } from 'src/app/ui/alert/alert.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { ActivoFijo, Accesorio, Incidencia, Adaptacion } from '../../services/models/activo-fijo.model';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ActivoFijoFacade } from 'src/app/modules/activos/application/facades/activo-fijo.facade';
import { ClasifActivoFacade } from 'src/app/modules/activos/application/facades/clasif-activo.facade';
import { ProveedorActivoFacade } from 'src/app/modules/activos/application/facades/proveedor-activo.facade';
import { UbicacionActivoFacade } from 'src/app/modules/activos/application/facades/ubicacion-activo.facade';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronLeft, faChevronRight, faChevronsLeft, faChevronsRight, faCirclePlus, faGear, faRotateRight } from '@fortawesome/pro-solid-svg-icons';




@Component({
  selector: 'app-activosfijos-operaciones-registroactivos',
  templateUrl: './activosfijos-operaciones-registroactivos.component.html',
  styleUrls: ['./activosfijos-operaciones-registroactivos.component.scss'],
  standalone: false,
})
export class ActivosfijosOperacionesRegistroactivosComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronLeft = faChevronLeft;
  fasChevronRight = faChevronRight;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasGear = faGear;
  fasRotateRight = faRotateRight;


    //Tipo de cambio para ecuador

  pais = this.countryService.getCountryCode();
  mostrarTipoCambio: boolean = true;

  private readonly activoFijoFacade = inject(ActivoFijoFacade);
  private readonly clasifActivoFacade = inject(ClasifActivoFacade);
  private readonly proveedorActivoFacade = inject(ProveedorActivoFacade);
  private readonly ubicacionActivoFacade = inject(UbicacionActivoFacade);

  // Selectores del store
  readonly isLoading = this.activoFijoFacade.isLoading;

  private destroy$ = new Subject<void>();

  // Array de documentos para el autocomplete de Documento vinculado
  documentosVinculados = [
    { id: 'doc1', nombre: 'Factura F001-000123' },
    { id: 'doc2', nombre: 'Boleta B001-000456' },
    { id: 'doc3', nombre: 'Guía de Remisión G001-000789' },
    { id: 'doc4', nombre: 'Nota de Crédito N001-000321' },
    { id: 'doc5', nombre: 'Nota de Débito D001-000654' },
    { id: 'doc6', nombre: 'Factura F002-000234' },
    { id: 'doc7', nombre: 'Boleta B002-000567' },
    { id: 'doc8', nombre: 'Guía de Remisión G002-000890' },
    { id: 'doc9', nombre: 'Nota de Crédito N002-000432' },
    { id: 'doc10', nombre: 'Factura F003-000345' },
    { id: 'doc11', nombre: 'Boleta B003-000678' },
    { id: 'doc12', nombre: 'Guía de Remisión G003-000901' },
    { id: 'doc13', nombre: 'Nota de Débito D002-000765' },
    { id: 'doc14', nombre: 'Factura F004-000456' },
    { id: 'doc15', nombre: 'Boleta B004-000789' },
  ];

  // Maneja la selección de un documento vinculado
  onDocumentoVinculadoSeleccionado(event: any) {
    if (event && event.id) {
      this.registroActivosForm.patchValue({ documentoVinculado: event.id });
    }
  }

  @ViewChild('scrollBox', { read: ElementRef }) scrollBox!: ElementRef;



  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  //FECHAS ÚNICAS (SINGLE)
  fechaAdquisicion: Date | undefined;
  fechaInicioDepreciacion: Date | undefined;
  fechaAsignacion: Date | undefined;

  filaSeleccionada: any = null; // Almacena la fila que se está editando
  registroActivosForm: FormGroup;
  private gridApi!: GridApi;
  estadoSeleccionado: string = 'todos';
  camponuevo: boolean = false;
  tabSeleccionado: string = 'datosGenerales';
  archivo: any;
  panelLateralVisible: boolean = true;
  gridContext!: {
    componentParent: ActivosfijosOperacionesRegistroactivosComponent;
  };

  // Orden de tabs para navegación
  tabsOrden: string[] = [
    'datosGenerales',
    'datosComplementarios',
    'accesorios',
    'Depreciación',
    'Incidencias',
    'Adaptaciones',
    'Asignaciones'
  ];

  // Tabs opcionales (no requieren validación para pasar al siguiente)
  tabsOpcionales: string[] = ['accesorios', 'Incidencias', 'Adaptaciones'];

  // Array de clases para el autocomplete (nivel 1 - se carga desde JSON)
  clasificaciones: { id: string; nombre: string }[] = [];
  // Array de subclases para el autocomplete (nivel 2 - filtrado por clase seleccionada)
  subclases: { id: string; nombre: string }[] = [];

  // Todas las clasificaciones del JSON para filtrar dinámicamente
  private allClasificaciones: any[] = [];

  // Array de subclasificaciones para el autocomplete
  subclasificaciones = [
    { id: 'sub1', nombre: 'Maquinaria Industrial' },
    { id: 'sub2', nombre: 'Maquinaria Agrícola' },
    { id: 'sub3', nombre: 'Equipo de Producción' },
    { id: 'sub4', nombre: 'Muebles de Oficina' },
    { id: 'sub5', nombre: 'Muebles de Almacén' },
    { id: 'sub6', nombre: 'Vehículos de Transporte' },
    { id: 'sub7', nombre: 'Vehículos de Carga' },
    { id: 'sub8', nombre: 'Computadoras' },
    { id: 'sub9', nombre: 'Impresoras' },
    { id: 'sub10', nombre: 'Servidores' },
    { id: 'sub11', nombre: 'Edificios' },
    { id: 'sub12', nombre: 'Terrenos' },
    { id: 'sub13', nombre: 'Herramientas Manuales' },
    { id: 'sub14', nombre: 'Herramientas Eléctricas' }
  ];

  //Array de usuarios asignados para el autocomplete
  usuariosAsignados = [
    { id: 'user1', nombre: 'Juan Pérez' },
    { id: 'user2', nombre: 'Luis Gracia' },
    { id: 'user3', nombre: 'Días  García' },
    { id: 'user4', nombre: 'Miriam Muñoz' },
    { id: 'user5', nombre: 'María Martínez' },
  ];

  //Array de proveedores para el autocomplete (se carga desde JSON)
  proveedores: { id: string; nombre: string }[] = [];

  // Array de ubicaciones para el autocomplete (se carga desde localStorage)
  ubicaciones: { id: string; nombre: string; descripcion?: string }[] = [];

  // Array de centros de costos para el autocomplete (se carga desde localStorage)
  centrosCostos: { id: string; nombre: string; descripcion?: string }[] = [];



  monedas = [
    { value: 'Soles', label: 'Soles' },
    { value: 'Dólares', label: 'Dólares' },
  ];

  estados = [
    { value: 'Activo', label: 'Activo' },
    { value: 'Inactivo', label: 'Inactivo' },
  ];

  garantias = [
    { value: 'garantia1', label: '27/10/2025 al 27/10/2026' },
    { value: 'garantia2', label: 'Otra garantía' },
  ];

  usuarios = [
    { value: 'user1', label: 'Juan Pérez' },
    { value: 'user2', label: 'María García' },
    { value: 'user3', label: 'Carlos López' },
  ];

  estadosComplementarios = [
    { value: 'activo', label: 'Activo' },
    { value: 'inactivo', label: 'Inactivo' },
    { value: 'reparacion', label: 'En reparación' },
  ];

  metodosDepreciacion = [
    { value: 'lineal', label: 'Linea recta' },
    { value: 'sumadedigitos', label: 'Suma de dígitos' },
    { value: 'sumadedigitos', label: 'Doble saldo decreciente' },
    { value: 'metododesuma', label: 'Metodo de suma de dígitos' },
    { value: 'unidades', label: 'Unidades de producción' },
  ];

  responsables = [
    { value: 'rodrigo', label: 'Rodrigo Hernández' },
    { value: 'juan', label: 'Juan Pérez' },
    { value: 'maria', label: 'María García' },
    { value: 'carlos', label: 'Carlos López' },
  ];

  opcionesNotificacion = [
    { value: 'email', label: 'Correo electrónico' },
    { value: 'whatsapp', label: 'WhatsApp' },
  ];

  notificarResponsable: boolean = false;

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

  rowData: any[] = [];

  colDefs: ColDef[] = [
    { field: 'activo_fijo_codigo', headerName: 'Código', width: 80 },
    { field: 'activo_fijo_descripcion', headerName: 'Descripción', flex: 1 },
    { field: 'activo_fijo_fecha_adquisicion', headerName: 'Fecha de adquisición', width: 130,},
    { field: 'activo_fijo_periodo_contable', headerName: 'Periodo Contable', width: 130, filter: true,},
    { field: 'activo_fijo_valor_adquisicion', headerName: 'Valor de adquisición', headerClass: 'derechaencabezado', width: 140,
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `(${formattedValue})`;
          }
          return formattedValue;
        }
        return '';
      },
      cellStyle: (params) => {
        const style: any = { 
          justifyContent: 'end',
        };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { field: 'activo_fijo_valor_neto', headerName: 'Valor neto en libros', headerClass: 'derechaencabezado', width: 140,
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `(${formattedValue})`;
          }
          return formattedValue;
        }
        return '';
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'right' };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { field: 'activo_fijo_estado', headerClass: 'centrarencabezado', headerName: 'Estado', width: 80, filter: true,
      cellRenderer: (params: any) => {
        const color =
          params.value === 'Activo'
            ? 'bg-[#DCFDE7] text-[#16A34A]'
            : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center',},
    },
  ];

  columnTypes = {};

  // AG-Grid para Accesorios
  private gridApiAccesorios!: GridApi;

  rowDataAccesorios = [
    { codigo: 'ACC01', descripcion: 'Parrilla de gas', valorIndividual: 1000, relacionActivo: 'Cocina Industrial',},
    { codigo: 'ACC01', descripcion: 'Parrilla de gas', valorIndividual: 1000, relacionActivo: 'Cocina Industrial',},
    { codigo: 'ACC01', descripcion: 'Parrilla de gas', valorIndividual: 1000, relacionActivo: 'Cocina Industrial',},
    { codigo: 'ACC01', descripcion: 'Parrilla de gas', valorIndividual: 1000, relacionActivo: 'Cocina Industrial',},
    { codigo: 'ACC01', descripcion: 'Parrilla de gas', valorIndividual: 1000, relacionActivo: 'Cocina Industrial',},
    { codigo: 'ACC01', descripcion: 'Parrilla de gas', valorIndividual: 1000, relacionActivo: 'Cocina Industrial',},
    { codigo: 'ACC01', descripcion: 'Parrilla de gas', valorIndividual: 1000, relacionActivo: 'Cocina Industrial',},
  ];

  colDefsAccesorios: ColDef[] = [
    { field: 'codigo', headerName: 'Código', width: 100 },
    { field: 'descripcion', headerName: 'Descripción', flex: 1, editable: true, minWidth: 150,},
    { field: 'valorIndividual', headerName: 'Valor individual', width: 130, editable: true, headerClass: 'derechaencabezado',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `(${formattedValue})`;
          }
          return formattedValue;
        }
        return '';
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'right' };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { field: 'relacionActivo', headerName: 'Relación con activo principal', flex: 1, minWidth: 150, editable: true,},
    { field: 'acciones', headerClass: 'centrarencabezado', headerName: 'Acciones', width: 100, cellRenderer: AccesorioActionsCellComponent,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center',},
    },
  ];

  // AG-Grid para Incidencias
  private gridApiIncidencias!: GridApi;

  rowDataIncidencias = [
    { fechaIncidencia: '14/01/2025', tipoIncidencia: 'Daño', descripcion: 'Fuga de gas en la válvula principal', accionCorrectiva: 'Se reemplazó la válvula.', costoAsociado: 100, estado: 'Abierto',},
    { fechaIncidencia: '14/01/2025', tipoIncidencia: 'Daño', descripcion: 'Fuga de gas en la válvula principal', accionCorrectiva: 'Se reemplazó la válvula.', costoAsociado: 100, estado: 'Cerrado',},
    { fechaIncidencia: '14/01/2025', tipoIncidencia: 'Daño', descripcion: 'Fuga de gas en la válvula principal', accionCorrectiva: 'Se reemplazó la válvula.', costoAsociado: 100, estado: 'Abierto',},
    { fechaIncidencia: '14/01/2025', tipoIncidencia: 'Daño', descripcion: 'Fuga de gas en la válvula principal', accionCorrectiva: 'Se reemplazó la válvula.', costoAsociado: 100, estado: 'Cerrado',},
    { fechaIncidencia: '14/01/2025', tipoIncidencia: 'Daño', descripcion: 'Fuga de gas en la válvula principal', accionCorrectiva: 'Se reemplazó la válvula.', costoAsociado: 100, estado: 'Abierto',},
    { fechaIncidencia: '14/01/2025', tipoIncidencia: 'Daño', descripcion: 'Fuga de gas en la válvula principal', accionCorrectiva: 'Se reemplazó la válvula.', costoAsociado: 100, estado: 'Cerrado',},
  ];

  colDefsIncidencias: ColDef[] = [
    { field: 'fechaIncidencia', headerName: 'F. de incidencia', width: 120 },
    { field: 'tipoIncidencia', headerName: 'Tipo de incidencia', width: 130 },
    { field: 'descripcion', headerName: 'Descripción', flex: 1, minWidth: 150 },
    { field: 'accionCorrectiva', headerName: 'Acción Correctiva', flex: 1, minWidth: 150 },
    { field: 'costoAsociado', headerName: 'Costo Asociado', headerClass: 'derechaencabezado', width: 120,
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `(${formattedValue})`;
          }
          return formattedValue;
        }
        return '';
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'right' };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { field: 'estado', headerName: 'Estado', headerClass: 'centrarencabezado', width: 100,
      cellRenderer: (params: any) => {
        const color =
          params.value === 'Abierto'
            ? 'bg-[#FFDECC] text-[#FF8947]'
            : 'bg-[#DCFDE7] text-[#16A34A]';
        return `<span class="px-2 py-0.5 rounded-xl text-xxss ${color}">${params.value}</span>`;
      },
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center',},
    },
  ];

  // AG-Grid para Adaptaciones
  private gridApiAdaptaciones!: GridApi;

  rowDataAdaptaciones = [
    { fechaAdaptacion: '14/01/2025', descripcion: 'Instalación de campana extra...', valorIncremental: 1200, responsable: 'Juan Pérez',},
    { fechaAdaptacion: '14/01/2025', descripcion: 'Instalación de campana extra...', valorIncremental: 1200, responsable: 'Juan Pérez',},
    { fechaAdaptacion: '14/01/2025', descripcion: 'Instalación de campana extra...', valorIncremental: 1200, responsable: 'Juan Pérez',},
    { fechaAdaptacion: '14/01/2025', descripcion: 'Instalación de campana extra...', valorIncremental: 1200, responsable: 'Juan Pérez',},
    { fechaAdaptacion: '14/01/2025', descripcion: 'Instalación de campana extra...', valorIncremental: 1200, responsable: 'Juan Pérez+',},
    { fechaAdaptacion: '14/01/2025', descripcion: 'Instalación de campana extra...', valorIncremental: 1200, responsable: 'Juan Pérez',},
  ];

  colDefsAdaptaciones: ColDef[] = [
    { field: 'fechaAdaptacion', headerName: 'Fecha de adaptación', width: 130 },
    { field: 'descripcion', headerName: 'Descripción', flex: 1, minWidth: 150 },
    { field: 'valorIncremental', headerName: 'Valor incremental', headerClass: 'derechaencabezado', width: 130,
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          
          // Si es negativo, mostrar entre paréntesis
          if (params.value < 0) {
            return `(${formattedValue})`;
          }
          return formattedValue;
        }
        return '';
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'right' };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { field: 'responsable', headerName: 'Responsable', flex: 1, minWidth: 150 },
  ];

  // AG-Grid para Traslados
  private gridApiTraslados!: GridApi;

  rowDataTraslados = [
    { nroTraslado: 'TRS-001', fechaTraslado: '10/02/2026', origen: 'Almacén Central', destino: 'Sucursal Norte', estado: 'Pendiente' },
    { nroTraslado: 'TRS-002', fechaTraslado: '08/02/2026', origen: 'Sucursal Norte', destino: 'Sucursal Sur', estado: 'Recepcionado' },
    { nroTraslado: 'TRS-003', fechaTraslado: '05/02/2026', origen: 'Almacén Central', destino: 'Sucursal Este', estado: 'Recepcionado' },
    { nroTraslado: 'TRS-004', fechaTraslado: '03/02/2026', origen: 'Sucursal Sur', destino: 'Almacén Central', estado: 'Pendiente' },
    { nroTraslado: 'TRS-005', fechaTraslado: '01/02/2026', origen: 'Sucursal Este', destino: 'Sucursal Oeste', estado: 'Recepcionado' },
  ];

  colDefsTraslados: ColDef[] = [
    { field: 'nroTraslado', headerName: 'Nro de traslado', width: 130 },
    { field: 'fechaTraslado', headerName: 'Fecha de traslado', width: 130 },
    { field: 'origen', headerName: 'Origen', flex: 1, minWidth: 150 },
    { field: 'destino', headerName: 'Destino', flex: 1, minWidth: 150 },
    { field: 'estado', headerName: 'Estado', headerClass: 'centrarencabezado', width: 120,
      cellRenderer: (params: any) => {
        const color =
          params.value === 'Pendiente'
            ? 'bg-[#FFDECC] text-[#FF8947]'
            : 'bg-[#DCFDE7] text-[#16A34A]';
        return `<span class="px-2 py-0.5 rounded-xl text-xxss ${color}">${params.value}</span>`;
      },
      cellStyle: {
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
    private simulation: SimulationService,
    private countryService: CountryService,
  ) {
    effect(() => {
      const activos = this.activoFijoFacade.activosFijos();
      this.rowData = activos;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });

    effect(() => {
      const items = this.clasifActivoFacade.clasifsActivo();
      this.allClasificaciones = items;

      // Clases: solo nivel 1 (orgHierarchy.length === 1)
      this.clasificaciones = items
        .filter((item) => !item.orgHierarchy || item.orgHierarchy.length === 1)
        .map((item) => ({
          id: item.clasif_activo_codigo,
          nombre: item.clasif_activo_nombre,
        }));
    });

    effect(() => {
      const items = this.proveedorActivoFacade.proveedores();
      this.proveedores = items.map((item) => ({
        id: item.proveedor_codigo,
        nombre: item.proveedor_razon_social,
      }));
    });

    effect(() => {
      const items = this.ubicacionActivoFacade.ubicaciones();
      this.ubicaciones = items.map((item) => {
        const nivel = item.ubic_nivel || '01';
        let prefijo = '';
        if (nivel === '02') prefijo = '  └─ ';
        if (nivel === '03') prefijo = '    └─ ';
        return {
          id: item.ubic_codigo,
          nombre: `${prefijo}${item.ubic_codigo} - ${item.ubic_nombre}`,
          descripcion: item.ubic_descripcion || '',
          responsable: item.ubic_responsable || '',
        };
      });
    });

    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );

    this.registroActivosForm = this.formBuilder.group({
      // Datos Generales
      codigoActivo: ['', Validators.required],
      nombreActivo: ['', Validators.required],
      clasificacion: ['', Validators.required],
      subclasificacion: [''],
      clase: [''],
      subclase: [''],
      marcaModelo: [''],
      proveedor: [''],
      documentoVinculado: [''],
      fechaAdquisicion: ['', Validators.required],
      moneda: ['Soles', Validators.required],
      valorAdquisicion: ['', Validators.required],
      tasadecambio: ['3.80'],
      valorSoles: [''],
      valorDolares: [''],
      estado: ['Activo', Validators.required],
      vidaUtil: [''],
      // Datos Complementarios
      garantia: [''],
      usuarioAsignado: [''],
      valorActualizado: ['', Validators.required],
      observaciones: [''],
      estadoComplementario: [''],
      // Depreciación
      metodoDepreciacion: ['', Validators.required],
      tasaAnual: ['20', Validators.required],
      fechaInicioDepreciacion: ['', Validators.required],
      valorResidual: ['', Validators.required],
      depreciacionAcumulada: ['', Validators.required],
      valorNetoLibros: ['', Validators.required],
      // Asignaciones
      responsableActivo: ['', Validators.required],
      centroCostos: ['', Validators.required],
      fechaAsignacion: ['', Validators.required],
      estadoAsignacion: ['Activo', Validators.required],
      notificarResponsable: [false],
      enviarNotificacionPor: [''],
    });

    this.gridContext = { componentParent: this };
  }

  ngOnInit() {
    // Por defecto iniciar en modo nuevo activo
    this.camponuevo = true;
    this.tabSeleccionado = 'datosGenerales';
    this.filaSeleccionada = null;
    
    // Cargar clasificaciones desde el facade (JSON + localStorage)
    this.clasifActivoFacade.cargarClasifActivos();
    
    // Cargar proveedores desde el facade (JSON)
    this.proveedorActivoFacade.cargarProveedores();
    
    // Cargar ubicaciones desde el facade (JSON)
    this.ubicacionActivoFacade.cargarUbicaciones();
    
    // Cargar centros de costo desde localStorage
    this.cargarCentrosCostoDesdeStorage();
    
    // Inicializar formulario con valores por defecto
    const monedaInicial = 'Soles';
    const tasaCambioInicial = this.obtenerTipoCambio(monedaInicial);
    
    this.registroActivosForm.patchValue({ 
      estado: 'Activo',
      moneda: monedaInicial,
      tasadecambio: tasaCambioInicial
    });
    
    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.registroActivosForm);

    // Cargar datos de activos fijos desde el servicio
    this.cargarActivosFijos();

    // Accesorios, incidencias y adaptaciones se gestionan en memoria local

    // Deshabilitar campos que se calculan automáticamente
    this.registroActivosForm.get('valorSoles')?.disable({ emitEvent: false });
    this.registroActivosForm.get('valorDolares')?.disable({ emitEvent: false });

    // Suscribirse a cambios en valor de adquisición
    this.registroActivosForm.get('valorAdquisicion')?.valueChanges.subscribe((valor) => {
      this.calcularConversion(valor);
    });
    
    // Suscribirse a cambios en tasa de cambio (si se modifica manualmente)
    this.registroActivosForm.get('tasadecambio')?.valueChanges.subscribe(() => {
      const valorAdq = this.registroActivosForm.get('valorAdquisicion')?.value;
      if (valorAdq) {
        this.calcularConversion(valorAdq);
      }
    });
    
    // Suscribirse a cambios en moneda para actualizar tasa de cambio y recalcular
    this.registroActivosForm.get('moneda')?.valueChanges.subscribe((moneda) => {
      if (moneda) {
        // Actualizar tasa de cambio automáticamente
        const nuevaTasaCambio = this.obtenerTipoCambio(moneda);
        this.registroActivosForm.get('tasadecambio')?.setValue(nuevaTasaCambio, { emitEvent: false });
        
        // Recalcular conversión si hay valor de adquisición
        const valorAdq = this.registroActivosForm.get('valorAdquisicion')?.value;
        if (valorAdq) {
          this.calcularConversion(valorAdq);
        }
      }
    });
    
    // Suscribirse a cambios en estado para habilitar/deshabilitar campos
    this.registroActivosForm.get('estado')?.valueChanges.subscribe((estado) => {
      this.configurarCamposPorEstado(estado);
    });

      //Labels de formulario: Tipo de cambio por ahora
    this.configurarLabelsPorPais();
  }

   configurarLabelsPorPais() {
  if(this.pais === 'EC') {
    this.mostrarTipoCambio = false; // Ocultar tipo de cambio en Ecuador
  }
}
  
  // Método para habilitar/deshabilitar campos según estado del activo
  private configurarCamposPorEstado(estado: string) {
    const camposDatosGenerales = [
      'nombreActivo',
      'clase',
      'subclase',
      'marcaModelo',
      'proveedor',
      'documentoVinculado',
      'fechaAdquisicion',
      'moneda',
      'valorAdquisicion',
      'vidaUtil'
    ];
    
    if (estado === 'Inactivo') {
      // Deshabilitar todos los campos excepto estado
      camposDatosGenerales.forEach(campo => {
        this.registroActivosForm.get(campo)?.disable({ emitEvent: false });
      });
    } else {
      // Habilitar todos los campos
      camposDatosGenerales.forEach(campo => {
        this.registroActivosForm.get(campo)?.enable({ emitEvent: false });
      });
    }
    
    // Campos que siempre deben estar disabled (se calculan automáticamente)
    this.registroActivosForm.get('tasadecambio')?.disable({ emitEvent: false });
    this.registroActivosForm.get('valorSoles')?.disable({ emitEvent: false });
    this.registroActivosForm.get('valorDolares')?.disable({ emitEvent: false });
  }

  /**
   * Obtiene el tipo de cambio desde localStorage para la moneda especificada
   */
  private obtenerTipoCambio(moneda: string): string {
    // Siempre obtener la tasa de cambio del dólar para hacer conversiones
    // Obtener tipos de cambio desde localStorage
    const tiposCambio = this.simulation.list('tipoCambio') || [];
    
    const fechaActual = new Date();
    const fechaFormateada = this.formatearFecha(fechaActual);
    
    // Siempre buscar el tipo de cambio del dólar
    const nombreMoneda = 'Dólar';
    
    // Buscar tipo de cambio activo para el dólar con fecha de vigencia actual
    const tipoCambioEncontrado = tiposCambio.find((tc: any) => {
      return tc.moneda === nombreMoneda && tc.estado === 'Activo' && tc.fechavigencia === fechaFormateada;
    });
    
    if (tipoCambioEncontrado) {
      return tipoCambioEncontrado.tcventa.toFixed(5);
    } else {
      // Si no hay tipo de cambio exacto, buscar el más reciente activo
      const tiposCambioMoneda = tiposCambio.filter((tc: any) => 
        tc.moneda === nombreMoneda && tc.estado === 'Activo'
      );
      
      if (tiposCambioMoneda.length > 0) {
        // Ordenar por fecha de vigencia (más reciente primero)
        tiposCambioMoneda.sort((a: any, b: any) => {
          const fechaA = this.parsearFechaString(a.fechavigencia);
          const fechaB = this.parsearFechaString(b.fechavigencia);
          return fechaB.getTime() - fechaA.getTime();
        });
        
        return tiposCambioMoneda[0].tcventa.toFixed(5);
      }
    }
    
    // Si no se encuentra ningún tipo de cambio, devolver valor por defecto
    return '3.80000';
  }

  /**
   * Convierte un string de fecha DD/MM/YYYY a objeto Date
   */
  private parsearFechaString(fechaString: string): Date {
    const [dia, mes, anio] = fechaString.split('/').map(Number);
    return new Date(anio, mes - 1, dia);
  }

  private calcularConversion(valorAdquisicion: any) {
    if (!valorAdquisicion || isNaN(valorAdquisicion)) {
      return;
    }

    const moneda = this.registroActivosForm.get('moneda')?.value;
    const tasaCambio = parseFloat(
      this.registroActivosForm.get('tasadecambio')?.value || '3.80'
    );
    const valor = parseFloat(valorAdquisicion);

    if (moneda === 'Soles') {
      // Si es en soles, calcular dólares
      const valorDolares = (valor / tasaCambio).toFixed(2);
      this.registroActivosForm.patchValue(
        {
          valorSoles: valor.toFixed(2),
          valorDolares: valorDolares,
        },
        { emitEvent: false }
      );
    } else if (moneda === 'USD') {
      // Si es en dólares, calcular soles
      const valorSoles = (valor * tasaCambio).toFixed(2);
      this.registroActivosForm.patchValue(
        {
          valorDolares: valor.toFixed(2),
          valorSoles: valorSoles,
        },
        { emitEvent: false }
      );
    }
  }

  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
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

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;

    // Seleccionar la primera fila por defecto al cargar la grilla (solo ocurre una vez)
    setTimeout(() => {
      if (this.rowData.length > 0) {
        const primerNodo = this.gridApi.getDisplayedRowAtIndex(0);
        if (primerNodo) {
          primerNodo.setSelected(true);
          this.cargarDatosRegistro(primerNodo.data);
        }
      }
    }, 100);
  }
  async abrirmodalMaestrotablas() {
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar activos',
        descripcionSubir:
          'Comparte tu archivo de excel con la información de tus ubicaciones y regístralos automáticamente en la plataforma.',
        buttonName: 'Importar activos',
      },
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
        try {
          this.importar(data);
        } catch (e) {
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

  async onCellClicked(event: any) {
    const data = event.data;

    // Prevenir la selección automática de AG-Grid
    event.node.setSelected(true);

    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Si el usuario cancela, mantener la selección anterior
      if (this.filaSeleccionada) {
        setTimeout(() => {
          this.gridApi.deselectAll();
          const rowNode = this.gridApi.getRowNode(
            this.filaSeleccionada.activo_fijo_codigo
          );
          if (rowNode) {
            rowNode.setSelected(true);
          }
        }, 0);
      } else {
        // Si no había fila seleccionada, asegurar que ninguna esté seleccionada
        this.gridApi.deselectAll();
      }
      return;
    }

    // Cargar los datos del registro seleccionado
    this.cargarDatosRegistro(data);
  }

  private cargarDatosRegistro(data: any) {
    this.camponuevo = false;
    this.filaSeleccionada = data;
    this.gridApi.deselectAll();

    // Cambiar al primer tab (Datos Generales)
    this.tabSeleccionado = 'datosGenerales';

    // Buscar el nodo y seleccionarlo
    this.gridApi.forEachNode((node) => {
      if (node.data === data) {
        node.setSelected(true);
      }
    });

    // Parsear fechas (formato DD/MM/YYYY a Date)
    let fechaAdq: Date | undefined;
    if (data.activo_fijo_fecha_adquisicion) {
      const [dia, mes, anio] = data.activo_fijo_fecha_adquisicion.split('/');
      fechaAdq = new Date(parseInt(anio), parseInt(mes) - 1, parseInt(dia));
      this.fechaAdquisicion = fechaAdq;
    }

    let fechaIniDep: Date | undefined;
    if (data.activo_fijo_fecha_inicio_depreciacion) {
      const [dia, mes, anio] = data.activo_fijo_fecha_inicio_depreciacion.split('/');
      fechaIniDep = new Date(parseInt(anio), parseInt(mes) - 1, parseInt(dia));
      this.fechaInicioDepreciacion = fechaIniDep;
    }

    let fechaAsig: Date | undefined;
    if (data.activo_fijo_fecha_asignacion) {
      const [dia, mes, anio] = data.activo_fijo_fecha_asignacion.split('/');
      fechaAsig = new Date(parseInt(anio), parseInt(mes) - 1, parseInt(dia));
      this.fechaAsignacion = fechaAsig;
    }

    // Poblar subclases según la clase del registro para que el autocomplete encuentre el valor
    const claseId = data.activo_fijo_clasificacion || '';
    if (claseId) {
      this.subclases = this.allClasificaciones
        .filter((item) => item.orgHierarchy && item.orgHierarchy.length === 2 && item.orgHierarchy[0] === claseId)
        .map((item) => ({
          id: item.clasif_activo_codigo,
          nombre: item.clasif_activo_nombre,
        }));
    }

    // Cargar TODOS los datos en el formulario
    this.registroActivosForm.patchValue({
      // Datos Generales
      codigoActivo: data.activo_fijo_codigo || '',
      nombreActivo: data.activo_fijo_descripcion || '',
      clase: claseId,
      subclase: data.activo_fijo_subclase || '',
      subclasificacion: data.activo_fijo_subclasificacion || '',
      marcaModelo: data.activo_fijo_marca_modelo || '',
      proveedor: data.activo_fijo_proveedor || '',
      documentoVinculado: data.activo_fijo_documento_vinculado || '',
      fechaAdquisicion: fechaAdq,
      moneda: data.activo_fijo_moneda || 'Soles',
      valorAdquisicion: data.activo_fijo_valor_adquisicion || '',
      tasadecambio: data.activo_fijo_tasa_cambio || '3.80',
      valorSoles: data.activo_fijo_valor_soles || '',
      valorDolares: data.activo_fijo_valor_dolares || '',
      estado: data.activo_fijo_estado || 'Activo',
      vidaUtil: data.activo_fijo_vida_util || '',
      // Datos Complementarios
      garantia: data.activo_fijo_garantia || '',
      usuarioAsignado: data.activo_fijo_usuario_asignado || '',
      valorActualizado: data.activo_fijo_valor_actualizado || '',
      observaciones: data.activo_fijo_observaciones || '',
      estadoComplementario: data.activo_fijo_estado_complementario || '',
      // Depreciación
      metodoDepreciacion: data.activo_fijo_metodo_depreciacion || '',
      tasaAnual: data.activo_fijo_tasa_anual || '',
      fechaInicioDepreciacion: fechaIniDep,
      valorResidual: data.activo_fijo_valor_residual || '',
      depreciacionAcumulada: data.activo_fijo_depreciacion_acumulada || '',
      valorNetoLibros: data.activo_fijo_valor_neto_libros || '',
      // Asignaciones
      responsableActivo: data.activo_fijo_responsable || '',
      centroCostos: data.activo_fijo_centro_costos || '',
      fechaAsignacion: fechaAsig,
      estadoAsignacion: data.activo_fijo_estado || 'Activo',
    });
    
    // Configurar campos según estado
    this.configurarCamposPorEstado(data.activo_fijo_estado || 'Activo');
    
    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }

  private async mostrarModalConfirmacion(): Promise<boolean> {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Continuar sin guardar',
        title: '¿Estas seguro de que quieres salir?',
        message: 'Si sales ahora, perderás la información ingresada',
        btnOkTxt: 'Continuar',
        btnCancelTxt: 'Cancelar',
      },
    });

    await modal.present();
    const { data } = await modal.onWillDismiss();

    return data === true;
  }

  async botonNuevoActivo() {
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Si cancela, no hacer nada
    }

    // Limpiar el formulario y preparar para nuevo registro
    this.camponuevo = true;
    this.tabSeleccionado = 'datosGenerales'; // Ir al primer tab
    this.gridApi.deselectAll();
    this.filaSeleccionada = null;
    this.registroActivosForm.reset();
    this.registroActivosForm.patchValue({ 
      estado: 'Activo',
      moneda: 'Soles',
      tasadecambio: '3.80'
    });
    
    // Habilitar todos los campos para nuevo activo
    this.configurarCamposPorEstado('Activo');
    
    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }

  botonGuardar() {
    // Solo funciona en modo edición (cuando hay fila seleccionada)
    if (!this.filaSeleccionada) {
      this.toastService.warning('No hay activo seleccionado para editar');
      return;
    }

    const formValue = this.registroActivosForm.getRawValue();
    
    // Obtener todos los activos existentes
    const activosExistentes = this.simulation.list('activoFijo') || [];
    
    // Buscar el índice del activo a actualizar
    const indice = activosExistentes.findIndex((a: any) => 
      a.id === this.filaSeleccionada.id || a.activo_fijo_codigo === this.filaSeleccionada.activo_fijo_codigo
    );
    
    if (indice === -1) {
      this.toastService.warning('No se encontró el activo para actualizar');
      return;
    }
    
    // Actualizar el activo existente manteniendo su id y código
    const activoActualizado = {
      ...activosExistentes[indice],
      activo_fijo_nombre_activo: formValue.nombreActivo,
      activo_fijo_descripcion: formValue.nombreActivo,
      activo_fijo_clasificacion: formValue.clase,
      activo_fijo_marca_modelo: formValue.marcaModelo,
      activo_fijo_proveedor: formValue.proveedor,
      activo_fijo_documento_vinculado: formValue.documentoVinculado,
      activo_fijo_fecha_adquisicion: this.formatearFecha(formValue.fechaAdquisicion || activosExistentes[indice].activo_fijo_fecha_adquisicion),
      activo_fijo_moneda: formValue.moneda,
      activo_fijo_valor_adquisicion: parseFloat(formValue.valorAdquisicion) || 0,
      activo_fijo_tasa_cambio: parseFloat(formValue.tasadecambio) || 3.80,
      activo_fijo_valor_soles: parseFloat(formValue.valorSoles) || 0,
      activo_fijo_valor_dolares: parseFloat(formValue.valorDolares) || 0,
      activo_fijo_valor_neto: parseFloat(formValue.valorAdquisicion) || 0,
      activo_fijo_estado: formValue.estado,
      activo_fijo_vida_util: parseFloat(formValue.vidaUtil) || 0,
      activo_fijo_usuario_asignado: formValue.usuarioAsignado,
      activo_fijo_estado_complementario: formValue.estadoComplementario,
      activo_fijo_metodo_depreciacion: formValue.metodoDepreciacion,
      activo_fijo_responsable: formValue.responsableActivo,
      activo_fijo_fecha_modificacion: new Date().toISOString()
    };
    
    // Reemplazar el activo en el array
    activosExistentes[indice] = activoActualizado;
    
    // Guardar todo el array actualizado usando replace()
    this.simulation.replace('activoFijo', activosExistentes);
    console.log('Activo actualizado en localStorage:', activoActualizado);
    
    this.toastService.success('Activo actualizado exitosamente');
    
    // Actualizar la fila seleccionada y recargar datos
    this.filaSeleccionada = activoActualizado;
    this.formValidationService.resetearEstado();
    this.cargarActivosFijos();
  }

  /**
   * Verifica si se puede guardar el formulario
   * Retorna true si el formulario es válido y tiene cambios
   */
  puedeGuardar(): boolean {
    return this.registroActivosForm.valid && this.registroActivosForm.dirty;
  }

  /**
   * Verifica si el botón siguiente debe estar habilitado
   * Retorna true si el tab es opcional o si todos los campos requeridos están completos
   */
  puedeAvanzar(): boolean {
    // Si el tab es opcional, siempre puede avanzar
    if (this.tabsOpcionales.includes(this.tabSeleccionado)) {
      return true;
    }

    // Validar según el tab actual
    switch (this.tabSeleccionado) {
      case 'datosGenerales':
        return this.sonValidosDatosGenerales();
      case 'datosComplementarios':
        return this.sonValidosDatosComplementarios();
      case 'Depreciación':
        return this.sonValidosDepreciacion();
      case 'Asignaciones':
        return this.sonValidosAsignaciones();
      default:
        return true;
    }
  }

  private sonValidosDatosGenerales(): boolean {
    const campos = ['nombreActivo', 'clasificacion', 'moneda', 'valorAdquisicion', 'estado'];
    return campos.every(campo => {
      const control = this.registroActivosForm.get(campo);
      return control && control.value;
    });
  }

  private sonValidosDatosComplementarios(): boolean {
    // Los datos complementarios son opcionales
    return true;
  }

  private sonValidosDepreciacion(): boolean {
    // La depreciación es opcional
    return true;
  }

  private sonValidosAsignaciones(): boolean {
    // Las asignaciones son opcionales
    return true;
  }

  /**
   * Verifica si el tab actual es el último
   */
  esUltimoTab(): boolean {
    const indiceActual = this.tabsOrden.indexOf(this.tabSeleccionado);
    return indiceActual === this.tabsOrden.length - 1;
  }

  /**
   * Navega al siguiente tab
   */
  siguienteTab(): void {
    // Validar campos del tab actual si no es opcional
    if (!this.validarTabActual()) {
      return;
    }

    const indiceActual = this.tabsOrden.indexOf(this.tabSeleccionado);
    if (indiceActual < this.tabsOrden.length - 1) {
      this.tabSeleccionado = this.tabsOrden[indiceActual + 1];
    }
  }

  /**
   * Navega al tab anterior
   */
  anteriorTab(): void {
    const indiceActual = this.tabsOrden.indexOf(this.tabSeleccionado);
    if (indiceActual > 0) {
      this.tabSeleccionado = this.tabsOrden[indiceActual - 1];
    }
  }

  /**
   * Valida los campos del tab actual
   * Retorna true si es válido o si el tab es opcional
   */
  validarTabActual(): boolean {
    // Si el tab es opcional, permitir pasar
    if (this.tabsOpcionales.includes(this.tabSeleccionado)) {
      return true;
    }

    // Validar según el tab actual
    switch (this.tabSeleccionado) {
      case 'datosGenerales':
        return this.validarDatosGenerales();
      case 'datosComplementarios':
        return this.validarDatosComplementarios();
      case 'Depreciación':
        return this.validarDepreciacion();
      case 'Asignaciones':
        return this.validarAsignaciones();
      default:
        return true;
    }
  }

  private validarDatosGenerales(): boolean {
    const campos = [
      'nombreActivo', 
      'clasificacion', 
      'marcaModelo',
      'proveedor',
      'fechaAdquisicion', 
      'moneda', 
      'valorAdquisicion',
      'valorSoles',
      'valorDolares',
      'estado',
      'vidaUtil'
    ];

    // Asegurar que los valores calculados estén presentes si hay valor de adquisición
    const valorAdq = this.registroActivosForm.get('valorAdquisicion')?.value;
    const vSoles = this.registroActivosForm.get('valorSoles')?.value;
    const vDolares = this.registroActivosForm.get('valorDolares')?.value;

    if (valorAdq && (!vSoles || !vDolares)) {
      this.calcularConversion(valorAdq);
    }

    const camposInvalidos = campos.filter(campo => {
      const control = this.registroActivosForm.get(campo);
      const valor = control?.value;
      return (valor === null || valor === undefined || valor === '');
    });

    if (camposInvalidos.length > 0) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return false;
    }
    return true;
  }

  private validarDatosComplementarios(): boolean {
    const campos = ['usuarioAsignado', 'valorActualizado'];

    const camposInvalidos = campos.filter(campo => {
      const control = this.registroActivosForm.get(campo);
      const valor = control?.value;
      return (valor === null || valor === undefined || valor === '');
    });

    if (camposInvalidos.length > 0) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return false;
    }
    return true;
  }

  private validarDepreciacion(): boolean {
    const campos = ['metodoDepreciacion', 'tasaAnual', 'fechaInicioDepreciacion', 'valorResidual', 'depreciacionAcumulada', 'valorNetoLibros'];

    const camposInvalidos = campos.filter(campo => {
      const control = this.registroActivosForm.get(campo);
      const valor = control?.value;
      return (valor === null || valor === undefined || valor === '');
    });

    if (camposInvalidos.length > 0) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return false;
    }
    return true;
  }

  private validarAsignaciones(): boolean {
    const campos = ['responsableActivo', 'centroCostos', 'fechaAsignacion', 'estadoAsignacion'];
    
    // Validar campos básicos
    const camposInvalidos = campos.filter(campo => {
      const control = this.registroActivosForm.get(campo);
      const valor = control?.value;
      return (valor === null || valor === undefined || valor === '');
    });

    // Si notificarResponsable está marcado, validar enviarNotificacionPor
    if (this.registroActivosForm.get('notificarResponsable')?.value) {
      const enviarNotificacion = this.registroActivosForm.get('enviarNotificacionPor');
      if (!enviarNotificacion || !enviarNotificacion.value) {
        camposInvalidos.push('enviarNotificacionPor');
      }
    }

    if (camposInvalidos.length > 0) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return false;
    }
    return true;
  }

  /**
   * Registra el nuevo activo en localStorage
   */
  registrarActivo(): void {
    // Validar el último tab
    if (!this.validarTabActual()) {
      return;
    }

    const formValue = this.registroActivosForm.getRawValue();
    
    // Obtener activos existentes para generar código
    const activosExistentes = this.simulation.list('activoFijo') || [];
    const nuevoCodigoNumero = activosExistentes.length > 0 
      ? Math.max(...activosExistentes.map((r: any) => parseInt(r.activo_fijo_codigo?.split('-')[1]) || 0)) + 1
      : 1;
    const nuevoCodigo = `AF-${String(nuevoCodigoNumero).padStart(3, '0')}`;

    const nuevoActivo = {
      id: Date.now().toString(),
      activo_fijo_codigo: nuevoCodigo,
      activo_fijo_nombre_activo: formValue.nombreActivo,
      activo_fijo_descripcion: formValue.nombreActivo,
      activo_fijo_clasificacion: formValue.clase,
      activo_fijo_subclasificacion: formValue.subclase,
      activo_fijo_marca_modelo: formValue.marcaModelo,
      activo_fijo_proveedor: formValue.proveedor,
      activo_fijo_documento_vinculado: formValue.documentoVinculado,
      activo_fijo_fecha_adquisicion: this.formatearFecha(formValue.fechaAdquisicion || new Date()),
      activo_fijo_periodo_contable: this.obtenerPeriodoContable(),
      activo_fijo_moneda: formValue.moneda,
      activo_fijo_valor_adquisicion: parseFloat(formValue.valorAdquisicion) || 0,
      activo_fijo_tasa_cambio: parseFloat(formValue.tasadecambio) || 3.80,
      activo_fijo_valor_soles: parseFloat(formValue.valorSoles) || 0,
      activo_fijo_valor_dolares: parseFloat(formValue.valorDolares) || 0,
      activo_fijo_valor_neto: parseFloat(formValue.valorAdquisicion) || 0,
      activo_fijo_estado: formValue.estado || 'Activo',
      activo_fijo_vida_util: parseFloat(formValue.vidaUtil) || 0,
      activo_fijo_usuario_asignado: formValue.usuarioAsignado,
      activo_fijo_valor_actualizado: parseFloat(formValue.valorActualizado) || 0,
      activo_fijo_observaciones: formValue.observaciones,
      activo_fijo_estado_complementario: formValue.estadoComplementario,
      activo_fijo_metodo_depreciacion: formValue.metodoDepreciacion,
      activo_fijo_tasa_anual: parseFloat(formValue.tasaAnual) || 0,
      activo_fijo_fecha_inicio_depreciacion: this.formatearFecha(formValue.fechaInicioDepreciacion),
      activo_fijo_valor_residual: parseFloat(formValue.valorResidual) || 0,
      activo_fijo_depreciacion_acumulada: parseFloat(formValue.depreciacionAcumulada) || 0,
      activo_fijo_valor_neto_libros: parseFloat(formValue.valorNetoLibros) || 0,
      activo_fijo_responsable: formValue.responsableActivo,
      activo_fijo_centro_costos: formValue.centroCostos,
      activo_fijo_fecha_asignacion: this.formatearFecha(formValue.fechaAsignacion),
      activo_fijo_fecha_creacion: new Date().toISOString(),
    };

    // Guardar en localStorage
    this.simulation.save('activoFijo', nuevoActivo);
    console.log('Nuevo activo guardado en localStorage:', nuevoActivo);

    this.toastService.success('¡Activo registrado exitosamente!');
    
    // Recargar datos y limpiar
    this.cargarActivosFijos();
    this.camponuevo = false;
    this.tabSeleccionado = 'datosGenerales';
    this.registroActivosForm.reset();
    this.registroActivosForm.patchValue({ 
      estado: 'Activo',
      moneda: 'Soles',
      tasadecambio: '3.80'
    });
    // Deshabilitar campos calculados
    this.registroActivosForm.get('tasadecambio')?.disable({ emitEvent: false });
    this.registroActivosForm.get('valorSoles')?.disable({ emitEvent: false });
    this.registroActivosForm.get('valorDolares')?.disable({ emitEvent: false });
    this.formValidationService.resetearEstado();
  }

  private obtenerPeriodoContable(): string {
    const fecha = new Date();
    return `${fecha.getFullYear()}${String(fecha.getMonth() + 1).padStart(2, '0')}`;
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  onGridReadyAccesorios(params: GridReadyEvent) {
    this.gridApiAccesorios = params.api;
  }

  onCellClickedAccesorios(event: any) {
    console.log('Accesorio clicked', event);
  }

  eliminarAccesorio(accesorio: any) {
    if (!accesorio || !accesorio.id) {
      this.toastService.danger('No se pudo identificar el accesorio');
      return;
    }

    // Mostrar confirmación antes de eliminar
    this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Eliminar accesorio',
        title: '¿Estás seguro?',
        message: 'Esta acción no se puede deshacer',
        btnOkTxt: 'Eliminar',
        btnCancelTxt: 'Cancelar',
      },
    }).then(modal => {
      modal.present();
      modal.onWillDismiss().then(({ data }) => {
        if (data === true) {
          this.rowDataAccesorios = this.rowDataAccesorios.filter((a: any) => a !== accesorio);
          this.toastService.success('Accesorio eliminado');
        }
      });
    });
  }

  async botonNuevoAccesorio() {
    // En modo edición, validar que haya un activo seleccionado
    // En modo nuevo, permitir agregar accesorios temporales
    if (!this.camponuevo && (!this.filaSeleccionada || !this.filaSeleccionada.id)) {
      this.toastService.warning('Primero debes seleccionar un activo fijo');
      return;
    }

    const modal = await this.modalController.create({
      component: ActivosfijosOperacionesRegistroactivosCrearAccesorioComponent,
      cssClass: 'promo',
      componentProps: {},
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.accesorio) {
      if (this.camponuevo) {
        // Modo nuevo: agregar accesorio temporal a la tabla local
        const accesorioTemporal = {
          codigo: data.accesorio.codigo || `ACC-${Date.now()}`,
          descripcion: data.accesorio.descripcion || '',
          valorIndividual: data.accesorio.valorIndividual || 0,
          relacionActivo: 'Nuevo Activo'
        };
        this.rowDataAccesorios = [...this.rowDataAccesorios, accesorioTemporal];
        this.toastService.success('Accesorio agregado');
      } else {
        // Modo edición: crear accesorio usando el servicio
        const nuevoAccesorio: Accesorio = {
          activoFijoId: this.filaSeleccionada.id,
          codigo: data.accesorio.codigo || '',
          descripcion: data.accesorio.descripcion || '',
          valorAdquisicion: data.accesorio.valorIndividual || 0,
          estado: 'activo'
        };

        this.rowDataAccesorios = [...this.rowDataAccesorios, {
          codigo: nuevoAccesorio.codigo,
          descripcion: nuevoAccesorio.descripcion,
          valorIndividual: nuevoAccesorio.valorAdquisicion ?? 0,
          relacionActivo: this.filaSeleccionada?.codigo ?? ''
        }];
        this.toastService.success('Accesorio agregado exitosamente');
      }
    }
  }

  onGridReadyIncidencias(params: GridReadyEvent) {
    this.gridApiIncidencias = params.api;
  }

  onCellClickedIncidencias(event: any) {
    console.log('Incidencia clicked', event);
  }

  async botonNuevaIncidencia() {
    // En modo edición, validar que haya un activo seleccionado
    // En modo nuevo, permitir agregar incidencias temporales
    if (!this.camponuevo && (!this.filaSeleccionada || !this.filaSeleccionada.id)) {
      this.toastService.warning('Primero debes seleccionar un activo fijo');
      return;
    }

    const modal = await this.modalController.create({
      component: ActivosfijosOperacionesRegistroactivosCrearIncidenciaComponent,
      cssClass: 'promo2',
      componentProps: {},
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.incidencia) {
      if (this.camponuevo) {
        // Modo nuevo: agregar incidencia temporal a la tabla local
        const incidenciaTemporal = {
          fechaIncidencia: this.formatearFecha(data.incidencia.fechaIncidencia) || this.formatearFecha(new Date()),
          tipoIncidencia: data.incidencia.tipoIncidencia || 'Otro',
          descripcion: data.incidencia.descripcion || '',
          accionCorrectiva: data.incidencia.accionCorrectiva || '',
          costoAsociado: data.incidencia.costoAsociado || 0,
          estado: 'Abierto'
        };
        this.rowDataIncidencias = [...this.rowDataIncidencias, incidenciaTemporal];
        this.toastService.success('Incidencia agregada');
      } else {
        // Modo edición: crear incidencia usando el servicio
        const nuevaIncidencia: Incidencia = {
          activoFijoId: this.filaSeleccionada.id,
          tipo: data.incidencia.tipoIncidencia?.toLowerCase() || 'otro',
          descripcion: data.incidencia.descripcion || '',
          fechaIncidencia: data.incidencia.fechaIncidencia || new Date(),
          costoReparacion: data.incidencia.costoAsociado || 0,
          estado: 'pendiente',
          observaciones: data.incidencia.accionCorrectiva || ''
        };

        this.rowDataIncidencias = [...this.rowDataIncidencias, {
          fechaIncidencia: this.formatearFecha(nuevaIncidencia.fechaIncidencia) ?? '',
          tipoIncidencia: nuevaIncidencia.tipo,
          descripcion: nuevaIncidencia.descripcion,
          accionCorrectiva: nuevaIncidencia.observaciones ?? '',
          costoAsociado: nuevaIncidencia.costoReparacion ?? 0,
          estado: nuevaIncidencia.estado ?? ''
        }];
        this.toastService.success('Incidencia registrada exitosamente');
      }
    }
  }

  onGridReadyAdaptaciones(params: GridReadyEvent) {
    this.gridApiAdaptaciones = params.api;
  }

  onCellClickedAdaptaciones(event: any) {
    console.log('Adaptación clicked', event);
  }

  async botonNuevaAdaptacion() {
    // En modo edición, validar que haya un activo seleccionado
    // En modo nuevo, permitir agregar adaptaciones temporales
    if (!this.camponuevo && (!this.filaSeleccionada || !this.filaSeleccionada.id)) {
      this.toastService.warning('Primero debes seleccionar un activo fijo');
      return;
    }

    const modal = await this.modalController.create({
      component: ActivosfijosOperacionesRegistroactivosCrearAdaptacionComponent,
      cssClass: 'promo2',
      componentProps: {},
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.adaptacion) {
      if (this.camponuevo) {
        // Modo nuevo: agregar adaptación temporal a la tabla local
        const adaptacionTemporal = {
          fechaAdaptacion: this.formatearFecha(data.adaptacion.fechaAdaptacion) || this.formatearFecha(new Date()),
          descripcion: data.adaptacion.descripcion || '',
          valorIncremental: data.adaptacion.valorIncremental || 0,
          responsable: data.adaptacion.responsable || ''
        };
        this.rowDataAdaptaciones = [...this.rowDataAdaptaciones, adaptacionTemporal];
        this.toastService.success('Adaptación agregada');
      } else {
        // Modo edición: crear adaptación usando el servicio
        const nuevaAdaptacion: Adaptacion = {
          activoFijoId: this.filaSeleccionada.id,
          descripcion: data.adaptacion.descripcion || '',
          tipoAdaptacion: 'mejora',
          fechaAdaptacion: data.adaptacion.fechaAdaptacion || new Date(),
          costoAdaptacion: data.adaptacion.valorIncremental || 0,
          autorizadoPor: data.adaptacion.responsable || '',
          estado: 'completada'
        };

        this.rowDataAdaptaciones = [...this.rowDataAdaptaciones, {
          fechaAdaptacion: this.formatearFecha(nuevaAdaptacion.fechaAdaptacion) ?? '',
          descripcion: nuevaAdaptacion.descripcion,
          valorIncremental: nuevaAdaptacion.costoAdaptacion ?? 0,
          responsable: nuevaAdaptacion.autorizadoPor ?? ''
        }];
        this.toastService.success('Adaptación registrada exitosamente');
      }
    }
  }

  // Métodos para Traslados
  onGridReadyTraslados(params: GridReadyEvent) {
    this.gridApiTraslados = params.api;
  }

  onCellClickedTraslados(event: any) {
    console.log('Traslado clicked', event);
  }

  async botonNuevoTraslado() {
    // En modo edición, validar que haya un activo seleccionado
    if (!this.camponuevo && (!this.filaSeleccionada || !this.filaSeleccionada.id)) {
      this.toastService.warning('Primero debes seleccionar un activo fijo');
      return;
    }

    // Abrir modal de registro de traslado
    this.abrirModalRegistrarTraslado();
  }

  scrollLeft() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: -150, behavior: 'smooth' });
  }

  scrollRight() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: 150, behavior: 'smooth' });
  }

  onClasificacionSeleccionada(clasificacion: any) {
    console.log('Clasificación seleccionada:', clasificacion);
    if (clasificacion && clasificacion.id) {
      this.registroActivosForm.patchValue({ clasificacion: clasificacion.id });
    }
  }
  onClaseSeleccionada(clase: any) {
    if (clase && clase.id) {
      this.registroActivosForm.patchValue({ clase: clase.id });
      // Filtrar subclases que pertenezcan a la clase seleccionada
      this.subclases = this.allClasificaciones
        .filter((item) => item.orgHierarchy && item.orgHierarchy.length === 2 && item.orgHierarchy[0] === clase.id)
        .map((item) => ({
          id: item.clasif_activo_codigo,
          nombre: item.clasif_activo_nombre,
        }));
      // Limpiar subclase y subclasificacion al cambiar clase
      this.registroActivosForm.patchValue({ subclase: '', subclasificacion: '' });
    }
  }
  onSubClaseSeleccionada(subclase: any) {
    if (subclase && subclase.id) {
      this.registroActivosForm.patchValue({ subclase: subclase.id });
    }
  }

  onSubclasificacionSeleccionada(subclasificacion: any) {
    console.log('Subclasificación seleccionada:', subclasificacion);
    if (subclasificacion && subclasificacion.id) {
      this.registroActivosForm.patchValue({ subclasificacion: subclasificacion.id });
    }
  }

  onUbicacionSeleccionada(ubicacion: any) {
    console.log('Ubicación seleccionada:', ubicacion);
  }

  onCentroCostosSeleccionado(centroCostos: any) {
    console.log('Centro de costos seleccionado:', centroCostos);
    if (centroCostos && centroCostos.id) {
      this.registroActivosForm.patchValue({ centroCostos: centroCostos.id });
    }
  }

  onproveedorSeleccionado(proveedor: any) {
    console.log('Proveedor seleccionado:', proveedor);
    if (proveedor && proveedor.id) {
      this.registroActivosForm.patchValue({ proveedor: proveedor.id });
    }
  }

  onUsuarioAsignadoSeleccionado(usuarioAsignado: any) {
    console.log('Usuario asignado seleccionado:', usuarioAsignado);
    if (usuarioAsignado && usuarioAsignado.id) {
      this.registroActivosForm.patchValue({ usuarioAsignado: usuarioAsignado.id });
    }
  }

  // Para modo SINGLE - Manejo de fechas seleccionadas
  onFechaAdquisicion(date: Date) {
    console.log('Fecha Adquisicion:', date);
    this.fechaAdquisicion = date;
    this.registroActivosForm.patchValue({ fechaAdquisicion: date });
  }
  onFechaInicioDepreciacion(date: Date) {
    console.log('Fecha Inicio Depreciacion:', date);
    this.fechaInicioDepreciacion = date;
    this.registroActivosForm.patchValue({ fechaInicioDepreciacion: date });
  }
  onFechaAsignacion(date: Date) {
    console.log('Fecha Asignacion:', date);
    this.fechaAsignacion = date;
    this.registroActivosForm.patchValue({ fechaAsignacion: date });
  }

  onBtReset() {
    if (this.gridApi) {
      // Mostrar loading y recargar datos
      this.gridApi.showLoadingOverlay();

      // Recargar datos desde el servicio
      this.cargarActivosFijos();

      setTimeout(() => {
        this.gridApi.hideOverlay();
      }, 500);
    }
  }

  async modalverActualizaciones() {
    if (!this.filaSeleccionada || !this.filaSeleccionada.id) {
      this.toastService.warning('No hay activo seleccionado');
      return;
    }

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

    // Historial en memoria (sin servicio externo)
    const historialVacio: any[] = [];
    const rowData = historialVacio.map(h => ({
      fechaHora: this.formatearFechaHora(h.fechaActualizacion),
      usuario: h.usuario,
      accion: this.capitalizarPrimeraLetra(h.tipo),
      detalleCambio: h.descripcion || 'Sin descripción'
    }));

    this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - ' + this.filaSeleccionada?.codigo,
        rowData: rowData.length > 0 ? rowData : [{
          fechaHora: new Date().toLocaleString('es-PE'),
          usuario: 'Sistema',
          accion: 'Sin historial',
          detalleCambio: 'No hay actualizaciones registradas para este activo'
        }],
        colDefs: colDefs,
        anchoModal: '700px',
      },
    }).then(modal => modal.present());
  }

  // ========== MÉTODOS AUXILIARES PARA EL SERVICIO ==========

  /**
   * Delega la carga de activos fijos al facade de la capa de aplicación.
   * El facade orquesta el use case → repositorio → store → signal reactivo.
   * El effect() en el constructor escucha el signal y actualiza rowData automáticamente.
   */
  private cargarActivosFijos(): void {
    this.activoFijoFacade.cargarActivosFijos();
  }

  /**
   * Mapea activos del modelo al formato de la grilla
   */
  private mapearActivosParaGrid(activos: ActivoFijo[]): any[] {
    return activos.map(activo => ({
      id: activo.id,
      codigo: activo.codigo,
      descripcion: activo.descripcion || activo.nombreActivo,
      clasificacion: activo.clasificacion,
      marcaModelo: activo.marcaModelo,
      proveedor: activo.proveedor,
      documentoVinculado: activo.documentoVinculado,
      fechaAdquisicion: this.formatearFecha(activo.fechaAdquisicion),
      periodoContable: activo.periodoContable || '',
      moneda: activo.moneda,
      valorAdquisicion: activo.valorAdquisicion,
      tasadecambio: activo.tasadecambio,
      valorSoles: activo.valorSoles,
      valorDolares: activo.valorDolares,
      valorNeto: activo.valorNetoLibros || activo.valorNeto,
      vidaUtil: activo.vidaUtil,
      estado: activo.estado,
      garantia: activo.garantiaInicio ? 'garantia1' : '',
      usuarioAsignado: activo.usuarioAsignado,
      estadoComplementario: activo.estadoComplementario,
      metodoDepreciacion: activo.metodoDepreciacion,
      responsableActivo: activo.responsableActivo
    }));
  }

  /**
   * Mapea accesorios del modelo al formato de la grilla
   */
  private mapearAccesoriosParaGrid(accesorios: Accesorio[]): any[] {
    return accesorios.map(acc => ({
      id: acc.id,
      codigo: acc.codigo,
      descripcion: acc.descripcion,
      valorIndividual: acc.valorAdquisicion || 0,
      relacionActivo: 'Activo principal'
    }));
  }

  /**
   * Mapea incidencias del modelo al formato de la grilla
   */
  private mapearIncidenciasParaGrid(incidencias: Incidencia[]): any[] {
    return incidencias.map(inc => ({
      id: inc.id,
      fechaIncidencia: this.formatearFecha(inc.fechaIncidencia),
      tipoIncidencia: this.capitalizarPrimeraLetra(inc.tipo),
      descripcion: inc.descripcion,
      accionCorrectiva: inc.observaciones || '-',
      costoAsociado: inc.costoReparacion || 0,
      estado: inc.estado === 'resuelto' ? 'Cerrado' : 'Abierto'
    }));
  }

  /**
   * Mapea adaptaciones del modelo al formato de la grilla
   */
  private mapearAdaptacionesParaGrid(adaptaciones: Adaptacion[]): any[] {
    return adaptaciones.map(adap => ({
      id: adap.id,
      fechaAdaptacion: this.formatearFecha(adap.fechaAdaptacion),
      descripcion: adap.descripcion,
      valorIncremental: adap.costoAdaptacion,
      responsable: adap.autorizadoPor || '-'
    }));
  }

  /**
   * Formatea una fecha al formato DD/MM/YYYY
   */
  private formatearFecha(fecha: Date | string | undefined): string {
    if (!fecha) return '';
    
    const date = typeof fecha === 'string' ? new Date(fecha) : fecha;
    if (isNaN(date.getTime())) return '';
    
    const dia = String(date.getDate()).padStart(2, '0');
    const mes = String(date.getMonth() + 1).padStart(2, '0');
    const anio = date.getFullYear();
    
    return `${dia}/${mes}/${anio}`;
  }

  /**
   * Formatea fecha y hora
   */
  private formatearFechaHora(fecha: Date | string | undefined): string {
    if (!fecha) return '';
    
    const date = typeof fecha === 'string' ? new Date(fecha) : fecha;
    if (isNaN(date.getTime())) return '';
    
    return date.toLocaleString('es-PE', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }

  /**
   * Capitaliza la primera letra de un string
   */
  private capitalizarPrimeraLetra(texto: string): string {
    if (!texto) return '';
    return texto.charAt(0).toUpperCase() + texto.slice(1);
  }







  /**
   * Cargar centros de costo desde localStorage (módulo de contabilidad)
   */
  private cargarCentrosCostoDesdeStorage(): void {
    console.log(' Cargando centros de costo desde localStorage...');
    
    // Leer directamente del localStorage para evitar problemas de caché
    const centrosCostoJSON = localStorage.getItem('centroCosto');
    const centrosCostoGuardados = centrosCostoJSON ? JSON.parse(centrosCostoJSON) : [];
    
    console.log(` Total de centros de costo en localStorage: ${centrosCostoGuardados.length}`);
    console.log(' Datos crudos:', centrosCostoGuardados);
    
    if (centrosCostoGuardados.length > 0) {
      // Mapear los datos al formato del autocomplete
      this.centrosCostos = centrosCostoGuardados.map((item: any) => ({
        id: item.codigo,
        nombre: `${item.codigo} - ${item.descripcion || item.nombre}`,
        descripcion: item.descripcion || ''
      }));
      
      console.log(' Centros de costo cargados:', this.centrosCostos);
    } else {
      console.log(' No hay centros de costo guardados en localStorage');
      this.centrosCostos = [];
    }
  }

  /**
   * Limpieza al destruir el componente
   */
  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }

  /**
   * Abre el modal para registrar traslado de activo
   */
  async abrirModalRegistrarTraslado() {
    // Validar que haya un activo seleccionado
    if (!this.filaSeleccionada || !this.filaSeleccionada.id) {
      this.toastService.danger('Debes seleccionar un activo para trasladarlo');
      return;
    }

    const modal = await this.modalController.create({
      component: AfORegistroactivosRegistrarTrasladoComponent,
      cssClass: 'promo2',
      componentProps: {
        activoSeleccionado: this.filaSeleccionada
      },
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.traslado) {
      // Aquí puedes procesar el traslado
      console.log('Traslado registrado:', data.traslado);
      this.toastService.success('Traslado registrado exitosamente');
      
      // Aquí podrías guardar el traslado en el repositorio correspondiente
    }
  }

  /**
   * Abre el modal para revaluar un activo
   */
  async abrirModalRevaluar() {
    // Validar que haya un activo seleccionado
    if (!this.filaSeleccionada || !this.filaSeleccionada.id) {
      this.toastService.warning('Debes seleccionar un activo para revaluarlo');
      return;
    }

    const modal = await this.modalController.create({
      component: AfORegistroactivosRevaluarComponent,
      cssClass: 'promo2',
      componentProps: {
        activoSeleccionado: this.filaSeleccionada
      },
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.revaluacion) {
      // Aquí puedes procesar la revaluación
      console.log('Revaluación registrada:', data.revaluacion);
      
      // Aquí podrías guardar la revaluación en el repositorio correspondiente
    }
  }

  /**
   * Abre el modal para dar de baja un activo
   */
  async abrirModalDarDeBaja() {
    // Validar que haya un activo seleccionado
    if (!this.filaSeleccionada || !this.filaSeleccionada.id) {
      this.toastService.warning('Debes seleccionar un activo para darlo de baja');
      return;
    }

    const modal = await this.modalController.create({
      component: AfORegistroactivosBajaComponent,
      cssClass: 'promo2',
      componentProps: {
        activoSeleccionado: this.filaSeleccionada
      },
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.baja) {
      // Aquí puedes procesar la baja
      console.log('Baja de activo registrada:', data.baja);
      
      // Aquí podrías guardar la baja en el repositorio correspondiente
    }
  }
}
