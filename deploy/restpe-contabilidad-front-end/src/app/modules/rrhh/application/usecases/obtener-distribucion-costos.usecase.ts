import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { DistribucionCostosEntity } from '../../domain/models/distribucion-costos.entity';

@Injectable()
export class ObtenerDistribucionCostosUseCase {
  private readonly reportesRepository = inject(IReportesRepository);

  execute(): Observable<DistribucionCostosEntity[]> {
    return this.reportesRepository.obtenerDistribucionCostos();
  }
}
