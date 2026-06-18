import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalVerActualizacionesComponent } from '../../../../../ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormGroup, FormBuilder, Validators, AbstractControl, ValidationErrors } from '@angular/forms';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ConfiguracionFacade } from '../../../application/facades/configuracion.facade';
import { ConfiguracionMonedasGridEffects } from '../../../effects/configuracion-monedas-grid.effect';
import { MonedaEntity } from '../../../domain/models/moneda.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-a-l-monedas',
  templateUrl: './a-l-monedas.component.html',
  styleUrls: ['./a-l-monedas.component.scss'],
  standalone: false,
})
export class ALMonedasComponent implements OnInit, OnDestroy {
  // Facades y Effects
  private readonly configuracionFacade = inject(ConfiguracionFacade);
  private readonly monedasGridEffects = inject(ConfiguracionMonedasGridEffects);

  // Selectores del store
  readonly monedas = this.configuracionFacade.monedas;
  readonly loadingMonedas = this.configuracionFacade.loadingMonedas;
  readonly isLoading = this.configuracionFacade.isLoading;

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  // RANGO DE FECHAS

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private gridApi!: GridApi;
  MonedasForm!: FormGroup;
  filaSeleccionada: any = null;
  cargando = false;
  isResetting = false;
  esMonedaBase: boolean = false;
  deshabilitarCheckbox: boolean = false;
  camponuevo: boolean = false;
  modoCreacion: boolean = true;
  existeMonedaBase: boolean = false;


  estados = [
    'Activo',
    'Inactivo',
  ];

  localeText = {
    page: 'Página',
    of: 'de',
    to: 'a',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    noRowsToShow: 'No hay datos para mostrar',
    loadingOoo: 'Cargando...',
  };

  get rowData(): MonedaEntity[] {
    return this.monedasGridEffects.getRowData();
  }

