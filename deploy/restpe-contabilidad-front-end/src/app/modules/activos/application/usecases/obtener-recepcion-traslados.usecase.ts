import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IRecepcionTrasladoRepository } from '../../domain/repositories/irecepcion-traslado.repository';
import { RecepcionTrasladoEntity } from '../../domain/models/recepcion-traslado.entity';

/**
 * Caso de uso: Obtener listado de recepciones de traslados.
 * SRP: única responsabilidad de solicitar todos los registros al repositorio.
 */
@Injectable()
export class ObtenerRecepcionTrasladosUseCase {
  private readonly repository = inject(IRecepcionTrasladoRepository);

  execute(): Observable<RecepcionTrasladoEntity[]> {
    return this.repository.obtenerTodos();
  }
}
