import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';
import {Component, OnInit, inject, effect} from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
import { CategoriaArticuloEntity } from '../../../../domain/models/categoria-articulo.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faCog, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-a-t-clasificacion-articulos',
  templateUrl: './a-t-clasificacion-articulos.component.html',
  styleUrls: ['./a-t-clasificacion-articulos.component.scss'],
  standalone: false,
})
export class ATClasificacionArticulosComponent  implements OnInit {
  // Facades
  private readonly almacenFacade = inject(AlmacenFacade);
  private readonly catalogosFacade = inject(CatalogosFacade);

  // Selectores del store
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.loadingClasificacionArticulos;


  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasCog = faCog;
  fasRotateRight = faRotateRight;



  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  fechaInicial: Date | undefined; 
  registroForm!: FormGroup;
  private gridApi!: GridApi;
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(this.gridApi, 'a-t-clasificacion-articulos'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }
  gridContext!: { componentParent: ATClasificacionArticulosComponent };
  filaSeleccionada: CategoriaArticuloEntity | null = null;
  archivo: any = null;
  registroEditando: CategoriaArticuloEntity | null = null;

  // Variable para controlar si hay cambios en el formulario
  formularioConCambios: boolean = false;

  categoriaFiltrada: any = [];

  // Configuración para Tree Data
  treeData = true;
  groupDefaultExpanded = 1; // 0 = todo colapsado, -1 = todo expandido, 2 = expandir hasta nivel 2
  getDataPath = (data: CategoriaArticuloEntity) => data.categoria_articulo_org_hierarchy;

  autoGroupColumnDef: ColDef = {
    headerName: 'Descripción de categorías y subcategorías',
    flex: 1,
    cellRendererParams: {
      suppressCount: true,
    },
  };

  defaultColDef: ColDef = {
    sortable: false,
    resizable: true,
  };

  // Función para aplicar clases CSS a las filas
  getRowClass = (params: any) => {
  const row = params?.data;
  if (!row) return '';          // ← Protección

  if (row.categoria_articulo_is_categoria === true) {
    return 'row-main-category';
  }
  return '';
};

  columnTypes = {};

  //   Inyección del facade de catálogos
  readonly distritos = this.catalogosFacade.distritos;
  // Alias para compatibilidad con código existente
  readonly sucursales = this.catalogosFacade.distritos;

  nivelSelect = [
    "Categoría",
    "Subcategoría",
    "Familia",
    "Linea",
  ];

  private gridApiDetalle!: GridApi;

