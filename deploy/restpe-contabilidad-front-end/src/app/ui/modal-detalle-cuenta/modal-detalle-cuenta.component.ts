import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi } from 'ag-grid-enterprise';
import { ObservacionCellRenderComponent } from '../observacion-cell-render/observacion-cell-render.component';
import { ModalAdjuntarObservacionComponent } from '../modal-adjuntar-observacion/modal-adjuntar-observacion.component';
import { ModalGenerarAjusteComponent } from '../modal-generar-ajuste/modal-generar-ajuste.component';

// Font Awesome Icons
import { faChartLineDown, faDisplayChartUpCircleDollar, faSackDollar, faXmark } from '@fortawesome/pro-solid-svg-icons';
import { faInfoCircle, faLinkSimple, faLinkSlash, faGear } from '@fortawesome/pro-regular-svg-icons';
import { IconDefinition } from '@fortawesome/fontawesome-svg-core';


// Font Awesome Icons

// Font Awesome Icons

@Component({
  selector: 'app-modal-detalle-cuenta',
  templateUrl: './modal-detalle-cuenta.component.html',
  styleUrls: ['./modal-detalle-cuenta.component.scss'],
  standalone: false,
})
export class ModalDetalleCuentaComponent  implements OnInit {
  // Font Awesome Icons
  fasChartLineDown = faChartLineDown;
  fasDisplayChartUpCircleDollar = faDisplayChartUpCircleDollar;
  fasSackDollar = faSackDollar;
  fasXmark = faXmark;
  farInfoCircle = faInfoCircle;
  farLinkSimple = faLinkSimple;
  farLinkSlash = faLinkSlash;
  farGear = faGear;


  @Input() existendiferencias :boolean=false;
  @Input() cuentaData?: any;
  tabSeleccionadoDetalle='movimientos';
  private gridApiBancarioMultiple!: GridApi;
  
  // Propiedades para el modal de ajuste
  colDefsMovimientosAjustarModalPasarela: ColDef[] = [
    { field: 'fecha', headerName: 'Fecha', flex: 1, minWidth: 70 },
    { field: 'pasarela', headerName: 'Pasarela', flex: 1, minWidth: 80 },
    { field: 'comprobante', headerName: 'Comprobante', flex: 1, minWidth: 100 },
    { field: 'cliente', headerName: 'Cliente', flex: 1.5, minWidth: 120 },
    { field: 'monto', headerName: 'Monto', flex: 1, minWidth: 80, cellStyle: { textAlign: 'right' } },
    { field: 'comision', headerName: 'Comisión', flex: 1, minWidth: 80, cellStyle: { textAlign: 'right' } },
    { field: 'neto', headerName: 'Neto', flex: 1, minWidth: 80, cellStyle: { textAlign: 'right' } },
  ];

  colDefsAsientoModalPasarela: ColDef[] = [
    { field: 'cuenta', headerName: 'Cuenta', flex: 2, minWidth: 150 },
    { field: 'debe', headerName: 'Debe', flex: 1, minWidth: 100, cellStyle: { textAlign: 'right' } },
    { field: 'haber', headerName: 'Haber', flex: 1, minWidth: 100, cellStyle: { textAlign: 'right' } },
  ];

  tiposAjustePasarela = [
    { value: '001', label: 'Comisión bancaria' },
    { value: '002', label: 'Diferencia de cambio' },
    { value: '003', label: 'Error de registro' },
  ];

  cuentasContablesPasarela = [
    { value: '10411001', label: '10411001 - Banco de Crédito - Cuenta Corriente Soles' },
    { value: '63111001', label: '63111001 - Comisiones bancarias' },
    { value: '40111001', label: '40111001 - IGV por pagar' },
  ];
  
