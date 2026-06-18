import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGeneracionAsientosSiniestroRepository } from '../../domain/repositories/igeneracion-asientos-siniestro.repository';
import { GeneracionAsientosSiniestroEntity } from '../../domain/models/generacion-asientos-siniestro.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarGeneracionAsientosSiniestroUseCase {
  private readonly repo = inject(IGeneracionAsientosSiniestroRepository);

  execute(item: GeneracionAsientosSiniestroEntity): Observable<ApiResponse> {
    return this.repo.guardar(item);
  }
}
