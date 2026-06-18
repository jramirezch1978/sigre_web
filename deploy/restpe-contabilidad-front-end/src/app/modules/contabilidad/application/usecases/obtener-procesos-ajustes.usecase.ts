import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IProcesosAjustesRepository } from '../../domain/repositories/iprocesos-ajustes.repository';
import { ProcesosAjustesEntity } from '../../domain/models/procesos-ajustes.entity';

/**
 * ObtenerProcesosAjustesUseCase — Caso de uso de aplicación.
 * Encapsula la lógica de negocio: obtener el listado de asientos de procesos de ajuste.
 */
@Injectable()
export class ObtenerProcesosAjustesUseCase {

  private readonly repo = inject(IProcesosAjustesRepository);

  execute(): Observable<ProcesosAjustesEntity> {
    return this.repo.obtenerTodos();
  }
}
