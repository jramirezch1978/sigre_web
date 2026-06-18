import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IIncidenciaRepository } from '../../domain/repositories/iincidencia.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Use Case: Eliminar una incidencia.
 * SRP: única responsabilidad — eliminación de incidencia.
 */
@Injectable()
export class EliminarIncidenciaUseCase {
  private readonly repository = inject(IIncidenciaRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repository.eliminar(codigo);
  }
}
