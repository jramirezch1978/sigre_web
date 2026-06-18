import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IAsignacionRatiosRepository } from '../../../domain/repositories/iasignacion-ratios.repository';
import { AsignacionRatiosEntity } from '../../../domain/models/asignacion-ratios.entity';
import { ApiResponse } from '../../../../../shared/models/api-response.model';

@Injectable()
export class GuardarAsignacionRatiosUseCase {
  private readonly repo = inject(IAsignacionRatiosRepository);

  execute(item: AsignacionRatiosEntity): Observable<ApiResponse> {
    return this.repo.guardar(item);
  }
}
