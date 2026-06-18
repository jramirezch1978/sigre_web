import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { PlanillaEntity } from '../../domain/models/planilla.entity';

@Injectable()
export class ObtenerCalculoPlanillaUseCase {
  private readonly reportesRepository = inject(IReportesRepository);

  execute(): Observable<PlanillaEntity[]> {
    return this.reportesRepository.obtenerCalculoPlanilla();
  }
}
