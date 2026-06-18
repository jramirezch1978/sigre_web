import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { RrHhPermisosRegistroGridEffects } from 'src/app/modules/rrhh/effects/rr-hh-permisos-registro-grid.effect';
import { PermisoEntity } from 'src/app/modules/rrhh/domain/models/permiso.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { ModalNuevoTipoComponent } from 'src/app/modules/contabilidad/m-c-tabla/components/c-t-plancentrocosto/modals/modal-nuevo-tipo/modal-nuevo-tipo.component';

@Component({
  selector: 'app-a-j-permisos',
  templateUrl: './a-j-permisos.component.html',
  styleUrls: ['./a-j-permisos.component.scss'],
  standalone: false,
})
export class AJPermisosComponent  implements OnInit, OnDestroy, CanComponentDeactivate {
  // Facades y Effects
  private readonly rrHhFacade = inject(RrHhFacade);
  private readonly permisosGridEffects = inject(RrHhPermisosRegistroGridEffects);

  // Selectores del store
  readonly isLoading = this.rrHhFacade.loadingPermisosRegistro;
  isResetting = false;

  get rowData(): PermisoEntity[] {
    return this.permisosGridEffects.getRowData();
  }

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  // RANGO DE FECHAS

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private gridApi!: GridApi;
  camponuevo: boolean = true;
  PermisoForm!: FormGroup;
  filaSeleccionada: any = null; 
  deshabilitado = false;
  botonesHabilitados = false;
  trabajadorSeleccionado: any = null;
   tipoSeleccionado: string = 'inicio';


  trabajadorSelect: any[] = [
    { nombre: 'Ernesto Alvarado', permiso_sucursal: 'Santa Isabel, Piura', permiso_centro_costo: 'AC01 - Administración' },
    { nombre: 'Juan Pérez', permiso_sucursal: 'La Molina, Lima', permiso_centro_costo: 'AC01 - Administración' },
    { nombre: 'María García', permiso_sucursal: 'San Isidro, Lima', permiso_centro_costo: 'AC02 - Ventas' },
    { nombre: 'Carlos López', permiso_sucursal: 'San Borja, Lima', permiso_centro_costo: 'AC03 - Producción' },
    { nombre: 'Ana Torres', permiso_sucursal: 'Miraflores, Lima', permiso_centro_costo: 'AC02 - Ventas' },
    { nombre: 'Pedro Ramirez', permiso_sucursal: 'Surco, Lima', permiso_centro_costo: 'AC03 - Producción' }
  ];

    tipoFs=[
    { value: 'inicio', nombre: 'Inicio'},
    { value: 'fin', nombre: 'Fin'},
  ]
  

  tipos=[
    "Días",
    "Horas",
  ];

