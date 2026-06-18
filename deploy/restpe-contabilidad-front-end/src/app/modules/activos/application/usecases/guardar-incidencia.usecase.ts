import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IIncidenciaRepository } from '../../domain/repositories/iincidencia.repository';
import { IncidenciaEntity } from '../../domain/models/incidencia.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Use Case: Guardar una nueva incidencia.
 * SRP: única responsabilidad — persistencia de nueva incidencia.
 */
@Injectable()
export class GuardarIncidenciaUseCase {
  private readonly repository = inject(IIncidenciaRepository);

  execute(incidencia: IncidenciaEntity): Observable<ApiResponse> {
    return this.repository.guardar(incidencia);
  }
}
