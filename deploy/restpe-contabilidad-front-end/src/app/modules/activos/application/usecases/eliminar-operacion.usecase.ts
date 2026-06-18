import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IOperacionRepository } from '../../domain/repositories/ioperacion.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarOperacionUseCase {
  private readonly repository = inject(IOperacionRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repository.eliminar(codigo);
  }
}
