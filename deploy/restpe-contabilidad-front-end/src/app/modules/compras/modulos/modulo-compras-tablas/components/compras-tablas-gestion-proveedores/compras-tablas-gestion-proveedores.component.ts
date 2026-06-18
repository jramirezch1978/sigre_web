import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { AbstractControl, FormBuilder, FormControl, FormGroup, ValidationErrors, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent, RowNodeTransaction } from 'ag-grid-community';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalNuevaCondicionComponent } from '../modals/modal-nueva-condicion/modal-nueva-condicion.component';
import { ModalsAgregarCuentaComponent } from '../modals/modals-agregar-cuenta/modals-agregar-cuenta.component';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ViewChild } from '@angular/core';
import { AcciEditEliminarComponent } from 'src/app/ui/acci-edit-eliminar/acci-edit-eliminar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ProveedorFacade } from '../../../../application/facades/proveedor.facade';
import { CuentaBancariaEntity, ProveedorEntity } from '../../../../domain/models/proveedor.entity';
import { ProveedorFeedbackEffects } from '../../../../effects/proveedor-feedback.effect';
import { CondicionPagoFacade } from '../../../../application/facades/condicion-pago.facade';
import { ApiClientService } from 'src/app/core/infrastructure/http/api-client.service';
import { ActivatedRoute } from '@angular/router';
import { RelacionComercialModeService } from '../../../../infrastructure/services/relacion-comercial-mode.service';
import { catchError, of } from 'rxjs';

// Font Awesome Icons
import { faBook, faInfoCircle, faSearch as faSearchRegular } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faGear, faRotateRight, faSearch as faSearchSolid } from '@fortawesome/pro-solid-svg-icons';

// Font Awesome Icons



