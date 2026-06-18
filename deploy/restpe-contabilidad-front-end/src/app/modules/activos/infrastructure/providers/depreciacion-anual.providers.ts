import { Provider } from '@angular/core';
import { IDepreciacionAnualRepository } from '../../domain/repositories/idepreciacion-anual.repository';
import { DepreciacionAnualRepositoryImpl } from '../repository/depreciacion-anual.repository.impl';
import { DepreciacionAnualStore } from '../../store/depreciacion-anual.store';
import { ObtenerDepreciacionAnualUseCase } from '../../application/usecases/obtener-depreciacion-anual.usecase';
import { GuardarDepreciacionAnualUseCase } from '../../application/usecases/guardar-depreciacion-anual.usecase';
import { ActualizarDepreciacionAnualUseCase } from '../../application/usecases/actualizar-depreciacion-anual.usecase';
import { EliminarDepreciacionAnualUseCase } from '../../application/usecases/eliminar-depreciacion-anual.usecase';
import { DepreciacionAnualFacade } from '../../application/facades/depreciacion-anual.facade';
import { DepreciacionAnualFeedbackEffects } from '../../effects/depreciacion-anual-feedback.effect';
import { DepreciacionAnualSyncEffects } from '../../effects/depreciacion-anual-sync.effect';

export const DEPRECIACION_ANUAL_PROVIDERS: Provider[] = [
  { provide: IDepreciacionAnualRepository, useClass: DepreciacionAnualRepositoryImpl },
  DepreciacionAnualStore,
  ObtenerDepreciacionAnualUseCase,
  GuardarDepreciacionAnualUseCase,
  ActualizarDepreciacionAnualUseCase,
  EliminarDepreciacionAnualUseCase,
  DepreciacionAnualFacade,
  DepreciacionAnualFeedbackEffects,
  DepreciacionAnualSyncEffects,
];
