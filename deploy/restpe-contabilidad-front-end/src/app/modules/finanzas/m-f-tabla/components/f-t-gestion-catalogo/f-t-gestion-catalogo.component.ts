import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { formatDate } from 'date-fns';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { GestionCatalogoFacade } from 'src/app/modules/finanzas/application/facades/gestion-catalogo.facade';
import { GestionCatalogoFeedbackEffects } from 'src/app/modules/finanzas/effects/gestion-catalogo-feedback.effect';
import { GestionCatalogoSyncEffects } from 'src/app/modules/finanzas/effects/gestion-catalogo-sync.effect';
import { GestionCatalogoEntity } from 'src/app/modules/finanzas/domain/models/gestion-catalogo.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-f-t-gestion-catalogo',
  templateUrl: './f-t-gestion-catalogo.component.html',
  styleUrls: ['./f-t-gestion-catalogo.component.scss'],
  standalone: false,
})
export class FTGestionCatalogoComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // Facade + Effects
  readonly catalogoFacade = inject(GestionCatalogoFacade);
  private readonly _feedbackEffects = inject(GestionCatalogoFeedbackEffects);
  private readonly _syncEffects = inject(GestionCatalogoSyncEffects);
  readonly isLoading = this.catalogoFacade.isLoading;

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  documentoSeleccionado: string = 'todos';

  //FECHAS ÚNICAS (SINGLE)
  fechaCreacion: Date | undefined;

  catalogoFinanzasForm!: FormGroup;
  private gridApi!: GridApi;
  estadoSeleccionado: string = 'todos';
  naturalezaSeleccionada: string = '';
  tipoSeleccionado: string = '';
  usoSeleccionado: string = '';
  naturalezaContableSeleccionada: string = '';
  tipoDocumentoSeleccionado: string = '';
  naturalezaContableFormSeleccionada: string = '';
  usoDocumentoSeleccionado: string = '';
  camponuevo: boolean = true;
  gridContext!: { componentParent: FTGestionCatalogoComponent };
  filaSeleccionada: any = null;
  cuentas: any[] = [];
  tieneReferenciaBancaria: string = 'si';
  nrocomprobante: string = 'si';

  todosEstados: string = 'todos';


  disabledValidar: boolean = true;

  estados = [
    { label: 'Todos los estados', value: 'todos' },
    { label: 'Activo', value: 'activo' },
    { label: 'Inactivo', value: 'inactivo' },
  ];

  tipos = [
    { label: 'Todos los tipos', value: 'todos' },
    { label: 'Deudora', value: 'deudora' },
    { label: 'Acredora', value: 'acredora' },
  ];

  usos = [
    { label: 'Todos los usos', value: 'todos' },
    { label: 'Balance', value: 'balance' },
    { label: 'Resultado', value: 'resultado' },
    { label: 'Orden', value: 'orden' },
    { label: 'Control', value: 'control' },
  ];

  naturalezaContables = [
    { label: 'Todos las naturalezas contables', value: 'todos' },
    { label: 'Débito', value: 'debito' },
    { label: 'Crédito', value: 'credito' },
  ];

  // Formulario
  tDocumentos = [
    { label: 'Ingreso', value: 'ingreso' },
    { label: 'Egreso', value: 'egreso' },
    { label: 'Transferencia', value: 'transferencia' },
    { label: 'Otros', value: 'otros' },
  ];
  nContables = [
    { label: 'Débito', value: 'debito' },
    { label: 'Crédito', value: 'credito' },
  ];
  usoDocumentos = [
    { label: 'Pagos', value: 'pagos' },
    { label: 'Cobranzas', value: 'cobranzas' },
    { label: 'Tesorería', value: 'tesoreria' },
    { label: 'Conciliación', value: 'conciliacion' },
    { label: 'Otros', value: 'otros' },

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

  rowData: GestionCatalogoEntity[] = [];
  /** Texto del buscador (filtra la grilla en cliente). */
  busqueda = '';

  colDefs: ColDef[] = [
    { field: 'catalogo_codigo', headerName: 'Código', width: 80 },
    { field: 'catalogo_nombre_doc', headerName: 'Nombre de documento', flex: 1, minWidth: 150 },
    { field: 'catalogo_sunat_codigo', headerName: 'Código SUNAT', width: 110, filter: true },
    // SOBRA: el backend (doc_tipo) no devuelve estos campos → columnas comentadas, no borradas.
    // { field: 'catalogo_tipo_documento', headerName: 'Tipo de documento', width: 130, filter: true },
    // { field: 'catalogo_naturaleza', headerName: 'Naturaleza contable', width: 135, filter: true },
    // { field: 'catalogo_uso', headerName: 'Uso', width: 80, filter: true },
    // { field: 'catalogo_cuenta_contable', headerName: 'Cuenta contable', width: 120 },
    // SOBRA: el backend no devuelve fecha de creación para doc_tipo → columna comentada.
    // {
    //   field: 'catalogo_fecha_creacion', headerName: 'Fecha de creación', width: 120,
    //   valueFormatter: (params: any) => {
    //     if (params.value) {
    //       const date = new Date(params.value);
    //       const day = String(date.getDate() + 1).padStart(2, '0');
    //       const month = String(date.getMonth() + 1).padStart(2, '0');
    //       const year = date.getFullYear();
    //       return `${day}/${month}/${year}`;
    //     }
    //     return '';
    //   }
    // },
    {
      field: "catalogo_estado",
      headerName: "Estado", filter: true,
      headerClass: 'ag-header-hover ag-header-10px centrarencabezado',
      width: 90,
      cellRenderer: (params: any) => {
        const estado = params.value;
        const estadoClass = estado === 'Activo' ? 'text-green-600 bg-green-100' : 'text-red-600 bg-red-100';
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
    private formValidationService: FormValidationService,
  ) {
    effect(() => {
      this.rowData = [...this.catalogoFacade.documentos()].reverse();
      this.aplicarFiltro();
    });

    this.catalogoFinanzasForm = this.formBuilder.group({
      codigoDocumento: ['', Validators.required],
      nombreD: ['', Validators.required],
      // FALTA: 'sunatCodigo' sí lo acepta el backend (DocTipoRequest, opcional). Se agrega.
      sunatCodigo: [''],
      // SOBRA: el backend (DocTipoRequest) no acepta 'tipoDocumento'. Se comenta, no se borra.
      // tipoDocumento: ['', Validators.required],
      // SOBRA: el backend no acepta 'naturaleza'. Se comenta, no se borra.
      // naturaleza: ['', Validators.required],
      // SOBRA: el backend no acepta 'usoDocumento'. Se comenta, no se borra.
      // usoDocumento: ['', Validators.required],
      // SOBRA: el backend no acepta 'cuentaContable'. Se comenta, no se borra.
      // cuentaContable: ['', Validators.required],
      estado: ['activo', Validators.required],
      // SOBRA: el backend no acepta 'refBancaria'. Se comenta, no se borra.
      // refBancaria: [''],
      // SOBRA: el backend no acepta 'nroComprobante'. Se comenta, no se borra.
      // nroComprobante: [''],
      fechaCreacion: [{ value: this.getFechaHoy(), disabled: true }],
    });
    this.disabledValidar = true;

    this.gridContext = { componentParent: this };
  }

  ngOnInit() {
    this.catalogoFacade.cargarDocumentos();

    this.cuentas = [
      { id: '1010', nombre: '1010 - Caja' },
      { id: '1020', nombre: '1020 - Bancos' },
      { id: '1030', nombre: '1030 - Cuentas por cobrar' }
    ];

    // Inicializar servicio de validación de cambios
    this.formValidationService.inicializarFormulario(this.catalogoFinanzasForm);

    this.catalogoFinanzasForm.valueChanges.subscribe(() => {
      this.actualizarEstadoBoton();
    });

    // Actualizar estado inicial del botón
    this.actualizarEstadoBoton();
  }

  private verificarCambiosEnFormulario() {
    // Verificar si hay algún campo con valor (excepto fechaCreacion que siempre tiene valor)
    const tieneValores =
      this.catalogoFinanzasForm.get('nombreD')?.value ||
      this.catalogoFinanzasForm.get('refBancaria')?.value ||
      this.catalogoFinanzasForm.get('nroComprobante')?.value ||
      this.tipoDocumentoSeleccionado ||
      this.naturalezaContableFormSeleccionada ||
      this.usoDocumentoSeleccionado ||
      this.catalogoFinanzasForm.get('cuentaContable')?.value;

    // Si hay valores en el formulario Y NO hay fila seleccionada, habilitar el botón
    if (tieneValores && !this.filaSeleccionada) {
      this.disabledValidar = false;
    }
  }

  getFechaHoy(): string {
    return new Date().toISOString().substring(0, 10);
  }
  formatearFecha(fecha: Date): string {
    const dia = fecha.getDate().toString().padStart(2, '0');
    const mes = (fecha.getMonth() + 1).toString().padStart(2, '0');
    const anio = fecha.getFullYear();
    return `${anio}-${mes}-${dia}`;
  }
  parsearFecha(fechaStr: string): Date {
    const partes = fechaStr.split('-');
    return new Date(
      parseInt(partes[0]),
      parseInt(partes[1]) - 1,
      parseInt(partes[2]),
    );
  }

  private actualizarEstadoBoton() {
    if (this.filaSeleccionada && !this.camponuevo) {
      this.disabledValidar = false;
      return;
    }

    // Verificar si hay cambios en el formulario
    // SOBRA: 'refBancaria', 'nroComprobante', 'cuentaContable' comentados (el backend no los acepta).
    const hayValoresEnFormulario =
      this.catalogoFinanzasForm.get('codigoDocumento')?.value ||
      this.catalogoFinanzasForm.get('nombreD')?.value ||
      this.catalogoFinanzasForm.get('sunatCodigo')?.value;

    // SOBRA: selects standalone (tipo/naturaleza/uso) comentados; ya no se exigen.
    // const haySelectsConValores =
    //   this.tipoDocumentoSeleccionado ||
    //   this.naturalezaContableFormSeleccionada ||
    //   this.usoDocumentoSeleccionado;

    // Si hay cambios en el formulario Y es un documento nuevo, habilitar el botón
    if (hayValoresEnFormulario && this.camponuevo) {
      this.disabledValidar = false;
      return;
    }

    // Backend (DocTipoRequest) exige codigo + nombre (+ estado/flagEstado). sunatCodigo es opcional.
    const camposObligatorios = ['codigoDocumento', 'nombreD', 'estado'];
    const todosCompletos = camposObligatorios.every(campo => {
      const valor = this.catalogoFinanzasForm.get(campo)?.value;
      return valor !== null && valor !== undefined && valor !== '';
    });

    // SOBRA: ya no se validan los selects standalone (campos comentados).
    // const selectsCompletos = ...

    this.disabledValidar = !todosCompletos;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.aplicarFiltro();
  }

  /** Buscador: filtra por código, nombre, código SUNAT o estado (en cliente). */
  onBuscar(): void {
    this.aplicarFiltro();
  }

  /** Empuja a la grilla las filas filtradas según `busqueda`. */
  private aplicarFiltro(): void {
    if (!this.gridApi) {
      return;
    }
    const t = (this.busqueda ?? '').trim().toLowerCase();
    const filtradas = !t
      ? this.rowData
      : this.rowData.filter((d) =>
          `${d.catalogo_codigo ?? ''} ${d.catalogo_nombre_doc ?? ''} ${d.catalogo_sunat_codigo ?? ''} ${d.catalogo_estado ?? ''}`
            .toLowerCase()
            .includes(t)
        );
    this.gridApi.setGridOption('rowData', filtradas);
  }

  /** Exporta la grilla a Excel (.xlsx). */
  exportarExcel(): void {
    this.gridApi?.exportDataAsExcel({ fileName: 'tipos-documento.xlsx', sheetName: 'Tipos de documento' });
  }

  async onCellClicked(event: any) {
    console.log('Cell clicked', event);

    // Permitir que la fila se seleccione primero
    event.node.setSelected(true);

    // Validar cambios antes de cambiar de fila
    const puedeCargar = await this.formValidationService.validarCambios();

    if (!puedeCargar) {
      console.log('Usuario canceló, no cambiar de fila');
      // Deseleccionar y reseleccionar la fila anterior
      if (this.filaSeleccionada) {
        this.gridApi.deselectAll();
        this.gridApi.forEachNode((node) => {
          if (node.data === this.filaSeleccionada) {
            node.setSelected(true);
          }
        });
      } else {
        this.gridApi.deselectAll();
      }
      return;
    }

    this.filaSeleccionada = event.data;
    this.camponuevo = false;

    if (this.filaSeleccionada) {
      // SOBRA: 'cuentaContable' comentado (el backend no lo guarda).
      // const cuentaCompleta = this.filaSeleccionada.catalogo_cuenta_contable || '';
      // const cuentaEncontrada = this.cuentas.find(c =>
      //   cuentaCompleta.includes(c.id) || c.nombre === cuentaCompleta
      // );

      // Pausar detección de cambios mientras se cargan datos
      this.formValidationService.pausarDeteccion();

      this.catalogoFinanzasForm.patchValue({
        codigoDocumento: this.filaSeleccionada.catalogo_codigo || '',
        nombreD: this.filaSeleccionada.catalogo_nombre_doc || '',
        // FALTA (agregado): código SUNAT.
        sunatCodigo: this.filaSeleccionada.catalogo_sunat_codigo || '',
        // SOBRA: campos que el backend no guarda. Se comentan, no se borran.
        // tipoDocumento: this.mapearTipoDocumento(this.filaSeleccionada.catalogo_tipo_documento),
        // naturaleza: this.mapearNaturaleza(this.filaSeleccionada.catalogo_naturaleza),
        // usoDocumento: this.mapearUsoDocumento(this.filaSeleccionada.catalogo_uso),
        // cuentaContable: cuentaEncontrada ? cuentaEncontrada.id : '',
        estado: this.filaSeleccionada.catalogo_estado?.toLowerCase() === 'activo' ? 'activo' : 'inactivo',
        // refBancaria: this.filaSeleccionada.catalogo_referencia_bancaria || '',
        // nroComprobante: this.filaSeleccionada.catalogo_nro_comprobante || '',
        fechaCreacion: this.filaSeleccionada.catalogo_fecha_creacion || ''
      });

      // SOBRA: selects standalone (tipo/naturaleza/uso) comentados; ya no se cargan.
      // this.tipoDocumentoSeleccionado = this.mapearTipoDocumentoInverso(this.filaSeleccionada.catalogo_tipo_documento);
      // this.naturalezaContableFormSeleccionada = this.mapearNaturalezaInverso(this.filaSeleccionada.catalogo_naturaleza);
      // this.usoDocumentoSeleccionado = this.mapearUsoDocumentoInverso(this.filaSeleccionada.catalogo_uso);

      // SOBRA: radios de referencia y comprobante comentados.
      // this.tieneReferenciaBancaria = this.filaSeleccionada.catalogo_tiene_referencia || 'no';
      // this.nrocomprobante = this.filaSeleccionada.catalogo_tiene_comprobante || 'no';

      if (this.filaSeleccionada.catalogo_fecha_creacion) {
        // Soporta tanto ISO (yyyy-MM-dd) como dd/MM/yyyy
        const raw: string = this.filaSeleccionada.catalogo_fecha_creacion;
        if (raw.includes('-')) {
          const [anio, mes, dia] = raw.split('-');
          this.fechaCreacion = new Date(parseInt(anio), parseInt(mes) - 1, parseInt(dia));
        } else {
          const [dia, mes, anio] = raw.split('/');
          this.fechaCreacion = new Date(parseInt(anio), parseInt(mes) - 1, parseInt(dia));
        }
      }

      // Reanudar detección de cambios después de cargar datos
      this.formValidationService.reanudarDeteccion();

      // Marcar como pristine y untouched
      this.catalogoFinanzasForm.markAsPristine();
      this.catalogoFinanzasForm.markAsUntouched();

      // Resetear estado de validación
      setTimeout(() => {
        this.formValidationService.resetearEstado();
      }, 50);

      this.actualizarEstadoBoton();
    }
  }
  onBtReset(): void {
    this.catalogoFacade.cargarDocumentos();
  }

  private mapearTipoDocumento(tipo: string): string {
    const mapa: any = {
      'Ingreso': 'factura',
      'Egreso': 'boleta',
      'Transferencia': 'recibo',
      'Otros': 'nota'
    };
    return mapa[tipo] || '';
  }

  private mapearNaturaleza(naturaleza: string): string {
    const mapa: any = {
      'Débito': 'compras',
      'Crédito': 'ventas'
    };
    return mapa[naturaleza] || '';
  }

  private mapearUsoDocumento(uso: string): string {
    const mapa: any = {
      'Pagos': 'compras',
      'Cobranzas': 'ventas',
      'Cobranza': 'ventas',
      'Tesorería': 'interno',
      'Conciliación': 'interno',
      'Otros': 'interno'
    };
    return mapa[uso] || '';
  }

  private mapearTipoDocumentoInverso(tipo: string): string {
    const mapa: any = {
      'Ingreso': 'ingreso',
      'Egreso': 'egreso',
      'Transferencia': 'transferencia',
      'Otros': 'otros'
    };
    return mapa[tipo] || '';
  }

  private mapearNaturalezaInverso(naturaleza: string): string {
    const mapa: any = {
      'Débito': 'debito',
      'Crédito': 'credito'
    };
    return mapa[naturaleza] || '';
  }

  private mapearUsoDocumentoInverso(uso: string): string {
    const mapa: any = {
      'Pagos': 'pagos',
      'Cobranzas': 'cobranzas',
      'Cobranza': 'cobranzas',
      'Tesorería': 'tesoreria',
      'Conciliación': 'conciliacion',
      'Otros': 'otros'
    };
    return mapa[uso] || '';
  }

  async botonNuevaCuenta() {
    // Validar cambios antes de crear uno nuevo
    const puedeLimpiar = await this.formValidationService.validarCambios();

    if (!puedeLimpiar) {
      console.log('Usuario canceló, no limpiar formulario');
      return;
    }

    this.camponuevo = true;
    this.filaSeleccionada = null;

    // Pausar detección de cambios mientras se limpia
    this.formValidationService.pausarDeteccion();

    this.catalogoFinanzasForm.reset({
      estado: 'activo',
      fechaCreacion: formatDate(new Date(), 'yyyy-MM-dd'),
    });

    // Limpiar los selects standalone
    this.tipoDocumentoSeleccionado = '';
    this.naturalezaContableFormSeleccionada = '';
    this.usoDocumentoSeleccionado = '';

    // Deseleccionar todas las filas de la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Reanudar detección de cambios después de limpiar
    this.formValidationService.reanudarDeteccion();

    // Resetear estado de validación
    this.formValidationService.resetearEstado();

    this.actualizarEstadoBoton();
  }

  async botonCancelar(): Promise<void> {
    // Log para debugging
    console.log('  botonCancelar() llamado'); 
    console.log('Cambios detectados:', this.formValidationService.tieneModificaciones());
    console.log('Estado del formulario:', this.catalogoFinanzasForm.status);
    console.log('Valor del formulario:', this.catalogoFinanzasForm.value);

    // Validar cambios antes de cancelar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    console.log('Resultado del modal:', confirmar);

    if (!confirmar) {
      // Si el usuario NO confirma el cancelar, simplemente retornar
      return;
    }

    // Pausar detección de cambios mientras se limpia
    this.formValidationService.pausarDeteccion();

    // Reiniciar el formulario
    this.catalogoFinanzasForm.reset({
      estado: 'activo',
      fechaCreacion: formatDate(new Date(), 'yyyy-MM-dd'),
    });

    // Limpiar variables
    this.camponuevo = true;
    this.filaSeleccionada = null;
    this.tipoDocumentoSeleccionado = '';
    this.naturalezaContableFormSeleccionada = '';
    this.usoDocumentoSeleccionado = '';

    // Deseleccionar fila de la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Reanudar detección de cambios
    this.formValidationService.reanudarDeteccion();

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();

    // Actualizar estado del botón
    this.actualizarEstadoBoton();

    // Mostrar mensaje de confirmación
  }

  botonGuardar() {
    // Backend (DocTipoRequest) exige codigo + nombre (+ estado). 'cuentaContable' y los selects van comentados.
    const formValido = this.catalogoFinanzasForm.get('codigoDocumento')?.value &&
      this.catalogoFinanzasForm.get('nombreD')?.value &&
      this.catalogoFinanzasForm.get('estado')?.value;

    // SOBRA: el backend no acepta tipo/naturaleza/uso → ya no se exigen.
    // const selectsValidos = this.tipoDocumentoSeleccionado &&
    //   this.naturalezaContableFormSeleccionada &&
    //   this.usoDocumentoSeleccionado;

    if (!formValido) {
      this.toastService.warning('Por favor, completa los campos requeridos: código, nombre y estado');
      return;
    }

    // SOBRA: 'cuentaContable' comentado (el backend no lo guarda).
    // const cuentaId = this.catalogoFinanzasForm.get('cuentaContable')?.value;
    // const cuentaEncontrada = this.cuentas.find((c: any) => c.id === cuentaId);

    let fechaFormateada = '';
    if (this.fechaCreacion) {
      const dia = String(this.fechaCreacion.getDate()).padStart(2, '0');
      const mes = String(this.fechaCreacion.getMonth() + 1).padStart(2, '0');
      const anio = this.fechaCreacion.getFullYear();
      fechaFormateada = `${anio}-${mes}-${dia}`;
    } else {
      fechaFormateada = formatDate(new Date(), 'yyyy-MM-dd');
    }

    const payload: Partial<GestionCatalogoEntity> = {
      catalogo_nombre_doc: this.catalogoFinanzasForm.get('nombreD')?.value,
      // FALTA (agregado): código SUNAT, único campo extra que el backend (DocTipoRequest) acepta.
      catalogo_sunat_codigo: this.catalogoFinanzasForm.get('sunatCodigo')?.value || '',
      // SOBRA: el backend no guarda estos campos. Se comentan, no se borran.
      // catalogo_tipo_documento: this.convertirTipoDocumentoParaTabla(this.tipoDocumentoSeleccionado),
      // catalogo_naturaleza: this.convertirNaturalezaParaTabla(this.naturalezaContableFormSeleccionada),
      // catalogo_uso: this.convertirUsoParaTabla(this.usoDocumentoSeleccionado),
      // catalogo_cuenta_contable: cuentaEncontrada ? cuentaEncontrada.id : cuentaId,
      catalogo_estado: this.catalogoFinanzasForm.get('estado')?.value === 'activo' ? 'Activo' : 'Inactivo',
      catalogo_fecha_creacion: fechaFormateada,
    };

    if (this.camponuevo) {
      // El código ahora lo ingresa el usuario (backend lo exige y debe ser único).
      payload.catalogo_codigo = (this.catalogoFinanzasForm.get('codigoDocumento')?.value ?? '').trim();
      this.catalogoFacade.guardarDocumento(payload);

      this.formValidationService.resetearEstado();
      setTimeout(() => { this.botonNuevaCuenta(); }, 100);
    } else if (this.filaSeleccionada) {
      // PUT por id: el backend actualiza por id; mandamos código (para el request) + id (para la ruta).
      payload.catalogo_codigo = (this.catalogoFinanzasForm.get('codigoDocumento')?.value ?? '').trim();
      payload.catalogo_id = this.filaSeleccionada.catalogo_id;
      this.catalogoFacade.actualizarDocumento(this.filaSeleccionada.catalogo_codigo, payload);
      this.formValidationService.resetearEstado();
    }
  }

  /** Elimina el documento seleccionado contra el backend (DELETE /api/core/tipos-documento/{id}). */
  async eliminarDocumento(): Promise<void> {
    if (!this.filaSeleccionada?.catalogo_id) {
      this.toastService.warning('Selecciona un documento para eliminar');
      return;
    }

    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Eliminar documento',
        title: `¿Seguro que deseas eliminar el documento "${this.filaSeleccionada.catalogo_codigo}"?`,
        message: 'Esta acción no se puede deshacer.',
        btnOkTxt: 'Eliminar',
        btnCancelTxt: 'Cancelar',
      }
    });
    await modal.present();
    const { data } = await modal.onWillDismiss();
    if (data !== true) {
      return;
    }

    this.catalogoFacade.eliminarDocumento(this.filaSeleccionada.catalogo_id, this.filaSeleccionada.catalogo_codigo);

    // Limpiar el formulario tras solicitar la eliminación (reset directo, sin prompt de cambios).
    this.camponuevo = true;
    this.filaSeleccionada = null;
    this.formValidationService.pausarDeteccion();
    this.catalogoFinanzasForm.reset({
      estado: 'activo',
      fechaCreacion: formatDate(new Date(), 'yyyy-MM-dd'),
    });
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    this.formValidationService.reanudarDeteccion();
    this.formValidationService.resetearEstado();
    this.actualizarEstadoBoton();
  }

  onFechaCreacionSelected(date: Date) {
    console.log('Fecha creacion:', date);
    this.fechaCreacion = date;
  }

  /**
   * Convertir tipo de documento para insertar en tabla
   */
  convertirTipoDocumentoParaTabla(tipo: string): string {
    const mapa: Record<string, string> = {
      ingreso: 'Ingreso',
      egreso: 'Egreso',
      transferencia: 'Transferencia',
      otros: 'Otros',
    };
    return mapa[tipo] ?? tipo;
  }

  /**
   * Convertir naturaleza para insertar en tabla
   */
  convertirNaturalezaParaTabla(naturaleza: string): string {
    const mapa: Record<string, string> = {
      debito: 'Débito',
      credito: 'Crédito',
    };
    return mapa[naturaleza] ?? naturaleza;
  }

  /**
   * Convertir uso para insertar en tabla
   */
  convertirUsoParaTabla(uso: string): string {
    const mapa: Record<string, string> = {
      pagos: 'Pagos',
      cobranzas: 'Cobranzas',
      tesoreria: 'Tesorería',
      conciliacion: 'Conciliación',
      otros: 'Otros',
    };
    return mapa[uso] ?? uso;
  }

  /**
   * Manejador para cambios en los select
   */
  onSelectChange(): void {
    console.log('Select cambiado');
    this.verificarCambiosEnFormulario();
    this.actualizarEstadoBoton();
  }

  /**
   * Manejador cuando se selecciona una cuenta contable
   */
  onCuentaSeleccionada(event: any): void {
    console.log('Cuenta seleccionada:', event);
  }

  /**
   * Formatear números con guiones (ej: 214-181-122-37)
   */
  guiones(event: any): void {
    const valor = event.target.value;
    if (!valor) return;

    // Remover caracteres no numéricos
    const soloNumeros = valor.replace(/\D/g, '');
    
    // Formatear como grupos de 3 dígitos separados por guion
    let formateado = '';
    for (let i = 0; i < soloNumeros.length; i++) {
      if (i > 0 && i % 3 === 0) {
        formateado += '-';
      }
      formateado += soloNumeros[i];
    }

    // Actualizar el valor en el input
    event.target.value = formateado;
  }

  /**
   * Mostrar modal de actualizaciones
   */
  async modalverActualizaciones() {
    // Definir las columnas del modal
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 150 },
      { headerName: 'Usuario', field: 'usuario', width: 120 },
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

    // Datos de ejemplo del historial
    const rowData = [
      { 
        fechaHora: '07/02/2026 10:30:22', 
        usuario: 'Diego Admin', 
        accion: 'Crear', 
        detalleCambio: `Se creó el documento ${this.filaSeleccionada?.catalogo_codigo || 'N/A'}` 
      },
      { 
        fechaHora: '07/02/2026 10:15:15', 
        usuario: 'Diego Admin', 
        accion: 'Edición', 
        detalleCambio: 'Se editó la descripción del documento' 
      },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: { 
        titulo: `Historial de Actualizaciones del documento ${this.filaSeleccionada?.catalogo_codigo || 'N/A'}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }

  /**
   * Limpiar recursos en el destroy del componente
   */
  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  /**
   * Validar cambios antes de abandonar el componente
   */
  async canDeactivate(): Promise<boolean> {
    const tieneModificaciones = this.formValidationService.tieneModificaciones();
    console.log('  canDeactivate() llamado - Tiene modificaciones:', tieneModificaciones);

    if (!tieneModificaciones) {
      console.log('No hay cambios, permitir salida');
      return true;
    }

    const puede = await this.formValidationService.canDeactivate();
    console.log('Respuesta del modal:', puede);
    return puede;
  }
}