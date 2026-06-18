import { Component, OnInit, inject } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent, IRichCellEditorParams } from 'ag-grid-community';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { AccesorioActionsCellComponent } from '../af-o-asignacionratios/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { RecepcionTrasladoFacade } from '../../../application/facades/recepcion-traslado.facade';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-af-o-recept-traslados-af',
  templateUrl: './af-o-recept-traslados-af.component.html',
  styleUrls: ['./af-o-recept-traslados-af.component.scss'],
  standalone: false,
})
export class AfOReceptTrasladosAfComponent implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  filaSeleccionada: any = null;

// Estado para los botones de aprobar/rechazar activos
  activosSeleccionados: any[] = [];
  botonesActivosHabilitados(): boolean {
    return this.activosSeleccionados.length > 0;
  }

  onActivosTrasladoSelectionChanged(event: any): void {
    if (event && event.api) {
      this.activosSeleccionados = event.api.getSelectedRows();
    } else {
      this.activosSeleccionados = [];
    }
  }

  // Campos del formulario de traslado
  origen: string = '';
  destino: string = '';
  fechaRecepcion: Date | undefined;
  observaciones: string = '';

  onFechaRecepcion(date: Date) {
    this.fechaRecepcion = date;
  }

  guardarTraslado() {
    if (!this.filaSeleccionada) return;
    
    // Actualizar el estado de la fila seleccionada a "Aprobado"
    this.filaSeleccionada.traslado_estado = 'Aprobado';
    
    // Actualizar la fecha de recepción si se registró una
    if (this.fechaRecepcion) {
      const dia = String(this.fechaRecepcion.getDate()).padStart(2, '0');
      const mes = String(this.fechaRecepcion.getMonth() + 1).padStart(2, '0');
      const anio = this.fechaRecepcion.getFullYear();
      this.filaSeleccionada.traslado_fecha_recepcion = `${dia}/${mes}/${anio}`;
    }
    
    // Refrescar la tabla para mostrar los cambios
    this.gridApi.applyTransaction({ update: [this.filaSeleccionada] });
    
    this.toastService.success('¡Traslado aprobado exitosamente!');
  }

  /**
   * rechazar la revaluación seleccionada
   */
  async rechazarrRevaluacion() {
    if (!this.filaSeleccionada) return;
        
    const detallesEjemplo: DetalleItem[] = [
      { label: 'Cod. de traslado', value: this.filaSeleccionada.traslado_codigo },
      { label: 'Fecha recepción', value: this.filaSeleccionada.traslado_fecha_recepcion || '-' },
      { label: 'Origen', value: this.filaSeleccionada.traslado_origen },
      { label: 'Destino', value: this.filaSeleccionada.traslado_destino },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Rechazar traslado',
        subtitulomodal: 'Detalle de traslado',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Rechazar',
        colorBotonConfirmar: 'danger'
      }
    });

    await modal.present();
    
    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      // Actualizar el estado de la fila seleccionada a "Rechazado"
      this.filaSeleccionada.traslado_estado = 'Rechazado';
      
      // Refrescar la tabla para mostrar los cambios
      this.gridApi.applyTransaction({ update: [this.filaSeleccionada] });
      
      this.toastService.success('¡Traslado rechazado exitosamente!');
    }
  }
  //Fechas unicas
  fechaInicio: Date | undefined;
  fechaVencimiento: Date | undefined;


  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  panelLateralVisible = true;
  polizasProximasVencer = 1;
  selectedPoliza: any = null;
  selectedActivoId: any = null;
  disabledCancelar: boolean = false;
  disabledRenovar: boolean = false;
  disabledInputs: boolean = false;
  disabledGuardar: boolean = false;
  disabledCalendars: boolean = false;
  documentoSoporte: string = '';

  // Lista de activos para el autocomplete
  activosList = [
    { id: 1, nombre: 'Cocina Industrial', codigo: 'AF-001' },
    { id: 2, nombre: 'Mesa Plegable', codigo: 'AF-002' },
    { id: 3, nombre: 'Laptop', codigo: 'AF-003' },
    { id: 4, nombre: 'TV 43 pulgadas', codigo: 'AF-004' },
    { id: 5, nombre: 'Proyector', codigo: 'AF-005' },
    { id: 6, nombre: 'Cafetera', codigo: 'AF-006' },
  ];

  // Lista de compañías aseguradoras
  companiasList = [
    { id: 'rimac', nombre: 'Rímac Seguros' },
    { id: 'pacifico', nombre: 'Pacífico Seguros' },
    { id: 'positiva', nombre: 'Positiva Seguros' }
  ];

  // Lista de tipos de seguro
  tiposSeguroList = [
    { id: 'todo-riesgo', nombre: 'Todo Riesgo' },
    { id: 'incendio', nombre: 'Seguro contra incendios' },
    { id: 'maquinaria', nombre: 'Seguro de maquinaria' }
  ];

  // AG-Grid
  private gridApi!: GridApi;

  // Facade – fuente de datos reactiva
  private readonly recepcionTrasladoFacade = inject(RecepcionTrasladoFacade);

  /** Listado de traslados proveniente del JSON vía RecepcionTrasladoRepositoryImpl */
  readonly rowData          = this.recepcionTrasladoFacade.traslados;
  readonly isLoadingTraslados = this.recepcionTrasladoFacade.isLoading;

  colDefs: ColDef[] = [
    { field: 'traslado_codigo', headerName: 'Cód. de traslado', width: 130 },
    { field: 'traslado_fecha_recepcion', headerName: 'Fecha de recepción', width: 140 },
    { field: 'traslado_origen', headerName: 'Origen', width: 170 },
    { field: 'traslado_destino', headerName: 'Destino', width: 170 },
    { field: 'traslado_responsable', headerName: 'Responsable', width: 120 },
    {
      field: 'traslado_estado',
      headerName: 'Estado',
      width: 120,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        } else if (params.value === 'Aprobado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Aprobado</span>';
        } else if (params.value === 'Rechazado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Rechazado</span>';
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
  defaultColDef = {
    valueFormatter: (params:any) => {
      if (params.colDef.checkboxSelection) return params.value;
      return (params.value === null || params.value === undefined || params.value === '')
        ? '-'
        : params.value;
    }
  };

  // Lista de activos fijos para la segunda tabla (detalle de traslado)
  activosTraslado = [
    { codigo: 'AF-001', descripcion: 'Cocina Industrial', cantidadEnviada: 2, cantidadRecibida: 2, diferencia: 0, motivoDiferencia: '', estado: '' },
    { codigo: 'AF-045', descripcion: 'Laptop Dell', cantidadEnviada: 1, cantidadRecibida: 1, diferencia: 0, motivoDiferencia: '', estado: '' },
    { codigo: 'AF-324', descripcion: 'Escritorio', cantidadEnviada: 4, cantidadRecibida: 4, diferencia: 0, motivoDiferencia: '', estado: '' },
    { codigo: 'AF-341', descripcion: 'Sillas de escritorio', cantidadEnviada: 12, cantidadRecibida: 12, diferencia: 0, motivoDiferencia: '', estado: '' },
  ];

  colDefsActivosTraslado: ColDef[] = [
    { field: 'codigo', headerName: 'Cód. de activo fijo', width: 140, checkboxSelection: true },
    { field: 'descripcion', headerName: 'Descripción', flex: 1, minWidth: 200 },
    { field: 'cantidadEnviada', headerName: 'Cantidad enviada', width: 140, editable: true, },
    { field: 'cantidadRecibida', headerName: 'Cantidad recibida', width: 150, editable: true, },
    { field: 'diferencia', headerName: 'Diferencia', width: 100 },
    { field: 'motivoDiferencia', headerName: 'Motivo de diferencia', width: 170, editable: true, },
    {
      headerName: "Estado",
      field: "estado",
      editable: true,
      cellEditor: "agRichSelectCellEditor",
      cellEditorParams: {
        values: ["Bueno", "Dañado", "Faltante"],
      } as IRichCellEditorParams,
    },
  ];

  codigoPoliza: string = '';
  companiaSeleccionada: any = null;
  tipoSeguroSeleccionado: any = null;
  sumaAsegurada: string = '';
  monedaSeleccionada: string = '';
  primaTotal: string = '';
  deducible: string = '';
  tipoDeducible: string = '';
  beneficiario: string = '';

  constructor(
    private modalController: ModalController,
    private toastService: ToastService
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
    // Inicializar fecha de operación con hoy por defecto

  }

  ngOnInit() {
    // Cargar traslados desde el repositorio de datos (RecepcionTrasladoRepositoryImpl → JSON)
    this.recepcionTrasladoFacade.cargarTraslados();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    
    // Seleccionar el primer registro por defecto
    setTimeout(() => {
      const data = this.rowData();
      if (data && data.length > 0) {
        const firstNode = this.gridApi.getDisplayedRowAtIndex(0);
        if (firstNode) {
          firstNode.setSelected(true);
          this.filaSeleccionada = firstNode.data;
          
          // Cargar datos del primer registro en el formulario
          this.origen = firstNode.data.traslado_origen || '';
          this.destino = firstNode.data.traslado_destino || '';
          this.observaciones = '';
          
          // Parsear fecha si existe
          if (firstNode.data.traslado_fecha_recepcion && firstNode.data.traslado_fecha_recepcion !== '-') {
            const partes = firstNode.data.traslado_fecha_recepcion.split('/');
            if (partes.length === 3) {
              const dia = parseInt(partes[0], 10);
              const mes = parseInt(partes[1], 10) - 1;
              const anio = parseInt(partes[2], 10);
              this.fechaRecepcion = new Date(anio, mes, dia);
            }
          }
        }
      }
    }, 100);
  }

  onCellClicked(event: any) {
    this.filaSeleccionada = event.data;

    // Cargar datos en el formulario
    this.origen = event.data.traslado_origen || '';
    this.destino = event.data.traslado_destino || '';
    this.observaciones = '';
    
    // Parsear fecha si existe
    if (event.data.traslado_fecha_recepcion && event.data.traslado_fecha_recepcion !== '-') {
      const partes = event.data.traslado_fecha_recepcion.split('/');
      if (partes.length === 3) {
        const dia = parseInt(partes[0], 10);
        const mes = parseInt(partes[1], 10) - 1;
        const anio = parseInt(partes[2], 10);
        this.fechaRecepcion = new Date(anio, mes, dia);
      }
    } else {
      this.fechaRecepcion = undefined;
    }

    this.selectedPoliza = {
      ...event.data,
      sumaAsegurada: '10,000.00',
      primaTotal: '1,200.00'
    };

    // Actualizar estado de botones según el estado de la póliza
    this.updateButtonStates();
  }

  updateButtonStates() {
    if (this.selectedPoliza?.estado === 'Vence en 30 días') {
      this.disabledCancelar = false;
      this.disabledRenovar = false;
      this.disabledInputs = false;
      this.disabledGuardar = false;
      this.disabledCalendars = false;
    } else if (this.selectedPoliza?.estado === 'Vigente' && this.selectedPoliza?.estado === 'Vigente en 7 días') {
      this.disabledCancelar = false;
      this.disabledRenovar = true;
      this.disabledInputs = false;
      this.disabledGuardar = false;
      this.disabledCalendars = false;
    } else if (this.selectedPoliza?.estado === 'Vencida') {
      this.disabledCancelar = true;
      this.disabledRenovar = false;
      this.disabledInputs = true;
      this.disabledGuardar = true;
      this.disabledCalendars = true;
    } else if (this.selectedPoliza?.estado === 'Cancelada') {
      this.disabledCancelar = true;
      this.disabledRenovar = true;
      this.disabledInputs = true;
      this.disabledGuardar = true;
      this.disabledCalendars = true;
    } else {
      this.disabledCancelar = false;
      this.disabledRenovar = false;
      this.disabledInputs = false;
      this.disabledGuardar = false;
      this.disabledCalendars = false;
    }
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  onActivoSelected(activo: any) {
    console.log('Activo seleccionado:', activo);
    this.selectedActivoId = activo.id;
  }

  onCompaniaSelected(compania: any) {
    console.log('Compañía seleccionada:', compania);
  }

  onTipoSeguroSelected(tipo: any) {
    console.log('Tipo de seguro seleccionado:', tipo);
  }

  nuevaPoliza() {
    console.log('Nueva póliza');
    // Deseleccionar todas las filas
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    // Limpiar selección
    this.selectedPoliza = null;
    this.selectedActivoId = null;
    // Resetear estados de botones
    this.disabledCancelar = false;
    this.disabledRenovar = false;
    this.disabledInputs = false;
    this.disabledGuardar = false;
    this.disabledCalendars = false;
  }

  // Para modo SINGLE - Manejo de fecha seleccionada
  onFechaInicio(date: Date) {
    console.log('Fecha Inicio:', date);
    this.fechaInicio = date;
  }

  onFechaVenciemiento(date: Date) {
    console.log('Fecha Vencimiento:', date);
    this.fechaVencimiento = date;
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
    // Recarga datos desde el repositorio, lo que activa isLoadingTraslados()
    this.recepcionTrasladoFacade.cargarTraslados();
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

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos
    this.cargarDatos(range.start, range.end);
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }

}
