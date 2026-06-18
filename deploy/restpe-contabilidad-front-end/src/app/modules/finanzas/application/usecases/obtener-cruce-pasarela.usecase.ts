import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICrucePasarelaRepository } from '../../domain/repositories/icruce-pasarela.repository';
import { CrucePasarelaEntity } from '../../domain/models/cruce-pasarela.entity';

@Injectable()
export class ObtenerCrucePasarelaUseCase {
  private readonly repository = inject(ICrucePasarelaRepository);

  execute(): Observable<CrucePasarelaEntity[]> {
    return this.repository.obtenerCruces();
  }
}
