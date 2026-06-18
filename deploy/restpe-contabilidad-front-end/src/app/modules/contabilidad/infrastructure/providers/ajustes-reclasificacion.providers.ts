import { Provider } from '@angular/core';
import { IAjustesReclasificacionRepository } from '../../domain/repositories/iajustes-reclasificacion.repository';
import { AjustesReclasificacionRepositoryImpl } from '../repository/ajustes-reclasificacion.impl';
import { AjustesReclasificacionStore } from '../../store/ajustes-reclasificacion.store';
import { AjustesReclasificacionFacade } from '../../application/facades/ajustes-reclasificacion.facade';
import { ObtenerAjustesReclasificacionUseCase } from '../../application/usecases/obtener-ajustes-reclasificacion.usecase';
import { AjustesReclasificacionFeedbackEffects } from '../../effects/ajustes-reclasificacion-feedback.effect';

export const AJUSTES_RECLASIFICACION_PROVIDERS: Provider[] = [
  { provide: IAjustesReclasificacionRepository, useClass: AjustesReclasificacionRepositoryImpl },
  AjustesReclasificacionStore,
  AjustesReclasificacionFacade,
  ObtenerAjustesReclasificacionUseCase,
  AjustesReclasificacionFeedbackEffects,
];
