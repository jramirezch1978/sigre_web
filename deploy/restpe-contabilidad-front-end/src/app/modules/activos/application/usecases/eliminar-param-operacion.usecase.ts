import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IParamOperacionRepository } from '../../domain/repositories/iparam-operacion.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarParamOperacionUseCase {
  private readonly repository = inject(IParamOperacionRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repository.eliminar(codigo);
  }
}