  cards=[
      {nombre:'Saldo contable', valor:'S/485,750.00', icono: faChartLineDown},
      {nombre:'Saldo bancario', valor:'S/485,750.00', icono: faSackDollar},
      {nombre:'Diferencia', valor:'S/0.00', icono: faDisplayChartUpCircleDollar},
    ]
    colDefsMovimientos: ColDef[] = [
      { field: 'fecha', headerName: 'Fecha', flex: 1, minWidth: 56,filter:true },
      { field: 'pasarela', headerName: 'Pasarela', flex: 1, minWidth: 50},
      { field: 'descripcion', headerName: 'Descripción', flex: 2, minWidth: 84,},
      { field: 'cliente', headerName: 'Cliente', flex: 1, minWidth: 50},
      { field: 'comprobante', headerName: 'Nº de comprobante', flex: 1, minWidth: 76},
      { field: 'monto', headerName: 'Monto', flex: 1, minWidth: 70,
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
        cellStyle: (params) => {
          const style: any = { textAlign: 'right' };
          if (params.value < 0) {
            style.color = '#EF4444';
          }
          return style;
        },
      },
      { field: 'usuario', headerName: 'Usuario', flex: 1, minWidth: 46},
      // { field: 'estado', headerName: 'Estado', flex: 1, minWidth: 56,
      //   cellRenderer: (params: any) => {
      //     const estado = params.value;
      //     let badgeClass = '';
          
      //     switch(estado) {
      //       case 'Conciliado':
      //         badgeClass = 'bg-green-100 text-green-600';
      //         break;
      //       default:
      //         badgeClass = 'bg-[#F5F5F5] text-[#363636]';
      //     }
          
      //     return `<div class="badge-table ${badgeClass}"><span>${estado}</span></div>`;
      //   },
      //   cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      //  },    
    ];
    colDefsMovimientosMultiple: ColDef[] = [
      { field: '', checkboxSelection: true, headerCheckboxSelection: true,headerName: '', flex: 0.5, minWidth: 23 },
      { field: 'fecha', headerName: 'Fecha', flex: 1, minWidth: 56,filter:true },
      { field: 'pasarela', headerName: 'Pasarela', flex: 1, minWidth: 50},
      { field: 'descripcion', headerName: 'Descripción', flex: 2, minWidth: 84,},
      { field: 'cliente', headerName: 'Cliente', flex: 1, minWidth: 50},
      { field: 'comprobante', headerName: 'Nº de comprobante', flex: 1, minWidth: 76},
      { field: 'monto', headerName: 'Monto', flex: 1, minWidth: 70,
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
        cellStyle: (params) => {
          const style: any = { textAlign: 'right' };
          if (params.value < 0) {
            style.color = '#EF4444';
          }
          return style;
        },
      },
      { field: 'usuario', headerName: 'Usuario', flex: 1, minWidth: 46},
      // { field: 'estado', headerName: 'Estado', flex: 1, minWidth: 56,
      //   cellRenderer: (params: any) => {
      //     const estado = params.value;
      //     let badgeClass = '';
          
      //     switch(estado) {
      //       case 'Conciliado':
      //         badgeClass = 'bg-green-100 text-green-600';
      //         break;
      //       default:
      //         badgeClass = 'bg-[#F5F5F5] text-[#363636]';
      //     }
          
      //     return `<div class="badge-table ${badgeClass}"><span>${estado}</span></div>`;
      //   },
      //   cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      //  },    
    ];
  colDefsBancario: ColDef[] = [
    { field: 'fecha', headerName: 'Fecha', flex: 1, minWidth: 40,filter:true },
    { field: 'id', headerName: 'ID trans.', flex: 1, minWidth: 40,filter:true},
    { field: 'comprobante', headerName: 'Nº de comprobante', flex: 1, minWidth: 46,filter:true },
    { field: 'cliente', headerName: 'Cliente', flex: 1, minWidth: 46,filter:true },
    { field: 'monto', headerName: 'Monto', flex: 1, minWidth: 60,
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
      cellStyle: (params) => {
        const style: any = { textAlign: 'right' };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { field: 'comision', headerName: 'Comisión', flex: 2, minWidth: 80,},
    { field: 'neto', headerName: 'Neto', flex: 1, minWidth: 46,filter:true },
    // { field: 'estado', headerName: 'Estado', flex: 1, minWidth: 56,
    //   cellRenderer: (params: any) => {
    //     const estado = params.value;
    //     let badgeClass = '';
        
    //     switch(estado) {
    //       case 'Conciliado':
    //         badgeClass = 'bg-green-100 text-green-600';
    //         break;
    //       default:
    //         badgeClass = 'bg-[#F5F5F5] text-[#363636]';
    //     }
        
    //     return `<div class="badge-table ${badgeClass}"><span>${estado}</span></div>`;
    //   },
    //   cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    //  },  
    ]
    colDefsBancarioMultiple: ColDef[] = [
    { field: '', checkboxSelection: true, headerCheckboxSelection: true,headerName: '', flex: 0.5, minWidth: 23 },
    { field: 'fecha', headerName: 'Fecha', flex: 1, minWidth: 40,filter:true },
    { field: 'id', headerName: 'ID trans.', flex: 1, minWidth: 40,filter:true},
    { field: 'comprobante', headerName: 'Nº de comprobante', flex: 1, minWidth: 46,filter:true },
    { field: 'cliente', headerName: 'Cliente', flex: 1, minWidth: 46,filter:true },
    { field: 'monto', headerName: 'Monto', flex: 1, minWidth: 60,
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
      cellStyle: (params) => {
        const style: any = { textAlign: 'right' };
        if (params.value < 0) {
          style.color = '#EF4444';
        }
        return style;
      },
    },
    { field: 'comision', headerName: 'Comisión', flex: 2, minWidth: 80,},
    { field: 'neto', headerName: 'Neto', flex: 1, minWidth: 46,filter:true },
    {
      field: 'estado', headerName: 'Estado', flex: 1, minWidth: 56, headerClass: 'centrarencabezado',
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';
        
        switch(estado) {
          case 'Conciliado':
            badgeClass = 'bg-green-100 text-green-600';
            break;
          default:
            badgeClass = 'bg-[#F5F5F5] text-[#363636]';
        }
        
        return `<div class="badge-table ${badgeClass}"><span>${estado}</span></div>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    },
    {
      field: 'acciones', headerName: 'Acciones', flex: 0.5, minWidth: 60, headerClass: 'centrarencabezado',
      cellRenderer: ObservacionCellRenderComponent,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    },
    ]
    colDefsHistorial: ColDef[]=[
    { field: 'fechahora', headerName: 'Fecha y hora', flex: 1, minWidth: 40,filter:true },
    { field: 'usuario', headerName: 'Usuario', flex: 1, minWidth: 40,filter:true },
    { field: 'accion', headerName: 'Acción', flex: 1, minWidth: 40,filter:true },
    { field: 'detalle', headerName: 'Detalle del Cambio', flex: 1, minWidth: 40,filter:true },
    ]
    rowDataHistorial=[
      {fechahora:'09/12/2024 11:20:00', usuario:'Carlos Rodríguez', accion:'En proceso', detalle:'Se guardó el proceso para editar posteriormente.'}
    ]
  rowDataMovimientos = [
    {fecha:'10/11/2025', pasarela:'Yape', descripcion:'Pago por delivery - Orden #12345', cliente:'Juan Pérez García', comprobante:'B001-00234', monto:850.00, usuario:'clopez', estado:'Pendiente'},
    {fecha:'10/11/2025', pasarela:'Mercado Pago', descripcion:'Pago adelantado - Evento corporativo', cliente:'Transportes Norte SAC', comprobante:'F001-00095', monto:1450.00, usuario:'vlosano', estado:'Pendiente'},
    {fecha:'10/11/2025', pasarela:'Yape', descripcion:'Pago por consumo en local', cliente:'María López Sánchez', comprobante:'B001-00235', monto:140.00, usuario:'asanchez', estado:'Pendiente'},
    {fecha:'10/11/2025', pasarela:'Niubiz', descripcion:'Pago tarjeta de crédito - Mesa 15', cliente:'Carlos Ramírez Torres', comprobante:'B001-00236', monto:340.00, usuario:'vlosano', estado:'Pendiente'},
    {fecha:'10/11/2025', pasarela:'Mercado Pago', descripcion:'Pago por catering empresarial', cliente:'Grupo Inversiones ABC', comprobante:'F001-00096', monto:2450.00, usuario:'asanchez', estado:'Pendiente'},
    {fecha:'10/11/2025', pasarela:'Yape', descripcion:'Pago por delivery - Orden #12346', cliente:'Ana Torres Vega', comprobante:'B001-00237', monto:95.50, usuario:'clopez', estado:'Pendiente'},
  ]
  rowDataMovimientosMultiple = [
    {fecha:'10/11/2025', pasarela:'Yape', descripcion:'Pago por delivery - Orden #12345', cliente:'Juan Pérez García', comprobante:'B001-00234', monto:850.00, usuario:'clopez', estado:'Pendiente'},
    {fecha:'10/11/2025', pasarela:'Mercado Pago', descripcion:'Pago adelantado - Evento corporativo', cliente:'Transportes Norte SAC', comprobante:'F001-00095', monto:1450.00, usuario:'vlosano', estado:'Pendiente'},
    {fecha:'10/11/2025', pasarela:'Yape', descripcion:'Pago por consumo en local', cliente:'María López Sánchez', comprobante:'B001-00235', monto:140.00, usuario:'asanchez', estado:'Pendiente'},
    {fecha:'10/11/2025', pasarela:'Niubiz', descripcion:'Pago tarjeta de crédito - Mesa 15', cliente:'Carlos Ramírez Torres', comprobante:'B001-00236', monto:340.00, usuario:'vlosano', estado:'Pendiente'},
    {fecha:'10/11/2025', pasarela:'Mercado Pago', descripcion:'Pago por catering empresarial', cliente:'Grupo Inversiones ABC', comprobante:'F001-00096', monto:2450.00, usuario:'asanchez', estado:'Pendiente'},
    {fecha:'10/11/2025', pasarela:'Yape', descripcion:'Pago por delivery - Orden #12346', cliente:'Ana Torres Vega', comprobante:'B001-00237', monto:95.50, usuario:'clopez', estado:'Pendiente'},
  ]
  rowDataBancario = [
    {fecha:'10/11/2025', id:'TXN-2025-001', comprobante:'B001-00234', cliente:'Juan Pérez García', monto:850.00, comision:12.75, neto:837.25, estado:'Pendiente'},
    {fecha:'10/11/2025', id:'TXN-2025-002', comprobante:'F001-00095', cliente:'Transportes Norte SAC', monto:1450.00, comision:21.75, neto:1428.25, estado:'Pendiente'},
    {fecha:'10/11/2025', id:'TXN-2025-003', comprobante:'B001-00235', cliente:'María López Sánchez', monto:140.00, comision:2.10, neto:137.90, estado:'Pendiente'},
    {fecha:'10/11/2025', id:'TXN-2025-004', comprobante:'B001-00236', cliente:'Carlos Ramírez Torres', monto:340.00, comision:5.10, neto:334.90, estado:'Pendiente'},
    {fecha:'10/11/2025', id:'TXN-2025-005', comprobante:'F001-00096', cliente:'Grupo Inversiones ABC', monto:2450.00, comision:36.75, neto:2413.25, estado:'Pendiente'},
    {fecha:'10/11/2025', id:'TXN-2025-006', comprobante:'B001-00238', cliente:'Roberto Silva Campos', monto:175.00, comision:2.63, neto:172.37, estado:'Pendiente'},
    {fecha:'10/11/2025', id:'TXN-2025-007', comprobante:'B001-00239', cliente:'Patricia Mendoza Cruz', monto:425.50, comision:6.38, neto:419.12, estado:'Pendiente'},
    {fecha:'10/11/2025', id:'TXN-2025-008', comprobante:'F001-00097', cliente:'Eventos Corporativos SAC', monto:1800.00, comision:27.00, neto:1773.00, estado:'Pendiente'},
    {fecha:'10/11/2025', id:'TXN-2025-009', comprobante:'B001-00240', cliente:'Luis Gutiérrez Ramos', monto:220.00, comision:3.30, neto:216.70, estado:'Pendiente'},
  ]
  rowDataBancarioMultiple = [
    {fecha:'10/11/2025', id:'TXN-2025-001', comprobante:'B001-00234', cliente:'Juan Pérez García', monto:850.00, comision:12.75, neto:837.25, estado:'Pendiente'},
    {fecha:'10/11/2025', id:'TXN-2025-002', comprobante:'F001-00095', cliente:'Transportes Norte SAC', monto:1450.00, comision:21.75, neto:1428.25, estado:'Pendiente'},
    {fecha:'10/11/2025', id:'TXN-2025-003', comprobante:'B001-00235', cliente:'María López Sánchez', monto:140.00, comision:2.10, neto:137.90, estado:'Pendiente'},
    {fecha:'10/11/2025', id:'TXN-2025-004', comprobante:'B001-00236', cliente:'Carlos Ramírez Torres', monto:340.00, comision:5.10, neto:334.90, estado:'Pendiente'},
    {fecha:'10/11/2025', id:'TXN-2025-005', comprobante:'F001-00096', cliente:'Grupo Inversiones ABC', monto:2450.00, comision:36.75, neto:2413.25, estado:'Pendiente'},
    {fecha:'10/11/2025', id:'TXN-2025-006', comprobante:'B001-00238', cliente:'Roberto Silva Campos', monto:175.00, comision:2.63, neto:172.37, estado:'Pendiente'},
    {fecha:'10/11/2025', id:'TXN-2025-007', comprobante:'B001-00239', cliente:'Patricia Mendoza Cruz', monto:425.50, comision:6.38, neto:419.12, estado:'Pendiente'},
    {fecha:'10/11/2025', id:'TXN-2025-008', comprobante:'F001-00097', cliente:'Eventos Corporativos SAC', monto:1800.00, comision:27.00, neto:1773.00, estado:'Pendiente'},
    {fecha:'10/11/2025', id:'TXN-2025-009', comprobante:'B001-00240', cliente:'Luis Gutiérrez Ramos', monto:220.00, comision:3.30, neto:216.70, estado:'Pendiente'},
  ]
  columnTypes = {
    default: {
      resizable: false,
      sortable: false,
      filter: false,
      floatingFilter: false,
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
  constructor(private modalController: ModalController) { }

  ngOnInit() {}
  
  async abrirModalObservacion(data: any) {
    const modal = await this.modalController.create({
      component: ModalAdjuntarObservacionComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Adjuntar observación',
        observacionActual: data.observacion || '',
        placeholder: 'Escriba aquí su observación...'
      }
    });
    await modal.present();
    const { data: result, role } = await modal.onWillDismiss();
    if (role === 'aplicar' && result) {
      data.observacion = result.observacion;
      if (this.gridApiBancarioMultiple) {
        this.gridApiBancarioMultiple.refreshCells({ force: true });
      }
    }
  }

  onGridReadyBancarioMultiple(params: any) {
    this.gridApiBancarioMultiple = params.api;
  }
  
  dismissModal(){
    // Lógica para cerrar el modal
    this.modalController.dismiss();
  }

  async ajustecontable() {
    // Guardar los datos necesarios para reabrir el modal
    const datosModal = {
      existendiferencias: this.existendiferencias,
      cuentaData: this.cuentaData
    };

    // Cerrar el modal actual
    await this.modalController.dismiss(null, 'ajuste');

    // Abrir el modal de ajuste contable
    const modalAjuste = await this.modalController.create({
      component: ModalGenerarAjusteComponent,
      cssClass: 'promo',
      componentProps: {
        totalDebe: 'S/0.00',
        totalHaber: 'S/0.00',
        colDefsMovimientosAjustar: this.colDefsMovimientosAjustarModalPasarela,
        colDefsAsiento: this.colDefsAsientoModalPasarela,
        rowDataMovimientosAjustar: this.rowDataBancarioMultiple.filter((item: any) => item.estado === 'Pendiente'),
        tiposAjuste: this.tiposAjustePasarela,
        cuentasContables: this.cuentasContablesPasarela,
        labelTipoAjuste: 'Cuenta de gasto',
        labelCuentaDebito: 'Cuenta de crédito fiscal',
        labelCuentaCredito: 'Cuenta banco receptor',
        mostrarObservaciones: false
      }
    });

    await modalAjuste.present();
    
    const { data, role } = await modalAjuste.onWillDismiss();
    
    // Si se guardó el ajuste, volver a abrir el modal de detalle de cuenta
    if (role === 'aplicar' && data?.ajusteGenerado) {
      const modalDetalle = await this.modalController.create({
        component: ModalDetalleCuentaComponent,
        cssClass: 'promo2',
        componentProps: {
          cuentaData: datosModal.cuentaData,
          existendiferencias: datosModal.existendiferencias
        }
      });

      await modalDetalle.present();
    }
  }
}
