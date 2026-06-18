import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IRegistroUitRepository } from '../../domain/repositories/iregistro-uit.repository';
import { RegistroUitEntity } from '../../domain/models/registro-uit.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * GuardarRegistroUitUseCase — Caso de uso de escritura.
 * Persiste un nuevo registro UIT a través del repositorio.
 */
@Injectable()
export class GuardarRegistroUitUseCase {
  private readonly repository = inject(IRegistroUitRepository);

  execute(item: RegistroUitEntity): Observable<ApiResponse<RegistroUitEntity>> {
    return this.repository.guardar(item);
  }
}
