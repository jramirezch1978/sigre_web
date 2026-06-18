import { Component, OnInit, effect, inject } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ModalController } from '@ionic/angular';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormBuilder, FormGroup } from '@angular/forms';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { GeneracionAsientosIndexacionFacade } from '../../../application/facades/generacion-asientos-indexacion.facade';
import { GeneracionAsientosIndexacionEntity } from '../../../domain/models/generacion-asientos-indexacion.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-activofijo-procesos-generacionasientosindexacion',
  templateUrl: './activofijo-procesos-generacionasientosindexacion.component.html',
  styleUrls: [ './activofijo-procesos-generacionasientosindexacion.component.scss',],
  standalone: false,
})
export class ActivofijoProcesosGeneracionasientosindexacionComponent implements OnInit {
  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  formatDateDisplay(dateStr: string): string {
    if (!dateStr) return '-';
    const parts = dateStr.split('-');
    if (parts.length !== 3) return dateStr;
    return `${parts[2]}/${parts[1]}/${parts[0]}`;
  }

  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  panelLateralVisible: boolean = true;
  mesSeleccionado: number | null = null;
  anioSeleccionado: number | null = null;
  selectedCalculo: any = null;
  formIndexacion!: FormGroup;

  readonly facade = inject(GeneracionAsientosIndexacionFacade);
  rowData: GeneracionAsientosIndexacionEntity[] = [];

  autoGroupColumnDef: ColDef = {
    headerName: 'Código',
  };

  // AG-Grid
  private gridApi!: GridApi;
  context: any;

  gridOptions = {
    context: { componentParent: this }
  };

  monedas=[
    { label: 'Soles', value:'Soles'},
    { label: 'Dólares', value:'Dólares'},
  ]

