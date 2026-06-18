import { Provider } from '@angular/core';
import { IGeneracionAsientosSiniestroRepository } from '../../domain/repositories/igeneracion-asientos-siniestro.repository';
import { GeneracionAsientosSiniestroRepositoryImpl } from '../repository/generacion-asientos-siniestro.repository.impl';
import { GeneracionAsientosSiniestroStore } from '../../store/generacion-asientos-siniestro.store';
import { ObtenerGeneracionAsientosSiniestroUseCase } from '../../application/usecases/obtener-generacion-asientos-siniestro.usecase';
import { GuardarGeneracionAsientosSiniestroUseCase } from '../../application/usecases/guardar-generacion-asientos-siniestro.usecase';
import { ActualizarGeneracionAsientosSiniestroUseCase } from '../../application/usecases/actualizar-generacion-asientos-siniestro.usecase';
import { EliminarGeneracionAsientosSiniestroUseCase } from '../../application/usecases/eliminar-generacion-asientos-siniestro.usecase';
import { GeneracionAsientosSiniestroFacade } from '../../application/facades/generacion-asientos-siniestro.facade';
import { GeneracionAsientosSiniestroFeedbackEffects } from '../../effects/generacion-asientos-siniestro-feedback.effect';
import { GeneracionAsientosSiniestroSyncEffects } from '../../effects/generacion-asientos-siniestro-sync.effect';

export const GENERACION_ASIENTOS_SINIESTRO_PROVIDERS: Provider[] = [
  { provide: IGeneracionAsientosSiniestroRepository, useClass: GeneracionAsientosSiniestroRepositoryImpl },
  GeneracionAsientosSiniestroStore,
  ObtenerGeneracionAsientosSiniestroUseCase,
  GuardarGeneracionAsientosSiniestroUseCase,
  ActualizarGeneracionAsientosSiniestroUseCase,
  EliminarGeneracionAsientosSiniestroUseCase,
  GeneracionAsientosSiniestroFacade,
  GeneracionAsientosSiniestroFeedbackEffects,
  GeneracionAsientosSiniestroSyncEffects,
];