  estadoSelect = [
    { id: 'Activo', nombre: 'Activo' },
    { id: 'Inactivo', nombre: 'Inactivo' },
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

  rowData: CategoriaArticuloEntity[] = [];


  colDefs: ColDef<CategoriaArticuloEntity>[] = [
    { field: 'categoria_articulo_nivel', headerName: 'Nivel', width: 90, filter: true, },
    { field: 'categoria_articulo_fecha_creacion', headerName: 'Fecha creación', width: 100,
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
    { field: 'categoria_articulo_estado', headerName: 'Estado', width: 100, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center',},
      cellRenderer: (params: any) => {
        const color = params.value === 'Activo'
          ? 'bg-[#DCFDE7] text-[#16A34A]'
          : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
    },
    
  ];

  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private simulation: SimulationService,
    private formValidationService: FormValidationService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Sincronizar datos del facade (JSON) con rowData local
    effect(() => {
      const datos = this.almacenFacade.clasificacionArticulos();
      if (datos.length > 0) {
        const simulationData = this.simulation.list('categoria');
        // Verificar que los datos en simulación tienen el formato nuevo (snake_case)
        const isNewFormat =
          simulationData.length > 0 &&
          'categoria_articulo_org_hierarchy' in simulationData[0];

        if (isNewFormat) {
          // Usar datos de simulación (contienen mutaciones del usuario)
          this.rowData = [...simulationData];
        } else {
          // Seed inicial desde JSON (descarta cualquier dato legacy)
          this.rowData = [...datos];
          this.simulation.replace('categoria', datos);
        }
        this.inicializarCategorias();
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', this.rowData);
        }
      }
    });
  }

  ngOnInit() {
    // Cargar datos iniciales desde JSON via facade (arquitectura limpia)
    this.almacenFacade.cargarClasificacionArticulos();
    // Inicializar formulario con valores por defecto para evitar errores al usarlo
    this.registroForm = this.formBuilder.group({
      // usuario: [{value: 'Eduardo Jimenez Lopez', disabled: true}],
      fechaR: [{ value: this.getFechaHoy(), disabled: true }],
      descripcion: ['', Validators.required],
      sucursales: ['', Validators.required],
      nivel: ['', Validators.required],
      categoriaP: [''],
      observacion: [''],
      estado: [{ value: 'Activo', disabled: true}],
    });

    this.formValidationService.inicializarFormulario(this.registroForm);

    // Escuchar cambios en el formulario para activar/desactivar el botón "Nueva categoría"
    this.registroForm.valueChanges.subscribe(() => {
      // Si no hay fila seleccionada, marcar si hay cambios
      if (!this.filaSeleccionada) {
        this.formularioConCambios = this.registroForm.dirty;
      } else {
        // Si hay fila seleccionada, siempre permitir nueva
        this.formularioConCambios = true;
      }
    });

    // Contexto de la grilla (si se usa en cellRenderers u otros)
    this.gridContext = { componentParent: this };

    this.simulation.storageChanges().subscribe(changes => {
    this.rowData = changes['categoria'] || [];
    console.log('Mutación reactiva (simulation):', this.rowData);
    }); 

    this.registroForm.get('nivel')?.valueChanges.subscribe(() => {
      this.filtrarCategoriaPorNivel();
    });
    this.filtrarCategoriaPorNivel();

    //   Inicializar catálogos compartidos
    this.catalogosFacade.inicializarCatalogos();

    // Resetear estado después de toda la inicialización para que no detecte cambios falsos
    this.formValidationService.resetearEstado();
  }

  getFechaHoy(): string {
    return new Date().toISOString().substring(0, 10);
  }

  inicializarCategorias() {
    this.categoriaFiltrada = this.rowData.map(item => ({
      id: item.categoria_articulo_descripcion,
      nombre: item.categoria_articulo_descripcion,
      nivel: item.categoria_articulo_org_hierarchy.length,
      orgHierarchy: item.categoria_articulo_org_hierarchy,
      categoriaP: item.categoria_articulo_padre
    }));
  }

  filtrarCategoriaPorNivel() {
    const nivel = this.registroForm.get('nivel')?.value;

    let nivelNum = 1;

    switch (nivel) {
      case 'Categoría': nivelNum = 1; break;
      case 'Subcategoría': nivelNum = 2; break;
      case 'Familia': nivelNum = 3; break;
      case 'Linea': nivelNum = 4; break;
    }

    // Si es categoría, no hay padres
    if (nivelNum === 1) {
      this.categoriaFiltrada = [];
      this.registroForm.get('categoriaP')?.reset();
      this.registroForm.get('categoriaP')?.disable();
      return;
    }

    this.registroForm.get('categoriaP')?.enable();

    const parentLevel = nivelNum - 1;

    // FILTRO CORRECTO → usando el array preparado para el autocomplete
    this.categoriaFiltrada = this.rowData
      .filter(item => item.categoria_articulo_org_hierarchy.length === parentLevel)
      .map(item => ({
        id: item.categoria_articulo_descripcion,
        nombre: item.categoria_articulo_descripcion,
        nivel: item.categoria_articulo_org_hierarchy.length,
        orgHierarchy: item.categoria_articulo_org_hierarchy,
        categoriaP: item.categoria_articulo_padre
      }));
  }

  
  onSucursalSeleccionada(sucursal: any) {
    console.log('Sucursales seleccionadas:', sucursal);
    this.registroForm.patchValue({
      sucursales: sucursal
    })
  }
  onpadreSeleccionado(valor: any) {

    // Buscar el padre REAL dentro del rowData usando la descripción
    const padreReal = this.rowData.find(item => item.categoria_articulo_descripcion === valor.nombre);

    if (!padreReal) {
      console.warn("No se encontró el padre en rowData para:", valor);
    }

    this.registroForm.patchValue({
      categoriaP: padreReal || null
    });
  }


  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // Si los datos ya llegaron antes que el grid, aplicarlos ahora
    if (this.rowData.length > 0) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  
  async onCellClicked(event: any) {

    const nuevaFila = event.data;
    if (!nuevaFila) return;

    // Cancelar selección automática
    event.node.setSelected(true);

    // Si NO hay cambios reales → permitir
    if (!this.formValidationService.tieneModificaciones()) {
      event.node.setSelected(true);
      this.aplicarSeleccion(nuevaFila);
      return;
    }

    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) {

      setTimeout(() => {
        this.gridApi.deselectAll();
        this.gridApi.forEachNode((node) => {
          if (node.data === this.filaSeleccionada) {
            node.setSelected(true);
          }
        });
      });

      return;
    }

    event.node.setSelected(true);
    this.aplicarSeleccion(nuevaFila);
  }


