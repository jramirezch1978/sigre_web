import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IDepreciacionAnualRepository } from '../../domain/repositories/idepreciacion-anual.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarDepreciacionAnualUseCase {
  private readonly repository = inject(IDepreciacionAnualRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repository.eliminar(codigo);
  }
}
