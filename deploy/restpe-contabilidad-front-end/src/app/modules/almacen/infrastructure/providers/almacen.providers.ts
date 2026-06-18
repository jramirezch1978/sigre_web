import { Provider } from '@angular/core';
import { IAlmacenRepository } from '../../domain/repositories/ialmacen.repository';
import { ICatalogosRepository } from '../../domain/repositories/icatalogos.repository';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { IConsultasRepository } from '../../domain/repositories/iconsultas.repository';
import { IOperacionesRepository } from '../../domain/repositories/ioperaciones.repository';
import { AlmacenRepositoryImpl } from '../repository/almacen.repository.impl';
import { CatalogosRepositoryImpl } from '../repository/catalogos.repository.impl';
import { ReportesRepositoryImpl } from '../repository/reportes.repository.impl';
import { ConsultasRepositoryImpl } from '../repository/consultas.repository.impl';
import { OperacionesRepositoryImpl } from '../repository/operaciones.repository.impl';
import { AlmacenStore } from '../../store/almacen.store';
import { AlmacenFacade } from '../../application/facades/almacen.facade';
import { ObtenerAlmacenesUseCase } from '../../application/usecases/obtener-almacenes.usecase';
import { ObtenerTiposAlmacenUseCase } from '../../application/usecases/obtener-tipos-almacen.usecase';
import { GuardarAlmacenUseCase } from '../../application/usecases/guardar-almacen.usecase';
import { ActualizarAlmacenUseCase } from '../../application/usecases/actualizar-almacen.usecase';
import { EliminarAlmacenUseCase } from '../../application/usecases/eliminar-almacen.usecase';
import { ObtenerCatalogosUseCase } from '../../application/usecases/obtener-catalogos.usecase';
import { ObtenerTransferenciasUseCase } from '../../application/usecases/obtener-transferencias.usecase';
import { ObtenerComparacionesInventarioUseCase } from '../../application/usecases/obtener-comparaciones-inventario.usecase';
import { ObtenerReporteTomasUseCase } from '../../application/usecases/obtener-reporte-tomas.usecase';
import { ObtenerReporteValorizacionUseCase } from '../../application/usecases/obtener-reporte-valorizacion.usecase';
import { ObtenerReporteVendidosUseCase } from '../../application/usecases/obtener-reporte-vendidos.usecase';
import { ObtenerReporteStockMinimoUseCase } from '../../application/usecases/obtener-reporte-stock-minimo.usecase';
import { ObtenerReporteStockFechaUseCase } from '../../application/usecases/obtener-reporte-stock-fecha.usecase';
import { ObtenerReporteHistorialVencimientoUseCase } from '../../application/usecases/obtener-reporte-historial-vencimiento.usecase';
import { ObtenerReporteDiagnosticoAlmacenesUseCase } from '../../application/usecases/obtener-reporte-diagnostico-almacenes.usecase';
import { ObtenerConsultaArticulosUseCase } from '../../application/usecases/obtener-consulta-articulos.usecase';
import { ObtenerConsultaOrdenesCompraUseCase } from '../../application/usecases/obtener-consulta-ordenes-compra.usecase';
import { ObtenerConsultaDevolucionesUseCase } from '../../application/usecases/obtener-consulta-devoluciones.usecase';
import { ObtenerConsultaKardexUseCase } from '../../application/usecases/obtener-consulta-kardex.usecase';
import { ObtenerConsultaPrestamosUseCase } from '../../application/usecases/obtener-consulta-prestamos.usecase';
import { ObtenerRecepcionesAlmacenamientoUseCase } from '../../application/usecases/obtener-recepciones-almacenamiento.usecase';
import { ObtenerDespachosUseCase } from '../../application/usecases/obtener-despachos.usecase';
import { ObtenerGestionesDevolucionUseCase } from '../../application/usecases/obtener-gestiones-devolucion.usecase';
import { ObtenerRecepcionesTransferenciaUseCase } from '../../application/usecases/obtener-recepciones-transferencia.usecase';
import { ObtenerRegistroPerdidasUseCase } from '../../application/usecases/obtener-registro-perdidas.usecase';
import { ObtenerProductosAlmacenUseCase } from '../../application/usecases/obtener-productos-almacen.usecase';
import { ObtenerReposicionesStockUseCase } from '../../application/usecases/obtener-reposiciones-stock.usecase';
import { ObtenerProductosReposicionStockUseCase } from '../../application/usecases/obtener-productos-reposicion-stock.usecase';
import { ObtenerRecalculoPreciosUC } from '../../application/usecases/obtener-recalculo-precios.usecase';
import { ObtenerClasificacionArticulosUseCase } from '../../application/usecases/obtener-clasificacion-articulos.usecase';
import { ObtenerMaestroProductosUseCase } from '../../application/usecases/obtener-maestro-productos.usecase';
import { ObtenerMovAlmacenesUseCase } from '../../application/usecases/obtener-mov-almacenes.usecase';
import { DescargarMovimientoPdfUseCase } from '../../application/usecases/descargar-movimiento-pdf.usecase';
import { ObtenerReqTrasladosUseCase } from '../../application/usecases/obtener-req-traslados.usecase';
import { ObtenerCuadreStockUC } from '../../application/usecases/obtener-cuadre-stock.usecase';
import { ObtenerMovimientosCuadreStockUC } from '../../application/usecases/obtener-movimientos-cuadre-stock.usecase';
import { ObtenerActualizacionProductosUC } from '../../application/usecases/obtener-actualizacion-productos.usecase';
import { AlmacenFeedbackEffects } from '../../effects/almacen-feedback.effect';
import { AlmacenSyncEffects } from '../../effects/almacen-sync.effect';
import { ObtenerMotivosTrasladoAlmacenesUseCase } from '@modules/almacen/application/usecases/obtener-motivos-traslado-almacen.usecase';
import { IAlmacenMotivoTrasladoRepository } from '@modules/almacen/domain/repositories/ialmacen-motivo-traslado.repository';
import { AlmacenMotivoTrasladoRepositoryImpl } from '../repository/almacen-motivo-traslado.repository.impl';
import { MotivoTrasladoFacade } from '@modules/almacen/application/facades/motivo-traslado.facade';
import { MotivoTrasladoStore } from '@modules/almacen/store/motivo-traslado.store';
import { GuardarAlmacenMotivoTrasladoUseCase } from '@modules/almacen/application/usecases/guardar-almacen-motivo-traslado.usecase';

