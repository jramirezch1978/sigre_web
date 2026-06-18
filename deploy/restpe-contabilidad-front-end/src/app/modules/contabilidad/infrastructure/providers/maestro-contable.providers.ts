import { Provider } from '@angular/core';
import { IMaestroContableRepository } from '../../domain/repositories/imaestro-contable.repository';
import { MaestroContableRepositoryImpl } from '../repository/maestro-contable.impl';
import { MaestroContableStore } from '../../store/maestro-contable.store';
import { MaestroContableFacade } from '../../application/facades/maestro-contable.facade';
import { ObtenerMaestroContableUseCase } from '../../application/usecases/obtener-maestro-contable.usecase';
import { MaestroContableFeedbackEffects } from '../../effects/maestro-contable-feedback.effect';

export const MAESTRO_CONTABLE_PROVIDERS: Provider[] = [
  { provide: IMaestroContableRepository, useClass: MaestroContableRepositoryImpl },
  MaestroContableStore,
  MaestroContableFacade,
  ObtenerMaestroContableUseCase,
  MaestroContableFeedbackEffects,
];
