import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IMatrizContableRepository } from '../../domain/repositories/imatriz-contable.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarMatrizContableUseCase {
  private readonly repository = inject(IMatrizContableRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repository.eliminar(codigo);
  }
}
