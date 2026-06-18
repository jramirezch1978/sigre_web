import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IResumenActivoFijoRepository } from '../../domain/repositories/iresumen-activo-fijo.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarResumenActivoFijoUseCase {
  private readonly repository = inject(IResumenActivoFijoRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repository.eliminar(codigo);
  }
}
