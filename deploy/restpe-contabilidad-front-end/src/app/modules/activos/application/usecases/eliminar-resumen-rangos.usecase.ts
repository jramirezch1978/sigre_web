import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IResumenRangosRepository } from '../../domain/repositories/iresumen-rangos.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarResumenRangosUseCase {
  private readonly repository = inject(IResumenRangosRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repository.eliminar(codigo);
  }
}
