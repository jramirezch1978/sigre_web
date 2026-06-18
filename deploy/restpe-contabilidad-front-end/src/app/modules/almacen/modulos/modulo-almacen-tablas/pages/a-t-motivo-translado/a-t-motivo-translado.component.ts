import { Component, effect, inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import {
  faAngleDown,
  faCirclePlus,
  faDownload,
  faRotateRight,
} from '@fortawesome/pro-solid-svg-icons';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { AlmacenExportService } from '@modules/almacen/infrastructure/export/almacen-export.service';
import { ToastService } from '@ui/services/toast.service';
import { MotivoTrasladoAlmacenEntity } from '@modules/almacen/domain/models/motivo-traslado-almacen.entity';
import { MotivoTrasladoFacade } from '@modules/almacen/application/facades/motivo-traslado.facade';

@Component({
  selector: 'app-a-t-motivo-translado',
  templateUrl: './a-t-motivo-translado.component.html',
  styleUrls: ['./a-t-motivo-translado.component.scss'],
  standalone: false,
})
export class ATMotivoTransladoComponent implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  // Facades
  private readonly motivoFacade = inject(MotivoTrasladoFacade);

  //Services
  private readonly toastService = inject(ToastService);
  protected readonly exportSvc = inject(AlmacenExportService);
  private readonly fb = inject(FormBuilder);

  // Selectores del store
  readonly motivos = this.motivoFacade.motivos;
  readonly isLoading = this.motivoFacade.isLoading;
  readonly hasError = this.motivoFacade.hasError;
  readonly loadingObtener = this.motivoFacade.loadingObtener;
  readonly loadingGuardar = this.motivoFacade.loadingGuardar;
  readonly loadingEliminar = this.motivoFacade.loadingEliminar;
  readonly loadingActualizar = this.motivoFacade.loadingActualizar;
  readonly errorObtener = this.motivoFacade.errorObtener;
  readonly errorGuardar = this.motivoFacade.errorGuardar;
  readonly errorEliminar = this.motivoFacade.errorEliminar;
  readonly errorActualizar = this.motivoFacade.errorActualizar;
  readonly motivoSeleccionado = this.motivoFacade.motivoSeleccionado;
  readonly resultGuardar = this.motivoFacade.resultGuardar;
  readonly resultEliminar = this.motivoFacade.resultEliminar;
  readonly resultActualizar = this.motivoFacade.resultActualizar;

  selectedMotivo: any = null;
  selectedAlmacen: any = null;
  btnguardar = 'Registrar';

  motivoForm: FormGroup;

  private gridApi!: GridApi;

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

  colDefs: ColDef[] = [
    {
      field: 'codigo',
      headerName: 'Código',
      width: 100,
      cellClass: 'text-center',
      headerClass: 'text-center',
    },
    {
      field: 'nombre',
      headerName: 'Nombre',
      width: 200,
      cellClass: 'text-center',
      headerClass: 'text-center',
    },
    {
      field: 'flagEstado',
      headerName: 'Estado',
      width: 150,
      cellClass: 'text-center',
      headerClass: 'centrarencabezado',
      filter: true,
      cellRenderer: (params: any) => {
        if (params.value === '1') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>`;
        } else {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>`;
        }
      },
      cellStyle: {
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    },
  ];

  columnTypes = {
    rightAligned: { headerClass: 'text-right', cellClass: 'text-right' },
  };

  rowData: MotivoTrasladoAlmacenEntity[] = [];

  constructor() {
    this.motivoFacade.cargarMotivos();
    effect(() => {
      const datos = this.motivoFacade.motivos();
      if (datos && datos.length > 0) {
        const isNewFormat = datos[0] && 'codigo' in datos[0];
        console.log('DATOS: ', datos);

        if (isNewFormat) {
          this.rowData = datos;
          if (this.gridApi) {
            this.gridApi.setGridOption('rowData', this.rowData);
          }
        }
      }
    });

    effect(() => {
      const resultGuardar = this.motivoFacade.resultGuardar();
      console.log('ResultGuardar: ', resultGuardar);

      if (resultGuardar) {
        this.toastService.success(
          '¡Motivo de traslado registrado exitosamente!',
        );
        this.motivoFacade.cargarMotivos();
      } else {
        if (this.hasError()) {
          this.toastService.danger('Error al registrar motivo de traslado.');
        }
      }
    });

    this.motivoForm = this.fb.group({
      nombre: this.fb.control<string>('', [Validators.required]),
      estado: this.fb.control<string>('1', [Validators.required]),
    });
  }

  ngOnInit(): void {}

  exportarExcel(): void {
    this.exportSvc.exportarExcel(this.gridApi, 'at-motivos-almacenes');
  }

  toastsuccess() {
    if (!this.motivoForm.valid) {
      this.toastService.danger('Por favor, completa los campos requeridos');
      return;
    }

    const formValues = this.motivoForm.value;

    if (this.selectedMotivo) {
      // Modo edición - actualizar registro existente
      const index = this.rowData.findIndex(
        (item) => item.codigo === this.selectedMotivo.codigo,
      );

      if (index !== -1) {
        // Actualizar grid
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        // Actualizar motivo en el store
        const motivoActualizado: MotivoTrasladoAlmacenEntity = {
          ...this.selectedMotivo,
          nombre: formValues.nombre,
          flagEstado: formValues.estado,
        };
        // this.motivoFacade.actualizarMotivo(motivoActualizado);
      }
    } else {
      const nuevoCodigo = this.generarNuevoCodigo();

      const nuevoMotivo: MotivoTrasladoAlmacenEntity = {
        codigo: nuevoCodigo,
        nombre: formValues.nombre,
        flagEstado: formValues.estado,
      };

      this.motivoFacade.guardarMotivo(nuevoMotivo);

      this.gridApi.setGridOption('rowData', this.rowData);
    }

    this.nuevoMotivo();
  }

  generarNuevoCodigo(): string {
    const numeros = this.rowData.map((item) => {
      const match = item.codigo.match(/MOT-(\d+)/);
      return match ? parseInt(match[1], 10) : 0;
    });
    const maxNumero = Math.max(...numeros, 0);
    const nuevoNumero = (maxNumero + 1).toString().padStart(3, '0');
    return `MOT-${nuevoNumero}`;
  }

  nuevoMotivo() {
    this.btnguardar = 'Registrar';
    this.gridApi.deselectAll();
    this.selectedMotivo = null;
    this.motivoForm.reset({
      nombre: '',
      estado: '1',
    });
  }

  onBtReset() {
    this.motivoFacade.cargarMotivos();
  }

  public async modalEliminar() {
    // Validar que haya un movimiento seleccionado
    if (!this.selectedMotivo) {
      this.toastService.danger('Debe seleccionar un motivo para eliminar');
      return;
    }
  }

  async onCellClicked(event: any) {
    const data = event.data;

    // Prevenir selección automática de AG-Grid
    event.node.setSelected(true);

    // Cargar datos del registro seleccionado
    this.cargarDatosRegistro(data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: any, node?: any): void {
    this.btnguardar = 'Guardar';
    this.selectedMotivo = data;
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    // Seleccionar el nodo en AG-Grid
    if (node) {
      node.setSelected(true);
    } else if (this.gridApi) {
      this.gridApi.forEachNode((n) => {
        if (n.data === data) {
          n.setSelected(true);
        }
      });
    }

    this.motivoForm.patchValue({
      nombre: data.nombre || '',
      estado: data.flagEstado || '0',
    });
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }
}
