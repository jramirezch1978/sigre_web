import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICondicionPagoRepository } from '../../domain/repositories/icondicion-pago.repository';
import { CondicionPagoEntity } from '../../domain/models/condicion-pago.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarCondicionPagoUseCase {
  private readonly repository = inject(ICondicionPagoRepository);

  execute(condicion: CondicionPagoEntity): Observable<ApiResponse<CondicionPagoEntity>> {
    return this.repository.guardar(condicion);
  }
}
