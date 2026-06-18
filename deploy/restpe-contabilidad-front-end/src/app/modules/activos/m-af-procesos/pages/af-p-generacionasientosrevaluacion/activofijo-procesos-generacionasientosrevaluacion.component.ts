import { Component, OnInit, effect, inject } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalController } from '@ionic/angular';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { GeneracionAsientosRevaluacionFacade } from '../../../application/facades/generacion-asientos-revaluacion.facade';
import { GeneracionAsientosRevaluacionEntity } from '../../../domain/models/generacion-asientos-revaluacion.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-activofijo-procesos-generacionasientosrevaluacion',
  templateUrl: './activofijo-procesos-generacionasientosrevaluacion.component.html',
  styleUrls: [ './activofijo-procesos-generacionasientosrevaluacion.component.scss',],
  standalone: false,
})
export class ActivofijoProcesosGeneracionasientosrevaluacionComponent
  implements OnInit, CanComponentDeactivate
{
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  formatDateDisplay(dateStr: string): string {
    if (!dateStr) return '-';
    const parts = dateStr.split('-');
    if (parts.length !== 3) return dateStr;
    return `${parts[2]}/${parts[1]}/${parts[0]}`;
  }

  isloading = false;
  estadoseleccionado: string = '';
  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  fechaRegistro: Date = new Date();

  //FECHAS ÚNICAS (SINGLE)
  fechaContabilizacion: Date | undefined;

  panelLateralVisible = true;
  mesSeleccionado: number | null = null;
  anioSeleccionado: number | null = null;
  selectedCalculo: any = null;
  formRevaluacion!: FormGroup;
  
  // Variables para tracking de cambios en el formulario
  private formularioInicial: any = null;
  private formularioModificado: boolean = false;

  // AG-Grid
  private gridApi!: GridApi;
  context: any;

  readonly facade = inject(GeneracionAsientosRevaluacionFacade);
  rowData: GeneracionAsientosRevaluacionEntity[] = [];

  moneda= [
    {value:"Soles" , nombre: 'Soles'},
    {value:"Dólares", nombre:'Dólares'}
  ];

  colDefs: ColDef<GeneracionAsientosRevaluacionEntity>[] = [
    { field: 'gar_codigo', headerName: 'Código', flex: 0.6, minWidth: 70 },
    { field: 'gar_fecha_revaluacion', headerName: 'F. revaluación', flex: 0.8, minWidth: 90,
      valueFormatter: (params: any) => this.formatDateDisplay(params.value)},
    { field: 'gar_activo', headerName: 'Activo', flex: 1.2, minWidth: 120 },
    { field: 'gar_moneda', headerName: 'Moneda', flex: 1.2, minWidth: 120 },
    { field: 'gar_total_ajuste', headerName: 'Total ajuste', flex: 0.9, minWidth: 100, cellClass: 'text-right',
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
        const style: any = { textAlign: 'right' };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { field: 'gar_nuevo_valor', headerName: 'Nuevo valor', flex: 0.8, minWidth: 90, cellClass: 'text-right',},
    { field: 'gar_fecha_contable', headerName: 'F. contable', flex: 0.7, minWidth: 85,
      valueFormatter: (params: any) => this.formatDateDisplay(params.value)
    },
    { field: 'gar_nro_asiento_cont', headerName: 'N° de asiento cont.', flex: 1, minWidth: 130, cellRenderer: VistaCellRenderComponent,
    },
    { field: 'gar_usuarioResp', headerName: 'Usuario Responsable', flex: 0.7, minWidth: 85,
    },
    { field: 'gar_estado', headerName: 'Estado', filter: true, flex: 0.7, minWidth: 100, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center',
      },
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-[#363636]">Pendiente</span>';
        } else if (params.value === 'Contabilizado') {
          return '<span class="badge-table bg-[#D6E6FF] text-primary">Contabilizado</span>';
        }
        return params.value;
      },
    },
  ];

  gridOptions = {
    context: {
      componentParent: this,
    },
  };

  columnTypes = {
    rightAligned: { cellClass: 'text-right' },
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
    loadingOoo: 'Cargando...',
  };
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '-'
        : params.value;
    }
  };
  constructor(
    private modalController: ModalController,
    private fb: FormBuilder,
    private toastservice: ToastService
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );

    // Configurar context para AG-Grid
    this.context = { componentParent: this };

    effect(() => {
      this.rowData = this.facade.asientos();
    });
  }

  async abrirModalDesdeTabla(rowData: any) {
    console.log('Abriendo modal desde la tabla con datos:', rowData);

    const asientoData = rowData.asientoData || [
      { cuentaContable: '1510.02', descripcion: 'Equipos de cocina - Revaluación', debe: 600.00, haber: 0.00,},
      { cuentaContable: '3810.01', descripcion: 'Revaluación por equis motivo', debe: 0.00, haber: 600.00,},
    ];

    const colDefs: ColDef[] = [
      { field: 'cuentaContable', headerName: 'Cuenta contable', width: 130 },
      { field: 'descripcion', headerName: 'Descripción', width: 150, flex: 1,},
      { field: 'debe', headerName: 'Debe', width: 80, headerClass: 'centrarencabezado',
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
      { field: 'haber', headerName: 'Haber', width: 80, headerClass: 'centrarencabezado',
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
      }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Asiento Contable: ${rowData.gar_nro_asiento_cont || 'AS-2025-09-003'}`,
        widthModal: '700px',
        mostrarTabla: true,
        colDefs: colDefs,
        rowData: asientoData,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        ocultarBotonConfirmar: true,
        textoBotonCancelar: 'Cerrar'
      },
    });

    await modal.present();
  }

  async contabilizar() {
    if (!this.selectedCalculo) return;

    this.isloading = true;
    setTimeout(() => {
      // Encontrar la fila por ID
      const idx = this.rowData.findIndex(
        (r) => r.id === this.selectedCalculo.id
      );
      if (idx === -1) {
        this.isloading = false;
        console.warn('Fila no encontrada');
        return;
      }

      // Cambiar el estado a 'Contabilizado' y actualizar nroAsientoCont y showEye
      this.rowData[idx].gar_estado = 'Contabilizado';
      this.rowData[idx].gar_show_eye = true;
      if (!this.rowData[idx].gar_nro_asiento_cont) {
        this.rowData[idx].gar_nro_asiento_cont = 'AS-NEW-001';
      }

      // Actualizar en la tabla visualmente
      if (this.gridApi) {
        this.gridApi.refreshCells({ force: true });
      }

      console.log(`Fila ${this.selectedCalculo.id} contabilizada`);
      this.toastservice.success('¡Asiento generado exitosamente!');

      // Actualizar selectedCalculo con la nueva referencia
      this.selectedCalculo = { ...this.rowData[idx] };

      // actualizar formulario
      if (this.formRevaluacion) {
        this.updateFormDisabledState();
      }
      
      // Resetear tracking de cambios después de contabilizar
      this.guardarEstadoInicial();
      this.formularioModificado = false;
      
      this.isloading = false;
    }, 2000);
  }

  ngOnInit() {
    this.facade.cargarAsientos();

    // Inicializar formulario reactivo para el panel derecho
    this.formRevaluacion = this.fb.group({
      codigo: [''],
      fechaRegistro: [new Date().toISOString().split('T')[0]],
      periodoContable: [''],
      tipoRevaluacion: ['Comercial'],
      origenDatos: [''],
      tipoMoneda: ['Soles'],
      fechaContabilizacion: [''],
      libroContable: ['Principal'],
      prefijo: [''],
      centroCosto: [''],
      observaciones: [''],
    });
    
    // Suscribirse a cambios del formulario
    this.formRevaluacion.valueChanges.subscribe(() => {
      this.verificarCambios();
    });
    // Asegurar estado inicial de habilitación del formulario
    this.updateFormDisabledState();
  }

  async exportar() {
    // Mostrar toast de 'exportando'
    // this.toastservice.warning('Exportando...');
    console.log('Exportando cálculo:', this.selectedCalculo);
  }

  async reprocesar() {
    if (!this.selectedCalculo) return;
    
    // Validar si hay cambios antes de reprocesar
    if (this.formularioModificado) {
      const confirmar = await this.mostrarModalConfirmacion();
      
      if (!confirmar) {
        return; // Cancelar acción
      }
    }

    // Encontrar la fila por ID
    const idx = this.rowData.findIndex((r) => r.id === this.selectedCalculo.id);
    if (idx === -1) {
      console.warn('Fila no encontrada');
      return;
    }

    // Actualizar a Pendiente
    this.rowData[idx].gar_estado = 'Pendiente';
    this.rowData[idx].gar_show_eye = false;

    console.log(`Fila ${this.selectedCalculo.id} reprocesada`);

    // Actualizar selectedCalculo
    this.selectedCalculo = { ...this.rowData[idx] };

    // Actualizar tabla
    const res = this.gridApi.applyTransaction({
      update: [this.rowData[idx]],
    })!;

    this.updateFormDisabledState();
    
    // Resetear tracking
    this.guardarEstadoInicial();
    this.formularioModificado = false;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onCellClicked(event: any) {
    this.cargarDatosSeleccionados(event.data);
  }

  private cargarDatosSeleccionados(data: any) {
    this.estadoseleccionado = data.gar_estado || '';

    this.selectedCalculo = {
      ...data,
      codigo: data.gar_codigo,
      fechaRegistro: data.gar_fechaRegistro,
      periodoContable: data.gar_periodoContable,
      tipoRevaluacion: data.gar_tipoRevaluacion || 'Comercial',
      origenDatos: data.gar_origenDatos || '',
      tipoMoneda: data.gar_moneda || 'Soles',
      fechaContabilizacion: data.gar_fechaContabilizacion,
      libroContable: data.gar_libroContable || 'Principal',
      prefijo: data.gar_prefijoDocumento || '',
      centroCosto: data.gar_centroCosto || '',
      observaciones: data.gar_observaciones || '',
    };

    if (this.formRevaluacion) {
      this.formRevaluacion.patchValue({
        codigo: this.selectedCalculo.codigo,
        fechaRegistro: this.selectedCalculo.fechaRegistro,
        periodoContable: this.selectedCalculo.periodoContable,
        tipoRevaluacion: this.selectedCalculo.tipoRevaluacion,
        origenDatos: this.selectedCalculo.origenDatos,
        tipoMoneda: this.selectedCalculo.tipoMoneda,
        fechaContabilizacion: this.selectedCalculo.fechaContabilizacion,
        libroContable: this.selectedCalculo.libroContable,
        prefijo: this.selectedCalculo.prefijo,
        centroCosto: this.selectedCalculo.centroCosto,
        observaciones: this.selectedCalculo.observaciones,
      });
      this.anioSeleccionado = parseInt(this.selectedCalculo.periodoContable.substring(0, 4), 10);
      this.mesSeleccionado = parseInt(this.selectedCalculo.periodoContable.substring(4, 6), 10);
    }
  }

  isContabilizado(): boolean {
    return (
      this.selectedCalculo && this.selectedCalculo.gar_estado === 'Contabilizado'
    );
  }

  async abrirModalAsiento() {
    if (!this.selectedCalculo || !this.selectedCalculo.gar_nro_asiento_cont) return;

    const asientoData = this.selectedCalculo.asientoData || [
      { cuentaContable: '1510.02', descripcion: 'Equipos de cocina - Revaluación', debe: 600.00, credito: 0.00},
      { cuentaContable: '3810.01', descripcion: 'Revaluación por equis motivo', debe: 0.00, credito: 600.00},
    ];

    const colDefs: ColDef[] = [
      {  field: 'cuentaContable',  headerName: 'Cuenta contable',  width: 130 },
      {  field: 'descripcion',  headerName: 'Descripción',  width: 150, flex: 1,},
      {  field: 'debe',  headerName: 'Débito',  width: 80, headerClass: 'centrarencabezado',
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
      {  field: 'credito',  headerName: 'Crédito',  width: 80, headerClass: 'centrarencabezado',
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
      }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Asiento Contable: ${this.selectedCalculo.gar_nro_asiento_cont}`,
        widthModal: '700px',
        mostrarTabla: true,
        colDefs: colDefs,
        rowData: asientoData,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        ocultarBotonConfirmar: true,
        textoBotonCancelar: 'Cerrar'
      },
    });

    await modal.present();
  }

  // Método llamado por VistaCellRenderComponent al hacer clic en el ojo
  async abrirModal(nroAsiento: string, rowData: any) {
    if (!nroAsiento || nroAsiento === '-') return;

    const asientoData = rowData.asientoData || [
      { cuentaContable: '1510.02', descripcion: 'Equipos de cocina - Revaluación', debe: 600.00, credito: 0.00,},
      { cuentaContable: '3810.01', descripcion: 'Revaluación por equis motivo', debe: 0.00, credito: 600.00,},
    ];

    const colDefs: ColDef[] = [
      {  field: 'cuentaContable',  headerName: 'Cuenta contable',  width: 130 },
      {  field: 'descripcion',  headerName: 'Descripción',  width: 150, flex: 1,},
      {  field: 'debe',  headerName: 'Débito',  width: 80, headerClass: 'centrarencabezado',
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
      { field: 'credito', headerName: 'Crédito', width: 80, headerClass: 'centrarencabezado',
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
      }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Asiento Contable: ${nroAsiento}`,
        widthModal: '740px',
        mostrarTabla: true,
        colDefs: colDefs,
        rowData: asientoData,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        ocultarBotonConfirmar: true,
        textoBotonCancelar: 'Cerrar'
      },
    });

    await modal.present();
  }

  private updateFormDisabledState() {
    if (!this.formRevaluacion) return;

    const requiredControls = [
      'tipoRevaluacion',
      'origenDatos',
      'tipoMoneda',
      'fechaContabilizacion',
      'libroContable',
    ];
    const keepEnabledControls = ['prefijo', 'centroCosto', 'observaciones'];

    if (this.isContabilizado()) {
      // habilitar los campos requeridos y mantener habilitados los controles que el usuario indicó
      requiredControls.forEach((name) => {
        const c = this.formRevaluacion.get(name);
        if (c) c.enable({ emitEvent: false });
      });
      keepEnabledControls.forEach((name) => {
        const c = this.formRevaluacion.get(name);
        if (c) c.enable({ emitEvent: false });
      });
    this.formRevaluacion.get('fechaRegistro')?.disable();
      // si hay otros controles nuevos que deberían permanecer en su estado, no los tocamos
    } else {
      // habilitar todos los controles cuando NO está contabilizado
      Object.keys(this.formRevaluacion.controls).forEach((name) => {
        const c = this.formRevaluacion.get(name);
        if (c) c.enable({ emitEvent: false });
      });
    this.formRevaluacion.get('fechaRegistro')?.disable();

    }
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  onMonthYearChange(event: any) {
    console.log('Mes/Año seleccionado:', event);
    this.mesSeleccionado = event.month;
    this.anioSeleccionado = event.year;
  }
  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos
    this.cargarDatos(range.start, range.end);
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }

  // Para modo SINGLE - Manejo de fechas seleccionadas
  onFechaRegistro(date: Date) {
    console.log('Fecha registro:', date);
    this.fechaRegistro = date;
  }

  onFechaContabilizacion(date: Date) {
    console.log('Fecha ejecucion:', date);
    this.fechaContabilizacion = date;
  }

  // async contabilizar() {
  //     console.log('Contabilizar cálculo:', this.selectedCalculo);

  //     const modal = await this.modalController.create({
  //       component: ModalAsientoContableComponent,
  //       cssClass: 'modal-asiento-contable',
  //       componentProps: {
  //         nroAsiento: this.selectedCalculo?.nroAsientoCont || 'AS-2025-09-003',
  //         asientoData: []
  //       }
  //     });

  //     await modal.present();
  //   }

  //   exportar() {
  //     console.log('Exportar cálculo:', this.selectedCalculo);
  //     // Aquí iría la lógica para exportar
  //   }

  onBtReset() {
    this.facade.cargarAsientos();
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
        titulo: 'Historial de Actualizaciones - Asientos de Revaluación',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
  
      },
    });

    await modal.present();
  }
    
  /**
   * Guarda el estado actual del formulario como estado inicial
   */
  private guardarEstadoInicial() {
    this.formularioInicial = this.formRevaluacion ? this.formRevaluacion.value : null;
  }
  
  /**
   * Verifica si hubo cambios en el formulario comparando el estado actual con el inicial
   */
  private verificarCambios() {
    if (!this.formularioInicial || !this.formRevaluacion) {
      this.formularioModificado = false;
      return;
    }
    
    const valorActual = this.formRevaluacion.value;
    this.formularioModificado = JSON.stringify(this.formularioInicial) !== JSON.stringify(valorActual);
  }
  
  /**
   * Muestra el modal de confirmación cuando hay cambios sin guardar
   * @returns Promise<boolean> - true si el usuario confirma, false si cancela
   */
  private async mostrarModalConfirmacion(): Promise<boolean> {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Continuar sin guardar',
        title: '¿Seguro que quieres continuar sin guardar la información?',
        message: 'Si sales ahora, perderás los cambios realizados en el asiento de revaluación',
        btnOkTxt: 'Continuar',
        btnCancelTxt: 'Cancelar',
      }
    });
    
    await modal.present();
    const { data } = await modal.onWillDismiss();
    
    return data === true;
  }
  
  /**
   * Método requerido por CanDeactivate guard
   * Previene que el usuario abandone la pantalla sin guardar cambios
   */
  async canDeactivate(): Promise<boolean> {
    if (this.formularioModificado) {
      return await this.mostrarModalConfirmacion();
    }
    return true;
  }
}
