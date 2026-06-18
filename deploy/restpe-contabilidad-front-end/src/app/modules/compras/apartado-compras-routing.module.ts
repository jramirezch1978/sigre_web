import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ComprasTablasGestionProveedoresComponent } from './modulos/modulo-compras-tablas/components/compras-tablas-gestion-proveedores/compras-tablas-gestion-proveedores.component';
import { ComprasTablasCondicionesDePagoComponent } from './modulos/modulo-compras-tablas/components/compras-tablas-condiciones-de-pago/compras-tablas-condiciones-de-pago.component';
import { ComprasOperacionesOrdenesDeCompraComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-ordenes-de-compra/compras-operaciones-ordenes-de-compra.component';
import { ComprasOperacionesOrdenesDeServicioComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-ordenes-de-servicio/compras-operaciones-ordenes-de-servicio.component';
import { ComprasOperacionesAprovisionamientoComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-aprovisionamiento/compras-operaciones-aprovisionamiento.component';
import { ComprasOperacionesNotasCreditoComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-notas-credito/compras-operaciones-notas-credito.component';
import { ComprasOperacionesFacturaNoComprasComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-factura-no-compras/compras-operaciones-factura-no-compras.component';
import { ComprasReportesGestionComprasComponent } from './modulos/modulo-compras-reportes/components/compras-reportes-gestion-compras/compras-reportes-gestion-compras.component';
import { ComprasReportesComprasSugeridasComponent } from './modulos/modulo-compras-reportes/components/compras-reportes-compras-sugeridas/compras-reportes-compras-sugeridas.component';
import { ComprasReportesComprasCategoriaComponent } from './modulos/modulo-compras-reportes/components/compras-reportes-compras-categoria/compras-reportes-compras-categoria.component';
import { ComprasReportesAnalisisProveedoresComponent } from './modulos/modulo-compras-reportes/components/compras-reportes-analisis-proveedores/compras-reportes-analisis-proveedores.component';
import { ComprasReportesComprasIngresarComponent } from './modulos/modulo-compras-reportes/components/compras-reportes-compras-ingresar/compras-reportes-compras-ingresar.component';
import { ComprasReportesComprasTransitoComponent } from './modulos/modulo-compras-reportes/components/compras-reportes-compras-transito/compras-reportes-compras-transito.component';
import { ComprasReportesReporteDeComprasComponent } from './modulos/modulo-compras-reportes/components/compras-reportes-reporte-de-compras/compras-reportes-reporte-de-compras.component';
import { ComprasOperacionesFacturasProveedoresComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-facturas-proveedores/compras-operaciones-facturas-proveedores.component';
import { ComprasAprobarCompraComponent } from './modulos/modulo-compras-operaciones/components/compras-aprobar-compra/compras-aprobar-compra.component';
import { ComprasAprobarServicioComponent } from './modulos/modulo-compras-operaciones/components/compras-aprobar-servicio/compras-aprobar-servicio.component';
import { ComprasCotizacionesRegistrarComponent } from './modulos/modulo-compras-cotizaciones/components/compras-cotizaciones-registrar/compras-cotizaciones-registrar.component';
import { ComprasOperacionesDocumentosDirectosComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-documentos-directos/compras-operaciones-documentos-directos.component';
import { ComprasOperacionesActaConformidadComponent } from './modulos/modulo-compras-operaciones/components/compras-operaciones-acta-conformidad/compras-operaciones-acta-conformidad.component';

const routes: Routes = [
  {
    path: '',
    redirectTo: 'tabla/gestion-proveedores',
    pathMatch: 'full'
  },
  {
    path: 'tabla/gestion-proveedores',
    component: ComprasTablasGestionProveedoresComponent
  },
  {
    path: 'tabla/gestion-clientes',
    component: ComprasTablasGestionProveedoresComponent,
    data: { modo: 'cliente' },
  },
  {
    path: 'tabla/condiciones-pago',
    component: ComprasTablasCondicionesDePagoComponent,
  },
  {
    path: 'operaciones/ordenes-compra',
    component: ComprasOperacionesOrdenesDeCompraComponent,
  },
  {
    path: 'operaciones/ordenes-servicio',
    component: ComprasOperacionesOrdenesDeServicioComponent,
  },
  {
    path: 'operaciones/aprovisionamiento',
    component: ComprasOperacionesAprovisionamientoComponent,
  },
  {
    path: 'operaciones/facturas-proveedores',
    component: ComprasOperacionesFacturasProveedoresComponent,
  },
  {
    path: 'operaciones/notas-credito-debito',
    component: ComprasOperacionesNotasCreditoComponent,
  },
  {
    path: 'operaciones/no-compras',
    component: ComprasOperacionesFacturaNoComprasComponent,
  },
  {
    path: 'operaciones/documentos-directos',
    component: ComprasOperacionesDocumentosDirectosComponent,
  },
  {
    path: 'operaciones/acta-conformidad',
    component: ComprasOperacionesActaConformidadComponent,
  },
  {
    path: 'reportes/gestion-compras',
    component: ComprasReportesGestionComprasComponent,
  },
  {
    path: 'reportes/compras-sugeridas',
    component: ComprasReportesComprasSugeridasComponent,
  },
  {
    path: 'reportes/compras-categoria',
    component: ComprasReportesComprasCategoriaComponent,
  },
  {
    path: 'reportes/analisis-proveedores',
    component: ComprasReportesAnalisisProveedoresComponent,
  },
  {
    path: 'reportes/compras-por-ingresar',
    component: ComprasReportesComprasIngresarComponent,
  },
  {
    path: 'reportes/compras-transito',
    component: ComprasReportesComprasTransitoComponent,
  },
  {
    path: 'reportes/reporte-de-compras',
    component: ComprasReportesReporteDeComprasComponent,
  },
  {
    path: 'operaciones/aprobar-compra',
    component: ComprasAprobarCompraComponent,
  },
  {
    path: 'operaciones/aprobar-servicio',
    component: ComprasAprobarServicioComponent,
  },
  {
    path: 'cotizaciones/registrar',
    component: ComprasCotizacionesRegistrarComponent,
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ApartadoComprasRoutingModule { }
