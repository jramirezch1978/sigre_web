import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { ConfiguracionProvisionesEntity } from 'src/app/modules/rrhh/domain/models/configuracion-provisiones.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { SimulationService } from 'src/app/simulation/simulation.service';



@Component({
  selector: 'app-p-configuracion-provisiones',
  templateUrl: './p-configuracion-provisiones.component.html',
  styleUrls: ['./p-configuracion-provisiones.component.scss'],
  standalone: false,
})
export class PConfiguracionProvisionesComponent implements OnInit, CanComponentDeactivate {
  // Facades
  private readonly rrHhFacade = inject(RrHhFacade);

  // Selectores del store
  readonly isLoading = this.rrHhFacade.loadingConfiguracionProvisiones;
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  private gridApi!: GridApi;
  isResetting: boolean = false;
  fechaActual: string = new Date().toLocaleDateString('es-PE');
  pais= this.countryService.getCountryCode();
  countries= ALL_COUNTRIES;
  provisionForm!: FormGroup;
  modoEdicion: boolean = false;
  indiceEdicion: number = -1;
  contadorCodigo: number = 5;
  selectedCodigo: string | null = null;
  botonNuevaProvisionHabilitado: boolean = false;
  fechaInicioVigencia: Date | null = null;
  fechaFinVigencia: Date | null = null;
  mostrarFormulaCalculo: boolean = false;
  formularioModificado: boolean = false;
  private valoresIniciales: any = {};
  
  // Propiedades para el calendario de filtro
  startDate: Date | undefined = undefined;
  endDate: Date | undefined = undefined;
  minDate: Date | undefined = undefined;
  maxDate: Date | undefined = undefined;
  
  formulasCalculo: { [key: string]: string } = {
    'vacaciones': '(Sueldo / 30) × Días Vacaciones',
    'cts': '(Sueldo + Gratificación/6) / 12',
    'gratificación': 'Sueldo × Meses Trabajados / 6'
  };
  
  regimenesLaborales: any = [];
  
  provision: any =[
  ]
  estado = [
    { value: 'activo', label: 'Activo' },
    { value: 'inactivo', label: 'Inactivo' }
  ];
  periodicidad=[
    {value:'mensual', label:'Mensual'},
    {value:'bimestral', label:'Bimestral'},
    {value:'semestral', label:'Semestral'},
    {value:'anual', label:'Anual'},
  ]
  
  cuentasGasto: { id: string , nombre: string }[] = [];
  
  cuentasPasivo: { id: string , nombre: string }[] = [];
  
  centrosCosto = [
    { id: 'ADM', nombre: 'Administración' },
    { id: 'VTA', nombre: 'Ventas' },
    { id: 'OPE', nombre: 'Operaciones' },
    { id: 'LOG', nombre: 'Logística' },
    { id: 'RRHH', nombre: 'Recursos Humanos' }
  ];
  
