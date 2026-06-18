import { Provider } from '@angular/core';

// ── Concepto Financiero ──────────────────────────────────────────────────────
import { IConceptoFinancieroRepository } from '../../domain/repositories/iconcepto-financiero.repository';
import { ConceptoFinancieroRepositoryImpl } from '../repository/concepto-financiero.repository.impl';
import { ConceptoFinancieroStore } from '../../store/concepto-financiero.store';
import { ConceptoFinancieroFacade } from '../../application/facades/concepto-financiero.facade';
import { ObtenerConceptoFinancieroUseCase } from '../../application/usecases/obtener-concepto-financiero.usecase';
import { GuardarConceptoFinancieroUseCase } from '../../application/usecases/guardar-concepto-financiero.usecase';
import { ActualizarConceptoFinancieroUseCase } from '../../application/usecases/actualizar-concepto-financiero.usecase';
import { EliminarConceptoFinancieroUseCase } from '../../application/usecases/eliminar-concepto-financiero.usecase';
import { ConceptoFinancieroFeedbackEffects } from '../../effects/concepto-financiero-feedback.effect';
import { ConceptoFinancieroSyncEffects } from '../../effects/concepto-financiero-sync.effect';

// ── Gestión Catálogo ─────────────────────────────────────────────────────────
import { IGestionCatalogoRepository } from '../../domain/repositories/igestion-catalogo.repository';
import { GestionCatalogoRepositoryImpl } from '../repository/gestion-catalogo.repository.impl';
import { GestionCatalogoStore } from '../../store/gestion-catalogo.store';
import { GestionCatalogoFacade } from '../../application/facades/gestion-catalogo.facade';
import { ObtenerGestionCatalogoUseCase } from '../../application/usecases/obtener-gestion-catalogo.usecase';
import { GuardarGestionCatalogoUseCase } from '../../application/usecases/guardar-gestion-catalogo.usecase';
import { ActualizarGestionCatalogoUseCase } from '../../application/usecases/actualizar-gestion-catalogo.usecase';
import { EliminarGestionCatalogoUseCase } from '../../application/usecases/eliminar-gestion-catalogo.usecase';
import { GestionCatalogoFeedbackEffects } from '../../effects/gestion-catalogo-feedback.effect';
import { GestionCatalogoSyncEffects } from '../../effects/gestion-catalogo-sync.effect';

// ── Gestión Grupo ──────────────────────────────────────────────────────────
import { IGestionGrupoRepository } from '../../domain/repositories/igestion-grupo.repository';
import { GestionGrupoRepositoryImpl } from '../repository/gestion-grupo.repository.impl';
import { GestionGrupoStore } from '../../store/gestion-grupo.store';
import { GestionGrupoFacade } from '../../application/facades/gestion-grupo.facade';
import { ObtenerGestionGrupoUseCase } from '../../application/usecases/obtener-gestion-grupo.usecase';
import { GuardarGestionGrupoUseCase } from '../../application/usecases/guardar-gestion-grupo.usecase';
import { ActualizarGestionGrupoUseCase } from '../../application/usecases/actualizar-gestion-grupo.usecase';
import { GestionGrupoFeedbackEffects } from '../../effects/gestion-grupo-feedback.effect';
import { GestionGrupoSyncEffects } from '../../effects/gestion-grupo-sync.effect';

// ── Canje y Reprogramación ───────────────────────────────────────────────────
import { ICanjeReprogramacionRepository } from '../../domain/repositories/icanje-reprogramacion.repository';
import { CanjeReprogramacionRepositoryImpl } from '../repository/canje-reprogramacion.repository.impl';
import { CanjeReprogramacionStore } from '../../store/canje-reprogramacion.store';
import { CanjeReprogramacionFacade } from '../../application/facades/canje-reprogramacion.facade';
import { ObtenerCanjeReprogramacionUseCase } from '../../application/usecases/obtener-canje-reprogramacion.usecase';
import { AplicarCanjeUseCase } from '../../application/usecases/aplicar-canje.usecase';
import { ReprogramarVencimientoUseCase } from '../../application/usecases/reprogramar-vencimiento.usecase';
import { CanjeReprogramacionFeedbackEffects } from '../../effects/canje-reprogramacion-feedback.effect';
import { CanjeReprogramacionSyncEffects } from '../../effects/canje-reprogramacion-sync.effect';

// ── Transacción Periódica ────────────────────────────────────────────────────
import { ITransaccionPeriodicaRepository } from '../../domain/repositories/itransaccion-periodica.repository';
import { TransaccionPeriodicaRepositoryImpl } from '../repository/transaccion-periodica.repository.impl';
import { TransaccionPeriodicaStore } from '../../store/transaccion-periodica.store';
import { TransaccionPeriodicaFacade } from '../../application/facades/transaccion-periodica.facade';
import { ObtenerTransaccionPeriodicaUseCase } from '../../application/usecases/obtener-transaccion-periodica.usecase';
import { GuardarTransaccionPeriodicaUseCase } from '../../application/usecases/guardar-transaccion-periodica.usecase';
import { ActualizarTransaccionPeriodicaUseCase } from '../../application/usecases/actualizar-transaccion-periodica.usecase';
import { TransaccionPeriodicaFeedbackEffects } from '../../effects/transaccion-periodica-feedback.effect';
import { TransaccionPeriodicaSyncEffects } from '../../effects/transaccion-periodica-sync.effect';
// ── Relación Doc. por Cliente ───────────────────────────────────────────────
import { IRelacionDocClienteRepository } from '../../domain/repositories/irelaciondoc-cliente.repository';
import { RelacionDocClienteRepositoryImpl } from '../repository/relaciondoc-cliente.repository.impl';
import { RelacionDocClienteStore } from '../../store/relaciondoc-cliente.store';
import { RelacionDocClienteFacade } from '../../application/facades/relaciondoc-cliente.facade';
import { ObtenerRelacionDocClienteUseCase } from '../../application/usecases/obtener-relaciondoc-cliente.usecase';
import { RelacionDocClienteFeedbackEffects } from '../../effects/relaciondoc-cliente-feedback.effect';
// ── Relación Doc. por Proveedor ──────────────────────────────────────────────
import { IRelacionDocProveedorRepository } from '../../domain/repositories/irelaciondoc-proveedor.repository';

import { RelacionDocProveedorRepositoryImpl } from '../repository/relaciondoc-proveedor.repository.impl';
import { RelacionDocProveedorStore } from '../../store/relaciondoc-proveedor.store';
import { RelacionDocProveedorFacade } from '../../application/facades/relaciondoc-proveedor.facade';
import { ObtenerRelacionDocProveedorUseCase } from '../../application/usecases/obtener-relaciondoc-proveedor.usecase';
import { RelacionDocProveedorFeedbackEffects } from '../../effects/relaciondoc-proveedor-feedback.effect';