  private aplicarSeleccion(data: any) {

    this.filaSeleccionada = data;
    this.registroEditando = data;
    this.formularioConCambios = true; // Marcar que hay cambios cuando se selecciona una categoría

    this.registroForm.patchValue({
      fechaR: data.categoria_articulo_fecha_creacion,
      descripcion: data.categoria_articulo_descripcion,
      sucursales: data.categoria_articulo_sucursales,
      nivel: data.categoria_articulo_nivel,
      categoriaP: data.categoria_articulo_padre,
      observacion: data.categoria_articulo_observacion,
      estado: data.categoria_articulo_estado,
    });

    this.registroForm.get('estado')?.enable();

    // Nuevo punto base para validación
    this.formValidationService.resetearEstado();
  }

  async botonRegistrarCategoria() {

    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;

    // Entrar a modo crear
    this.filaSeleccionada = null;
    this.registroEditando = null;
    this.formularioConCambios = false; // Resetear estado de cambios

    this.registroForm.reset({
      estado: 'Activo',
      fechaR: this.getFechaHoy()
    });

    this.registroForm.get('fechaR')?.disable();
    this.registroForm.get('estado')?.disable();

    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // CLAVE: este es el nuevo punto base
    this.formValidationService.resetearEstado();
  }



  async botonEliminarCategoria() {
        
    const detallesEjemplo = [
      { label: 'Código', value: 'CAT-001' },
      { label: 'Nombre', value: this.filaSeleccionada!.categoria_articulo_descripcion },
      { label: 'Fecha de registro', value: this.filaSeleccionada!.categoria_articulo_fecha_creacion },
      { label: 'Nivel', value: this.filaSeleccionada!.categoria_articulo_nivel },
      { label: 'Usuario ejecutor', value: 'Ernesto Hermenergildo' },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Eliminar categoría',
        subtitulomodal: 'Detalle de eliminación',
        detalles: detallesEjemplo,
        tituloTextarea: 'Motivo de eliminación',
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Eliminar',
        colorBotonConfirmar: 'danger'
      }
    });

    await modal.present();
    
    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      this.eliminarRegistro()
    }
  }

  /**
   * Normaliza la "categoría asociada" a su objeto real.
   * Acepta el objeto seleccionado (alta) o la descripción en texto (edición),
   * y lo resuelve contra rowData. Devuelve null si no existe.
   */
  private resolverPadre(categoriaP: any): CategoriaArticuloEntity | null {
    if (!categoriaP) {
      return null;
    }
    if (typeof categoriaP === 'object' && categoriaP.categoria_articulo_descripcion) {
      return categoriaP as CategoriaArticuloEntity;
    }
    const desc = typeof categoriaP === 'object'
      ? categoriaP.categoria_articulo_descripcion
      : categoriaP;
    return this.rowData.find(x => x.categoria_articulo_descripcion === desc) ?? null;
  }

  generarRegistroDesdeForm(data: any): CategoriaArticuloEntity {

    const padre = this.resolverPadre(data.categoriaP);   // objeto padre o null
    const padreDesc = padre?.categoria_articulo_descripcion ?? null;
    const padreHier = padre?.categoria_articulo_org_hierarchy ?? [];
    let orgHierarchy: string[] = [];
    let categoriaPadre: string | null = null;
    let extras: Partial<CategoriaArticuloEntity> = {};

    switch (data.nivel) {

      // 1. CATEGORÍA
      case 'Categoría':
        orgHierarchy = [data.descripcion];
        categoriaPadre = null;
        extras.categoria_articulo_is_categoria = true;
        break;

      // 2. SUBCATEGORÍA
      case 'Subcategoría':
        orgHierarchy = [padreDesc, data.descripcion].filter(Boolean) as string[];
        categoriaPadre = padreDesc;
        break;

      // 3. FAMILIA
      case 'Familia':
        orgHierarchy = [padreHier[0], padreHier[1], data.descripcion].filter(Boolean) as string[];
        categoriaPadre = padreDesc;
        break;

      // 4. LÍNEA
      case 'Linea':
        orgHierarchy = [padreHier[0], padreHier[1], padreHier[2], data.descripcion].filter(Boolean) as string[];
        categoriaPadre = padreDesc;
        break;
    }

    return {
      categoria_articulo_org_hierarchy: orgHierarchy,
      categoria_articulo_fecha_creacion: data.fechaR,
      categoria_articulo_descripcion: data.descripcion,
      categoria_articulo_sucursales: data.sucursales,
      categoria_articulo_nivel: data.nivel,
      categoria_articulo_padre: categoriaPadre,
      categoria_articulo_observacion: data.observacion || 'Registro generado automáticamente',
      categoria_articulo_estado: data.estado,
      ...extras
    };
  }


  botonGuardar() {

    if (this.registroForm.invalid) {
      this.toastService.warning("¡Por favor, complete todos los campos requeridos!");
      return;
    }

    const formData = this.registroForm.getRawValue();

    // Los niveles distintos de "Categoría" requieren una categoría asociada
    // válida (seleccionada de la lista), si no, no se puede armar la jerarquía.
    if (formData.nivel && formData.nivel !== 'Categoría') {
      const padre = this.resolverPadre(formData.categoriaP);
      if (!padre) {
        this.toastService.warning('Seleccione una "Categoría asociada" válida de la lista para este nivel.');
        return;
      }
      formData.categoriaP = padre;
    }

    const nuevoRegistro = this.generarRegistroDesdeForm(formData);

    console.log("Guardando Categoría con:", nuevoRegistro);

    // SI NO ESTOY EDITANDO → CREAR
  if (!this.registroEditando) {
    this.simulation.save('categoria', nuevoRegistro);
    this.toastService.success(`¡${this.registroForm.get('nivel')?.value } registrada exitosamente!`);
  }

  // SI ESTOY EDITANDO → ACTUALIZAR
  else {

    // Traer lista actual
    const lista = this.simulation.list('categoria');

    // Buscar índice del registro original
    const index = lista.findIndex((x: any) =>
      x.categoria_articulo_descripcion === this.registroEditando?.categoria_articulo_descripcion &&
      x.categoria_articulo_nivel === this.registroEditando?.categoria_articulo_nivel &&
      JSON.stringify(x.categoria_articulo_org_hierarchy) === JSON.stringify(this.registroEditando?.categoria_articulo_org_hierarchy)
    );

    if (index >= 0) {
      lista[index] = nuevoRegistro;
      this.simulation.replace('categoria', lista);
      this.toastService.success(`¡${this.registroForm.get('nivel')?.value } actualizada exitosamente!`);
    } else {
      console.warn("No se encontró el registro a editar.");
    }
  }

  // Actualizar grilla
  this.rowData = [...this.simulation.list('categoria')];
  this.gridApi.setGridOption('rowData', this.rowData);

    // Reset
    this.registroEditando = null;
    this.registroForm.reset({
      estado: 'Activo',
      fechaR: this.getFechaHoy()
    });
    
    this.formValidationService.resetearEstado();

    // Refrescar la vista manualmente
    this.refrescarVista();
  }

  refrescarVista() {
    this.rowData = [...this.simulation.list('categoria')];
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
      {  headerName: 'Fecha y hora',  field: 'fechaHora', width: 150 },
      {  headerName: 'Usuario',  field: 'usuario', width: 120 },
      {  headerName: 'Acción',  field: 'accion', width: 150 },
      {  headerClass:'centrarencabezado', headerName: 'Detalle del cambio',
         cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center'},
         field: 'detalleCambio', flex: 1 },
      ];

    // Datos de ejemplo
    const rowData = [
      { fechaHora: this.filaSeleccionada!.categoria_articulo_fecha_creacion , usuario: 'Ernesto Hermenergildo', accion: 'Creación', detalleCambio: 'Se ha creado la categoría '},
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones de la Categoría ${this.filaSeleccionada!.categoria_articulo_descripcion}`,
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
    // Recargar desde JSON vía facade → activa appLoader automáticamente
    this.almacenFacade.cargarClasificacionArticulos();
  }
  async modalImportar(){
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar categorías',
        descripcionSubir: 'Comparte tu archivo de excel con la información de tus categorías y regístralas automáticamente en la plataforma.',
        buttonName: 'Importar categorías',
      }
    });
    await modal.present();

    try {
      const result = await modal.onWillDismiss();
      const data = result?.data;
      if (data && data.archivo) {
        // Guardar archivo en el componente padre
        this.archivo = data.archivo;
        // Mostrar toast indicando que el archivo fue subido
        try {
          const nombre = data.archivo?.name ?? 'archivo';
          this.toastService.success('¡Archivo subido!', nombre, 3000);
        } catch (e) {
          console.warn('ToastService falló', e);
        }
        // Llamar al método importar para procesar el archivo
        try { this.importar(data); } catch (e) { 
          this.toastService.danger('¡Importacion fallida!');
          }
      }
    } catch (e) {
      console.warn('Error al obtener resultado del modal', e);
      this.toastService.danger('¡Error al obtener resultado del modal!');
    }
  }
  importar(data:any){
    // Placeholder: aquí se procesaría el archivo (validaciones, parseo, subida, etc.)
    console.log('Importar llamado con:', data);
    // Por ahora solo guardamos el archivo en el estado (ya lo hacemos en modalImportar),
    // y se puede mostrar un toast adicional si se desea.
  }

  eliminarRegistro() {
    const registro = this.filaSeleccionada;

    // Obtener lista actual
    const lista = this.simulation.list('categoria');

    // Buscar índice exacto (categoria_articulo_org_hierarchy garantiza unicidad)
    const index = lista.findIndex((item: any) =>
      JSON.stringify(item.categoria_articulo_org_hierarchy) === JSON.stringify(registro!.categoria_articulo_org_hierarchy)
    );

    // Eliminar
    lista.splice(index, 1);

    // Guardar nueva lista
    this.simulation.replace('categoria', lista);

    // Actualizar grilla
    this.rowData = [...lista];
    this.gridApi.setGridOption('rowData', this.rowData);

    // Limpiar selección
    this.filaSeleccionada = null;
    this.registroEditando = null;
    this.registroForm.reset({
      estado: 'Activo',
      fechaR: this.getFechaHoy()
    });

    setTimeout(() => {
      this.toastService.success("¡Registro eliminado correctamente!");
    }, 400);
  }

}
