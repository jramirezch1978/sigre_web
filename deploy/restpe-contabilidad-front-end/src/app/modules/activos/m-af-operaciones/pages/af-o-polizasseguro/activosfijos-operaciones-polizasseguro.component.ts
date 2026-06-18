import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { PolizaSeguroFacade } from '../../../application/facades/poliza-seguro.facade';
import { ActivoFijoFacade } from '../../../application/facades/activo-fijo.facade';
import { ColDef, GridApi, GridOptions, GridReadyEvent } from 'ag-grid-community';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ModalCancelarPolizaComponent } from './modal/modal-cancelar-poliza/modal-cancelar-poliza.component';
import { ModalRenovarPolizaComponent } from './modal/modal-renovar-poliza/modal-renovar-poliza.component';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

// Font Awesome Icons
import { faBook, faCircleXmark, faInfoCircle, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-activosfijos-operaciones-polizasseguro',
  templateUrl: './activosfijos-operaciones-polizasseguro.component.html',
  styleUrls: ['./activosfijos-operaciones-polizasseguro.component.scss'],
  standalone: false
})
export class ActivosfijosOperacionesPolizasseguroComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farBook = faBook;
  farCircleXmark = faCircleXmark;
  farInfoCircle = faInfoCircle;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


 //Fechas unica


  polizaForm!: FormGroup

  panelLateralVisible = true;
  polizasProximasVencer = 1;
  selectedPoliza: any = null;
  disabledCancelar: boolean = false;
  disabledRenovar: boolean = false;
  disabledGuardar: boolean = false;
  disabledCalendars: boolean = false;
  documentoSoporte: string = '';

  monedas=[
    'Soles',
    'Dólares',
  ]
  // Lista de activos para el autocomplete
  activosList: any[] = [];

  // Lista de compañías aseguradoras
  companiasList = [
    { id: 'rimac', nombre: 'Rímac Seguros' },
    { id: 'pacifico', nombre: 'Pacífico Seguros' },
    { id: 'positiva', nombre: 'Positiva Seguros' }
  ];

  // Lista de tipos de seguro
  tiposSeguroList = [
    { id: 'todo-riesgo', nombre: 'Todo Riesgo' },
    { id: 'robo', nombre: 'Robo' },
    { id: 'incendio', nombre: 'Seguro contra incendios' },
    { id: 'maquinaria', nombre: 'Seguro de maquinaria' }
  ];

  // Facade – fuente de datos reactiva
  private readonly polizaSeguroFacade = inject(PolizaSeguroFacade);
  private readonly activoFijoFacade = inject(ActivoFijoFacade);

  // AG-Grid
  private gridApi!: GridApi;

  /** Listado de pólizas proveniente del JSON vía ReportesRepositoryImpl */
  readonly rowData        = this.polizaSeguroFacade.polizas;
  readonly isLoadingPolizas = this.polizaSeguroFacade.isLoading;

  colDefs: ColDef[] = [
    { field: 'poliza_codigo', headerName: 'Código', width: 90 },
    { field: 'poliza_activo', headerName: 'Activo', width: 150 },
    { field: 'poliza_aseguradora', headerName: 'Aseguradora', width: 140, filter: true },
    { field: 'poliza_fecha_inicio', headerName: 'F. de Inicio', width: 100,
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
    { field: 'poliza_fecha_vencimiento', headerName: 'F. de Vencimiento', width: 130,
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
      field: 'poliza_estado', 
      headerName: 'Estado',
      filter: true,
      width: 130,headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Vence en 30 días') {
          return '<span class="badge-table bg-[#FFF0BF] text-yellow !w-20">Vence en 30 días</span>';
        } else if (params.value === 'Vigente') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Vigente</span>';
        }else if (params.value === 'Vencida') {
          return '<span class="badge-table bg-warning-10 text-warning">Vencida</span>';
        } else if (params.value === 'Anulada') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulada</span>';
        } else if (params.value === 'Vigente en 7 días') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85 !w-20">Vigente en 7 días</span>';
        } else if (params.value === 'En siniestro') {
          return '<span class="badge-table bg-[#D6E6FF] text-primary">En siniestro</span>';
        }
        return params.value;
      }
    }
  ];

  columnTypes = {
    rightAligned: { cellClass: 'text-right' }
  };

  localeText = {
    page: 'Página',
    of: 'de',
    to: 'a',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    noRowsToShow: 'No hay filas para mostrar',
    loadingOoo: 'Cargando...'
  };
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  constructor(
    private modalController: ModalController,
    private toastService: ToastService,
    private fb : FormBuilder,
    private formValidationService: FormValidationService
  ) {
    effect(() => {
      const items = this.activoFijoFacade.activosFijos();
      this.activosList = items.map((item) => ({
        id: item.activo_fijo_codigo,
        nombre: `${item.activo_fijo_codigo} - ${item.activo_fijo_descripcion}`,
        descripcion: item.activo_fijo_descripcion,
      }));
    });
   }

  ngOnInit() {
    this.polizaForm = this.fb.group({
      activo:['', Validators.required],
      codigoPoliza:['', Validators.required],
      companiaSeleccionada:['', Validators.required],
      tipoSeguroSeleccionado:['', Validators.required],
      fechaInicio:['', Validators.required],
      fechaVencimiento: ['', Validators.required],
      sumaAsegurada:['', Validators.required],
      monedaSeleccionada:['', Validators.required],
      primaTotal:['', Validators.required],
      deducible:['', Validators.required],
      tipoDeducible:['', Validators.required],
      beneficiario:['', Validators.required],
      documentoSoporte:['', Validators.required],
      observaciones: [''],
    });

    // Inicializar servicio de validación de formularios
    this.formValidationService.inicializarFormulario(this.polizaForm);
    // Resetear estado inicial después de inicializar
    this.formValidationService.resetearEstado();

    // Cargar pólizas desde el repositorio de datos (ReportesRepositoryImpl → JSON)
    this.polizaSeguroFacade.cargarPolizas();
    this.activoFijoFacade.cargarActivosFijos();
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
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

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }
  gridOptions: GridOptions = {
    getRowId: (params) => params.data.poliza_codigo
  };

  async onCellClicked(event: any) {
    console.log('Fila seleccionada:', event.data);
    
    // Validar cambios antes de cambiar de póliza
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló, deseleccionar todo primero
      if (this.gridApi) {
        this.gridApi.deselectAll();
        // Volver a seleccionar la fila anterior si existía
        if (this.selectedPoliza) {
          this.gridApi.forEachNode((node) => {
            if (node.data === this.selectedPoliza) {
              node.setSelected(true);
            }
          });
        }
      }
      return;
    }
    
    // Deseleccionar todas las filas primero
    this.gridApi.deselectAll();
    
    // Seleccionar la fila clickeada
    event.node.setSelected(true);
    
    this.selectedPoliza = {
      ...event.data,
      poliza_suma_asegurada: '10,000.00',
      poliza_prima_total: '1,200.00'
    };

    this.llenarFormulario(event.data)
    
    // Actualizar estado de botones según el estado de la póliza
    this.updateButtonStates();
  }

  llenarFormulario(data:any){

    this.polizaForm.patchValue({
      activo: data.poliza_cod_activo,
      codigoPoliza: data.poliza_codigo,
      companiaSeleccionada: data.poliza_aseguradora,
      tipoSeguroSeleccionado: data.poliza_tipo_seguro,
      fechaInicio: this.parsearFecha(data.poliza_fecha_inicio),
      fechaVencimiento:  this.parsearFecha(data.poliza_fecha_vencimiento),
      sumaAsegurada: data.poliza_suma_asegurada,
      monedaSeleccionada: data.poliza_moneda,
      primaTotal: data.poliza_prima_total,
      deducible: data.poliza_deducible,
      tipoDeducible: data.poliza_tipo_deducible,
      beneficiario: data.poliza_beneficiario,
      documentoSoporte: data.poliza_documento_soporte,
      observaciones: data.poliza_observaciones,
    });

    // Marcar como pristine y untouched
    this.polizaForm.markAsPristine();
    this.polizaForm.markAsUntouched();
    
    // Resetear estado de validación después de cargar datos
    setTimeout(() => {
      this.formValidationService.resetearEstado();
    }, 50);

  }

  updateButtonStates() {
    if (this.selectedPoliza?.poliza_estado === 'Vence en 30 días') {
      this.disabledCancelar = false;
      this.disabledRenovar = false;
      this.polizaForm.enable();
      this.disabledGuardar = false;
      this.disabledCalendars = false;
    } else if ( this.selectedPoliza?.poliza_estado === 'Vigente' || this.selectedPoliza?.poliza_estado === 'Vigente en 7 días') {
      this.disabledCancelar = false;
      this.disabledRenovar = true;
      this.polizaForm.enable();
      this.disabledGuardar = false;
      this.disabledCalendars = false;
    } else if (this.selectedPoliza?.poliza_estado === 'Vencida') {
      this.disabledCancelar = true;
      this.disabledRenovar = false;
      this.polizaForm.disable();
      this.disabledGuardar = true;
      this.disabledCalendars = true;
    } else if (this.selectedPoliza?.poliza_estado === 'Anulada') {
      this.disabledCancelar = true;
      this.disabledRenovar = true;
      this.polizaForm.disable();
      this.disabledGuardar = true;
      this.disabledCalendars = true;
    } else {
      this.disabledCancelar = false;
      this.disabledRenovar = false;
      this.polizaForm.enable();
      this.disabledGuardar = false;
      this.disabledCalendars = false;
    }
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  onActivoSelected(activo: any) {
    console.log('Activo seleccionado:', activo);
    this.polizaForm.patchValue({
      activo: activo.nombre
    });
  }

  onCompaniaSelected(compania: any) {
    console.log('Compañía seleccionada:', compania);
  }

  onTipoSeguroSelected(tipo: any) {
    console.log('Tipo de seguro seleccionado:', tipo);
  }

  async nuevaPoliza() {
    // Validar cambios antes de limpiar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }

    console.log('Nueva póliza');
    // Deseleccionar todas las filas
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    // Limpiar selección
    this.selectedPoliza = null;
    // Resetear estados de botones
    this.disabledCancelar = false;
    this.disabledRenovar = false;
    this.polizaForm.enable();
    this.disabledGuardar = false;
    this.disabledCalendars = false;
    
    // Resetear formulario
    this.polizaForm.reset();
    this.documentoSoporte = '';
    
    // Resetear estado de validación
    this.formValidationService.resetearEstado();
  }

  async botonCancelar(): Promise<void> {
    // Validar cambios antes de cancelar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Si cancela, deseleccionar la fila
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }
      return; // Cancelar acción
    }

    // Reiniciar el formulario a los valores por defecto
    if (this.polizaForm) {
      this.polizaForm.reset();

      // Limpiar variables
      this.selectedPoliza = null;
      this.documentoSoporte = '';

      // Deseleccionar fila de la tabla
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }

      // Resetear estados de botones
      this.disabledCancelar = false;
      this.disabledRenovar = false;
      this.polizaForm.enable();
      this.disabledGuardar = false;
      this.disabledCalendars = false;

      // Resetear estado del servicio de validación
      this.formValidationService.resetearEstado();
    }
  }

  // cancelarPoliza() {
  //   console.log('Cancelar póliza:', this.selectedPoliza);
  //   this.openCancelarModal();
  // }

  // async openCancelarModal() {
  //   const modal = await this.modalController.create({
  //     component: ModalCancelarPolizaComponent,
  //     componentProps: {
  //       poliza: this.selectedPoliza
  //     },
  //     cssClass: 'promo'
  //   });

  //   await modal.present();
    
  //   const { data } = await modal.onDidDismiss();
    
  //   if (data && data.cancelada) {
  //     // Usuario confirmó la cancelación
  //     this.toastService.success('¡Póliza cancelada exitosamente!');
  //     // Aquí iría la lógica para cancelar la póliza en el backend
  //     // Por ahora, actualizar el estado localmente
  //     if (this.selectedPoliza) {
  //       this.selectedPoliza.estado = 'Cancelada';
  //       this.updateButtonStates();
        
  //       // Actualizar en la tabla también
  //       const rowNode = this.gridApi.getRowNode(this.selectedPoliza.codigo);
  //       if (rowNode) {
  //         rowNode.setDataValue('estado', 'Cancelada');
  //       }
  //     }
  //   }
    
  // }
