import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { INumTrasladoRepository } from '../../domain/repositories/inum-traslado.repository';
import { NumTrasladoEntity } from '../../domain/models/num-traslado.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarNumTrasladoUseCase {
  private readonly repository = inject(INumTrasladoRepository);

  execute(numTraslado: NumTrasladoEntity): Observable<ApiResponse> {
    return this.repository.guardar(numTraslado);
  }
}
