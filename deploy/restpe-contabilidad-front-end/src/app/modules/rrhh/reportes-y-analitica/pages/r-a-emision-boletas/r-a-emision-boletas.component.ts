import { Component, ElementRef, OnInit, OnDestroy, ViewChild, inject } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalVerActualizacionesComponent } from '../../../../../ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';
import { BotonAccionesComponent } from 'src/app/ui/boton-acciones/boton-acciones.component';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ModalDetalleComponent } from '../../../../../ui/modal-detalle/modal-detalle.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { EmisionBoletasEntity } from 'src/app/modules/rrhh/domain/models/emision-boletas.entity';
import { SucursalEntity } from 'src/app/modules/rrhh/domain/models/sucursal.entity';
import { CentroEntity } from 'src/app/modules/rrhh/domain/models/centro.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-r-a-emision-boletas',
  templateUrl: './r-a-emision-boletas.component.html',
  styleUrls: ['./r-a-emision-boletas.component.scss'],
  standalone: false,
})
export class RAEmisionBoletasComponent implements OnInit, OnDestroy {
  private readonly rrHhFacade = inject(RrHhFacade);
  readonly isLoading = this.rrHhFacade.loadingEmisionBoletas;

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
  minDate: Date;
  maxDate: Date;

  EmisionForm!: FormGroup;
  fechaEmision: Date | undefined;

  periodoMes: number | null = null;
  periodoAnio: number | null = null;

  private gridApi!: GridApi;
  panelLateralVisible = true;
  isResetting = false;
  mostrarBuscadorPrincipal = true;
  filaSeleccionada: any = null;
  cargando = false;
  camponuevo: boolean = false;

  private gridApiDetalle!: GridApi;
  mostrarInformacion = false;



  // Variables de detalle de boleta emitida
  trabajador = '-';
  periodo = '-';
  fechaemision = '--/--/----, --:--';
  estado = '-';
  archivogenerado = '-';
  mesSeleccionado: number | null = null;
  anioSeleccionado: number | null = null;
  fechaEmisionActual: Date = new Date();
  periodoPagoMes: number | null = null;
  periodoPagoAnio: number | null = null;
  sucursalSeleccionada: string = '';
  centroCostoSeleccionado: string = '';
  tipoPlanillaSeleccionada: string = '';
  trabajadorSeleccionado: string = '';
  tipoArchivoSeleccionado: string = '';


  planillas = [
    'Sueldo',
    'Gratificación',
    'Bonificación',
    'CTS',
  ]

  archivos = [
    'TXT',
    'XML',
    'XLSX',
    'PDF',
  ]

  sucursales: SucursalEntity[] = [
    { id: 1, nombre: 'Miraflores' },
    { id: 2, nombre: 'Santa Anita' },
    { id: 3, nombre: 'Piura' },
    { id: 4, nombre: 'Sullana' },
    { id: 5, nombre: 'Talara' },
  ];

  centros: CentroEntity[] = [
    { id: 1, nombre: 'Operaciones' },
    { id: 2, nombre: 'Cocina' },
    { id: 3, nombre: 'Bar' },
    { id: 4, nombre: 'Operaciones' },
    { id: 5, nombre: 'Marketing y ventas' },
    { id: 6, nombre: 'RRHH' }
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
    loadingOoo: 'Cargando...',
  };

  rowData: EmisionBoletasEntity[] = [];

