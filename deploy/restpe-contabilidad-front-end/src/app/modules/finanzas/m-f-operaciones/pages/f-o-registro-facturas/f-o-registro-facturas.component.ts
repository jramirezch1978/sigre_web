import { Component, OnInit, OnDestroy, inject, Signal, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { CountryService } from 'src/app/ui/services/countryservice.service';

import { RegistroFacturaFacade } from 'src/app/modules/finanzas/application/facades/registro-factura.facade';
import { RegistroFacturaFeedbackEffects } from 'src/app/modules/finanzas/effects/registro-factura-feedback.effect';
import { RegistroFacturaSyncEffects } from 'src/app/modules/finanzas/effects/registro-factura-sync.effect';
import { RegistroFacturaEntity } from 'src/app/modules/finanzas/domain/models/registro-factura.entity';

// Font Awesome Icons
import { faBook, faCircleXmark, faSearch as faSearchRegular } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight, faSearch as faSearchSolid } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-f-o-registro-facturas',
  templateUrl: './f-o-registro-facturas.component.html',
  styleUrls: ['./f-o-registro-facturas.component.scss'],
  standalone: false,
})
export class FORegistroFacturasComponent implements OnInit, OnDestroy {
  // ── Arquitectura limpia ───────────────────────────────────────────────────
  readonly facturasFacade = inject(RegistroFacturaFacade);
  private readonly _feedbackEffects = inject(RegistroFacturaFeedbackEffects);
  private readonly _syncEffects = inject(RegistroFacturaSyncEffects);
  readonly isLoading: Signal<boolean> = this.facturasFacade.isLoading;

  // Font Awesome Icons
  farBook = faBook;
  farCircleXmark = faCircleXmark;
  farSearch = faSearchRegular;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasSearch = faSearchSolid;
  fasRotateRight = faRotateRight;


  facturaForm!: FormGroup;
  filaSeleccionada: any = null;
  startDate: Date = new Date();
  endDate: Date = new Date();
  minDate: Date = new Date(new Date().getFullYear() - 1, 0, 1);
  maxDate: Date = new Date();
  documentos: Array<{ nombre: string }> = [];
  maxDocumentos: number = 5;
  documentoSoporte: string = '';
  private gridApi!: GridApi;
  botonesHabilitados: boolean = true;
  documentoIdentidad: File | null = null;
  countries = ALL_COUNTRIES;
  tiposDocumentoCliente: any[]= [];

  tiposDocumento = [
    { value: 'factura', label: 'Factura' },
    { value: 'notaDebito', label: 'Nota de débito' },
    { value: 'notaCredito', label: 'Nota de crédito' },
    { value: 'reciboPago', label: 'Recibo de pago' },
    { value: 'reciboHonorarios', label: 'Recibo por honorarios' }
  ];

  monedas = [
    { value: 'soles', label: 'Soles' },
    { value: 'dolares', label: 'Dólares' }
  ];

  mediosCobro = [
    { value: 'transferencia', label: 'Transferencia bancaria' },
    { value: 'efectivo', label: 'Pago en efectivo' },
    { value: 'cheque', label: 'Cheque' },
    { value: 'debito', label: 'Tarjeta de débito' },
    { value: 'credito', label: 'Tarjeta de crédito' }
  ];

  sucursales = [
    { id: '1', nombre: 'San Juan de lurigancho, Lima' },
    { id: '2', nombre: 'Santa Isabel, Piura' },
    { id: '3', nombre: 'Miraflores, Lima' },
    { id: '4', nombre: 'San Isidro, Lima' },
  ];

