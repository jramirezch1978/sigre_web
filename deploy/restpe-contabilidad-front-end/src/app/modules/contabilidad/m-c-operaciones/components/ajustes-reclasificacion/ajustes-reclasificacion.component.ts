import { Component, OnInit, inject, signal, effect, untracked, computed } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { AjusteReclasificacionItem, CuentaMovimientoAjusteItem } from 'src/app/modules/contabilidad/domain/models/ajustes-reclasificacion.entity';
import { AjustesReclasificacionFacade } from 'src/app/modules/contabilidad/application/facades/ajustes-reclasificacion.facade';
import { AjustesReclasificacionFeedbackEffects } from 'src/app/modules/contabilidad/effects/ajustes-reclasificacion-feedback.effect';
import { SeleccionarCuentaContableFacade } from 'src/app/modules/contabilidad/application/facades/seleccionar-cuenta-contable.facade';
import { SeleccionarCuentaContableFeedbackEffects } from 'src/app/modules/contabilidad/effects/seleccionar-cuenta-contable-feedback.effect';
import { AccesorioActionsCellComponent } from 'src/app/modules/activos/m-af-tabla/pages/af-o-registroactivos/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';


@Component({
  selector: 'app-ajustes-reclasificacion',
  templateUrl: './ajustes-reclasificacion.component.html',
  styleUrls: ['./ajustes-reclasificacion.component.scss'],
  standalone: false,
})
export class AjustesReclasificacionComponent implements OnInit {

  // ── Facades & Effects ────────────────────────────────────────────────────
  private readonly ajustesFacade  = inject(AjustesReclasificacionFacade);
  private readonly cuentaFacade   = inject(SeleccionarCuentaContableFacade);
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  private readonly ajustesEffects = inject(AjustesReclasificacionFeedbackEffects);
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  private readonly cuentaEffects  = inject(SeleccionarCuentaContableFeedbackEffects);

  // ── Señales reactivas ─────────────────────────────────────────────────────
  rowData = signal<AjusteReclasificacionItem[]>([]);
  readonly isLoading = computed(() => this.ajustesFacade.isLoading());

  // Efecto que siembra rowData la primera vez que la facade carga los asientos
  private readonly _syncRowData = effect(() => {
    const facadeItems = this.ajustesFacade.items() as AjusteReclasificacionItem[];
    if (facadeItems.length > 0 && this.rowData().length === 0) {
      untracked(() => this.rowData.set(facadeItems));
    }
  });

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  startDate: Date | undefined;
  endDate: Date | undefined;
   private gridApi!: GridApi;
   private gridApiCuentas!: GridApi;
  minDate: Date;
  maxDate: Date;
   estadoSeleccionado: string = 'todos';
   GestionAsientosAjustesForm!: FormGroup;
   mostrartabla: boolean = true;
   datosseleccionado = false;
   asientoSeleccionado: AjusteReclasificacionItem | null = null;
   estadoAnterior: string = 'Activo';
   fechaContableSelected: Date | undefined;
   
   // Variables para tracking de cambios en el formulario
   private formularioInicial: any = null;
   private formularioModificado: boolean = false;
   numeroAsientoTemporal: string | null = null;
   modoNuevoAsiento: boolean = true;
   
   libros = [
    { id: 'diario', nombre: 'Libro diario' },
    { id: 'compras', nombre: 'Compras' },
    { id: 'ventas', nombre: 'Ventas' },
    { id: 'mayor', nombre: 'Caja y bancos' },
  ];
   
   monedas = [
     { id: 'Soles', nombre: 'Soles' },
     { id: 'USD', nombre: 'Dólares' },
     
   ];
 
   // Cuentas contables derivadas desde el catálogo del facade
   get cuentasContables() {
     return this.cuentaFacade.items().map(c => ({
       id: c.cuenta_contable_codigo,
      nombre: `${c.cuenta_contable_codigo} - ${c.cuenta_contable_descripcion}`
     }));
   }
 
   centrosCostoList = [
     'Administración',
     'Finanzas',
     'Compras',
     'Ventas',
     'Operaciones',
     'Marketing'
   ];
 
   tercerosList = [
     'Proveedor A',
     'Proveedor B',
     'Banco Continental',
     'SUNAT',
     'Cliente General',
     'Otros'
   ];
 
   columnTypes = {
     default: {
       resizable: false,
       sortable: false,
       filter: false,
       floatingFilter: false,
     }
   };
 
