import { Component, OnInit, ViewChild, inject, effect } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { FacturacionRegaliasFacade } from '../../application/facades/facturacion-regalias.facade';
import { FacturacionRegaliasEntity } from '../../domain/models/facturacion-regalias.entity';
import { FacturacionRegaliasFeedbackEffects } from '../../effects/facturacion-regalias-feedback.effect';

// Font Awesome Icons
import { faBook, faSearch as faSearchRegular } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCirclePlus, faDownload, faRotateRight, faSearch as faSearchSolid } from '@fortawesome/pro-solid-svg-icons';

// Font Awesome Icons

@Component({
  selector: 'app-v-o-facturacion-de-regalias',
  templateUrl: './v-o-facturacion-de-regalias.component.html',
  styleUrls: ['./v-o-facturacion-de-regalias.component.scss'],
  standalone: false,
})
export class VOFacturacionDeRegaliasComponent implements OnInit, CanComponentDeactivate {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearchRegular;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;
  fasSearch = faSearchSolid;

  // Inyección del Facade y Effects
  private readonly facturacionFacade = inject(FacturacionRegaliasFacade);
  private readonly feedbackEffects = inject(FacturacionRegaliasFeedbackEffects);

  // Selectores reactivos del Facade
  readonly facturasSignal = this.facturacionFacade.facturas;
  readonly isLoading = this.facturacionFacade.isLoading;
  readonly loadingObtener = this.facturacionFacade.loadingObtener;
  readonly loadingGuardar = this.facturacionFacade.loadingGuardar;

  @ViewChild('periodoPickerRef') periodoPickerRef: any;

