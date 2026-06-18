import { Provider } from '@angular/core';
import { IAseguradoraRepository } from '../../domain/repositories/iaseguradora.repository';
import { AseguradoraRepositoryImpl } from '../repository/aseguradora.repository.impl';
import { AseguradoraStore } from '../../store/aseguradora.store';
import { ObtenerAseguradoresUseCase } from '../../application/usecases/obtener-aseguradores.usecase';
import { GuardarAseguradoraUseCase } from '../../application/usecases/guardar-aseguradora.usecase';
import { ActualizarAseguradoraUseCase } from '../../application/usecases/actualizar-aseguradora.usecase';
import { EliminarAseguradoraUseCase } from '../../application/usecases/eliminar-aseguradora.usecase';
import { AseguradoraFacade } from '../../application/facades/aseguradora.facade';
import { AseguradoraFeedbackEffects } from '../../effects/aseguradora-feedback.effect';
import { AseguradoraSyncEffects } from '../../effects/aseguradora-sync.effect';

export const ASEGURADORA_PROVIDERS: Provider[] = [
  // Repository (binding interfaz → implementación)
  {
    provide:  IAseguradoraRepository,
    useClass: AseguradoraRepositoryImpl,
  },
  // Store
  AseguradoraStore,
  // Use Cases
  ObtenerAseguradoresUseCase,
  GuardarAseguradoraUseCase,
  ActualizarAseguradoraUseCase,
  EliminarAseguradoraUseCase,
  // Facade
  AseguradoraFacade,
  // Effects
  AseguradoraFeedbackEffects,
  AseguradoraSyncEffects,
];
