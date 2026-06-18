import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IFacturaProveedorRepository } from '../../../domain/repositories/ifactura-proveedor.repository';
import { FacturaProveedorEntity } from '../../../domain/models/factura-proveedor.entity';
import { ApiResponse } from '../../../../../shared/models/api-response.model';

/**
 * Caso de uso: Actualizar Factura de Proveedor - Application Layer
 */
@Injectable()
export class ActualizarFacturaProveedorUseCase {
  private readonly repository = inject(IFacturaProveedorRepository);

  execute(factura: FacturaProveedorEntity): Observable<ApiResponse<FacturaProveedorEntity>> {
    return this.repository.actualizar(factura);
  }
}
