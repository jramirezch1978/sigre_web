import { Component, effect, inject, OnDestroy, OnInit } from '@angular/core';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import {
  faAngleDown,
  faCirclePlus,
  faDownload,
  faRotateRight,
} from '@fortawesome/pro-solid-svg-icons';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import {
  ColDef,
  ColGroupDef,
  GridApi,
  GridReadyEvent,
} from 'ag-grid-enterprise';
import { ToastService } from '@ui/services/toast.service';
import { ModalController } from '@ionic/angular';
import { FormValidationService } from '@ui/services/form-validation.service';
import { format, formatDate } from 'date-fns';
import { ModalVerActualizacionesComponent } from '@ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { TipoDocumentoFacade } from '@modules/finanzas/application/facades/tipo-documento.facade';
import {
  SunatTipoDocumentoEntity,
  TipoDocumentoEntity,
} from '@modules/finanzas/domain/models/tipo-documento.entity';
import { debounceTime, distinctUntilChanged, Subject } from 'rxjs';
import { SunatTipoDocumentoFacade } from '@modules/finanzas/application/facades/sunat-tipo-documento.facade';

@Component({
  selector: 'app-f-t-tipo-documento',
  templateUrl: './f-t-tipo-documento.component.html',
  styleUrls: ['./f-t-tipo-documento.component.scss'],
  standalone: false,
})
export class FTTipoDocumentoComponent
  implements OnInit, OnDestroy, CanComponentDeactivate
{
  // Facade + Effects
  // readonly catalogoFacade = inject(GestionCatalogoFacade);
  readonly tipoDocumentoFacade = inject(TipoDocumentoFacade);
  private readonly sunatTipoFacade = inject(SunatTipoDocumentoFacade);
  readonly isLoading =
    this.tipoDocumentoFacade.isLoading || this.sunatTipoFacade.isLoading;

  //Services
  private readonly toastService = inject(ToastService);
  private readonly modalController = inject(ModalController);
  private readonly formValidationService = inject(FormValidationService);
  private readonly formBuilder = inject(FormBuilder);

  private buscarSubject = new Subject<string>();
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

  tipoDocumentoForm!: FormGroup;
  private gridApi!: GridApi;
  estadoSeleccionado: string = 'todos';
  naturalezaSeleccionada: string = '';
  tipoSeleccionado: string = '';
  usoSeleccionado: string = '';
  naturalezaContableSeleccionada: string = '';
  tipoDocumentoSeleccionado: string = '';
  sunatDocumentoSeleccionado: string = '';
  naturalezaContableFormSeleccionada: string = '';
  usoDocumentoSeleccionado: string = '';
  camponuevo: boolean = true;
  gridContext!: { componentParent: FTTipoDocumentoComponent };
  filaSeleccionada: any = null;
  cuentas: any[] = [];
  tieneReferenciaBancaria: string = 'si';
  nrocomprobante: string = 'si';
  sunatTiposDocumento: SunatTipoDocumentoEntity[] = [];

  todosEstados: string = 'todos';

  disabledValidar: boolean = true;

  textoSearch: string = '';

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
    noRowsToShow: 'No hay datos para mostrar',
  };

  rowData: TipoDocumentoEntity[] = [];

  colDefs: (ColDef | ColGroupDef)[] = [
    { field: 'codigo', headerName: 'Código', width: 80, filter: true },
    {
      field: 'nombre',
      headerName: 'Nombre de documento',
      flex: 1,
      minWidth: 150,
      filter: true,
    },
    {
      headerName: 'SUNAT',
      children: [
        {
          headerName: 'Codigo',
          width: 100,
          valueGetter: (params: any) => {
            return params.data?.sunatCatalogoTipoDocumento?.codigoItem
              ? params.data.sunatCatalogoTipoDocumento.codigoItem
              : '-';
          },
        },
        {
          headerName: 'Nombre',
          flex: 1,
          minWidth: 150,
          valueGetter: (params: any) => {
            return params.data?.sunatCatalogoTipoDocumento?.nombreItem
              ? params.data.sunatCatalogoTipoDocumento.nombreItem
              : '-';
          },
        },
      ],
    },
    // {
    //   field: 'catalogo_tipo_documento',
    //   headerName: 'Tipo de documento',
    //   width: 130,
    // },
    // {
    //   field: 'catalogo_naturaleza',
    //   headerName: 'Naturaleza contable',
    //   width: 135,
    // },
    // { field: 'catalogo_uso', headerName: 'Uso', width: 80 },
    // {
    //   field: 'catalogo_cuenta_contable',
    //   headerName: 'Cuenta contable',
    //   width: 120,
    // },
    // {
    //   field: 'catalogo_fecha_creacion',
    //   headerName: 'Fecha de creación',
    //   width: 120,
    //   valueFormatter: (params: any) => {
    //     if (params.value) {
    //       const date = new Date(params.value);
    //       const day = String(date.getDate() + 1).padStart(2, '0');
    //       const month = String(date.getMonth() + 1).padStart(2, '0');
    //       const year = date.getFullYear();
    //       return `${day}/${month}/${year}`;
    //     }
    //     return '';
    //   },
    // },
    {
      field: 'flagEstado',
      headerName: 'Estado',
      headerClass: 'ag-header-hover ag-header-10px centrarencabezado',
      width: 90,
      cellRenderer: (params: any) => {
        const estado = params.value;
        const estadoClass =
          estado === '1'
            ? 'text-green-600 bg-green-100'
            : 'text-red-600 bg-red-100';
        return `<span class="px-2 py-[1px] rounded-full text-xxss font-medium ${estadoClass}">${estado === '1' ? 'Activo' : 'Inactivo'}</span>`;
      },
      cellStyle: {
        textAlign: 'center',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    },
  ];

  columnTypes = {};

  constructor() {
    effect(() => {
      this.sunatTiposDocumento = [
        ...this.sunatTipoFacade.tiposDocumentoActivos(),
      ];
    });

    this.tipoDocumentoFacade.cargarTiposDocumento();

    effect(() => {
      this.rowData = [...this.tipoDocumentoFacade.tiposDocumento()].reverse();
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }
    });

    this.tipoDocumentoForm = this.formBuilder.group({
      codigoDocumento: ['', Validators.required],
      nombreD: ['', Validators.required],
      tipoDocumento: ['', Validators.required],
      naturaleza: ['', Validators.required],
      usoDocumento: ['', Validators.required],
      cuentaContable: ['', Validators.required],
      estado: ['1', Validators.required],
      refBancaria: [''],
      nroComprobante: [''],
      fechaCreacion: [{ value: this.getFechaHoy(), disabled: true }],
      sunatCodigo: [''],
    });
    this.disabledValidar = true;

    this.gridContext = { componentParent: this };
    effect(() => {
      //Mostrar ToastService al success de guardar
      if (this.tipoDocumentoFacade.resultGuardar()) {
        this.toastService.success('Tipo de documento guardado');
      } else if (this.tipoDocumentoFacade.resultActualizar()) {
        this.toastService.success('Tipo de documento actualizado');
      } else if (this.tipoDocumentoFacade.resultEliminar()) {
        this.toastService.success('Tipo de documento eliminado');
      } else if (this.tipoDocumentoFacade.errorObtener()) {
        this.toastService.danger('Error al cargar tipos de documento');
      } else if (this.tipoDocumentoFacade.errorGuardar()) {
        this.toastService.danger('Error al guardar tipo de documento');
      } else if (this.tipoDocumentoFacade.errorActualizar()) {
        this.toastService.danger('Error al actualizar tipo de documento');
      } else if (this.tipoDocumentoFacade.errorEliminar()) {
        this.toastService.danger('Error al eliminar tipo de documento');
      }
    });
  }

  ngOnInit() {
    this.tipoDocumentoFacade.cargarTiposDocumento();
    this.sunatTipoFacade.cargarTiposDocumentoActivos();
    this.cuentas = [
      { id: '1010', nombre: '1010 - Caja' },
      { id: '1020', nombre: '1020 - Bancos' },
      { id: '1030', nombre: '1030 - Cuentas por cobrar' },
    ];

    // Inicializar servicio de validación de cambios
    this.formValidationService.inicializarFormulario(this.tipoDocumentoForm);

    this.tipoDocumentoForm.valueChanges.subscribe(() => {
      this.actualizarEstadoBoton();
    });

    // Actualizar estado inicial del botón
    this.actualizarEstadoBoton();

    // Configuramos el buscador con un retraso de 300ms
    this.buscarSubject
      .pipe(
        debounceTime(300),
        distinctUntilChanged(), // Solo busca si el texto realmente cambió
      )
      .subscribe((texto) => {
        if (this.gridApi) {
          // El Quick Filter de AG-Grid hace toda la magia por ti
          this.gridApi.setGridOption('quickFilterText', texto);
        }
      });
  }

  private verificarCambiosEnFormulario() {
    // Verificar si hay algún campo con valor (excepto fechaCreacion que siempre tiene valor)
    const tieneValores =
      this.tipoDocumentoForm.get('nombreD')?.value ||
      this.tipoDocumentoForm.get('refBancaria')?.value ||
      this.tipoDocumentoForm.get('nroComprobante')?.value ||
      this.tipoDocumentoSeleccionado ||
      this.naturalezaContableFormSeleccionada ||
      this.usoDocumentoSeleccionado ||
      this.tipoDocumentoForm.get('cuentaContable')?.value;

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
    const hayValoresEnFormulario =
      this.tipoDocumentoForm.get('nombreD')?.value ||
      this.tipoDocumentoForm.get('refBancaria')?.value ||
      this.tipoDocumentoForm.get('nroComprobante')?.value ||
      this.tipoDocumentoForm.get('cuentaContable')?.value;

    // Verificar si hay selects con valores
    const haySelectsConValores =
      this.tipoDocumentoSeleccionado ||
      this.naturalezaContableFormSeleccionada ||
      this.usoDocumentoSeleccionado;

    // Si hay cambios en el formulario Y es un documento nuevo, habilitar el botón
    if ((hayValoresEnFormulario || haySelectsConValores) && this.camponuevo) {
      this.disabledValidar = false;
      return;
    }

    const camposObligatorios = ['nombreD', 'cuentaContable', 'estado'];
    const todosCompletos = camposObligatorios.every((campo) => {
      const valor = this.tipoDocumentoForm.get(campo)?.value;
      return valor !== null && valor !== undefined && valor !== '';
    });

    // Validar también los selects standalone
    const selectsCompletos =
      this.tipoDocumentoSeleccionado &&
      this.tipoDocumentoSeleccionado !== '' &&
      this.naturalezaContableFormSeleccionada &&
      this.naturalezaContableFormSeleccionada !== '' &&
      this.usoDocumentoSeleccionado &&
      this.usoDocumentoSeleccionado !== '';

    this.disabledValidar = !(todosCompletos && selectsCompletos);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
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
      const cuentaCompleta =
        this.filaSeleccionada.catalogo_cuenta_contable || '';
      const cuentaEncontrada = this.cuentas.find(
        (c) => cuentaCompleta.includes(c.id) || c.nombre === cuentaCompleta,
      );

      // Pausar detección de cambios mientras se cargan datos
      this.formValidationService.pausarDeteccion();

      this.tipoDocumentoForm.patchValue({
        codigoDocumento: this.filaSeleccionada.codigo || '',
        nombreD: this.filaSeleccionada.nombre || '',
        tipoDocumento: this.mapearTipoDocumento(
          this.filaSeleccionada.catalogo_tipo_documento,
        ),
        naturaleza: this.mapearNaturaleza(
          this.filaSeleccionada.catalogo_naturaleza,
        ),
        usoDocumento: this.mapearUsoDocumento(
          this.filaSeleccionada.catalogo_uso,
        ),
        cuentaContable: cuentaEncontrada ? cuentaEncontrada.id : '',
        estado: this.filaSeleccionada.flagEstado,
        refBancaria: this.filaSeleccionada.catalogo_referencia_bancaria || '',
        nroComprobante: this.filaSeleccionada.catalogo_nro_comprobante || '',
        fechaCreacion: this.filaSeleccionada.catalogo_fecha_creacion || '',
        sunatCodigo: this.filaSeleccionada.sunatCatalogoTipoDocumento
          ? this.filaSeleccionada.sunatCatalogoTipoDocumento.codigoItem
          : '',
      });

      // this.sunatDocumentoSeleccionado = this.filaSeleccionada
      //   .sunatCatalogoTipoDocumento
      //   ? this.filaSeleccionada.sunatCatalogoTipoDocumento.codigoItem
      //   : '';

      // Actualizar los selects standalone
      this.tipoDocumentoSeleccionado = this.mapearTipoDocumentoInverso(
        this.filaSeleccionada.catalogo_tipo_documento,
      );

      this.naturalezaContableFormSeleccionada = this.mapearNaturalezaInverso(
        this.filaSeleccionada.catalogo_naturaleza,
      );

      this.usoDocumentoSeleccionado = this.mapearUsoDocumentoInverso(
        this.filaSeleccionada.catalogo_uso,
      );

      // Actualizar radios de referencia y comprobante
      this.tieneReferenciaBancaria =
        this.filaSeleccionada.catalogo_tiene_referencia || 'no';
      this.nrocomprobante =
        this.filaSeleccionada.catalogo_tiene_comprobante || 'no';

      if (this.filaSeleccionada.catalogo_fecha_creacion) {
        // Soporta tanto ISO (yyyy-MM-dd) como dd/MM/yyyy
        const raw: string = this.filaSeleccionada.catalogo_fecha_creacion;
        if (raw.includes('-')) {
          const [anio, mes, dia] = raw.split('-');
          this.fechaCreacion = new Date(
            parseInt(anio),
            parseInt(mes) - 1,
            parseInt(dia),
          );
        } else {
          const [dia, mes, anio] = raw.split('/');
          this.fechaCreacion = new Date(
            parseInt(anio),
            parseInt(mes) - 1,
            parseInt(dia),
          );
        }
      }

      // Reanudar detección de cambios después de cargar datos
      this.formValidationService.reanudarDeteccion();

      // Marcar como pristine y untouched
      this.tipoDocumentoForm.markAsPristine();
      this.tipoDocumentoForm.markAsUntouched();

      // Resetear estado de validación
      setTimeout(() => {
        this.formValidationService.resetearEstado();
      }, 50);

      this.actualizarEstadoBoton();
    }
  }

  onBtReset(): void {
    this.tipoDocumentoFacade.cargarTiposDocumento();
  }

  private mapearTipoDocumento(tipo: string): string {
    const mapa: any = {
      Ingreso: 'factura',
      Egreso: 'boleta',
      Transferencia: 'recibo',
      Otros: 'nota',
    };
    return mapa[tipo] || '';
  }

  private mapearNaturaleza(naturaleza: string): string {
    const mapa: any = {
      Débito: 'compras',
      Crédito: 'ventas',
    };
    return mapa[naturaleza] || '';
  }

  private mapearUsoDocumento(uso: string): string {
    const mapa: any = {
      Pagos: 'compras',
      Cobranzas: 'ventas',
      Cobranza: 'ventas',
      Tesorería: 'interno',
      Conciliación: 'interno',
      Otros: 'interno',
    };
    return mapa[uso] || '';
  }

  private mapearTipoDocumentoInverso(tipo: string): string {
    const mapa: any = {
      Ingreso: 'ingreso',
      Egreso: 'egreso',
      Transferencia: 'transferencia',
      Otros: 'otros',
    };
    return mapa[tipo] || '';
  }

  private mapearNaturalezaInverso(naturaleza: string): string {
    const mapa: any = {
      Débito: 'debito',
      Crédito: 'credito',
    };
    return mapa[naturaleza] || '';
  }

  private mapearUsoDocumentoInverso(uso: string): string {
    const mapa: any = {
      Pagos: 'pagos',
      Cobranzas: 'cobranzas',
      Cobranza: 'cobranzas',
      Tesorería: 'tesoreria',
      Conciliación: 'conciliacion',
      Otros: 'otros',
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

    this.tipoDocumentoForm.reset({
      estado: '1',
      sunatCodigo: '',
      nombreD: '',
      // fechaCreacion: formatDate(new Date(), 'yyyy-MM-dd'),
    });

    // Limpiar los selects standalone
    this.tipoDocumentoSeleccionado = '';
    this.naturalezaContableFormSeleccionada = '';
    this.usoDocumentoSeleccionado = '';
    this.sunatDocumentoSeleccionado = '';
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
    console.log(
      'Cambios detectados:',
      this.formValidationService.tieneModificaciones(),
    );
    console.log('Estado del formulario:', this.tipoDocumentoForm.status);
    console.log('Valor del formulario:', this.tipoDocumentoForm.value);

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
    this.tipoDocumentoForm.reset({
      estado: '1',
      sunatCodigo: '',
      nombreD: '',
      // fechaCreacion: formatDate(new Date(), 'yyyy-MM-dd'),
    });

    // Limpiar variables
    this.camponuevo = true;
    this.filaSeleccionada = null;
    this.tipoDocumentoSeleccionado = '';
    this.naturalezaContableFormSeleccionada = '';
    this.usoDocumentoSeleccionado = '';
    this.sunatDocumentoSeleccionado = '';

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
    const formValido =
      this.tipoDocumentoForm.get('nombreD')?.value &&
      this.tipoDocumentoForm.get('estado')?.value;

    // const selectsValidos =
    //   this.tipoDocumentoSeleccionado &&
    //   this.naturalezaContableFormSeleccionada &&
    //   this.usoDocumentoSeleccionado;

    if (!formValido) {
      this.toastService.warning(
        'Por favor, completa todos los campos requeridos',
      );
      return;
    }

    // const cuentaId = this.tipoDocumentoForm.get('cuentaContable')?.value;
    // const cuentaEncontrada = this.cuentas.find((c: any) => c.id === cuentaId);

    // let fechaFormateada = '';
    // if (this.fechaCreacion) {
    //   const dia = String(this.fechaCreacion.getDate()).padStart(2, '0');
    //   const mes = String(this.fechaCreacion.getMonth() + 1).padStart(2, '0');
    //   const anio = this.fechaCreacion.getFullYear();
    //   fechaFormateada = `${anio}-${mes}-${dia}`;
    // } else {
    //   fechaFormateada = formatDate(new Date(), 'yyyy-MM-dd');
    // }

    const payload: TipoDocumentoEntity = {
      id: this.filaSeleccionada ? this.filaSeleccionada.id : undefined,
      codigo: this.tipoDocumentoForm.get('codigoDocumento')?.value,
      nombre: this.tipoDocumentoForm.get('nombreD')?.value,
      sunatCodigo: this.tipoDocumentoForm.get('sunatCodigo')?.value || null,
      flagEstado: this.tipoDocumentoForm.get('estado')?.value,
    };

    if (this.camponuevo) {
      const nuevoNumero = this.rowData.length + 1;
      payload.codigo = `TDO-${String(nuevoNumero).padStart(3, '0')}`;

      this.tipoDocumentoFacade.guardarTipoDocumento(payload);
      this.formValidationService.resetearEstado();

      setTimeout(() => {
        this.botonNuevaCuenta();
      }, 100);
    } else if (this.filaSeleccionada) {
      this.tipoDocumentoFacade.actualizarTipoDocumento(
        this.filaSeleccionada.id,
        payload,
      );
      this.formValidationService.resetearEstado();
    }
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
        headerName: 'Acción',
        field: 'accion',
        width: 150,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
      {
        headerName: 'Detalle del cambio',
        field: 'detalleCambio',
        flex: 1,
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
        detalleCambio: `Se creó el documento ${this.filaSeleccionada?.catalogo_codigo || 'N/A'}`,
      },
      {
        fechaHora: '07/02/2026 10:15:15',
        usuario: 'Diego Admin',
        accion: 'Edición',
        detalleCambio: 'Se editó la descripción del documento',
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
      },
    });

    await modal.present();
  }

  /**
   * Limpiar recursos en el destroy del componente
   */
  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
    this.buscarSubject.complete();
  }

  /**
   * Validar cambios antes de abandonar el componente
   */
  async canDeactivate(): Promise<boolean> {
    const tieneModificaciones =
      this.formValidationService.tieneModificaciones();
    console.log(
      '  canDeactivate() llamado - Tiene modificaciones:',
      tieneModificaciones,
    );

    if (!tieneModificaciones) {
      console.log('No hay cambios, permitir salida');
      return true;
    }

    const puede = await this.formValidationService.canDeactivate();
    console.log('Respuesta del modal:', puede);
    return puede;
  }

  onBuscar() {
    this.buscarSubject.next(this.textoSearch);
  }

  exportarExcel(): void {
    if (!this.gridApi) {
      return;
    }
    const fechaFormateada = format(new Date(), 'yyyy-MM-dd_HH-mm-ss');
    this.gridApi.exportDataAsExcel({
      fileName: `tipos_documento_${fechaFormateada}.xlsx`,
      sheetName: `tipos_documento`.substring(0, 28),
    });
  }
}
