import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IResumenActivoFijoRepository } from '../../domain/repositories/iresumen-activo-fijo.repository';
import { ResumenActivoFijoEntity } from '../../domain/models/resumen-activo-fijo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarResumenActivoFijoUseCase {
  private readonly repository = inject(IResumenActivoFijoRepository);

  execute(item: ResumenActivoFijoEntity): Observable<ApiResponse> {
    return this.repository.guardar(item);
  }
}
