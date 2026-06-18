import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IAsignacionRatiosRepository } from '../../../domain/repositories/iasignacion-ratios.repository';
import { ApiResponse } from '../../../../../shared/models/api-response.model';

@Injectable()
export class EliminarAsignacionRatiosUseCase {
  private readonly repo = inject(IAsignacionRatiosRepository);

  execute(id: string): Observable<ApiResponse> {
    return this.repo.eliminar(id);
  }
}
