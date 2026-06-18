import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef, GridState } from 'ag-grid-community';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { MovCuentasBancYCajasEntity } from 'src/app/modules/finanzas/domain/models/mov-cuentas-banc-y-cajas.entity';
import { MovCuentasBancYCajasFacade } from 'src/app/modules/finanzas/application/facades/mov-cuentas-banc-y-cajas.facade';
import { MovCuentasBancYCajasFeedbackEffects } from 'src/app/modules/finanzas/effects/mov-cuentas-banc-y-cajas-feedback.effect';

// Font Awesome Icons
import { faBook, faCircleXmark, faEye, faInfoCircle, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDollarSign, faDownload, faList, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { IconDefinition } from '@fortawesome/fontawesome-svg-core';

// Font Awesome Icons

@Component({
  selector: 'app-f-t-mov-cuentas-banc-y-cajas',
  templateUrl: './f-t-mov-cuentas-banc-y-cajas.component.html',
  styleUrls: ['./f-t-mov-cuentas-banc-y-cajas.component.scss'],
  standalone: false,
})
export class FTMovCuentasBancYCajasComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farBook = faBook;
  farCircleXmark = faCircleXmark;
  farEye = faEye;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDollarSign = faDollarSign;
  fasDownload = faDownload;
  fasList = faList;
  fasRotateRight = faRotateRight;
  farInfoCircle = faInfoCircle;

  // Facade e Effects (arquitectura limpia)
  private readonly movCuentasFacade = inject(MovCuentasBancYCajasFacade);
  private readonly feedbackEffects = inject(MovCuentasBancYCajasFeedbackEffects);

  // Selectores reactivos del store
  readonly isLoading = this.movCuentasFacade.isLoading;

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  
  private gridApi!: GridApi;
  filaSeleccionada: any = null;
  modoCreacion: boolean = true;
  movimientoForm!: FormGroup;
  fechaRegistroSeleccionada: Date | undefined;
  fechaTransferenciaSeleccionada: Date | undefined;
  mostrarSucursales: boolean = false;
  mostrarCamposMoneda: boolean = false;
  montoLimite = '10,000.00';
  montoLimiteNumerico = 10000;

  cards = [
        { id: 2, nombre: 'Transferencia en periodo:', desde:'202512', valor: '20', icono: faList },
        { id: 2, nombre: 'Total transferido entre bancos y cajas en periodo:', desde:'202512', valor: 'S/100.00.00', icono: faDollarSign },
      ]
  
  
  tiposMovimiento = [
    { id: 'Banco a Banco', nombre: 'Banco a Banco' },
    { id: 'Caja a Banco', nombre: 'Caja a Banco' },
    { id: 'Banco a Caja', nombre: 'Banco a Caja' },
    { id: 'Caja a Caja', nombre: 'Caja a Caja' },
  ];
  
  sucursales = [
    { id: 1, nombre: 'SUC-001 - Lima Centro' },
    { id: 2, nombre: 'SUC-002 - Miraflores' },
    { id: 3, nombre: 'SUC-003 - San Isidro' },
    { id: 4, nombre: 'SUC-004 - Surco' },
    { id: 5, nombre: 'SUC-005 - Callao' },
  ];
  
  monedas = [
    { id: 'Soles', nombre: 'Soles', simbolo: 'S/' },
    { id: 'USD', nombre: 'Dólares', simbolo: '$' },
    { id: 'EUR', nombre: 'Euros', simbolo: '€' },
  ];
  
  cuentas = [
    { id: 1, nombre: 'BCP-001 - Cuenta Recaudadora (..4587)' },
    { id: 2, nombre: 'BBVA-002 - Cuenta Operativa (..1205)' },
    { id: 3, nombre: 'CAJA PRINCIPAL - Lima' },
    { id: 4, nombre: 'CAJA SUCURSAL - Miraflores' },
  ];
  
  mediosTransferencia = [
    { id: 'Transferencia', nombre: 'Transferencia' },
    { id: 'Efectivo', nombre: 'Efectivo' },
    { id: 'Cheque', nombre: 'Cheque' },
    { id: 'Depósito', nombre: 'Depósito' },
  ];
  
  estados = [
    { id: 'Pendiente', nombre: 'Pendiente' },
    { id: 'Confirmado', nombre: 'Confirmado' },
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
  
  rowData: MovCuentasBancYCajasEntity[] = [];
  
  colDefs: ColDef[] = [
    { field: 'mcb_codigo', headerName: 'Código', width: 100, minWidth:120 },
    { field: 'mcb_fechaRegistro', headerName: 'Fecha de registro', width: 110, minWidth: 110},
    { field: 'mcb_fechaTransferencia', headerName: 'Fecha de transferencia', width: 120, minWidth: 110 },
    { field: 'mcb_tipoMovimiento', headerName: 'Tipo movimiento', width: 130, minWidth: 130, filter: true },
    { field: 'mcb_cuentaOrigen', headerName: 'Cuenta de origen', width: 190, minWidth: 180, filter: true },
    { field: 'mcb_cuentaDestino', headerName: 'Cuenta de destino', width: 190, minWidth: 180, filter: true },
    { field: 'mcb_montoTransferido', headerName: 'Monto transferido', width: 130,minWidth: 130,
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
    { field: 'mcb_medioTransferencia', headerName: 'Medio', width: 100, minWidth: 120 },
    { field: 'mcb_numeroAsiento', headerName: 'N° comprobante', width: 120,minWidth: 140, },
    { 
      field: 'mcb_estado', 
      headerName: 'Estado', 
      width: 110, 
      minWidth: 100,
      filter: true,
      headerClass: 'centrarencabezado',
      cellStyle: () => {
        const style: any = { justifyContent: 'center', };
        return style;
      },
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-[#363636]">Pendiente</span>';
        } else if (params.value === 'Confirmado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Confirmado</span>';
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
      return 'Registrar nuevo movimiento';
    }
    return `Información del mov.: ${this.filaSeleccionada?.mcb_codigo || ''}`;
  }
  
  get formularioDeshabilitado(): boolean {
    if (this.modoCreacion) return false;
    const estado = this.filaSeleccionada?.mcb_estado;
    return estado === 'Confirmado' || estado === 'Anulado' || estado === 'Pendiente';
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
      const movimientos = this.movCuentasFacade.movimientos();
      this.rowData = movimientos;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });
  }

  ngOnInit() {
    this.initForm();
    this.movCuentasFacade.cargarMovimientos();
  }
  
  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }
  
  initForm() {
    const today = new Date();
    const day = String(today.getDate()).padStart(2, '0');
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const year = today.getFullYear();
    const todayString = `${day}/${month}/${year}`;
    
    this.movimientoForm = this.formBuilder.group({
      razonSocial: ['Importadora Vinos del Sur EIRL', Validators.required],
      usuarioEjecutor: ['Eduardo Jimenez Lopez', Validators.required],
      fechaRegistro: [{ value: todayString, disabled: true }],
      tipoMovimiento: ['', Validators.required],
      sucursalOrigen: ['', Validators.required],
      sucursalDestino: ['', Validators.required],
      cuentaOrigen: ['', Validators.required],
      cuentaDestino: ['', Validators.required],
      monedaOrigen: ['', Validators.required],
      tipoCambio: [{value: '', disabled: true}],
      montoTransferido: ['', [Validators.required, Validators.min(0.01), Validators.max(this.montoLimiteNumerico)]],
      medioTransferencia: ['', Validators.required],
      archivoAdjunto: [''],
      estado: [{ value: 'Pendiente', disabled: true }],
      numeroAsiento: [''],
      observaciones: ['']
    });
    
    this.fechaRegistroSeleccionada = today;
    this.fechaTransferenciaSeleccionada = today;
    
    // Listener para mostrar campos de sucursal cuando se seleccione tipo de movimiento
    this.movimientoForm.get('tipoMovimiento')?.valueChanges.subscribe((value) => {
      this.mostrarSucursales = !!value;
      if (!value) {
        // Limpiar campos de sucursal si se deselecciona el tipo
        this.movimientoForm.patchValue({
          sucursalOrigen: '',
          sucursalDestino: ''
        });
      }
    });
    
    // Listener para mostrar campos de moneda cuando se seleccione cuenta origen
    this.movimientoForm.get('cuentaOrigen')?.valueChanges.subscribe((value) => {
      this.mostrarCamposMoneda = !!value;
      if (!value) {
        // Limpiar campos de moneda, tipo de cambio y monto si se deselecciona la cuenta
        this.movimientoForm.patchValue({
          monedaOrigen: '',
          tipoCambio: '',
          montoTransferido: '',
          medioTransferencia: ''
        });
      }
    });
    
    // Inicializar servicio de validación
    this.formValidationService.inicializarFormulario(this.movimientoForm);
  }
  
  limpiarFormulario() {
    const today = new Date();
    const day = String(today.getDate()).padStart(2, '0');
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const year = today.getFullYear();
    const todayString = `${day}/${month}/${year}`;
    
    this.movimientoForm.patchValue({
      razonSocial: 'Importadora Vinos del Sur EIRL',
      usuarioEjecutor: 'Eduardo Jimenez Lopez',
      fechaRegistro: todayString,
      tipoMovimiento: '',
      sucursalOrigen: '',
      sucursalDestino: '',
      cuentaOrigen: '',
      cuentaDestino: '',
      monedaOrigen: '',
      tipoCambio: '',
      montoTransferido: '',
      medioTransferencia: '',
      archivoAdjunto: '',
      numeroAsiento: '',
      observaciones: ''
    });
    
    this.fechaTransferenciaSeleccionada = undefined;
    
    // Habilitar todos los campos editables
    this.movimientoForm.get('razonSocial')?.enable();
    this.movimientoForm.get('usuarioEjecutor')?.enable();
    this.movimientoForm.get('tipoMovimiento')?.enable();
    this.movimientoForm.get('sucursalOrigen')?.enable();
    this.movimientoForm.get('sucursalDestino')?.enable();
    this.movimientoForm.get('cuentaOrigen')?.enable();
    this.movimientoForm.get('cuentaDestino')?.enable();
    this.movimientoForm.get('monedaOrigen')?.enable();
    this.movimientoForm.get('tipoCambio')?.disable();
    this.movimientoForm.get('montoTransferido')?.enable();
    this.movimientoForm.get('medioTransferencia')?.enable();
    this.movimientoForm.get('archivoAdjunto')?.enable();
    this.movimientoForm.get('estado')?.disable();
    this.movimientoForm.get('observaciones')?.enable();
  }
  getRowClass = (params: any) => {
    if (params.data && params.data.mcb_montoTransferido < 0) {
      return 'row-parcial-blink';
    }
    return '';
  };
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }
  
  onFirstDataRendered(params: any) {
    params.api.sizeColumnsToFit();
  }
  
  onBtReset() {
    if (this.gridApi) {
      this.initialState.filter = {};
      this.gridApi.setFilterModel(null);
    }
  }
  
  filtrarPorFechas(event: any) {
    // Implementar filtro de fechas
  }
  
  onFechaTransferenciaSelected(fecha: Date) {
    this.fechaTransferenciaSeleccionada = fecha;
  }
  
  async onCellClicked(event: any) {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló, mantener estado actual
    }
    
    this.modoCreacion = false;
    this.filaSeleccionada = event.data;
    
    // Actualizar variable para mostrar sucursales
    this.mostrarSucursales = !!event.data.mcb_tipoMovimiento;
    // Actualizar variable para mostrar campos de moneda
    this.mostrarCamposMoneda = !!event.data.mcb_cuentaOrigen;
    
    // Cargar datos en el formulario
    this.movimientoForm.patchValue({
      razonSocial: 'Importadora Vinos del Sur EIRL',
      usuarioEjecutor: 'Eduardo Jimenez Lopez',
      fechaRegistro: event.data.mcb_fechaRegistro,
      tipoMovimiento: event.data.mcb_tipoMovimiento,
      cuentaOrigen: event.data.mcb_cuentaOrigen,
      cuentaDestino: event.data.mcb_cuentaDestino,
      tipoCambio: event.data.mcb_tipoCambio,
      montoTransferido: event.data.mcb_montoTransferido,
      medioTransferencia: event.data.mcb_medioTransferencia,
      archivoAdjunto: event.data.mcb_archivoAdjunto,
      estado: event.data.mcb_estado,
      numeroAsiento: event.data.mcb_numeroAsiento,
      observaciones: event.data.mcb_observaciones
    });
    
    // Cargar fecha de transferencia
    this.fechaTransferenciaSeleccionada = event.data.mcb_fechaTransferencia ? this.parseFecha(event.data.mcb_fechaTransferencia) : undefined;
    
    // Si está Confirmado o Anulado, deshabilitar todo
    if (event.data.mcb_estado === 'Confirmado' || event.data.mcb_estado === 'Anulado') {
      this.movimientoForm.disable();
    } else if (event.data.mcb_estado === 'Pendiente') {
      // Si está Pendiente, deshabilitar todo excepto el estado
      this.movimientoForm.disable();
      this.movimientoForm.get('estado')?.enable();
    }
    
    // Resetear servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }
  
  async botonRegistrarMov() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló, mantener estado actual
    }
    
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.mostrarSucursales = false;
    this.mostrarCamposMoneda = false;
    
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
    if (this.movimientoForm.invalid || !this.fechaTransferenciaSeleccionada) {
      this.toastService.danger('Por favor, complete todos los campos requeridos.');
      return;
    }
    
    // Generar código único
    const codigo = `MOV-2025-${String(5 + this.rowData.length).padStart(3, '0')}`;
    
    // Crear nuevo registro
    const nuevoRegistro: MovCuentasBancYCajasEntity = {
      mcb_codigo: codigo,
      mcb_fechaRegistro: this.movimientoForm.get('fechaRegistro')?.value,
      mcb_fechaTransferencia: this.formatearFecha(this.fechaTransferenciaSeleccionada),
      mcb_tipoMovimiento: this.movimientoForm.get('tipoMovimiento')?.value,
      mcb_cuentaOrigen: this.movimientoForm.get('cuentaOrigen')?.value,
      mcb_cuentaDestino: this.movimientoForm.get('cuentaDestino')?.value,
      mcb_tipoCambio: this.movimientoForm.get('tipoCambio')?.value,
      mcb_montoTransferido: this.movimientoForm.get('montoTransferido')?.value,
      mcb_medioTransferencia: this.movimientoForm.get('medioTransferencia')?.value,
      mcb_archivoAdjunto: this.movimientoForm.get('archivoAdjunto')?.value || '',
      mcb_estado: 'Pendiente',
      mcb_numeroAsiento: this.movimientoForm.get('numeroAsiento')?.value,
      mcb_observaciones: this.movimientoForm.get('observaciones')?.value || ''
    };
    
    // Agregar a la tabla al inicio
    this.rowData = [nuevoRegistro, ...this.rowData];
    
    // Actualizar la grid
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
      this.gridApi.deselectAll();
    }
    
    this.toastService.success('¡Movimiento registrado exitosamente!');
    
    // Limpiar formulario para seguir agregando más
    this.limpiarFormulario();
    
    // Resetear servicio de validación después de guardar
    this.formValidationService.resetearEstado();
  }
  
  async botonAnular() {
    if (!this.filaSeleccionada) {
      this.toastService.danger('No hay movimiento seleccionado.');
      return;
    }

    const detallesEjemplo = [
      { label: 'Fecha de transf.', value: '05/11/2025' },
      { label: 'Cta. origen', value: this.filaSeleccionada.mcb_cuentaOrigen },
      { label: 'Cta. destino', value: this.filaSeleccionada.mcb_cuentaDestino },
      { label: 'Monto transf.', value: this.filaSeleccionada.mcb_montoTransferido },
      { label: 'Estado', value: this.filaSeleccionada.mcb_estado },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Anular movimiento',
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
        row.mcb_codigo === this.filaSeleccionada.mcb_codigo
      );

      if (index !== -1) {
        this.rowData[index].mcb_estado = 'Anulado';
        this.rowData[index].mcb_observaciones = data.motivo;
        
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

        this.toastService.success('¡Movimiento anulado exitosamente!');
      }
    }
  }
  
  botonGuardar() {
    if (this.movimientoForm.invalid) {
      this.toastService.danger('Por favor, complete todos los campos requeridos.');
      return;
    }
    
    // Actualizar datos en rowData
    const index = this.rowData.findIndex(row => row.mcb_codigo === this.filaSeleccionada.mcb_codigo);
    
    if (index !== -1) {
      this.rowData[index] = {
        ...this.rowData[index],
        mcb_fechaTransferencia: this.fechaTransferenciaSeleccionada ? this.formatearFecha(this.fechaTransferenciaSeleccionada) : this.rowData[index].mcb_fechaTransferencia,
        mcb_tipoMovimiento: this.movimientoForm.get('tipoMovimiento')?.value,
        mcb_cuentaOrigen: this.movimientoForm.get('cuentaOrigen')?.value,
        mcb_cuentaDestino: this.movimientoForm.get('cuentaDestino')?.value,
        mcb_tipoCambio: this.movimientoForm.get('tipoCambio')?.value,
        mcb_montoTransferido: this.movimientoForm.get('montoTransferido')?.value,
        mcb_medioTransferencia: this.movimientoForm.get('medioTransferencia')?.value,
        mcb_archivoAdjunto: this.movimientoForm.get('archivoAdjunto')?.value,
        mcb_estado: this.movimientoForm.get('estado')?.value,
        mcb_observaciones: this.movimientoForm.get('observaciones')?.value
      };
      
      // Actualizar fila seleccionada
      this.filaSeleccionada = { ...this.rowData[index] };
      
      // Actualizar grid
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }
      
      this.toastService.success('¡Cambios guardados exitosamente!');
      
      // Resetear servicio de validación
      this.formValidationService.resetearEstado();
    }
  }
  
  async verAsientoContable() {
    if (!this.filaSeleccionada?.mcb_numeroAsiento) {
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
      { cuentaContable: '101101', descripcion: 'Caja y Bancos â€“ BCP', debe: '-', haber: '25,000.00' },
      { cuentaContable: '101102', descripcion: 'Caja y Bancos â€“ BBVA', debe: '25,000.00', haber: '-' },
    ];
    
    const detalles = [
      { label: 'Fecha de registro', value: this.filaSeleccionada.mcb_fechaRegistro },
      { label: 'Origen', value: 'Tesorería' },
      { label: 'Tipo', value: 'Movimiento entre cuentas' },
      { label: 'Estado', value: this.filaSeleccionada.mcb_estado },
      { label: 'Total Debe (S/)', value: '25,000.00' },
      { label: 'Total Haber (S/)', value: '25,000.00' },
    ];
    
    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Información del asiento contable ${this.filaSeleccionada.mcb_numeroAsiento}`,
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
      this.toastService.danger('Seleccione un movimiento.');
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
      { fechaHora: '09/01/2025 10:30', usuario: 'Eduardo Jimenez', accion: 'Creación', detalleCambio: 'Se registró el movimiento' },
      { fechaHora: '09/01/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se modificó el estado a Confirmado' },
    ];
    
    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones del movimiento ${this.filaSeleccionada.mcb_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
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
      const mes = parseInt(partes[1], 10) - 1;
      const anio = parseInt(partes[2], 10);
      return new Date(anio, mes, dia);
    }
    return undefined;
  }
  
  subirArchivo(event: any) {
    const archivo = event.target.files[0];
    if (archivo) {
      this.movimientoForm.patchValue({
        archivoAdjunto: archivo.name
      });
    }
  }
  
  removeFile() {
    this.movimientoForm.patchValue({
      archivoAdjunto: ''
    });
    this.toastService.success('La acción se realizó con éxito.');
  }
}

