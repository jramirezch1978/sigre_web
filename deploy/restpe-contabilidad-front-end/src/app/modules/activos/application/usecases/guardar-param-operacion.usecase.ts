import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IParamOperacionRepository } from '../../domain/repositories/iparam-operacion.repository';
import { ParamOperacionEntity } from '../../domain/models/param-operacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarParamOperacionUseCase {
  private readonly repository = inject(IParamOperacionRepository);

  execute(paramOperacion: ParamOperacionEntity): Observable<ApiResponse> {
    return this.repository.guardar(paramOperacion);
  }
}
