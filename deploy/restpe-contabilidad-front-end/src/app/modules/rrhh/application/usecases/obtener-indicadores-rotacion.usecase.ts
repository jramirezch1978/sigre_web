import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { IndicadoresRotacionEntity } from '../../domain/models/indicadores-rotacion.entity';

@Injectable()
export class ObtenerIndicadoresRotacionUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<IndicadoresRotacionEntity[]> {
    return this.repository.obtenerIndicadoresRotacion();
  }
}
