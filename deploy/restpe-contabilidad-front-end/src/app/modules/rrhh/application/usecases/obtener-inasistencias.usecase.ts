import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { InasistenciaEntity } from '../../domain/models/inasistencia.entity';

@Injectable()
export class ObtenerInasistenciasUseCase {
  constructor(private readonly repository: IReportesRepository) {}

  execute(): Observable<InasistenciaEntity[]> {
    return this.repository.obtenerInasistencias();
  }
}
