import { Provider } from '@angular/core';
import { IActivoFijoRepository } from '../../domain/repositories/iactivo-fijo.repository';
import { ActivoFijoRepositoryImpl } from '../repository/activo-fijo.repository.impl';
import { ActivoFijoStore } from '../../store/activo-fijo.store';
import { ActivoFijoFacade } from '../../application/facades/activo-fijo.facade';
import { ObtenerActivosFijosUseCase }  from '../../application/usecases/obtener-activos-fijos.usecase';
import { GuardarActivoFijoUseCase }    from '../../application/usecases/guardar-activo-fijo.usecase';
import { ActualizarActivoFijoUseCase } from '../../application/usecases/actualizar-activo-fijo.usecase';
import { EliminarActivoFijoUseCase }   from '../../application/usecases/eliminar-activo-fijo.usecase';
import { ActivoFijoFeedbackEffects }   from '../../effects/activo-fijo-feedback.effect';
import { ActivoFijoSyncEffects }       from '../../effects/activo-fijo-sync.effect';

export const ACTIVO_FIJO_PROVIDERS: Provider[] = [
  // Repository (binding interfaz → implementación)
  {
    provide:  IActivoFijoRepository,
    useClass: ActivoFijoRepositoryImpl,
  },
  // Store
  ActivoFijoStore,
  // Use Cases
  ObtenerActivosFijosUseCase,
  GuardarActivoFijoUseCase,
  ActualizarActivoFijoUseCase,
  EliminarActivoFijoUseCase,
  // Facade
  ActivoFijoFacade,
  // Effects
  ActivoFijoFeedbackEffects,
  ActivoFijoSyncEffects,
];
