import { Provider } from '@angular/core';
import { IConsultaCentroCostosRepository } from '../../domain/repositories/iconsulta-centro-costos.repository';
import { ConsultaCentroCostosRepositoryImpl } from '../repository/consulta-centro-costos.impl';
import { ConsultaCentroCostosStore } from '../../store/consulta-centro-costos.store';
import { ConsultaCentroCostosFacade } from '../../application/facades/consulta-centro-costos.facade';
import { ObtenerConsultaCentroCostosUseCase } from '../../application/usecases/obtener-consulta-centro-costos.usecase';
import { ConsultaCentroCostosFeedbackEffects } from '../../effects/consulta-centro-costos-feedback.effect';

export const CONSULTA_CENTRO_COSTOS_PROVIDERS: Provider[] = [
  { provide: IConsultaCentroCostosRepository, useClass: ConsultaCentroCostosRepositoryImpl },
  ConsultaCentroCostosStore,
  ConsultaCentroCostosFacade,
  ObtenerConsultaCentroCostosUseCase,
  ConsultaCentroCostosFeedbackEffects,
];
