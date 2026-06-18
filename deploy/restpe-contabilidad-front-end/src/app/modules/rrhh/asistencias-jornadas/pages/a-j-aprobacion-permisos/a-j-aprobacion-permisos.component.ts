import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';

import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { RrHhAprobacionPermisosGridEffects } from 'src/app/modules/rrhh/effects/rr-hh-aprobacion-permisos-grid.effect';
import { PermisoEntity } from 'src/app/modules/rrhh/domain/models/permiso.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';




@Component({
  selector: 'app-a-j-aprobacion-permisos',
  templateUrl: './a-j-aprobacion-permisos.component.html',
  styleUrls: ['./a-j-aprobacion-permisos.component.scss'],
  standalone: false,
})
export class AJAprobacionPermisosComponent implements OnInit {
  // Facades y Effects
  private readonly rrHhFacade = inject(RrHhFacade);
  private readonly aprobacionGridEffects = inject(RrHhAprobacionPermisosGridEffects);

  // Selectores del store
  readonly isLoading = this.rrHhFacade.loadingPermisos;
  isResetting = false;

  get rowData(): PermisoEntity[] {
    return this.aprobacionGridEffects.getRowData();
  }

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  // RANGO DE FECHAS

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private gridApi!: GridApi;
  PermisoForm!: FormGroup;
  filaSeleccionada: any = null; 
  botonesHabilitados = false;

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
  columnTypes = {
    currency: { 
        width: 150,
    },
    shaded: {
        cellClass: 'shaded-class'
    }
  };
  defaultColDef = {
    resizable: true,
    flex: 1,
    minWidth: 100,
  };
  //  Tipado con la misma interfaz
  colDefs: ColDef<PermisoEntity>[] = [
    { field: 'permiso_codigo', headerName: 'Código', width: 110 },
    { field: 'permiso_trabajador', headerName: 'Trabajador', width: 140, filter: true },
    { field: 'permiso_sucursal', headerName: 'Sucursal', width: 140, filter: true },
    { field: 'permiso_centro_costo', headerName: 'Centro de costo', width: 150, filter: true },
    { field: 'permiso_motivo', headerName: 'Motivo', width: 140 },
    { field: 'permiso_tipo', headerName: 'Tipo de permiso', width: 150, filter: true },
    { field: 'permiso_tiempo_permiso', headerName: 'Tiempo de permiso', width: 140, filter: true },
    // { field: 'permiso_fecha_inicio', headerName: 'Fecha de inicio', width: 120,
    //   valueFormatter: (params: any) => {
    //     if (!params.value) return '';
    //     const date = new Date(params.value);
    //     const year = date.getFullYear();
    //     const month = String(date.getMonth() + 1).padStart(2, '0');
    //     const day = String(date.getDate() + 1).padStart(2, '0');
    //     return `${day}/${month}/${year}`;
    //   }
    // },
    // { field: 'permiso_fecha_fin', headerName: 'Fecha de fin ', width: 120,
    //   valueFormatter: (params: any) => {
    //     if (!params.value) return '';
    //     const date = new Date(params.value);
    //     const year = date.getFullYear();
    //     const month = String(date.getMonth() + 1).padStart(2, '0');
    //     const day = String(date.getDate() +1).padStart(2, '0');
    //     return `${day}/${month}/${year}`;
    //   }
    // },
    { field: 'permiso_estado', headerName: 'Estado', headerClass:'centrarencabezado', width: 100, filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Aprobado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Aprobado</span>';
        } else if (params.value === 'Rechazado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Rechazado</span>';
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        }
        return params.value;
      }
    }
  ];
  
  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController
  ) {
    this.minDate = new Date(2020, 0, 1);
    this.maxDate = new Date();
  }

  ngOnInit() {
    // Cargar permisos desde el JSON a través de la capa de infraestructura
    this.rrHhFacade.cargarPermisos();

    this.PermisoForm = this.formBuilder.group({
      permiso_trabajador: [{ value: '', disabled: true }, Validators.required],
      permiso_sucursal: [{ value: '', disabled: true }, Validators.required],
      permiso_centro_costo: [{ value: '', disabled: true }, Validators.required],
      permiso_tipo: [{ value: '', disabled: true }, Validators.required],
      permiso_motivo: [{ value: '', disabled: true }, Validators.required],
      permiso_tiempo_permiso: [{ value: '', disabled: true }, Validators.required],
      permiso_fecha_inicio: [{ value: '', disabled: true }],
      permiso_fecha_fin: [{ value: '', disabled: true }],
      fechaP: [{ value: '12/2/2021', disabled: true }],
      permiso_hora_inicio: [{ value: '', disabled: true }],
      permiso_hora_fin: [{ value: '', disabled: true }],
      permiso_estado: [{ value: 'Pendiente', disabled: true }, Validators.required],
    });
  }
  
  filtrarPorFechas(range: { start: Date; end: Date }): void {
    this.startDate = range.start;
    this.endDate = range.end;
  }

  onCellClicked(event: any) {
    const data = event.data;
    
    // Prevenir selección automática de AG-Grid
    event.node.setSelected(false);

    // Cargar datos del registro seleccionado
    this.cargarDatosRegistro(data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: any, node?: any): void {
    this.filaSeleccionada = data;
    this.gridApi.deselectAll();

    // Seleccionar el nodo en AG-Grid
    if (node) {
      node.setSelected(true);
    } else {
      this.gridApi.forEachNode((n) => {
        if (n.data === data) {
          n.setSelected(true);
        }
      });
    }

    // Llenar los campos del formulario con los datos de la fila
    this.PermisoForm.patchValue({
      permiso_trabajador: data.permiso_trabajador || '',               
      permiso_sucursal: data.permiso_sucursal || '',                   
      permiso_centro_costo: data.permiso_centro_costo || '',
      permiso_tipo: data.permiso_tipo || '',
      permiso_motivo: data.permiso_motivo || '',
      permiso_tiempo_permiso: data.permiso_tiempo_permiso || '',
      permiso_fecha_inicio: data.permiso_fecha_inicio || '',
      permiso_fecha_fin: data.permiso_fecha_fin || '',
      permiso_hora_inicio: data.permiso_hora_inicio || '',
      permiso_hora_fin: data.permiso_hora_fin || '',
      permiso_estado: data.permiso_estado || 'Pendiente'
    });

    // Habilitar botones solo si el estado es Pendiente
    this.botonesHabilitados = data.permiso_estado === 'Pendiente';
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.aprobacionGridEffects.setGridApi(params.api);
  }

  onFirstDataRendered(): void {
    const firstNode = this.gridApi.getDisplayedRowAtIndex(0);
    if (firstNode) {
      firstNode.setSelected(true);
      this.cargarDatosRegistro(firstNode.data, firstNode);
    }
  }

  onBtReset() {
    this.isResetting = true;
    this.rrHhFacade.cargarPermisos();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.isResetting = false;
      }
    }, 100);
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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del permiso'},
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de fecha de inicio'},
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - ' + this.filaSeleccionada.permiso_codigo,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });
    
    await modal.present();
  }

  botonAprobar() {
    if (!this.filaSeleccionada) {
      return;
    }

    // Actualizar el estado y filtrar solo Pendiente en la grilla
    const currentData = this.aprobacionGridEffects.getRowData();
    const index = currentData.findIndex((item: PermisoEntity) => item.permiso_codigo === this.filaSeleccionada.permiso_codigo);
    if (index !== -1) {
      const updatedData = [...currentData];
      updatedData[index] = { ...updatedData[index], permiso_estado: 'Aprobado' };
      const soloPendientes = updatedData.filter((item) => item.permiso_estado === 'Pendiente');
      this.aprobacionGridEffects.setRowData(soloPendientes);
    }

    this.toastService.success('¡Permiso aprobado exitosamente!');
    this.limpiarFormulario();
  }

  async botonRechazar() {
    if (!this.filaSeleccionada) {
      return;
    }

    // Formatear fechas para mostrar en el modal
    const formatearFecha = (fecha: string) => {
      if (!fecha) return '-';
      const date = new Date(fecha);
      const day = String(date.getDate() + 1).padStart(2, '0');
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const year = date.getFullYear();
      return `${day}/${month}/${year}`;
    };

    const detalles: DetalleItem[] = [
      { label: 'Trabajador', value: this.filaSeleccionada.permiso_trabajador },
      { label: 'Fecha inicio', value: formatearFecha(this.filaSeleccionada.permiso_fecha_inicio) },
      { label: 'Fecha fin', value: formatearFecha(this.filaSeleccionada.permiso_fecha_fin) },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Rechazar permiso',
        subtitulomodal: 'Detalle del permiso:',
        detalles: detalles,
        mostrarTextarea: true,
        motivoObligatorio: true,
        tituloTextarea: 'Motivo del rechazo:',
        placeholderTextarea: 'Describe el motivo del rechazo del permiso',
        textoBotonConfirmar: 'Rechazar',
        colorBotonConfirmar: 'danger',
        validarTextarea: true
      }
    });

    await modal.present();
    
    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar' && data.motivo) {
      // Actualizar el estado a través del effect
      const currentData = this.aprobacionGridEffects.getRowData();
      const index = currentData.findIndex((item: PermisoEntity) => item.permiso_codigo === this.filaSeleccionada.permiso_codigo);
      if (index !== -1) {
        const updatedData = [...currentData];
        updatedData[index] = { ...updatedData[index], permiso_estado: 'Rechazado', permiso_motivo: `${updatedData[index].permiso_motivo} - Rechazo: ${data.motivo}` };
        const soloPendientes = updatedData.filter((item) => item.permiso_estado === 'Pendiente');
        this.aprobacionGridEffects.setRowData(soloPendientes);
      }

      this.toastService.success('¡Permiso rechazado exitosamente!');
      this.limpiarFormulario();
    }
  }

  private limpiarFormulario(): void {
    this.filaSeleccionada = null;
    this.botonesHabilitados = false;
    this.gridApi?.deselectAll();
    this.PermisoForm.patchValue({
      permiso_trabajador: '',
      permiso_sucursal: '',
      permiso_centro_costo: '',
      permiso_tipo: '',
      permiso_motivo: '',
      permiso_tiempo_permiso: '',
      permiso_fecha_inicio: '',
      permiso_fecha_fin: '',
      permiso_hora_inicio: '',
      permiso_hora_fin: '',
      permiso_estado: ''
    });
  }

}
