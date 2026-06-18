import { Provider } from '@angular/core';
import { ISeguroRepository } from '../../domain/repositories/iseguro.repository';
import { SeguroRepositoryImpl } from '../repository/seguro.repository.impl';
import { SeguroStore } from '../../store/seguro.store';
import { ObtenerSeguroUseCase } from '../../application/usecases/obtener-seguro.usecase';
import { GuardarSeguroUseCase } from '../../application/usecases/guardar-seguro.usecase';
import { ActualizarSeguroUseCase } from '../../application/usecases/actualizar-seguro.usecase';
import { EliminarSeguroUseCase } from '../../application/usecases/eliminar-seguro.usecase';
import { SeguroFacade } from '../../application/facades/seguro.facade';
import { SeguroFeedbackEffects } from '../../effects/seguro-feedback.effect';
import { SeguroSyncEffects } from '../../effects/seguro-sync.effect';

export const SEGURO_PROVIDERS: Provider[] = [
  { provide: ISeguroRepository, useClass: SeguroRepositoryImpl },
  SeguroStore,
  ObtenerSeguroUseCase,
  GuardarSeguroUseCase,
  ActualizarSeguroUseCase,
  EliminarSeguroUseCase,
  SeguroFacade,
  SeguroFeedbackEffects,
  SeguroSyncEffects,
];
