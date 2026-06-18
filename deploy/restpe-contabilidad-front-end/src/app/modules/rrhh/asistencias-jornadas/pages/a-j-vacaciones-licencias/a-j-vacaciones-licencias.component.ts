import { Component, OnInit, ViewChild, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { RrHhVacacionesLicenciasRegistroGridEffects } from 'src/app/modules/rrhh/effects/rr-hh-vacaciones-licencias-registro-grid.effect';
import { VacacionLicenciaEntity } from 'src/app/modules/rrhh/domain/models/vacacion-licencia.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-a-j-vacaciones-licencias',
  templateUrl: './a-j-vacaciones-licencias.component.html',
  styleUrls: ['./a-j-vacaciones-licencias.component.scss'],
  standalone: false,
})
export class AJVacacionesLicenciasComponent  implements OnInit, CanComponentDeactivate {
  private readonly rrHhFacade = inject(RrHhFacade);
  private readonly vacacionesGridEffects = inject(RrHhVacacionesLicenciasRegistroGridEffects);
  readonly isLoading = this.rrHhFacade.loadingVacacionesLicenciasRegistro;
  isResetting = false;
  get rowData(): VacacionLicenciaEntity[] { return this.vacacionesGridEffects.getRowData(); }

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  @ViewChild('fileUpload') fileUploadComponent: any;
  private gridApi!: GridApi;
  camponuevo: boolean = true;
  SolicitudForm!: FormGroup;
  filaSeleccionada: any = null;
  botonesHabilitados: boolean = false; // Control para habilitar/deshabilitar botones
  deshabilitado = false;

  // Fecha
  
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  tipos=[
    "Vacaciones",
    "Licencia",
    "Subsidio",
  ];

  subtipos=[
    "Con goce",
    "Sin goce",
  ]
   subtiposSolicitud=[
    "Médica",
    "Maternidad",
    "Paternidad",
  ]

