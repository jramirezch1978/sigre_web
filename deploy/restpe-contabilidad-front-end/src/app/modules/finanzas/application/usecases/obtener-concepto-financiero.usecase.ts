import { Injectable, inject } from '@angular/core';
import { IConceptoFinancieroRepository } from '../../domain/repositories/iconcepto-financiero.repository';
import { ConceptoFinancieroEntity } from '../../domain/models/concepto-financiero.entity';
import { Observable } from 'rxjs';

@Injectable()
export class ObtenerConceptoFinancieroUseCase {
  private readonly repository = inject(IConceptoFinancieroRepository);

  execute(): Observable<ConceptoFinancieroEntity[]> {
    return this.repository.obtenerTodos();
  }
}
