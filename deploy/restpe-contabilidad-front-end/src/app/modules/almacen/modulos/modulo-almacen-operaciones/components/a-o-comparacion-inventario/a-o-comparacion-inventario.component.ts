import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';

import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController, ViewWillEnter } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-a-o-comparacion-inventario',
  templateUrl: './a-o-comparacion-inventario.component.html',
  styleUrls: ['./a-o-comparacion-inventario.component.scss'],
  standalone: false,
})
export class AOComparacionInventarioComponent implements OnInit, OnDestroy, CanComponentDeactivate, ViewWillEnter {
  // Facades
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Acceso al facade desde el template
  protected readonly facade = this.almacenFacade;

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.isLoading;



  // ---------------------------------------------------------------------------
  // Inyección de dependencias
  // ---------------------------------------------------------------------------

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;




  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  fechaInicial: Date | undefined;

  panelLateralVisible: boolean = true;
  comparacionForm!: FormGroup;
  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'a-o-comparacion-inventario'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }
  tipoSeleccionado: string = 'registro';
  gridContext!: { componentParent: AOComparacionInventarioComponent };
  filaSeleccionada: any = null;
  private comparacionSeleccionadaData: any = null;
  almacenSeleccionado: any = null;
  modoCreacion: boolean = true;

  tipoFs = [
    { value: 'registro', nombre: 'Registro' },
    { value: 'devol', nombre: 'Devolución' },
  ]

  // ---------------------------------------------------------------------------
  // Catálogos desde Facade
  // ---------------------------------------------------------------------------
  productosPorAlmacen: any = {

    'Almacén Principal': [
      { almacen_codigo: 'PROD-001', nombre: 'Harina de Trigo 10KG', tipoA: 'Entrada', stockS: 110, stockF: 10, diferenciaC: 100, diferenciaV: 999.99, medida: 'UND' },
      { almacen_codigo: 'PROD-002', nombre: 'Leche Gloria 410g', tipoA: 'Entrada', stockS: 18, stockF: 10, diferenciaC: 8, diferenciaV: 999.99, medida: 'UND' },
      { almacen_codigo: 'PROD-003', nombre: 'Azúcar Rubia 5KG', tipoA: 'Salida', stockS: 15, stockF: 10, diferenciaC: 5, diferenciaV: 999.99, medida: 'UND' },
    ],

    'Almacén Alvarado': [
      { almacen_codigo: 'PROD-010', nombre: 'Aceite Girasol 1L', tipoA: 'Entrada', stockS: 112, stockF: 10, diferenciaC: 102, diferenciaV: 999.99, medida: 'UND' },
      { almacen_codigo: 'PROD-011', nombre: 'Arroz Extra 50KG', tipoA: 'Entrada', stockS: 12, stockF: 10, diferenciaC: 2, diferenciaV: 999.99, medida: 'SACO' },
    ],

    'Almacén chiquito': [
      { almacen_codigo: 'PROD-020', nombre: 'Fideos Tallarín 1KG', tipoA: 'Entrada', stockS: 120, stockF: 10, diferenciaC: 110, diferenciaV: 999.99, medida: 'UND' },
      { almacen_codigo: 'PROD-021', nombre: 'Mantequilla Gloria 200g', tipoA: 'Entrada', stockS: 115, stockF: 10, diferenciaC: 105, diferenciaV: 999.99, medida: 'UND' },
      { almacen_codigo: 'PROD-022', nombre: 'Huevos AA Caja x 30', tipoA: 'Entrada', stockS: 16, stockF: 10, diferenciaC: 6, diferenciaV: 999.99, medida: 'CJ' },
    ],

    'Almacén Surquillo': [
      { almacen_codigo: 'PROD-030', nombre: 'Gaseosa Coca-Cola 1.5L', tipoA: 'Entrada', stockS: 124, stockF: 10, diferenciaC: 114, diferenciaV: 999.99, medida: 'UND' },
      { almacen_codigo: 'PROD-031', nombre: 'Jabón Bolívar Barra', tipoA: 'Entrada', stockS: 130, stockF: 10, diferenciaC: 120, diferenciaV: 999.99, medida: 'UND' },
    ],

    'Almacén Miraflores': [
      { almacen_codigo: 'PROD-040', nombre: 'Café Altomayo 200g', tipoA: 'Entrada', stockS: 118, stockF: 10, diferenciaC: 108, diferenciaV: 999.99, medida: 'UND' },
      { almacen_codigo: 'PROD-041', nombre: 'Té Hornimans 100 sobres', tipoA: 'Salida', stockS: 15, stockF: 10, diferenciaC: 5, diferenciaV: 999.99, medida: 'UND' },
      { almacen_codigo: 'PROD-042', nombre: 'Chocolate Sol del Cusco 90g', tipoA: 'Entrada', stockS: 122, stockF: 10, diferenciaC: 112, diferenciaV: 999.99, medida: 'UND' },
    ]

  };
  private gridApiDetalle!: GridApi;

  estadoSelect = [
    { id: 'Pendiente', nombre: 'Pendiente' },
    { id: 'Aprobado', nombre: 'Aprobado' },
    { id: 'Aplicado', nombre: 'Aplicado' },
    { id: 'Anulado', nombre: 'Anulado' },
  ];

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
  rowDataDetalle = [

  ];

  colDefs: ColDef[] = [
    { field: 'comparacion_inventario_codigo', headerName: 'Código', width: 90 },
    { field: 'comparacion_inventario_fecha_conteo', headerName: 'Fecha conteo', width: 100 },
    { field: 'comparacion_inventario_almacen', headerName: 'Almacén solicitante', width: 130, filter: true, },
    {
      field: 'comparacion_inventario_producto', headerName: 'Producto en inventario', width: 180,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'end', alignItems: 'center', },
    },
    { field: 'comparacion_inventario_responsable', headerName: 'Responsable de registro', flex: 1 },
    { field: 'comparacion_inventario_observacion', headerName: 'Observaciones', width: 120, },
    {
      field: 'comparacion_inventario_estado', headerName: 'Estado', width: 100, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', },
      cellRenderer: (params: any) => {
        if (params.value === 'Aprobado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Aprobado</span>';
        } else if (params.value === 'Aplicado') {
          return '<span class="badge-table bg-primary-5 text-primary">Aplicado</span>';
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        } else if (params.value === 'Anulado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulado</span>';
        }
        return params.value;
      },
    },

  ];

  colDefsDetalle: ColDef[] = [
    { field: 'almacen_codigo', headerName: 'Código', width: 80 },
    { field: 'nombre', headerName: 'Nombre de producto', flex: 1, minWidth: 200 },
    { field: 'stockS', headerName: 'Stock sistema', width: 130, valueGetter: p => `${p.data.stockS}` },
    { field: 'medidastocksistema', headerName: 'Unidad de medida', width: 130, valueGetter: p => `${p.data.medida}` },
    { field: 'stockF', headerName: 'Stock físico', width: 130, valueGetter: p => `${p.data.stockF}` },
    { field: 'medidastockfisico', headerName: 'Unidad de medida', width: 130, valueGetter: p => `${p.data.medida}` },
    { field: 'diferenciaC', headerName: 'Diferencia (cantidad)', width: 130, valueGetter: p => `${p.data.diferenciaC} ${p.data.medida}` },
    { field: 'medidaunidad', headerName: 'Unidad de medida', width: 130, valueGetter: p => `${p.data.medida}` },
    {
      field: 'diferenciaV', headerName: 'Diferencia (Valor)', width: 130, headerClass: 'derechaencabezado',
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
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'end', };
        if (params.value < 0) {
          style.color = '#EF4444'; // Rojo para negativos
        }
        return style;
      },
    },
    { field: 'tipoA', headerName: 'Tipo ajuste', width: 130, filter: true },
  ];


  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  ngOnInit() {
    // Inicializar catálogos compartidos
    this.catalogosFacade.inicializarCatalogos();

    // Obtener la fecha de hoy en formato DD/MM/YYYY
    const fechaHoy = new Date().toLocaleDateString('es-ES', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric'
    });

    // Inicializar formulario con valores por defecto para nuevo registro
    this.comparacionForm = this.formBuilder.group({
      usuario: [{ value: 'Eduardo Jimenez Lopez', disabled: true }],
      FechaC: [{ value: fechaHoy, disabled: true }],
      almacen: ['', Validators.required],
      observacion: [''],
      estado: [{ value: 'Pendiente', disabled: true }],
    });

    // Inicializar servicio de validación de formularios
    this.formValidationService.inicializarFormulario(this.comparacionForm);

    // Contexto de la grilla (si se usa en cellRenderers u otros)
    this.gridContext = { componentParent: this };

    // Asegurar que inicie sin fila seleccionada (modo nuevo registro)
    this.filaSeleccionada = null;
    this.almacenSeleccionado = null;
    this.rowDataDetalle = [];
  }

  ionViewWillEnter() {
    this.almacenFacade.cargarComparacionesInventario();
  }

  ngOnDestroy() {
    // Limpiar el tracking del formulario
    this.formValidationService.limpiarFormulario();
  }

  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  tieneModificaciones(): boolean {
    return this.formValidationService.tieneModificaciones();
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible
  }
  onAlmacenSeleccionado(almacen: any) {
    if (almacen) {
      this.almacenSeleccionado = almacen;
      // La clave del mapa es el nombre del almacén
      this.rowDataDetalle = this.productosPorAlmacen[almacen.almacen_nombre] ?? [];
    } else {
      this.rowDataDetalle = [];
    }
  }



  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    if (this.comparacionSeleccionadaData) {
      setTimeout(() => {
        this.gridApi.forEachNode(node => {
          if (node.data === this.comparacionSeleccionadaData) {
            node.setSelected(true);
            this.filaSeleccionada = node.data;
          }
        });
      }, 150);
    }
  }


  // onGridReadyDetalle(params: GridReadyEvent) {
  //   this.gridApi = params.api;
  // }

  onGridReadyDetalle(params: GridReadyEvent) {
  this.gridApiDetalle = params.api;
}

  // 3. Validar antes de cambiar de registro
  async onCellClicked(event: any) {
    const puede = await this.formValidationService.validarCambios();
    
    if (!puede) {
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
        }
      }, 0);
      return;
    }

    this.cargarDatos(event.data);
  }

  // 6. Cargar datos y resetear estado
  private cargarDatos(data: any) {
    this.filaSeleccionada = data;
    this.comparacionSeleccionadaData = data;
    this.modoCreacion = false;

    // Seleccionar la fila en AG-Grid
    if (this.gridApi) {
      this.gridApi.forEachNode(node => {
        if (node.data === data) node.setSelected(true);
      });
    }

    // Resolver campos snake_case del JSON (con fallback camelCase)
    const almacenNombre = data.comparacion_inventario_almacen ?? data.almacen ?? '';
    const estado        = data.comparacion_inventario_estado  ?? data.estado  ?? '';

    // Buscar el objeto almacén para mostrar el detalle de productos
    this.almacenSeleccionado = this.almacenes().find(alm => alm.almacen_nombre === almacenNombre) ?? null;
    this.rowDataDetalle = this.productosPorAlmacen[almacenNombre] ?? [];

    // Habilitar todos los controles ANTES de patchValue para que writeValue llegue al autocomplete
    Object.keys(this.comparacionForm.controls).forEach(key =>
      this.comparacionForm.get(key)?.enable({ emitEvent: false })
    );

    this.comparacionForm.patchValue({
      usuario:     data.comparacion_inventario_responsable    ?? data.responsable  ?? '',
      FechaC:      data.comparacion_inventario_fecha_creacion ?? data.fechaC       ?? '',
      almacen:     almacenNombre,
      observacion: data.comparacion_inventario_observacion   ?? data.observacion  ?? '',
      estado,
    });

    // Asegurar que FechaC y usuario siempre estén disabled
    this.comparacionForm.get('FechaC')?.disable();
    this.comparacionForm.get('usuario')?.disable();

    // Marcar como estado guardado
    this.formValidationService.resetearEstado();
  }

  // 4. Validar antes de crear nuevo registro
  async botonRegistrarDevolucion() {
    const puede = await this.formValidationService.validarCambios();
    
    if (!puede) {
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
        }
      }, 0);
      return;
    }

    // Reiniciar el formulario a los valores por defecto (modo nuevo registro)
    if (this.comparacionForm) {
      this.comparacionForm.reset();

      // Obtener la fecha de hoy en formato DD/MM/YYYY
      const fechaHoy = new Date().toLocaleDateString('es-ES', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
      });

      // Asignar valores por defecto y deshabilitar campos correspondientes
      this.comparacionForm.patchValue({
        usuario: 'Eduardo Jimenez Lopez',
        estado: 'Pendiente',
        FechaC: fechaHoy
      });
      // Deshabilitar campos que no deben ser editables en nuevo registro
      this.comparacionForm.get('usuario')?.disable();
      this.comparacionForm.get('FechaC')?.disable();
      this.comparacionForm.get('estado')?.disable();

      // Limpiar variables de estado
      this.filaSeleccionada = null;
      this.comparacionSeleccionadaData = null;
      this.almacenSeleccionado = null;
      this.modoCreacion = true;
      this.rowDataDetalle = [];

      // Deseleccionar filas de la grilla
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }

      this.formValidationService.resetearEstado();
    }
  }

  botonAnularDevolucion() {
    this.abrirModalAnular();
  }

  async abrirModalAnular() {

    const detallesEjemplo = [
      { label: 'Código', value: this.filaSeleccionada.almacen_codigo },
      { label: 'Alm. solicitante', value: this.filaSeleccionada.almacen },
      { label: 'Prod. en inventario', value: this.filaSeleccionada.producto },
      { label: 'Usuario ejecutor', value: this.filaSeleccionada.responsable },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Anular comparativa de inventario',
        subtitulomodal: 'Detalle de anulación',
        detalles: detallesEjemplo,
        tituloTextarea: 'Motivo de anulación',
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Anular',
        colorBotonConfirmar: 'danger'
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      // Confirmar inactivación - mantener el estado Inactivo
      this.toastService.success('¡Proceso anulado exitosamente!');
    }
  }

  botonGuardar() {
    // Validar que el formulario tenga los datos mínimos
    if (!this.comparacionForm.get('almacen')?.value) {
      this.toastService.warning("Por favor, Selecciona un almacén");
      return;
    }

    if (!this.filaSeleccionada) {
      // Modo nuevo registro
      const existing = this.facade.comparacionesInventario();
      const nuevoCodigo = `COM-2025-${(existing.length + 1).toString().padStart(3, '0')}`;
      const fechaHoy = new Date().toLocaleDateString('es-ES', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
      });

      // Contar productos del almacén seleccionado
      const productosDelAlmacen = this.productosPorAlmacen[this.comparacionForm.get('almacen')?.value] || [];

      const nuevoRegistro = {
        almacen_codigo: nuevoCodigo,
        fechaC: fechaHoy,
        producto: productosDelAlmacen.length.toString(),
        almacen: this.comparacionForm.get('almacen')?.value,
        responsable: this.comparacionForm.get('usuario')?.value || 'Eduardo Jimenez Lopez',
        observaciones: this.comparacionForm.get('observacion')?.value || '',
        estado: 'Pendiente',
        observacion: this.comparacionForm.get('observacion')?.value || ''
      };

      // Actualizar el store con el nuevo registro al inicio
      this.almacenFacade.actualizarListaComparaciones([nuevoRegistro, ...existing]);

      // Mostrar toast de éxito
      this.toastService.success("¡Cambios guardados exitosamente!");

      // Resetear estado del servicio de validación después de guardar
      this.formValidationService.resetearEstado();

      // Seleccionar el registro recién creado y habilitar el selector de estado
      this.filaSeleccionada = nuevoRegistro;
      this.comparacionForm.patchValue({
        usuario: nuevoRegistro.responsable,
        FechaC: nuevoRegistro.fechaC,
        almacen: nuevoRegistro.almacen,
        observacion: '',
        estado: nuevoRegistro.estado
      });

      // Habilitar el campo estado para que sea un selector
      this.comparacionForm.get('estado')?.enable();
      // Asegurar que FechaC siempre esté disabled
      this.comparacionForm.get('FechaC')?.disable();

      // Seleccionar la nueva fila en la grilla
      if (this.gridApi) {
        // Esperar un momento para que la grilla se actualice
        setTimeout(() => {
          const firstNode = this.gridApi.getRowNode('0');
          if (firstNode) {
            firstNode.setSelected(true);
          }
        }, 100);
      }

    } else {
      // Modo edición - actualizar el registro existente
      const estadoActualizado = this.comparacionForm.get('estado')?.value;
      const observacionActualizada = this.comparacionForm.get('observacion')?.value;

      // Actualizar en el store
      const lista = [...this.facade.comparacionesInventario()];
      const index = lista.findIndex(r => r.comparacion_inventario_codigo === this.filaSeleccionada.comparacion_inventario_codigo);

      if (index !== -1) {
        // Actualizar el registro con estado y observación
        lista[index] = {
          ...lista[index],
          comparacion_inventario_estado: estadoActualizado,
          comparacion_inventario_observacion: observacionActualizada
        };

        this.almacenFacade.actualizarListaComparaciones(lista);

        // Reseleccionar la fila actualizada
        if (this.gridApi) {
          setTimeout(() => {
            const updatedNode = this.gridApi.getRowNode(index.toString());
            if (updatedNode) {
              updatedNode.setSelected(true);
            }
          }, 100);
        }

        // Actualizar filaSeleccionada con los nuevos valores
        this.filaSeleccionada = lista[index];

        this.toastService.success("¡Cambios guardados exitosamente!");
      }
    }
  }

  onTipoSeleccionado(tipo: any) {
    console.log('Tipo seleccionado:', tipo);
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos
    this.cargarDatosPorFechas(range.start, range.end);
  }

  cargarDatosPorFechas(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
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
      { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Se ha creado el grupo 1.00' },
      { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se edito la descripción del grupo' },
      { fechaHora: '13/11/2025 09:00', usuario: 'Carlos Rodríguez', accion: 'Actualización', detalleCambio: 'Se cambió el tipo de flujo' },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones de la Comparación ${this.filaSeleccionada?.almacen_codigo || ''}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

  onFechaSeleccionada(date: Date) {
    console.log('Fecha seleccionada:', date);
    if (this.comparacionForm && date) {
      const fechaCtrl = this.comparacionForm.get('fechaD');
      if (fechaCtrl) {
        fechaCtrl.setValue(date);
      }
    }
  }

  onBtReset() {
    this.almacenFacade.cargarComparacionesInventario();
  }
}

