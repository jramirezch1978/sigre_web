import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { DefinicionAreasJerarquiasEntity } from 'src/app/modules/rrhh/domain/models/definicion-areas-jerarquias.entity';




interface IAreas {
  id: number;
  area_nombre: string;
}
interface ICentros {
  id: number;
  area_nombre: string;
}

interface IJefes {
  id: number;
  area_nombre: string;
}

@Component({
  selector: 'app-definicion-areas-jerarquias',
  templateUrl: './definicion-areas-jerarquias.component.html',
  styleUrls: ['./definicion-areas-jerarquias.component.scss'],
  standalone: false,
})
export class DefinicionAreasJerarquiasComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  // Facade y selectores del store
  private readonly rrHhFacade = inject(RrHhFacade);
  readonly isLoading = this.rrHhFacade.loadingDefinicionAreasJerarquias;



  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  fechaCreacion: Date | undefined;
  modoCreacion: boolean = true; 
  modoEdicion: boolean = false;

  private gridApi!: GridApi;
  DefAreasForm!: FormGroup;

  filaSeleccionada: any = null;

  formularioActivo: boolean = true; // Formulario activo por defecto

  areas: IAreas[] = [
    { id: 1, area_nombre: 'Dirección General' },
    { id: 2, area_nombre: 'Operaciones' },
  ];

  centros: ICentros[] = [
    { id: 1, area_nombre: 'Operaciones' },
    { id: 2, area_nombre: 'Cocina' },
    { id: 3, area_nombre: 'Marketing' },
    { id: 4, area_nombre: 'Recursos Humanos' },
  ];
  jefes: IJefes[] = [
    { id: 1, area_nombre: 'Alexander Palomeque Aguirre' },
    { id: 2, area_nombre: 'Rhan Chang Castagníno' },
    { id: 3, area_nombre: 'Odalucha Espinoza Valladolid' },
    { id: 4, area_nombre: 'Milagros Veintimilla Ontaneda' },

  ];

   niveles = [
    'Dirección',
    'Gerencia',
    'Jefatura',
    'Operación',
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

  rowData: DefinicionAreasJerarquiasEntity[] = [];
  isResetting = false;

  colDefs: ColDef[] = [
    { field: 'area_codigo', headerName: 'Código', width: 100 },
    { field: 'area_fecha_creacion', headerName: 'Fecha de creación', width: 110,
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
    { field: 'area_nombre', headerName: 'Nombre de área', width: 180, filter: true },
    { field: 'area_descripcion', headerName: 'Descripción', flex: 1, minWidth: 200, filter: true },
    { field: 'area_nivel', headerName: 'Nivel', width: 120, filter: true },
    { field: 'area_area_supervisora', headerName: 'Área supervisora', width: 160, filter: true },
    { field: 'area_centro_costo', headerName: 'Centro de costo', width: 160 },
    { field: 'area_jefe_asignado', headerName: 'Jefe asignado', width: 150 },
    {
      field: 'area_estado', headerName: 'Estado', width: 100, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
        } else if (params.value === 'Inactivo') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>';
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
    this.initializeForm();
    // Inicializar el servicio de validación de formularios
    this.formValidationService.inicializarFormulario(this.DefAreasForm);
    // Cargar datos desde el JSON a través de la capa de infraestructura
    this.rrHhFacade.cargarDefinicionAreasJerarquias();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = [...this.rrHhFacade.definicionAreasJerarquias()];
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', this.rowData);
        }
        clearInterval(interval);
      }
    }, 100);
  }
  private initializeForm(): void {
    this.fechaCreacion = new Date();
    this.DefAreasForm = this.formBuilder.group({
      fechaCreacion: [{ value: new Date().toISOString().substring(0, 10), disabled: true }],
      nombres: ['', Validators.required],
      area_descripcion: ['', Validators.required],
      area_nivel: ['', Validators.required],
      area:[''],
      area_centro_costo: ['', Validators.required],
      jefe: ['', Validators.required],
      area_estado: [{ value: 'Activo', disabled: true }],


    });
  } 

   onGridReady(params: GridReadyEvent) {
      this.gridApi = params.api;
      // No seleccionar ninguna fila por defecto para mantener el estado de nuevo registro
    }
  
    async onCellClicked(event: any) {
      if (!event.data) return;
      const data = event.data;

      // Validar cambios antes de cambiar de área
      const confirmar = await this.formValidationService.validarCambios();

      if (!confirmar) {
        // Usuario canceló - restaurar selección anterior
        if (this.gridApi && this.filaSeleccionada) {
          const prevCodigo = this.filaSeleccionada.area_codigo;
          setTimeout(() => {
            this.gridApi.deselectAll();
            this.gridApi.forEachNode((node) => {
              if (node.data?.area_codigo === prevCodigo) {
                node.setSelected(true);
              }
            });
          }, 0);
        }
        return;
      }

      // Usuario confirmó, cargar datos y seleccionar nueva fila
      this.filaSeleccionada = data;
      this.modoCreacion = false;
      this.modoEdicion = true;
      this.formularioActivo = false;
      this.cargarDatosEnFormulario(data);
      this.deshabilitarFormulario();
      const selectedCodigo = data.area_codigo;
      setTimeout(() => {
        this.gridApi?.deselectAll();
        this.gridApi?.forEachNode((node) => {
          if (node.data?.area_codigo === selectedCodigo) {
            node.setSelected(true);
          }
        });
      }, 0);
    }
  
    onBtReset() {
      this.isResetting = true;
      this.rrHhFacade.cargarDefinicionAreasJerarquias();
      const interval = setInterval(() => {
        if (!this.isLoading()) {
          this.rowData = [...this.rrHhFacade.definicionAreasJerarquias()];
          if (this.gridApi) {
            this.gridApi.setGridOption('rowData', this.rowData);
          }
          clearInterval(interval);
          this.isResetting = false;
        }
      }, 100);
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

  private cargarDatosEnFormulario(datos: any): void {
    // Buscar el área supervisora correspondiente
    const areaSupervisora = this.areas.find(a => a.area_nombre === datos.area_area_supervisora);
    
    // Buscar el centro de costo correspondiente
    const centroCosto = this.centros.find(c => c.area_nombre === datos.area_centro_costo);
    
    // Buscar el jefe asignado correspondiente
    const jefeAsignado = this.jefes.find(j => j.area_nombre === datos.area_jefe_asignado);
    
    // Cargamos los valores en el formulario (los autocompletes necesitan el ID, no el objeto completo)
    this.DefAreasForm.patchValue({
      fechaCreacion: datos.fechaCreacion || new Date().toISOString().substring(0, 10),
      nombres: datos.area_nombre,
      area_descripcion: datos.area_descripcion,
      area_nivel: datos.area_nivel,
      area: areaSupervisora?.id || null,
      area_centro_costo: centroCosto?.id || null,
      jefe: jefeAsignado?.id || null,
      // Mostramos el estado actual de la fila
      area_estado: datos.area_estado || 'Activo',
    });
    
    // Resetear el estado del servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }

  // Método para deshabilitar el formulario
  private deshabilitarFormulario(): void {
    Object.keys(this.DefAreasForm.controls).forEach(key => {
      if (key !== 'area_estado') {
        this.DefAreasForm.get(key)?.disable();
      } else {
        // Habilitar explícitamente el campo estado
        this.DefAreasForm.get(key)?.enable();
      }
    });
  }

  onAreaSeleccionado(areas: IAreas) {
    console.log('Area seleccionada:', areas);
  }
  onCentroSeleccionado(centro: ICentros) {
    console.log('Centros de costo seleccionados:', centro);
  }
  onJefesSeleccionado(jefes: IJefes) {
    console.log('Centros de costo seleccionados:', jefes);
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
        titulo: `Historial de actualizaciones del área ${this.filaSeleccionada.area_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }

  async botonNuevo(): Promise<void> {
    // Validar si hay cambios sin guardar antes de crear uno nuevo
    const puede = await this.formValidationService.validarCambios();
    if (!puede) {
      return; // Usuario canceló, mantener el formulario actual
    }
    
    this.modoCreacion = true;
    this.modoEdicion = false;
    this.filaSeleccionada = null;
    this.formularioActivo = true;
    
    // Resetear el formulario con valores por defecto
    this.fechaCreacion = new Date();
    this.DefAreasForm.reset({
      fechaCreacion: { value: new Date().toISOString().substring(0, 10), disabled: true },
      nombres: '',
      area_descripcion: '',
      area_nivel: '',
      area: null,
      area_centro_costo: null,
      jefe: null,
      area_estado: { value: 'Activo', disabled: true }
    });
    
    this.habilitarFormulario();
    
    // Resetear el estado del servicio de validación
    this.formValidationService.resetearEstado();
    
    // Deseleccionar cualquier fila en la grilla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  async botonCancelar(): Promise<void> {
    // Validar cambios antes de cancelar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Si cancela, deseleccionar la fila
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }
      return; // Cancelar acción
    }

    // Reiniciar el formulario a los valores por defecto
    if (this.DefAreasForm) {
      this.DefAreasForm.reset({
        fechaCreacion: { value: new Date().toISOString().substring(0, 10), disabled: true },
        nombres: '',
        area_descripcion: '',
        area_nivel: '',
        area: null,
        area_centro_costo: null,
        jefe: null,
        area_estado: { value: 'Activo', disabled: true }
      });

      // Limpiar fila seleccionada
      this.filaSeleccionada = null;

      // Deseleccionar fila de la tabla
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }

      // Retornar a modo creación
      this.modoCreacion = true;
      this.modoEdicion = false;
      this.formularioActivo = true;
      this.habilitarFormulario();

      // Resetear estado del servicio de validación
      this.formValidationService.resetearEstado();
    }
  }

  botonCrear(): void {
    if (this.DefAreasForm.invalid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    // Obtener los IDs de los autocompletes
    const areaId = this.DefAreasForm.get('area')?.value;
    const centroCostoId = this.DefAreasForm.get('area_centro_costo')?.value;
    const jefeId = this.DefAreasForm.get('jefe')?.value;

    // Buscar los objetos completos por ID
    const areaSupervisora = this.areas.find(a => a.id === areaId);
    const centroCosto = this.centros.find(c => c.id === centroCostoId);
    const jefeAsignado = this.jefes.find(j => j.id === jefeId);

    const nuevoRegistro = {
      area_codigo: `AR-${String(this.rowData.length + 1).padStart(4, '0')}`,
      area_fecha_creacion: new Date().toISOString().substring(0, 10),
      area_nombre: this.DefAreasForm.get('nombres')?.value,
      area_descripcion: this.DefAreasForm.get('area_descripcion')?.value,
      area_nivel: this.DefAreasForm.get('area_nivel')?.value,
      area_area_supervisora: areaSupervisora?.area_nombre || '-',
      area_centro_costo: centroCosto?.area_nombre || '-',
      area_jefe_asignado: jefeAsignado?.area_nombre || '-',
      area_estado: 'Activo'
    };

    this.rowData = [nuevoRegistro, ...this.rowData];
    
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }

    this.toastService.success('¡Área registrada exitosamente!');
    // Resetear el estado del servicio de validación después de guardar
    this.formValidationService.resetearEstado();
    this.botonNuevo();
  }

  guardarEdicion(): void {
    if (this.filaSeleccionada) {
      // Actualizar el estado de la fila seleccionada
      const nuevoEstado = this.DefAreasForm.get('area_estado')?.value;
      
      // Encontrar el índice de la fila en rowData
      const indice = this.rowData.findIndex(row => row.area_codigo === this.filaSeleccionada.area_codigo);
      
      if (indice !== -1) {
        // Actualizar el estado en el rowData
        this.rowData[indice].area_estado = nuevoEstado;
        this.filaSeleccionada.area_estado = nuevoEstado;
        
        // Refrescar la tabla
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', [...this.rowData]);
        }
        
        // Mostrar mensaje de éxito
        this.toastService.success('¡Cambios realizados exitosamente!');
        // Resetear el estado del servicio de validación después de guardar
        this.formValidationService.resetearEstado();
        
        // Resetear el formulario como si fuera una creación nueva
        this.botonNuevo();
      }
    }
  }

  private habilitarFormulario(): void {
    Object.keys(this.DefAreasForm.controls).forEach(key => {
      if (key !== 'fechaCreacion' && key !== 'area_estado') {
        this.DefAreasForm.get(key)?.enable();
      }
    });
  }

  // Implementar canDeactivate para proteger navegación
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  // Limpiar el servicio al destruir el componente
  ngOnDestroy(): void {
    this.formValidationService.limpiarFormulario();
  }


}
