import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { ReportePlanillaEntity } from '../../domain/models/reporte-planilla.entity';

@Injectable()
export class ObtenerReportesPlanillaUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<ReportePlanillaEntity[]> {
    return this.repository.obtenerReportesPlanilla();
  }
}
