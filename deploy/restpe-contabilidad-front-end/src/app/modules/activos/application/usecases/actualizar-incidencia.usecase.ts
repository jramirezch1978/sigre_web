import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IIncidenciaRepository } from '../../domain/repositories/iincidencia.repository';
import { IncidenciaEntity } from '../../domain/models/incidencia.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Use Case: Actualizar una incidencia existente.
 * SRP: única responsabilidad — actualización de incidencia.
 */
@Injectable()
export class ActualizarIncidenciaUseCase {
  private readonly repository = inject(IIncidenciaRepository);

  execute(incidencia: IncidenciaEntity): Observable<ApiResponse> {
    return this.repository.actualizar(incidencia);
  }
}
