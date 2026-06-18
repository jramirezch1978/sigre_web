import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGeneracionAsientosSiniestroRepository } from '../../domain/repositories/igeneracion-asientos-siniestro.repository';
import { GeneracionAsientosSiniestroEntity } from '../../domain/models/generacion-asientos-siniestro.entity';

@Injectable()
export class ObtenerGeneracionAsientosSiniestroUseCase {
  private readonly repo = inject(IGeneracionAsientosSiniestroRepository);

  execute(): Observable<GeneracionAsientosSiniestroEntity[]> {
    return this.repo.obtenerTodos();
  }
}
