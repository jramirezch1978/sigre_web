import { Component, OnInit, inject, effect, Signal } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { TransaccionPeriodicaFacade } from 'src/app/modules/finanzas/application/facades/transaccion-periodica.facade';
import { TransaccionPeriodicaFeedbackEffects } from 'src/app/modules/finanzas/effects/transaccion-periodica-feedback.effect';
import { TransaccionPeriodicaSyncEffects } from 'src/app/modules/finanzas/effects/transaccion-periodica-sync.effect';
import { TransaccionPeriodicaEntity } from 'src/app/modules/finanzas/domain/models/transaccion-periodica.entity';

// Font Awesome Icons
import { faBook, faSearch as faSearchRegular } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight, faSearch as faSearchSolid } from '@fortawesome/pro-solid-svg-icons';
import { ProveedorFacade } from '@modules/compras/application/facades/proveedor.facade';
import { ProveedorEntity } from '@modules/compras/domain/models/proveedor.entity';

// Font Awesome Icons

@Component({
  selector: 'app-f-o-transacciones-periodicas',
  templateUrl: './f-o-transacciones-periodicas.component.html',
  styleUrls: ['./f-o-transacciones-periodicas.component.scss'],
  standalone: false,
})
export class FOTransaccionesPeriodicasComponent implements OnInit {
  // ── Clean Architecture ───────────────────────────────────────────────────
  readonly transaccionFacade = inject(TransaccionPeriodicaFacade);
  readonly proveedorFacade = inject(ProveedorFacade);
  private readonly _feedbackEffects = inject(TransaccionPeriodicaFeedbackEffects);
  private readonly _syncEffects = inject(TransaccionPeriodicaSyncEffects);
  readonly isLoading: Signal<boolean> = this.transaccionFacade.isLoading;

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearchRegular;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;
  fasSearch = faSearchSolid;

  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  proveedores: ProveedorEntity[] = [];
  mostrarCalendarios: boolean = true;
  transaccionForm!: FormGroup;
  disabledCalendars: boolean = false;
  private gridApi!: GridApi;
  gridContext!: { componentParent: FOTransaccionesPeriodicasComponent };
  filaSeleccionada: TransaccionPeriodicaEntity | null = null;
  private gridApiDetalle!: GridApi;
  cuentasContables: any[] = [];
  countries = ALL_COUNTRIES;
  tiposIdentificacion: any[] = [];
  estadoSelect = [
    'Activo',
    'Pausado'
  ];
  monedas = [
    'Soles',
    'Dólares'
  ];
  tipoMonto = [
    'Fijo',
    'Variable'
  ];
  periodicidad = [
    'Mensual',
    'Bimensual',
    'Trimestral',
    'Semestral',
    'Anual'
  ];
  dias = Array.from({ length: 31 }, (_, i) => i + 1);

