import { Component, OnInit, ElementRef, viewChild, ViewChild, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { AccesorioActionsCellComponent } from '../../../m-af-tabla/pages/af-o-registroactivos/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';

// Font Awesome Icons
import { faBook, faCircleXmark, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faAngleLeft, faAngleRight, faChevronLeft, faChevronRight, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { RevaluacionFacade } from '../../../application/facades/revaluacion.facade';


@Component({
  selector: 'app-activosfijos-operaciones-revaluaciones',
  templateUrl: './activosfijos-operaciones-revaluaciones.component.html',
  styleUrls: ['./activosfijos-operaciones-revaluaciones.component.scss'],
  standalone: false
})
export class ActivosfijosOperacionesRevaluacionesComponent implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farCircleXmark = faCircleXmark;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasAngleLeft = faAngleLeft;
  fasAngleRight = faAngleRight;
  fasChevronLeft = faChevronLeft;
  fasChevronRight = faChevronRight;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  @ViewChild('scrollBox', { read: ElementRef }) scrollBox!: ElementRef;

  documentoSoporte: string = '';

  filaSeleccionada: any = null; // Almacena la fila que se está editando
  revaluacionForm: FormGroup;
  private gridApi!: GridApi;
  estadoSeleccionado: string = 'todos';
  camponuevo: boolean = false;
  tabSeleccionado: string = 'seleccionActivo';
  panelLateralVisible: boolean = true;
  gridContext!: { componentParent: ActivosfijosOperacionesRevaluacionesComponent };
  
  // Propiedades para controlar el estado de los botones
  disabledAnular: boolean = true;
  disabledValidar: boolean = true;

  // Array de activos para el autocomplete
  activos = [
    { id: 'AF-001', nombre: 'AF-001 - Cocina Industrial' },
    { id: 'AF-002', nombre: 'AF-002 - Equipo de Sonido' },
    { id: 'AF-003', nombre: 'AF-003 - Computadora' },
    { id: 'AF-004', nombre: 'AF-004 - Mobiliario' }
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
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  private readonly revaluacionFacade     = inject(RevaluacionFacade);
  readonly rowData                        = this.revaluacionFacade.revaluaciones;
  readonly isLoadingRevaluaciones         = this.revaluacionFacade.isLoading;

  colDefs: ColDef[] = [
    { field: 'revaluacion_codigo', headerName: 'Cod. Revaluación', width: 80 },
    { field: 'revaluacion_activo', headerName: 'Activo', width: 200 },
    { field: 'revaluacion_fecha', headerName: 'Fecha de Revaluación', width: 120 },
    { field: 'revaluacion_nuevo_valor', headerName: 'Nuevo Valor', width: 130 },
    { field: 'revaluacion_tipo', headerName: 'Tipo Revaluación', width: 130 },
    { field: 'revaluacion_estado', headerName: "Estado", headerClass: 'centrarencabezado', width: 90,
          cellRenderer: (params: any) => {
            const estado = params.value;
            let estadoClass = '';
            switch (estado) {
              case 'En proceso':
                estadoClass = 'text-[#F2A626] bg-[#FFF0BF]';
                break;
              case 'Validado':
                estadoClass = 'text-green-600 bg-green-100';
                break;
              case 'Contabilizado':
                estadoClass = 'text-primary bg-[#D6E6FF]';
                break;
              case 'Anulado':
                estadoClass = 'text-red-600 bg-red-100';
                break;
              default:
                estadoClass = 'text-gray-600 bg-gray-100';
                break;
            }
            return `<span class="badge-table ${estadoClass}">${estado}</span>`;
          },
          cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
         },
  ];

  columnTypes = {};


  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController
  ) {
    this.revaluacionForm = this.formBuilder.group({
      // Tab 1: Selección del Activo
      activo: ['', Validators.required],
      valorNetoA: ['', Validators.required],
      depreAcumulada: ['', Validators.required],
      valorNetoC: ['', Validators.required],
      // Tab 2: Ingreso de Valores
      tipoRevaluacion: ['', Validators.required],
      fechaRevaluacion: ['', Validators.required],
      estado: ['', Validators.required],
      factorRevaluacion: ['', Validators.required],
      nuevoValor: ['', Validators.required],
      moneda: ['', Validators.required],
      documentoSoporte: ['', Validators.required],
  responsableValuador: ['usuario', Validators.required],
  responsableValuadorinput: [''],
  nombreResponsable: ['', Validators.required],
      // Tab 3: Cálculo de la Revaluación (deshabilitado - se llena automáticamente)
      valorRev: [{ value: '', disabled: true }, Validators.required],
      depreAcum: [{ value: '', disabled: true }, Validators.required],
      ajusteVal: [{ value: '', disabled: true }, Validators.required],
      ajusteCont: [{ value: '', disabled: true }, Validators.required]
    });

    this.gridContext = { componentParent: this };
  }

  ngOnInit() {
    this.revaluacionFacade.cargarRevaluaciones();
  }

  /**
   * Valida los campos de la pestaña "Selección del Activo".
   * Requiere: activo, valorNetoA, depreAcumulada, valorNetoC
   */
  get seleccionActivoValid(): boolean {
    const activo = this.revaluacionForm.get('activo');
    const valorNetoA = this.revaluacionForm.get('valorNetoA');
    const depreAcumulada = this.revaluacionForm.get('depreAcumulada');
    const valorNetoC = this.revaluacionForm.get('valorNetoC');

    if (!activo || !valorNetoA || !depreAcumulada || !valorNetoC) return false;
    return !!(activo.valid && valorNetoA.valid && depreAcumulada.valid && valorNetoC.valid);
  }

  /**
   * Valida los campos de la pestaña "Ingreso de Valores".
   * Requiere: tipoRevaluacion, fechaRevaluacion, estado, documentoSoporte, responsableValuador, moneda
   */
  get ingresoValoresValid(): boolean {
    const tipoRevaluacion = this.revaluacionForm.get('tipoRevaluacion');
    const fechaRevaluacion = this.revaluacionForm.get('fechaRevaluacion');
    const estado = this.revaluacionForm.get('estado');
    const documentoSoporte = this.revaluacionForm.get('documentoSoporte');
    const responsableValuador = this.revaluacionForm.get('responsableValuador');
    const moneda = this.revaluacionForm.get('moneda');

    if (!tipoRevaluacion || !fechaRevaluacion || !estado || !documentoSoporte || !responsableValuador || !moneda) {
      return false;
    }
    return !!(
      tipoRevaluacion.valid &&
      fechaRevaluacion.valid &&
      estado.valid &&
      documentoSoporte.valid &&
      responsableValuador.valid &&
      moneda.valid
    );
  }

  /** Avanza a "Ingreso de Valores" sólo si la pestaña anterior es válida */
  nextTab() {
    if (this.seleccionActivoValid) {
      this.tabSeleccionado = 'ingresoValores';
    } else {
      // marcar campos como tocados para mostrar validaciones
      this.revaluacionForm.get('activo')?.markAsTouched();
      this.revaluacionForm.get('valorNetoA')?.markAsTouched();
      this.revaluacionForm.get('depreAcumulada')?.markAsTouched();
      this.revaluacionForm.get('valorNetoC')?.markAsTouched();
    }
  }

  /** Avanza a "Cálculo de la Revaluación" sólo si "Ingreso de Valores" es válido */
  nextTabIngreso() {
    if (this.ingresoValoresValid) {
      this.tabSeleccionado = 'calculoRevaluacion';
      // Calcular automáticamente los valores del tab 3
      this.calcularValoresRevaluacion();
    } else {
      // marcar campos como tocados
      this.revaluacionForm.get('tipoRevaluacion')?.markAsTouched();
      this.revaluacionForm.get('fechaRevaluacion')?.markAsTouched();
      this.revaluacionForm.get('estado')?.markAsTouched();
      this.revaluacionForm.get('documentoSoporte')?.markAsTouched();
      this.revaluacionForm.get('responsableValuador')?.markAsTouched();
      this.revaluacionForm.get('moneda')?.markAsTouched();
      
      // Si se seleccionó 'otro', marcar también el campo custom
      const responsableValuador = this.revaluacionForm.get('responsableValuador')?.value;
      if (responsableValuador === 'otro') {
        this.revaluacionForm.get('responsableValuadorCustom')?.markAsTouched();
      }
    }
  }

  /** Guarda la revaluación (sólo llamable desde tab final cuando está completa) */
  guardarRevaluacion() {
    if (this.ingresoValoresValid) {
      console.log('Guardar revaluación', this.revaluacionForm.getRawValue());
      
      // Mostrar toast de éxito
      this.toastService.success('¡Se registró la revaluación exitosamente!');
      
      // Limpiar el formulario
      this.revaluacionForm.reset();
      this.documentoSoporte = '';
      
      // Volver al primer tab
      this.tabSeleccionado = 'seleccionActivo';
      
      // Mostrar el panel lateral si estaba oculto
      if (!this.panelLateralVisible) {
        this.panelLateralVisible = true;
      }
      
      // aquí iría lógica para grabar en BD, etc.
    }
  }

  /**
   * Valida cambios de tabs desde el ion-segment
   * Impide cambiar a Tab 2 si Tab 1 no está completa
   * Impide cambiar a Tab 3 si Tab 2 no está completa
   */
  onSegmentChange(event: any) {
    const newTab = event.detail.value;

    // Si intenta ir a Tab 2 (ingresoValores)
    if (newTab === 'ingresoValores' && !this.seleccionActivoValid) {
      console.warn('No puedes acceder a Ingreso de Valores sin completar Selección del Activo');
      this.tabSeleccionado = 'seleccionActivo';
      return;
    }

    // Si intenta ir a Tab 3 (calculoRevaluacion)
    if (newTab === 'calculoRevaluacion' && !this.ingresoValoresValid) {
      console.warn('No puedes acceder a Cálculo de la Revaluación sin completar Ingreso de Valores');
      this.tabSeleccionado = 'ingresoValores';
      return;
    }

    // Si la validación pasó, permite el cambio
    this.tabSeleccionado = newTab;
    
    // Si se cambia al tab de cálculo, ejecutar cálculos automáticos
    if (newTab === 'calculoRevaluacion') {
      this.calcularValoresRevaluacion();
    }
    
    // Si se cambia al tab de cálculo, ejecutar cálculos automáticos
    if (newTab === 'calculoRevaluacion') {
      this.calcularValoresRevaluacion();
    }
  }

  /**
   * Calcula automáticamente los valores de revaluación cuando se accede al tab 3
   * Basándose en los datos ingresados en los tabs anteriores
   */
  private calcularValoresRevaluacion(): void {
    try {
      // Obtener valores de los tabs anteriores
      const valorNetoActual = parseFloat(this.revaluacionForm.get('valorNetoA')?.value) || 0;
      const depreAcumuladaActual = parseFloat(this.revaluacionForm.get('depreAcumulada')?.value) || 0;
      const valorNetoContable = parseFloat(this.revaluacionForm.get('valorNetoC')?.value) || 0;
      const factorRevaluacion = parseFloat(this.revaluacionForm.get('factorRevaluacion')?.value) || 1;
      const nuevoValor = parseFloat(this.revaluacionForm.get('nuevoValor')?.value) || 0;

      // Cálculos de revaluación
      const valorRevaluado = nuevoValor; // El nuevo valor ingresado
      const depreAcumuladaRevaluada = depreAcumuladaActual * factorRevaluacion;
      const ajusteValor = valorRevaluado - valorNetoActual;
      const ajusteContable = (valorRevaluado - depreAcumuladaRevaluada) - valorNetoContable;

      // Actualizar el formulario con los valores calculados
      this.revaluacionForm.patchValue({
        valorRev: valorRevaluado.toFixed(2),
        depreAcum: depreAcumuladaRevaluada.toFixed(2),
        ajusteVal: ajusteValor.toFixed(2),
        ajusteCont: ajusteContable.toFixed(2)
      }, { emitEvent: false });

      // Deshabilitar los campos calculados
      this.revaluacionForm.get('valorRev')?.disable({ emitEvent: false });
      this.revaluacionForm.get('depreAcum')?.disable({ emitEvent: false });
      this.revaluacionForm.get('ajusteVal')?.disable({ emitEvent: false });
      this.revaluacionForm.get('ajusteCont')?.disable({ emitEvent: false });

      console.log(' Valores de revaluación calculados automáticamente:', {
        valorRevaluado,
        depreAcumuladaRevaluada,
        ajusteValor,
        ajusteContable
      });

    } catch (error) {
      console.error('  Error al calcular valores de revaluación:', error);
      this.toastService.danger('Error al calcular los valores de revaluación');
    }
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onCellClicked(event: any) {
    
    this.camponuevo = false;

    const data = event.data;
    this.filaSeleccionada = data; // Guardar referencia de la fila seleccionada
    this.gridApi.deselectAll(); // Deseleccionar todas las filas primero

    event.node.setSelected(true); // Seleccionar la fila clickeada
    this.filaSeleccionada = data; // Guardar referencia de la fila seleccionada
    
    // Actualizar estado de botones según el estado de la revaluación
    this.updateButtonStates();
  }

  /**
   * Actualiza el estado de los botones Anular y Validar según el estado de la revaluación
   * Solo se habilitan cuando el estado es "En proceso"
   */
  updateButtonStates() {
    if (this.filaSeleccionada?.revaluacion_estado === 'En proceso') {
      this.disabledAnular = false;
      this.disabledValidar = false;
    } else {
      // Para todos los demás estados (Anulado, Validado, Contabilizado)
      this.disabledAnular = true;
      this.disabledValidar = true;
    }
  }

  /**
   * Anula la revaluación seleccionada
   */
  async anularRevaluacion() {
        
        const detallesEjemplo: DetalleItem[] = [
          { label: 'Cód. Revaluación:', value: 'RV-0002' },
          { label: 'Responsable:', value: 'Juan Pérez' },
          { label: 'F. de Revaluación:', value: '27/10/2026' },
        ];
    
        const modal = await this.modalController.create({
          component: ModalDetalleComponent,
          cssClass: 'promo',
          componentProps: {
            tituloModal: 'Anular revaluación',
            subtitulomodal: 'Detalle de revaluación:',
            detalles: detallesEjemplo,
            mostrarTextarea: true,
            mostrarBotonEliminar: true,
            textoBotonConfirmar: 'Anular',
            colorBotonConfirmar: 'danger'
          }
        });
    
        await modal.present();
        
        const { data } = await modal.onWillDismiss();
        if (data && data.action === 'confirmar') {
          // Confirmar inactivación - mantener el estado Inactivo
          // this.toastService.success('¡Póliza cancelada exitosamente!');
          // Aquí iría la lógica para cancelar la póliza en el backend
          return;
        }
      
  }

  /**
   * Valida la revaluación seleccionada
   */
  async validarRevaluacion() {
    
        const modal = await this.modalController.create({
          component: ModalConfirmationComponent,
          cssClass: 'promo',
          componentProps: {
            titlemodal: 'Confirmar Validación',
            title: 'Confirmar Validación de Revaluación',
            message:
              'Por favor, revisa los detalles antes de proceder. Una vez validado, no podrás modificar ni deshacer esta acción.',
            btnOkTxt: 'Confirmar',
            btnCancelTxt: 'Cancelar',
          },
        });
    
        await modal.present();
        const { data } = await modal.onWillDismiss();
        if (data === true) {
          this.Revaluacionvalidada();
        }
  }


  async Revaluacionvalidada() {
    
        const modal = await this.modalController.create({
          component: ModalConfirmationComponent,
          cssClass: 'promo',
          componentProps: {
            tipemodal:'confirm',
            titlemodal: 'Validación exitosa',
            title: '¡Revaluación Validada!',
            message:
              'La revaluación ha sido validada correctamente. Ahora puede proceder a su contabilización.',
            btnOkTxt: 'Contabilizar Ahora',
            btnCancelTxt: 'Cancelar',
          },
        });
    
        await modal.present();
        const { data } = await modal.onWillDismiss();
        if (data === true) {
        
        }
  }

    scrollLeft() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: -150, behavior: 'smooth' });
  }

  scrollRight() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: 150, behavior: 'smooth' });
  }


  botonNuevaRevaluacion() {
    this.camponuevo = true;
    this.revaluacionForm.reset();
    this.revaluacionForm.patchValue({ estado: 'Activo' });
    
    // Deseleccionar todas las filas
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Limpiar selección y deshabilitar botones
    this.filaSeleccionada = null;
    this.disabledAnular = true;
    this.disabledValidar = true;
  }

  botonGuardarActivo() {
    if (this.revaluacionForm.valid) {
      console.log('Guardar activo', this.revaluacionForm.value);
    }
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  onCellClickedActivo(event: any) {
    console.log('Datos generales clicked', event);
  }

  eliminarAccesorio(accesorio: any) {
    console.log('Eliminar accesorio', accesorio);
  }
  onActivoSeleccionado(activo: any) {
    console.log('Activo seleccionado:', activo);
    
    // Simular datos del activo seleccionado (en producción esto vendría de un servicio)
    const datosActivo: { [key: string]: { 
      valorNetoA: number, 
      depreAcumulada: number, 
      valorNetoC: number,
      // Datos calculados para el tab 3
      valorRev: number,
      depreAcum: number,
      ajusteVal: number,
      ajusteCont: number
    } } = {
      'AF-001': { 
        valorNetoA: 5000, 
        depreAcumulada: 1200, 
        valorNetoC: 3800,
        valorRev: 6500,
        depreAcum: 1560,
        ajusteVal: 1500,
        ajusteCont: 1140
      },
      'AF-002': { 
        valorNetoA: 3500, 
        depreAcumulada: 800, 
        valorNetoC: 2700,
        valorRev: 4550,
        depreAcum: 1040,
        ajusteVal: 1050,
        ajusteCont: 810
      },
      'AF-003': { 
        valorNetoA: 2000, 
        depreAcumulada: 600, 
        valorNetoC: 1400,
        valorRev: 2600,
        depreAcum: 780,
        ajusteVal: 600,
        ajusteCont: 420
      },
      'AF-004': { 
        valorNetoA: 4500, 
        depreAcumulada: 1000, 
        valorNetoC: 3500,
        valorRev: 5850,
        depreAcum: 1300,
        ajusteVal: 1350,
        ajusteCont: 1050
      }
    };

    // Obtener los datos del activo seleccionado
    const datos = datosActivo[activo.id];
    
    if (datos) {
      // Rellenar los campos del Tab 1 con patchValue
      this.revaluacionForm.patchValue({
        valorNetoA: datos.valorNetoA,
        depreAcumulada: datos.depreAcumulada,
        valorNetoC: datos.valorNetoC,
        // Rellenar también los campos del Tab 3 (calculados automáticamente)
        valorRev: datos.valorRev,
        depreAcum: datos.depreAcum,
        ajusteVal: datos.ajusteVal,
        ajusteCont: datos.ajusteCont
      });
      
      // Asegurar que el control 'activo' tenga el valor seleccionado
      const activoControl = this.revaluacionForm.get('activo');
      if (activoControl) {
        activoControl.setValue(activo);
        activoControl.markAsTouched();
        activoControl.updateValueAndValidity();
      }

      // Marcar los campos como tocados para activar las validaciones
      this.revaluacionForm.get('valorNetoA')?.markAsTouched();
      this.revaluacionForm.get('depreAcumulada')?.markAsTouched();
      this.revaluacionForm.get('valorNetoC')?.markAsTouched();
      this.revaluacionForm.get('valorRev')?.markAsTouched();
      this.revaluacionForm.get('depreAcum')?.markAsTouched();
      this.revaluacionForm.get('ajusteVal')?.markAsTouched();
      this.revaluacionForm.get('ajusteCont')?.markAsTouched();
    }
  }

  onFechaRevaluacionSelected(date: Date) {
    this.revaluacionForm.patchValue({
      fechaRevaluacion: date
    });
    this.revaluacionForm.get('fechaRevaluacion')?.markAsTouched();
  }
  
  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      this.documentoSoporte = file.name;
      // actualizar el FormControl para que la validación considere el archivo subido
      const control = this.revaluacionForm.get('documentoSoporte');
      if (control) {
        control.setValue(file.name);
        control.markAsDirty();
        control.updateValueAndValidity();
      }
    }
  }

  removeFile() {
    this.documentoSoporte = '';
    const control = this.revaluacionForm.get('documentoSoporte');
    if (control) {
      control.setValue('');
      control.markAsDirty();
      control.updateValueAndValidity();
    }
  }

    onBtReset() {
      this.revaluacionFacade.cargarRevaluaciones();
    }
  
    async modalverActualizaciones() {
      // Definir las columnas
      const colDefs = [
        {
          headerName: 'Fecha y hora',
          field: 'fechaHora',
          width: 150,
        },
        {
          headerName: 'Usuario',
          field: 'usuario',
          width: 120,
        },
        {
          headerName: 'Acción',
          field: 'accion',
          width: 150,
        },
        {  headerClass:'centrarencabezado', headerName: 'Detalle del cambio',
           cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center'},
           field: 'detalleCambio', flex: 1 },
      ];
  
      // Datos de ejemplo
      const rowData = [
        {
          fechaHora: '21/11/2025 09:00',
          usuario: 'Carlos Zapata',
          accion: 'Creación',
          detalleCambio: 'Registro inicial del tipo de cambio para Dólar',
        },
        {
          fechaHora: '21/11/2025 09:05',
          usuario: 'Carlos Zapata',
          accion: 'Actualización',
          detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385',
        },
        {
          fechaHora: '20/11/2025 08:30',
          usuario: 'Carlos Zapata',
          accion: 'Creación',
          detalleCambio:
            'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380',
        },
        {
          fechaHora: '19/11/2025 08:45',
          usuario: 'Carlos Zapata',
          accion: 'Creación',
          detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT',
        },
      ];
  
      const modal = await this.modalController.create({
        component: ModalVerActualizacionesComponent,
        cssClass: 'promo',
        componentProps: {
          titulo: 'Historial de Actualizaciones - Tipo de Cambio',
          rowData: rowData,
          colDefs: colDefs,
          anchoModal: '700px',
    
        },
      });
  
      await modal.present();
    }

}


