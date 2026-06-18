import { Component, OnInit, inject, signal, effect, untracked, computed } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ProcesosAjusteItem, ProcesosAjusteDetalleItem } from 'src/app/modules/contabilidad/domain/models/procesos-ajustes.entity';
import { ProcesosAjustesFacade } from 'src/app/modules/contabilidad/application/facades/procesos-ajustes.facade';
import { ProcesosAjustesFeedbackEffects } from 'src/app/modules/contabilidad/effects/procesos-ajustes-feedback.effect';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faChevronsLeft, faChevronsRight, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-c-p-procesosajustes',
  templateUrl: './c-p-procesosajustes.component.html',
  styleUrls: ['./c-p-procesosajustes.component.scss'],
  standalone: false,
})
export class CPProcesosajustesComponent  implements OnInit {

  // ── Facades & Effects ───────────────────────────────────────────────────
  private readonly ajustesFacade  = inject(ProcesosAjustesFacade);
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  private readonly ajustesEffects = inject(ProcesosAjustesFeedbackEffects);

  // ── Señales reactivas ───────────────────────────────────────────────────
  rowData = signal<ProcesosAjusteItem[]>([]);
  readonly isLoading = computed(() => this.ajustesFacade.isLoading());

  // Efecto que siembra rowData la primera vez que la facade carga los asientos
  private readonly _syncRowData = effect(() => {
    const facadeItems = this.ajustesFacade.items() as ProcesosAjusteItem[];
    if (facadeItems.length > 0 && this.rowData().length === 0) {
      untracked(() => this.rowData.set(facadeItems));
    }
  });

  // Font Awesome Icons
  farSearch = faSearch;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasRotateRight = faRotateRight;


  pais= this.countryService.getCountryCode();
  countries= ALL_COUNTRIES;
  monedasignificado='' ;
  formFiltro!: FormGroup;
  fechaRegistro: Date | undefined; 
  fechaContable: Date | undefined;

  ajusteCForm!: FormGroup;
  private gridApi!: GridApi;
  gridContext!: { componentParent: CPProcesosajustesComponent };
  filaSeleccionada: any = null;

  panelLateralVisible= true;
  cantidad: any | null = null;

  rowFiltrado: ProcesosAjusteItem[] = [];

