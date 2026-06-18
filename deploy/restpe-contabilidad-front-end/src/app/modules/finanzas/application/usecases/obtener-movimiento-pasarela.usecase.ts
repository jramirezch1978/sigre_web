import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IMovimientoPasarelaRepository } from '../../domain/repositories/imovimiento-pasarela.repository';
import { MovimientoPasarelaEntity } from '../../domain/models/movimiento-pasarela.entity';

@Injectable()
export class ObtenerMovimientoPasarelaUseCase {
  private readonly repository = inject(IMovimientoPasarelaRepository);

  execute(): Observable<MovimientoPasarelaEntity[]> {
    return this.repository.obtenerMovimientos();
  }
}