  colDefs: ColDef[] = [
    { field: 'planilla_codigo', headerName: 'Codigo', flex: 1, minWidth: 150 },
    { field: 'planilla_periodo', headerName: 'Periodo', width: 100, filter: true,
      valueFormatter: (params: any) => {
        if (!params.value) {
          return '-';
        }
        return params.value.toString().trim();
      }
    },
    { field: 'planilla_desde', headerName: 'Desde', flex: 1, minWidth: 150 },
    { field: 'planilla_hasta', headerName: 'Hasta', flex: 1, minWidth: 150 },
    // { field: 'planilla_trabajador', headerName: 'Trabajador', flex: 1, minWidth: 150 },
    { field: 'planilla_sucursal', headerName: 'Sucursal', width: 130, filter: true },
    { field: 'planilla_centro_costos', headerName: 'Centro de costos', width: 140, filter: true },
    { field: 'planilla_num_trabajador', headerName: 'N° de trabajadores', width: 110 },
    { field: 'planilla_tipo_planilla', headerName: 'Tipo planilla', width: 120, filter: true },
    {
      field: 'planilla_fecha_emision', headerName: 'Fecha emisión', width: 100,
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        // Si ya está en formato dd/MM/yyyy, devolverlo como está
        if (params.value.includes('/')) {
          return params.value;
        }
        // Si está en formato yyyy-MM-dd, convertir a dd/MM/yyyy
        if (params.value.includes('-')) {
          const [year, month, day] = params.value.split('-');
          return `${day}/${month}/${year}`;
        }
        return params.value;
      }
    },
    {
      field: 'planilla_estado',
      headerName: 'Estado',
      width: 100,
      filter: true,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        const color = params.value === 'Emitido' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FEE2E2] text-[#DC2626]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      }
    }
  ];

  // Datos columna del formulario
  rowDataDetalle = [
    { periodo: 202510, documento: '02938945', nombres: 'Alexander Palomeque Aguirre', devengado:1243, pagado: 1243, descuentos: '', tribuaportes: 124.30, netopagar: 1101.67, tributosempleador: 124.30, fechaemision: '2025-11-06', estado: 'Emitido'},
    { periodo: 202510, documento: '02938945', nombres: 'Alvaro Ontaneda Herradura', devengado: 3113, pagado: 3113, descuentos: '', tribuaportes: 124.30, netopagar: 1101.67, tributosempleador: 124.30, fechaemision: '2025-11-06', estado: 'Error' },  
    { periodo: 202510, documento: '02938945', nombres: 'Alexander Palomeque Aguirre', devengado:1243, pagado: 1243, descuentos: '', tribuaportes: 124.30, netopagar: 1101.67, tributosempleador: 124.30, fechaemision: '2025-11-06', estado: 'Emitido'}
  ];

  // Columnas del formulario
  colDefsDetalle: ColDef[] = [
    { 
      checkboxSelection: true, 
      headerCheckboxSelection: true,
      width: 50,
      maxWidth: 50,
      pinned: 'left'
    },
    { field: 'periodo', headerName: 'Periodo', width: 80 },
    { field: 'documento', headerName: 'Documento identidad', width: 80 },
    { field: 'nombres', headerName: 'Nombre y apellidos', flex: 1, minWidth: 150 },
    {
      field: 'devengado', headerName: 'Devengado', headerClass: 'derechaencabezado', width: 100,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
      valueFormatter: (params: any) => {
        if (params.value == null || params.value === '') return 'S/ 0.00';
        const valor = Number(params.value);
        return 'S/ ' + valor.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
      }
    },
    {
      field: 'pagado', headerName: 'Pagado', headerClass: 'derechaencabezado', width: 100,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
        valueFormatter: (params: any) => {
        if (params.value == null || params.value === '') return 'S/ 0.00';
        const valor = Number(params.value);
        return 'S/ ' + valor.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
      }
    },
    {
      field: 'descuentos', headerName: 'Descuentos', headerClass: 'derechaencabezado', width: 120,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
        valueFormatter: (params: any) => {
        if (params.value == null || params.value === '') return 'S/ 0.00';
        const valor = Number(params.value);
        return 'S/ ' + valor.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
      }
    },
    {
      field: 'tribuaportes', headerName: 'Tributos y aportes trabajador', headerClass: 'derechaencabezado', width: 120,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
        valueFormatter: (params: any) => {
        if (params.value == null || params.value === '') return 'S/ 0.00';
        const valor = Number(params.value);
        return 'S/ ' + valor.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
      }
    },
    {
      field: 'netopagar', headerName: 'Neto a pagar', headerClass: 'derechaencabezado', width: 120,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
       valueFormatter: (params: any) => {
        if (params.value == null || params.value === '') return 'S/ 0.00';
        const valor = Number(params.value);
        return 'S/ ' + valor.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
      }
    },
    {
      field: 'tributosempleador', headerName: 'Tributos y aportes empleador', headerClass: 'derechaencabezado', width: 120,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
        valueFormatter: (params: any) => {
        if (params.value == null || params.value === '') return 'S/ 0.00';
        const valor = Number(params.value);
        return 'S/ ' + valor.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
      }
    },
    { field: 'fechaemision', headerName: 'Fecha emisión', width: 120,
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        // Si ya está en formato dd/MM/yyyy, devolverlo como está
        if (params.value.includes('/')) {
          return params.value;
        }
        // Si está en formato yyyy-MM-dd, convertir a dd/MM/yyyy
        if (params.value.includes('-')) {
          const [year, month, day] = params.value.split('-');
          return `${day}/${month}/${year}`;
        }
        return params.value;
      }
    },
    {
      field: 'estado', headerName: 'Estado', width: 100, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', }, filter: true,
      cellRenderer: (params: any) => {
        if (params.value === 'Emitido') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Emitido</span>';
        } else if (params.value === 'Error') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Error</span>';
        }
        return params.value;
      },
    }
  ];

  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService,
    
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  ngOnInit() {
    this.fechaEmision = new Date();
    this.EmisionForm = this.formBuilder.group({
      fechaEmision: [{value:'', disabled: true }],
      periodo: [{value:'', disabled: true}],
      sucursalAutocomplete: [{value:'', disabled: true}],
      sucursalInput: [{value:'', disabled: true}],
      centroCosto: [{value:'', disabled: true}],
      centroCostoInput: [{value:'', disabled: true}],
      planillaSelect: [{value:'', disabled: true}],
      tipoPlanilla: [{value:'', disabled: true}],
      tipoArchivo: [''],
    });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.EmisionForm);

    // Cargar datos desde el repositorio
    this.rrHhFacade.cargarEmisionBoletas();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.emisionBoletas();
        clearInterval(timer);
        // Seleccionar la primera fila una vez que Angular actualice la tabla
        setTimeout(() => {
          if (this.gridApi && this.rowData.length > 0) {
            const firstNode = this.gridApi.getDisplayedRowAtIndex(0);
            if (firstNode) {
              firstNode.setSelected(true);
              this.onCellClicked({ data: firstNode.data });
            }
          }
        }, 0);
      }
    }, 100);
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onBtReset(): void {
    this.isResetting = true;
    this.rrHhFacade.cargarEmisionBoletas();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.emisionBoletas();
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', [...this.rowData]);
        }
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

  async onCellClicked(event: any) {
    if (event.data) {
      this.filaSeleccionada = event.data;
      this.camponuevo = false;

      const data = event.data;
      console.log('Boleta seleccionada:', data);

      // Llenar los campos del formulario con los datos de la fila seleccionada
      this.trabajador = data.planilla_trabajador;
      this.periodo = data.planilla_periodo;
      // Formatear fecha de emisión a dd/mm/yyyy si es posible
      if (data.planilla_fecha_emision) {
        let fecha = data.planilla_fecha_emision;
        if (/^\d{4}-\d{2}-\d{2}$/.test(fecha)) {
          // yyyy-mm-dd => dd/mm/yyyy
          const [y, m, d] = fecha.split('-');
          fecha = `${d}/${m}/${y}`;
        } else {
          const d = new Date(fecha);
          if (!isNaN(d.getTime())) {
            const day = String(d.getDate()).padStart(2, '0');
            const m = String(d.getMonth() + 1).padStart(2, '0');
            const y = d.getFullYear();
            fecha = `${day}/${m}/${y}`;
          }
        }
        this.fechaemision = fecha;
      } else {
        this.fechaemision = data.planilla_fecha_emision;
      }
      this.estado = data.planilla_estado;
      this.archivogenerado = 'Boleta_' + data.planilla_num_boleta + '.pdf';

      // Parsear el periodo (formato YYYYMM)
      const periodoStr = data.planilla_periodo.toString();
      if (periodoStr.length === 6) {
        this.periodoPagoAnio = parseInt(periodoStr.substring(0, 4));
        this.periodoPagoMes = parseInt(periodoStr.substring(4, 6));
      }

      // Buscar y asignar la sucursal
      const sucursal = this.sucursales.find(s => s.nombre === data.planilla_sucursal);
      if (sucursal) {
        this.sucursalSeleccionada = sucursal.id.toString();
      } else {
        this.sucursalSeleccionada = data.planilla_sucursal;
      }

      // Buscar y asignar el centro de costo
      const centroCosto = this.centros.find(c => c.nombre === data.planilla_centro_costos);
      if (centroCosto) {
        this.centroCostoSeleccionado = centroCosto.id.toString();
      } else {
        this.centroCostoSeleccionado = data.planilla_centro_costos;
      }

      // Actualizar el formulario con los datos, formateando la fecha a dd/mm/yyyy
      let fechaFormateada = data.planilla_fecha_emision;
      if (fechaFormateada) {
        if (/^\d{4}-\d{2}-\d{2}$/.test(fechaFormateada)) {
          const [y, m, d] = fechaFormateada.split('-');
          fechaFormateada = `${d}/${m}/${y}`;
        } else {
          const d = new Date(fechaFormateada);
          if (!isNaN(d.getTime())) {
            const day = String(d.getDate()).padStart(2, '0');
            const m = String(d.getMonth() + 1).padStart(2, '0');
            const y = d.getFullYear();
            fechaFormateada = `${day}/${m}/${y}`;
          }
        }
      }
      this.EmisionForm.patchValue({
        fechaEmision: fechaFormateada,
        periodo: data.planilla_periodo,
        sucursalInput: data.planilla_sucursal,
        centroCostoInput: data.planilla_centro_costos,
        tipoPlanilla: data.planilla_tipo_planilla,
        tipoArchivo: ''
      });
    }
  }

  botonGuardar() {
    const formValues = this.EmisionForm.getRawValue(); // getRawValue para obtener valores disabled

    // Crear objeto con los datos del formulario
    const boletaData = {
      planilla_codigo: this.filaSeleccionada?.planilla_codigo || this.generarNumBoleta(),
      planilla_periodo: formValues.periodo || `${this.periodoAnio}${String(this.periodoMes).padStart(2, '0')}`,
      planilla_desde: this.filaSeleccionada?.planilla_desde || '',
      planilla_hasta: this.filaSeleccionada?.planilla_hasta || '',
      planilla_trabajador: this.trabajador !== '-' ? this.trabajador : (this.filaSeleccionada?.planilla_trabajador || ''),
      planilla_sucursal: formValues.sucursalInput || this.filaSeleccionada?.planilla_sucursal || '',
      planilla_centro_costos: formValues.centroCostoInput || this.filaSeleccionada?.planilla_centro_costos || '',
      planilla_num_trabajador: this.filaSeleccionada?.planilla_num_trabajador ?? 0,
      planilla_num_boleta: this.filaSeleccionada?.planilla_num_boleta || this.generarNumBoleta(),
      planilla_tipo_planilla: formValues.tipoPlanilla || formValues.planillaSelect || '',
      planilla_fecha_emision: new Date().toLocaleDateString('es-PE'),
      planilla_estado: 'Emitido'
    };

    let res: any;

    // Mostrar toast de confirmación
    this.toastService.success("¡Boleta emitida exitosamente!");

    // Establecer la boleta emitida como seleccionada para mostrar la lista
    this.filaSeleccionada = boletaData;

    // Si es una nueva boleta (camponuevo = true)
    if (this.camponuevo) {
      // Agregar al inicio del array rowData
      this.rowData.unshift(boletaData);

      // Agregar a la tabla en la parte superior (index: 0)
      res = this.gridApi.applyTransaction({
        add: [boletaData],
        addIndex: 0
      });
      console.log('Nueva boleta agregada');
    }
    // Si es edición (camponuevo = false y hay una fila seleccionada)
    else if (this.filaSeleccionada) {
      // Verificar si la boleta ya existe en la tabla principal
      const boletaExistente = this.rowData.find(b => b.planilla_num_boleta === boletaData.planilla_num_boleta);
      
      if (boletaExistente) {
        // Actualizar los valores de la fila existente
        Object.assign(boletaExistente, boletaData);

        res = this.gridApi.applyTransaction({
          update: [boletaExistente]
        });
        console.log('Boleta actualizada');
      } else {
        // Si no existe, agregarla como nueva
        this.rowData.unshift(boletaData);
        res = this.gridApi.applyTransaction({
          add: [boletaData],
          addIndex: 0
        });
        console.log('Boleta agregada a tabla principal');
      }
    }

    // Después del toast, cargar los datos de la boleta emitida
    if (this.camponuevo) {
      // Para boleta nueva, usa la boleta recién creada
      this.cargarDetalleBoletaEmitida(boletaData);
    } else if (this.filaSeleccionada) {
      // Para edición, usa la fila actualizada
      this.cargarDetalleBoletaEmitida(this.filaSeleccionada);
    }
  }

  async botonCancelar() {
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Cancelar acción
    }

    // Limpiar todos los campos de detalle
    this.trabajador = '-';
    this.periodo = '-';
    this.fechaemision = '--/--/----, --:--';
    this.estado = '-';
    this.archivogenerado = '-';
    this.mesSeleccionado = null;
    this.anioSeleccionado = null;
    this.periodoPagoMes = null;
    this.periodoPagoAnio = null;
    this.sucursalSeleccionada = '';
    this.centroCostoSeleccionado = '';
    this.tipoPlanillaSeleccionada = '';
    this.trabajadorSeleccionado = '';
    this.tipoArchivoSeleccionado = '';

    // Limpiar la fila seleccionada
    this.filaSeleccionada = null;
    this.camponuevo = false;
    
    // Deseleccionar cualquier fila en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Limpiar los valores del formulario
    this.periodoMes = null;
    this.periodoAnio = null;
    this.fechaEmision = new Date();
    
    this.EmisionForm.reset({
      fechaEmision: this.fechaEmision.toLocaleDateString('es-PE'),
      periodo: '',
      sucursalAutocomplete: '',
      sucursalInput: '',
      centroCosto: '',
      centroCostoInput: '',
      planillaSelect: '',
      tipoPlanilla: '',
      tipoArchivo: '',
    });
    
    // Habilitar todos los campos del formulario excepto fechaEmision
    this.EmisionForm.get('periodo')?.enable();
    this.EmisionForm.get('sucursalAutocomplete')?.enable();
    this.EmisionForm.get('sucursalInput')?.enable();
    this.EmisionForm.get('centroCosto')?.enable();
    this.EmisionForm.get('centroCostoInput')?.enable();
    this.EmisionForm.get('planillaSelect')?.enable();
    this.EmisionForm.get('tipoPlanilla')?.enable();
    this.EmisionForm.get('tipoArchivo')?.enable();
    
    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }

  private cargarDetalleBoletaEmitida(data: any): void {
    // Asignar como fila seleccionada para mostrar detalle
    this.filaSeleccionada = data;

    // Llenar los campos de detalle de boleta emitida
    this.trabajador = data.planilla_trabajador;
    this.periodo = data.planilla_periodo;
    this.fechaemision = data.planilla_fecha_emision;
    this.estado = data.planilla_estado;
    this.archivogenerado = 'Boleta_' + data.planilla_num_boleta + '.pdf';

    // Parsear el periodo (formato YYYYMM)
    const periodoStr = data.planilla_periodo.toString();
    if (periodoStr.length === 6) {
      this.periodoPagoAnio = parseInt(periodoStr.substring(0, 4));
      this.periodoPagoMes = parseInt(periodoStr.substring(4, 6));
    }

    // Buscar y asignar la sucursal
    const sucursal = this.sucursales.find(s => s.nombre === data.planilla_sucursal);
    if (sucursal) {
      this.sucursalSeleccionada = sucursal.id.toString();
    } else {
      this.sucursalSeleccionada = data.planilla_sucursal;
    }

    // Buscar y asignar el centro de costo
    const centroCosto = this.centros.find(c => c.nombre === data.planilla_centro_costos);
    if (centroCosto) {
      this.centroCostoSeleccionado = centroCosto.id.toString();
    } else {
      this.centroCostoSeleccionado = data.planilla_centro_costos;
    }

    // Actualizar el formulario con los datos de la boleta emitida
    this.EmisionForm.patchValue({
      fechaEmision: data.planilla_fecha_emision,
      periodo: data.planilla_periodo,
      sucursalInput: data.planilla_sucursal,
      centroCostoInput: data.planilla_centro_costos,
      tipoPlanilla: data.planilla_tipo_planilla,
      tipoArchivo: ''
    });

    this.camponuevo = false;
  }

  private generarNumBoleta(): string {
    const fecha = new Date();
    const año = fecha.getFullYear();
    const mes = String(fecha.getMonth() + 1).padStart(2, '0');
    const secuencial = String(Math.floor(Math.random() * 10000)).padStart(5, '0');
    return `${año}-${mes}-${secuencial}`;
  }

  private limpiarFormulario(): void {
    this.fechaEmision = new Date();
    this.EmisionForm.reset();
    this.EmisionForm.patchValue({
      fechaEmision: this.fechaEmision.toLocaleDateString('es-PE')
    });
    this.filaSeleccionada = null;
    this.camponuevo = false;
  }

  botonNuevaBoleta(): void {
    // Limpiar todos los campos de detalle
    this.trabajador = '-';
    this.periodo = '-';
    this.fechaemision = '--/--/----, --:--';
    this.estado = '-';
    this.archivogenerado = '-';
    this.mesSeleccionado = null;
    this.anioSeleccionado = null;
    this.periodoPagoMes = null;
    this.periodoPagoAnio = null;
    this.sucursalSeleccionada = '';
    this.centroCostoSeleccionado = '';
    this.tipoPlanillaSeleccionada = '';
    this.trabajadorSeleccionado = '';
    this.tipoArchivoSeleccionado = '';

    this.filaSeleccionada = null;
    this.camponuevo = true;
    this.limpiarFormulario();
    // Deseleccionar la fila de la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }


  onSelectionChanged(event: any): void {
    // Este método se mantiene por compatibilidad pero la lógica principal está en onCellClicked
  }

  onSurcursalSeleccionada(sucursal: SucursalEntity) {
    console.log('Sucursal seleccionada:', sucursal);
  }

  onCentroSeleccionado(centro: CentroEntity) {
    console.log('Centros de costo seleccionados:', centro);
  }
  onPeriodoSeleccionado(periodo: { month: number; year: number }) {
    console.log('Periodo seleccionado:', periodo);
    this.EmisionForm.patchValue({
      periodo: `${periodo.year}${String(periodo.month).padStart(2, '0')}`
    });
  }

  onPeriodoContableChange(event: {month: number, year: number}) {
    console.log('Periodo contable:', event);
    this.periodoMes = event.month;
    this.periodoAnio = event.year;
  }

  onGridReadyDetalle(params: GridReadyEvent) {
      this.gridApiDetalle = params.api;
    }

  descargarBoletasSeleccionadas() {
    const filasSeleccionadas = this.gridApiDetalle.getSelectedRows();
    
    if (filasSeleccionadas.length === 0) {
      this.toastService.warning('Seleccione al menos una boleta para descargar');
      return;
    }

    // Simular descarga con toast
    const nombresTrabajadores = filasSeleccionadas.map(fila => fila.nombres).join(', ');
    const cantidad = filasSeleccionadas.length;
    
    this.toastService.success(
      `Descargando boleta${cantidad > 1 ? 's' : ''}`,
      // `Boletas de: ${nombresTrabajadores.length > 50 ? nombresTrabajadores.substring(0, 50) + '...' : nombresTrabajadores}`
    );

    // Aquí iría la lógica real de descarga
    console.log('Boletas seleccionadas para descargar:', filasSeleccionadas);
  }
  
    onCellClickedDetalle(event: any) {
      if (event.data) {
        const data = event.data;
        
        // Seleccionar la fila en la tabla
        if (this.gridApiDetalle) {
          this.gridApiDetalle.deselectAll();
          event.node?.setSelected(true);
        }
        
        // Mostrar el panel de información
        this.mostrarInformacion = true;
        console.log('Trabajador seleccionado:', data);

        // Llenar los campos del formulario con los datos de la fila seleccionada de detalle
        this.trabajador = data.nombres || '-';
        this.periodo = data.periodo ? this.formatearPeriodo(data.periodo) : '-';
        this.fechaemision = data.fechaemision ? this.formatearFecha(data.fechaemision) : '--/--/----';
        this.estado = data.estado || '-';
        this.archivogenerado = `Boleta_${data.documento || 'sin_numero'}.pdf`;
        
        // Parsear el periodo (si está en formato YYYYMM)
        const periodoStr = data.periodo?.toString();
        if (periodoStr && periodoStr.length === 6) {
          this.periodoPagoMes = parseInt(periodoStr.substring(4, 6));
          this.periodoPagoAnio = parseInt(periodoStr.substring(0, 4));
        }
      }
    }

    private formatearPeriodo(periodo: any): string {
      if (!periodo || periodo === '-') return '-';
      const periodoStr = periodo.toString().trim();
      if (periodoStr.includes('/')) {
        return periodoStr;
      }
      if (periodoStr.length === 6 && !isNaN(Number(periodoStr))) {
        const year = periodoStr.substring(0, 4);
        const month = periodoStr.substring(4, 6);
        return `${month}/${year}`;
      }
      return periodoStr;
    }


  togglePanelLateral(): void {
    this.panelLateralVisible = !this.panelLateralVisible;
  }


  filtrarPorFechas(range: { start: Date; end: Date }): void {
    this.startDate = range.start;
    this.endDate = range.end;
  }

  // Formateo fecha para modal
  formatearFecha(fecha: string): string {
    if (!fecha) return '-';

    // Si ya está en formato dd/MM/yyyy, devolverlo como está
    if (fecha.includes('/')) {
      return fecha;
    }

    // Si está en formato yyyy-MM-dd, convertir a dd/MM/yyyy
    if (fecha.includes('-')) {
      const [año, mes, dia] = fecha.split('-');
      return `${dia}/${mes}/${año}`;
    }

    return '-';
  }

  async modalverActualizaciones(): Promise<void> {
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
      { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Registro inicial del siniestro'},
      { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Cambio de estado de "Reportado" a "En evaluación"'},
      { fechaHora: '13/11/2025 09:00', usuario: 'Carlos Rodríguez', accion: 'Actualización', detalleCambio: 'Agregó documentación de respaldo (3 archivos)'},
      { fechaHora: '13/11/2025 16:45', usuario: 'Ana Martínez', accion: 'Actualización', detalleCambio: 'Cambio de estado de "En evaluación" a "Aprobado"' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones del Reclamo SIN-0000000007',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }


}
