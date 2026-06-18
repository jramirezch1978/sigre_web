import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IConciliacionRepository } from '../../domain/repositories/iconciliacion.repository';
import { ConciliacionEntity } from '../../domain/models/conciliacion.entity';

@Injectable()
export class ObtenerConciliacionUseCase {
  private readonly repository = inject(IConciliacionRepository);

  execute(): Observable<ConciliacionEntity[]> {
    return this.repository.obtenerConciliaciones();
  }
}
