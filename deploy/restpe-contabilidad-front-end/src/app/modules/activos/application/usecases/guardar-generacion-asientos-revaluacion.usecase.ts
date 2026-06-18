import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGeneracionAsientosRevaluacionRepository } from '../../domain/repositories/igeneracion-asientos-revaluacion.repository';
import { GeneracionAsientosRevaluacionEntity } from '../../domain/models/generacion-asientos-revaluacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarGeneracionAsientosRevaluacionUseCase {
  private readonly repo = inject(IGeneracionAsientosRevaluacionRepository);

  execute(item: GeneracionAsientosRevaluacionEntity): Observable<ApiResponse> {
    return this.repo.guardar(item);
  }
}
