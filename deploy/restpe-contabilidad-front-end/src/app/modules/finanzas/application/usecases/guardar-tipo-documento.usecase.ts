import { inject, Injectable } from '@angular/core';
import { TipoDocumentoEntity } from '@modules/finanzas/domain/models/tipo-documento.entity';
import { ITipoDocumentoRepository } from '@modules/finanzas/domain/repositories/itipo-documento.repository';
import { Observable } from 'rxjs';

@Injectable()
export class GuardarTipoDocumentoUseCase {
  private readonly repo = inject(ITipoDocumentoRepository);

  execute(tipoDocumento: TipoDocumentoEntity): Observable<TipoDocumentoEntity> {
    return this.repo.guardarTipoDocumento(tipoDocumento);
  }
}
