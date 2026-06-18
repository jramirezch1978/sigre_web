import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ILibrosAsientosRepository } from '../../domain/repositories/ilibros-asientos.repository';
import { LibroMayorEntity, LibroDiarioEntity, BalanceComprobEntity } from '../../domain/models/libros-asientos.entity';

/**
 * ObtenerLibrosAsientosUseCase — Caso de uso de lectura.
 * Orquesta la obtención de cada tipo de reporte de forma independiente.
 */
@Injectable()
export class ObtenerLibrosAsientosUseCase {

  private readonly repository = inject(ILibrosAsientosRepository);

  ejecutarLibroMayor(): Observable<LibroMayorEntity> {
    return this.repository.obtenerLibroMayor();
  }

  ejecutarLibroDiario(): Observable<LibroDiarioEntity> {
    return this.repository.obtenerLibroDiario();
  }

  ejecutarBalanceComprobacion(): Observable<BalanceComprobEntity> {
    return this.repository.obtenerBalanceComprobacion();
  }
}
