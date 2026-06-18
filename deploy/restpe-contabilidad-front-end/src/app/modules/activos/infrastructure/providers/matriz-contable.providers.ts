import { Provider } from '@angular/core';
import { IMatrizContableRepository } from '../../domain/repositories/imatriz-contable.repository';
import { MatrizContableRepositoryImpl } from '../repository/matriz-contable.repository.impl';
import { MatrizContableStore } from '../../store/matriz-contable.store';
import { ObtenerMatrizContableUseCase } from '../../application/usecases/obtener-matriz-contable.usecase';
import { GuardarMatrizContableUseCase } from '../../application/usecases/guardar-matriz-contable.usecase';
import { ActualizarMatrizContableUseCase } from '../../application/usecases/actualizar-matriz-contable.usecase';
import { EliminarMatrizContableUseCase } from '../../application/usecases/eliminar-matriz-contable.usecase';
import { MatrizContableFacade } from '../../application/facades/matriz-contable.facade';
import { MatrizContableFeedbackEffects } from '../../effects/matriz-contable-feedback.effect';
import { MatrizContableSyncEffects } from '../../effects/matriz-contable-sync.effect';

export const MATRIZ_CONTABLE_PROVIDERS: Provider[] = [
  { provide: IMatrizContableRepository, useClass: MatrizContableRepositoryImpl },
  MatrizContableStore,
  ObtenerMatrizContableUseCase,
  GuardarMatrizContableUseCase,
  ActualizarMatrizContableUseCase,
  EliminarMatrizContableUseCase,
  MatrizContableFacade,
  MatrizContableFeedbackEffects,
  MatrizContableSyncEffects,
];
