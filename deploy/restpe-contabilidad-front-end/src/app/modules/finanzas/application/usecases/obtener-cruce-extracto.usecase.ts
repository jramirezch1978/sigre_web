import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICruceExtractoRepository } from '../../domain/repositories/icruce-extracto.repository';
import { CruceExtractoEntity } from '../../domain/models/cruce-extracto.entity';

@Injectable()
export class ObtenerCruceExtractoUseCase {
  private readonly repository = inject(ICruceExtractoRepository);

  execute(): Observable<CruceExtractoEntity[]> {
    return this.repository.obtenerCruces();
  }
}