  tiemposP=[
    "Remunerado",
    "No remunerado",
  ];

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
  //  Tipado con la entidad
  colDefs: ColDef<PermisoEntity>[] = [
    { field: 'permiso_codigo', headerName: 'Código', width: 110 },
    { field: 'permiso_trabajador', headerName: 'Trabajador', width: 140, filter: true },
    { field: 'permiso_sucursal', headerName: 'Sucursal', width: 140, filter: true },
    { field: 'permiso_centro_costo', headerName: 'Centro de costo', width: 150, filter: true },
    { field: 'permiso_motivo', headerName: 'Motivo', flex:1, minWidth: 140 },
    { field: 'permiso_tipo', headerName: 'Tipo de permiso', width: 150, filter: true },
    { field: 'permiso_fecha_inicio', headerName: 'Fecha de inicio', width: 120,
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate() + 1).padStart(2, '0');
        return `${day}/${month}/${year}`;
      }
    },
    { field: 'permiso_fecha_fin', headerName: 'Fecha de fin ', width: 120,
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate() +1).padStart(2, '0');
        return `${day}/${month}/${year}`;
      }
    },
    { field: 'permiso_estado', headerName: 'Estado', headerClass:'centrarencabezado', width: 100, filter: true,
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
      private modalController: ModalController,
      private formValidationService: FormValidationService
    ) {
      this.minDate = new Date(2020, 0, 1);
      this.maxDate = new Date();
    }

  ngOnInit() {
    // Cargar permisos desde el JSON a través de la capa de infraestructura
    this.rrHhFacade.cargarPermisosRegistro();

    this.PermisoForm = this.formBuilder.group({
      permiso_trabajador: ['', Validators.required],
      permiso_sucursal: [{value: '', disabled: true}, Validators.required],
      permiso_centro_costo: [{value: '', disabled: true}, Validators.required],
      permiso_tipo: ['', Validators.required],
      permiso_motivo: ['', Validators.required],
      permiso_tiempo_permiso: ['', Validators.required],
      permiso_fecha_inicio: [new Date()],
      permiso_fecha_fin: [new Date()],
      permiso_hora_inicio: [''],
      permiso_hora_fin: [''],
      permiso_estado: [{ value: 'Pendiente', disabled: true }, Validators.required],
    });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.PermisoForm);
  }

  onTrabajadorSeleccionado(trabajador: any) {
    this.trabajadorSeleccionado = trabajador;
    // Rellenar automáticamente los campos de sucursal y centro de costo
    this.PermisoForm.patchValue({ 
      permiso_trabajador: trabajador?.nombre || '',
      permiso_sucursal: trabajador?.permiso_sucursal || '',
      permiso_centro_costo: trabajador?.permiso_centro_costo || ''
    });
  }

  onFechaISelected(fecha: Date) {
    this.PermisoForm.patchValue({ permiso_fecha_inicio: fecha });
  } 
  onFechaFSelected(fecha: Date) {
    this.PermisoForm.patchValue({ permiso_fecha_fin: fecha });
  } 
  
  filtrarPorFechas(range: { start: Date; end: Date }): void {
    this.startDate = range.start;
    this.endDate = range.end;
  }
  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  async onSelectionChanged(params: any) {
    const selected = params.api.getSelectedNodes();

    // Si NO seleccionaron nada, salir
    if (!selected.length) {
      return;
    }

    const nuevaSeleccion = selected[0].data;

    // Si es la misma fila, no hacer nada (evitar validación innecesaria)
    if (this.filaSeleccionada && this.filaSeleccionada.permiso_codigo === nuevaSeleccion.permiso_codigo) {
      return;
    }

    // Guardar referencia del elemento que tiene el foco actualmente
    const elementoConFoco = document.activeElement as HTMLElement;
    
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Si cancela → deseleccionar todo y re-seleccionar la anterior
      setTimeout(() => {
        this.gridApi.deselectAll();
        if (this.filaSeleccionada) {
          this.gridApi.forEachNode((node) => {
            if (node.data.permiso_codigo === this.filaSeleccionada.permiso_codigo) {
              node.setSelected(true);
            }
          });
        }
        // Restaurar foco si es un input
        if (elementoConFoco && (elementoConFoco.tagName === 'INPUT' || elementoConFoco.tagName === 'TEXTAREA')) {
          elementoConFoco.focus();
        }
      }, 0);
      return;
    }
    
    // Usuario confirmó → aplicar nueva selección
    this.cargarDatosRegistro(nuevaSeleccion);
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: any): void {
    this.camponuevo = false;
    this.filaSeleccionada = data;
    // AG-Grid ya tiene la selección visual correcta, no manipular aquí

    // Llenar los campos del formulario con los datos de la fila
    // Para ion-input type="date" necesitamos formato YYYY-MM-DD (string)
    this.PermisoForm.patchValue({
      permiso_trabajador: data.permiso_trabajador || '',               
      permiso_sucursal: data.permiso_sucursal || '',                   
      permiso_centro_costo: data.permiso_centro_costo || '',
      permiso_tipo: data.permiso_tipo || '',
      permiso_motivo: data.permiso_motivo || '',
      permiso_tiempo_permiso: data.permiso_tiempo_permiso || '',
      permiso_fecha_inicio: data.permiso_fecha_inicio || '',
      permiso_fecha_fin: data.permiso_fecha_fin || '',
      permiso_hora_inicio: data.permiso_hora_inicio || '',
      permiso_hora_fin: data.permiso_hora_fin || '',
      permiso_estado: data.permiso_estado || 'Pendiente'
    });

    // Establecer trabajador seleccionado para el autocomplete
    this.trabajadorSeleccionado = { nombre: data.permiso_trabajador || '' };

    // Habilitar edición solo si el estado es Pendiente
    const puedeEditar = data.permiso_estado === 'Pendiente';
    
    if (puedeEditar) {
      // Habilitar todos los campos excepto sucursal, centroCosto y estado
      this.PermisoForm.enable();
      this.PermisoForm.get('permiso_sucursal')?.disable();
      this.PermisoForm.get('permiso_centro_costo')?.disable();
      this.PermisoForm.get('permiso_estado')?.disable();
      this.deshabilitado = false;
    } else {
      // Deshabilitar todos los campos si no se puede editar
      this.PermisoForm.disable();
      this.deshabilitado = true;
    }

    // Habilitar botones solo si el estado es Pendiente
    this.botonesHabilitados = data.permiso_estado === 'Pendiente';

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }

  async botonNuevoPermiso(){
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Cancelar acción
    }

    this.camponuevo = true;
    this.filaSeleccionada = null; 
    this.trabajadorSeleccionado = null;
    this.gridApi?.deselectAll(); 
    this.PermisoForm.reset({
      permiso_estado:'Pendiente',
      permiso_fecha_inicio: new Date(),
      permiso_fecha_fin: new Date(),
    });
 
    // Habilitar todos los campos para edición
    this.PermisoForm.enable();
    this.deshabilitado = false;
    
    // Generar código automático
    
    // Deshabilitar campos específicos
    this.PermisoForm.get('permiso_sucursal')?.disable();
    this.PermisoForm.get('permiso_centro_costo')?.disable();
    this.PermisoForm.get('permiso_estado')?.disable();

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }
  botonGuardar(){
    if (this.PermisoForm.invalid) {
      this.PermisoForm.markAllAsTouched();
      this.toastService.warning("Por favor, completa todos los campos requeridos");
      return;
    }

    const formValues = this.PermisoForm.getRawValue();
    
    // Generar código automático para nuevos permisos
    const codigo = this.camponuevo ? this.generarNuevoCodigo() : this.filaSeleccionada?.permiso_codigo;
    
    // Crear objeto con los datos del formulario
    const permisoData: PermisoEntity = {
      permiso_codigo: codigo,
      permiso_trabajador: formValues.permiso_trabajador,
      permiso_sucursal: formValues.permiso_sucursal,
      permiso_centro_costo: formValues.permiso_centro_costo,
      permiso_tipo: formValues.permiso_tipo,
      permiso_motivo: formValues.permiso_motivo,
      permiso_tiempo_permiso: formValues.permiso_tiempo_permiso,
      permiso_fecha_inicio: formValues.permiso_fecha_inicio instanceof Date ? formValues.permiso_fecha_inicio.toISOString().split('T')[0] : formValues.permiso_fecha_inicio,
      permiso_fecha_fin: formValues.permiso_fecha_fin instanceof Date ? formValues.permiso_fecha_fin.toISOString().split('T')[0] : formValues.permiso_fecha_fin,
      permiso_hora_inicio: formValues.permiso_hora_inicio,
      permiso_hora_fin: formValues.permiso_hora_fin,
      permiso_estado: formValues.permiso_estado
    };

    // Si es un nuevo permiso (camponuevo = true)
    if (this.camponuevo) {
      const currentData = this.permisosGridEffects.getRowData();
      this.permisosGridEffects.setRowData([permisoData, ...currentData]);
      this.toastService.success('¡Permiso creado exitosamente!');

      // Limpiar formulario solo al registrar nuevo
      this.PermisoForm.reset({
        permiso_estado: 'Pendiente',
        permiso_fecha_inicio: new Date(),
        permiso_fecha_fin: new Date(),
      });
      this.PermisoForm.get('permiso_sucursal')?.disable();
      this.PermisoForm.get('permiso_centro_costo')?.disable();
      this.PermisoForm.get('permiso_estado')?.disable();
      this.filaSeleccionada = null;
      this.trabajadorSeleccionado = null;
      this.camponuevo = true;
      this.gridApi?.deselectAll();
    }
    // Si es edición (camponuevo = false y hay una fila seleccionada)
    else if (this.filaSeleccionada) {
      const currentData = this.permisosGridEffects.getRowData();
      const index = currentData.findIndex((item: PermisoEntity) => item.permiso_codigo === this.filaSeleccionada.permiso_codigo);
      if (index !== -1) {
        const updatedData = [...currentData];
        updatedData[index] = permisoData;
        this.filaSeleccionada = permisoData;
        this.permisosGridEffects.setRowData(updatedData);
      }
      this.toastService.success('¡Cambios guardados exitosamente!');
      // No limpiar formulario ni deseleccionar la tabla al editar
    }

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }
  
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.permisosGridEffects.setGridApi(params.api);
  }

  // Generar código automático para nuevas operaciones
  generarNuevoCodigo(): string {
    const numeros = this.permisosGridEffects.getRowData().map(item => {
      const match = item.permiso_codigo.match(/PERM-(\d+)/);
      return match ? parseInt(match[1], 10) : 0;
    });
    const maxNumero = Math.max(...numeros, 0);
    const nuevoNumero = (maxNumero + 1).toString().padStart(3, '0');
    return `PERM-${nuevoNumero}`;
  }


  onBtReset() {
    this.isResetting = true;
    this.rrHhFacade.cargarPermisosRegistro();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.isResetting = false;
      }
    }, 100);
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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar'},
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385'},
      { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380'},
      { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de actualización del permiso ${this.filaSeleccionada.permiso_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
       
      }
    });
    
    await modal.present();
  }

  async abrirModalNuevoTipo() {
      const modal = await this.modalController.create({
        component: ModalNuevoTipoComponent,
        cssClass: 'custom-modal-small'
      });
  
      await modal.present();
  
      const { data } = await modal.onWillDismiss();
  
      if (data && data.action === 'guardar') {
        const nuevoTipo = data.nuevoTipo.trim();
  
        // Verificar si ya existe
        if (this.tiemposP.includes(nuevoTipo)) {
          this.toastService.danger('Este tipo ya existe');
          return;
        }
  
        // Agregar el nuevo tipo
        this.tiemposP.push(nuevoTipo);
  
        // Seleccionar automáticamente el nuevo tipo en el formulario
        this.PermisoForm.patchValue({ clasificacion: nuevoTipo });
  
        this.toastService.success('Tipo agregado exitosamente');
      }
    }

}
