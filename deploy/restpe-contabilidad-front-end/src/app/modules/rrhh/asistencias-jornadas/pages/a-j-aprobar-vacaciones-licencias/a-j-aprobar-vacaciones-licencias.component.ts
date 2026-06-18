import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { RrHhAprobarVacacionesGridEffects } from 'src/app/modules/rrhh/effects/rr-hh-aprobar-vacaciones-grid.effect';
import { VacacionLicenciaEntity } from 'src/app/modules/rrhh/domain/models/vacacion-licencia.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-a-j-aprobar-vacaciones-licencias',
  templateUrl: './a-j-aprobar-vacaciones-licencias.component.html',
  styleUrls: ['./a-j-aprobar-vacaciones-licencias.component.scss'],
  standalone: false,
})
export class AJAprobarVacacionesLicenciasComponent implements OnInit {
  // Facades y Effects
  private readonly rrHhFacade = inject(RrHhFacade);
  private readonly vacacionesGridEffects = inject(RrHhAprobarVacacionesGridEffects);

  // Selectores del store
  readonly isLoading = this.rrHhFacade.loadingVacacionesLicencias;
  isResetting = false;

  get rowData(): VacacionLicenciaEntity[] {
    return this.vacacionesGridEffects.getRowData();
  }

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  private gridApi!: GridApi;
  SolicitudForm!: FormGroup;
  filaSeleccionada: any = null;
  botonesHabilitados: boolean = false;
  tipoSeleccionado: string = 'inicio';


