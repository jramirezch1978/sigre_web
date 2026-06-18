import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICalculoDepreciacionRepository } from '../../domain/repositories/icalculo-depreciacion.repository';
import { CalculoDepreciacionEntity } from '../../domain/models/calculo-depreciacion.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarCalculoDepreciacionUseCase {
  private readonly repository = inject(ICalculoDepreciacionRepository);

  execute(item: CalculoDepreciacionEntity): Observable<ApiResponse> {
    return this.repository.guardar(item);
  }
}
