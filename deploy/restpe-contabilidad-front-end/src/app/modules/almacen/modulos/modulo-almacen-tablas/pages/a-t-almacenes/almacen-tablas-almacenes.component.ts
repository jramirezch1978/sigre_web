import { Component, OnInit, OnDestroy, inject, effect, signal } from '@angular/core';
import { AlmacenHttpService } from '../../../../infrastructure/http/almacen-http.service';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalController } from '@ionic/angular';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
import { AlmacenEntity } from '../../../../domain/models/almacen.entity';
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFeedbackEffects } from '../../../../effects/almacen-feedback.effect';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';




@Component({
  selector: 'app-almacen-tablas-almacenes',
  templateUrl: './almacen-tablas-almacenes.component.html',
  styleUrls: ['./almacen-tablas-almacenes.component.scss'],
  standalone: false,
})
export class AlmacenTablasAlmacenesComponent implements OnInit, OnDestroy, CanComponentDeactivate {
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
  //FECHAS ÚNICAS (SINGLE)

  fechacreacion: Date | undefined;
  ResponsableAlmacenFecha: Date | undefined;
  selectedAlmacen: AlmacenEntity | null = null;

  // Variable para controlar si estamos en modo creación o edición
  modoCreacion: boolean = true; // Cambio: Iniciar en modo creación

  // Variable para controlar si hay cambios en el formulario
  formularioConCambios: boolean = false;

  // Variables para modal de gestión catálogo
  mostrarModalCatalogo: boolean = false;
  catalogoForm!: FormGroup;

