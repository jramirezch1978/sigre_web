import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGeneracionAsientosDepreciacionRepository } from '../../domain/repositories/igeneracion-asientos-depreciacion.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarGeneracionAsientosDepreciacionUseCase {
  private readonly repository = inject(IGeneracionAsientosDepreciacionRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repository.eliminar(codigo);
  }
}
