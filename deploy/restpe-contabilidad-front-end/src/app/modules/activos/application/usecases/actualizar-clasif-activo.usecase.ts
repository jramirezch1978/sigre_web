import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IClasifActivoRepository } from '../../domain/repositories/iclasif-activo.repository';
import { ClasifActivoEntity } from '../../domain/models/clasif-activo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Use Case: Actualizar una clasificación de activo existente.
 * SRP: única responsabilidad — actualización de clasificación.
 */
@Injectable()
export class ActualizarClasifActivoUseCase {
  private readonly repository = inject(IClasifActivoRepository);

  execute(clasif: ClasifActivoEntity): Observable<ApiResponse> {
    return this.repository.actualizar(clasif);
  }
}
