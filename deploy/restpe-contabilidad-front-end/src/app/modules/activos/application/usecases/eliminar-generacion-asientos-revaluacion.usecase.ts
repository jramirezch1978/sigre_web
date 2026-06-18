import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGeneracionAsientosRevaluacionRepository } from '../../domain/repositories/igeneracion-asientos-revaluacion.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarGeneracionAsientosRevaluacionUseCase {
  private readonly repo = inject(IGeneracionAsientosRevaluacionRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repo.eliminar(codigo);
  }
}
