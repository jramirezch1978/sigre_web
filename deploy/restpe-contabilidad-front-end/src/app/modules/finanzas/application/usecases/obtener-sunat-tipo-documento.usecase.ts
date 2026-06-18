import { inject, Injectable } from '@angular/core';
import { SunatTipoDocumentoEntity } from '@modules/finanzas/domain/models/tipo-documento.entity';
import { ISunatTipoDocumentoRepository } from '@modules/finanzas/domain/repositories/isunat-tipo-documento.repository';
import { Observable } from 'rxjs';

@Injectable()
export class ObtenerSunatTiposDocumentoUseCase {
  private readonly repository = inject(ISunatTipoDocumentoRepository);

  execute(): Observable<SunatTipoDocumentoEntity[]> {
    return this.repository.obtenerTiposDocumento();
  }

  executeActivos(): Observable<SunatTipoDocumentoEntity[]> {
    return this.repository.obtenerTiposDocumentoActivos();
  }
}
