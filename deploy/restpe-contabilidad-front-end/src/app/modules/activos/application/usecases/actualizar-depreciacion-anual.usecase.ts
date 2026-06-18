import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IDepreciacionAnualRepository } from '../../domain/repositories/idepreciacion-anual.repository';
import { DepreciacionAnualEntity } from '../../domain/models/depreciacion-anual.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class ActualizarDepreciacionAnualUseCase {
  private readonly repository = inject(IDepreciacionAnualRepository);

  execute(item: DepreciacionAnualEntity): Observable<ApiResponse> {
    return this.repository.actualizar(item);
  }
}