  centrosCostos = [
    { codigo: 'AC01', nombre: 'AC01 - Administración', porcentaje: '10%' },
    { codigo: 'AC02', nombre: 'AC02 - Ventas', porcentaje: '10%' },
    { codigo: 'AC03', nombre: 'AC03 - Producción', porcentaje: '10%' },
    { codigo: 'AC04', nombre: 'AC04 - Logística', porcentaje: '10%' },
    { codigo: 'AC05', nombre: 'AC05 - Finanzas', porcentaje: '10%' }
  ];
  sucursales = [
    { id: '1', nombre: 'Miraflores' },
    { id: '2', nombre: 'San Isidro' },
    { id: '3', nombre: 'Surco' },
    { id: '4', nombre: 'La Molina' },
    { id: '5', nombre: 'San Borja' },
    { id: '6', nombre: 'Barranco' },
    { id: '7', nombre: 'Chorrillos' },
    { id: '8', nombre: 'Jesús María' },
    { id: '9', nombre: 'Lince' },
    { id: '10', nombre: 'Magdalena' },
    { id: '11', nombre: 'Pueblo Libre' },
    { id: '12', nombre: 'San Miguel' },
    { id: '13', nombre: 'Callao' }
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
  rowData: TransaccionPeriodicaEntity[] = [];



  colDefs: ColDef[] = [
    { field: 'transaccion_codigo_programacion', headerName: 'Código de programación', width: 150 },
    { field: 'transaccion_fecha_emision', headerName: 'Fecha de emisión', width: 100,
      valueFormatter: (params) => {
        if (params.value) {
          const date = new Date(params.value + 'T00:00:00');
          return date.toLocaleDateString('es-PE');
        }
        return '';
      }
    },
    { field: 'transaccion_fecha_vencimiento', headerName: 'Fecha de vencimiento', width: 100,
      valueFormatter: (params) => {
        if (params.value) {
          const date = new Date(params.value + 'T00:00:00');
          return date.toLocaleDateString('es-PE');
        }
        return '';
      }
    },
    { field: 'transaccion_doc_fiscal', headerName: 'Documento fiscal', flex: 1, minWidth: 150, filter: true },
    { field: 'transaccion_proveedor', headerName: 'Razón social', flex: 1, minWidth: 150, filter: true },
    { field: 'transaccion_tipo_gasto', headerName: 'Tipo de gasto', width: 150, filter: true },
    { field: 'transaccion_periodicidad', headerName: 'Periodicidad', width: 130, filter: true },
    { field: 'transaccion_dia_mes', headerName: 'Día del mes', width: 120 },
    {
      field: 'transaccion_monto', headerName: 'Monto', width: 120,
      valueFormatter: (params: any) => {
        if (params.data?.transaccion_moneda === 'Soles') {
          return `S/ ${params.value}`;
        } else if (params.data?.transaccion_moneda === 'Dólares') {
          return `$ ${params.value}`;
        }
        return params.value;
      }
    },
    { field: 'transaccion_cuenta_contable', headerName: 'Cuenta contable', width: 150 },
    {
      field: 'transaccion_estado', headerName: 'Estado', width: 120, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }, filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
        } else if (params.value === 'Pausado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Pausado</span>';
        }
        return params.value;
      }
    }
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

    // Sincronizar store → grid
    effect(() => {
      const data = this.transaccionFacade.transacciones();
      this.rowData = data;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }
    });

    // Effect para sincronizar proveedores desde el store
    effect(() => {
      this.proveedores = this.proveedorFacade.proveedores();
    });

  }

  ngOnInit() {
    this.transaccionFacade.cargarTransacciones();
    this.docpais();
    this.cargarCuentasContables();

    const hoy = new Date().toISOString().split('T')[0];
    // Inicializar formulario 
    this.transaccionForm = this.formBuilder.group({
      tipoDocumentoProveedor: [this.tiposIdentificacion[0]?.value, Validators.required],
      numeroDocumentoProveedor: ['', Validators.required],
      nombreProveedor: ['', Validators.required],
      tipoGasto: ['', Validators.required],
      periodicidad: ['', Validators.required],
      diaMes: ['', Validators.required],
      tipoMonto: ['', Validators.required],
      montoEst: [''],
      montoMin: [''],
      montoMax: [''],
      moneda: [null, Validators.required],
      cuentaC: ['', Validators.required],
      centroC: ['', Validators.required],
      sucursal: ['', Validators.required],
      estado: ['Activo'],
      fechaE: [null, Validators.required],
      fechaV: [null],
      aprobacion: ['Pendiente']
    });

    this.gridContext = { componentParent: this };
    this.formValidationService.inicializarFormulario(this.transaccionForm);
    this.proveedorFacade.cargarProveedores();
  }
  docpais() {
    const country = this.countries.find(
      c => c.codigo === this.countryService.getCountryCode()
    );
    this.countries.find(c => {
      if (c.codigo === country?.codigo) {
        c.personalidadfiscal?.find(tip => {
          this.tiposIdentificacion.push({ value: tip.value, label: tip.nombre, numero: tip.numero })
        })
      }
    })
  }

  cargarCuentasContables() {
    // Leer directamente desde localStorage para obtener los datos más recientes
    const datosGuardados = localStorage.getItem('plancontable');
    let cuentasLS: any[] = [];

    if (datosGuardados) {
      try {
        cuentasLS = JSON.parse(datosGuardados);
      } catch (e) {
        console.error('Error al parsear cuentas contables:', e);
        cuentasLS = [];
      }
    }

    console.log(' Cuentas contables cargadas:', cuentasLS.length);

    // Mapear cuentas con el formato necesario para el autocomplete
    this.cuentasContables = cuentasLS.map((item: any) => ({
      id: item.codigo,
      codigo: item.codigo,
      descripcion: item.descripcion,
      nombre: `${item.codigo} - ${item.descripcion}`,
      naturaleza: item.naturaleza,
      tipo: item.tipo,
      nivel: item.nivel,
      estado: item.estado,
      ...item
    }));

    console.log(' Cuentas contables cargadas:', this.cuentasContables.length);
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Lógica para filtrar datos
  }

  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  onCuentaSeleccionada(cuenta: any) {
    this.transaccionForm.patchValue({
      cuentaC: cuenta.id
    });
  }
  onSucursalSeleccionada(sucursal: any) {
    this.transaccionForm.patchValue({
      sucursal: sucursal.id
    });
  }
  onCentroSeleccionado(centroC: any) {
    this.transaccionForm.patchValue({
      centroC: centroC.codigo
    });
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // No auto-seleccionar ningún dato al iniciar
  }

  async onCellClicked(event: any) {
    const data = event?.data;
    if (!data) { return; }

    // Prevenir selección automática de AG-Grid
    event.node.setSelected(false);

    // Guardar referencia del elemento que tiene el foco
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Mantener selección anterior
      if (this.filaSeleccionada) {
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
            if (node.data.transaccion_codigo_programacion === this.filaSeleccionada?.transaccion_codigo_programacion) {
              node.setSelected(true);
            }
          });

          // Restaurar el foco al campo que estaba activo
          if (elementoConFoco && elementoConFoco.tagName === 'INPUT') {
            setTimeout(() => {
              elementoConFoco.focus();
            }, 100);
          }
        }, 0);
      } else {
        this.gridApi.deselectAll();
      }
      return;
    }

    // Cargar datos del transaccion seleccionado
    this.cargarDatostransaccion(data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatostransaccion(data: any, node?: any): void {
    this.filaSeleccionada = data;

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    if (node) {
      node.setSelected(true);
    }

    this.transaccionForm.patchValue({
      tipoDocumentoProveedor: data.transaccion_tipo_doc_proveedor || '',
      nombreProveedor: data.transaccion_proveedor || '',
      numeroDocumentoProveedor: data.transaccion_doc_fiscal || '',
      tipoGasto: data.transaccion_tipo_gasto || '',
      periodicidad: data.transaccion_periodicidad || '',
      diaMes: data.transaccion_dia_mes || '',
      tipoMonto: data.transaccion_tipo_monto || '',
      montoEst: data.transaccion_monto || '',
      montoMin: data.transaccion_monto_min || '',
      montoMax: data.transaccion_monto_max || '',
      moneda: data.transaccion_moneda || '',
      cuentaC: data.transaccion_cuenta_contable || '',
      centroC: data.transaccion_centro_costo || '',
      sucursal: data.transaccion_sucursal || '',
      estado: data.transaccion_estado || '',
      fechaE: data.transaccion_fecha_emision || '',
      fechaV: data.transaccion_fecha_vencimiento || '',
      aprobacion: data.transaccion_aprobacion || '',
    });

    this.formValidationService.resetearEstado();
  }

  async botonRegistrarTransaccion() {
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Cancelar acción
    }
    this.resetearCalendarios();

    // Reiniciar el formulario completamente vacío
    if (this.transaccionForm) {
      this.transaccionForm.reset({
        tipoDocumentoProveedor: 'ruc',
        estado: 'Activo',
      });

      this.filaSeleccionada = null;

      // Deseleccionar fila de la tabla
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }

      // Resetear estado del servicio de validación
      this.formValidationService.resetearEstado();

    }
  }
  // AGREGAR este nuevo método para resetear calendarios:
  private resetearCalendarios(): void {
    // Ocultar calendarios
    this.mostrarCalendarios = false;

    // Mostrar calendarios de nuevo en el siguiente ciclo
    setTimeout(() => {
      this.mostrarCalendarios = true;
    }, 0);
  }


  botonGuardar() {
    // Validar que el formulario sea válido
    if (this.transaccionForm.invalid) {
      this.toastService.warning(`Por favor, complete todos los campos requeridos`);
      return;
    }

    const formValue = this.transaccionForm.getRawValue();

    // Crear objeto completo con todos los campos del formulario
    const transaccionCompleta = {
      transaccion_codigo_programacion: this.filaSeleccionada
        ? this.filaSeleccionada.transaccion_codigo_programacion
        : this.generateCodigoProgramacion(),
      transaccion_doc_fiscal: formValue.numeroDocumentoProveedor || '',
      transaccion_proveedor: formValue.nombreProveedor || '',
      transaccion_tipo_doc_proveedor: formValue.tipoDocumentoProveedor || '',
      transaccion_tipo_gasto: formValue.tipoGasto || '',
      transaccion_periodicidad: formValue.periodicidad || '',
      transaccion_dia_mes: formValue.diaMes || 1,
      transaccion_tipo_monto: formValue.tipoMonto || 'Fijo',
      transaccion_monto: formValue.montoEst || formValue.montoMin || 0,
      transaccion_monto_min: formValue.montoMin || '',
      transaccion_monto_max: formValue.montoMax || '',
      transaccion_moneda: formValue.moneda || 'Soles',
      transaccion_cuenta_contable: formValue.cuentaC || '',
      transaccion_centro_costo: formValue.centroC || '',
      transaccion_sucursal: formValue.sucursal || '',
      transaccion_estado: formValue.estado || 'Activo',
      transaccion_fecha_emision: formValue.fechaE || '',
      transaccion_fecha_vencimiento: formValue.fechaV || '',
      transaccion_aprobacion: formValue.aprobacion || ''
    };

    if (this.filaSeleccionada) {
      // EDITAR: Actualizar transaccion existente — mantener selección y formulario
      this.transaccionFacade.actualizarTransaccion(
        this.filaSeleccionada.transaccion_codigo_programacion,
        transaccionCompleta
      );
      this.formValidationService.resetearEstado();
    } else {
      // AGREGAR: Crear nueva transaccion — limpiar formulario y selección
      this.transaccionFacade.guardarTransaccion(transaccionCompleta);
      this.limpiarFormulario();
      this.formValidationService.resetearEstado();
    }
  }

  private generateCodigoProgramacion(): string {
    const maxCodigo = this.rowData
      .map(t => parseInt(t.transaccion_codigo_programacion, 10))
      .filter(n => !isNaN(n))
      .reduce((max, n) => (n > max ? n : max), 0);
    return String(maxCodigo + 1).padStart(5, '0');
  }

  // Método para limpiar y resetear el formulario
  private limpiarFormulario(): void {
    const hoy = new Date().toISOString().split('T')[0];

    this.transaccionForm.reset({
      tipoDocumentoProveedor: 'RUC',
      estado: 'Pendiente',
    });


    this.filaSeleccionada = null;

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }

  // Método para buscar Proveedor por DNI/RUC
  buscarProveedor() {
    const tipoDoc = this.transaccionForm.get('documentoproveedor')?.value;
    let numeroDoc = this.transaccionForm.get('numeroDocumentoProveedor')?.value;

    console.log(' Buscando proveedor - Tipo:', tipoDoc, 'Documento original:', numeroDoc, 'Tipo de dato:', typeof numeroDoc);

    if (!numeroDoc) {
      this.toastService.warning('Por favor, ingresa un número de documento');
      return;
    }

    // Convertir a string y limpiar espacios
    numeroDoc = String(numeroDoc).trim();

    console.log(' Documento limpio:', numeroDoc);
    console.log(' Proveedores disponibles desde localStorage:', this.proveedores.length);

    // DEBUG: Mostrar todos los identificacionFiscal de los proveedores
    console.log(' Documentos en proveedores:', this.proveedores.map(p => ({
      proveedor_identificacion_fiscal: p.proveedor_identificacion_fiscal,
      tipo: typeof p.proveedor_identificacion_fiscal,
      proveedor_estado: p.proveedor_estado,
      proveedor_razon_social: p.proveedor_razon_social
    })));

    // Buscar en proveedores cargados desde localStorage
    // Comparar ambos como strings y también verificar estado activo
    const proveedorEncontrado = this.proveedores.find(p => {
      const docProveedor = String(p.proveedor_identificacion_fiscal).trim();
      const docBusqueda = String(numeroDoc).trim();
      const estadoActivo = p.proveedor_estado === 'Activo';

      console.log(`Comparando: "${docProveedor}" === "${docBusqueda}" && estado: ${p.proveedor_estado} (activo: ${estadoActivo})`);

      return docProveedor === docBusqueda && estadoActivo;
    });

    console.log('  Resultado búsqueda:', proveedorEncontrado ? 'ENCONTRADO' : 'NO ENCONTRADO');

    if (proveedorEncontrado) {
      // PAUSAR detección de cambios

      // Rellenar automáticamente los campos con datos del proveedor
      this.transaccionForm.patchValue({
        nombreProveedor: proveedorEncontrado.proveedor_razon_social,
        direccionFiscal: proveedorEncontrado.proveedor_direccion_fiscal || ''
      });

      console.log(' Proveedor encontrado:', proveedorEncontrado.proveedor_razon_social);

      // REANUDAR detección después de un momento
      setTimeout(() => {
      }, 100);
    } else {
      // Mostrar mensaje más detallado
      this.toastService.warning(
        'Proveedor no encontrado',
        `No se encontró ${tipoDoc}: ${numeroDoc} o el proveedor está inactivo`
      );
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
      { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Se ha creado el grupo 1.00' },
      { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se edito la descripción del grupo' },
      { fechaHora: '13/11/2025 09:00', usuario: 'Carlos Rodríguez', accion: 'Actualización', detalleCambio: 'Se cambió el tipo de flujo' },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones de la transacción ${this.filaSeleccionada?.transaccion_codigo_programacion}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

  // onFechaSeleccionadaI(date: Date) {
  //   console.log('Fecha seleccionada:', date);
  //   if (this.transaccionForm && date) {
  //     const fechaVormato = new Date(date).toISOString().split('T')[0];
  //     this.transaccionForm.get('fechaE')?.setValue(fechaVormato);
  //   }
  // }

  // onFechaSeleccionadaF(date: Date) {
  //   console.log('Fecha seleccionada:', date);
  //   if (this.transaccionForm && date) {
  //     const fechaVormato = new Date(date).toISOString().split('T')[0];
  //     this.transaccionForm.get('fechaV')?.setValue(fechaVormato);
  //   }
  // }

  onFechaEmision(date: Date) {
    this.transaccionForm.patchValue({
      fechaE: date,
    })
  }

  onFechaVencimiento(date: Date) {
    this.transaccionForm.patchValue({
      fechaV: date,
    })
  }


  onBtReset() {
    this.transaccionFacade.cargarTransacciones();
  }
}