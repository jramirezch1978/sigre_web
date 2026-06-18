import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { CanDeactivateGuard } from 'src/app/auth/guards/can-deactivate.guard';

import { AlmacenConsultasKardexComponent } from './modulos/modulo-almacen-consultas/components/almacen-consultas-kardex/almacen-consultas-kardex.component';
import { AlmacenConsultasCompraComponent } from './modulos/modulo-almacen-consultas/components/almacen-consultas-compra/almacen-consultas-compra.component';
import { AlmacenConsultasArticuloComponent } from './modulos/modulo-almacen-consultas/components/almacen-consultas-articulo/almacen-consultas-articulo.component';
import { AlmacenConsultasPrestamosComponent } from './modulos/modulo-almacen-consultas/components/almacen-consultas-prestamos/almacen-consultas-prestamos.component';
import { AlmacenConsultasDevolucionesComponent } from './modulos/modulo-almacen-consultas/components/almacen-consultas-devoluciones/almacen-consultas-devoluciones.component';
import { AlmacenReportesStockFechaComponent } from './modulos/modulo-almacen-reportes/components/almacen-reportes-stock-fecha/almacen-reportes-stock-fecha.component';
import { AlmacenReportesHistorialVencimientoComponent } from './modulos/modulo-almacen-reportes/components/almacen-reportes-historial-vencimiento/almacen-reportes-historial-vencimiento.component';
import { AlmacenReportesValorizacionComponent } from './modulos/modulo-almacen-reportes/components/almacen-reportes-valorizacion/almacen-reportes-valorizacion.component';
import { AlmacenReportesVendidosZonaComponent } from './modulos/modulo-almacen-reportes/components/almacen-reportes-vendidos-zona/almacen-reportes-vendidos-zona.component';
import { AlmacenReportesStockMinimoComponent } from './modulos/modulo-almacen-reportes/components/almacen-reportes-stock-minimo/almacen-reportes-stock-minimo.component';
import { AlmacenReportesDiagnosticoAlmacenesComponent } from './modulos/modulo-almacen-reportes/components/almacen-reportes-diagnostico-almacenes/almacen-reportes-diagnostico-almacenes.component';
import { AlmacenReportesTomasComponent } from './modulos/modulo-almacen-reportes/components/almacen-reportes-tomas/almacen-reportes-tomas.component';
import { AlmacenTablasAlmacenesComponent } from './modulos/modulo-almacen-tablas/pages/a-t-almacenes/almacen-tablas-almacenes.component';
import { AtMovAlmacenesComponent } from './modulos/modulo-almacen-tablas/pages/at-mov-almacenes/at-mov-almacenes.component';
import { AoAlmacenamientoComponent } from './modulos/modulo-almacen-operaciones/components/a-o-almacenamiento/a-o-almacenamiento.component';
import { AoDespachoComponent } from './modulos/modulo-almacen-operaciones/components/a-o-despacho/a-o-despacho.component';
import { AoRecepcionComponent } from './modulos/modulo-almacen-operaciones/components/a-o-recepcion/a-o-recepcion.component';
import { AoReqTrasladoComponent } from './modulos/modulo-almacen-operaciones/components/a-o-req-traslado/a-o-req-traslado.component';
import { AOGestionDevolucionesComponent } from './modulos/modulo-almacen-operaciones/components/a-o-gestion-devoluciones/a-o-gestion-devoluciones.component';
import { AOComparacionInventarioComponent } from './modulos/modulo-almacen-operaciones/components/a-o-comparacion-inventario/a-o-comparacion-inventario.component';
import { AOReposicionStockComponent } from './modulos/modulo-almacen-operaciones/components/a-o-reposicion-stock/a-o-reposicion-stock.component';
import { APRecalcularComponent } from './modulos/modulo-almacen-procesos/pages/a-p-recalcular/a-p-recalcular.component';
import { AORegistroPerdidasComponent } from './modulos/modulo-almacen-operaciones/components/a-o-registro-perdidas/a-o-registro-perdidas.component';
import { ATClasificacionArticulosComponent } from './modulos/modulo-almacen-tablas/pages/a-t-clasificacion-articulos/a-t-clasificacion-articulos.component';
import { ATMaestroProductosComponent } from './modulos/modulo-almacen-tablas/pages/a-t-maestro-productos/a-t-maestro-productos.component';
import { APActualizacionComponent } from './modulos/modulo-almacen-procesos/pages/a-p-actualizacion/a-p-actualizacion.component';
import { APCuadrestockComponent } from './modulos/modulo-almacen-procesos/pages/a-p-cuadrestock/a-p-cuadrestock.component';
import { ATMotivoTransladoComponent } from './modulos/modulo-almacen-tablas/pages/a-t-motivo-translado/a-t-motivo-translado.component';