export const ALMACEN_PROVIDERS: Provider[] = [
  // Repositories
  {
    provide: IAlmacenRepository,
    useClass: AlmacenRepositoryImpl
  },
  {
    provide: ICatalogosRepository,
    useClass: CatalogosRepositoryImpl
  },
  {
    provide: IReportesRepository,
    useClass: ReportesRepositoryImpl
  },
  {
    provide: IConsultasRepository,
    useClass: ConsultasRepositoryImpl
  },
  {
    provide: IOperacionesRepository,
    useClass: OperacionesRepositoryImpl
  },
  {
    provide: IAlmacenMotivoTrasladoRepository,
    useClass: AlmacenMotivoTrasladoRepositoryImpl
  },
  // Store
  AlmacenStore,
  MotivoTrasladoStore,
  // Use Cases - Almacenes
  ObtenerAlmacenesUseCase,
  ObtenerTiposAlmacenUseCase,
  GuardarAlmacenUseCase,
  ActualizarAlmacenUseCase,
  EliminarAlmacenUseCase,
  // Use Cases - Catálogos y Datos
  ObtenerCatalogosUseCase,
  ObtenerTransferenciasUseCase,
  ObtenerComparacionesInventarioUseCase,
  ObtenerReporteTomasUseCase,
  ObtenerReporteValorizacionUseCase,
  ObtenerReporteVendidosUseCase,
  ObtenerReporteStockMinimoUseCase,
  ObtenerReporteStockFechaUseCase,
  ObtenerReporteHistorialVencimientoUseCase,
  ObtenerReporteDiagnosticoAlmacenesUseCase,
  ObtenerConsultaArticulosUseCase,
  ObtenerConsultaOrdenesCompraUseCase,
  ObtenerConsultaDevolucionesUseCase,
  ObtenerConsultaKardexUseCase,
  ObtenerConsultaPrestamosUseCase,
  ObtenerRecepcionesAlmacenamientoUseCase,
  ObtenerDespachosUseCase,
  ObtenerGestionesDevolucionUseCase,
  ObtenerRecepcionesTransferenciaUseCase,
  ObtenerRegistroPerdidasUseCase,
  ObtenerProductosAlmacenUseCase,
  ObtenerReposicionesStockUseCase,
  ObtenerProductosReposicionStockUseCase,
  ObtenerRecalculoPreciosUC,
  ObtenerClasificacionArticulosUseCase,
  ObtenerMaestroProductosUseCase,
  ObtenerMovAlmacenesUseCase,
  DescargarMovimientoPdfUseCase,
  ObtenerReqTrasladosUseCase,
  ObtenerCuadreStockUC,
  ObtenerMovimientosCuadreStockUC,
  ObtenerActualizacionProductosUC,
  ObtenerMotivosTrasladoAlmacenesUseCase,
  GuardarAlmacenMotivoTrasladoUseCase,
  // Facade
  AlmacenFacade,
  MotivoTrasladoFacade,
  // Effects
  AlmacenFeedbackEffects,
  AlmacenSyncEffects
];
