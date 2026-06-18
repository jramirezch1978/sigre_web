import { Provider } from '@angular/core';
import { ITipoDeCambioRepository } from '../../domain/repositories/itipo-de-cambio.repository';
import { TipoDeCambioRepositoryImpl } from '../repository/tipo-de-cambio.impl';
import { TipoDeCambioStore } from '../../store/tipo-de-cambio.store';
import { TipoDeCambioFacade } from '../../application/facades/tipo-de-cambio.facade';
import { ObtenerTiposDeCambioUseCase } from '../../application/usecases/obtener-tipos-de-cambio.usecase';
import { GuardarTipoDeCambioUseCase } from '../../application/usecases/guardar-tipo-de-cambio.usecase';
import { ActualizarTipoDeCambioUseCase } from '../../application/usecases/actualizar-tipo-de-cambio.usecase';
import { EliminarTipoDeCambioUseCase } from '../../application/usecases/eliminar-tipo-de-cambio.usecase';
import { TipoDeCambioFeedbackEffects } from '../../effects/tipo-de-cambio-feedback.effect';
import { TipoDeCambioSyncEffects } from '../../effects/tipo-de-cambio-sync.effect';

export const TIPO_DE_CAMBIO_PROVIDERS: Provider[] = [
  { provide: ITipoDeCambioRepository, useClass: TipoDeCambioRepositoryImpl },
  TipoDeCambioStore,
  TipoDeCambioFacade,
  ObtenerTiposDeCambioUseCase,
  GuardarTipoDeCambioUseCase,
  ActualizarTipoDeCambioUseCase,
  EliminarTipoDeCambioUseCase,
  TipoDeCambioFeedbackEffects,
  TipoDeCambioSyncEffects,
];