  colDefs: ColDef<GeneracionAsientosIndexacionEntity>[] = [
    { field: 'gai_codigo', headerName: 'Código', flex: 0.6, minWidth: 70 },
    { field: 'gai_periodo', headerName: 'Periodo', flex: 0.5, minWidth: 70 },
    { field: 'gai_fecha_ejecucion', headerName: 'Fecha de ejecución', flex: 0.8, minWidth: 90,
      valueFormatter: (params: any) => this.formatDateDisplay(params.value)
     },
    { field: 'gai_activos', headerName: 'Activo', flex: 1.2, minWidth: 120 },
    { field: 'gai_moneda', headerName: 'Moneda', flex: 1.2, minWidth: 120 },
    { field: 'gai_total_ajuste', headerName: 'Total Ajuste', flex: 0.9, minWidth: 100, headerClass: 'ag-right-aligned-header',
      cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end',},
      cellRenderer: (params: any) => {
        const val = params?.value;
        if (val == null) return '';
        const cleaned = String(val).replace(/[^0-9.-]/g, '');
        const num = parseFloat(cleaned);
        if (!isNaN(num)) {
          if (num < 0) {
            return `<span style="color:#EF4444">${params.value}</span>`;
          } else if (num > 0) {
            return `<span style="color:#16A34A">${params.value}</span>`;
          }
        }
        return params.value;
      },
    },
    { field: 'gai_nuevo_valor', headerName: 'Nuevo Valor', flex: 0.8, minWidth: 90, headerClass: 'ag-right-aligned-header',
      cellStyle: { textAlign: 'end', display: 'flex', justifyContent: 'end', alignItems: 'end',},
    },
    { field: 'gai_nro_asiento_cont', headerName: 'N° de asiento cont.', flex: 1, minWidth: 130, cellRenderer: VistaCellRenderComponent,},
    { field: 'gai_usuarioEject', headerName: 'Usuario Ejecutor', flex: 0.7, minWidth: 85,},
    //     {
    //   field: 'nroAsientoCont',
    //   headerName: 'N° de asiento contable',
    //   width: 130,
    //   cellRenderer: (params: any) => {
    //     // Si el estado es "Pendiente", no mostrar nada
    //     if (params.data?.estado === 'Pendiente') {
    //       return '';
    //     }
    //     // Si el estado es "Contabilizado", usar el cell renderer personalizado
    //     return params.value;
    //   },
    //   cellRendererSelector: (params: any) => {
    //     // Si el estado es "Contabilizado", usar el componente personalizado
    //     if (params.data?.estado === 'Contabilizado') {
    //       return {
    //         component: VistaCellRenderComponent,
    //       };
    //     }
    //     // Para otros estados, usar el renderer por defecto
    //     return undefined;
    //   },
    // },
    { field: 'gai_estado', headerName: 'Estado', flex: 0.7, minWidth: 100, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center',},
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-[#363636]">Pendiente</span>';
        } else if (params.value === 'Contabilizado') {
          return '<span class="badge-table bg-[#D6E6FF] text-primary">Contabilizado</span>';
        }
        return params.value;
      },
    },
  ];

  columnTypes = {
    rightAligned: { cellClass: 'text-right' },
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
    loadingOoo: 'Cargando...',
  };
  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '-'
        : params.value;
    }
  };

  constructor(
    private toastservice: ToastService,
    private modalController: ModalController) 
    {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate()); 
    
    // Configurar context para AG-Grid
    this.context = { componentParent: this };

    effect(() => {
      this.rowData = this.facade.asientos();
    });
    }

  ngOnInit() {
    this.facade.cargarAsientos();

    this.formIndexacion = new FormBuilder().group({
      razonSocial: [''],
      periodoContable: [''],
      fechaEjecucion: [''],
      tipoMoneda: [''],
      usuarioEjecutor: [''],
      fechaContable: [''],
      libroContable: [''],
      prefijo: [''],
      observaciones: ['']
    });
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }
  onMonthYearChange(event: {month: number, year: number}) {
    this.mesSeleccionado = event.month;
    this.anioSeleccionado = event.year;
    console.log('Mes y año seleccionado:', event);
    // Aquí puedes agregar la lógica para filtrar los datos
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onCellClicked(event: any) {
    this.cargarDatosSeleccionados(event.data);
  }

  private cargarDatosSeleccionados(data: any) {
    this.selectedCalculo = {
      ...data,
      razonSocial: data.gai_razonSocial || 'Restaurant.pe SAC',
      periodo: data.gai_periodo || '',
      fechaEjecucion: data.gai_fecha_ejecucion || '',
      usuarioEjecutor: data.gai_usuarioEject || 'Eduardo Jiménez López',
      tipoMoneda: data.gai_tipoMoneda || 'Soles',
      fechaContable: data.gai_fecha_contable || '',
      libroContable: data.gai_libroContable || 'Principal',
      prefijo: data.gai_prefijo || '',
      observaciones: data.gai_observaciones || ''
    };

    if (this.formIndexacion) {
      this.formIndexacion.patchValue({
        razonSocial: this.selectedCalculo.razonSocial,
        periodoContable: this.selectedCalculo.periodo,
        fechaEjecucion: this.selectedCalculo.fechaEjecucion,
        tipoMoneda: this.selectedCalculo.tipoMoneda,
        usuarioEjecutor: this.selectedCalculo.usuarioEjecutor,
        fechaContable: this.selectedCalculo.fechaContable,
        libroContable: this.selectedCalculo.libroContable,
        prefijo: this.selectedCalculo.prefijo,
        observaciones: this.selectedCalculo.observaciones
      });
      this.anioSeleccionado = parseInt(this.selectedCalculo.periodo.substring(0, 4), 10);
      this.mesSeleccionado = parseInt(this.selectedCalculo.periodo.substring(4, 6), 10);
    }
  }

  async openAsiento(nroAsientoCont: string, rowData?: any) {
    const asientoData = rowData || [
      { cuentaContable: '1510.02', descripcion: 'Equipos de cocina - Revalorización', debe: 600.00, haber: 0.00},
      { cuentaContable: '3810.01', descripcion: 'Revalorización por inflación', debe: 0.00, haber: 600.00},
    ];

    const colDefs: ColDef[] = [
      { field: 'cuentaContable', headerName: 'Cuenta contable', width: 130 },
      { field: 'descripcion', headerName: 'Descripción', width: 150, flex: 1,},
      { field: 'debe', headerName: 'Debe', width: 80, headerClass: 'centrarencabezado',
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        valueFormatter: (params) => {
          if (params.value !== null && params.value !== undefined) {
            const absValue = Math.abs(params.value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);
            
            if (params.value < 0) {
              return `(${formattedValue})`;
            }
            return formattedValue;
          }
          return '-';
        },
      },
      { field: 'haber', headerName: 'Haber', width: 80, headerClass: 'centrarencabezado',
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        valueFormatter: (params) => {
          if (params.value !== null && params.value !== undefined) {
            const absValue = Math.abs(params.value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);
            
            if (params.value < 0) {
              return `(${formattedValue})`;
            }
            return formattedValue;
          }
          return '-';
        },
      }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Asiento Contable: ${nroAsientoCont}`,
        widthModal: '740px',
        mostrarTabla: true,
        colDefs: colDefs,
        rowData: asientoData,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        ocultarBotonConfirmar: true,
        textoBotonCancelar: 'Cerrar'
      }
    });
    await modal.present();
  }

  async abrirModalDesdeTabla(rowData: any) {
    console.log('Abriendo modal desde la tabla con datos:', rowData);

    const asientoData = rowData.asientoData || [
      { cuentaContable: '1510.02', descripcion: 'Equipos de cocina - Revalorización', debe: 600.00, haber: 0.00},
      { cuentaContable: '3810.01', descripcion: 'Revalorización por inflación', debe: 0.00, haber: 600.00},
    ];

    const colDefs: ColDef[] = [
      { field: 'cuentaContable', headerName: 'Cuenta contable', width: 130 },
      { field: 'descripcion', headerName: 'Descripción', width: 150, flex: 1,},
      { field: 'debe', headerName: 'Debe', width: 80, headerClass: 'centrarencabezado',
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        valueFormatter: (params) => {
          if (params.value !== null && params.value !== undefined) {
            const absValue = Math.abs(params.value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);
            if (params.value < 0) {
              return `(${formattedValue})`;
            }
            return formattedValue;
          }
          return '-';
        },
      },
      { field: 'haber', headerName: 'Haber', width: 80, headerClass: 'centrarencabezado',
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        valueFormatter: (params) => {
          if (params.value !== null && params.value !== undefined) {
            const absValue = Math.abs(params.value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);
            
            if (params.value < 0) {
              return `(${formattedValue})`;
            }
            return formattedValue;
          }
          return '-';
        },
      }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Asiento Contable: ${rowData.gai_nro_asiento_cont || 'ASIN-2025-10'}`,
        widthModal: '700px',
        mostrarTabla: true,
        colDefs: colDefs,
        rowData: asientoData,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        ocultarBotonConfirmar: true,
        textoBotonCancelar: 'Cerrar'
      }
    });

    await modal.present();
  }

  // Método llamado por VistaCellRenderComponent al hacer clic en el ojo
  async abrirModal(nroAsiento: string, rowData: any) {
    if (!nroAsiento || nroAsiento === '-') return;

    const asientoData = rowData.asientoData || [
      { cuentaContable: '1510.02', descripcion: 'Equipos de cocina - Revalorización', debe: 600.00, haber: 0.00},
      { cuentaContable: '3810.01', descripcion: 'Revalorización por inflación', debe: 0.00, haber: 600.00},
    ];

    const colDefs: ColDef[] = [
      { field: 'cuentaContable', headerName: 'Cuenta contable', width: 130 },
      { field: 'descripcion', headerName: 'Descripción', width: 150, flex: 1,},
      { field: 'debe', headerName: 'Debe', width: 80, headerClass: 'centrarencabezado',
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        valueFormatter: (params) => {
          if (params.value !== null && params.value !== undefined) {
            const absValue = Math.abs(params.value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);
            
            if (params.value < 0) {
              return `(${formattedValue})`;
            }
            return formattedValue;
          }
          return '-';
        },
      },
      { field: 'haber', headerName: 'Haber', width: 80, headerClass: 'centrarencabezado',
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        valueFormatter: (params) => {
          if (params.value !== null && params.value !== undefined) {
            const absValue = Math.abs(params.value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);
            
            if (params.value < 0) {
              return `(${formattedValue})`;
            }
            return formattedValue;
          }
          return '-';
        },
      }
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Asiento Contable: ${nroAsiento}`,
        widthModal: '700px',
        mostrarTabla: true,
        colDefs: colDefs,
        rowData: asientoData,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        ocultarBotonConfirmar: true,
        textoBotonCancelar: 'Cerrar'
      }
    });

    await modal.present();
  }

  contabilizar() {
    if (this.selectedCalculo) {
      // Cambiar el estado a "Contabilizado"
      this.selectedCalculo.gai_estado = 'Contabilizado';
      
      // Encontrar y actualizar la fila en rowData
      const index = this.rowData.findIndex(row => row.gai_codigo === this.selectedCalculo.gai_codigo);
      if (index !== -1) {
        this.rowData[index].gai_estado = 'Contabilizado';
        if (!this.rowData[index].gai_nro_asiento_cont) {
          this.rowData[index].gai_nro_asiento_cont = 'MN-2026-04-001';
        }
        // Forzar actualización del grid
        this.gridApi.refreshCells({ force: true });
      }
      
      // Actualizar selectedCalculo con la nueva referencia
      this.selectedCalculo = { ...this.rowData[index] };
      
      // Mostrar mensaje de éxito
      this.toastservice.success('¡Asiento generado exitosamente!');
    }
  }

  exportar() {
    console.log('Exportar cálculo:', this.selectedCalculo);
    // Aquí iría la lógica para exportar
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos
    this.cargarDatos(range.start, range.end);
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }

  // Para modo SINGLE - Manejo de fechas seleccionadas
  onFechaEjecucion(date: Date) {
    this.formIndexacion.patchValue({
      fechaEjecucion: date
    })
  }
  onFechaContable(date: Date) {
    this.formIndexacion.patchValue({
      fechaContable: date
    })
  }

  
   onBtReset() {
    this.facade.cargarAsientos();
  }
  
}