  // Arreglos para los selects
  estados=[
    { value: 'contabilizado', nombre: 'Contabilizado'},
    { value: 'anulado', nombre: 'Inactivo'},
    { value: 'pendiente', nombre: 'Pendiente'},
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

  tasaCSelect=[
    { nombre: 'Soles', value: 'soles' },
    { nombre: 'Dólares', value: 'dolares' },
  ];

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
  
  // rowData populated via signal — see _syncRowData effect above

  rowDataDetalle: ProcesosAjusteDetalleItem[] = [];

  // rowDetalle removed — detalle is now embedded per item in the JSON

  total={ debeS: '380.00', debeD: '112.00', haberS: '380.00', haberD: '112.00'}

  colDefs: ColDef<ProcesosAjusteItem>[] = [
    { field: 'proc_ajuste_nasiento', headerName: 'N° de asiento', width: 120 },
    { field: 'proc_ajuste_fecha_registro', headerName: 'Fecha registro', width: 100, 
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }  
  },

    { field: 'proc_ajuste_fecha_contable', headerName: 'Fecha contable', width: 100,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }  
     },
    { field: 'proc_ajuste_glosa', headerName: 'Glosa', flex:1, minWidth:200 },
    { field: 'proc_ajuste_situacion_c', headerName: 'Situación contable', width: 120 },
    { field: 'proc_ajuste_total', headerName: 'Total', width: 80 },
    { field: 'proc_ajuste_estado', headerClass: 'centrarencabezado', headerName: 'Estado',  width: 80, 
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center',},
      cellRenderer: (params: any) => {
        switch (params.value) {
          case 'Contabilizado':
            var color = 'bg-[#D6E6FF] text-primary';
            break;
          case 'Anulado':
            var color = 'bg-[#FEE2E2] text-[#DC2626]';
            break;
          default:
            var color = 'text-gray-600 bg-gray-100';
        }
        return `<span class="badge-table capitalize ${color}">${params.value}</span>`;
      },
    }
    
  ]; 


  colDefsDetalle: ColDef<ProcesosAjusteDetalleItem>[] = [
    { field: 'proc_ajuste_det_cuenta', headerName: 'Cuenta', width: 100 },
    { field: 'proc_ajuste_det_descripcion', headerName: 'Descripción', width: 180 },
    {  field: 'proc_ajuste_det_debe',  headerName: 'Debe(S/)',  width: 120, valueFormatter: p => p.value || '-'},
    {  field: 'proc_ajuste_det_haber',  headerName: 'Haber(S/)',  width: 120, valueFormatter: p => p.value || '-'},
    {  field: 'proc_ajuste_det_centrocostos',  headerName: 'Centro de costos',  width: 120, valueFormatter: p => p.value || '-'},
  ];

  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private router : Router,
    private countryService: CountryService,
  ) {
  }

  ngOnInit() {
  this.obtenerdatospais();
  this.formFiltro = this.formBuilder.group({
    periodoContable: ['', Validators.required],
    tipoAjuste: ['', Validators.required],
    estado: ['', Validators.required],
  });

  // Inicializar formulario con valores por defecto para evitar errores al usarlo
  this.ajusteCForm = this.formBuilder.group({
    usuario: [{value:'', disabled: true}],
    fechaRegistro: [this.formatDate(new Date())],
    origen: [{value:'', disabled: true}],
    fechaContable: [{value:'', disabled: true}],
    tipoFlujo: [{value:'', disabled: true}],
    moneda: [{value:'', disabled: true}],
    tasaC: [{value:'', disabled: true}],
    estado: [{value:'', disabled: true}],
    situacion: [{value:'', disabled: true}],
    glosa: [{value:'', disabled: true}],
  });
  this.ajusteCForm.get('fechaRegistro')?.disable();
  // Contexto de la grilla (si se usa en cellRenderers u otros)
  this.gridContext = { componentParent: this };
  }
  obtenerdatospais(){
    this.countries.find((country: any) => {
      if(country.codigo === this.pais){
        this.monedasignificado=country.monedapais[0].value
      }
    });
  }

  onBtReset() {
      this.ajustesFacade.cargarDatos();
  }
  private formatDate(date: Date): string {
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
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
      this.formFiltro.patchValue({ periodoContable: periodoValue });
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

  onCellClicked(event: any) {
    // Solo mostrar detalle si hay selección
    if (event?.data) {
      this.filaSeleccionada = event.data;
      
      // Llenar el formulario con los datos de la fila seleccionada
      this.ajusteCForm.patchValue({
        usuario: this.filaSeleccionada.proc_ajuste_usuario || '',
        fechaRegistro: this.filaSeleccionada.proc_ajuste_fecha_registro || '',
        origen: this.filaSeleccionada.proc_ajuste_origen || '',
        fechaContable: this.filaSeleccionada.proc_ajuste_fecha_contable || '',
        tipoFlujo: this.filaSeleccionada.proc_ajuste_tipo_flujo || '',
        moneda: this.filaSeleccionada.proc_ajuste_moneda || '',
        tasaC: this.filaSeleccionada.proc_ajuste_tasa_c || '',
        estado: this.filaSeleccionada.proc_ajuste_estado || 'activo',
        situacion: this.filaSeleccionada.proc_ajuste_situacion_c || '',
        glosa: this.filaSeleccionada.proc_ajuste_glosa || '',
      });

      // Deshabilitar campos de solo lectura
      this.ajusteCForm.get('usuario')?.disable();
      this.ajusteCForm.get('fechaRegistro')?.disable();
      this.ajusteCForm.get('origen')?.disable();
      this.ajusteCForm.get('tasaContable')?.disable();
      this.ajusteCForm.get('situacion')?.disable();
      
      // Cargar detalle del asiento seleccionado desde los datos embebidos
      this.rowDataDetalle = (this.filaSeleccionada as ProcesosAjusteItem).proc_ajuste_detalle || [];
      this.cantidad = this.total;
    } else {
      this.filaSeleccionada = null;
      this.ajusteCForm.reset();
      this.rowDataDetalle = [];
    }
  }

  buscarAsiento() {
    if (this.formFiltro.valid) {
      this.ajustesFacade.cargarDatos();
      this.rowFiltrado = [...this.rowData()];
    }
  }

 

  botonAjustarAsiento() {
    this.router.navigate(['contabilidad/operaciones/gestion-asientos-automatico']),
    this.toastService.success('¡Asiento registrado exiosamente!');
  }
}
