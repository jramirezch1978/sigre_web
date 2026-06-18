import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IMatrizContableRepository } from '../../domain/repositories/imatriz-contable.repository';
import { MatrizContableEntity } from '../../domain/models/matriz-contable.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarMatrizContableUseCase {
  private readonly repository = inject(IMatrizContableRepository);

  execute(matriz: MatrizContableEntity): Observable<ApiResponse> {
    return this.repository.guardar(matriz);
  }
}