public async abrirModalCancelar() {
    
    const detallesEjemplo: DetalleItem[] = [
      { label: 'N° de Póliza', value:  this.selectedPoliza.poliza_codigo},
      { label: 'Fecha de Inicio', value: this.selectedPoliza.poliza_fecha_inicio },
      { label: 'Fecha de Vencimiento', value: this.selectedPoliza.poliza_fecha_vencimiento },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Anulación de póliza',
        subtitulomodal: 'Detalle del asiento:',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Anular',
        colorBotonConfirmar: 'danger',
        motivoObligatorio: true,
      }
    });

    await modal.present();
    
    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      // Por ahora, actualizar el estado localmente
      this.selectedPoliza.poliza_estado = 'Anulada';

      const rowNode = this.gridApi.getRowNode(this.selectedPoliza.poliza_codigo);
      if (rowNode) {
        rowNode.setDataValue('poliza_estado', 'Anulada');
      }

      this.updateButtonStates();
      setTimeout(() => {
      this.toastService.success('¡La acción se realizó con éxito!');
      }, 400);
    }
  }
  renovarPoliza() {
    console.log('Renovar póliza:', this.selectedPoliza);
    this.openRenovarModal();
  }

  async openRenovarModal() {
    const modal = await this.modalController.create({
      component: ModalRenovarPolizaComponent,
      componentProps: {
        poliza: this.selectedPoliza
      },
      cssClass: 'promo'
    });

    await modal.present();
    
    const { data } = await modal.onDidDismiss();
    
    if (data && data.renovada) {
      // Usuario confirmó la renovación
      this.toastService.success('¡Póliza renovada exitosamente!');
      // Aquí iría la lógica para renovar la póliza en el backend
      console.log('Datos de renovación:', data.datos);
      
      // Actualizar el estado de la póliza
      if (this.selectedPoliza) {
        this.selectedPoliza.poliza_estado = 'Vigente';
        this.selectedPoliza.poliza_codigo = data.datos.numeroPoliza;
        this.selectedPoliza.poliza_fecha_inicio = data.datos.fechaInicio;
        this.selectedPoliza.poliza_fecha_vencimiento = data.datos.fechaVencimiento;
        this.updateButtonStates();
      }
    }
  }

  guardarPoliza() {
    // Validar que el formulario sea válido
    if (this.polizaForm.invalid) {
      console.log('Formulario inválido:', this.polizaForm.errors);
      console.log('Controles inválidos:');
      Object.keys(this.polizaForm.controls).forEach(key => {
        const control = this.polizaForm.get(key);
        if (control?.invalid) {
          console.log(`- ${key}:`, control.errors);
        }
      });
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    // Si está editando una póliza existente
    if (this.selectedPoliza) {
      // Actualizar la póliza en la tabla
      const rowNode = this.gridApi.getRowNode(this.selectedPoliza.poliza_codigo);
      if (rowNode) {
        rowNode.setData({
          ...this.selectedPoliza,
        });
      }
      this.toastService.success('¡Póliza actualizada exitosamente!');
      this.formValidationService.resetearEstado();
    } else {
      // Crear nueva póliza
      const nuevaPoliza = {
        poliza_codigo: `POL-${String(this.rowData().length + 1).padStart(3, '0')}`,
        poliza_activo: this.polizaForm.get('activo')?.value || '',
        poliza_aseguradora: 'Rímac Seguros',
        poliza_estado: 'Vigente'
      };

      // Agregar a la tabla
      this.gridApi.applyTransaction({ add: [nuevaPoliza] });
      // this.rowData.push(nuevaPoliza);

      this.toastService.success('¡Póliza registrada exitosamente!');

      // Limpiar formulario después del toast
      setTimeout(() => {
        this.selectedPoliza = null;
        this.documentoSoporte = '';
        this.polizaForm.reset();
        this.formValidationService.resetearEstado();
      }, 100);
    }
  }


   // Para modo SINGLE - Manejo de fecha seleccionada
  onFechaInicio(date: Date) {
    console.log('Fecha Inicio:', date);
    this.polizaForm.patchValue({
      fechaInicio: this.formatearFecha(date)
    })
  }

  onFechaVenciemiento(date: Date) {
    console.log('Fecha Vencimiento:', date);
    this.polizaForm.patchValue({
      fechaVencimiento: this.formatearFecha(date)
    })
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

    onBtReset() {
      // Recarga datos desde el repositorio, lo que activa isLoadingPolizas()
      this.polizaSeguroFacade.cargarPolizas();
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
        { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar',},
        { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385',},
        { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio:   'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380',},
        { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT',},
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
