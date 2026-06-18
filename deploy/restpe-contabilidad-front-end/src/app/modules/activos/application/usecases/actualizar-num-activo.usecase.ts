import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { INumActivoRepository } from '../../domain/repositories/inum-activo.repository';
import { NumActivoEntity } from '../../domain/models/num-activo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class ActualizarNumActivoUseCase {
  private readonly repository = inject(INumActivoRepository);

  execute(numActivo: NumActivoEntity): Observable<ApiResponse> {
    return this.repository.actualizar(numActivo);
  }
}
