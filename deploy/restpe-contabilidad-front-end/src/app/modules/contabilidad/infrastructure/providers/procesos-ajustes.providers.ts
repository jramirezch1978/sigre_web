import { Provider } from '@angular/core';
import { IProcesosAjustesRepository } from '../../domain/repositories/iprocesos-ajustes.repository';
import { ProcesosAjustesRepositoryImpl } from '../repository/procesos-ajustes.impl';
import { ProcesosAjustesStore } from '../../store/procesos-ajustes.store';
import { ProcesosAjustesFacade } from '../../application/facades/procesos-ajustes.facade';
import { ObtenerProcesosAjustesUseCase } from '../../application/usecases/obtener-procesos-ajustes.usecase';
import { ProcesosAjustesFeedbackEffects } from '../../effects/procesos-ajustes-feedback.effect';

export const PROCESOS_AJUSTES_PROVIDERS: Provider[] = [
  { provide: IProcesosAjustesRepository, useClass: ProcesosAjustesRepositoryImpl },
  ProcesosAjustesStore,
  ProcesosAjustesFacade,
  ObtenerProcesosAjustesUseCase,
  ProcesosAjustesFeedbackEffects,
];
