import { Component, OnInit, inject, effect } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ModalDetalleDocComponent } from '../../modals/modal-detalle-doc/modal-detalle-doc.component';
import { ModalAplicarCanjeComponent } from '../../modals/modal-aplicar-canje/modal-aplicar-canje.component';
import { ModalReprogramarComponent } from '../../modals/modal-reprogramar/modal-reprogramar.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { CanjeReprogramacionFacade } from 'src/app/modules/finanzas/application/facades/canje-reprogramacion.facade';
import { CanjeReprogramacionFeedbackEffects } from 'src/app/modules/finanzas/effects/canje-reprogramacion-feedback.effect';
import { CanjeReprogramacionSyncEffects } from 'src/app/modules/finanzas/effects/canje-reprogramacion-sync.effect';
import { CanjeReprogramacionEntity } from 'src/app/modules/finanzas/domain/models/canje-reprogramacion.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDollarSign, faDownload, faExclamation, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-f-o-canje-y-reprogramacion',
  templateUrl: './f-o-canje-y-reprogramacion.component.html',
  styleUrls: ['./f-o-canje-y-reprogramacion.component.scss'],
  standalone: false,
})
export class FOCanjeYReprogramacionComponent  implements OnInit {
  // Facade + Effects
  readonly canjeFacade = inject(CanjeReprogramacionFacade);
  private readonly _feedbackEffects = inject(CanjeReprogramacionFeedbackEffects);
  private readonly _syncEffects = inject(CanjeReprogramacionSyncEffects);
  readonly isLoading = this.canjeFacade.isLoading;

  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDollarSign = faDollarSign;
  fasDownload = faDownload;
  fasExclamation = faExclamation;
  fasRotateRight = faRotateRight;



    //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  filaSeleccionada: any;
  private gridApi!: GridApi;
  context: any;
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
  columnTypes = {
    currency: {
      width: 150,
    },
    shaded: {
      cellClass: 'shaded-class'
    }
  };
  defaultColDef = {
    resizable: true,
    flex: 1,
    minWidth: 100,
  };

  rowData: CanjeReprogramacionEntity[] = [];

  
  colDefs: ColDef[] = [
    { field: 'canje_tipo_comprobante', headerName: 'Tipo de comprobante', width: 120, filter: true },
    { field: 'canje_nro_documento', headerName: 'N° comprobante', width: 120, cellRenderer: VistaCellRenderComponent, },
    { field: 'canje_doc_fiscal', headerName: 'Documento fiscal', minWidth: 140, flex: 1 , filter: true },
    { field: 'canje_proveedor', headerName: 'Razón social', minWidth: 140, flex: 1 , filter: true },
    { field: 'canje_fecha_emision', headerName: 'Fecha emisión', width: 120,
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
    { field: 'canje_fecha_vencimiento', headerName: 'Fecha vencimiento', width: 130,
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
    { field: 'canje_monto_total', headerName: 'Monto total', width: 100,
      valueFormatter: (params: any) => {
        if (params.data?.canje_moneda === 'Soles') {
          return `S/ ${params.value}`;
        }
        return params.value;
      }
    },
    { field: 'canje_monto_pendiente', headerName: 'Monto pendiente', width: 120,
      valueFormatter: (params: any) => {
        if (params.data?.canje_moneda === 'Soles') {
          return `S/ ${params.value}`;
        }
        return params.value;
      }
    },
    { field: 'canje_moneda', headerName: 'Moneda', width: 100, filter: true },
    { field: 'canje_centro_costo', headerName: 'Centro de costo', width: 140, filter: true },
    { field: 'canje_sucursal', headerName: 'Sucursal', width: 120, filter: true },
    { field: 'canje_asiento', headerName: 'Asiento', width: 140, cellRenderer: VistaCellRenderComponent,},
    { field: 'canje_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center'},
      cellRenderer: (params: any) => {
        if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        } else if (params.value === 'Pagado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagado</span>';
        } else if (params.value === 'Compensado') {
          return '<span class="badge-table bg-[#D6E6FF] text-primary">Compensado</span>';
        } else if (params.value === 'Anulado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulado</span>';
        }
        return params.value;
      }
    }
  ];