  trabajadores = [
    { nombre: 'Ernesto Alvarado', vacacion_licencia_sucursal: 'Santa Isabel, Piura', vacacion_licencia_centro_costo: 'Administración' },
    { nombre: 'Ana Rodríguez', vacacion_licencia_sucursal: 'San Isidro, Lima', vacacion_licencia_centro_costo: 'AC02 - Recursos Humanos' },
    { nombre: 'Juan Pérez', vacacion_licencia_sucursal: 'La Molina, Lima', vacacion_licencia_centro_costo: 'AC01 - Administración' },
    { nombre: 'María García', vacacion_licencia_sucursal: 'San Isidro, Lima', vacacion_licencia_centro_costo: 'AC02 - Ventas' },
    { nombre: 'Carlos López', vacacion_licencia_sucursal: 'San Borja, Lima', vacacion_licencia_centro_costo: 'AC03 - Producción' },
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
    loadingOoo: 'Cargando...'
  };
  columnTypes = {
    currency: { 
        width: 150,
    },
    shaded: {
        cellClass: 'shaded-class'
    }
  };
  defaultColDef = {
    resizable: true,
    flex: 1,
    minWidth: 100,
  };

  
  //  Tipado con la misma entidad
  colDefs: ColDef<VacacionLicenciaEntity>[] = [
    { field: 'vacacion_licencia_codigo', headerName: 'Código', width: 110 },
    { field: 'vacacion_licencia_trabajador', headerName: 'Trabajador', width: 140, filter:true },
    { field: 'vacacion_licencia_sucursal', headerName: 'Sucursal', width: 140 },
    { field: 'vacacion_licencia_centro_costo', headerName: 'Centro de costo', width: 150, filter:true },
    { field: 'vacacion_licencia_motivo', headerName: 'Motivo', flex:1, minWidth: 140 },
    { field: 'vacacion_licencia_tipo', headerName: 'Tipo de solicitud', width: 140, filter:true },
    { field: 'vacacion_licencia_fecha_inicio', headerName: 'Fecha de inicio', width: 120,
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate() + 1).padStart(2, '0');
        return `${day}/${month}/${year}`;
      }
    },
    { field: 'vacacion_licencia_fecha_fin', headerName: 'Fecha de fin ', width: 120,
      valueFormatter: (params: any) => {
        if (!params.value) return '';
        const date = new Date(params.value);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate() +1).padStart(2, '0');
        return `${day}/${month}/${year}`;
      }
    },
    { field: 'vacacion_licencia_estado', headerName: 'Estado', headerClass:'centrarencabezado' , width: 110, filter:true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Aprobado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Aprobado</span>';
        } else if (params.value === 'Rechazado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Rechazado</span>';
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        }
        return params.value;
      }
    }
  ];
  
    constructor(
      private formBuilder: FormBuilder,
      private toastService: ToastService,
      private modalController: ModalController,
      private formValidationService: FormValidationService
    ) {
      this.minDate = new Date(2020, 0, 1);
      this.maxDate = new Date();
    }

  ngOnInit() {
    this.rrHhFacade.cargarVacacionesLicenciasRegistro();
    this.SolicitudForm = this.formBuilder.group({
      vacacion_licencia_trabajador: ['', Validators.required],
      vacacion_licencia_sucursal: [{value: '', disabled: true}, Validators.required],
      vacacion_licencia_centro_costo: [{value: '', disabled: true}, Validators.required],
      vacacion_licencia_tipo: ['', Validators.required],
      tipoAnual: [{value: '', disabled: true}],
      diasAnual: [{value: '', disabled: true}],
      vacacion_licencia_subtipo: ['', Validators.required],
      vacacion_licencia_subtipo_subsidio: [{value: '', disabled: true}, Validators.required],
      vacacion_licencia_dias_solicitados: [''],
      vacacion_licencia_fecha_inicio: [new Date()],
      vacacion_licencia_fecha_fin: [new Date()],
      vacacion_licencia_motivo: [''],
      docSustento: [null],
      vacacion_licencia_estado: [{ value: 'Pendiente', disabled: true }, Validators.required],
    });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.SolicitudForm);

    // Escuchar cambios en el tipo de solicitud
    this.SolicitudForm.get('vacacion_licencia_tipo')?.valueChanges.subscribe(tipo => {
      this.onTipoSolicitudChange(tipo);
      this.actualizarValidacionesDinamicas(tipo);
    });

    // Aplicar validaciones iniciales segun el tipo actual (si hubiese valor precargado)
    this.actualizarValidacionesDinamicas(this.SolicitudForm.get('vacacion_licencia_tipo')?.value);
  }

  private actualizarValidacionesDinamicas(tipo: string) {
    const licenciaMotivoControl = this.SolicitudForm.get('vacacion_licencia_motivo');
    const docSustentoControl = this.SolicitudForm.get('docSustento');

    // Limpiar validaciones y valores previos
    [licenciaMotivoControl, docSustentoControl]
      .forEach(control => {
        control?.clearValidators();
        control?.setValidators([]);
        control?.updateValueAndValidity({ emitEvent: false });
      });

      // Aplicar validaciones según el tipo
      if (tipo != 'Vacaciones') {
        licenciaMotivoControl?.setValidators([Validators.required]);
        docSustentoControl?.setValidators([Validators.required]);
      }

      // Actualizar validaciones
    [licenciaMotivoControl, docSustentoControl]
      .forEach(control => control?.updateValueAndValidity({ emitEvent: false }));
    
  }

  // Método para manejar cambios en el tipo de solicitud
  onTipoSolicitudChange(tipo: string) {
    const subtipoCtrl = this.SolicitudForm.get('vacacion_licencia_subtipo');
    const diasDCtrl = this.SolicitudForm.get('vacacion_licencia_dias_solicitados');
    const subtipoSubsidioCtrl = this.SolicitudForm.get('vacacion_licencia_subtipo_subsidio');
    const tipoAnualCtrl = this.SolicitudForm.get('tipoAnual');
    const diasAnualCtrl = this.SolicitudForm.get('diasAnual');

    if (tipo === 'Vacaciones') {
      this.SolicitudForm.patchValue({
        vacacion_licencia_subtipo: 'Anual',
        vacacion_licencia_dias_solicitados: '15 días',
        tipoAnual: 'Anual',
        diasAnual: '15 días',
        vacacion_licencia_subtipo_subsidio: ''
      });

      // Deshabilitar todos los campos para vacaciones
      subtipoCtrl?.disable({ emitEvent: false });
      diasDCtrl?.disable({ emitEvent: false });
      subtipoSubsidioCtrl?.disable({ emitEvent: false });
      tipoAnualCtrl?.disable({ emitEvent: false });
      diasAnualCtrl?.disable({ emitEvent: false });
    } else if (tipo === 'Licencia') {
      // Limpiar campos y habilitar subtipo para Licencia, días disponibles deshabilitado
      this.SolicitudForm.patchValue({
        vacacion_licencia_subtipo: '',
        vacacion_licencia_dias_solicitados: '',
        tipoAnual: '',
        diasAnual: '',
        vacacion_licencia_subtipo_subsidio: ''
      });

      subtipoCtrl?.enable({ emitEvent: false });
      diasDCtrl?.disable({ emitEvent: false });
      subtipoSubsidioCtrl?.disable({ emitEvent: false });
    } else if (tipo === 'Subsidio') {
      // Limpiar campos y habilitar subtipoSubsidio para Subsidio
      this.SolicitudForm.patchValue({
        vacacion_licencia_subtipo: '',
        vacacion_licencia_dias_solicitados: '',
        tipoAnual: '',
        diasAnual: '',
        vacacion_licencia_subtipo_subsidio: ''
      });

      subtipoCtrl?.disable({ emitEvent: false });
      diasDCtrl?.disable({ emitEvent: false });
      subtipoSubsidioCtrl?.enable({ emitEvent: false });
    } else {
      // Limpiar campos si no hay tipo seleccionado
      this.SolicitudForm.patchValue({
        vacacion_licencia_subtipo: '',
        vacacion_licencia_dias_solicitados: '',
        tipoAnual: '',
        diasAnual: '',
        vacacion_licencia_subtipo_subsidio: ''
      });

      // Deshabilitar todos los campos
      subtipoCtrl?.disable({ emitEvent: false });
      diasDCtrl?.disable({ emitEvent: false });
      subtipoSubsidioCtrl?.disable({ emitEvent: false });
    }
  }
    filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    console.log('Filtrar desde:', range.start, 'hasta:', range.end);
  }

  onFechaISelected(fecha: Date) {
    this.SolicitudForm.patchValue({ vacacion_licencia_fecha_inicio: fecha });
  } 
  onFechaFSelected(fecha: Date) {
    this.SolicitudForm.patchValue({ vacacion_licencia_fecha_fin: fecha });
  }

  onTrabajadorSeleccionado(trabajador: any) {
    this.SolicitudForm.patchValue({
      vacacion_licencia_trabajador: trabajador.nombre,
      vacacion_licencia_sucursal: trabajador.vacacion_licencia_sucursal,
      vacacion_licencia_centro_costo: trabajador.vacacion_licencia_centro_costo
    });
  }
  
  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

    // Métodos para el componente de carga de documentos
  onDocumentoSustentoSelected(file: File) {
    console.log('Documento de Sustento seleccionado:', file.name);
    
    this.SolicitudForm.patchValue({ docSustento: file });
  }

  onDocumentoSustentoRemoved() {
    this.SolicitudForm.patchValue({ docSustento: null });
    console.log('Documento de Sustento removido');
  }

  showFileError(errorMessage: string) {
    console.error('Error de archivo:', errorMessage);
    // Aquí puedes mostrar un toast o mensaje de error al usuario
    // Por ejemplo: this.toastService.showError(errorMessage);
  }

  async onCellClicked(event: any) {
    const data = event.data;
    
    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló: deshacer la selección automática de AG-Grid
      event.node.setSelected(false);
      // La fila anterior se mantiene seleccionada
      return;
    }

    // Usuario confirmó, cambiar a la nueva fila seleccionada
    this.gridApi.deselectAll();
    
    // Cargar datos del registro seleccionado
    this.cargarDatosRegistro(data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: any, node?: any): void {
    this.camponuevo = false;
    this.filaSeleccionada = data;
    
    // Deshabilitar botones si el estado es Aprobado o Rechazado
    this.botonesHabilitados = data.vacacion_licencia_estado !== 'Aprobado' && data.vacacion_licencia_estado !== 'Rechazado';
    this.filaSeleccionada = data;
    this.gridApi.deselectAll();

    // Seleccionar el nodo en AG-Grid
    if (node) {
      node.setSelected(true);
    } else {
      this.gridApi.forEachNode((n) => {
        if (n.data === data) {
          n.setSelected(true);
        }
      });
    }

    // Llenar los campos del formulario con los datos de la fila
    console.log('Datos de fila:', data);
    console.log('Tipo:', data.vacacion_licencia_tipo);
    console.log('SubtipoSubsidio:', data.vacacion_licencia_subtipo_subsidio);
    
    this.SolicitudForm.patchValue({
      vacacion_licencia_trabajador: data.vacacion_licencia_trabajador || '',               
      vacacion_licencia_sucursal: data.vacacion_licencia_sucursal || '',                   
      vacacion_licencia_centro_costo: data.vacacion_licencia_centro_costo || '',
      vacacion_licencia_tipo: data.vacacion_licencia_tipo || '',
      vacacion_licencia_subtipo: data.vacacion_licencia_subtipo || '',
      vacacion_licencia_dias_solicitados: data.vacacion_licencia_dias_solicitados || '',
      vacacion_licencia_fecha_inicio: data.vacacion_licencia_fecha_inicio || '',
      vacacion_licencia_fecha_fin: data.vacacion_licencia_fecha_fin || '',
      vacacion_licencia_motivo: data.vacacion_licencia_motivo || '',
      docSustento: data.docSustento || null,
      vacacion_licencia_estado: data.vacacion_licencia_estado || 'Pendiente'
    });
    
    console.log('Valor cargado en vacacion_licencia_subtipo_subsidio:', this.SolicitudForm.get('vacacion_licencia_subtipo_subsidio')?.value);

    // Habilitar formulario para edición si el estado es Pendiente
    if (data.vacacion_licencia_estado === 'Pendiente') {
      this.SolicitudForm.enable();
      this.deshabilitado = false;
      
      // Deshabilitar campos específicos que no deben editarse
      this.SolicitudForm.get('vacacion_licencia_trabajador')?.enable();
      this.SolicitudForm.get('vacacion_licencia_sucursal')?.disable();
      this.SolicitudForm.get('vacacion_licencia_centro_costo')?.disable();
      this.SolicitudForm.get('vacacion_licencia_estado')?.disable();
      
      // Ejecutar la lógica de tipo de solicitud para habilitar/deshabilitar campos correctamente
      if (data.vacacion_licencia_tipo) {
        this.onTipoSolicitudChange(data.vacacion_licencia_tipo);
      }
    } else {
      // Deshabilitar todos los campos si está Aprobado o Rechazado
      this.SolicitudForm.disable();
      this.deshabilitado = true;
    }
    
    // Si es Vacaciones, cargar tipoAnual y diasAnual
    if (data.vacacion_licencia_tipo === 'Vacaciones') {
      if (data.vacacion_licencia_subtipo) {
        this.SolicitudForm.get('tipoAnual')?.setValue(data.vacacion_licencia_subtipo);
      }
      if (data.vacacion_licencia_dias_solicitados) {
        this.SolicitudForm.get('diasAnual')?.setValue(data.vacacion_licencia_dias_solicitados);
      }
    }
    
    // Si es Subsidio, cargar el valor después de deshabilitar
    if (data.vacacion_licencia_tipo === 'Subsidio' && data.vacacion_licencia_subtipo_subsidio) {
      this.SolicitudForm.get('vacacion_licencia_subtipo_subsidio')?.setValue(data.vacacion_licencia_subtipo_subsidio);
    }
    
    // Si es Licencia, cargar subtipo
    if (data.vacacion_licencia_tipo === 'Licencia') {
      if (data.vacacion_licencia_subtipo) {
        this.SolicitudForm.get('vacacion_licencia_subtipo')?.setValue(data.vacacion_licencia_subtipo);
      }
    }

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }

  async botonNuevaSolicitud(){
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló: mantener estado actual y fila seleccionada si existía
      return;
    }

    // Usuario confirmó, ahora sí deseleccionar y limpiar
    this.camponuevo = true;
    this.filaSeleccionada = null; // Limpiar la fila seleccionada
    this.gridApi?.deselectAll(); // Deseleccionar filas en la tabla
    this.SolicitudForm.reset();
    
    // Habilitar todos los campos para edición
    this.SolicitudForm.enable();
    this.deshabilitado = false;
    
    // Establecer estado como "Pendiente" y limpiar sucursal y centro de costo
    this.SolicitudForm.patchValue({
      vacacion_licencia_trabajador: '',
      vacacion_licencia_sucursal: '',
      vacacion_licencia_centro_costo: '',
      vacacion_licencia_estado:'Pendiente',
      vacacion_licencia_fecha_inicio: new Date(),
      vacacion_licencia_fecha_fin: new Date(),
    });
    
    // Deshabilitar campos específicos
    this.SolicitudForm.get('vacacion_licencia_trabajador')?.enable();
    this.SolicitudForm.get('vacacion_licencia_sucursal')?.disable();
    this.SolicitudForm.get('vacacion_licencia_centro_costo')?.disable();
    this.SolicitudForm.get('vacacion_licencia_estado')?.disable();
    
    // Deshabilitar campos de subtipo y días hasta que se seleccione un tipo de solicitud
    this.SolicitudForm.get('tipoAnual')?.disable();
    this.SolicitudForm.get('diasAnual')?.disable();
    this.SolicitudForm.get('vacacion_licencia_subtipo')?.disable();
    this.SolicitudForm.get('vacacion_licencia_dias_solicitados')?.disable();
    this.SolicitudForm.get('vacacion_licencia_subtipo_subsidio')?.disable();

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }
  botonGuardar(){
    if (this.SolicitudForm.invalid) {
      this.SolicitudForm.markAllAsTouched();
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    const formValues = this.SolicitudForm.getRawValue();
    
    // Generar código automático para nuevas solicitudes
    const codigo = this.camponuevo ? this.generarNuevoCodigo() : this.filaSeleccionada?.vacacion_licencia_codigo;
    
    // Si es tipo Vacaciones, usar los valores de tipoAnual y diasAnual
    const subtipo = formValues.vacacion_licencia_tipo === 'Vacaciones' ? formValues.tipoAnual : formValues.vacacion_licencia_subtipo;
    const diasD = formValues.vacacion_licencia_tipo === 'Vacaciones' ? formValues.diasAnual : formValues.vacacion_licencia_dias_solicitados;
    
    // Crear objeto con los datos del formulario
    const solicitudData: VacacionLicenciaEntity = {
      vacacion_licencia_codigo: codigo,
      vacacion_licencia_trabajador: formValues.vacacion_licencia_trabajador,
      vacacion_licencia_sucursal: formValues.vacacion_licencia_sucursal,
      vacacion_licencia_centro_costo: formValues.vacacion_licencia_centro_costo,
      vacacion_licencia_tipo: formValues.vacacion_licencia_tipo,
      vacacion_licencia_subtipo: subtipo,
      vacacion_licencia_subtipo_subsidio: formValues.vacacion_licencia_subtipo_subsidio || '',
      vacacion_licencia_dias_solicitados: diasD,
      vacacion_licencia_fecha_inicio: formValues.vacacion_licencia_fecha_inicio instanceof Date ? formValues.vacacion_licencia_fecha_inicio.toISOString().split('T')[0] : formValues.vacacion_licencia_fecha_inicio,
      vacacion_licencia_fecha_fin: formValues.vacacion_licencia_fecha_fin instanceof Date ? formValues.vacacion_licencia_fecha_fin.toISOString().split('T')[0] : formValues.vacacion_licencia_fecha_fin,
      vacacion_licencia_motivo: formValues.vacacion_licencia_motivo,
      vacacion_licencia_estado: formValues.vacacion_licencia_estado
    };

    // Si es una nueva solicitud (camponuevo = true)
    if (this.camponuevo) {
      const currentData = this.vacacionesGridEffects.getRowData();
      this.vacacionesGridEffects.setRowData([solicitudData, ...currentData]);
      this.toastService.success('¡Solicitud registrada exitosamente!');

      // Limpiar formulario solo al registrar nuevo
      this.SolicitudForm.reset({
        vacacion_licencia_estado: 'Pendiente',
        vacacion_licencia_fecha_inicio: new Date(),
        vacacion_licencia_fecha_fin: new Date(),
      });
      this.SolicitudForm.enable();
      this.SolicitudForm.get('vacacion_licencia_sucursal')?.disable({ emitEvent: false });
      this.SolicitudForm.get('vacacion_licencia_centro_costo')?.disable({ emitEvent: false });
      this.SolicitudForm.get('vacacion_licencia_estado')?.disable({ emitEvent: false });
      this.SolicitudForm.get('tipoAnual')?.disable({ emitEvent: false });
      this.SolicitudForm.get('diasAnual')?.disable({ emitEvent: false });
      this.SolicitudForm.get('vacacion_licencia_subtipo')?.disable({ emitEvent: false });
      this.SolicitudForm.get('vacacion_licencia_dias_solicitados')?.disable({ emitEvent: false });
      this.SolicitudForm.get('vacacion_licencia_subtipo_subsidio')?.disable({ emitEvent: false });

      if (this.fileUploadComponent) {
        this.fileUploadComponent.removeFile();
      }

      this.filaSeleccionada = null;
      this.camponuevo = true;
      this.gridApi?.deselectAll();
    } 
    // Si es edición (camponuevo = false y hay una fila seleccionada)
    else if (this.filaSeleccionada) {
      const currentData = this.vacacionesGridEffects.getRowData();
      const index = currentData.findIndex(r => r.vacacion_licencia_codigo === this.filaSeleccionada.vacacion_licencia_codigo);
      if (index !== -1) {
        const updatedData = [...currentData];
        updatedData[index] = solicitudData;
        this.vacacionesGridEffects.setRowData(updatedData);
      }
      this.toastService.success('¡Cambios guardados exitosamente!');
    }

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }
  
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.vacacionesGridEffects.setGridApi(params.api);
  }

  // Generar código automático para nuevas operaciones
  generarNuevoCodigo(): string {
    const numeros = this.vacacionesGridEffects.getRowData().map(item => {
      const match = item.vacacion_licencia_codigo.match(/SOL-(\d+)/);
      return match ? parseInt(match[1], 10) : 0;
    });
    const maxNumero = Math.max(...numeros, 0);
    const nuevoNumero = (maxNumero + 1).toString().padStart(3, '0');
    return `SOL-${nuevoNumero}`;
  }

  onBtReset() {
    this.isResetting = true;
    this.rrHhFacade.cargarVacacionesLicenciasRegistro();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.isResetting = false;
      }
    }, 100);
  }
  async funcionCancelar() {
    // Validar cambios antes de cancelar PRIMERO
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Usuario canceló la cancelación, mantener estado actual
      return;
    }

    // Usuario confirma cancelación, ahora deseleccionar y limpiar
    this.gridApi?.deselectAll();
    
    this.camponuevo = true;
    this.filaSeleccionada = null;
    this.SolicitudForm.reset();
    
    // Habilitar todos los campos para edición
    this.SolicitudForm.enable();
    this.deshabilitado = false;
    
    // Establecer valores por defecto
    this.SolicitudForm.patchValue({
      vacacion_licencia_trabajador: '',
      vacacion_licencia_sucursal: '',
      vacacion_licencia_centro_costo: '',
      vacacion_licencia_estado: 'Pendiente',
      vacacion_licencia_fecha_inicio: new Date(),
      vacacion_licencia_fecha_fin: new Date(),
    });
    
    // Deshabilitar campos específicos
    this.SolicitudForm.get('vacacion_licencia_trabajador')?.enable();
    this.SolicitudForm.get('vacacion_licencia_sucursal')?.disable();
    this.SolicitudForm.get('vacacion_licencia_centro_costo')?.disable();
    this.SolicitudForm.get('vacacion_licencia_estado')?.disable();
    
    // Deshabilitar campos de subtipo y días hasta que se seleccione un tipo de solicitud
    this.SolicitudForm.get('tipoAnual')?.disable();
    this.SolicitudForm.get('diasAnual')?.disable();
    this.SolicitudForm.get('vacacion_licencia_subtipo')?.disable();
    this.SolicitudForm.get('vacacion_licencia_dias_solicitados')?.disable();
    this.SolicitudForm.get('vacacion_licencia_subtipo_subsidio')?.disable();

    // Limpiar el componente de carga de archivo
    if (this.fileUploadComponent) {
      this.fileUploadComponent.removeFile();
    }

    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar'},
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385'},
      { fechaHora: '20/11/2025 08:30', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380'},
      { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - '+this.filaSeleccionada.vacacion_licencia_codigo,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
       
      }
    });
    
    await modal.present();
  }

}