@Component({
  selector: 'app-compras-tablas-gestion-proveedores',
  templateUrl: './compras-tablas-gestion-proveedores.component.html',
  styleUrls: ['./compras-tablas-gestion-proveedores.component.scss'],
  standalone: false,
})
export class ComprasTablasGestionProveedoresComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farBook = faBook;
  farInfoCircle = faInfoCircle;
  farSearch = faSearchRegular;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasGear = faGear;
  fasRotateRight = faRotateRight;
  fasSearch = faSearchSolid;


  // datostabla: any;

  GestionProveedoresForm!: FormGroup;
  proveedorForm!: FormGroup;
  ComercialForm!: FormGroup;
  estadoSeleccionado: string = '';
  mostrartabla: boolean = true;
  gridApi!: GridApi;
  isloading = false;
  gridApiBancaria!: GridApi;
  @ViewChild('autocompleteCondiciones') autocompleteCondiciones: any;
  campoeditar: boolean = true;
  filaSeleccionada: any = null; // Almacena la fila que se está editando
  tituloform = ''
  tabSeleccionadoDetalle: string = 'general'; // Tab seleccionado por defecto
  modoEdicion: boolean = false; // Indica si está en modo edición o creación
  modoCreacion: boolean = true; // Indica si está creando un nuevo proveedor
  textoBotonRegistrar: string = 'Registrar'; // Texto del botón que cambia según el modo
  countries = ALL_COUNTRIES;
  tipoIdentificacionSeleccionado: any = null; // Almacena el tipo de identificación actual

  /**
   * Límites máximos por campo. Alineados con la capacidad típica de las columnas
   * de core.entidad_contribuyente / contactos en el backend. Ajustar si el backend
   * confirma capacidades distintas.
   */
  readonly limites = {
    razonSocial: 200,
    nombreComercial: 150,
    direccionFiscal: 250,
    email: 100,
    telefono: 15,
    documento: 11,
    contactoNombre: 150,
    contactoCargo: 100,
  };

  /** Patrón de email razonablemente estricto. */
  private static readonly EMAIL_PATTERN =
    /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

  /**
   * Sanitiza un campo numérico: elimina cualquier carácter que no sea dígito
   * mientras el usuario escribe o pega (RUC, teléfonos). Respeta el límite máximo.
   */
  soloDigitos(form: FormGroup, control: string, event: any, maxLength?: number): void {
    const input = event?.target as { value?: string } | null;
    const original = String(event?.detail?.value ?? input?.value ?? '');
    let limpio = original.replace(/\D/g, '');
    if (maxLength && limpio.length > maxLength) {
      limpio = limpio.slice(0, maxLength);
    }
    if (limpio !== original) {
      form.get(control)?.setValue(limpio);
      if (input) {
        input.value = limpio;
      }
    }
  }

  /**
   * Restringe un control de formulario directamente sobre su valor (independiente
   * del comportamiento de ion-input). Trunca a `max` caracteres y, opcionalmente,
   * elimina todo lo que no sea dígito. Es la garantía real de que el campo nunca
   * supera el límite, escriba o pegue el usuario.
   */
  private restringirCampo(
    form: FormGroup,
    control: string,
    max: number,
    soloNumeros = false
  ): void {
    const c = form.get(control);
    if (!c) {
      return;
    }
    c.valueChanges.subscribe((valor) => {
      if (valor == null) {
        return;
      }
      const original = String(valor);
      let limpio = soloNumeros ? original.replace(/\D/g, '') : original;
      if (limpio.length > max) {
        limpio = limpio.slice(0, max);
      }
      if (limpio !== original) {
        c.setValue(limpio, { emitEvent: false });
      }
    });
  }

  /**
   * Trunca un campo de texto al máximo permitido mientras el usuario escribe o
   * pega. Refuerza el atributo maxlength para que nunca supere el límite.
   */
  limitarTexto(form: FormGroup, control: string, event: any, maxLength: number): void {
    const input = event?.target as { value?: string } | null;
    const original = String(event?.detail?.value ?? input?.value ?? '');
    if (original.length > maxLength) {
      const recortado = original.slice(0, maxLength);
      form.get(control)?.setValue(recortado);
      if (input) {
        input.value = recortado;
      }
    }
  }

  /** Rechaza valores que solo contienen espacios en blanco. */
  static noSoloEspacios(control: AbstractControl): ValidationErrors | null {
    const valor = control.value;
    if (valor == null || valor === '') {
      return null; // de esto se encarga Validators.required
    }
    return String(valor).trim().length === 0 ? { soloEspacios: true } : null;
  }

  // Inyección del Facade y Effects
  private readonly proveedorFacade = inject(ProveedorFacade);
  private readonly feedbackEffects = inject(ProveedorFeedbackEffects);
  private readonly condicionPagoFacade = inject(CondicionPagoFacade);
  private readonly api = inject(ApiClientService);
  private readonly route = inject(ActivatedRoute);
  private readonly relacionModo = inject(RelacionComercialModeService);

  /** true cuando la pantalla opera en modo Cliente (ruta gestion-clientes). */
  esModoCliente = false;
  /** Etiqueta de la entidad según el modo ('Proveedor' | 'Cliente'). */
  get entidadLabel(): string {
    return this.esModoCliente ? 'Cliente' : 'Proveedor';
  }

  // Selectores del store para UI reactiva
  readonly proveedores = this.proveedorFacade.proveedores;
  readonly isLoading = this.proveedorFacade.isLoading;
  readonly loadingObtener = this.proveedorFacade.loadingObtener;
  readonly loadingGuardar = this.proveedorFacade.loadingGuardar;
  readonly loadingEliminar = this.proveedorFacade.loadingEliminar;
  readonly loadingActualizar = this.proveedorFacade.loadingActualizar;

  condicionesPago: any[] = [];

  tiposIdentificacion: any[] = [
    // { value: 'dni', label: 'DNI' },
    // { value: 'ruc', label: 'RUC' }
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
  rowDataBancaria: CuentaBancariaEntity[] = [

  ];

  // Cuentas bancarias disponibles para el autocomplete
  cuentasBancariasDisponibles: CuentaBancariaEntity[] = [
    { cuenta_bancaria_banco: 'BCP', cuenta_bancaria_numero_cuenta: '194-12345678-0-12', cuenta_bancaria_cci: '00219400123456780112', cuenta_bancaria_tipo: 'Corriente', cuenta_bancaria_moneda: 'Soles', cuenta_bancaria_estado: 'Activo' },
    { cuenta_bancaria_banco: 'BBVA', cuenta_bancaria_numero_cuenta: '0011-0234-0100123456', cuenta_bancaria_cci: '01101100023401001234', cuenta_bancaria_tipo: 'Ahorros', cuenta_bancaria_moneda: 'USD', cuenta_bancaria_estado: 'Activo' },
    { cuenta_bancaria_banco: 'Interbank', cuenta_bancaria_numero_cuenta: '200-3001234567', cuenta_bancaria_cci: '00320000300123456789', cuenta_bancaria_tipo: 'Corriente', cuenta_bancaria_moneda: 'Soles', cuenta_bancaria_estado: 'Activo' },
    { cuenta_bancaria_banco: 'Scotiabank', cuenta_bancaria_numero_cuenta: '000-9876543', cuenta_bancaria_cci: '00900700000098765432', cuenta_bancaria_tipo: 'Ahorros', cuenta_bancaria_moneda: 'Soles', cuenta_bancaria_estado: 'Activo' },
    { cuenta_bancaria_banco: 'BanBif', cuenta_bancaria_numero_cuenta: '0384-123456', cuenta_bancaria_cci: '03803800000038412345', cuenta_bancaria_tipo: 'Corriente', cuenta_bancaria_moneda: 'USD', cuenta_bancaria_estado: 'Activo' },
  ];

  columnTypes = {
    currency: {
      width: 150,
    },
    shaded: {
      cellClass: 'shaded-class'
    }
  };
  defaultColDef = {
    resizable: true,
    flex: 1,
    minWidth: 100,
  };
  rowData: ProveedorEntity[] = [
  ];


  //  Tipado con la misma interfaz
  colDefs: ColDef<ProveedorEntity>[] = [
    { field: "proveedor_codigo", headerName: "Código", headerClass: 'ag-header-hover ag-header-10px', flex: 1 },
    { field: "proveedor_razon_social", headerName: "Razón social", headerClass: 'ag-header-hover ag-header-10px', flex: 1, filter: true },
    { field: "proveedor_identificacion_fiscal", headerName: "Documento fiscal", headerClass: 'ag-header-hover ag-header-10px', flex: 1, filter: true },
    { field: "proveedor_cargo_contacto", headerName: "Cargo", headerClass: 'ag-header-hover ag-header-10px', flex: 1 },
    {
      field: "proveedor_estado", headerName: "Estado", headerClass: 'centrarencabezado', filter: true, flex: 1,
      cellRenderer: (params: any) => {
        const estado = params.value;
        const estadoClass = estado === 'Activo' ? 'text-green-600 bg-green-100' : 'text-red-600 bg-red-100';
        return `<span class="px-2 py-[1px] rounded-full text-xxss font-medium ${estadoClass}">${estado}</span>`;
      },
      cellStyle: {
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    },
  ];
  colDefsBancaria: ColDef<CuentaBancariaEntity>[] = [];

  // Datos por tipo de condición - mapeando los nombres correctos
  datosCondiciones: any = {
    'Contado': [
      { condicion_pago_nombre: 'Contado - Inmediato', condicion_pago_tipo: 'Contado', condicion_pago_plazo: 0, condicion_pago_cuotas: 1, condicion_pago_periodicidad_cuotas: 'N/A' },
    ],
    'Crédito': [
      { condicion_pago_nombre: 'Crédito 30 días', condicion_pago_tipo: 'Crédito', condicion_pago_plazo: 30, condicion_pago_cuotas: 1, condicion_pago_periodicidad_cuotas: 'Mensual' },
    ],
    'Mixto': [
      { condicion_pago_nombre: 'Mixto - 50% Contado + 50% Crédito', condicion_pago_tipo: 'Mixto', condicion_pago_plazo: 30, condicion_pago_cuotas: 2, condicion_pago_periodicidad_cuotas: 'Mensual' },
    ]
  };

  rowDataCondiciones: any[] = [];

  // Configuración del AG-Grid
  columnDefsCondiciones: ColDef[] = [
    { headerName: 'Nombre', field: 'condicion_pago_nombre',width: 150 },
    { headerName: 'Tipo de condición', field: 'condicion_pago_tipo', width: 150,},
    { headerName: 'Plazo pagos días', field: 'condicion_pago_plazo', width: 150 },
    { headerName: 'Número de cuotas', field: 'condicion_pago_cuotas', width: 150 },
    { headerName: 'Periocidad de cuotas', field: 'condicion_pago_periodicidad_cuotas', width: 150 },
  ];


  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private countryService: CountryService,
    private formValidationService: FormValidationService,
    private toastService: ToastService
  ) {
    // Effect para actualizar la tabla cuando cambian los datos del store
    effect(() => {
      const proveedores = this.proveedores();
      this.rowData = proveedores;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
        // Re-seleccionar la fila activa si estamos en modo edición
        if (this.filaSeleccionada) {
          const codigoSeleccionado = this.filaSeleccionada.proveedor_codigo;
          setTimeout(() => {
            this.gridApi.forEachNode(node => {
              if (node.data?.proveedor_codigo === codigoSeleccionado) {
                node.setSelected(true);
              }
            });
          }, 0);
        }
      }
    });

    // Effect para actualizar condiciones de pago desde el store
    effect(() => {
      const condiciones = this.condicionPagoFacade.condicionesPago();
      this.condicionesPago = condiciones.map(c => ({
        codigo: c.condicion_pago_codigo,
        nombre: c.condicion_pago_nombre,
        tipo: c.condicion_pago_tipo
      }));
    });
  }

  ngOnInit() {
    this.inicializarColumnasBancarias();
    this.docpais();
    this.GestionProveedoresForm = this.formBuilder.group({
      search: [''],
      filtroEstado: ['todos'],
      estado: ['Activo'],
      observaciones: [''],
      tabDetalle: ['general'],
    });

    // Inicializar formulario de proveedor general
    // Determinar el modo (proveedor/cliente) desde la data de la ruta.
    this.esModoCliente = this.route.snapshot.data?.['modo'] === 'cliente';
    this.relacionModo.setModo(this.esModoCliente ? 'cliente' : 'proveedor');

    this.proveedorForm = this.formBuilder.group({
      codigo: [{ value: '', disabled: true }],
      tipoIdentificacion: [{  value: this.tipoIdentificacionSeleccionado, disabled: true }, [Validators.required]],
      identfiscal: ['', [
        Validators.required,
        Validators.pattern(/^[0-9]{8,11}$/),
      ]],
      razonSocial: ['', [
        Validators.required,
        ComprasTablasGestionProveedoresComponent.noSoloEspacios,
        Validators.maxLength(this.limites.razonSocial),
      ]],
      nombreComercial: ['', [
        Validators.required,
        ComprasTablasGestionProveedoresComponent.noSoloEspacios,
        Validators.maxLength(this.limites.nombreComercial),
      ]],
      direccionFiscal: ['', [
        Validators.required,
        ComprasTablasGestionProveedoresComponent.noSoloEspacios,
        Validators.maxLength(this.limites.direccionFiscal),
      ]],
      email: ['', [
        Validators.required,
        Validators.pattern(ComprasTablasGestionProveedoresComponent.EMAIL_PATTERN),
        Validators.maxLength(this.limites.email),
      ]],
      telefono: ['', [
        Validators.required,
        Validators.pattern(/^[0-9]{6,15}$/),
      ]],
      estado: ['Activo', [Validators.required]],
      proveedor: ['Nacional', [Validators.required]],
    });
    // Inicializar formulario comercial (datos de contacto)
    this.ComercialForm = this.formBuilder.group({
      nombre: ['', [
        Validators.required,
        ComprasTablasGestionProveedoresComponent.noSoloEspacios,
        Validators.maxLength(this.limites.contactoNombre),
      ]],
      cargo: ['', [Validators.maxLength(this.limites.contactoCargo)]],
      telefono: ['', [
        Validators.required,
        Validators.pattern(/^[0-9]{6,15}$/),
      ]],
      email: ['', [
        Validators.required,
        Validators.pattern(ComprasTablasGestionProveedoresComponent.EMAIL_PATTERN),
        Validators.maxLength(this.limites.email),
      ]],
      condicionPago: [''],
      plazocredito: [''],
    });

    // Restricciones de longitud/numérico aplicadas sobre el modelo (a prueba de fallos)
    this.restringirCampo(this.proveedorForm, 'identfiscal', this.limites.documento, true);
    this.restringirCampo(this.proveedorForm, 'telefono', this.limites.telefono, true);
    this.restringirCampo(this.proveedorForm, 'razonSocial', this.limites.razonSocial);
    this.restringirCampo(this.proveedorForm, 'nombreComercial', this.limites.nombreComercial);
    this.restringirCampo(this.proveedorForm, 'direccionFiscal', this.limites.direccionFiscal);
    this.restringirCampo(this.proveedorForm, 'email', this.limites.email);
    this.restringirCampo(this.ComercialForm, 'nombre', this.limites.contactoNombre);
    this.restringirCampo(this.ComercialForm, 'cargo', this.limites.contactoCargo);
    this.restringirCampo(this.ComercialForm, 'telefono', this.limites.telefono, true);
    this.restringirCampo(this.ComercialForm, 'email', this.limites.email);

    // Inicializar servicio de validación de formularios
    this.formValidationService.inicializarFormulario(this.proveedorForm);

    // Registrar callbacks para limpiar formulario después de guardar/actualizar con éxito
    this.feedbackEffects.registrarCallbacks({
      onGuardarExito: () => this.resetearFormularioDespuesDeGuardar(),
      onActualizarExito: () => {
        // Actualizar filaSeleccionada con el objeto nuevo del store
        if (this.filaSeleccionada) {
          const actualizado = this.rowData.find(
            p => p.proveedor_codigo === this.filaSeleccionada.proveedor_codigo
          );
          if (actualizado) this.filaSeleccionada = actualizado;
        }
        this.formValidationService.resetearEstado();
      },
      onEliminarExito: () => {
        // Tras la baja lógica: recargar la lista y limpiar el formulario
        this.cargarProveedoresDesdeStore();
        this.resetearFormularioDespuesDeGuardar();
      }
    });

    // Cargar proveedores y condiciones de pago desde el store
    this.cargarProveedoresDesdeStore();
    this.condicionPagoFacade.cargarCondicionesPago();

    this.proveedorForm.get('tipoIdentificacion')?.valueChanges.subscribe(value => {
      console.log('Cambió a:', value);
    });
  }

  inicializarColumnasBancarias() {
    const pais = this.countryService.getCountryCode();

    this.colDefsBancaria = [
      { field: "cuenta_bancaria_banco", headerName: "Banco", headerClass: 'ag-header-hover ag-header-10px', width: 100, cellDataType: 'text' },
      { field: "cuenta_bancaria_numero_cuenta", headerName: "N° Cuenta", headerClass: 'ag-header-hover ag-header-10px', width: 130, cellDataType: 'text' },
      { field: "cuenta_bancaria_tipo", headerName: "Tipo", headerClass: 'ag-header-hover ag-header-10px', width: 90, cellDataType: 'text' },
      { field: "cuenta_bancaria_moneda", headerName: "Moneda", headerClass: 'ag-header-hover ag-header-10px', width: 80, cellDataType: 'text' },
      { headerClass: 'centrarencabezado', field: 'cuenta_bancaria_estado', headerName: 'Estado', width: 90,
        cellRenderer: (params: any) => {
          const estado = params.value;
          let badgeClass = '';

          switch (estado) {
            case 'Activo':
              badgeClass = 'bg-green-100 text-green-600';
              break;
            case 'Inactivo':
              badgeClass = 'bg-red-100 text-red-600';
              break;
            default:
              badgeClass = 'bg-[#F5F5F5] text-[#363636';
          }
          return `<span class="badge-table ${badgeClass}">${estado}</span>`;
        },
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
      },
      { headerName: 'Acciones', headerClass: 'centrarencabezado', cellRenderer: AcciEditEliminarComponent, width: 80, editable: false,
        cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' },
      }
        
    ];

    // Agregar columna CCI solo si el país NO es GT
    if (pais !== 'GT') {
      this.colDefsBancaria.splice(2, 0, {
        field: "cuenta_bancaria_cci",
        headerName: "CCI",
        headerClass: 'ag-header-hover ag-header-10px',
        width: 150,
        cellDataType: 'text'
      });
    }
  }

  docpais() {
    const country = this.countries.find(
      c => c.codigo === this.countryService.getCountryCode()
    );
    this.countries.find(c => {
      if (c.codigo === country?.codigo) {
        // Filtrar solo el tipo con id: 'empresa'
        const tipoEmpresa = c.personalidadfiscal?.find(tip => tip.id === 'empresa');
        if (tipoEmpresa) {
          this.tiposIdentificacion = [{ id: tipoEmpresa.id, value: tipoEmpresa.value, label: tipoEmpresa.nombre, numero: tipoEmpresa.numero }];
          this.tipoIdentificacionSeleccionado = tipoEmpresa.nombre; // Guardar el nombre para mostrar
        }
      }
    })
  }
  onchangedocs(event: any) {
    console.log('Tipo de identificación seleccionado:', event.detail.value);
  }

  /**
   * Cargar proveedores desde el store usando el facade
   */
  cargarProveedoresDesdeStore() {
    console.log('Cargando proveedores desde el store...');
    this.proveedorFacade.cargarProveedores(this.construirFiltroLista());
  }

  /** Arma el filtro de la lista según el estado seleccionado (todos/activos/inactivos). */
  private construirFiltroLista(): { activo?: boolean } {
    const estado = this.GestionProveedoresForm?.get('filtroEstado')?.value ?? 'todos';
    if (estado === 'activos') {
      return { activo: true };
    }
    if (estado === 'inactivos') {
      return { activo: false };
    }
    return {};
  }

  /** Se dispara al cambiar el filtro de estado de la lista; recarga desde el backend. */
  onFiltroEstadoChange(): void {
    this.cargarProveedoresDesdeStore();
  }

  ngOnDestroy(): void {
    this.formValidationService.limpiarFormulario();
  }

  buscarproveedor() {
    let documento = this.proveedorForm.get('identfiscal')?.value;
    if (documento !== null && documento !== undefined) {
      documento = String(documento).trim();
    }

    if (!documento) {
      this.toastService.warning('¡Ingresa un número de documento para buscar!');
      return;
    }

    this.api
      .get<any>('/core/relaciones-comerciales', {
        nroDocumento: documento,
        page: 0,
        size: 20,
      })
      .pipe(catchError(() => of(null)))
      .subscribe((response) => {
        const lista = this.extraerListaRelaciones(response);
        const encontrado = lista.find((p) => p?.flagEstado === '1') ?? lista[0];

        if (encontrado) {
          this.proveedorForm.patchValue({
            razonSocial: encontrado.razonSocial ?? '',
            nombreComercial: encontrado.nombreComercial ?? '',
            direccionFiscal: encontrado.direccion ?? '',
            email: encontrado.email ?? '',
            telefono: encontrado.telefono ?? '',
          });
          this.toastService.success(`¡Proveedor encontrado: ${encontrado.razonSocial}!`);
        } else {
          this.toastService.warning('¡No se encontró un proveedor con ese documento!');
        }
      });
  }

  /** Normaliza la respuesta de relaciones comerciales (arreglo o página { content: [] }) */
  private extraerListaRelaciones(response: any): any[] {
    if (Array.isArray(response)) {
      return response;
    }
    if (Array.isArray(response?.content)) {
      return response.content;
    }
    return [];
  }
  async nuevoproveedor() {
    // Validar cambios antes de limpiar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Usuario canceló, mantener el formulario actual
    }

    // Limpiar estado
    this.modoCreacion = true;
    this.modoEdicion = false;
    this.filaSeleccionada = null;
    this.textoBotonRegistrar = 'Registrar';

    // Deseleccionar filas de la tabla de manera explícita
    if (this.gridApi) {
      // Método 1: deselectAll
      this.gridApi.deselectAll();
      
      // Método 2: Asegurar deselección iterando sobre todos los nodos
      this.gridApi.forEachNode((node) => {
        node.setSelected(false);
      });
    }

    // Resetear formularios con valores por defecto
    this.proveedorForm.reset({
      tipoIdentificacion: this.tipoIdentificacionSeleccionado,
      estado: 'Activo',
      proveedor: 'Nacional'
    });
    this.proveedorForm.get('razonSocial')?.enable();
    this.proveedorForm.get('nombreComercial')?.enable();

    this.ComercialForm.reset({
      condicionPago: 'Contado'
    });

    // Limpiar cuentas bancarias
    this.rowDataBancaria = [];
    if (this.gridApiBancaria) {
      this.gridApiBancaria.setGridOption('rowData', this.rowDataBancaria);
    }

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }
  mostrarTabla(valor: boolean) {
    this.mostrartabla = valor;
  }

  async onCellClicked(event: any) {
    if (!event.data) return;

    const data = event.data;

    // Prevenir selección automática
    event.node.setSelected(false);

    // Guardar referencia del elemento que tiene el foco actualmente
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Mantener selección anterior
      if (this.filaSeleccionada) {
        setTimeout(() => {
          this.gridApi.forEachNode((node) => {
            if (node.data === this.filaSeleccionada) {
              node.setSelected(true);
            }
          });
          // Restaurar foco si es un input
          if (elementoConFoco && (elementoConFoco.tagName === 'INPUT' || elementoConFoco.tagName === 'ION-INPUT')) {
            elementoConFoco.focus();
          }
        }, 0);
      } else {
        this.gridApi.deselectAll();
      }
      return;
    }

    // Usuario confirmó - proceder con la selección
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    event.node.setSelected(true);

    this.campoeditar = false;
    this.filaSeleccionada = data;
    this.tituloform = data.proveedor_codigo;
    this.modoEdicion = true;
    this.modoCreacion = false;
    this.textoBotonRegistrar = 'Guardar';

    // Habilitar campos para edición
    this.proveedorForm.get('razonSocial')?.enable();
    this.proveedorForm.get('nombreComercial')?.enable();

    // Llenar formulario general
    this.proveedorForm.patchValue({
      codigo: data.proveedor_codigo || '',
      tipoIdentificacion: this.tipoIdentificacionSeleccionado,
      identfiscal: data.proveedor_identificacion_fiscal || '',
      razonSocial: data.proveedor_razon_social || '',
      nombreComercial: data.proveedor_nombre_comercial || '',
      direccionFiscal: data.proveedor_direccion_fiscal || '',
      email: data.proveedor_email || '',
      telefono: data.proveedor_telefono || '',
      estado: data.proveedor_estado || 'Activo',
      proveedor: data.proveedor_tipo || 'Nacional',
    });

    // Llenar formulario comercial
    this.ComercialForm.patchValue({
      nombre: data.proveedor_nombre_contacto || '',
      cargo: data.proveedor_cargo_contacto || '',
      telefono: data.proveedor_telefono_contacto || '',
      email: data.proveedor_email_contacto || '',
      condicionPago: data.proveedor_condicion_pago_comercial || 'Contado',
      plazocredito: data.proveedor_plazo_credito || '',
    });

    // Cargar datos de la tabla de condiciones
    if (data.proveedor_condicion_pago_comercial) {
      this.onCondicionPagoSeleccionada(data.proveedor_condicion_pago_comercial);
    }

    // Cargar cuentas bancarias del proveedor
    this.rowDataBancaria = data.proveedor_cuentas_bancarias ? [...data.proveedor_cuentas_bancarias] : [];
    if (this.gridApiBancaria) {
      this.gridApiBancaria.setGridOption('rowData', this.rowDataBancaria);
    }

    // Resetear servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }
  // async onCellClickedBancaria(event: any) {
  //   const cuentaSeleccionada = event.data;
  //   await this.abrirModalEdicion(cuentaSeleccionada);
  // }
  botonNuevaOperacion() {
    this.campoeditar = true;
    this.filaSeleccionada = null; // Limpiar la fila seleccionada
    this.GestionProveedoresForm.reset();
    this.GestionProveedoresForm.patchValue({
      estado: 'Activo',
    });
  }
  async abrirModalEdicion(cuenta: CuentaBancariaEntity) {
    const modal = await this.modalController.create({
      component: ModalsAgregarCuentaComponent,
      cssClass: 'promo',
      componentProps: {
        cuentaEditar: cuenta,
        modoEdicion: true
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();

    if (data && data.accion === 'guardar') {
      // Actualizar la cuenta en la tabla
      const cuentaActualizada: CuentaBancariaEntity = {
        cuenta_bancaria_banco: data.cuenta.banco,
        cuenta_bancaria_numero_cuenta: data.cuenta.numeroCuenta,
        cuenta_bancaria_cci: data.cuenta.cci,
        cuenta_bancaria_tipo: data.cuenta.tipoCuenta,
        cuenta_bancaria_moneda: data.cuenta.moneda,
        cuenta_bancaria_estado: data.cuenta.estado
      };

      // Encontrar y actualizar la fila
      Object.assign(cuenta, cuentaActualizada);

      // Actualizar la grilla bancaria (no la de proveedores)
      if (this.gridApiBancaria) {
        this.gridApiBancaria.applyTransaction({
          update: [cuenta]
        });
      }

      console.log('Cuenta bancaria actualizada:', cuentaActualizada);
    }
  }
  async botonNuevaCuenta() {
    const modal = await this.modalController.create({
      component: ModalsAgregarCuentaComponent,
      cssClass: 'promo',
      componentProps: {
        modoEdicion: false
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();

    if (data && data.accion === 'agregar') {
      // Agregar la nueva cuenta a la tabla
      const nuevaCuenta: CuentaBancariaEntity = {
        cuenta_bancaria_banco: data.cuenta.banco,
        cuenta_bancaria_numero_cuenta: data.cuenta.numeroCuenta,
        cuenta_bancaria_cci: data.cuenta.cci,
        cuenta_bancaria_tipo: data.cuenta.tipoCuenta,
        cuenta_bancaria_moneda: data.cuenta.moneda,
        cuenta_bancaria_estado: data.cuenta.estado
      };

      // Agregar al array de datos
      this.rowDataBancaria = [...this.rowDataBancaria, nuevaCuenta];

      // Actualizar la grilla
      if (this.gridApiBancaria) {
        this.gridApiBancaria.setGridOption('rowData', this.rowDataBancaria);
      }

      console.log('Cuenta bancaria agregada:', nuevaCuenta);
    }
  }

  onEditar(item: any) {
    // Cuenta bancaria: mantiene el comportamiento existente (modal de edición)
    if (item && item.cuenta_bancaria_numero_cuenta !== undefined) {
      console.log('Editar cuenta bancaria:', item);
      this.abrirModalEdicion(item);
      return;
    }
    // Proveedor: cargar la fila en el formulario reutilizando la lógica de selección
    this.onCellClicked({ data: item, node: { setSelected: () => {} } });
  }

  async onEliminar(item: any) {
    // Cuenta bancaria: comportamiento existente (quitar de la grilla local)
    if (item && item.cuenta_bancaria_numero_cuenta !== undefined) {
      this.rowDataBancaria = this.rowDataBancaria.filter(
        cuenta => cuenta.cuenta_bancaria_numero_cuenta !== item.cuenta_bancaria_numero_cuenta
      );
      if (this.gridApiBancaria) {
        this.gridApiBancaria.setGridOption('rowData', this.rowDataBancaria);
      }
      return;
    }

    // Proveedor: baja lógica (desactivación) contra el backend
    const id = item?.id ?? item?.proveedor_codigo;
    if (!id) {
      this.toastService.warning('No se pudo identificar el proveedor a dar de baja.');
      return;
    }

    const confirmar = window.confirm(
      `¿Dar de baja al proveedor "${item.proveedor_razon_social || id}"? Quedará inactivo.`
    );
    if (!confirmar) {
      return;
    }

    this.proveedorFacade.eliminarProveedor(String(id));
  }
  async abrirmodalUbicaciones() {
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar proveedores',
        descripcionSubir: 'Comparte tu archivo de excel con la información de tus proveedores y regístralos automáticamente en la plataforma.',
        buttonName: 'Importar proveedores',
        habilitarformatonumerico: true,
      }
    });
    await modal.present();
  }

  /** Columnas que se exportan (Excel/PDF), en orden. */
  private readonly columnasExport: { header: string; field: keyof ProveedorEntity }[] = [
    { header: 'Código', field: 'proveedor_codigo' },
    { header: 'Razón social', field: 'proveedor_razon_social' },
    { header: 'Documento fiscal', field: 'proveedor_identificacion_fiscal' },
    { header: 'Nombre comercial', field: 'proveedor_nombre_comercial' },
    { header: 'Email', field: 'proveedor_email' },
    { header: 'Teléfono', field: 'proveedor_telefono' },
    { header: 'Contacto', field: 'proveedor_nombre_contacto' },
    { header: 'Cargo', field: 'proveedor_cargo_contacto' },
    { header: 'Estado', field: 'proveedor_estado' },
  ];

  /** Filas a exportar: respeta el filtro/orden del grid si está disponible. */
  private obtenerFilasExport(): ProveedorEntity[] {
    if (this.gridApi) {
      const filas: ProveedorEntity[] = [];
      this.gridApi.forEachNodeAfterFilterAndSort((node) => {
        if (node.data) {
          filas.push(node.data as ProveedorEntity);
        }
      });
      if (filas.length) {
        return filas;
      }
    }
    return this.rowData ?? [];
  }

  private nombreArchivoExport(): string {
    const base = this.esModoCliente ? 'clientes' : 'proveedores';
    const fecha = new Date().toISOString().slice(0, 10);
    return `${base}_${fecha}`;
  }

  /** Exporta la lista a un archivo Excel (.xlsx). */
  async exportarExcel(): Promise<void> {
    const filas = this.obtenerFilasExport();
    if (!filas.length) {
      this.toastService.warning('No hay datos para exportar.');
      return;
    }

    const datos = filas.map((fila) => {
      const registro: Record<string, unknown> = {};
      this.columnasExport.forEach((col) => {
        registro[col.header] = fila[col.field] ?? '';
      });
      return registro;
    });

    // Import dinámico (mismo patrón que el resto del proyecto) para evitar warnings de CommonJS.
    const XLSX = await import('xlsx');
    const hoja = XLSX.utils.json_to_sheet(datos, {
      header: this.columnasExport.map((c) => c.header),
    });
    const libro = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(libro, hoja, this.esModoCliente ? 'Clientes' : 'Proveedores');
    XLSX.writeFile(libro, `${this.nombreArchivoExport()}.xlsx`);
  }

  /** Genera y descarga un PDF (.pdf) con la lista, sin abrir el diálogo de impresión. */
  async exportarPdf(): Promise<void> {
    const filas = this.obtenerFilasExport();
    if (!filas.length) {
      this.toastService.warning('No hay datos para exportar.');
      return;
    }

    const titulo = this.esModoCliente ? 'Lista de clientes' : 'Lista de proveedores';

    // Import dinámico para no cargar las librerías hasta que se exporte.
    const { jsPDF } = await import('jspdf');
    const autoTable = (await import('jspdf-autotable')).default;

    const doc = new jsPDF({ orientation: 'landscape', unit: 'pt', format: 'a4' });

    doc.setFontSize(14);
    doc.text(titulo, 40, 40);
    doc.setFontSize(9);
    doc.setTextColor(110);
    doc.text(
      `Generado: ${new Date().toLocaleString('es-PE')} — ${filas.length} registro(s)`,
      40,
      56
    );
    doc.setTextColor(0);

    autoTable(doc, {
      startY: 70,
      head: [this.columnasExport.map((c) => c.header)],
      body: filas.map((fila) => this.columnasExport.map((c) => String(fila[c.field] ?? ''))),
      styles: { fontSize: 8, cellPadding: 3 },
      headStyles: { fillColor: [240, 240, 240], textColor: 20, fontStyle: 'bold' },
      margin: { left: 40, right: 40 },
    });

    doc.save(`${this.nombreArchivoExport()}.pdf`);
  }

  /** Filtro rápido de la lista de proveedores: busca en todas las columnas visibles. */
  onBuscarLista(event: any): void {
    const valor = (event?.detail?.value ?? event?.target?.value ?? '').toString();
    this.gridApi?.setGridOption('quickFilterText', valor);
  }

  onGridReadyProveedores(params: GridReadyEvent) {
    this.gridApi = params.api;
    // Habilitar las acciones (editar / dar de baja) de la grilla principal de proveedores
    params.api.setGridOption('context', { componentParent: this });
  }

  onGridReadyBancaria(params: GridReadyEvent) {
    this.gridApiBancaria = params.api;
    // Pasar el contexto del componente padre para que AcciEditEliminarComponent pueda acceder a los métodos
    params.api.setGridOption('context', { componentParent: this });
  }

  onProveedorGuardado(proveedorData: any) {
    // Crear el objeto para la tabla
    const nuevoProveedor: ProveedorEntity = {
      proveedor_codigo: proveedorData.codigo || 'PROV-' + String(this.rowData.length + 1).padStart(3, '0'),
      proveedor_razon_social: proveedorData.razonSocial || '',
      proveedor_identificacion_fiscal: proveedorData.identfiscal || '',
      proveedor_estado: proveedorData.estado || 'Activo',
      proveedor_condicion_pago: '30 días',
      proveedor_nombre_comercial: proveedorData.nombreComercial || '',
      proveedor_direccion_fiscal: proveedorData.direccionFiscal || '',
      proveedor_email: proveedorData.email || '',
      proveedor_telefono: proveedorData.telefono || '',
      proveedor_tipo: proveedorData.proveedor || 'Nacional',
      proveedor_nombre_contacto: proveedorData.nombreContacto || '',
      proveedor_telefono_contacto: proveedorData.telefonoContacto || '',
      proveedor_email_contacto: proveedorData.emailContacto || '',
      proveedor_condicion_pago_comercial: proveedorData.condicionPagoComercial || 'Contado',
      proveedor_plazo_credito: proveedorData.plazoCredito || ''
    };

    // Agregar a la tabla
    this.rowData = [...this.rowData, nuevoProveedor];

    // Actualizar la grilla
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);

      // Seleccionar la nueva fila agregada
      setTimeout(() => {
        const lastIndex = this.rowData.length - 1;
        const lastNode = this.gridApi.getDisplayedRowAtIndex(lastIndex);
        if (lastNode) {
          this.gridApi.deselectAll();
          lastNode.setSelected(true);
          this.filaSeleccionada = lastNode.data;
          this.tituloform = lastNode.data.proveedor_codigo;
          this.campoeditar = false;

          // Hacer scroll para que sea visible
          this.gridApi.ensureIndexVisible(lastIndex);
        }
      }, 100);

      console.log('Tabla actualizada con nuevo proveedor:', nuevoProveedor);
    }
  }
  onBtReset() {
      this.cargarProveedoresDesdeStore();
  }

  validarCamposObligatorios(): boolean {
    return this.proveedorForm.valid && this.ComercialForm.valid;
  }

  guardar() {
    if (this.proveedorForm.invalid) {
      this.proveedorForm.markAllAsTouched();
      this.tabSeleccionadoDetalle = 'general';
      this.toastService.warning('Revisa los campos de la pestaña General');
      return;
    }

    if (this.ComercialForm.invalid) {
      this.ComercialForm.markAllAsTouched();
      this.tabSeleccionadoDetalle = 'comercial';
      this.toastService.warning('Revisa los datos de contacto (pestaña Comercial)');
      return;
    }

    const proveedorGeneralData = this.proveedorForm.getRawValue();
    const proveedorComercialData = this.ComercialForm.getRawValue();

    // Combinar datos de ambos formularios + cuentas bancarias
    const proveedorCompleto: ProveedorEntity = {
      proveedor_codigo: this.modoCreacion ? '' : proveedorGeneralData.codigo,
      proveedor_razon_social: proveedorGeneralData.razonSocial || '',
      proveedor_identificacion_fiscal: proveedorGeneralData.identfiscal || '',
      proveedor_tipo_doc_identidad_id: this.resolverTipoDocIdentidadId(proveedorGeneralData.tipoIdentificacion),
      proveedor_estado: proveedorGeneralData.estado || 'Activo',
      proveedor_condicion_pago: '30 días',
      proveedor_nombre_comercial: proveedorGeneralData.nombreComercial || '',
      proveedor_direccion_fiscal: proveedorGeneralData.direccionFiscal || '',
      proveedor_email: proveedorGeneralData.email || '',
      proveedor_telefono: proveedorGeneralData.telefono || '',
      proveedor_tipo: proveedorGeneralData.proveedor || 'Nacional',
      proveedor_nombre_contacto: proveedorComercialData.nombre || '',
      proveedor_cargo_contacto: proveedorComercialData.cargo || '',
      proveedor_telefono_contacto: proveedorComercialData.telefono || '',
      proveedor_email_contacto: proveedorComercialData.email || '',
      proveedor_condicion_pago_comercial: proveedorComercialData.condicionPago || 'Contado',
      proveedor_plazo_credito: proveedorComercialData.plazocredito || '',
      proveedor_cuentas_bancarias: [...this.rowDataBancaria]
    };

    if (this.modoEdicion && this.filaSeleccionada) {
      // Modo edición: actualizar proveedor existente usando el facade
      this.proveedorFacade.actualizarProveedor(proveedorCompleto);
    } else {
      // Modo creación: guardar nuevo proveedor usando el facade (el reset lo maneja onGuardarExito)
      this.proveedorFacade.guardarProveedor(proveedorCompleto);
    }
  }

  /** Resetea el formulario a estado limpio después de un guardado/actualización exitoso */
  private resolverTipoDocIdentidadId(tipoIdentificacion: unknown): number {
    const valor = String(tipoIdentificacion ?? this.tipoIdentificacionSeleccionado ?? '').trim().toUpperCase();
    const tipoEncontrado = this.tiposIdentificacion.find((tipo: any) =>
      String(tipo.id ?? '').toUpperCase() === valor ||
      String(tipo.value ?? '').toUpperCase() === valor ||
      String(tipo.label ?? '').toUpperCase() === valor
    );

    const id = Number(tipoEncontrado?.tipoDocIdentidadId ?? tipoEncontrado?.docTipoId ?? tipoEncontrado?.id);
    return Number.isFinite(id) && id > 0 ? id : 1;
  }

  private resetearFormularioDespuesDeGuardar(): void {
    this.modoCreacion = true;
    this.modoEdicion = false;
    this.filaSeleccionada = null;
    this.textoBotonRegistrar = 'Registrar';

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    this.proveedorForm.reset({
      tipoIdentificacion: this.tipoIdentificacionSeleccionado,
      estado: 'Activo',
      proveedor: 'Nacional'
    });
    this.proveedorForm.get('razonSocial')?.enable();
    this.proveedorForm.get('nombreComercial')?.enable();

    this.ComercialForm.reset({ condicionPago: 'Contado' });

    this.rowDataBancaria = [];
    if (this.gridApiBancaria) {
      this.gridApiBancaria.setGridOption('rowData', this.rowDataBancaria);
    }

    this.formValidationService.resetearEstado();
  }

  onCondicionPagoSeleccionada(condiciones: any) {
    // Extraer valor si es un objeto
    let valorCondicion = condiciones;
    if (typeof condiciones === 'object' && condiciones !== null && !Array.isArray(condiciones)) {
      valorCondicion = condiciones.codigo || condiciones.nombre || condiciones;
    }

    // Actualizar el formulario
    this.ComercialForm.patchValue({ condicionPago: valorCondicion });

    // Normalizar a array de valores
    const valores: string[] = Array.isArray(condiciones) ? condiciones : [valorCondicion];

    let datosAcumulados: any[] = [];

    valores.forEach((valor: string) => {
      // Estrategia 1: el valor coincide directamente con una clave de datosCondiciones (ej: 'Crédito')
      const claveDirecta = Object.keys(this.datosCondiciones).find(clave =>
        clave.toLowerCase() === valor.toLowerCase()
      );

      if (claveDirecta) {
        datosAcumulados = [...datosAcumulados, ...this.datosCondiciones[claveDirecta]];
        return;
      }

      // Estrategia 2: el valor es un código de condicionesPago, buscar por código o nombre
      const condicionEncontrada = this.condicionesPago.find(
        (item: any) => item.codigo === valor || item.nombre?.toLowerCase() === valor.toLowerCase()
      );

      if (condicionEncontrada) {
        // Primero intentar por campo 'tipo' (coincide exactamente con claves de datosCondiciones)
        const clavePorTipo = condicionEncontrada.tipo
          ? Object.keys(this.datosCondiciones).find(clave =>
              clave.toLowerCase() === condicionEncontrada.tipo.toLowerCase()
            )
          : undefined;

        if (clavePorTipo) {
          datosAcumulados = [...datosAcumulados, ...this.datosCondiciones[clavePorTipo]];
        } else {
          // Fallback: match parcial por nombre
          const nombreCondicion = condicionEncontrada.nombre;
          const clavePorNombre = nombreCondicion
            ? Object.keys(this.datosCondiciones).find(clave =>
                nombreCondicion.toLowerCase().includes(clave.toLowerCase()) ||
                clave.toLowerCase().includes(nombreCondicion.toLowerCase())
              )
            : undefined;
          if (clavePorNombre) {
            datosAcumulados = [...datosAcumulados, ...this.datosCondiciones[clavePorNombre]];
          }
        }
      }
    });

    this.rowDataCondiciones = datosAcumulados;
  }



  async openNuevaCondicion() {
    // Guardar la lista actual para detectar la nueva condición
    const listaAnterior = [...this.condicionesPago];
    
    const modal = await this.modalController.create({
      component: ModalNuevaCondicionComponent,
      cssClass: 'promo',
      componentProps: {}
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();

    if (data == true) {
      // condicionesPago se actualiza automáticamente via effect() desde el store
      // Encontrar la nueva condición comparando las listas
      const nuevaCondicion = this.condicionesPago.find(
        (condicion: any) => !listaAnterior.some((item: any) => item.codigo === condicion.codigo)
      );

      // Reabrire el dropdown después de actualizar la lista
      setTimeout(() => {
        if (this.autocompleteCondiciones) {
          // Si el dropdown está cerrado, abrirlo
          if (!this.autocompleteCondiciones.showDropdown) {
            this.autocompleteCondiciones.toggleDropdown();
          }

          // Si encontramos la nueva condición, seleccionarla
          if (nuevaCondicion) {
            // Agregar la nueva condición a las ya seleccionadas (no reemplazar)
            this.autocompleteCondiciones.tempSelectedItems = [...this.autocompleteCondiciones.tempSelectedItems, nuevaCondicion.codigo];
            this.autocompleteCondiciones.selectedItems = [...this.autocompleteCondiciones.selectedItems, nuevaCondicion.codigo];
            
            // Actualizar el formulario sin cargar los datos de la tabla
            this.ComercialForm.patchValue({
              condicionPago: this.autocompleteCondiciones.selectedItems
            });
            
            console.log('Condición seleccionada automáticamente:', nuevaCondicion);
          }
        }
      }, 300);
    }
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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del proveedor.' },
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación del proveedor.' },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de actualización del proveedor ${this.filaSeleccionada?.proveedor_razon_social || ''}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }
}

