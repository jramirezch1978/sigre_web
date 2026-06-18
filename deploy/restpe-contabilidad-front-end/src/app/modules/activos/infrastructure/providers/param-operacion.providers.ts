import { Provider } from '@angular/core';
import { IParamOperacionRepository } from '../../domain/repositories/iparam-operacion.repository';
import { ParamOperacionRepositoryImpl } from '../repository/param-operacion.repository.impl';
import { ParamOperacionStore } from '../../store/param-operacion.store';
import { ObtenerParamOperacionUseCase } from '../../application/usecases/obtener-param-operacion.usecase';
import { GuardarParamOperacionUseCase } from '../../application/usecases/guardar-param-operacion.usecase';
import { ActualizarParamOperacionUseCase } from '../../application/usecases/actualizar-param-operacion.usecase';
import { EliminarParamOperacionUseCase } from '../../application/usecases/eliminar-param-operacion.usecase';
import { ParamOperacionFacade } from '../../application/facades/param-operacion.facade';
import { ParamOperacionFeedbackEffects } from '../../effects/param-operacion-feedback.effect';
import { ParamOperacionSyncEffects } from '../../effects/param-operacion-sync.effect';

export const PARAM_OPERACION_PROVIDERS: Provider[] = [
  { provide: IParamOperacionRepository, useClass: ParamOperacionRepositoryImpl },
  ParamOperacionStore,
  ObtenerParamOperacionUseCase,
  GuardarParamOperacionUseCase,
  ActualizarParamOperacionUseCase,
  EliminarParamOperacionUseCase,
  ParamOperacionFacade,
  ParamOperacionFeedbackEffects,
  ParamOperacionSyncEffects,
];
