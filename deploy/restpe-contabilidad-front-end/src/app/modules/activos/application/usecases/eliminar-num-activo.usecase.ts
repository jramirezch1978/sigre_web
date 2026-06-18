import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { INumActivoRepository } from '../../domain/repositories/inum-activo.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarNumActivoUseCase {
  private readonly repository = inject(INumActivoRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repository.eliminar(codigo);
  }
}
