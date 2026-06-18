import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IAprobacionTrasladoRepository } from '../../../domain/repositories/iaprobacion-traslado.repository';
import { ApiResponse } from '../../../../../shared/models/api-response.model';

@Injectable()
export class EliminarAprobacionTrasladoUseCase {
  private readonly repo = inject(IAprobacionTrasladoRepository);

  execute(id: string): Observable<ApiResponse> {
    return this.repo.eliminar(id);
  }
}
