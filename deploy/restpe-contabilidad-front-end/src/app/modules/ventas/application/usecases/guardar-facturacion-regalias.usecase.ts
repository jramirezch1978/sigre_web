import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IFacturacionRegaliasRepository } from '../../domain/repositories/ifacturacion-regalias.repository';
import { FacturacionRegaliasEntity } from '../../domain/models/facturacion-regalias.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarFacturacionRegaliasUseCase {
  private readonly repository = inject(IFacturacionRegaliasRepository);

  execute(factura: FacturacionRegaliasEntity): Observable<ApiResponse<FacturacionRegaliasEntity>> {
    return this.repository.guardar(factura);
  }
}
