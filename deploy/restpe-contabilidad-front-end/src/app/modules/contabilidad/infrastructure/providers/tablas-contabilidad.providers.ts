import { Provider } from '@angular/core';
import { ITablasContabilidadRepository } from '../../domain/repositories/itablas-contabilidad.repository';
import { TablasContabilidadRepositoryImpl } from '../repository/tablas-contabilidad.impl';
import { TablasContabilidadStore } from '../../store/tablas-contabilidad.store';
import { TablasContabilidadFacade } from '../../application/facades/tablas-contabilidad.facade';
import { ObtenerTablasContabilidadUseCase } from '../../application/usecases/obtener-tablas-contabilidad.usecase';
import { TablasContabilidadFeedbackEffects } from '../../effects/tablas-contabilidad-feedback.effect';

export const TABLAS_CONTABILIDAD_PROVIDERS: Provider[] = [
  { provide: ITablasContabilidadRepository, useClass: TablasContabilidadRepositoryImpl },
  TablasContabilidadStore,
  TablasContabilidadFacade,
  ObtenerTablasContabilidadUseCase,
  TablasContabilidadFeedbackEffects,
];
