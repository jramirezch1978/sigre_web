import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IAprobacionTrasladoRepository } from '../../../domain/repositories/iaprobacion-traslado.repository';
import { AprobacionTrasladoEntity } from '../../../domain/models/aprobacion-traslado.entity';

@Injectable()
export class ObtenerAprobacionTrasladoUseCase {
  private readonly repo = inject(IAprobacionTrasladoRepository);

  execute(): Observable<AprobacionTrasladoEntity[]> {
    return this.repo.obtenerTodos();
  }
}