  // Configuración de AG-Grid
  columnDefs: any[] = [
    { headerName: 'Código', field: 'configuracion_provision_codigo', flex: 1, sortable: true, filter: true },
    { headerName: 'Periodo de vigencia', field: 'configuracion_provision_periodo_vigencia', flex: 1, sortable: true, filter: true },
    { headerName: 'Tipo de provisión', field: 'configuracion_provision_tipo_provision', flex: 1, sortable: true, filter: true },
    { headerName: 'Régimen laboral', field: 'configuracion_provision_regimen_laboral', flex: 1, sortable: true, filter: true },
    { headerName: 'Centro de costo', field: 'configuracion_provision_centro_costo', flex: 1, sortable: true, filter: true },
    { headerName: 'Periodicidad', field: 'configuracion_provision_periodicidad', flex: 1, sortable: true, filter: true },
    { 
      headerClass: 'centrarencabezado',
      headerName: 'Estado', 
      field: 'configuracion_provision_estado',
      flex: 1,
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

  rowData: ConfiguracionProvisionesEntity[] = [];

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
    private modalController: ModalController,
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private countryService: CountryService,
    private simulation: SimulationService, 
  ) { }

  ngOnInit() {
    this.obtenerdatospais();
    this.inicializarFormulario();
    this.cargarCuentasContables();

    // Cargar provisiones desde JSON a través de la capa de infraestructura
    this.rrHhFacade.cargarConfiguracionProvisiones();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.rowData = [...this.rrHhFacade.configuracionProvisiones()];
      }
    }, 100);

    // Detectar cambios en el formulario
    this.provisionForm.valueChanges.subscribe(() => {
      this.detectarCambios();
    });
  }
  obtenerdatospais(){
    this.countries.find(country => {
      if(country.codigo === this.pais){
        this.regimenesLaborales = country.regimenesLaborales || [];
        this.provision =  country.tipoprovision;
      }
    });
  }
  inicializarFormulario() {
    this.provisionForm = this.formBuilder.group({
      fechaInicio: ['', Validators.required],
      fechaFinVigencia: [null],
      regimenLaboral: ['', Validators.required],
      tipoProvision: ['', Validators.required],
      formulaCalculo: [''],
      descripcion: [''],
      cuentaGasto: [null, Validators.required],
      cuentaPasivo: [null, Validators.required],
      centroCosto: [null, Validators.required],
      periodicidad: ['', Validators.required],
      estado: ['activo', Validators.required]
    });
  }

  /**
   * Cargar cuentas contables desde localStorage
   */
  cargarCuentasContables() {
    const cuentas = this.simulation.list('plancontable') || [];
    this.cuentasGasto = cuentas.map((item:any) => ({
      id: item.codigo,
      nombre: `${item.codigo} - ${item.descripcion}`,
    }));
    this.cuentasPasivo = cuentas.map((item:any) => ({
      id: item.codigo,
      nombre: `${item.codigo} - ${item.descripcion}`,
    }));
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onBtReset() {
    this.isResetting = true;
    this.rrHhFacade.cargarConfiguracionProvisiones();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.rowData = [...this.rrHhFacade.configuracionProvisiones()];
        this.isResetting = false;
      }
    }, 100);
  }

  onFechaInicioChange(fecha: Date) {
    if (fecha) {
      this.fechaInicioVigencia = fecha;
      const fechaFormateada = fecha.toLocaleDateString('es-PE');
      this.provisionForm.patchValue({ fechaInicio: fechaFormateada });
    }
  }

  onFechaFinChange(fecha: Date) {
    if (fecha) {
      this.fechaFinVigencia = fecha;
      const fechaFormateada = fecha.toLocaleDateString('es-PE');
      this.provisionForm.patchValue({ fechaFinVigencia: fechaFormateada });
    }
  }

  onFiltroFechaChange(event: { start: Date | null, end: Date | null }) {
    this.startDate = event.start || undefined;
    this.endDate = event.end || undefined;
    // Aquí puedes agregar lógica para filtrar la tabla por fechas si lo necesitas
  }

  onTipoProvisionChange(event: any) {
    const tipoProvisionValue = event.detail.value;
    
    // Buscar el label del tipo de provisión seleccionado
    const tipoProvisionItem = this.provision.find((item: any) => item.value === tipoProvisionValue);
    const tipoProvisionLabel = tipoProvisionItem?.label?.toLowerCase() || '';
    
    // Mostrar el campo de fórmula solo para vacaciones, cts y gratificación
    this.mostrarFormulaCalculo = ['vacaciones', 'cts', 'gratificación'].includes(tipoProvisionLabel);
    
    // Establecer la fórmula por defecto según el label
    if (this.mostrarFormulaCalculo && this.formulasCalculo[tipoProvisionLabel]) {
      this.provisionForm.patchValue({ formulaCalculo: this.formulasCalculo[tipoProvisionLabel] });
    } else {
      this.provisionForm.patchValue({ formulaCalculo: '' });
    }
  }

  async onRowClicked(event: any) {
    if (!event.data) return;
    
    // Validar cambios antes de cambiar de registro
    let confirmar = true;
    if (this.formularioModificado) {
      confirmar = await this.mostrarAlertaCambiosSinGuardar();
    }
    
    if (!confirmar) {
      // Usuario canceló, deseleccionar todo primero
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }
      return;
    }
    
    // Usuario confirmó, cargar nueva fila
    this.botonNuevaProvisionHabilitado = true;
    this.cargarDatosParaEditar(event.data, event.rowIndex);
  }

  cargarDatosParaEditar(data: any, index: number) {
    this.modoEdicion = true;
    this.indiceEdicion = index;
    this.selectedCodigo = data.configuracion_provision_codigo || null;
    
    // Buscar régimen laboral por label
    const regimenLaboralItem = this.regimenesLaborales.find((r: any) => 
      r.label?.toLowerCase() === data.configuracion_provision_regimen_laboral?.toLowerCase()
    );
    const regimenLaboral = regimenLaboralItem?.value || '';
    
    // Buscar tipo de provisión por label
    const tipoProvisionItem = this.provision.find((p: any) => 
      p.label?.toLowerCase() === data.configuracion_provision_tipo_provision?.toLowerCase()
    );
    const tipoProvision = tipoProvisionItem?.value || '';
    const tipoProvisionLabel = tipoProvisionItem?.label?.toLowerCase() || '';
    
    // Mostrar campo de fórmula si corresponde
    this.mostrarFormulaCalculo = ['vacaciones', 'cts', 'gratificación'].includes(tipoProvisionLabel);
    
    // Obtener la fórmula (si existe en data, usarla; si no, usar la por defecto)
    const formulaCalculo = data.formulaCalculo || (this.mostrarFormulaCalculo ? this.formulasCalculo[tipoProvisionLabel] : '');
    
    // Buscar periodicidad por label
    const periodicidadItem = this.periodicidad.find((p: any) => 
      p.label?.toLowerCase() === data.configuracion_provision_periodicidad?.toLowerCase()
    );
    const periodicidad = periodicidadItem?.value || '';
    
    // Buscar estado por label
    const estadoItem = this.estado.find((e: any) => 
      e.label?.toLowerCase() === data.configuracion_provision_estado?.toLowerCase()
    );
    const estado = estadoItem?.value || 'activo';
    
    // Buscar centro de costo por nombre
    const centroCostoItem = this.centrosCosto.find(cc => cc.nombre === data.configuracion_provision_centro_costo);
    const centroCosto = centroCostoItem?.id || null;
    
    // Buscar cuenta de gasto por código (el id es el código)
    const cuentaGasto = data.configuracion_provision_cuenta_gasto || null;
    
    // Buscar cuenta de pasivo por código (el id es el código)
    const cuentaPasivo = data.configuracion_provision_cuenta_pasivo || null;
    
    // Parsear las fechas desde los campos dedicados del JSON
    let fechaInicio = '';
    let fechaFin = null;
    
    if (data.configuracion_provision_fecha_inicio) {
      this.fechaInicioVigencia = new Date(data.configuracion_provision_fecha_inicio + 'T00:00:00');
      fechaInicio = this.fechaInicioVigencia.toLocaleDateString('es-PE');
    } else if (data.configuracion_provision_periodo_vigencia) {
      const partes = data.configuracion_provision_periodo_vigencia.split(' - ');
      if (partes.length === 2) {
        this.fechaInicioVigencia = new Date(parseInt(partes[0].trim()), 0, 1);
        fechaInicio = this.fechaInicioVigencia.toLocaleDateString('es-PE');
      } else {
        const anio = data.configuracion_provision_periodo_vigencia.trim();
        this.fechaInicioVigencia = new Date(parseInt(anio), 0, 1);
        fechaInicio = this.fechaInicioVigencia.toLocaleDateString('es-PE');
      }
    }

    if (data.configuracion_provision_fecha_fin) {
      this.fechaFinVigencia = new Date(data.configuracion_provision_fecha_fin + 'T00:00:00');
      fechaFin = this.fechaFinVigencia.toLocaleDateString('es-PE');
    } else if (data.configuracion_provision_periodo_vigencia) {
      const partes = data.configuracion_provision_periodo_vigencia.split(' - ');
      if (partes.length === 2) {
        this.fechaFinVigencia = new Date(parseInt(partes[1].trim()), 0, 1);
        fechaFin = this.fechaFinVigencia.toLocaleDateString('es-PE');
      } else {
        this.fechaFinVigencia = null;
      }
    }
    
    this.provisionForm.patchValue({
      fechaInicio: fechaInicio,
      fechaFinVigencia: fechaFin,
      regimenLaboral: regimenLaboral,
      tipoProvision: tipoProvision,
      formulaCalculo: formulaCalculo,
      descripcion: data.configuracion_provision_descripcion || '',
      cuentaGasto: cuentaGasto,
      cuentaPasivo: cuentaPasivo,
      centroCosto: centroCosto,
      periodicidad: periodicidad,
      estado: estado
    });
    
    // Forzar actualización de los autocompletes después de un pequeño delay
    setTimeout(() => {
      this.provisionForm.get('cuentaGasto')?.updateValueAndValidity();
      this.provisionForm.get('cuentaPasivo')?.updateValueAndValidity();
      this.provisionForm.get('centroCosto')?.updateValueAndValidity();
      
      // Guardar valores iniciales y resetear flag de modificado
      this.guardarValoresIniciales();
      this.formularioModificado = false;
    }, 100);
  }

  async nuevoRegistro() {
    // Verificar si hay cambios sin guardar
    if (this.formularioModificado) {
      const confirmar = await this.mostrarAlertaCambiosSinGuardar();
      if (!confirmar) {
        return;
      }
    }
    
    this.modoEdicion = false;
    this.indiceEdicion = -1;
    this.provisionForm.reset({ estado: 'activo' });
    this.selectedCodigo = null;
    this.botonNuevaProvisionHabilitado = false;
    this.fechaInicioVigencia = null;
    this.fechaFinVigencia = null;
    this.mostrarFormulaCalculo = false;
    
    // Deseleccionar fila en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Guardar valores iniciales y resetear flag
    this.guardarValoresIniciales();
    this.formularioModificado = false;
  }

  async cancelar() {
    // Deseleccionar la fila INMEDIATAMENTE
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Validar si hay cambios sin guardar
    if (this.formularioModificado) {
      const confirmar = await this.mostrarAlertaCambiosSinGuardar();
      if (!confirmar) {
        return; // Cancelar acción, ya está deseleccionado
      }
    }
    
    // Si confirmó, limpiar formulario
    this.modoEdicion = false;
    this.indiceEdicion = -1;
    this.provisionForm.reset({ estado: 'activo' });
    this.selectedCodigo = null;
    this.botonNuevaProvisionHabilitado = false;
    this.fechaInicioVigencia = null;
    this.fechaFinVigencia = null;
    this.mostrarFormulaCalculo = false;

    // Guardar valores iniciales y resetear flag
    this.guardarValoresIniciales();
    this.formularioModificado = false;
  }

  async guardarProvision() {
    // Validar solo los campos requeridos
    const camposRequeridos = ['fechaInicio', 'regimenLaboral', 'tipoProvision', 'cuentaGasto', 'cuentaPasivo', 'centroCosto', 'periodicidad', 'estado'];
    let formularioValido = true;
    
    camposRequeridos.forEach(campo => {
      const control = this.provisionForm.get(campo);
      if (!control?.value) {
        control?.markAsTouched();
        formularioValido = false;
      }
    });

    if (!formularioValido) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    const formValue = this.provisionForm.value;
    
    // Construir el periodo de vigencia - extraer solo el año
    let periodoVigencia = '';
    if (this.fechaInicioVigencia) {
      const anioInicio = this.fechaInicioVigencia.getFullYear();
      
      if (this.fechaFinVigencia) {
        const anioFin = this.fechaFinVigencia.getFullYear();
        // Si los años son diferentes, mostrar rango de años
        if (anioInicio !== anioFin) {
          periodoVigencia = `${anioInicio} - ${anioFin}`;
        } else {
          // Si son del mismo año, mostrar solo el año
          periodoVigencia = `${anioInicio}`;
        }
      } else {
        // Si solo hay fecha de inicio, mostrar solo el año
        periodoVigencia = `${anioInicio}`;
      }
    } else {
      // Fallback: usar el valor del formulario si no hay fechas
      periodoVigencia = formValue.fechaInicio;
    }
    
    // Resolver labels desde los values del formulario
    const tipoProvisionLabel = this.provision.find((p: any) => p.value === formValue.tipoProvision)?.label || formValue.tipoProvision;
    const regimenLaboralLabel = this.regimenesLaborales.find((r: any) => r.value === formValue.regimenLaboral)?.label || formValue.regimenLaboral;
    const centroCostoLabel = this.centrosCosto.find(cc => cc.id === formValue.centroCosto)?.nombre || formValue.centroCosto || 'Sin asignar';
    const periodicidadLabel = this.periodicidad.find(p => p.value === formValue.periodicidad)?.label || formValue.periodicidad || 'No definida';
    const estadoLabel = this.estado.find(e => e.value === formValue.estado)?.label || this.capitalizarPrimeraLetra(formValue.estado);

    // Formatear fechas a yyyy-mm-dd
    const fechaInicioStr = this.fechaInicioVigencia ? this.fechaInicioVigencia.toISOString().split('T')[0] : undefined;
    const fechaFinStr = this.fechaFinVigencia ? this.fechaFinVigencia.toISOString().split('T')[0] : undefined;

    if (this.modoEdicion) {
      // Actualizar registro existente
      this.rowData[this.indiceEdicion] = {
        configuracion_provision_codigo: this.rowData[this.indiceEdicion].configuracion_provision_codigo,
        configuracion_provision_periodo_vigencia: periodoVigencia,
        configuracion_provision_fecha_inicio: fechaInicioStr,
        configuracion_provision_fecha_fin: fechaFinStr,
        configuracion_provision_tipo_provision: tipoProvisionLabel,
        configuracion_provision_regimen_laboral: regimenLaboralLabel,
        configuracion_provision_centro_costo: centroCostoLabel,
        configuracion_provision_periodicidad: periodicidadLabel,
        configuracion_provision_estado: estadoLabel,
        configuracion_provision_cuenta_gasto: formValue.cuentaGasto || this.rowData[this.indiceEdicion].configuracion_provision_cuenta_gasto,
        configuracion_provision_cuenta_pasivo: formValue.cuentaPasivo || this.rowData[this.indiceEdicion].configuracion_provision_cuenta_pasivo,
        configuracion_provision_descripcion: formValue.descripcion || ''
      };
      this.toastService.success('¡Provisión actualizada exitosamente!');
    } else {
      // Crear nuevo registro
      const nuevoRegistro = {
        configuracion_provision_codigo: `PROV-${String(this.contadorCodigo).padStart(3, '0')}`,
        configuracion_provision_periodo_vigencia: periodoVigencia,
        configuracion_provision_fecha_inicio: fechaInicioStr,
        configuracion_provision_fecha_fin: fechaFinStr,
        configuracion_provision_tipo_provision: tipoProvisionLabel,
        configuracion_provision_regimen_laboral: regimenLaboralLabel,
        configuracion_provision_centro_costo: centroCostoLabel,
        configuracion_provision_periodicidad: periodicidadLabel,
        configuracion_provision_estado: estadoLabel,
        configuracion_provision_cuenta_gasto: formValue.cuentaGasto || '',
        configuracion_provision_cuenta_pasivo: formValue.cuentaPasivo || '',
        configuracion_provision_descripcion: formValue.descripcion || ''
      };
      this.rowData = [nuevoRegistro, ...this.rowData];
      this.contadorCodigo++;
      this.toastService.success('¡Provisión registrada exitosamente!');
    }

    // Actualizar la tabla
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }

    // Resetear flag de modificado antes de limpiar formulario
    this.formularioModificado = false;
    
    // Limpiar formulario
    await this.nuevoRegistro();
  }

  capitalizarPrimeraLetra(texto: string): string {
    if (!texto) return '';
    return texto.charAt(0).toUpperCase() + texto.slice(1);
  }

  guardarValoresIniciales() {
    this.valoresIniciales = {
      ...this.provisionForm.getRawValue(),
      fechaInicioVigencia: this.fechaInicioVigencia,
      fechaFinVigencia: this.fechaFinVigencia,
      mostrarFormulaCalculo: this.mostrarFormulaCalculo
    };
  }

  detectarCambios() {
    const valoresActuales = {
      ...this.provisionForm.getRawValue(),
      fechaInicioVigencia: this.fechaInicioVigencia,
      fechaFinVigencia: this.fechaFinVigencia,
      mostrarFormulaCalculo: this.mostrarFormulaCalculo
    };
    
    this.formularioModificado = JSON.stringify(valoresActuales) !== JSON.stringify(this.valoresIniciales);
  }

  async mostrarAlertaCambiosSinGuardar(): Promise<boolean> {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Confirmar cambios',
        title: '¿Seguro que quieres continuar sin guardar la información?',
        message: 'Si sales ahora, perderás la información ingresada',
        btnOkTxt: 'Continuar',
        btnCancelTxt: 'Cancelar'
      }
    });

    await modal.present();
    const { data } = await modal.onWillDismiss();
    return data === true;
  }

  async canDeactivate(): Promise<boolean> {
    if (this.formularioModificado) {
      const resultado = await this.mostrarAlertaCambiosSinGuardar();
      if (resultado) {
        // Si el usuario confirma salir, resetear el estado
        this.formularioModificado = false;
      }
      return resultado;
    }
    return true;
  }

  parseFecha(fechaStr: string): Date | null {
    if (!fechaStr) return null;
    // Parsear fecha en formato dd/mm/yyyy
    const partes = fechaStr.split('/');
    if (partes.length === 3) {
      const dia = parseInt(partes[0], 10);
      const mes = parseInt(partes[1], 10) - 1; // Los meses en JS van de 0-11
      const anio = parseInt(partes[2], 10);
      return new Date(anio, mes, dia);
    }
    // Si es solo un año (como en los datos de ejemplo)
    if (fechaStr.length === 4 && !isNaN(Number(fechaStr))) {
      return new Date(parseInt(fechaStr, 10), 0, 1);
    }
    return null;
  }

  async modalverActualizaciones() {
     // Definir las columnas
     const colDefs = [
       { headerName: 'Fecha y hora', field: 'fechaHora', width: 150, },
       { headerName: 'Usuario', field: 'usuario', width: 120, },
       { headerName: 'Acción', field: 'accion', width: 150, },
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
 
     // Obtener el código de la fila seleccionada si existe
     let codigo = '';
     if (this.modoEdicion && this.indiceEdicion >= 0 && this.rowData[this.indiceEdicion]) {
       codigo = this.rowData[this.indiceEdicion].configuracion_provision_codigo;
     } else if (this.rowData.length > 0) {
       codigo = this.rowData[0].configuracion_provision_codigo;
     }
     const titulo = codigo
       ? `Historial de actualizaciones de provisiones ${codigo}`
       : 'Historial de actualizaciones de provisiones';
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

}
