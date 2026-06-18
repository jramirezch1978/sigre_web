import { Component, OnInit, inject, computed, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ClonacionAsientosFacade } from 'src/app/modules/contabilidad/application/facades/clonacion-asientos.facade';
import { ClonacionAsientosFeedbackEffects } from 'src/app/modules/contabilidad/effects/clonacion-asientos-feedback.effect';
import { ClonacionAsientoItem } from 'src/app/modules/contabilidad/domain/models/clonacion-asientos.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faChevronsLeft, faChevronsRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-c-p-clonacionasientos',
  templateUrl: './c-p-clonacionasientos.component.html',
  styleUrls: ['./c-p-clonacionasientos.component.scss'],
  standalone: false,
})
export class CPClonacionasientosComponent  implements OnInit, CanComponentDeactivate {
  // Font Awesome Icons
  farSearch = faSearch;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;

  // Clean Architecture — Facade & Effects
  private readonly clonacionFacade   = inject(ClonacionAsientosFacade);
  private readonly feedbackEffects   = inject(ClonacionAsientosFeedbackEffects);

  // Señales expuestas desde el store
  readonly isLoading   = computed(() => this.clonacionFacade.isLoading());
  readonly asientosC   = computed(() => this.clonacionFacade.items() as ClonacionAsientoItem[]);

  asientoForm!: FormGroup;
  mostartitulo= false;
  ajusteCForm!: FormGroup;
  private gridApi!: GridApi;
  gridContext!: { componentParent: CPClonacionasientosComponent };
  asientoSeleccionado: ClonacionAsientoItem | null = null;
  pais= this.countryService.getCountryCode();
  panelLateralVisible= true;
  cantidad: any | null = null;

  rowFiltrado: any[]=[];
  
  // Variables para tracking de cambios en el formulario
  private formularioInicial: any = null;
  private formularioModificado: boolean = false;
  private asientoClonado: boolean = false;

  // Arreglos para los selects
  estados=[
    { value: 'activo', nombre: 'Activo'},
    { value: 'inactivo', nombre: 'Inactivo'},
  ]

  tipoAjs=[
    { value: 'tipocambio', nombre: 'Ajuste por tipo de cambio'},
    { value: 'redondeo', nombre: 'Ajuste por redondeo'},
  ]

  libroSelect = [
     { value: 'diario', nombre: 'Diario' },
     { value: 'mayor', nombre: 'Mayor' },
     { value: 'compras', nombre: 'Compras' },
     { value: 'ventas', nombre: 'Ventas' }
   ];

  monedaSelect=[
    { nombre: 'Soles', value: 'soles' },
    { nombre: 'Dólares', value: 'dolares' },
  ];

  // tasaCSelect=[
  //   { nombre: 'Soles', value: 'soles' },
  //   { nombre: 'Dólares', value: 'dolares' },
  // ];

  estadoSelect = [
    { value: 'activo', nombre: 'Activo' },
    { value: 'inactivo', nombre: 'Inactivo' }
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
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  rowDataDetalle: any[] = [];

  rowDetalle = [
    { cuenta: '601201', descripcion: 'Compras de insumos', debe: 'S/1,000.00', haber: 'S/1,000.00'},
    { cuenta: '401111', descripcion: 'IGV por pagar', debe: 'S/180.00', haber: 'S/1,000.0'},
    { cuenta: '421101', descripcion: 'Proveedores - Nacionales', debe: '-', haber: '-'},
  ];

  total={ debeS: '380.00', debeD: '112.00', haberS: '380.00', haberD: '112.00'} 


  colDefsDetalle: ColDef[] = [
    { field: 'cuenta', headerName: 'Cuenta', width: 100 },
    { field: 'descripcion', headerName: 'Descripción', width: 180 },
    {  field: 'debe',  headerName: 'Debe(S/)',  width: 120, valueFormatter: p => p.value || '-'},
    {  field: 'haber',  headerName: 'Haber(S/)',  width: 120, valueFormatter: p => p.value || '-'},
  ];

  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private router : Router,
    private modalController: ModalController,
    private countryService: CountryService,
  ) {
  }