   colDefs: ColDef<AjusteReclasificacionItem>[] = [
    { field: 'ajuste_rec_numero_asiento', headerName: 'Nº de asiento', flex: 1, minWidth: 100 },
    { field: 'ajuste_rec_fecha_registro', headerName: 'Fecha registro', flex: 1, minWidth: 110 },
    { field: 'ajuste_rec_fecha_contable', headerName: 'Fecha contable', flex: 1, minWidth: 110 },
   { field: 'ajuste_rec_origen', headerName: 'Origen', flex: 1, minWidth: 100 },
    { field: 'ajuste_rec_glosa', headerName: 'Glosa', flex: 2, minWidth: 150 },
    { field: 'ajuste_rec_situacion_contable', headerName: 'Situación contable', flex: 1.2, minWidth: 120, filter: true },
    {  field: 'ajuste_rec_usuario_ejecutor', headerName: 'Usuario ejecutor', flex: 1.2, minWidth: 120 },
    { field: 'ajuste_rec_total', headerName: 'Total', flex: 0.8, minWidth: 80,
       valueFormatter: (params) => {
         if (params.value !== null && params.value !== undefined) {
           const absValue = Math.abs(params.value);
           const formatter = new Intl.NumberFormat('es-PE', {
             minimumFractionDigits: 2,
             maximumFractionDigits: 2
           });
           const formattedNumber = formatter.format(absValue);
           const moneda = params.data?.ajuste_rec_moneda === 'USD' ? '$' : 'S/';
           if (params.value < 0) {
             return `${moneda} (${formattedNumber})`;
           }
           return `${moneda} ${formattedNumber}`;
         }
         return 'S/ 0.00';
       },
       cellStyle: (params) => {
         const style: any = { textAlign: 'right' };
         if (params.value < 0) {
           style.color = '#EF4444';
         }
         return style;
       }
     },
     { 
       field: 'ajuste_rec_estado', 
       headerName: 'Estado', 
       headerClass: 'centrarencabezado',
       flex: 0.8, 
       filter: true,
       minWidth: 80,
       cellRenderer: (params: any) => {
         const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
         return `<span class="badge-table ${color}">${params.value}</span>`;
       },
       cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
     }
   ];
 
   // rowData populated via signal from facade — see _syncRowData effect above

   colDefsCuentas: ColDef<CuentaMovimientoAjusteItem>[] = [
     { field: 'cuenta_mov_ajuste_cuenta', headerName: 'Cuenta', flex: 0.8, minWidth: 80 },
     { field: 'cuenta_mov_ajuste_descripcion', headerName: 'Descripción', flex: 1.5, minWidth: 120 },
     { field: 'cuenta_mov_ajuste_debe_soles', headerName: 'Debe(S/)', flex: 0.8, minWidth: 80,
       valueFormatter: params => params.value ? params.value.toFixed(2) : '0.00',editable: true
     },
     { field: 'cuenta_mov_ajuste_haber_soles', headerName: 'Haber(S/)', flex: 0.8, minWidth: 80,
       valueFormatter: params => params.value ? params.value.toFixed(2) : '0.00',editable: true
     },
     { field: 'cuenta_mov_ajuste_debe_dolares', headerName: 'Debe($)', flex: 0.8, minWidth: 80,
       valueFormatter: params => params.value ? params.value.toFixed(2) : '0.00', editable: true
     },
     { field: 'cuenta_mov_ajuste_haber_dolares', headerName: 'Haber($)', flex: 0.8, minWidth: 80,
       valueFormatter: params => params.value ? params.value.toFixed(2) : '0.00',editable: true
     },
     { field: 'cuenta_mov_ajuste_centro_costo', headerName: 'Centro de costo', flex: 1, minWidth: 100,
       cellEditor: 'agSelectCellEditor',
       cellEditorParams: {
         values: ['Administración', 'Finanzas', 'Compras', 'Ventas', 'Operaciones', 'Marketing']
       },
       editable: true
     },
     { field: 'cuenta_mov_ajuste_doc_referencial', headerName: 'Doc. referencial', flex: 1, minWidth: 100,editable: true },
     { headerName: 'Acciones', flex: 0.7, minWidth: 70,
       headerClass: 'centrarencabezado',
       cellRenderer: AccesorioActionsCellComponent,
       cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
     }
   ];
 
   rowDataCuentas: CuentaMovimientoAjusteItem[] = [];
   
