import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IAnalisisCuentaContableRepository } from '../../domain/repositories/ianalisis-cuenta-contable.repository';
import { AnalisisCuentaContableEntity } from '../../domain/models/analisis-cuenta-contable.entity';

/**
 * ObtenerAnalisisCuentaContableUseCase — Caso de uso de lectura.
 * Orquesta la obtención del análisis de cuenta contable.
 */
@Injectable()
export class ObtenerAnalisisCuentaContableUseCase {

  private readonly repository = inject(IAnalisisCuentaContableRepository);

  execute(): Observable<AnalisisCuentaContableEntity> {
    return this.repository.obtenerTodos();
  }
}
