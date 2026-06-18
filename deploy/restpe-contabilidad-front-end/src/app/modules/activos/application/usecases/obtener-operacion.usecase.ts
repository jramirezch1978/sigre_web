import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IOperacionRepository } from '../../domain/repositories/ioperacion.repository';
import { OperacionEntity } from '../../domain/models/operacion.entity';

@Injectable()
export class ObtenerOperacionUseCase {
  private readonly repository = inject(IOperacionRepository);

  execute(): Observable<OperacionEntity[]> {
    return this.repository.obtenerTodos();
  }
}
