import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ISeguroRepository } from '../../domain/repositories/iseguro.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarSeguroUseCase {
  private readonly repository = inject(ISeguroRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repository.eliminar(codigo);
  }
}