  // Inyección del Facade y Effects
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);
  private readonly feedbackEffects = inject(AlmacenFeedbackEffects);

  // Selectores del store para UI reactiva
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.isLoading;
  readonly loadingObtener = this.almacenFacade.loadingObtener;
  readonly loadingGuardar = this.almacenFacade.loadingGuardar;
  readonly loadingEliminar = this.almacenFacade.loadingEliminar;
  readonly loadingActualizar = this.almacenFacade.loadingActualizar;

  // Catálogos compartidos desde el Store
  // Sucursal REAL de la sesión (la elegida en el login), no el catálogo mock.
  readonly sucursales = signal<{ id: number; nombre: string }[]>([]);
  readonly empleados = this.catalogosFacade.empleadosActivos;
  readonly ciudades = this.catalogosFacade.ciudades;
  readonly distritos = this.catalogosFacade.distritos;
  // Tipos de almacén REALES del backend (`almacen.almacen_tipo`): MP, PT, SP, IN, AF.
  readonly tiposAlmacen = this.almacenFacade.tiposAlmacen;

  onFechaResponsableAlmacen(fecha: Date) {
    this.ResponsableAlmacenFecha = fecha;
  }

  private gridApi!: GridApi;
  almacenForm!: FormGroup;

  colDefs: ColDef[] = [
    { field: 'almacen_codigo', headerName: 'Código', width: 70, sortable: true, },
    {
      field: 'almacen_fecha_creacion', headerName: 'Fecha de creación', width: 110, sortable: true,
      cellRenderer: (params: any) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        if (isNaN(date.getTime())) return params.value;
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();
        return `${day}/${month}/${year}`;
      }
    },
    { field: 'almacen_nombre', headerName: 'Nombre de almacén', flex: 1, minWidth: 200, sortable: true, filter: true },
    {
      headerName: 'Tipo', colId: 'almacen_tipo', width: 150, sortable: true, filter: true,
      // El backend devuelve solo almacenTipoId (sin nombre); resolvemos contra el catálogo.
      valueGetter: (p: any) =>
        this.tiposAlmacen().find((t) => t.id === p.data?.almacen_tipo_id)?.nombre ?? (p.data?.almacen_tipo || ''),
    },
    {
      headerName: 'Sucursal', colId: 'sucursal', width: 130, sortable: true, filter: true,
      // sucursalId real → nombre desde el catálogo de sucursales.
      valueGetter: (p: any) =>
        this.sucursales().find((s: any) => s.id === p.data?.sucursalId)?.nombre ?? '',
    },
    {
      headerClass: 'centrarencabezado', field: 'almacen_estado', headerName: 'Estado', width: 90, sortable: true, filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>`;
        } else if (params.value === 'Inactivo') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>`;
        }
        return params.value;
      },
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
  ];

  rowData: AlmacenEntity[] = [];

  columnTypes = {};

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
    private fb: FormBuilder,
    private modalController: ModalController,
    private toastservice: ToastService,
    private formValidationService: FormValidationService
  ) {
    const today = new Date();
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );
    this.maxDate = today;

    // Effect para actualizar la tabla cuando cambian los datos del store.
    // Lee también los catálogos (tipos/sucursales) para re-evaluar los valueGetter
    // (nombre de tipo y sucursal) cuando esos catálogos terminen de cargar.
    effect(() => {
      const almacenes = this.almacenes();
      this.tiposAlmacen();
      this.sucursales();
      this.rowData = almacenes;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
        this.gridApi.refreshCells({ force: true });
      }
    });

    // Los effects de feedback (toasts) están manejados por AlmacenFeedbackEffects
    // Los effects de sync (recarga) están manejados por AlmacenSyncEffects
  }

  ngOnInit() {
    //  Inicializar formulario con fecha de hoy deshabilitada
    this.almacenForm = this.fb.group({
      fechaC: [{ value: this.getFechaHoy(), disabled: true }], // Deshabilitado
      descripcion: new FormControl(''),
      codigo: new FormControl(''),
      nombredealmacen: new FormControl(''),
      direccion: new FormControl(''),
      ciudad: new FormControl(''),
      distrito: new FormControl(''),
      distritoAuto: new FormControl(''),
      capacidad: new FormControl(''),
      capacidadm2: new FormControl('m2'),
      tipo: new FormControl(''),
      observaciones: new FormControl(''),
      responsable: new FormControl(''),
      estado: new FormControl('activo'),
    });

    // Deshabilitar explícitamente el campo de fecha
    this.almacenForm.get('fechaC')?.disable({ emitEvent: false });

    // Escuchar cambios en el formulario para activar/desactivar el botón "Nuevo Almacén"
    this.almacenForm.valueChanges.subscribe(() => {
      // Si estamos en modo creación, marcar que hay cambios
      if (this.modoCreacion) {
        this.formularioConCambios = this.almacenForm.dirty;
      } else {
        // En modo edición, siempre permitir cambiar a nuevo
        this.formularioConCambios = true;
      }
    });

    // Inicializar formulario de catálogo
    this.catalogoForm = this.fb.group({
      nombre: new FormControl(''),
      tipo: new FormControl(''),
      descripcion: new FormControl('')
    });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.almacenForm);

    // Registrar callbacks para limpiar formulario después de guardar/actualizar con éxito
    this.feedbackEffects.registrarCallbacks({
      onGuardarExito: () => this.resetearFormularioDespuesDeGuardar(),
      onActualizarExito: () => this.resetearFormularioDespuesDeGuardar()
    });

    //  Cargar almacenes usando el facade
    this.cargarAlmacenesDesdeStore();

    // Inicializar catálogos compartidos (solo una vez, se cachea en el store)
    this.catalogosFacade.inicializarCatalogos();
    // Cargar tipos de almacén reales del backend para el selector
    this.almacenFacade.cargarTiposAlmacen();

    // Sucursal real de la sesión (login): alimenta el selector y la grilla, y
    // se usa por defecto al crear (los almacenes quedan en TU sucursal).
    const sucId = AlmacenHttpService.getSucursalId();
    const sucNombre = AlmacenHttpService.getSucursalNombre() || `Sucursal ${sucId}`;
    if (sucId) {
      this.sucursales.set([{ id: sucId, nombre: sucNombre }]);
      this.almacenForm.patchValue({ distritoAuto: sucId });
    }
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  /**
   * Cargar almacenes desde el store usando el facade
   */
  cargarAlmacenesDesdeStore() {
    console.log(' Cargando almacenes desde el store...');
    this.almacenFacade.cargarAlmacenes();
  }

  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  getFechaHoy(): string {
    return new Date().toISOString().substring(0, 10);
  }

  onBtReset() {
    if (this.gridApi) {
      this.gridApi.showLoadingOverlay();

      //  Recargar datos desde el store
      this.cargarAlmacenesDesdeStore();

      setTimeout(() => {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.gridApi.hideOverlay();

        //  Cambio: NO seleccionar automáticamente después de refrescar
        // Mantener en modo creación
        this.nuevoAlmacen();

        console.log(' Tabla refrescada desde localStorage');
      }, 300);
    }
  }

  async onCellClicked(event: any) {
    const data = event.data;

    // Marcar la fila seleccionada primero
    event.node.setSelected(true);

    // Guardar referencia del elemento que tiene el foco
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Desmarcar la fila actual y mantener selección anterior
      if (this.selectedAlmacen) {
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
            if (node.data.almacen_codigo === this.selectedAlmacen!.almacen_codigo) {
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

    // Cargar datos del almacén seleccionado
    this.cargarDatosAlmacen(data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosAlmacen(data: AlmacenEntity, node?: any): void {
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    if (node) {
      node.setSelected(true);
    }

    this.selectedAlmacen = data;
    this.modoCreacion = false; // Cambiar a modo edición

    if (this.selectedAlmacen) {
      const capacidadSplit = this.selectedAlmacen.almacen_capacidad.split(' ');
      const capacidadNumero = capacidadSplit[0] || '';
      const capacidadUnidad = capacidadSplit[1] || 'm2';

      //  Cargar fecha de creación del almacén seleccionado
      const fechaCreacion = this.selectedAlmacen.almacen_fecha_creacion
        ? new Date(this.selectedAlmacen.almacen_fecha_creacion).toISOString().substring(0, 10)
        : this.getFechaHoy();

      this.almacenForm.patchValue({
        fechaC: fechaCreacion,
        codigo: this.selectedAlmacen.almacen_codigo || '',
        nombredealmacen: this.selectedAlmacen.almacen_nombre || '',
        tipo: this.selectedAlmacen.almacen_tipo_id ?? '',
        direccion: this.selectedAlmacen.almacen_direccion || '',
        ciudad: this.selectedAlmacen.almacen_ciudad || '',
        distrito: this.selectedAlmacen.almacen_distrito || '',
        capacidad: capacidadNumero,
        capacidadm2: capacidadUnidad,
        responsable: this.selectedAlmacen.almacen_responsable || '',
        estado: this.selectedAlmacen.almacen_estado ? this.selectedAlmacen.almacen_estado.toLowerCase() : 'activo',
        observaciones: this.selectedAlmacen.almacen_observaciones || ''
      });

      // Resetear estado del servicio de validación
      this.formValidationService.resetearEstado();
    }
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;

    //  Cambio: NO seleccionar la primera fila automáticamente
    // El componente inicia en modo creación
  }

  //  Método ya no es necesario que se llame automáticamente
  seleccionarPrimeraFila() {
    if (this.gridApi && this.rowData.length > 0) {
      setTimeout(() => {
        const firstNode = this.gridApi.getDisplayedRowAtIndex(0);
        if (firstNode) {
          firstNode.setSelected(true);
          this.selectedAlmacen = firstNode.data;
          this.modoCreacion = false;

          if (this.selectedAlmacen) {
            const capacidadSplit = this.selectedAlmacen.almacen_capacidad.split(' ');
            const capacidadNumero = capacidadSplit[0] || '';
            const capacidadUnidad = capacidadSplit[1] || 'm2';

            const fechaCreacion = this.selectedAlmacen.almacen_fecha_creacion
              ? new Date(this.selectedAlmacen.almacen_fecha_creacion).toISOString().substring(0, 10)
              : this.getFechaHoy();

            this.almacenForm.patchValue({
              fechaC: fechaCreacion,
              codigo: this.selectedAlmacen.almacen_codigo || '',
              nombredealmacen: this.selectedAlmacen.almacen_nombre || '',
              tipo: this.selectedAlmacen.almacen_tipo_id ?? '',
              direccion: this.selectedAlmacen.almacen_direccion || '',
              ciudad: this.selectedAlmacen.almacen_ciudad || '',
              distrito: this.selectedAlmacen.almacen_distrito || '',
              capacidad: capacidadNumero,
              capacidadm2: capacidadUnidad,
              responsable: this.selectedAlmacen.almacen_responsable || '',
              estado: this.selectedAlmacen.almacen_estado ? this.selectedAlmacen.almacen_estado.toLowerCase() : 'activo',
              observaciones: this.selectedAlmacen.almacen_observaciones || ''
            });
          }
        }
      }, 100);
    }
  }

  async nuevoAlmacen() {
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Cancelar acción
    }

    this.modoCreacion = true;
    this.selectedAlmacen = null;
    this.formularioConCambios = false; // Resetear estado de cambios

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    //  Resetear con fecha de hoy deshabilitada
    this.almacenForm.reset({
      fechaC: this.getFechaHoy(), // Fecha de hoy
      descripcion: '',
      nombredealmacen: '',
      direccion: '',
      ciudad: '',
      distrito: '',
      distritoAuto: '',
      capacidad: '',
      capacidadm2: 'm2',
      tipo: '',
      observaciones: '',
      responsable: '',
      estado: 'activo',
    });

    // Asegurar que la fecha esté deshabilitada
    this.almacenForm.get('fechaC')?.disable({ emitEvent: false });

    this.ResponsableAlmacenFecha = undefined;
    this.fechacreacion = undefined;

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }

  /** Resetea el formulario a estado limpio después de un guardado exitoso */
  private resetearFormularioDespuesDeGuardar(): void {
    this.modoCreacion = true;
    this.selectedAlmacen = null;
    this.formularioConCambios = false;
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    this.almacenForm.reset({
      fechaC: this.getFechaHoy(),
      descripcion: '',
      nombredealmacen: '',
      direccion: '',
      ciudad: '',
      distrito: '',
      distritoAuto: '',
      capacidad: '',
      capacidadm2: 'm2',
      tipo: '',
      observaciones: '',
      responsable: '',
      estado: 'activo',
    });
    this.almacenForm.get('fechaC')?.disable({ emitEvent: false });
    this.ResponsableAlmacenFecha = undefined;
    this.fechacreacion = undefined;
    this.formValidationService.resetearEstado();
  }

  guardarOCrearAlmacen() {
    // Validar campos requeridos (solo los que persisten en la BD: nombre y tipo;
    // el código se valida aparte). Dirección/ciudad/distrito ya no aplican.
    if (!this.almacenForm.get('nombredealmacen')?.value ||
      !this.almacenForm.get('tipo')?.value) {
      this.toastservice.warning('Por favor complete todos los campos requeridos');
      return;
    }

    // El backend exige un código no vacío (máx. 20)
    if (this.modoCreacion && !this.almacenForm.get('codigo')?.value?.trim()) {
      this.toastservice.warning('Ingrese el código del almacén');
      return;
    }

    const formValue = this.almacenForm.getRawValue(); // getRawValue incluye campos deshabilitados

    // Combinar capacidad con unidad
    const capacidadCompleta = `${formValue.capacidad} ${formValue.capacidadm2}`;

    // Tipo de almacén: el form guarda el id real (FK almacen_tipo_id); resolvemos
    // el nombre para mostrarlo en la grilla mientras el backend confirma.
    const tipoId = formValue.tipo != null && formValue.tipo !== '' ? Number(formValue.tipo) : undefined;
    const tipoNombre = this.tiposAlmacen().find((t) => t.id === tipoId)?.nombre ?? '';

    // Crear objeto almacén
    const almacen: AlmacenEntity = {
      id: this.modoCreacion ? undefined : this.selectedAlmacen?.id,
      sucursalId: formValue.distritoAuto ? Number(formValue.distritoAuto) : this.selectedAlmacen?.sucursalId,
      almacen_tipo_id: tipoId,
      almacen_codigo: ((this.modoCreacion ? formValue.codigo : this.selectedAlmacen!.almacen_codigo) || '').trim(),
      almacen_nombre: formValue.nombredealmacen,
      almacen_direccion: formValue.direccion,
      almacen_distrito: formValue.distrito,
      almacen_ciudad: formValue.ciudad,
      almacen_tipo: tipoNombre,
      almacen_capacidad: capacidadCompleta,
      almacen_responsable: formValue.responsable || '',
      almacen_estado: formValue.estado.charAt(0).toUpperCase() + formValue.estado.slice(1),
      almacen_fecha: formValue.fechaC,
      almacen_fecha_creacion: formValue.fechaC,
      almacen_observaciones: formValue.observaciones || ''
    };

    if (this.modoCreacion) {
      // Modo creación - guardar nuevo almacén (el reset del formulario lo maneja el callback onGuardarExito)
      this.almacenFacade.guardarAlmacen(almacen);
    } else {
      // Modo edición - actualizar almacén existente
      if (!this.selectedAlmacen) {
        this.toastservice.warning('No hay almacén seleccionado para actualizar');
        return;
      }

      this.almacenFacade.actualizarAlmacen(almacen);

      // Resetear servicio de validación después de guardar
      this.formValidationService.resetearEstado();
    }
  }

  onDistritoSeleccionado(distrito: any) {
    console.log('Distrito seleccionado:', distrito);
  }

  onResponsableSeleccionado(responsable: any) {
    console.log('Responsable seleccionado:', responsable);
    if (responsable && responsable.nombre) {
      this.almacenForm.patchValue({ responsable: responsable.nombre });
    }
  }

  onFechaCreacion(fecha: any) {
    console.log('Fecha de creación seleccionada:', fecha);
  }

  /** Exporta la grilla de almacenes a Excel (ag-grid-enterprise). */
  exportarExcel() {
    if (!this.gridApi || this.rowData.length === 0) {
      this.toastservice.warning('No hay almacenes para exportar');
      return;
    }
    this.gridApi.exportDataAsExcel({ fileName: 'almacenes.xlsx', sheetName: 'Almacenes' });
  }

  /** Exporta la grilla de almacenes a CSV (alternativa portable). */
  exportarPdf() {
    if (!this.gridApi || this.rowData.length === 0) {
      this.toastservice.warning('No hay almacenes para exportar');
      return;
    }
    this.gridApi.exportDataAsCsv({ fileName: 'almacenes.csv' });
  }



  public async modaleliminar() {
    // Validar que haya un almacén seleccionado
    if (!this.selectedAlmacen) {
      this.toastservice.warning('Debe seleccionar un almacén para eliminar');
      return;
    }

    // Preparar datos del almacén seleccionado
    const detallesAlmacen: DetalleItem[] = [
      { label: 'Código', value: this.selectedAlmacen.almacen_codigo },
      { label: 'Nombre de almacén', value: this.selectedAlmacen.almacen_nombre },
      { label: 'Dirección', value: this.selectedAlmacen.almacen_direccion },
      { label: 'Capacidad', value: this.selectedAlmacen.almacen_capacidad },
      { label: 'Responsable', value: this.selectedAlmacen.almacen_responsable },
      { label: 'Estado', value: this.selectedAlmacen.almacen_estado }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Eliminar almacén',
        subtitulomodal: 'Detalle de eliminación:',
        detalles: detallesAlmacen,
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
        this.toastservice.warning('Debe ingresar un motivo para eliminar');
        return;
      }

      // Eliminar usando el facade
      const codigoAEliminar = this.selectedAlmacen.almacen_codigo;
      this.almacenFacade.eliminarAlmacen(codigoAEliminar);

      // Limpiar formulario y selección - cambiar a modo creación
      this.nuevoAlmacen();

      console.log('Almacén con código', codigoAEliminar, 'eliminado. Motivo:', data.motivo);
    }
  }

  guardarCatalogo() {
    if (this.catalogoForm.valid) {
      console.log('Catálogo guardado:', this.catalogoForm.value);
      this.mostrarModalCatalogo = false;
      this.catalogoForm.reset();
    } else {
      console.log('Formulario de catálogo no válido');
    }
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    this.cargarDatos(range.start, range.end);
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
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
      { fechaHora: '12/11/2025 14:40:22', usuario: 'Juan Pérez', accion: 'Crear', detalleCambio: 'Se a creado el documento REC-001'},
      { fechaHora: '12/11/2025 14:40:22', usuario: 'Carlos Zapata', accion: 'Edición del documento', detalleCambio: 'Se edito la descripción del documento'},
      { fechaHora: '08/11/2025 14:15:30', usuario: 'Jorgue Gomez', accion: 'Cambio de cuenta contable', detalleCambio: 'Se cambio la cuenta contable por la de 1010'},
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones del documento REC-001',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }
}
