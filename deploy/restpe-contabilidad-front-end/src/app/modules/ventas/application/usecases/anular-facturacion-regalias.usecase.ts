import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IFacturacionRegaliasRepository } from '../../domain/repositories/ifacturacion-regalias.repository';
import { FacturacionRegaliasEntity } from '../../domain/models/facturacion-regalias.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class AnularFacturacionRegaliasUseCase {
  private readonly repository = inject(IFacturacionRegaliasRepository);

  execute(codigo: string, motivo: string): Observable<ApiResponse<FacturacionRegaliasEntity>> {
    return this.repository.anular(codigo, motivo);
  }
}
