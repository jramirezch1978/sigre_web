import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ConfiguracionFacade } from 'src/app/modules/configuracion/application/facades/configuracion.facade';
import { ConfiguracionUsuariosGridEffects } from 'src/app/modules/configuracion/effects/configuracion-usuarios-grid.effect';
import { UsuarioEntity } from 'src/app/modules/configuracion/domain/models/usuario.entity';

// Font Awesome Icons
import { faEye, faEyeSlash, faAngleRight, faLock, faInfoCircle, faIdCard, faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faCirclePlus, faChevronsLeft, faChevronsRight } from '@fortawesome/pro-solid-svg-icons';
import { faUser,  } from '@fortawesome/pro-light-svg-icons';

// Font Awesome Icons



interface IRow {
  usuario_usuario: string;
  usuario_nombre: string;
  usuario_apellido: string;
  usuario_cargo: string;
  usuario_estado: string;
}

@Component({
  selector: 'app-a-l-usuarios',
  templateUrl: './a-l-usuarios.component.html',
  styleUrls: ['./a-l-usuarios.component.scss'],
  standalone: false,
})
export class ALUsuariosComponent implements OnInit, OnDestroy {
  // Facades y Effects
  private readonly configuracionFacade = inject(ConfiguracionFacade);
  private readonly usuariosGridEffects = inject(ConfiguracionUsuariosGridEffects);

  // Selectores del store
  readonly isLoading = this.configuracionFacade.loadingUsuarios;

  get rowData(): UsuarioEntity[] {
    return this.usuariosGridEffects.getRowData();
  }

  // Font Awesome Icons
  farEye = faEye;
  farEyeSlash = faEyeSlash;
  farAngleRight = faAngleRight;
  farLock = faLock;
  falInfoCircle = faInfoCircle;
  farIdCard = faIdCard;
  falUser = faUser;
  farBook = faBook;
  farSearch = faSearch;
  fasCirclePlus = faCirclePlus;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;

  panelLateralVisible: boolean = true;
  private gridApi!: GridApi;
  gridContext!: { componentParent: ALUsuariosComponent };
  filaSeleccionada: any = null;
  isResetting = false;
  tipo='password';
  moduloSeleccionado: any = null;
  moduloSeleccionadoIndex: number = -1;
  modoCreacion: boolean = true;
  botonRegistroHabilitado: boolean = true;

  usuarioForm!:FormGroup;
  
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
  columnTypes: any = {};
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  cargos: string[] = ['Administrador', 'Supervisor', 'Operador'];
  estados: string[] = ['Activo', 'Inactivo'];

