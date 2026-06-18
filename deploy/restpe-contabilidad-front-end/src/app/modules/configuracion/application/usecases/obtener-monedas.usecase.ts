import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { MonedaEntity } from '../../domain/models/moneda.entity';

@Injectable()
export class ObtenerMonedasUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<MonedaEntity[]> {
    return this.repository.obtenerMonedas();
  }
}
