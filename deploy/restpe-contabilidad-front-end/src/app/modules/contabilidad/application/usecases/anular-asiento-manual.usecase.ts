import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGestionAsientosManualesRepository } from '../../domain/repositories/igestion-asientos-manuales.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * AnularAsientoManualUseCase — Caso de uso de escritura.
 * Inactiva (anula) un asiento manual a través del repositorio.
 */
@Injectable()
export class AnularAsientoManualUseCase {
  private readonly repository = inject(IGestionAsientosManualesRepository);

  execute(nroAsiento: string): Observable<ApiResponse<boolean>> {
    return this.repository.anular(nroAsiento);
  }
}
