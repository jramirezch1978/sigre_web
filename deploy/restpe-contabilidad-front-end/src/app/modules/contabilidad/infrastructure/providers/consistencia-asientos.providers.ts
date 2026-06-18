import { Provider } from '@angular/core';
import { IConsistenciaAsientosRepository } from '../../domain/repositories/iconsistencia-asientos.repository';
import { ConsistenciaAsientosRepositoryImpl } from '../repository/consistencia-asientos.impl';
import { ConsistenciaAsientosStore } from '../../store/consistencia-asientos.store';
import { ConsistenciaAsientosFacade } from '../../application/facades/consistencia-asientos.facade';
import { ObtenerConsistenciaAsientosUseCase } from '../../application/usecases/obtener-consistencia-asientos.usecase';
import { ConsistenciaAsientosFeedbackEffects } from '../../effects/consistencia-asientos-feedback.effect';

export const CONSISTENCIA_ASIENTOS_PROVIDERS: Provider[] = [
  { provide: IConsistenciaAsientosRepository, useClass: ConsistenciaAsientosRepositoryImpl },
  ConsistenciaAsientosStore,
  ConsistenciaAsientosFacade,
  ObtenerConsistenciaAsientosUseCase,
  ConsistenciaAsientosFeedbackEffects,
];
