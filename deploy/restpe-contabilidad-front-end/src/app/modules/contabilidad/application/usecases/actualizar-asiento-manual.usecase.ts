import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGestionAsientosManualesRepository } from '../../domain/repositories/igestion-asientos-manuales.repository';
import { AsientoManualItem } from '../../domain/models/gestion-asientos-manual.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * ActualizarAsientoManualUseCase — Caso de uso de escritura.
 * Actualiza un asiento manual existente a través del repositorio.
 */
@Injectable()
export class ActualizarAsientoManualUseCase {
  private readonly repository = inject(IGestionAsientosManualesRepository);

  execute(asiento: AsientoManualItem): Observable<ApiResponse<AsientoManualItem>> {
    return this.repository.actualizar(asiento);
  }
}