  modulos = [
    {
      nombre: 'Almacén',
      submodulo: [
        { nombre: 'Tablas', selectodos: true, items: [
          { nombre: 'Almacén', seleccionado: true },
          { nombre: 'Tipos de movimiento por almacenes', seleccionado: true },
          { nombre: 'Clases de productos', seleccionado: true },
          { nombre: 'Maestro de productos', seleccionado: true }
        ]},
        { nombre: 'Operaciones', selectodos: true, items: [
          { nombre: 'Requerimientos de traslado entre almacenes', seleccionado: true },
          { nombre: 'Despacho de productos', seleccionado: true },
          { nombre: 'Recepción de mercadería', seleccionado: true },
          { nombre: 'Almacenamiento de mercadería', seleccionado: true },
          { nombre: 'Registro y gestión de devoluciones', seleccionado: true },
          { nombre: 'Reposición de stock', seleccionado: true },
          { nombre: 'Comparacion de inventario', seleccionado: true },
          { nombre: 'Registro de Pérdidas/Mermas', seleccionado: true },
        ]},
        { nombre: 'Consultas', selectodos: true, items: [
          { nombre: 'Kardex / Movimiento de inventario', seleccionado: true },
          { nombre: 'Órdenes de compra', seleccionado: true },
          { nombre: 'Consulta de productos', seleccionado: true },
          { nombre: 'Préstamos de mercadería', seleccionado: true },
          { nombre: 'Devoluciones a Proveedores', seleccionado: true },
        ]},
        { nombre: 'Reportes', selectodos: true, items: [
          { nombre: 'Stock a la fecha', seleccionado: true },
          { nombre: 'Historial de movimiento', seleccionado: true },
          { nombre: 'Valorizacion', seleccionado: true },
          { nombre: 'Productos vendidos por periodo', seleccionado: true },
          { nombre: 'Stock mínimo', seleccionado: true },
          { nombre: 'Diagnostico de almacenes', seleccionado: true },
          { nombre: 'Reportes de tomas de inventario', seleccionado: true },
        ]},
        { nombre: 'Procesos', selectodos: true, items: [
          { nombre: 'Recálculo de precios promedio', seleccionado: true },
          { nombre: 'Cuadres de stock', seleccionado: true },
          { nombre: 'Actualización automática', seleccionado: true },
        ]}
      ]
    },
    {
      nombre: 'Compras',
      submodulo: [
        { nombre: 'Tablas', selectodos: true, items: [
          { nombre: 'Proveedores', seleccionado: true },
          { nombre: 'Condiciones de pago', seleccionado: true }
        ]},
        { nombre: 'Operaciones', selectodos: true, items: [
          { nombre: 'Aprovisionamiento', seleccionado: true },
          { nombre: 'Generar orden de compra', seleccionado: true },
          { nombre: 'Aprobar orden de compra', seleccionado: true },
          { nombre: 'Generar orden de servicio', seleccionado: true },
          { nombre: 'Aprobar orden de servicio', seleccionado: true },
          { nombre: 'Registro de comprobantes', seleccionado: true },
          { nombre: 'Notas de crédito / débito', seleccionado: true },
          { nombre: 'Facturas que pertenecen a gastos', seleccionado: true },
        ]},
        { nombre: 'Reportes', selectodos: true, items: [
          { nombre: 'Reportes de compras', seleccionado: true },
          { nombre: 'Reporte de compras en tránsito', seleccionado: true },
          { nombre: 'Reporte de compras por ingresar', seleccionado: true },
          { nombre: 'Reporte de análisis de proveedores', seleccionado: true },
          { nombre: 'Reporte de compras por categorías', seleccionado: true },
          { nombre: 'Reporte de Gestión de compras', seleccionado: true },
          { nombre: 'Reporte de compras sugeridas', seleccionado: true },
        ]}
      ]
    },
    {
      nombre: 'Ventas',
      submodulo: [
        // { nombre: 'Tablas', selectodos: true, items: [
        //   { nombre: 'Clientes', seleccionado: true },
        //   { nombre: 'Vendedores', seleccionado: true },
        //   { nombre: 'Lista de precios', seleccionado: true }
        // ]},
        { nombre: 'Operaciones', selectodos: true, items: [
          { nombre: 'Facturación de regalías', seleccionado: true }
        ]},
        // { nombre: 'Consultas', selectodos: true, items: [
        //   { nombre: 'Facturación', seleccionado: true },
        //   { nombre: 'Cuentas por cobrar', seleccionado: true }
        // ]},
        { nombre: 'Reportes', selectodos: true, items: [
          { nombre: 'Reporte tributario por periodo', seleccionado: true },
          { nombre: 'Reporte de ventas', seleccionado: true }
        ]}
      ]
    },
    {
      nombre: 'Finanzas',
      submodulo: [
        { nombre: 'Tablas', selectodos: true, items: [
          { nombre: 'Documentos', seleccionado: true },
          { nombre: 'Conceptos Financieros', seleccionado: true },
          { nombre: 'Grupos y códigos de flujos de caja', seleccionado: true },
        ]},
        { nombre: 'Operaciones', selectodos: true, items: [
          { nombre: 'Canje y reprogramación de vencimiento', seleccionado: true },
          { nombre: 'Relación de documentos por proveedor', seleccionado: true },
          { nombre: 'Aplicación de Pagos Recibidos a Documentos', seleccionado: true },
          { nombre: 'Registro de Letras de Cambio Emitidas a Clientes como Forma de Pago', seleccionado: true },
          { nombre: 'Registro de facturas que pertenecen a otros ingresos', seleccionado: true },
          { nombre: 'Relación de documentos por cliente', seleccionado: true },
        ]},
        { nombre: 'Consultas', selectodos: true, items: [
          { nombre: 'Consultas de saldos de caja y bancos', seleccionado: true },
          { nombre: 'Consultas de flujo de caja', seleccionado: true },
          { nombre: 'Documentos por finanzas', seleccionado: true },
        ]},
        { nombre: 'Adelantos', selectodos: true, items: [
          { nombre: 'Generación de érdenes de giro', seleccionado: true },
          { nombre: 'Aprobación de órdenes de giro', seleccionado: true },
          { nombre: 'Liquidación de rendición de gastos', seleccionado: true },
          { nombre: 'Aprobación de liquidación de adeantos', seleccionado: true },
          { nombre: 'Cierre de liquidación de adelantos', seleccionado: true },
        ]},
        { nombre: 'Tesorería', selectodos: true, items: [
          { nombre: 'Carteras de pagos', seleccionado: true },
          { nombre: 'Carteras de cobros', seleccionado: true },
          { nombre: 'Pagos masivos', seleccionado: true },
          { nombre: 'Aplicación de pagos', seleccionado: true },
          { nombre: 'Anulación o reversión de pago', seleccionado: true },
          { nombre: 'Movimiento entre cuentas bancarias y cajas', seleccionado: true },
          { nombre: 'Programación de Pagos por Realizar por Vencimientos', seleccionado: true },
          { nombre: 'Ejecución de pagos a ente tributario', seleccionado: true },
          { nombre: 'Pago de Detracciones', seleccionado: true },
          { nombre: 'Asignación de Fondo Fijo de Caja', seleccionado: true },
          { nombre: 'Asignación de caja chica', seleccionado: true },
          { nombre: 'Registro de egresos menores', seleccionado: true },
          { nombre: 'Proyección de los ingresos y egresos', seleccionado: true },
          { nombre: 'Registro de ingresos del día', seleccionado: true },
        ]},
        { nombre: 'Conciliaciones', selectodos: true, items: [
          { nombre: 'Cruce de extracto bancario', seleccionado: true },
          { nombre: 'Cruce de informacion en pasarela', seleccionado: true },
          { nombre: 'Conciliaciones bancarias', seleccionado: true },
        ]},
        { nombre: 'Reportes', selectodos: true, items: [
          { nombre: 'Cuentas por pagar', seleccionado: true },
          { nombre: 'Tesorería', seleccionado: true },
          { nombre: 'Documentos y clientes', seleccionado: true },
          { nombre: 'Obligaciones por vencer', seleccionado: true },
          { nombre: 'Finanzas', seleccionado: true },
        ]},
      ]
    },
    {
      nombre: 'Contabilidad',
      submodulo: [
        { nombre: 'Tablas', selectodos: true, items: [
          { nombre: 'Plan contable', seleccionado: true },
          { nombre: 'Plan de centros de costo', seleccionado: true },
          { nombre: 'Contabilidad', seleccionado: true },
          { nombre: 'Impuestos', seleccionado: true },
          { nombre: 'Plan de cuentas vs Subcategorias', seleccionado: true },
          { nombre: 'Tipo de cambio', seleccionado: true },
        ]},
        { nombre: 'Reportes', selectodos: true, items: [
          { nombre: 'Reportes de Maestros Contables', seleccionado: true },
          { nombre: 'Reportes de validación', seleccionado: true },
          { nombre: 'Reportes de libros contables', seleccionado: true },
          { nombre: 'Reportes financieros', seleccionado: true },
          { nombre: 'Análisis de Cuenta Contable', seleccionado: true },
        ]},
        { nombre: 'Operaciones', selectodos: true, items: [
          { nombre: 'Gestión de asientos manual', seleccionado: true },
          { nombre: 'Gestión de asientos contables automáticos', seleccionado: true },
          { nombre: 'Ajustes y Reclasificación contable', seleccionado: true },
        ]},
        { nombre: 'Procesos', selectodos: true, items: [
          { nombre: 'Consistencia de asientos', seleccionado: true },
          { nombre: 'Procesos de ajustes contables', seleccionado: true },
          { nombre: 'Clonación de asientos contables', seleccionado: true },
          { nombre: 'Procesos de cierre contable', seleccionado: true },
        ]},
        { nombre: 'Consultas', selectodos: true, items: [
          { nombre: 'Saldos de cuentas corriente', seleccionado: true },
          { nombre: 'Centro de costos por trabajador', seleccionado: true },
        ]}
      ]
    },
    {
      nombre: 'Activos Fijos',
      submodulo: [
        { nombre: 'Tablas', selectodos: true, items: [
          { nombre: 'Maestro de tablas', seleccionado: true },
          { nombre: 'Operaciones', seleccionado: true },
          { nombre: 'Incidencias', seleccionado: true },
          { nombre: 'Aseguradoras', seleccionado: true },
          { nombre: 'Seguros', seleccionado: true },
          { nombre: 'Clasificación de Activos', seleccionado: true },
          { nombre: 'Matrices contables', seleccionado: true },
          { nombre: 'Ubicación de Activos', seleccionado: true },
          { nombre: 'Parámetros de operaciones', seleccionado: true },
          { nombre: 'Configuración de numeración de activos', seleccionado: true },
          { nombre: 'Configuración de numeración de traslados', seleccionado: true },
        ]},
        { nombre: 'Operaciones', selectodos: true, items: [
          { nombre: 'Registro de Traslado', seleccionado: true },
          { nombre: 'Aprobación de Traslado', seleccionado: true },
          { nombre: 'Recepción de Traslados de Activos Fijos', seleccionado: true },
          { nombre: 'Operaciones Especiales', seleccionado: true },
          { nombre: 'Pólizas de Seguro', seleccionado: true },
          { nombre: 'Asignación de ratios de depreciación', seleccionado: true },
          { nombre: 'Proceso de baja de activos', seleccionado: true },
        ]},
        { nombre: 'Reportes', selectodos: true, items: [
          { nombre: 'Resumen Activo Fijo', seleccionado: true },
          { nombre: 'Depreciación Anual por Activo', seleccionado: true },
          { nombre: 'Resumen de Activo Fijo Por Rangos', seleccionado: true },
        ]},
        { nombre: 'Procesos', selectodos: true, items: [
          { nombre: 'Cálculo de Depreciación', seleccionado: true },
          { nombre: 'Generación de Asientos de Depreciación', seleccionado: true },
          { nombre: 'Generación de Asientos de Revaluación', seleccionado: true },
          { nombre: 'Generación de Asientos de Indexación', seleccionado: true },
          { nombre: 'Generación de Devengo Mensual de Aseguradores', seleccionado: true },
          { nombre: 'Generación de Asientos de Siniestro y Recupero', seleccionado: true },
        ]},
      ]
    },
    {
      nombre: 'RR.HH',
      submodulo: [
        { nombre: 'Consultas y Validaciones', selectodos: true, items: [
          { nombre: 'Inasistencias', seleccionado: true },
          { nombre: 'Reportes de planilla', seleccionado: true },
          { nombre: 'Análisis de inconsistencias en nómina', seleccionado: true },
        ]},
        { nombre: 'Maestros de Personal', selectodos: true, items: [
          { nombre: 'Datos personales y contacto', seleccionado: true },
          { nombre: 'Definición de categorías laborales', seleccionado: true },
          { nombre: 'Definición de cargo', seleccionado: true },
          { nombre: 'Definición de areas y jerarquias', seleccionado: true },
          { nombre: 'Afiliacion a Fondos de pensiones, Salud y Riesgos Laborales', seleccionado: true },
        ]},
        { nombre: 'Asistencia y Jornadas', selectodos: true, items: [
          { nombre: 'Calendarios laborales', seleccionado: true },
          { nombre: 'Asistencias y horas extra', seleccionado: true },
          { nombre: 'Permisos', seleccionado: true },
          { nombre: 'Aprobación de permisos', seleccionado: true },
          { nombre: 'Vacaciones y licencias', seleccionado: true },
          { nombre: 'Aprobar vacaciones y licencias', seleccionado: true },
        ]},
        { nombre: 'Procesos de Nómina', selectodos: true, items: [
          { nombre: 'Conceptos', seleccionado: true },
          { nombre: 'Cálculo de planillas', seleccionado: true },
          { nombre: 'Registrar liquidación', seleccionado: true },
          { nombre: 'Aprobar liquidación', seleccionado: true },
          { nombre: 'Procesos especiales', seleccionado: true },
          { nombre: 'Provisión de Gasto', seleccionado: true },
        ]},
        { nombre: 'Reportes y Analítica', selectodos: true, items: [
          { nombre: 'Emisión de Boletas y Planillas', seleccionado: true },
          { nombre: 'Distribución de Costos por Centros de Costo y Canal', seleccionado: true },
          { nombre: 'Indicadores de Rotación y Ausentismo', seleccionado: true },
          { nombre: 'Generación de archivos regulatorios laborales y tributarios', seleccionado: true },
          { nombre: 'Dashboard de RR.HH', seleccionado: true },
        ]},
        { nombre: 'Parámetros generales', selectodos: true, items: [
          { nombre: 'Configuración de Frecuencia y Calendarios de Pago', seleccionado: true },
          { nombre: 'Registro de Remuneración Mínima por País y Vigencia', seleccionado: true },
          { nombre: 'Generación de Numeración Automática para Documentos del Módulo de RR.HH.', seleccionado: true },
          { nombre: 'Agrupación de Trabajadores por Sede, Centro de Costo, Canal, Cargo y Salario', seleccionado: true },
          { nombre: 'Configuración de Provisiones de Gastos de Planillas', seleccionado: true },
          { nombre: 'Tipo de contrato', seleccionado: true },
        ]}
      ]
    },
    {
      nombre: 'Producción',
      submodulo: [
        { nombre: 'Procesos', selectodos: true, items: [
          { nombre: 'Asignación de gastos indirectos de fabricación', seleccionado: true },
        ]}
      ]
    },
    {
      nombre: 'Configuración',
      submodulo: [
        { nombre: 'Localización', selectodos: true, items: [
          { nombre: 'Retenciones', seleccionado: true },
          { nombre: 'Monedas', seleccionado: true },
          { nombre: 'Ejercicios y Periodos', seleccionado: true },
          { nombre: 'Cuentas bancarias', seleccionado: true },
          { nombre: 'Canales de pago y cobro', seleccionado: true },
          { nombre: 'Condiciones de pago y cobro', seleccionado: true },
          { nombre: 'Usuarios', seleccionado: true },
        ]},
        { nombre: 'Ajustes', selectodos: true, items: [
          { nombre: 'Datos Generales de la cuenta', seleccionado: true },
          { nombre: 'Plantillas de Notificación para Asignación de Activos', seleccionado: true },
        ]},
        { nombre: 'Compañías', selectodos: true, items: [
          { nombre: 'Compañias, Sucursales Y Transacciones', seleccionado: true },
        ]}
      ]
    }
  ];

