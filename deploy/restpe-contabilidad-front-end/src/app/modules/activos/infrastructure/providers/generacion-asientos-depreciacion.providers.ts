import { Provider } from '@angular/core';
import { IGeneracionAsientosDepreciacionRepository } from '../../domain/repositories/igeneracion-asientos-depreciacion.repository';
import { GeneracionAsientosDepreciacionRepositoryImpl } from '../repository/generacion-asientos-depreciacion.repository.impl';
import { GeneracionAsientosDepreciacionStore } from '../../store/generacion-asientos-depreciacion.store';
import { ObtenerGeneracionAsientosDepreciacionUseCase } from '../../application/usecases/obtener-generacion-asientos-depreciacion.usecase';
import { GuardarGeneracionAsientosDepreciacionUseCase } from '../../application/usecases/guardar-generacion-asientos-depreciacion.usecase';
import { ActualizarGeneracionAsientosDepreciacionUseCase } from '../../application/usecases/actualizar-generacion-asientos-depreciacion.usecase';
import { EliminarGeneracionAsientosDepreciacionUseCase } from '../../application/usecases/eliminar-generacion-asientos-depreciacion.usecase';
import { GeneracionAsientosDepreciacionFacade } from '../../application/facades/generacion-asientos-depreciacion.facade';
import { GeneracionAsientosDepreciacionFeedbackEffects } from '../../effects/generacion-asientos-depreciacion-feedback.effect';
import { GeneracionAsientosDepreciacionSyncEffects } from '../../effects/generacion-asientos-depreciacion-sync.effect';

export const GENERACION_ASIENTOS_DEPRECIACION_PROVIDERS: Provider[] = [
  { provide: IGeneracionAsientosDepreciacionRepository, useClass: GeneracionAsientosDepreciacionRepositoryImpl },
  GeneracionAsientosDepreciacionStore,
  ObtenerGeneracionAsientosDepreciacionUseCase,
  GuardarGeneracionAsientosDepreciacionUseCase,
  ActualizarGeneracionAsientosDepreciacionUseCase,
  EliminarGeneracionAsientosDepreciacionUseCase,
  GeneracionAsientosDepreciacionFacade,
  GeneracionAsientosDepreciacionFeedbackEffects,
  GeneracionAsientosDepreciacionSyncEffects,
];
