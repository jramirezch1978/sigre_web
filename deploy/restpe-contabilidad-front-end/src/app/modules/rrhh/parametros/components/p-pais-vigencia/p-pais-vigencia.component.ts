import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { count } from 'rxjs';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { PaisVigenciaEntity } from 'src/app/modules/rrhh/domain/models/pais-vigencia.entity';



@Component({
  selector: 'app-p-pais-vigencia',
  templateUrl: './p-pais-vigencia.component.html',
  styleUrls: ['./p-pais-vigencia.component.scss'],
  standalone: false,
})
export class PPaisVigenciaComponent  implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  private readonly rrHhFacade = inject(RrHhFacade);
  readonly isLoading = this.rrHhFacade.loadingPaisVigencia;
  isResetting = false;

  codigoSeleccionado: string = '';
  countries= ALL_COUNTRIES;
  formularioRemuneracion!: FormGroup;
  monedapais: any ='';
  tipoCambioDefecto: number = 3.85;
  pais= this.countryService.getCountryCode();
  tituloPanelDerecho = 'Nueva remuneración mínima';
  modoCreacion: boolean = true;
  filaSeleccionada: any = null;
  textoBotonGuardar: string = 'Registrar';
  private gridApi!: GridApi;
  // Configuración del calendario de rango
  startDate: Date = new Date(new Date().getFullYear(), new Date().getMonth(), 1);
  endDate: Date = new Date();
  minDate: Date = new Date(2020, 0, 1);
  maxDate: Date = new Date();

  // Arrays de opciones
  tiposTrabajador = [
    { value: 'general', label: 'General' },
    { value: 'sectorial', label: 'Sectorial' },
    { value: 'aprendiz', label: 'Aprendiz pre-profesional' },
    { value: 'temporal', label: 'Temporal' },
    { value: 'parttime', label: 'Part time' },
    { value: 'practicante', label: 'Practicante profesional' }
  ];

  estadosRegistro = [
    { value: 'activo', label: 'Activo' },
    { value: 'inactivo', label: 'Inactivo' }
  ];

  // Configuración de AG-Grid
  columnDefs: any[] = [];

  rowData: PaisVigenciaEntity[] = [];

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
    private toastservice: ToastService,
    private modalController: ModalController,
    private fb: FormBuilder,
    private countryService: CountryService,
    public formValidationService: FormValidationService
  ) { }

  ngOnInit() {
    this.inicializarFormulario();
    
    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.formularioRemuneracion);
    this.formValidationService.resetearEstado();
    
    this.obtenerdaatosdepais();
    this.inicializarColumnDefs();

    this.rrHhFacade.cargarPaisVigencia();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        if (this.countryService.getCountryCode() !== 'GT') {
          this.rowData = this.rrHhFacade.paisVigencia();
        }
        clearInterval(timer);
      }
    }, 100);
  }

  onBtReset(): void {
    this.isResetting = true;
    this.rrHhFacade.cargarPaisVigencia();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        if (this.countryService.getCountryCode() !== 'GT') {
          this.rowData = this.rrHhFacade.paisVigencia();
        }
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }
  obtenerdaatosdepais(){
    this.countries.find(c => {
      if(c.codigo === this.pais){
        c.monedapais?.find(tip => {
          this.monedapais= tip.simbolo;
        })
      }
    })   
  }

  inicializarColumnDefs() {
    this.columnDefs = [
      { headerName: 'Código', field: 'pais_vigencia_codigo', flex: 1, sortable: true, filter: true },
      { headerName: 'Fecha de vigencia', field: 'pais_vigencia_fecha_vigencia', flex: 1, sortable: true, filter: true },
      { headerName: 'Remuneración mínima ('+ this.monedapais +')', field: 'pais_vigencia_remuneracion_soles', flex: 1, sortable: true, filter: true },
      { headerName: 'Remuneración mínima ($)', field: 'pais_vigencia_remuneracion_dolares', flex: 1, sortable: true, filter: true },
      { headerName: 'Tipo de trabajador', field: 'pais_vigencia_tipo_trabajador', flex: 1, sortable: true, filter: true },
      { 
        headerClass: 'centrarencabezado',
        headerName: 'Estado', 
        field: 'pais_vigencia_estado',
        width: 100,
        sortable: true,
        filter: true,
        cellRenderer: (params: any) => {
          const estado = params.value;
          if (estado === 'Activo') {
            return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
          } else if (estado === 'Inactivo') {
            return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>';
          }
          return params.value;
        },
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center'},
      }
    ];

    // Agregar columna de bonificación solo para Guatemala
    if(this.countryService.getCountryCode() === 'GT'){
      this.rowData = []; // Limpiar los datos existentes
      this.columnDefs.splice(3, 0, { 
        headerName: 'Salario ordinario', 
        field: 'pais_vigencia_salario_ordinario', 
        flex: 1, 
        sortable: true, 
        filter: true 
      });
      this.rowData.push(
        { pais_vigencia_codigo: 'REM-003', pais_vigencia_fecha_vigencia: ' 01/01/2025', pais_vigencia_remuneracion_soles: this.monedapais + ' 2,500.00' , pais_vigencia_remuneracion_dolares: '$ 320.00', pais_vigencia_salario_ordinario: this.monedapais + ' 2,200.00', pais_vigencia_bonificacion: this.monedapais + ' 300.00', pais_vigencia_kpi: this.monedapais + ' 300.00', pais_vigencia_tipo_trabajador: 'General', pais_vigencia_estado: 'Activo', pais_vigencia_fecha_desde: new Date(2025, 0, 1), pais_vigencia_fecha_hasta: null, pais_vigencia_remuneracion_soles_num: 2500, pais_vigencia_remuneracion_dolares_num: 320.00, pais_vigencia_tipo_cambio: 7.80, pais_vigencia_tipo_trabajador_value: 'general', pais_vigencia_estado_value: 'activo' } as any,
      );
      this.columnDefs.splice(4, 0, { 
        headerName: 'Bonificación', 
        field: 'pais_vigencia_bonificacion', 
        flex: 1, 
        sortable: true, 
        filter: true 
      });
    }
  }
  inicializarFormulario() {
    this.formularioRemuneracion = this.fb.group({
      pais_vigencia_codigo: [null],
      vigenciaDesde: [null, Validators.required],
      pais_vigencia_salario_ordinario: [null],
      pais_vigencia_bonificacion: [null],
      pais_vigencia_kpi: [null],
      vigenciaHasta: [null],
      pais_vigencia_remuneracion_soles: [null, Validators.required],
      pais_vigencia_remuneracion_dolares: [null],
      pais_vigencia_tipo_cambio: [this.tipoCambioDefecto],
      pais_vigencia_tipo_trabajador: [null, Validators.required],
      estadoRegistro: ['activo']
    });

    // Deshabilitar campos calculados desde el formulario
    this.formularioRemuneracion.get('pais_vigencia_remuneracion_dolares')?.disable();
    this.formularioRemuneracion.get('pais_vigencia_tipo_cambio')?.disable();
  }

  async onCellClicked(event: any) {
    const data = event.data;
    
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló: deseleccionar todo
      if (this.gridApi) {
        this.gridApi.deselectAll();
        // Re-seleccionar fila anterior si existía
        if (this.filaSeleccionada) {
          this.gridApi.forEachNode((node) => {
            if (node.data.pais_vigencia_codigo === this.filaSeleccionada?.pais_vigencia_codigo) {
              node.setSelected(true);
            }
          });
        }
      }
      return; // Usuario canceló, mantener formulario actual
    }
    
    // Cambiar a modo edición
    this.modoCreacion = false;
    this.filaSeleccionada = data;
    this.tituloPanelDerecho = `Remuneración mínima: ${data.pais_vigencia_codigo}`;
    this.textoBotonGuardar = 'Guardar';
    
    this.formularioRemuneracion.patchValue({
      pais_vigencia_codigo: data.pais_vigencia_codigo,
      vigenciaDesde: data.pais_vigencia_fecha_desde,
      vigenciaHasta: data.pais_vigencia_fecha_hasta,
      pais_vigencia_salario_ordinario: data.pais_vigencia_salario_ordinario,
      pais_vigencia_bonificacion: data.pais_vigencia_bonificacion,
      pais_vigencia_kpi: data.pais_vigencia_kpi,
      pais_vigencia_remuneracion_soles: data.pais_vigencia_remuneracion_soles_num,
      pais_vigencia_remuneracion_dolares: data.pais_vigencia_remuneracion_dolares_num,
      pais_vigencia_tipo_cambio: data.pais_vigencia_tipo_cambio ?? this.tipoCambioDefecto,
      pais_vigencia_tipo_trabajador: data.pais_vigencia_tipo_trabajador_value,
      estadoRegistro: data.pais_vigencia_estado_value
    });
    
    // Calcular y actualizar remuneración en dólares
    this.calcularRemuneracionDolares();
    
    // Resetear servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }

  onRemuneracionSolesChange(event: any) {
    const valor = event.detail.value;
    if (valor && !isNaN(valor)) {
      this.formularioRemuneracion.patchValue({
        pais_vigencia_remuneracion_soles: parseFloat(valor)
      });
      this.calcularRemuneracionDolares();
    }
  }

  calcularRemuneracionDolares() {
    const remuneracionSoles = this.formularioRemuneracion.get('pais_vigencia_remuneracion_soles')?.value;
    const tipoCambio = this.formularioRemuneracion.get('pais_vigencia_tipo_cambio')?.value;
    
    if (remuneracionSoles && tipoCambio) {
      const remuneracionDolares = remuneracionSoles / tipoCambio;
      this.formularioRemuneracion.get('pais_vigencia_remuneracion_dolares')?.setValue(remuneracionDolares.toFixed(2));
    }
  }

  async nuevaVigencia() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    // Cambiar a modo creación
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.tituloPanelDerecho = 'Nueva remuneración mínima';
    this.textoBotonGuardar = 'Registrar';
    
    this.formularioRemuneracion.reset({
      pais_vigencia_tipo_cambio: this.tipoCambioDefecto,
      estadoRegistro: 'activo'
    });
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
    
    // Deseleccionar fila en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  onFechaDesdeSelected(fecha: Date) {
    this.formularioRemuneracion.patchValue({ vigenciaDesde: fecha });
  }

  onFechaHastaSelected(fecha: Date) {
    this.formularioRemuneracion.patchValue({ vigenciaHasta: fecha });
  }

  async modalverActualizaciones() {
      // Definir las columnas
      const colDefs = [
        { headerName: 'Fecha y hora', field: 'fechaHora', width: 100, },
        { headerName: 'Usuario', field: 'usuario', width: 120, },
        { headerName: 'Acción', field: 'accion', width: 80, },
        { headerName: 'Detalle del cambio', field: 'detalleCambio', flex: 1,
          wrapText: true,
          autoHeight: true,
          cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' }, 
        },
      ];
  
      // Datos de ejemplo
      const rowData = [
        { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar' },
        { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385' },
        { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380 ' },
        { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT' },
      ];
  
      const defaultColDefModal: ColDef = {
        wrapText: true,
        autoHeight: true,
      };
  
      const codigo = this.formularioRemuneracion?.get('pais_vigencia_codigo')?.value || '';
      const titulo = codigo
      
        ? `Historial de actualizaciones de remuneraciones mínimas ${codigo}`
        : 'Historial de actualizaciones de remuneraciones mínimas';
      const modal = await this.modalController.create({
        component: ModalVerActualizacionesComponent,
        cssClass: 'promo',
        componentProps: {
          titulo: titulo,
          rowData: rowData,
          colDefs: colDefs,
          defaultColDef: defaultColDefModal,
          anchoModal: '700px',
        },
      });
  
      await modal.present();
    }
  
  // Crear una nueva vigencia en la tabla
  private crearNuevaVigencia() {
    if (!this.formularioRemuneracion) return;

    const valores = this.formularioRemuneracion.getRawValue();

    // Validaciones mínimas
    if (!valores.vigenciaDesde || !valores.pais_vigencia_remuneracion_soles || !valores.pais_vigencia_tipo_trabajador) {
      // Campos requeridos faltantes: mostrar toast y no registrar
      this.toastservice.warning('Por favor, completa todos los campos obligatorios para realizar esta acción.');
      return;
    }

    const codigo = this.generarNuevoCodigo();
    const fechaDesde = valores.vigenciaDesde instanceof Date ? valores.vigenciaDesde : new Date(valores.vigenciaDesde);
    const fechaHasta = valores.vigenciaHasta ? (valores.vigenciaHasta instanceof Date ? valores.vigenciaHasta : new Date(valores.vigenciaHasta)) : null;

    const fechaVigencia = fechaHasta
      ? `${this.formatearFecha(fechaDesde)} - ${this.formatearFecha(fechaHasta)}`
      : `${this.formatearFecha(fechaDesde)}`;

    const tipoCambio = valores.pais_vigencia_tipo_cambio ?? this.tipoCambioDefecto;
    const remuneracionSolesNum = Number(valores.pais_vigencia_remuneracion_soles);
    const remuneracionDolaresNum = Number(tipoCambio) ? remuneracionSolesNum / Number(tipoCambio) : 0;

    const remuneracionSolesStr = `${this.monedapais} ${remuneracionSolesNum.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
    const remuneracionDolaresStr = `$ ${remuneracionDolaresNum.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;

    const tipoTrabajadorItem = this.tiposTrabajador.find(t => t.value === valores.pais_vigencia_tipo_trabajador);
    const tipoTrabajadorLabel = tipoTrabajadorItem ? tipoTrabajadorItem.label : valores.pais_vigencia_tipo_trabajador;
    const estadoItem = this.estadosRegistro.find(e => e.value === valores.estadoRegistro);
    const estadoLabel = estadoItem ? estadoItem.label : (valores.estadoRegistro || 'Activo');

    const nuevoRegistro: any = {
      pais_vigencia_codigo: codigo,
      pais_vigencia_fecha_vigencia: fechaVigencia,
      pais_vigencia_remuneracion_soles: remuneracionSolesStr,
      pais_vigencia_remuneracion_dolares: remuneracionDolaresStr,
      pais_vigencia_tipo_trabajador: tipoTrabajadorLabel,
      pais_vigencia_estado: estadoLabel,
      // Campos técnicos para edición posterior
      pais_vigencia_fecha_desde: fechaDesde,
      pais_vigencia_fecha_hasta: fechaHasta,
      pais_vigencia_remuneracion_soles_num: remuneracionSolesNum,
      pais_vigencia_remuneracion_dolares_num: remuneracionDolaresNum,
      pais_vigencia_tipo_cambio: tipoCambio,
      pais_vigencia_tipo_trabajador_value: valores.pais_vigencia_tipo_trabajador,
      pais_vigencia_estado_value: valores.estadoRegistro || 'activo',
      // Solo para Guatemala, mantener si existen
      pais_vigencia_salario_ordinario: valores.pais_vigencia_salario_ordinario,
      pais_vigencia_bonificacion: valores.pais_vigencia_bonificacion,
      pais_vigencia_kpi: valores.pais_vigencia_kpi,
    };

    // Insertar al inicio y forzar cambio de referencia para que AG-Grid re-renderice
    this.rowData = [nuevoRegistro, ...this.rowData];

    this.toastservice.success('¡Remuneración agregada con éxito!');

    // Vaciar formulario para nuevo registro
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.textoBotonGuardar = 'Registrar';
    this.formularioRemuneracion.reset();
    this.formularioRemuneracion.patchValue({
      pais_vigencia_tipo_cambio: this.tipoCambioDefecto,
      estadoRegistro: 'activo',
      pais_vigencia_remuneracion_dolares: null
    });

      if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Restablecer título del panel derecho
    this.tituloPanelDerecho = 'Nueva remuneración mínima';
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  get botonHabilitado(): boolean {
    if (this.filaSeleccionada) {
      return true;
    }

    const valores = this.formularioRemuneracion.getRawValue();
    
    // Verificar si hay algún campo con valor que no sea el tipoCambio por defecto
    const tieneDatos = 
      valores.vigenciaDesde !== null ||
      valores.vigenciaHasta !== null ||
      valores.pais_vigencia_salario_ordinario !== null ||
      valores.pais_vigencia_bonificacion !== null ||
      valores.pais_vigencia_kpi !== null ||
      valores.pais_vigencia_remuneracion_soles !== null ||
      valores.pais_vigencia_tipo_trabajador !== null ||
      (valores.estadoRegistro !== null && valores.estadoRegistro !== 'activo'); // Solo si es diferente del valor por defecto

    return tieneDatos;
  }

  private formatearFecha(fecha: Date): string {
    const d = new Date(fecha);
    const dia = String(d.getDate()).padStart(2, '0');
    const mes = String(d.getMonth() + 1).padStart(2, '0');
    const anio = d.getFullYear();
    return `${dia}/${mes}/${anio}`;
  }

  // Método unificado para guardar cambios (crear o actualizar)
  guardarCambios() {
    if(this.formularioRemuneracion.invalid) {
      this.toastservice.warning('Por favor, completa todos los campos requeridos.');
      return;
    }

    if (this.modoCreacion) {
      this.crearNuevaVigencia();
    } else {
      this.actualizarVigencia();
    }
  }

  // Actualizar vigencia existente
  private actualizarVigencia() {
    if (!this.formularioRemuneracion || !this.filaSeleccionada) return;

    const valores = this.formularioRemuneracion.getRawValue();

    // Validaciones mínimas
    if (!valores.vigenciaDesde || !valores.pais_vigencia_remuneracion_soles || !valores.pais_vigencia_tipo_trabajador) {
      this.toastservice.warning('Por favor, completa todos los campos requeridos para realizar esta acción.');
      return;
    }

    const fechaDesde = valores.vigenciaDesde instanceof Date ? valores.vigenciaDesde : new Date(valores.vigenciaDesde);
    const fechaHasta = valores.vigenciaHasta ? (valores.vigenciaHasta instanceof Date ? valores.vigenciaHasta : new Date(valores.vigenciaHasta)) : null;

    const fechaVigencia = fechaHasta
      ? `${this.formatearFecha(fechaDesde)} - ${this.formatearFecha(fechaHasta)}`
      : `${this.formatearFecha(fechaDesde)}`;

    const tipoCambio = valores.pais_vigencia_tipo_cambio ?? this.tipoCambioDefecto;
    const remuneracionSolesNum = Number(valores.pais_vigencia_remuneracion_soles);
    const remuneracionDolaresNum = Number(tipoCambio) ? remuneracionSolesNum / Number(tipoCambio) : 0;

    const remuneracionSolesStr = `${this.monedapais} ${remuneracionSolesNum.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
    const remuneracionDolaresStr = `$ ${remuneracionDolaresNum.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;

    const tipoTrabajadorItem = this.tiposTrabajador.find(t => t.value === valores.pais_vigencia_tipo_trabajador);
    const tipoTrabajadorLabel = tipoTrabajadorItem ? tipoTrabajadorItem.label : valores.pais_vigencia_tipo_trabajador;
    const estadoItem = this.estadosRegistro.find(e => e.value === valores.estadoRegistro);
    const estadoLabel = estadoItem ? estadoItem.label : (valores.estadoRegistro || 'Activo');

    // Actualizar el registro existente
    const index = this.rowData.findIndex(item => item.pais_vigencia_codigo === this.filaSeleccionada.pais_vigencia_codigo);
    if (index !== -1) {
      this.rowData[index] = {
        ...this.rowData[index],
        pais_vigencia_fecha_vigencia: fechaVigencia,
        pais_vigencia_remuneracion_soles: remuneracionSolesStr,
        pais_vigencia_remuneracion_dolares: remuneracionDolaresStr,
        pais_vigencia_tipo_trabajador: tipoTrabajadorLabel,
        pais_vigencia_estado: estadoLabel,
        pais_vigencia_fecha_desde: fechaDesde,
        pais_vigencia_fecha_hasta: fechaHasta,
        pais_vigencia_remuneracion_soles_num: remuneracionSolesNum,
        pais_vigencia_remuneracion_dolares_num: remuneracionDolaresNum,
        pais_vigencia_tipo_cambio: tipoCambio,
        pais_vigencia_tipo_trabajador_value: valores.pais_vigencia_tipo_trabajador,
        pais_vigencia_estado_value: valores.estadoRegistro || 'activo',
        pais_vigencia_salario_ordinario: valores.pais_vigencia_salario_ordinario,
        pais_vigencia_bonificacion: valores.pais_vigencia_bonificacion,
        pais_vigencia_kpi: valores.pais_vigencia_kpi,
      };

      // Forzar cambio de referencia para que AG-Grid re-renderice
      this.rowData = [...this.rowData];
    }

    this.toastservice.success('¡Remuneración actualizada con éxito!');

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
    
    // Deseleccionar fila en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  async cancelar() {
    // Deseleccionar PRIMERO
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló (ya deseleccionado)
    }
    
    // Limpiar formulario y volver a modo creación
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.tituloPanelDerecho = 'Nueva remuneración mínima';
    this.textoBotonGuardar = 'Registrar';
    
    this.formularioRemuneracion.reset({
      pais_vigencia_tipo_cambio: this.tipoCambioDefecto,
      estadoRegistro: 'activo'
    });
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  private generarNuevoCodigo(): string {
    // Obtener máximo correlativo ignorando prefijo
    const numeros = this.rowData.map(item => {
      const match = String(item.pais_vigencia_codigo || '').match(/\D*(\d+)/);
      return match ? parseInt(match[1], 10) : 0;
    });
    const max = Math.max(0, ...numeros);
    const siguiente = String(max + 1).padStart(5, '0');
    return `RM-${siguiente}`;
  }
  
}
