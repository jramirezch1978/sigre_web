import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IConsistenciaAsientosRepository } from '../../domain/repositories/iconsistencia-asientos.repository';
import { ConsistenciaAsientosEntity } from '../../domain/models/consistencia-asientos.entity';

@Injectable()
export class ObtenerConsistenciaAsientosUseCase {

  private readonly repository = inject(IConsistenciaAsientosRepository);

  execute(): Observable<ConsistenciaAsientosEntity[]> {
    return this.repository.obtenerTodos();
  }
}

