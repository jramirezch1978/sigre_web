import { Component, OnInit, inject } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-cv-analisis-inconsistencia-nomina',
  templateUrl: './cv-analisis-inconsistencia-nomina.component.html',
  styleUrls: ['./cv-analisis-inconsistencia-nomina.component.scss'],
  standalone: false,
})
export class CvAnalisisInconsistenciaNominaComponent implements OnInit {
  // Facade
  private readonly rrHhFacade = inject(RrHhFacade);

  // Selectores del store
  readonly analisisInconsistenciaNomina = this.rrHhFacade.analisisInconsistenciaNomina;
  readonly isLoading = this.rrHhFacade.loadingAnalisisInconsistenciaNomina;

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;


  private gridApi!: GridApi;
  pais = this.countryservice.getCountryCode();
  // Campos del formulario
  fechaAnalisis: Date = new Date();
  fechaAnalisisFormateada: string = '';
  periodoSeleccionado: string = '';
  tipoValidacionSeleccionado: string[] = [];

  trabajadores = [
    { id: 1, nombre: 'Alexander Palomeque Aguirre', analisis_inconsistencia_sucursal: 'La Molina, Lima', analisis_inconsistencia_centro_costo: 'Administración' },
    { id: 2, nombre: 'Rhan Chang Castagnino', analisis_inconsistencia_sucursal: 'San Isidro, Lima', analisis_inconsistencia_centro_costo: 'Recursos Humanos' },
    { id: 3, nombre: 'Odalucha Espinoza Valladolid', analisis_inconsistencia_sucursal: 'Miraflores, Lima', analisis_inconsistencia_centro_costo: 'Oficina Administrativa' },
    { id: 4, nombre: 'Milagros Veintimilla Ontaneda', analisis_inconsistencia_sucursal: 'Santa Isabel, Piura', analisis_inconsistencia_centro_costo: 'Marketing' },
    { id: 5, nombre: 'Axel Rose Quispe Paniagua', analisis_inconsistencia_sucursal: 'Tangarará, Piura', analisis_inconsistencia_centro_costo: 'Operaciones' }
  ];


  periodos = [
    { label: 'Enero 2025', value: '202501' },
    { label: 'Febrero 2025', value: '202502' },
    { label: 'Marzo 2025', value: '202503' },
    { label: 'Abril 2025', value: '202504' },
    { label: 'Mayo 2025', value: '202505' },
    { label: 'Junio 2025', value: '202506' },
    { label: 'Julio 2025', value: '202507' },
    { label: 'Agosto 2025', value: '202508' },
    { label: 'Septiembre 2025', value: '202509' },
    { label: 'Octubre 2025', value: '202510' },
    { label: 'Noviembre 2025', value: '202511' },
    { label: 'Diciembre 2025', value: '202512' }
  ];

  tiposValidacion = [
    { label: 'Duplicados', value: 'duplicados' },
    { label: 'Topes', value: 'topes' },
    { label: 'Aportes', value: 'aportes' },
    { label: 'Errores de cálculo', value: 'errores_calculo' },
  ];

  trabajadorSeleccionadoId: number | null = null;
  sucursalSeleccionada: string = '';
  centroCostoSeleccionado: string = '';

