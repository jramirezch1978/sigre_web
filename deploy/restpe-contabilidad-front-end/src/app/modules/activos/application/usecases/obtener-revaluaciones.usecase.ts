import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IRevaluacionRepository } from '../../domain/repositories/irevaluacion.repository';
import { RevaluacionEntity } from '../../domain/models/revaluacion.entity';

/**
 * Caso de uso: Obtener listado de revaluaciones de activos fijos.
 * SRP: única responsabilidad de solicitar todos los registros al repositorio.
 */
@Injectable()
export class ObtenerRevaluacionesUseCase {
  private readonly repository = inject(IRevaluacionRepository);

  execute(): Observable<RevaluacionEntity[]> {
    return this.repository.obtenerTodos();
  }
}
