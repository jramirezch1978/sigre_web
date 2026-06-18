import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGeneracionAsientosSiniestroRepository } from '../../domain/repositories/igeneracion-asientos-siniestro.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarGeneracionAsientosSiniestroUseCase {
  private readonly repo = inject(IGeneracionAsientosSiniestroRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repo.eliminar(codigo);
  }
}