  colDefs: ColDef[] = [
    { field: 'moneda_nombre', headerName: 'Nombre', flex: 1, minWidth: 150},
    { field: 'moneda_simbolo', headerName: 'Símbolo', width: 80},
    { field: 'moneda_decimal', headerName: 'Precisión decimal', width: 120},
    { 
      field: 'moneda_monedabase', 
      headerName: 'Moneda base', 
      width: 120,
      cellRenderer: (params: any) => {
        return params.value ? 'Sí' : 'No';
      }
    },
    { field: 'moneda_fecha_registro', headerName: 'Fecha de registro', width: 130,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate()).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
    },
    {
      field: 'moneda_estado',
      headerName: 'Estado',
      width: 100,
      filter: true,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>`;
        } else if (params.value === 'Inactivo') {
          return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>`;
        }
        return params.value;
      },
    }
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
    // Limpiar estado previo para forzar loader en cada entrada
    this.configuracionFacade.clearMonedas();
    
    // Cargar monedas desde el store
    this.configuracionFacade.cargarMonedas();
    
    // Verificar moneda base ANTES de inicializar el formulario
    this.verificarMonedaBase();
    // Ahora inicializar el formulario
    this.inicializarFormulario();
    // Inicializar servicio de validación de formularios
    this.formValidationService.inicializarFormulario(this.MonedasForm);
    // Resetear estado inicial después de inicializar
    this.formValidationService.resetearEstado();
  }

  // Validador personalizado para símbolos (no permite números)
  validadorSimbolo(control: AbstractControl): ValidationErrors | null {
    if (!control.value) {
      return null;
    }
    const soloNumeros = /^\d+$/.test(control.value);
    if (soloNumeros) {
      return { soloNumeros: true };
    }
    return null;
  }

  inicializarFormulario(): void {
    // Si ya existe una moneda base, el new moneda debe ser false
    const valorMonedaBase = this.existeMonedaBase ? false : true;
    
    this.MonedasForm = this.formBuilder.group({
      nombre: ['', Validators.required],
      simbolo: ['', [Validators.required, this.validadorSimbolo.bind(this)]],
      decimal: ['', [Validators.required, Validators.min(0)]],
      monedabase: [{ value: valorMonedaBase, disabled: true }],
      estado: [{value: 'Activo', disabled: true}, Validators.required],
      estadoSelect: ['Activo', Validators.required]
    });
    this.deshabilitarCheckbox = true;
    this.verificarMonedaBase();
    this.actualizarEstadoControles();
  }

  actualizarEstadoControles(): void {
    if (this.filaSeleccionada?.moneda_monedabase) {
      // Si es moneda base, deshabilitar el input y habilitar el select
      this.MonedasForm.get('estado')?.disable();
      this.MonedasForm.get('estadoSelect')?.enable();
    } else {
      // Si no es moneda base, deshabilitar el select y habilitar el input
      this.MonedasForm.get('estadoSelect')?.enable();
      this.MonedasForm.get('estado')?.disable();
    }
  }

  verificarMonedaBase(): void {
    const currentData = this.monedasGridEffects.getRowData();
    this.existeMonedaBase = currentData.some(moneda => moneda.moneda_monedabase === true);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.monedasGridEffects.setGridApi(params.api);
    // No auto-seleccionar ningún dato al iniciar
  }

  async onCellClicked(event: any) {
    if (!event.data) return;
    
    const data = event.data;
    const node = event.node;
    if (!data) { return; }
    
    // Validar cambios ANTES de cualquier operación de grid
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Re-seleccionar la fila anterior si existe
      if (this.filaSeleccionada && this.gridApi) {
        this.gridApi.forEachNode((node) => {
          if (node.data.moneda_nombre === this.filaSeleccionada.moneda_nombre) {
            node.setSelected(true);
          }
        });
      }
      return;
    }
    
    // Usuario confirmó - cargar nuevos datos
    this.gridApi.deselectAll();
    
    // Usuario confirmó, aplicar nueva selección
    this.filaSeleccionada = data;
    this.camponuevo = true;
    this.modoCreacion = false;
    
    // Marcar visualmente la fila como seleccionada
    setTimeout(() => node.setSelected(true), 0);
    
    // Cargar datos del formulario
    this.MonedasForm.patchValue({
      nombre: data?.moneda_nombre || '',
      simbolo: data?.moneda_simbolo || '',
      decimal: data?.moneda_decimal || '',
      monedabase: data?.moneda_monedabase || false,
      estado: data?.moneda_estado || '',
      estadoSelect: data?.moneda_estado || ''
    });
    
    // Habilitar formulario
    this.MonedasForm.enable();
    
    // Actualizar controles habilitados/deshabilitados
    this.actualizarEstadoControles();
    
    // Resetear estado después de cargar datos
    this.formValidationService.resetearEstado();
  }

  llenarFormularioDesdeRegistro(registro: any) {
    // Este método ya no se usa, se mantiene por compatibilidad
  }

  onBtReset(): void {
    this.isResetting = true;
    this.configuracionFacade.cargarMonedas();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

  activarMonedaBase(): void {
    if (!this.filaSeleccionada) {
      // Primer registro de moneda base
      this.esMonedaBase = true;
      this.deshabilitarCheckbox = true;
      this.MonedasForm.patchValue({ monedabase: true });
      this.MonedasForm.get('monedabase')?.disable();
    }
  }

  async nuevaMoneda(): Promise<void> {
    // Validar cambios antes de limpiar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }

    // Solo resetear el formulario existente, NO crear uno nuevo
    this.MonedasForm.reset();
    this.MonedasForm.enable();
    
    // Reconfigurar los campos con valores por defecto
    const valorMonedaBase = this.existeMonedaBase ? false : true;
    this.MonedasForm.patchValue({
      nombre: '',
      simbolo: '',
      decimal: '',
      monedabase: valorMonedaBase,
      estado: 'Activo',
      estadoSelect: 'Activo'
    });
    
    // Limpiar variables
    this.filaSeleccionada = null;
    this.camponuevo = false;
    this.modoCreacion = true;
    
    // Deseleccionar filas de la grilla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Resetear estado de validación
    this.formValidationService.resetearEstado();
  }

  registrarMoneda(): void {
    // Marcar todos los campos como tocados para mostrar errores
    Object.keys(this.MonedasForm.controls).forEach(key => {
      this.MonedasForm.get(key)?.markAsTouched();
    });

    if (this.MonedasForm.invalid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    // Si estamos en modo edición (camponuevo = true), actualizar el registro existente
    if (this.camponuevo && this.filaSeleccionada) {
      const currentData = this.monedasGridEffects.getRowData();
      const index = currentData.findIndex(row => row === this.filaSeleccionada);
      if (index !== -1) {
        const updatedData = [...currentData];
        updatedData[index] = {
          ...updatedData[index],
          moneda_nombre: this.MonedasForm.get('nombre')?.value,
          moneda_simbolo: this.MonedasForm.get('simbolo')?.value,
          moneda_decimal: this.MonedasForm.get('decimal')?.value,
          moneda_monedabase: this.MonedasForm.get('monedabase')?.value,
          moneda_estado: this.filaSeleccionada.moneda_monedabase 
            ? this.MonedasForm.get('estado')?.value 
            : this.MonedasForm.get('estadoSelect')?.value
        };

        // Actualizar usando el effect
        this.monedasGridEffects.setRowData(updatedData);

        this.toastService.success('Moneda actualizada correctamente');
        this.formValidationService.resetearEstado();
      }
      return;
    }

    // Modo creación
    const nuevaMoneda: MonedaEntity = {
      moneda_nombre: this.MonedasForm.get('nombre')?.value,
      moneda_simbolo: this.MonedasForm.get('simbolo')?.value,
      moneda_decimal: this.MonedasForm.get('decimal')?.value,
      moneda_monedabase: this.MonedasForm.get('monedabase')?.value,
      moneda_fecha_registro: new Date().toISOString().split('T')[0],
      moneda_estado: 'Activo'
    };

    // Obtener datos actuales del effect y agregar nueva moneda
    const currentData = this.monedasGridEffects.getRowData();
    const updatedData = [...currentData, nuevaMoneda];
    this.monedasGridEffects.setRowData(updatedData);
    
    // Deseleccionar filas
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Mostrar toast de éxito
    this.toastService.success('¡Moneda registrada exitosamente!');

    // Limpiar variables para modo creación
    this.filaSeleccionada = null;
    this.modoCreacion = true;
    this.camponuevo = false;
    
    // Verificar si ya existe una moneda base
    this.verificarMonedaBase();
    
    // Limpiar formulario SIN crear uno nuevo
    this.MonedasForm.reset();
    
    // Reconfigurar los campos con valores por defecto
    const valorMonedaBase = this.existeMonedaBase ? false : true;
    this.MonedasForm.patchValue({
      nombre: '',
      simbolo: '',
      decimal: '',
      monedabase: valorMonedaBase,
      estado: 'Activo',
      estadoSelect: 'Activo'
    });
    
    // LUEGO resetear estado de validación para que sepa que el formulario vacío es el nuevo estado inicial
    this.formValidationService.resetearEstado();
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    console.log('Filtrar por fechas:', range);
    // Aquí iría la lógica para filtrar los datos
  }

  async botonCancelar() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    this.MonedasForm.reset();
    this.MonedasForm.enable();
    this.filaSeleccionada = null;
    this.camponuevo = false;
    this.modoCreacion = true;
    
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    this.formValidationService.resetearEstado();
  }

  async modalverActualizaciones(): Promise<void> {
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
      { historial_actualizacion_fecha_hora: '12/11/2025 10:30', historial_actualizacion_usuario: 'Juan Pérez', historial_actualizacion_accion: 'Creación', historial_actualizacion_detalle_cambio: 'Registro inicial del siniestro'},
      { historial_actualizacion_fecha_hora: '12/11/2025 14:15', historial_actualizacion_usuario: 'María González', historial_actualizacion_accion: 'Actualización', historial_actualizacion_detalle_cambio: 'Cambio de estado de "Reportado" a "En evaluación"'},
      { historial_actualizacion_fecha_hora: '13/11/2025 09:00', historial_actualizacion_usuario: 'Carlos Rodríguez', historial_actualizacion_accion: 'Actualización', historial_actualizacion_detalle_cambio: 'Agregó documentación de respaldo (3 archivos)'},
      { historial_actualizacion_fecha_hora: '13/11/2025 16:45', historial_actualizacion_usuario: 'Ana Martínez', historial_actualizacion_accion: 'Actualización', historial_actualizacion_detalle_cambio: 'Cambio de estado de "En evaluación" a "Aprobado"' }
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

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

}
