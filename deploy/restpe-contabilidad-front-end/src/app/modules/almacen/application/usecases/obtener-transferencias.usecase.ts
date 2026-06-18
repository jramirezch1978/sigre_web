import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICatalogosRepository } from '../../domain/repositories/icatalogos.repository';
import { TransferenciaEntity } from '../../domain/models/catalogo.entity';

@Injectable()
export class ObtenerTransferenciasUseCase {
  private readonly repository = inject(ICatalogosRepository);

  execute(): Observable<TransferenciaEntity[]> {
    return this.repository.obtenerTransferencias();
  }
}
