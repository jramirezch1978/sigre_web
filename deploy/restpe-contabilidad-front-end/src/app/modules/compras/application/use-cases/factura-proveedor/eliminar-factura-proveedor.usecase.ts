import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IFacturaProveedorRepository } from '../../../domain/repositories/ifactura-proveedor.repository';
import { ApiResponse } from '../../../../../shared/models/api-response.model';

/**
 * Caso de uso: Eliminar Factura de Proveedor - Application Layer
 */
@Injectable()
export class EliminarFacturaProveedorUseCase {
  private readonly repository = inject(IFacturaProveedorRepository);

  execute(codigo: string): Observable<ApiResponse<boolean>> {
    return this.repository.eliminar(codigo);
  }
}
