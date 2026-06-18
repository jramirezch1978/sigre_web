import { Component, ElementRef, OnInit, OnDestroy, ViewChild, inject } from '@angular/core';
import { ColDef, ColGroupDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';
import { BotonAccionesComponent } from 'src/app/ui/boton-acciones/boton-acciones.component';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { GeneracionArchivosEntity } from 'src/app/modules/rrhh/domain/models/generacion-archivos.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-r-a-generacion-archivos',
  templateUrl: './r-a-generacion-archivos.component.html',
  styleUrls: ['./r-a-generacion-archivos.component.scss'],
  standalone: false,

})
export class RAGeneracionArchivosComponent implements OnInit, OnDestroy {
  private readonly rrHhFacade = inject(RrHhFacade);
  readonly isLoading = this.rrHhFacade.loadingGeneracionArchivos;

  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  pais= this.countryService.getCountryCode();
  countries= ALL_COUNTRIES;
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

   periodoMes: number | null = null;
  periodoAnio: number | null = null;

  GeracionArchivosForm!:FormGroup;
  fechaEmision: Date | undefined;
  filaSeleccionada: any = null;
  panelLateralVisible = true;
  cargando = false;
  botonNuevoArchivoDeshabilitado: boolean = true;

  trabajador = '-';
  periodo = '-';
  fechaemision = '--/--/----, --:--';
  estado = '-';
  detalle_error = '-';
  archivogenerado = '-';

  private gridApi!: GridApi;
  isResetting = false;

  sucursales = [
    { id: '0', nombre: 'Todas las sucursales' },
    { id: '1', nombre: 'La Molina, Lima' },
    { id: '2', nombre: 'San Isidro, Lima' },
    { id: '3', nombre: 'San Borja, Lima' },
    { id: '4', nombre: 'Santa Isabel, Piura' },
  ];


  archivos: any = []

  contratos = [
    'TXL',
    'XML',
    'XLSX',
    'PDF',

  ]

  columnTypes = {
    rightAligned: {
      headerClass: 'ag-right-aligned-header',
      cellClass: 'ag-right-aligned-cell'
    }
  };

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
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };


rowData: GeneracionArchivosEntity[] = [];

