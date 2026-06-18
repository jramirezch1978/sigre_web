import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IMaestroPersonalRepository } from '../../domain/repositories/imaestro-personal.repository';
import { DefinicionCargosEntity } from '../../domain/models/definicion-cargos.entity';

@Injectable()
export class ObtenerDefinicionCargosUseCase {
  private readonly repository = inject(IMaestroPersonalRepository);

  execute(): Observable<DefinicionCargosEntity[]> {
    return this.repository.obtenerDefinicionCargos();
  }
}
