import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { TipoContratoEntity } from 'src/app/modules/rrhh/domain/models/tipo-contrato.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-p-tipo-contrato',
  templateUrl: './p-tipo-contrato.component.html',
  styleUrls: ['./p-tipo-contrato.component.scss'],
  standalone: false,
})
export class PTipoContratoComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  private readonly rrHhFacade = inject(RrHhFacade);
  readonly isLoading = this.rrHhFacade.loadingTipoContrato;
  isResetting = false;
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  private gridApi!: GridApi;
  formularioTipoContrato!: FormGroup;
  filaSeleccionada: any = null;

  estado = [
    { value: 'activo', label: 'Activo' },
    { value: 'inactivo', label: 'Inactivo' }
  ];
  defaultEstado = this.estado[0].value;
  // Configuración de AG-Grid
  columnDefs: any[] = [
    { headerName: 'Código', field: 'tipo_contrato_codigo', width: 100, sortable: true, filter: true },
    { headerName: 'Nombre', field: 'tipo_contrato_nombre', flex: 1, sortable: true, filter: true },
    { headerName: 'Descripción', field: 'tipo_contrato_descripcion', flex: 2, sortable: true, filter: true },
    {
      headerClass: 'centrarencabezado',
      headerName: 'Estado',
      field: 'tipo_contrato_estado',
      width: 100,
      sortable: true,
      filter: true,
      cellRenderer: (params: any) => {
        const estado = params.value;
        if (estado === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
        } else if (estado === 'Inactivo') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>';
        }
        return params.value;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    }
  ];

  rowData: TipoContratoEntity[] = [];

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

  constructor(
    private modalController: ModalController,
    private toastService: ToastService,
    private fb: FormBuilder,
    private formValidationService: FormValidationService
  ) { }

  ngOnInit() {
    this.inicializarFormulario();
    this.formValidationService.inicializarFormulario(this.formularioTipoContrato);
    this.formValidationService.resetearEstado();
    this.rrHhFacade.cargarTipoContrato();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.tipoContrato();
        clearInterval(timer);
      }
    }, 100);
  }

  inicializarFormulario() {
    this.formularioTipoContrato = this.fb.group({
      nombre: [null],
      descripcion: [null],
      estado: [this.defaultEstado]
    });
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onBtReset(): void {
    this.isResetting = true;
    this.rrHhFacade.cargarTipoContrato();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.tipoContrato();
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

  async onCellClicked(event: any) {
    const data = event.data;
    
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló, deseleccionar la nueva fila y mantener la anterior
      if (this.gridApi) {
        this.gridApi.deselectAll();
        // Si había una fila seleccionada anteriormente, reseleccionarla
        if (this.filaSeleccionada) {
          const node = this.gridApi.getRowNode(this.rowData.indexOf(this.filaSeleccionada).toString());
          if (node) {
            node.setSelected(true);
          }
        }
      }
      return;
    }
    
    this.filaSeleccionada = data;
    this.formularioTipoContrato.patchValue({
      nombre: data.tipo_contrato_nombre,
      descripcion: data.tipo_contrato_descripcion,
      estado: data.tipo_contrato_estado_value
    });
    
    // Resetear servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }

  async nuevoTipoContrato() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    this.filaSeleccionada = null;
    this.formularioTipoContrato.reset({
      estado: this.defaultEstado,
    });
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
    
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  btnguardar() {
    const nombre = this.formularioTipoContrato.get('nombre')?.value;
    const descripcion = this.formularioTipoContrato.get('descripcion')?.value;
    const estadoValue = this.formularioTipoContrato.get('estado')?.value;

    if (!nombre || String(nombre).trim() === '' || !estadoValue) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    if (this.filaSeleccionada) {
      // Modo edición: actualizar y mantener selección
      this.filaSeleccionada.tipo_contrato_nombre = nombre;
      this.filaSeleccionada.tipo_contrato_descripcion = descripcion;
      this.filaSeleccionada.tipo_contrato_estado_value = estadoValue;
      this.filaSeleccionada.tipo_contrato_estado = estadoValue === 'activo' ? 'Activo' : 'Inactivo';

      if (this.gridApi) {
        this.gridApi.applyTransaction({ update: [this.filaSeleccionada] });
        this.gridApi.refreshCells({ force: true });
      }

      this.toastService.success('¡Tipo de contrato actualizado exitosamente!');
      this.formValidationService.resetearEstado();
    } else {
      // Modo creación: registrar y limpiar formulario
      const nuevoRegistro = {
        tipo_contrato_codigo: this.generarCodigo(),
        tipo_contrato_nombre: nombre,
        tipo_contrato_descripcion: descripcion,
        tipo_contrato_estado_value: estadoValue,
        tipo_contrato_estado: estadoValue === 'activo' ? 'Activo' : 'Inactivo',
      };
      this.rowData = [nuevoRegistro, ...this.rowData];

      if (this.gridApi) {
        this.gridApi.applyTransaction({ add: [nuevoRegistro], addIndex: 0 });
      }

      this.toastService.success('¡Tipo de contrato registrado exitosamente!');

      // Primero limpiar formulario, LUEGO resetear tracking
      this.formularioTipoContrato.reset({
        estado: this.defaultEstado,
      });
      this.formValidationService.resetearEstado();
    }
  }

  // Genera un código automático para el nuevo registro
  generarCodigo(): string {
    const prefix = 'TC-';

    // Si no hay datos, empezar desde 1
    if (!this.rowData || this.rowData.length === 0) {
      return `${prefix}001`;
    }

    const max = this.rowData.reduce((acc, curr) => {
      // Verificar que el código existe y tiene el formato correcto
      if (curr.tipo_contrato_codigo && typeof curr.tipo_contrato_codigo === 'string' && curr.tipo_contrato_codigo.startsWith(prefix)) {
        const num = parseInt(curr.tipo_contrato_codigo.replace(prefix, ''), 10);
        // Verificar que es un número válido
        return (!isNaN(num) && num > acc) ? num : acc;
      }
      return acc;
    }, 0);

    const next = (max + 1).toString().padStart(3, '0');
    return `${prefix}${next}`;
  }



  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  async modalverActualizaciones() {
    // Definir las columnas
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 150, },
      { headerName: 'Usuario', field: 'usuario', width: 120, },
      { headerName: 'Acción', field: 'accion', width: 150, },
      {
        headerName: 'Detalle del cambio', field: 'detalleCambio', flex: 1,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
    ];

    // Datos de ejemplo
    const rowData = [
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar' },
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385' },
      { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380 ' },
      { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT' },
    ];

    const defaultColDefModal: ColDef = {
      wrapText: true,
      autoHeight: true,
    };

    let codigo = this.filaSeleccionada?.tipo_contrato_codigo;
    let titulo = 'Historial de actualizaciones de tipo de contrato';
    if (codigo) {
      titulo += ` ${codigo}`;
    }
    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: titulo,
        rowData: rowData,
        colDefs: colDefs,
        defaultColDef: defaultColDefModal,
        anchoModal: '700px',
      },
    });

    await modal.present();
  }
}
