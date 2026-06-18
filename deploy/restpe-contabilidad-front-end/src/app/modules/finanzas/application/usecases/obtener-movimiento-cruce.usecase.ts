import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IMovimientoCruceRepository } from '../../domain/repositories/imovimiento-cruce.repository';
import { MovimientoCruceEntity } from '../../domain/models/movimiento-cruce.entity';

@Injectable()
export class ObtenerMovimientoCruceUseCase {
  private readonly repository = inject(IMovimientoCruceRepository);

  execute(): Observable<MovimientoCruceEntity[]> {
    return this.repository.obtenerMovimientos();
  }
}
