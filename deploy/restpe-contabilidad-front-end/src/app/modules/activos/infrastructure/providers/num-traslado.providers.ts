import { Provider } from '@angular/core';
import { INumTrasladoRepository } from '../../domain/repositories/inum-traslado.repository';
import { NumTrasladoRepositoryImpl } from '../repository/num-traslado.repository.impl';
import { NumTrasladoStore } from '../../store/num-traslado.store';
import { ObtenerNumTrasladoUseCase } from '../../application/usecases/obtener-num-traslado.usecase';
import { GuardarNumTrasladoUseCase } from '../../application/usecases/guardar-num-traslado.usecase';
import { ActualizarNumTrasladoUseCase } from '../../application/usecases/actualizar-num-traslado.usecase';
import { EliminarNumTrasladoUseCase } from '../../application/usecases/eliminar-num-traslado.usecase';
import { NumTrasladoFacade } from '../../application/facades/num-traslado.facade';
import { NumTrasladoFeedbackEffects } from '../../effects/num-traslado-feedback.effect';
import { NumTrasladoSyncEffects } from '../../effects/num-traslado-sync.effect';

export const NUM_TRASLADO_PROVIDERS: Provider[] = [
  { provide: INumTrasladoRepository, useClass: NumTrasladoRepositoryImpl },
  NumTrasladoStore,
  ObtenerNumTrasladoUseCase,
  GuardarNumTrasladoUseCase,
  ActualizarNumTrasladoUseCase,
  EliminarNumTrasladoUseCase,
  NumTrasladoFacade,
  NumTrasladoFeedbackEffects,
  NumTrasladoSyncEffects,
];
