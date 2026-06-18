import { Component, OnInit, OnDestroy, inject } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalVerActualizacionesComponent } from '../../../../../ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ConfiguracionFacade } from '../../../application/facades/configuracion.facade';
import { ConfiguracionRetencionesGridEffects } from '../../../effects/configuracion-retenciones-grid.effect';
import { RetencionEntity } from '../../../domain/models/retencion.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



interface ICuCargo {
  id: number;
  nombre: string;
}
interface ICuAbono {
  id: number;
  nombre: string;
}
interface IAplicables {
  id: number;
  nombre: string;
}

@Component({
  selector: 'app-a-l-retenciones',
  templateUrl: './a-l-retenciones.component.html',
  styleUrls: ['./a-l-retenciones.component.scss'],
  standalone: false,
})
export class ALRetencionesComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  // Inyección del Facade y Effects
  private readonly configuracionFacade = inject(ConfiguracionFacade);
  private readonly retencionesGridEffects = inject(ConfiguracionRetencionesGridEffects);
  
  // Selectores del store
  readonly retenciones = this.configuracionFacade.retenciones;
  readonly loadingRetenciones = this.configuracionFacade.loadingRetenciones;
  readonly isLoading = this.configuracionFacade.isLoading;

  private gridApi!: GridApi;
  cargando = false;
  isResetting = false;
  RetencionForm!: FormGroup;
  mostrarBuscadorPrincipal = true;
  camponuevo: boolean = false;
  modoCreacion: boolean = true;
  filaSeleccionada: any = null;
  tipoPortentajeSeleccionado: string = '';

   estados = [
    'Activo',
    'Inactivo',
  ];
  porcentajes = [
    'Fijo',
    'Variable',
  ];

  cuentascargo: ICuCargo[] = [
    { id: 1, nombre: '63111 - Gastos de Ss x terc.' },
    { id: 2, nombre: '63121 - Remuneraciones' },
    { id: 3, nombre: '65111 - Seguros' },
  ];

  cuentasabono: ICuAbono[] = [
    { id: 1, nombre: '90111 - Cuenta puente de gastos' },
    { id: 2, nombre: '90211 - Cuenta de distribución' },
    { id: 3, nombre: '79111 - Cargas imputables' },
  ];

  aplicables: IAplicables[] = [
    { id: 1, nombre: 'Compras' },
    { id: 2, nombre: 'Ventas' },
    { id: 3, nombre: 'Pagos' },
    { id: 4, nombre: 'Planillas' },
    { id: 5, nombre: 'Recibos por honorarios' },


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

  get rowData(): RetencionEntity[] {
    return this.retencionesGridEffects.getRowData();
  }

  colDefs: ColDef[] = [
    {
      field: 'retencion_codigo',
      headerName: 'Codigo',
      width: 100,
    },
    { field: 'retencion_descripcion', headerName: 'Descripción', flex: 1, minWidth: 150 },
    {
      field: 'retencion_porcentaje',
      headerName: 'Porcentaje',
      width: 130,
      cellRenderer: (params: any) => {
        const tipoPorcentaje = params.data.retencion_tipo_porcentaje;
        if (tipoPorcentaje === 'Fijo') {
          return `${params.value}%`;
        } else if (tipoPorcentaje === 'Variable') {
          // Para variable, mostrar rango mínimo - máximo
          return `${params.data.retencion_porcentaje_minimo}% - ${params.data.retencion_porcentaje_maximo}%`;
        }
        return params.value;
      }
    },
    { field: 'retencion_tipo_porcentaje', headerName: 'Tipo de porcentaje', width: 140, filter: true },
    {
      field: 'retencion_aplicable',
      headerName: 'Aplica en',
      width: 110,
      cellRenderer: (params: any) => {
        // Si es un string, mostrar tal cual
        if (typeof params.value === 'string') {
          return params.value;
        }
        // Si es un array, unirlos con comas
        if (Array.isArray(params.value)) {
          return params.value.map((item: any) => {
            return typeof item === 'object' ? item.nombre : item;
          }).join(', ');
        }
        return params.value;
      }
    },
    {
      field: 'retencion_estado',
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
  ) { }

  ngOnInit() {
    // Limpiar estado previo para forzar loader en cada entrada
    this.configuracionFacade.clearRetenciones();
    
    // Cargar retenciones desde el store
    this.configuracionFacade.cargarRetenciones();
    
    this.initializeForm();
    // Inicializar servicio de validación de formularios
    this.formValidationService.inicializarFormulario(this.RetencionForm);
    // Resetear estado inicial después de inicializar
    this.formValidationService.resetearEstado();
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  initializeForm() {
    this.RetencionForm = this.formBuilder.group({
      descripcion: ['', Validators.required],
      porcentajeSelect: ['', Validators.required],
      porcentaje: ['', [Validators.required, Validators.min(0), Validators.max(100)]],
      porminimo: ['', [Validators.required, Validators.min(0), Validators.max(100)]],
      pormaximo: ['', [Validators.required, Validators.min(0), Validators.max(100)]],
      cuentaCargo: ['', Validators.required],
      cuentaAbono: ['', Validators.required],
      aplicable: ['', Validators.required],
      estadoSelect: ['Activo', Validators.required],
    });

    // Detectar cambios en el tipo de porcentaje
    this.RetencionForm.get('porcentajeSelect')?.valueChanges.subscribe(valor => {
      this.tipoPortentajeSeleccionado = valor;
      this.actualizarValidadoresSegunTipo(valor);
    });
  }

  actualizarValidadoresSegunTipo(tipo: string) {
    const porcentajeControl = this.RetencionForm.get('porcentaje');
    const porminControl = this.RetencionForm.get('porminimo');
    const pormaxControl = this.RetencionForm.get('pormaximo');

    if (tipo === 'Fijo') {
      // Solo porcentaje es requerido
      porcentajeControl?.setValidators([Validators.required]);
      porminControl?.setValidators([]);
      pormaxControl?.setValidators([]);
    } else if (tipo === 'Variable') {
      // Porcentaje mínimo y máximo son requeridos
      porcentajeControl?.setValidators([]);
      porminControl?.setValidators([Validators.required]);
      pormaxControl?.setValidators([Validators.required]);
    }

    porcentajeControl?.updateValueAndValidity();
    porminControl?.updateValueAndValidity();
    pormaxControl?.updateValueAndValidity();
  }

  async onCellClicked(event: any) {
    if (!event.data) return;
    const node = event.node;
    
    // Validar cambios antes de cambiar de retención
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló, deseleccionar todo primero
      if (this.gridApi) {
        this.gridApi.deselectAll();
        // Volver a seleccionar la fila anterior si existía
        if (this.filaSeleccionada) {
          this.gridApi.forEachNode((node) => {
            if (node.data === this.filaSeleccionada) {
              node.setSelected(true);
            }
          });
        }
      }
      return;
    }
    
    // Deseleccionar la fila anterior
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Usuario confirmó, aplicar nueva selección
    this.filaSeleccionada = event.data;
    this.camponuevo = true;
    this.modoCreacion = false;
    
    // Marcar visualmente la fila como seleccionada
    event.node.setSelected(true);
    
    // Llenar el formulario con los datos de la fila seleccionada
    this.llenarFormularioDesdeRegistro(event.data);
  }

  llenarFormularioDesdeRegistro(registro: any) {
    // Convertir el string de aplicable a array de IDs
    let aplicableIds: number[] = [];
    
    if (registro.retencion_aplicable) {
      // Si es string (como "Compras, pagos"), dividirlo y buscar los IDs
      const nombresAplicables = typeof registro.retencion_aplicable === 'string' 
        ? registro.retencion_aplicable.split(',').map((s: string) => s.trim().toLowerCase())
        : registro.retencion_aplicable;
      
      // Buscar los IDs correspondientes a los nombres (comparación case-insensitive)
      aplicableIds = this.aplicables
        .filter(item => nombresAplicables.some((nombre: string) => nombre === item.nombre.toLowerCase()))
        .map(item => item.id);
    }
    
    // Buscar las cuentas completas por nombre para los autocompletes
    const cuentaCargoEncontrada = registro.retencion_cuenta_cargo 
      ? this.cuentascargo.find(c => c.nombre === registro.retencion_cuenta_cargo)?.nombre || ''
      : '';
    
    const cuentaAbonoEncontrada = registro.retencion_cuenta_abono 
      ? this.cuentasabono.find(c => c.nombre === registro.retencion_cuenta_abono)?.nombre || ''
      : '';
    
    // Actualizar el tipo de porcentaje seleccionado ANTES de cargar los datos
    this.tipoPortentajeSeleccionado = registro.retencion_tipo_porcentaje;
    
    // Pequeño delay para asegurar que los campos se actualicen correctamente
    setTimeout(() => {
      this.RetencionForm.patchValue({
        descripcion: registro.retencion_descripcion,
        porcentajeSelect: registro.retencion_tipo_porcentaje,
        porcentaje: registro.retencion_porcentaje,
        porminimo: registro.retencion_porcentaje_minimo,
        pormaximo: registro.retencion_porcentaje_maximo,
        cuentaCargo: cuentaCargoEncontrada,
        cuentaAbono: cuentaAbonoEncontrada,
        aplicable: aplicableIds,
        estadoSelect: registro.retencion_estado
      });
      
      // Habilitar todos los controles explícitamente
      this.RetencionForm.enable();
      
      // Marcar como pristine y untouched
      this.RetencionForm.markAsPristine();
      this.RetencionForm.markAsUntouched();
      
      // Resetear estado de validación después de cargar datos
      setTimeout(() => {
        this.formValidationService.resetearEstado();
      }, 50);
    }, 0);
  }

  async nuevaRetencion(): Promise<void> {
    // Validar cambios antes de limpiar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    // Resetear todo el formulario
    this.RetencionForm.reset({
      estadoSelect: 'Activo',
      porcentajeSelect: ''
    });
    
    // Limpiar variables
    this.tipoPortentajeSeleccionado = '';
    this.filaSeleccionada = null;
    this.camponuevo = false; // Cambiar a modo creación
    this.modoCreacion = true;
    
    // Deseleccionar filas de la grilla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Resetear estado de validación
    this.formValidationService.resetearEstado();
  }

  async botonCancelar(): Promise<void> {
    // Validar cambios antes de cancelar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Si cancela, deseleccionar la fila
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }
      return; // Cancelar acción
    }

    // Reiniciar el formulario a los valores por defecto
    if (this.RetencionForm) {
      this.RetencionForm.reset({
        estadoSelect: 'Activo',
        porcentajeSelect: ''
      });

      // Limpiar tipo de porcentaje seleccionado
      this.tipoPortentajeSeleccionado = '';

      // Limpiar fila seleccionada
      this.filaSeleccionada = null;

      // Deseleccionar fila de la tabla
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }

      // Retornar a modo creación
      this.camponuevo = false;
      this.modoCreacion = true;

      // Resetear estado del servicio de validación
      this.formValidationService.resetearEstado();
    }
  }



  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.retencionesGridEffects.setGridApi(params.api);
    // No auto-seleccionar ningún dato al iniciar
  }

  onBtReset(): void {
    this.isResetting = true;
    this.configuracionFacade.clearRetenciones();
    this.configuracionFacade.cargarRetenciones();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.isResetting = false;
        clearInterval(timer);
      }
    }, 100);
  }

  onCCargoSeleccionado(cuentascargo: ICuCargo) {
    console.log('Cuentas de cargo seleccionadas:', cuentascargo);
  }
  onCAbonoSeleccionado(cuentaabono: ICuAbono) {
    console.log('Cuentas de abono seleccionadas:', cuentaabono);
  }

  onAplicableSeleccionado(cuentaabono: ICuAbono) {
    console.log('Cuentas de abono seleccionadas:', cuentaabono);
  }

  limitarPorcentaje(event: any): void {
    let valor = event.target.value;
    
    // Si está vacío, permitir
    if (!valor || valor === '') {
      return;
    }

    // Convertir a número
    let numValor = parseInt(valor, 10);

    // Validar que sea un número válido
    if (isNaN(numValor)) {
      event.target.value = '';
      return;
    }

    // Limitar a máximo 100
    if (numValor > 100) {
      event.target.value = '100';
      return;
    }

    // Limitar a máximo 3 dígitos (0-100)
    if (valor.toString().length > 3) {
      event.target.value = valor.toString().slice(0, 3);
      return;
    }

    // Asegurar que sea un número positivo
    if (numValor < 0) {
      event.target.value = '0';
    }
  }

  registrarRetencion(): void {
    // Marcar todos los campos como tocados para mostrar errores
    Object.keys(this.RetencionForm.controls).forEach(key => {
      this.RetencionForm.get(key)?.markAsTouched();
    });

    // Validar que el formulario sea válido
    if (this.RetencionForm.invalid) {
      console.log('Formulario inválido:', this.RetencionForm.errors);
      console.log('Controles inválidos:');
      Object.keys(this.RetencionForm.controls).forEach(key => {
        const control = this.RetencionForm.get(key);
        if (control?.invalid) {
          console.log(`- ${key}:`, control.errors);
        }
      });
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    const formValues = this.RetencionForm.value;
    const currentData = this.retencionesGridEffects.getRowData();

    // Si estamos en modo edición (camponuevo = true), actualizar el registro existente
    if (this.camponuevo && this.filaSeleccionada) {
      // Extraer IDs del campo aplicable para convertirlos a nombres
      let aplicableNombres: string[] = [];
      if (Array.isArray(formValues.aplicable)) {
        aplicableNombres = formValues.aplicable.map((id: number) => {
          const item = this.aplicables.find(a => a.id === id);
          return item ? item.nombre : '';
        }).filter((nombre: string) => nombre !== '');
      }

      // Actualizar el registro existente
      const index = currentData.findIndex(row => row.retencion_codigo === this.filaSeleccionada.retencion_codigo);
      if (index !== -1) {
        const updatedData = [...currentData];
        updatedData[index] = {
          ...updatedData[index],
          retencion_descripcion: formValues.descripcion,
          retencion_tipo_porcentaje: formValues.porcentajeSelect,
          retencion_porcentaje: formValues.porcentajeSelect === 'Fijo' ? formValues.porcentaje : null,
          retencion_porcentaje_minimo: formValues.porcentajeSelect === 'Variable' ? formValues.porminimo : null,
          retencion_porcentaje_maximo: formValues.porcentajeSelect === 'Variable' ? formValues.pormaximo : null,
          retencion_cuenta_cargo: formValues.cuentaCargo,
          retencion_cuenta_abono: formValues.cuentaAbono,
          retencion_aplicable: aplicableNombres.join(', '),
          retencion_estado: formValues.estadoSelect
        };

        // Actualizar la grilla usando el effect
        this.retencionesGridEffects.setRowData(updatedData);

        this.toastService.success('¡Cambios guardados exitosamente!');
        this.formValidationService.resetearEstado();
      }
      return;
    }

    // Modo creación - Extraer nombres del campo aplicable
    let aplicableNombres: string[] = [];
    if (Array.isArray(formValues.aplicable)) {
      aplicableNombres = formValues.aplicable.map((id: number) => {
        const item = this.aplicables.find(a => a.id === id);
        return item ? item.nombre : '';
      }).filter((nombre: string) => nombre !== '');
    }

    // Generar código de retención (ej: R005, R006, etc)
    const ultimoCodigo = currentData.length > 0 
      ? parseInt(currentData[0].retencion_codigo.replace('R', ''), 10) 
      : 0;
    const nuevoCodigoNum = ultimoCodigo + 1;
    const nuevoCodigo = 'R' + nuevoCodigoNum.toString().padStart(3, '0');

    // Crear el nuevo objeto según el tipo de porcentaje
    let nuevoRegistro: any = {
      retencion_codigo: nuevoCodigo,
      retencion_descripcion: formValues.descripcion,
      retencion_tipo_porcentaje: formValues.porcentajeSelect,
      retencion_cuenta_cargo: formValues.cuentaCargo,
      retencion_cuenta_abono: formValues.cuentaAbono,
      retencion_aplicable: aplicableNombres.join(', '), // Guardar como string con nombres
      retencion_estado: formValues.estadoSelect
    };

    // Agregar porcentajes según el tipo
    if (formValues.porcentajeSelect === 'Fijo') {
      nuevoRegistro.retencion_porcentaje = formValues.porcentaje;
      nuevoRegistro.retencion_porcentaje_minimo = null;
      nuevoRegistro.retencion_porcentaje_maximo = null;
    } else if (formValues.porcentajeSelect === 'Variable') {
      nuevoRegistro.retencion_porcentaje = null;
      nuevoRegistro.retencion_porcentaje_minimo = formValues.porminimo;
      nuevoRegistro.retencion_porcentaje_maximo = formValues.pormaximo;
    }

    // Agregar el nuevo registro al inicio del array
    const updatedData = [nuevoRegistro, ...currentData];

    // Actualizar la grilla usando el effect
    this.retencionesGridEffects.setRowData(updatedData);

    // Deseleccionar todo
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Limpiar variables para modo creación
    this.filaSeleccionada = null;
    this.modoCreacion = true;
    this.camponuevo = false;
    
    // Limpiar formulario PRIMERO
    this.RetencionForm.reset({
      estadoSelect: 'Activo',
      porcentajeSelect: ''
    });
    this.tipoPortentajeSeleccionado = '';
    
    // LUEGO resetear estado de validación para que sepa que el formulario vacío es el nuevo estado inicial
    this.formValidationService.resetearEstado();

    this.toastService.success('¡Retención registrada exitosamente!');
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
      { historial_actualizacion_fecha_hora: '12/11/2025 10:30', historial_actualizacion_usuario: 'Juan Pérez', historial_actualizacion_accion: 'Creación', historial_actualizacion_detalle_cambio: 'Registro inicial de la retención'},
      { historial_actualizacion_fecha_hora: '12/11/2025 14:15', historial_actualizacion_usuario: 'María González', historial_actualizacion_accion: 'Actualización', historial_actualizacion_detalle_cambio: 'Cambio de estado de "Activo" a "Inactivo"'},
      { historial_actualizacion_fecha_hora: '13/11/2025 09:00', historial_actualizacion_usuario: 'Carlos Rodríguez', historial_actualizacion_accion: 'Actualización', historial_actualizacion_detalle_cambio: 'Actualizó los aplicables'},
      { historial_actualizacion_fecha_hora: '13/11/2025 16:45', historial_actualizacion_usuario: 'Ana Martínez', historial_actualizacion_accion: 'Actualización', historial_actualizacion_detalle_cambio: 'Cambio de estado de "Inactivo" a "Activo"' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones de la retención ${this.filaSeleccionada?.retencion_codigo}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }

}