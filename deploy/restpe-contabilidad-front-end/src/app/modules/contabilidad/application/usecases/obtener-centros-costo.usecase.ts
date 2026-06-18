import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICentroCostoRepository } from '../../domain/repositories/icentro-costo.repository';
import { CentroCostoEntity } from '../../domain/models/centro-costo.entity';

@Injectable()
export class ObtenerCentrosCostoUseCase {
  private readonly repository = inject(ICentroCostoRepository);

  execute(): Observable<CentroCostoEntity[]> {
    return this.repository.obtenerTodos();
  }
}
