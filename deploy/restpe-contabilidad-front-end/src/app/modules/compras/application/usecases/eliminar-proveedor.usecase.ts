import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IProveedorRepository } from '../../domain/repositories/iproveedor.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarProveedorUseCase {
  private readonly repository = inject(IProveedorRepository);

  execute(codigo: string): Observable<ApiResponse<boolean>> {
    return this.repository.eliminar(codigo);
  }
}
