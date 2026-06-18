import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { PaisVigenciaEntity } from '../../domain/models/pais-vigencia.entity';

@Injectable()
export class ObtenerPaisVigenciaUseCase {
  private readonly reportesRepository = inject(IReportesRepository);

  execute(): Observable<PaisVigenciaEntity[]> {
    return this.reportesRepository.obtenerPaisVigencia();
  }
}