  sucursalSeleccionada: string = '';
  centrosCostos = [
    { codigo: 'AC01', nombre: 'AC01 - Administración', porcentaje: '10%' },
    { codigo: 'AC02', nombre: 'AC02 - Ventas', porcentaje: '10%' },
    { codigo: 'AC03', nombre: 'AC03 - Producción', porcentaje: '10%' },
    { codigo: 'AC04', nombre: 'AC04 - Logística', porcentaje: '10%' },
    { codigo: 'AC05', nombre: 'AC05 - Finanzas', porcentaje: '10%' }
  ];
  cuentaContable = [
    { codigo: 'AC01', nombre: 'Ingresos por alquileres', porcentaje: '10%' },
    { codigo: 'AC02', nombre: 'Ingresos financieros', porcentaje: '10%' },
    { codigo: 'AC03', nombre: 'Otros ingresos operativos', porcentaje: '10%' },
  ];
  clientesEjemplo = [
    { dni: '12345678', ruc: '20123456789', nombre: 'Juan Pérez García' },
    { dni: '87654321', ruc: '20987654321', nombre: 'María López Rodríguez' },
    { dni: '74581632', ruc: '20745816320', nombre: 'Pruebas S.A.C' },
    { dni: '65432109', ruc: '20654321090', nombre: 'Servicios Generales S.A.C' },
  ];
  colDefsFacturas: ColDef[] = [
    { field: 'factura_tipo_doc', headerName: 'Tipo documento', flex: 1, minWidth: 100, filter: true },
    { field: 'factura_nro_documento', headerName: 'N° documento', flex: 2, minWidth: 150 },
    { field: 'factura_cliente', headerName: 'Cliente', flex: 1, minWidth: 120, filter: true },
    { field: 'factura_sucursal', headerName: 'Sucursal', flex: 1, minWidth: 150, filter: true },
    {
      field: 'factura_fecha_emision', headerName: 'Fecha emisión', flex: 1, minWidth: 120,
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
      field: 'factura_fecha_vencimiento', headerName: 'Fecha vencimiento', flex: 1, minWidth: 120,
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
      field: 'factura_monto', headerName: 'Monto Total', headerClass: 'derechaencabezado', flex: 1, minWidth: 120,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
    },
    { field: 'factura_moneda', headerName: 'Moneda', flex: 1, minWidth: 120, filter: true },
    {
      field: 'factura_asiento', headerName: 'Asiento', flex: 1, minWidth: 120,
      cellRenderer: VistaCellRenderComponent,
    },
    {
      field: 'factura_estado', headerName: 'Estado', headerClass: 'centrarencabezado', flex: 1, minWidth: 120, filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-[#363636]">Pendiente</span>';
        } else if (params.value === 'Pagado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagado</span>';
        } else if (params.value === 'Anulado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulado</span>';
        }
        return params.value;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    }
  ]
  rowDataFacturas: RegistroFacturaEntity[] = [];

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

