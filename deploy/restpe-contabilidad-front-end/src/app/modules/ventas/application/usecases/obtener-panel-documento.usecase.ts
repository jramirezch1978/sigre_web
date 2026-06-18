import { Injectable, inject } from '@angular/core';
import { IPanelDocumentoRepository } from '../../domain/repositories/ipanel-documento.repository';
import { PanelDocumentoEntity } from '../../domain/models/panel-documento.entity';
import { Observable } from 'rxjs';

@Injectable()
export class ObtenerPanelDocumentoUseCase {

  private readonly repository = inject(IPanelDocumentoRepository);

  execute(): Observable<PanelDocumentoEntity[]> {
    return this.repository.obtenerTodos();
  }
}
