import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ApartadoFinanzasRoutingModule } from './apartado-finanzas-routing.module';
import { FTGestionCatalogoComponent } from './m-f-tabla/components/f-t-gestion-catalogo/f-t-gestion-catalogo.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { AgGridSharedModule } from 'src/app/shared/ag-grid-shared.module';
import { UiModule } from 'src/app/ui/ui.module';
import { EyeCellAsientoComponent } from '../contabilidad/m-c-operaciones/components/saldos-cuentas-corriente/eye-cell-asiento/eye-cell-asiento.component';
import { FTConceptoFinancieroComponent } from './m-f-tabla/components/f-t-concepto-financiero/f-t-concepto-financiero.component';
import { FTGestionGruposComponent } from './m-f-tabla/components/f-t-gestion-grupos/f-t-gestion-grupos.component';
import { FCConciliacionesComponent } from './m-f-conciliaciones/f-c-conciliaciones/f-c-conciliaciones.component';
import { FCCruceExtractoComponent } from './m-f-conciliaciones/f-c-cruce-extracto/f-c-cruce-extracto.component';
import { FCCrucePasarelaComponent } from './m-f-conciliaciones/f-c-cruce-pasarela/f-c-cruce-pasarela.component';
import { FRCuentasPagarComponent } from './m-f-reportes/pages/f-r-cuentas-pagar/f-r-cuentas-pagar.component';
import { FRDocumentosClientesComponent } from './m-f-reportes/pages/f-r-documentos-clientes/f-r-documentos-clientes.component';
import { FRFinanzasComponent } from './m-f-reportes/pages/f-r-finanzas/f-r-finanzas.component';
import { FRObligacionesPorVencerComponent } from './m-f-reportes/pages/f-r-obligaciones-por-vencer/f-r-obligaciones-por-vencer.component';
import { FRTesoreriaComponent } from './m-f-reportes/pages/f-r-tesoreria/f-r-tesoreria.component';
import { FinanzasConsultasConsultasCajaBancoComponent } from './m-f-consultas/f-c-consultas-caja-banco/finanzas-consultas-consultas-caja-banco.component';
import { FinanzasConsultasConsultasFlujoCajaComponent } from './m-f-consultas/f-c-consultas-flujo-caja/finanzas-consultas-consultas-flujo-caja.component';
import { FinanzasConsultasConsultasDocumentosComponent } from './m-f-consultas/f-c-consultas-documentos/finanzas-consultas-consultas-documentos.component';
import { FAOrdenesGiroComponent } from './m-f-adelantos/pages/f-a-ordenes-giro/f-a-ordenes-giro.component';
import { FTCarterasCobrosComponent } from './m-f-tesoreria/components/f-t-carteras-cobros/f-t-carteras-cobros.component';
import { FTPagosMasivosComponent } from './m-f-tesoreria/components/f-t-pagos-masivos/f-t-pagos-masivos.component';
import { ModalDetalleConsultasCajabancoComponent } from './m-f-consultas/f-c-consultas-caja-banco/modal-detalle-consultas-cajabanco/modal-detalle-consultas-cajabanco.component';
import { FAAprobarGiroComponent } from './m-f-adelantos/pages/f-a-aprobar-giro/f-a-aprobar-giro.component';
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
import { DiferenciaCellRendererComponent } from './m-f-conciliaciones/f-c-conciliaciones/cell-renderers/diferencia-cell-renderer/diferencia-cell-renderer.component';
import { ModalDetalleDocComponent } from './m-f-operaciones/modals/modal-detalle-doc/modal-detalle-doc.component';
import { ModalAplicarCanjeComponent } from './m-f-operaciones/modals/modal-aplicar-canje/modal-aplicar-canje.component';
import { ModalReprogramarComponent } from './m-f-operaciones/modals/modal-reprogramar/modal-reprogramar.component';
import { FTPagoDetraccionComponent } from './m-f-tesoreria/components/f-t-pago-detraccion/f-t-pago-detraccion.component';
import { FTProgramPagosPorRealizarPorVencComponent } from './m-f-tesoreria/components/f-t-program-pagos-por-realizar-por-venc/f-t-program-pagos-por-realizar-por-venc.component';
import { FTEjecucionPagoComponent } from './m-f-tesoreria/components/f-t-ejecucion-pago/f-t-ejecucion-pago.component';
import { AsignacionFondoFijoCajaComponent } from './m-f-tesoreria/components/asignacion-fondo-fijo-caja/asignacion-fondo-fijo-caja.component';
import { AsignacionCajaChicaComponent } from './m-f-tesoreria/components/asignacion-caja-chica/asignacion-caja-chica.component';
import { RegistroEgresoMenorComponent } from './m-f-tesoreria/components/registro-egreso-menor/registro-egreso-menor.component';
import { RegistroIngresoDeDiaComponent } from './m-f-tesoreria/components/registro-ingreso-de-dia/registro-ingreso-de-dia.component';
import { ModalDetalleDocEditComponent } from './m-f-operaciones/modals/modal-detalle-doc-edit/modal-detalle-doc-edit.component';
import { FTProyeccionIngresosEgresosComponent } from './m-f-tesoreria/components/f-t-proyeccion-ingresos-egresos/f-t-proyeccion-ingresos-egresos.component';
import { DetailCellRendererComponent } from './m-f-tesoreria/components/f-t-proyeccion-ingresos-egresos/detail-cell-renderer/detail-cell-renderer.component';
import { ModalAjusteProyeccionComponent } from './m-f-tesoreria/components/f-t-proyeccion-ingresos-egresos/modal-ajuste-proyeccion/modal-ajuste-proyeccion.component';
import { ModalDetalleDocumentosComponent } from './m-f-tesoreria/components/f-t-proyeccion-ingresos-egresos/modal-detalle-documentos/modal-detalle-documentos.component';
import { ModalPagarComponent } from './m-f-operaciones/modals/modal-pagar/modal-pagar.component';
import { ModalAgregarMedioDePagoComponent } from './m-f-operaciones/modals/modal-agregar-medio-de-pago/modal-agregar-medio-de-pago.component';
import { ModalFiltrosComponent } from 'src/app/ui/modal-filtros/modal-filtros.component';
import { FTMovCuentasBancYCajasComponent } from './m-f-tesoreria/components/f-t-mov-cuentas-banc-y-cajas/f-t-mov-cuentas-banc-y-cajas.component';
import { FINANZAS_PROVIDERS } from './infrastructure/providers/finanzas.providers';
import { FTTipoDocumentoComponent } from './m-f-tabla/components/f-t-tipo-documento/f-t-tipo-documento.component';
import { ModuleRegistry, QuickFilterModule } from 'ag-grid-enterprise';