// ── Pagos Recibidos ──────────────────────────────────────────────────────────
import { IPagoRecibidoRepository } from '../../domain/repositories/ipago-recibido.repository';
import { PagoRecibidoRepositoryImpl } from '../repository/pago-recibido.repository.impl';
import { PagoRecibidoStore } from '../../store/pago-recibido.store';
import { PagoRecibidoFacade } from '../../application/facades/pago-recibido.facade';
import { ObtenerPagoRecibidoUseCase } from '../../application/usecases/obtener-pago-recibido.usecase';
import { PagoRecibidoFeedbackEffects } from '../../effects/pago-recibido-feedback.effect';

// ── Letra de Cambio ──────────────────────────────────────────────────────────
import { ILetraCambioRepository } from '../../domain/repositories/iletra-cambio.repository';
import { LetraCambioRepositoryImpl } from '../repository/letra-cambio.repository.impl';
import { LetraCambioStore } from '../../store/letra-cambio.store';
import { LetraCambioFacade } from '../../application/facades/letra-cambio.facade';
import { ObtenerLetraCambioUseCase } from '../../application/usecases/obtener-letra-cambio.usecase';
import { GuardarLetraCambioUseCase } from '../../application/usecases/guardar-letra-cambio.usecase';
import { ActualizarLetraCambioUseCase } from '../../application/usecases/actualizar-letra-cambio.usecase';
import { LetraCambioFeedbackEffects } from '../../effects/letra-cambio-feedback.effect';
import { LetraCambioSyncEffects } from '../../effects/letra-cambio-sync.effect';

// ── Registro de Facturas ────────────────────────────────────────────────────────
import { IRegistroFacturaRepository } from '../../domain/repositories/iregistro-factura.repository';
import { RegistroFacturaRepositoryImpl } from '../repository/registro-factura.repository.impl';
import { RegistroFacturaStore } from '../../store/registro-factura.store';
import { RegistroFacturaFacade } from '../../application/facades/registro-factura.facade';
import { ObtenerRegistroFacturaUseCase } from '../../application/usecases/obtener-registro-factura.usecase';
import { GuardarRegistroFacturaUseCase } from '../../application/usecases/guardar-registro-factura.usecase';
import { ActualizarRegistroFacturaUseCase } from '../../application/usecases/actualizar-registro-factura.usecase';
import { RegistroFacturaFeedbackEffects } from '../../effects/registro-factura-feedback.effect';
import { RegistroFacturaSyncEffects } from '../../effects/registro-factura-sync.effect';

// ── Consulta Caja y Banco ─────────────────────────────────────────────────────────────────────
import { IConsultaCajaBancoRepository } from '../../domain/repositories/iconsulta-caja-banco.repository';
import { ConsultaCajaBancoRepositoryImpl } from '../repository/consulta-caja-banco.repository.impl';
import { ConsultaCajaBancoStore } from '../../store/consulta-caja-banco.store';
import { ConsultaCajaBancoFacade } from '../../application/facades/consulta-caja-banco.facade';
import { ObtenerConsultaCajaBancoUseCase } from '../../application/usecases/obtener-consulta-caja-banco.usecase';
import { ConsultaCajaBancoFeedbackEffects } from '../../effects/consulta-caja-banco-feedback.effect';

// ── Consulta Flujo de Caja ───────────────────────────────────────────────────
import { IConsultaFlujoCajaRepository } from '../../domain/repositories/iconsulta-flujo-caja.repository';
import { ConsultaFlujoCajaRepositoryImpl } from '../repository/consulta-flujo-caja.repository.impl';
import { ConsultaFlujoCajaStore } from '../../store/consulta-flujo-caja.store';
import { ConsultaFlujoCajaFacade } from '../../application/facades/consulta-flujo-caja.facade';
import { ObtenerConsultaFlujoCajaUseCase } from '../../application/usecases/obtener-consulta-flujo-caja.usecase';
import { ConsultaFlujoCajaFeedbackEffects } from '../../effects/consulta-flujo-caja-feedback.effect';

// ── Consulta Documentos ──────────────────────────────────────────────────────
import { IConsultaDocumentosRepository } from '../../domain/repositories/iconsulta-documentos.repository';
import { ConsultaDocumentosRepositoryImpl } from '../repository/consulta-documentos.repository.impl';
import { ConsultaDocumentosStore } from '../../store/consulta-documentos.store';
import { ConsultaDocumentosFacade } from '../../application/facades/consulta-documentos.facade';
import { ObtenerConsultaDocumentosUseCase } from '../../application/usecases/obtener-consulta-documentos.usecase';
import { ConsultaDocumentosFeedbackEffects } from '../../effects/consulta-documentos-feedback.effect';

// ── Órdenes de Giro ────────────────────────────────────────────────
import { IOrdenGiroRepository } from '../../domain/repositories/iorden-giro.repository';
import { OrdenGiroRepositoryImpl } from '../repository/orden-giro.repository.impl';
import { OrdenGiroStore } from '../../store/orden-giro.store';
import { OrdenGiroFacade } from '../../application/facades/orden-giro.facade';
import { ObtenerOrdenGiroUseCase } from '../../application/usecases/obtener-orden-giro.usecase';
import { GuardarOrdenGiroUseCase } from '../../application/usecases/guardar-orden-giro.usecase';
import { ActualizarOrdenGiroUseCase } from '../../application/usecases/actualizar-orden-giro.usecase';
import { OrdenGiroFeedbackEffects } from '../../effects/orden-giro-feedback.effect';
import { OrdenGiroSyncEffects } from '../../effects/orden-giro-sync.effect';

// ── Liq. y Rendición ─────────────────────────────────────────────────────────────
import { ILiqRendicionRepository } from '../../domain/repositories/iliq-rendicion.repository';
import { LiqRendicionRepositoryImpl } from '../repository/liq-rendicion.repository.impl';
import { LiqRendicionStore } from '../../store/liq-rendicion.store';
import { LiqRendicionFacade } from '../../application/facades/liq-rendicion.facade';
import { ObtenerLiqRendicionUseCase } from '../../application/usecases/obtener-liq-rendicion.usecase';
import { GuardarLiqRendicionUseCase } from '../../application/usecases/guardar-liq-rendicion.usecase';
import { ActualizarLiqRendicionUseCase } from '../../application/usecases/actualizar-liq-rendicion.usecase';
import { LiqRendicionFeedbackEffects } from '../../effects/liq-rendicion-feedback.effect';
import { LiqRendicionSyncEffects } from '../../effects/liq-rendicion-sync.effect';