const routes: Routes = [
  {
    path: '',
    redirectTo: 'consultas/kardex-movimientos',
    pathMatch: 'full'
  },
  
  {
    path: 'consultas/kardex-movimientos',
    component: AlmacenConsultasKardexComponent
  },
  {
    path: 'consultas/ordenes-compra',
    component: AlmacenConsultasCompraComponent
  },
  {
    path: 'consultas/consulta-articulos',
    component: AlmacenConsultasArticuloComponent
  },
  {
    path: 'consultas/prestamos',
    component: AlmacenConsultasPrestamosComponent
  },
  {
    path: 'consultas/devoluciones',
    component: AlmacenConsultasDevolucionesComponent
  },
  {
    path: 'consultas/stock-fecha',
    component: AlmacenReportesStockFechaComponent
  },
  {
    path: 'consultas/historial-movimiento',
    component: AlmacenReportesHistorialVencimientoComponent,
  },
  {
    path: 'consultas/valorizacion',
    component: AlmacenReportesValorizacionComponent,
  },
  {
    path: 'consultas/productos-vendidos-por-periodo',
    component: AlmacenReportesVendidosZonaComponent,
  },
  {
    path: 'consultas/stock-minimo',
    component: AlmacenReportesStockMinimoComponent,
  },
  {
    path: 'consultas/diagnostico-almacenes',
    component: AlmacenReportesDiagnosticoAlmacenesComponent,
  },
  {
    path: 'consultas/reporte-tomas-inventario',
    component: AlmacenReportesTomasComponent,
  },
  {
    path: 'tablas/tablas-almacenes',
    component: AlmacenTablasAlmacenesComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tablas/almacenes-movimiento',
    component: AtMovAlmacenesComponent,
  },
  {
    path: 'tablas/clasificacion-articulos',
    component: ATClasificacionArticulosComponent,
  },
  {
    path: 'tablas/maestro-productos',
    component: ATMaestroProductosComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'operaciones/almacenamiento',
    component: AoAlmacenamientoComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'operaciones/despacho',
    component: AoDespachoComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'operaciones/recepcion',
    component: AoRecepcionComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'operaciones/req-traslado',
    component: AoReqTrasladoComponent,
    canDeactivate: [CanDeactivateGuard]
  },
  {
    path: 'operaciones/devoluciones',
    component: AOGestionDevolucionesComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'operaciones/reposicion-stock',
    component: AOReposicionStockComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'operaciones/comparacion-inventario',
    component: AOComparacionInventarioComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'operaciones/registro-perdidas',
    component: AORegistroPerdidasComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'procesos/recalcular',
    component: APRecalcularComponent,
  },
  {
    path: 'procesos/cuadre-stock',
    component: APCuadrestockComponent,
  },
  {
    path: 'procesos/actualizacion',
    component: APActualizacionComponent,
  },
  {
    path:"tablas/motivo-traslado",
    component: ATMotivoTransladoComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ApartadoAlmacenRoutingModule {}
