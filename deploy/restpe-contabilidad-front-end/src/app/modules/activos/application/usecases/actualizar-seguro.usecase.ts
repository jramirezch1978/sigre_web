import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ISeguroRepository } from '../../domain/repositories/iseguro.repository';
import { SeguroEntity } from '../../domain/models/seguro.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class ActualizarSeguroUseCase {
  private readonly repository = inject(ISeguroRepository);

  execute(seguro: SeguroEntity): Observable<ApiResponse> {
    return this.repository.actualizar(seguro);
  }
}
