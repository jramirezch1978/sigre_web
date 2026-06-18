import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IFacturacionRegaliasRepository } from '../../domain/repositories/ifacturacion-regalias.repository';
import { FacturacionRegaliasEntity } from '../../domain/models/facturacion-regalias.entity';

@Injectable()
export class ObtenerFacturacionRegaliasUseCase {
  private readonly repository = inject(IFacturacionRegaliasRepository);

  execute(): Observable<FacturacionRegaliasEntity[]> {
    return this.repository.obtenerTodos();
  }
}
