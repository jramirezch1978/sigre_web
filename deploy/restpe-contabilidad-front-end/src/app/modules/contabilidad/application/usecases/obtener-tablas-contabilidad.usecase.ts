import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ITablasContabilidadRepository } from '../../domain/repositories/itablas-contabilidad.repository';
import { TablasContabilidadEntity } from '../../domain/models/tablas-contabilidad.entity';

/**
 * ObtenerTablasContabilidadUseCase — Caso de uso de aplicación.
 * Encapsula la lógica de negocio: obtener el catálogo de tipos de documento contable.
 */
@Injectable()
export class ObtenerTablasContabilidadUseCase {

  private readonly repo = inject(ITablasContabilidadRepository);

  execute(): Observable<TablasContabilidadEntity> {
    return this.repo.obtenerTodos();
  }
}
