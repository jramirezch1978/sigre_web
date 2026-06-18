import { Component, OnInit, OnDestroy, effect, inject } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { CalculoDepreciacionFacade } from '../../../application/facades/calculo-depreciacion.facade';
import { CalculoDepreciacionEntity } from '../../../domain/models/calculo-depreciacion.entity';
import { ActivoFijoFacade } from '../../../application/facades/activo-fijo.facade';
import { ActivoFijoEntity } from '../../../domain/models/activo-fijo.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faCalculator, faCalendarDays, faChevronsLeft, faChevronsRight, faCirclePlus, faDollarSign, faDownload, faList, faPercent, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-activofijo-procesos-calculodepreciacion',
  templateUrl: './activofijo-procesos-calculodepreciacion.component.html',
  styleUrls: ['./activofijo-procesos-calculodepreciacion.component.scss'],
  standalone: false,
})
export class ActivofijoProcesosCalculodepreciacionComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCalculator = faCalculator;
  fasCalendarDays = faCalendarDays;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDollarSign = faDollarSign;
  fasDownload = faDownload;
  fasList = faList;
  fasPercent = faPercent;
  fasRotateRight = faRotateRight;

  //RANGO DE FECHAS

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  startDateActivos: Date | undefined;
  endDateActivos: Date | undefined;

  private gridApi!: GridApi;
  mostrarTabla: boolean = true;
  mesSeleccionado: number | null = null;
  anioSeleccionado: number | null = null;
  mesSeleccionadoP: number | null = null;
  anioSeleccionadoP: number | null = null;
  modoNuevoCalculo: boolean = false;
  calculoEjecutado: boolean = false;
  mostrarBotones: boolean = false;
  formDisabled: boolean = true; // Formulario en modo solo lectura por defecto

  filaSeleccionada: any = null; 

  readonly facade = inject(CalculoDepreciacionFacade);
  private readonly activoFijoFacade = inject(ActivoFijoFacade);
  rowData: CalculoDepreciacionEntity[] = [];

  depreciacionForm!: FormGroup;
  gridContext: any;
  gridColumnApi: any;


  localeText = {
    page: 'Página',
    to: 'a',
    of: 'de',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    loadingOoo: 'Cargando...',
    noRowsToShow: 'No hay datos para mostrar',
  };
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  tipoDSelect= [
    { id: 'Contable', nombre: 'Contable'},
    { id: 'Tributaria', nombre: 'Tributaria'},
  ];

  tipoCSelect=[
    { id: 'Mensual', nombre: 'Mensual'},
    { id: 'Anual', nombre: 'Anual'},
  ]

  metodoCSelect= [
    { id: 'Decreciente', nombre: 'Decreciente'},
    { id: 'Lineal', nombre: 'Lineal'},
  ];

  // Datos de la tabla

  // Definición de columnas
  colDefs: ColDef<CalculoDepreciacionEntity>[] = [
    { field: 'cd_codigo', headerName: 'Código', flex: 1, cellClass: 'text-primary font-medium cursor-pointer' },
    { field: 'cd_periodo', headerName: 'Periodo', flex: 1 },
    { field: 'cd_fecha_ejecucion', headerName: 'Fecha ejecución', flex: 1,
      valueFormatter: (params) => {
        if (params.value) {
          const date = new Date(params.value);
          return date.toLocaleDateString('es-PE', { day: '2-digit', month: '2-digit', year: 'numeric' });
        }
        return '';
      },
     },
    { field: 'cd_usuario', headerName: 'Usuario que ejecutó', flex: 2 },
    { headerName: 'Total activos', headerClass: 'Derechaencabezado ag-right-aligned-header', flex: 1, cellClass: 'text-center', cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end' },
      valueGetter: (params) => params.data?.cd_activos?.length || 0,
    },
    { headerName: 'Depreciación total', flex: 1, cellClass: 'text-right', headerClass: 'ag-right-aligned-header', cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end' },
      valueGetter: (params) => (params.data?.cd_activos || []).reduce((sum: number, a: any) => sum + (a.dpcPeriodo || 0), 0),
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          if (params.value < 0) {
            return `(S/ ${formattedValue})`;
          }
          return `S/ ${formattedValue}`;
        }
        return '';
      },
    },
    { headerName: 'Costo de adquisición', flex: 1, cellClass: 'text-right', headerClass: 'ag-right-aligned-header', cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end' },
      valueGetter: (params) => (params.data?.cd_activos || []).reduce((sum: number, a: any) => sum + (a.costoadquisicion || 0), 0),
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          const absValue = Math.abs(params.value);
          const formattedValue = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(absValue);
          if (params.value < 0) {
            return `(S/ ${formattedValue})`;
          }
          return `S/ ${formattedValue}`;
        }
        return '';
      },
    },
    { headerName: '% Desgaste', flex: 1, headerClass: 'ag-right-aligned-header', cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end' }, 
      valueGetter: (params) => {
        const activos = params.data?.cd_activos || [];
        if (activos.length === 0) return 0;
        const totalAcumulada = activos.reduce((sum: number, a: any) => sum + (a.dpcAcumulada || 0), 0);
        const totalCosto = activos.reduce((sum: number, a: any) => sum + (a.costoadquisicion || 0), 0);
        return totalCosto > 0 ? Math.round((totalAcumulada / totalCosto) * 100) : 0;
      },
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return params.value + '%';
        }
        return '';
      },
    },
  ];

  // Tipos de columnas
  columnTypes = {
    rightAligned: { cellClass: 'text-right' },
    centered: { cellClass: 'text-center' },
  };

  constructor(
    private toastService: ToastService,
    private modalController: ModalController,
    private fb: FormBuilder,
    private formValidationService: FormValidationService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );
    // Mantener rowData sincronizado con el store
    effect(() => {
      this.rowData = [...this.facade.calculos()].reverse();
      this.modoNuevoCalculo = this.rowData.length === 0;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });
  }

  ngOnInit() {
    this.facade.cargarCalculos();
    this.activoFijoFacade.cargarActivosFijos();
    this.depreciacionForm = this.fb.group({
      codigo: [''],
      fechaE: [{ value: this.getFechaHoy(), disabled: true}],
      tipoC: ['Mensual'],
      periodoC: ['',Validators.required],
      tipoD: ['',Validators.required],
      metodoC: ['',Validators.required],
      incluirAR: false,
      incluirAM: false,
    });

    this.gridContext = { componentParent: this };

    // Inicializar servicio de validación de formulario
    this.formValidationService.inicializarFormulario(this.depreciacionForm);

    // Tipo de cálculo: si es Anual, el periodo no aplica
    this.depreciacionForm.get('tipoC')?.valueChanges.subscribe((valor: string) => {
      const periodoControl = this.depreciacionForm.get('periodoC');
      if (valor === 'Anual') {
        periodoControl?.clearValidators();
        periodoControl?.setValue('');
        this.mesSeleccionadoP = null;
        this.anioSeleccionadoP = null;
      } else {
        periodoControl?.setValidators(Validators.required);
      }
      periodoControl?.updateValueAndValidity();
    });
    

  }

  getFechaHoy(): string {
    return new Date().toISOString().substring(0, 10);
  }

   onGridReady(params: any) {
    this.gridApi = params.api;
    this.gridColumnApi = params.columnApi;
  }



  async onCellClicked(params: any) {
    const selected = params.api.getSelectedNodes();

    if (!selected.length) {
      this.filaSeleccionada = null;
      return;
    }

    const nuevaSeleccion = selected[0].data;

    // Si es la misma fila, no hacer nada
    if (this.filaSeleccionada && this.filaSeleccionada.cd_codigo === nuevaSeleccion.cd_codigo) {
      return;
    }

    // Guardar referencia del elemento con foco
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar si hay cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Re-seleccionar fila anterior
      params.api.deselectAll();
      if (this.filaSeleccionada) {
        setTimeout(() => {
          this.gridApi.forEachNode((node: any) => {
            if (node.data.cd_codigo === this.filaSeleccionada.cd_codigo) {
              node.setSelected(true);
            }
          });
          if (elementoConFoco && typeof elementoConFoco.focus === 'function') {
            elementoConFoco.focus();
          }
        });
      }
      return;
    }

    this.filaSeleccionada = nuevaSeleccion;
    this.llenarFormulario(this.filaSeleccionada);
  }

  private llenarFormulario(data: any) {
    if (!data) return;

    this.depreciacionForm.patchValue({
      codigo: data.cd_codigo,
      fechaE: data.cd_fecha_ejecucion,
      tipoC: data.cd_tipo_calculo,
      periodoC: data.cd_periodo,
      tipoD: data.cd_tipo_depreciacion,
      metodoC: data.cd_metodo_calculo,
      incluirAR: data.cd_incluir_ar,
      incluirAM: data.cd_incluir_am,
    });

    this.rowDataActivos = data.cd_activos || [];
    this.depreciacionForm.disable();

    // Resetear servicio de validación después de cargar datos
    this.formValidationService.resetearEstado();
  }

  // AG-Grid para Activos
  private gridApiActivos!: GridApi;

  rowDataActivos: any[] = [];

  colDefsActivos: ColDef[] = [
    { field: 'codigo', headerName: 'Código', width: 80 },
    { field: 'activoFijo', headerName: 'Activo fijo', width: 150 },
    { field: 'categoria', headerName: 'Categoría', width: 120 },
    { field: 'fuenteDoc', headerName: 'Fuente de depreciación', width: 180 },
    { field: 'sucursal', headerName: 'Sucursal', width: 170 },
    { field: 'centroCostos', headerName: 'Centro de Costos', width: 150 },
    { field: 'fechaAdquisicion', headerName: 'Fecha adquisición', width: 110 },
    { field: 'costoadquisicion', headerName: 'Costo de adquisición', width: 120, cellClass: 'text-right',
      valueFormatter: (params) => {
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
    },
    { field: 'dpcPeriodo', headerName: 'Depreciación periodo', width: 110, cellClass: 'text-right',
      valueFormatter: (params) => {
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
    },
    { field: 'dpcAcumulada', headerName: 'Depreciación acumulada', width: 120, cellClass: 'text-right', valueFormatter: (params) => {
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
    },
    { field: 'costoneto', headerName: 'Costo neto', width: 120, cellClass: 'text-right',
      valueFormatter: (params) => {
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
    },
  ];

  onGridReadyActivos(params: GridReadyEvent) {
    this.gridApiActivos = params.api;
  }

  async togglePanelLateral() {
    // Validar cambios antes de cambiar de vista
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;

    this.mostrarTabla = !this.mostrarTabla;

    // Si vuelve a la tabla, resetear tracking
    if (this.mostrarTabla) {
      this.formValidationService.resetearEstado();
    }
  }

  onMonthYearChange(event: { month: number; year: number }) {
    this.mesSeleccionado = event.month;
    this.anioSeleccionado = event.year;
    console.log('Mes y año seleccionado:', event);

  }

  onMonthYearChangePeriodo(event: { month: number; year: number }) {
    this.mesSeleccionadoP = event.month;
    this.anioSeleccionadoP = event.year;
    this.depreciacionForm.patchValue({
      periodoC: `${this.anioSeleccionadoP}${String(this.mesSeleccionadoP).padStart(2, '0')}`,
    });
  }

  async nuevoCalculo() {
    // Validar cambios antes de crear nuevo cálculo
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;

    // Reiniciar el formulario a los valores por defecto
    if (this.depreciacionForm) {
      this.depreciacionForm.enable();
      this.depreciacionForm.reset();
      // usar id esperado por los selects 
      this.depreciacionForm.patchValue({ fechaE: this.formatDate(new Date()), tipoC: 'Mensual' });
      this.filaSeleccionada = null;
    }
     const camposSiempreDeshabilitados = [
    'fechaE',
  ];

  camposSiempreDeshabilitados.forEach(campo => {
    if (this.depreciacionForm.get(campo)) {
      this.depreciacionForm.get(campo)?.disable();
    }
  });
    this.calculoEjecutado = false;
    this.mostrarBotones = false;
    this.mostrarTabla = false;
    this.gridApi.deselectAll();
    this.filaSeleccionada = null;
    this.rowDataActivos = [];
    
    // Limpiar campos del formulario
    this.mesSeleccionado = null;
    this.anioSeleccionado = null;

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }
  private formatDate(date: Date): string {
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();
    return `${year}-${month}-${day}`;
  }
  ejecutarCalculoMasivo() {
    if(this.depreciacionForm.invalid) {
      this.toastService.warning('Por favor, complete todos los campos requeridos antes de ejecutar el cálculo.');
      return;
    }
    const periodoVal = this.depreciacionForm.get('periodoC')?.value || '';
    // Validar que no exista un cálculo con el mismo periodo
    const existeCalculo = this.rowData.some(c => c.cd_periodo === periodoVal);
    if (existeCalculo && periodoVal) {
      this.toastService.warning(`Ya existe un cálculo para el periodo ${periodoVal}. No se puede duplicar.`);
      return;
    }
    this.calculoEjecutado = true;
    this.mostrarBotones = true;
    // Mostrar toast de confirmación al ejecutar el cálculo
    this.toastService.success('¡Cálculo masivo realizado exitosamente!');
    // Mapear activos desde ActivoFijoFacade a la estructura de la tabla secundaria
    const activos = this.activoFijoFacade.activosFijos();
    this.rowDataActivos = activos.map((a: ActivoFijoEntity) => ({
      codigo: a.activo_fijo_codigo,
      activoFijo: a.activo_fijo_descripcion || a.activo_fijo_nombre_activo || '',
      categoria: a.activo_fijo_clasificacion || '',
      fuenteDoc: 'Adquisición del activo',
      sucursal: a.activo_fijo_ubicacion_fisica || '',
      centroCostos: a.activo_fijo_centro_costos || '',
      fechaAdquisicion: a.activo_fijo_fecha_adquisicion || '',
      costoadquisicion: a.activo_fijo_valor_adquisicion || 0,
      dpcPeriodo: (a.activo_fijo_valor_adquisicion || 0) / ((a.activo_fijo_vida_util || 1) * 12),
      dpcAcumulada: a.activo_fijo_depreciacion_acumulada || 0,
      costoneto: a.activo_fijo_valor_neto || 0,
    }));
  }

  confirmarCalculo() {
    const form = this.depreciacionForm.getRawValue();

    const periodo = form.periodoC || '';
    const anio = periodo.substring(0, 4);
    const mes = periodo.substring(4, 6);

    const nuevoRegistro: CalculoDepreciacionEntity = {
      cd_codigo: periodo ? `DEP-${anio}-${mes}` : `DEP-${new Date().getFullYear()}-${String(new Date().getMonth() + 1).padStart(2, '0')}`,
      cd_periodo: form.periodoC || '',
      cd_fecha_ejecucion: form.fechaE || this.getFechaHoy(),
      cd_usuario: 'Carlos Falcao Ontaneda Herradura',
      cd_tipo_depreciacion: form.tipoD || '',
      cd_tipo_calculo: form.tipoC || 'Mensual',
      cd_metodo_calculo: form.metodoC || '',
      cd_incluir_ar: form.incluirAR || false,
      cd_incluir_am: form.incluirAM || false,
      cd_estado: 'Pendiente',
      cd_activos: this.rowDataActivos,
    };

    this.facade.guardarCalculo(nuevoRegistro);
    this.toastService.success('¡Cálculo masivo guardado exitosamente!');

    // Navegar a la tabla inmediatamente
    this.mostrarBotones = false;
    this.calculoEjecutado = false;
    this.rowDataActivos = [];
    this.depreciacionForm.reset({
      fechaE: this.getFechaHoy(),
      tipoC: 'Mensual',
    });
    this.filaSeleccionada = null;
    this.mostrarTabla = true;

    // Resetear validación y forzar recarga
    this.formValidationService.resetearEstado();
    this.facade.cargarCalculos();
  }

  async cancelarCalculo() {
    // Validar si hay cambios antes de cancelar
    const confirmar = await this.formValidationService.validarCambios();
    if (!confirmar) return;

    this.calculoEjecutado = false;
    this.mostrarBotones = false;
    this.mostrarTabla = true;
    
    // Volver a modo solo lectura
    this.formDisabled = true;
    this.formValidationService.resetearEstado();
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos
    this.cargarDatos(range.start, range.end);
  }
  filtrarPorFechasActivos(range: { start: Date; end: Date }) {
    this.startDateActivos = range.start;
    this.endDateActivos = range.end;
    // Llamar a servicio para filtrar datos
    this.cargarDatos(range.start, range.end);
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }

  onBtReset() {
    this.facade.cargarCalculos();
  }

  // --- Cálculos dinámicos para cards principales ---

  private formatCurrency(value: number): string {
    return 'S/ ' + new Intl.NumberFormat('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(value);
  }

  get depreciacionAcumuladaTotal(): string {
    const total = this.rowData.reduce((sum, c) => {
      return sum + (c.cd_activos || []).reduce((s: number, a: any) => s + (a.dpcAcumulada || 0), 0);
    }, 0);
    return this.formatCurrency(total);
  }

  get depreciacionMensualTotal(): string {
    const total = this.rowData.reduce((sum, c) => {
      return sum + (c.cd_activos || []).reduce((s: number, a: any) => s + (a.dpcPeriodo || 0), 0);
    }, 0);
    return this.formatCurrency(total);
  }

  get promedioDesgasteGlobal(): string {
    let totalAcumulada = 0;
    let totalCosto = 0;
    this.rowData.forEach(c => {
      (c.cd_activos || []).forEach((a: any) => {
        totalAcumulada += a.dpcAcumulada || 0;
        totalCosto += a.costoadquisicion || 0;
      });
    });
    const pct = totalCosto > 0 ? Math.round((totalAcumulada / totalCosto) * 100) : 0;
    return pct + '%';
  }

  // --- Cálculos dinámicos para cards de detalle ---

  get depreciacionTotalPeriodo(): string {
    const total = this.rowDataActivos.reduce((sum: number, a: any) => sum + (a.dpcPeriodo || 0), 0);
    return this.formatCurrency(total);
  }

  get costoNetoTotal(): string {
    const total = this.rowDataActivos.reduce((sum: number, a: any) => sum + (a.costoneto || 0), 0);
    return this.formatCurrency(total);
  }

  get promedioDesgastePeriodo(): string {
    if (this.rowDataActivos.length === 0) return '0%';
    const totalAcumulada = this.rowDataActivos.reduce((sum: number, a: any) => sum + (a.dpcAcumulada || 0), 0);
    const totalCosto = this.rowDataActivos.reduce((sum: number, a: any) => sum + (a.costoadquisicion || 0), 0);
    const pct = totalCosto > 0 ? Math.round((totalAcumulada / totalCosto) * 100) : 0;
    return pct + '%';
  }

}
