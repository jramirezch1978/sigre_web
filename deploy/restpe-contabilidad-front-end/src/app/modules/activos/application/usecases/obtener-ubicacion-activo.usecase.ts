import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IUbicacionActivoRepository } from '../../domain/repositories/iubicacion-activo.repository';
import { UbicacionActivoEntity } from '../../domain/models/ubicacion-activo.entity';

@Injectable()
export class ObtenerUbicacionActivoUseCase {
  private readonly repository = inject(IUbicacionActivoRepository);

  execute(): Observable<UbicacionActivoEntity[]> {
    return this.repository.obtenerTodos();
  }
}
