import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { ReglaAsignacionEntity } from '../../domain/models/regla-asignacion.entity';

@Injectable()
export class ObtenerReglasAsignacionUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<ReglaAsignacionEntity[]> {
    return this.repository.obtenerReglasAsignacion();
  }
}
