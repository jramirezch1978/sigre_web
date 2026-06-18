import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IRegistroUitRepository } from '../../domain/repositories/iregistro-uit.repository';
import { RegistroUitEntity } from '../../domain/models/registro-uit.entity';

/**
 * ObtenerRegistrosUitUseCase — Caso de uso de lectura.
 * Obtiene todos los registros UIT desde el repositorio.
 */
@Injectable()
export class ObtenerRegistrosUitUseCase {
  private readonly repository = inject(IRegistroUitRepository);

  execute(): Observable<RegistroUitEntity[]> {
    return this.repository.obtenerTodos();
  }
}
