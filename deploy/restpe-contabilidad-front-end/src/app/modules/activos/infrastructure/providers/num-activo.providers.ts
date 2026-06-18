import { Provider } from '@angular/core';
import { INumActivoRepository } from '../../domain/repositories/inum-activo.repository';
import { NumActivoRepositoryImpl } from '../repository/num-activo.repository.impl';
import { NumActivoStore } from '../../store/num-activo.store';
import { ObtenerNumActivoUseCase } from '../../application/usecases/obtener-num-activo.usecase';
import { GuardarNumActivoUseCase } from '../../application/usecases/guardar-num-activo.usecase';
import { ActualizarNumActivoUseCase } from '../../application/usecases/actualizar-num-activo.usecase';
import { EliminarNumActivoUseCase } from '../../application/usecases/eliminar-num-activo.usecase';
import { NumActivoFacade } from '../../application/facades/num-activo.facade';
import { NumActivoFeedbackEffects } from '../../effects/num-activo-feedback.effect';
import { NumActivoSyncEffects } from '../../effects/num-activo-sync.effect';

export const NUM_ACTIVO_PROVIDERS: Provider[] = [
  { provide: INumActivoRepository, useClass: NumActivoRepositoryImpl },
  NumActivoStore,
  ObtenerNumActivoUseCase,
  GuardarNumActivoUseCase,
  ActualizarNumActivoUseCase,
  EliminarNumActivoUseCase,
  NumActivoFacade,
  NumActivoFeedbackEffects,
  NumActivoSyncEffects,
];