  ngOnInit() {

  // Cargar asientos desde el repositorio JSON
  this.clonacionFacade.cargarDatos();

  this.asientoForm = this.formBuilder.group({
    periodoContable: [''],
    moneda: [''],
    asientoC: ['', Validators.required],
    tipoAsiento: [{value: 'Manual', disabled: true}],
    fechaN: [new Date(), Validators.required],
    glosa: [''],
    periodoContableDestino: ['', Validators.required],
  });

  // Inicializar formulario con valores por defecto para evitar errores al usarlo
  this.ajusteCForm = this.formBuilder.group({
    usuario: [{value: '', disabled: true}],
    fechaR: [{value: '', disabled: true}],
    origen: [{value: '', disabled: true}],
    fechaC: [''],
    tipoFlujo: ['', Validators.required],
    moneda: [''],
    tipoC: [{value: '3.33', disabled: true}],
    estado: ['', Validators.required],
    situacion: [{value: '', disabled: true}],
    glosa: [''],
  });
  
  // Contexto de la grilla (si se usa en cellRenderers u otros)
  this.gridContext = { componentParent: this };
  
  // TRACKING DE CAMBIOS - Suscribirse a cambios del formulario derecho
  this.ajusteCForm.valueChanges.subscribe(() => {
    this.verificarCambios();
  });
  }

  onAsientoSeleccionado(evento: any) {
    console.log('Asiento seleccionado:', evento);

    // Buscar el asiento completo desde el store
    const asientoCompleto = this.asientosC().find((a: ClonacionAsientoItem) => a.nasiento === evento.nasiento);

    if (asientoCompleto) {

      // Guardar temporalmente el asiento seleccionado
      this.asientoSeleccionado = asientoCompleto;

      // Cargar cuentas del asiento si existen
      if (asientoCompleto.cuentas && asientoCompleto.cuentas.length > 0) {
        this.rowDataDetalle = asientoCompleto.cuentas;
      }

      // Llenar SOLO el formulario izquierdo
      this.asientoForm.patchValue({
        asientoC: asientoCompleto.nasiento,
        tipoAsiento: 'Manual',
        moneda: asientoCompleto.moneda,
        glosa: asientoCompleto.glosa,
        fechaN: asientoCompleto.fechaR,
        periodoContable: '',
        periodoContableDestino: ''
      });

    }
  }



  onPeriodoSeleccionado(event: any) {
    console.log('Periodo seleccionado:', event);
    
    let periodoValue = '';
    
    // El evento viene como {month: number, year: number}
    if (event && typeof event === 'object' && event.month && event.year) {
      const year = event.year;
      const month = String(event.month).padStart(2, '0');
      periodoValue = `${year}${month}`;
    } else if (event instanceof Date) {
      const year = event.getFullYear();
      const month = String(event.getMonth() + 1).padStart(2, '0');
      periodoValue = `${year}${month}`;
    } else if (typeof event === 'string') {
      periodoValue = event;
    }
    
    if (periodoValue) {
      this.asientoForm.patchValue({ periodoContable: periodoValue });
      console.log('Periodo guardado en formulario:', periodoValue);
    } else {
      console.warn('No se pudo procesar el evento del período:', event);
    }
  }

