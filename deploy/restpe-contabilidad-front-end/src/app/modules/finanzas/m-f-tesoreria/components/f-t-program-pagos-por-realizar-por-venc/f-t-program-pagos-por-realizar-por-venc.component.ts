import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef, GridState } from 'ag-grid-community';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ProgramPagosPorVencEntity } from 'src/app/modules/finanzas/domain/models/program-pagos-por-venc.entity';
import { ProgramPagosPorVencFacade } from 'src/app/modules/finanzas/application/facades/program-pagos-por-venc.facade';
import { ProgramPagosPorVencFeedbackEffects } from 'src/app/modules/finanzas/effects/program-pagos-por-venc-feedback.effect';

// Font Awesome Icons
import { faBook, faEye, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDollar, faDownload, faFile, faPercent, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-f-t-program-pagos-por-realizar-por-venc',
  templateUrl: './f-t-program-pagos-por-realizar-por-venc.component.html',
  styleUrls: ['./f-t-program-pagos-por-realizar-por-venc.component.scss'],
  standalone: false
})
export class FTProgramPagosPorRealizarPorVencComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farBook = faBook;
  farEye = faEye;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDollar = faDollar;
  fasDownload = faDownload;
  fasFile = faFile;
  fasPercent = faPercent;
  fasRotateRight = faRotateRight;

  // Facade e Effects (arquitectura limpia)
  private readonly programPagosFacade = inject(ProgramPagosPorVencFacade);
  private readonly feedbackEffects = inject(ProgramPagosPorVencFeedbackEffects);

  // Selectores reactivos del store
  readonly isLoading = this.programPagosFacade.isLoading;

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  
  private gridApi!: GridApi;
  filaSeleccionada: any = null;
  modoCreacion: boolean = true;
  pagoForm!: FormGroup;
  fechaRegistroSeleccionada: Date | undefined;
  fechaPagoSeleccionada: Date | undefined;
  fechaVencimientoDoc: Date | undefined;
  mostrarDocAsociado: boolean = false;
  mostrarCamposDocumento: boolean = false;
  documentosAsociados: any[] = [];
  
  prioridades = [
    { id: 'Alta', nombre: 'Alta' },
    { id: 'Media', nombre: 'Media' },
    { id: 'Baja', nombre: 'Baja' },
  ];
  
  proveedores = [
    { id: 1, nombre: 'Carnes del Sur S.A.C' },
    { id: 2, nombre: 'Distribuidora Gourmet S.A.C' },
    { id: 3, nombre: 'La Cooperativa del Café' },
    { id: 4, nombre: 'Pescados del Mar S.A.C' },
  ];
  
  tiposDoc = [
    { id: 'Factura', nombre: 'Factura' },
    { id: 'Letra', nombre: 'Letra' },
    { id: 'Nota de débito', nombre: 'Nota de débito' },
  ];
  
  cuentasPago = [
    { id: 1, nombre: 'BCP-001 - Cuenta Recaudadora (..4587)' },
    { id: 2, nombre: 'BBVA-002 - Cuenta Operativa (..1205)' },
    { id: 3, nombre: 'Interbank-003 - Cuenta Corriente (..7890)' },
    { id: 4, nombre: 'Scotiabank-004 - Cuenta de Ahorros (..3456)' },
  ];
  
  entidades = [
    { id: 1, nombre: 'BCP' },
    { id: 2, nombre: 'BBVA' },
    { id: 3, nombre: 'Interbank' },
    { id: 4, nombre: 'Scotiabank' },
    { id: 5, nombre: 'B. Nación' },
    { id: 6, nombre: 'Caja Piura' },
    { id: 7, nombre: 'Caja Arequipa' },
    { id: 8, nombre: 'Caja Trujillo' },
  ];
  
  estados = [
    { id: 'Programado', nombre: 'Programado' },
    { id: 'Pagado', nombre: 'Pagado' },

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
  
  defaultColDef = {
    valueFormatter: (params: any) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '-'
        : params.value;
    }
  };
  
  rowData: ProgramPagosPorVencEntity[] = [];
  
  colDefs: ColDef[] = [
    { field: 'ppv_codigo', headerName: 'Código', width: 120, minWidth: 120 },
    { field: 'ppv_fechaRegistro', headerName: 'Fecha de vencimiento', width: 110, minWidth: 110 },
    { field: 'ppv_fechaPagoProg', headerName: 'Fecha. programado', width: 110, minWidth: 110 },
    { field: 'ppv_tipoDoc', headerName: 'Tipo de comprobante', width: 110, minWidth:110, filter: true },
    { field: 'ppv_nDocumento', headerName: 'N° documento', width: 140, minWidth:140 },
    { field: 'ppv_entidad', headerName: 'Entidad', flex: 1, minWidth: 180 },
    { field: 'ppv_ctaPago', headerName: 'Cuenta de pago', flex: 1, minWidth: 180 },
    { field: 'ppv_montoTotal', headerName: 'Monto total', width: 120, minWidth: 120, 
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
            return `S/(${formattedValue})`;
          }
          return `S/${formattedValue}`;
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
    { field: 'ppv_prioridad', headerName: 'Prioridad', width: 100, filter: true, minWidth: 100 },
    { field: 'ppv_proveedor', headerName: 'Proveedor', flex: 1, filter: true, minWidth: 180 },
    { 
      field: 'ppv_estado', 
      headerName: 'Estado', 
      headerClass: 'centrarencabezado',
      cellStyle: { justifyContent: 'center' },
      width: 110, 
      minWidth: 110,
      filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Programado') {
          return '<span class="badge-table bg-[#FFF4CC] text-[#F2A626]">Programado</span>';
        } else if (params.value === 'Pagado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagado</span>';
        } else if (params.value === 'Anulado') {
          return '<span class="badge-table bg-[#FFE5E5] text-[#D32F2F]">Anulado</span>';
        }
        return params.value;
      },
    },
  ];
  
  initialState: GridState = {};
  
  get tituloFormulario(): string {
    if (this.modoCreacion) {
      return 'Nuevo Pago Programado';
    }
    return `Información de la programación: ${this.filaSeleccionada?.ppv_codigo || ''}`;
  }
  
  get formularioDeshabilitado(): boolean {
    if (this.modoCreacion) return false;
    const estado = this.filaSeleccionada?.ppv_estado;
    return estado === 'Pagado' || estado === 'Anulado';
  }
  
  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController,
    private formValidationService: FormValidationService
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Effect reactivo: sincroniza el store con la tabla cuando llegan datos
    effect(() => {
      const pagos = this.programPagosFacade.pagos();
      this.rowData = pagos;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });
  }

  ngOnInit() {
    this.initForm();
    this.programPagosFacade.cargarPagos();
  }
  
  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }
  
  initForm() {
    const today = new Date();
    const todayString = today.toLocaleDateString('es-PE');
    
    this.pagoForm = this.formBuilder.group({
      razonSocial: ['Importadora Vinos del Sur EIRL', Validators.required],
      usuarioEjecutor: ['Eduardo Jimenez Lopez', Validators.required],
      fechaRegistro: [{ value: todayString, disabled: true }],
      prioridad: ['', Validators.required],
      proveedor: ['', Validators.required],
      tipoDoc: [{ value: '', disabled: true }, Validators.required],
      docAsociado: [{ value: '', disabled: true }],
      fechaVencimiento: [''],
      fechaPagoProg: ['', Validators.required],
      nDocumento: ['', Validators.required],
      montoTotal: ['', Validators.required],
      entidad: ['', Validators.required],
      ctaPago: ['', Validators.required],
      numeroPreAsiento: [''],
      numeroAsiento: [''],
      estado: [{ value: 'Programado', disabled: true }],
      observaciones: ['']
    });
    
    this.fechaRegistroSeleccionada = today;
    this.fechaPagoSeleccionada = today;
    this.mostrarDocAsociado = false;
    
    // Inicializar servicio de validación
    this.formValidationService.inicializarFormulario(this.pagoForm);
    
    // Suscribirse a cambios en proveedor para habilitar tipo de doc
    this.pagoForm.get('proveedor')?.valueChanges.subscribe(value => {
      if (value) {
        this.pagoForm.get('tipoDoc')?.enable();
      } else {
        this.pagoForm.get('tipoDoc')?.disable();
        this.pagoForm.get('tipoDoc')?.setValue('');
        this.mostrarDocAsociado = false;
      }
    });
    
    // Suscribirse a cambios en tipo de doc para mostrar campo de doc asociado
    this.pagoForm.get('tipoDoc')?.valueChanges.subscribe(value => {
      if (value) {
        this.mostrarDocAsociado = true;
        this.pagoForm.get('docAsociado')?.enable();
        this.pagoForm.get('docAsociado')?.setValidators([Validators.required]);
        this.pagoForm.get('docAsociado')?.updateValueAndValidity();
        // Simular documentos asociados según tipo
        this.cargarDocumentosAsociados(value);
      } else {
        this.mostrarDocAsociado = false;
        this.pagoForm.get('docAsociado')?.disable();
        this.pagoForm.get('docAsociado')?.clearValidators();
        this.pagoForm.get('docAsociado')?.setValue('');
        this.pagoForm.get('docAsociado')?.updateValueAndValidity();
      }
    });
    
    // Suscribirse a cambios en doc asociado para llenar campos automáticamente
    this.pagoForm.get('docAsociado')?.valueChanges.subscribe(value => {
      this.mostrarCamposDocumento = !!value;
      if (value) {
        this.cargarDatosDocumento(value);
      } else {
        // Limpiar campos si se deselecciona el documento
        this.pagoForm.patchValue({
          fechaVencimiento: '',
          montoTotal: '',
          ctaPago: ''
        });
      }
    });
  }

  entidadSeleccionada( entidad:any){
    this.pagoForm.patchValue({
      entidad: entidad.nombre
    });
  }
  
  limpiarFormulario() {
    const today = new Date();
    const todayString = today.toLocaleDateString('es-PE');
    
    this.pagoForm.patchValue({
      razonSocial: 'Importadora Vinos del Sur EIRL',
      usuarioEjecutor: 'Eduardo Jimenez Lopez',
      fechaRegistro: todayString,
      prioridad: '',
      proveedor: '',
      tipoDoc: '',
      nDocumento: '',
      montoTotal: '',
      ctaPago: '',
      numeroPreAsiento: '',
      estado: 'Programado',
      observaciones: ''
    });
    
    this.fechaPagoSeleccionada = undefined;
    
    // Habilitar todos los campos editables
    this.pagoForm.get('razonSocial')?.enable();
    this.pagoForm.get('usuarioEjecutor')?.enable();
    this.pagoForm.get('prioridad')?.enable();
    this.pagoForm.get('proveedor')?.enable();
    this.pagoForm.get('tipoDoc')?.enable();
    this.pagoForm.get('nDocumento')?.enable();
    this.pagoForm.get('montoTotal')?.enable();
    this.pagoForm.get('entidad')?.enable();
    this.pagoForm.get('ctaPago')?.enable();
    // this.pagoForm.get('estado')?.enable();
    this.pagoForm.get('observaciones')?.enable();
  }
  
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }
  
  onFirstDataRendered(params: any) {
    params.api.sizeColumnsToFit();
  }
  
  onBtReset() {
    this.programPagosFacade.cargarPagos();
  }
  
  filtrarPorFechas(event: any) {
    // Implementar filtro de fechas
  }
  
  onFechaPagoSelected(fecha: Date) {
    this.fechaPagoSeleccionada = fecha;
    this.pagoForm.patchValue({
      fechaPagoProg: this.formatearFecha(fecha)
    });
  }
  
  cargarDocumentosAsociados(tipoDoc: string) {
    // Simular carga de documentos según el tipo y proveedor
    const proveedor = this.pagoForm.get('proveedor')?.value;
    
    if (tipoDoc === 'Factura') {
      this.documentosAsociados = [
        { id: 'F001-00123', nombre: 'F001-00123' },
        { id: 'F001-00124', nombre: 'F001-00124' },
        { id: 'F001-00125', nombre: 'F001-00125' },
      ];
    } else if (tipoDoc === 'Letra') {
      this.documentosAsociados = [
        { id: 'L001-00123', nombre: 'L001-00123' },
        { id: 'L001-00124', nombre: 'L001-00124' },
      ];
    } else if (tipoDoc === 'Nota de débito') {
      this.documentosAsociados = [
        { id: 'ND-12345', nombre: 'ND-12345' },
        { id: 'ND-12346', nombre: 'ND-12346' },
      ];
    }
  }
  
  cargarDatosDocumento(docId: string) {
    // Simular carga de datos del documento seleccionado
    const datosDoc = {
      nDocumento: docId,
      fechaVencimiento: '15/02/2025',
      fechaPagoProg: '10/02/2025',
      montoTotal: 5000.00,
      ctaPago: 'BBVA-002 - Cuenta Operativa (..1205)'
    };
    
    // Llenar campos automáticamente
    this.pagoForm.patchValue({
      nDocumento: datosDoc.nDocumento,
      fechaVencimiento: datosDoc.fechaVencimiento,
      fechaPagoProg: datosDoc.fechaPagoProg,
      montoTotal: datosDoc.montoTotal,
      ctaPago: datosDoc.ctaPago
    });
    
    // Establecer fecha de pago programado
    this.fechaPagoSeleccionada = this.parseFecha(datosDoc.fechaPagoProg);
    this.fechaVencimientoDoc = this.parseFecha(datosDoc.fechaVencimiento);
  }
  
  async onCellClicked(event: any) {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló, mantener estado actual
    }
    
    this.modoCreacion = false;
    this.filaSeleccionada = event.data;
    
    // Cargar datos en el formulario
    this.pagoForm.patchValue({
      razonSocial: 'Importadora Vinos del Sur EIRL',
      usuarioEjecutor: 'Eduardo Jimenez Lopez',
      fechaRegistro: event.data.ppv_fechaRegistro,
      prioridad: event.data.ppv_prioridad,
      proveedor: event.data.ppv_proveedor,
      tipoDoc: event.data.ppv_tipoDoc,
      fechaVencimiento: event.data.fechaVencimiento || '',
      fechaPagoProg: event.data.ppv_fechaPagoProg || '',
      nDocumento: event.data.ppv_nDocumento,
      montoTotal: event.data.ppv_montoTotal,
      entidad: event.data.ppv_entidad || '',
      ctaPago: event.data.ppv_ctaPago,
      numeroPreAsiento: event.data.ppv_numeroPreAsiento || '',
      numeroAsiento: event.data.ppv_numeroAsiento || '',
      estado: event.data.ppv_estado,
      observaciones: event.data.ppv_observaciones
    });
    
    // Cargar fecha de pago
    this.fechaPagoSeleccionada = event.data.ppv_fechaPagoProg ? this.parseFecha(event.data.ppv_fechaPagoProg) : undefined;
    
    // Si está Pagado o Anulado, deshabilitar todo
    if (event.data.ppv_estado === 'Pagado' || event.data.ppv_estado === 'Anulado') {
      this.pagoForm.disable();
    } else if (event.data.ppv_estado === 'Programado') {
      // Si está Programado, deshabilitar todos los campos excepto estado y observaciones
      this.pagoForm.disable();
      this.pagoForm.get('estado')?.enable();
      this.pagoForm.get('observaciones')?.enable();
    } else {
      // Otro estado, habilitar formulario
      this.pagoForm.enable();
      this.pagoForm.get('fechaRegistro')?.disable();
    }
    
    // Resetear servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }
  
  async botonRegistrarPago() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló, mantener estado actual
    }
    
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.mostrarCamposDocumento = false;
    
    // Limpiar selección en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Limpiar formulario
    this.limpiarFormulario();
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }
  
  botonCancelar() {
    if (this.filaSeleccionada) {
      // Si había una fila seleccionada, volver a ella
      this.modoCreacion = false;
      this.onCellClicked({ data: this.filaSeleccionada });
    } else {
      // Si no había selección, limpiar formulario
      this.limpiarFormulario();
    }
  }
  
  botonRegistrar() {
    // Marcar todos los campos como touched para mostrar errores
    Object.keys(this.pagoForm.controls).forEach(key => {
      this.pagoForm.get(key)?.markAsTouched();
    });
    
    if (this.pagoForm.invalid || !this.fechaPagoSeleccionada) {
      console.log('Formulario inválido:', this.pagoForm);
      console.log('Errores:', this.getFormErrors());
      this.toastService.danger('Por favor, complete todos los campos requeridos.');
      return;
    }
    
    // Generar código único
    const codigo = `PG-2025-${String(5 + this.rowData.length).padStart(3, '0')}`;
    
    // Crear nuevo registro
    const nuevoRegistro: ProgramPagosPorVencEntity = {
      ppv_codigo: codigo,
      ppv_fechaRegistro: this.pagoForm.get('fechaRegistro')?.value,
      ppv_fechaPagoProg: this.formatearFecha(this.fechaPagoSeleccionada),
      ppv_prioridad: this.pagoForm.get('prioridad')?.value,
      ppv_proveedor: this.pagoForm.get('proveedor')?.value,
      ppv_tipoDoc: this.pagoForm.get('tipoDoc')?.value,
      ppv_nDocumento: this.pagoForm.get('nDocumento')?.value,
      ppv_montoTotal: this.pagoForm.get('montoTotal')?.value,
      ppv_entidad: this.pagoForm.get('entidad')?.value || '',
      ppv_ctaPago: this.pagoForm.get('ctaPago')?.value,
      ppv_numeroPreAsiento: this.pagoForm.get('numeroPreAsiento')?.value || '',
      ppv_estado: 'Programado',
      ppv_observaciones: this.pagoForm.get('observaciones')?.value || ''
    };
    
    // Agregar a la tabla al inicio
    this.rowData = [nuevoRegistro, ...this.rowData];
    
    // Actualizar la grid
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
      this.gridApi.deselectAll();
    }
    
    this.toastService.success('¡Pago programado registrado exitosamente!');
    
    // Limpiar formulario y ponerlo en modo creación
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.limpiarFormulario();
    
    // Resetear servicio de validación después de guardar
    this.formValidationService.resetearEstado();
  }
    async verAsientoContable() {
      if (!this.filaSeleccionada || !this.filaSeleccionada.ppv_numeroPreAsiento) {
        this.toastService.danger('No hay asiento contable disponible.');
        return;
      }
  
      const colDefs: ColDef[] = [
        { field: 'cuentaContable', headerName: 'Cuenta Contable', width: 120 },
        { field: 'descripcion', headerName: 'Descripción', flex: 1 },
        { field: 'debe', headerName: 'Debe (S/)', width: 100, headerClass: 'centrarencabezado', cellStyle: { textAlign: 'right' } },
        { field: 'haber', headerName: 'Haber (S/)', width: 100, headerClass: 'centrarencabezado', cellStyle: { textAlign: 'right' } },
      ];
      
      const rowData = [
        { cuentaContable: '421101', descripcion: 'Proveedores nacionales', debe: '-', haber: '5,500.00' },
        { cuentaContable: '101101', descripcion: 'Caja y Bancos â€“ Interbank', debe: '5,500.00', haber: '-' },
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
          tituloModal: `Información del asiento contable ${this.filaSeleccionada.ppv_numeroPreAsiento}`,
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
  
  async botonAnular() {
    if (!this.filaSeleccionada) {
      this.toastService.danger('No hay pago seleccionado.');
      return;
    }

    const detallesEjemplo = [
      { label: 'F. pago program.', value: '05/11/2025' },
      { label: 'Prioridad', value: this.filaSeleccionada.ppv_estado },
      { label: 'Proveedor', value: this.filaSeleccionada.ppv_proveedor },
      { label: 'N° doc.', value: this.filaSeleccionada.ppv_nDocumento },
      { label: 'Monto total', value: this.filaSeleccionada.ppv_montoTotal },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Anular pago programado',
        subtitulomodal: 'Detalle de anulación',
        detalles: detallesEjemplo,
        tituloTextarea: 'Motivo de anulación',
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Anular',
        colorBotonConfirmar: 'danger'
      }
    });

    await modal.present();
    
    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      // Validar que el motivo no esté vacío
      if (!data.motivo || data.motivo.trim() === '') {
        this.toastService.danger('Debe ingresar un motivo de anulación.');
        this.botonAnular();
        return;
      }

      // Actualizar el estado en rowData
      const index = this.rowData.findIndex(row => 
        row.ppv_codigo === this.filaSeleccionada.ppv_codigo
      );

      if (index !== -1) {
        this.rowData[index].ppv_estado = 'Anulado';
        this.rowData[index].ppv_observaciones = data.motivo;
        
        // Actualizar la fila seleccionada
        this.filaSeleccionada = { ...this.rowData[index] };

        // Refrescar la tabla para que se vea el cambio de estado
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', [...this.rowData]);
          
          // Reseleccionar la fila después de actualizar
          setTimeout(() => {
            const updatedNode = this.gridApi.getRowNode(index.toString());
            if (updatedNode) {
              updatedNode.setSelected(true);
            }
          }, 100);
        }

        // Recargar el formulario con el nuevo estado
        this.onCellClicked({ data: this.filaSeleccionada });

        this.toastService.success('¡La acción se realizó con éxito!');
      }
    }
  }
  
  botonGuardar() {
    if (this.pagoForm.invalid) {
      this.toastService.danger('Por favor, complete todos los campos requeridos.');
      return;
    }
    
    // Actualizar datos en rowData
    const index = this.rowData.findIndex(row => row.ppv_codigo === this.filaSeleccionada.ppv_codigo);
    
    if (index !== -1) {
      this.rowData[index] = {
        ...this.rowData[index],
        ppv_fechaPagoProg: this.fechaPagoSeleccionada ? this.formatearFecha(this.fechaPagoSeleccionada) : this.rowData[index].ppv_fechaPagoProg,
        ppv_prioridad: this.pagoForm.get('prioridad')?.value,
        ppv_proveedor: this.pagoForm.get('proveedor')?.value,
        ppv_tipoDoc: this.pagoForm.get('tipoDoc')?.value,
        ppv_nDocumento: this.pagoForm.get('nDocumento')?.value,
        ppv_montoTotal: this.pagoForm.get('montoTotal')?.value,
        ppv_ctaPago: this.pagoForm.get('ctaPago')?.value,
        ppv_numeroPreAsiento: this.pagoForm.get('numeroPreAsiento')?.value,
        ppv_estado: this.pagoForm.get('estado')?.value as 'Programado' | 'Pagado' | 'Anulado',
        ppv_observaciones: this.pagoForm.get('observaciones')?.value
      };
      
      // Actualizar grid
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.gridApi.deselectAll();
      }
      
      this.toastService.success('¡Cambios guardados exitosamente!');
      
      // Limpiar formulario y ponerlo en modo creación
      this.modoCreacion = true;
      this.filaSeleccionada = null;
      this.limpiarFormulario();
      
      // Resetear servicio de validación
      this.formValidationService.resetearEstado();
    }
  }
  
  async modalverActualizaciones() {
    if (!this.filaSeleccionada) {
      this.toastService.danger('Seleccione un pago programado.');
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
      { fechaHora: '05/01/2025 10:30', usuario: 'Eduardo Jimenez', accion: 'Creación', detalleCambio: 'Se programó el pago' },
      { fechaHora: '06/01/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se modificó la prioridad a Alta' },
    ];
    
    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones del pago ${this.filaSeleccionada.ppv_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });
    
    await modal.present();
  }
  
  getFormErrors(): any {
    const errors: any = {};
    Object.keys(this.pagoForm.controls).forEach(key => {
      const control = this.pagoForm.get(key);
      if (control && control.errors) {
        errors[key] = {
          value: control.value,
          errors: control.errors,
          disabled: control.disabled
        };
      }
    });
    return errors;
  }
  
  formatearFecha(fecha: Date): string {
    return fecha.toLocaleDateString('es-PE');
  }
  
  parseFecha(fechaString: string): Date | undefined {
    // Parsear formato DD/MM/YYYY
    const partes = fechaString.split('/');
    if (partes.length === 3) {
      const dia = parseInt(partes[0], 10);
      const mes = parseInt(partes[1], 10) - 1;
      const anio = parseInt(partes[2], 10);
      return new Date(anio, mes, dia);
    }
    return undefined;
  }
}