colDefs: ColDef[] = [
    { field: 'archivo_reg_codigo', headerName: 'Código', width: 130 },
    { field: 'archivo_reg_periodo', headerName: 'Periodo', width: 90, filter: true },
    { field: 'archivo_reg_sucursal', headerName: 'Sucursal', flex:1, minWidth: 180, filter: true,
      valueFormatter: (params: any) => {
        const sucursal = this.sucursales.find(s => s.id == params.value);
        return sucursal ? sucursal.nombre : params.value || '';
      },
      filterValueGetter: (params: any) => {
        const sucursal = this.sucursales.find(s => s.id == params.data?.archivo_reg_sucursal);
        return sucursal ? sucursal.nombre : params.data?.archivo_reg_sucursal || '';
      }
     },
    { field: 'archivo_reg_nombre', headerName: 'Archivo regulatorio', width: 150, filter: true },
    { field: 'archivo_reg_tipo_formato', headerName: 'Tipo formato', width: 110, filter: true },
    { field: 'archivo_reg_fecha_emision', headerName: 'Fecha de emisión', width: 110,
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${day}/${month}/${year}`;
      }
    },
    {
      field: 'archivo_reg_estado', headerName: 'Estado', width: 100, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Generado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Generado</span>'
        } else if (params.value === 'Error') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Error</span>'
        }
        return params.value;
      }
    }
  ];
  constructor(
     private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService,
    private countryService: CountryService,
  ) { 
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  ngOnInit() {
    this.obtenerdatospais();
    this.fechaEmision = new Date();

    this.GeracionArchivosForm = this.formBuilder.group({
      fechaEmision: [{ value: this.fechaEmision.toLocaleDateString('es-PE'), disabled: true }],
      periodoContable: [null, Validators.required],
      sucursalSelect: [null, Validators.required],
      archivoSelect: [null, Validators.required],
      tipoFormatoSelect: [null, Validators.required],
    });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.GeracionArchivosForm);
    
    // Escuchar cambios en el formulario para actualizar el estado del botón
    this.GeracionArchivosForm.valueChanges.subscribe(() => {
      this.actualizarEstadoBoton();
    });

    // Cargar datos desde el repositorio
    this.rrHhFacade.cargarGeneracionArchivos();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.generacionArchivos();
        if (this.filaSeleccionada) {
          const prevData = this.filaSeleccionada;
          setTimeout(() => {
            this.gridApi?.forEachNode((node) => {
              if (node.data === prevData) {
                node.setSelected(true);
              }
            });
          }, 0);
        }
        clearInterval(timer);
      }
    }, 100);
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }
  obtenerdatospais(){
    this.countries.find(c => {
      if(c.codigo === this.pais){
        // Lógica para utilizar los datos del país
        this.archivos = c.archivoregulatorio;
      }
    }
    );
  }
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    if (this.filaSeleccionada) {
      const prevData = this.filaSeleccionada;
      setTimeout(() => {
        this.gridApi?.forEachNode((node) => {
          if (node.data === prevData) {
            node.setSelected(true);
          }
        });
      }, 0);
    }
  }
  
  async onCellClicked(event: any) {
    const data = event?.data;
    if (!data) { return; }

    const clickedNode = event.node;
    this.filaSeleccionada = data;

    // Completar los campos del formulario
    const fechaEmision = new Date(data.archivo_reg_fecha_emision);
    const periodoStr = data.archivo_reg_periodo; // "202510"
    const mes = parseInt(periodoStr.substring(4, 6));
    const anio = parseInt(periodoStr.substring(0, 4));

    this.periodoMes = mes;
    this.periodoAnio = anio;

    this.formValidationService.pausarDeteccion();
    this.GeracionArchivosForm.patchValue({
      fechaEmision: fechaEmision.toLocaleDateString('es-PE'),
      periodoContable: periodoStr,
      sucursalSelect: data.archivo_reg_sucursal,
      archivoSelect: data.archivo_reg_nombre,
      tipoFormatoSelect: data.archivo_reg_tipo_formato
    });

    // Deshabilitar todos los campos del formulario
    this.GeracionArchivosForm.get('fechaEmision')?.disable();
    this.GeracionArchivosForm.get('periodoContable')?.disable();
    this.GeracionArchivosForm.get('sucursalSelect')?.disable();
    this.GeracionArchivosForm.get('archivoSelect')?.disable();
    this.GeracionArchivosForm.get('tipoFormatoSelect')?.disable();

    // Actualizar estado del botón
    this.actualizarEstadoBoton();

    // Completar los campos de detalle
    this.trabajador = data.archivo_reg_sucursal || '-';
    this.periodo = `${periodoStr.substring(4, 6)}/${periodoStr.substring(0, 4)}`;

    const fechaEmisionFormatted = `${fechaEmision.getDate().toString().padStart(2, '0')}/${(fechaEmision.getMonth() + 1).toString().padStart(2, '0')}/${fechaEmision.getFullYear()}, ${fechaEmision.getHours().toString().padStart(2, '0')}:${fechaEmision.getMinutes().toString().padStart(2, '0')}`;
    this.fechaemision = fechaEmisionFormatted;

    this.estado = data.archivo_reg_estado;
    this.detalle_error = data.archivo_reg_detalle_error || '-';
    this.archivogenerado = `REG${periodoStr}0000123.${data.archivo_reg_tipo_formato.toLowerCase()}`;

    console.log('Fila seleccionada:', this.filaSeleccionada);

    setTimeout(() => {
      this.gridApi?.deselectAll();
      clickedNode?.setSelected(true);
      this.formValidationService.reanudarDeteccion();
    }, 0);
  }

  onBtReset(): void {
    this.isResetting = true;
    this.rrHhFacade.cargarGeneracionArchivos();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.generacionArchivos();
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', [...this.rowData]);
        }
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

   togglePanelLateral(): void {
    this.panelLateralVisible = !this.panelLateralVisible;

  }

  async nuevoArchivo() {
    // Si hay una fila seleccionada, es modo visualización sin cambios editables
    // Si hay cambios en el formulario, mostrar modal de confirmación
    if (!this.filaSeleccionada && this.tieneCamposRellenos()) {
      // Solo mostrar modal si hay cambios reales en el formulario (no en modo visualización)
      const confirmar = await this.formValidationService.validarCambios();
      if (!confirmar) {
        return; // Cancelar acción
      }
    }

    // Limpiar la fila seleccionada
    this.filaSeleccionada = null;
    
    // Deseleccionar cualquier fila en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Limpiar los valores del formulario
    this.periodoMes = null;
    this.periodoAnio = null;
    this.fechaEmision = new Date();
    
    this.GeracionArchivosForm.reset({
      fechaEmision: this.fechaEmision.toLocaleDateString('es-PE'),
      periodoContable: null,
      sucursalSelect: null,
      archivoSelect: null,
      tipoFormatoSelect: null,
    });
    
    // Habilitar todos los campos del formulario excepto fechaEmision
    this.GeracionArchivosForm.get('periodoContable')?.enable();
    this.GeracionArchivosForm.get('sucursalSelect')?.enable();
    this.GeracionArchivosForm.get('archivoSelect')?.enable();
    this.GeracionArchivosForm.get('tipoFormatoSelect')?.enable();
    
    // Actualizar estado del botón
    this.actualizarEstadoBoton();
    
    // Limpiar los campos de detalle
    this.trabajador = '-';
    this.periodo = '-';
    this.fechaemision = '--/--/----, --:--';
    this.estado = '-';
    this.detalle_error = '-';

    this.archivogenerado = '-';

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }

  /**
   * Actualiza el estado del botón "Nuevo archivo regulatorio"
   * Se habilita si: hay una fila seleccionada O si hay al menos un campo del formulario relleno
   */
  private actualizarEstadoBoton(): void {
    const tieneFilaSeleccionada = !!this.filaSeleccionada;
    const tieneFormulaRelleno = this.tieneCamposRellenos();
    
    this.botonNuevoArchivoDeshabilitado = !(tieneFilaSeleccionada || tieneFormulaRelleno);
  }

  /**
   * Verifica si al menos un campo del formulario tiene un valor (excluyendo fechaEmision que es de solo lectura)
   */
  private tieneCamposRellenos(): boolean {
    if (!this.GeracionArchivosForm) return false;
    
    const controls = this.GeracionArchivosForm.getRawValue();
    // Excluir fechaEmision porque es siempre de solo lectura
    return Object.entries(controls)
      .filter(([key]) => key !== 'fechaEmision')
      .some(([, valor]) => valor && valor !== '');
  }

  async botonCancelar() {
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Cancelar acción
    }

    // Limpiar la fila seleccionada
    this.filaSeleccionada = null;
    
    // Deseleccionar cualquier fila en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Limpiar los valores del formulario
    this.periodoMes = null;
    this.periodoAnio = null;
    this.fechaEmision = new Date();
    
    this.GeracionArchivosForm.reset({
      fechaEmision: this.fechaEmision.toLocaleDateString('es-PE'),
      periodoContable: null,
      sucursalSelect: null,
      archivoSelect: null,
      tipoFormatoSelect: null,
    });
    
    // Habilitar todos los campos del formulario excepto fechaEmision
    this.GeracionArchivosForm.get('periodoContable')?.enable();
    this.GeracionArchivosForm.get('sucursalSelect')?.enable();
    this.GeracionArchivosForm.get('archivoSelect')?.enable();
    this.GeracionArchivosForm.get('tipoFormatoSelect')?.enable();
    
    // Limpiar los campos de detalle
    this.trabajador = '-';
    this.periodo = '-';
    this.fechaemision = '--/--/----, --:--';
    this.estado = '-';
    this.detalle_error = '-';
    this.archivogenerado = '-';

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }
  generarArchivo(): void {
    // Validar que todos los campos obligatorios estén rellenos
    if (this.GeracionArchivosForm.invalid) {
      const camposConError: string[] = [];
      const nombresAmigables: { [key: string]: string } = {
        periodoContable: 'Periodo',
        sucursalSelect: 'Sucursal',
        archivoSelect: 'Archivo regulatorio',
        tipoFormatoSelect: 'Tipo de formato',
      };
      
      Object.keys(this.GeracionArchivosForm.controls).forEach(key => {
        const control = this.GeracionArchivosForm.get(key);
        if (control && control.invalid) {
          camposConError.push(nombresAmigables[key] || key);
        }
      });
      
      this.toastService.warning(`Por favor, completa todos los campos requeridos`);
      return;
    }

    // Generar código único para el nuevo archivo
    const numeroArchivo = this.rowData.length + 1;
    const codigoNuevo = `AR-2025-${numeroArchivo.toString().padStart(3, '0')}`;

    // Obtener valores del formulario
    const periodoStr = `${this.periodoAnio}${this.periodoMes?.toString().padStart(2, '0')}`;
    const fechaEmisionDate = this.fechaEmision || new Date();

    // Crear nuevo registro
    const nuevoRegistro = {
      archivo_reg_codigo: codigoNuevo,
      archivo_reg_periodo: periodoStr,
      archivo_reg_sucursal: this.GeracionArchivosForm.get('sucursalSelect')?.value,
      archivo_reg_nombre: this.GeracionArchivosForm.get('archivoSelect')?.value,
      archivo_reg_tipo_formato: this.GeracionArchivosForm.get('tipoFormatoSelect')?.value,
      archivo_reg_fecha_emision: fechaEmisionDate.toISOString(),
      archivo_reg_estado: 'Generado'
    };

    // Agregar al inicio del array
    this.rowData = [nuevoRegistro, ...this.rowData];

    // Actualizar la tabla
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }

    // Mostrar toast de éxito
    this.toastService.success('¡Archivo generado exitosamente!');

    // Resetear el estado de validación antes de limpiar para que no salte el modal de cambios sin guardar
    this.formValidationService.resetearEstado();

    // Limpiar el formulario
    this.nuevoArchivo();
  }

    onSelectionChanged(event: any): void {
    // Este método se mantiene por compatibilidad pero la lógica principal está en onCellClicked
  }

  onPeriodoContableChange(event: {month: number, year: number}) {
    console.log('Periodo contable:', event);
    this.periodoMes = event.month;
    this.periodoAnio = event.year;
    // Actualizar el valor del formulario
    this.GeracionArchivosForm.patchValue({
      periodoContable: `${event.month}/${event.year}`
    });
  }

    onPeriodoSeleccionado(event: any) {
    console.log('Periodo seleccionado:', event);
  }

  filtrarPorFechas(range: { start: Date; end: Date }): void {
    this.startDate = range.start;
    this.endDate = range.end;
  }
}
