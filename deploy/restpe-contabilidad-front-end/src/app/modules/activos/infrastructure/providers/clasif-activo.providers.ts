import { Provider } from '@angular/core';
import { IClasifActivoRepository } from '../../domain/repositories/iclasif-activo.repository';
import { ClasifActivoRepositoryImpl } from '../repository/clasif-activo.repository.impl';
import { ClasifActivoStore } from '../../store/clasif-activo.store';
import { ObtenerClasifActivosUseCase } from '../../application/usecases/obtener-clasif-activos.usecase';
import { GuardarClasifActivoUseCase } from '../../application/usecases/guardar-clasif-activo.usecase';
import { ActualizarClasifActivoUseCase } from '../../application/usecases/actualizar-clasif-activo.usecase';
import { EliminarClasifActivoUseCase } from '../../application/usecases/eliminar-clasif-activo.usecase';
import { ClasifActivoFacade } from '../../application/facades/clasif-activo.facade';
import { ClasifActivoFeedbackEffects } from '../../effects/clasif-activo-feedback.effect';
import { ClasifActivoSyncEffects } from '../../effects/clasif-activo-sync.effect';

export const CLASIF_ACTIVO_PROVIDERS: Provider[] = [
  // Repository (binding interfaz → implementación)
  {
    provide:  IClasifActivoRepository,
    useClass: ClasifActivoRepositoryImpl,
  },
  // Store
  ClasifActivoStore,
  // Use Cases
  ObtenerClasifActivosUseCase,
  GuardarClasifActivoUseCase,
  ActualizarClasifActivoUseCase,
  EliminarClasifActivoUseCase,
  // Facade
  ClasifActivoFacade,
  // Effects
  ClasifActivoFeedbackEffects,
  ClasifActivoSyncEffects,
];
