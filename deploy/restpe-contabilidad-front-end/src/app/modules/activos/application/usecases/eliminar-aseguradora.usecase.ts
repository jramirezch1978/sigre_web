import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IAseguradoraRepository } from '../../domain/repositories/iaseguradora.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarAseguradoraUseCase {
  private readonly repository = inject(IAseguradoraRepository);

  execute(codigo: string): Observable<ApiResponse<boolean>> {
    return this.repository.eliminar(codigo);
  }
}
