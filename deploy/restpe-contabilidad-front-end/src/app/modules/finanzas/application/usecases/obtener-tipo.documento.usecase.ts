import { inject, Injectable } from '@angular/core';
import { TipoDocumentoEntity } from '@modules/finanzas/domain/models/tipo-documento.entity';
import { ITipoDocumentoRepository } from '@modules/finanzas/domain/repositories/itipo-documento.repository';
import { Observable } from 'rxjs';

@Injectable()
export class ObtenerTiposDocumentoUseCase {
  private readonly repository = inject(ITipoDocumentoRepository);

  execute(): Observable<TipoDocumentoEntity[]> {
    return this.repository.obtenerTiposDocumento();
  }
}
