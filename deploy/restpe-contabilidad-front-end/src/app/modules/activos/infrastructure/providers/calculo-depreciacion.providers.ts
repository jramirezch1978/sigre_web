import { Provider } from '@angular/core';
import { ICalculoDepreciacionRepository } from '../../domain/repositories/icalculo-depreciacion.repository';
import { CalculoDepreciacionRepositoryImpl } from '../repository/calculo-depreciacion.repository.impl';
import { CalculoDepreciacionStore } from '../../store/calculo-depreciacion.store';
import { ObtenerCalculoDepreciacionUseCase } from '../../application/usecases/obtener-calculo-depreciacion.usecase';
import { GuardarCalculoDepreciacionUseCase } from '../../application/usecases/guardar-calculo-depreciacion.usecase';
import { ActualizarCalculoDepreciacionUseCase } from '../../application/usecases/actualizar-calculo-depreciacion.usecase';
import { EliminarCalculoDepreciacionUseCase } from '../../application/usecases/eliminar-calculo-depreciacion.usecase';
import { CalculoDepreciacionFacade } from '../../application/facades/calculo-depreciacion.facade';
import { CalculoDepreciacionFeedbackEffects } from '../../effects/calculo-depreciacion-feedback.effect';
import { CalculoDepreciacionSyncEffects } from '../../effects/calculo-depreciacion-sync.effect';

export const CALCULO_DEPRECIACION_PROVIDERS: Provider[] = [
  { provide: ICalculoDepreciacionRepository, useClass: CalculoDepreciacionRepositoryImpl },
  CalculoDepreciacionStore,
  ObtenerCalculoDepreciacionUseCase,
  GuardarCalculoDepreciacionUseCase,
  ActualizarCalculoDepreciacionUseCase,
  EliminarCalculoDepreciacionUseCase,
  CalculoDepreciacionFacade,
  CalculoDepreciacionFeedbackEffects,
  CalculoDepreciacionSyncEffects,
];
