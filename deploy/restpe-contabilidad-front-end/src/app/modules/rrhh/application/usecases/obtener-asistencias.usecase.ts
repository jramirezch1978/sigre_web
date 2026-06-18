import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { AsistenciaEntity } from '../../domain/models/asistencia.entity';

@Injectable()
export class ObtenerAsistenciasUseCase {
  constructor(private readonly repository: IReportesRepository) {}

  execute(): Observable<AsistenciaEntity[]> {
    return this.repository.obtenerAsistencias();
  }
}
