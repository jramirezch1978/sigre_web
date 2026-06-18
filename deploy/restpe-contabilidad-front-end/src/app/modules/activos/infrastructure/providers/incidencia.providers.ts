import { Provider } from '@angular/core';
import { IIncidenciaRepository } from '../../domain/repositories/iincidencia.repository';
import { IncidenciaRepositoryImpl } from '../repository/incidencia.repository.impl';
import { IncidenciaStore } from '../../store/incidencia.store';
import { ObtenerIncidenciasUseCase } from '../../application/usecases/obtener-incidencias.usecase';
import { GuardarIncidenciaUseCase } from '../../application/usecases/guardar-incidencia.usecase';
import { ActualizarIncidenciaUseCase } from '../../application/usecases/actualizar-incidencia.usecase';
import { EliminarIncidenciaUseCase } from '../../application/usecases/eliminar-incidencia.usecase';
import { IncidenciaFacade } from '../../application/facades/incidencia.facade';
import { IncidenciaFeedbackEffects } from '../../effects/incidencia-feedback.effect';
import { IncidenciaSyncEffects } from '../../effects/incidencia-sync.effect';

/**
 * Providers del módulo de Incidencias.
 * Registra todas las dependencias de Clean Architecture para este dominio.
 */
export const INCIDENCIA_PROVIDERS: Provider[] = [
  { provide: IIncidenciaRepository, useClass: IncidenciaRepositoryImpl },
  IncidenciaStore,
  ObtenerIncidenciasUseCase,
  GuardarIncidenciaUseCase,
  ActualizarIncidenciaUseCase,
  EliminarIncidenciaUseCase,
  IncidenciaFacade,
  IncidenciaFeedbackEffects,
  IncidenciaSyncEffects,
];
