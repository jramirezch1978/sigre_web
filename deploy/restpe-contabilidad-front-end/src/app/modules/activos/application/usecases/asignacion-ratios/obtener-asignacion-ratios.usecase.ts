import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IAsignacionRatiosRepository } from '../../../domain/repositories/iasignacion-ratios.repository';
import { AsignacionRatiosEntity } from '../../../domain/models/asignacion-ratios.entity';

@Injectable()
export class ObtenerAsignacionRatiosUseCase {
  private readonly repo = inject(IAsignacionRatiosRepository);

  execute(): Observable<AsignacionRatiosEntity[]> {
    return this.repo.obtenerTodos();
  }
}
