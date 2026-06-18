import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGeneracionAsientosIndexacionRepository } from '../../domain/repositories/igeneracion-asientos-indexacion.repository';
import { GeneracionAsientosIndexacionEntity } from '../../domain/models/generacion-asientos-indexacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class ActualizarGeneracionAsientosIndexacionUseCase {
  private readonly repo = inject(IGeneracionAsientosIndexacionRepository);

  execute(item: GeneracionAsientosIndexacionEntity): Observable<ApiResponse> {
    return this.repo.actualizar(item);
  }
}
