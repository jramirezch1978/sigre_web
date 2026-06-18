import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IOperacionRepository } from '../../domain/repositories/ioperacion.repository';
import { OperacionEntity } from '../../domain/models/operacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class ActualizarOperacionUseCase {
  private readonly repository = inject(IOperacionRepository);

  execute(operacion: OperacionEntity): Observable<ApiResponse> {
    return this.repository.actualizar(operacion);
  }
}
