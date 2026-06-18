import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ITablaImpuestoRepository } from '../../domain/repositories/itable-impuesto.repository';
import { TablaImpuestoEntity } from '../../domain/models/tabla-impuesto.entity';

@Injectable()
export class ObtenerTablaImpuestosUseCase {
  private readonly repository = inject(ITablaImpuestoRepository);

  execute(): Observable<TablaImpuestoEntity[]> {
    return this.repository.obtenerTodos();
  }
}
