import { Component, OnInit, ViewChild, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { BotonAccionesComponent } from 'src/app/ui/boton-acciones/boton-acciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { AutocompleteComponent } from 'src/app/ui/autocomplete/autocomplete.component';
import { ModalController } from '@ionic/angular';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { AgrupacionSedeEntity } from 'src/app/modules/rrhh/domain/models/agrupacion-sede.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-p-agrupacion-sede',
  templateUrl: './p-agrupacion-sede.component.html',
  styleUrls: ['./p-agrupacion-sede.component.scss'],
  standalone: false,
})
export class PAgrupacionSedeComponent  implements OnInit, CanComponentDeactivate {
  // Facades
  private readonly rrHhFacade = inject(RrHhFacade);

  // Selectores del store
  readonly isLoading = this.rrHhFacade.loadingAgrupacionSede;
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;



  @ViewChild(AutocompleteComponent) autocomplete!: AutocompleteComponent;
  
  mostrartabla: boolean = true;
  isResetting: boolean = false;
  grupoSeleccionado: AgrupacionSedeEntity | null = null;
  grupoTrabajadoresForm!: FormGroup;
  puedeExportar: boolean = false;
  botonNuevoHabilitado: boolean = false;
  formularioModificado: boolean = false;
  private valoresIniciales: any = {};
  
  // AG Grid - Tabla de grupos
  private gridApi!: GridApi;
  rowData: AgrupacionSedeEntity[] = [];
  colDefs: ColDef[] = [];
  defaultColDef: ColDef = {
    sortable: true,
    resizable: true,
    flex: 1,
    minWidth: 100,
  };
  localeText = {
    page: 'Página',
    of: 'de',
    to: 'a',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    noRowsToShow: 'No hay filas para mostrar',
  };
  
  // AG Grid - Tabla de trabajadores
  private gridApiTrabajadores!: GridApi;
  rowDataTrabajadores: any[] = [];
  colDefsTrabajadores: ColDef[] = [];
  
  criteriosPrincipales: string[] = [
    'Sede',
    'Centro de costo',
    'Canal',
    'Cargo',
    'Salario',
  ];

  sedes: string[] = [
    'Sede Lima Centro',
    'Sede Miraflores',
    'Sede San Isidro',
    'Sede Barranco',
    'Sede Surco'
  ];
  centrosCosto: string[] = [
    'Atención al cliente',
    'Cocina',
    'Administración',
    'Limpieza',
    'Seguridad',
  ];
  canales: string[] = [
    'Salón',
    'Delivery',
    'Eventos',
    'Otros'
  ];
  cargos: string[] = [
    'Cocinero y ayudante de cocina',
    'Gerente',
    'Administrador',
    'Cajero',
    'Mesero',
    'Chef',
    'Supervisor'
  ];
  salarios: string[] = [
    'S/1,200',
    'S/1,500',
    'S/2,000',
    'S/2,500',
    'S/3,000'
  ];  

  // Lista completa de trabajadores para el autocomplete
  trabajadores: any[] = [
    { agrupacion_sede_nombre: 'Carmen Zapata Guitiérrez', docfiscal: '02623746', agrupacion_sede_cargo: 'Cocinero', tipoContrato: 'Ocasional', remuneracion: 'S/2,000.00' },
    { agrupacion_sede_nombre: 'Jean Pierre Santillán García', docfiscal: '72623746', agrupacion_sede_cargo: 'Ayudante de cocina', tipoContrato: 'Parcial', remuneracion: 'S/1,200.00' },
    { agrupacion_sede_nombre: 'Sandra Carolina García Campos', docfiscal: '72623776', agrupacion_sede_cargo: 'Ayudante de cocina', tipoContrato: 'De suplencia', remuneracion: 'S/1,200.00' },
    { agrupacion_sede_nombre: 'Álvaro Jiménez', docfiscal: '72623772', agrupacion_sede_cargo: 'Ayudante de cocina', tipoContrato: 'De suplencia', remuneracion: 'S/1,200.00' },
    { agrupacion_sede_nombre: 'Laura Córdova Pérez', docfiscal: '72623798', agrupacion_sede_cargo: 'Ayudante de cocina', tipoContrato: 'De suplencia', remuneracion: 'S/1,200.00' }
  ];

  constructor(private fb: FormBuilder, private toastService: ToastService, private modalController: ModalController) { }