// ── Aprobar Giro ─────────────────────────────────────────────────────────────
import { IAprobarGiroRepository } from '../../domain/repositories/iaprobar-giro.repository';
import { AprobarGiroRepositoryImpl } from '../repository/aprobar-giro.repository.impl';
import { AprobarGiroStore } from '../../store/aprobar-giro.store';
import { AprobarGiroFacade } from '../../application/facades/aprobar-giro.facade';
import { ObtenerAprobarGiroUseCase } from '../../application/usecases/obtener-aprobar-giro.usecase';
import { ActualizarAprobarGiroUseCase } from '../../application/usecases/actualizar-aprobar-giro.usecase';
import { AprobarGiroFeedbackEffects } from '../../effects/aprobar-giro-feedback.effect';
import { AprobarGiroSyncEffects } from '../../effects/aprobar-giro-sync.effect';

// ── Aprobar Liq. Gastos ────────────────────────────────────────────────────────
import { IAprobarLiqGastosRepository } from '../../domain/repositories/iaprobar-liq-gastos.repository';
import { AprobarLiqGastosRepositoryImpl } from '../repository/aprobar-liq-gastos.repository.impl';
import { AprobarLiqGastosStore } from '../../store/aprobar-liq-gastos.store';
import { AprobarLiqGastosFacade } from '../../application/facades/aprobar-liq-gastos.facade';
import { ObtenerAprobarLiqGastosUseCase } from '../../application/usecases/obtener-aprobar-liq-gastos.usecase';
import { ActualizarAprobarLiqGastosUseCase } from '../../application/usecases/actualizar-aprobar-liq-gastos.usecase';
import { AprobarLiqGastosFeedbackEffects } from '../../effects/aprobar-liq-gastos-feedback.effect';
import { AprobarLiqGastosSyncEffects } from '../../effects/aprobar-liq-gastos-sync.effect';

// ── Carteras Cobros ──────────────────────────────────────────────────────────
import { ICarterasCobrosRepository } from '../../domain/repositories/icarteras-cobros.repository';
import { CarterasCobrosRepositoryImpl } from '../repository/carteras-cobros.repository.impl';
import { CarterasCobrosStore } from '../../store/carteras-cobros.store';
import { CarterasCobrosFacade } from '../../application/facades/carteras-cobros.facade';
import { ObtenerCarterasCobrosUseCase } from '../../application/usecases/obtener-carteras-cobros.usecase';
import { ActualizarCarterasCobrosUseCase } from '../../application/usecases/actualizar-carteras-cobros.usecase';
import { CarterasCobrosFeedbackEffects } from '../../effects/carteras-cobros-feedback.effect';
import { CarterasCobrosSyncEffects } from '../../effects/carteras-cobros-sync.effect';// ── Pagos Masivos ────────────────────────────────────────────────────────────
import { IPagosMasivosRepository } from '../../domain/repositories/ipagos-masivos.repository';
import { PagosMasivosRepositoryImpl } from '../repository/pagos-masivos.repository.impl';
import { PagosMasivosStore } from '../../store/pagos-masivos.store';
import { PagosMasivosFacade } from '../../application/facades/pagos-masivos.facade';
import { ObtenerPagosMasivosUseCase } from '../../application/usecases/obtener-pagos-masivos.usecase';
import { ObtenerPagosMasivosDocumentosUseCase } from '../../application/usecases/obtener-pagos-masivos-documentos.usecase';
import { GuardarPagosMasivosUseCase } from '../../application/usecases/guardar-pagos-masivos.usecase';
import { PagosMasivosFeedbackEffects } from '../../effects/pagos-masivos-feedback.effect';
import { PagosMasivosSyncEffects } from '../../effects/pagos-masivos-sync.effect';
// ── Aplicación Pagos ─────────────────────────────────────────────────────────
import { IAplicacionPagosRepository } from '../../domain/repositories/iaplicacion-pagos.repository';
import { AplicacionPagosRepositoryImpl } from '../repository/aplicacion-pagos.repository.impl';
import { AplicacionPagosStore } from '../../store/aplicacion-pagos.store';
import { AplicacionPagosFacade } from '../../application/facades/aplicacion-pagos.facade';
import { ObtenerAplicacionPagosUseCase } from '../../application/usecases/obtener-aplicacion-pagos.usecase';
import { GuardarAplicacionPagosUseCase } from '../../application/usecases/guardar-aplicacion-pagos.usecase';
import { ActualizarAplicacionPagosUseCase } from '../../application/usecases/actualizar-aplicacion-pagos.usecase';
import { AplicacionPagosFeedbackEffects } from '../../effects/aplicacion-pagos-feedback.effect';
import { AplicacionPagosSyncEffects } from '../../effects/aplicacion-pagos-sync.effect';
import { ObtenerAplicacionPagosPlanillaUseCase } from '../../application/usecases/obtener-aplicacion-pagos-planilla.usecase';
import { ObtenerAplicacionPagosTrabajadoresUseCase } from '../../application/usecases/obtener-aplicacion-pagos-trabajadores.usecase';
// ── Cerrar Liq. Adelantos ────────────────────────────────────────────────────
import { ICerrarLiqAdelantosRepository } from '../../domain/repositories/icerrar-liq-adelantos.repository';
import { CerrarLiqAdelantosRepositoryImpl } from '../repository/cerrar-liq-adelantos.repository.impl';
import { CerrarLiqAdelantosStore } from '../../store/cerrar-liq-adelantos.store';
import { CerrarLiqAdelantosFacade } from '../../application/facades/cerrar-liq-adelantos.facade';
import { ObtenerCerrarLiqAdelantosUseCase } from '../../application/usecases/obtener-cerrar-liq-adelantos.usecase';
import { ActualizarCerrarLiqAdelantosUseCase } from '../../application/usecases/actualizar-cerrar-liq-adelantos.usecase';
import { CerrarLiqAdelantosFeedbackEffects } from '../../effects/cerrar-liq-adelantos-feedback.effect';
import { CerrarLiqAdelantosSyncEffects } from '../../effects/cerrar-liq-adelantos-sync.effect';

// ── Movimientos entre Cuentas Bancarias y Cajas ──────────────────────────────
import { IMovCuentasBancYCajasRepository } from '../../domain/repositories/imov-cuentas-banc-y-cajas.repository';
import { MovCuentasBancYCajasRepositoryImpl } from '../repository/mov-cuentas-banc-y-cajas.repository.impl';
import { MovCuentasBancYCajasStore } from '../../store/mov-cuentas-banc-y-cajas.store';
import { MovCuentasBancYCajasFacade } from '../../application/facades/mov-cuentas-banc-y-cajas.facade';
import { ObtenerMovCuentasBancYCajasUseCase } from '../../application/usecases/obtener-mov-cuentas-banc-y-cajas.usecase';
import { MovCuentasBancYCajasFeedbackEffects } from '../../effects/mov-cuentas-banc-y-cajas-feedback.effect';

