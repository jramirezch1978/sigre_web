import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IMaestroPersonalRepository } from '../../domain/repositories/imaestro-personal.repository';
import { DefinicionAreasJerarquiasEntity } from '../../domain/models/definicion-areas-jerarquias.entity';

@Injectable()
export class ObtenerDefinicionAreasJerarquiasUseCase {
  private readonly repository = inject(IMaestroPersonalRepository);

  execute(): Observable<DefinicionAreasJerarquiasEntity[]> {
    return this.repository.obtenerDefinicionAreasJerarquias();
  }
}
