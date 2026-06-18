import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef, GridState } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { AsignacionCajaChicaEntity } from 'src/app/modules/finanzas/domain/models/asignacion-caja-chica.entity';
import { AsignacionCajaChicaFacade } from 'src/app/modules/finanzas/application/facades/asignacion-caja-chica.facade';
import { AsignacionCajaChicaFeedbackEffects } from 'src/app/modules/finanzas/effects/asignacion-caja-chica-feedback.effect';



@Component({
  selector: 'app-asignacion-caja-chica',
  templateUrl: './asignacion-caja-chica.component.html',
  styleUrls: ['./asignacion-caja-chica.component.scss'],
  standalone: false,
})
export class AsignacionCajaChicaComponent implements OnInit, OnDestroy {
  private readonly facade = inject(AsignacionCajaChicaFacade);
  private readonly feedbackEffects = inject(AsignacionCajaChicaFeedbackEffects);
  readonly isLoading = this.facade.isLoading;
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;
  pais= this.countryService.getCountryCode();
  countries= ALL_COUNTRIES;

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  
  private gridApi!: GridApi;
  filaSeleccionada: any = null;
  modoCreacion: boolean = true;
  asignacionForm!: FormGroup;
  fechaAsignacionSeleccionada: Date | undefined;
  botonRegistrarDeshabilitado: boolean = true;

  
  clientes=[
    'Falcao',
    'Diego',
    'Jp',
  ]
  
  cajas = [
    { id: 1, nombre: 'Caja 1' },
    { id: 2, nombre: 'Caja 3' },
    { id: 3, nombre: 'Caja 4' },
    { id: 4, nombre: 'Caja principal' },
  ];

  sucursales = [
    { id: '1', nombre: 'San Juan de lurigancho, Lima' },
    { id: '2', nombre: 'Santa Isabel, Piura' },
    { id: '3', nombre: 'Miraflores, Lima' },
    { id: '4', nombre: 'San Isidro, Lima' },
  ];

  sucursalSeleccionada: string = '';
  
  monedas = [
    { id: 'Soles', nombre: 'Soles' },
    { id: 'Dólares', nombre: 'Dólares' },
  ];
  
  responsables = [
    { id: 1, nombre: 'Juan Pérez' },
    { id: 2, nombre: 'María García' },
  ];
  
  estados = [
    { id: 'Activo', nombre: 'Activo' },
    { id: 'Reintegrado', nombre: 'Reintegrado' },
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
  
  defaultColDef = {
    valueFormatter: (params: any) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '-'
        : params.value;
    }
  };
  
  rowData: AsignacionCajaChicaEntity[] = [];
  
