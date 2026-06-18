import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IResumenRangosRepository } from '../../domain/repositories/iresumen-rangos.repository';
import { ResumenRangosEntity } from '../../domain/models/resumen-rangos.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarResumenRangosUseCase {
  private readonly repository = inject(IResumenRangosRepository);

  execute(item: ResumenRangosEntity): Observable<ApiResponse> {
    return this.repository.guardar(item);
  }
}
