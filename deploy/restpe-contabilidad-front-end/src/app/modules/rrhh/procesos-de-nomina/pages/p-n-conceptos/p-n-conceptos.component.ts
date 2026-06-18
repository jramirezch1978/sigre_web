import { Component, ElementRef, OnInit, ViewChild, inject } from '@angular/core';
import { ColDef, ColGroupDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';
import { BotonAccionesComponent } from 'src/app/ui/boton-acciones/boton-acciones.component';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ModalImportarComponent } from 'src/app/ui/modal-importar/modal-importar.component';
import { CalcularConceptoComponent } from '../../modals/calcular-concepto/calcular-concepto.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { ConceptoEntity } from 'src/app/modules/rrhh/domain/models/concepto.entity';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faGear, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { DefinicionCargosEntity } from '@modules/rrhh/domain/models/definicion-cargos.entity';
import { CentroCostoEntity } from '@modules/contabilidad/domain/models/centro-costo.entity';
import { DatosPersonalesEntity } from '@modules/rrhh/domain/models/datos-personales.entity';
import { CentroCostoFacade } from 'src/app/modules/contabilidad/application/facades/plan-centro-costos.facade';
import { ModalVerActualizacionesComponent } from '@ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';


@Component({
  selector: 'app-p-n-conceptos',
  templateUrl: './p-n-conceptos.component.html',
  styleUrls: ['./p-n-conceptos.component.scss'],
  standalone: false,
})
export class PNConceptosComponent implements OnInit {
  private readonly rrHhFacade = inject(RrHhFacade);
  private readonly centroCostoFacade = inject(CentroCostoFacade);
  readonly isLoading = this.rrHhFacade.loadingConceptos;
  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasGear = faGear;
  fasRotateRight = faRotateRight;
  farBook = faBook;

  countries= ALL_COUNTRIES;
  pais = this.countryService.getCountryCode();
  monedapais: any ='S/';

  // RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;
  fechaVigenciaDesde: Date | undefined;
  fechaVigenciaHasta: Date | undefined;

  ConceptosFijosForm!: FormGroup;

  panelLateralVisible = true;
  mostrarResultado = false;
  mostrarInformacion = false;
  mostrarBuscadorPrincipal = true;

  private gridApi!: GridApi;
  fechaEmision: Date | undefined;
  periodoFacturacion: any = null;
  filaSeleccionada: any = null;
  archivo: any;
  cargoSeleccionado: string = '';

  private gridApiDetalle!: GridApi;

  categorias = [
    'Ingreso',
    'Descuento',
    'Aporte y retenciones',
  ]
  modos = [
    'Fijo',
    'Porcentaje',
  ]
  aplicables = [
    'Cargo',
    'Trabajador',
    'Centro de costo',
    'Grupo'
  ]
  estados = [
    'Activo',
    'Inactivo',
  ]
  tipoIngresos = [
    { value: '1', concepto_nombre: 'Sueldo' },
    { value: '2', concepto_nombre: 'Asignaciones' },
    { value: '3', concepto_nombre: 'Propinas' },
    { value: '4', concepto_nombre: 'Horas extra' },
    { value: '5', concepto_nombre: 'Bono' },
    { value: '6', concepto_nombre: 'Comisiones' },
    { value: '7', concepto_nombre: 'Otros ingresos' },
    { value: '8', concepto_nombre: 'Metas' },
    { value: '9', concepto_nombre: 'Recargo al consumo' },
  ]
  tipoDescuentos = [
    { value: '1', concepto_nombre: 'Adelanto de sueldo' },
    { value: '2', concepto_nombre: 'Adelanto de gratificación' },
    { value: '3', concepto_nombre: 'Préstamo personal' },
  ]
  aportes = [
    'Aportes sociales', 'Retención de trabajador'
  ]
  claseAportes = [
    { value: '1', concepto_nombre: 'Essalud' },
    { value: '2', concepto_nombre: 'SCTR' },
    { value: '3', concepto_nombre: 'Seguro ley de vida' },
  ]
  claseRetencion = [
    { value: '1', concepto_nombre: 'AFP' },
    { value: '2', concepto_nombre: 'ONP' },
    { value: '3', concepto_nombre: 'Renta de 5ta categoría' },
  ]

  cargos: DefinicionCargosEntity[] = [];

  empleados: DatosPersonalesEntity[] = [];

  centrocostos: CentroCostoEntity[]=[];

  sucursales = [
    { id: '1', concepto_nombre: 'Sucursal Principal' },
    { id: '2', concepto_nombre: 'Sucursal Norte' },
    { id: '3', concepto_nombre: 'Sucursal Sur' },
    { id: '4', concepto_nombre: 'Sucursal Este' },
    { id: '5', concepto_nombre: 'Sucursal Oeste' },
  ];

