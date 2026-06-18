import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IAprobacionTrasladoRepository } from '../../../domain/repositories/iaprobacion-traslado.repository';
import { AprobacionTrasladoEntity } from '../../../domain/models/aprobacion-traslado.entity';
import { ApiResponse } from '../../../../../shared/models/api-response.model';

@Injectable()
export class ActualizarAprobacionTrasladoUseCase {
  private readonly repo = inject(IAprobacionTrasladoRepository);

  execute(item: AprobacionTrasladoEntity): Observable<ApiResponse> {
    return this.repo.actualizar(item);
  }
}
