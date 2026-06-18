import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IActivoFijoRepository } from '../../domain/repositories/iactivo-fijo.repository';
import { ActivoFijoEntity } from '../../domain/models/activo-fijo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarActivoFijoUseCase {
  private readonly repository = inject(IActivoFijoRepository);

  execute(activo: ActivoFijoEntity): Observable<ApiResponse<ActivoFijoEntity>> {
    return this.repository.guardar(activo);
  }
}
