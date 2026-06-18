import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { CountryService } from 'src/app/ui/services/countryservice.service';

// Font Awesome Icons
import { faBook, faCircleXmark, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { PagoDetraccionEntity } from 'src/app/modules/finanzas/domain/models/pago-detraccion.entity';
import { PagoDetraccionFacade } from 'src/app/modules/finanzas/application/facades/pago-detraccion.facade';
import { PagoDetraccionFeedbackEffects } from 'src/app/modules/finanzas/effects/pago-detraccion-feedback.effect';



@Component({
  selector: 'app-f-t-pago-detraccion',
  templateUrl: './f-t-pago-detraccion.component.html',
  styleUrls: ['./f-t-pago-detraccion.component.scss'],
  standalone: false,
})
export class FTPagoDetraccionComponent implements OnInit, OnDestroy {
  private readonly facade = inject(PagoDetraccionFacade);
  private readonly feedbackEffects = inject(PagoDetraccionFeedbackEffects);
  readonly isLoading = this.facade.isLoading;
  // Font Awesome Icons
  farBook = faBook;
  farCircleXmark = faCircleXmark;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  pais= this.countryService.getCountryCode();
  detraccionForm!: FormGroup;
  private gridApi!: GridApi;
  startDate: Date = new Date();
  endDate: Date = new Date();
  fechaPagoInicial?: Date;
  minDate: Date = new Date(new Date().getFullYear() - 1, 0, 1);
  maxDate: Date = new Date();
  documentoSoporte: string = '';
  desactivarautocomplete: boolean = false;
  filasSeleccionadas: any[] = [];
  mostrarTabla= false;

  mediosPago = [
    { value: 'Transferencia', label: 'Transferencia' },
    { value: 'Efectivo', label: 'Efectivo' }
  ];

  cuentasOrigen = [
    { codigo: 'CTA001', nombre: 'BCP - Cuenta Corriente Soles - 191-1234567' },
    { codigo: 'CTA002', nombre: 'Banco de la Nación - Cuenta Corriente Soles - 200-3001234567' },
  ];
  colDefsDetracciones: ColDef[] = [
    { field: '', 
      checkboxSelection: (params) => params.data.pd_estado !== 'Pagada' && params.data.pd_estado !== 'Pend. constancia',
      headerCheckboxSelection: true,
      headerName: '', 
      width: 50, 
      minWidth: 50, 
      headerClass: 'centrarencabezadocheck', 
      cellStyle: { justifyContent: 'center' }, 
    },
    { field: 'pd_codigo', headerName: 'Codigo', flex: 1, minWidth: 130 },
    { field: 'pd_fechapago', headerName: 'Fecha de pago', flex: 1, minWidth: 130 },
    { field: 'pd_proveedor', headerName: 'Proveedor', flex: 1, minWidth: 200 },
    { field: 'pd_importe', headerName: 'Importe', width: 100,
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
            return `S/ (${formattedValue})`;
          }
          return `S/ ${formattedValue}`;
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
    { field: 'pd_mediopago', headerName: 'Medio de pago', flex: 1, minWidth: 110 },
    // { field: 'responsable', headerName: 'Responsable', flex: 1, minWidth: 200 },
    { field: 'pd_estado', headerName: 'Estado', width: 130, minWidth: 130,
      headerClass: 'centrarencabezado',
      cellRenderer: (params: any) => {
        if (params.value === 'Pend. pago') {
          return '<span class="badge-table bg-[#F5F5F5] text-[#363636]">Pend. pago</span>';
        } else if (params.value === 'Pagada') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagada</span>';
        } else if (params.value === 'Pend. constancia') {
          return '<span class="badge-table !w-[78px] bg-[#F5F5F5] text-[#363636]">Pend. constancia</span>';
        }
        return params.value;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
     },
  ]
  rowDataDetracciones: PagoDetraccionEntity[] = [];
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
    private toastService: ToastService,
    private simulation: SimulationService,
    private countryService: CountryService,
  ) {
    this.initForm();
    effect(() => {
      const detracciones = this.facade.detracciones();
      this.rowDataDetracciones = detracciones;
      if (this.gridApi) this.gridApi.setGridOption('rowData', this.rowDataDetracciones);
    });
  }

  ngOnInit() {
    this.facade.cargarDetracciones();
  }

  ngOnDestroy() {
    this.facade.resetState();
  }
  onBtReset() {
    this.facade.cargarDetracciones();
  }
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    if (this.filasSeleccionadas.length > 0) {
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
          const codigosSeleccionados = new Set(this.filasSeleccionadas.map((f: any) => f.pd_codigo));
          this.gridApi.forEachNode((node: any) => {
            if (node.data && codigosSeleccionados.has(node.data.pd_codigo)) {
              node.setSelected(true);
              this.gridApi.ensureNodeVisible(node, 'middle');
            }
          });
        }
      }, 150);
    }
  }
  // onCellClicked(event: any){
  //   console.log('Celda clickeada:', event.data);
  // }
  onSelectionChangedBancario(event: any) {
    if (this.gridApi) {
      this.filasSeleccionadas = this.gridApi.getSelectedRows();
      console.log('=== Extracto Bancario - Selección Múltiple ===');
      console.log('Total de filas seleccionadas:', this.filasSeleccionadas.length);
      console.log('Datos:', this.filasSeleccionadas);
    }
    
    if (this.filasSeleccionadas.length > 0) {
      // Simular que se ha subido un documento de constancia
      this.documentoSoporte = `constancia_${this.filasSeleccionadas[0].pd_codigo}.pdf`;
      this.fileseleccionado = true;
      
      this.detraccionForm.patchValue({
        RUCproveedor: this.filasSeleccionadas[0].pd_RUCproveedor,
        proveedor: this.filasSeleccionadas[0].pd_proveedor,
        numeroConstancia: '202510080045678',
        documentoAsociado: 'F001-5897',
        importeDetraccion: this.filasSeleccionadas[0].pd_importe,
        medioPago: this.filasSeleccionadas[0].pd_mediopago,
        estado: this.filasSeleccionadas[0].pd_estado}
      )
    } else {
      // Si no hay filas seleccionadas, limpiar el documento
      this.documentoSoporte = '';
      this.fileseleccionado = false;
    }
    
    // Solo deshabilitar si hay exactamente 1 fila seleccionada y está en estado "Pagada" o "Pend. constancia"
    if (this.filasSeleccionadas.length === 1 && (this.filasSeleccionadas[0].pd_estado === 'Pagada' || this.filasSeleccionadas[0].pd_estado === 'Pend. constancia')) {
      this.detraccionForm.disable();
      this.desactivarautocomplete = true;
    } else {
      this.detraccionForm.enable();
      this.detraccionForm.get('RUCproveedor')?.disable();
      this.detraccionForm.get('proveedor')?.disable();
      this.detraccionForm.get('documentoAsociado')?.disable();
      this.detraccionForm.get('importeDetraccion')?.disable();
      this.detraccionForm.get('estado')?.disable();
      this.desactivarautocomplete = false;
    }
  }
  initForm() {
    this.detraccionForm = this.fb.group({
      RUCproveedor: [{ value: '', disabled: true }],
      proveedor: [{ value: '', disabled: true }],
      documentoAsociado: [{ value: '', disabled: true }],
      importeDetraccion: [{ value: '', disabled: true }],
      estado: [{ value: '', disabled: true }],
      cuentaOrigen: [''],
      numeroConstancia: ['', Validators.required],
      fechaPago: ['', Validators.required],
      medioPago: ['', Validators.required],
      observaciones: ['']
    });
  }
  onCuentaOrigenSelected(item: any) {
    this.detraccionForm.patchValue({ cuentaOrigen: item });
    this.detraccionForm.get('cuentaOrigen')?.markAsTouched();
  }

  filtrarPorFechas(event: { startDate: Date; endDate: Date }) {
    console.log('Rango de fechas seleccionado:', event);
    this.startDate = event.startDate;
    this.endDate = event.endDate;
  }
  fileseleccionado: boolean = false;
  onFileSelected(event: any): void {
    const file = event.target.files[0];
    if (file) {
      this.documentoSoporte = file.name;
      
      // Auto-llenar campos cuando se selecciona la constancia de pago
      const fechaPago = new Date('2024-12-15'); // Fecha fija de ejemplo
      
      this.detraccionForm.patchValue({
        numeroConstancia: 'CP-2024-001234',
        fechaPago: fechaPago,
        medioPago: 'Transferencia'
      });
      
      // Actualizar fechaPagoInicial para que el componente base-calendar-new detecte el cambio
      // El componente en modo 'single' escucha cambios en [initialDate] mediante ngOnChanges
      this.fechaPagoInicial = new Date(fechaPago);
      
      this.fileseleccionado = true;
    }
  }
  guardar(){
    
    // Validar que haya al menos una fila seleccionada
    if (this.filasSeleccionadas.length === 0) {
      this.toastService.warning('Por favor, selecciona al menos una detracción para guardar');
      return;
    }

    // Validar que la fila no esté ya en estado "Pagada"
    if (this.filasSeleccionadas[0].pd_estado === 'Pagada') {
      this.toastService.warning('Esta detracción ya está marcada como Pagada');
      return;
    }

    // Actualizar el estado a "Pagada" en las filas seleccionadas
    this.filasSeleccionadas.forEach((fila: any) => {
      fila.pd_estado = 'Pagada';
      fila.pd_mediopago = this.detraccionForm.get('medioPago')?.value;
      fila.numeroConstancia = this.detraccionForm.get('numeroConstancia')?.value;
    });

    // Actualizar los datos en la grilla
    this.rowDataDetracciones = [...this.rowDataDetracciones];

    //Guardar los datos actualizados en localStorage
    this.simulation.replace('detracciones', this.rowDataDetracciones);

    // Limpiar la selección
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Limpiar el formulario
    this.detraccionForm.reset();
    this.filasSeleccionadas = [];

    this.toastService.success('¡Cambios realizados exitosamente!');
  }
  descargararchivotxt(){
    // Actualizar el estado a "Pend. constancia" en las filas seleccionadas
    this.filasSeleccionadas.forEach((fila: any) => {
      fila.pd_estado = 'Pend. constancia';
    });

    // Actualizar los datos en la grilla
    this.rowDataDetracciones = [...this.rowDataDetracciones];

    // Guardar los datos actualizados en localStorage
    this.simulation.replace('detracciones', this.rowDataDetracciones);

    // Limpiar la selección
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Limpiar variables
    this.filasSeleccionadas = [];

    this.toastService.success('¡Archivo TXT generado y descargado exitosamente!');
  }
  removeFile() {
    this.documentoSoporte = '';
    // Auto-llenar campos cuando se selecciona la constancia de pago
      const fechaPago=''; // Fecha fija de ejemplo
      
      this.detraccionForm.patchValue({
        numeroConstancia: '',
        fechaPago: fechaPago,
        medioPago: ''
      });
  }
  
  puedeGuardar(): boolean {
    // No se puede guardar si el formulario es inválido
    if (this.detraccionForm.invalid) {
      return false;
    }
    
    // No se puede guardar si no hay filas seleccionadas
    if (this.filasSeleccionadas.length === 0) {
      return false;
    }
    
    // No se puede guardar si alguna de las filas seleccionadas está en estado "Pagada" o "Pend. constancia"
    const tienePagadaOConstancia = this.filasSeleccionadas.some(fila => fila.pd_estado === 'Pagada' || fila.pd_estado === 'Pend. constancia');
    if (tienePagadaOConstancia) {
      return false;
    }
    
    return true;
  }
  async modalverConfirmacion() {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Confirmar descarga',
        title: 'Confirmar descarga de archivo TXT',
        message:
          'Se generará un archivo TXT con 6 detracciones, por un total de S/ 4,500.00 para el pago masivo en SUNAT/Banco de la Nación.',
        submessage: '<span>Las detracciones quedarán en estado <span class="font-bold">“Pendiente de Constancia”</span> y no podrán modificarse.</span>',  
        btnOkTxt: 'Generar y descargar',
        btnCancelTxt: 'Cancelar',
      },
    });
    modal.present();

    const { data } = await modal.onDidDismiss();    
    // Si el usuario confirmó la acción, generar y descargar el archivo
    if (data) {
      this.descargararchivotxt();
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
            { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar'},
            { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385'},
            { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio:   'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380'},
            { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT'},
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

}
