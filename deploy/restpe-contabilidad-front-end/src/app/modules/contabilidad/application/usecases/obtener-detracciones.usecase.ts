import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IDetraccionRepository } from '../../domain/repositories/idetraccion.repository';
import { DetraccionEntity } from '../../domain/models/detraccion.entity';

@Injectable()
export class ObtenerDetraccionesUseCase {
  private readonly repository = inject(IDetraccionRepository);

  execute(): Observable<DetraccionEntity[]> {
    return this.repository.obtenerTodos();
  }
}
