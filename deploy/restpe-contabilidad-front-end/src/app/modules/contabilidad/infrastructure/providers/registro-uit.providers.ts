import { Provider } from '@angular/core';
import { IRegistroUitRepository } from '../../domain/repositories/iregistro-uit.repository';
import { RegistroUitRepositoryImpl } from '../repository/registro-uit.impl';
import { RegistroUitStore } from '../../store/registro-uit.store';
import { RegistroUitFacade } from '../../application/facades/registro-uit.facade';
import { ObtenerRegistrosUitUseCase } from '../../application/usecases/obtener-registros-uit.usecase';
import { GuardarRegistroUitUseCase } from '../../application/usecases/guardar-registro-uit.usecase';
import { ActualizarRegistroUitUseCase } from '../../application/usecases/actualizar-registro-uit.usecase';
import { RegistroUitFeedbackEffects } from '../../effects/registro-uit-feedback.effect';
import { RegistroUitSyncEffects } from '../../effects/registro-uit-sync.effect';

export const REGISTRO_UIT_PROVIDERS: Provider[] = [
  { provide: IRegistroUitRepository, useClass: RegistroUitRepositoryImpl },
  RegistroUitStore,
  RegistroUitFacade,
  ObtenerRegistrosUitUseCase,
  GuardarRegistroUitUseCase,
  ActualizarRegistroUitUseCase,
  RegistroUitFeedbackEffects,
  RegistroUitSyncEffects,
];
