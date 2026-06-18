import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import {Component, OnInit, OnDestroy, inject} from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController, ViewWillEnter } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-a-o-registro-perdidas',
  templateUrl: './a-o-registro-perdidas.component.html',
  styleUrls: ['./a-o-registro-perdidas.component.scss'],
  standalone: false,
})
export class AORegistroPerdidasComponent implements OnInit, OnDestroy, CanComponentDeactivate, ViewWillEnter {
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
  registroForm!: FormGroup;
  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'a-o-registro-perdidas'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }
  gridContext!: { componentParent: AORegistroPerdidasComponent };
  filaSeleccionada: any = null;
  private perdidasSeleccionadaData: any = null;
  productoSeleccionado: any = null;
  modoCreacion: boolean = true;

  //   Inyección del facade de catálogos
  readonly unidadesMedida = this.catalogosFacade.unidadesMedida;

  perdidaSelect = [
    { id: 'Vencimiento', nombre: 'Vencimiento' },
    { id: 'Deterioro', nombre: 'Deterioro' },
    { id: 'Evaporación', nombre: 'Evaporación' },
    { id: 'Rotura', nombre: 'Rotura' },
    { id: 'Otros', nombre: 'Otros' },
  ];
  readonly productos = this.almacenFacade.productosAlmacen;
  private gridApiDetalle!: GridApi;

  estadoSelect = [
    { id: 'Pendiente', nombre: 'Pendiente' },
    { id: 'Aprobado', nombre: 'Aprobado' },
    { id: 'Rechazado', nombre: 'Rechazado' },
    { id: 'Aplicado', nombre: 'Aplicado' },
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
  // La lista principal de registros de pérdidas se gestiona a través del store (facade.registroPerdidas)

  colDefs: ColDef[] = [
    { field: 'registro_perdidas_codigo', headerName: 'Código', width: 90 },
    { field: 'registro_perdidas_fecha_registro', headerName: 'Fecha registro', width: 100,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
     },
    { field: 'registro_perdidas_codigo_producto', headerName: 'Código de producto', width: 234 },
    { field: 'registro_perdidas_producto', headerName: 'Producto con pérdida', width: 234 },
    { field: 'registro_perdidas_almacen', headerName: 'Almacén', width: 150, filter: true, },
    { field: 'registro_perdidas_tipo', headerName: 'Tipo', width: 100, filter: true, },
    { headerName: 'Merma', width: 80, valueGetter: p => `${p.data.registro_perdidas_cantidad_perdida} ${p.data.registro_perdidas_medida}`, },
    { field: 'registro_perdidas_valor_unitario', headerName: 'Valor unitario', width: 100, headerClass: 'derechaencabezado',
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
            return `${formattedValue}`;
        }
        return '';
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'end', };
        if (params.value < 0) {
          style.color = '#EF4444'; // Rojo para negativos
        }
        return style;
      }
    },
    { field: 'registro_perdidas_valor_total', headerName: 'Valor total', width: 100, headerClass: 'derechaencabezado',
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
            return `${formattedValue}`;
        }
        return '';
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'end', };
        if (params.value < 0) {
          style.color = '#EF4444'; // Rojo para negativos
        }
        return style;
      }
    },
    { field: 'registro_perdidas_responsable', headerName: 'Responsable de registro', width: 150 },
    {
      field: 'registro_perdidas_estado', headerName: 'Estado', width: 100, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', },
      cellRenderer: (params: any) => {
        if (params.value === 'Aprobado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Aprobado</span>';
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        } else if (params.value === 'Aplicado') {
          return '<span class="badge-table bg-primary-5 text-primary">Aplicado</span>';
        } else if (params.value === 'Anulada') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulada</span>';
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
    // Inicializar formulario con valores por defecto para evitar errores al usarlo
    this.registroForm = this.formBuilder.group({
      usuario: [{ value: 'Eduardo Jimenez Lopez', disabled: true }],
      fechaR: [{value: this.getFechaHoy(), disabled: true }],
      almacen: ['', Validators.required],
      producto: ['', Validators.required],
      tipoP: ['', Validators.required],
      cantidadP: ['', Validators.required],
      medida: ['UND', Validators.required],
      valorU: [{ value: '', disabled: true }],
      valorT: [{ value: '', disabled: true }],
      observacion: [''],
      estado: [{ value: 'Pendiente', disabled: true }],
    });

    // Inicializar servicio de validación de formularios
    this.formValidationService.inicializarFormulario(this.registroForm);

    // Contexto de la grilla (si se usa en cellRenderers u otros)
    this.gridContext = { componentParent: this };

    //   Inicializar catálogos compartidos
    this.catalogosFacade.inicializarCatalogos();
  }

  ionViewWillEnter() {
    this.almacenFacade.cargarRegistroPerdidas();
    this.almacenFacade.cargarProductosAlmacen();
  }

  getFechaHoy(): string {
    return new Date().toISOString().substring(0, 10);
  }

  ngOnDestroy() {
    // Limpiar el tracking del formulario
    this.formValidationService.limpiarFormulario();
  }

  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible
  }

  tieneModificaciones(): boolean {
    return this.formValidationService.tieneModificaciones();
  }

  onAlmacenSeleccionado(almacen: any) {
    console.log('Almacén seleccionado:', almacen);
  }
  onproductoSeleccionado(producto: any) {
    if (producto) {
      this.productoSeleccionado = producto;
      this.registroForm.patchValue({
        valorU: (producto as any).valorU ?? producto.producto_valor_unitario ?? '',
        medida: (producto as any).medida ?? producto.producto_medida         ?? 'UND',
      });
    }
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    if (this.perdidasSeleccionadaData) {
      setTimeout(() => {
        this.gridApi.forEachNode(node => {
          if (node.data === this.perdidasSeleccionadaData) {
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

  // 3. Validar antes de cambiar de registro
  async onCellClicked(event: any) {
    console.log('onCellClicked - Evento:', event);
    const puede = await this.formValidationService.validarCambios();
    console.log('onCellClicked - Puede continuar:', puede);
    
    if (!puede) {
      console.log('onCellClicked - Cancelado por usuario, desmarcando...');
      setTimeout(() => {
        console.log('onCellClicked - setTimeout ejecutándose, gridApi:', !!this.gridApi);
        if (this.gridApi) {
          console.log('onCellClicked - Ejecutando deselectAll()')
          this.gridApi.deselectAll();
        }
      }, 0);
      return;
    }

    console.log('onCellClicked - Cargando datos:', event.data);
    this.cargarDatos(event.data);
  }

  // 6. Cargar datos y resetear estado
  private cargarDatos(data: any) {
    this.filaSeleccionada = data;
    this.perdidasSeleccionadaData = data;
    this.modoCreacion = false;

    if (this.gridApi) {
      this.gridApi.forEachNode(node => {
        if (node.data === data) node.setSelected(true);
      });
    }

    const estado = data.registro_perdidas_estado ?? data.estado ?? '';

    // Habilitar todos los controles ANTES de patchValue para que writeValue llegue a los autocompletes
    this.registroForm.enable({ emitEvent: false });

    this.registroForm.patchValue({
      usuario:    data.registro_perdidas_responsable      ?? data.responsable  ?? '',
      fechaR:     data.registro_perdidas_fecha_registro   ?? data.fechaR       ?? '',
      almacen:    data.registro_perdidas_almacen          ?? data.almacen      ?? '',
      producto:   data.registro_perdidas_producto         ?? data.producto     ?? '',
      tipoP:      data.registro_perdidas_tipo             ?? data.tipo         ?? '',
      valorU:     data.registro_perdidas_valor_unitario   ?? data.valorU       ?? '',
      valorT:     data.registro_perdidas_valor_total      ?? data.valorT       ?? '',
      cantidadP:  data.registro_perdidas_cantidad_perdida ?? data.cantidadP    ?? '',
      medida:     data.registro_perdidas_medida           ?? data.medida       ?? '',
      observacion: data.registro_perdidas_observacion     ?? data.observacion  ?? '',
      estado,
    });

    // Manejar el estado según el valor
    if (estado === 'Anulada') {
      this.registroForm.disable();
      this.registroForm.get('estado')?.setValue('Anulada');
    } else {
      // Mantener campos específicos deshabilitados
      this.registroForm.get('usuario')?.disable();
      this.registroForm.get('fechaR')?.disable();
      this.registroForm.get('valorU')?.disable();
      this.registroForm.get('valorT')?.disable();
      this.registroForm.get('estado')?.enable();
    }

    // Marcar como estado guardado
    this.formValidationService.resetearEstado();
  }

  // 4. Validar antes de limpiar formulario
  async botonRegistrarPerdida() {
    console.log('botonRegistrarPerdida - Iniciando...');
    const puede = await this.formValidationService.validarCambios();
    console.log('botonRegistrarPerdida - Puede continuar:', puede);
    
    if (!puede) {
      console.log('botonRegistrarPerdida - Usuario canceló, desmarcando fila...');
      // Si cancela, desmarcar la fila
      setTimeout(() => {
        console.log('botonRegistrarPerdida - setTimeout ejecutándose, gridApi:', !!this.gridApi);
        if (this.gridApi) {
          console.log('botonRegistrarPerdida - Ejecutando deselectAll()');
          this.gridApi.deselectAll();
          console.log('botonRegistrarPerdida - deselectAll() completado');
        }
      }, 0);
      return;
    }

    console.log('botonRegistrarPerdida - Reseteando formulario...');
    this.registroForm.reset();
    this.registroForm.patchValue({
      usuario: 'Eduardo Jimenez Lopez',
      fechaR: new Date(),
      medida: 'UND',
      estado: 'Pendiente'
    });
    
    // Deshabilitar campos que no se editan
    this.registroForm.get('fechaR')?.disable();
    this.registroForm.get('usuario')?.disable();
    this.registroForm.get('valorU')?.disable();
    this.registroForm.get('valorT')?.disable();
    this.registroForm.get('estado')?.disable();
    
    this.filaSeleccionada = null;
    this.perdidasSeleccionadaData = null;
    this.modoCreacion = true;

    // Deseleccionar cualquier fila en la tabla
    if (this.gridApi) {
      console.log('botonRegistrarPerdida - Desmarcando fichas (nuevo registro)');
      this.gridApi.deselectAll();
    }

    this.formValidationService.resetearEstado();
    console.log('botonRegistrarPerdida - Completado');
  }

  botonAnularPerdida() {
    this.abrirModalAnular();
  }

  async abrirModalAnular() {

    const detallesEjemplo = [
      { label: 'Código', value: this.filaSeleccionada.almacen_codigo },
      { label: 'Almacén', value: this.filaSeleccionada.almacen },
      { label: 'Prod.en inventario', value: '200' },
      { label: 'Usuario ejecutor', value: this.filaSeleccionada.responsable },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Anular merma',
        subtitulomodal: 'Detalle de anulación',
        detalles: detallesEjemplo,
        tituloTextarea: 'Motivo de anulación',
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Anular',
        colorBotonConfirmar: 'danger',
        motivoObligatorio: true
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      // Confirmar inactivación - mantener el estado Inactivo
      this.toastService.success('¡La acción se realizó con éxito!');
    }
  }

  // 5. Resetear después de guardar
  botonGuardar() {
    if (this.registroForm.invalid) {
      this.registroForm.markAllAsTouched();
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    console.log('Guardando...', this.registroForm.value);
    
    // Resetear tracking
    this.formValidationService.resetearEstado();
    this.toastService.success('¡Pérdida registrada exitosamente!');

    const formValue = this.registroForm.getRawValue();

    if (!this.filaSeleccionada) {
      // Es una nueva pérdida
      const nuevaPerdida = {
        almacen_codigo: `MER-2025-${String(this.facade.registroPerdidas().length + 1).padStart(3, '0')}`,
        fechaR: new Date().toLocaleDateString('es-PE'),
        producto: formValue.producto,
        codproducto: '',
        almacen: formValue.almacen,
        tipo: formValue.tipoP,
        cantidadP: formValue.cantidadP,
        medida: formValue.medida,
        valorU: formValue.valorU || 'S/ 0.00',
        valorT: formValue.valorT || 'S/ 0.00',
        responsable: formValue.usuario,
        estado: 'Pendiente'
      };

      // Actualizar el store con la nueva pérdida al inicio
      this.almacenFacade.actualizarListaRegistroPerdidas([nuevaPerdida, ...this.facade.registroPerdidas()]);

      // Seleccionar la nueva fila
      setTimeout(() => {
        if (this.gridApi) {
          const firstNode = this.gridApi.getRowNode('0');
          if (firstNode) {
            firstNode.setSelected(true);
            this.onCellClicked({ data: firstNode.data });
          }
        }
      }, 100);
    }
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
        titulo: `Historial de Actualizaciones de la Pérdida ${this.filaSeleccionada.almacen_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

  onFechaSeleccionada(date: Date) {
    console.log('Fecha seleccionada:', date);
    if (this.registroForm && date) {
      const fechaCtrl = this.registroForm.get('fechaR');
      if (fechaCtrl) {
        fechaCtrl.setValue(date);
      }
    }
  }

  onBtReset() {
    this.almacenFacade.cargarRegistroPerdidas();
  }
}


