import { Provider } from '@angular/core';
import { IAprobacionTrasladoRepository } from '../../domain/repositories/iaprobacion-traslado.repository';
import { AprobacionTrasladoRepositoryImpl } from '../repository/aprobacion-traslado.repository.impl';
import { AprobacionTrasladoStore } from '../../store/aprobacion-traslado.store';
import { ObtenerAprobacionTrasladoUseCase } from '../../application/usecases/aprobacion-traslado/obtener-aprobacion-traslado.usecase';
import { GuardarAprobacionTrasladoUseCase } from '../../application/usecases/aprobacion-traslado/guardar-aprobacion-traslado.usecase';
import { ActualizarAprobacionTrasladoUseCase } from '../../application/usecases/aprobacion-traslado/actualizar-aprobacion-traslado.usecase';
import { EliminarAprobacionTrasladoUseCase } from '../../application/usecases/aprobacion-traslado/eliminar-aprobacion-traslado.usecase';
import { AprobacionTrasladoFacade } from '../../application/facades/aprobacion-traslado.facade';
import { AprobacionTrasladoFeedbackEffects } from '../../effects/aprobacion-traslado-feedback.effect';
import { AprobacionTrasladoSyncEffects } from '../../effects/aprobacion-traslado-sync.effect';

export const APROBACION_TRASLADO_PROVIDERS: Provider[] = [
  { provide: IAprobacionTrasladoRepository, useClass: AprobacionTrasladoRepositoryImpl },
  AprobacionTrasladoStore,
  ObtenerAprobacionTrasladoUseCase,
  GuardarAprobacionTrasladoUseCase,
  ActualizarAprobacionTrasladoUseCase,
  EliminarAprobacionTrasladoUseCase,
  AprobacionTrasladoFacade,
  AprobacionTrasladoFeedbackEffects,
  AprobacionTrasladoSyncEffects,
];
