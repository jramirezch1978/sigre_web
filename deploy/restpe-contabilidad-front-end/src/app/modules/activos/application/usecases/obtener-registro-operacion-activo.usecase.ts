import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IRegistroOperacionActivoRepository } from '../../domain/repositories/iregistro-operacion-activo.repository';
import { RegistroOperacionActivoEntity } from '../../domain/models/registro-operacion-activo.entity';

/**
 * Caso de uso: Obtener listado de registro de operaciones de activos.
 * SRP: única responsabilidad de solicitar todos los registros al repositorio.
 */
@Injectable()
export class ObtenerRegistroOperacionActivoUseCase {
  private readonly repository = inject(IRegistroOperacionActivoRepository);

  execute(): Observable<RegistroOperacionActivoEntity[]> {
    return this.repository.obtenerTodos();
  }
}
