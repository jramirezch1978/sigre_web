import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IParametrosRepository } from '../../domain/repositories/iparametros.repository';
import { AgrupacionSedeEntity } from '../../domain/models/agrupacion-sede.entity';

@Injectable()
export class ObtenerAgrupacionSedeUseCase {
  private readonly repository = inject(IParametrosRepository);

  execute(): Observable<AgrupacionSedeEntity[]> {
    return this.repository.obtenerAgrupacionSede();
  }
}