// ── Programación de Pagos por Vencimiento ────────────────────────────────────
import { IProgramPagosPorVencRepository } from '../../domain/repositories/iprogram-pagos-por-venc.repository';
import { ProgramPagosPorVencRepositoryImpl } from '../repository/program-pagos-por-venc.repository.impl';
import { ProgramPagosPorVencStore } from '../../store/program-pagos-por-venc.store';
import { ProgramPagosPorVencFacade } from '../../application/facades/program-pagos-por-venc.facade';
import { ObtenerProgramPagosPorVencUseCase } from '../../application/usecases/obtener-program-pagos-por-venc.usecase';
import { ProgramPagosPorVencFeedbackEffects } from '../../effects/program-pagos-por-venc-feedback.effect';

// ── Anulación / Reversión de Pagos ──────────────────────────────────────────
import { IAnulacionPagosRepository } from '../../domain/repositories/ianulacion-pagos.repository';
import { AnulacionPagosRepositoryImpl } from '../repository/anulacion-pagos.repository.impl';
import { AnulacionPagosStore } from '../../store/anulacion-pagos.store';
import { AnulacionPagosFacade } from '../../application/facades/anulacion-pagos.facade';
import { ObtenerAnulacionPagosUseCase } from '../../application/usecases/obtener-anulacion-pagos.usecase';
import { AnulacionPagosFeedbackEffects } from '../../effects/anulacion-pagos-feedback.effect';

// ── Ejecución de Pago ────────────────────────────────────────────────────────
import { IEjecucionPagoRepository } from '../../domain/repositories/iejecucion-pago.repository';
import { EjecucionPagoRepositoryImpl } from '../repository/ejecucion-pago.repository.impl';
import { EjecucionPagoStore } from '../../store/ejecucion-pago.store';
import { EjecucionPagoFacade } from '../../application/facades/ejecucion-pago.facade';
import { ObtenerEjecucionPagoUseCase } from '../../application/usecases/obtener-ejecucion-pago.usecase';
import { GuardarEjecucionPagoUseCase } from '../../application/usecases/guardar-ejecucion-pago.usecase';
import { AnularEjecucionPagoUseCase } from '../../application/usecases/anular-ejecucion-pago.usecase';
import { EjecucionPagoFeedbackEffects } from '../../effects/ejecucion-pago-feedback.effect';
import { EjecucionPagoSyncEffects } from '../../effects/ejecucion-pago-sync.effect';

// ── Pago Detracción ──────────────────────────────────────────────────────
import { IPagoDetraccionRepository } from '../../domain/repositories/ipago-detraccion.repository';
import { PagoDetraccionRepositoryImpl } from '../repository/pago-detraccion.repository.impl';
import { PagoDetraccionStore } from '../../store/pago-detraccion.store';
import { PagoDetraccionFacade } from '../../application/facades/pago-detraccion.facade';
import { ObtenerPagoDetraccionUseCase } from '../../application/usecases/obtener-pago-detraccion.usecase';
import { PagoDetraccionFeedbackEffects } from '../../effects/pago-detraccion-feedback.effect';

// ── Asignación Fondo Fijo Caja ────────────────────────────────────────────
import { IAsignacionFondoFijoCajaRepository } from '../../domain/repositories/iasignacion-fondo-fijo-caja.repository';
import { AsignacionFondoFijoCajaRepositoryImpl } from '../repository/asignacion-fondo-fijo-caja.repository.impl';
import { AsignacionFondoFijoCajaStore } from '../../store/asignacion-fondo-fijo-caja.store';
import { AsignacionFondoFijoCajaFacade } from '../../application/facades/asignacion-fondo-fijo-caja.facade';
import { ObtenerAsignacionFondoFijoCajaUseCase } from '../../application/usecases/obtener-asignacion-fondo-fijo-caja.usecase';
import { AsignacionFondoFijoCajaFeedbackEffects } from '../../effects/asignacion-fondo-fijo-caja-feedback.effect';

// ── Asignación Caja Chica ─────────────────────────────────────────────────
import { IAsignacionCajaChicaRepository } from '../../domain/repositories/iasignacion-caja-chica.repository';
import { AsignacionCajaChicaRepositoryImpl } from '../repository/asignacion-caja-chica.repository.impl';
import { AsignacionCajaChicaStore } from '../../store/asignacion-caja-chica.store';
import { AsignacionCajaChicaFacade } from '../../application/facades/asignacion-caja-chica.facade';
import { ObtenerAsignacionCajaChicaUseCase } from '../../application/usecases/obtener-asignacion-caja-chica.usecase';
import { AsignacionCajaChicaFeedbackEffects } from '../../effects/asignacion-caja-chica-feedback.effect';
// ── Registro Egreso Menor ───────────────────────────────────────────────
import { IRegistroEgresoMenorRepository } from '../../domain/repositories/iregistro-egreso-menor.repository';
import { RegistroEgresoMenorRepositoryImpl } from '../repository/registro-egreso-menor.repository.impl';
import { RegistroEgresoMenorStore } from '../../store/registro-egreso-menor.store';
import { RegistroEgresoMenorFacade } from '../../application/facades/registro-egreso-menor.facade';
import { ObtenerRegistroEgresoMenorUseCase } from '../../application/usecases/obtener-registro-egreso-menor.usecase';
import { RegistroEgresoMenorFeedbackEffects } from '../../effects/registro-egreso-menor-feedback.effect';
import { IProyeccionIngresosEgresosRepository } from '../../domain/repositories/iproyeccion-ingresos-egresos.repository';
import { ProyeccionIngresosEgresosRepositoryImpl } from '../repository/proyeccion-ingresos-egresos.repository.impl';
import { ProyeccionIngresosEgresosStore } from '../../store/proyeccion-ingresos-egresos.store';
import { ObtenerProyeccionIngresosEgresosUseCase } from '../../application/usecases/obtener-proyeccion-ingresos-egresos.usecase';
import { ProyeccionIngresosEgresosFacade } from '../../application/facades/proyeccion-ingresos-egresos.facade';
import { ProyeccionIngresosEgresosFeedbackEffects } from '../../effects/proyeccion-ingresos-egresos-feedback.effect';

// ── Registro Ingreso de Día ──────────────────────────────────────────
import { IRegistroIngresoDeDiaRepository } from '../../domain/repositories/iregistro-ingreso-de-dia.repository';
import { RegistroIngresoDeDiaRepositoryImpl } from '../repository/registro-ingreso-de-dia.repository.impl';
import { RegistroIngresoDeDiaStore } from '../../store/registro-ingreso-de-dia.store';
import { RegistroIngresoDeDiaFacade } from '../../application/facades/registro-ingreso-de-dia.facade';
import { ObtenerRegistroIngresoDeDiaUseCase } from '../../application/usecases/obtener-registro-ingreso-de-dia.usecase';
import { RegistroIngresoDeDiaFeedbackEffects } from '../../effects/registro-ingreso-de-dia-feedback.effect';

