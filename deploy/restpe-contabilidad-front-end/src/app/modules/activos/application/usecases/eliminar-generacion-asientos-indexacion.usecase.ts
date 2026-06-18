import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGeneracionAsientosIndexacionRepository } from '../../domain/repositories/igeneracion-asientos-indexacion.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarGeneracionAsientosIndexacionUseCase {
  private readonly repo = inject(IGeneracionAsientosIndexacionRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repo.eliminar(codigo);
  }
}
