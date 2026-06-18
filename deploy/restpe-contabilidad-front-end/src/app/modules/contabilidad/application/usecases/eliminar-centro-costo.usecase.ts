import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICentroCostoRepository } from '../../domain/repositories/icentro-costo.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarCentroCostoUseCase {
  private readonly repository = inject(ICentroCostoRepository);

  execute(codigo: string): Observable<ApiResponse<boolean>> {
    return this.repository.eliminar(codigo);
  }
}
