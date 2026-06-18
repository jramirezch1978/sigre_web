import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { ConceptoEntity } from '../../domain/models/concepto.entity';

@Injectable()
export class ObtenerConceptosUseCase {
  private readonly reportesRepository = inject(IReportesRepository);

  execute(): Observable<ConceptoEntity[]> {
    return this.reportesRepository.obtenerConceptos();
  }
}
