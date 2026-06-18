import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef, GridState } from 'ag-grid-community';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { AnulacionPagosEntity } from 'src/app/modules/finanzas/domain/models/anulacion-pagos.entity';
import { AnulacionPagosFacade } from 'src/app/modules/finanzas/application/facades/anulacion-pagos.facade';
import { AnulacionPagosFeedbackEffects } from 'src/app/modules/finanzas/effects/anulacion-pagos-feedback.effect';

// Font Awesome Icons
import { faBook, faEye, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-f-t-anulacion-o-reversion-pagos',
  templateUrl: './f-t-anulacion-o-reversion-pagos.component.html',
  styleUrls: ['./f-t-anulacion-o-reversion-pagos.component.scss'],
  standalone: false,
})
export class FTAnulacionOReversionPagosComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farBook = faBook;
  farEye = faEye;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  // Facade e Effects (arquitectura limpia)
  private readonly anulacionPagosFacade = inject(AnulacionPagosFacade);
  private readonly feedbackEffects = inject(AnulacionPagosFeedbackEffects);

  // Selectores reactivos del store
  readonly isLoading = this.anulacionPagosFacade.isLoading;

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  
  private gridApi!: GridApi;
  filaSeleccionada: any = null;
  modoCreacion: boolean = true;
  anulacionForm!: FormGroup;
  fechaPagoSeleccionada: Date | undefined;
  
  tiposDocumento = [
    { id: 'Factura', nombre: 'Factura' },
    { id: 'Boleta', nombre: 'Boleta' },
    { id: 'Nota de débito', nombre: 'Nota de débito' },
  ];
  
  proveedores = [
    { id: 1, nombre: 'Carnes del Sur S.A.C.' },
    { id: 2, nombre: 'Distribuidora Gourmet Perú S.A.C.' },
    { id: 3, nombre: 'La Cooperativa del Café S.A.C.' },
    { id: 4, nombre: 'Pescados del Mar S.A.C.' },
  ];
  
  sucursales = [
    { id: 1, nombre: 'CC Real Plaza, Piura' },
    { id: 2, nombre: 'Santa Isabel, Piura' },
    { id: 3, nombre: 'San Juan de Lurigancho, Lima' },
    { id: 4, nombre: 'Villa el Salvador, Lima' },
  ];
  
  documentosAsociados = [
    { 
      id: 'F001-4587', 
      nombre: 'F001-4587',
      fechaPago: '20/02/2025',
      moneda: 'Soles ',
      montoPagado: 'S/ 13,000.00',
      medioPago: 'Transferencia',
      sucursal: 'CC Real Plaza, Piura'
    },
    { 
      id: 'B001-2345', 
      nombre: 'B001-2345',
      fechaPago: '15/02/2025',
      moneda: 'Dólares ($)',
      montoPagado: '$ 3,500.00',
      medioPago: 'Cheque',
      sucursal: 'Santa Isabel, Piura'
    },
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
  
  rowData: AnulacionPagosEntity[] = [];
  
  colDefs: ColDef[] = [
    { field: 'arp_proveedor', headerName: 'Proveedor', width: 180, filter: true, minWidth: 150 },
    { field: 'arp_tipoDoc', headerName: 'Tipo de comprobante', width: 140, filter: true, minWidth: 120 },
    { field: 'arp_serieNumDoc', headerName: 'Serie/N° comprobante', width: 170, minWidth: 150 },
    { field: 'arp_fechaPago', headerName: 'Fecha de pago', width: 180, minWidth: 150 },
    { field: 'arp_moneda', headerName: 'Moneda', width: 150, filter: true, minWidth: 120 },
    { field: 'arp_sucursal', headerName: 'Sucursal', width: 150, filter: true,  minWidth: 120 },
    { field: 'arp_montoPagado', headerName: 'Monto pagado', width: 170, minWidth: 150,
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
    { field: 'arp_medioPago', headerName: 'Medio pago', width: 170, filter: true, minWidth: 150 },
    { field: 'arp_accionRealizada', headerName: 'Fecha de proceso', width: 150, minWidth: 120 },
    { 
      field: 'arp_estado', 
      headerName: 'Estado', 
      width: 100, 
      minWidth: 100,
      headerClass: 'centrarencabezado',
      filter: true,
      cellStyle: () => {
        const style: any = { justifyContent: 'center', };
        return style;
      },
      cellRenderer: (params: any) => {
        if (params.value === 'Anulado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulado</span>';
        }
        if (params.value === 'Revertido') {
          return '<span class="badge-table bg-[#FFDECC] text-[#FF8947]">Revertido</span>';
        }
        return params.value;
      },
    },
  ];
  
  initialState: GridState = {};
  
  get tituloFormulario(): string {
    if (this.modoCreacion) {
      return 'Nuevo proceso';
    }
    return `Información de doc.: ${this.filaSeleccionada?.arp_serieNumDoc || ''}`;
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
      const registros = this.anulacionPagosFacade.registros();
      this.rowData = registros;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });
  }

  ngOnInit() {
    this.initForm();
    this.anulacionPagosFacade.cargarRegistros();
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }
  
  initForm() {
    const today = new Date();
    const todayString = today.toLocaleDateString('es-PE');
    
    this.anulacionForm = this.formBuilder.group({
      razonSocial: ['Importadora Vinos del Sur EIRL', Validators.required],
      usuarioEjecutor: ['Eduardo Jimenez Lopez', Validators.required],
      fechaRegistro: [{ value: todayString, disabled: true }],
      proveedor: ['', Validators.required],
      tipoDoc: [{ value: '', disabled: true }, Validators.required],
      docAsociado: [{ value: '', disabled: true }, Validators.required],
      serieNumDoc: ['', Validators.required],
      sucursal: ['', Validators.required],
      fechaPago: [{ value: '', disabled: true }],
      moneda: [{ value: '', disabled: true }, Validators.required],
      montoPagado: [{ value: '', disabled: true }, Validators.required],
      medioPago: [{ value: '', disabled: true }, Validators.required],
      accionRealizada: [{ value: '', disabled: true }, Validators.required],
      numeroAsiento: [''],
      justificacion: ['']
    });
    
    this.fechaPagoSeleccionada = undefined;
    
    // Configurar listeners para habilitar campos progresivamente
    this.configurarListeners();
    
    // Inicializar servicio de validación
    this.formValidationService.inicializarFormulario(this.anulacionForm);
  }
  
  limpiarFormulario() {
    const today = new Date();
    const todayString = today.toLocaleDateString('es-PE');
    
    this.anulacionForm.patchValue({
      razonSocial: 'Importadora Vinos del Sur EIRL',
      usuarioEjecutor: 'Eduardo Jimenez Lopez',
      fechaRegistro: todayString,
      proveedor: '',
      tipoDoc: '',
      docAsociado: '',
      serieNumDoc: '',
      sucursal: '',
      fechaPago: '',
      moneda: '',
      montoPagado: '',
      medioPago: '',
      accionRealizada: '',
      numeroAsiento: '',
      justificacion: ''
    });
    
    // Habilitar solo proveedor al inicio
    this.anulacionForm.get('proveedor')?.enable();
    
    // Deshabilitar el resto de campos
    this.anulacionForm.get('tipoDoc')?.disable();
    this.anulacionForm.get('docAsociado')?.disable();
    this.anulacionForm.get('accionRealizada')?.disable();
    
    this.fechaPagoSeleccionada = undefined;
  }
  
  configurarListeners() {
    // Cuando se selecciona proveedor, habilitar tipo de doc
    this.anulacionForm.get('proveedor')?.valueChanges.subscribe(value => {
      if (value && this.modoCreacion) {
        this.anulacionForm.get('tipoDoc')?.enable();
      } else if (this.modoCreacion) {
        this.anulacionForm.get('tipoDoc')?.disable();
        this.anulacionForm.get('tipoDoc')?.setValue('');
        this.anulacionForm.get('docAsociado')?.disable();
        this.anulacionForm.get('docAsociado')?.setValue('');
      }
    });
    
    // Cuando se selecciona tipo de doc, habilitar doc asociado
    this.anulacionForm.get('tipoDoc')?.valueChanges.subscribe(value => {
      if (value && this.modoCreacion) {
        this.anulacionForm.get('docAsociado')?.enable();
      } else if (this.modoCreacion) {
        this.anulacionForm.get('docAsociado')?.disable();
        this.anulacionForm.get('docAsociado')?.setValue('');
      }
    });
    
    // Cuando se selecciona doc asociado, cargar datos y habilitar acción
    this.anulacionForm.get('docAsociado')?.valueChanges.subscribe(value => {
      if (value && this.modoCreacion) {
        this.cargarDatosDocumento(value);
        this.anulacionForm.get('accionRealizada')?.enable();
      } else if (this.modoCreacion) {
        this.anulacionForm.get('accionRealizada')?.disable();
        this.anulacionForm.get('accionRealizada')?.setValue('');
      }
    });
    
    // Cuando se selecciona la acción, generar número de asiento si es Reversión
    this.anulacionForm.get('accionRealizada')?.valueChanges.subscribe(value => {
      if (value === 'Reversión' && this.modoCreacion) {
        // Generar número de asiento contable automáticamente
        const numeroAsiento = `ASC-2025-${String(Math.floor(Math.random() * 900000) + 100000)}`;
        this.anulacionForm.patchValue({
          numeroAsiento: numeroAsiento
        });
      } else if (this.modoCreacion) {
        // Limpiar el número de asiento si no es Reversión
        this.anulacionForm.patchValue({
          numeroAsiento: ''
        });
      }
    });
  }
  
  cargarDatosDocumento(docId: string) {
    // Buscar el documento en el array
    const doc = this.documentosAsociados.find(d => d.id === docId);
    
    if (doc) {
      // Cargar datos en campos disabled
      this.anulacionForm.patchValue({
        fechaPago: doc.fechaPago,
        moneda: doc.moneda,
        montoPagado: doc.montoPagado,
        medioPago: doc.medioPago,
        sucursal: doc.sucursal,
        serieNumDoc: doc.nombre
      });
      
      // Parsear fecha para el calendario
      this.fechaPagoSeleccionada = this.parseFecha(doc.fechaPago);
    }
  }
  
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }
  
  onFirstDataRendered(params: any) {
    params.api.sizeColumnsToFit();
  }
  
  onBtReset() {
    this.anulacionPagosFacade.cargarRegistros();
  }
  
  filtrarPorFechas(event: any) {
    // Implementar filtro de fechas
  }
  
  onFechaPagoSelected(fecha: Date) {
    this.fechaPagoSeleccionada = fecha;
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
    this.anulacionForm.patchValue({
      razonSocial: 'Importadora Vinos del Sur EIRL',
      usuarioEjecutor: 'Eduardo Jimenez Lopez',
      fechaRegistro: '01/11/2025',
      proveedor: event.data.arp_proveedor,
      tipoDoc: event.data.arp_tipoDoc,
      docAsociado: event.data.arp_serieNumDoc,
      serieNumDoc: event.data.arp_serieNumDoc,
      sucursal: event.data.arp_sucursal,
      fechaPago: event.data.arp_fechaPago,
      moneda: event.data.arp_moneda,
      montoPagado: event.data.arp_montoPagado,
      medioPago: event.data.arp_medioPago,
      accionRealizada: event.data.arp_accionRealizada,
      numeroAsiento: event.data.arp_numeroAsiento,
      justificacion: event.data.arp_justificacion
    });
    
    // Cargar fecha de pago
    this.fechaPagoSeleccionada = event.data.arp_fechaPago ? this.parseFecha(event.data.arp_fechaPago) : undefined;
    
    // Deshabilitar todo el formulario en modo visualización
    this.anulacionForm.disable();
    
    // Resetear servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }
  
  async botonAnularNuevoDoc() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló, mantener estado actual
    }
    
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    
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
      
      // Reseleccionar la fila en la tabla
      if (this.gridApi) {
        const rowIndex = this.rowData.findIndex(row => 
          row.arp_serieNumDoc === this.filaSeleccionada.arp_serieNumDoc && 
          row.arp_tipoDoc === this.filaSeleccionada.arp_tipoDoc
        );
        if (rowIndex !== -1) {
          setTimeout(() => {
            const node = this.gridApi.getRowNode(rowIndex.toString());
            if (node) {
              node.setSelected(true);
            }
          }, 100);
        }
      }
    } else {
      // Si no había selección, limpiar formulario
      this.limpiarFormulario();
    }
  }
  
  async botonAnular() {
    if (this.anulacionForm.invalid) {
      this.toastService.danger('Por favor, complete todos los campos requeridos.');
      return;
    }
    
    // Obtener la acción realizada
    const accionRealizada = this.anulacionForm.get('accionRealizada')?.value;
    const esReversion = accionRealizada === 'Reversión';
    
    // Preparar los detalles para el modal según el tipo de acción
    const detalles = [
      { label: 'Serie/N° doc.', value: this.anulacionForm.get('serieNumDoc')?.value },
      { label: 'Monto pagado', value: this.anulacionForm.get('montoPagado')?.value },
      { label: 'Fecha de pago', value: this.fechaPagoSeleccionada ? this.formatearFecha(this.fechaPagoSeleccionada) : '' },
      { label: 'Medio de pago', value: this.anulacionForm.get('medioPago')?.value }
    ];
    
    // Solo agregar asiento contable si es reversión
    if (esReversion) {
      detalles.push({ label: 'Asiento contable', value: this.anulacionForm.get('numeroAsiento')?.value || 'ASC-2025-000148' });
    }
    
    // Abrir modal de confirmación
    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: esReversion ? 'Revertir pago' : 'Anular pago',
        subtitulomodal: esReversion ? 'Detalle de reversión:' : 'Detalle de anulación:',
        detalles:  detalles,
        tituloTextarea: esReversion ? 'Motivo de reversión' : 'Motivo de anulación',
        mostrarTextarea: true,
        isdoblecolumna: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: esReversion ? 'Revertir' : 'Anular',
        colorBotonConfirmar: esReversion ? 'warning' : 'danger'
      }
    });
    
    await modal.present();
    
    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      // Validar que el motivo no esté vacío
      if (!data.motivo || data.motivo.trim() === '') {
        this.toastService.danger(`Debe ingresar un motivo de ${esReversion ? 'reversión' : 'anulación'}.`);
        // Volver a abrir el modal
        this.botonAnular();
        return;
      }
      
      // Generar número de asiento único
      const numeroAsiento = `ASC-2025-${String(152 + this.rowData.length).padStart(6, '0')}`;
      
      // Crear nuevo registro
      const nuevoRegistro: AnulacionPagosEntity = {
        arp_proveedor: this.anulacionForm.get('proveedor')?.value,
        arp_tipoDoc: this.anulacionForm.get('tipoDoc')?.value,
        arp_serieNumDoc: this.anulacionForm.get('serieNumDoc')?.value,
        arp_fechaPago: this.fechaPagoSeleccionada ? this.formatearFecha(this.fechaPagoSeleccionada) : '',
        arp_moneda: this.anulacionForm.get('moneda')?.value,
        arp_sucursal: this.anulacionForm.get('sucursal')?.value,
        arp_montoPagado: this.anulacionForm.get('montoPagado')?.value,
        arp_medioPago: this.anulacionForm.get('medioPago')?.value,
        arp_accionRealizada: accionRealizada,
        arp_estado: esReversion ? 'Revertido' : 'Anulado',
        arp_numeroAsiento: numeroAsiento,
        arp_justificacion: data.motivo
      };
      
      // Agregar a la tabla al inicio
      this.rowData = [nuevoRegistro, ...this.rowData];
      
      // Actualizar la grid
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
        
        // Seleccionar la nueva fila después de un pequeño delay
        setTimeout(() => {
          const node = this.gridApi.getRowNode('0');
          if (node) {
            node.setSelected(true);
          }
        }, 100);
      }
      
      this.toastService.success(`¡La acción se realizó con éxito!`);
      
      // Cambiar a modo visualización
      this.modoCreacion = false;
      this.filaSeleccionada = nuevoRegistro;
      
      // Actualizar formulario con el número de asiento y la justificación
      this.anulacionForm.patchValue({
        numeroAsiento: numeroAsiento,
        justificacion: data.motivo
      });
      
      // Deshabilitar todo el formulario
      this.anulacionForm.disable();
      
      // Resetear servicio de validación después de guardar
      this.formValidationService.resetearEstado();
    }
  }
  
  async verAsientoContable() {
    if (!this.filaSeleccionada?.arp_numeroAsiento) {
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
        tituloModal: `Información del asiento contable ${this.filaSeleccionada.arp_numeroAsiento}`,
        subtitulomodal: 'Detalle del asiento',
        detalles: detalles,
        mostrarTabla: true,
        colDefs: colDefs,
        rowData: rowData,
        isdoblecolumna: true,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        textoBotonCancelar: 'Cerrar',
      }
    });
    
    await modal.present();
  }
  
  formatearFecha(fecha: Date): string {
    return fecha.toLocaleDateString('es-PE');
  }
  
  parseFecha(fechaString: string): Date | undefined {
    // Parsear formato DD/MM/YYYY
    const partes = fechaString.split('/');
    if (partes.length === 3) {
      const dia = parseInt(partes[0], 10);
      const mes = parseInt(partes[1], 10) - 1; // Meses en JS van de 0-11
      const anio = parseInt(partes[2], 10);
      return new Date(anio, mes, dia);
    }
    return undefined;
  }
  
  async modalverActualizaciones() {
    if (!this.filaSeleccionada) {
      this.toastService.danger('Seleccione un documento.');
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
      { fechaHora: '12/12/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Se registró el pago/anticipo' },
      { fechaHora: '13/12/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se modificó el estado a Aplicado' },
    ];
    
    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones del documento ${this.filaSeleccionada.arp_serieNumDoc}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });
    
    await modal.present();
  }
}

