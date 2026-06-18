import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IParametrosRepository } from '../../domain/repositories/iparametros.repository';
import { GeneracionNumeracionEntity } from '../../domain/models/generacion-numeracion.entity';

@Injectable()
export class ObtenerGeneracionNumeracionUseCase {
  private readonly parametrosRepository = inject(IParametrosRepository);

  execute(): Observable<GeneracionNumeracionEntity[]> {
    return this.parametrosRepository.obtenerGeneracionNumeracion();
  }
}
