import { Component, OnInit, OnDestroy, inject, effect } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent,} from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { AseguradoraFacade } from '../../../application/facades/aseguradora.facade';
import { AseguradoraFeedbackEffects } from '../../../effects/aseguradora-feedback.effect';
import { AseguradoraEntity } from '../../../domain/models/aseguradora.entity';

// Font Awesome Icons
import { faBook, faSearch as faSearchRegular } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight, faSearch as faSearchSolid } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-activofijo-tabla-aseguradores',
  templateUrl: './activofijo-tabla-aseguradores.component.html',
  styleUrls: ['./activofijo-tabla-aseguradores.component.scss'],
  standalone: false,
})
export class ActivofijoTablaAseguradoresComponent implements OnInit, OnDestroy, CanComponentDeactivate {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearchRegular;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;
  fasSearch = faSearchSolid;



  // ─────────── Inyección del Facade y Effects ───────────
  private readonly aseguradoraFacade   = inject(AseguradoraFacade);
  private readonly feedbackEffects     = inject(AseguradoraFeedbackEffects);

  // ─────────── Selectores del store ───────────
  readonly aseguradorasSignal = this.aseguradoraFacade.aseguradoras;
  readonly isLoading          = this.aseguradoraFacade.isLoading;

  gridApi!: GridApi;
  camponuevo: boolean = true;
  estadoSeleccionado: string = 'todos';
  AseguradoraForm!: FormGroup;
  filaSeleccionada: AseguradoraEntity | null = null;
  tituloform = '';

  columnTypes = {
    currency: {
      width: 150,
    },
    shaded: {
      cellClass: 'shaded-class',
    },
  };
  defaultColDef = {
    resizable: true,
    flex: 1,
    minWidth: 100,
  };

  // rowData se llena reactivamente desde el store via effect()
  rowData: AseguradoraEntity[] = [];

