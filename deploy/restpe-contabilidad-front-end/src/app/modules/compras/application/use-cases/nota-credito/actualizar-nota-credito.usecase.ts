import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { INotaCreditoRepository } from '../../../domain/repositories/inota-credito.repository';
import { NotaCreditoEntity } from '../../../domain/models/nota-credito.entity';
import { ApiResponse } from '../../../../../shared/models/api-response.model';

/**
 * Caso de uso: Actualizar Nota de Crédito/Débito - Application Layer
 */
@Injectable()
export class ActualizarNotaCreditoUseCase {
  private readonly repository = inject(INotaCreditoRepository);

  execute(nota: NotaCreditoEntity): Observable<ApiResponse<NotaCreditoEntity>> {
    return this.repository.actualizar(nota);
  }
}
