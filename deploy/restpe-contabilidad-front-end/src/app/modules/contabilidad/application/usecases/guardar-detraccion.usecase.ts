import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IDetraccionRepository } from '../../domain/repositories/idetraccion.repository';
import { DetraccionEntity } from '../../domain/models/detraccion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarDetraccionUseCase {
  private readonly repository = inject(IDetraccionRepository);

  execute(detraccion: DetraccionEntity): Observable<ApiResponse<DetraccionEntity>> {
    return this.repository.guardar(detraccion);
  }
}
