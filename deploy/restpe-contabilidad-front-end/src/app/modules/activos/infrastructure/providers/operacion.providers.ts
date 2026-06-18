import { Provider } from '@angular/core';
import { IOperacionRepository } from '../../domain/repositories/ioperacion.repository';
import { OperacionRepositoryImpl } from '../repository/operacion.repository.impl';
import { OperacionStore } from '../../store/operacion.store';
import { ObtenerOperacionUseCase } from '../../application/usecases/obtener-operacion.usecase';
import { GuardarOperacionUseCase } from '../../application/usecases/guardar-operacion.usecase';
import { ActualizarOperacionUseCase } from '../../application/usecases/actualizar-operacion.usecase';
import { EliminarOperacionUseCase } from '../../application/usecases/eliminar-operacion.usecase';
import { OperacionFacade } from '../../application/facades/operacion.facade';
import { OperacionFeedbackEffects } from '../../effects/operacion-feedback.effect';
import { OperacionSyncEffects } from '../../effects/operacion-sync.effect';

export const OPERACION_PROVIDERS: Provider[] = [
  { provide: IOperacionRepository, useClass: OperacionRepositoryImpl },
  OperacionStore,
  ObtenerOperacionUseCase,
  GuardarOperacionUseCase,
  ActualizarOperacionUseCase,
  EliminarOperacionUseCase,
  OperacionFacade,
  OperacionFeedbackEffects,
  OperacionSyncEffects,
];
