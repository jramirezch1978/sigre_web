import { Injectable, inject } from '@angular/core';
import { IConceptoFinancieroRepository } from '../../domain/repositories/iconcepto-financiero.repository';
import { Observable } from 'rxjs';

@Injectable()
export class EliminarConceptoFinancieroUseCase {
  private readonly repository = inject(IConceptoFinancieroRepository);

  execute(id: number): Observable<{ success: boolean }> {
    return this.repository.eliminar(id);
  }
}