  // Fecha
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

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
    tipoFs = [
    { value: 'inicio', nombre: 'De inicio' },
    { value: 'fin', nombre: 'De fin' },
  ]
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
  colDefs: ColDef<VacacionLicenciaEntity>[] = [
    { field: 'vacacion_licencia_codigo', headerName: 'Código', width: 110 },
    { field: 'vacacion_licencia_trabajador', headerName: 'Trabajador', width: 140, filter: true },
    { field: 'vacacion_licencia_sucursal', headerName: 'Sucursal', width: 140 },
    { field: 'vacacion_licencia_centro_costo', headerName: 'Centro de costo', width: 150, filter: true },
    { field: 'vacacion_licencia_motivo', headerName: 'Motivo', flex: 1, minWidth: 140 },
    { field: 'vacacion_licencia_tipo', headerName: 'Tipo de solicitud', width: 140 },
    {
      field: 'vacacion_licencia_fecha_inicio', headerName: 'Fecha de inicio', width: 120,
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate() + 1).padStart(2, '0');
        return `${day}/${month}/${year}`;
      }
    },
    {
      field: 'vacacion_licencia_fecha_fin', headerName: 'Fecha de fin ', width: 120,
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate() + 1).padStart(2, '0');
        return `${day}/${month}/${year}`;
      }
    },
    {
      field: 'vacacion_licencia_estado', headerName: 'Estado', headerClass: 'centrarencabezado', width: 110, filter: true, 
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
    // Cargar vacaciones y licencias desde el JSON a través de la capa de infraestructura
    this.rrHhFacade.cargarVacacionesLicencias();

    this.SolicitudForm = this.formBuilder.group({
      vacacion_licencia_trabajador: [{ value: '', disabled: true }],
      vacacion_licencia_sucursal: [{ value: '', disabled: true }],
      vacacion_licencia_centro_costo: [{ value: '', disabled: true }],
      vacacion_licencia_tipo: [{ value: '', disabled: true }],
      tipoAnual: [{ value: '', disabled: true }],
      diasAnual: [{ value: '', disabled: true }],
      vacacion_licencia_subtipo: [{ value: '', disabled: true }],
      vacacion_licencia_subtipo_subsidio: [{ value: '', disabled: true }],
      vacacion_licencia_dias_solicitados: [{ value: '', disabled: true }],
      vacacion_licencia_fecha_inicio: [{ value: '', disabled: true }],
      vacacion_licencia_fecha_fin: [{ value: '', disabled: true }],
      vacacion_licencia_motivo: [{ value: '', disabled: true }],
      vacacion_licencia_estado: [{ value: '', disabled: true }],
    });
  }

  onCellClicked(event: any) {
    const data = event.data;
    this.filaSeleccionada = data;

    // Deshabilitar botones si el estado es Aprobado o Rechazado
    this.botonesHabilitados = data.vacacion_licencia_estado !== 'Aprobado' && data.vacacion_licencia_estado !== 'Rechazado';

    this.gridApi.deselectAll();
    event.node.setSelected(true);

    // Llenar los campos del formulario con los datos de la fila
    this.SolicitudForm.patchValue({
      vacacion_licencia_trabajador: data.vacacion_licencia_trabajador || '',
      vacacion_licencia_sucursal: data.vacacion_licencia_sucursal || '',
      vacacion_licencia_centro_costo: data.vacacion_licencia_centro_costo || '',
      vacacion_licencia_tipo: data.vacacion_licencia_tipo || '',
      vacacion_licencia_subtipo: data.vacacion_licencia_subtipo || '',
      vacacion_licencia_dias_solicitados: data.vacacion_licencia_dias_solicitados || '',
      vacacion_licencia_fecha_inicio: data.vacacion_licencia_fecha_inicio || '',
      vacacion_licencia_fecha_fin: data.vacacion_licencia_fecha_fin || '',
      vacacion_licencia_motivo: data.vacacion_licencia_motivo || '',
      vacacion_licencia_estado: data.vacacion_licencia_estado || 'Pendiente'
    });

    // Si es Vacaciones, cargar tipoAnual y diasAnual
    if (data.vacacion_licencia_tipo === 'Vacaciones') {
      if (data.vacacion_licencia_subtipo) {
        this.SolicitudForm.get('tipoAnual')?.setValue(data.vacacion_licencia_subtipo);
      }
      if (data.vacacion_licencia_dias_solicitados) {
        this.SolicitudForm.get('diasAnual')?.setValue(data.vacacion_licencia_dias_solicitados);
      }
    }

    // Si es Subsidio, cargar el valor
    if (data.vacacion_licencia_tipo === 'Subsidio' && data.vacacion_licencia_subtipo_subsidio) {
      this.SolicitudForm.get('vacacion_licencia_subtipo_subsidio')?.setValue(data.vacacion_licencia_subtipo_subsidio);
    }

    // Si es Licencia, cargar subtipo
    if (data.vacacion_licencia_tipo === 'Licencia') {
      if (data.vacacion_licencia_subtipo) {
        this.SolicitudForm.get('vacacion_licencia_subtipo')?.setValue(data.vacacion_licencia_subtipo);
      }
    }
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.vacacionesGridEffects.setGridApi(params.api);
  }

  onFirstDataRendered(): void {
    if (this.gridApi) {
      const firstNode = this.gridApi.getDisplayedRowAtIndex(0);
      if (firstNode) {
        firstNode.setSelected(true);
        const data = firstNode.data;
        this.filaSeleccionada = data;
        this.botonesHabilitados = data.vacacion_licencia_estado !== 'Aprobado' && data.vacacion_licencia_estado !== 'Rechazado';
        this.SolicitudForm.patchValue({
          vacacion_licencia_trabajador: data.vacacion_licencia_trabajador || '',
          vacacion_licencia_sucursal: data.vacacion_licencia_sucursal || '',
          vacacion_licencia_centro_costo: data.vacacion_licencia_centro_costo || '',
          vacacion_licencia_tipo: data.vacacion_licencia_tipo || '',
          vacacion_licencia_subtipo: data.vacacion_licencia_subtipo || '',
          vacacion_licencia_dias_solicitados: data.vacacion_licencia_dias_solicitados || '',
          vacacion_licencia_fecha_inicio: data.vacacion_licencia_fecha_inicio || '',
          vacacion_licencia_fecha_fin: data.vacacion_licencia_fecha_fin || '',
          vacacion_licencia_motivo: data.vacacion_licencia_motivo || '',
          vacacion_licencia_estado: data.vacacion_licencia_estado || 'Pendiente'
        });
        if (data.vacacion_licencia_tipo === 'Vacaciones') {
          if (data.vacacion_licencia_subtipo) { this.SolicitudForm.get('tipoAnual')?.setValue(data.vacacion_licencia_subtipo); }
          if (data.vacacion_licencia_dias_solicitados) { this.SolicitudForm.get('diasAnual')?.setValue(data.vacacion_licencia_dias_solicitados); }
        }
        if (data.vacacion_licencia_tipo === 'Subsidio' && data.vacacion_licencia_subtipo_subsidio) {
          this.SolicitudForm.get('vacacion_licencia_subtipo_subsidio')?.setValue(data.vacacion_licencia_subtipo_subsidio);
        }
        if (data.vacacion_licencia_tipo === 'Licencia' && data.vacacion_licencia_subtipo) {
          this.SolicitudForm.get('vacacion_licencia_subtipo')?.setValue(data.vacacion_licencia_subtipo);
        }
      }
    }
  }

  onBtReset() {
    this.isResetting = true;
    this.rrHhFacade.cargarVacacionesLicencias();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.isResetting = false;
      }
    }, 100);
  }

  async modalverActualizaciones() {
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

    const rowData = [
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial de la solicitud'},
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de fecha de inicio'},
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - ' + this.filaSeleccionada.vacacion_licencia_codigo,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }

  botonAprobar() {
    if (!this.filaSeleccionada) { return; }

    const currentData = this.vacacionesGridEffects.getRowData();
    const index = currentData.findIndex((item: VacacionLicenciaEntity) => item.vacacion_licencia_codigo === this.filaSeleccionada.vacacion_licencia_codigo);
    if (index !== -1) {
      const updatedData = [...currentData];
      updatedData[index] = { ...updatedData[index], vacacion_licencia_estado: 'Aprobado' };
      const soloPendientes = updatedData.filter((item) => item.vacacion_licencia_estado === 'Pendiente');
      this.vacacionesGridEffects.setRowData(soloPendientes);
    }

    this.toastService.success('¡Solicitud aprobada exitosamente!');
    this.limpiarFormulario();
  }


  filtrarPorFechas(event: any) {
    console.log('Filtrar por fechas:', event);
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
        { label: 'Trabajador', value: this.filaSeleccionada.vacacion_licencia_trabajador },
        { label: 'Fecha inicio', value: formatearFecha(this.filaSeleccionada.vacacion_licencia_fecha_inicio) },
        { label: 'Fecha fin', value: formatearFecha(this.filaSeleccionada.vacacion_licencia_fecha_fin) },
      ];
  
      const modal = await this.modalController.create({
        component: ModalDetalleComponent,
        cssClass: 'promo',
        componentProps: {
          tituloModal: `Rechazar solicitud ${this.filaSeleccionada.vacacion_licencia_codigo}:`,
          subtitulomodal: `Detalle de la solicitud`,
          detalles: detalles,
          mostrarTextarea: true,
          motivoObligatorio: true,
          tituloTextarea: 'Motivo del rechazo:',
          placeholderTextarea: 'Describe el motivo del rechazo de la solicitud',
          textoBotonConfirmar: 'Rechazar',
          colorBotonConfirmar: 'danger',
          validarTextarea: true
        }
      });
  
      await modal.present();
      
      const { data } = await modal.onWillDismiss();
      if (data && data.action === 'confirmar' && data.motivo) {
        const currentData = this.vacacionesGridEffects.getRowData();
        const index = currentData.findIndex((item: VacacionLicenciaEntity) => item.vacacion_licencia_codigo === this.filaSeleccionada.vacacion_licencia_codigo);
        if (index !== -1) {
          const updatedData = [...currentData];
          updatedData[index] = { ...updatedData[index], vacacion_licencia_estado: 'Rechazado' };
          const soloPendientes = updatedData.filter((item) => item.vacacion_licencia_estado === 'Pendiente');
          this.vacacionesGridEffects.setRowData(soloPendientes);
        }

        this.toastService.success('¡Solicitud rechazada exitosamente!');
        this.limpiarFormulario();
      }
    }

  private limpiarFormulario(): void {
    this.filaSeleccionada = null;
    this.botonesHabilitados = false;
    this.gridApi?.deselectAll();
    this.SolicitudForm.patchValue({
      vacacion_licencia_trabajador: '',
      vacacion_licencia_sucursal: '',
      vacacion_licencia_centro_costo: '',
      vacacion_licencia_tipo: '',
      tipoAnual: '',
      diasAnual: '',
      vacacion_licencia_subtipo: '',
      vacacion_licencia_subtipo_subsidio: '',
      vacacion_licencia_dias_solicitados: '',
      vacacion_licencia_fecha_inicio: '',
      vacacion_licencia_fecha_fin: '',
      vacacion_licencia_motivo: '',
      vacacion_licencia_estado: ''
    });
  }
}
