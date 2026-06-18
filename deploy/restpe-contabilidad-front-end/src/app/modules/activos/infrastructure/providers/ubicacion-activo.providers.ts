import { Provider } from '@angular/core';
import { IUbicacionActivoRepository } from '../../domain/repositories/iubicacion-activo.repository';
import { UbicacionActivoRepositoryImpl } from '../repository/ubicacion-activo.repository.impl';
import { UbicacionActivoStore } from '../../store/ubicacion-activo.store';
import { ObtenerUbicacionActivoUseCase } from '../../application/usecases/obtener-ubicacion-activo.usecase';
import { GuardarUbicacionActivoUseCase } from '../../application/usecases/guardar-ubicacion-activo.usecase';
import { ActualizarUbicacionActivoUseCase } from '../../application/usecases/actualizar-ubicacion-activo.usecase';
import { EliminarUbicacionActivoUseCase } from '../../application/usecases/eliminar-ubicacion-activo.usecase';
import { UbicacionActivoFacade } from '../../application/facades/ubicacion-activo.facade';
import { UbicacionActivoFeedbackEffects } from '../../effects/ubicacion-activo-feedback.effect';
import { UbicacionActivoSyncEffects } from '../../effects/ubicacion-activo-sync.effect';

export const UBICACION_ACTIVO_PROVIDERS: Provider[] = [
  { provide: IUbicacionActivoRepository, useClass: UbicacionActivoRepositoryImpl },
  UbicacionActivoStore,
  ObtenerUbicacionActivoUseCase,
  GuardarUbicacionActivoUseCase,
  ActualizarUbicacionActivoUseCase,
  EliminarUbicacionActivoUseCase,
  UbicacionActivoFacade,
  UbicacionActivoFeedbackEffects,
  UbicacionActivoSyncEffects,
];
