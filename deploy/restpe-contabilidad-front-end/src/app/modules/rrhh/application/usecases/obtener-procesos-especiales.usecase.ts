import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { ProcesosEspecialesEntity } from '../../domain/models/procesos-especiales.entity';

@Injectable()
export class ObtenerProcesosEspecialesUseCase {
  private readonly reportesRepository = inject(IReportesRepository);

  execute(): Observable<ProcesosEspecialesEntity[]> {
    return this.reportesRepository.obtenerProcesosEspeciales();
  }
}
