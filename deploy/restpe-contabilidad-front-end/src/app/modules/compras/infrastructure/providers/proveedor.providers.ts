import { Provider } from '@angular/core';
import { IProveedorRepository } from '../../domain/repositories/iproveedor.repository';
import { ICondicionPagoRepository } from '../../domain/repositories/icondicion-pago.repository';
import { IOrdenCompraRepository } from '../../domain/repositories/iorden-compra.repository';
import { IOrdenServicioRepository } from '../../domain/repositories/iorden-servicio.repository';
import { ProveedorRepositoryImpl } from '../repository/proveedores.repository.impl';
import { CondicionPagoRepositoryImpl } from '../repository/condiciones-pago.repository.impl';
import { OrdenesCompraRepositoryImpl } from '../repositories/ordenes-de-compra.repository.impl';
import { OrdenesServicioRepositoryImpl } from '../repositories/ordenes-de-servicio.repository.impl';
import { ProveedorStore } from '../../store/proveedor.store';
import { CondicionPagoStore } from '../../store/condicion-pago.store';
import { OrdenCompraStore } from '../../stores/orden-compra.store';
import { OrdenServicioStore } from '../../stores/orden-servicio.store';
import { ProveedorFacade } from '../../application/facades/proveedor.facade';
import { CondicionPagoFacade } from '../../application/facades/condicion-pago.facade';
import { OrdenCompraFacade } from '../../application/facades/orden-compra.facade';
import { OrdenServicioFacade } from '../../application/facades/orden-servicio.facade';
import { CotizacionStore } from '../../stores/cotizacion.store';
import { CotizacionFacade } from '../../application/facades/cotizacion.facade';
import { ObtenerProveedoresUseCase } from '../../application/usecases/obtener-proveedores.usecase';
import { GuardarProveedorUseCase } from '../../application/usecases/guardar-proveedor.usecase';
import { ActualizarProveedorUseCase } from '../../application/usecases/actualizar-proveedor.usecase';
import { EliminarProveedorUseCase } from '../../application/usecases/eliminar-proveedor.usecase';
import { ObtenerCondicionesPagoUseCase } from '../../application/usecases/obtener-condiciones-pago.usecase';
import { GuardarCondicionPagoUseCase } from '../../application/usecases/guardar-condicion-pago.usecase';
import { ActualizarCondicionPagoUseCase } from '../../application/usecases/actualizar-condicion-pago.usecase';
import { EliminarCondicionPagoUseCase } from '../../application/usecases/eliminar-condicion-pago.usecase';
import { ObtenerOrdenesCompraUseCase } from '../../application/use-cases/orden-compra/obtener-ordenes-compra.usecase';
import { GuardarOrdenCompraUseCase } from '../../application/use-cases/orden-compra/guardar-orden-compra.usecase';
import { ActualizarOrdenCompraUseCase } from '../../application/use-cases/orden-compra/actualizar-orden-compra.usecase';
import { EliminarOrdenCompraUseCase } from '../../application/use-cases/orden-compra/eliminar-orden-compra.usecase';
import { ObtenerOrdenesServicioUseCase } from '../../application/use-cases/orden-servicio/obtener-ordenes-servicio.usecase';
import { GuardarOrdenServicioUseCase } from '../../application/use-cases/orden-servicio/guardar-orden-servicio.usecase';
import { ActualizarOrdenServicioUseCase } from '../../application/use-cases/orden-servicio/actualizar-orden-servicio.usecase';
import { EliminarOrdenServicioUseCase } from '../../application/use-cases/orden-servicio/eliminar-orden-servicio.usecase';
import { ProveedorFeedbackEffects } from '../../effects/proveedor-feedback.effect';
import { ProveedorSyncEffects } from '../../effects/proveedor-sync.effect';
import { CondicionPagoFeedbackEffects } from '../../effects/condicion-pago-feedback.effect';
import { CondicionPagoSyncEffects } from '../../effects/condicion-pago-sync.effect';
import { OrdenCompraFeedbackEffects } from '../../effects/orden-compra-feedback.effect';
import { OrdenCompraSyncEffects } from '../../effects/orden-compra-sync.effect';
import { OrdenServicioFeedbackEffects } from '../../effects/orden-servicio-feedback.effect';
import { OrdenServicioSyncEffects } from '../../effects/orden-servicio-sync.effect';
import { IAprovisionamientoRepository } from '../../domain/repositories/iaprovisionamiento.repository';
import { AprovisionamientoRepositoryImpl } from '../repository/aprovisionamiento.repository.impl';
import { AprovisionamientoStore } from '../../stores/aprovisionamiento.store';
import { AprovisionamientoFacade } from '../../application/facades/aprovisionamiento.facade';
import { ObtenerPlanesAbastecimientoUseCase } from '../../application/use-cases/aprovisionamiento/obtener-planes-abastecimiento.usecase';
import { GuardarPlanAbastecimientoUseCase } from '../../application/use-cases/aprovisionamiento/guardar-plan-abastecimiento.usecase';
import { ActualizarPlanAbastecimientoUseCase } from '../../application/use-cases/aprovisionamiento/actualizar-plan-abastecimiento.usecase';
import { EliminarPlanAbastecimientoUseCase } from '../../application/use-cases/aprovisionamiento/eliminar-plan-abastecimiento.usecase';
import { AprovisionamientoFeedbackEffects } from '../../effects/aprovisionamiento-feedback.effect';
import { AprovisionamientoSyncEffects } from '../../effects/aprovisionamiento-sync.effect';
import { IFacturaNoCompraRepository } from '../../domain/repositories/ifactura-no-compra.repository';
import { FacturaNoComprasRepositoryImpl } from '../repository/factura-no-compras.repository.impl';
import { FacturaNoCompraStore } from '../../stores/factura-no-compra.store';
import { FacturaNoCompraFacade } from '../../application/facades/factura-no-compra.facade';
import { ObtenerFacturasNoCompraUseCase } from '../../application/use-cases/factura-no-compra/obtener-facturas-no-compra.usecase';
import { GuardarFacturaNoCompraUseCase } from '../../application/use-cases/factura-no-compra/guardar-factura-no-compra.usecase';
import { ActualizarFacturaNoCompraUseCase } from '../../application/use-cases/factura-no-compra/actualizar-factura-no-compra.usecase';
import { EliminarFacturaNoCompraUseCase } from '../../application/use-cases/factura-no-compra/eliminar-factura-no-compra.usecase';
import { FacturaNoCompraFeedbackEffects } from '../../effects/factura-no-compra-feedback.effect';
import { FacturaNoCompraSyncEffects } from '../../effects/factura-no-compra-sync.effect';
import { INotaCreditoRepository } from '../../domain/repositories/inota-credito.repository';
import { NotaCreditoRepositoryImpl } from '../repository/nota-credito.repository.impl';
import { NotaCreditoStore } from '../../stores/nota-credito.store';
import { NotaCreditoFacade } from '../../application/facades/nota-credito.facade';
import { ObtenerNotasCreditoUseCase } from '../../application/use-cases/nota-credito/obtener-notas-credito.usecase';
import { GuardarNotaCreditoUseCase } from '../../application/use-cases/nota-credito/guardar-nota-credito.usecase';
import { ActualizarNotaCreditoUseCase } from '../../application/use-cases/nota-credito/actualizar-nota-credito.usecase';
import { EliminarNotaCreditoUseCase } from '../../application/use-cases/nota-credito/eliminar-nota-credito.usecase';
import { NotaCreditoFeedbackEffects } from '../../effects/nota-credito-feedback.effect';
import { NotaCreditoSyncEffects } from '../../effects/nota-credito-sync.effect';
import { IFacturaProveedorRepository } from '../../domain/repositories/ifactura-proveedor.repository';
import { FacturaProveedorRepositoryImpl } from '../repository/factura-proveedor.repository.impl';
import { FacturaProveedorStore } from '../../stores/factura-proveedor.store';
import { FacturaProveedorFacade } from '../../application/facades/factura-proveedor.facade';
import { ObtenerFacturasProveedorUseCase } from '../../application/use-cases/factura-proveedor/obtener-facturas-proveedor.usecase';
import { GuardarFacturaProveedorUseCase } from '../../application/use-cases/factura-proveedor/guardar-factura-proveedor.usecase';
import { ActualizarFacturaProveedorUseCase } from '../../application/use-cases/factura-proveedor/actualizar-factura-proveedor.usecase';
import { EliminarFacturaProveedorUseCase } from '../../application/use-cases/factura-proveedor/eliminar-factura-proveedor.usecase';
import { FacturaProveedorFeedbackEffects } from '../../effects/factura-proveedor-feedback.effect';
import { FacturaProveedorSyncEffects } from '../../effects/factura-proveedor-sync.effect';
import { IAprobarCompraRepository } from '../../domain/repositories/iaprobar-compra.repository';
import { AprobarCompraRepositoryImpl } from '../repository/aprobar-compra.repository.impl';
import { AprobarCompraStore } from '../../stores/aprobar-compra.store';
import { AprobarCompraFacade } from '../../application/facades/aprobar-compra.facade';
import { ObtenerOrdenesPendientesUseCase } from '../../application/use-cases/aprobar-compra/obtener-ordenes-pendientes.usecase';
import { AprobarOrdenUseCase } from '../../application/use-cases/aprobar-compra/aprobar-orden.usecase';
import { RechazarOrdenUseCase } from '../../application/use-cases/aprobar-compra/rechazar-orden.usecase';
import { RetornarOrdenUseCase } from '../../application/use-cases/aprobar-compra/retornar-orden.usecase';
import { AprobarOrdenesMasivoUseCase } from '../../application/use-cases/aprobar-compra/aprobar-ordenes-masivo.usecase';
import { AprobarCompraFeedbackEffects } from '../../effects/aprobar-compra-feedback.effect';
import { AprobarCompraSyncEffects } from '../../effects/aprobar-compra-sync.effect';
import { IAprobarServicioRepository } from '../../domain/repositories/iaprobar-servicio.repository';
import { AprobarServicioRepositoryImpl } from '../repository/aprobar-servicio.repository.impl';
import { AprobarServicioStore } from '../../stores/aprobar-servicio.store';
import { AprobarServicioFacade } from '../../application/facades/aprobar-servicio.facade';
import { ObtenerOrdenesServicioPendientesUseCase } from '../../application/use-cases/aprobar-servicio/obtener-ordenes-servicio-pendientes.usecase';
import { AprobarOrdenServicioUseCase } from '../../application/use-cases/aprobar-servicio/aprobar-orden-servicio.usecase';
import { RechazarOrdenServicioUseCase } from '../../application/use-cases/aprobar-servicio/rechazar-orden-servicio.usecase';
import { RetornarOrdenServicioUseCase } from '../../application/use-cases/aprobar-servicio/retornar-orden-servicio.usecase';
import { AprobarOrdenesServicioMasivoUseCase } from '../../application/use-cases/aprobar-servicio/aprobar-ordenes-servicio-masivo.usecase';
import { AprobarServicioFeedbackEffects } from '../../effects/aprobar-servicio-feedback.effect';
import { AprobarServicioSyncEffects } from '../../effects/aprobar-servicio-sync.effect';
import { IReporteComprasIngresarRepository } from '../../domain/repositories/ireporte-compras-ingresar.repository';
import { ReporteComprasIngresarRepositoryImpl } from '../repository/reporte-compras-ingresar.impl';
import { ReporteComprasIngresarStore } from '../../stores/reporte-compras-ingresar.store';
import { ObtenerReporteComprasIngresarUseCase } from '../../application/use-cases/reporte-compras-ingresar/obtener-reporte-compras-ingresar.usecase';
import { ReporteComprasIngresarFacade } from '../../application/facades/reporte-compras-ingresar.facade';
import { IReporteComprasTransitoRepository } from '../../domain/repositories/ireporte-compras-transito.repository';
import { ReporteComprasTransitoRepositoryImpl } from '../repository/reporte-compras-transito.impl';
import { ReporteComprasTransitoStore } from '../../stores/reporte-compras-transito.store';
import { ObtenerReporteComprasTransitoUseCase } from '../../application/use-cases/reporte-compras-transito/obtener-reporte-compras-transito.usecase';
import { ReporteComprasTransitoFacade } from '../../application/facades/reporte-compras-transito.facade';
import { IReporteComprasRepository } from '../../domain/repositories/ireporte-compras.repository';
import { ReporteComprasRepositoryImpl } from '../repository/reporte-compras.impl';
import { ReporteComprasStore } from '../../stores/reporte-compras.store';
import { ObtenerReporteComprasUseCase } from '../../application/use-cases/reporte-compras/obtener-reporte-compras.usecase';
import { ReporteComprasFacade } from '../../application/facades/reporte-compras.facade';
import { IReporteComprasSugeridasRepository } from '../../domain/repositories/ireporte-compras-sugeridas.repository';
import { ReporteComprasSugeridasRepositoryImpl } from '../repository/reporte-compras-sugeridas.impl';
import { ReporteComprasSugeridasStore } from '../../stores/reporte-compras-sugeridas.store';
import { ObtenerReporteComprasSugeridasUseCase } from '../../application/use-cases/reporte-compras-sugeridas/obtener-reporte-compras-sugeridas.usecase';
import { ReporteComprasSugeridasFacade } from '../../application/facades/reporte-compras-sugeridas.facade';
import { IReporteComprasCategoriaRepository } from '../../domain/repositories/ireporte-compras-categoria.repository';
import { ReporteComprasCategoriaRepositoryImpl } from '../repository/reporte-compras-categoria.impl';
import { ReporteComprasCategoriaStore } from '../../stores/reporte-compras-categoria.store';
import { ObtenerReporteComprasCategoriaUseCase } from '../../application/use-cases/reporte-compras-categoria/obtener-reporte-compras-categoria.usecase';
import { ReporteComprasCategoriaFacade } from '../../application/facades/reporte-compras-categoria.facade';
import { IReporteComprasGestionComprasRepository } from '../../domain/repositories/ireporte-compras-gestion-compras.repository';
import { ReporteComprasGestionComprasRepositoryImpl } from '../repository/reporte-compras-gestion-compras.impl';
import { ReporteComprasGestionComprasStore } from '../../stores/reporte-compras-gestion-compras.store';
import { ObtenerReporteComprasGestionComprasUseCase } from '../../application/use-cases/reporte-compras-gestion-compras/obtener-reporte-compras-gestion-compras.usecase';
import { ReporteComprasGestionComprasFacade } from '../../application/facades/reporte-compras-gestion-compras.facade';
import { IReporteAnalisisProveedoresRepository } from '../../domain/repositories/ireporte-analisis-proveedores.repository';
import { ReporteAnalisisProveedoresRepositoryImpl } from '../repository/reporte-analisis-proveedores.impl';
import { ReporteAnalisisProveedoresStore } from '../../stores/reporte-analisis-proveedores.store';
import { ObtenerReporteAnalisisProveedoresUseCase } from '../../application/use-cases/reporte-analisis-proveedores/obtener-reporte-analisis-proveedores.usecase';
import { ReporteAnalisisProveedoresFacade } from '../../application/facades/reporte-analisis-proveedores.facade';
import { IDocumentoDirectoRepository } from '../../domain/repositories/idocumento-directo.repository';
import { DocumentoDirectoRepositoryImpl } from '../repository/documento-directo.repository.impl';
import { DocumentoDirectoFacade } from '../../application/facades/documento-directo.facade';
import { IActaConformidadRepository } from '../../domain/repositories/iacta-conformidad.repository';
import { ActaConformidadRepositoryImpl } from '../repository/acta-conformidad.repository.impl';
import { ActaConformidadFacade } from '../../application/facades/acta-conformidad.facade';
import { ICotizacionRepository } from '@modules/compras/domain/repositories/icotizacion.repository';
import { CotizacionRepositoryImpl } from '../repository/cotizacion.repository.impl';
import { ObtenerCotizacionesUseCase } from '@modules/compras/application/use-cases/cotizacion/obtener-cotizaciones.usecase';
import { GuardarCotizacionUseCase } from '@modules/compras/application/use-cases/cotizacion/guardar-cotizacion.usecase';

