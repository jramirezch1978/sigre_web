import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IActivoFijoRepository } from '../../domain/repositories/iactivo-fijo.repository';
import { ActivoFijoEntity } from '../../domain/models/activo-fijo.entity';

@Injectable()
export class ObtenerActivosFijosUseCase {
  private readonly repository = inject(IActivoFijoRepository);

  execute(): Observable<ActivoFijoEntity[]> {
    return this.repository.obtenerTodos();
  }
}
