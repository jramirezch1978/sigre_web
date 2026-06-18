import { Provider } from '@angular/core';
import { IRevaluacionRepository } from '../../domain/repositories/irevaluacion.repository';
import { RevaluacionRepositoryImpl } from '../repository/reportes.repository.impl';
import { RevaluacionStore } from '../../store/revaluacion.store';
import { ObtenerRevaluacionesUseCase } from '../../application/usecases/obtener-revaluaciones.usecase';
import { RevaluacionFacade } from '../../application/facades/revaluacion.facade';

export const REVALUACION_PROVIDERS: Provider[] = [
  { provide: IRevaluacionRepository, useClass: RevaluacionRepositoryImpl },
  RevaluacionStore,
  ObtenerRevaluacionesUseCase,
  RevaluacionFacade,
];