  colDefs: ColDef[] = [
    { field: 'acc_codigo', headerName: 'Código', width: 120 },
    { field: 'acc_caja', headerName: 'Caja', width: 100 },
    { field: 'acc_sucursal', headerName: 'Sucursal', width: 100 },
    { field: 'acc_fechaAsignacion', headerName: 'Fecha  de asignación', width: 130, },
    { field: 'acc_montoAsignado', headerName: 'Monto asignado', width: 100,
      headerClass: 'derechaencabezado',
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
        return '';
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'end', };
        if (params.value < 0) {
          style.color = '#EF4444'; // Rojo para negativos
        }
        return style;
      }
    },
    { field: 'acc_moneda', headerName: 'Moneda', width: 100, filter: true },
    { field: 'acc_responsable', headerName: 'Responsable', width: 140, },
    { field: 'acc_observaciones', headerName: 'Observaciones', width: 200},
    {
      field: 'acc_estado',
      headerName: 'Estado',
      headerClass : 'centrarencabezado',
      width: 110,
      filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center'},
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
        } else if (params.value === 'Reintegrado') {
          return '<span class="badge-table bg-[#D6E6FF] text-[#3B82F6]">Reintegrado</span>';        
        }
        return params.value;
      },
    },
  ];
  
  initialState: GridState = {};
  
  get tituloFormulario(): string {
    if (this.modoCreacion) {
      return 'Asignación de caja chica';
    }
    return `Asignación: ${this.filaSeleccionada?.acc_codigo || ''}`;
  }
  
  get formularioDeshabilitado(): boolean {
    if (this.modoCreacion) return false;
    const estado = this.filaSeleccionada?.acc_estado;
    return estado === 'Reintegrado';
  }
  
  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController,
    private formValidationService: FormValidationService,
    private countryService: CountryService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
    effect(() => {
      const asignaciones = this.facade.asignaciones();
      this.rowData = asignaciones;
      if (this.gridApi) this.gridApi.setGridOption('rowData', this.rowData);
    });
  }

  ngOnInit() {
    this.initForm();
    this.facade.cargarAsignaciones();
    
    // Escuchar cambios en el formulario para habilitar/deshabilitar botón Registrar
    this.asignacionForm.valueChanges.subscribe(() => {
      // El botón se habilita si al menos un campo tiene valor
      const tieneValores = Object.values(this.asignacionForm.value).some(valor => valor && valor !== '');
      this.botonRegistrarDeshabilitado = !tieneValores;
    });
  }
  
  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }
  
  initForm() {
    this.asignacionForm = this.formBuilder.group({
      sucursal: ['', Validators.required],
      caja: ['', Validators.required],
      moneda: ['', Validators.required],
      tipoCambio: [{value: '3.36', disabled: true}],
      montoMaximo: ['', Validators.required],
      montoTotal: ['', Validators.required],
      responsable: ['', Validators.required],
      estado: [{ value: 'Activo', disabled: true }],
      observaciones: ['']
    });
    
    this.fechaAsignacionSeleccionada = new Date();
    
    // Inicializar servicio de validación
    this.formValidationService.inicializarFormulario(this.asignacionForm);
  }
  
  limpiarFormulario() {
    this.asignacionForm.patchValue({
      sucursal: '',
      caja: '',
      moneda: '',
      montoTotal: '',
      montoMaximo: '',
      responsable: '',
      acc_estado: 'Activo',
      observaciones: ''
    });
    
    this.sucursalSeleccionada = '';
    this.fechaAsignacionSeleccionada = undefined;
    
    // Habilitar todos los campos editables
    this.asignacionForm.get('sucursal')?.enable();
    this.asignacionForm.get('caja')?.enable();
    this.asignacionForm.get('moneda')?.enable();
    this.asignacionForm.get('montoTotal')?.enable();
    this.asignacionForm.get('montoMaximo')?.enable();
    this.asignacionForm.get('responsable')?.enable();
    this.asignacionForm.get('estado')?.disable();
    this.asignacionForm.get('observaciones')?.enable();
  }
  
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }
  
  onFirstDataRendered(params: any) {
    params.api.sizeColumnsToFit();
  }
  
  onBtReset() {
    this.facade.cargarAsignaciones();
  }

  onSucursalSeleccionada(sucursal: any) {
    this.sucursalSeleccionada = sucursal?.id || '';
    this.asignacionForm.patchValue({
      sucursal: sucursal?.nombre || ''
    });
    console.log('Sucursal seleccionada:', sucursal);
  }
  
  filtrarPorFechas(event: any) {
    // Implementar filtro de fechas
  }
  
  onFechaAsignacionSelected(fecha: Date) {
    this.fechaAsignacionSeleccionada = fecha;
  }
  
  async onCellClicked(event: any) {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló, mantener estado actual
    }
    
    this.modoCreacion = false;
    this.filaSeleccionada = event.data;
    
    // Cargar datos en el formulario
    const sucursalEncontrada = this.sucursales.find(s => s.nombre === event.data.acc_sucursal);
    this.asignacionForm.patchValue({
      sucursal: sucursalEncontrada?.id || '',
      caja: event.data.acc_caja,
      moneda: event.data.acc_moneda,
      montoMaximo: event.data.acc_montoMaximo,
      montoTotal: event.data.acc_montoAsignado,
      responsable: event.data.acc_responsable,
      estado: event.data.acc_estado,
      observaciones: event.data.acc_observaciones
    });
    
    // Cargar fecha de asignación
    this.fechaAsignacionSeleccionada = event.data.acc_fechaAsignacion ? this.parseFecha(event.data.acc_fechaAsignacion) : undefined;
    
    // Si está Reintegrado, deshabilitar todo
    if (event.data.acc_estado === 'Reintegrado') {
      this.asignacionForm.disable();
    } else {
      // Si está Activo, habilitar campos
      this.asignacionForm.enable();
    }
    
    // Resetear servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }
  
  async botonNuevaAsignacion() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló, mantener estado actual
    }
    
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    
    // Limpiar selección en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Limpiar formulario
    this.limpiarFormulario();
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }
  
  botonRegistrar() {
    // Validación: Si el botón está deshabilitado, no permitir acción
    if (this.botonRegistrarDeshabilitado) {
      this.toastService.danger('Por favor, complete al menos un campo del formulario.');
      return;
    }
    
    if (this.asignacionForm.invalid || !this.fechaAsignacionSeleccionada) {
      this.toastService.danger('Por favor, complete todos los campos requeridos.');
      return;
    }
    
    // Generar código único
    const codigo = `FDS-${String(127 + this.rowData.length).padStart(5, '0')}`;
    
    // Formatear monto con moneda
    const moneda = this.asignacionForm.get('moneda')?.value === 'Soles' ? 'S/' : '$';
    const monto = this.asignacionForm.get('montoTotal')?.value;
    
    // Crear nuevo registro
    const nuevoRegistro: AsignacionCajaChicaEntity = {
      acc_codigo: codigo,
      acc_sucursal: this.asignacionForm.get('sucursal')?.value,
      acc_caja: this.asignacionForm.get('caja')?.value,
      acc_fechaAsignacion: this.formatearFecha(this.fechaAsignacionSeleccionada),
      acc_montoAsignado: monto,
      acc_montoMaximo: this.asignacionForm.get('montoMaximo')?.value,
      acc_moneda: this.asignacionForm.get('moneda')?.value,
      acc_responsable: this.asignacionForm.get('responsable')?.value,
      acc_observaciones: this.asignacionForm.get('observaciones')?.value || '',
      acc_estado: 'Activo'
    };
    
    // Agregar a la tabla al inicio
    this.rowData = [nuevoRegistro, ...this.rowData];
    
    // Actualizar la grid
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
      this.gridApi.deselectAll();
    }
    
    this.toastService.success(' ¡Se registró la asignación exitosamente!');
    
    // Limpiar formulario para seguir agregando más
    this.limpiarFormulario();
    
    // Resetear servicio de validación después de guardar
    this.formValidationService.resetearEstado();
  }
  
  botonReintegrarFondo() {
    if (!this.filaSeleccionada) {
      this.toastService.danger('No hay asignación seleccionada.');
      return;
    }

    // Actualizar el estado en rowData
    const index = this.rowData.findIndex(row => 
      row.acc_codigo === this.filaSeleccionada.acc_codigo
    );

    if (index !== -1) {
      this.rowData[index].acc_estado = 'Reintegrado';
      
      // Actualizar la fila seleccionada
      this.filaSeleccionada = { ...this.rowData[index] };

      // Refrescar la tabla para que se vea el cambio de estado
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        
        // Reseleccionar la fila después de actualizar
        setTimeout(() => {
          const updatedNode = this.gridApi.getRowNode(index.toString());
          if (updatedNode) {
            updatedNode.setSelected(true);
          }
        }, 100);
      }

      // Recargar el formulario con el nuevo estado
      this.onCellClicked({ data: this.filaSeleccionada });

      this.toastService.success('¡Fondo reintegrado exitosamente!');
    }
  }
  
  async modalverActualizaciones() {
    if (!this.filaSeleccionada) {
      this.toastService.danger('Seleccione una asignación.');
      return;
    }
    
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
      { 
      field: 'estado', 
      headerClass: 'centrarencabezado',
      headerName: 'Estado', 
      width: 110, 
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center'},
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
        } else if (params.value === 'Reintegrado') {
          return '<span class="badge-table bg-[#D6E6FF] text-[#3B82F6]">Reintegrado</span>';
        }
        return params.value;
      },
    },
    ];
    
    const rowData = [
      { fechaHora: '28/11/2025 10:30', usuario: 'Eduardo Jimenez', accion: 'Creación', detalleCambio: 'Se asignó la caja chica', estado: 'Activo' },
      { fechaHora: '28/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se modificó el responsable', estado: 'Activo' },
      { fechaHora: '29/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Reintegración', detalleCambio: 'Se reintegró el fondo a la caja principal', estado: 'Reintegrado' },
    ];
    
    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones de ${this.filaSeleccionada.acc_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });
    
    await modal.present();
  }
  
  formatearFecha(fecha: Date): string {
    return fecha.toLocaleDateString('es-PE');
  }
  
  parseFecha(fechaString: string): Date | undefined {
    // Parsear formato DD/MM/YYYY
    const partes = fechaString.split('/');
    if (partes.length === 3) {
      const dia = parseInt(partes[0], 10);
      const mes = parseInt(partes[1], 10) - 1;
      const anio = parseInt(partes[2], 10);
      return new Date(anio, mes, dia);
    }
    return undefined;
  }
}
