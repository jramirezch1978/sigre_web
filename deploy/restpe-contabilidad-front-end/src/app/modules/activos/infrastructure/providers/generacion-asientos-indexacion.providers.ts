import { Provider } from '@angular/core';
import { IGeneracionAsientosIndexacionRepository } from '../../domain/repositories/igeneracion-asientos-indexacion.repository';
import { GeneracionAsientosIndexacionRepositoryImpl } from '../repository/generacion-asientos-indexacion.repository.impl';
import { GeneracionAsientosIndexacionStore } from '../../store/generacion-asientos-indexacion.store';
import { ObtenerGeneracionAsientosIndexacionUseCase } from '../../application/usecases/obtener-generacion-asientos-indexacion.usecase';
import { GuardarGeneracionAsientosIndexacionUseCase } from '../../application/usecases/guardar-generacion-asientos-indexacion.usecase';
import { ActualizarGeneracionAsientosIndexacionUseCase } from '../../application/usecases/actualizar-generacion-asientos-indexacion.usecase';
import { EliminarGeneracionAsientosIndexacionUseCase } from '../../application/usecases/eliminar-generacion-asientos-indexacion.usecase';
import { GeneracionAsientosIndexacionFacade } from '../../application/facades/generacion-asientos-indexacion.facade';
import { GeneracionAsientosIndexacionFeedbackEffects } from '../../effects/generacion-asientos-indexacion-feedback.effect';
import { GeneracionAsientosIndexacionSyncEffects } from '../../effects/generacion-asientos-indexacion-sync.effect';

export const GENERACION_ASIENTOS_INDEXACION_PROVIDERS: Provider[] = [
  { provide: IGeneracionAsientosIndexacionRepository, useClass: GeneracionAsientosIndexacionRepositoryImpl },
  GeneracionAsientosIndexacionStore,
  ObtenerGeneracionAsientosIndexacionUseCase,
  GuardarGeneracionAsientosIndexacionUseCase,
  ActualizarGeneracionAsientosIndexacionUseCase,
  EliminarGeneracionAsientosIndexacionUseCase,
  GeneracionAsientosIndexacionFacade,
  GeneracionAsientosIndexacionFeedbackEffects,
  GeneracionAsientosIndexacionSyncEffects,
];
