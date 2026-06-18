import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICuentaVsSubcategoriaRepository } from '../../domain/repositories/icuenta-vs-subcategoria.repository';
import { CuentaVsSubcategoriaEntity } from '../../domain/models/cuenta-vs-subcategoria.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class ActualizarCuentaVsSubcategoriaUseCase {
  private readonly repository = inject(ICuentaVsSubcategoriaRepository);

  execute(item: CuentaVsSubcategoriaEntity): Observable<ApiResponse<CuentaVsSubcategoriaEntity>> {
    return this.repository.actualizar(item);
  }
}
