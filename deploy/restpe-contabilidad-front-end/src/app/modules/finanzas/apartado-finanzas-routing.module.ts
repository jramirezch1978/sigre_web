import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { FTGestionCatalogoComponent } from './m-f-tabla/components/f-t-gestion-catalogo/f-t-gestion-catalogo.component';
import { FTConceptoFinancieroComponent } from './m-f-tabla/components/f-t-concepto-financiero/f-t-concepto-financiero.component';
import { FCCrucePasarelaComponent } from './m-f-conciliaciones/f-c-cruce-pasarela/f-c-cruce-pasarela.component';
import { FCConciliacionesComponent } from './m-f-conciliaciones/f-c-conciliaciones/f-c-conciliaciones.component';
import { FCCruceExtractoComponent } from './m-f-conciliaciones/f-c-cruce-extracto/f-c-cruce-extracto.component';
import { FRCuentasPagarComponent } from './m-f-reportes/pages/f-r-cuentas-pagar/f-r-cuentas-pagar.component';
import { FRDocumentosClientesComponent } from './m-f-reportes/pages/f-r-documentos-clientes/f-r-documentos-clientes.component';
import { FRFinanzasComponent } from './m-f-reportes/pages/f-r-finanzas/f-r-finanzas.component';
import { FRObligacionesPorVencerComponent } from './m-f-reportes/pages/f-r-obligaciones-por-vencer/f-r-obligaciones-por-vencer.component';
import { FRTesoreriaComponent } from './m-f-reportes/pages/f-r-tesoreria/f-r-tesoreria.component';
import { CanDeactivateGuard } from 'src/app/auth/guards/can-deactivate.guard';
import { FinanzasConsultasConsultasCajaBancoComponent } from './m-f-consultas/f-c-consultas-caja-banco/finanzas-consultas-consultas-caja-banco.component';
import { FinanzasConsultasConsultasFlujoCajaComponent } from './m-f-consultas/f-c-consultas-flujo-caja/finanzas-consultas-consultas-flujo-caja.component';
import { FinanzasConsultasConsultasDocumentosComponent } from './m-f-consultas/f-c-consultas-documentos/finanzas-consultas-consultas-documentos.component';
import { FAOrdenesGiroComponent } from './m-f-adelantos/pages/f-a-ordenes-giro/f-a-ordenes-giro.component';
import { FAAprobarGiroComponent } from './m-f-adelantos/pages/f-a-aprobar-giro/f-a-aprobar-giro.component';
import { FTCarterasCobrosComponent } from './m-f-tesoreria/components/f-t-carteras-cobros/f-t-carteras-cobros.component';
import { FTPagosMasivosComponent } from './m-f-tesoreria/components/f-t-pagos-masivos/f-t-pagos-masivos.component';
import { FALiqRendicionComponent } from './m-f-adelantos/pages/f-a-liq-rendicion/f-a-liq-rendicion.component';
import { FAAprobarLiqGastosComponent } from './m-f-adelantos/pages/f-a-aprobar-liq-gastos/f-a-aprobar-liq-gastos.component';
import { FACerrarLiqAdelantosComponent } from './m-f-adelantos/pages/f-a-cerrar-liq-adelantos/f-a-cerrar-liq-adelantos.component';
import { FTAplicacionPagosComponent } from './m-f-tesoreria/components/f-t-aplicacion-pagos/f-t-aplicacion-pagos.component';
import { FOCanjeYReprogramacionComponent } from './m-f-operaciones/pages/f-o-canje-y-reprogramacion/f-o-canje-y-reprogramacion.component';
import { FOTransaccionesPeriodicasComponent } from './m-f-operaciones/pages/f-o-transacciones-periodicas/f-o-transacciones-periodicas.component';
import { FORelaciondocProveedorComponent } from './m-f-operaciones/pages/f-o-relaciondoc-proveedor/f-o-relaciondoc-proveedor.component';
import { FOPagosRecibidosComponent } from './m-f-operaciones/pages/f-o-pagos-recibidos/f-o-pagos-recibidos.component';
import { FOLetrasCammbioComponent } from './m-f-operaciones/pages/f-o-letras-cammbio/f-o-letras-cammbio.component';
import { FORegistroFacturasComponent } from './m-f-operaciones/pages/f-o-registro-facturas/f-o-registro-facturas.component';
import { FORelaciondocClienteComponent } from './m-f-operaciones/pages/f-o-relaciondoc-cliente/f-o-relaciondoc-cliente.component';
import { FTAnulacionOReversionPagosComponent } from './m-f-tesoreria/components/f-t-anulacion-o-reversion-pagos/f-t-anulacion-o-reversion-pagos.component';
import { FTMovCuentasBancYCajasComponent } from './m-f-tesoreria/components/f-t-mov-cuentas-banc-y-cajas/f-t-mov-cuentas-banc-y-cajas.component';
import { FTPagoDetraccionComponent } from './m-f-tesoreria/components/f-t-pago-detraccion/f-t-pago-detraccion.component';
import { FTProgramPagosPorRealizarPorVencComponent } from './m-f-tesoreria/components/f-t-program-pagos-por-realizar-por-venc/f-t-program-pagos-por-realizar-por-venc.component';
import { FTEjecucionPagoComponent } from './m-f-tesoreria/components/f-t-ejecucion-pago/f-t-ejecucion-pago.component';
import { AsignacionFondoFijoCajaComponent } from './m-f-tesoreria/components/asignacion-fondo-fijo-caja/asignacion-fondo-fijo-caja.component';
import { AsignacionCajaChicaComponent } from './m-f-tesoreria/components/asignacion-caja-chica/asignacion-caja-chica.component';
import { RegistroEgresoMenorComponent } from './m-f-tesoreria/components/registro-egreso-menor/registro-egreso-menor.component';
import { RegistroIngresoDeDiaComponent } from './m-f-tesoreria/components/registro-ingreso-de-dia/registro-ingreso-de-dia.component';
import { FTProyeccionIngresosEgresosComponent } from './m-f-tesoreria/components/f-t-proyeccion-ingresos-egresos/f-t-proyeccion-ingresos-egresos.component';
import { FTGestionGruposComponent } from './m-f-tabla/components/f-t-gestion-grupos/f-t-gestion-grupos.component';
import { FTTipoDocumentoComponent } from './m-f-tabla/components/f-t-tipo-documento/f-t-tipo-documento.component';
const routes: Routes = [
  {
    path: 'tesoreria/carteras-cobros',
    component: FTCarterasCobrosComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tesoreria/pagos-masivos',
    component: FTPagosMasivosComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tesoreria/cartera-pagos',
    component: FTAplicacionPagosComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tesoreria/anulacion-o-reversion-de-pagos',
    component: FTAnulacionOReversionPagosComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tesoreria/mov-cuentas-banc-y-cajas',
    component: FTMovCuentasBancYCajasComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tesoreria/ejecucion-pago',
    component: FTEjecucionPagoComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tesoreria/program-pagos-por-realizar-por-venc',
    component: FTProgramPagosPorRealizarPorVencComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tesoreria/pago-detraccion',
    component: FTPagoDetraccionComponent,
  },
  {
    path: 'tesoreria/asignacion-fondo-fijo-caja',
    component: AsignacionFondoFijoCajaComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tesoreria/asignacion-caja-chica',
    component: AsignacionCajaChicaComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tesoreria/proyeccion-ingresos-egresos',
    component: FTProyeccionIngresosEgresosComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tesoreria/registro-egreso-menor',
    component: RegistroEgresoMenorComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tesoreria/registro-ingreso-de-dia',
    component: RegistroIngresoDeDiaComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tabla/gestion-catalogo',
    component: FTGestionCatalogoComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tabla/conceptos-financieros',
    component: FTConceptoFinancieroComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'tabla/gestion-grupos',
    component: FTGestionGruposComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'consultas/consultas-saldos-caja-bancos',
    component: FinanzasConsultasConsultasCajaBancoComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'consultas/consultas-flujo-caja',
    component: FinanzasConsultasConsultasFlujoCajaComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'consultas/documento-finanzas',
    component: FinanzasConsultasConsultasDocumentosComponent,
    canDeactivate: [CanDeactivateGuard],
  },
  {
    path: 'conciliaciones/conciliaciones',
    component: FCConciliacionesComponent,
  },
  {
    path: 'conciliaciones/cruce-extracto',
    component: FCCruceExtractoComponent,
  },
  {
    path: 'conciliaciones/cruce-pasarela',
    component: FCCrucePasarelaComponent,
  },
  {
    path: 'reportes/cuentas-por-pagar',
    component: FRCuentasPagarComponent,
  },
  {
    path: 'reportes/documentos-clientes',
    component: FRDocumentosClientesComponent,
  },
  {
    path: 'reportes/finanzas',
    component: FRFinanzasComponent,
  },
  {
    path: 'reportes/obligaciones-por-vencer',
    component: FRObligacionesPorVencerComponent,
  },
  {
    path: 'reportes/tesoreria',
    component: FRTesoreriaComponent,
  },
  {
    path: 'adelantos/ordenes-giro',
    component: FAOrdenesGiroComponent,
  },
  {
    path: 'adelantos/aprobar-giro',
    component: FAAprobarGiroComponent,
  },
  {
    path: 'adelantos/rendicion-gastos',
    component: FALiqRendicionComponent,
  },
  {
    path: 'adelantos/aprobar-rendicion-gastos',
    component: FAAprobarLiqGastosComponent,
  },
  {
    path: 'adelantos/cerrar-liq-adelantos',
    component: FACerrarLiqAdelantosComponent,
  },
  {
    path: 'operaciones/canje-reprogramacion',
    component: FOCanjeYReprogramacionComponent,
  },
  {
    path: 'operaciones/transacciones-periodicas',
    component: FOTransaccionesPeriodicasComponent,
  },
  {
    path: 'operaciones/documentos-proveedor',
    component: FORelaciondocProveedorComponent,
  },
  {
    path: 'operaciones/pagos-recibidos',
    component: FOPagosRecibidosComponent,
  },
  {
    path: 'operaciones/letras-cambio',
    component: FOLetrasCammbioComponent,
  },
  {
    path: 'operaciones/registro-facturas',
    component: FORegistroFacturasComponent,
  },
  {
    path: 'operaciones/documentos-cliente',
    component: FORelaciondocClienteComponent,
  },
   {
    path: 'tabla/tipos-documento',
    component: FTTipoDocumentoComponent,
    canDeactivate: [CanDeactivateGuard],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ApartadoFinanzasRoutingModule {}
