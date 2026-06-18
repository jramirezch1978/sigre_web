import { Provider } from '@angular/core';
import { ICentroCostoRepository } from '../../domain/repositories/icentro-costo.repository';
import { PlanCentroCostosRepositoryImpl } from '../repository/plan-centro-costos.impl';
import { CentroCostoStore } from '../../store/centro-costo.store';
import { CentroCostoFacade } from '../../application/facades/plan-centro-costos.facade';
import { ObtenerCentrosCostoUseCase } from '../../application/usecases/obtener-centros-costo.usecase';
import { GuardarCentroCostoUseCase } from '../../application/usecases/guardar-centro-costo.usecase';
import { ActualizarCentroCostoUseCase } from '../../application/usecases/actualizar-centro-costo.usecase';
import { EliminarCentroCostoUseCase } from '../../application/usecases/eliminar-centro-costo.usecase';
import { CentroCostoFeedbackEffects } from '../../effects/centro-costo-feedback.effect';
import { CentroCostoSyncEffects } from '../../effects/centro-costo-sync.effect';

export const CENTRO_COSTO_PROVIDERS: Provider[] = [
  { provide: ICentroCostoRepository, useClass: PlanCentroCostosRepositoryImpl },
  CentroCostoStore,
  CentroCostoFacade,
  ObtenerCentrosCostoUseCase,
  GuardarCentroCostoUseCase,
  ActualizarCentroCostoUseCase,
  EliminarCentroCostoUseCase,
  CentroCostoFeedbackEffects,
  CentroCostoSyncEffects,
];