  frameworkComponents = {
    BotonAccionesComponent: BotonAccionesComponent,
    VistaCellRenderComponent: VistaCellRenderComponent
  };

  gridOptions = {
    context: {
      componentParent: this,
    },
    frameworkComponents: this.frameworkComponents,
    rowSelection: 'single',
    suppressRowClickSelection: false,
    suppressRowTransform: true
  };

  columnTypes = {
    rightAligned: {
      headerClass: 'ag-right-aligned-header',
      cellClass: 'ag-right-aligned-cell'
    }
  };

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

  rowData: ConceptoEntity[] = [];

  rowDataTrabajadores: any[] = [];

  colDefsTrabajadores: ColDef[] = [
    { field: 'empleado_codigo', headerName: 'Código', width: 100 },
    { field: 'empleado_nombre', headerName: 'Nombre de trabajador', flex: 1, minWidth: 200 },
    { field: 'tipoDocumento', headerName: 'Tipo documento', width: 150 },
  ];

  colDefs: ColDef[] = [
    { field: 'concepto_codigo', headerName: 'Código ', width: 90 },
    { field: 'concepto_nombre', headerName: 'Nombre de concepto', flex: 1, minWidth: 150 },
    { field: 'concepto_sucursal', headerName: 'Sucursal', width: 150 , filter:true },
    { field: 'concepto_aplicable', headerName: 'Aplicable a', width: 250,
      cellStyle: { wordBreak: 'break-word', whiteSpace: 'normal'},
      autoHeight: true,
      cellRendererSelector: (params: any) => {
        const texto = String(params.data?.concepto_aplicable || '');
        const matchGrupo = texto.match(/Grupo\s*:\s*(.*)$/i);
        if (matchGrupo) {
          const grupoTexto = matchGrupo[1]?.trim() || '';
          const cantidad = grupoTexto
            ? grupoTexto.split(',').map((n: string) => n.trim()).filter((n: string) => !!n).length
            : 0;
          return {
            component: VistaCellRenderComponent,
            params: {
              htmlValue: `<strong>Grupo:</strong> ${cantidad} trabajador${cantidad === 1 ? '' : 'es'}`,
              rowData: params.data,
              context: params.context
            }
          };
        }
        return undefined; // Usa el cellRenderer por defecto para otros tipos
      },
      cellRenderer: (params: any) => {
        if (!params.value) return '';

        const texto = String(params.value);

        const matchCargo = texto.match(/Cargo\s*:\s*(.*)$/i);
        if (matchCargo) {
          return `<span class="!font-bold">Cargo:</span> ${matchCargo[1]?.trim() || ''}`;
        }

        const matchTrabajador = texto.match(/Trabajador\s*:\s*(.*)$/i);
        if (matchTrabajador) {
          return `<span class="!font-bold">Trabajador:</span> ${matchTrabajador[1]?.trim() || ''}`;
        }

        const matchCentroCosto = texto.match(/Centro de costo[s]?\s*:\s*(.*)$/i);
        if (matchCentroCosto) {
          return `<span class="!font-bold">Centro de costo:</span> ${matchCentroCosto[1]?.trim() || ''}`;
        }

        // Fallback para variantes inesperadas del prefijo de centro de costo
        if (/centro/i.test(texto) && /costo/i.test(texto)) {
          return `<span class="!font-bold">Centro de costo:</span> ${texto.split(':').slice(1).join(':').trim() || texto}`;
        }

        return params.value;
      }
    },
    { field: 'concepto_tipo', headerName: 'Tipo', width: 70 , filter:true },
    { field: 'concepto_modo_calculo', headerName: 'Modo cáculo', width: 100, filter:true },
    { field: 'concepto_monto_valor', headerName: 'Monto / Valor', headerClass: 'derechaencabezado', width: 120,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
      valueFormatter: (params: any) => {
        if (params.data?.concepto_modo_calculo === 'Porcentaje') {
          return `${params.value}%`;
        } else if (params.data?.concepto_modo_calculo === 'Fijo') {
          return `${this.monedapais} ${params.value}`;
        }
        return '-';
      }
    },
    { field: 'concepto_fecha_desde', headerName: 'Vigencia desde', width: 120,
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
    { field: 'concepto_fecha_hasta', headerName: 'Vigencia hasta', width: 120,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate()).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return 'Indefinido';
      }
    },
    { field: 'concepto_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        if (params.value === 'Activo') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>'
        } else if (params.value === 'Inactivo') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>'
        }
        return params.value;
      }
    }
  ];

  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private countryService: CountryService,
    private formValidationService: FormValidationService
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  ngOnInit() {
    this.initializeForm();

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.ConceptosFijosForm);
    this.formValidationService.resetearEstado();

    this.obtenerdatosdepais();

    // Cargar catálogos para autocompletes desde JSON
    this.rrHhFacade.cargarDefinicionCargos();
    this.rrHhFacade.cargarDatosPersonales();
    this.centroCostoFacade.cargarCentrosCosto();

    const catalogosTimer = setInterval(() => {
      this.cargos = [...this.rrHhFacade.definicionCargos()];
      this.empleados = [...this.rrHhFacade.datosPersonales()];
      this.centrocostos = [...this.centroCostoFacade.centrosCosto()];

      if (
        !this.rrHhFacade.loadingDefinicionCargos()
        && !this.rrHhFacade.loadingDatosPersonales()
        && !this.centroCostoFacade.isLoading()
      ) {
        clearInterval(catalogosTimer);
      }
    }, 100);

    this.rrHhFacade.cargarConceptos();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.conceptos();
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', [...this.rowData]);
        }
        // Restaurar fila seleccionada si existe (al volver a la pantalla)
        if (this.filaSeleccionada) {
          const codigo = this.filaSeleccionada.concepto_codigo;
          setTimeout(() => {
            this.gridApi?.forEachNode((node) => {
              if (node.data?.concepto_codigo === codigo) {
                node.setSelected(true);
              }
            });
          }, 0);
        }
        clearInterval(timer);
      }
    }, 100);
  }

  obtenerdatosdepais(){
    const pais = this.countries.find(c => c.codigo === this.pais);
    if(pais){
      this.tipoIngresos = (pais.tipoIngresos ?? []).map((i: any) => ({ value: i.value, concepto_nombre: i.nombre }));
      this.tipoDescuentos = (pais.tipoDescuentos ?? []).map((i: any) => ({ value: i.value, concepto_nombre: i.nombre }));
      this.claseAportes = (pais.claseAportes ?? []).map((i: any) => ({ value: i.value, concepto_nombre: i.nombre }));
      this.claseRetencion = (pais.claseRetencion ?? []).map((i: any) => ({ value: i.value, concepto_nombre: i.nombre }));
    };
    this.countries.find(c => {
      if(c.codigo === this.pais){
        c.monedapais?.find(tip => {
          this.monedapais= tip.simbolo;
        })
      }
    });
  };

  private initializeForm(): void {
    // Obtener fecha actual en formato ISO (YYYY-MM-DD)
    const fechaActual = this.formatearFecha(new Date());
    
    this.ConceptosFijosForm = this.formBuilder.group({
      nombreConcepto: ['', Validators.required],
      categoriaSelect: ['', Validators.required],
      tipoIngresoSelect: [''],
      tipoDescuentoSelect: [''],
      tipoAporteSelect: [''],
      tipoClaseAporteSelect: [''],
      modoSelect: ['', Validators.required],
      montoInput: [''],
      valorInput: [''],
      fechaVigenciaDesde: [{ value: fechaActual, disabled: true }],
      fechaVigenciaHasta: [''], 
      conceptoVigencia: [false],
      aplicableSelect: ['', Validators.required],
      estadoSelect: ['Activo', Validators.required],
      fechaAdquisicion: [''],
      concepto_sucursal: ['', Validators.required], // Agregar required
      cargo: [''],
      trabajador: [''],
      centroCosto: [''],
      grupoTrabajadores: [''],
      // Controles para Jornada Laboral
      diasLaborados: [''],
      diasSubsidiados: [''],
      diasNoLaborados: [''],
      diasTotal: [''],
      ordinaria: [''],
      ordinaria2: [''],
    });
    
    // Validaciones dinámicas según el modo de cálculo
    this.ConceptosFijosForm.get('modoSelect')?.valueChanges.subscribe(modo => {
      if (modo === 'Fijo') {
        this.ConceptosFijosForm.get('montoInput')?.setValidators([Validators.required]);
        this.ConceptosFijosForm.get('valorInput')?.clearValidators();
      } else if (modo === 'Porcentaje') {
        this.ConceptosFijosForm.get('valorInput')?.setValidators([Validators.required]);
        this.ConceptosFijosForm.get('montoInput')?.clearValidators();
      }
      this.ConceptosFijosForm.get('montoInput')?.updateValueAndValidity();
      this.ConceptosFijosForm.get('valorInput')?.updateValueAndValidity();
    });
    
    // Validaciones dinámicas según "Aplicable a"
    this.ConceptosFijosForm.get('aplicableSelect')?.valueChanges.subscribe(aplicable => {
      // Limpiar validaciones de todos los campos de "Aplicable a"
      this.ConceptosFijosForm.get('cargo')?.clearValidators();
      this.ConceptosFijosForm.get('trabajador')?.clearValidators();
      this.ConceptosFijosForm.get('centroCosto')?.clearValidators();
      this.ConceptosFijosForm.get('grupoTrabajadores')?.clearValidators();
      
      // Agregar validación según el tipo seleccionado
      if (aplicable === 'Cargo') {
        this.ConceptosFijosForm.get('cargo')?.setValidators([Validators.required]);
      } else if (aplicable === 'Trabajador') {
        this.ConceptosFijosForm.get('trabajador')?.setValidators([Validators.required]);
      } else if (aplicable === 'Centro de costo') {
        this.ConceptosFijosForm.get('centroCosto')?.setValidators([Validators.required]);
      } else if (aplicable === 'Grupo') {
        this.ConceptosFijosForm.get('grupoTrabajadores')?.setValidators([Validators.required]);
      }
      
      // Actualizar validación
      this.ConceptosFijosForm.get('cargo')?.updateValueAndValidity();
      this.ConceptosFijosForm.get('trabajador')?.updateValueAndValidity();
      this.ConceptosFijosForm.get('centroCosto')?.updateValueAndValidity();
      this.ConceptosFijosForm.get('grupoTrabajadores')?.updateValueAndValidity();
    });
  }

  async abrirmodalImportar() {
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar conceptos',
        descripcionSubir: 'Comparte tu archivo de excel con la información de tus conceptos y regístralos automáticamente en la plataforma.',
        buttonName: 'Importar conceptos',
      }
    });
    await modal.present();

    try {
      const result = await modal.onWillDismiss();
      const data = result?.data;
      if (data && data.archivo) {
        // Guardar archivo en el componente padre
        this.archivo = data.archivo;
        // Mostrar toast indicando que el archivo fue subido
        try {
          const nombre = data.archivo?.name ?? 'archivo';
          this.toastService.success('Archivo subido', nombre, 3000);
        } catch (e) {
          console.warn('ToastService falló', e);
        }
        // Llamar al método importar para procesar el archivo
        try { this.importar(data); } catch (e) {
          this.toastService.danger('Importacion fallida');
        }
      }
    } catch (e) {
      console.warn('Error al obtener resultado del modal', e);
      this.toastService.danger('Error al obtener resultado del modal');
    }
  }

  scrollAPrimeraFila(): void {
    if (this.gridApi) {
      // Seleccionar la primera fila
      this.gridApi.deselectAll();
      const firstRowNode = this.gridApi.getRenderedNodes()[0];
      if (firstRowNode) {
        firstRowNode.setSelected(true);
        // Hacer scroll a la primera fila
        this.gridApi.ensureIndexVisible(0, 'top');
      }
    }
  }

  importar(data: any) {
    // Placeholder: aquí se procesaría el archivo (validaciones, parseo, subida, etc.)
    console.log('Importar llamado con:', data);
    // Por ahora solo guardamos el archivo en el estado (ya lo hacemos en modalImportar),
    // y se puede mostrar un toast adicional si se desea.
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // Restaurar la fila seleccionada al volver a la pantalla
    if (this.filaSeleccionada) {
      const codigo = this.filaSeleccionada.concepto_codigo;
      setTimeout(() => {
        this.gridApi?.forEachNode((node) => {
          if (node.data?.concepto_codigo === codigo) {
            node.setSelected(true);
          }
        });
      }, 0);
    }
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

 async nuevoConcepto(): Promise<void> {
    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Usuario canceló
    }
    
    // Deseleccionar la fila en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    
    // Limpiar fila seleccionada
    this.filaSeleccionada = null;
    
    // Ocultar lista de trabajadores
    this.cargoSeleccionado = '';
    this.rowDataTrabajadores = [];
    
    // Obtener fecha actual en formato ISO
    const fechaActual = this.formatearFecha(new Date());
    
    // Resetear formulario
    this.ConceptosFijosForm.reset({
      fechaVigenciaDesde: fechaActual,
      estadoSelect: 'Activo'
    });
    
    // Marcar el formulario como pristine para que valueChanges no habilite los botones
    this.ConceptosFijosForm.markAsPristine();
    this.ConceptosFijosForm.markAsUntouched();
    
    // Resetear variables de visibilidad
    this.mostrarResultado = false;
    this.mostrarInformacion = false;

    // Habilitar todos los campos cuando es nuevo concepto
    this.ConceptosFijosForm.enable();
    this.ConceptosFijosForm.get('fechaVigenciaDesde')?.disable();
    
    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  } 

  async onCellClicked(event: any) {
    console.log('onCellClicked llamado con:', event);
    
    if (event.data) {
      console.log('Datos de la fila:', event.data);
      
      // Validar si hay cambios sin guardar
      const confirmar = await this.formValidationService.validarCambios();
      
      if (!confirmar) {
        // Usuario canceló: restaurar selección anterior
        if (this.gridApi && this.filaSeleccionada) {
          const prevCodigo = this.filaSeleccionada.concepto_codigo;
          setTimeout(() => {
            this.gridApi.deselectAll();
            this.gridApi.forEachNode((node) => {
              if (node.data?.concepto_codigo === prevCodigo) {
                node.setSelected(true);
              }
            });
          }, 0);
        }
        return; // Usuario canceló, mantener formulario actual
      }

      // Seleccionar la nueva fila
      const selectedCodigo = event.data.concepto_codigo;
      setTimeout(() => {
        this.gridApi?.deselectAll();
        this.gridApi?.forEachNode((node) => {
          if (node.data?.concepto_codigo === selectedCodigo) {
            node.setSelected(true);
          }
        });
      }, 0);
      
      this.filaSeleccionada = event.data;

      // Detectar si la vigencia hasta es indefinida (vacía o sin valor)
      const vigenciaHastaVacia = !event.data.concepto_fecha_hasta || event.data.concepto_fecha_hasta === '' || event.data.concepto_fecha_hasta === 'Indefinido';

      // Parsear el campo "concepto_aplicable" para extraer tipo y valor
      const aplicableTexto = event.data.concepto_aplicable || '';
      let aplicableTipo = '';
      let aplicableValor = '';

      if (aplicableTexto.includes('Cargo:')) {
        aplicableTipo = 'Cargo';
        aplicableValor = aplicableTexto.split('Cargo:')[1]?.trim() || '';
      } else if (aplicableTexto.includes('Trabajador:')) {
        aplicableTipo = 'Trabajador';
        aplicableValor = aplicableTexto.split('Trabajador:')[1]?.trim() || '';
      } else if (aplicableTexto.includes('Centro de costo:')) {
        aplicableTipo = 'Centro de costo';
        aplicableValor = aplicableTexto.split('Centro de costo:')[1]?.trim() || '';
      } else if (aplicableTexto.includes('Grupo:')) {
        aplicableTipo = 'Grupo';
        aplicableValor = aplicableTexto.split('Grupo:')[1]?.trim() || '';
      }

      console.log('Tipo:', aplicableTipo, 'Valor:', aplicableValor);
      
      // Mostrar lista de trabajadores SIEMPRE que haya un aplicableValor (sin importar el tipo)
      if (aplicableValor) {
        this.cargoSeleccionado = aplicableValor;
      } else {
        this.cargoSeleccionado = '';
      }

      // Cargar los datos de la fila seleccionada en el formulario
      this.ConceptosFijosForm.patchValue({
        nombreConcepto: event.data.concepto_nombre || '',
        concepto_sucursal: event.data.concepto_sucursal || '',
        modoSelect: event.data.concepto_modo_calculo || '',
        categoriaSelect: event.data.concepto_tipo || '',
        tipoIngresoSelect: event.data.concepto_tipo_ingreso || '',
        tipoDescuentoSelect: event.data.concepto_tipo_descuento || '',
        tipoAporteSelect: event.data.concepto_tipo_aporte || '',
        tipoClaseAporteSelect: event.data.concepto_tipo_clase_aporte || '',
        aplicableSelect: aplicableTipo,
        estadoSelect: event.data.concepto_estado || '',
        fechaVigenciaDesde: event.data.concepto_fecha_desde || '',
        fechaVigenciaHasta: event.data.concepto_fecha_hasta || '',
        conceptoVigencia: vigenciaHastaVacia,
      });
      
      // Actualizar la variable fechaVigenciaHasta si hay una fecha
      if (!vigenciaHastaVacia && event.data.concepto_fecha_hasta) {
        this.fechaVigenciaHasta = new Date(event.data.concepto_fecha_hasta);
      } else {
        this.fechaVigenciaHasta = undefined;
      }

      console.log('Valores después de patchValue:', this.ConceptosFijosForm.value);

      // Asignar el valor específico al campo correspondiente según el tipo
      if (aplicableTipo === 'Cargo') {
        // Buscar el cargo en la lista por nombre
        const cargoEncontrado = this.cargos.find(c => c.cargo_nombre === aplicableValor);
        this.ConceptosFijosForm.patchValue({ cargo: cargoEncontrado?.cargo_codigo || '' });
        console.log('Cargo asignado:', cargoEncontrado?.cargo_codigo || '');

        // Cargar lista de trabajadores del cargo seleccionado
        this.rowDataTrabajadores = this.empleados
          .filter(e => e.empleado_cargo === aplicableValor)
          .map(e => ({
            empleado_codigo: e.empleado_codigo,
            empleado_nombre: e.empleado_nombres_apellidos,
            tipoDocumento: e.empleado_tipo_documento,
          }));
      } else if (aplicableTipo === 'Trabajador') {
        // Buscar el trabajador en la lista por nombre
        const trabajadorEncontrado = this.empleados.find(t => t.empleado_nombres_apellidos === aplicableValor);
        this.ConceptosFijosForm.patchValue({ trabajador: trabajadorEncontrado?.empleado_codigo || '' });
        console.log('Trabajador asignado:', trabajadorEncontrado?.empleado_codigo || '');
      } else if (aplicableTipo === 'Centro de costo') {
        // Buscar el centro de costo en la lista por nombre
        const centroCostoEncontrado = this.centrocostos.find(cc => cc.centro_costo_nombre === aplicableValor);
        this.ConceptosFijosForm.patchValue({ centroCosto: centroCostoEncontrado?.centro_costo_codigo || '' });
        console.log('Centro de costo asignado:', centroCostoEncontrado?.centro_costo_codigo || '');
      } else if (aplicableTipo === 'Grupo') {
        // Permite formato por nombres separados por coma: "Nombre 1, Nombre 2"
        const nombresGrupo = aplicableValor
          .split(',')
          .map((n: string) => n.trim())
          .filter((n: string) => !!n);

        const codigosGrupo = nombresGrupo
          .map((nombre: string) => this.empleados.find((e) => e.empleado_nombres_apellidos === nombre)?.empleado_codigo)
          .filter((codigo): codigo is string => !!codigo);

        this.ConceptosFijosForm.patchValue({ grupoTrabajadores: codigosGrupo });
        console.log('Grupo asignado:', codigosGrupo);
      }

      // Asignar el monto o valor según el modo de cálculo
      if (event.data.concepto_modo_calculo === 'Fijo') {
        this.ConceptosFijosForm.patchValue({
          montoInput: event.data.concepto_monto_valor || '',
          valorInput: ''
        });
      } else if (event.data.concepto_modo_calculo === 'Porcentaje') {
        this.ConceptosFijosForm.patchValue({
          valorInput: event.data.concepto_monto_valor || '',
          montoInput: ''
        });
      }

      // Deshabilitar TODOS los campos excepto estadoSelect cuando está en modo edición
      this.ConceptosFijosForm.disable();
      // estadoSelect queda HABILITADO para poder cambiar el estado
      this.ConceptosFijosForm.get('estadoSelect')?.enable();
      
      console.log('Formulario después de disable:', this.ConceptosFijosForm.value);
      
      // Resetear servicio de validación después de cargar datos
      this.formValidationService.resetearEstado();
    }
  }

  onFechaVigenciaDesdeSelected(fecha: Date) {
    this.fechaVigenciaDesde = fecha;
    console.log('Fecha Vigencia Desde seleccionada:', this.fechaVigenciaDesde);
  }

  onSucursalSeleccionada(sucursal: any) {
    this.ConceptosFijosForm.patchValue({
      concepto_sucursal: sucursal?.concepto_nombre
    });
  }

  onCargoSeleccionado(cargo: any) {
    console.log('Cargo seleccionado:', cargo);
    
    this.cargoSeleccionado = cargo.cargo_nombre || cargo;
    //filtrar todos los empleados que tengan el mismo cargo
    const empleadosFiltrados = this.empleados.filter(e => e.empleado_cargo === this.cargoSeleccionado);
    this.rowDataTrabajadores = empleadosFiltrados.map(e => ({
      empleado_codigo: e.empleado_codigo,
      empleado_nombre: e.empleado_nombres_apellidos,
      tipoDocumento: e.empleado_tipo_documento,
    }));
  }

  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApiDetalle = params.api;
  }

  onTrabajadorSeleccionado(trabajador: any) {
    console.log('Trabajador seleccionado:', trabajador);
  }
  onCentroCostoSeleccionado(centroCosto: any) {
    console.log('Centro de Costo seleccionado:', centroCosto);
  }
  onGrupoTrabajadoresSeleccionado(grupo: any) {
    console.log('Grupo de Trabajadores seleccionado:', grupo);
  }
  onCellClickedTributos(event: any) {
    console.log('Tributo seleccionado:', event.data);
  }
  
  guardarConceptoFijo() {
    if (this.ConceptosFijosForm.invalid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    if (this.filaSeleccionada) {
      // Modo edición
      this.actualizarConcepto();
    } else {
      // Modo creación
      this.registrarNuevoConcepto();
    }
  }

  private registrarNuevoConcepto() {
    const valores = this.ConceptosFijosForm.getRawValue();
    const codigo = this.generarNuevoCodigo();

    // Construir el texto de "concepto_aplicable"
    let aplicableTexto = '';
    if (valores.aplicableSelect === 'Cargo') {
      const cargoNombre = this.cargos.find(c => c.cargo_codigo === valores.cargo)?.cargo_nombre || '';
      aplicableTexto = `Cargo: ${cargoNombre}`;
    } else if (valores.aplicableSelect === 'Trabajador') {
      const trabajadorNombre = this.empleados.find(t => t.empleado_codigo === valores.trabajador)?.empleado_nombres_apellidos || '';
      aplicableTexto = `Trabajador: ${trabajadorNombre}`;
    } else if (valores.aplicableSelect === 'Centro de costo') {
      const centroCostoNombre = this.centrocostos.find(cc => cc.centro_costo_codigo === valores.centroCosto)?.centro_costo_nombre || '';
      aplicableTexto = `Centro de costo: ${centroCostoNombre}`;
    } else if (valores.aplicableSelect === 'Grupo') {
      const grupoIds: string[] = Array.isArray(valores.grupoTrabajadores) ? valores.grupoTrabajadores : [];
      const grupoNombres = grupoIds
        .map((id: string) => this.empleados.find((e) => e.empleado_codigo === id)?.empleado_nombres_apellidos)
        .filter((nombre): nombre is string => !!nombre);
      aplicableTexto = `Grupo: ${grupoNombres.join(', ')}`;
    }

    // Determinar el valor de monto/valor
    const montoValor = valores.modoSelect === 'Fijo' ? valores.montoInput : valores.valorInput;

    // Formatear fecha vigencia hasta
    let fechaHasta = '';
    if (!valores.conceptoVigencia && this.fechaVigenciaHasta) {
      fechaHasta = this.formatearFecha(this.fechaVigenciaHasta);
    }

    const nuevoRegistro = {
      concepto_codigo: codigo,
      concepto_nombre: valores.nombreConcepto,
      concepto_sucursal: valores.concepto_sucursal,
      concepto_tipo: valores.categoriaSelect,
      concepto_tipo_ingreso: valores.tipoIngresoSelect || '',
      concepto_tipo_descuento: valores.tipoDescuentoSelect || '',
      concepto_tipo_aporte: valores.tipoAporteSelect || '',
      concepto_tipo_clase_aporte: valores.tipoClaseAporteSelect || '',
      concepto_modo_calculo: valores.modoSelect,
      concepto_monto_valor: montoValor || 0,
      concepto_fecha_desde: valores.fechaVigenciaDesde,
      concepto_fecha_hasta: fechaHasta,
      concepto_aplicable: aplicableTexto,
      concepto_estado: valores.estadoSelect
    };

    // Agregar al inicio del array
    this.rowData = [nuevoRegistro, ...this.rowData];

    this.toastService.success('¡Concepto registrado con éxito!');

    // Resetear formulario
    this.filaSeleccionada = null;
    this.ConceptosFijosForm.reset({
      fechaVigenciaDesde: this.formatearFecha(new Date()),
      estadoSelect: 'Activo'
    });

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();

    // Deseleccionar en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  private actualizarConcepto() {
    if (!this.filaSeleccionada) return;

    const valores = this.ConceptosFijosForm.getRawValue();

    // Construir el texto de "concepto_aplicable"
    let aplicableTexto = '';
    if (valores.aplicableSelect === 'Cargo') {
      const cargoNombre = this.cargos.find(c => c.cargo_codigo === valores.cargo)?.cargo_nombre || '';
      aplicableTexto = `Cargo: ${cargoNombre}`;
    } else if (valores.aplicableSelect === 'Trabajador') {
      const trabajadorNombre = this.empleados.find(t => t.empleado_codigo === valores.trabajador)?.empleado_nombres_apellidos || '';
      aplicableTexto = `Trabajador: ${trabajadorNombre}`;
    } else if (valores.aplicableSelect === 'Centro de costo') {
      const centroCostoNombre = this.centrocostos.find(cc => cc.centro_costo_codigo === valores.centroCosto)?.centro_costo_nombre || '';
      aplicableTexto = `Centro de costo: ${centroCostoNombre}`;
    } else if (valores.aplicableSelect === 'Grupo') {
      const grupoIds: string[] = Array.isArray(valores.grupoTrabajadores) ? valores.grupoTrabajadores : [];
      const grupoNombres = grupoIds
        .map((id: string) => this.empleados.find((e) => e.empleado_codigo === id)?.empleado_nombres_apellidos)
        .filter((nombre): nombre is string => !!nombre);
      aplicableTexto = `Grupo: ${grupoNombres.join(', ')}`;
    }

    // Determinar el valor de monto/valor
    const montoValor = valores.modoSelect === 'Fijo' ? valores.montoInput : valores.valorInput;

    // Formatear fecha vigencia hasta
    let fechaHasta = '';
    if (!valores.conceptoVigencia && this.fechaVigenciaHasta) {
      fechaHasta = this.formatearFecha(this.fechaVigenciaHasta);
    }

    // Buscar el índice del registro en rowData
    const codigoSeleccionado = this.filaSeleccionada.concepto_codigo;
    const index = this.rowData.findIndex(item => item.concepto_codigo === codigoSeleccionado);
    
    if (index !== -1) {
      this.rowData[index] = {
        ...this.rowData[index],
        concepto_nombre: valores.nombreConcepto,
        concepto_sucursal: valores.concepto_sucursal,
        concepto_tipo: valores.categoriaSelect,
        concepto_tipo_ingreso: valores.tipoIngresoSelect || '',
        concepto_tipo_descuento: valores.tipoDescuentoSelect || '',
        concepto_tipo_aporte: valores.tipoAporteSelect || '',
        concepto_tipo_clase_aporte: valores.tipoClaseAporteSelect || '',
        concepto_modo_calculo: valores.modoSelect,
        concepto_monto_valor: montoValor || 0,
        concepto_fecha_desde: valores.fechaVigenciaDesde,
        concepto_fecha_hasta: fechaHasta,
        concepto_aplicable: aplicableTexto,
        concepto_estado: valores.estadoSelect
      };

      // Mantener referencia actual de la fila seleccionada con datos actualizados
      this.filaSeleccionada = this.rowData[index];

      // Forzar cambio de referencia para que AG-Grid re-renderice
      this.rowData = [...this.rowData];

      // Mantener la selección visual en la fila editada
      if (this.gridApi) {
        setTimeout(() => {
          this.gridApi.forEachNode((node) => {
            node.setSelected(node.data?.concepto_codigo === codigoSeleccionado);
          });
        }, 0);
      }
    }

    this.toastService.success('¡Cambios guardados exitosamente!');

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  private generarNuevoCodigo(): string {
    // Obtener máximo correlativo del formato CPT-2025-XXX
    const anioActual = new Date().getFullYear();
    const prefijoBase = `CPT-${anioActual}-`;

    const numeros = this.rowData
      .filter(item => item.concepto_codigo?.startsWith(prefijoBase))
      .map(item => {
        const match = String(item.concepto_codigo || '').match(/CPT-\d{4}-(\d+)/);
        return match ? parseInt(match[1], 10) : 0;
      });

    const max = numeros.length > 0 ? Math.max(...numeros) : 0;
    const siguiente = String(max + 1).padStart(3, '0');
    return `${prefijoBase}${siguiente}`;
  }

  onBtReset(): void {
    this.rrHhFacade.cargarConceptos();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.conceptos();
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', [...this.rowData]);
        }
        clearInterval(timer);
      }
    }, 100);
  }

  togglePanelLateral(): void {
    this.panelLateralVisible = !this.panelLateralVisible;

  }

  filtrarPorFechas(range: { start: Date; end: Date }): void {
    this.startDate = range.start;
    this.endDate = range.end;
  }

  async abrirModal(valor: string, fila: any): Promise<void> {
    const data = fila || this.filaSeleccionada;
    
    if (!data) {
      return;
    }

    // Parsear el nombre del grupo del campo aplicable
    const aplicableTexto = String(data.concepto_aplicable || '');
    const matchGrupo = aplicableTexto.match(/Grupo\s*:\s*(.*)$/i);
    if (!matchGrupo) {
      this.toastService.warning('Este concepto no es de tipo Grupo');
      return;
    }

    const nombresGrupo = matchGrupo[1]
      .split(',')
      .map((n: string) => n.trim())
      .filter((n: string) => !!n);

    const rowDataTrabajadores = nombresGrupo.map((nombre: string) => {
      const empleado = this.empleados.find((e) => e.empleado_nombres_apellidos === nombre);
      return {
        empleado_codigo: empleado?.empleado_codigo || '-',
        empleado_nombre: nombre,
        tipoDocumento: empleado?.empleado_tipo_documento || '-'
      };
    });


    // Columnas para tabla de trabajadores (mostrar código tipo T-00001)
    const colDefs: ColDef[] = [
      { field: 'empleado_codigo', headerName: 'Código trabajador', width: 140 },
      { field: 'empleado_nombre', headerName: 'Nombre del trabajador', flex: 1, minWidth: 220 },
      { field: 'tipoDocumento', headerName: 'Tipo documento', width: 140 }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Grupo de trabajadores`,
        subtitulomodal: 'Total trabajadores: ' + rowDataTrabajadores.length,
        mostrarTabla: true,
        colDefs: colDefs,
        rowData: rowDataTrabajadores,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        textoBotonCancelar: 'Cerrar',
        ocultarBotonConfirmar: true
      }
    });

    await modal.present();
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
        { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial del concepto', },
        { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de la lista de empleados', },
      ];
  
      const modal = await this.modalController.create({
        component: ModalVerActualizacionesComponent,
        cssClass: 'promo',
        componentProps: {
          titulo: `Historial de actualizaciones del concepto ${this.filaSeleccionada?.concepto_codigo || ''}`,
          rowData: rowData,
          colDefs: colDefs,
          anchoModal: '700px',
  
        },
      });
  
      await modal.present();
    }

}
