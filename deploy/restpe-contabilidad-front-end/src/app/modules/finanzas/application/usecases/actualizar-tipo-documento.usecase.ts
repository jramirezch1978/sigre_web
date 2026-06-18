import { inject, Injectable } from '@angular/core';
import { ITipoDocumentoRepository } from '@modules/finanzas/domain/repositories/itipo-documento.repository';
import { Observable } from 'rxjs';
import { TipoDocumentoEntity } from '@modules/finanzas/domain/models/tipo-documento.entity';

@Injectable()
export class ActualizarTipoDocumentoUseCase {
  private readonly repo = inject(ITipoDocumentoRepository);

  execute(id: number, tipoDocumento: any): Observable<TipoDocumentoEntity> {
    return this.repo.actualizar(id, tipoDocumento);
  }

  executeEstado(id: number, estado: string): Observable<TipoDocumentoEntity> {
    return this.repo.actualizarEstado(id, estado);
  }
}
