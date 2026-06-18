import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICentroCostoRepository } from '../../domain/repositories/icentro-costo.repository';
import { CentroCostoEntity } from '../../domain/models/centro-costo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarCentroCostoUseCase {
  private readonly repository = inject(ICentroCostoRepository);

  execute(centro: CentroCostoEntity): Observable<ApiResponse<CentroCostoEntity>> {
    return this.repository.guardar(centro);
  }
}
