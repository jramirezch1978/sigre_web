import { Injectable, inject } from '@angular/core';
import { IConceptoFinancieroRepository } from '../../domain/repositories/iconcepto-financiero.repository';
import { ConceptoFinancieroEntity } from '../../domain/models/concepto-financiero.entity';
import { Observable } from 'rxjs';

@Injectable()
export class ActualizarConceptoFinancieroUseCase {
  private readonly repository = inject(IConceptoFinancieroRepository);

  execute(
    codigo: string,
    cambios: Partial<ConceptoFinancieroEntity>,
  ): Observable<ConceptoFinancieroEntity> {
    return this.repository.actualizar(codigo, cambios);
  }
}
