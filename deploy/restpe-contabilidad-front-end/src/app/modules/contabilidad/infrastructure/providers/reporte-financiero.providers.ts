import { Provider } from '@angular/core';
import { IReporteFinancieroRepository } from '../../domain/repositories/ireporte-financiero.repository';
import { ReporteFinancieroRepositoryImpl } from '../repository/reporte-financiero.impl';
import { ReporteFinancieroStore } from '../../store/reporte-financiero.store';
import { ReporteFinancieroFacade } from '../../application/facades/reporte-financiero.facade';
import { ObtenerReporteFinancieroUseCase } from '../../application/usecases/obtener-reporte-financiero.usecase';
import { ReporteFinancieroFeedbackEffects } from '../../effects/reporte-financiero-feedback.effect';

export const REPORTE_FINANCIERO_PROVIDERS: Provider[] = [
  { provide: IReporteFinancieroRepository, useClass: ReporteFinancieroRepositoryImpl },
  ReporteFinancieroStore,
  ReporteFinancieroFacade,
  ObtenerReporteFinancieroUseCase,
  ReporteFinancieroFeedbackEffects,
];
