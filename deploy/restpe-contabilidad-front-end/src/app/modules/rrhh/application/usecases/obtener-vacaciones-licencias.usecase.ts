import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { VacacionLicenciaEntity } from '../../domain/models/vacacion-licencia.entity';

@Injectable()
export class ObtenerVacacionesLicenciasUseCase {
  constructor(private readonly repository: IReportesRepository) {}

  execute(): Observable<VacacionLicenciaEntity[]> {
    return this.repository.obtenerVacacionesLicencias();
  }
}
