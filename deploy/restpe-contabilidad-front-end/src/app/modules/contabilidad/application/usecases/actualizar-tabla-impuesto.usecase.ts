import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ITablaImpuestoRepository } from '../../domain/repositories/itable-impuesto.repository';
import { TablaImpuestoEntity } from '../../domain/models/tabla-impuesto.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class ActualizarTablaImpuestoUseCase {
  private readonly repository = inject(ITablaImpuestoRepository);

  execute(item: TablaImpuestoEntity): Observable<ApiResponse<TablaImpuestoEntity>> {
    return this.repository.actualizar(item);
  }
}
