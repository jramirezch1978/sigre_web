import { Provider } from '@angular/core';
import { ILibrosAsientosRepository } from '../../domain/repositories/ilibros-asientos.repository';
import { LibrosAsientosRepositoryImpl } from '../repository/libros-asientos.impl';
import { LibrosAsientosStore } from '../../store/libros-asientos.store';
import { LibrosAsientosFacade } from '../../application/facades/libros-asientos.facade';
import { ObtenerLibrosAsientosUseCase } from '../../application/usecases/obtener-libros-asientos.usecase';

export const LIBROS_ASIENTOS_PROVIDERS: Provider[] = [
  { provide: ILibrosAsientosRepository, useClass: LibrosAsientosRepositoryImpl },
  LibrosAsientosStore,
  LibrosAsientosFacade,
  ObtenerLibrosAsientosUseCase,
];
