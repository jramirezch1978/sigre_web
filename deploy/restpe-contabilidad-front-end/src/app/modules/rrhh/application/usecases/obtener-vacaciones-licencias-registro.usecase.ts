import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { VacacionLicenciaEntity } from '../../domain/models/vacacion-licencia.entity';

@Injectable()
export class ObtenerVacacionesLicenciasRegistroUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<VacacionLicenciaEntity[]> {
    return this.repository.obtenerVacacionesLicenciasRegistro();
  }
}