//Activar el módulo de Quick Filter(input Busquedas) de AG-Grid Enterprise
ModuleRegistry.registerModules([QuickFilterModule]);

@NgModule({
  imports: [
    CommonModule,
    ApartadoFinanzasRoutingModule,
    FormsModule,
    IonicModule,
    ReactiveFormsModule,
    FontAwesomeModule,
    AgGridSharedModule,
    UiModule,
    EyeCellAsientoComponent,
    DetailCellRendererComponent,
  ],
  declarations: [
    FTGestionCatalogoComponent,
    FTGestionGruposComponent,
    FTConceptoFinancieroComponent,
    FCConciliacionesComponent,
    FCCruceExtractoComponent,
    FCCrucePasarelaComponent,
    FRCuentasPagarComponent,
    FRDocumentosClientesComponent,
    FRFinanzasComponent,
    FRObligacionesPorVencerComponent,
    FRTesoreriaComponent,
    FinanzasConsultasConsultasCajaBancoComponent,
    FinanzasConsultasConsultasFlujoCajaComponent,
    FinanzasConsultasConsultasDocumentosComponent,
    ModalDetalleConsultasCajabancoComponent,
    FAOrdenesGiroComponent,
    FTCarterasCobrosComponent,
    FTPagosMasivosComponent,
    FAAprobarGiroComponent,
    FTAplicacionPagosComponent,
    FTPagoDetraccionComponent,
    FALiqRendicionComponent,
    FAAprobarLiqGastosComponent,
    FACerrarLiqAdelantosComponent,
    FOCanjeYReprogramacionComponent,
    FOTransaccionesPeriodicasComponent,
    FORelaciondocProveedorComponent,
    FOPagosRecibidosComponent,
    FOLetrasCammbioComponent,
    FORegistroFacturasComponent,
    FORelaciondocClienteComponent,
    FTAnulacionOReversionPagosComponent,
    DiferenciaCellRendererComponent,
    ModalDetalleDocComponent,
    ModalDetalleDocEditComponent,
    ModalAplicarCanjeComponent,
    ModalReprogramarComponent,
    FTProgramPagosPorRealizarPorVencComponent,
    FTEjecucionPagoComponent,
    AsignacionFondoFijoCajaComponent,
    AsignacionCajaChicaComponent,
    RegistroEgresoMenorComponent,
    RegistroIngresoDeDiaComponent,
    FTProyeccionIngresosEgresosComponent,
    ModalAjusteProyeccionComponent,
    ModalDetalleDocumentosComponent,
    ModalPagarComponent,
    ModalAgregarMedioDePagoComponent,
    ModalFiltrosComponent,
    FTMovCuentasBancYCajasComponent,
    FTTipoDocumentoComponent,
  ],
  providers: [...FINANZAS_PROVIDERS],
})
export class ApartadoFinanzasModule {}
