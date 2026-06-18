import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGeneracionAsientosRevaluacionRepository } from '../../domain/repositories/igeneracion-asientos-revaluacion.repository';
import { GeneracionAsientosRevaluacionEntity } from '../../domain/models/generacion-asientos-revaluacion.entity';

@Injectable()
export class ObtenerGeneracionAsientosRevaluacionUseCase {
  private readonly repo = inject(IGeneracionAsientosRevaluacionRepository);

  execute(): Observable<GeneracionAsientosRevaluacionEntity[]> {
    return this.repo.obtenerTodos();
  }
}
