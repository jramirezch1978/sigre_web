import { Provider } from '@angular/core';
import { IReporteValidacionRepository } from '../../domain/repositories/ireporte-validacion.repository';
import { ReporteValidacionRepositoryImpl } from '../repository/reporte-validacion.impl';
import { ReporteValidacionStore } from '../../store/reporte-validacion.store';
import { ReporteValidacionFacade } from '../../application/facades/reporte-validacion.facade';
import { ObtenerReporteValidacionUseCase } from '../../application/usecases/obtener-reporte-validacion.usecase';
import { ReporteValidacionFeedbackEffects } from '../../effects/reporte-validacion-feedback.effect';

export const REPORTE_VALIDACION_PROVIDERS: Provider[] = [
  { provide: IReporteValidacionRepository, useClass: ReporteValidacionRepositoryImpl },
  ReporteValidacionStore,
  ReporteValidacionFacade,
  ObtenerReporteValidacionUseCase,
  ReporteValidacionFeedbackEffects,
];
