import { Component, OnInit, inject, effect } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent, RowSelectionOptions, GridState } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormGroup, FormBuilder, FormControl } from '@angular/forms';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faChevronsLeft, faChevronsRight, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

// Facade
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
import { ActualizacionProductoEntity } from '../../../../domain/models/actualizacion-producto.entity';

@Component({
  selector: 'app-a-p-actualizacion',
  templateUrl: './a-p-actualizacion.component.html',
  styleUrls: ['./a-p-actualizacion.component.scss'],
  standalone: false,
})
export class APActualizacionComponent implements OnInit {
  // Facades
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly actualizacionProductos = this.almacenFacade.actualizacionProductos;
  
  // Estado de loading desde el facade
  readonly isLoading = this.almacenFacade.loadingActualizacionProductos;


  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasRotateRight = faRotateRight;


    //RANGO DE FECHAS

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  mostrartabla: boolean = true;
  actualizacionForm!: FormGroup;
  estadoSeleccionado = 'todos';
  filaSeleccionada: ActualizacionProductoEntity | null = null;
  productoSeleccionadoNombre: string = '';
  private gridApi!: GridApi;
  filasSeleccionadasCount: number = 0;

  botonesDesactivados: boolean = true;
  botonRevertirDesactivado: boolean = true;

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
    valueFormatter: (params:any) => {
      if (params.colDef.checkboxSelection) return params.value;
      return (params.value === null || params.value === undefined || params.value === '')
        ? '-'
        : params.value;
    }
  };

  rowData: ActualizacionProductoEntity[] = [];

  colDefs: ColDef[] = [
    { headerCheckboxSelection: true,  checkboxSelection: (params) => params.data?.actualizacion_estado == 'Pendiente', width: 40, headerName: '', pinned: 'left', headerClass: 'header-checkbox-col', cellClass: 'cell-checkbox-col',},
    { field: 'actualizacion_codigo', headerName: 'Código producto', width: 130},
    { field: 'actualizacion_unidad_medida', headerName: 'Unidad de medida', width: 130,},
    { field: 'actualizacion_descripcion', headerName: 'Descripción', flex: 1, minWidth: 120},
    { field: 'actualizacion_proveedor', headerName: 'Proveedor', filter: true, width: 150},
    { field: 'actualizacion_precio_anterior', headerName: 'Precio anterior', width: 130,
      headerClass: 'derechaencabezado',
       cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
        alignItems: 'center',
      },
      valueFormatter: (params: any) => {
        return params.value ? `S/ ${params.value.toFixed(2)}` : 'S/ 0.00';
      }
    },
    { field: 'actualizacion_precio_ultima', headerName: 'Precio última compra', width: 140,
      headerClass: 'derechaencabezado',
       cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
        alignItems: 'center',
      },
      valueFormatter: (params: any) => {
        return params.value ? `S/ ${params.value.toFixed(2)}` : 'S/ 0.00';
      }
    },
    { field: 'actualizacion_diferencia', headerName: 'Diferencia', width: 100, headerClass: 'derechaencabezado', 
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
        alignItems: 'center',
      },
      cellRenderer: (params: any) => {
        const valor = params.value;
        let prefijo = '';
        
        if (valor > 0) {
          prefijo = '+';
        }
        
        return `<span class="text-red-600 font-semibold">${prefijo}S/ ${Math.abs(valor).toFixed(2)}</span>`;
      }
    },
    { field: 'actualizacion_fecha_ultima', headerName: 'Fecha última factura', width: 120, cellClass: 'text-center',
      cellRenderer: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '-';
      }
    },
    { field: 'actualizacion_fecha_actualizacion', headerName: 'Fecha de actualización', width: 150, cellClass: 'text-center',
      cellRenderer: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '-';
      }
    },
    { field: 'actualizacion_n_factura', headerName: 'Nº de factura', width: 120},
    { field: 'actualizacion_estado', headerName: 'Estado', headerClass: 'centrarencabezado', filter :true, width: 90, cellClass: 'text-center',
      cellRenderer: (params: any) => {
        const estado = params.value;
        let colorClasses = 'bg-[#F5F5F5] text-[#363636]';
        
        if (estado === 'Actualizado') {
          colorClasses = 'bg-[#DCFDE7] text-[#16A34A]';
        } else if (estado === 'Revertido') {
          colorClasses = 'bg-[#FFF0BF] text-[#F2A626]';
        }
        
        return `<span class="badge-table ${colorClasses}">${estado}</span>`;
      },
      cellStyle: {
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    }
  ];

  rowSelection: RowSelectionOptions | 'single' | 'multiple' = {
    mode: 'multiRow',
  };

  initialState: GridState = {};

  historialActualizaciones: any[] = [];

  // Facade

  constructor(
    private fb: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController
    
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Effect para sincronizar datos del store con la tabla
    effect(() => {
      const datos = this.actualizacionProductos();
      this.rowData = datos;

      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });
  }

  ngOnInit() {
    this.catalogosFacade.inicializarCatalogos();
    this.initForm();
    
    // Cargar datos desde el store vía facade
    this.almacenFacade.cargarActualizacionProductos();
  }

  initForm() {
    this.actualizacionForm = this.fb.group({
      proveedor: [{ value: '', disabled: true }],
      precioAnterior: [{ value: '', disabled: true }],
      precioUltima: [{ value: '', disabled: true }],
      diferencia: [{ value: '', disabled: true }],
      ultimaFactura: [{ value: '', disabled: true }],
      nFactura: [{ value: '', disabled: true }],
      estado: [{ value: '', disabled: true }]
    });
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onSelectionChanged(event: any) {
    this.filasSeleccionadasCount = this.gridApi.getSelectedRows().length;
  }

  onCellClicked(event: any) {
    const data: ActualizacionProductoEntity = event.data;
    this.filaSeleccionada = data;
    this.productoSeleccionadoNombre = `Producto: ${data.actualizacion_codigo} - ${data.actualizacion_descripcion}`;
    this.gridApi.deselectAll();
    event.node.setSelected(true);

    this.actualizacionForm.patchValue({
      proveedor: data.actualizacion_proveedor || '',
      precioAnterior: data.actualizacion_precio_anterior || 0,
      precioUltima: data.actualizacion_precio_ultima || 0,
      diferencia: data.actualizacion_diferencia || 0,
      ultimaFactura: data.actualizacion_fecha_ultima || '',
      nFactura: data.actualizacion_n_factura || '',
      estado: data.actualizacion_estado || ''
    }, { emitEvent: false });
    this.botonesDesactivados = data.actualizacion_estado !== 'Pendiente';
    this.botonRevertirDesactivado = data.actualizacion_estado !== 'Pendiente';
  }

  onBtReset() {
    if (this.gridApi) {
      this.almacenFacade.cargarActualizacionProductos();
    }
  }

  buttonActualizar() {
    if (!this.filaSeleccionada) {
      return;
    }

    const codigo = this.filaSeleccionada.actualizacion_codigo;

    // Actualizar el array local con copia inmutable de la fila
    this.rowData = this.rowData.map(r =>
      r.actualizacion_codigo === codigo
        ? { ...r, actualizacion_estado: 'Actualizado' as const }
        : r
    );

    // Actualizar referencia de fila seleccionada
    this.filaSeleccionada = this.rowData.find(r => r.actualizacion_codigo === codigo)!;

    // Refrescar la grilla con los datos actualizados
    this.gridApi.setGridOption('rowData', this.rowData);

    // Actualizar formulario
    this.actualizacionForm.patchValue({ estado: 'Actualizado' }, { emitEvent: false });

    // Registrar en historial
    const ahora = new Date();
    const horaFormato = `${String(ahora.getDate()).padStart(2, '0')}/${String(ahora.getMonth() + 1).padStart(2, '0')}/${ahora.getFullYear()} - ${String(ahora.getHours()).padStart(2, '0')}:${String(ahora.getMinutes()).padStart(2, '0')}`;

    this.historialActualizaciones.unshift({
      fechaHora: horaFormato,
      usuario: 'Usuario actual',
      accion: 'Actualizar precio',
      detalleCambio: `Precio de S/ ${this.filaSeleccionada.actualizacion_precio_anterior.toFixed(2)} actualizado a S/ ${this.filaSeleccionada.actualizacion_precio_ultima.toFixed(2)}. Factura: ${this.filaSeleccionada.actualizacion_n_factura}`,
      estado: 'Actualizado'
    });

    this.botonesDesactivados = true;
    this.botonRevertirDesactivado = false;
    this.toastService.success('¡Precio actualizado exitosamente!');
  }

  async abrirModalRevertir() {
    const detalles = [
      { label: 'Proveedor', value: this.filaSeleccionada?.actualizacion_proveedor || '' },
      { label: 'Nº de factura', value: this.filaSeleccionada?.actualizacion_n_factura || '' }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Producto: ${this.filaSeleccionada?.actualizacion_codigo || ''} - ${this.filaSeleccionada?.actualizacion_descripcion || ''}`,
        subtitulomodal: 'Detalle de la reversión',
        detalles: detalles,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo de la reversión:',
        placeholderTextarea: 'Describe el motivo de la reversión...',
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Revertir',
        colorBotonConfirmar: 'primary'
      }
    });
    
    await modal.present();
    const { data } = await modal.onWillDismiss();
    
    if (data?.action === 'confirmar') {
      const codigo = this.filaSeleccionada!.actualizacion_codigo;

      // Actualizar el array local con copia inmutable de la fila
      this.rowData = this.rowData.map(r =>
        r.actualizacion_codigo === codigo
          ? { ...r, actualizacion_estado: 'Revertido' as const }
          : r
      );

      // Actualizar referencia de fila seleccionada
      this.filaSeleccionada = this.rowData.find(r => r.actualizacion_codigo === codigo)!;

      // Refrescar la grilla con los datos actualizados
      this.gridApi.setGridOption('rowData', this.rowData);

      // Actualizar formulario
      this.actualizacionForm.patchValue({ estado: 'Revertido' }, { emitEvent: false });

      // Registrar en historial
      const ahora = new Date();
      const horaFormato = `${String(ahora.getDate()).padStart(2, '0')}/${String(ahora.getMonth() + 1).padStart(2, '0')}/${ahora.getFullYear()} - ${String(ahora.getHours()).padStart(2, '0')}:${String(ahora.getMinutes()).padStart(2, '0')}`;

      this.historialActualizaciones.unshift({
        fechaHora: horaFormato,
        usuario: 'Usuario actual',
        accion: 'Revertir actualización',
        detalleCambio: `Reversión de actualización. Motivo: ${data.motivo || 'No especificado'}`,
        estado: 'Revertido'
      });

      this.botonesDesactivados = true;
      this.botonRevertirDesactivado = true;
      this.toastService.success('¡Precio revertido exitosamente!');
    }
  }

  async modalverActualizaciones() {
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 100, },
      { headerName: 'Usuario', field: 'usuario', width: 120, },
      {
        headerName: 'Acción', field: 'accion', width: 100,
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
      { 
        headerName: 'Estado', 
        headerClass: 'centrarencabezado',
        field: 'estado',
        width: 90,
        cellClass: 'text-center',
        cellRenderer: (params: any) => {
          const estado = params.value;
          let colorClasses = 'bg-[#F5F5F5] text-[#363636]';
          
          if (estado === 'Actualizado') {
            colorClasses = 'bg-[#DCFDE7] text-[#16A34A]';
          } else if (estado === 'Revertido') {
            colorClasses = 'bg-[#FEF3C7] text-[#B45309]';
          }
          
          return `<span class="badge-table ${colorClasses}">${estado}</span>`;
        },
        cellStyle: {
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
        },
      }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de actualizaciones de precios ${this.filaSeleccionada?.actualizacion_codigo || ''} - ${this.filaSeleccionada?.actualizacion_descripcion || ''}`,
        rowData: this.historialActualizaciones,
        colDefs: colDefs,
        altoModal: '400px'
      }
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