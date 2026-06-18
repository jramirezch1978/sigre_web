import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { DashboardRrhhEntity } from '../../domain/models/dashboard-rrhh.entity';

@Injectable()
export class ObtenerDashboardRrhhUseCase {
  private readonly reportesRepository = inject(IReportesRepository);

  execute(): Observable<DashboardRrhhEntity> {
    return this.reportesRepository.obtenerDashboardRrhh();
  }
}