   // Variables para totales
   totalDebeSoles: number = 0;
   totalHaberSoles: number = 0;
   totalDebeDolares: number = 0;
   totalHaberDolares: number = 0;
   asientoCuadra: boolean = false;
 
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
   defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };
 
   treeData = false;
   getDataPath = undefined;
   groupDefaultExpanded = -1;
   autoGroupColumnDef = undefined;
 
   constructor(
     private formBuilder: FormBuilder, 
     private modalController: ModalController, 
     private toastService: ToastService,
     public formValidationService: FormValidationService
   ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate()); 
    }
 
   ngOnInit() {
     this.GestionAsientosAjustesForm = this.formBuilder.group({
       usuario: [{ value: 'Juan Pérez', disabled: true }],
       fechaRegistro: [{ value: new Date().toISOString().split('T')[0], disabled: true }],
       origen: [{ value: 'Manual', disabled: false }],
       fechaContable: ['', Validators.required],
       libro: ['', Validators.required],
       moneda: ['Soles'],
       tasaCambio: [{ value: '3.75', disabled: true }],
       estado: ['Activo', Validators.required],
       situacionContable: [{ value: 'No transferido', disabled: true }],
       glosaContable: ['']
     });
     
     // Guardar estado inicial vacío
     this.formularioInicial = this.GestionAsientosAjustesForm.value;
     this.formValidationService.inicializarFormulario(this.GestionAsientosAjustesForm);
     
     // Suscribirse a los cambios del formulario
     this.GestionAsientosAjustesForm.valueChanges.subscribe(() => {
       this.verificarCambios();
     });

     // Cargar datos desde la capa de datos
     this.ajustesFacade.cargarDatos();
     this.cuentaFacade.cargarDatos();
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
    if (this.gridApi) {
      // Mostrar loading y recargar datos
      this.gridApi.showLoadingOverlay();

      // Recargar datos desde facade
      this.ajustesFacade.cargarDatos();
      setTimeout(() => {
        this.gridApi.setGridOption('rowData', [...this.rowData()]);
        this.gridApi.hideOverlay();
        console.log('Tabla refrescada');
      }, 400);
    }
  }
 
   onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;

    // Seleccionar la primera fila por defecto y cargar sus datos
    setTimeout(() => {
      if (this.gridApi && this.rowData().length > 0) {
        const firstNode = this.gridApi.getRowNode('0');
        if (firstNode) {
          firstNode.setSelected(true);
          // Cargar datos del primer asiento
          this.cargarDatosAsiento(firstNode.data);
        }
      }
    }, 100);
  }
 
   onGridReadyCuentas(params: GridReadyEvent) {
     this.gridApiCuentas = params.api;
     
     // Escuchar cambios en las celdas para recalcular totales
     params.api.addEventListener('cellValueChanged', () => {
       this.calcularTotales();
     });
   }
 
   async onCellClicked(event: any) {
     const data = event.data;
     
     // Prevenir selección automática de AG-Grid
     event.node.setSelected(true);
     
     // Validar si hay cambios sin guardar usando el servicio centralizado
     if (!await this.formValidationService.validarCambios()) {
       // Mantener selección anterior
       if (this.asientoSeleccionado) {
         setTimeout(() => {
           this.gridApi.deselectAll();
           const rowNode = this.gridApi.getRowNode(this.asientoSeleccionado!.ajuste_rec_numero_asiento);
           if (rowNode) {
             rowNode.setSelected(true);
           }
         }, 0);
       } else {
         this.gridApi.deselectAll();
       }
       return;
     }
     
     // Cargar datos del asiento seleccionado
     this.cargarDatosAsiento(data);
   }
   
   /**
    * Carga los datos de un asiento en el formulario
    */
   private cargarDatosAsiento(data: any) {
     console.log('Asiento seleccionado:', data);
     
     this.asientoSeleccionado = data;
     this.estadoAnterior = data.ajuste_rec_estado;
     
     // Deseleccionar todas las filas primero
     this.gridApi.deselectAll();
     
     // Seleccionar el nodo en AG-Grid
     this.gridApi.forEachNode((node) => {
       if (node.data.ajuste_rec_numero_asiento === data.ajuste_rec_numero_asiento) {
         node.setSelected(true);
       }
     });

     // Actualizar fecha contable en el calendario
     this.fechaContableSelected = data.ajuste_rec_fecha_contable
       ? new Date(data.ajuste_rec_fecha_contable + 'T00:00:00')
       : undefined;
     
     // Llenar formulario con datos seleccionados
     this.GestionAsientosAjustesForm.patchValue({
       usuario: data.ajuste_rec_usuario_ejecutor,
       fechaRegistro: data.ajuste_rec_fecha_registro,
       origen: data.ajuste_rec_origen,
       fechaContable: data.ajuste_rec_fecha_contable,
       libro: data.ajuste_rec_libro,
       moneda: data.ajuste_rec_moneda,
       estado: data.ajuste_rec_estado,
       situacionContable: data.ajuste_rec_situacion_contable,
       glosaContable: data.ajuste_rec_glosa,
     });
     
     // Cargar datos de cuentas asociadas al asiento seleccionado
     this.cargarCuentasDelAsiento(data);
     
     if(data.ajuste_rec_estado === 'Activo' && data.ajuste_rec_situacion_contable === 'No transferido'){
       this.datosseleccionado = true;
     }
     else{
       this.datosseleccionado = false;
     }
     if(data.ajuste_rec_estado === 'Activo' && data.ajuste_rec_situacion_contable === 'Transferido'){
       this.GestionAsientosAjustesForm.get('fechaContable')?.disable();
       this.GestionAsientosAjustesForm.get('moneda')?.disable();
       this.GestionAsientosAjustesForm.get('libro')?.disable();
       this.GestionAsientosAjustesForm.get('estado')?.disable();
       this.GestionAsientosAjustesForm.get('glosaContable')?.disable();
     }
     else{
       this.GestionAsientosAjustesForm.get('fechaContable')?.enable();
       this.GestionAsientosAjustesForm.get('moneda')?.enable();
       this.GestionAsientosAjustesForm.get('libro')?.enable();
       this.GestionAsientosAjustesForm.get('estado')?.enable();
       this.GestionAsientosAjustesForm.get('glosaContable')?.enable();
     }
     
     // Guardar nuevo estado inicial del formulario
     this.formularioInicial = this.GestionAsientosAjustesForm.value;
     this.formularioModificado = false;
     this.formValidationService.resetearEstado();
     
     // Limpiar número temporal ya que ahora tenemos uno real
     this.numeroAsientoTemporal = null;
     
     // Desactivar modo nuevo asiento
     this.modoNuevoAsiento = false;
   }
 
   async botonnuevoasiento() {
     // Validar cambios antes de limpiar usando el servicio centralizado
     if (!await this.formValidationService.validarCambios()) {
       return; // Cancelar acción
     }
     
     // Habilitar campos del formulario
     this.GestionAsientosAjustesForm.get('fechaContable')?.enable();
     this.GestionAsientosAjustesForm.get('moneda')?.enable();
     this.GestionAsientosAjustesForm.get('libro')?.enable();
     this.GestionAsientosAjustesForm.get('estado')?.enable();
     this.GestionAsientosAjustesForm.get('glosaContable')?.enable();
     
     // Resetear formulario con valores por defecto
     this.GestionAsientosAjustesForm = this.formBuilder.group({
       usuario: [{ value: 'Juan Pérez', disabled: true }],
       fechaRegistro: [{ value: new Date().toISOString().split('T')[0], disabled: true }],
       origen: [{ value: 'Manual', disabled: false }],
       fechaContable: ['', Validators.required],
       libro: ['', Validators.required],
       moneda: ['Soles'],
       tasaCambio: [{ value: '3.75', disabled: true }],
       estado: ['Activo', Validators.required],
       situacionContable: [{ value: 'No transferido', disabled: true }],
       glosaContable: ['']
     });
     
     this.formValidationService.inicializarFormulario(this.GestionAsientosAjustesForm);

     // Suscribirse nuevamente a los cambios
     this.GestionAsientosAjustesForm.valueChanges.subscribe(() => {
       this.verificarCambios();
     });
     
     // Deseleccionar toda la tabla
     if (this.gridApi) {
       this.gridApi.deselectAll();
     }
     
     // Limpiar asiento seleccionado y tabla de cuentas
     this.asientoSeleccionado = null;
     this.rowDataCuentas = [];
     if (this.gridApiCuentas) {
       this.gridApiCuentas.setGridOption('rowData', []);
     }
     this.datosseleccionado = false;
     
     // Restaurar cuentas en el autocomplete (getter reactivo — no requiere mutación)

     // Resetear tracking de cambios
     this.formularioInicial = this.GestionAsientosAjustesForm.value;
     this.formularioModificado = false;
     this.formValidationService.resetearEstado();
     
     // Limpiar número temporal
     this.numeroAsientoTemporal = null;
     
     // Activar modo nuevo asiento
     this.modoNuevoAsiento = true;
     
     // Resetear totales
     this.calcularTotales();
   }
   
   /**
    * Carga las cuentas asociadas a un asiento específico desde los datos embebidos del JSON
    */
   private cargarCuentasDelAsiento(data: AjusteReclasificacionItem) {
     // Obtener las cuentas embebidas en el item del asiento
     this.rowDataCuentas = data.ajuste_rec_cuentas ? [...data.ajuste_rec_cuentas] : [];

     // Actualizar la grilla
     if (this.gridApiCuentas) {
       this.gridApiCuentas.setGridOption('rowData', this.rowDataCuentas);
     }

     // Recalcular totales
     this.calcularTotales();
   }
 
   botonNuevaSubclase() {
     console.log('Nueva subclase');
   }
 
   onCuentaContableSeleccionada(cuenta: any) {
     console.log('Cuenta seleccionada:', cuenta);
     
     // Extraer código y descripción del nombre de la cuenta
     const partes = cuenta.nombre.split(' - ');
     const codigoCuenta = partes[0];
     const descripcion = partes[1] || '';
     
     // Crear nueva fila para la cuenta
     const nuevaCuenta: CuentaMovimientoAjusteItem = {
       cuenta_mov_ajuste_cuenta: codigoCuenta,
       cuenta_mov_ajuste_descripcion: descripcion,
       cuenta_mov_ajuste_debe_soles: 0,
       cuenta_mov_ajuste_haber_soles: 0,
       cuenta_mov_ajuste_debe_dolares: 0,
       cuenta_mov_ajuste_haber_dolares: 0,
       cuenta_mov_ajuste_centro_costo: '',
       cuenta_mov_ajuste_doc_referencial: '',
      }
     
     // Agregar la nueva cuenta al array
     this.rowDataCuentas = [...this.rowDataCuentas, nuevaCuenta];
     
     // Actualizar la grilla
     if (this.gridApiCuentas) {
       this.gridApiCuentas.setGridOption('rowData', this.rowDataCuentas);
     }
     
     // Eliminar la cuenta del autocomplete para que no se pueda agregar de nuevo
     // (manejado por el componente autocomplete usando los ids ya presentes en rowDataCuentas)
     
     // Recalcular totales
     this.calcularTotales();
   }

   onFechaContableSelected(date: Date) {
     console.log('Fecha contable seleccionada:', date);
     this.fechaContableSelected = date;
     this.GestionAsientosAjustesForm.get('fechaContable')?.setValue(this.formatDate(date));
   }
 
   async onEstadoChange(event: any) {
     const nuevoEstado = event.detail.value;
     
     if (nuevoEstado === 'Inactivo' && this.datosseleccionado && this.asientoSeleccionado) {
       // Abrir modal de confirmación
       await this.abrirModalInactivar();
     }
   }
 
   guardar(){
     if (this.GestionAsientosAjustesForm.invalid || !this.fechaContableSelected) {
       this.GestionAsientosAjustesForm.markAllAsTouched();
       this.toastService.warning('Por favor, completa todos los campos requeridos');
       return;
     }

     // Validar que el asiento cuadre
     if (!this.asientoCuadra) {
       this.toastService.warning('El asiento no cuadra: validar los campos Debe y Haber');
       return;
     }
     
     if (this.rowDataCuentas.length === 0) {
       this.toastService.warning('Debe agregar al menos una cuenta contable');
       return;
     }
     
     const formValues = this.GestionAsientosAjustesForm.getRawValue();
     
     // Si es un asiento nuevo (temporal)
     if (this.numeroAsientoTemporal && !this.asientoSeleccionado) {
       // Crear nuevo asiento
       const nuevoAsiento: AjusteReclasificacionItem = {
         ajuste_rec_numero_asiento: this.numeroAsientoTemporal,
         ajuste_rec_fecha_registro: formValues.fechaRegistro,
         ajuste_rec_fecha_contable: this.fechaContableSelected ? this.formatDate(this.fechaContableSelected) : '',
         ajuste_rec_origen: formValues.origen,
         ajuste_rec_glosa: formValues.glosaContable,
         ajuste_rec_situacion_contable: formValues.situacionContable,
         ajuste_rec_usuario_ejecutor: formValues.usuario,
         ajuste_rec_total: this.totalDebeSoles, // Usar el total del debe como total del asiento
         ajuste_rec_moneda: formValues.moneda || 'Soles',
         ajuste_rec_estado: formValues.estado
       };
       
       // Agregar a la lista principal (actualizar signal)
       this.rowData.set([nuevoAsiento, ...this.rowData()]);
       
       // Actualizar la grilla
       if (this.gridApi) {
         this.gridApi.setGridOption('rowData', [...this.rowData()]);
         
         // Seleccionar el asiento recién creado
         setTimeout(() => {
           const firstNode = this.gridApi.getRowNode('0');
           if (firstNode) {
             firstNode.setSelected(true);
           }
         }, 100);
       }
       
       // Convertir el asiento temporal en uno real
       this.asientoSeleccionado = nuevoAsiento;
       this.numeroAsientoTemporal = null;
       this.formValidationService.resetearEstado();
       
       this.toastService.success('¡Asiento creado exitosamente!');
     } else if (this.asientoSeleccionado) {
       // Actualizar asiento existente
       this.asientoSeleccionado.ajuste_rec_fecha_contable = this.fechaContableSelected ? this.formatDate(this.fechaContableSelected) : this.asientoSeleccionado.ajuste_rec_fecha_contable;
       this.asientoSeleccionado.ajuste_rec_glosa = formValues.glosaContable;
       this.asientoSeleccionado.ajuste_rec_estado = formValues.estado;
       this.asientoSeleccionado.ajuste_rec_total = this.totalDebeSoles;
       
       // Actualizar en el signal inmutablemente
       const index = this.rowData().findIndex((a: AjusteReclasificacionItem) => a.ajuste_rec_numero_asiento === this.asientoSeleccionado!.ajuste_rec_numero_asiento);
       if (index !== -1) {
         const updated = [...this.rowData()];
         updated[index] = { ...this.asientoSeleccionado };
         this.rowData.set(updated);
         this.gridApi.setGridOption('rowData', [...this.rowData()]);
       }
       this.formValidationService.resetearEstado();
       
       this.toastService.success('¡Asiento actualizado exitosamente!');
     }
     
     // Mantener botones habilitados ya que ahora es un asiento guardado
     this.datosseleccionado = true;
     
     // Resetear tracking al guardar exitosamente
     this.formularioInicial = this.GestionAsientosAjustesForm.value;
     this.formularioModificado = false;
   }
   
   /**
    * Registra un nuevo asiento contable
    */
   registrar() {
     if (this.GestionAsientosAjustesForm.invalid || !this.fechaContableSelected) {
       this.GestionAsientosAjustesForm.markAllAsTouched();
       this.toastService.warning('Por favor, completa todos los campos requeridos');
       return;
     }

     if (this.rowDataCuentas.length === 0) {
       this.toastService.warning('Debe agregar al menos una cuenta contable');
       return;
     }

     if (!this.asientoCuadra) {
       this.toastService.warning('El asiento no cuadra: validar los campos Debe y Haber');
       return;
     }
     
     const formValues = this.GestionAsientosAjustesForm.getRawValue();
     
     // Generar número de asiento si no existe
     if (!this.numeroAsientoTemporal) {
       this.generarNumeroAsientoTemporal();
     }
     
     // Crear nuevo asiento
     const nuevoAsiento: AjusteReclasificacionItem = {
       ajuste_rec_numero_asiento: this.numeroAsientoTemporal!,
       ajuste_rec_fecha_registro: formValues.fechaRegistro,
       ajuste_rec_fecha_contable: this.fechaContableSelected ? this.formatDate(this.fechaContableSelected) : '',
       ajuste_rec_origen: formValues.origen,
       ajuste_rec_glosa: formValues.glosaContable,
       ajuste_rec_situacion_contable: formValues.situacionContable,
       ajuste_rec_usuario_ejecutor: formValues.usuario,
       ajuste_rec_total: formValues.moneda === 'USD' ? this.totalDebeDolares : this.totalDebeSoles,
       ajuste_rec_moneda: formValues.moneda || 'Soles',
       ajuste_rec_estado: formValues.estado
      }
     
     // Agregar a la lista principal (actualizar signal)
     this.rowData.set([nuevoAsiento, ...this.rowData()]);
     
     // Actualizar la grilla
     if (this.gridApi) {
       this.gridApi.setGridOption('rowData', [...this.rowData()]);
       this.formValidationService.resetearEstado();
       
       // Seleccionar el asiento recién creado
       setTimeout(() => {
         this.gridApi.forEachNode((node) => {
           if (node.data.ajuste_rec_numero_asiento === nuevoAsiento.ajuste_rec_numero_asiento) {
             node.setSelected(true);
           }
         });
       }, 100);
     }
     
     // Convertir el asiento temporal en uno real
     this.asientoSeleccionado = nuevoAsiento;
     this.numeroAsientoTemporal = null;
     this.modoNuevoAsiento = false;
     
     // Resetear tracking
     this.formularioInicial = this.GestionAsientosAjustesForm.value;
     this.formularioModificado = false;
     
     this.toastService.success('¡Asiento registrado exitosamente!');
   }
   
   /**
    * Formatea una fecha a formato yyyy-MM-dd
    */
   private formatDate(date: Date): string {
     const day = String(date.getDate()).padStart(2, '0');
     const month = String(date.getMonth() + 1).padStart(2, '0');
     const year = date.getFullYear();
     return `${year}-${month}-${day}`;
   }
   async abrirmodalUbicaciones(){
           const modal = await this.modalController.create({
             component: ModalImportarComponent,
             cssClass: 'promo',
             componentProps: {
               titulo: 'Importar ubicaciones',
               descripcionSubir: 'Comparte tu archivo de excel con la información de tus ubicaciones y regístralos automáticamente en la plataforma.',
               buttonName: 'Importar ubicaciones',
             }
           });
           await modal.present();
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
         { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Registro inicial del siniestro'},
         { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Cambio de estado de "Reportado" a "En evaluación"'},
         { fechaHora: '13/11/2025 09:00', usuario: 'Carlos Rodríguez', accion: 'Actualización', detalleCambio: 'Agregó documentación de respaldo (3 archivos)'},
         { fechaHora: '13/11/2025 16:45', usuario: 'Ana Martínez', accion: 'Actualización', detalleCambio: 'Cambio de estado de "En evaluación" a "Aprobado"' }
       ];
   
       const modal = await this.modalController.create({
         component: ModalVerActualizacionesComponent,
         cssClass: 'promo',
         componentProps: {
           titulo: 'Historial de Actualizaciones del Asiento AM-2025-11-001',
           rowData: rowData,
           colDefs: colDefs,
           anchoModal: '700px',
          
         }
       });
       
       await modal.present();
     }
   public async botonrevertir() {
        // Ejemplo de datos que puedes personalizar
        const detallesEjemplo: DetalleItem[] = [
          { label: 'Fecha de registro', value: '12/12/2025' },
          { label: 'Fecha contable', value: '12/12/2025' },
          { label: 'Glosa', value: 'Provisión de servicios de internet – Local San Isidro (Mes 11/2025).' },
          { label: 'Total', value: 'S/380.00' },
        ];
    
        const modal = await this.modalController.create({
          component: ModalDetalleComponent,
          cssClass: 'promo',
          componentProps: {
            tituloModal: 'Reverso de asiento MN-2025-11-05-003',
            subtitulomodal: 'Detalle de asiento:',
            tituloTextarea:'Motivo de reversión:',
            placeholderTextarea:'Se ajusta la glosa para identificar que los insumos son para producción.',
            detalles: detallesEjemplo,
            mostrarTextarea: true,
            mostrarBotonEliminar: true,
            textoBotonConfirmar: 'Revertir',
            colorBotonConfirmar: 'primary',
            botonoutline:'solid'
          }
        });
    
        await modal.present();
        
        const { data } = await modal.onWillDismiss();
        if (data && data.action === 'confirmar') {
          console.log('Almacén eliminado. Motivo:', data.motivo);
          // Aquí puedes agregar la lógica para eliminar el almacén
        }
      }
  public async botonduplicar() {
        // Ejemplo de datos que puedes personalizar
        const detallesEjemplo: DetalleItem[] = [
          { label: 'Fecha de registro:', value: '12/12/2025' },
          { label: 'Fecha contable:', value: '12/12/2025' },
          { label: 'Glosa:', value: 'Provisión de servicios de internet – Local San Isidro (Mes 11/2025).' },
          { label: 'Total:', value: 'S/380.00' },
          { label: 'Replicado:', value: 'No' }
        ];
    
        const modal = await this.modalController.create({
          component: ModalDetalleComponent,
          cssClass: 'promo',
          componentProps: {
            tituloModal: 'Duplicar asiento MN-2025-11-01-003',
            subtitulomodal: 'Detalle de asiento:',
            detalles: detallesEjemplo,
            mostrarTextarea: false,
            mostrarBotonEliminar: true,
            textoBotonConfirmar: 'Duplicar',
            colorBotonConfirmar: 'primary',
            botonoutline:'solid'
          }
        });
    
        await modal.present();
        
        const { data } = await modal.onWillDismiss();
        if (data && data.action === 'confirmar') {
          console.log('Almacén eliminado. Motivo:', data.motivo);
          // Aquí puedes agregar la lógica para eliminar el almacén
        }
      }
   public async abrirModalInactivar() {
     if (!this.asientoSeleccionado) return;
     
     const detallesEjemplo: DetalleItem[] = [
       { label: 'Fecha de registro:', value: this.asientoSeleccionado.ajuste_rec_fecha_registro },
       { label: 'Fecha contable:', value: this.asientoSeleccionado.ajuste_rec_fecha_contable },
       { label: 'Glosa:', value: this.asientoSeleccionado.ajuste_rec_glosa },
       { label: 'Total:', value: `S/ ${this.asientoSeleccionado.ajuste_rec_total.toFixed(2)}` },
     ];
 
     const modal = await this.modalController.create({
       component: ModalDetalleComponent,
       cssClass: 'promo',
       componentProps: {
         tituloModal: `Inactivar asiento ${this.asientoSeleccionado.ajuste_rec_numero_asiento}`,
         subtitulomodal: 'Detalle del asiento:',
         detalles: detallesEjemplo,
         mostrarTextarea: false,
         mostrarBotonEliminar: true,
         textoBotonConfirmar: 'Inactivar',
         colorBotonConfirmar: 'danger'
       }
     });
 
     await modal.present();
     
     const { data } = await modal.onWillDismiss();
     if (data && data.action === 'confirmar') {
       // Confirmar inactivación - mantener el estado Inactivo
       this.toastService.success('¡Asiento inactivado exitosamente!');
       
       // Actualizar el estado en la tabla
       if (this.asientoSeleccionado) {
         this.asientoSeleccionado.ajuste_rec_estado = 'Inactivo';
         this.gridApi.setGridOption('rowData', [...this.rowData()]);
       }
     } else {
       // Cancelar - revertir al estado anterior
       this.GestionAsientosAjustesForm.patchValue({
         estado: this.estadoAnterior
       }, { emitEvent: false });
     }
   }
   
   // ==================== MÉTODOS AUXILIARES ====================
   
   /**
    * Calcula los totales de debe y haber en soles y dólares
    */
   private calcularTotales() {
     this.totalDebeSoles = 0;
     this.totalHaberSoles = 0;
     this.totalDebeDolares = 0;
     this.totalHaberDolares = 0;
     
     // Sumar todos los valores de la tabla
     this.rowDataCuentas.forEach(cuenta => {
       this.totalDebeSoles += cuenta.cuenta_mov_ajuste_debe_soles || 0;
       this.totalHaberSoles += cuenta.cuenta_mov_ajuste_haber_soles || 0;
       this.totalDebeDolares += cuenta.cuenta_mov_ajuste_debe_dolares || 0;
       this.totalHaberDolares += cuenta.cuenta_mov_ajuste_haber_dolares || 0;
     });
     
     // Validar si el asiento cuadra (diferencia de 0.00)
     const diferenciaSoles = Math.abs(this.totalDebeSoles - this.totalHaberSoles);
     const diferenciaDolares = Math.abs(this.totalDebeDolares - this.totalHaberDolares);
     
     // Asiento cuadra si ambas diferencias son menores a 0.01 (para manejar errores de redondeo)
     this.asientoCuadra = diferenciaSoles < 0.01 && diferenciaDolares < 0.01;
     
     console.log('Totales calculados:', {
       debeSoles: this.totalDebeSoles,
       haberSoles: this.totalHaberSoles,
       debeDolares: this.totalDebeDolares,
       haberDolares: this.totalHaberDolares,
       cuadra: this.asientoCuadra
     });
   }
   
   /**
    * Genera un número de asiento temporal para nuevos registros
    */
   private generarNumeroAsientoTemporal() {
     const fecha = new Date();
     const año = fecha.getFullYear();
     const mes = String(fecha.getMonth() + 1).padStart(2, '0');
     const random = Math.floor(Math.random() * 9000) + 1000; // Número aleatorio de 4 dígitos
     
     this.numeroAsientoTemporal = `AM-${año}-${mes}-${random}`;
     this.datosseleccionado = true; // Mostrar botones
     
     console.log('Número temporal generado:', this.numeroAsientoTemporal);
     console.log('Botones habilitados:', this.datosseleccionado);
   }
   
   // ==================== MÉTODOS DE VALIDACIÓN DE FORMULARIO ====================
   
   /**
    * Verifica si hubo cambios en el formulario comparando el estado actual con el inicial
    */
   private verificarCambios() {
     if (!this.formularioInicial) {
       this.formularioModificado = false;
       return;
     }
     
     const valorActual = this.GestionAsientosAjustesForm.value;
     this.formularioModificado = JSON.stringify(this.formularioInicial) !== JSON.stringify(valorActual);
     
     // Generar número temporal si estamos creando un nuevo asiento
     if (!this.asientoSeleccionado && !this.numeroAsientoTemporal && this.formularioModificado) {
       this.generarNumeroAsientoTemporal();
     }
   }

}
