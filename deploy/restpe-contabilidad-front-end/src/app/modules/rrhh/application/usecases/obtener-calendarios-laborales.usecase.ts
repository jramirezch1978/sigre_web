import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { CalendarioLaboralEntity } from '../../domain/models/calendario-laboral.entity';

@Injectable()
export class ObtenerCalendariosLaboralesUseCase {
  constructor(private readonly repository: IReportesRepository) {}

  execute(): Observable<CalendarioLaboralEntity[]> {
    return this.repository.obtenerCalendariosLaborales();
  }
}