  onPeriodoSeleccionadoDestino(event: any) {
    console.log('Periodo seleccionado:', event);
    
    let periodoValue = '';
    
    // El evento viene como {month: number, year: number}
    if (event && typeof event === 'object' && event.month && event.year) {
      const year = event.year;
      const month = String(event.month).padStart(2, '0');
      periodoValue = `${year}${month}`;
    } else if (event instanceof Date) {
      const year = event.getFullYear();
      const month = String(event.getMonth() + 1).padStart(2, '0');
      periodoValue = `${year}${month}`;
    } else if (typeof event === 'string') {
      periodoValue = event;
    }
    
    if (periodoValue) {
      this.asientoForm.patchValue({ periodoContableDestino: periodoValue });
      console.log('Periodo guardado en formulario:', periodoValue);
    } else {
      console.warn('No se pudo procesar el evento del período:', event);
    }
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  async clonarAsiento() {
    this.clonacionFacade.cargarDatos();
    // Verificar si hay cambios sin guardar antes de clonar
    if (this.asientoClonado && this.formularioModificado) {
      const continuar = await this.mostrarModalConfirmacion();
      if (!continuar) {
        return; // Cancelar la clonación
      }
    }

    if (!this.asientoForm.valid) {
      this.toastService.danger('Completa los campos requeridos');
      return;
    }
    this.mostartitulo=true;
    if (!this.asientoSeleccionado) {
      this.toastService.danger('Selecciona un asiento primero');
      return;
    }

    const asiento = this.asientoSeleccionado as ClonacionAsientoItem;

    const asientoClonado = {
      nasiento: `${asiento.nasiento}-CLON`,
      fechaRegistro: new Date(),
      fechaContable: this.asientoForm.value.periodoContableDestino,
      glosa: this.asientoForm.value.glosa,
      situacionContable: asiento.situacionC,
      total: asiento.total,
      estado: asiento.estado,
      usuario: 'Admin Sistema',
      origen: 'Clonación',
      tipoFlujo: asiento.tipoFlujo,
      moneda: asiento.moneda,
      tasaC: asiento.tasaC
    };

    // Llenar SOLO en este momento el formulario derecho:
    this.ajusteCForm.patchValue({
      usuario: asientoClonado.usuario,
      fechaR: asientoClonado.fechaRegistro,
      origen: asientoClonado.origen,
      fechaC: asientoClonado.fechaContable,
      tipoFlujo: asientoClonado.tipoFlujo,
      moneda: asientoClonado.moneda,
      tasaC: asientoClonado.tasaC,
      estado: asientoClonado.estado,
      situacion: asientoClonado.situacionContable,
      glosa: asientoClonado.glosa,
    });

    this.rowDataDetalle= this.rowDetalle;
    this.cantidad=this.total;

    // AHORA sí activar seguimiento de cambios
    this.asientoClonado = true;
    this.guardarEstadoInicial();
    this.formularioModificado = false;
  }



  onFechaNSeleccionada(date: Date) {
    if (this.asientoForm && date) {
      const fechaCtrl = this.ajusteCForm.get('fechaR');
      if (fechaCtrl) {
        fechaCtrl.setValue(date);
      }
    }
  }

  onFechaRSeleccionada(date: Date) {
    if (this.ajusteCForm && date) {
      const fechaCtrl = this.ajusteCForm.get('fechaR');
      if (fechaCtrl) {
        fechaCtrl.setValue(date);
      }
    }
  }

  onFechaCSeleccionada(date: Date) {
    if (this.ajusteCForm && date) {
      const fechaCtrl = this.ajusteCForm.get('fechaC');
      if (fechaCtrl) {
        fechaCtrl.setValue(date);
      }
    }
  }

  botonAjustarAsiento() {
    if (!this.ajusteCForm.valid) {
      this.toastService.danger('Completa todos los campos obligatorios');
      return;
    }

    this.router.navigate(['contabilidad/operaciones/gestion-asientos-manual']),
    this.toastService.success('¡Asiento registrado exiosamente!');
    
    // Resetear seguimiento después de guardar
    this.formularioModificado = false;
    this.asientoClonado = false;
  }

  // Métodos de validación de cambios
  guardarEstadoInicial() {
    this.formularioInicial = this.ajusteCForm.getRawValue();
  }

  verificarCambios() {
    if (!this.asientoClonado) {
      return; // No verificar cambios si no se ha clonado ningún asiento
    }

    const estadoActual = this.ajusteCForm.getRawValue();
    this.formularioModificado =
      JSON.stringify(this.formularioInicial) !== JSON.stringify(estadoActual);
  }

  async mostrarModalConfirmacion(): Promise<boolean> {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      componentProps: {
        title: '¿Seguro que quieres continuar sin guardar la información?',
        message: 'Si sales ahora, perderás la información ingresada',
          btnOkTxt: 'Continuar',
          btnCancelTxt: 'Cancelar',
      },
      cssClass: 'promo',
    });

    await modal.present();
    const { data } = await modal.onWillDismiss();
    return data?.confirmed || false;
  }

  async canDeactivate(): Promise<boolean> {
    if (this.asientoClonado && this.formularioModificado) {
      return await this.mostrarModalConfirmacion();
    }
    return true;
  }
}

