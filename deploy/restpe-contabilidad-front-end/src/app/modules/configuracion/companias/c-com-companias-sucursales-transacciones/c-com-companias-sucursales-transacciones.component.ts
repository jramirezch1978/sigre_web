import { Component, ElementRef, OnInit, OnDestroy, ViewChild, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';
import {
  ColDef,
  GridApi,
  GridReadyEvent,
  RowClickedEvent,
} from 'ag-grid-community';
import { ModalNuevaSucursalComponent } from './modal/modal-nueva-sucursal.component';
import { AutocompleteComponent } from 'src/app/ui/autocomplete/autocomplete.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ConfiguracionFacade } from '../../application/facades/configuracion.facade';
import { ConfiguracionCompaniasGridEffects } from '../../effects/configuracion-companias-grid.effect';
import { CompaniaEntity } from '../../domain/models/compania.entity';

// Font Awesome Icons
import { faBook, faCircleXmark, faInfoCircle, faSearch as faSearchRegular } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faCloudArrowUp, faDownload, faEdit, faRotateRight, faSearch as faSearchSolid, faXmark } from '@fortawesome/pro-solid-svg-icons';

// Font Awesome Icons



@Component({
  selector: 'app-c-com-companias-sucursales-transacciones',
  templateUrl: './c-com-companias-sucursales-transacciones.component.html',
  styleUrls: ['./c-com-companias-sucursales-transacciones.component.scss'],
  standalone: false,
})
export class CComCompaniasSucursalesTransaccionesComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farBook = faBook;
  farCircleXmark = faCircleXmark;
  farInfoCircle = faInfoCircle;
  farSearch = faSearchRegular;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasCloudArrowUp = faCloudArrowUp;
  fasDownload = faDownload;
  fasEdit = faEdit;
  fasRotateRight = faRotateRight;
  fasSearch = faSearchSolid;
  fasXmark = faXmark;

  // Inyección del Facade y Effects
  private readonly configuracionFacade = inject(ConfiguracionFacade);
  private readonly companiasGridEffects = inject(ConfiguracionCompaniasGridEffects);
  
  // Selectores del store
  readonly companias = this.configuracionFacade.companias;
  readonly loadingCompanias = this.configuracionFacade.loadingCompanias;
  readonly isLoading = this.configuracionFacade.isLoading;
  isResetting = false;

  @ViewChild('scrollBox', { read: ElementRef }) scrollBox!: ElementRef;
  @ViewChild('autocompleteSucursales') autocompleteSucursales!: AutocompleteComponent;

  // Propiedades de UI
  mostrarpanelizquierdo = true;
  panelLateralVisible = false;
  filaSeleccionada: any = null;
  imagenUrl: string | null = null;
  tabSucursalesDesbloqueado = false;
  tabTransaccionesDesbloqueado = false;
  modoCreacion: boolean = true;
  tabSeleccionado: string = 'general';


  mesSeleccionadoC: number | null = null;
  anioSeleccionadoC: number | null = null;

  // Fechas para el calendario
  startDate = new Date(new Date().getFullYear(), new Date().getMonth(), 1);
  endDate = new Date();
  minDate = new Date(2020, 0, 1);
  maxDate = new Date();

  // FormGroup
  datosCompaniaForm!: FormGroup;

  // AG Grid
  localeText = {
    page: 'Página',
    to: 'a',
    of: 'de',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    loadingOoo: 'Cargando...',
    noRowsToShow: 'No hay datos para mostrar',
  };
  private gridApi!: GridApi;

    tabs = [
    { value: 'general', label: 'Datos Generales' },
    { value: 'sucursales', label: 'Sucursales' },
    { value: 'transacciones', label: 'Transacciones' },
  ];

  // Método para determinar si un tab está deshabilitado
  isTabDisabled(tabValue: string): boolean {
    if (tabValue === 'general') {
      return false; // General siempre está habilitado
    }
    if (tabValue === 'sucursales') {
      return !this.tabSucursalesDesbloqueado;
    }
    if (tabValue === 'transacciones') {
      return !this.tabTransaccionesDesbloqueado;
    }
    return false;
  }

  // Datos de la tabla principal (gestionado por effect)
  columnDefs: ColDef[] = [
    { field: 'compania_codigo', headerName: 'Código', width: 100 },
    { field: 'compania_razon_social', headerName: 'Razón social', flex: 1 },
    { field: 'compania_direccion_fiscal', headerName: 'Dirección fiscal', flex: 1 },
    {
      field: 'compania_correo_electronico',
      headerName: 'Correo electrónico',
      width: 180,
    },
    { field: 'compania_contable_desde', headerName: 'Contable desde', width: 130 },
    {
      field: 'compania_estado',
      filter: true,
      headerClass: 'centrarencabezado',
      headerName: 'Estado',
      width: 80,
      cellRenderer: (params: any) => {
        const color =
          params.value === 'Activo'
            ? 'bg-[#DCFDE7] text-[#16A34A]'
            : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
      cellStyle: {
        textAlign: 'center',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
    },
  ];
  columnTypes = {};

  // Datos tabla sucursales
  rowDataSucursales: any[] = [];
  columnDefsSucursales: ColDef[] = [
    { field: 'codigo', headerName: 'Código', width: 100 },
    { field: 'nombre', headerName: 'Nombre', flex: 1 },
    { field: 'direccion', headerName: 'Dirección', flex: 1 },
    { field: 'estado', headerName: 'Estado', width: 100 },
  ];

  // Sucursales disponibles y asociadas
  sucursalesDisponibles: any[] = [];
  sucursalesAsociadas: any[] = [];

  // Opciones para los selects
  zonasHorarias = [
    { value: 'UTC-5', label: 'Lima, Perú' },
    { value: 'UTC-4', label: 'Santiago, Chile' },
    { value: 'UTC-5', label: 'Bogotá, Colombia' },
    { value: 'UTC-5', label: 'Quito, Ecuador' },
    { value: 'UTC-6', label: 'San José, Costa Rica' },
  ];

  idiomas = [
    { value: 'es', label: 'Español' },
    { value: 'en', label: 'Inglés' },
    { value: 'pt', label: 'Portugués' },
  ];

  estados = [
    { value: 'activo', label: 'Activo' },
    { value: 'inactivo', label: 'Inactivo' },
  ];

  constructor(
    private fb: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService
  ) {}

  ngOnInit() {
    this.inicializarFormulario();
    
    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.datosCompaniaForm);
    this.formValidationService.resetearEstado();
    
    // Cargar compañías desde el JSON
    this.configuracionFacade.cargarCompanias();
    
    // Cargar datos de ejemplo para sucursales
    this.cargarDatosEjemploSucursales();
    
    this.botonNuevaCompania(); // Iniciar con formulario de nueva compañía
  }

  /**
   * @summary Getter para acceder a rowData desde el template
   * @description El rowData está gestionado por ConfiguracionCompaniasGridEffects
   */
  get rowData(): CompaniaEntity[] {
    return this.companiasGridEffects.getRowData();
  }

  inicializarFormulario() {
    this.datosCompaniaForm = this.fb.group({
      ruc: [
        '',
        [
          Validators.required,
          Validators.minLength(11),
          Validators.maxLength(11),
        ],
      ],
      razonSocial: ['', Validators.required],
      correoElectronico: ['', [Validators.required, Validators.email]],
      direccionFiscal: ['', Validators.required],
      zonaHoraria: ['', Validators.required],
      nombreComercial: ['', Validators.required],
      periodoContable: ['', Validators.required],
      idioma: ['', Validators.required],
      estado: ['', Validators.required],
    });
  }

  cargarDatosEjemploSucursales() {
    // Datos de ejemplo para sucursales
    this.rowDataSucursales = [
      { codigo: 'S001', nombre: 'Sucursal Principal', direccion: 'Av. Principal 123', estado: 'Activo', },
      { codigo: 'S002', nombre: 'Sucursal Norte', direccion: 'Jr. Los Olivos 456', estado: 'Activo', },
    ];

    // Datos de ejemplo para sucursales disponibles
    this.sucursalesDisponibles = [
      { id: 1, nombre: 'Santa Isabel, Piura' },
      { id: 2, nombre: 'CC. Real Plaza, Piura' },
      { id: 3, nombre: 'Av. Brasil, Lima' },
      { id: 4, nombre: 'San Isidro, Lima' },
      { id: 5, nombre: 'Ferreñafe, Chiclayo' },
    ];

    // Datos de ejemplo para sucursales asociadas
    this.sucursalesAsociadas = [];
  }

  async botonNuevaCompania() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.imagenUrl = null;
    this.tabSeleccionado = 'general';
    this.tabSucursalesDesbloqueado = false;
    this.tabTransaccionesDesbloqueado = false;
    this.sucursalesAsociadas = [];

    // Resetear el picker de período contable
    this.mesSeleccionadoC = null;
    this.anioSeleccionadoC = null;

    // Deseleccionar cualquier fila en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Establecer valores por defecto
    this.datosCompaniaForm.reset({
      ruc: '',
      razonSocial: '',
      correoElectronico: '',
      direccionFiscal: '',
      zonaHoraria: '', // Lima, Perú por defecto
      nombreComercial: '',
      periodoContable: '', // Usuario debe seleccionarlo manualmente
      idioma: 'es', // Español por defecto
      estado: 'activo', // Activo por defecto
    });
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();

    console.log('Nueva compañía');
  }

  async onCellClicked(event: RowClickedEvent) {
    const data = event.data;
    const node = event.node;
    if (!data) { return; }
    
    // Guardar referencia del elemento que tiene el foco
    const elementoConFoco = document.activeElement as HTMLElement;
    
    // Validar cambios ANTES de cualquier operación de grid
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Re-seleccionar la fila anterior si existe
      if (this.filaSeleccionada && this.gridApi) {
        this.gridApi.forEachNode((node) => {
          if (node.data.compania_codigo === this.filaSeleccionada.compania_codigo) {
            node.setSelected(true);
          }
        });
      }
      
      // Restaurar foco si es un input
      if (elementoConFoco && elementoConFoco.tagName === 'INPUT') {
        setTimeout(() => elementoConFoco.focus(), 100);
      }
      return;
    }
    
    // Usuario confirmó - cargar nuevos datos
    this.gridApi.deselectAll();
    
    this.modoCreacion = false;
    this.filaSeleccionada = data;
    this.cargarDatosCompania(data);

    // Desbloquear todos los tabs al editar una compañía existente
    this.tabSucursalesDesbloqueado = true;
    this.tabTransaccionesDesbloqueado = true;
    setTimeout(() => node.setSelected(true), 0);
  }

  cargarDatosCompania(data: any) {
    this.datosCompaniaForm.patchValue({
      ruc: data.compania_ruc || '',
      razonSocial: data.compania_razon_social || '',
      correoElectronico: data.compania_correo_electronico || '',
      direccionFiscal: data.compania_direccion_fiscal || '',
      zonaHoraria: data.compania_zona_horaria || '',
      nombreComercial: data.compania_nombre_comercial || '',
      periodoContable: data.compania_contable_desde || '',
      idioma: data.compania_idioma || 'es',
      estado: data.compania_estado ? data.compania_estado.toLowerCase() : 'activo',
    });
    
    // Resetear servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }

  async botonCancelar() {
    // Deseleccionar la fila INMEDIATAMENTE
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Limpiar referencia de fila
    this.filaSeleccionada = null;
    
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      this.formValidationService.resetearEstado();
      return;
    }
    
    // Limpiar todo
    this.datosCompaniaForm.reset();
    this.modoCreacion = true;
    this.imagenUrl = null;
    this.tabSeleccionado = 'general';
    this.tabSucursalesDesbloqueado = false;
    this.tabTransaccionesDesbloqueado = false;
    this.sucursalesAsociadas = [];
    
    this.formValidationService.resetearEstado();
  }

  scrollLeft() {
    if (this.scrollBox) {
      this.scrollBox.nativeElement.scrollBy({ left: -100, behavior: 'smooth' });
    }
  }

  scrollRight() {
    if (this.scrollBox) {
      this.scrollBox.nativeElement.scrollBy({ left: 100, behavior: 'smooth' });
    }
  }

  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e: any) => {
        this.imagenUrl = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  }

  eliminarImagen() {
    this.imagenUrl = null;
  }

  onSucursalSeleccionada(sucursal: any) {
    if (sucursal) {
      // Verificar si la sucursal ya está asociada
      const yaExiste = this.sucursalesAsociadas.some(
        (s) => s.id === sucursal.id
      );
      if (!yaExiste) {
        this.sucursalesAsociadas.push(sucursal);
        console.log('Sucursal agregada:', sucursal);
        // Limpiar el autocomplete con un pequeño delay
        setTimeout(() => {
          if (this.autocompleteSucursales) {
            this.autocompleteSucursales.clearSelection();
          }
        }, 0);
      } else {
        console.log('La sucursal ya está asociada');
        this.toastService.danger('Esta sucursal ya está asociada');
        // Limpiar también si ya existe
        setTimeout(() => {
          if (this.autocompleteSucursales) {
            this.autocompleteSucursales.clearSelection();
          }
        }, 0);
      }
    }
  }

  eliminarSucursal(id: number) {
    this.sucursalesAsociadas = this.sucursalesAsociadas.filter(
      (s) => s.id !== id
    );
    console.log('Sucursal eliminada:', id);
  }

    onMonthYearChangePeriodoC(event: { month: number; year: number }) {
    this.mesSeleccionadoC = event.month;
    this.anioSeleccionadoC = event.year;

    // Formato año+mes: 202602
    const mesStr = String(event.month).padStart(2, '0');
    const periodo = `${event.year}${mesStr}`;
    this.datosCompaniaForm.get('periodoContable')?.setValue(periodo);
  }

  buscarrdfiscal() {
    const rucValue = this.datosCompaniaForm.get('ruc')?.value;
    
    console.log('Valor del RUC:', rucValue, 'Tipo:', typeof rucValue);
    
    // Convertir a string para comparar (el input type="number" puede devolver number)
    const rucString = String(rucValue);
    
    // Si el RUC es el de ejemplo, autocompletar con datos estáticos
    if (rucString === '20123456789') {
      this.datosCompaniaForm.patchValue({
        razonSocial: 'RESTAURANT EL BUEN SABOR S.A.C.'
      });
    }
  }
  validarTabGeneral(): boolean {
    const form = this.datosCompaniaForm;
    return !!(
      this.imagenUrl && // Validar que el logotipo esté cargado
      form.get('ruc')?.valid &&
      form.get('razonSocial')?.valid &&
      form.get('correoElectronico')?.valid &&
      form.get('direccionFiscal')?.valid &&
      form.get('zonaHoraria')?.valid &&
      form.get('nombreComercial')?.valid &&
      form.get('periodoContable')?.valid &&
      form.get('idioma')?.valid &&
      form.get('estado')?.valid
    );
  }

  siguienteTab() {
    if (this.tabSeleccionado === 'general') {
      // Validar que todos los campos requeridos estén completos
      if (!this.validarTabGeneral()) {
        this.toastService.warning('Por favor, completa todos los campos requeridos');
        return;
      }
      this.tabSucursalesDesbloqueado = true;
      this.tabSeleccionado = 'sucursales';
    } else if (this.tabSeleccionado === 'sucursales') {
      this.tabTransaccionesDesbloqueado = true;
      this.tabSeleccionado = 'transacciones';
    }
  }

  async abrirModalNuevaSucursal() {
    const modal = await this.modalController.create({
      component: ModalNuevaSucursalComponent,
      cssClass: 'promo2',
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data?.action === 'agregar' && data.sucursal) {
      this.sucursalesAsociadas.push(data.sucursal);
    }
  }

  botonGuardar() {
    if (this.datosCompaniaForm.valid) {
      const formData = this.datosCompaniaForm.value;

      if (!this.modoCreacion && this.filaSeleccionada) {
        // Actualizar compañía existente
        const index = this.rowData.findIndex(
          (c) => c.compania_codigo === this.filaSeleccionada.compania_codigo
        );
        if (index !== -1) {
          this.rowData[index] = {
            ...this.rowData[index],
            compania_ruc: formData.ruc,
            compania_razon_social: formData.razonSocial,
            compania_direccion_fiscal: formData.direccionFiscal,
            compania_correo_electronico: formData.correoElectronico,
            compania_contable_desde: formData.periodoContable,
            compania_estado: formData.estado === 'activo' ? 'Activo' : 'Inactivo',
            compania_zona_horaria: formData.zonaHoraria,
            compania_nombre_comercial: formData.nombreComercial,
            compania_idioma: formData.idioma,
          };

          // Actualizar la referencia de filaSeleccionada
          this.filaSeleccionada = this.rowData[index];

          // Actualizar la tabla
          if (this.gridApi) {
            this.gridApi.setGridOption('rowData', [...this.rowData]);
            
            // Re-seleccionar la fila editada
            setTimeout(() => {
              this.gridApi.forEachNode((node) => {
                if (node.data === this.rowData[index]) {
                  node.setSelected(true);
                }
              });
            }, 100);
          }
          
          this.toastService.success('¡Cambios guardados exitosamente!');
          
          // Marcar como pristine después de guardar edición
          this.datosCompaniaForm.markAsPristine();
          
          // Resetear servicio de validación
          this.formValidationService.resetearEstado();
        }
      } else {
        // Registrar nueva compañía
        const nuevoCodigo = this.generarCodigoCompania();
        const nuevaCompania = {
          compania_codigo: nuevoCodigo,
          compania_ruc: formData.ruc,
          compania_razon_social: formData.razonSocial,
          compania_direccion_fiscal: formData.direccionFiscal,
          compania_correo_electronico: formData.correoElectronico,
          compania_contable_desde: formData.periodoContable,
          compania_estado: formData.estado === 'activo' ? 'Activo' : 'Inactivo',
          compania_zona_horaria: formData.zonaHoraria,
          compania_nombre_comercial: formData.nombreComercial,
          compania_idioma: formData.idioma,
        };

        // Actualizar rowData a través del effect
        const currentData = this.companiasGridEffects.getRowData();
        this.companiasGridEffects.setRowData([...currentData, nuevaCompania]);

        this.toastService.success('¡Compañía registrada exitosamente!');
        
        // Limpiar para registro rápido
        this.modoCreacion = true;
        this.filaSeleccionada = null;
        this.imagenUrl = null;
        this.tabSeleccionado = 'general';
        this.tabSucursalesDesbloqueado = false;
        this.tabTransaccionesDesbloqueado = false;
        this.sucursalesAsociadas = [];
        
        // Mantener el período contable seleccionado para el siguiente registro
        const periodoActual = formData.periodoContable;
        
        // Establecer valores por defecto
        this.datosCompaniaForm.reset({
          ruc: '',
          razonSocial: '',
          correoElectronico: '',
          direccionFiscal: '',
          zonaHoraria: 'UTC-5',
          nombreComercial: '',
          periodoContable: periodoActual, // Mantener el período seleccionado
          idioma: 'es',
          estado: 'activo',
        });
        
        // Deseleccionar en la tabla
        if (this.gridApi) {
          this.gridApi.deselectAll();
        }
        
        // Resetear servicio de validación
        this.formValidationService.resetearEstado();
      }
    }
  }
  
  puedeGuardar(): boolean {
    return this.datosCompaniaForm.valid && this.datosCompaniaForm.dirty;
  }

  onBtReset() {
    this.isResetting = true;
    this.configuracionFacade.cargarCompanias();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

  generarCodigoCompania(): string {
    // Obtener el último número de código
    const codigos = this.rowData.map((c) => {
      const match = c.compania_codigo.match(/COM-(\d+)/);
      return match ? parseInt(match[1]) : 0;
    });

    const maxCodigo = codigos.length > 0 ? Math.max(...codigos) : 0;
    const nuevoCodigo = maxCodigo + 1;

    return `COM-${String(nuevoCodigo).padStart(3, '0')}`;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // Registrar la API de la grilla en el effect
    this.companiasGridEffects.setGridApi(params.api);
  }

    async modalverActualizaciones() {
      const colDefs = [
        { headerName: 'Fecha y hora', field: 'historial_actualizacion_fecha_hora', width: 150, },
        { headerName: 'Usuario', field: 'historial_actualizacion_usuario', width: 120, },
        {
          headerName: 'Acción', field: 'historial_actualizacion_accion', width: 150,
          wrapText: true,
          autoHeight: true,
          cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
        },
        {
          headerName: 'Detalle del cambio', field: 'historial_actualizacion_detalle_cambio', flex: 1,
          wrapText: true,
          autoHeight: true,
          cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
        },
      ];
  
      const rowData = [
        { historial_actualizacion_fecha_hora: '20/11/2025 16:01:44', historial_actualizacion_usuario: 'Ana Pérez', historial_actualizacion_accion: 'Actualización de estado', historial_actualizacion_detalle_cambio: 'Estado: De "Activo" a "Inactivo" (autorización especial).'},
        { historial_actualizacion_fecha_hora: '12/11/2025 14:40:22', historial_actualizacion_usuario: 'Jorge Gómez', historial_actualizacion_accion: 'Edición del asiento', historial_actualizacion_detalle_cambio: 'Cuenta contable: De 631201 (Suministros) a 631109 (Servicios de Internet).'},
        { historial_actualizacion_fecha_hora: '08/11/2025 14:15:30', historial_actualizacion_usuario: 'Jorge Gómez', historial_actualizacion_accion: 'Registro del asiento', historial_actualizacion_detalle_cambio: 'Se ingresó la cabecera y detalle inicial. Totales: Debe S/ 380.00 – Haber S/ 380.00.' }
      ];
  
      const modal = await this.modalController.create({
        component: ModalVerActualizacionesComponent,
        cssClass: 'promo',
        componentProps: {
          titulo: `Historial de Actualizaciones de la compañía ${this.filaSeleccionada?.compania_codigo || 'N/A'}`,
          rowData: rowData,
          colDefs: colDefs,
          anchoModal: '700px',
         
        }
      });
      
      await modal.present();
    }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }
}
