import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IActivoFijoRepository } from '../../domain/repositories/iactivo-fijo.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarActivoFijoUseCase {
  private readonly repository = inject(IActivoFijoRepository);

  execute(codigo: string): Observable<ApiResponse<boolean>> {
    return this.repository.eliminar(codigo);
  }
}
