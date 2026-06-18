import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { AccesorioActionsCellComponent } from 'src/app/modules/activos/m-af-tabla/pages/af-o-registroactivos/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { DefinicionCargosEntity } from 'src/app/modules/rrhh/domain/models/definicion-cargos.entity';
import { DefinicionAreasJerarquiasEntity } from 'src/app/modules/rrhh/domain/models/definicion-areas-jerarquias.entity';
import { CategoriaLaboralEntity } from 'src/app/modules/rrhh/domain/models/categoria-laboral.entity';
import { CentroCostoFacade } from 'src/app/modules/contabilidad/application/facades/plan-centro-costos.facade';
import { CentroCostoEntity } from 'src/app/modules/contabilidad/domain/models/centro-costo.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-definicion-cargos',
  templateUrl: './definicion-cargos.component.html',
  styleUrls: ['./definicion-cargos.component.scss'],
  standalone: false,
})
export class DefinicionCargosComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // Facade
  private readonly facade = inject(RrHhFacade);
  private readonly centroCostoFacade = inject(CentroCostoFacade);

  // Selectores del store
  readonly isLoading = this.facade.loadingDefinicionCargos;

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  mostrarpanelizquierdo: boolean = true;
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private gridApi!: GridApi;
  private gridApiFunciones!: GridApi;
  DefCargosForm!: FormGroup;

  filaSeleccionada: any = null;
  camponuevo: boolean = true;
  formularioActivo: boolean = true;

  // Datos para tabla de funciones
  rowDataFunciones = [
    { numero: 1, descripcion: '' }
  ];

  colDefsFunciones: ColDef[] = [
    { 
      field: 'numero', 
      headerName: 'N°',
      headerClass: 'centrarencabezado', 
      width: 50,
      cellStyle: (params: any) => {
        const style: any = { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' };
        if (!params.data.descripcion || params.data.descripcion.trim() === '') {
          style.color = '#C7C7C7';
        }
        return style;
      }
    },
    { 
      field: 'descripcion', 
      headerName: 'Descripción de función', 
      flex: 1,
      editable: true,
      cellEditor: 'agTextCellEditor',
      cellStyle: { cursor: 'pointer' },
      valueFormatter: (params) =>
        params.value && params.value.trim() !== ''
          ? params.value
          : 'Escribe aquí la función',
      cellClass: (params) =>
        !params.value || params.value.trim() === ''
          ? 'placeholder-cell'
          : ''
    
    },
    {
      field: 'accion',
      headerName: 'Acción',
      width: 80,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', cursor: 'pointer' },
      cellRenderer: AccesorioActionsCellComponent,
      cellRendererParams: (params: any) => {
        return {
          color: (!params.data.descripcion || params.data.descripcion.trim() === '') ? 'text-[#C7C7C7]' : 'text-danger'
        };
      },
      onCellClicked: (params: any) => {
        this.eliminarFuncion(params.node.rowIndex);
      }
    }
  ];


  areas: DefinicionAreasJerarquiasEntity[] = [];
  categorialab: CategoriaLaboralEntity[] = [];
  centros: CentroCostoEntity[] = [];

  niveles = [
    'Operativo',
    'Supervicion',
    'Gerencia',
    'Dirección',
  ];
  
   estados = [
    'Activo','Inactivo'
  ]


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
  rowData: DefinicionCargosEntity[] = [];
  isResetting = false;


  colDefs: ColDef[] = [
    { field: 'cargo_codigo', headerName: 'Código', width: 80 },
    { field: 'cargo_nombre', headerName: 'Nombres de cargo', flex: 1, minWidth: 150 },
    { field: 'cargo_funciones', headerName: 'Funciones ', width: 300,
      valueFormatter: (params: any) => {
        if (Array.isArray(params.value)) {
          return params.value
            .filter((f: any) => f.descripcion && f.descripcion.trim() !== '')
            .map((f: any) => f.descripcion)
            .join(', ');
        }
        return params.value || '';
      }
    },
    { field: 'cargo_centro_costos', headerName: 'Centro de Costos', width: 150, },
    { field: 'cargo_nivel', headerName: 'Nivel', width: 160, filter: true, },
    { field: 'cargo_salario_minimo', headerName: 'B. salarial mínimo', width: 130,
      valueFormatter: (params: any) => {
        const moneda = 'S/';
        const valor = Number(params.value).toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        return `${moneda} ${valor}`;
      }
     },
    { field: 'cargo_salario_promedio', headerName: 'B. salarial promedio', width: 130,
      valueFormatter: (params: any) => {
        const moneda = 'S/';
        const valor = Number(params.value).toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        return `${moneda} ${valor}`;
      }
     },
    { field: 'cargo_salario_maximo', headerName: 'B. salarial máximo', width: 130,
      valueFormatter: (params: any) => {
        const moneda = 'S/';
        const valor = Number(params.value).toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        return `${moneda} ${valor}`;
      }
     },
    { field: 'cargo_vigencia', headerName: 'Vigencia hasta', width: 100,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return 'Indefinido';
      }
     },
    {
      field: 'cargo_estado', headerName: 'Estado', width: 100, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', },
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
    this.DefCargosForm = this.formBuilder.group({
      fechaCreacion: [{ value: new Date().toISOString().substring(0, 10), disabled: true }],
      nombres: ['', [Validators.required]],
      cargo_area: ['', Validators.required],
      categoriaLab: ['', Validators.required],
      centroCosto: ['', Validators.required],
      cargo_nivel: ['', Validators.required],
      SalarialMin: ['', [Validators.required, Validators.min(0)]],
      SalarialProm: ['', [Validators.required, Validators.min(0)]],
      SalarialMax: ['', [Validators.required, Validators.min(0)]],
      fechaVigencia: [new Date()],
      conceptoVigencia: [false],
      cargo_estado: ['Activo'],
    });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.DefCargosForm);

    // Cargar datos desde el JSON a través de la capa de infraestructura
    this.facade.cargarDefinicionCargos();
    this.facade.cargarDefinicionAreasJerarquias();
    this.facade.cargarCategoriasLaborales();
    this.centroCostoFacade.cargarCentrosCosto();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.rowData = [...this.facade.definicionCargos()];

        // Cargar áreas desde el facade
        this.areas = this.facade.definicionAreasJerarquias();

        // Cargar centros de costo desde el facade de contabilidad
        this.centros = this.centroCostoFacade.centrosCosto();

        // Cargar categorías laborales desde el facade
        this.categorialab = this.facade.categoriasLaborales();

        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', this.rowData);
        }
        // Restaurar fila seleccionada si existe (al volver a la pantalla)
        if (this.filaSeleccionada) {
          const codigo = this.filaSeleccionada.cargo_codigo;
          setTimeout(() => {
            this.gridApi?.forEachNode((node) => {
              if (node.data?.cargo_codigo === codigo) {
                node.setSelected(true);
              }
            });
          }, 0);
        }
      }
    }, 100);
  }



  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // Restaurar la fila seleccionada al volver a la pantalla
    if (this.filaSeleccionada) {
      const codigo = this.filaSeleccionada.cargo_codigo;
      setTimeout(() => {
        this.gridApi?.forEachNode((node) => {
          if (node.data?.cargo_codigo === codigo) {
            node.setSelected(true);
          }
        });
      }, 0);
    }
  }

  async onSelectionChanged(params: any) {
    const selected = params.api.getSelectedNodes();

    // Si NO seleccionaron nada, salir
    if (!selected.length) {
      return;
    }

    const nuevaSeleccion = selected[0].data;

    // Si es la misma fila, no hacer nada (evitar validación innecesaria)
    if (this.filaSeleccionada && this.filaSeleccionada.cargo_codigo === nuevaSeleccion.cargo_codigo) {
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
            if (node.data.cargo_codigo === this.filaSeleccionada.cargo_codigo) {
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
    this.filaSeleccionada = nuevaSeleccion;
    this.formularioActivo = false;
    this.cargarDatosEnFormulario(nuevaSeleccion);
    this.formValidationService.resetearEstado();
  }

  async botoncancelar(): Promise<void> {
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Cancelar acción
    }

    // Usuario confirmó, limpiar formulario y volver a modo nuevo
    this.gridApi.deselectAll();
    this.filaSeleccionada = null;
    this.camponuevo = true;
    this.formularioActivo = true;
    this.resetearFormulario();
    this.habilitarFormulario();
    this.formValidationService.resetearEstado();
  }

  onBtReset() {
    this.isResetting = true;
    this.facade.cargarDefinicionCargos();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.rowData = [...this.facade.definicionCargos()];
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', this.rowData);
        }
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

   onAreaSeleccionado(area: any) {
    console.log('Área seleccionada:', area);
  }
  onCategoriaSeleccionado(categoria: any) {
    console.log('Categoría seleccionada:', categoria);
  }

  onCentroSeleccionado(centro: any) {
    console.log('Centro de costo seleccionado:', centro);
  }

  onFechaVigenciaHastaSelected(fecha: Date) {
    this.DefCargosForm.get('fechaVigencia')?.setValue(fecha);
  }

  onConceptoVigenciaChange(event: any) {
    const isChecked = event.detail.checked;
    console.log('Vigencia indefinida:', isChecked);
    if (isChecked) {
      // Si se activa la vigencia indefinida, limpiar la fecha
      this.DefCargosForm.get('fechaVigenciaHasta')?.reset();
    }
  }

  private cargarDatosEnFormulario(datos: any): void {
  
    this.DefCargosForm.patchValue({
      nombres: datos.cargo_nombre,
      cargo_area: datos.cargo_area,
      centroCosto: datos.cargo_centro_costos,
      categoriaLab: datos.cargo_categoria,
      cargo_nivel: datos.cargo_nivel,
      SalarialMin: datos.cargo_salario_minimo,
      SalarialProm: datos.cargo_salario_promedio,
      SalarialMax: datos.cargo_salario_maximo,
      fechaVigencia: datos.cargo_vigencia,
      cargo_estado: datos.cargo_estado,
      conceptoVigencia: datos.cargo_vigencia === '' ? true : false,
    });

    // Cargar funciones en la segunda tabla
    if (datos.cargo_funciones && datos.cargo_funciones.length > 0) {
      this.rowDataFunciones = datos.cargo_funciones.map((f: any) => ({ numero: f.numero, descripcion: f.descripcion }));
    } else {
      this.rowDataFunciones = [{ numero: 1, descripcion: '' }];
    }
    // Agregar fila vacía para agregar solo si es Activo
    if (datos.cargo_estado !== 'Inactivo') {
      const ultimaFila = this.rowDataFunciones[this.rowDataFunciones.length - 1];
      if (!ultimaFila || ultimaFila.descripcion.trim() !== '') {
        this.rowDataFunciones.push({ numero: this.rowDataFunciones.length + 1, descripcion: '' });
      }
    }
    if (this.gridApiFunciones) {
      this.gridApiFunciones.setGridOption('rowData', [...this.rowDataFunciones]);
    }

    // Si el estado es Inactivo, deshabilitar todo el formulario
    if (datos.cargo_estado === 'Inactivo') {
      this.DefCargosForm.disable();
    } else {
      // Si el estado es Activo, habilitar el formulario
      this.habilitarFormulario();
    }
  }

  // Método para deshabilitar el formulario
  private deshabilitarFormulario(): void {
    Object.keys(this.DefCargosForm.controls).forEach(key => {
      const control = this.DefCargosForm.get(key);
      // Solo permitir edición de estado en modo edición
      if (key !== 'cargo_estado') {
        control?.disable();
      }
    });
  }

  // Método para habilitar el formulario
  private habilitarFormulario(): void {
    Object.keys(this.DefCargosForm.controls).forEach(key => {
      const control = this.DefCargosForm.get(key);
      // No habilitar campos deshabilitados (fechaCreacion y estado)
      if (key !== 'fechaCreacion' && key !== 'cargo_estado') {
        control?.enable();
      }
    });
  }

  // Método para crear nuevo cargo
  async crearNuevoCargo(): Promise<void> {
    // Validar si hay cambios sin guardar
    const puede = await this.formValidationService.validarCambios();
    
    if (!puede) {
      return; // Usuario canceló
    }

    // Usuario confirmó, crear nuevo cargo
    this.gridApi.deselectAll();
    this.filaSeleccionada = null;
    this.camponuevo = true;
    this.formularioActivo = true;
    this.resetearFormulario();
    this.habilitarFormulario();
    this.formValidationService.resetearEstado();
  }

  // Método para resetear el formulario
  private resetearFormulario(): void {
    this.DefCargosForm.reset({
      fechaCreacion: { value: new Date().toISOString().substring(0, 10), disabled: true },
      cargo_estado: 'Activo',
      conceptoVigencia: false,
      fechaVigencia: new Date(),
    });

    // Resetear tabla de funciones
    this.rowDataFunciones = [{ numero: 1, descripcion: '' }];
    if (this.gridApiFunciones) {
      this.gridApiFunciones.setGridOption('rowData', [...this.rowDataFunciones]);
    }
  }

  // Método para guardar nuevo cargo
  botonGuardar(): void {
    console.log('🔵 Iniciando guardar...', {camponuevo: this.camponuevo, filaSeleccionada: this.filaSeleccionada});
    
    // Marcar todos los campos como tocados para mostrar errores
    Object.keys(this.DefCargosForm.controls).forEach(key => {
      const control = this.DefCargosForm.get(key);
      if (control) {
        control.markAsTouched();
      }
    });

    if (this.DefCargosForm.invalid) {
      let campoFaltante = '';
      Object.keys(this.DefCargosForm.controls).forEach(key => {
        const control = this.DefCargosForm.get(key);
        if (control && control.invalid && !control.disabled) {
          campoFaltante = key;
          console.log(`Campo inválido: ${key}`, control.errors);
        }
      });
      this.toastService.warning('Por favor, completa todos los campos requeridos' );
      return;
    }

    const formValues = this.DefCargosForm.getRawValue();
    
    // Generar código automático para nuevos cargos
    const codigo = this.camponuevo ? `CA-${String(this.rowData.length + 1).padStart(4, '0')}` : this.filaSeleccionada?.cargo_codigo;
    
    // Determinar la vigencia
    let vigencia = '';
    const esIndefinido = this.DefCargosForm.get('conceptoVigencia')?.value;
    if (esIndefinido) {
      vigencia = '';
    } else if (formValues.fechaVigencia) {
      const fechaObj = formValues.fechaVigencia instanceof Date ? formValues.fechaVigencia : new Date(formValues.fechaVigencia);
      const day = String(fechaObj.getDate()).padStart(2, '0');
      const month = String(fechaObj.getMonth() + 1).padStart(2, '0');
      const year = fechaObj.getFullYear();
      vigencia = `${year}-${month}-${day}`;
    }
    
    // Crear objeto con los datos del formulario
    const cargoData = {
      cargo_codigo: codigo,
      fechaCreacion: formValues.fechaCreacion || new Date().toISOString().substring(0, 10),
      cargo_nombre: formValues.nombres || '',
      cargo_funciones: formValues.cargo_funciones || '',
      cargo_area: formValues.cargo_area || '',
      cargo_categoria: formValues.categoriaLab || '',
      cargo_centro_costos: formValues.centroCosto || '',
      cargo_nivel: formValues.cargo_nivel || '',
      cargo_salario_minimo: formValues.SalarialMin || 0,
      cargo_salario_promedio: formValues.SalarialProm || 0,
      cargo_salario_maximo: formValues.SalarialMax || 0,
      cargo_vigencia: vigencia,
      cargo_estado: formValues.cargo_estado || 'Activo',
    };

    try {
      let guardoExitoso = false;
      
      // Si es un nuevo cargo (camponuevo = true)
      if (this.camponuevo === true) {
        console.log(' Modo NUEVO - Agregando cargo:', cargoData);
        // Agregar al inicio del array rowData
        this.rowData.unshift(cargoData);
        
        // Actualizar la tabla
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', [...this.rowData]);
        }
        
        this.toastService.success('¡Cargo laboral registrado exitosamente!');
        guardoExitoso = true;
      } 
      // Si es edición (camponuevo = false y hay una fila seleccionada)
      else if (this.camponuevo === false && this.filaSeleccionada) {
        console.log(' Modo EDICIÓN - Actualizando cargo:', cargoData);
        // Actualizar los valores de la fila seleccionada
        Object.assign(this.filaSeleccionada, cargoData);
        
        // Refrescar la tabla
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', [...this.rowData]);
        }
        
        this.toastService.success('¡Cambios guardados exitosamente!');
        guardoExitoso = true;
      } else {
        console.error('  No se pudo determinar el modo de guardado', {
          camponuevo: this.camponuevo,
          filaSeleccionada: this.filaSeleccionada,
          tipo_camponuevo: typeof this.camponuevo,
          tipo_fila: typeof this.filaSeleccionada
        });
        this.toastService.danger('Error', 'Por favor selecciona una fila o crea un nuevo cargo', 3000);
      }
      
      // Limpiar formulario SOLO si guardó exitosamente
      if (guardoExitoso) {
        this.resetearFormulario();
        this.filaSeleccionada = null;
        this.camponuevo = false;
        this.formularioActivo = true;
        this.habilitarFormulario();
        this.formValidationService.resetearEstado();
      }
      
    } catch (error) {
      console.error('  Error al guardar cargo:', error);
      this.toastService.danger('Error', 'Ocurrió un error al guardar el cargo', 3000);
    }
  }

  // Método para guardar cambios en modo edición
  guardarEdicion(): void {
    this.botonGuardar();
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
        titulo: `Historial de actualizaciones del cargo ${this.filaSeleccionada.cargo_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }

  onGridReadyFunciones(params: GridReadyEvent) {
    this.gridApiFunciones = params.api;
    
    // Escuchar eventos de edición de celdas
    this.gridApiFunciones.addEventListener('cellValueChanged', (event: any) => {
      this.onCellValueChanged(event);
    });
  }

  onCellValueChanged(event: any) {
    // Verificar si la celda editada es la de descripción
    if (event.colDef.field === 'descripcion') {
      // Refrescar las celdas para actualizar los estilos
      if (this.gridApiFunciones) {
        this.gridApiFunciones.refreshCells({ force: true });
      }
      
      // Si hay contenido, verificar si es la última fila (solo para estado Activo o nuevo)
      if (event.newValue && event.newValue.trim() !== '') {
        const esInactivo = this.filaSeleccionada && this.filaSeleccionada.cargo_estado === 'Inactivo';
        const isLastRow = event.node.rowIndex === this.rowDataFunciones.length - 1;
        
        if (isLastRow && !esInactivo) {
          // Agregar una nueva fila vacía automáticamente
          this.agregarNuevaFuncion();
        }
      }
    }
  }

  eliminarFuncion(rowIndex: number) {
    if (this.rowDataFunciones.length > 1) {
      this.rowDataFunciones.splice(rowIndex, 1);
      // Renumerar todas las filas
      this.rowDataFunciones = this.rowDataFunciones.map((item, index) => ({
        ...item,
        numero: index + 1
      }));
      
      if (this.gridApiFunciones) {
        this.gridApiFunciones.setGridOption('rowData', [...this.rowDataFunciones]);
      }
      // this.toastService.success('¡Función eliminada exitosamente!');
    } else {
      // this.toastService.warning('Debe mantener al menos una función');
    }
  }

  agregarNuevaFuncion() {
    const nuevoNumero = this.rowDataFunciones.length + 1;
    this.rowDataFunciones.push({ numero: nuevoNumero, descripcion: '' });
    
    if (this.gridApiFunciones) {
      this.gridApiFunciones.setGridOption('rowData', [...this.rowDataFunciones]);
    }
  }

  // Implementar CanComponentDeactivate para proteger la navegación
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  // Limpiar el servicio al destruir el componente
  ngOnDestroy(): void {
    this.formValidationService.limpiarFormulario();
  }
}
