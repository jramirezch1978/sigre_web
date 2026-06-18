import { Provider } from '@angular/core';
import { IRegistroOperacionActivoRepository } from '../../domain/repositories/iregistro-operacion-activo.repository';
import { RegistroOperacionActivoRepositoryImpl } from '../repository/reportes.repository.impl';
import { RegistroOperacionActivoStore } from '../../store/registro-operacion-activo.store';
import { ObtenerRegistroOperacionActivoUseCase } from '../../application/usecases/obtener-registro-operacion-activo.usecase';
import { RegistroOperacionActivoFacade } from '../../application/facades/registro-operacion-activo.facade';

export const REGISTRO_OPERACION_ACTIVO_PROVIDERS: Provider[] = [
  { provide: IRegistroOperacionActivoRepository, useClass: RegistroOperacionActivoRepositoryImpl },
  RegistroOperacionActivoStore,
  ObtenerRegistroOperacionActivoUseCase,
  RegistroOperacionActivoFacade,
];
