import { Provider } from '@angular/core';
import { IDetraccionRepository } from '../../domain/repositories/idetraccion.repository';
import { DetraccionesRepositoryImpl } from '../../domain/repositories/detracciones.impl';
import { DetraccionStore } from '../../store/detraccion.store';
import { DetraccionFacade } from '../../application/facades/detraccion.facade';
import { ObtenerDetraccionesUseCase } from '../../application/usecases/obtener-detracciones.usecase';
import { GuardarDetraccionUseCase } from '../../application/usecases/guardar-detraccion.usecase';
import { ActualizarDetraccionUseCase } from '../../application/usecases/actualizar-detraccion.usecase';
import { EliminarDetraccionUseCase } from '../../application/usecases/eliminar-detraccion.usecase';
import { DetraccionFeedbackEffects } from '../../effects/detraccion-feedback.effect';
import { DetraccionSyncEffects } from '../../effects/detraccion-sync.effect';

export const DETRACCION_PROVIDERS: Provider[] = [
  { provide: IDetraccionRepository, useClass: DetraccionesRepositoryImpl },
  DetraccionStore,
  DetraccionFacade,
  ObtenerDetraccionesUseCase,
  GuardarDetraccionUseCase,
  ActualizarDetraccionUseCase,
  EliminarDetraccionUseCase,
  DetraccionFeedbackEffects,
  DetraccionSyncEffects,
];
