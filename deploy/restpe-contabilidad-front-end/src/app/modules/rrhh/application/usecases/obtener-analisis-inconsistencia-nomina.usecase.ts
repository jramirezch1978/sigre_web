import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { AnalisisInconsistenciaEntity } from '../../domain/models/analisis-inconsistencia.entity';

@Injectable()
export class ObtenerAnalisisInconsistenciaNominaUseCase {
  constructor(private readonly repository: IReportesRepository) {}

  execute(): Observable<AnalisisInconsistenciaEntity[]> {
    return this.repository.obtenerAnalisisInconsistenciaNomina();
  }
}
