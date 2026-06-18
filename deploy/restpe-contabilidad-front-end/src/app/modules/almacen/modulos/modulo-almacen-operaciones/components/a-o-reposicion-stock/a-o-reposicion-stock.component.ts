import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import {Component, OnInit, OnDestroy, inject} from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController, ViewWillEnter } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef, ISelectCellEditorParams } from 'ag-grid-community';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';


@Component({
  selector: 'app-a-o-reposicion-stock',
  templateUrl: './a-o-reposicion-stock.component.html',
  styleUrls: ['./a-o-reposicion-stock.component.scss'],
  standalone: false,
})
export class AOReposicionStockComponent implements OnInit, OnDestroy, CanComponentDeactivate, ViewWillEnter {
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
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  panelLateralVisible: boolean = true;
  fechaInicial: Date | undefined;

  requerimientoForm!: FormGroup;
  productoAutocomplete: any = null;
  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'a-o-reposicion-stock'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }
  tipoSeleccionado: string = 'solicitud';
  gridContext!: { componentParent: AOReposicionStockComponent };
  filaSeleccionada: any = null;
  private reposicionSeleccionadaData: any = null;
  productoSeleccionado: any = null;
  btnTexto: string = 'Registrar';

  //  Inyección del facade de catálogos
  readonly unidadesMedida = this.catalogosFacade.unidadesMedida;

  tipoFs = [
    { value: 'solicitud', nombre: 'Solicitud' },
    { value: 'reposicion', nombre: 'Reposición' },
  ]
  estadoSelect = [
    { id: 'Pendiente', nombre: 'Pendiente' },
    { id: 'Atendida', nombre: 'Atendida' },
    { id: 'Rechazada', nombre: 'Rechazada' },
    { id: 'En proceso', nombre: 'En proceso' },
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
  
  readonly productos = this.almacenFacade.productosReposicionStock;
  // La lista principal de reposiciones se gestiona a través del store (facade.reposicionesStock)

  colDefs: ColDef[] = [
    { field: 'reposicion_stock_codigo', headerName: 'Código', width: 100 },
    { field: 'reposicion_stock_fecha_solicitud', headerName: 'Fecha solicitud', width: 130,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() ).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      } 
    },
    { field: 'reposicion_stock_producto', headerName: 'Producto a reponer', flex: 1, minWidth: 150 },
    { field: 'reposicion_stock_almacen_solicitante', headerName: 'Almacén solicitante', width: 150 },
    { headerName: 'Cantidad solicitada', width: 150, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'end', alignItems: 'center', },
      valueFormatter: (params: any) => {
        return `${params.data.reposicion_stock_cantidad_solicitada} ${params.data.reposicion_stock_medida}`;
      }
    },
    { field: 'reposicion_stock_fecha_respuesta', headerName: 'Fecha reposición', width: 130,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() ).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      } 
    },
    { field: 'reposicion_stock_responsable', headerName: 'Responsable de solicitar', width: 200 },
    { field: 'reposicion_stock_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', },
      cellRenderer: (params: any) => {
        if (params.value === 'Atendida') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Atendida</span>';
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        } else if (params.value === 'En proceso') {
          return '<span class="badge-table bg-[#FFF0BF] text-[#F2A626]">En proceso</span>';
        } else if (params.value === 'Anulada') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulada</span>';
        } else if (params.value === 'Rechazada') {
          return '<span class="badge-table bg-[#FFDECC] text-[#FF8947]">Rechazada</span>';
        }
        return params.value;
      },
    },
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
    // Obtener fecha de hoy en formato YYYY-MM-DD
    const hoy = new Date().toISOString().split('T')[0];

    // Inicializar formulario con valores por defecto para evitar errores al usarlo
    this.requerimientoForm = this.formBuilder.group({
      usuario: [{ value: 'Eduardo Jimenez Lopez', disabled: true }],
      fechaS: [{ value: hoy, disabled: true }],
      fechaR: ['', Validators.required],
      almacenS: ['', Validators.required],
      producto: ['', Validators.required],
      stockA: [{value:'', disabled: true}],
      stockMin: [{value:'', disabled: true}],
      cantidadS: ['', [Validators.required, Validators.min(1)]],
      medida: ['', Validators.required],
      observacion: [''],
      estado: [{ value: 'Pendiente', disabled: true }],
    });

    // Contexto de la grilla (si se usa en cellRenderers u otros)
    this.gridContext = { componentParent: this };

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.requerimientoForm);

    //   Inicializar catálogos compartidos
    this.catalogosFacade.inicializarCatalogos();
  }

  ionViewWillEnter() {
    this.almacenFacade.cargarReposicionesStock();
    this.almacenFacade.cargarProductosReposicionStock();
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  tieneModificaciones(): boolean {
    return this.formValidationService.tieneModificaciones();
  }

  onAlmacenSeleccionado(almacen: any) {
    console.log('Almacén seleccionado:', almacen);
  }
  onProductoSeleccionado(producto: any) {
    if (producto) {
      this.productoSeleccionado = producto;

      // llenar campos del formulario
      this.requerimientoForm.patchValue({
        stockA: producto.stockA,
        stockMin: producto.stockMin,
        medida: producto.medida,
      });
    }

  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    if (this.reposicionSeleccionadaData) {
      setTimeout(() => {
        this.gridApi.forEachNode(node => {
          if (node.data === this.reposicionSeleccionadaData) {
            node.setSelected(true);
            this.filaSeleccionada = node.data;
          }
        });
      }, 150);
    }
  }

  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  async onCellClicked(event: any) {
    const data = event?.data;
    if (!data) { return; }

    // Prevenir selección automática de AG-Grid
    event.node.setSelected(true);

    // Guardar referencia del elemento que tiene el foco
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Mantener selección anterior
      if (this.filaSeleccionada) {
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
            if (node.data.almacen_codigo === this.filaSeleccionada.almacen_codigo) {
              node.setSelected(true);
            }
          });

          // Restaurar el foco al campo que estaba activo
          if (elementoConFoco && elementoConFoco.tagName === 'INPUT') {
            setTimeout(() => {
              elementoConFoco.focus();
            }, 100);
          }
        }, 0);
      } else {
        this.gridApi.deselectAll();
      }
      return;
    }

    // Cargar datos del requerimiento seleccionado
    this.cargarDatosRequerimiento(data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosRequerimiento(data: any, node?: any): void {
    this.filaSeleccionada = data;
    this.reposicionSeleccionadaData = data;

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    if (node) {
      node.setSelected(true);
    }

    // Habilitar todos los controles ANTES de patchValue para que writeValue llegue a los autocompletes
    Object.keys(this.requerimientoForm.controls).forEach(key =>
      this.requerimientoForm.get(key)?.enable({ emitEvent: false })
    );

    // Resolver campos con nombres snake_case del JSON (con fallback camelCase)
    const productoId = data.reposicion_stock_producto       ?? data.producto    ?? '';
    const almacenId  = data.reposicion_stock_almacen_solicitante ?? data.almacenS ?? '';
    const estado     = data.reposicion_stock_estado          ?? data.estado      ?? '';

    // Buscar el producto en el array de productos para obtener stock actual y mínimo
    const productoEncontrado = this.productos().find((p: any) => p.id === productoId);

    // Convertir fechas de DD/MM/YYYY o YYYY-MM-DD
    const convertirFecha = (fecha: string): string => {
      if (!fecha) return '';
      const partes = fecha.split('/');
      if (partes.length === 3) {
        return `${partes[2]}-${partes[1]}-${partes[0]}`;
      }
      return fecha; // ya en formato YYYY-MM-DD
    };

    this.requerimientoForm.patchValue({
      usuario:    data.reposicion_stock_responsable        ?? data.responsable  ?? '',
      fechaS:     convertirFecha(data.reposicion_stock_fecha_solicitud ?? data.fechaS ?? ''),
      fechaR:     convertirFecha(data.reposicion_stock_fecha_respuesta  ?? data.fechaR ?? ''),
      almacenS:   almacenId,
      producto:   productoId,
      stockA:     (productoEncontrado as any)?.stockA    ?? productoEncontrado?.producto_stock_actual  ?? '',
      stockMin:   (productoEncontrado as any)?.stockMin  ?? productoEncontrado?.producto_stock_minimo ?? '',
      cantidadS:  data.reposicion_stock_cantidad_solicitada ?? data.cantidadS ?? '',
      medida:     data.reposicion_stock_medida              ?? data.medida     ?? '',
      observacion: data.reposicion_stock_observacion        ?? data.observacion ?? '',
      estado,
    });

    // Establecer el producto seleccionado para el autocomplete
    if (productoEncontrado) {
      this.productoSeleccionado = productoEncontrado;
    }

    this.requerimientoForm.get('stockA')?.disable();
    this.requerimientoForm.get('stockMin')?.disable();
    this.requerimientoForm.get('medida')?.disable();

    // Si el estado es Rechazada o Anulada, deshabilitar TODOS los campos
    if (data.estado === 'Rechazada' || data.estado === 'Anulada') {
      this.requerimientoForm.get('fechaR')?.disable();
      this.requerimientoForm.get('almacenS')?.disable();
      this.requerimientoForm.get('producto')?.disable();
      this.requerimientoForm.get('cantidadS')?.disable();
      this.requerimientoForm.get('observacion')?.disable();
      this.requerimientoForm.get('estado')?.disable();
    } else {
      // Para cualquier otro estado, habilitar todos los campos editables
      this.requerimientoForm.get('fechaR')?.enable();
      this.requerimientoForm.get('almacenS')?.enable();
      this.requerimientoForm.get('producto')?.enable();
      this.requerimientoForm.get('cantidadS')?.enable();
      this.requerimientoForm.get('observacion')?.enable();
      this.requerimientoForm.get('estado')?.enable();
    }

    // Cambiar texto del botón a 'Guardar'
    this.btnTexto = 'Guardar';

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }

  async botonRegistrarRequerimiento() {
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Cancelar acción
    }

    // Reiniciar el formulario a los valores por defecto
    if (this.requerimientoForm) {
      // Obtener fecha de hoy en formato YYYY-MM-DD
      const hoy = new Date().toISOString().split('T')[0];

      this.requerimientoForm.reset();
      // usar id esperado por los selects y asignar fecha de hoy automáticamente
      this.requerimientoForm.patchValue({
        usuario: 'Eduardo Jimenez Lopez',
        estado: 'Pendiente',
        fechaS: hoy, // siempre hoy en formato correcto
        medida: 'UND'
      });
      // Deshabilitar campos que no se editan por defecto
      this.requerimientoForm.get('fechaS')?.disable();
      this.requerimientoForm.get('usuario')?.disable();
      this.requerimientoForm.get('estado')?.disable();

      // Habilitar campos editables
      this.requerimientoForm.get('fechaR')?.enable();
      this.requerimientoForm.get('almacenS')?.enable();
      this.requerimientoForm.get('producto')?.enable();
      this.requerimientoForm.get('stockA')?.enable();
      this.requerimientoForm.get('stockMin')?.enable();
      this.requerimientoForm.get('cantidadS')?.enable();
      this.requerimientoForm.get('medida')?.enable();
      this.requerimientoForm.get('observacion')?.enable();

      this.filaSeleccionada = null;
      this.reposicionSeleccionadaData = null;
      this.productoSeleccionado = null;

      // Deseleccionar fila de la tabla
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }

      // Cambiar texto del botón a 'Registrar'
      this.btnTexto = 'Registrar';

      // Resetear estado del servicio de validación
      this.formValidationService.resetearEstado();
    }
  }

  // Generar código automático para nuevos requerimientos
  private generarCodigoRequerimiento(): string {
    const year = new Date().getFullYear();

    // Encontrar el número más alto de requerimientos del año actual
    const codigosDelAnio = this.facade.reposicionesStock()
      .map(item => item.reposicion_stock_codigo)
      .filter((almacen_codigo: string) => almacen_codigo.startsWith(`REP-${year}-`))
      .map((almacen_codigo: string) => parseInt(almacen_codigo.split('-')[2]))
      .filter((num: number) => !isNaN(num));

    const maxNumero = codigosDelAnio.length > 0 ? Math.max(...codigosDelAnio) : 0;
    const siguienteNumero = maxNumero + 1;

    // Formatear con ceros a la izquierda (3 dígitos)
    return `REP-${year}-${siguienteNumero.toString().padStart(3, '0')}`;
  }

  validacionBloqueo(): boolean {
    if (this.filaSeleccionada) {
      return this.filaSeleccionada.estado === 'Rechazada' || this.filaSeleccionada.estado === 'Anulada';
    } else {
      return false;
    }
  } 

  async abrirModalAnular() {

    const detallesEjemplo = [
      { label: 'Código', value: this.filaSeleccionada.almacen_codigo },
      { label: 'Prod. solicitado', value: this.filaSeleccionada.producto },
      { label: 'Cant.solicitada', value: this.filaSeleccionada.cantidadS + ' ' + this.filaSeleccionada.medida },
      { label: 'Usuario ejecutor', value: this.filaSeleccionada.responsable },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Anular requerimiento de reposición',
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
      // Validar que se haya ingresado un motivo
      if (!data.motivo || data.motivo.trim() === '') {
        this.toastService.warning('Debe ingresar un motivo para anular el requerimiento.');
        return;
      }

      // Actualizar estado del requerimiento a 'Anulada'
      const lista = [...this.facade.reposicionesStock()];
      const index = lista.findIndex(item => item.reposicion_stock_codigo === this.filaSeleccionada.reposicion_stock_codigo);

      if (index !== -1) {
        lista[index] = { ...lista[index], reposicion_stock_estado: 'Anulada' };
        this.almacenFacade.actualizarListaReposicionesStock(lista);

        // Actualizar la tabla
        this.gridApi.setGridOption('rowData', [...lista]);
      }

      this.toastService.success('¡Requerimiento anulado exitosamente!');

      // Limpiar formulario y volver al estado inicial (como si presionara "Registrar solicitud")
      this.limpiarFormulario();

      // Resetear servicio de validación
      this.formValidationService.resetearEstado();
    }
  }

  formatearFecha(fecha: Date): string {
    const dia = fecha.getDate().toString().padStart(2, '0');
    const mes = (fecha.getMonth() + 1).toString().padStart(2, '0');
    const anio = fecha.getFullYear();
    return `${anio}-${mes}-${dia}`;
  }

  botonGuardar() {
    // Validar que el formulario sea válido
    if (this.requerimientoForm.invalid) {
      this.toastService.warning('Por favor, complete todos los campos requeridos.');
      return;
    }

    // Obtener valores del formulario (incluyendo los deshabilitados)
    const formValue = this.requerimientoForm.getRawValue();

    if (this.filaSeleccionada) {
      // EDITAR: Actualizar requerimiento existente
      const lista = [...this.facade.reposicionesStock()];
      const index = lista.findIndex(item => item.reposicion_stock_codigo === this.filaSeleccionada.reposicion_stock_codigo);

      if (index !== -1) {
        lista[index] = {
          reposicion_stock_codigo: this.filaSeleccionada.reposicion_stock_codigo,
          reposicion_stock_fecha_solicitud: formValue.fechaS,
          reposicion_stock_producto: formValue.producto,
          reposicion_stock_almacen_solicitante: formValue.almacenS,
          reposicion_stock_cantidad_solicitada: formValue.cantidadS,
          reposicion_stock_medida: formValue.medida,
          reposicion_stock_fecha_respuesta: this.formatearFecha(formValue.fechaR),
          reposicion_stock_responsable: formValue.usuario,
          reposicion_stock_estado: formValue.estado,
        };

        this.almacenFacade.actualizarListaReposicionesStock(lista);
        // Actualizar la tabla
        this.gridApi.setGridOption('rowData', [...lista]);

        this.toastService.success('¡Cambios guardados exitosamente!');
      }
    } else {
      // AGREGAR: Crear nuevo requerimiento
      const nuevoCodigo = this.generarCodigoRequerimiento();

      const nuevoRequerimiento = {
        almacen_codigo: nuevoCodigo,
        fechaS: formValue.fechaS,
        producto: formValue.producto,
        almacenS: formValue.almacenS,
        cantidadS: formValue.cantidadS,
        medida: formValue.medida,
        fechaR: this.formatearFecha(formValue.fechaR),
        responsable: formValue.usuario,
        estado: formValue.estado,
        observacion: formValue.observacion
      };

      const listaActualizada = [nuevoRequerimiento, ...this.facade.reposicionesStock()];
      this.almacenFacade.actualizarListaReposicionesStock(listaActualizada);
      // Actualizar la tabla
      this.gridApi.setGridOption('rowData', [...listaActualizada]);

      this.toastService.success('¡Requerimiento registrado exitosamente!');
    }

    // Limpiar formulario y resetear a estado inicial
    this.limpiarFormulario();

    // Resetear servicio de validación después de limpiar el formulario
    this.formValidationService.resetearEstado();
  }

  // Método para limpiar y resetear el formulario
  private limpiarFormulario(): void {
    // Obtener fecha de hoy en formato YYYY-MM-DD
    const hoy = new Date().toISOString().split('T')[0];

    this.requerimientoForm.reset();
    this.requerimientoForm.patchValue({
      usuario: 'Eduardo Jimenez Lopez',
      estado: 'Pendiente',
      fechaS: hoy,
      medida: 'UND'
    });

    // Deshabilitar campos que no se editan por defecto
    this.requerimientoForm.get('fechaS')?.disable();
    this.requerimientoForm.get('usuario')?.disable();
    this.requerimientoForm.get('estado')?.disable();

    // Habilitar campos editables
    this.requerimientoForm.get('fechaR')?.enable();
    this.requerimientoForm.get('almacenS')?.enable();
    this.requerimientoForm.get('producto')?.enable();
    this.requerimientoForm.get('stockA')?.enable();
    this.requerimientoForm.get('stockMin')?.enable();
    this.requerimientoForm.get('cantidadS')?.enable();
    this.requerimientoForm.get('medida')?.enable();
    this.requerimientoForm.get('observacion')?.enable();

    this.filaSeleccionada = null;
    this.productoSeleccionado = null;

    // Deseleccionar fila de la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Cambiar texto del botón a 'Registrar'
    this.btnTexto = 'Registrar';
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
        titulo: `Historial de Actualizaciones del requerimiento ${this.filaSeleccionada.almacen_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

  onFechaSeleccionada(date: Date) {
    console.log('Fecha seleccionada:', date);
    if (this.requerimientoForm && date) {
      const fechaCtrl = this.requerimientoForm.get('fechaR');
      if (fechaCtrl) {
        fechaCtrl.setValue(date);
      }
    }
  }

  onBtReset() {
    this.almacenFacade.cargarReposicionesStock();
  }
}

