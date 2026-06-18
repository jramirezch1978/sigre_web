import { Component, OnInit, OnDestroy, inject, computed, effect } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef, RowSelectionOptions, GridState } from 'ag-grid-community';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { PagosMasivosFacade } from 'src/app/modules/finanzas/application/facades/pagos-masivos.facade';
import { PagosMasivosEntity } from 'src/app/modules/finanzas/domain/models/pagos-masivos.entity';
import { PagosMasivosDocumentoEntity } from 'src/app/modules/finanzas/domain/models/pagos-masivos-documento.entity';
import { PagosMasivosSyncEffects } from 'src/app/modules/finanzas/effects/pagos-masivos-sync.effect';
import { PagosMasivosFeedbackEffects } from 'src/app/modules/finanzas/effects/pagos-masivos-feedback.effect';

// Font Awesome Icons
import { faBook, faEye, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-f-t-pagos-masivos',
  templateUrl: './f-t-pagos-masivos.component.html',
  styleUrls: ['./f-t-pagos-masivos.component.scss'],
  standalone: false,
})
export class FTPagosMasivosComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farBook = faBook;
  farEye = faEye;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  readonly facade = inject(PagosMasivosFacade);
  readonly loaderActivo = computed(() => this.facade.isLoading());
  // EFFECTS (inyectar para que los constructores registren los effect())
  private readonly _syncEffects = inject(PagosMasivosSyncEffects);
  private readonly _feedbackEffects = inject(PagosMasivosFeedbackEffects);

  // Variable temporal para documentos seleccionados durante el proceso de guardado
  private _pendingDocumentosPagados: PagosMasivosDocumentoEntity[] = [];

  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  mostrartabla: boolean = true;
  pagoMasivoForm!: FormGroup;
  private gridApi!: GridApi;
  private gridApiDocumentos!: GridApi;
  filaSeleccionada: any = null;
  pagoSeleccionadoNombre: string = 'Nuevo pago masivo';
  documentosSeleccionados: PagosMasivosDocumentoEntity[] = [];

  mediosPago = [
    { id: '1', nombre: 'Efectivo' },
    { id: '2', nombre: 'Transferencia' },
    { id: '3', nombre: 'Cheque' },
    { id: '4', nombre: 'Tarjeta' },
  ];

  cuentasBancarias = [
    { id: '1', nombre: 'BCP - Cta. Cte. 193-12345678-0-12 (Soles)' },
    { id: '2', nombre: 'BCP - Cta. Cte. 193-98765432-0-45 (Dólares)' },
    { id: '3', nombre: 'BBVA - Cta. Cte. 0011-0123-01-00012345 (Soles)' },
    { id: '4', nombre: 'Interbank - Cta. Cte. 200-3001234567-8 (Soles)' },
    { id: '5', nombre: 'Scotiabank - Cta. Cte. 000-1234567-8 (Soles)' },
  ];

  get esTransferencia(): boolean {
    return this.pagoMasivoForm?.get('medioPago')?.value === '2';
  }

  // Los datos ahora provienen del facade (cargados desde JSON)
  rowDataPagos: PagosMasivosEntity[] = [];
  rowDataDocumentos: PagosMasivosDocumentoEntity[] = [];

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

  defaultColDef = {
    valueFormatter: (params: any) => {
      if (params.colDef.checkboxSelection) return params.value;
      return (params.value === null || params.value === undefined || params.value === '')
        ? '-'
        : params.value;
    }
  };



  colDefsPagos: ColDef[] = [
    { field: 'pm_codigo', headerName: 'Código', width: 140 },
    { field: 'pm_documentosPagados', headerName: 'Documentos pagados', width: 140 },
    { field: 'pm_sucursales', headerName: 'Sucursales', flex: 1, minWidth:120, filter: true },
    { field: 'pm_moneda', headerName: 'Moneda', width: 110, filter: 1 },
    { field: 'pm_metodoPago', headerName: 'Método de pago', width: 160, filter: true },
    { field: 'pm_fechaPago', headerName: 'Fecha de pago', width: 100 },
    { field: 'pm_usuarioEjecutor', headerName: 'Usuario ejecutor', flex: 1, minWidth:120, filter: true },
  ];

  colDefsDocumentos: ColDef[] = [
    { field: 'pmd_tipoDoc', headerName: 'Tipo de documento', width: 120, filter: true },
    { field: 'pmd_serieNum', headerName: 'Serie / N° doc.', width: 120 },
    { field: 'pmd_proveedor', headerName: 'Proveedor', flex: 1, minWidth: 180, filter: true },
    { field: 'pmd_fechaEmision', headerName: 'Fecha de emisión', width: 90 },
    { field: 'pmd_fechaVencimiento', headerName: 'Fecha de vencimiento', width: 120 },
    { field: 'pmd_moneda', headerName: 'Moneda', width: 100 },
    { 
      field: 'pmd_montoTotal', 
      headerName: 'Monto total', 
      width: 110,
      headerClass: 'ag-right-aligned-header',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
          return formattedValue;
        }
        return '';
      },
      cellStyle: { justifyContent: 'right' }
    },
    { 
      field: 'pmd_montoPendiente', 
      headerName: 'Monto pendiente', 
      width: 130,
      headerClass: 'ag-right-aligned-header',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
          return formattedValue;
        }
        return '';
      },
      cellStyle: { justifyContent: 'right' }
    },
    { 
      field: 'pmd_montoPagado', 
      headerName: 'Monto pagado', 
      width: 120,
      headerClass: 'ag-right-aligned-header',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
          return formattedValue;
        }
        return '';
      },
      cellStyle: { justifyContent: 'right' }
    },
    { 
      field: 'pmd_estado', 
      headerName: 'Estado', 
      width: 100, 
      headerClass: 'centrarencabezado', 
      filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Parcial') {
          return '<span class="badge-table bg-[#FFDECC] text-[#FF8947]">Parcial</span>';
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        } else if (params.value === 'Pagado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagado</span>';
        }
        return params.value;
      },
    },
  ];

  rowSelection: RowSelectionOptions | 'single' | 'multiple' = {
    mode: 'multiRow',
  };

  initialState: GridState = {};

  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController,
    private formValidationService: FormValidationService
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Sincronizar la tabla principal con el store
    effect(() => {
      const data = this.facade.registros();
      this.rowDataPagos = data;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...data]);
      }
    });

    // Sincronizar la tabla de documentos disponibles con el store
    effect(() => {
      const data = this.facade.documentos() as PagosMasivosDocumentoEntity[];
      this.rowDataDocumentos = data;
      if (!this.filaSeleccionada && this.gridApiDocumentos) {
        this.gridApiDocumentos.setGridOption('rowData', [...data]);
      }
    });

    // Loading overlay en tabla principal (pagos masivos)
    effect(() => {
      const loading = this.facade.isLoading();
      if (this.gridApi) {
        if (loading) {
          this.gridApi.showLoadingOverlay();
        } else {
          this.gridApi.hideOverlay();
        }
      }
    });

    // Loading overlay en tabla de documentos disponibles
    effect(() => {
      const loading = this.facade.loadingDocumentos();
      if (this.gridApiDocumentos) {
        if (loading) {
          this.gridApiDocumentos.showLoadingOverlay();
        } else {
          this.gridApiDocumentos.hideOverlay();
        }
      }
    });

    // Post-guardado: actualizar UI con el nuevo pago
    effect(() => {
      if (this.facade.guardadoOk()) {
        const registros = this.facade.registros();
        if (registros.length === 0) return;
        const ultimoPago = registros[0];

        this.filaSeleccionada = ultimoPago;
        this.pagoSeleccionadoNombre = `Pago masivo - ${ultimoPago.pm_codigo}`;

        this.pagoMasivoForm.patchValue({
          fechaPago: ultimoPago.pm_fechaPago || '',
          medioPago: ultimoPago.pm_metodoPago || '',
          observaciones: ultimoPago.pm_observaciones || '',
          numeroPreAsiento: ultimoPago.pm_numeroPreAsiento || '',
        });
        this.pagoMasivoForm.disable();

        const documentosPagados = this._pendingDocumentosPagados.map(doc => ({
          ...doc,
          pmd_estado: 'Pagado' as 'Pagado'
        }));

        if (this.gridApiDocumentos) {
          this.gridApiDocumentos.setGridOption('rowData', documentosPagados);
          this.gridApiDocumentos.deselectAll();
        }

        this._pendingDocumentosPagados = [];
        this.documentosSeleccionados = [];

        setTimeout(() => {
          const firstNode = this.gridApi?.getDisplayedRowAtIndex(0);
          if (firstNode) {
            firstNode.setSelected(true);
          }
        }, 100);
      }
    });
  }

  ngOnInit() {
    this.initForm();
    this.facade.cargarDatos();
    this.facade.cargarDocumentos();
  }

  ngOnDestroy() {
    this.facade.resetState();
  }

  initForm() {
    this.pagoMasivoForm = this.formBuilder.group({
      fechaPago: [''],
      medioPago: [''],
      cuentaBancaria: [''],
      observaciones: [''],
      numeroPreAsiento: [''],
    });
    this.formValidationService.inicializarFormulario(this.pagoMasivoForm);
  }

  /**
   * Valida si el formulario tiene al menos un campo con valor
   */
  get formularioTieneValores(): boolean {
    if (!this.pagoMasivoForm) return false;
    
    const formValue = this.pagoMasivoForm.value;
    return !!(
      (formValue.fechaPago && formValue.fechaPago.toString().trim()) ||
      (formValue.medioPago && formValue.medioPago.toString().trim()) ||
      (formValue.observaciones && formValue.observaciones.toString().trim())
    );
  }

  /**
   * Valida si el botón "Nuevo pago masivo" debe estar habilitado
   */
  get botonNuevoPagoHabilitado(): boolean {
    return this.filaSeleccionada !== null || this.formularioTieneValores;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onGridReadyDocumentos(params: GridReadyEvent) {
    this.gridApiDocumentos = params.api;
    // Cargar todos los documentos disponibles por defecto desde el facade
    const documentos = this.facade.documentos() as PagosMasivosDocumentoEntity[];
    this.gridApiDocumentos.setGridOption('rowData', [...documentos]);
  }

  async onCellClicked(event: any) {
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;

    // Salir del modo nuevo y mostrar información del pago seleccionado
    const data = event.data;
    this.filaSeleccionada = data;
    this.pagoSeleccionadoNombre = `Información de pago masivo: ${data.pm_codigo}`;
    this.gridApi.deselectAll();
    event.node.setSelected(true);

    this.pagoMasivoForm.patchValue({
      fechaPago: data.pm_fechaPago || '',
      medioPago: data.pm_metodoPago || '',
      observaciones: data.pm_observaciones || '',
      numeroPreAsiento: data.pm_numeroPreAsiento || '',
    });

    // Mostrar solo los documentos pagados de este pago masivo (sin checkboxes)
    // En este ejemplo, mostramos los primeros 5 documentos como ejemplo
    const documentosPagados = this.rowDataDocumentos.slice(0, 5).map(doc => ({
      ...doc,
      pmd_estado: 'Pagado' as 'Pagado'
    }));
    
    if (this.gridApiDocumentos) {
      this.gridApiDocumentos.setGridOption('rowData', documentosPagados);
      this.gridApiDocumentos.deselectAll();
    }

    this.pagoMasivoForm.disable();
    
    // Deshabilitar específicamente el control de observaciones
    const observacionesCtrl = this.pagoMasivoForm.get('observaciones');
    if (observacionesCtrl) {
      observacionesCtrl.disable();
    }
    
    // Deshabilitar el campo de número de asiento contable específicamente
    const numeroAsientoCtrl = this.pagoMasivoForm.get('numeroPreAsiento');
    if (numeroAsientoCtrl) {
      numeroAsientoCtrl.disable();
    }

    this.formValidationService.resetearEstado();
  }

  onSelectionChanged() {
    if (this.gridApiDocumentos) {
      const selectedRows = this.gridApiDocumentos.getSelectedRows();
      this.documentosSeleccionados = selectedRows;
    }
  }

  async nuevoPageMasivo() {
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;

    this.filaSeleccionada = null;
    this.pagoSeleccionadoNombre = 'Nuevo pago masivo';
    this.documentosSeleccionados = [];
    
    // Deseleccionar en la tabla principal
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Limpiar y habilitar formulario
    this.pagoMasivoForm.reset();
    this.pagoMasivoForm.enable();
    
    // Habilitar específicamente el control de observaciones
    const observacionesCtrl = this.pagoMasivoForm.get('observaciones');
    if (observacionesCtrl) {
      observacionesCtrl.enable();
    }

    // Mostrar todos los documentos disponibles desde el facade
    if (this.gridApiDocumentos) {
      this.gridApiDocumentos.setGridOption('rowData', [...(this.facade.documentos() as PagosMasivosDocumentoEntity[])]);
      this.gridApiDocumentos.deselectAll();
    }
  }

  async cancelarPagoMasivo() {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Cancelar reporte',
        title: '¿Estás seguro de cancelar este reporte?',
        message: 'Al cancelar este reporte, todo cálculo que hayas realizado se eliminará. Una vez cancelado, no podrás modificar ni deshacer esta acción.',
        btnCancelTxt: 'No, regresar',
        btnOkTxt: 'Sí, cancelar',
        isDelete: true
      }
    });

    await modal.present();
    const { data } = await modal.onDidDismiss();

    if (data) {
      // Volver al modo nuevo (estado inicial)
      this.filaSeleccionada = null;
      this.pagoSeleccionadoNombre = 'Nuevo pago masivo';
      this.documentosSeleccionados = [];
      this._pendingDocumentosPagados = [];
      
      this.pagoMasivoForm.reset();
      this.pagoMasivoForm.enable();

      if (this.gridApi) {
        this.gridApi.deselectAll();
      }

      if (this.gridApiDocumentos) {
        this.gridApiDocumentos.setGridOption('rowData', [...(this.facade.documentos() as PagosMasivosDocumentoEntity[])]);
        this.gridApiDocumentos.deselectAll();
      }
    }
  }

  registrarPago() {
    if (this.documentosSeleccionados.length === 0) {
      this.toastService.danger('Debe seleccionar al menos un documento para pagar.');
      return;
    }

    const formValues = this.pagoMasivoForm.value;

    // Generar código único para el nuevo pago (formato: M-PD-YYYY-XXXX)
    const registros = this.facade.registros();
    const codigoNumero = registros.length + 1;
    const codigoPago = `M-PD-${new Date().getFullYear()}-${String(codigoNumero).padStart(4, '0')}`;

    // Generar número de asiento contable (formato: ASC-YYYY-XXXXX con 5 dígitos)
    const numeroAsiento = `ASC-${new Date().getFullYear()}-${String(codigoNumero).padStart(5, '0')}`;

    // Obtener el medio de pago seleccionado
    const medioSeleccionado = this.mediosPago.find(m => m.id === formValues.medioPago)?.nombre || formValues.medioPago;

    // Guardar documentos seleccionados para el efecto post-guardado
    this._pendingDocumentosPagados = [...this.documentosSeleccionados];

    // Crear entidad y delegar al facade
    const nuevoPago: PagosMasivosEntity = {
      pm_codigo: codigoPago,
      pm_documentosPagados: this.documentosSeleccionados.length,
      pm_sucursales: 'Sucursal principal',
      pm_moneda: 'Soles',
      pm_metodoPago: medioSeleccionado,
      pm_fechaPago: formValues.fechaPago ? new Date(formValues.fechaPago).toLocaleDateString('es-PE') : new Date().toLocaleDateString('es-PE'),
      pm_usuarioEjecutor: 'Usuario actual',
      pm_numeroPreAsiento: numeroAsiento,
      pm_observaciones: formValues.observaciones || ''
    };

    this.facade.guardar(nuevoPago);
    this.formValidationService.resetearEstado();
    // El toast de éxito lo maneja PagosMasivosSyncEffects
    // La actualización de la UI la maneja el effect de guardadoOk en el constructor
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Lógica para filtrar datos
  }

  onFechaNSeleccionada(date: Date) {
    if (this.pagoMasivoForm && date) {
      const fechaCtrl = this.pagoMasivoForm.get('fechaPago');
      if (fechaCtrl) {
        fechaCtrl.setValue(date);
      }
    }
  }

  async verAsientoContable() {
    if (!this.filaSeleccionada || !this.filaSeleccionada.pm_numeroPreAsiento) {
      this.toastService.danger('No hay asiento contable disponible.');
      return;
    }

    const colDefs: ColDef[] = [
      { field: 'cuentaContable', headerName: 'Cuenta Contable', width: 120 },
      { field: 'descripcion', headerName: 'Descripción', flex: 1 },
      { field: 'debe', headerName: 'Debe (S/)', width: 100, 
        headerClass: 'derechaencabezado',
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
          const style: any = { justifyContent: 'end', };
          if (params.value < 0) {
            style.color = '#EF4444'; // Rojo para negativos
          }
          return style;
        }
       },
      { field: 'haber', headerName: 'Haber (S/)', width: 100, 
        headerClass: 'derechaencabezado',
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
          const style: any = { justifyContent: 'end', };
          if (params.value < 0) {
            style.color = '#EF4444'; // Rojo para negativos
          }
          return style;
        }
       },
    ];
    
    const rowData = [
      { cuentaContable: '421101', descripcion: 'Proveedores nacionales', debe: '-', haber: '5,500.00' },
      { cuentaContable: '101101', descripcion: 'Caja y Bancos – Interbank', debe: '5,500.00', haber: '-' },
    ];

    const detalles = [
      { label: 'Fecha de registro', value: '05/11/2025' },
      { label: 'Origen', value: 'Tesorería' },
      { label: 'Sucursal', value: 'Sucursal Principal' },
      { label: 'Estado', value: 'Registrado' },
      { label: 'Total Debe (S/)', value: '5,500.00' },
      { label: 'Total Haber (S/)', value: '5,500.00' },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Información del asiento contable ${this.filaSeleccionada.pm_numeroPreAsiento}`,
        subtitulomodal: 'Detalle del asiento',
        detalles: detalles,
        mostrarTabla: true,
        colDefs: colDefs,
        rowData: rowData,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        textoBotonCancelar: 'Cerrar',
      }
    });

    await modal.present();
  }

  async modalverActualizaciones() {
    if (!this.filaSeleccionada) {
      this.toastService.danger('Seleccione un pago masivo.');
      return;
    }

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
      { fechaHora: '12/12/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Se registró el pago masivo' },
      { fechaHora: '13/12/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se modificó el pago masivo' },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones del pago masivo ${this.filaSeleccionada.pm_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }

  onBtReset() {
    this.facade.cargarDatos();
  }

}