  private gridApi!: GridApi;
  fechaEmision: Date | undefined;
  VentasRegaliasForm!: FormGroup
  periodoFacturacion: any = null;
  filaSeleccionada: any = null;
  botonesActivos: boolean = false;
  mesPeriodoSeleccionado: string = ''; //

  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.validarCambios();
  }

  franquiciasAutocomplete = [
    { id: 1, ruc: '20606467479', nombre: 'Burger Town - Miraflores' },
    { id: 2, ruc: '20606467479', nombre: 'Burger Town - San Isidro' }, // segunda franquicia mismo RUC
    { id: 3, ruc: '20312456789', nombre: 'Pizza & Pasta Express - San Isidro' },
    { id: 4, ruc: '20456789012', nombre: 'Coffee Lab Perú - Surco' },
    { id: 5, ruc: '20567890123', nombre: 'Burger Town Colombia - Bogotá' },
  ];
  franquiciasAutocompleteFiltradas: any[] = [
    // { id: 1, ruc: '20606467479', nombre: 'Burger Town - Miraflores' },
    // { id: 2, ruc: '20606467479', nombre: 'Burger Town - San Isidro' }, // segunda franquicia mismo RUC
    // { id: 3, ruc: '20312456789', nombre: 'Pizza & Pasta Express - San Isidro' },
    // { id: 4, ruc: '20456789012', nombre: 'Coffee Lab Perú - Surco' },
    // { id: 5, ruc: '20567890123', nombre: 'Burger Town Colombia - Bogotá' },
  ];

  impuestosAplicablesOptions = [
    { id: 1, nombre: '18% IGV' },
    { id: 2, nombre: '19% IVA' },
    { id: 3, nombre: '16% IVA' },
    { id: 4, nombre: 'Sin impuestos' },
  ];
  // Array de franquicias con RUC, razón social y datos por periodo
  franquicias = [
    {
      ruc: '20606467479',
      razonSocial: 'Burger Town - Miraflores',
      nombre: 'Pizzeria Burger Town - Miraflores',
      // porcentajeRegalias: 5,
      impuestosAplicables: '18% IGV',
      periodos: {
        '12': { montoBase: 105000, montoRegualia: 5250, montoImpuestos: 945, totalFactura: 6195, baseCalculo: 30000 },
        '11': { montoBase: 98000, montoRegualia: 4900, montoImpuestos: 882, totalFactura: 5782, baseCalculo: 30000 },
        '10': { montoBase: 102000, montoRegualia: 5100, montoImpuestos: 918, totalFactura: 6018, baseCalculo: 30000 },
      }

    },
    {
      ruc: '20606467479',
      razonSocial: 'Burger Town - San Isidro',
      nombre: 'Burger Town - San Isidro',
      // porcentajeRegalias: 5,
      impuestosAplicables: '18% IGV',
      baseCalculo: 'ventas netas',
      periodos: {
        '12': { montoBase: 120000, montoRegualia: 6000, montoImpuestos: 1080, totalFactura: 7080, baseCalculo: 30000 },
        '11': { montoBase: 112000, montoRegualia: 5600, montoImpuestos: 1008, totalFactura: 6608, baseCalculo: 40000 },
        '10': { montoBase: 110000, montoRegualia: 5500, montoImpuestos: 990, totalFactura: 6490, baseCalculo: 50000 },
      }

    },
    {
      ruc: '20312456789',
      razonSocial: 'Pizza & Pasta Express - San Isidro',
      // porcentajeRegalias: 5,
      impuestosAplicables: '18% IGV',
      periodos: {
        '12': { montoBase: 115000, montoRegualia: 5750, montoImpuestos: 1035, totalFactura: 6785, baseCalculo: 10000 },
        '11': { montoBase: 108000, montoRegualia: 5400, montoImpuestos: 972, totalFactura: 6372, baseCalculo: 20000 },
        '10': { montoBase: 110000, montoRegualia: 5500, montoImpuestos: 990, totalFactura: 6490, baseCalculo: 30000 },
      }
    },
    {
      ruc: '20456789012',
      razonSocial: 'Coffee Lab Perú - Surco',
      // porcentajeRegalias: 5,
      impuestosAplicables: '18% IGV',
      periodos: {
        '12': { montoBase: 95000, montoRegualia: 4750, montoImpuestos: 855, totalFactura: 5605, baseCalculo: 70000 },
        '11': { montoBase: 92000, montoRegualia: 4600, montoImpuestos: 828, totalFactura: 5428, baseCalculo: 80000 },
        '10': { montoBase: 98000, montoRegualia: 4900, montoImpuestos: 882, totalFactura: 5782, baseCalculo: 90000 },
      }
    },
    {
      ruc: '20567890123',
      razonSocial: 'Burger Town Colombia - Bogotá',
      // porcentajeRegalias: 5,
      impuestosAplicables: '19% IVA',
      periodos: {
        '12': { montoBase: 125000, montoRegualia: 6250, montoImpuestos: 1250, totalFactura: 7500, baseCalculo: 330000 },
        '11': { montoBase: 120000, montoRegualia: 6000, montoImpuestos: 1200, totalFactura: 7200, baseCalculo: 440000 },
        '10': { montoBase: 118000, montoRegualia: 5900, montoImpuestos: 1180, totalFactura: 7080, baseCalculo: 55000 },
      }
    },
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

  // rowData se maneja a través del Facade (facturasSignal)
  rowData: FacturacionRegaliasEntity[] = [];



  colDefs: ColDef[] = [
    { field: 'factura_codigo', headerName: 'Código ', width: 150 },
    { field: 'factura_franquicia', headerName: 'Franquicia', flex: 1, minWidth: 150 },
    { field: 'factura_periodo', headerName: 'Periodo facturación', width: 150 },
    {
      field: 'factura_monto_regalia', headerName: 'Monto regalía', headerClass: 'derechaencabezado', width: 120,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
      valueFormatter: (params: any) => {
        if (params.data?.factura_moneda === 'Soles') {
          return `S/ ${params.value}`;
        } else if (params.data?.factura_moneda === 'Dólares') {
          return `$ ${params.value}`;
        }
        return params.value;
      }
    },
    { field: 'factura_moneda', headerName: 'Moneda', width: 150 },
    {
      field: 'factura_impuesto', headerName: 'Impuestos', headerClass: 'derechaencabezado', width: 100,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
    },
    {
      field: 'factura_monto_impuesto', headerName: 'Importe', headerClass: 'derechaencabezado', width: 120,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
    },
    {
      field: 'factura_monto_factura', headerName: 'Monto Factura', headerClass: 'derechaencabezado', width: 120,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
    },

    {
      field: 'factura_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
        } else if (params.value === 'Anulado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulado</span>';
        }
        return params.value;
      }
    }
  ];


  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    public formValidationService: FormValidationService
  ) {
    // Effect para sincronizar el signal del facade con rowData y la grid
    effect(() => {
      const facturas = this.facturasSignal();
      this.rowData = facturas;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }
    });
  }

  ngOnInit() {
    this.VentasRegaliasForm = this.formBuilder.group({
      fechaRegistro: [{ value: new Date().toLocaleDateString('es-PE'), disabled: true }],
      fechaEmision: [{ value: '', disabled: false }],
      rucfranquicia: [{ value: '', disabled: false, }, [Validators.required]], // RUC editable
      razonSocial: [{ value: '', disabled: true }], // Se llena al buscar
      periodoFacturacion: ['', Validators.required],
      franquicia: ['', Validators.required],
      baseCalculo: [''],
      porcentajeRegalias: [''],
      montoBase: [{ value: '', disabled: true }],
      montoRegualia: [{ value: '', disabled: true }],
      impuestosAplicables: [''],
      montoImpuestos: [{ value: '', disabled: true }],
      totalFactura: [{ value: '', disabled: true }],
      observaciones: [''],
    });

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.VentasRegaliasForm);
    this.formValidationService.resetearEstado();

    // Cargar facturas desde el repositorio vía Facade
    this.facturacionFacade.cargarFacturas();

    // Suscribirse a cambios en la base de cálculo
    this.VentasRegaliasForm.get('baseCalculo')?.valueChanges.subscribe(value => {
      this.calcularMontos();
    });

    // Suscribirse a cambios en el porcentaje de regalías
    this.VentasRegaliasForm.get('porcentajeRegalias')?.valueChanges.subscribe(value => {
      this.calcularMontos();
    });

    // Suscribirse a cambios en los impuestos aplicables
    this.VentasRegaliasForm.get('impuestosAplicables')?.valueChanges.subscribe(value => {
      this.calcularMontos();
    });
  }

  calcularMontos() {
    const baseCalculoStr = this.VentasRegaliasForm.get('baseCalculo')?.value;
    const porcentajeRegaliasStr = this.VentasRegaliasForm.get('porcentajeRegalias')?.value;
    const impuestosSeleccionadosIds = this.VentasRegaliasForm.get('impuestosAplicables')?.value || [];

    if (!baseCalculoStr) {
      return;
    }

    // Limpiar y convertir base de cálculo a número
    const baseCalculo = parseFloat(String(baseCalculoStr).replace(/,/g, ''));
    
    if (isNaN(baseCalculo)) {
      return;
    }

    // El monto base es igual a la base de cálculo
    const montoBase = baseCalculo;

    // Actualizar monto base
    this.VentasRegaliasForm.get('montoBase')?.setValue(
      `${montoBase.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
    );

    let montoRegualia = 0;

    // Calcular monto de regalía si hay porcentaje
    if (porcentajeRegaliasStr) {
      const porcentaje = parseFloat(String(porcentajeRegaliasStr).replace('%', ''));
      
      if (!isNaN(porcentaje)) {
        montoRegualia = (montoBase * porcentaje) / 100;
        
        this.VentasRegaliasForm.get('montoRegualia')?.setValue(
          `${montoRegualia.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
        );
      }
    }

    // Calcular monto de impuestos si hay impuestos seleccionados y monto de regalía
    if (montoRegualia > 0 && Array.isArray(impuestosSeleccionadosIds) && impuestosSeleccionadosIds.length > 0) {
      let totalImpuestos = 0;

      // Iterar sobre cada impuesto seleccionado
      impuestosSeleccionadosIds.forEach((impuestoId: number) => {
        const impuesto = this.impuestosAplicablesOptions.find(imp => imp.id === impuestoId);
        
        if (impuesto) {
          // Extraer el porcentaje del nombre (ej: "18% IGV" -> 18)
          const match = impuesto.nombre.match(/(\d+(\.\d+)?)/);
          
          if (match) {
            const porcentajeImpuesto = parseFloat(match[1]);
            const montoImpuesto = (montoRegualia * porcentajeImpuesto) / 100;
            totalImpuestos += montoImpuesto;
          }
        }
      });

      // Actualizar el campo de monto de impuestos
      this.VentasRegaliasForm.get('montoImpuestos')?.setValue(
        `${totalImpuestos.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
      );

      // Calcular total factura (monto regalía + monto impuestos)
      const totalFactura = montoRegualia + totalImpuestos;
      this.VentasRegaliasForm.get('totalFactura')?.setValue(
        `${totalFactura.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
      );
    } else if (montoRegualia > 0) {
      // Si no hay impuestos, limpiar el campo y el total es solo el monto de regalía
      this.VentasRegaliasForm.get('montoImpuestos')?.setValue('0.00');
      this.VentasRegaliasForm.get('totalFactura')?.setValue(
        `${montoRegualia.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
      );
    }
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // No auto-seleccionar ningún dato al iniciar
  }

  formatearFecha(fecha: Date): string {
    const dia = String(fecha.getDate()).padStart(2, '0');
    const mes = String(fecha.getMonth() + 1).padStart(2, '0');
    const anio = fecha.getFullYear();
    return `${anio}-${mes}-${dia}`;
  }
  parsearFecha(fechaStr: string): Date {
    const partes = fechaStr.split('-');
    return new Date(
      parseInt(partes[0]),
      parseInt(partes[1]) - 1,
      parseInt(partes[2]),
    );
  }

  async onCellClicked(event: any) {
    if (event.data) {
      // Validar si hay cambios sin guardar
      const confirmar = await this.formValidationService.validarCambios();

      if (!confirmar) {
        // Usuario canceló: deseleccionar todo y re-seleccionar la anterior
        if (this.gridApi) {
          this.gridApi.deselectAll();
          if (this.filaSeleccionada) {
            this.gridApi.forEachNode((node) => {
              if (node.data.factura_codigo === this.filaSeleccionada?.factura_codigo) {
                node.setSelected(true);
              }
            });
          }
        }
        return; // Usuario canceló, mantener formulario actual
      }

      this.filaSeleccionada = event.data;

      this.VentasRegaliasForm.patchValue({
        fechaRegistro: new Date().toLocaleDateString('es-PE'),
        fechaEmision: '',
        rucfranquicia: event.data.factura_ruc || '',
        razonSocial: event.data.factura_franquicia,
        periodoFacturacion: event.data.factura_periodo,
        franquicia: event.data.factura_franquicia,
        baseCalculo: event.data.factura_base_calculo ? event.data.factura_base_calculo.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '',
        porcentajeRegalias: event.data.factura_porcentaje_regalias ? `${event.data.factura_porcentaje_regalias}%` : '',
        montoBase: event.data.factura_monto_base ? `S/ ${event.data.factura_monto_base.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}` : '',
        montoRegualia: event.data.factura_monto_regalia,
        impuestosAplicables: event.data.factura_impuesto,
        montoImpuestos: event.data.factura_monto_impuesto,
        totalFactura: event.data.factura_monto_factura,
        observaciones: event.data.factura_observaciones || '',
      });

      // Habilitar botones solo si la fila NO está anulado
      this.botonesActivos = event.data.factura_estado !== 'Anulado';

      // Resetear servicio de validación tras cargar datos
      this.formValidationService.resetearEstado();
    }
  }

  onPeriodoSeleccionado(event: any) {
    console.log('Evento período seleccionado:', event);

    const rucIngresado = this.VentasRegaliasForm.get('rucfranquicia')?.value;

    if (!rucIngresado) {
      return;
    }

    const franquicia: any = this.franquicias.find(f => f.ruc === rucIngresado);

    if (!franquicia) {
      return;
    }

    // El event es un objeto con {month: 11, year: 2025}
    let mesPeriodo: string = '';

    if (event && typeof event === 'object' && event.month !== undefined) {
      // Extraer el mes del objeto y convertir a string con padding
      mesPeriodo = String(event.month).padStart(2, '0');
    }

    // 🔹 Guardar el mes en la variable de clase
    this.mesPeriodoSeleccionado = mesPeriodo;

    // Actualizar el control del formulario para que el servicio de validación detecte el cambio
    if (event && event.year) {
      const periodoCompleto = `${event.year}${mesPeriodo}`;
      this.VentasRegaliasForm.get('periodoFacturacion')?.setValue(periodoCompleto);
    }

    console.log('Mes extraído:', mesPeriodo);
    console.log('Periodos disponibles en franquicia:', Object.keys(franquicia.periodos));

    const datosDelPeriodo = franquicia.periodos[mesPeriodo];

    if (datosDelPeriodo) {
      this.VentasRegaliasForm.get('baseCalculo')?.setValue(datosDelPeriodo.baseCalculo);
      this.VentasRegaliasForm.get('montoBase')?.setValue(`S/ ${datosDelPeriodo.montoBase.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`);
      this.VentasRegaliasForm.get('montoRegualia')?.setValue(`S/ ${datosDelPeriodo.montoRegualia.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`);
      this.VentasRegaliasForm.get('montoImpuestos')?.setValue(`S/ ${datosDelPeriodo.montoImpuestos.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`);
      this.VentasRegaliasForm.get('totalFactura')?.setValue(`S/ ${datosDelPeriodo.totalFactura.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`);

      console.log('DATOS RELLENADOS:', datosDelPeriodo);
    } else {
      console.log('No hay datos para mes:', mesPeriodo);
      this.toastService.warning(`¡No existen ventas registradas en el periodo seleccionado! ${mesPeriodo}`);
    }
  }

  onFechaVigenciaDesdeSelected(fecha: Date) {
    this.fechaEmision = fecha;
    // Actualizar el FormControl para que pase la validación
    this.VentasRegaliasForm.patchValue({ fechaEmision: this.formatearFecha(fecha) });
    console.log('Fecha Vigencia Desde seleccionada:', this.fechaEmision);
  }

  async botoncancelar() {
    await this.nuevaFacturacion();
  }

  async abrirModalAnular() {
    if (!this.filaSeleccionada) {
      this.toastService.warning('Por favor, selecciona una factura para anular');
      return;
    }

    if (this.filaSeleccionada.factura_estado === 'Anulado') {
      this.toastService.warning('Esta factura ya está anulada');
      return;
    }

    const detallesEjemplo = [
      { label: 'Código', value: this.filaSeleccionada.factura_codigo },
      { label: 'Franquicia', value: this.filaSeleccionada.factura_franquicia },
      { label: 'Periodo', value: this.filaSeleccionada.factura_periodo },
      { label: 'Estado', value: this.filaSeleccionada.factura_estado },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Anular facturación de regalía',
        subtitulomodal: 'Detalle de facturación:',
        detalles: detallesEjemplo,
        tituloTextarea: 'Motivo de anulación:',
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Anular',
        colorBotonConfirmar: 'danger',
        motivoObligatorio: true
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      // Actualizar estado a 'Anulado'
      const index = this.rowData.findIndex(item => item.factura_codigo === this.filaSeleccionada.factura_codigo);

      if (index !== -1) {
        // Anular vía Facade (actualiza el signal y el estado local)
        this.facturacionFacade.anularFactura(this.filaSeleccionada.factura_codigo, data.motivo);
      }

      // Deshabilitar los botones cuando está anulada
      this.botonesActivos = false;

      // Limpiar selección y formulario
      this.filaSeleccionada = null;
      this.fechaEmision = undefined;
      this.periodoFacturacion = null;
      this.mesPeriodoSeleccionado = '';

      if (this.periodoPickerRef) {
        this.periodoPickerRef.selectedMonth = null;
        this.periodoPickerRef.selectedYear = null;
        this.periodoPickerRef.showDropdown = false;
      }

      this.VentasRegaliasForm.reset({
        fechaRegistro: new Date().toLocaleDateString('es-PE'),
      });

      this.franquiciasAutocompleteFiltradas = [];

      if (this.gridApi) {
        this.gridApi.deselectAll();
      }

      this.formValidationService.resetearEstado();
    }
  }


  onBtReset() {
    this.facturacionFacade.cargarFacturas();
  }

  // Método para resetear el formulario cuando se hace clic en Nueva facturación
  async nuevaFacturacion() {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }

    // Resetear el formulario a su estado inicial
    this.fechaEmision = undefined;
    this.periodoFacturacion = null;
    this.mesPeriodoSeleccionado = '';
    this.filaSeleccionada = null;
    this.botonesActivos = false;
    
    // Resetear el componente month-year-picker directamente
    if (this.periodoPickerRef) {
      this.periodoPickerRef.selectedMonth = null;
      this.periodoPickerRef.selectedYear = null;
      this.periodoPickerRef.showDropdown = false;
    }
    
    // Resetear el control de periodo de facturación explícitamente
    this.VentasRegaliasForm.get('periodoFacturacion')?.reset();
    this.VentasRegaliasForm.get('periodoFacturacion')?.setValue(null);
    this.VentasRegaliasForm.get('periodoFacturacion')?.updateValueAndValidity();
    
    this.VentasRegaliasForm.patchValue({
      fechaRegistro: new Date().toLocaleDateString('es-PE'),
      fechaEmision: '',
      rucfranquicia: '',
      razonSocial: '',
      franquicia: '',
      baseCalculo: '',
      porcentajeRegalias: '',
      montoBase: '',
      montoRegualia: '',
      impuestosAplicables: '',
      montoImpuestos: '',
      totalFactura: '',
      observaciones: ''
    });
    
    // Limpiar el autocomplete filtrado
    this.franquiciasAutocompleteFiltradas = [];
    
    // Deseleccionar cualquier fila en la grid
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  // Método que se dispara cuando el usuario escribe en el RUC
  onRucChange() {
    const rucIngresado = this.VentasRegaliasForm.get('rucfranquicia')?.value;
    console.log('onRucChange disparado. RUC ingresado:', rucIngresado);

    if (!rucIngresado || rucIngresado.trim() === '') {
      // Si está vacío, mostrar todas las franquicias
      this.franquiciasAutocompleteFiltradas = [...this.franquiciasAutocomplete];
      console.log('RUC vacío. Mostrando todas:', this.franquiciasAutocompleteFiltradas);
      return;
    }

    // Filtrar opciones del autocomplete según el RUC ingresado
    const rucTrimmed = rucIngresado.trim();
    const filtradas = this.franquiciasAutocomplete.filter(f => {
      const coincide = f.ruc === rucTrimmed;
      console.log(`Comparando RUC: "${f.ruc}" === "${rucTrimmed}" => ${coincide}`);
      return coincide;
    });
    
    this.franquiciasAutocompleteFiltradas = filtradas;
    console.log('Franquicias filtradas:', this.franquiciasAutocompleteFiltradas);
  }

  // Método para buscar franquicia por RUC (cuando hace click en la lupa)
  buscarFranquicia() {
    const rucIngresado = this.VentasRegaliasForm.get('rucfranquicia')?.value;

    if (!rucIngresado) {
      this.toastService.warning('Por favor ingresa un RUC');
      return;
    }

    // Filtrar opciones del autocomplete según el RUC ingresado
    this.franquiciasAutocompleteFiltradas = this.franquiciasAutocomplete.filter(f => f.ruc === rucIngresado);

    // Buscar en el array de franquicias
    const franquiciasCoincidentes = this.franquicias.filter(f => f.ruc === rucIngresado);

    if (franquiciasCoincidentes.length === 0) {
      this.toastService.warning('No se encontró ninguna franquicia con ese RUC');
      this.VentasRegaliasForm.patchValue({ franquicia: '', razonSocial: '' });
      return;
    }

    // Tomar la primera coincidencia y rellenar
    const franquicia = franquiciasCoincidentes[0];
    this.VentasRegaliasForm.patchValue({
      razonSocial: franquicia.razonSocial,
      impuestosAplicables: franquicia.impuestosAplicables,
      franquicia: franquicia.nombre, // seleccionar en el autocomplete
    });
  }

  // Método para guardar la factura de regalías
  guardarFactura() {
    if (this.VentasRegaliasForm.invalid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos.');
      return;
    }
    const rucIngresado = this.VentasRegaliasForm.get('rucfranquicia')?.value;
    const periodoSeleccionado = this.VentasRegaliasForm.get('periodoFacturacion')?.value;
    const razonSocial = this.VentasRegaliasForm.get('razonSocial')?.value;
    const baseCalculo = this.VentasRegaliasForm.get('baseCalculo')?.value;
    const porcentajeRegalias = this.VentasRegaliasForm.get('porcentajeRegalias')?.value;
    const montoBase = this.VentasRegaliasForm.get('montoBase')?.value;
    const montoRegualia = this.VentasRegaliasForm.get('montoRegualia')?.value;
    const montoImpuestos = this.VentasRegaliasForm.get('montoImpuestos')?.value;
    const totalFactura = this.VentasRegaliasForm.get('totalFactura')?.value;
    const impuestosAplicables = this.VentasRegaliasForm.get('impuestosAplicables')?.value;
    const observaciones = this.VentasRegaliasForm.get('observaciones')?.value;

    // Validar que haya RUC y período seleccionados
    // if (!rucIngresado || !periodoSeleccionado) {
    //   this.toastService.warning('Por favor completa RUC y período antes de guardar');
    //   return;
    // }

    // Obtener mes y año del período seleccionado
    let mesPeriodo = '';
    // 🔹 Usar la variable de clase que guardó el mes
    if (this.mesPeriodoSeleccionado) {
      mesPeriodo = this.mesPeriodoSeleccionado;
    }

    const periodofacFormato = `2025${mesPeriodo}`; // Asumiendo año 2025

    // Obtener períodos ya registrados para esta franquicia
    const periodosRegistrados = this.rowData
      .filter(row => row.factura_franquicia === razonSocial)
      .map(row => row.factura_periodo);

    // Verificar si la franquicia ya ha sido facturada en este período
    const yaFacturado = periodosRegistrados.includes(periodofacFormato);

    if (yaFacturado) {
      const periodosStr = periodosRegistrados.join(', ');
      this.toastService.warning(`¡Esta franquicia ya se ha facturado en el período seleccionado!`);
      return;
    }

    // Generar código único para la nueva factura
    const ultimoCodigo = this.rowData.length > 0
      ? parseInt(this.rowData[0].factura_codigo.split('-')[2])
      : 0;
    const nuevoCodigo = `FR-2025-${String(ultimoCodigo + 1).padStart(4, '0')}`;

    // Extraer valores numéricos de los strings formateados
    const baseCalculoNumerico = baseCalculo ? parseFloat(baseCalculo.replace(/,/g, '')) : 0;
    const porcentajeRegaliasNumerico = porcentajeRegalias ? parseInt(porcentajeRegalias.replace('%', '')) : 5;
    const montoBaseNumerico = montoBase ? parseFloat(montoBase.replace(/S\/|,/g, '').trim()) : 0;
    const montoImpuestosStr = montoImpuestos ? montoImpuestos.replace(/S\/|,/g, '').trim() : '0.00';

    // Crear nuevo registro
    const nuevoRegistro = {
      factura_codigo: nuevoCodigo,
      factura_franquicia: razonSocial,
      factura_moneda: '',
      factura_ruc: rucIngresado,
      factura_periodo: periodofacFormato,
      factura_base_calculo: baseCalculoNumerico,
      factura_porcentaje_regalias: porcentajeRegaliasNumerico,
      factura_monto_base: montoBaseNumerico,
      factura_monto_regalia: montoRegualia,
      factura_impuesto: impuestosAplicables,
      factura_monto_impuesto: montoImpuestosStr,
      factura_monto_factura: totalFactura,
      factura_observaciones: observaciones || '',
      factura_estado: 'Activo'
    };

    // Guardar vía Facade (actualiza el signal y rowData reactivamente)
    this.facturacionFacade.guardarFactura(nuevoRegistro as FacturacionRegaliasEntity);

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();

    // Habilitar botones tras guardar
    this.botonesActivos = true;
    this.filaSeleccionada = nuevoRegistro;

    // Resetear el formulario a su estado inicial
    this.fechaEmision = undefined;
    this.periodoFacturacion = null;
    this.mesPeriodoSeleccionado = '';
    
    // Resetear el componente month-year-picker directamente
    if (this.periodoPickerRef) {
      this.periodoPickerRef.selectedMonth = null;
      this.periodoPickerRef.selectedYear = null;
      this.periodoPickerRef.showDropdown = false;
    }
    
    // Resetear el control de periodo de facturación explícitamente
    this.VentasRegaliasForm.get('periodoFacturacion')?.reset();
    this.VentasRegaliasForm.get('periodoFacturacion')?.setValue(null);
    this.VentasRegaliasForm.get('periodoFacturacion')?.updateValueAndValidity();
    
    this.VentasRegaliasForm.patchValue({
      fechaRegistro: new Date().toLocaleDateString('es-PE'),
      fechaEmision: '',
      rucfranquicia: '',
      razonSocial: '',
      franquicia: '',
      baseCalculo: '',
      porcentajeRegalias: '',
      montoBase: '',
      montoRegualia: '',
      impuestosAplicables: '',
      montoImpuestos: '',
      totalFactura: '',
      observaciones: ''
    });
    
    // Limpiar el autocomplete filtrado
    this.franquiciasAutocompleteFiltradas = [];

    // Resetear servicio de validación tras limpiar formulario
    this.formValidationService.resetearEstado();
  }
  
  async modalverActualizaciones() {
    // Definir las columnas
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 150, },
      { headerName: 'Usuario', field: 'usuario', width: 120, },
      { headerName: 'Acción', field: 'accion', width: 150,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' }, 
       },
      { headerName: 'Detalle del cambio', field: 'detalleCambio', flex: 1,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' }, 
      },
    ];

    // Datos de ejemplo
    const rowData = [
      { fechaHora: '08/11/2025 14:15:30', usuario: 'Carlos Perez', accion: 'Registro de facturación de franquicia', detalleCambio: 'Registro de facturación de franquicia Burguer Town - Miraflores' },
    ];

    const defaultColDefModal: ColDef = {
      wrapText: true,
      autoHeight: true,
    };

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de actualizaciones de facturación de franquicia FR-2025-0009',
        rowData: rowData,
        colDefs: colDefs,
        defaultColDef: defaultColDefModal,
        anchoModal: '700px',
      },
    });

    await modal.present();
  }

  async verDetalleImpuestos(event: Event) {
    event.stopPropagation();

    const impuestosSeleccionadosIds = this.VentasRegaliasForm.get('impuestosAplicables')?.value || [];
    const montoRegualiaStr = this.VentasRegaliasForm.get('montoRegualia')?.value;

    if (!Array.isArray(impuestosSeleccionadosIds) || impuestosSeleccionadosIds.length === 0) {
      this.toastService.warning('No hay impuestos seleccionados');
      return;
    }

    // Limpiar y convertir monto de regalía a número
    const montoRegualia = montoRegualiaStr ? parseFloat(String(montoRegualiaStr).replace(/,/g, '')) : 0;

    // if (montoRegualia === 0) {
    //   this.toastService.warning('El monto de regalía debe ser mayor a 0');
    //   return;
    // }

    // Construir el array de detalles
    const detalles: any[] = [];
    let totalImpuestos = 0;

    impuestosSeleccionadosIds.forEach((impuestoId: number) => {
      const impuesto = this.impuestosAplicablesOptions.find(imp => imp.id === impuestoId);
      
      if (impuesto) {
        // Extraer el porcentaje del nombre (ej: "18% IGV" -> 18)
        const match = impuesto.nombre.match(/(\d+(\.\d+)?)/);
        
        if (match) {
          const porcentajeImpuesto = parseFloat(match[1]);
          const montoImpuesto = (montoRegualia * porcentajeImpuesto) / 100;
          totalImpuestos += montoImpuesto;

          detalles.push({
            label: impuesto.nombre,
            value: `S/ ${montoRegualia.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })} × ${porcentajeImpuesto}% = S/ ${montoImpuesto.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
          });
        }
      }
    });

    // Agregar el total al final
    detalles.push({
      label: 'Total impuestos',
      value: `S/ ${totalImpuestos.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
    });

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Detalle de impuestos aplicados',
        subtitulomodal: 'Cálculo de impuestos sobre monto de regalía:',
        detalles: detalles,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        ocultarBotonConfirmar: true,
        textoBotonCancelar: 'Cerrar',
        widthModal: '550px'
      }
    });

    await modal.present();
  }

}
