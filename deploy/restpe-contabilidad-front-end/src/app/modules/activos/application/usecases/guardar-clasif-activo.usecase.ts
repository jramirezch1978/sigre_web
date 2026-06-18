import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IClasifActivoRepository } from '../../domain/repositories/iclasif-activo.repository';
import { ClasifActivoEntity } from '../../domain/models/clasif-activo.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Use Case: Guardar una nueva clasificación de activo.
 * SRP: única responsabilidad — persistencia de nueva clasificación.
 */
@Injectable()
export class GuardarClasifActivoUseCase {
  private readonly repository = inject(IClasifActivoRepository);

  execute(clasif: ClasifActivoEntity): Observable<ApiResponse> {
    return this.repository.guardar(clasif);
  }
}