// ── Cruce Extracto (Conciliaciones) ─────────────────────────────────────
import { ICruceExtractoRepository } from '../../domain/repositories/icruce-extracto.repository';
import { CruceExtractoRepositoryImpl } from '../repository/cruce-extracto.repository.impl';
import { CruceExtractoStore } from '../../store/cruce-extracto.store';
import { CruceExtractoFacade } from '../../application/facades/cruce-extracto.facade';
import { ObtenerCruceExtractoUseCase } from '../../application/usecases/obtener-cruce-extracto.usecase';
import { CruceExtractoFeedbackEffects } from '../../effects/cruce-extracto-feedback.effect';
import { IMovimientoCruceRepository } from '../../domain/repositories/imovimiento-cruce.repository';
import { MovimientoCruceRepositoryImpl } from '../repository/movimiento-cruce.repository.impl';
import { ObtenerMovimientoCruceUseCase } from '../../application/usecases/obtener-movimiento-cruce.usecase';
import { IConciliacionRepository } from '../../domain/repositories/iconciliacion.repository';
import { ConciliacionRepositoryImpl } from '../repository/conciliacion.repository.impl';
import { ConciliacionStore } from '../../store/conciliacion.store';
import { ObtenerConciliacionUseCase } from '../../application/usecases/obtener-conciliacion.usecase';
import { ConciliacionFacade } from '../../application/facades/conciliacion.facade';
import { ConciliacionFeedbackEffects } from '../../effects/conciliacion-feedback.effect';
import { ICrucePasarelaRepository } from '../../domain/repositories/icruce-pasarela.repository';
import { CrucePasarelaRepositoryImpl } from '../repository/cruce-pasarela.repository.impl';
import { IMovimientoPasarelaRepository } from '../../domain/repositories/imovimiento-pasarela.repository';
import { MovimientoPasarelaRepositoryImpl } from '../repository/movimiento-pasarela.repository.impl';
import { CrucePasarelaStore } from '../../store/cruce-pasarela.store';
import { ObtenerCrucePasarelaUseCase } from '../../application/usecases/obtener-cruce-pasarela.usecase';
import { ObtenerMovimientoPasarelaUseCase } from '../../application/usecases/obtener-movimiento-pasarela.usecase';
import { CrucePasarelaFacade } from '../../application/facades/cruce-pasarela.facade';
import { CrucePasarelaFeedbackEffects } from '../../effects/cruce-pasarela-feedback.effect';
import { ICuentaPagarRepository } from '../../domain/repositories/icuenta-pagar.repository';
import { CuentaPagarRepositoryImpl } from '../repository/cuenta-pagar.repository.impl';
import { CuentaPagarStore } from '../../store/cuenta-pagar.store';
import { ObtenerCuentaPagarUseCase } from '../../application/usecases/obtener-cuenta-pagar.usecase';
import { CuentaPagarFacade } from '../../application/facades/cuenta-pagar.facade';
import { CuentaPagarFeedbackEffects } from '../../effects/cuenta-pagar-feedback.effect';
// ── Reporte Tesorería ────────────────────────────────────────────────────────
import { IReporteTesoreriaRepository } from '../../domain/repositories/ireporte-tesoreria.repository';
import { ReporteTesoreriaRepositoryImpl } from '../repository/reporte-tesoreria.repository.impl';
import { ReporteTesoreriaStore } from '../../store/reporte-tesoreria.store';
import { ObtenerReporteTesoreriaUseCase } from '../../application/usecases/obtener-reporte-tesoreria.usecase';
import { ReporteTesoreriaFacade } from '../../application/facades/reporte-tesoreria.facade';
import { ReporteTesoreriaFeedbackEffects } from '../../effects/reporte-tesoreria-feedback.effect';
// ── Documentos por Cobrar (Clientes) ───────────────────────────────────────
import { IDocumentoClienteRepository } from '../../domain/repositories/idocumento-cliente.repository';
import { DocumentoClienteRepositoryImpl } from '../repository/documento-cliente.repository.impl';
import { DocumentoClienteStore } from '../../store/documento-cliente.store';
import { ObtenerDocumentoClienteUseCase } from '../../application/usecases/obtener-documento-cliente.usecase';
import { DocumentoClienteFacade } from '../../application/facades/documento-cliente.facade';
import { DocumentoClienteFeedbackEffects } from '../../effects/documento-cliente-feedback.effect';
// ── Obligaciones por Vencer ─────────────────────────────────────────────────
import { IObligacionVencerRepository } from '../../domain/repositories/iobligacion-vencer.repository';
import { ObligacionVencerRepositoryImpl } from '../repository/obligacion-vencer.repository.impl';
import { ObligacionVencerStore } from '../../store/obligacion-vencer.store';
import { ObtenerObligacionVencerUseCase } from '../../application/usecases/obtener-obligacion-vencer.usecase';
import { ObligacionVencerFacade } from '../../application/facades/obligacion-vencer.facade';
import { ObligacionVencerFeedbackEffects } from '../../effects/obligacion-vencer-feedback.effect';
// ── Reporte Finanzas ───────────────────────────────────────────────────────────────
import { IReporteFinanzasRepository } from '../../domain/repositories/ireporte-finanzas.repository';
import { ReporteFinanzasRepositoryImpl } from '../repository/reporte-finanzas.repository.impl';
import { ReporteFinanzasStore } from '../../store/reporte-finanzas.store';
import { ObtenerReporteFinanzasUseCase } from '../../application/usecases/obtener-reporte-finanzas.usecase';
import { ReporteFinanzasFacade } from '../../application/facades/reporte-finanzas.facade';
import { ReporteFinanzasFeedbackEffects } from '../../effects/reporte-finanzas-feedback.effect';

// ── Proveedor (desde módulo Compras) ────────────────────────────────────────
import { IProveedorRepository } from '@modules/compras/domain/repositories/iproveedor.repository';
import { ProveedorRepositoryImpl } from '@modules/compras/infrastructure/repository/proveedores.repository.impl';
import { ProveedorStore } from '@modules/compras/store/proveedor.store';
import { ObtenerProveedoresUseCase } from '@modules/compras/application/usecases/obtener-proveedores.usecase';
import { GuardarProveedorUseCase } from '@modules/compras/application/usecases/guardar-proveedor.usecase';
import { ActualizarProveedorUseCase } from '@modules/compras/application/usecases/actualizar-proveedor.usecase';
import { EliminarProveedorUseCase } from '@modules/compras/application/usecases/eliminar-proveedor.usecase';
import { ProveedorFacade } from '@modules/compras/application/facades/proveedor.facade';

