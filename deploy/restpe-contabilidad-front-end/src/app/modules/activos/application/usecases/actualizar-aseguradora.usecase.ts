import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IAseguradoraRepository } from '../../domain/repositories/iaseguradora.repository';
import { AseguradoraEntity } from '../../domain/models/aseguradora.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class ActualizarAseguradoraUseCase {
  private readonly repository = inject(IAseguradoraRepository);

  execute(aseguradora: AseguradoraEntity): Observable<ApiResponse<AseguradoraEntity>> {
    return this.repository.actualizar(aseguradora);
  }
}
