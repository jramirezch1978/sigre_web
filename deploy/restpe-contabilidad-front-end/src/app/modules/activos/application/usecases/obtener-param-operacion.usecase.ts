import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IParamOperacionRepository } from '../../domain/repositories/iparam-operacion.repository';
import { ParamOperacionEntity } from '../../domain/models/param-operacion.entity';

@Injectable()
export class ObtenerParamOperacionUseCase {
  private readonly repository = inject(IParamOperacionRepository);

  execute(): Observable<ParamOperacionEntity[]> {
    return this.repository.obtenerTodos();
  }
}
