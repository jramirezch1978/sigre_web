import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ITipoDeCambioRepository } from '../../domain/repositories/itipo-de-cambio.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarTipoDeCambioUseCase {
  private readonly repository = inject(ITipoDeCambioRepository);

  execute(id: number): Observable<ApiResponse<boolean>> {
    return this.repository.eliminar(id);
  }
}
