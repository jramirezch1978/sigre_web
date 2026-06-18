import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IUbicacionActivoRepository } from '../../domain/repositories/iubicacion-activo.repository';
import { UbicacionActivoEntity } from '../../domain/models/ubicacion-activo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class ActualizarUbicacionActivoUseCase {
  private readonly repository = inject(IUbicacionActivoRepository);

  execute(ubicacion: UbicacionActivoEntity): Observable<ApiResponse> {
    return this.repository.actualizar(ubicacion);
  }
}
