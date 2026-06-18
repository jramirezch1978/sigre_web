import { Component, OnInit, effect, inject } from '@angular/core';
import { ModalController } from '@ionic/angular';
import {
  ColDef,
  GridApi,
  GridReadyEvent,
  GridState,
  RowSelectionOptions,
} from 'ag-grid-community';
import { ModalRechazComponent } from 'src/app/modules/compras/modals/modal-rechaz/modal-rechaz.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ModalRechazarTrasladoComponent } from './components/modals/modal-rechazar-traslado/modal-rechazar-traslado.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormGroup, FormBuilder, FormControl } from '@angular/forms';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { AprobacionTrasladoFacade } from '../../../application/facades/aprobacion-traslado.facade';
import { AprobacionTrasladoEntity } from '../../../domain/models/aprobacion-traslado.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';


@Component({
  selector: 'app-activosfijos-operaciones-aprobaciontraslado',
  templateUrl: './activosfijos-operaciones-aprobaciontraslado.component.html',
  styleUrls: ['./activosfijos-operaciones-aprobaciontraslado.component.scss'],
  standalone: false,
})
export class ActivosfijosOperacionesAprobaciontrasladoComponent
  implements OnInit {
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

  filaSeleccionada: any = null; // Almacena la fila que se está editando
  filasSeleccionadasCheckbox: any[] = []; // Almacena las filas seleccionadas con checkbox
  camponuevo: boolean = false;
  estadoSeleccionado = 'todos';
  tabSeleccionadoDetalle = 'general';
  private gridApi!: GridApi;
  mostrartabla = true;
  isGeneralFormValid = false; // Nueva propiedad para controlar el estado del formulario
  OperacionesForm!: FormGroup;

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
      if (params.colDef.checkboxSelection) return params.value;
      return (params.value === null || params.value === undefined || params.value === '')
        ? '-'
        : params.value;
    }
  };

  colDefs: ColDef[] = [
    { headerCheckboxSelection: true, checkboxSelection: true, width: 40, headerName: '', pinned: 'left', headerClass: 'header-checkbox-col', cellClass: 'cell-checkbox-col', },
    { headerName: 'N° de Traslado', field: 'atr_numero_traslado', flex: 1, },
    { headerName: 'Fecha de Solicitud', field: 'atr_fecha_solicitud', flex: 1, },
    { headerName: 'Solicitante', field: 'atr_solicitante', flex: 1, },
    { headerName: 'Origen', field: 'atr_origen', flex: 1, },
    { headerName: 'Destino', field: 'atr_destino', flex: 1, },
    {
      headerClass: 'centrarencabezado', headerName: 'Estado', field: 'atr_estado', flex: 1,
      filter: true,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let colorClasses = 'bg-[#F5F5F5] text-[#363636]'; // Pendiente por defecto

        if (estado === 'Aprobado') {
          colorClasses = 'bg-[#DCFDE7] text-[#16A34A]';
        } else if (estado === 'Rechazado') {
          colorClasses = 'bg-[#FEE2E2] text-[#DC2626]';
        }

        return `<span class="badge-table ${colorClasses}">${estado}</span>`;
      },
      cellStyle: {
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    },
  ];
  rowSelection: RowSelectionOptions | 'single' | 'multiple' = {
    mode: 'multiRow',
  };
  initialState: GridState = {
    // rowSelection: ["2"],
  };
  rowData: AprobacionTrasladoEntity[] = [];
  readonly facade = inject(AprobacionTrasladoFacade);

  constructor(
    private modalController: ModalController,
    private formBuilder: FormBuilder,
    private toastservice: ToastService,
    private formValidationService: FormValidationService
  ) {
    effect(() => { this.rowData = this.facade.traslados(); });
    const today = new Date();
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );
    this.maxDate = today;
  }

  ngOnInit() {
    this.facade.cargarTraslados();
    this.OperacionesForm = this.formBuilder.group({
      numeroTraslado: new FormControl(''),
      fechaSolicitud: new FormControl(''),
      solicitante: new FormControl(''),
      origen: new FormControl(''),
      destino: new FormControl(''),
      estado: new FormControl(''),
      observaciones: new FormControl(''),
    });
  }

  onCellClicked(event: any) {
    this.camponuevo = false;
    if (event && event.data) {
      const data = event.data;
      this.filaSeleccionada = data;
      this.gridApi.deselectAll();
      event.node.setSelected(true);
      this.cargarDatosEnFormulario(data);
    } else {
      // Si se hace clic fuera de una fila, limpiar la selección
      this.filaSeleccionada = null;
    }
    // Los datos se pasarán automáticamente al componente hijo a través del @Input datosTraslado
  }

  /**
   * Carga los datos de una fila en el formulario
   */
  private cargarDatosEnFormulario(data: AprobacionTrasladoEntity) {
    this.OperacionesForm.patchValue({
      numeroTraslado: data.atr_numero_traslado,
      fechaSolicitud: data.atr_fecha_solicitud,
      solicitante:    data.atr_solicitante,
      origen:         data.atr_origen,
      destino:        data.atr_destino,
      estado:         data.atr_estado,
      observaciones:  data.atr_motivo_traslado || '',
    });
  }

  onGeneralFormValidChange(isValid: boolean) {
    this.isGeneralFormValid = isValid;
  }

  onSelectionChanged() {
    if (this.gridApi) {
      this.filasSeleccionadasCheckbox = this.gridApi.getSelectedRows();
    }
  }

  get tieneMultiplesSelecciones(): boolean {
    return this.filasSeleccionadasCheckbox.length > 1;
  }

  async modalverAprobar() {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Confirmar Aprobación',
        title: 'Confirmar Aprobación de Traslado(s)',
        message:
          'Por favor, revisa los detalles antes de proceder. Una vez aprobados, no podrás modificar ni deshacer esta acción.',
        btnOkTxt: 'Confirmar',
        btnCancelTxt: 'Cancelar',
      },
    });

    await modal.present();
  }
  async modalverRechazar() {
    // Validar que haya una fila seleccionada
    if (!this.filaSeleccionada) {
      this.toastservice.warning('Por favor selecciona un traslado para rechazar');
      return;
    }

    const modal = await this.modalController.create({
      component: ModalRechazarTrasladoComponent,
      cssClass: 'promo',
      componentProps: {},
    });

    await modal.present();
    const { data } = await modal.onWillDismiss();

    if (data === true) {
      // Actualizar el estado del traslado a Rechazado
      this.filaSeleccionada.atr_estado = 'Rechazado';

      // Actualizar la grilla
      this.gridApi.applyTransaction({
        update: [this.filaSeleccionada],
      });
      setTimeout(() => {
        this.toastservice.success('¡La acción se realizó con éxito!');
      }, 500);
      this.filaSeleccionada = null;
    }
  }

  botonGuardar() {
    const formValues = this.OperacionesForm.value;

    // Crear objeto con los datos del formulario
    const operacionData = {
      estado: 'Aprobado', // Cambiar estado a Aprobado
    };

    let res;

    // Si es una nueva operación (camponuevo = true)
    if (this.camponuevo) {
      res = this.gridApi.applyTransaction({
        add: [operacionData],
      })!;
      console.log('Nueva operación agregada');
      this.toastservice.success('¡Se guardaron cambios exitosamente!');
    }
    // Si es edición (hay una fila seleccionada)
    else if (this.filaSeleccionada) {
      // Actualizar los valores de la fila seleccionada
      Object.assign(this.filaSeleccionada, operacionData);

      res = this.gridApi.applyTransaction({
        update: [this.filaSeleccionada],
      })!;
      console.log('Traslado aprobado');
      this.toastservice.success('¡Los traslados aprobaron exitosamente!');
    }

    // Limpiar formulario y resetear estado
    this.OperacionesForm.reset();
    this.filaSeleccionada = null;
    this.camponuevo = false;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;

    // Seleccionar la primera fila por defecto
    setTimeout(() => {
      this.gridApi.forEachNode((node, index) => {
        if (index === 0) {
          node.setSelected(true);
          this.filaSeleccionada = node.data;
          this.cargarDatosEnFormulario(node.data);
        }
      });
    }, 100);
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

  onBtReset() {
    this.facade.cargarTraslados();
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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar', },
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385', },
      { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380', },
      { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT', },
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