export const PROVEEDOR_PROVIDERS: Provider[] = [
  // Repositories
  {
    provide: IProveedorRepository,
    useClass: ProveedorRepositoryImpl
  },
  {
    provide: ICondicionPagoRepository,
    useClass: CondicionPagoRepositoryImpl
  },
  {
    provide: IOrdenCompraRepository,
    useClass: OrdenesCompraRepositoryImpl
  },
  {
    provide: IOrdenServicioRepository,
    useClass: OrdenesServicioRepositoryImpl
  },
  {
    provide: IAprovisionamientoRepository,
    useClass: AprovisionamientoRepositoryImpl
  },
  {
    provide: IFacturaNoCompraRepository,
    useClass: FacturaNoComprasRepositoryImpl
  },
  {
    provide: INotaCreditoRepository,
    useClass: NotaCreditoRepositoryImpl
  },
  {
    provide: IFacturaProveedorRepository,
    useClass: FacturaProveedorRepositoryImpl
  },
  {
    provide: IAprobarCompraRepository,
    useClass: AprobarCompraRepositoryImpl
  },
  {
    provide: IAprobarServicioRepository,
    useClass: AprobarServicioRepositoryImpl
  },
  {
    provide: IReporteComprasIngresarRepository,
    useClass: ReporteComprasIngresarRepositoryImpl
  },
  {
    provide: IReporteComprasTransitoRepository,
    useClass: ReporteComprasTransitoRepositoryImpl
  },
  {
    provide: IReporteComprasRepository,
    useClass: ReporteComprasRepositoryImpl
  },
  {
    provide: IReporteComprasSugeridasRepository,
    useClass: ReporteComprasSugeridasRepositoryImpl
  },
  {
    provide: IReporteComprasCategoriaRepository,
    useClass: ReporteComprasCategoriaRepositoryImpl
  },
  {
    provide: IReporteComprasGestionComprasRepository,
    useClass: ReporteComprasGestionComprasRepositoryImpl
  },
  {
    provide: IReporteAnalisisProveedoresRepository,
    useClass: ReporteAnalisisProveedoresRepositoryImpl
  },
  {
    provide: IDocumentoDirectoRepository,
    useClass: DocumentoDirectoRepositoryImpl
  },
  {
    provide: IActaConformidadRepository,
    useClass: ActaConformidadRepositoryImpl
  },
  {
    provide: ICotizacionRepository,
    useClass: CotizacionRepositoryImpl
  },
  // Stores
  ProveedorStore,
  CondicionPagoStore,
  OrdenCompraStore,
  OrdenServicioStore,
  CotizacionStore,
  AprovisionamientoStore,
  FacturaNoCompraStore,
  NotaCreditoStore,
  FacturaProveedorStore,
  AprobarCompraStore,
  AprobarServicioStore,
  ReporteComprasIngresarStore,
  ReporteComprasTransitoStore,
  ReporteComprasStore,
  ReporteComprasSugeridasStore,
  ReporteComprasCategoriaStore,
  ReporteComprasGestionComprasStore,
  ReporteAnalisisProveedoresStore,
  // Use Cases - Proveedores
  ObtenerProveedoresUseCase,
  GuardarProveedorUseCase,
  ActualizarProveedorUseCase,
  EliminarProveedorUseCase,
  // Use Cases - Condiciones de Pago
  ObtenerCondicionesPagoUseCase,
  GuardarCondicionPagoUseCase,
  ActualizarCondicionPagoUseCase,
  EliminarCondicionPagoUseCase,
  // Use Cases - Órdenes de Compra
  ObtenerOrdenesCompraUseCase,
  GuardarOrdenCompraUseCase,
  ActualizarOrdenCompraUseCase,
  EliminarOrdenCompraUseCase,
  // Use Cases - Órdenes de Servicio
  ObtenerOrdenesServicioUseCase,
  GuardarOrdenServicioUseCase,
  ActualizarOrdenServicioUseCase,
  EliminarOrdenServicioUseCase,
  // Use Cases - Aprovisionamiento
  ObtenerPlanesAbastecimientoUseCase,
  GuardarPlanAbastecimientoUseCase,
  ActualizarPlanAbastecimientoUseCase,
  EliminarPlanAbastecimientoUseCase,
  // Use Cases - Factura No Compra
  ObtenerFacturasNoCompraUseCase,
  GuardarFacturaNoCompraUseCase,
  ActualizarFacturaNoCompraUseCase,
  EliminarFacturaNoCompraUseCase,
  // Use Cases - Notas de Crédito/Débito
  ObtenerNotasCreditoUseCase,
  GuardarNotaCreditoUseCase,
  ActualizarNotaCreditoUseCase,
  EliminarNotaCreditoUseCase,
  // Use Cases - Facturas de Proveedor
  ObtenerFacturasProveedorUseCase,
  GuardarFacturaProveedorUseCase,
  ActualizarFacturaProveedorUseCase,
  EliminarFacturaProveedorUseCase,
  // Use Cases - Aprobación de Compras
  ObtenerOrdenesPendientesUseCase,
  AprobarOrdenUseCase,
  RechazarOrdenUseCase,
  RetornarOrdenUseCase,
  AprobarOrdenesMasivoUseCase,
  // Use Cases - Aprobación de Servicios
  ObtenerOrdenesServicioPendientesUseCase,
  AprobarOrdenServicioUseCase,
  RechazarOrdenServicioUseCase,
  RetornarOrdenServicioUseCase,
  AprobarOrdenesServicioMasivoUseCase,
  // Use Cases - Reporte Compras por Ingresar
  ObtenerReporteComprasIngresarUseCase,
  // Use Cases - Reporte Compras en Tránsito
  ObtenerReporteComprasTransitoUseCase,
  // Use Cases - Reporte de Compras
  ObtenerReporteComprasUseCase,
  // Use Cases - Reporte Compras Sugeridas
  ObtenerReporteComprasSugeridasUseCase,
  // Use Cases - Reporte Compras por Categoría
  ObtenerReporteComprasCategoriaUseCase,
  // Use Cases - Reporte Gestión de Compras
  ObtenerReporteComprasGestionComprasUseCase,
  // Use Cases - Reporte Análisis de Proveedores
  ObtenerReporteAnalisisProveedoresUseCase,
  // Use Cases - Cotizaciones
  ObtenerCotizacionesUseCase,
  GuardarCotizacionUseCase,
  // Facades
  ProveedorFacade,
  CondicionPagoFacade,
  OrdenCompraFacade,
  OrdenServicioFacade,
  CotizacionFacade,
  AprovisionamientoFacade,
  FacturaNoCompraFacade,
  NotaCreditoFacade,
  FacturaProveedorFacade,
  AprobarCompraFacade,
  AprobarServicioFacade,
  ReporteComprasIngresarFacade,
  ReporteComprasTransitoFacade,
  ReporteComprasFacade,
  ReporteComprasSugeridasFacade,
  ReporteComprasCategoriaFacade,
  ReporteComprasGestionComprasFacade,
  ReporteAnalisisProveedoresFacade,
  DocumentoDirectoFacade,
  ActaConformidadFacade,
  // Effects - Proveedores
  ProveedorFeedbackEffects,
  ProveedorSyncEffects,
  // Effects - Condiciones de Pago
  CondicionPagoFeedbackEffects,
  CondicionPagoSyncEffects,
  // Effects - Órdenes de Compra
  OrdenCompraFeedbackEffects,
  OrdenCompraSyncEffects,
  // Effects - Órdenes de Servicio
  OrdenServicioFeedbackEffects,
  OrdenServicioSyncEffects,
  // Effects - Aprovisionamiento
  AprovisionamientoFeedbackEffects,
  AprovisionamientoSyncEffects,
  // Effects - Factura No Compra
  FacturaNoCompraFeedbackEffects,
  FacturaNoCompraSyncEffects,
  // Effects - Notas de Crédito/Débito
  NotaCreditoFeedbackEffects,
  NotaCreditoSyncEffects,
  // Effects - Facturas de Proveedor
  FacturaProveedorFeedbackEffects,
  FacturaProveedorSyncEffects,
  // Effects - Aprobación de Compras
  AprobarCompraFeedbackEffects,
  AprobarCompraSyncEffects,
  // Effects - Aprobación de Servicios
  AprobarServicioFeedbackEffects,
  AprobarServicioSyncEffects
];
