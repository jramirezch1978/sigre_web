import { Provider } from '@angular/core';
import { IResumenActivoFijoRepository } from '../../domain/repositories/iresumen-activo-fijo.repository';
import { ResumenActivoFijoRepositoryImpl } from '../repository/resumen-activo-fijo.repository.impl';
import { ResumenActivoFijoStore } from '../../store/resumen-activo-fijo.store';
import { ObtenerResumenActivoFijoUseCase } from '../../application/usecases/obtener-resumen-activo-fijo.usecase';
import { GuardarResumenActivoFijoUseCase } from '../../application/usecases/guardar-resumen-activo-fijo.usecase';
import { ActualizarResumenActivoFijoUseCase } from '../../application/usecases/actualizar-resumen-activo-fijo.usecase';
import { EliminarResumenActivoFijoUseCase } from '../../application/usecases/eliminar-resumen-activo-fijo.usecase';
import { ResumenActivoFijoFacade } from '../../application/facades/resumen-activo-fijo.facade';
import { ResumenActivoFijoFeedbackEffects } from '../../effects/resumen-activo-fijo-feedback.effect';
import { ResumenActivoFijoSyncEffects } from '../../effects/resumen-activo-fijo-sync.effect';

export const RESUMEN_ACTIVO_FIJO_PROVIDERS: Provider[] = [
  { provide: IResumenActivoFijoRepository, useClass: ResumenActivoFijoRepositoryImpl },
  ResumenActivoFijoStore,
  ObtenerResumenActivoFijoUseCase,
  GuardarResumenActivoFijoUseCase,
  ActualizarResumenActivoFijoUseCase,
  EliminarResumenActivoFijoUseCase,
  ResumenActivoFijoFacade,
  ResumenActivoFijoFeedbackEffects,
  ResumenActivoFijoSyncEffects,
];
