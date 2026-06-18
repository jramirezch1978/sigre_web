import { Component, OnInit, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ConsistenciaAsientosFacade } from '../../../application/facades/consistencia-asientos.facade';
import { ConsistenciaAsientosFeedbackEffects } from '../../../effects/consistencia-asientos-feedback.effect';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';
import { ConsistenciaAsientosEntity } from '@modules/contabilidad/domain/models/consistencia-asientos.entity';



@Component({
  selector: 'app-c-p-consistenciaasientos',
  templateUrl: './c-p-consistenciaasientos.component.html',
  styleUrls: ['./c-p-consistenciaasientos.component.scss'],
  standalone: false,
})
export class CPConsistenciaasientosComponent  implements OnInit {
  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  // Rango de fechas

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  // Clean Architecture — Facade y Effects
  private readonly consistenciaAsientosFacade = inject(ConsistenciaAsientosFacade);
  private readonly feedbackEffects = inject(ConsistenciaAsientosFeedbackEffects);
  readonly isLoading = () => this.consistenciaAsientosFacade.isLoading();
  private gridApi!: GridApi;
  form!: FormGroup;
  fechaEjecucion: Date | undefined; 
  
  filasGeneradas: any[] = [];

  // Configuración de ag-grid
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
        ? '-'
        : params.value;
    }
  };

  directorio= '';

  monedas=[
    { label: 'Soles', value: 'soles' },
    { label: 'Dólares', value: 'dolares' },
  ];
  nivelesSelect = [
    { id: '01', nombre: '01' },
    { id: '02', nombre: '02' },
    { id: '03', nombre: '03' },
    { id: '04', nombre: '04' },
    { id: '05', nombre: '05' },
  ];



  colErrores: ColDef<ConsistenciaAsientosEntity>[] = [
  { field: 'cons_asiento_periodo', headerName: 'Periodo', width: 90 },
  { field: 'cons_asiento_asiento', headerName: 'N° de asiento', width: 140 },
  { field: 'cons_asiento_fecha_contable', headerName: 'Fecha contable', width: 130,
    valueFormatter: (params) => {
      if (params.value) {
        const date = new Date(params.value + 'T00:00:00');
        return date.toLocaleDateString('es-PE');
      }
      return '';
    }
  },
  { field: 'cons_asiento_cuenta', headerName: 'Cuenta contable', width: 120 },
  { field: 'cons_asiento_moneda', headerName: 'Moneda', width: 100 },
  {  field: 'cons_asiento_diferencia',  headerName: 'Diferencia',  width: 120,
    valueFormatter: (params: any) => {
      if (params.value !== null && params.value !== undefined) {
        const absValue = Math.abs(params.value);
        const formattedValue = new Intl.NumberFormat('es-PE', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2,
        }).format(absValue);
        
        // Si es negativo, mostrar entre paréntesis
        if (params.value < 0) {
          return `(${formattedValue})`;
        }
        return formattedValue;
      }
      return '';
    },
    cellStyle: (params: any) => {
      const style: any = { textAlign: 'right' };
      if (params.value < 0) {
        style.color = '#DC2626'; // Rojo para negativos
      }
      return style;
    }
  },
  { field: 'cons_asiento_tipo_error', headerName: 'Tipo de error', width: 130 },
  { field: 'cons_asiento_usuario', headerName: 'Usuario ejecutor', width: 180 },
  { field: 'cons_asiento_estado', headerName: 'Estado', width: 130, headerClass: 'centrarencabezado',
    cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    cellRenderer: (params: any) => {
      if (params.value === 'Validado') {
        return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Validado</span>';
      }
      if (params.value === 'Inconsistente') {
        return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inconsistente</span>';
      }
      return params.value;
    }
  }
];
  
  constructor(
    private fb: FormBuilder,
    private toastService : ToastService,
  ) {
    // Configurar fechas
    this.minDate = new Date(2020, 0, 1);
    this.maxDate = new Date();
    this.startDate = new Date(2025, 0, 1);
    this.endDate = new Date(2025, 0, 31);

    // Sincronizar store → grid automáticamente
    effect(() => {
      this.filasGeneradas = [...this.consistenciaAsientosFacade.items()];
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.filasGeneradas);
      }
    });
  }

  ngOnInit() {
    this.form = this.fb.group({
      periodoContable: ['', Validators.required],
      directorio: [''],
      moneda: [''],
      nivel: [''],
      incluirNul: [false]
    });
    
    // Inicializar la fecha de ejecución con la fecha de hoy
    this.fechaEjecucion = new Date();
  }

  cargarDatos(): void {
    this.consistenciaAsientosFacade.cargarDatos();
  }

  onBtReset() {
    this.cargarDatos();
  }
  onGridReady(params: GridReadyEvent) {
      this.gridApi = params.api;
    }

  filtrarPorFechas(event: any) {
    console.log('Rango de fechas seleccionado:', event);
    this.startDate = event.startDate;
    this.endDate = event.endDate;
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
      this.form.patchValue({ periodoContable: periodoValue });
      console.log('Periodo guardado en formulario:', periodoValue);
    } else {
      console.warn('No se pudo procesar el evento del período:', event);
    }
  }


  onFechaEjecucion(date: Date) {
    console.log('Fecha Ejecucion:', date);
    this.fechaEjecucion = date;  
  }

  generarValidacion() {
    // VALIDACIÓN 1 — Detectar campos faltantes
    const camposFaltantes: string[] = [];
    
    const periodoContable = this.form.get('periodoContable');

    if (!periodoContable || !periodoContable.value) { 
      camposFaltantes.push('Período contable'); 
    }

    if (camposFaltantes.length > 0) {
      const mensaje = `Campos requeridos faltantes: ${camposFaltantes.join(', ')}`;
      this.toastService.warning(mensaje,'',12000);
      return;
    }

    // VALIDACIÓN 2 — Validaciones del formulario
    if (this.form.invalid) {
      this.toastService.danger('Existen errores de validación.','Corríjalos antes de generar el archivo', 12000);
      return;
    }

    // VALIDACIÓN 3 — Simulamos que hay registros
    const registrosEncontrados = true; // cambia a false para simular

    if (!registrosEncontrados) {
      this.toastService.warning('No existen asientos registrados en el periodo seleccionado',);
      return;
    }

    // VALIDACIÓN 4 — error de sistema simulado
    const errorSistema = false; // cambia a true para probar

    if (errorSistema) {
      this.toastService.danger('Error al ejecutar la validación','Contacte a un administrador del sistema', 12000);
      return;
    }

    // ÉXITO — cargar datos solo al pasar todos los filtros
    this.consistenciaAsientosFacade.cargarDatos();
    this.toastService.success('¡Validación completada exitosamente!','se encontraron asientos descuadrados');
  }
  
  carpetaSeleccionada(event: any) {
    const files = event.target.files;
    if (files.length > 0) {
      const ruta = files[0].webkitRelativePath.split('/')[0];
      this.form.patchValue({ directorio: ruta });
    }
  }

}





