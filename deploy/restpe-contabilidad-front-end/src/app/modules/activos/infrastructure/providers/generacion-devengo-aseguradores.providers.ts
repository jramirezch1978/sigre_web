import { Provider } from '@angular/core';
import { IGeneracionDevengoAseguradoresRepository } from '../../domain/repositories/igeneracion-devengo-aseguradores.repository';
import { GeneracionDevengoAseguradoresRepositoryImpl } from '../repository/generacion-devengo-aseguradores.repository.impl';
import { GeneracionDevengoAseguradoresStore } from '../../store/generacion-devengo-aseguradores.store';
import { ObtenerGeneracionDevengoAseguradoresUseCase } from '../../application/usecases/obtener-generacion-devengo-aseguradores.usecase';
import { GuardarGeneracionDevengoAseguradoresUseCase } from '../../application/usecases/guardar-generacion-devengo-aseguradores.usecase';
import { ActualizarGeneracionDevengoAseguradoresUseCase } from '../../application/usecases/actualizar-generacion-devengo-aseguradores.usecase';
import { EliminarGeneracionDevengoAseguradoresUseCase } from '../../application/usecases/eliminar-generacion-devengo-aseguradores.usecase';
import { GeneracionDevengoAseguradoresFacade } from '../../application/facades/generacion-devengo-aseguradores.facade';
import { GeneracionDevengoAseguradoresFeedbackEffects } from '../../effects/generacion-devengo-aseguradores-feedback.effect';
import { GeneracionDevengoAseguradoresSyncEffects } from '../../effects/generacion-devengo-aseguradores-sync.effect';

export const GENERACION_DEVENGO_ASEGURADORES_PROVIDERS: Provider[] = [
  { provide: IGeneracionDevengoAseguradoresRepository, useClass: GeneracionDevengoAseguradoresRepositoryImpl },
  GeneracionDevengoAseguradoresStore,
  ObtenerGeneracionDevengoAseguradoresUseCase,
  GuardarGeneracionDevengoAseguradoresUseCase,
  ActualizarGeneracionDevengoAseguradoresUseCase,
  EliminarGeneracionDevengoAseguradoresUseCase,
  GeneracionDevengoAseguradoresFacade,
  GeneracionDevengoAseguradoresFeedbackEffects,
  GeneracionDevengoAseguradoresSyncEffects,
];
