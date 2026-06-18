import { Provider } from '@angular/core';

// ── Facturación de Regalías ──────────────────────────────────────────────────
import { IFacturacionRegaliasRepository } from '../../domain/repositories/ifacturacion-regalias.repository';
import { FacturacionRegaliasRepositoryImpl } from '../repository/facturacion-regalias.repository.impl';
import { FacturacionRegaliasStore } from '../../store/facturacion-regalias.store';
import { FacturacionRegaliasFacade } from '../../application/facades/facturacion-regalias.facade';
import { ObtenerFacturacionRegaliasUseCase } from '../../application/usecases/obtener-facturacion-regalias.usecase';
import { GuardarFacturacionRegaliasUseCase } from '../../application/usecases/guardar-facturacion-regalias.usecase';
import { AnularFacturacionRegaliasUseCase } from '../../application/usecases/anular-facturacion-regalias.usecase';
import { FacturacionRegaliasFeedbackEffects } from '../../effects/facturacion-regalias-feedback.effect';
import { FacturacionRegaliasSyncEffects } from '../../effects/facturacion-regalias-sync.effect';

// ── Reporte Tributario por Período ───────────────────────────────────────────
import { IReporteTributarioRepository } from '../../domain/repositories/ireporte-tributario.repository';
import { ReporteTributarioRepositoryImpl } from '../repository/reporte-tributario.repository.impl';
import { ReporteTributarioStore } from '../../store/reporte-tributario.store';
import { ReporteTributarioFacade } from '../../application/facades/reporte-tributario.facade';
import { ObtenerReporteTributarioUseCase } from '../../application/usecases/obtener-reporte-tributario.usecase';
import { ReporteTributarioFeedbackEffects } from '../../effects/reporte-tributario-feedback.effect';
import { ReporteTributarioSyncEffects } from '../../effects/reporte-tributario-sync.effect';

// ── Reporte de Ventas ────────────────────────────────────────────────────────
import { IReporteVentasRepository } from '../../domain/repositories/ireporte-ventas.repository';
import { ReporteVentasRepositoryImpl } from '../repository/reporte-ventas.repository.impl';
import { ReporteVentasStore } from '../../store/reporte-ventas.store';
import { ReporteVentasFacade } from '../../application/facades/reporte-ventas.facade';
import { ObtenerReporteVentasUseCase } from '../../application/usecases/obtener-reporte-ventas.usecase';
import { ReporteVentasFeedbackEffects } from '../../effects/reporte-ventas-feedback.effect';
import { ReporteVentasSyncEffects } from '../../effects/reporte-ventas-sync.effect';

// ── Panel de Reenvío ─────────────────────────────────────────────────────────
import { IPanelReenvioRepository } from '../../domain/repositories/ipanel-reenvio.repository';
import { PanelReenvioRepositoryImpl } from '../repository/panel-reenvio.repository.impl';
import { PanelReenvioStore } from '../../store/panel-reenvio.store';
import { PanelReenvioFacade } from '../../application/facades/panel-reenvio.facade';
import { ObtenerPanelReenvioUseCase } from '../../application/usecases/obtener-panel-reenvio.usecase';
import { PanelReenvioFeedbackEffects } from '../../effects/panel-reenvio-feedback.effect';
import { PanelReenvioSyncEffects } from '../../effects/panel-reenvio-sync.effect';

// ── Panel de Estados de Documento ────────────────────────────────────────────
import { IPanelDocumentoRepository } from '../../domain/repositories/ipanel-documento.repository';
import { PanelDocumentoRepositoryImpl } from '../repository/panel-documento.repository.impl';
import { PanelDocumentoStore } from '../../store/panel-documento.store';
import { PanelDocumentoFacade } from '../../application/facades/panel-documento.facade';
import { ObtenerPanelDocumentoUseCase } from '../../application/usecases/obtener-panel-documento.usecase';
import { PanelDocumentoFeedbackEffects } from '../../effects/panel-documento-feedback.effect';
import { PanelDocumentoSyncEffects } from '../../effects/panel-documento-sync.effect';

export const VENTAS_PROVIDERS: Provider[] = [
  // ── Facturación de Regalías ──────────────────────────────────────────────
  { provide: IFacturacionRegaliasRepository, useClass: FacturacionRegaliasRepositoryImpl },
  FacturacionRegaliasStore,
  ObtenerFacturacionRegaliasUseCase,
  GuardarFacturacionRegaliasUseCase,
  AnularFacturacionRegaliasUseCase,
  FacturacionRegaliasFacade,
  FacturacionRegaliasFeedbackEffects,
  FacturacionRegaliasSyncEffects,

  // ── Reporte Tributario por Período ────────────────────────────────────────
  { provide: IReporteTributarioRepository, useClass: ReporteTributarioRepositoryImpl },
  ReporteTributarioStore,
  ObtenerReporteTributarioUseCase,
  ReporteTributarioFacade,
  ReporteTributarioFeedbackEffects,
  ReporteTributarioSyncEffects,

  // ── Reporte de Ventas ─────────────────────────────────────────────────────
  { provide: IReporteVentasRepository, useClass: ReporteVentasRepositoryImpl },
  ReporteVentasStore,
  ObtenerReporteVentasUseCase,
  ReporteVentasFacade,
  ReporteVentasFeedbackEffects,
  ReporteVentasSyncEffects,

  // ── Panel de Reenvío ──────────────────────────────────────────────────────
  { provide: IPanelReenvioRepository, useClass: PanelReenvioRepositoryImpl },
  PanelReenvioStore,
  ObtenerPanelReenvioUseCase,
  PanelReenvioFacade,
  PanelReenvioFeedbackEffects,
  PanelReenvioSyncEffects,

  // ── Panel de Estados de Documento ────────────────────────────────────────
  { provide: IPanelDocumentoRepository, useClass: PanelDocumentoRepositoryImpl },
  PanelDocumentoStore,
  ObtenerPanelDocumentoUseCase,
  PanelDocumentoFacade,
  PanelDocumentoFeedbackEffects,
  PanelDocumentoSyncEffects,
];
