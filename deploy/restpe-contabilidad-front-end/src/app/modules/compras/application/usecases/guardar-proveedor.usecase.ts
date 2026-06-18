import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IProveedorRepository } from '../../domain/repositories/iproveedor.repository';
import { ProveedorEntity } from '../../domain/models/proveedor.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarProveedorUseCase {
  private readonly repository = inject(IProveedorRepository);

  execute(proveedor: ProveedorEntity): Observable<ApiResponse<ProveedorEntity>> {
    return this.repository.guardar(proveedor);
  }
}
