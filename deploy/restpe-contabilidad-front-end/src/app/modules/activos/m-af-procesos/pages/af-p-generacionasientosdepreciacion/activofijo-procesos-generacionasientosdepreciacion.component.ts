import { Component, OnInit, effect, inject } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalController } from '@ionic/angular';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { GeneracionAsientosDepreciacionFacade } from '../../../application/facades/generacion-asientos-depreciacion.facade';
import { GeneracionAsientosDepreciacionEntity } from '../../../domain/models/generacion-asientos-depreciacion.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-activofijo-procesos-generacionasientosdepreciacion',
  templateUrl: './activofijo-procesos-generacionasientosdepreciacion.component.html',
  styleUrls: ['./activofijo-procesos-generacionasientosdepreciacion.component.scss'],
  standalone: false
})
export class ActivofijoProcesosGeneracionasientosdepreciacionComponent implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;




    //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  
  //FECHAS ÚNICAS (SINGLE)
  fechaContabilizacion: Date | undefined;
  fechaActual: Date = new Date();
  minDateContabilizacion: Date;
  

  panelLateralVisible = true;
  mesSeleccionado: number | null = null;
  anioSeleccionado: number | null = null;
  esContabilizado: boolean = true;

  // Formulario reactivo
  asientoForm!: FormGroup;
  filaSeleccionada: any = null;
  // AG-Grid
  private gridApi!: GridApi;
  context: any;

  readonly facade = inject(GeneracionAsientosDepreciacionFacade);
  rowData: GeneracionAsientosDepreciacionEntity[] = [];

  colDefs: ColDef<GeneracionAsientosDepreciacionEntity>[] = [
    { field: 'gad_codigo', headerName: 'Código', flex: 1 },
    { field: 'gad_periodo', headerName: 'Periodo', flex: 1 },
    { field: 'gad_fecha_ejecucion', headerName: 'Fecha ejecución', flex: 1,
      valueFormatter: (params) => {
        if (params.value) {
          const date = new Date(params.value);
          return date.toLocaleDateString('es-PE', { day: '2-digit', month: '2-digit', year: 'numeric' });
        }
        return '';
      },
    },
    { field: 'gad_activos', headerName: 'Activos', flex: 1 },
    { field: 'gad_moneda', headerName: 'Moneda', flex: 1 },
    { field: 'gad_usuario_resp', headerName: 'Usuario que registró', flex: 1 },
    { field: 'gad_dpc_total', headerName: 'Costo de adquisición', flex: 1, headerClass: 'derechaencabezado', cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end' },
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
      }, },
    { field: 'gad_valor_cont', headerName: 'Valor contable', flex: 1, headerClass: 'derechaencabezado', cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end' },
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
      }, },
    {
      field: 'gad_nro_asiento_cont',
      headerName: 'Asiento Contable',
      flex: 1,
      cellRenderer: VistaCellRenderComponent,
    },
    { 
      field: 'gad_estado', 
      headerName: 'Estado', filter: true,
      flex: 1, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-[#363636]">Pendiente</span>';
        } else if (params.value === 'Contabilizado') {
          return '<span class="badge-table bg-[#D6E6FF] text-primary">Contabilizado</span>';
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

  constructor(private modalController: ModalController,
      private toastservice: ToastService,
      private fb: FormBuilder) {
     const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate()); 
    this.minDateContabilizacion = today;

    this.context = { componentParent: this };

    effect(() => {
      this.rowData = [...this.facade.asientos()].reverse();
    });
   }

  ngOnInit() {
    this.asientoForm = this.fb.group({
      periodoContable: [{ value: '', disabled: true }],
      fechaGeneracion: [{ value: '', disabled: true }],
      tipoCalculo: [{ value: '', disabled: true }],
      tipoDepreciacion: [{ value: '', disabled: true }],
      metodoCalculo: [{ value: '', disabled: true }],
      fechaContabilizacion: [''],
      prefijoDoc: [''],
      observaciones: [''],
    });

    this.facade.cargarAsientos();
  }

  private llenarFormulario(data: GeneracionAsientosDepreciacionEntity) {
    if (!data) return;

    const fechaGen = data.gad_fecha_ejecucion
      ? new Date(data.gad_fecha_ejecucion).toLocaleDateString('es-PE', { day: '2-digit', month: '2-digit', year: 'numeric' })
      : '';

    this.asientoForm.patchValue({
      periodoContable: data.gad_periodo || '',
      fechaGeneracion: fechaGen,
      tipoCalculo: data.gad_tipo_calculo || '',
      tipoDepreciacion: data.gad_tipo_depreciacion || '',
      metodoCalculo: data.gad_metodo_calculo || '',
      fechaContabilizacion: data.gad_fecha_contabilizacion || '',
      prefijoDoc: data.gad_prefijo_doc || '',
      observaciones: data.gad_observaciones || '',
    });

    this.esContabilizado = data.gad_estado === 'Contabilizado';

    // Habilitar/deshabilitar campos editables según estado
    if (this.esContabilizado) {
      this.asientoForm.get('fechaContabilizacion')?.disable();
      this.asientoForm.get('prefijoDoc')?.disable();
      this.asientoForm.get('observaciones')?.disable();
    } else {
      this.asientoForm.get('fechaContabilizacion')?.enable();
      this.asientoForm.get('prefijoDoc')?.enable();
      this.asientoForm.get('observaciones')?.enable();
    }

    // Calcular minDateContabilizacion
    const fechaEjecucion = new Date(data.gad_fecha_ejecucion);
    const hoy = new Date();
    this.minDateContabilizacion = fechaEjecucion > hoy ? fechaEjecucion : hoy;

    // Actualizar fecha del calendar si viene del JSON
    if (data.gad_fecha_contabilizacion) {
      this.fechaContabilizacion = new Date(data.gad_fecha_contabilizacion);
      this.fechaActual = this.fechaContabilizacion;
    } else {
      this.fechaContabilizacion = undefined;
      this.fechaActual = new Date();
    }

    this.filaSeleccionada = data;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;

  }

  onCellClicked(event: any) {
    // Deseleccionar todas las filas primero
    this.gridApi.deselectAll();
    
    // Seleccionar la fila clickeada
    event.node.setSelected(true);
    
    this.llenarFormulario(event.data);
  }

  async abrirModal(nroAsiento: string, rowData: any) {
    if (!nroAsiento || nroAsiento === '-') return;

    // Si filaSeleccionada es null (clic directo en el ojo sin seleccionar fila), usar rowData
    const source = this.filaSeleccionada ?? rowData;

    // Datos de ejemplo del asiento contable
    const asientoData = source?.asientoData || [
      {
        cuentaContable: '6810.02',
        descripcion: 'Equipos de cocina - Depreciación',
        debito: 600.00,
        credito: 0.00
      },
      {
        cuentaContable: '3910.01',
        descripcion: 'Depreciación por equis motivo',
        debito: 0.00,
        credito: 600.00
      }
    ];

    // Definir columnas para la tabla de asientos
    const colDefs: ColDef[] = [
      { 
        field: 'cuentaContable', 
        headerName: 'Cuenta contable', 
        width: 130 
      },
      { 
        field: 'descripcion', 
        headerName: 'Descripción', 
        width: 150,
        flex: 1,
      },
      { 
        field: 'debito', 
        headerName: 'Debe', 
        width: 80,
        headerClass: 'centrarencabezado',
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
        field: 'credito', 
        headerName: 'Haber', 
        width: 80,
        headerClass: 'centrarencabezado',
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
        mostrarTotales: true,
        totalDebe: new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(
          asientoData.reduce((sum: number, item: any) => sum + item.debito, 0)
        ),
        totalHaber: new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(
          asientoData.reduce((sum: number, item: any) => sum + item.credito, 0)
        ),
        textoBotonCancelar: 'Cerrar',
      }
    });

    await modal.present();
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  onMonthYearChange(event: {month: number, year: number}) {
    this.mesSeleccionado = event.month;
    this.anioSeleccionado = event.year;
  }

  async contabilizar() {
    if (!this.filaSeleccionada) return;

    // Validar que se haya seleccionado fecha de contabilización
    if (!this.fechaContabilizacion) {
      this.toastservice.warning('Debe seleccionar una fecha de contabilización');
      return;
    }

    // Generar número de asiento contable
    const numeroAsiento = `AS-${new Date().getFullYear()}-${String(new Date().getMonth() + 1).padStart(2, '0')}-${String(Math.floor(Math.random() * 1000)).padStart(3, '0')}`;

    // Formatear fecha contabilización a YYYY-MM-DD
    const fc = this.fechaContabilizacion;
    const fechaStr = `${fc.getFullYear()}-${String(fc.getMonth() + 1).padStart(2, '0')}-${String(fc.getDate()).padStart(2, '0')}`;

    // Actualizar el registro
    const registroActualizado: GeneracionAsientosDepreciacionEntity = {
      ...this.filaSeleccionada,
      gad_estado: 'Contabilizado',
      gad_nro_asiento_cont: numeroAsiento,
      gad_fecha_contabilizacion: fechaStr,
    };

    this.facade.actualizarAsiento(registroActualizado);

    // Actualizar la fila en rowData para refrescar la tabla
    const idx = this.rowData.findIndex(r => r.gad_codigo === this.filaSeleccionada.gad_codigo);
    if (idx !== -1) {
      this.rowData[idx] = registroActualizado;
    }

    // Refrescar la tabla
    if (this.gridApi) {
      this.gridApi.refreshCells({ force: true });
    }

    // Recargar formulario con estado actualizado
    this.llenarFormulario(registroActualizado);

    this.toastservice.success('Cálculo contabilizado correctamente');
  }

  exportar() {
    console.log('Exportar cálculo:', this.filaSeleccionada);
    // Aquí iría la lógica para exportar
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
  onFechaContabilizacion(date: Date) {
    console.log('Fecha contabilizacion:', date);
    this.fechaContabilizacion = date;
  }

   onBtReset() {
    this.facade.cargarAsientos();
  }

  botonCancelar(){
    this.filaSeleccionada = null;
    this.asientoForm.reset({
      fechaContabilizacion: new Date(),
    });
    this.gridApi.deselectAll();
  }
    
  async modalverActualizaciones() {
    // Definir las columnas
    const colDefs = [
      { 
        headerName: 'Fecha y hora', 
        field: 'fechaHora',
        width: 150
      },
      { 
        headerName: 'Usuario', 
        field: 'usuario',
        width: 120
      },
      { 
        headerName: 'Acción', 
        field: 'accion',
        width: 150
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
        detalleCambio: 'Registro inicial del tipo de cambio para Dólar'
      },
      {
        fechaHora: '21/11/2025 09:05',
        usuario: 'Carlos Zapata',
        accion: 'Actualización',
        detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385'
      },
      {
        fechaHora: '20/11/2025 08:30',
        usuario: 'Carlos Zapata',
        accion: 'Creación',
        detalleCambio: 'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380'
      },
      {
        fechaHora: '19/11/2025 08:45',
        usuario: 'Carlos Zapata',
        accion: 'Creación',
        detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT'
      }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - Tipo de Cambio',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
        
      }
    });
    
    await modal.present();
  }
  
}