// ── Tipo Documento (desde módulo Finanzas) ─────────────────────────────────
import { ITipoDocumentoRepository } from '@modules/finanzas/domain/repositories/itipo-documento.repository';
import { TipoDocumentoRepositoryImpl } from '../repository/tipo-documento.repository.impl';
import { TipoDocumentoStore } from '@modules/finanzas/store/tipo-documento.store';
import { ObtenerTiposDocumentoUseCase } from '@modules/finanzas/application/usecases/obtener-tipo.documento.usecase';
import { TipoDocumentoFacade } from '@modules/finanzas/application/facades/tipo-documento.facade';
import { ActualizarTipoDocumentoUseCase } from '@modules/finanzas/application/usecases/actualizar-tipo-documento.usecase';
import { EliminarTipoDocumentoUseCase } from '@modules/finanzas/application/usecases/eliminar-tipo-documento.usecase';
import { GuardarTipoDocumentoUseCase } from '@modules/finanzas/application/usecases/guardar-tipo-documento.usecase';
import { ISunatTipoDocumentoRepository } from '@modules/finanzas/domain/repositories/isunat-tipo-documento.repository';
import { SunatTipoDocumentoRepositoryImpl } from '../repository/sunat-tipo-documento-repository.impl';
import { SunatTipoDocumentoStore } from '@modules/finanzas/store/sunat-tipo-documento.store';
import { SunatTipoDocumentoFacade } from '@modules/finanzas/application/facades/sunat-tipo-documento.facade';
import { ObtenerSunatTiposDocumentoUseCase } from '@modules/finanzas/application/usecases/obtener-sunat-tipo-documento.usecase';
import { IMatrizContableRepository } from '@modules/activos/domain/repositories/imatriz-contable.repository';
import { MatrizContableRepositoryImpl } from '@modules/activos/infrastructure/repository/matriz-contable.repository.impl';
import { MatrizContableFacade } from '@modules/activos/application/facades/matriz-contable.facade';
import { MatrizContableStore } from '@modules/activos/store/matriz-contable.store';
import { ObtenerMatrizContableUseCase } from '@modules/activos/application/usecases/obtener-matriz-contable.usecase';
import { ActualizarMatrizContableUseCase } from '@modules/activos/application/usecases/actualizar-matriz-contable.usecase';
import { GuardarMatrizContableUseCase } from '@modules/activos/application/usecases/guardar-matriz-contable.usecase';
import { EliminarMatrizContableUseCase } from '@modules/activos/application/usecases/eliminar-matriz-contable.usecase';

