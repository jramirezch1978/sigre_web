import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { INumTrasladoRepository } from '../../domain/repositories/inum-traslado.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarNumTrasladoUseCase {
  private readonly repository = inject(INumTrasladoRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repository.eliminar(codigo);
  }
}
