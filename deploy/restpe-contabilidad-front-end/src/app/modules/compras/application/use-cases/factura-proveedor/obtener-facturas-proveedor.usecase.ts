import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IFacturaProveedorRepository } from '../../../domain/repositories/ifactura-proveedor.repository';
import { FacturaProveedorEntity } from '../../../domain/models/factura-proveedor.entity';

/**
 * Caso de uso: Obtener Facturas de Proveedor - Application Layer
 */
@Injectable()
export class ObtenerFacturasProveedorUseCase {
  private readonly repository = inject(IFacturaProveedorRepository);

  execute(): Observable<FacturaProveedorEntity[]> {
    return this.repository.obtenerFacturas();
  }
}