  constructor(
    private modalController: ModalController,
    private toastservice: ToastService
  ) {
    effect(() => {
      this.rowData = this.canjeFacade.registros();
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }
    });

    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  ngOnInit() {
    this.canjeFacade.cargarRegistros();
    this.context = { componentParent: this };
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }
  async onCellClicked(event: any) {
    const data = event.data;
    this.filaSeleccionada = data;
  }
  onBtReset() {
    this.canjeFacade.cargarRegistros();
  }
  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos
  }

  async abrirModal(value: any, rowData: any) {
      console.log('Abriendo modal para:', value, rowData);
      
      // Determinar si es documento o asiento basándose en el valor
      const esDocumento = value.includes('F') || value.includes('DOC');
      const esAsiento = value.includes('MN') || value.includes('ASC');
      
      if (esDocumento) {
        await this.abrirModalDocumento(value, rowData);
      } else if (esAsiento) {
        await this.abrirModalAsiento(value, rowData);
      }
    }
  
    async abrirModalDocumento(numeroDocumento: string, rowData: any) {
      const detalleDocumento = [
        { label: 'Razón Social', value: 'CONSTRUCTORA ABC S.A.C.' },
        { label: 'Monto total', value: 'S/ 1,500.00' },
        { label: 'Proveedor', value: 'Constructora ABC' },
        { label: 'Monto pendiente', value: 'S/ 200.00' },
        { label: 'Fecha emisión', value: '12/12/2025' },
        { label: 'Centro de costo', value: 'Almacenes y bodegas' },
        { label: 'Fecha vencimiento', value: '12/12/2025' },
        { label: 'Sucursal', value: 'Lima Centro' },
        { label: 'Moneda', value: 'Soles' },
        { label: 'Estado', value: 'Pendiente' },
      ];
  
      const modal = await this.modalController.create({
        component: ModalDetalleDocComponent,
        cssClass: 'promo',
        componentProps: {
          tituloModal: `Movimientos del documento ${numeroDocumento}`,
          detalles: detalleDocumento,
          textoBotonSecundario: 'Reprogramar vencimiento',
          textoBotonPrimario: 'Aplicar canje',
          colorBoton: 'medium',
        }
      });
  
      await modal.present();

      const { data } = await modal.onDidDismiss();
      if (data) {
        if (data.accion === 'primaria') {
          console.log('Aplicar canje seleccionado');
          // Lógica para aplicar canje
          this.aplicarCanje();
        } else if (data.accion === 'secundaria') {
          console.log('Reprogramar vencimiento seleccionado');
          // Lógica para reprogramar vencimiento
          this.reprogramarVencimiento(rowData);
        }
      }
    }
    
    async aplicarCanje() {

      const modal = await this.modalController.create({
        component: ModalAplicarCanjeComponent,
        cssClass: 'promo2',
        componentProps: {
          razonS: 'CONSTRUCTORA ABC S.A.C.',
          proveedor: 'Constructora ABC',
          nDocumento: 'F001-00123',
          montoP:  200.00,
        }
      });
  
      await modal.present();
      const { data } = await modal.onDidDismiss();
      if (data == true) {
        const nroDocumento = this.filaSeleccionada?.canje_nro_documento ?? 'F001-00123';
        this.canjeFacade.aplicarCanje(nroDocumento);
      }
    }

    async reprogramarVencimiento( rowData: any) {
      const modal = await this.modalController.create({
        component: ModalReprogramarComponent,
        cssClass: 'promo2',
        componentProps: {
          fechaVencimientoActual: rowData.canje_fecha_vencimiento
        }
      });
  
      await modal.present();
      const { data } = await modal.onDidDismiss();
      if (data?.success) {
        const nroDocumento = this.filaSeleccionada?.canje_nro_documento ?? rowData.canje_nro_documento;
        this.canjeFacade.reprogramarVencimiento(nroDocumento, data.nuevaFechaVencimiento);
      }
    }

  async abrirModalAsiento(numeroAsiento: string, rowData: any) {
  
    const detalleAsiento=[
      { label: 'Fecha de registro', value: '12/12/2025'},
      { label: 'Fecha contable', value: '12/12/2025'},
      { label: 'Glosa', value: 'Provisión de servicios de internet - Local San Isidro (Mes 11/2025)'},
      { label: 'Total', value: 'S/ 380.00'},
      { label: 'Duplicado', value: 'No'},
    ]

    const colDefs: ColDef[] = [
      {  field: 'cuentaContable',  headerName: 'Cuenta contable',  width: 100 },
      {  field: 'descripcion',  headerName: 'Descripción',  minWidth: 150, flex: 1 ,},
      { field: 'debe', headerName: 'Debe (S/)',  width: 80, headerClass: 'centrarencabezado',
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
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
          return '-';
        },
      },
      { field: 'haber', headerName: 'Haber (S/)', width: 80,
        headerClass: 'centrarencabezado',cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
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
          return '-';
        },
      },
      {  field: 'centroC',  headerName: 'Centro de costo',  width: 100 },
      {  field: 'docRef',  headerName: 'Documento referencial',  width: 100 },
      {  field: 'tercero',  headerName: 'Tercero',  width: 80 },

    ];
  
    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Asiento ${numeroAsiento}`,
        subtitulomodal: 'Detalle del asiento',
        detalles: detalleAsiento,
        mostrarTabla: true,
        mostrarTextarea: false,
        mostrarTotal: true,
        itemstotal: [
          { label: 'Total debe(S/):', value: 'S/380.00' },
          { label: 'Total haber(S/):', value: 'S/380.00' }
        ],
        mostrarBotonEliminar: false,
        widthModal: '740px',
        colDefs: colDefs,
        rowData: [
          {
            cuentaContable: rowData.cuentaC || '151002',
            descripcion: `Asiento para ${rowData.canje_proveedor || 'Proveedor'}`,
            debe: rowData.montoT || 380.00,
            haber: 0,
            centroC: 'CC-SI01',
            docRef: rowData.canje_nro_documento,
            tercero: 'Claro Perú',
          },
          {
            cuentaContable: '381001',
            descripcion: 'Contrapartida del asiento',
            debe: 0,
            haber: rowData.montoT || 380.00,
            centroC: 'CC-SI01',
            docRef: rowData.canje_nro_documento,
            tercero: 'Claro Perú',
          }
        ]
      }
    });

    await modal.present();
  }

}
