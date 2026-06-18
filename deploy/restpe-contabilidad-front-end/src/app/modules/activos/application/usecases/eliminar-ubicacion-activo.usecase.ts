import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IUbicacionActivoRepository } from '../../domain/repositories/iubicacion-activo.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarUbicacionActivoUseCase {
  private readonly repository = inject(IUbicacionActivoRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repository.eliminar(codigo);
  }
}
