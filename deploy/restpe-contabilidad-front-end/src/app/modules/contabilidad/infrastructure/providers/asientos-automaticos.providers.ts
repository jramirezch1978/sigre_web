import { Provider } from '@angular/core';
import { IGestionAsientosAutomaticosRepository } from '../../domain/repositories/igestion-asientos-automaticos.repository';
import { AsientosAutomaticosRepositoryImpl } from '../repository/asientos-automaticos.impl';
import { GestionAsientosAutomaticoStore } from '../../store/gestion-asientos-automatico.store';
import { GestionAsientosAutomaticoFacade } from '../../application/facades/gestion-asientos-automatico.facade';
import { ObtenerGestionAsientosAutomaticosUseCase } from '../../application/usecases/obtener-gestion-asientos-automaticos.usecase';
import { GestionAsientosAutomaticosFeedbackEffects } from '../../effects/gestion-asientos-automaticos-feedback.effect';

export const ASIENTOS_AUTOMATICOS_PROVIDERS: Provider[] = [
  { provide: IGestionAsientosAutomaticosRepository, useClass: AsientosAutomaticosRepositoryImpl },
  GestionAsientosAutomaticoStore,
  GestionAsientosAutomaticoFacade,
  ObtenerGestionAsientosAutomaticosUseCase,
  GestionAsientosAutomaticosFeedbackEffects,
];
