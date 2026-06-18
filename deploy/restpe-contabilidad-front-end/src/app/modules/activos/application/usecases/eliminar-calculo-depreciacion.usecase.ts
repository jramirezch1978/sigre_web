import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICalculoDepreciacionRepository } from '../../domain/repositories/icalculo-depreciacion.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarCalculoDepreciacionUseCase {
  private readonly repository = inject(ICalculoDepreciacionRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repository.eliminar(codigo);
  }
}
