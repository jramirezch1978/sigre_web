import { Injectable, inject } from '@angular/core';
import { IPanelReenvioRepository } from '../../domain/repositories/ipanel-reenvio.repository';
import { PanelReenvioEntity } from '../../domain/models/panel-reenvio.entity';
import { Observable } from 'rxjs';

@Injectable()
export class ObtenerPanelReenvioUseCase {

  private readonly repository = inject(IPanelReenvioRepository);

  execute(): Observable<PanelReenvioEntity[]> {
    return this.repository.obtenerTodos();
  }
}
