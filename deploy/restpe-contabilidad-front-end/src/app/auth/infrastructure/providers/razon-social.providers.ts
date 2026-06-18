import { Provider } from '@angular/core';
import { IRazonSocialRepository } from '../../domain/repositories/irazon-social.repository';
import { RazonSocialRepositoryImpl } from '../repository/razon-social.repository.impl';
import { RazonSocialStore } from '../../store/razon-social.store';
import { RazonSocialFacade } from '../../application/facades/razon-social.facade';
import { ObtenerRazonesSocialesUseCase } from '../../application/usecases/obtener-razones-sociales.usecase';

export const RAZON_SOCIAL_PROVIDERS: Provider[] = [
  // Port → Adapter
  { provide: IRazonSocialRepository, useClass: RazonSocialRepositoryImpl },
];
