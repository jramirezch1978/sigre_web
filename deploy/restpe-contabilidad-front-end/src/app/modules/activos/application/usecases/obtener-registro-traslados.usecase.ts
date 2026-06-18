import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IRegistroTrasladoRepository } from '../../domain/repositories/iregistro-traslado.repository';
import { RegistroTrasladoEntity } from '../../domain/models/registro-traslado.entity';

/**
 * Caso de uso: Obtener listado de registro de traslados.
 * SRP: única responsabilidad de solicitar todos los registros al repositorio.
 */
@Injectable()
export class ObtenerRegistroTrasladosUseCase {
  private readonly repository = inject(IRegistroTrasladoRepository);

  execute(): Observable<RegistroTrasladoEntity[]> {
    return this.repository.obtenerTodos();
  }
}
