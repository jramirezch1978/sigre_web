import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IParametrosRepository } from '../../domain/repositories/iparametros.repository';
import { FrecuenciaCalendariosEntity } from '../../domain/models/frecuencia-calendarios.entity';

@Injectable()
export class ObtenerFrecuenciaCalendariosUseCase {
  private readonly parametrosRepository = inject(IParametrosRepository);

  execute(): Observable<FrecuenciaCalendariosEntity[]> {
    return this.parametrosRepository.obtenerFrecuenciaCalendarios();
  }
}