  colDefs: ColDef<AseguradoraEntity>[] = [
    { field: 'aseguradora_codigo',       headerName: 'Código',           headerClass: 'ag-header-hover ag-header-10px', flex: 0.7, minWidth: 70,  },
    { field: 'aseguradora_razon_social', headerName: 'Razón Social',     headerClass: 'ag-header-hover ag-header-10px', flex: 2,   minWidth: 150, },
    { field: 'aseguradora_doc_fiscal',   headerName: 'Documento Fiscal', headerClass: 'ag-header-hover ag-header-10px', flex: 1.2, minWidth: 100, },
    { field: 'aseguradora_contacto',     headerName: 'Contacto',         headerClass: 'ag-header-hover ag-header-10px', flex: 1.5, minWidth: 120, },
    { field: 'aseguradora_telefono',     headerName: 'Teléfono',         headerClass: 'ag-header-hover ag-header-10px', flex: 1.2, minWidth: 110, },
    {
      field: 'aseguradora_estado', filter: true,
      headerClass: 'centrarencabezado',
      headerName: 'Estado',
      flex: 0.8, minWidth: 80,
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

  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController,
    private formValidationService: FormValidationService
  ) {
    // Effect: actualiza la tabla en cuanto cambian los datos del store
    effect(() => {
      const aseguradoras = this.aseguradorasSignal();
      this.rowData = aseguradoras;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });
  }

  ngOnInit() {
    this.AseguradoraForm = this.formBuilder.group({
      search: new FormControl(''),
      filtroEstado: new FormControl('todos'),
      razonSocial: new FormControl('', [Validators.required]),
      codigoAseguradora: new FormControl('', [Validators.required]),
      rucNitIdFiscal: new FormControl('', [Validators.required]),
      direccionFiscal: new FormControl('', [Validators.required]),
      telefonoPrincipal: new FormControl('', [Validators.required]),
      correoContacto: new FormControl('', [Validators.required]),
      contactoPrincipal: new FormControl('', [Validators.required]),
      paginaWeb: new FormControl(''),
      condicionesComerciales: new FormControl('', [Validators.required]),
      estado: new FormControl('Activo', [Validators.required]),
      observaciones: new FormControl(''),
      documentoproveedor: new FormControl('RUC'),
    });

    // Inicializar servicio de validación de formularios
    this.formValidationService.inicializarFormulario(this.AseguradoraForm);

    // Inicializar en modo creación con código automático
    setTimeout(() => {
      const nuevoCodigo = this.generarNuevoCodigo();
      this.AseguradoraForm.patchValue({
        codigoAseguradora: nuevoCodigo
      });
      this.formValidationService.resetearEstado();
    }, 0);

    // Cargar aseguradoras desde el store (JSON + localStorage)
    this.aseguradoraFacade.cargarAseguradoras();
  }

  buscarrdfiscal() {
    const rucBuscado = this.AseguradoraForm.get('rucNitIdFiscal')?.value;

    if (!rucBuscado) {
      this.toastService.warning('Por favor, ingrese un RUC/NIT para buscar');
      return;
    }

    const rucString = String(rucBuscado);
    const aseguradoraEncontrada = this.rowData.find(
      (a: AseguradoraEntity) => a.aseguradora_doc_fiscal === rucString
    );

    if (aseguradoraEncontrada) {
      this.AseguradoraForm.patchValue({
        razonSocial:       aseguradoraEncontrada.aseguradora_razon_social,
        codigoAseguradora: aseguradoraEncontrada.aseguradora_codigo,
        contactoPrincipal: aseguradoraEncontrada.aseguradora_contacto ?? '',
        telefonoPrincipal: aseguradoraEncontrada.aseguradora_telefono ?? '',
        estado:            aseguradoraEncontrada.aseguradora_estado,
      });
    } else {
      this.toastService.warning('No se encontró una aseguradora con ese RUC/NIT');
    }
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }
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

  async onCellClicked(event: any) {
    if (!event.data) return;
    
    // Validar cambios antes de cambiar de aseguradora
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
    this.cargarDatosRegistro(event.data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosRegistro(data: AseguradoraEntity, node?: any): void {
    this.camponuevo = false;
    this.filaSeleccionada = data;
    
    if (node && !node.isSelected()) {
      node.setSelected(true);
    }

    this.tituloform = data.aseguradora_codigo;
    this.AseguradoraForm.patchValue({
      razonSocial: data.aseguradora_razon_social || '',
      codigoAseguradora: data.aseguradora_codigo || '',
      rucNitIdFiscal: data.aseguradora_doc_fiscal || '',
      direccionFiscal: data.aseguradora_direccion_fiscal || '',
      telefonoPrincipal: data.aseguradora_telefono || '',
      correoContacto: data.aseguradora_correo || '',
      contactoPrincipal: data.aseguradora_contacto || '',
      paginaWeb: data.aseguradora_pagina_web || '',
      condicionesComerciales: data.aseguradora_condiciones_comerciales || '',
      estado: data.aseguradora_estado || '',
      observaciones: data.aseguradora_observaciones || '',
      documentoproveedor: data.aseguradora_tipo_documento || 'RUC',
    });

    this.formValidationService.resetearEstado();
  }
  async botonNuevaOperacion() {
    // Validar cambios antes de limpiar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    this.camponuevo = true;
    this.filaSeleccionada = null; // Limpiar la fila seleccionada
    this.gridApi?.deselectAll(); // Deseleccionar filas en la tabla
    this.AseguradoraForm.reset();
    
    // Generar código automático
    const nuevoCodigo = this.generarNuevoCodigo();
    
    // Solo establecer valores por defecto
    this.AseguradoraForm.patchValue({
      codigoAseguradora: nuevoCodigo,
      estado: 'Activo',
      documentoproveedor: 'RUC'
    });
    
    // Resetear estado del servicio de validación
    this.formValidationService.resetearEstado();
  }
  botonGuardar() {
    Object.keys(this.AseguradoraForm.controls).forEach(key => {
      this.AseguradoraForm.get(key)?.markAsTouched();
    });

    if (this.AseguradoraForm.invalid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    const formValues = this.AseguradoraForm.value;
    const nuevoCodigo = this.camponuevo ? this.generarNuevoCodigo() : formValues.codigoAseguradora;

    const aseguradoraData: AseguradoraEntity = {
      aseguradora_codigo: nuevoCodigo,
      aseguradora_razon_social: formValues.razonSocial,
      aseguradora_doc_fiscal: formValues.rucNitIdFiscal,
      aseguradora_tipo_documento: formValues.documentoproveedor,
      aseguradora_direccion_fiscal: formValues.direccionFiscal,
      aseguradora_telefono: formValues.telefonoPrincipal,
      aseguradora_correo: formValues.correoContacto,
      aseguradora_contacto: formValues.contactoPrincipal,
      aseguradora_pagina_web: formValues.paginaWeb,
      aseguradora_condiciones_comerciales: formValues.condicionesComerciales,
      aseguradora_observaciones: formValues.observaciones,
      aseguradora_estado: formValues.estado,
    };

    if (this.camponuevo) {
      // Modo creación: persistir y recargar vía facade
      this.aseguradoraFacade.guardarAseguradora(aseguradoraData);
    } else if (this.filaSeleccionada) {
      // Modo edición: actualizar vía facade
      this.aseguradoraFacade.actualizarAseguradora(aseguradoraData);
    }

    // Limpiar y volver a modo creación
    const siguienteCodigo = this.generarNuevoCodigo();
    this.AseguradoraForm.reset();
    this.AseguradoraForm.patchValue({
      codigoAseguradora: siguienteCodigo,
      estado:            'Activo',
      documentoproveedor: 'RUC',
    });
    this.filaSeleccionada = null;
    this.camponuevo       = true;
    this.tituloform       = '';

    this.formValidationService.resetearEstado();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;

    // Iniciar en modo creación (formulario vacío)
    // No seleccionar ninguna fila automáticamente
  }

  // Generar código automático para nuevas aseguradoras
  generarNuevoCodigo(): string {
    const numeros = this.rowData.map((item: AseguradoraEntity) => {
      const match = item.aseguradora_codigo?.match(/ASG-(\d+)/);
      return match ? parseInt(match[1], 10) : 0;
    });
    const maxNumero  = Math.max(...numeros, 0);
    const nuevoNumero = (maxNumero + 1).toString().padStart(3, '0');
    return `ASG-${nuevoNumero}`;
  }

  puedeGuardar(): boolean {
    // El botón se habilita solo si el formulario es válido
    if (!this.AseguradoraForm.valid) {
      return false;
    }

    // Si es modo nuevo, solo validar que sea válido
    if (this.camponuevo) {
      return true;
    }

    // Si es modo edición, solo habilitar cuando hay cambios
    return this.formValidationService.tieneModificaciones();
  }
  onBtReset() {
    if (this.gridApi) {
      this.gridApi.showLoadingOverlay();
      // Recargar datos desde el store (JSON + localStorage)
      this.aseguradoraFacade.cargarAseguradoras();
      setTimeout(() => {
        this.gridApi.hideOverlay();
      }, 400);
    }
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
      {
        fechaHora: '21/11/2025 09:00',
        usuario: 'Carlos Zapata',
        accion: 'Creación',
        detalleCambio: 'Registro inicial del tipo de cambio para Dólar'
      },
      {
        fechaHora: '21/11/2025 09:05',
        usuario: 'Carlos Zapata',
        accion: 'Actualización',
        detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385'
      },
      {
        fechaHora: '20/11/2025 08:30',
        usuario: 'Carlos Zapata',
        accion: 'Creación',
        detalleCambio: 'Registro de tipo de cambio con TC Compra: 3.372 y TC Venta: 3.380'
      },
      {
        fechaHora: '19/11/2025 08:45',
        usuario: 'Carlos Zapata',
        accion: 'Creación',
        detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT'
      }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones - Tipo de Cambio',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',

      }
    });

    await modal.present();
  }

}

