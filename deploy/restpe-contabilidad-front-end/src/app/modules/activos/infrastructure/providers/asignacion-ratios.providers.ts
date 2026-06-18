import { Provider } from '@angular/core';
import { IAsignacionRatiosRepository } from '../../domain/repositories/iasignacion-ratios.repository';
import { AsignacionRatiosRepositoryImpl } from '../repository/asignacion-ratios.repository.impl';
import { AsignacionRatiosStore } from '../../store/asignacion-ratios.store';
import { ObtenerAsignacionRatiosUseCase } from '../../application/usecases/asignacion-ratios/obtener-asignacion-ratios.usecase';
import { GuardarAsignacionRatiosUseCase } from '../../application/usecases/asignacion-ratios/guardar-asignacion-ratios.usecase';
import { ActualizarAsignacionRatiosUseCase } from '../../application/usecases/asignacion-ratios/actualizar-asignacion-ratios.usecase';
import { EliminarAsignacionRatiosUseCase } from '../../application/usecases/asignacion-ratios/eliminar-asignacion-ratios.usecase';
import { AsignacionRatiosFacade } from '../../application/facades/asignacion-ratios.facade';
import { AsignacionRatiosFeedbackEffects } from '../../effects/asignacion-ratios-feedback.effect';
import { AsignacionRatiosSyncEffects } from '../../effects/asignacion-ratios-sync.effect';

export const ASIGNACION_RATIOS_PROVIDERS: Provider[] = [
  { provide: IAsignacionRatiosRepository, useClass: AsignacionRatiosRepositoryImpl },
  AsignacionRatiosStore,
  ObtenerAsignacionRatiosUseCase,
  GuardarAsignacionRatiosUseCase,
  ActualizarAsignacionRatiosUseCase,
  EliminarAsignacionRatiosUseCase,
  AsignacionRatiosFacade,
  AsignacionRatiosFeedbackEffects,
  AsignacionRatiosSyncEffects,
];