export const FINANZAS_PROVIDERS: Provider[] = [
  // ── Concepto Financiero ────────────────────────────────────────────────────
  { provide: IConceptoFinancieroRepository, useClass: ConceptoFinancieroRepositoryImpl },
  ConceptoFinancieroStore,
  ObtenerConceptoFinancieroUseCase,
  GuardarConceptoFinancieroUseCase,
  ActualizarConceptoFinancieroUseCase,
  EliminarConceptoFinancieroUseCase,
  ConceptoFinancieroFacade,
  ConceptoFinancieroFeedbackEffects,
  ConceptoFinancieroSyncEffects,

  // ── Gestión Catálogo ───────────────────────────────────────────────────────
  { provide: IGestionCatalogoRepository, useClass: GestionCatalogoRepositoryImpl },
  GestionCatalogoStore,
  ObtenerGestionCatalogoUseCase,
  GuardarGestionCatalogoUseCase,
  ActualizarGestionCatalogoUseCase,
  EliminarGestionCatalogoUseCase,
  GestionCatalogoFacade,
  GestionCatalogoFeedbackEffects,
  GestionCatalogoSyncEffects,

  // ── Gestión Grupo ──────────────────────────────────────────────────────
  { provide: IGestionGrupoRepository, useClass: GestionGrupoRepositoryImpl },
  GestionGrupoStore,
  ObtenerGestionGrupoUseCase,
  GuardarGestionGrupoUseCase,
  ActualizarGestionGrupoUseCase,
  GestionGrupoFacade,
  GestionGrupoFeedbackEffects,
  GestionGrupoSyncEffects,

  // ── Canje y Reprogramación ─────────────────────────────────────────────────
  { provide: ICanjeReprogramacionRepository, useClass: CanjeReprogramacionRepositoryImpl },
  CanjeReprogramacionStore,
  ObtenerCanjeReprogramacionUseCase,
  AplicarCanjeUseCase,
  ReprogramarVencimientoUseCase,
  CanjeReprogramacionFacade,
  CanjeReprogramacionFeedbackEffects,
  CanjeReprogramacionSyncEffects,

  // ── Transacción Periódica ────────────────────────────────────────────────
  { provide: ITransaccionPeriodicaRepository, useClass: TransaccionPeriodicaRepositoryImpl },
  TransaccionPeriodicaStore,
  ObtenerTransaccionPeriodicaUseCase,
  GuardarTransaccionPeriodicaUseCase,
  ActualizarTransaccionPeriodicaUseCase,
  TransaccionPeriodicaFacade,
  TransaccionPeriodicaFeedbackEffects,
  TransaccionPeriodicaSyncEffects,

  // ── Relación Doc. por Cliente ──────────────────────────────────────────────
  { provide: IRelacionDocClienteRepository, useClass: RelacionDocClienteRepositoryImpl },
  RelacionDocClienteStore,
  ObtenerRelacionDocClienteUseCase,
  RelacionDocClienteFacade,
  RelacionDocClienteFeedbackEffects,

  // ── Relación Doc. por Proveedor ──────────────────────────────────────────
  { provide: IRelacionDocProveedorRepository, useClass: RelacionDocProveedorRepositoryImpl },
  RelacionDocProveedorStore,
  ObtenerRelacionDocProveedorUseCase,
  RelacionDocProveedorFacade,
  RelacionDocProveedorFeedbackEffects,

  // ── Pagos Recibidos ────────────────────────────────────────────────────────
  { provide: IPagoRecibidoRepository, useClass: PagoRecibidoRepositoryImpl },
  PagoRecibidoStore,
  ObtenerPagoRecibidoUseCase,
  PagoRecibidoFacade,
  PagoRecibidoFeedbackEffects,

  // ── Letra de Cambio ────────────────────────────────────────────────────────
  { provide: ILetraCambioRepository, useClass: LetraCambioRepositoryImpl },
  LetraCambioStore,
  ObtenerLetraCambioUseCase,
  GuardarLetraCambioUseCase,
  ActualizarLetraCambioUseCase,
  LetraCambioFacade,
  LetraCambioFeedbackEffects,
  LetraCambioSyncEffects,

  // ── Registro de Facturas ────────────────────────────────────────────────────────
  { provide: IRegistroFacturaRepository, useClass: RegistroFacturaRepositoryImpl },
  RegistroFacturaStore,
  ObtenerRegistroFacturaUseCase,
  GuardarRegistroFacturaUseCase,
  ActualizarRegistroFacturaUseCase,
  RegistroFacturaFacade,
  RegistroFacturaFeedbackEffects,
  RegistroFacturaSyncEffects,

  // ── Consulta Caja y Banco ─────────────────────────────────────────────────────────────────────
  { provide: IConsultaCajaBancoRepository, useClass: ConsultaCajaBancoRepositoryImpl },
  ConsultaCajaBancoStore,
  ObtenerConsultaCajaBancoUseCase,
  ConsultaCajaBancoFacade,
  ConsultaCajaBancoFeedbackEffects,

  // ── Consulta Flujo de Caja ────────────────────────────────────────────────────────────────────
  { provide: IConsultaFlujoCajaRepository, useClass: ConsultaFlujoCajaRepositoryImpl },
  ConsultaFlujoCajaStore,
  ObtenerConsultaFlujoCajaUseCase,
  ConsultaFlujoCajaFacade,
  ConsultaFlujoCajaFeedbackEffects,

  // ── Consulta Documentos ───────────────────────────────────────────────────────────────────────
  { provide: IConsultaDocumentosRepository, useClass: ConsultaDocumentosRepositoryImpl },
  ConsultaDocumentosStore,
  ObtenerConsultaDocumentosUseCase,
  ConsultaDocumentosFacade,
  ConsultaDocumentosFeedbackEffects,
  // ── Órdenes de Giro ────────────────────────────────────────────────────────────────────
  { provide: IOrdenGiroRepository, useClass: OrdenGiroRepositoryImpl },
  OrdenGiroStore,
  ObtenerOrdenGiroUseCase,
  GuardarOrdenGiroUseCase,
  ActualizarOrdenGiroUseCase,
  OrdenGiroFacade,
  OrdenGiroFeedbackEffects,
  OrdenGiroSyncEffects,

  // ── Aprobar Giro ──────────────────────────────────────────────────────────────────────
  { provide: IAprobarGiroRepository, useClass: AprobarGiroRepositoryImpl },
  AprobarGiroStore,
  ObtenerAprobarGiroUseCase,
  ActualizarAprobarGiroUseCase,
  AprobarGiroFacade,
  AprobarGiroFeedbackEffects,
  AprobarGiroSyncEffects,

  // ── Liq. y Rendición ────────────────────────────────────────────────────────────────────
  { provide: ILiqRendicionRepository, useClass: LiqRendicionRepositoryImpl },
  LiqRendicionStore,
  ObtenerLiqRendicionUseCase,
  GuardarLiqRendicionUseCase,
  ActualizarLiqRendicionUseCase,
  LiqRendicionFacade,
  LiqRendicionFeedbackEffects,
  LiqRendicionSyncEffects,

  // ── Aprobar Liq. Gastos ────────────────────────────────────────────────────────────────────
  { provide: IAprobarLiqGastosRepository, useClass: AprobarLiqGastosRepositoryImpl },
  AprobarLiqGastosStore,
  ObtenerAprobarLiqGastosUseCase,
  ActualizarAprobarLiqGastosUseCase,
  AprobarLiqGastosFacade,
  AprobarLiqGastosFeedbackEffects,
  AprobarLiqGastosSyncEffects,

  // ── Cerrar Liq. Adelantos ────────────────────────────────────────────────────────
  { provide: ICerrarLiqAdelantosRepository, useClass: CerrarLiqAdelantosRepositoryImpl },
  CerrarLiqAdelantosStore,
  ObtenerCerrarLiqAdelantosUseCase,
  ActualizarCerrarLiqAdelantosUseCase,
  CerrarLiqAdelantosFacade,
  CerrarLiqAdelantosFeedbackEffects,
  CerrarLiqAdelantosSyncEffects,

  // ── Carteras Cobros ──────────────────────────────────────────────────────────
  { provide: ICarterasCobrosRepository, useClass: CarterasCobrosRepositoryImpl },
  CarterasCobrosStore,
  ObtenerCarterasCobrosUseCase,
  ActualizarCarterasCobrosUseCase,
  CarterasCobrosFacade,
  CarterasCobrosFeedbackEffects,
  CarterasCobrosSyncEffects,

  // ── Pagos Masivos ──────────────────────────────────────────────────────────
  { provide: IPagosMasivosRepository, useClass: PagosMasivosRepositoryImpl },
  PagosMasivosStore,
  ObtenerPagosMasivosUseCase,
  ObtenerPagosMasivosDocumentosUseCase,
  GuardarPagosMasivosUseCase,
  PagosMasivosFacade,
  PagosMasivosFeedbackEffects,
  PagosMasivosSyncEffects,

  // ── Aplicación Pagos ─────────────────────────────────────────────────────
  { provide: IAplicacionPagosRepository, useClass: AplicacionPagosRepositoryImpl },
  AplicacionPagosStore,
  ObtenerAplicacionPagosUseCase,
  GuardarAplicacionPagosUseCase,
  ActualizarAplicacionPagosUseCase,
  ObtenerAplicacionPagosPlanillaUseCase,
  ObtenerAplicacionPagosTrabajadoresUseCase,
  AplicacionPagosFacade,
  AplicacionPagosFeedbackEffects,
  AplicacionPagosSyncEffects,

  // ── Anulación / Reversión de Pagos ────────────────────────────────────────
  { provide: IAnulacionPagosRepository, useClass: AnulacionPagosRepositoryImpl },
  AnulacionPagosStore,
  ObtenerAnulacionPagosUseCase,
  AnulacionPagosFacade,
  AnulacionPagosFeedbackEffects,

  // ── Programación de Pagos por Vencimiento ─────────────────────────────────
  { provide: IProgramPagosPorVencRepository, useClass: ProgramPagosPorVencRepositoryImpl },
  ProgramPagosPorVencStore,
  ObtenerProgramPagosPorVencUseCase,
  ProgramPagosPorVencFacade,
  ProgramPagosPorVencFeedbackEffects,

  // ── Movimientos entre Cuentas Bancarias y Cajas ───────────────────────────
  { provide: IMovCuentasBancYCajasRepository, useClass: MovCuentasBancYCajasRepositoryImpl },
  MovCuentasBancYCajasStore,
  ObtenerMovCuentasBancYCajasUseCase,
  MovCuentasBancYCajasFacade,
  MovCuentasBancYCajasFeedbackEffects,

  // ── Ejecución de Pago ─────────────────────────────────────────────────────
  { provide: IEjecucionPagoRepository, useClass: EjecucionPagoRepositoryImpl },
  EjecucionPagoStore,
  ObtenerEjecucionPagoUseCase,
  GuardarEjecucionPagoUseCase,
  AnularEjecucionPagoUseCase,
  EjecucionPagoFacade,
  EjecucionPagoFeedbackEffects,
  EjecucionPagoSyncEffects,

  // ── Pago Detracción ─────────────────────────────────────────────────
  { provide: IPagoDetraccionRepository, useClass: PagoDetraccionRepositoryImpl },
  PagoDetraccionStore,
  ObtenerPagoDetraccionUseCase,
  PagoDetraccionFacade,
  PagoDetraccionFeedbackEffects,

  // ── Asignación Fondo Fijo Caja ──────────────────────────────────────────
  { provide: IAsignacionFondoFijoCajaRepository, useClass: AsignacionFondoFijoCajaRepositoryImpl },
  AsignacionFondoFijoCajaStore,
  ObtenerAsignacionFondoFijoCajaUseCase,
  AsignacionFondoFijoCajaFacade,
  AsignacionFondoFijoCajaFeedbackEffects,

  // ── Asignación Caja Chica ───────────────────────────────────────────────
  { provide: IAsignacionCajaChicaRepository, useClass: AsignacionCajaChicaRepositoryImpl },
  AsignacionCajaChicaStore,
  ObtenerAsignacionCajaChicaUseCase,
  AsignacionCajaChicaFacade,
  AsignacionCajaChicaFeedbackEffects,
  // ── Registro Egreso Menor ───────────────────────────────────────────
  { provide: IRegistroEgresoMenorRepository, useClass: RegistroEgresoMenorRepositoryImpl },
  RegistroEgresoMenorStore,
  ObtenerRegistroEgresoMenorUseCase,
  RegistroEgresoMenorFacade,
  RegistroEgresoMenorFeedbackEffects,

  // ── Proyección Ingresos Egresos ────────────────────────────────────────
  { provide: IProyeccionIngresosEgresosRepository, useClass: ProyeccionIngresosEgresosRepositoryImpl },
  ProyeccionIngresosEgresosStore,
  ObtenerProyeccionIngresosEgresosUseCase,
  ProyeccionIngresosEgresosFacade,
  ProyeccionIngresosEgresosFeedbackEffects,

  // ── Registro Ingreso de Día ──────────────────────────────────────────
  { provide: IRegistroIngresoDeDiaRepository, useClass: RegistroIngresoDeDiaRepositoryImpl },
  RegistroIngresoDeDiaStore,
  ObtenerRegistroIngresoDeDiaUseCase,
  RegistroIngresoDeDiaFacade,
  RegistroIngresoDeDiaFeedbackEffects,

  // ── Cruce Extracto (Conciliaciones) ────────────────────────────────────
  { provide: ICruceExtractoRepository, useClass: CruceExtractoRepositoryImpl },
  CruceExtractoStore,
  ObtenerCruceExtractoUseCase,
  CruceExtractoFacade,
  CruceExtractoFeedbackEffects,
  { provide: IMovimientoCruceRepository, useClass: MovimientoCruceRepositoryImpl },
  ObtenerMovimientoCruceUseCase,

  // ── Conciliación ──────────────────────────────────────────────────────
  { provide: IConciliacionRepository, useClass: ConciliacionRepositoryImpl },
  ConciliacionStore,
  ObtenerConciliacionUseCase,
  ConciliacionFacade,
  ConciliacionFeedbackEffects,

  // ── Cruce Pasarela (Conciliaciones) ────────────────────────────────────────────
  { provide: ICrucePasarelaRepository, useClass: CrucePasarelaRepositoryImpl },
  { provide: IMovimientoPasarelaRepository, useClass: MovimientoPasarelaRepositoryImpl },
  CrucePasarelaStore,
  ObtenerCrucePasarelaUseCase,
  ObtenerMovimientoPasarelaUseCase,
  CrucePasarelaFacade,
  CrucePasarelaFeedbackEffects,

  // ── Cuentas por Pagar (Reportes) ────────────────────────────────────────────
  { provide: ICuentaPagarRepository, useClass: CuentaPagarRepositoryImpl },
  CuentaPagarStore,
  ObtenerCuentaPagarUseCase,
  CuentaPagarFacade,
  CuentaPagarFeedbackEffects,

  // ── Reporte Tesorería ────────────────────────────────────────────────────────
  { provide: IReporteTesoreriaRepository, useClass: ReporteTesoreriaRepositoryImpl },
  ReporteTesoreriaStore,
  ObtenerReporteTesoreriaUseCase,
  ReporteTesoreriaFacade,
  ReporteTesoreriaFeedbackEffects,

  // ── Documentos por Cobrar (Clientes) ───────────────────────────────────────
  { provide: IDocumentoClienteRepository, useClass: DocumentoClienteRepositoryImpl },
  DocumentoClienteStore,
  ObtenerDocumentoClienteUseCase,
  DocumentoClienteFacade,
  DocumentoClienteFeedbackEffects,

  // ── Obligaciones por Vencer ─────────────────────────────────────────────────
  { provide: IObligacionVencerRepository, useClass: ObligacionVencerRepositoryImpl },
  ObligacionVencerStore,
  ObtenerObligacionVencerUseCase,
  ObligacionVencerFacade,
  ObligacionVencerFeedbackEffects,

  // ── Reporte Finanzas ───────────────────────────────────────────────────────────────
  { provide: IReporteFinanzasRepository, useClass: ReporteFinanzasRepositoryImpl },
  ReporteFinanzasStore,
  ObtenerReporteFinanzasUseCase,
  ReporteFinanzasFacade,
  ReporteFinanzasFeedbackEffects,

  // ── Proveedor (desde módulo Compras) ────────────────────────────────────────
  { provide: IProveedorRepository, useClass: ProveedorRepositoryImpl },
  ProveedorStore,
  ObtenerProveedoresUseCase,
  GuardarProveedorUseCase,
  ActualizarProveedorUseCase,
  EliminarProveedorUseCase,
  ProveedorFacade,

   // ── Tipo de documento ───────────────────────────────
  { provide: ITipoDocumentoRepository, useClass: TipoDocumentoRepositoryImpl },
  TipoDocumentoStore,
  ActualizarTipoDocumentoUseCase,
  ObtenerTiposDocumentoUseCase,
  GuardarTipoDocumentoUseCase,
  EliminarTipoDocumentoUseCase,
  TipoDocumentoFacade,
  { provide: ISunatTipoDocumentoRepository , useClass: SunatTipoDocumentoRepositoryImpl },
  SunatTipoDocumentoStore,
  ObtenerSunatTiposDocumentoUseCase,
  SunatTipoDocumentoFacade,

  // ── Matriz Contable (desde módulo Activos) ───────────────────────────────
    { provide: IMatrizContableRepository, useClass: MatrizContableRepositoryImpl },
    MatrizContableFacade,
    MatrizContableStore,
    ObtenerMatrizContableUseCase,
    ActualizarMatrizContableUseCase,
    GuardarMatrizContableUseCase,
    EliminarMatrizContableUseCase,
];
