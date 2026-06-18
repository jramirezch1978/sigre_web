import { Provider } from '@angular/core';
import { IAnalisisCuentaContableRepository } from '../../domain/repositories/ianalisis-cuenta-contable.repository';
import { AnalisisCuentaContableRepositoryImpl } from '../repository/analisis-cuenta-contable.impl';
import { AnalisisCuentaContableStore } from '../../store/analisis-cuenta-contable.store';
import { AnalisisCuentaContableFacade } from '../../application/facades/analisis-cuenta-contable.facade';
import { ObtenerAnalisisCuentaContableUseCase } from '../../application/usecases/obtener-analisis-cuenta-contable.usecase';
import { AnalisisCuentaContableFeedbackEffects } from '../../effects/analisis-cuenta-contable-feedback.effect';

export const ANALISIS_CUENTA_CONTABLE_PROVIDERS: Provider[] = [
  { provide: IAnalisisCuentaContableRepository, useClass: AnalisisCuentaContableRepositoryImpl },
  AnalisisCuentaContableStore,
  AnalisisCuentaContableFacade,
  ObtenerAnalisisCuentaContableUseCase,
  AnalisisCuentaContableFeedbackEffects,
];
