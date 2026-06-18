import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IClasifActivoRepository } from '../../domain/repositories/iclasif-activo.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Use Case: Eliminar una clasificación de activo.
 * SRP: única responsabilidad — eliminación de clasificación.
 */
@Injectable()
export class EliminarClasifActivoUseCase {
  private readonly repository = inject(IClasifActivoRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repository.eliminar(codigo);
  }
}
