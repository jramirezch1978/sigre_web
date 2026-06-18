import { Provider } from '@angular/core';
import { IResumenRangosRepository } from '../../domain/repositories/iresumen-rangos.repository';
import { ResumenRangosRepositoryImpl } from '../repository/resumen-rangos.repository.impl';
import { ResumenRangosStore } from '../../store/resumen-rangos.store';
import { ObtenerResumenRangosUseCase } from '../../application/usecases/obtener-resumen-rangos.usecase';
import { GuardarResumenRangosUseCase } from '../../application/usecases/guardar-resumen-rangos.usecase';
import { ActualizarResumenRangosUseCase } from '../../application/usecases/actualizar-resumen-rangos.usecase';
import { EliminarResumenRangosUseCase } from '../../application/usecases/eliminar-resumen-rangos.usecase';
import { ResumenRangosFacade } from '../../application/facades/resumen-rangos.facade';
import { ResumenRangosFeedbackEffects } from '../../effects/resumen-rangos-feedback.effect';
import { ResumenRangosSyncEffects } from '../../effects/resumen-rangos-sync.effect';

export const RESUMEN_RANGOS_PROVIDERS: Provider[] = [
  { provide: IResumenRangosRepository, useClass: ResumenRangosRepositoryImpl },
  ResumenRangosStore,
  ObtenerResumenRangosUseCase,
  GuardarResumenRangosUseCase,
  ActualizarResumenRangosUseCase,
  EliminarResumenRangosUseCase,
  ResumenRangosFacade,
  ResumenRangosFeedbackEffects,
  ResumenRangosSyncEffects,
];
