import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { ApartadoComprasRoutingModule } from './apartado-compras-routing.module';
import { ALMACEN_PROVIDERS } from '../almacen/infrastructure/providers/almacen.providers';
import { ComprasTablasCondicionesDePagoComponent } from './modulos/modulo-compras-tablas/components/compras-tablas-condiciones-de-pago/compras-tablas-condiciones-de-pago.component';
import { ComprasTablasGestionProveedoresComponent } from './modulos/modulo-compras-tablas/components/compras-tablas-gestion-proveedores/compras-tablas-gestion-proveedores.component';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { AgGridSharedModule } from 'src/app/shared/ag-grid-shared.module';
import { ModalsAgregarCuentaComponent } from './modulos/modulo-compras-tablas/components/modals/modals-agregar-cuenta/modals-agregar-cuenta.component';
import { ComprasOperacionesAprovisionamientoComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-aprovisionamiento/compras-operaciones-aprovisionamiento.component';
import { ComprasOperacionesFacturaNoComprasComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-factura-no-compras/compras-operaciones-factura-no-compras.component';
import { ComprasOperacionesFacturasProveedoresComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-facturas-proveedores/compras-operaciones-facturas-proveedores.component';
import { ComprasOperacionesNotasCreditoComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-notas-credito/compras-operaciones-notas-credito.component';
import { ComprasOperacionesOrdenesDeCompraComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-ordenes-de-compra/compras-operaciones-ordenes-de-compra.component';
import { ComprasOperacionesOrdenesDeServicioComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-ordenes-de-servicio/compras-operaciones-ordenes-de-servicio.component';
import { ComprasReportesAnalisisProveedoresComponent } from './modulos/modulo-compras-reportes/components/compras-reportes-analisis-proveedores/compras-reportes-analisis-proveedores.component';
import { ComprasReportesComprasCategoriaComponent } from './modulos/modulo-compras-reportes/components/compras-reportes-compras-categoria/compras-reportes-compras-categoria.component';
import { ComprasReportesComprasIngresarComponent } from './modulos/modulo-compras-reportes/components/compras-reportes-compras-ingresar/compras-reportes-compras-ingresar.component';
import { ComprasReportesComprasSugeridasComponent } from './modulos/modulo-compras-reportes/components/compras-reportes-compras-sugeridas/compras-reportes-compras-sugeridas.component';
import { ComprasReportesComprasTransitoComponent } from './modulos/modulo-compras-reportes/components/compras-reportes-compras-transito/compras-reportes-compras-transito.component';
import { ComprasReportesReporteDeComprasComponent } from './modulos/modulo-compras-reportes/components/compras-reportes-reporte-de-compras/compras-reportes-reporte-de-compras.component';
import { ComprasReportesGestionComprasComponent } from './modulos/modulo-compras-reportes/components/compras-reportes-gestion-compras/compras-reportes-gestion-compras.component';
import { ModalRechazComponent } from './modals/modal-rechaz/modal-rechaz.component';
import { ModalAprobarComponent } from './modals/modal-aprobar/modal-aprobar.component';
import { UiModule } from 'src/app/ui/ui.module';
import { ModalNuevaCondicionComponent } from './modulos/modulo-compras-tablas/components/modals/modal-nueva-condicion/modal-nueva-condicion.component';
import { ComprasAprobarCompraComponent } from './modulos/modulo-compras-operaciones/components/compras-aprobar-compra/compras-aprobar-compra.component';
import { ComprasAprobarServicioComponent } from './modulos/modulo-compras-operaciones/components/compras-aprobar-servicio/compras-aprobar-servicio.component';
import { StockWarningCellComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-aprovisionamiento/cell-renderers/stock-warning-cell/stock-warning-cell.component';
import { CantidadInfoCellComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-aprovisionamiento/cell-renderers/cantidad-info-cell/cantidad-info-cell.component';
import { ComprasOperacionesDocumentosDirectosComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-documentos-directos/compras-operaciones-documentos-directos.component';
import { ComprasOperacionesActaConformidadComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-acta-conformidad/compras-operaciones-acta-conformidad.component';
import { PROVEEDOR_PROVIDERS } from './infrastructure/providers/proveedor.providers';
import { ComprasCotizacionesRegistrarComponent } from './modulos/modulo-compras-cotizaciones/components/compras-cotizaciones-registrar/compras-cotizaciones-registrar.component';

@NgModule({
  imports: [
    CommonModule,
    IonicModule,
    FormsModule,
    ReactiveFormsModule,
    ApartadoComprasRoutingModule,
    FontAwesomeModule,
    UiModule,
    AgGridSharedModule,

  ],
  providers: [
    ...PROVEEDOR_PROVIDERS,
    ...ALMACEN_PROVIDERS
  ],
  declarations: [
    ComprasTablasCondicionesDePagoComponent,
    ComprasTablasGestionProveedoresComponent,
    ComprasOperacionesFacturaNoComprasComponent,
    ComprasOperacionesFacturasProveedoresComponent,
    ComprasOperacionesNotasCreditoComponent,
    ComprasOperacionesOrdenesDeCompraComponent,
    ComprasOperacionesAprovisionamientoComponent,
    ComprasOperacionesOrdenesDeServicioComponent,
    ComprasReportesGestionComprasComponent,
    ComprasReportesReporteDeComprasComponent,
    ComprasReportesComprasTransitoComponent,
    ComprasReportesComprasSugeridasComponent,
    ComprasReportesComprasIngresarComponent,
    ComprasReportesComprasCategoriaComponent,
    ComprasReportesAnalisisProveedoresComponent,
    ComprasAprobarServicioComponent,
    ComprasAprobarCompraComponent,
    ComprasOperacionesDocumentosDirectosComponent,
    ComprasOperacionesActaConformidadComponent,
    ModalsAgregarCuentaComponent,
    ModalRechazComponent,
    ModalAprobarComponent,
    ModalNuevaCondicionComponent,
    StockWarningCellComponent,
    CantidadInfoCellComponent,
    ComprasCotizacionesRegistrarComponent
]
})
export class ApartadoComprasModule { }
