import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { AgGridSharedModule } from 'src/app/shared/ag-grid-shared.module';
import { UiModule } from 'src/app/ui/ui.module';
import { ApartadoAlmacenRoutingModule } from './apartado-almacen-routing.module';
import { AlmacenReportesStockFechaComponent } from './modulos/modulo-almacen-reportes/components/almacen-reportes-stock-fecha/almacen-reportes-stock-fecha.component';
import { AlmacenReportesDiagnosticoAlmacenesComponent } from './modulos/modulo-almacen-reportes/components/almacen-reportes-diagnostico-almacenes/almacen-reportes-diagnostico-almacenes.component';
import { AlmacenReportesHistorialVencimientoComponent } from './modulos/modulo-almacen-reportes/components/almacen-reportes-historial-vencimiento/almacen-reportes-historial-vencimiento.component';
import { AlmacenReportesStockMinimoComponent } from './modulos/modulo-almacen-reportes/components/almacen-reportes-stock-minimo/almacen-reportes-stock-minimo.component';
import { AlmacenReportesValorizacionComponent } from './modulos/modulo-almacen-reportes/components/almacen-reportes-valorizacion/almacen-reportes-valorizacion.component';
import { AlmacenReportesVendidosZonaComponent } from './modulos/modulo-almacen-reportes/components/almacen-reportes-vendidos-zona/almacen-reportes-vendidos-zona.component';
import { AlmacenReportesTomasComponent } from './modulos/modulo-almacen-reportes/components/almacen-reportes-tomas/almacen-reportes-tomas.component';
import { AlmacenConsultasArticuloComponent } from './modulos/modulo-almacen-consultas/components/almacen-consultas-articulo/almacen-consultas-articulo.component';
import { AlmacenConsultasCompraComponent } from './modulos/modulo-almacen-consultas/components/almacen-consultas-compra/almacen-consultas-compra.component';
import { AlmacenConsultasDevolucionesComponent } from './modulos/modulo-almacen-consultas/components/almacen-consultas-devoluciones/almacen-consultas-devoluciones.component';
import { AlmacenConsultasKardexComponent } from './modulos/modulo-almacen-consultas/components/almacen-consultas-kardex/almacen-consultas-kardex.component';
import { AlmacenConsultasPrestamosComponent } from './modulos/modulo-almacen-consultas/components/almacen-consultas-prestamos/almacen-consultas-prestamos.component';
import { AlmacenTablasAlmacenesComponent } from './modulos/modulo-almacen-tablas/pages/a-t-almacenes/almacen-tablas-almacenes.component';
import { AtMovAlmacenesComponent } from './modulos/modulo-almacen-tablas/pages/at-mov-almacenes/at-mov-almacenes.component';
import { AoAlmacenamientoComponent } from './modulos/modulo-almacen-operaciones/components/a-o-almacenamiento/a-o-almacenamiento.component';
import { AoDespachoComponent } from './modulos/modulo-almacen-operaciones/components/a-o-despacho/a-o-despacho.component';
import { AoRecepcionComponent } from './modulos/modulo-almacen-operaciones/components/a-o-recepcion/a-o-recepcion.component';
import { AoReqTrasladoComponent } from './modulos/modulo-almacen-operaciones/components/a-o-req-traslado/a-o-req-traslado.component';
import { AOGestionDevolucionesComponent } from './modulos/modulo-almacen-operaciones/components/a-o-gestion-devoluciones/a-o-gestion-devoluciones.component';
import { AOReposicionStockComponent } from './modulos/modulo-almacen-operaciones/components/a-o-reposicion-stock/a-o-reposicion-stock.component';
import { AOComparacionInventarioComponent } from './modulos/modulo-almacen-operaciones/components/a-o-comparacion-inventario/a-o-comparacion-inventario.component';
import { APRecalcularComponent } from './modulos/modulo-almacen-procesos/pages/a-p-recalcular/a-p-recalcular.component';
import { APActualizacionComponent } from './modulos/modulo-almacen-procesos/pages/a-p-actualizacion/a-p-actualizacion.component';
import { AORegistroPerdidasComponent } from './modulos/modulo-almacen-operaciones/components/a-o-registro-perdidas/a-o-registro-perdidas.component';
import { ATClasificacionArticulosComponent } from './modulos/modulo-almacen-tablas/pages/a-t-clasificacion-articulos/a-t-clasificacion-articulos.component';
import { ATMaestroProductosComponent } from './modulos/modulo-almacen-tablas/pages/a-t-maestro-productos/a-t-maestro-productos.component';
import { ModalRecalcularComponent } from './modulos/modulo-almacen-procesos/pages/a-p-cuadrestock/modals/modal-recalcular/modal-recalcular.component';
import { ALMACEN_PROVIDERS } from './infrastructure/providers/almacen.providers';
import { APCuadrestockComponent } from './modulos/modulo-almacen-procesos/pages/a-p-cuadrestock/a-p-cuadrestock.component';
import { ATMotivoTransladoComponent } from './modulos/modulo-almacen-tablas/pages/a-t-motivo-translado/a-t-motivo-translado.component';


@NgModule({
  imports: [
    CommonModule,
    IonicModule,
    FormsModule,
    ReactiveFormsModule,
    ApartadoAlmacenRoutingModule,
    FontAwesomeModule,
    UiModule,
    AgGridSharedModule,
  ],
  declarations: [
    AlmacenReportesStockFechaComponent,
    AlmacenReportesDiagnosticoAlmacenesComponent,
    AlmacenReportesHistorialVencimientoComponent,
    AlmacenReportesStockMinimoComponent,
    AlmacenReportesValorizacionComponent,
    AlmacenReportesVendidosZonaComponent,
    AlmacenReportesTomasComponent,
    AlmacenConsultasArticuloComponent,
    AlmacenConsultasCompraComponent,
    AlmacenConsultasDevolucionesComponent,
    AlmacenConsultasKardexComponent,
    AlmacenConsultasPrestamosComponent,
    AlmacenTablasAlmacenesComponent,
    AtMovAlmacenesComponent,
    AoAlmacenamientoComponent,
    AoDespachoComponent,
    AoRecepcionComponent,
    AoReqTrasladoComponent,
    AOGestionDevolucionesComponent,
    AORegistroPerdidasComponent,
    AOReposicionStockComponent,
    AOComparacionInventarioComponent,
    APRecalcularComponent,
    APActualizacionComponent,
    APCuadrestockComponent,
    ATClasificacionArticulosComponent,
    ATMaestroProductosComponent,
    ModalRecalcularComponent,
    ATMotivoTransladoComponent
    
    // Aquí irán los componentes de los módulos
  ],
  providers: [
    ...ALMACEN_PROVIDERS
  ]
})
export class ApartadoAlmacenModule { }
