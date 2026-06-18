import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IDetraccionRepository } from '../../domain/repositories/idetraccion.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarDetraccionUseCase {
  private readonly repository = inject(IDetraccionRepository);

  execute(codigo: string): Observable<ApiResponse<boolean>> {
    return this.repository.eliminar(codigo);
  }
}