  // Datos de la tabla
  filasGeneradas: any[] = [];
  generando: boolean = false;
  columnDefs: ColDef[] = [
    { field: 'analisis_inconsistencia_periodo', headerName: 'Periodo', flex: 0.6, minWidth: 80 },
    { field: 'analisis_inconsistencia_fecha_deteccion', headerName: 'Fecha de detección', flex: 0.8, minWidth: 100 },
    { field: 'analisis_inconsistencia_trabajador', headerName: 'Trabajador', flex: 1.5, minWidth: 180 },
    { field: 'analisis_inconsistencia_sucursal', headerName: 'Sucursal', flex: 1, minWidth: 140 },
    { field: 'analisis_inconsistencia_centro_costo', headerName: 'Centro de costo', flex: 1, minWidth: 140 },
    { field: 'analisis_inconsistencia_tipo_error', headerName: 'Tipo de error', flex: 1.2, minWidth: 150 },
    { field: 'analisis_inconsistencia_descripcion_error', headerName: 'Descripción del error', flex: 2, minWidth: 250,
     },
    { field: 'analisis_inconsistencia_monto_observado', headerName: 'Monto observado', flex: 0.9, minWidth: 120,
      headerClass: 'derechaencabezado',
      cellStyle: { display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    { field: 'analisis_inconsistencia_valor_esperado', headerName: 'Valor esperado', flex: 0.9, minWidth: 120,
      headerClass: 'derechaencabezado',
      cellStyle: { display: 'flex', justifyContent: 'end', alignItems: 'center' }
    },
    { 
      field: 'analisis_inconsistencia_estado', 
      headerName: 'Estado', 
      flex: 0.8,
      minWidth: 110,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        let badgeClass = '';
        if (params.value === 'Observada') {
          badgeClass = 'bg-[#FFDECC] text-[#FF8947]';
        } else if (params.value === 'Validada') {
          badgeClass = 'bg-[#DCFDE7] text-[#16A34A]';
        } else if (params.value === 'Corregida') {
          badgeClass = 'bg-[#FFF0BF] text-[#F2A626]';
        }
        return `<span class="badge-table ${badgeClass}">${params.value}</span>`;
      }
    }
  ];

  // Datos de ejemplo
  datosEjemplo = [
    { analisis_inconsistencia_periodo: '202510', analisis_inconsistencia_fecha_deteccion: '18/12/2025', analisis_inconsistencia_trabajador: 'Jean Pierre Santillán García', analisis_inconsistencia_sucursal: 'La Molina, Lima', analisis_inconsistencia_centro_costo: 'Administración', analisis_inconsistencia_tipo_error: 'Aportes fuera de rango', analisis_inconsistencia_descripcion_error: 'El aporte al AFP registrado en el sistema excede al tope máximo permitido según la configuración vigente del sistema', analisis_inconsistencia_monto_observado: '850.00', analisis_inconsistencia_valor_esperado: '700.00', analisis_inconsistencia_estado: 'Observada'},
    { analisis_inconsistencia_periodo: '202510', analisis_inconsistencia_fecha_deteccion: '18/12/2025', analisis_inconsistencia_trabajador: 'Jean Pierre Santillán García', analisis_inconsistencia_sucursal: 'La Molina, Lima', analisis_inconsistencia_centro_costo: 'Administración', analisis_inconsistencia_tipo_error: 'Tope excedido', analisis_inconsistencia_descripcion_error: 'El sistema identificó que este trabajador superó el límite para este concepto en el periodo evaluado.', analisis_inconsistencia_monto_observado: '240.00', analisis_inconsistencia_valor_esperado: '120.00', analisis_inconsistencia_estado: 'Validada'},
    { analisis_inconsistencia_periodo: '202510', analisis_inconsistencia_fecha_deteccion: '18/12/2025', analisis_inconsistencia_trabajador: 'Jean Pierre Santillán García', analisis_inconsistencia_sucursal: 'La Molina, Lima', analisis_inconsistencia_centro_costo: 'Administración', analisis_inconsistencia_tipo_error: 'Aportes fuera de rango', analisis_inconsistencia_descripcion_error: 'El aporte calculado no se encuentra dentro del rango permitido según la base de cálculo de este periodo.', analisis_inconsistencia_monto_observado: '1,650.00', analisis_inconsistencia_valor_esperado: '1,700.00', analisis_inconsistencia_estado: 'Corregida'},
    { analisis_inconsistencia_periodo: '202510', analisis_inconsistencia_fecha_deteccion: '18/12/2025', analisis_inconsistencia_trabajador: 'Jean Pierre Santillán García', analisis_inconsistencia_sucursal: 'La Molina, Lima', analisis_inconsistencia_centro_costo: 'Administración', analisis_inconsistencia_tipo_error: 'Error de cálculo', analisis_inconsistencia_descripcion_error: 'Se detectó una diferencia entre el monto calculado manualmente por el analista y el registrado en el sistema.', analisis_inconsistencia_monto_observado: '80.00', analisis_inconsistencia_valor_esperado: '90.00', analisis_inconsistencia_estado: 'Corregida'},
    { analisis_inconsistencia_periodo: '202510', analisis_inconsistencia_fecha_deteccion: '18/12/2025', analisis_inconsistencia_trabajador: 'Jean Pierre Santillán García', analisis_inconsistencia_sucursal: 'La Molina, Lima', analisis_inconsistencia_centro_costo: 'Administración', analisis_inconsistencia_tipo_error: 'Registro duplicado', analisis_inconsistencia_descripcion_error: 'El sistema detectó un registro duplicado para el mismo trabajador, periodo y concepto.', analisis_inconsistencia_monto_observado: '650.00', analisis_inconsistencia_valor_esperado: '550.00', analisis_inconsistencia_estado: 'Corregida'},
    { analisis_inconsistencia_periodo: '202510', analisis_inconsistencia_fecha_deteccion: '18/12/2025', analisis_inconsistencia_trabajador: 'Jean Pierre Santillán García', analisis_inconsistencia_sucursal: 'La Molina, Lima', analisis_inconsistencia_centro_costo: 'Administración', analisis_inconsistencia_tipo_error: 'Tope excedido', analisis_inconsistencia_descripcion_error: 'El registro fue marcado inicialmente como excedido; sin embargo, el monto coincide con el valor permitido.', analisis_inconsistencia_monto_observado: '950.00', analisis_inconsistencia_valor_esperado: '950.00', analisis_inconsistencia_estado: 'Corregida' }
  ];

  columnTypes = {};

  gridOptions = {
    context: {
      componentParent: this,
    },
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

  constructor(
    private toastService: ToastService,
    private countryservice: CountryService,
    private modalController: ModalController,
    
  ) {}

  ngOnInit() {
    // Inicializar fecha de análisis con fecha actual
    this.fechaAnalisisFormateada = this.formatearFecha(this.fechaAnalisis);
    // Cargar datos desde el JSON vía infraestructura
    this.rrHhFacade.cargarAnalisisInconsistenciaNomina();
  }

  get botonHabilitado(): boolean {
    return Boolean(
      this.periodoSeleccionado && 
      this.trabajadorSeleccionadoId && 
      this.tipoValidacionSeleccionado && 
      this.tipoValidacionSeleccionado.length > 0
    );
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onTrabajadorSeleccionado(trabajador: any) {
    // trabajador es el objeto completo emitido por itemSelected
    if (trabajador && trabajador.id) {
      this.trabajadorSeleccionadoId = trabajador.id;
      this.sucursalSeleccionada = trabajador.analisis_inconsistencia_sucursal || '';
      this.centroCostoSeleccionado = trabajador.analisis_inconsistencia_centro_costo || '';
    } else {
      this.trabajadorSeleccionadoId = null;
      this.sucursalSeleccionada = '';
      this.centroCostoSeleccionado = '';
    }
    this.verificarYAutocompletar();
  }

  onSucursalSeleccionada(sucursal: any) {
    this.sucursalSeleccionada = sucursal;
    console.log('Sucursal seleccionada:', sucursal);
  }

  onCentroCostoSeleccionado(centroCosto: any) {
    this.centroCostoSeleccionado = centroCosto;
    console.log('Centro de costo seleccionado:', centroCosto);
  }

  onFechaAnalisis(fecha: Date) {
    this.fechaAnalisis = fecha;
    console.log('Fecha de análisis:', fecha);
  }

  onPeriodoSeleccionado(event: any) {
    this.periodoSeleccionado = event;
    console.log('Periodo seleccionado:', event);
    this.verificarYAutocompletar();
  }

  onTipoValidacionSeleccionado(tipos: any[]) {
    this.tipoValidacionSeleccionado = tipos;
    console.log('Tipos de validación seleccionados:', tipos);
    this.verificarYAutocompletar();
  }

  private verificarYAutocompletar() {
    // La fecha siempre se mantiene como la fecha actual, no se actualiza aquí
  }

  private formatearFecha(fecha: Date): string {
    const dia = fecha.getDate().toString().padStart(2, '0');
    const mes = (fecha.getMonth() + 1).toString().padStart(2, '0');
    const anio = fecha.getFullYear();
    return `${dia}/${mes}/${anio}`;
  }

  generarValidacion() {
    console.log('=== Generando validación ===');
    console.log('Periodo:', this.periodoSeleccionado);
    console.log('Trabajador ID:', this.trabajadorSeleccionadoId);
    console.log('Tipo validación:', this.tipoValidacionSeleccionado);
    this.generando = true;
    this.filasGeneradas = [];
    setTimeout(() => {
      this.filasGeneradas = [...this.analisisInconsistenciaNomina()];
      this.generando = false;
      console.log('Filas generadas:', this.filasGeneradas.length);
      this.toastService.success('¡Análisis recalculado exitosamente!');
    }, 1000);
  }

  onBtReset() {
    if (this.gridApi) {
      this.gridApi.setFilterModel(null);
      this.gridApi.onFilterChanged();
    }
  }

  cancelarReporte() {
    this.filasGeneradas = [];
    this.periodoSeleccionado = '';
    this.tipoValidacionSeleccionado = [];
    this.trabajadorSeleccionadoId = null;
    this.sucursalSeleccionada = '';
    this.centroCostoSeleccionado = '';
    this.fechaAnalisisFormateada = '';
    this.toastService.success('Reporte cancelado');
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
}
