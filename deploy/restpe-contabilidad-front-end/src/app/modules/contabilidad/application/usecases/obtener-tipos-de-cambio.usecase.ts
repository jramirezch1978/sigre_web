import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ITipoDeCambioRepository } from '../../domain/repositories/itipo-de-cambio.repository';
import { TipoDeCambioEntity } from '../../domain/models/tipo-de-cambio.entity';

@Injectable()
export class ObtenerTiposDeCambioUseCase {
  private readonly repository = inject(ITipoDeCambioRepository);

  execute(): Observable<TipoDeCambioEntity[]> {
    return this.repository.obtenerTodos();
  }
}
