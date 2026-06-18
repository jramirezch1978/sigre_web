import { Provider } from '@angular/core';
import { IClonacionAsientosRepository } from '../../domain/repositories/iclonacion-asientos.repository';
import { ClonacionAsientosRepositoryImpl } from '../repository/clonacion-asientos.impl';
import { ClonacionAsientosStore } from '../../store/clonacion-asientos.store';
import { ClonacionAsientosFacade } from '../../application/facades/clonacion-asientos.facade';
import { ObtenerClonacionAsientosUseCase } from '../../application/usecases/obtener-clonacion-asientos.usecase';
import { ClonacionAsientosFeedbackEffects } from '../../effects/clonacion-asientos-feedback.effect';

export const CLONACION_ASIENTOS_PROVIDERS: Provider[] = [
  { provide: IClonacionAsientosRepository, useClass: ClonacionAsientosRepositoryImpl },
  ClonacionAsientosStore,
  ClonacionAsientosFacade,
  ObtenerClonacionAsientosUseCase,
  ClonacionAsientosFeedbackEffects,
];
