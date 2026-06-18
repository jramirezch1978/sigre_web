import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IIncidenciaRepository } from '../../domain/repositories/iincidencia.repository';
import { IncidenciaEntity } from '../../domain/models/incidencia.entity';

/**
 * Use Case: Obtener todas las incidencias.
 * SRP: única responsabilidad — consulta de incidencias.
 */
@Injectable()
export class ObtenerIncidenciasUseCase {
  private readonly repository = inject(IIncidenciaRepository);

  execute(): Observable<IncidenciaEntity[]> {
    return this.repository.obtenerTodos();
  }
}
