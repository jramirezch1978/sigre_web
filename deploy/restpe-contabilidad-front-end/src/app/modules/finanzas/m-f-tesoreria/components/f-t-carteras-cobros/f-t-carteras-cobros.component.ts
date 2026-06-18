import { Component, OnInit, inject, computed, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CountryService } from 'src/app/ui/services/countryservice.service';

// Font Awesome Icons
import { faBook, faEye, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChartLine, faChevronsLeft, faChevronsRight, faDesktop, faDollarSign, faDownload, faRotateRight, faTriangleExclamation } from '@fortawesome/pro-solid-svg-icons';

import { CarterasCobrosEntity } from 'src/app/modules/finanzas/domain/models/carteras-cobros.entity';
import { CarterasCobrosFacade } from 'src/app/modules/finanzas/application/facades/carteras-cobros.facade';
import { CarterasCobrosFeedbackEffects } from 'src/app/modules/finanzas/effects/carteras-cobros-feedback.effect';
import { CarterasCobrosSyncEffects } from 'src/app/modules/finanzas/effects/carteras-cobros-sync.effect';

export interface card {
  title: string;
  cantidad: string;
  icon: string;
}

@Component({
  selector: 'app-f-t-carteras-cobros',
  templateUrl: './f-t-carteras-cobros.component.html',
  styleUrls: ['./f-t-carteras-cobros.component.scss'],
  standalone: false,
})
export class FTCarterasCobrosComponent  implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farEye = faEye;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChartLine = faChartLine;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasDesktop = faDesktop;
  fasDollarSign = faDollarSign;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;
  fasTriangleExclamation = faTriangleExclamation;

  readonly facade = inject(CarterasCobrosFacade);
  private readonly _syncEffects = inject(CarterasCobrosSyncEffects);
  private readonly _feedbackEffects = inject(CarterasCobrosFeedbackEffects);
  readonly loaderActivo = computed(() => this.facade.isLoading());

  //Tipo de cambio para ecuador

  pais = this.countryService.getCountryCode();
  mostrarTipoCambio: boolean = true;


  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  panelLateralVisible: boolean = true;
  cobroForm!: FormGroup;
  monedapais: any ='S/';

  private gridApi!: GridApi;
  gridContext!: { componentParent: FTCarterasCobrosComponent };
  filaSeleccionada: CarterasCobrosEntity | null = null;
  aplicarNotaCredito: boolean = false;

  estadoSelect = [
    { id: 'Pendiente', nombre: 'Pendiente' },
    { id: 'Parcial', nombre: 'Parcial' },
    { id: 'Cobrado', nombre: 'Cobrado' },
  ];

  mediosdeCobro = [
    { id: 'Efectivo', nombre: 'Efectivo' },
    { id: 'Transferencia', nombre: 'Transferencia' },
    { id: 'Cheque', nombre: 'Cheque' },
    { id: 'Tarjeta', nombre: 'Tarjeta' },
  ];

  monedas = [
    { id: 'Soles', nombre: 'Soles (S/)', simbolo: 'S/' },
    { id: 'Dolares', nombre: 'Dólares ($)', simbolo: '$' },
  ];

  sucursales = [
    { id: 1, nombre: 'La Molina, Lima' },
    { id: 2, nombre: 'San Isidro, Lima' },
    { id: 3, nombre: 'Miraflores, Lima' },
  ];

  notasCredito = [
    { id: 'NC-001', nombre: 'NC-001 - S/ 500.00' },
    { id: 'NC-002', nombre: 'NC-002 - S/ 1,200.00' },
    { id: 'NC-003', nombre: 'NC-003 - S/ 800.00' },
  ];

  cardsCobros: card[] = [
    { title: 'Documentos vencidos', cantidad: '20 doc. (10%)', icon: 'triangle-exclamation' },
    { title: 'Promedio de días de cobro', cantidad: '10', icon: 'desktop' },
    { title: 'Monto total anticipos', cantidad: 'S/ 10,000.00', icon: 'dollar-sign' },
    { title: 'Notas de crédito aplicadas', cantidad: 'S/ 10,000.00', icon: 'chart-line' },
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

  rowData: CarterasCobrosEntity[] = [];

  colDefs: ColDef[] = [
    { field: 'cc_cliente', headerName: 'Cliente', flex:1, minWidth: 170, filter: true },
    { field: 'cc_tipoDoc', headerName: 'Tipo de comprobante', width: 120, filter: true },
    { field: 'cc_serieNum', headerName: 'Serie/N° comprobante', width: 120 },
    { field: 'cc_fechaEmision', headerName: 'Fecha de emisión', width: 120 },
    { field: 'cc_fechaVenc', headerName: 'Fecha de vencimiento', width: 130 },
    { field: 'cc_sucursal', headerName: 'Sucursal', width: 150, filter: true },
    { 
      field: 'cc_montoTotal', 
      headerName: 'Monto total', 
      width: 110,
      headerClass: 'ag-right-aligned-header',

      // Para diferentes paises
      
      
      // valueFormatter: (params) => {
      //   if (params.value !== null && params.value !== undefined) {
      //     const valorNumerico = typeof params.value === 'string' 
      //       ? parseFloat(params.value.replace('S/ ', '').replace(/,/g, ''))
      //       : params.value;
          
      //     const absValue = Math.abs(valorNumerico);
      //     const formattedValue = new Intl.NumberFormat('es-PE', {
      //       minimumFractionDigits: 2,
      //       maximumFractionDigits: 2,
      //     }).format(absValue);
          
      //     if (valorNumerico < 0) {::
      //       return `(${formattedValue})`;
      //     }
      //     return formattedValue;
      //   }
      //   return '';
      // },
      // Para tropicalizacion de paises
      valueFormatter: (params: any) => {
        if(params.value){
          return `${this.monedapais} ${params.value}`;
        }
        return '-'
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'right' };
        if (params.value !== null && params.value !== undefined) {
          const valorNumerico = typeof params.value === 'string' 
            ? parseFloat(params.value.replace('S/ ', '').replace(/,/g, ''))
            : params.value;
          
          if (valorNumerico < 0) {
            style.color = '#EF4444';
          }
        }
        return style;
      }
      
    },
    { 
      field: 'cc_montoCobrado', 
      headerName: 'Monto cobrado', 
      width: 110,
      headerClass: 'ag-right-aligned-header',
      // valueFormatter: (params) => {
      //   if (params.value !== null && params.value !== undefined) {
      //     const valorNumerico = typeof params.value === 'string' 
      //       ? parseFloat(params.value.replace('S/ ', '').replace(/,/g, ''))
      //       : params.value;
          
      //     const absValue = Math.abs(valorNumerico);
      //     const formattedValue = new Intl.NumberFormat('es-PE', {
      //       minimumFractionDigits: 2,
      //       maximumFractionDigits: 2,
      //     }).format(absValue);
          
      //     if (valorNumerico < 0) {
      //       return `(${formattedValue})`;
      //     }
      //     return formattedValue;
      //   }
      //   return '';
      // },

      valueFormatter: (params: any) => {
        if(params.value){
          return `${this.monedapais} ${params.value}`;
        }
        return '-'
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'right' };
        if (params.value !== null && params.value !== undefined) {
          const valorNumerico = typeof params.value === 'string' 
            ? parseFloat(params.value.replace('S/ ', '').replace(/,/g, ''))
            : params.value;
          
          if (valorNumerico < 0) {
            style.color = '#EF4444';
          }
        }
        return style;
      }
    },
    { 
      field: 'cc_montoPendiente', 
      headerName: 'Monto pendiente', 
      width: 110,
      headerClass: 'ag-right-aligned-header',
      // valueFormatter: (params) => {
      //   if (params.value !== null && params.value !== undefined) {
      //     const valorNumerico = typeof params.value === 'string' 
      //       ? parseFloat(params.value.replace('S/ ', '').replace(/,/g, ''))
      //       : params.value;
          
      //     const absValue = Math.abs(valorNumerico);
      //     const formattedValue = new Intl.NumberFormat('es-PE', {
      //       minimumFractionDigits: 2,
      //       maximumFractionDigits: 2,
      //     }).format(absValue);
          
      //     if (valorNumerico < 0) {
      //       return `(${formattedValue})`;
      //     }
      //     return formattedValue;
      //   }
      //   return '';
      // },

      valueFormatter: (params: any) => {
        if(params.value){
          return `${this.monedapais} ${params.value}`;
        }
        return '-'
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'right' };
        if (params.value !== null && params.value !== undefined) {
          const valorNumerico = typeof params.value === 'string' 
            ? parseFloat(params.value.replace('S/ ', '').replace(/,/g, ''))
            : params.value;
          
          if (valorNumerico < 0) {
            style.color = '#EF4444';
          }
        }
        return style;
      }
    },
    { field: 'cc_estado', headerName: 'Estado', width: 100, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center',},
      cellRenderer: (params: any) => {
        if (params.value === 'Cobrado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Cobrado</span>';
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        } else if (params.value === 'Parcial') {
          return '<span class="badge-table bg-[#FFEDD5] text-[#EA580C]">Parcial</span>';
        } else if (params.value === 'Vencido') {
          return '<span class="badge-table bg-[#FEF3C7] text-[#F2A626]">Vencido</span>';
        }
        return params.value;
      },
    },
  ];

  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private countryService: CountryService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    effect(() => {
      const data = this.facade.cobros();
      this.rowData = data;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...data]);
      }
    });
  }

  ngOnInit() {
    // Inicializar formulario
    this.cobroForm = this.formBuilder.group({
      razonSocial: [''],
      usuarioEjecutor: [''],
      cliente: [''],
      tipoDoc: [''],
      serieNumDoc: [''],
      fechaEmision: [{value: '', disabled: true}],
      fechaVencimiento: [{value: '', disabled: true}],
      moneda: [''],
      tipoCambio: [''],
      montoTotal: [''],
      montoCobrado: [''],
      saldoPendiente: [''],
      sucursales: [''],
      estado: [''],
      mediodeCobro: [''],
      fechadeCobro: [''],
      fechadeCobroParcial: [''],
      asientoContable: [''],
      notaCredito: [''],
      observacion: [''],
    });

    // Contexto de la grilla
    this.gridContext = { componentParent: this };
    this.facade.cargarDatos();

    //Labels de formulario: Tipo de cambio por ahora
    this.configurarLabelsPorPais();

  }

  
 configurarLabelsPorPais() {
  if(this.pais === 'EC') {
    this.mostrarTipoCambio = false; // Ocultar tipo de cambio en Ecuador
  }
}

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    if (this.rowData.length > 0) {
      this.gridApi.setGridOption('rowData', [...this.rowData]);
    }
    if (this.filaSeleccionada) {
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node: any) => {
            if (node.data && node.data.cc_serieNum === this.filaSeleccionada?.cc_serieNum) {
              node.setSelected(true);
              this.gridApi.ensureNodeVisible(node, 'middle');
            }
          });
        }
      }, 150);
    }
  }

  onCellClicked(event: any) {
    const data = event?.data;
    if (!data) { return; }

    this.filaSeleccionada = data;
    this.aplicarNotaCredito = data.cc_estado === 'Vencido' || data.cc_estado === 'Cobrado';

    // Limpiar formulario
    this.cobroForm.reset();

    // Cargar campos fijos
    this.cobroForm.patchValue({
      razonSocial: data.cc_cliente || '',
      usuarioEjecutor: 'Eduardo Jiménez López',
      cliente: data.cc_cliente || '',
      tipoDoc: data.cc_tipoDoc || '',
      serieNumDoc: data.cc_serieNum || '',
      fechaEmision: this.convertirFechaParaInput(data.cc_fechaEmision) || '',
      fechaVencimiento: this.convertirFechaParaInput(data.cc_fechaVenc) || '',
      moneda: data.cc_moneda || 'Soles',
      tipoCambio: 'S/ 3.40',
      montoTotal: this.formatearMonto(data.cc_montoTotal) || '',
      montoCobrado: this.formatearMonto(data.cc_montoCobrado) || '',
      sucursales: data.cc_sucursal,
    });

    // Cargar datos según el estado
    if (data.cc_estado === 'Pendiente') {
      this.cobroForm.patchValue({
        estado: data.cc_estado,
        observacion: data.cc_observacion || '',
      });
      this.cobroForm.disable();
      this.cobroForm.get('estado')?.enable();
    } else if (data.cc_estado === 'Parcial') {
      this.cobroForm.patchValue({
        estado: data.cc_estado,
        mediodeCobro: data.cc_mediodeCobro || '',
        fechadeCobroParcial: data.cc_fechadeCobroParcial || '',
        saldoPendiente: this.formatearMonto(data.cc_saldoPendiente) || '',
        observacion: data.cc_observacion || '',
      });
      this.cobroForm.enable();
      this.cobroForm.get('fechaEmision')?.disable();
      this.cobroForm.get('fechaVencimiento')?.disable();
    } else if (data.cc_estado === 'Cobrado') {
      this.cobroForm.patchValue({
        estado: data.cc_estado,
        mediodeCobro: data.cc_mediodeCobro || 'Transferencia',
        fechadeCobro: this.convertirFechaParaInput(data.cc_fechadeCobro || '27/10/2025'),
        asientoContable: data.cc_asientoContable || 'ASC-2025-000148',
        observacion: data.cc_observacion || 'Cobro realizado el 27/10/2025 mediante transferencia bancaria.',
      });
      // Deshabilitar todos los campos en estado Cobrado
      this.cobroForm.disable();
    } else if (data.cc_estado === 'Vencido') {
      this.cobroForm.patchValue({
        estado: data.cc_estado,
        observacion: data.cc_observacion || '',
      });
      // Deshabilitar todos los campos en estado Vencido
      this.cobroForm.disable();
    } else {
      this.cobroForm.enable();
    }

    // Seleccionar la fila en la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    if (event.node) {
      event.node.setSelected(true);
    }
  }

  formatearMonto(valor: number): string {
    if (!valor) return '';
    return `S/ ${valor.toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
  }

  onFechadeCobroSeleccionada(date: Date) {
    if (this.cobroForm && date) {
      this.cobroForm.patchValue({ fechadeCobro: date });
    }
  }

  onFechadeCobroParcialSeleccionada(date: Date) {
    if (this.cobroForm && date) {
      this.cobroForm.patchValue({ fechadeCobroParcial: date });
    }
  }

  onCheckboxNotaCreditoChange(event: any) {
    this.aplicarNotaCredito = event.detail.checked;
    
    if (!this.aplicarNotaCredito) {
      this.cobroForm.patchValue({ notaCredito: null });
    }
  }

  // Convierte fecha de DD/MM/YYYY a YYYY-MM-DD para inputs tipo date
  convertirFechaParaInput(fecha: string): string {
    if (!fecha) return '';
    const partes = fecha.split('/');
    if (partes.length === 3) {
      return `${partes[2]}-${partes[1]}-${partes[0]}`;
    }
    return fecha;
  }

  botonGuardar() {
    if (this.cobroForm.invalid) {
      this.toastService.danger('Por favor, complete todos los campos requeridos.');
      return;
    }

    if (!this.filaSeleccionada) {
      this.toastService.danger('No hay documento seleccionado.');
      return;
    }

    const fila = this.filaSeleccionada;
    const estadoValue = this.cobroForm.get('estado')?.value;
    const mediodeCobroValue = this.cobroForm.get('mediodeCobro')?.value;
    const fechadeCobroValue = this.cobroForm.get('fechadeCobro')?.value;
    const fechadeCobroParcialValue = this.cobroForm.get('fechadeCobroParcial')?.value;
    const observacionValue = this.cobroForm.get('observacion')?.value;

    const entidadActualizada: CarterasCobrosEntity = {
      ...fila,
      ...(estadoValue ? { cc_estado: estadoValue } : {}),
      ...(mediodeCobroValue ? { cc_mediodeCobro: mediodeCobroValue } : {}),
      ...(fechadeCobroValue ? { cc_fechadeCobro: fechadeCobroValue } : {}),
      ...(fechadeCobroParcialValue ? { cc_fechadeCobroParcial: fechadeCobroParcialValue } : {}),
      ...(observacionValue ? { cc_observacion: observacionValue } : {}),
    } as CarterasCobrosEntity;

    this.facade.actualizar(entidadActualizada);
    this.onCellClicked({ data: entidadActualizada, node: null });
  }

  async verAsientoContable() {
    const colDefs: ColDef[] = [
      { field: 'cuentaContable', headerName: 'Cuenta Contable', width: 120 },
      { field: 'descripcion', headerName: 'Descripción', flex: 1 },
      { field: 'debe', headerName: 'Debe (S/)', width: 100, headerClass: 'centrarencabezado', cellStyle: { textAlign: 'right' } },
      { field: 'haber', headerName: 'Haber (S/)', width: 100, headerClass: 'centrarencabezado', cellStyle: { textAlign: 'right' } },
    ];
    
    const rowData = [
      { cuentaContable: '121101', descripcion: 'Clientes nacionales', debe: '5,500.00', haber: '-' },
      { cuentaContable: '101101', descripcion: 'Caja y Bancos – Interbank', debe: '-', haber: '5,500.00' },
    ];

    const detalles = [
      { label: 'Fecha de registro', value: '05/11/2025' },
      { label: 'Origen', value: 'Tesorería' },
      { label: 'Sucursal', value: 'Sucursal Principal' },
      { label: 'Estado', value: 'Registrado' },
      { label: 'Total Debe (S/)', value: '5,500.00' },
      { label: 'Total Haber (S/)', value: '5,500.00' },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Información del asiento contable ASC-2025-000145',
        subtitulomodal: 'Detalle del asiento',
        detalles: detalles,
        mostrarTabla: true,
        colDefs: colDefs,
        rowData: rowData,
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        textoBotonCancelar: 'Cerrar',
      }
    });

    await modal.present();
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Lógica para filtrar datos
  }

  async modalverActualizaciones() {
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

    const rowData = [
      { fechaHora: '12/12/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Se registró el documento' },
      { fechaHora: '13/12/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se programó el cobro' },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones del documento ${this.filaSeleccionada?.cc_tipoDoc} - ${this.filaSeleccionada?.cc_serieNum}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }

  onBtReset() {
    this.facade.cargarDatos();
  }

}
