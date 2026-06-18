import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import {Component, OnInit, inject} from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalController, ViewWillEnter } from '@ionic/angular';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { Observable } from 'rxjs';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

// Facades
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';

interface CanComponentDeactivate {
  canDeactivate: () => Observable<boolean> | Promise<boolean> | boolean;
}

interface ActualizacionHistorial {
  fechaHora: string;
  usuario: string;
  accion: string;
  detalleCambio: string;
}

@Component({
  selector: 'app-a-o-recepcion',
  templateUrl: './a-o-recepcion.component.html',
  styleUrls: ['./a-o-recepcion.component.scss'],
  standalone: false,
})
export class AoRecepcionComponent implements OnInit, ViewWillEnter {
  // Facades
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Acceso al facade desde el template
  protected readonly facade = this.almacenFacade;

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.isLoading;


  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  mostrartabla = true;
  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'a-o-recepcion'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }
  recepcionForm!: FormGroup;
  
  // Control de totales
  totalSolicitada: number = 0;
  totalRecibida: number = 0;
  diferencia: number = 0;
  ordenSeleccionada: boolean = false;
  recepcionConfirmada: boolean = false;
  filaSeleccionada:any=null;
  
  // Variables para validación de formulario
  private recepcionFormInicial: any = null;
  private formularioModificado: boolean = false;
  private recepcionSeleccionada: any = null;

  // Variable para persistir la selección cuando se oculta/muestra la tabla
  private recepcionSeleccionadaData: any = null;

  // Historial de actualizaciones por transferencia (simulando base de datos)
  historialPorTransferencia: { [key: string]: ActualizacionHistorial[] } = {
    'T001-2025': [
      {
        fechaHora: '21/11/2025 10:30:15',
        usuario: 'Ana Pérez',
        accion: 'Confirmación de recepción',
        detalleCambio: 'Recepción completa. Total recibido: 100 unidades.'
      },
      {
        fechaHora: '20/11/2025 09:15:00',
        usuario: 'Jorge Gómez',
        accion: 'Registro de transferencia',
        detalleCambio: 'Se registró la transferencia inicial desde Almacén Principal.'
      }
    ],
    'T002-2025': [
      {
        fechaHora: '21/11/2025 08:00:00',
        usuario: 'Carlos Ruiz',
        accion: 'Registro de transferencia',
        detalleCambio: 'Transferencia creada y enviada. Estado: Pendiente de recepción.'
      }
    ],
    'T003-2025': [
      {
        fechaHora: '22/11/2025 14:20:30',
        usuario: 'María López',
        accion: 'Confirmación de recepción',
        detalleCambio: 'Estado actualizado de "Pendiente" a "Total". Cantidad recibida: 100/100.'
      },
      {
        fechaHora: '19/11/2025 11:45:00',
        usuario: 'Pedro Sánchez',
        accion: 'Registro de transferencia',
        detalleCambio: 'Transferencia registrada desde Almacén Principal a Almacén Central.'
      }
    ],
    'T005-2025': [
      {
        fechaHora: '21/11/2025 16:45:22',
        usuario: 'Luis Torres',
        accion: 'Confirmación de recepción',
        detalleCambio: 'Estado actualizado de "Pendiente" a "Parcial". Cantidad recibida: 50/100. Diferencia: 50 unidades. Motivos registrados: Tomate: "Producto dañado en transporte"'
      },
      {
        fechaHora: '20/11/2025 10:00:00',
        usuario: 'Ana Pérez',
        accion: 'Registro de transferencia',
        detalleCambio: 'Transferencia creada. Total de 100 unidades.'
      }
    ]
  };

  sucursalesColDefs: ColDef[] = [
    { field: 'codigoArticulo', headerName: 'Código', width: 100 },
    { field: 'descripcion', headerName: 'Descripción', width: 150 },
    { field: 'unidadMedida', headerName: 'Unidad', width: 120 },
    { 
      field: 'cantidadSolicitada', 
      headerName: 'Cant. solicitada', 
      width: 130, 
      editable: false,
      cellStyle: { color: '#9CA3AF', textAlign: 'right', display: 'flex', justifyContent: 'flex-end', alignItems: 'center' }
    },
    { 
      field: 'cantidadEntregada', 
      headerName: 'Cant. entregada', 
      width: 130, 
      editable: true,
      cellEditor: 'agNumberCellEditor',
      valueParser: (params: any) => {
        const num = Number(params.newValue);
        return isNaN(num) ? 0 : num;
      },
      onCellValueChanged: (params: any) => this.onCantidadEntregadaChanged(params)
    },
    { 
      field: 'diferencia', 
      headerName: 'Diferencia', 
      width: 100, 
      editable: false,
      valueFormatter: (params: any) => {
        const val = params.value;
        if (val === null || val === undefined || isNaN(val)) {
          return '0';
        }
        return val.toString();
      }
    },
    { 
      field: 'estado', 
      headerName: 'Estado del producto', 
      headerClass: 'centrar-encabezado',
      cellEditor: 'agSelectCellEditor',
      cellEditorParams: { 
        values: ['Bueno', 'Dañado', 'Faltante'],
      },
      cellStyle: { textAlign: 'center', justifyContent: 'center', alignItems: 'center', cursor: 'pointer' },
      width: 120,
      editable: true,
      onCellValueChanged: (params: any) => {
        // Solo guardar el valor, sin refrescar nada
        params.data.estado = params.newValue;
      },
      cellRenderer: (params: any) => {
        if (!params.value) {
          return '';
        }
        let color = '';
        if (params.value === 'Bueno') {
          color = 'bg-[#DCFDE7] text-[#16A34A]';
        } else if (params.value === 'Dañado') {
          color = 'bg-[#FEE2E2] text-[#DC2626]';
        } else if (params.value === 'Faltante') {
          color = 'bg-[#FFF0BF] text-[#F2A626]';
        }
        return `<span class="badge-table ${color}">${params.value}</span>`;
      }
    },
    { field: 'motivoDiferencia', headerName: 'Motivo', width: 150, editable: true }
  ];

  sucursalesRowData: any[] = [];

  columnTypes = {
    default: {
      resizable: false,
      sortable: false,
      filter: false,
      floatingFilter: false,
    }
  };

  // Columnas principales
  colDefs: ColDef[] = [
    { field: 'recepcion_transferencia_nro', headerName: 'N° transferencia', width: 120 },
    { field: 'recepcion_transferencia_fecha_envio', headerName: 'Fecha envío', width: 110 },
    { field: 'recepcion_transferencia_fecha_recepcion', headerName: 'Fecha recepción', width: 110 },
    { field: 'recepcion_transferencia_cantidad_enviada', headerName: 'Cantidad enviada', width: 130 },
    { field: 'recepcion_transferencia_cantidad_recibida', headerName: 'Cantidad recibida', width: 130 },
    { field: 'recepcion_transferencia_diferencia', headerName: 'Diferencia', width: 90 },
    { field: 'recepcion_transferencia_origen', headerName: 'Origen', width: 140, filter: true },
    { field: 'recepcion_transferencia_destino', headerName: 'Destino', width: 140, filter: true },
    { 
      field: 'recepcion_transferencia_estado', 
      headerName: 'Estado', filter: true, 
      width: 100,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },

      cellRenderer: (params: any) => {
        let color = '';
        if (params.value === 'Total') {
          color = 'bg-[#DCFDE7] text-[#16A34A]';
        } else if (params.value === 'Parcial') {
          color = 'bg-[#FFF0BF] text-[#F57C00]';
        } else {
          color = 'bg-[#F5F5F5] text-[#363636]';
        }
        return `<span class="badge-table ${color}">${params.value}</span>`;
      }
    }
  ];

  // Datos de transferencias
  // La lista principal de recepciones de transferencia se gestiona a través del store (facade.recepcionesTransferencia)

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

  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController,
  ) { 
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  ngOnInit() {
    this.initForm();
  }

  ionViewWillEnter() {
    this.almacenFacade.cargarRecepcionesTransferencia();
  }

  initForm() {
    this.recepcionForm = this.formBuilder.group({
      ordenCompra: [{ value: '', disabled: true}],
      trasnferencia: [{ value: '', disabled: true}],
      origen: [{ value: '', disabled: true}],
      destino: [{ value: '', disabled: true}],
      fechaEntrega: [{ value: '', disabled: true}],
      localEntrega: [{ value: '', disabled: true}],
      estado: [{ value: '', disabled: true}]
    });

    // Guardar estado inicial del formulario
    this.recepcionFormInicial = this.recepcionForm.value;

    // Suscribirse a cambios en el formulario
    this.recepcionForm.valueChanges.subscribe(() => {
      this.verificarCambios();
    });
  }

  /**
   * Verifica si el formulario ha sido modificado
   */
  private verificarCambios() {
    if (!this.recepcionFormInicial) {
      this.formularioModificado = false;
      return;
    }
    
    const valorActual = this.recepcionForm.value;
    this.formularioModificado = JSON.stringify(this.recepcionFormInicial) !== JSON.stringify(valorActual);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;

    // Restaurar la selección cuando la tabla se muestra de nuevo
    if (this.recepcionSeleccionadaData) {
      setTimeout(() => {
        this.gridApi.deselectAll();
        this.gridApi.forEachNode((node) => {
          if (node.data.recepcion_transferencia_nro === this.recepcionSeleccionadaData.recepcion_transferencia_nro) {
            node.setSelected(true);
          }
        });
      }, 150);
    }
  }

  /**
   * Cargar datos de una fila del grid sin pasar el evento cellClicked
   */
  private cargarDatosFromNode(node: any): void {
    const data = node.data;
    const estado = data.recepcion_transferencia_estado;

    if (estado == 'Pendiente') {
      this.recepcionConfirmada = false;
    } else {
      this.recepcionConfirmada = true;
    }

    // Cargar datos de la recepción seleccionada
    this.recepcionSeleccionada = data;
    this.recepcionSeleccionadaData = data;
    this.filaSeleccionada = data;
    
    // Deseleccionar todas las filas y seleccionar esta
    this.gridApi.deselectAll();
    node.setSelected(true);
    
    console.log('Recepción seleccionada:', this.recepcionSeleccionada);

    const filaDatos = data;

    this.recepcionForm.patchValue({
      ordenCompra: filaDatos.recepcion_transferencia_nro,
      trasnferencia: filaDatos.recepcion_transferencia_nro,
      origen: filaDatos.recepcion_transferencia_origen,
      destino: filaDatos.recepcion_transferencia_destino,
      fechaEntrega: filaDatos.recepcion_transferencia_fecha_envio,
      localEntrega: filaDatos.recepcion_transferencia_fecha_recepcion,
      estado: filaDatos.recepcion_transferencia_estado
    });

    // Cargar datos de detalle
    this.sucursalesRowData = [
      {
        codigoArticulo: '0006',
        descripcion: 'Tomate',
        unidadMedida: 'Kilogramos',
        cantidadSolicitada: 50,
        cantidadEntregada: 0,
        diferencia: 50,
        motivoDiferencia: '-',
        estado: ''
      },
      {
        codigoArticulo: '0321',
        descripcion: 'Queso mozzarella',
        unidadMedida: 'Kilogramos',
        cantidadSolicitada: 45,
        cantidadEntregada: 0,
        diferencia: 45,
        motivoDiferencia: '-',
        estado: ''
      },
      {
        codigoArticulo: '0089',
        descripcion: 'Aceite vegetal',
        unidadMedida: 'Litros',
        cantidadSolicitada: 5,
        cantidadEntregada: 0,
        diferencia: 5,
        motivoDiferencia: '-',
        estado: ''
      }
    ];

    // Actualizar totales
    this.totalSolicitada = filaDatos.recepcion_transferencia_cantidad_enviada || 0;
    this.totalRecibida = filaDatos.recepcion_transferencia_cantidad_recibida || 0;
    this.diferencia = filaDatos.recepcion_transferencia_diferencia || 0;

    // Actualizar estado inicial
    this.recepcionFormInicial = this.recepcionForm.value;
    this.formularioModificado = false;

    this.ordenSeleccionada = true;
  }

  async onCellClicked(event: any) {
    this.filaSeleccionada = event.data;
    const data = event.data;
    
    // Prevenir selección automática
    event.node.setSelected(false);
    
    // Validar si hay cambios sin guardar
    if (this.formularioModificado) {
      const confirmar = await this.mostrarModalConfirmacion();
      
      if (!confirmar) {
        // Mantener selección anterior
        if (this.recepcionSeleccionada) {
          setTimeout(() => {
            this.gridApi.deselectAll();
            this.gridApi.forEachNode((node) => {
              if (node.data === this.recepcionSeleccionada) {
                node.setSelected(true);
              }
            });
          }, 0);
        } else {
          this.gridApi.deselectAll();
        }
        return;
      }
    }
    
    // Cargar datos de la fila seleccionada
    this.cargarDatosFromNode(event.node);
  }

  onCantidadEntregadaChanged(params: any) {
    const cantidadSolicitada = params.data.cantidadSolicitada;
    const cantidadEntregada = params.newValue || 0;
    const diferencia = cantidadSolicitada - cantidadEntregada;
    
    params.data.diferencia = diferencia;
    
    // Refrescar solo diferencia sin validar otros campos
    params.api.refreshCells({
      rowNodes: [params.node],
      columns: ['diferencia']
    });
    
    this.recalcularTotales();
  }

  recalcularTotales() {
    this.totalSolicitada = this.sucursalesRowData.reduce((sum, item) => sum + item.cantidadSolicitada, 0);
    this.totalRecibida = this.sucursalesRowData.reduce((sum, item) => sum + (item.cantidadEntregada || 0), 0);
    this.diferencia = this.totalSolicitada - this.totalRecibida;
  }

  onBtReset() {
    this.almacenFacade.cargarRecepcionesTransferencia();
  }

  async modalverActualizaciones() {
    if (!this.recepcionSeleccionada) {
      this.toastService.warning('Por favor seleccione una transferencia');
      return;
    }

    const nroTransferencia = this.recepcionSeleccionada.nroTransferencia;
    
    // Obtener historial específico de esta transferencia
    const historialTransferencia = this.historialPorTransferencia[nroTransferencia] || [];


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

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones de ${nroTransferencia}`,
        rowData: historialTransferencia,
        colDefs: colDefs,
        anchoModal: '700px',
       
      }
    });
    
    await modal.present();
  }

  confirmarRecepcion() {
    if (this.ordenSeleccionada && this.recepcionSeleccionada) {
      const formData = this.recepcionForm.getRawValue();
      const datosRecepcion = {
        ...formData,
        totalSolicitada: this.totalSolicitada,
        totalRecibida: this.totalRecibida,
        diferencia: this.diferencia,
        articulos: this.sucursalesRowData
      };
      
      console.log('Datos de recepción:', datosRecepcion);
      
      const nroTransferencia = this.recepcionSeleccionada.nroTransferencia;
      
      // Solo actualizar si el estado era "Pendiente"
      if (this.recepcionSeleccionada.estado === 'Pendiente') {
        // Actualizar el estado en la tabla principal
        this.recepcionSeleccionada.estado = 'Parcial';
        this.recepcionSeleccionada.cantidadRecibida = this.totalRecibida;
        this.recepcionSeleccionada.diferencia = this.diferencia;
        
        // Actualizar lista en el store
        const lista = [...this.facade.recepcionesTransferencia()];
        const index = lista.findIndex(item => 
          item.nroTransferencia === nroTransferencia
        );
        
        if (index !== -1) {
          lista[index] = { ...this.recepcionSeleccionada };
        }
        
        // Actualizar el store con la lista modificada
        this.almacenFacade.actualizarListaRecepcionesTransferencia(lista);
        
        // Actualizar el formulario
        this.recepcionForm.patchValue({
          estado: 'Parcial'
        });
        
        // Crear entrada en el historial
        const ahora = new Date();
        const fechaHora = `${ahora.toLocaleDateString('es-PE')} ${ahora.toLocaleTimeString('es-PE')}`;
        
        // Construir detalle del cambio con motivos
        let detalleMotivos = '';
        const articulosConMotivo = this.sucursalesRowData.filter(art => 
          art.motivoDiferencia && art.motivoDiferencia !== '-'
        );
        
        if (articulosConMotivo.length > 0) {
          detalleMotivos = ' Motivos registrados: ' + articulosConMotivo.map(art => 
            `${art.descripcion}: "${art.motivoDiferencia}"`
          ).join(', ');
        }
        
        const nuevaActualizacion: ActualizacionHistorial = {
          fechaHora: fechaHora,
          usuario: 'Usuario Actual', // Aquí deberías obtener el usuario logueado
          accion: 'Confirmación de recepción',
          detalleCambio: `Estado actualizado de "Pendiente" a "Parcial". Cantidad recibida: ${this.totalRecibida}/${this.totalSolicitada}. Diferencia: ${this.diferencia} unidades.${detalleMotivos}`
        };
        
        // Inicializar historial si no existe
        if (!this.historialPorTransferencia[nroTransferencia]) {
          this.historialPorTransferencia[nroTransferencia] = [];
        }
        
        // Agregar al inicio del historial de esta transferencia
        this.historialPorTransferencia[nroTransferencia].unshift(nuevaActualizacion);
        
        console.log('Estado actualizado a Parcial');
        console.log('Nueva actualización registrada:', nuevaActualizacion);
        console.log('Historial completo:', this.historialPorTransferencia[nroTransferencia]);
      }
      
      // Resetear tracking de cambios después de guardar
      this.recepcionFormInicial = this.recepcionForm.value;
      this.formularioModificado = false;
      this.recepcionConfirmada= true;
      
      this.toastService.success('¡Recepción confirmada exitosamente!');
    } else {
      this.toastService.warning('Por favor seleccione una orden de compra');
    }
  }

  generarComp(){

    this.toastService.success('¡Comprobante generado exitosamente!');

  }

  /**
   * Muestra modal de confirmación cuando hay cambios sin guardar
   */
  private async mostrarModalConfirmacion(): Promise<boolean> {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Confirmar cambios',
        title: '¿Seguro que quieres continuar sin guardar la información?',
        message: 'Si sales ahora, perderás la información ingresada',
        btnOkTxt: 'Continuar',
        btnCancelTxt: 'Cancelar',
      }
    });
    
    await modal.present();
    const { data } = await modal.onWillDismiss();
    
    return data === true;
  }

  /**
   * Implementa CanComponentDeactivate para proteger navegación
   */
  async canDeactivate(): Promise<boolean> {
    if (this.formularioModificado) {
      return await this.mostrarModalConfirmacion();
    }
    return true;
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    console.log('Filtrar desde:', range.start, 'hasta:', range.end);
  }

  limpiarFormulario() {
    this.recepcionForm.reset();
    this.sucursalesRowData = [];
    this.totalSolicitada = 0;
    this.totalRecibida = 0;
    this.diferencia = 0;
    this.ordenSeleccionada = false;
    this.recepcionSeleccionada = null;
    this.recepcionFormInicial = this.recepcionForm.value;
    this.formularioModificado = false;
  }
}