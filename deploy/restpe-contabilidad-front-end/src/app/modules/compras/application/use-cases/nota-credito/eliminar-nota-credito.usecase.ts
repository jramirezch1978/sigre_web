import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { INotaCreditoRepository } from '../../../domain/repositories/inota-credito.repository';
import { ApiResponse } from '../../../../../shared/models/api-response.model';

/**
 * Caso de uso: Eliminar Nota de Crédito/Débito - Application Layer
 */
@Injectable()
export class EliminarNotaCreditoUseCase {
  private readonly repository = inject(INotaCreditoRepository);

  execute(codigo: string): Observable<ApiResponse<boolean>> {
    return this.repository.eliminar(codigo);
  }
}
