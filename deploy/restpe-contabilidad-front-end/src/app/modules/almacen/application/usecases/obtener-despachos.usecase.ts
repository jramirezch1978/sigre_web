import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { DespachoEntity } from '../../domain/models/despacho.entity';

@Injectable()
export class ObtenerDespachosUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<DespachoEntity[]> {
    return this.repository.obtenerDespachos();
  }
}
