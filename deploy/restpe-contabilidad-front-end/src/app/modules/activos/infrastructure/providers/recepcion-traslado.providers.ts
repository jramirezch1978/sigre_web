import { Provider } from '@angular/core';
import { IRecepcionTrasladoRepository } from '../../domain/repositories/irecepcion-traslado.repository';
import { RecepcionTrasladoRepositoryImpl } from '../repository/reportes.repository.impl';
import { RecepcionTrasladoStore } from '../../store/recepcion-traslado.store';
import { ObtenerRecepcionTrasladosUseCase } from '../../application/usecases/obtener-recepcion-traslados.usecase';
import { RecepcionTrasladoFacade } from '../../application/facades/recepcion-traslado.facade';

export const RECEPCION_TRASLADO_PROVIDERS: Provider[] = [
  { provide: IRecepcionTrasladoRepository, useClass: RecepcionTrasladoRepositoryImpl },
  RecepcionTrasladoStore,
  ObtenerRecepcionTrasladosUseCase,
  RecepcionTrasladoFacade,
];
