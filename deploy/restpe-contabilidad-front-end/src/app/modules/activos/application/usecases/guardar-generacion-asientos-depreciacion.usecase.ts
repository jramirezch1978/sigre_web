import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGeneracionAsientosDepreciacionRepository } from '../../domain/repositories/igeneracion-asientos-depreciacion.repository';
import { GeneracionAsientosDepreciacionEntity } from '../../domain/models/generacion-asientos-depreciacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarGeneracionAsientosDepreciacionUseCase {
  private readonly repository = inject(IGeneracionAsientosDepreciacionRepository);

  execute(item: GeneracionAsientosDepreciacionEntity): Observable<ApiResponse> {
    return this.repository.guardar(item);
  }
}
