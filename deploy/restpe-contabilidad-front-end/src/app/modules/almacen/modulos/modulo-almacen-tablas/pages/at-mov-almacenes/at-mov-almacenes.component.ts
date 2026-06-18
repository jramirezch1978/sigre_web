import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
import { MovAlmacenEntity } from '../../../../domain/models/mov-almacen.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-at-mov-almacenes',
  templateUrl: './at-mov-almacenes.component.html',
  styleUrls: ['./at-mov-almacenes.component.scss'],
  standalone: false,
})
export class AtMovAlmacenesComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // Facades
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.loadingMovAlmacenes;



  // ---------------------------------------------------------------------------
  // Inyección de dependencias
  // ---------------------------------------------------------------------------

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  selectedMovimiento: any = null;
  selectedAlmacen: any = null;
  btnguardar = 'Registrar';
  
  // Variable para controlar si hay cambios en el formulario
  formularioConCambios: boolean = false;

  async onCellClicked(event: any) {
    const data = event.data;

    // Prevenir selección automática de AG-Grid
    event.node.setSelected(true);

    // Guardar referencia del elemento que tiene el foco
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Mantener selección anterior
      if (this.selectedMovimiento) {
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
    if (node.data.mov_almacen_codigo === this.selectedMovimiento.mov_almacen_codigo) {
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

    // Cargar datos del registro seleccionado
    this.cargarDatosRegistro(data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: any, node?: any): void {
    this.btnguardar = 'Guardar';
    this.selectedMovimiento = data;
    this.formularioConCambios = true; // Marcar que hay cambios cuando se selecciona un movimiento
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


    // Formatear fechaRegistro a yyyy-mm-dd si existe
    let fechaCreacion = data.mov_almacen_fecha_registro
      ? this.formatearFechaISO(data.mov_almacen_fecha_registro)
      : this.getFechaHoy();

    // Buscar el id del almacén asociado por nombre (para el autocomplete)
    let almacenId = '';
    if (data.mov_almacen_almacen_asociado) {
      const almacen = this.almacenes().find(a => a.almacen_nombre === data.mov_almacen_almacen_asociado);
      almacenId = almacen ? almacen.almacen_codigo : '';
    }

    // Normalizar valores para selects
    const tipoMovimiento = (data.mov_almacen_tipo || '').toLowerCase();
    // Los selects esperan 'entrada', 'salida', 'traslado'
    const afectaInventario = (data.mov_almacen_afecta_inventario || '').toLowerCase() === 'si' ? 'si' : (data.mov_almacen_afecta_inventario || '').toLowerCase() === 'no' ? 'no' : '';
    const afectaValorContable = (data.mov_almacen_afecta_valor || '').toLowerCase() === 'si' ? 'si' : (data.mov_almacen_afecta_valor || '').toLowerCase() === 'no' ? 'no' : '';

    this.movimientoForm.patchValue({
      fechaCreacion: fechaCreacion,
      tipoMovimiento: tipoMovimiento,
      motivoMovimiento: data.mov_almacen_motivo || '',
      afectaInventario: afectaInventario,
      afectaValorContable: afectaValorContable,
      almacenAsociado: almacenId,
      observaciones: data.observaciones || '',
      estado: data.mov_almacen_estado || 'activo'
    });

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }

  // Utilidad para convertir dd/mm/yyyy o dd-mm-yyyy a yyyy-mm-dd
  private formatearFechaISO(fecha: string): string {
    if (!fecha) return '';
    // Soporta dd/mm/yyyy o dd-mm-yyyy
    const partes = fecha.includes('/') ? fecha.split('/') : fecha.split('-');
    if (partes.length === 3) {
      // Si ya está en formato yyyy-mm-dd, devolver igual
      if (partes[0].length === 4) return fecha;
      // Si es dd/mm/yyyy o dd-mm-yyyy
      return `${partes[2]}-${partes[1].padStart(2, '0')}-${partes[0].padStart(2, '0')}`;
    }
    return fecha;

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }

  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'at-mov-almacenes'); }

  /**
   * PDF del vale de movimiento (HU §18.9): descarga el PDF Jasper generado por
   * el backend (`/api/almacen/movimientos/pdf/{id}`) para el movimiento
   * seleccionado. No es captura de pantalla.
   */
  exportarPdf(): void {
    this.descargarValePdf(this.selectedMovimiento?.mov_almacen_id);
  }

  /** Descarga el PDF del vale por id (compartido por el botón y el menú contextual). */
  private descargarValePdf(id: number | null | undefined): void {
    if (!id) {
      this.toastService.warning('Selecciona un movimiento (vale) para descargar su PDF');
      return;
    }
    this.almacenFacade.descargarMovimientoPdf(id).subscribe({
      next: (blob) => this.exportSvc.descargarBlob(blob, `vale_${id}.pdf`),
      error: (err) => this.toastService.danger(err?.message || 'No se pudo generar el PDF del vale'),
    });
  }

  /**
   * Menú contextual de la grilla (click derecho): mantiene CSV/Excel nativos y
   * añade "PDF Export" para descargar el vale de la fila clicada.
   */
  getContextMenuItems = (params: any): any[] => {
    const items = (params?.defaultItems ?? []).slice();
    items.push('separator');
    items.push({
      name: 'PDF Export',
      action: () => this.descargarValePdf(params?.node?.data?.mov_almacen_id),
    });
    return items;
  };
  movimientoForm!: FormGroup;
  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  // Modo single
  fechaMovimiento: Date | undefined;

  // ---------------------------------------------------------------------------
  // Catálogos desde Facade
  // ---------------------------------------------------------------------------
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
  colDefs: ColDef[] = [
    { field: 'mov_almacen_codigo', headerName: 'Código', width: 80, cellClass: 'text-center', headerClass: 'text-center' },
    { field: 'mov_almacen_fecha_registro', headerName: 'Fecha Creación', width: 100, cellClass: 'text-center', headerClass: 'text-center' },
    { field: 'mov_almacen_tipo', headerName: 'Tipo', width: 110, cellClass: 'text-center', headerClass: 'text-center', filter: true },
    { field: 'mov_almacen_almacen_asociado', headerName: 'Almacén Asociado', width: 140, cellClass: 'text-left', headerClass: 'text-left', filter: true },
    { field: 'mov_almacen_afecta_inventario', headerName: 'Afecta inventario', width: 110, cellClass: 'text-center', headerClass: 'text-center' },
    { field: 'mov_almacen_motivo', headerName: 'Motivo del movimiento', flex: 1, minWidth: 200, cellClass: 'text-center', headerClass: 'text-center' },
    { field: 'mov_almacen_afecta_valor', headerName: 'Afecta valor contable', width: 130, cellClass: 'text-left', headerClass: 'text-left' },
    {
      field: 'mov_almacen_estado', headerName: 'Estado', width: 90, cellClass: 'text-center', headerClass: 'centrarencabezado', filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'activo') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>`;
        } else {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>`;
        }
      },
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  columnTypes = {
    rightAligned: { headerClass: 'text-right', cellClass: 'text-right' },
  };

  rowData: MovAlmacenEntity[] = [];


  constructor(
    private fb: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController,
    private formValidationService: FormValidationService
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    effect(() => {
      const datos = this.almacenFacade.movAlmacenes();
      if (datos && datos.length > 0) {
        const isNewFormat = datos[0] && 'mov_almacen_codigo' in datos[0];
        if (isNewFormat) {
          this.rowData = datos;
          if (this.gridApi) {
            this.gridApi.setGridOption('rowData', this.rowData);
          }
        }
      }
    });
  }

  ngOnInit() {
    // Inicializar catálogos compartidos
    this.catalogosFacade.inicializarCatalogos();
    // Cargar almacenes para el autocomplete "Almacén asociado"
    this.almacenFacade.cargarAlmacenes();
    // Cargar movimientos de almacén
    this.almacenFacade.cargarMovAlmacenes();

    this.movimientoForm = this.fb.group({
      fechaCreacion: new FormControl({ value: this.getFechaHoy(), disabled: true }),
      tipoMovimiento: new FormControl(''),
      motivoMovimiento: new FormControl(''),
      afectaInventario: new FormControl(''),
      afectaValorContable: new FormControl(''),
      almacenAsociado: new FormControl(''),
      observaciones: new FormControl(''),
      estado: new FormControl('activo')
    });

    // Escuchar cambios en el formulario para activar/desactivar el botón "Nuevo Movimiento"
    this.movimientoForm.valueChanges.subscribe(() => {
      // Si no hay movimiento seleccionado, marcar si hay cambios
      if (!this.selectedMovimiento) {
        this.formularioConCambios = this.movimientoForm.dirty;
      } else {
        // Si hay movimiento seleccionado, siempre permitir nuevo
        this.formularioConCambios = true;
      }
    });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.movimientoForm);
  }

  getFechaHoy(): string {
    return new Date().toISOString().substring(0, 10);
  }
  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }
  async nuevomovimiento() {
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Cancelar acción
    }

    this.btnguardar = 'Registrar';
    this.gridApi.deselectAll();
    this.selectedMovimiento = null;
    this.formularioConCambios = false; // Resetear estado de cambios

    // Obtener fecha de creación dinámica
    let fechaCreacion = this.selectedAlmacen && this.selectedAlmacen.almacen_fecha_creacion
      ? new Date(this.selectedAlmacen.almacen_fecha_creacion).toISOString().substring(0, 10)
      : this.getFechaHoy();

    this.movimientoForm.reset({
      fechaCreacion: fechaCreacion,
      tipoMovimiento: '',
      motivoMovimiento: '',
      afectaInventario: '',
      afectaValorContable: '',
      almacenAsociado: '',
      observaciones: '',
      estado: 'activo'
    });

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }
  onBtReset() {
    this.almacenFacade.cargarMovAlmacenes();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onAlmacenSeleccionado(almacen: any) {
    console.log('Almacén seleccionado:', almacen);
  }

  filtrarPorFechas(event: any) {
    console.log('Filtrar por fechas:', event);
  }

  abrirmodalUbicaciones() {
    console.log('Abrir modal ubicaciones');
  }
  toastsuccess() {
    if (!this.movimientoForm.valid) {
      return;
    }

    const formValues = this.movimientoForm.value;

    if (this.selectedMovimiento) {
      // Modo edición - actualizar registro existente
      const index = this.rowData.findIndex(item => item.mov_almacen_codigo === this.selectedMovimiento.mov_almacen_codigo);

      if (index !== -1) {
        this.rowData[index] = {
          ...this.rowData[index],
          mov_almacen_tipo: formValues.tipoMovimiento || this.rowData[index].mov_almacen_tipo,
          mov_almacen_almacen_asociado: formValues.almacenAsociado || this.rowData[index].mov_almacen_almacen_asociado,
          mov_almacen_afecta_inventario: formValues.afectaInventario || this.rowData[index].mov_almacen_afecta_inventario,
          mov_almacen_motivo: formValues.motivoMovimiento || this.rowData[index].mov_almacen_motivo,
          mov_almacen_afecta_valor: formValues.afectaValorContable || this.rowData[index].mov_almacen_afecta_valor,
          mov_almacen_estado: formValues.estado || this.rowData[index].mov_almacen_estado
        };

        // Actualizar grid
        this.gridApi.setGridOption('rowData', [...this.rowData]);

        this.toastService.success('¡Movimiento actualizado exitosamente!');
      }
    } else {
      // Modo registro - crear nuevo movimiento
      const nuevoCodigo = this.generarNuevoCodigo();
      const fechaActual = new Date().toLocaleDateString('es-PE', { day: '2-digit', month: '2-digit', year: 'numeric' });

      // Buscar el nombre del almacén asociado por id
      let nombreAlmacen = '';
      if (formValues.almacenAsociado) {
        const almacen = this.almacenes().find(a => a.almacen_codigo === formValues.almacenAsociado);
        nombreAlmacen = almacen ? almacen.almacen_nombre : formValues.almacenAsociado;
      }
      const nuevoMovimiento: MovAlmacenEntity = {
        mov_almacen_id: null,
        mov_almacen_codigo: nuevoCodigo,
        mov_almacen_fecha_registro: fechaActual,
        mov_almacen_tipo: formValues.tipoMovimiento,
        mov_almacen_almacen_asociado: nombreAlmacen,
        mov_almacen_afecta_inventario: formValues.afectaInventario,
        mov_almacen_motivo: formValues.motivoMovimiento,
        mov_almacen_afecta_valor: formValues.afectaValorContable,
        mov_almacen_estado: formValues.estado || 'activo'
      };

      // Agregar al inicio del array
      this.rowData = [nuevoMovimiento, ...this.rowData];

      // Actualizar grid
      this.gridApi.setGridOption('rowData', this.rowData);

      this.toastService.success('¡Movimiento registrado exitosamente!');
    }

    // Resetear servicio de validación después de guardar
    this.formValidationService.resetearEstado();

    // Seleccionar y mostrar la fila recién registrada
    this.btnguardar = 'Guardar';
    // Seleccionar la primera fila (la recién agregada)
    setTimeout(() => {
      if (this.gridApi) {
        this.gridApi.forEachNode((node, index) => {
          if (index === 0) {
            node.setSelected(true);
            this.cargarDatosRegistro(node.data, node);
          }
        });
      }
    }, 0);
  }

  // Generar código automático para nuevos movimientos
  generarNuevoCodigo(): string {
    const numeros = this.rowData.map(item => {
      const match = item.mov_almacen_codigo.match(/MOV-(\d+)/);
      return match ? parseInt(match[1], 10) : 0;
    });
    const maxNumero = Math.max(...numeros, 0);
    const nuevoNumero = (maxNumero + 1).toString().padStart(3, '0');
    return `MOV-${nuevoNumero}`;
  }
  public async modaleliminar() {
    // Validar que haya un movimiento seleccionado
    if (!this.selectedMovimiento) {
      this.toastService.danger('Debe seleccionar un movimiento para eliminar');
      return;
    }

    // Preparar datos del movimiento seleccionado
    const detallesMovimiento: DetalleItem[] = [
      { label: 'Código', value: this.selectedMovimiento.mov_almacen_codigo },
      { label: 'Tipo de mov', value: this.selectedMovimiento.mov_almacen_tipo },
      { label: 'Fecha de creación', value: this.selectedMovimiento.mov_almacen_fecha_registro },
      { label: 'Almacén asoc.', value: this.selectedMovimiento.mov_almacen_almacen_asociado },
      { label: 'Afecta inventario', value: this.selectedMovimiento.mov_almacen_afecta_inventario },
      { label: 'Estado', value: this.selectedMovimiento.mov_almacen_estado }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Eliminar movimiento',
        subtitulomodal: 'Detalle de eliminación:',
        detalles: detallesMovimiento,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo de eliminación',
        placeholderTextarea: 'Describe el motivo de la eliminación',
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Eliminar',
        colorBotonConfirmar: 'danger',
        validarMotivo: true // Activar validación de motivo obligatorio
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      // Validar que se haya proporcionado un motivo
      if (!data.motivo || data.motivo.trim() === '') {
        this.toastService.danger('Debe ingresar un motivo para eliminar');
        return;
      }

      // Eliminar el movimiento del array
      const index = this.rowData.findIndex(item => item.mov_almacen_codigo === this.selectedMovimiento.mov_almacen_codigo);

      if (index !== -1) {
        this.rowData.splice(index, 1);

        // Actualizar grid
        this.gridApi.setGridOption('rowData', [...this.rowData]);

        // Limpiar formulario y selección
        this.selectedMovimiento = null;
        this.btnguardar = 'Registrar';
        this.gridApi.deselectAll();

        this.movimientoForm.reset({
          fechaCreacion: '16/11/2025',
          tipoMovimiento: '',
          motivoMovimiento: '',
          afectaInventario: '',
          afectaValorContable: '',
          almacenAsociado: '',
          observaciones: '',
          estado: 'activo'
        });

        // Resetear estado del servicio de validación
        this.formValidationService.resetearEstado();

        this.toastService.success('Movimiento eliminado exitosamente');
        console.log('Movimiento eliminado. Motivo:', data.motivo);
      }
    }
  }

  //   onfechaMovimiento(fecha: Date) {
  //   this.fechaMovimiento = fecha;
  // }

  async modalverActualizaciones() {
    // Definir las columnas
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 150, },
      { headerName: 'Usuario', field: 'usuario', width: 120, },
      {headerName: 'Acción', field: 'accion', width: 150,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
      {headerName: 'Detalle del cambio', field: 'detalleCambio', flex: 1,
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
        titulo: `Historial de Actualizaciones del movimiento ${this.selectedMovimiento.mov_almacen_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

}
