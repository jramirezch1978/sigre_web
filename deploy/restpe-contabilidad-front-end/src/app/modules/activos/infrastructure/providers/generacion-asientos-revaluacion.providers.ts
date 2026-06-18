import { Provider } from '@angular/core';
import { IGeneracionAsientosRevaluacionRepository } from '../../domain/repositories/igeneracion-asientos-revaluacion.repository';
import { GeneracionAsientosRevaluacionRepositoryImpl } from '../repository/generacion-asientos-revaluacion.repository.impl';
import { GeneracionAsientosRevaluacionStore } from '../../store/generacion-asientos-revaluacion.store';
import { ObtenerGeneracionAsientosRevaluacionUseCase } from '../../application/usecases/obtener-generacion-asientos-revaluacion.usecase';
import { GuardarGeneracionAsientosRevaluacionUseCase } from '../../application/usecases/guardar-generacion-asientos-revaluacion.usecase';
import { ActualizarGeneracionAsientosRevaluacionUseCase } from '../../application/usecases/actualizar-generacion-asientos-revaluacion.usecase';
import { EliminarGeneracionAsientosRevaluacionUseCase } from '../../application/usecases/eliminar-generacion-asientos-revaluacion.usecase';
import { GeneracionAsientosRevaluacionFacade } from '../../application/facades/generacion-asientos-revaluacion.facade';
import { GeneracionAsientosRevaluacionFeedbackEffects } from '../../effects/generacion-asientos-revaluacion-feedback.effect';
import { GeneracionAsientosRevaluacionSyncEffects } from '../../effects/generacion-asientos-revaluacion-sync.effect';

export const GENERACION_ASIENTOS_REVALUACION_PROVIDERS: Provider[] = [
  { provide: IGeneracionAsientosRevaluacionRepository, useClass: GeneracionAsientosRevaluacionRepositoryImpl },
  GeneracionAsientosRevaluacionStore,
  ObtenerGeneracionAsientosRevaluacionUseCase,
  GuardarGeneracionAsientosRevaluacionUseCase,
  ActualizarGeneracionAsientosRevaluacionUseCase,
  EliminarGeneracionAsientosRevaluacionUseCase,
  GeneracionAsientosRevaluacionFacade,
  GeneracionAsientosRevaluacionFeedbackEffects,
  GeneracionAsientosRevaluacionSyncEffects,
];
