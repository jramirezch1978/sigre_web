import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReporteTributarioRepository } from '../../domain/repositories/ireporte-tributario.repository';
import { ReporteTributarioDetalleEntity, ReporteTributarioConsolidadoEntity } from '../../domain/models/reporte-tributario.entity';

@Injectable()
export class ObtenerReporteTributarioUseCase {
  private readonly repository = inject(IReporteTributarioRepository);

  executeVentas(): Observable<ReporteTributarioDetalleEntity[]> {
    return this.repository.obtenerVentas();
  }

  executeCompras(): Observable<ReporteTributarioDetalleEntity[]> {
    return this.repository.obtenerCompras();
  }

  executeConsolidado(): Observable<ReporteTributarioConsolidadoEntity[]> {
    return this.repository.obtenerConsolidado();
  }
}
