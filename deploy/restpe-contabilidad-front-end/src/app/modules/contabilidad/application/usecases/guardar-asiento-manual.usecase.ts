import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGestionAsientosManualesRepository } from '../../domain/repositories/igestion-asientos-manuales.repository';
import { AsientoManualItem } from '../../domain/models/gestion-asientos-manual.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * GuardarAsientoManualUseCase — Caso de uso de escritura.
 * Persiste un nuevo asiento manual a través del repositorio.
 */
@Injectable()
export class GuardarAsientoManualUseCase {
  private readonly repository = inject(IGestionAsientosManualesRepository);

  execute(asiento: AsientoManualItem): Observable<ApiResponse<AsientoManualItem>> {
    return this.repository.guardar(asiento);
  }
}