  ngOnInit() {
    this.inicializarFormulario();
    this.inicializarColumnasGrupos();
    this.inicializarColumnasTrabajadores();

    // Cargar grupos desde JSON a través de la capa de infraestructura
    this.rrHhFacade.cargarAgrupacionSede();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.rowData = [...this.rrHhFacade.agrupacionSede()];
        if (this.grupoSeleccionado) {
          const prevData = this.grupoSeleccionado;
          setTimeout(() => {
            this.gridApi?.forEachNode((node) => {
              if (node.data === prevData) {
                node.setSelected(true);
              }
            });
          }, 0);
        }
      }
    }, 100);
    
    // Suscribirse a cambios del formulario
    this.grupoTrabajadoresForm.valueChanges.subscribe(() => {
      this.detectarCambios();
    });
    
    // Iniciar en modo "Nuevo grupo"
    this.nuevoGrupo();
  }

  inicializarColumnasGrupos() {
    this.colDefs = [
      { field: 'agrupacion_sede_codigo', headerName: 'Código', width: 120 },
      { field: 'agrupacion_sede_fecha_creacion', headerName: 'Fecha creación', width: 130,
        valueFormatter: (params: any) => {
          if (!params.value) return '';
          const parts = params.value.split('-');
          if (parts.length === 3) {
            return `${parts[2]}/${parts[1]}/${parts[0]}`;
          }
          return params.value;
        }
      },
      { field: 'agrupacion_sede_nombre', headerName: 'Nombre', flex: 1, minWidth: 200 },
      { field: 'agrupacion_sede_criterio_principal', headerName: 'Criterio principal', width: 150 },
      { field: 'agrupacion_sede_num_trabajadores', headerName: 'N° trabajadores', width: 140 },
      { 
        field: 'agrupacion_sede_estado', 
        headerName: 'Estado',
        headerClass: 'centrarencabezado', 
        width: 100,
         cellRenderer: (params: any) => {
        const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
      }
    ];
  }

  inicializarColumnasTrabajadores() {
    this.colDefsTrabajadores = [
      { field: 'agrupacion_sede_nombre', headerName: 'Nombre', flex: 1, minWidth: 150 },
      { field: 'docfiscal', headerName: 'Documento fiscal', width: 100 },
      { field: 'tipoContrato', headerName: 'Tipo de contrato', width: 140 },
      { field: 'agrupacion_sede_cargo', headerName: 'Cargo', width: 120 },
      { field: 'remuneracion', headerName: 'Remuneración', headerClass:'derechaencabezado', width: 130,
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right'}
       },
      { 
        field: 'acciones', 
        headerName: 'Acciones', 
        width: 100,
        headerClass: 'centrarencabezado',
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        cellRenderer: BotonAccionesComponent
      }
    ];
  }

  cargarDatosGrupos() {
    // Los datos se cargan desde el JSON a través de RrHhFacade.cargarAgrupacionSede()
    // Este método se mantiene por compatibilidad pero la carga real ocurre en ngOnInit
  }

  onBtReset() {
    this.isResetting = true;
    this.rrHhFacade.cargarAgrupacionSede();
    const interval = setInterval(() => {
      if (!this.isLoading()) {
        clearInterval(interval);
        this.rowData = [...this.rrHhFacade.agrupacionSede()];
        this.isResetting = false;
      }
    }, 100);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    if (this.grupoSeleccionado) {
      const prevData = this.grupoSeleccionado;
      setTimeout(() => {
        this.gridApi?.forEachNode((node) => {
          if (node.data === prevData) {
            node.setSelected(true);
          }
        });
      }, 0);
    }
  }

  onGridReadyTrabajadores(params: GridReadyEvent) {
    this.gridApiTrabajadores = params.api;
  }

  async onCellClicked(event: any) {
    if (!event.data) return;

    const clickedNode = event.node;

    // Validar cambios antes de cambiar de grupo
    let confirmar = true;
    if (this.formularioModificado) {
      confirmar = await this.mostrarAlertaCambiosSinGuardar();
    }

    if (!confirmar) {
      // Usuario canceló - restaurar grupo anterior por referencia de objeto
      if (this.grupoSeleccionado) {
        const prevData = this.grupoSeleccionado;
        setTimeout(() => {
          this.gridApi?.deselectAll();
          this.gridApi?.forEachNode((node) => {
            if (node.data === prevData) {
              node.setSelected(true);
            }
          });
        }, 0);
      }
      return;
    }

    this.botonNuevoHabilitado = true;
    this.onGrupoSeleccionado(event.data);
    setTimeout(() => {
      this.gridApi?.deselectAll();
      clickedNode?.setSelected(true);
    }, 0);
  }

  inicializarFormulario() {
    const fechaHoy = new Date().toISOString().substring(0, 10);
    this.grupoTrabajadoresForm = this.fb.group({
      nombreGrupo: ['', Validators.required],
      agrupacion_sede_criterio_principal: ['', Validators.required],
      agrupacion_sede_sede: [''],
      agrupacion_sede_centro_costo: [''],
      agrupacion_sede_canal: [''],
      agrupacion_sede_cargo: [''],
      agrupacion_sede_salario: [''],
      agrupacion_sede_descripcion: [''],
      agrupacion_sede_num_trabajadores: [''],
      agrupacion_sede_fecha_creacion: [{ value: fechaHoy, disabled: true }],
      agrupacion_sede_estado: ['Activo', Validators.required]
    });
  }

  onGrupoSeleccionado(grupo: AgrupacionSedeEntity) {
    this.grupoSeleccionado = grupo;
    
    // Habilitar el formulario
    this.grupoTrabajadoresForm.enable();
    
    this.grupoTrabajadoresForm.patchValue({
      nombreGrupo: grupo.agrupacion_sede_nombre,
      agrupacion_sede_criterio_principal: grupo.agrupacion_sede_criterio_principal,
      agrupacion_sede_num_trabajadores: grupo.agrupacion_sede_num_trabajadores,
      agrupacion_sede_fecha_creacion: grupo.agrupacion_sede_fecha_creacion,
      agrupacion_sede_estado: grupo.agrupacion_sede_estado,
      agrupacion_sede_sede: grupo.agrupacion_sede_sede || '',
      agrupacion_sede_centro_costo: grupo.agrupacion_sede_centro_costo || '',
      agrupacion_sede_canal: grupo.agrupacion_sede_canal || '',
      agrupacion_sede_cargo: grupo.agrupacion_sede_cargo || '',
      agrupacion_sede_salario: grupo.agrupacion_sede_salario || '',
      agrupacion_sede_descripcion: grupo.agrupacion_sede_descripcion || ''
    });
    
    // Deshabilitar fechaCreación
    this.grupoTrabajadoresForm.get('agrupacion_sede_fecha_creacion')?.disable();
    
    // Cargar trabajadores del grupo seleccionado
    this.cargarTrabajadoresDelGrupo(grupo);
    
    // Guardar valores iniciales y resetear flag de modificado
    this.guardarValoresIniciales();
    this.formularioModificado = false;
  }
  
  cargarTrabajadoresDelGrupo(grupo: AgrupacionSedeEntity) {
    if (grupo.trabajadores && grupo.trabajadores.length > 0) {
      this.rowDataTrabajadores = [...grupo.trabajadores];
    } else {
      this.rowDataTrabajadores = [];
    }
    
    // Actualizar la tabla
    this.gridApiTrabajadores?.setGridOption('rowData', this.rowDataTrabajadores);
  }

  async modalverActualizaciones() {
    // Definir las columnas
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 150 },
      { headerName: 'Usuario', field: 'usuario', width: 120 },
      { headerName: 'Acción', field: 'accion', width: 150 },
      { 
        headerName: 'Detalle del cambio', 
        field: 'detalleCambio', 
        flex: 1,
        wrapText: true,
        autoHeight: true,
        cellStyle: { 
          whiteSpace: 'normal',
          lineHeight: '1.5'
        }
      }
    ];

    // Datos de ejemplo
    const rowData = [
      {
        fechaHora: '21/11/2025 09:00',
        usuario: 'Carlos Zapata',
        accion: 'Creación',
        detalleCambio: 'Registro inicial del grupo de trabajadores',
      },
      {
        fechaHora: '21/11/2025 09:05',
        usuario: 'Carlos Zapata',
        accion: 'Actualización',
        detalleCambio: 'Modificación del número de trabajadores de 10 a 12',
      },
      {
        fechaHora: '20/11/2025 08:30',
        usuario: 'Carlos Zapata',
        accion: 'Creación',
        detalleCambio: 'Registro de grupo con criterio principal: Cargo',
      },
      {
        fechaHora: '19/11/2025 08:45',
        usuario: 'Carlos Zapata',
        accion: 'Creación',
        detalleCambio: 'Registro inicial del grupo de trabajadores',
      },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de actualizaciones de ${this.grupoSeleccionado?.agrupacion_sede_nombre || 'grupo de trabajadores'}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      },
    });

    await modal.present();
  }

  async nuevoGrupo() {
    // Verificar si hay cambios sin guardar
    if (this.formularioModificado) {
      const confirmar = await this.mostrarAlertaCambiosSinGuardar();
      if (!confirmar) {
        return;
      }
    }
    
    const fechaHoy = new Date().toISOString().substring(0, 10);
    this.grupoSeleccionado = null;
    
    // Resetear el formulario
    this.grupoTrabajadoresForm.reset({
      agrupacion_sede_fecha_creacion: fechaHoy,
      agrupacion_sede_estado: 'Activo'
    });
    
    // Habilitar todos los campos del formulario
    this.grupoTrabajadoresForm.enable();
    
    // Desactivar solo la fecha de creación
    this.grupoTrabajadoresForm.get('agrupacion_sede_fecha_creacion')?.disable();
    
    // Limpiar la selección del grid
    this.gridApi?.deselectAll();
    
    // Limpiar la tabla de trabajadores
    this.rowDataTrabajadores = [];
    this.gridApiTrabajadores?.setGridOption('rowData', this.rowDataTrabajadores);
    
    // Desactivar los botones de exportar
    this.puedeExportar = false;
    
    // Deshabilitar el botón "Nuevo grupo"
    this.botonNuevoHabilitado = false;
    
    // Guardar valores iniciales y resetear flag
    this.guardarValoresIniciales();
    this.formularioModificado = false;
  }

  guardar() {
    if (this.grupoTrabajadoresForm.invalid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }
    if(this.rowDataTrabajadores.length === 0){
      this.toastService.warning('Debe agregar al menos un trabajador al grupo');
      return;
    }
    if (this.grupoTrabajadoresForm.valid && this.rowDataTrabajadores.length > 0) {
      // Generar código único para el nuevo grupo
      const ultimoCodigo = this.rowData.length > 0 ? this.rowData[0].agrupacion_sede_codigo : 'GT-000000';
      const numeroActual = parseInt(ultimoCodigo.split('-')[1]) + 1;
      const nuevoCodigo = `GT-${String(numeroActual).padStart(6, '0')}`;
      
      // Obtener valores del formulario
      const formValue = this.grupoTrabajadoresForm.getRawValue();
      
      // Crear el nuevo grupo
      const nuevoGrupo: AgrupacionSedeEntity = {
        agrupacion_sede_codigo: nuevoCodigo,
        agrupacion_sede_fecha_creacion: formValue.agrupacion_sede_fecha_creacion,
        agrupacion_sede_nombre: formValue.nombreGrupo,
        agrupacion_sede_criterio_principal: formValue.agrupacion_sede_criterio_principal,
        agrupacion_sede_num_trabajadores: this.rowDataTrabajadores.length,
        agrupacion_sede_estado: formValue.agrupacion_sede_estado,
        agrupacion_sede_sede: formValue.agrupacion_sede_sede || undefined,
        agrupacion_sede_centro_costo: formValue.agrupacion_sede_centro_costo || undefined,
        agrupacion_sede_canal: formValue.agrupacion_sede_canal || undefined,
        agrupacion_sede_cargo: formValue.agrupacion_sede_cargo || undefined,
        agrupacion_sede_salario: formValue.agrupacion_sede_salario || undefined,
        agrupacion_sede_descripcion: formValue.agrupacion_sede_descripcion || undefined,
        trabajadores: [...this.rowDataTrabajadores]
      };
      
      // Agregar al inicio de la tabla
      this.rowData = [nuevoGrupo, ...this.rowData];
      this.gridApi?.setGridOption('rowData', this.rowData);
      
      // Habilitar botones de exportar
      this.puedeExportar = true;
      
      // Mostrar toast de éxito
      this.toastService.success('¡Grupo registrado con éxito!');
      
      // Resetear flag de modificado antes de llamar nuevoGrupo
      this.formularioModificado = false;
      
      // Resetear a modo "Nuevo grupo"
      this.nuevoGrupo();
    }
  }

  seleccionarTrabajador(trabajador: any) {
    if (!trabajador) return;
    
    // Obtener el límite de trabajadores
    const limite = this.grupoTrabajadoresForm.get('agrupacion_sede_num_trabajadores')?.value;
    
    // Validar si ya existe el trabajador
    const existe = this.rowDataTrabajadores.find(t => t.docfiscal === trabajador.docfiscal);
    if (existe) {
      this.toastService.warning('El trabajador ya está agregado al grupo');
      return;
    }
    
    // Validar si se alcanzó el límite
    if (limite && this.rowDataTrabajadores.length >= limite) {
      this.toastService.warning(`Solo puedes agregar ${limite} trabajadores según el límite establecido`);
      return;
    }
    
    // Agregar trabajador a la tabla
    this.rowDataTrabajadores = [...this.rowDataTrabajadores, trabajador];
    this.gridApiTrabajadores?.setGridOption('rowData', this.rowDataTrabajadores);
    
    // Actualizar el campo N° de trabajadores en el formulario
    this.grupoTrabajadoresForm.patchValue({
      agrupacion_sede_num_trabajadores: this.rowDataTrabajadores.length
    });
    
    // Detectar cambios después de agregar trabajador
    this.detectarCambios();
    
    // Limpiar el autocomplete después de agregar el trabajador
    setTimeout(() => {
      this.autocomplete?.clearSelection();
    }, 0);
  }

  eliminarArticulo(trabajador: any) {
    this.rowDataTrabajadores = this.rowDataTrabajadores.filter(t => t.docfiscal !== trabajador.docfiscal);
    this.gridApiTrabajadores?.setGridOption('rowData', this.rowDataTrabajadores);
    
    // Actualizar el campo N° de trabajadores en el formulario
    this.grupoTrabajadoresForm.patchValue({
      agrupacion_sede_num_trabajadores: this.rowDataTrabajadores.length
    });
    
    // Detectar cambios después de eliminar trabajador
    this.detectarCambios();
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
    const fechaHoy = new Date().toISOString().substring(0, 10);
    this.grupoSeleccionado = null;
    
    // Resetear el formulario
    this.grupoTrabajadoresForm.reset({
      agrupacion_sede_fecha_creacion: fechaHoy,
      agrupacion_sede_estado: 'Activo'
    });
    
    // Habilitar todos los campos del formulario
    this.grupoTrabajadoresForm.enable();
    
    // Desactivar solo la fecha de creación
    this.grupoTrabajadoresForm.get('agrupacion_sede_fecha_creacion')?.disable();
    
    // Limpiar la tabla de trabajadores
    this.rowDataTrabajadores = [];
    this.gridApiTrabajadores?.setGridOption('rowData', this.rowDataTrabajadores);
    
    // Guardar valores iniciales y resetear flag
    this.guardarValoresIniciales();
    this.formularioModificado = false;
    this.botonNuevoHabilitado = false;
  }

  guardarValoresIniciales() {
    this.valoresIniciales = {
      ...this.grupoTrabajadoresForm.getRawValue(),
      trabajadores: [...this.rowDataTrabajadores]
    };
  }

  detectarCambios() {
    const valoresActuales = this.grupoTrabajadoresForm.getRawValue();
    const valoresInicialesForm = { ...this.valoresIniciales };
    delete valoresInicialesForm.trabajadores;
    
    // Comparar valores del formulario
    const formularioCambiado = JSON.stringify(valoresActuales) !== JSON.stringify(valoresInicialesForm);
    
    // Comparar trabajadores
    const trabajadoresCambiados = JSON.stringify(this.rowDataTrabajadores) !== JSON.stringify(this.valoresIniciales.trabajadores || []);
    
    this.formularioModificado = formularioCambiado || trabajadoresCambiados;
    console.log('detectarCambios - formularioModificado:', this.formularioModificado);
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
        // Si el usuario confirma salir, limpiar el formulario y resetear el estado
        this.formularioModificado = false;
        const fechaHoy = new Date().toISOString().substring(0, 10);
        this.grupoSeleccionado = null;
        this.grupoTrabajadoresForm.reset({
          agrupacion_sede_fecha_creacion: fechaHoy,
          agrupacion_sede_estado: 'Activo'
        });
        this.rowDataTrabajadores = [];
        this.botonNuevoHabilitado = false;
        if (this.gridApi) {
          this.gridApi.deselectAll();
        }
      }
      return resultado;
    }
    return true;
  }

}