  constructor(
    private modalController: ModalController,
    private fb: FormBuilder,
    private toastservice: ToastService,
    private countryService: CountryService,
    private formValidationService: FormValidationService,
  ) {
    this.docpais();
    this.initForm();

    // Sincronizar rowDataFacturas y grid cuando cambie el store
    effect(() => {
      const facturas = this.facturasFacade.facturas();
      this.rowDataFacturas = facturas;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', facturas);
      }
    });
  }

  ngOnInit() {
    this.facturasFacade.cargarFacturas();
    this.formValidationService.inicializarFormulario(this.facturaForm);
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }
  docpais(){
   const country = this.countries.find(
    c => c.codigo === this.countryService.getCountryCode()
    );
    this.countries.find(c => {
      if(c.codigo === country?.codigo){
        c.personalidadfiscal?.find(tip => {
          this.tiposDocumentoCliente.push({value: tip.value, label: tip.nombre , numero: tip.numero})
        })
      }
    })    
  }
  initForm() {
    this.facturaForm = this.fb.group({
      tipoDocumentoCliente: [this.tiposDocumentoCliente[0]?.value, Validators.required],
      numeroDocumentoCliente: ['', Validators.required],
      cliente: [''],
      sucursal: [''],
      tipoDocumento: ['', Validators.required],
      serie: ['', Validators.required],
      numero: ['', Validators.required],
      fechaEmision: ['', Validators.required],
      fechaVencimiento: ['', Validators.required],
      descripcionServicio: [''],
      montoTotal: ['', Validators.required],
      moneda: ['', Validators.required],
      tipoCambio: [''],
      centroCosto: [''],
      cuentaContableIngreso: [''],
      medioCobro: [''],
      estado: [{ value: 'Pendiente', disabled: true }],
      observaciones: ['']
    });
  }
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;

  }

  async onCellClicked(event: any) {
    const data = event.data;

    // Evitar validación si se hace clic en la misma fila ya seleccionada
    if (this.filaSeleccionada && this.filaSeleccionada.factura_nro_documento === data.factura_nro_documento) {
      return;
    }

    // Capturar foco actual antes de abrir el modal
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Restaurar selección anterior
      setTimeout(() => {
        this.gridApi.deselectAll();
        if (this.filaSeleccionada) {
          this.gridApi.forEachNode((node) => {
            if (node.data.factura_nro_documento === this.filaSeleccionada.factura_nro_documento) {
              node.setSelected(true);
            }
          });
        }
        // Restaurar foco al campo que estaba activo
        if (elementoConFoco && elementoConFoco.tagName === 'INPUT') {
          setTimeout(() => elementoConFoco.focus(), 100);
        }
      }, 0);
      return;
    }

    console.log('Fila seleccionada:', data);
    this.filaSeleccionada = data;

    // Deseleccionar todas las filas primero y luego seleccionar la clickeada
    this.gridApi.deselectAll();
    event.node.setSelected(true);

    // Autocompletar el formulario con los datos de la fila seleccionada
    this.autocompletarFormulario(data);

    // Habilitar botones cuando se selecciona una fila en estado Pendiente
    this.botonesHabilitados = data.factura_estado === 'Pendiente';

    // Deshabilitar los controles si el estado es Anulado
    if (data.factura_estado === 'Anulado') {
      this.disableFormControls();
    } else {
      this.enableFormControls();
    }
  }

  autocompletarFormulario(data: any) {
    // Separar serie y número del campo combinado (ej: "F001-00001234" → serie="F001", numero="00001234")
    const partes = (data.factura_nro_documento || '').split('-');
    const serie = partes[0] || '';
    const numero = partes.slice(1).join('-') || '';

    // Mapear tipo de documento (JSON guarda el label, el select usa el value)
    const tipoDocMapping: { [key: string]: string } = {
      'factura': 'factura',
      'boleta': 'boleta',
      'nota de débito': 'notaDebito',
      'nota de crédito': 'notaCredito',
      'recibo de pago': 'reciboPago',
      'recibo por honorarios': 'reciboHonorarios',
    };
    const tipoDocValue = tipoDocMapping[(data.factura_tipo_doc || '').toLowerCase()] || (data.factura_tipo_doc || '').toLowerCase();

    // Mapear moneda (JSON guarda "Dólares" con acento, el select usa "dolares" sin acento)
    const monedaMapping: { [key: string]: string } = {
      'soles': 'soles',
      'dólares': 'dolares',
      'dolares': 'dolares',
    };
    const monedaValue = monedaMapping[(data.factura_moneda || '').toLowerCase()] || (data.factura_moneda || '').toLowerCase();

    // Llenar el formulario con los datos de la fila
    this.facturaForm.patchValue({
      tipoDocumentoCliente: data.factura_tipo_doc_cliente || 'dni',
      numeroDocumentoCliente: data.factura_dni,
      cliente: data.factura_cliente,
      sucursal: data.factura_sucursal || '',
      tipoDocumento: tipoDocValue,
      serie: serie,
      numero: numero,
      fechaEmision: data.factura_fecha_emision,
      fechaVencimiento: data.factura_fecha_vencimiento,
      descripcionServicio: data.factura_descripcion_servicio || '',
      montoTotal: data.factura_monto,
      moneda: monedaValue,
      tipoCambio: data.factura_tipo_cambio ?? '',
      centroCosto: data.factura_centro_costo || '',
      cuentaContableIngreso: data.factura_cuenta_contable_ingreso || '',
      medioCobro: data.factura_medio_cobro || '',
      estado: data.factura_estado,
      observaciones: data.factura_observaciones || ''
    });

    // Marcar el estado cargado como estado inicial (sin cambios)
    this.formValidationService.resetearEstado();

    console.log('Formulario autocompletado con los datos de la fila');
  }


  filtrarPorFechas(event: { startDate: Date; endDate: Date }) {
    console.log('Rango de fechas seleccionado:', event);
    this.startDate = event.startDate;
    this.endDate = event.endDate;
    // Aquí puedes agregar la lógica para filtrar los datos
  }

  onCentroCostoSelected(item: any) {
    this.facturaForm.patchValue({ centroCosto: item?.codigo });
    this.facturaForm.get('centroCosto')?.markAsTouched();
  }

  onCuentaContableSelected(item: any) {
    this.facturaForm.patchValue({ cuentaContableIngreso: item?.codigo });
    this.facturaForm.get('cuentaContableIngreso')?.markAsTouched();
  }

    // Métodos para el componente de carga de documentos
  onDocumentoIdentidadSelected(file: File) {
    this.documentoIdentidad = file;
    console.log('Documento de identidad seleccionado:', file.name);
    // Aquí puedes agregar lógica adicional como subir el archivo al servidor
  }

  onDocumentoIdentidadRemoved() {
    this.documentoIdentidad = null;
    console.log('Documento de identidad removido');
  }

  showFileError(errorMessage: string) {
    console.error('Error de archivo:', errorMessage);
    // Aquí puedes mostrar un toast o mensaje de error al usuario
    // Por ejemplo: this.toastService.showError(errorMessage);
  }

  async nuevoDocumento() {
    // Validar si hay cambios sin guardar antes de limpiar
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;

    // Limpiar la fila seleccionada
    this.filaSeleccionada = null;

    // Deseleccionar todas las filas en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Resetear el formulario a sus valores iniciales
    this.facturaForm.reset({
      tipoDocumentoCliente: 'dni',
      estado: { value: 'Pendiente', disabled: true },
    });

    this.sucursalSeleccionada = '';
    // Limpiar archivo adjunto
    this.documentoSoporte = '';

    // Marcar el formulario limpio como estado inicial
    this.formValidationService.resetearEstado();
  }
  buscarCliente() {
    const tipoDoc = this.facturaForm.get('tipoDocumentoCliente')?.value;
    const numeroDocValue = this.facturaForm.get('numeroDocumentoCliente')?.value;
    const numeroDoc = numeroDocValue ? String(numeroDocValue).trim() : '';

    console.log('Buscando cliente:', { tipoDoc, numeroDoc, numeroDocValue });

    if (!numeroDoc) {
      console.log('Debe ingresar un número de documento');
      return;
    }

    // Buscar en la data de ejemplo
    let clienteEncontrado;

    if (tipoDoc === 'dni') {
      clienteEncontrado = this.clientesEjemplo.find(c => c.dni === numeroDoc);
    } else if (tipoDoc === 'ruc') {
      clienteEncontrado = this.clientesEjemplo.find(c => c.ruc === numeroDoc);
    }

    if (clienteEncontrado) {
      this.facturaForm.patchValue({
        cliente: clienteEncontrado.nombre
      });

    } else {
      // Limpiar el campo si no se encuentra;
      this.facturaForm.patchValue({
        cliente: ''
      });

      this.toastservice.warning('¡No se ha encontrado el cliente!');
    }
  }

  onSucursalSeleccionada(sucursal: any) {
    this.sucursalSeleccionada = sucursal?.id || '';
    // El ControlValueAccessor ya actualiza el form control (valueKey="nombre")
    console.log('Sucursal seleccionada:', sucursal);
  }

  async abrirModal(value: any, rowData: any) {
    console.log('Abriendo modal para:', value, rowData);
    
    // Solo abrir modal si es asiento (contiene 'MN')
    const esAsiento = value.includes('MN');
    
    if (esAsiento) {
      await this.abrirModalAsiento(value, rowData);
    }
    // Si es documento, no hacer nada (el otro modal ya está configurado)
  }

  async abrirModalAsiento(numeroAsiento: string, rowData: any) {
    console.log('Abriendo modal de asiento:', numeroAsiento, rowData);
    
    const detalleAsiento = [
      { label: 'Fecha de registro', value: new Date().toLocaleDateString('es-PE') },
      { label: 'Fecha contable', value: new Date().toLocaleDateString('es-PE') },
      { label: 'Glosa', value: `Asiento para ${rowData.factura_cliente || 'Cliente'}` },
      { label: 'Total', value: `${rowData.factura_moneda === 'Soles' ? 'S/' : '$'} ${rowData.factura_monto}` },
      { label: 'Número de asiento', value: numeroAsiento },
    ];

    const colDefs: ColDef[] = [
      { field: 'cuentaContable', headerName: 'Cuenta contable', width: 100 },
      { field: 'descripcion', headerName: 'Descripción', minWidth: 150, flex: 1 },
      {
        field: 'debe', headerName: 'Debe (S/)', width: 80, headerClass: 'centrarencabezado',
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        valueFormatter: (params) => {
          if (params.value !== null && params.value !== undefined) {
            const absValue = Math.abs(params.value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);

            if (params.value < 0) {
              return `(${formattedValue})`;
            }
            return formattedValue;
          }
          return '-';
        },
      },
      {
        field: 'haber', headerName: 'Haber (S/)', width: 80,
        headerClass: 'centrarencabezado', cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        valueFormatter: (params) => {
          if (params.value !== null && params.value !== undefined) {
            const absValue = Math.abs(params.value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);

            if (params.value < 0) {
              return `(${formattedValue})`;
            }
            return formattedValue;
          }
          return '-';
        },
      },
      { field: 'centroC', headerName: 'Centro de costo', width: 90 },
      { field: 'docRef', headerName: 'Documento referencial', width: 90 },
      { field: 'tercero', headerName: 'Tercero', width: 100 },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Información del asiento contable ${numeroAsiento}`,
        subtitulomodal: 'Detalle del asiento',
        detalles: detalleAsiento,
        widthModal: '740px',
        mostrarTabla: true,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        colDefs: colDefs,
        rowData: [
          {
            cuentaContable: '151002',
            descripcion: `Factura ${rowData.factura_nro_documento}`,
            debe: rowData.factura_monto || '0.00',
            haber: '',
            centroC: rowData.centroCosto || '-',
            docRef: rowData.factura_nro_documento,
            tercero: rowData.factura_cliente,
          },
          {
            cuentaContable: '381001',
            descripcion: 'Contrapartida del asiento',
            debe: '',
            haber: rowData.factura_monto || '0.00',
            centroC: rowData.centroCosto || '-',
            docRef: rowData.factura_nro_documento,
            tercero: rowData.factura_cliente,
          }
        ]
      }
    });

    await modal.present();
  }

  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      this.documentoSoporte = file.name;
    }
  }
  removeFile() {
    this.documentoSoporte = '';
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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del documento',},
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación del monto',},
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - 001-TRA',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      },
    });

    await modal.present();
  }

  guardarFactura(): void {
    // Validar que el formulario sea válido
    if (this.facturaForm.invalid) {
      this.toastservice.warning('Por favor, completa todos los campos obligatorios');
      return;
    }

    const formValue = this.facturaForm.getRawValue();

    // Crear nueva factura
    const nuevaFactura = {
      factura_tipo_doc: formValue.tipoDocumento === 'factura' ? 'Factura' :
        formValue.tipoDocumento === 'notaDebito' ? 'Nota de débito' :
          formValue.tipoDocumento === 'notaCredito' ? 'Nota de crédito' :
            formValue.tipoDocumento === 'reciboPago' ? 'Recibo de pago' :
              'Recibo por honorarios',
      factura_nro_documento: `${formValue.serie}-${formValue.numero}`,
      factura_cliente: formValue.cliente,
      factura_sucursal: formValue.sucursal || '',
      factura_dni: formValue.numeroDocumentoCliente,
      factura_tipo_doc_cliente: formValue.tipoDocumentoCliente,
      factura_fecha_emision: formValue.fechaEmision,
      factura_fecha_vencimiento: formValue.fechaVencimiento,
      factura_descripcion_servicio: formValue.descripcionServicio || '',
      factura_monto: formValue.montoTotal,
      factura_moneda: formValue.moneda === 'soles' ? 'Soles' : formValue.moneda === 'dolares' ? 'Dólares' : formValue.moneda,
      factura_tipo_cambio: formValue.tipoCambio || null,
      factura_centro_costo: formValue.centroCosto || '',
      factura_cuenta_contable_ingreso: formValue.cuentaContableIngreso || '',
      factura_medio_cobro: formValue.medioCobro || '',
      factura_asiento: '',
      factura_show_eye: false,
      factura_estado: formValue.estado,
      factura_observaciones: formValue.observaciones || ''
    };

    // Si estamos editando, actualizar la fila existente
    if (this.filaSeleccionada) {
      this.facturasFacade.actualizarFactura(nuevaFactura as RegistroFacturaEntity);
      this.toastservice.success('Factura actualizada exitosamente');
    } else {
      // Agregar nueva factura
      this.facturasFacade.guardarFactura(nuevaFactura as RegistroFacturaEntity);
      this.toastservice.success('¡Factura registrada exitosamente!');
    }

    // Marcar como guardado (sin cambios pendientes)
    this.formValidationService.resetearEstado();

    // Resetear formulario
    this.facturaForm.reset({
      tipoDocumentoCliente: 'dni',
      estado: { value: 'Pendiente', disabled: true },
    });

    // Limpiar selección
    this.filaSeleccionada = null;
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Limpiar archivo adjunto
    this.documentoSoporte = '';
  }

  onEstadoChanged(event: any): void {
    const nuevoEstado = event.detail.value;
    const estadoActual = this.filaSeleccionada?.factura_estado;

    if (estadoActual === 'Pendiente' && (nuevoEstado === 'Pagado' || nuevoEstado === 'Anulado')) {
      if (this.filaSeleccionada) {
        const facturaActualizada: RegistroFacturaEntity = { ...this.filaSeleccionada, factura_estado: nuevoEstado };
        this.facturasFacade.actualizarFactura(facturaActualizada);

        if (nuevoEstado === 'Pagado') {
          this.toastservice.success('Factura marcada como Pagada');
        } else if (nuevoEstado === 'Anulado') {
          this.toastservice.warning('Factura anulada');
        }

        this.botonesHabilitados = false;

        if (nuevoEstado === 'Anulado') {
          this.disableFormControls();
        }
      }
    }
  }

  disableFormControls(): void {
    Object.keys(this.facturaForm.controls).forEach(key => {
      const control = this.facturaForm.get(key);
      if (control) {
        control.disable();
      }
    });
  }

  enableFormControls(): void {
    Object.keys(this.facturaForm.controls).forEach(key => {
      const control = this.facturaForm.get(key);
      if (control && key !== 'cliente' && key !== 'estado') {
        control.enable();
      }
    });
  }

  botonGuardarBorrador(): void {
    if (!this.filaSeleccionada) {
      this.toastservice.warning('Por favor, selecciona una factura');
      return;
    }

    const fecha = new Date().toISOString().split('T')[0];
    const asientoNum = String(this.rowDataFacturas.length).padStart(3, '0');
    const asiento = `MN-${fecha.replace(/-/g, '-')}-${asientoNum}`;

    const facturaActualizada: RegistroFacturaEntity = {
      ...this.filaSeleccionada,
      factura_estado: 'Pagado',
      factura_asiento: asiento,
      factura_show_eye: true,
    };

    this.facturasFacade.actualizarFactura(facturaActualizada);
    this.toastservice.success('¡Factura pagada exitosamente!');
    this.botonesHabilitados = false;
    this.filaSeleccionada = null;
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  botonAnular(): void {
    if (!this.filaSeleccionada) {
      this.toastservice.warning('Por favor, selecciona una factura para anular');
      return;
    }

    this.openAnularModal();
  }

  async openAnularModal(): Promise<void> {
    const detalles = [
      { label: 'Cliente', value: this.filaSeleccionada?.factura_cliente || '' },
      { label: 'F. de emisión', value: this.filaSeleccionada?.factura_fecha_emision || '' },
      { label: 'N° documento', value: this.filaSeleccionada?.factura_nro_documento || '' },
      { label: 'Monto', value: `${this.filaSeleccionada?.factura_moneda}/${this.filaSeleccionada?.factura_monto}` || '' }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      componentProps: {
        tituloModal: `Anular factura ${this.filaSeleccionada?.factura_nro_documento}`,
        subtitulomodal: 'Detalle de la factura',
        detalles: detalles,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo de la anulación:',
        placeholderTextarea: 'Describe el motivo de la anulación de la factura.',
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Anular',
        textoBotonCancelar: 'Cancelar',
        colorBotonConfirmar: 'danger',
        motivoObligatorio: true
      },
      cssClass: 'promo',
    });

    await modal.present();

    const { data } = await modal.onDidDismiss();

    if (data && data.action === 'confirmar') {
      this.toastservice.success('¡Factura anulada exitosamente!');

      if (this.filaSeleccionada) {
        const facturaAnulada: RegistroFacturaEntity = { ...this.filaSeleccionada, factura_estado: 'Anulado' };
        this.facturasFacade.actualizarFactura(facturaAnulada);
        this.facturaForm.patchValue({ estado: 'Anulado' });
      }

      this.botonesHabilitados = false;
      this.filaSeleccionada = null;
    }
  }
  onBtReset(){
    this.facturasFacade.cargarFacturas();
  }
}

