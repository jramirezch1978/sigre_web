import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ConfiguracionFacade } from '../../application/facades/configuracion.facade';
import { PlantillaNotificacionEntity } from '../../domain/models/plantilla-notificacion.entity';
import { ConfiguracionGridEffects } from '../../effects/configuracion-grid.effect';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-c-a-notifiacion-asignacion-activos',
  templateUrl: './c-a-notifiacion-asignacion-activos.component.html',
  styleUrls: ['./c-a-notifiacion-asignacion-activos.component.scss'],
  standalone: false,
})
export class CANotifiacionAsignacionActivosComponent implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  private gridApi!: GridApi;
  notificacionForm: FormGroup;
  filaSeleccionada: any = null;
  camponuevo: boolean = false;

  // Inyección del Facade y Effects
  private readonly configuracionFacade = inject(ConfiguracionFacade);
  private readonly gridEffects = inject(ConfiguracionGridEffects);
  
  // Selectores del store
  readonly plantillasNotificacion = this.configuracionFacade.plantillasNotificacion;
  readonly historialPlantillasNotificacion = this.configuracionFacade.historialPlantillasNotificacion;
  readonly loadingPlantillas = this.configuracionFacade.loadingPlantillasNotificacion;
  readonly loadingHistorial = this.configuracionFacade.loadingHistorialPlantillasNotificacion;
  readonly isLoading = this.configuracionFacade.isLoading;
  isResetting = false;

  localeText = {
    page: 'Página',
    to: 'a',
    of: 'de',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    loadingOoo: 'Cargando...',
    noRowsToShow: 'No hay datos para mostrar',
  };

  colDefs: ColDef[] = [
    { headerName: 'Plantilla', field: 'plantilla_notificacion_plantilla', flex: 1},
    { headerName: 'Última modificación', field: 'plantilla_notificacion_ultima_modificacion', width: 130},
    { headerName: 'Asunto', field: 'plantilla_notificacion_asunto', width: 250,},
    { headerName: 'Contenido', field: 'plantilla_notificacion_contenido', width: 350,},
    { field: 'plantilla_notificacion_estado', headerName: 'Estado', headerClass: 'centrarencabezado', width: 80,
      cellRenderer: (params: any) => {
        const estado = params.value;
        const estadoClass = estado === 'Activo' ? 'text-green-600 bg-green-100' : 'text-red-600 bg-red-100';
        return `<span class="badge-table !w-[40px] ${estadoClass}">${estado}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
  ];

  columnTypes = {
    rightAligned: {
      headerClass: 'ag-right-aligned-header',
      cellClass: 'ag-right-aligned-cell',
    },
  };

  constructor(
    private fb: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
  ) {
    this.notificacionForm = this.fb.group({
      asunto: ['', Validators.required],
      contenido: ['', Validators.required],
      estado: ['Activo', Validators.required],
    });
  }

  ngOnInit() {
    // Cargar plantillas desde el JSON
    this.configuracionFacade.cargarPlantillasNotificacion();
  }

  /**
   * @summary Getter para acceder a rowData desde el template
   * @description El rowData está gestionado por ConfiguracionGridEffects
   */
  get rowData(): PlantillaNotificacionEntity[] {
    return this.gridEffects.getRowData();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // Registrar la API de la grilla en el effect
    this.gridEffects.setGridApi(params.api);
  }

  onCellClicked(event: any) {
    this.filaSeleccionada = event.data;
    this.camponuevo = false;
    this.cargarDatosEnFormulario(event.data);
    event.node.setSelected(true);
  }

  cargarDatosEnFormulario(data: any) {
    this.notificacionForm.patchValue({
      asunto: data.plantilla_notificacion_asunto,
      contenido: data.plantilla_notificacion_contenido,
      estado: data.plantilla_notificacion_estado,
    });
  }

  onBtReset(): void {
    this.isResetting = true;
    this.configuracionFacade.cargarPlantillasNotificacion();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

  async modalverActualizaciones() {
    // Cargar historial si no está cargado
    if (this.historialPlantillasNotificacion().length === 0) {
      this.configuracionFacade.cargarHistorialPlantillasNotificacion();
    }

    const colDefs = [
      { headerName: 'Fecha y hora', field: 'historial_actualizacion_fecha_hora', width: 150, },
      { headerName: 'Usuario', field: 'historial_actualizacion_usuario', width: 120, },
      {
        headerName: 'Acción', field: 'historial_actualizacion_accion', width: 150,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
      {
        headerName: 'Detalle del cambio', field: 'historial_actualizacion_detalle_cambio', flex: 1,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
    ];

    // Obtener datos del store
    const rowData = this.historialPlantillasNotificacion();

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones de la plantilla',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }

  botonGuardar() {
    if (this.notificacionForm.valid && this.filaSeleccionada) {
      // Obtener rowData desde el effect
      const rowData = this.gridEffects.getRowData();
      
      // Encontrar el índice de la fila seleccionada
      const index = rowData.findIndex(row => row.plantilla_notificacion_plantilla === this.filaSeleccionada.plantilla_notificacion_plantilla);
      
      if (index !== -1) {
        // Actualizar la fila con los nuevos valores
        rowData[index] = {
          ...rowData[index],
          plantilla_notificacion_asunto: this.notificacionForm.get('asunto')?.value || rowData[index].plantilla_notificacion_asunto,
          plantilla_notificacion_contenido: this.notificacionForm.get('contenido')?.value,
          plantilla_notificacion_estado: this.notificacionForm.get('estado')?.value,
          plantilla_notificacion_ultima_modificacion: new Date().toLocaleDateString('es-PE')
        };

        // Actualizar la grilla
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', [...rowData]);
          // Deseleccionar la fila
          this.gridApi.deselectAll();
        }

        this.toastService.success('¡Cambios guardados exitosamente!');

        console.log('Plantilla actualizada:', rowData[index]);

        // Limpiar formulario y resetear fila seleccionada
        this.notificacionForm.reset({
          asunto: '',
          contenido: '',
          estado: 'Activo'
        });
        this.filaSeleccionada = null;
      }
    }
  }

  get disabledValidar(): boolean {
    return !this.notificacionForm.valid;
  }
}
