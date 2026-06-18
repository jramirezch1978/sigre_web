import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IClonacionAsientosRepository } from '../../domain/repositories/iclonacion-asientos.repository';
import { ClonacionAsientosEntity } from '../../domain/models/clonacion-asientos.entity';

/**
 * ObtenerClonacionAsientosUseCase — Caso de uso de lectura.
 * Orquesta la obtención de asientos disponibles para el proceso de clonación.
 */
@Injectable()
export class ObtenerClonacionAsientosUseCase {

  private readonly repository = inject(IClonacionAsientosRepository);

  execute(): Observable<ClonacionAsientosEntity> {
    return this.repository.obtenerTodos();
  }
}
