import { inject, Injectable } from '@angular/core';
import { ITipoDocumentoRepository } from '@modules/finanzas/domain/repositories/itipo-documento.repository';
import { Observable } from 'rxjs';

@Injectable()
export class EliminarTipoDocumentoUseCase {
  private readonly repo = inject(ITipoDocumentoRepository);

  execute(id: number): Observable<boolean> {
    return this.repo.eliminar(id);
  }
}
