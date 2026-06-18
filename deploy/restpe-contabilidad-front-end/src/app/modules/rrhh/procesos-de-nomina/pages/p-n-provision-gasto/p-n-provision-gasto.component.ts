import { Component, OnInit, ViewChild, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { tr } from 'date-fns/locale';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { ProvisionGastoEntity } from 'src/app/modules/rrhh/domain/models/provision-gasto.entity';



@Component({
  selector: 'app-p-n-provision-gasto',
  templateUrl: './p-n-provision-gasto.component.html',
  styleUrls: ['./p-n-provision-gasto.component.scss'],
  standalone: false,
})
export class PNProvisionGastoComponent  implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  // Formatea una fecha a yyyy/mm/dd si es válida


  private readonly rrHhFacade = inject(RrHhFacade);
  readonly isLoading = this.rrHhFacade.loadingProvisionGasto;
  isResetting = false;

    botonGuardarDeshabilitado: boolean = false;
    botonRevertirDeshabilitado: boolean = false;
    botonNuevoAsientoDeshabilitado: boolean = true;
  @ViewChild('autocompleteCuentas') autocompleteCuentas: any;
  countries= ALL_COUNTRIES;
  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  fechaInicial: Date | undefined; 
  panelLateralVisible: boolean = true;

  AsientoForm!: FormGroup;
  private gridApi!: GridApi;
  private detalleGridApi!: GridApi;
  gridContext!: { componentParent: PNProvisionGastoComponent};
  filaSeleccionada: any = null;
  cuentasFiltradas: any[] = []
  context: any;
  mesSeleccionadoC: number | null = null;
  anioSeleccionadoC: number | null = null;
  deshabilitado: boolean = false;

  // Array de centros de costos
  centrosCostos = [
    { codigo: 'Administración', nombre: 'Administración'},
    { codigo: 'Ventas', nombre: 'Ventas'},
    { codigo: 'Producción', nombre: 'Producción'},
    { codigo: 'Logística', nombre: 'Logística'},
    { codigo: 'Finanzas', nombre: 'Finanzas'}
  ];

  sucursales = [
    { id: '0', nombre: 'Todas las sucursales' },
    { id: '1', nombre: 'La Molina, Lima' },
    { id: '2', nombre: 'San Isidro, Lima' },
    { id: '3', nombre: 'San Borja, Lima' },
    { id: '4', nombre: 'Santa Isabel, Piura' },
  ];
  
  tipoP:any=[
    // "Gratificaciones",
    // "CTS",
    // "Vacaciones",
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

  cuentas = [
    { cuenta: '621109', descripcion: 'Servicios de internet', debeS: '380.00', haberS: ''},
    { cuenta: '411101', descripcion: 'Proveedores Nacionales / Cuentas por Pagar Comerciales', debeS: '', haberS: '380.00' }
  ];


  rowData: ProvisionGastoEntity[] = [];

  rowDataGT: ProvisionGastoEntity[] = [
    { provision_gasto_codigo: 'EJ-00048', provision_gasto_tipo: 'Bono 14', provision_gasto_periodo: 'Julio 2025', provision_gasto_sucursal: 'La Molina, Lima', provision_gasto_fecha: '2025-11-28', provision_gasto_asiento: 'MN-2025-01-458', provision_gasto_estado: 'Ejecutado' },
    { provision_gasto_codigo: 'EJ-00047', provision_gasto_tipo: 'Aguinaldo', provision_gasto_periodo: 'Julio 2025', provision_gasto_sucursal: 'San Isidro, Lima', provision_gasto_fecha: '2025-11-28', provision_gasto_asiento: 'MN-2025-01-458', provision_gasto_estado: 'Ejecutado' },
    { provision_gasto_codigo: 'EJ-00046', provision_gasto_tipo: 'Vacaciones', provision_gasto_periodo: 'Julio 2025', provision_gasto_sucursal: 'San Borja, Lima', provision_gasto_fecha: '2025-11-28', provision_gasto_asiento: 'MN-2025-01-458', provision_gasto_estado: 'Ejecutado' },
    { provision_gasto_codigo: 'EJ-00045', provision_gasto_tipo: 'Bono 14', provision_gasto_periodo: 'Julio 2025', provision_gasto_sucursal: 'Todas las sucursales', provision_gasto_fecha: '2025-11-28', provision_gasto_asiento: 'MN-2025-01-458', provision_gasto_estado: 'Revertido' }
  ];

  colDefs: ColDef[] = [
    { field: 'provision_gasto_codigo', headerName: 'Código', width: 100 },
    { field: 'provision_gasto_tipo', headerName: 'Tipo de provisión', width: 180, filter: true},
    { field: 'provision_gasto_periodo', headerName: 'Periodo', width: 100, filter:true,
      valueFormatter: (params: any) => {
        // Muestra el periodo como '202507' o vacío si no existe
        return params.value || '';
      }
    },
    { field: 'provision_gasto_sucursal', headerName: 'Sucursal', width: 250, filter: true,
      valueFormatter: (params: any) => {
        const sucursal = this.sucursales.find(s => s.id == params.value);
        return sucursal ? sucursal.nombre : params.value || '';
      },
      filterValueGetter: (params: any) => {
        const sucursal = this.sucursales.find(s => s.id == params.data?.provision_gasto_sucursal);
        return sucursal ? sucursal.nombre : params.data?.provision_gasto_sucursal || '';
      }
    },
    { field: 'provision_gasto_fecha', headerName: 'Fecha', width: 100,
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
    { field: 'provision_gasto_asiento', headerName: 'Asiento', width: 140, cellRenderer: VistaCellRenderComponent,},
    { field: 'provision_gasto_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center'},
      cellRenderer: (params: any) => {
        if (params.value === 'Revertido') {
          return '<span class="badge-table bg-[#FFF0BF] text-[#F2A626]">Revertido</span>';
        } else if (params.value === 'Ejecutado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Ejecutado</span>';
        } 
        return params.value;
      }
    }
  ];

  colDefsDetalle: ColDef[] = [
  { field: 'cuenta', headerName: 'Cuenta', width: 120},
  { field: 'descripcion', headerName: 'Descripción', width: 250, },
  { field: 'debeS', headerName: 'Debe (S/)', headerClass:'derechaencabezado', width: 130,
    cellStyle: {textAlign: 'right',display: 'flex',justifyContent: 'right'},
    valueFormatter: (params: any) => {
      if(params.value) {
      return `S/ ${params.value}`;
      }
      return '-';
    }
  },
  { field: 'haberS', headerName: 'Haber (S/)', headerClass:'derechaencabezado', width: 130,
    cellStyle: {textAlign: 'right',display: 'flex',justifyContent: 'right'},
    valueFormatter: (params: any) => {
      if(params.value) {
      return `S/ ${params.value}`;
      }
      return '-';
    }
  },
  
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
    // Inicializar formulario 
    this.AsientoForm = this.formBuilder.group({
      provision_gasto_sucursal: ['', Validators.required],
      periodoN: ['', Validators.required],
      provision_gasto_tipo: ['', Validators.required],
      fechaC: ['', Validators.required],
      provision_gasto_centro_costo: [''],
      provision_gasto_estado: ['Ejecutado'],
    });

    this.gridContext = { componentParent: this };
    this.formValidationService.inicializarFormulario(this.AsientoForm);
    this.context = { componentParent: this };
    this.tipoprovision();
    this.cargarDatosSegunPais();
    
    // Escuchar cambios en el formulario para actualizar el estado del botón
    this.AsientoForm.valueChanges.subscribe(() => {
      this.actualizarEstadoBoton();
    });

    this.rrHhFacade.cargarProvisionGasto();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.provisionGasto();
        this.cargarDatosSegunPais();
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', [...this.rowData]);
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
        clearInterval(timer);
      }
    }, 100);
  }

  cargarDatosSegunPais() {
    const country = this.countryService.getCountryCode();
    if (country === 'GT') {
      this.rowData = this.rowDataGT;
    }
  }

  togglePanelLateral(){
    this.panelLateralVisible = !this.panelLateralVisible;
  }
  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Lógica para filtrar datos
  }
  formatearFecha(fecha: string): string {
    if (!fecha) return '-';
    
    const [año, mes, dia] = fecha.split('-');
    return `${dia}/${mes}/${año}`;
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }
  tipoprovision(){
    const country = this.countryService.getCountryCode();

    this.countries.find(c => {

      if(c.codigo === country){
        this.tipoP = c.tipoprovision;
      }});
  }
  onPeriodoSeleccionado(event: any) {
    console.log('Periodo seleccionado:', event);
  }
  onSucursalSeleccionada(sucursal: any) {
    console.log('Sucursal seleccionada:', sucursal);
    this.AsientoForm.get('provision_gasto_sucursal')?.setValue(sucursal.id);
  }
  onMonthYearChangePeriodoC(event: { month: number; year: number }) {
    // event.month es number, lo convertimos a string de dos dígitos solo para el periodo
    this.mesSeleccionadoC = event.month;
    this.anioSeleccionadoC = event.year;
    const mesStr = event.month.toString().padStart(2, '0');
    const periodo = `${this.anioSeleccionadoC}${mesStr}`;
    this.AsientoForm.get('periodoN')?.setValue(periodo);
  }

  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
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
  onDetalleGridReady(params: GridReadyEvent) {
    this.detalleGridApi = params.api;
    // Pasar el contexto del componente al grid para que los cellRenderers puedan acceder a los métodos
    this.detalleGridApi.setGridOption('context', { componentParent: this });
  }

  async onCellClicked(event: any) {
    const data = event?.data;
    if (!data) { return; }

    const clickedNode = event.node;

    // Guardar referencia del elemento que tiene el foco
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Usuario canceló - restaurar fila anterior por referencia de objeto
      if (this.filaSeleccionada) {
        const prevData = this.filaSeleccionada;
        setTimeout(() => {
          this.gridApi?.deselectAll();
          this.gridApi?.forEachNode((node) => {
            if (node.data === prevData) {
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
      }
      return;
    }

    // Usuario confirmó - cargar datos y seleccionar la nueva fila
    this.formValidationService.pausarDeteccion();
    this.cargarDatosletra(data, clickedNode);
    this.deshabilitado = true;
    this.cuentasFiltradas = this.cuentas;
    setTimeout(() => {
      this.gridApi?.deselectAll();
      clickedNode?.setSelected(true);
      this.formValidationService.reanudarDeteccion();
    }, 0);
  }

    private formatearFechaC(fecha: string): string {
    if (!fecha) return '';
    // Si ya está en formato yyyy/mm/dd
    if (/^\d{4}\/\d{2}\/\d{2}$/.test(fecha)) return fecha;
    // Si está en formato yyyy-mm-dd
    if (/^\d{4}-\d{2}-\d{2}$/.test(fecha)) return fecha.replace(/-/g, '/');
    // Si viene en otro formato, intentar parsear
    const d = new Date(fecha);
    if (isNaN(d.getTime())) return fecha;
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return `${y}/${m}/${day}`;
  }

  // Método para cargar datos en el formulario
  private cargarDatosletra(data: any, node?: any): void {
    this.filaSeleccionada = data;

    // Extraer mes y año del período (ej: "Julio 2025" -> mes="Julio", año=2025)
    if (data.provision_gasto_periodo) {
      const periodoPartes = data.provision_gasto_periodo.split(' ');
      if (periodoPartes.length === 2) {
        this.mesSeleccionadoC = periodoPartes[0];
        this.anioSeleccionadoC = parseInt(periodoPartes[1], 10);
      }
    }

    this.AsientoForm.patchValue({
      provision_gasto_sucursal: data.provision_gasto_sucursal,
      provision_gasto_tipo: data.provision_gasto_tipo,
      fechaC: this.formatearFechaC(data.provision_gasto_fecha),
      periodoN: data.provision_gasto_periodo || '',
      provision_gasto_centro_costo: data.provision_gasto_centro_costo || '',
      provision_gasto_estado: data.provision_gasto_estado,
    });

    // Controlar habilitación de botones y formulario según estado
    if (data.provision_gasto_estado === 'Revertido') {
      this.AsientoForm.disable();
      this.deshabilitado = true;
      this.botonGuardarDeshabilitado = true;
      this.botonRevertirDeshabilitado = true;
    } else if (data.provision_gasto_estado === 'Ejecutado') {
      this.AsientoForm.disable();
      this.deshabilitado = false;
      this.botonGuardarDeshabilitado = true;
      this.botonRevertirDeshabilitado = false;
    } else {
      this.AsientoForm.enable();
      this.deshabilitado = false;
      this.botonGuardarDeshabilitado = false;
      this.botonRevertirDeshabilitado = false;
    }

    this.formValidationService.resetearEstado();
    
    // Actualizar estado del botón "Nuevo asiento por provisión"
    this.actualizarEstadoBoton();
  }

  async botonNuevoCalculo() {
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Cancelar acción
    }

    // Reiniciar el formulario a los valores por defecto
    if (this.AsientoForm) {
      // Obtener fecha de hoy en formato YYYY-MM-DD
      const hoy = new Date().toISOString().split('T')[0];

      this.AsientoForm.reset();
      this.AsientoForm.enable();
      
      this.filaSeleccionada = null;
      
      // Deseleccionar fila de la tabla
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }

      // Resetear estado del servicio de validación
      this.formValidationService.resetearEstado();
      this.deshabilitado = false;
      this.cuentasFiltradas = [];
      
      // Actualizar estado del botón
      this.actualizarEstadoBoton();
    }
  }

  /**
   * Actualiza el estado del botón "Nuevo asiento por provisión"
   * Se habilita si: hay una fila seleccionada O si hay al menos un campo del formulario relleno
   */
  private actualizarEstadoBoton(): void {
    const tieneFilaSeleccionada = !!this.filaSeleccionada;
    const tieneFormulaRelleno = this.tieneCamposRellenos();
    
    this.botonNuevoAsientoDeshabilitado = !(tieneFilaSeleccionada || tieneFormulaRelleno);
  }

  /**
   * Verifica si al menos un campo del formulario tiene un valor
   */
  private tieneCamposRellenos(): boolean {
    if (!this.AsientoForm) return false;
    
    const controls = this.AsientoForm.getRawValue();
    return Object.values(controls).some(valor => valor && valor !== '');
  }

  botonGuardar() {
    // Validar que el formulario sea válido
    if (this.AsientoForm.invalid) {
      // Mostrar cuáles campos tienen errores
      const camposConError: string[] = [];
      const nombresAmigables: { [key: string]: string } = {
        provision_gasto_sucursal: 'Sucursal',
        periodoC: 'Periodo',
        provision_gasto_tipo: 'Tipo',
        fechaC: 'Fecha contable',
        provision_gasto_centro_costo: 'Centro de costo',
        provision_gasto_estado: 'Estado',
      };
      Object.keys(this.AsientoForm.controls).forEach(key => {
        const control = this.AsientoForm.get(key);
        if (control && control.invalid) {
          // Usar nombre amigable si existe, si no el key
          camposConError.push(nombresAmigables[key] || key);
        }
      });
      console.log('Campos con error:', camposConError);
      this.toastService.warning(`Por favor, completa todos los campos requeridos: ${camposConError.join(', ')}`);
      return;
    }

    const formValue = this.AsientoForm.getRawValue();
    const codigo = this.filaSeleccionada ? this.filaSeleccionada.provision_gasto_codigo : `EJ-${String(this.rowData.length + 1).padStart(5, '0')}`;

    // Crear objeto completo con todos los campos del formulario
    const provisonGasto = {
      provision_gasto_codigo: codigo || '',
      provision_gasto_tipo: formValue.provision_gasto_tipo || '',
      provision_gasto_periodo: formValue.periodoC || '',
      provision_gasto_sucursal: formValue.provision_gasto_sucursal || '',
      provision_gasto_centro_costo: formValue.provision_gasto_centro_costo || '-',
      provision_gasto_fecha: formValue.fechaC || '', // Usar la fecha contable correctamente
      provision_gasto_asiento: formValue.provision_gasto_asiento || 'MN-2025-01-458',
      provision_gasto_estado: formValue.provision_gasto_estado || 'Ejecutado',
    };

    if (this.filaSeleccionada) {
      // EDITAR: Actualizar provision existente
      const index = this.rowData.findIndex(item => item.provision_gasto_codigo === this.filaSeleccionada.provision_gasto_codigo);
      
      if (index !== -1) {
        this.rowData[index] = provisonGasto;
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.toastService.success('¡Asieneto actualizado exitosamente!');
      }
    } else {
      // AGREGAR: Crear nueva provision
      this.rowData.unshift(provisonGasto);
      this.gridApi.setGridOption('rowData', [...this.rowData]);
      this.toastService.success('¡Asiento registrado exitosamente!');
    }
    
    this.limpiarFormulario();
    this.deshabilitado = true;
    this.cuentasFiltradas = [];
    // No abrir/cerrar el panel lateral automáticamente al guardar
    this.formValidationService.resetearEstado();
  }

  // Método para limpiar y resetear el formulario
  private limpiarFormulario(): void {
    this.mesSeleccionadoC = null;
    this.anioSeleccionadoC = null;
    this.AsientoForm.reset({
      periodoC: '',
      fechaC: '',
      provision_gasto_estado: 'Ejecutado',
    });
    // Forzar el valor del calendario visual a null si es necesario
    if (typeof (this as any).fechaContablePicker !== 'undefined') {
      (this as any).fechaContablePicker.value = null;
    }
    this.cuentasFiltradas = [];
    if (this.detalleGridApi) {
      this.detalleGridApi.setGridOption('rowData', []);
    }
    this.filaSeleccionada = null;
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
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
        { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Se ha creado el grupo 1.00'},
        { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se edito la descripción del grupo'},
        { fechaHora: '13/11/2025 09:00', usuario: 'Carlos Rodríguez', accion: 'Actualización', detalleCambio: 'Se cambió el tipo de flujo'},
      ];
  
      const modal = await this.modalController.create({
        component: ModalVerActualizacionesComponent,
        cssClass: 'promo',
        componentProps: {
          titulo: `Historial de Actualizaciones de la letra ${this.filaSeleccionada.provision_gasto_codigo}`,
          rowData: rowData,
          colDefs: colDefs,
          anchoModal: '700px',
          
        }
      });
      
      await modal.present();
      
      // Manejar la respuesta cuando se cierre el modal
      const { data } = await modal.onWillDismiss();
      if (data) {
        console.log('Modal cerrado con datos:', data);
      }
  }

  onFechaSeleccionadaC(date: Date) {
    console.log('Fecha seleccionada:', date);
    if (this.AsientoForm && date) {
      // Formatear a yyyy/mm/dd
      const d = new Date(date);
      if (!isNaN(d.getTime())) {
        const y = d.getFullYear();
        const m = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');
        const fechaFormato = `${y}/${m}/${day}`;
        this.AsientoForm.get('fechaC')?.setValue(fechaFormato);
      }
    }
  }

  onBtReset() {
    this.isResetting = true;
    this.rrHhFacade.cargarProvisionGasto();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.provisionGasto();
        this.cargarDatosSegunPais();
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

  botonGenerarP(){
    this.cuentasFiltradas = this.cuentas;
  }

  async botonRevertir(){
    const detallesEjemplo = [
      { label: 'Fecha de registro', value: '12/12/2025' },
      { label: 'Fecha contable', value: '12/12/2025' },
      { label: 'Glosa', value: 'Provisión de servicios de internet – Local San Isidro (Mes 11/2025).' },
      { label: 'Total', value: 'S/380.00' },
      // { label: 'Duplicado', value: 'No' },
    ];
    
    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Reversión de asiento ${this.filaSeleccionada.provision_gasto_asiento}`,
        subtituloModal: 'Detalle de asiento',
        widthModal: '492px',
        tituloTextaera: 'Motivo de la reversión',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Revertir',
        colorBotonConfirmar: 'primary',
        motivoObligatorio: true,
      }
    });

    await modal.present();
        
    const { data, role } = await modal.onWillDismiss();
    
    // Verificar si se confirmó la acción
    if (data && data.action === 'confirmar') {
      // Actualizar el estado de la letra a 'Revertido'
      this.filaSeleccionada.provision_gasto_estado = 'Revertido';

      // Encontrar y actualizar la fila en la tabla principal
      const index = this.rowData.findIndex(item => item.provision_gasto_codigo === this.filaSeleccionada.provision_gasto_codigo);
      if (index !== -1) {
        this.rowData[index].provision_gasto_estado = 'Revertido';
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }
      
      // Mostrar mensaje de éxito
      this.toastService.success('¡La acción se realizó con éxito!');
      console.log('Motivo de rreversión:', data.motivo);
    } else if (role === 'backdrop' || role === 'escape') {
      // Modal cerrado sin confirmación
      console.log('Reversión cancelada');
    }
  }
  async abrirModal(value: any, rowData: any) {
      const detalleAsiento=[
      { label: 'Fecha de registro', value: '12/12/2025'},
      { label: 'Fecha contable', value: '12/12/2025'},
      { label: 'Glosa', value: 'Provisión de servicios de internet - Local San Isidro (Mes 11/2025)'},
      { label: 'Total', value: 'S/ 380.00'},
      // { label: 'Duplicado', value: 'No'},
    ]

    const colDefs: ColDef[] = [
      {  field: 'cuentaContable',  headerName: 'Cuenta',  width: 70 },
      {  field: 'descripcion',  headerName: 'Descripción',  minWidth: 260, flex: 1 ,},
      { field: 'debe', headerName: 'Debe (S/)',  width: 80, headerClass: 'centrarencabezado',
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        valueFormatter: (params) => {
          if (params.value !== null && params.value !== undefined) {
            const absValue = Math.abs(params.value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);
            
            // Si es negativo, mostrar entre paréntesis
            if (params.value < 0) {
              return `(${formattedValue})`;
            }
            return formattedValue;
          }
          return '-';
        },
      },
      { field: 'haber', headerName: 'Haber (S/)', width: 80,
        headerClass: 'centrarencabezado',cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        valueFormatter: (params) => {
          if (params.value !== null && params.value !== undefined) {
            const absValue = Math.abs(params.value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);
            
            // Si es negativo, mostrar entre paréntesis
            if (params.value < 0) {
              return `(${formattedValue})`;
            }
            return formattedValue;
          }
          return '-';
        },
      },
      {  field: 'centroC',  headerName: 'Centro de costo',  width: 100 },
      {  field: 'docRef',  headerName: 'Documento referencial',  width: 145 },
      {  field: 'tercero',  headerName: 'Tercero',  width: 80 },

    ];
  
    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Asiento ${value}`,
        detalles: detalleAsiento,
        mostrarTabla: true,
        subtitulomodal: '',
        widthModal: '877px',
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        mostrarTotal: true,
        itemstotal: [
          { label: 'Total debe (S/)', value: '380.00' },
          { label: 'Total haber (S/)', value: '380.00' },
        ],
        colDefs: colDefs,
        rowData: [
          {
            cuentaContable: '631109',
            descripcion: 'Servicios de internet',
            debe: 380.00,
            haber: null,
            centroC: 'CC-SI01',
            docRef: 'F001- 000123',
            tercero: 'Claro Perú',
          },
          {
            cuentaContable: '421101',
            descripcion: 'Proveedores Nacionales / Cuentas por Pagar Comerciales',
            debe: null,
            haber: 380.00,
            centroC: 'CC-SI01',
            docRef: 'F001- 000123',
            tercero: 'Claro Perú',
          }
        ]
      }
    });

    await modal.present();
  }
}