  colDefs: ColDef[] = [
    { field: 'usuario_usuario', headerName: 'Usuario', width: 80 },
    { field: 'usuario_nombre', headerName: 'Nombre', width: 70 },
    { field: 'usuario_apellido', headerName: 'Apellido', width: 70 },
    { field: 'usuario_cargo', headerName: 'Cargo', width: 80, filter: true },
    { field: 'usuario_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>`;
        } else if (params.value === 'Inactivo') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>`;
        }
        return params.value;
      },
    },
  ];
  
  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService
  ) {
  }

  ngOnInit() {
    this.usuarioForm = this.formBuilder.group({
      usuario: ['', Validators.required],
      clave: ['', Validators.required],
      cargo: ['', Validators.required],
      estado: ['Activo', Validators.required],

      nombres: ['', Validators.required],
      apellidos: ['', Validators.required],
      telefono: [''],
      email: ['', Validators.required],
      dni: ['', Validators.required],
      direccion: [''],

      // permisos: [],
    });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.usuarioForm);
    this.formValidationService.resetearEstado();

    // Contexto de la grilla (si se usa en cellRenderers u otros)
    this.gridContext = { componentParent: this };

    // Seleccionar el primer módulo por defecto
    if (this.modulos.length > 0) {
      this.moduloSeleccionado = this.modulos[0];
      this.moduloSeleccionadoIndex = 0;
    }

    // Cargar usuarios desde el JSON a través de la capa de infraestructura
    this.configuracionFacade.cargarUsuarios();
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  togglePassword(){
    if(this.tipo=='password'){
      this.tipo='text';
    }else{
      this.tipo='password';
    }
  }

  onBtReset() {
    this.isResetting = true;
    this.configuracionFacade.cargarUsuarios();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.usuariosGridEffects.setGridApi(params.api);
    if (this.filaSeleccionada) {
      const prevData = this.filaSeleccionada;
      setTimeout(() => {
        this.gridApi?.forEachNode((node) => {
          if (node.data === prevData) {
            node.setSelected(true);
          }
        });
      }, 0);
    }
  }

  async onCellClicked(event: any) {
    const data = event.data;
    const clickedNode = event.node;
    if (!data) { return; }

    // Guardar referencia del elemento que tiene el foco
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar cambios ANTES de cualquier operación de grid
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Re-seleccionar la fila anterior por referencia de objeto
      if (this.filaSeleccionada && this.gridApi) {
        const prevData = this.filaSeleccionada;
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
            if (node.data === prevData) {
              node.setSelected(true);
            }
          });
        }, 0);
      }

      // Restaurar foco si es un input
      if (elementoConFoco && elementoConFoco.tagName === 'INPUT') {
        setTimeout(() => elementoConFoco.focus(), 100);
      }
      return;
    }

    // Usuario confirmó - cargar nuevos datos
    this.filaSeleccionada = data;
    this.modoCreacion = false;
    this.cargarDatosFormulario(data);
    setTimeout(() => {
      this.gridApi?.deselectAll();
      clickedNode?.setSelected(true);
    }, 0);
  }

  cargarDatosFormulario(data: any) {
    this.usuarioForm.patchValue({
      usuario: data.usuario_usuario || '',
      clave: data.usuario_clave || '',
      cargo: data.usuario_cargo || '',
      estado: data.usuario_estado || 'Activo',
      nombres: data.usuario_nombre || '',
      apellidos: data.usuario_apellido || '',
      telefono: data.usuario_telefono || '',
      email: data.usuario_email || '',
      dni: data.usuario_dni || '',
      direccion: data.usuario_direccion || ''
    });
    
    // Resetear servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }

  async nuevoUsuario() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.usuarioForm.reset({
      estado: 'Activo'
    });
    
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }
  botonGuardar() {
    if (this.usuarioForm.valid) {
      const formValues = this.usuarioForm.value;
      const rowData = this.usuariosGridEffects.getRowData();
      
      if (this.modoCreacion) {
        // Agregar nuevo usuario a la tabla
        const nuevoUsuario: UsuarioEntity = {
          usuario_usuario: formValues.usuario,
          usuario_nombre: formValues.nombres,
          usuario_apellido: formValues.apellidos,
          usuario_cargo: formValues.cargo,
          usuario_estado: formValues.estado,
          usuario_email: formValues.email,
          usuario_dni: formValues.dni,
          usuario_telefono: formValues.telefono,
          usuario_clave: formValues.clave,
          usuario_direccion: formValues.direccion
        };
        
        this.usuariosGridEffects.setRowData([...rowData, nuevoUsuario]);
        
        this.toastService.success('¡Usuario registrado exitosamente!');
        
        // Limpiar formulario para registro rápido
        this.modoCreacion = true;
        this.filaSeleccionada = null;
        this.usuarioForm.reset({
          estado: 'Activo'
        });
        
        // Desmarcar en la tabla
        if (this.gridApi) {
          this.gridApi.deselectAll();
        }
        
        // Resetear servicio de validación
        this.formValidationService.resetearEstado();
      } else {
        // Editar usuario existente
        const index = rowData.findIndex((item: UsuarioEntity) => item === this.filaSeleccionada);
        
        if (index !== -1) {
          const usuarioActualizado: UsuarioEntity = {
            usuario_usuario: formValues.usuario,
            usuario_nombre: formValues.nombres,
            usuario_apellido: formValues.apellidos,
            usuario_clave: formValues.clave,
            usuario_cargo: formValues.cargo,
            usuario_estado: formValues.estado,
            usuario_email: formValues.email,
            usuario_dni: formValues.dni,
            usuario_telefono: formValues.telefono,
            usuario_direccion: formValues.direccion
          };
          
          const updatedData = [...rowData];
          updatedData[index] = usuarioActualizado;
          this.filaSeleccionada = usuarioActualizado;
          
          this.usuariosGridEffects.setRowData(updatedData);
          
          // Re-seleccionar la fila editada
          setTimeout(() => {
            this.gridApi?.forEachNode((node) => {
              if (node.data === usuarioActualizado) {
                node.setSelected(true);
              }
            });
          }, 100);
          
          this.toastService.success('¡Cambios guardados exitosamente!');
        }
        
        // Marcar como pristine después de guardar edición
        this.usuarioForm.markAsPristine();
        
        // Resetear servicio de validación
        this.formValidationService.resetearEstado();
      }
    } else {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
    }
  }

  async botonCancelar() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    this.usuarioForm.reset({
      estado: 'Activo'
    });
    this.usuarioForm.markAsPristine();
    this.usuarioForm.markAsUntouched();
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    this.formValidationService.resetearEstado();
  }
  
  async modalverActualizaciones(): Promise<void> {
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'historial_actualizacion_fecha_hora', width: 150, },
      { headerName: 'Usuario', field: 'historial_actualizacion_usuario', width: 120, },
      {
        headerName: 'Acción', field: 'historial_actualizacion_accion', width: 150,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
      {
        headerName: 'Detalle del cambio', field: 'historial_actualizacion_detalle_cambio', flex: 1,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
    ];

    const rowData = [
      { historial_actualizacion_fecha_hora: '12/11/2025 10:30', historial_actualizacion_usuario: 'Juan Pérez', historial_actualizacion_accion: 'Creación', historial_actualizacion_detalle_cambio: 'Registro de usuario administrado'},
      { historial_actualizacion_fecha_hora: '12/11/2025 14:15', historial_actualizacion_usuario: 'María González', historial_actualizacion_accion: 'Actualización', historial_actualizacion_detalle_cambio: 'Cambio de contraseña"'},
      { historial_actualizacion_fecha_hora: '13/11/2025 09:00', historial_actualizacion_usuario: 'Carlos Rodríguez', historial_actualizacion_accion: 'Actualización', historial_actualizacion_detalle_cambio: 'Se modificó la dirección y el número de teléfono'},
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones del Usuario',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }

  seleccionarTodosTabla(tabla: any) {
    tabla.items.forEach((item: any) => {
      item.seleccionado = tabla.selectodos;
    });
  }

  seleccionarModulo(modulo: any) {
    this.moduloSeleccionado = modulo;
    this.moduloSeleccionadoIndex = this.modulos.indexOf(modulo);
  }

  obtenerTotalSeleccionados(modulo: any): number {
    let total = 0;
    modulo.submodulo.forEach((submod: any) => {
      submod.items.forEach((item: any) => {
        if (item.seleccionado) {
          total++;
        }
      });
    });
    return total;
  }

  obtenerTotalItems(modulo: any): number {
    let total = 0;
    modulo.submodulo.forEach((submod: any) => {
      total += submod.items.length;
    });
    return total;
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }
}

