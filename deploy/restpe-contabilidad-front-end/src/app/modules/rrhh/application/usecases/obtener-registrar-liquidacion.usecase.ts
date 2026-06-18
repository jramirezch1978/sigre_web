import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { LiquidacionEntity } from '../../domain/models/liquidacion.entity';

@Injectable()
export class ObtenerRegistrarLiquidacionUseCase {
  private readonly reportesRepository = inject(IReportesRepository);

  execute(): Observable<LiquidacionEntity[]> {
    return this.reportesRepository.obtenerRegistrarLiquidacion();
  }
}
