import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IMaestroContableRepository } from '../../domain/repositories/imaestro-contable.repository';
import { MaestroContableEntity } from '../../domain/models/maestro-contable.entity';

/**
 * ObtenerMaestroContableUseCase — Caso de uso de lectura.
 * Consulta el maestro contable completo a través del repositorio.
 */
@Injectable()
export class ObtenerMaestroContableUseCase {
  private readonly repository = inject(IMaestroContableRepository);

  execute(): Observable<MaestroContableEntity> {
    return this.repository.obtenerTodos();
  }
}
