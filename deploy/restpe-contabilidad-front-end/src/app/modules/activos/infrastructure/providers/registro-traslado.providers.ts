import { Provider } from '@angular/core';
import { IRegistroTrasladoRepository } from '../../domain/repositories/iregistro-traslado.repository';
import { RegistroTrasladoRepositoryImpl } from '../repository/reportes.repository.impl';
import { RegistroTrasladoStore } from '../../store/registro-traslado.store';
import { ObtenerRegistroTrasladosUseCase } from '../../application/usecases/obtener-registro-traslados.usecase';
import { RegistroTrasladoFacade } from '../../application/facades/registro-traslado.facade';

export const REGISTRO_TRASLADO_PROVIDERS: Provider[] = [
  { provide: IRegistroTrasladoRepository, useClass: RegistroTrasladoRepositoryImpl },
  RegistroTrasladoStore,
  ObtenerRegistroTrasladosUseCase,
  RegistroTrasladoFacade,
];
