import { Component, OnInit, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { RegistroUitFacade } from 'src/app/modules/contabilidad/application/facades/registro-uit.facade';
import { RegistroUitFeedbackEffects } from 'src/app/modules/contabilidad/effects/registro-uit-feedback.effect';
import { RegistroUitSyncEffects } from 'src/app/modules/contabilidad/effects/registro-uit-sync.effect';
import { RegistroUitEntity } from 'src/app/modules/contabilidad/domain/models/registro-uit.entity';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-c-t-registro-uit',
  templateUrl: './c-t-registro-uit.component.html',
  styleUrls: ['./c-t-registro-uit.component.scss'],
  standalone: false,
})
export class CTRegistroUitComponent  implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  // Clean Architecture — Facade + Effects
  readonly registroUitFacade  = inject(RegistroUitFacade);
  readonly feedbackEffects    = inject(RegistroUitFeedbackEffects);
  readonly syncEffects        = inject(RegistroUitSyncEffects);
  readonly isLoading          = this.registroUitFacade.isLoading;

  pais= this.country.getCountryCode();
  countries= ALL_COUNTRIES;
  valortributario = this.countries.find(c => c.codigo === this.pais)?.valortributario || 'UIT';
  monedapais =  this.countries.find(c => c.codigo === this.pais)?.monedapais?.[0]?.simbolo || 'S/';
  uitForm!: FormGroup;
  modoCreacion: boolean = true; // true = Registrar (nuevo), false = Guardar (editar)
  filaSeleccionada: any = null;
  private gridApi!: GridApi;
  showCalendars: boolean = true; // Bandera para forzar re-renderizado de calendarios

  // Variables para cal endario
  startDate: Date | undefined = undefined;
  endDate: Date | undefined = undefined;
  minDate: Date = new Date(2020, 0, 1);
  maxDate: Date = new Date(2030, 11, 31);


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

  columnDefs: ColDef[] = [
    { field: 'registro_uit_anio_fiscal', headerName: 'Año fiscal', flex: 1 },
    { field: 'registro_uit_valor_uit', headerName: 'Valor ' + this.valortributario , flex: 1,
      valueFormatter: (params: any) => {
        if (params.value) {
          return `${this.monedapais} ${params.value.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
        }
        return '';
      }
    },
    { field: 'registro_uit_fecha_inicio', headerName: 'Fecha de inicio', flex: 1,
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
    { field: 'registro_uit_fecha_fin', headerName: 'Fecha de fin', flex: 1,
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
    { field: 'registro_uit_estado', headerName: 'Estado', flex: 1, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Vigente') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Vigente</span>';
        } else if (params.value === 'Histórico') {
          return '<span class="badge-table bg-[#FFF0BF] text-[#F2A626]">Histórico</span>';
        }
        return params.value;
      }
    }
  ];

  rowData: RegistroUitEntity[] = [];

  constructor(
    private modalController: ModalController,
    private toastService: ToastService,
    private country: CountryService,
    private fb: FormBuilder,
    private formValidationService: FormValidationService
  ) {
    // Sincronizar rowData con el store via effect
    effect(() => {
      this.rowData = this.registroUitFacade.items();
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });

    // Registrar callbacks del feedback effect
    this.feedbackEffects.registrarCallbacks({
      onGuardarExito:    () => this.nuevaUIT(),
      onActualizarExito: () => this.nuevaUIT()
    });
  }

  ngOnInit() {
    this.initForm();
    this.formValidationService.inicializarFormulario(this.uitForm);
    this.registroUitFacade.cargarItems();
  }

  initForm() {
    this.uitForm = this.fb.group({
      fechaInicio: ['', Validators.required],
      fechaFin: ['', Validators.required],
      anioVigencia: ['', Validators.required],
      valorUIT: ['', Validators.required],
      estado: [{ value: 'Vigente', disabled: true }, Validators.required],
      vigente: [{ value: false, disabled: false }]
    });
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }
  // paisuit(){
  //   this.countries.find(c => {
  //     if(c.codigo === this.pais){
  //       return c.nombre;
  //     }})
  // }
  OnBtreset(){
    this.registroUitFacade.cargarItems();
  }
  onCellClicked(event: any) {
    const selectedRow = event.data;
    console.log('Celda clickeada:', selectedRow);
    
    this.filaSeleccionada = selectedRow;
    this.modoCreacion = false; // Cambiar a modo edición
    
    // Ocultar calendarios temporalmente
    this.showCalendars = false;
    
    // Parsear fechas
    const fechaInicio = new Date(selectedRow.registro_uit_fecha_inicio + 'T00:00:00');
    const fechaFin = new Date(selectedRow.registro_uit_fecha_fin + 'T00:00:00');
    
    // Autocompletar formulario
    this.uitForm.patchValue({
      fechaInicio: selectedRow.registro_uit_fecha_inicio,
      fechaFin: selectedRow.registro_uit_fecha_fin,
      anioVigencia: selectedRow.registro_uit_anio_fiscal,
      valorUIT: selectedRow.registro_uit_valor_uit,
      estado: selectedRow.registro_uit_estado,
      vigente: selectedRow.registro_uit_estado === 'Vigente'
    });
    
    // Si es vigente, marcar checkbox y deshabilitarlo
    this.uitForm.get('vigente')?.setValue(true);
    this.uitForm.get('vigente')?.disable();
    
    // Asignar fechas y volver a mostrar calendarios en el siguiente ciclo
    setTimeout(() => {
      this.startDate = fechaInicio;
      this.endDate = fechaFin;
      this.showCalendars = true;
    }, 0);

    this.formValidationService.resetearEstado();
  }

  
  onFechaInicio(fecha: Date) {
    this.startDate = fecha;
    this.uitForm.patchValue({
      fechaInicio: fecha
    });
  }
  onPeriodoAnualSeleccionado(anio: any) {
    this.uitForm.patchValue({
      anioVigencia: anio
    });
  }

  onFechaFin(fecha: Date) {
    this.endDate = fecha;
    this.uitForm.patchValue({
      fechaFin: fecha
    });
  }
  guardar(){
    // Usar getRawValue() para incluir campos deshabilitados
    if (this.uitForm.invalid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }
    
    const datosUIT = this.uitForm.getRawValue();
    console.log('UIT a guardar:', datosUIT);
    
    if (this.modoCreacion) {
      // Crear nuevo registro
      const nuevoRegistro: RegistroUitEntity = {
        registro_uit_anio_fiscal: datosUIT.anioVigencia,
        registro_uit_valor_uit: parseFloat(datosUIT.valorUIT),
        registro_uit_fecha_inicio: datosUIT.fechaInicio instanceof Date
          ? datosUIT.fechaInicio.toISOString().split('T')[0]
          : datosUIT.fechaInicio,
        registro_uit_fecha_fin: datosUIT.fechaFin instanceof Date
          ? datosUIT.fechaFin.toISOString().split('T')[0]
          : datosUIT.fechaFin,
        registro_uit_estado: datosUIT.estado
      };

      // Guardar via CA — feedback effect maneja toast + nuevaUIT()
      this.registroUitFacade.guardarItem(nuevoRegistro);
    } else {
      // Editar registro existente — actualizar via CA
      const registroActualizado: RegistroUitEntity = {
        registro_uit_anio_fiscal: datosUIT.anioVigencia,
        registro_uit_valor_uit: parseFloat(datosUIT.valorUIT),
        registro_uit_fecha_inicio: datosUIT.fechaInicio instanceof Date
          ? datosUIT.fechaInicio.toISOString().split('T')[0]
          : datosUIT.fechaInicio,
        registro_uit_fecha_fin: datosUIT.fechaFin instanceof Date
          ? datosUIT.fechaFin.toISOString().split('T')[0]
          : datosUIT.fechaFin,
        registro_uit_estado: datosUIT.estado
      };

      // Actualizar via CA — feedback effect maneja toast + nuevaUIT()
      this.registroUitFacade.actualizarItem(registroActualizado);
    }
  }

  async botonCancelar() {
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) {
      return;
    }
    this.nuevaUIT();
  }
  
  nuevaUIT() {
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    
    // Ocultar calendarios temporalmente
    this.showCalendars = false;
    
    // Resetear fechas a undefined
    this.startDate = undefined;
    this.endDate = undefined;
    
    // Resetear formulario con valores por defecto
    this.uitForm.reset({
      fechaInicio: '',
      fechaFin: '',
      anioVigencia: '',
      valorUIT: '',
      estado: 'Vigente',
      vigente: false
    });
    
    // Habilitar el campo vigente
    this.uitForm.get('vigente')?.enable();
    
    // Deseleccionar todas las filas
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Volver a mostrar calendarios limpios
    setTimeout(() => {
      this.showCalendars = true;
    }, 0);

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
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del tipo de cambio para Dólar' },
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de TC Venta de 3.380 a 3.385' },
      { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro de tipo de cambio del día - Fuente: SUNAT' },
    ];

    const defaultColDefModal: ColDef = {
      wrapText: true,
      autoHeight: true,
    };

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de actualizaciones de UIT',
        rowData: rowData,
        colDefs: colDefs,
        defaultColDef: defaultColDefModal,
        anchoModal: '700px',
      },
    });

    await modal.present();
  }
}
