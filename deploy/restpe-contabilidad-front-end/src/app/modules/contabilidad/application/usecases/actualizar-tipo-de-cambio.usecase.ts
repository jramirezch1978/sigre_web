import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ITipoDeCambioRepository } from '../../domain/repositories/itipo-de-cambio.repository';
import { TipoDeCambioEntity } from '../../domain/models/tipo-de-cambio.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class ActualizarTipoDeCambioUseCase {
  private readonly repository = inject(ITipoDeCambioRepository);

  execute(item: TipoDeCambioEntity): Observable<ApiResponse<TipoDeCambioEntity>> {
    return this.repository.actualizar(item);
  }
}
