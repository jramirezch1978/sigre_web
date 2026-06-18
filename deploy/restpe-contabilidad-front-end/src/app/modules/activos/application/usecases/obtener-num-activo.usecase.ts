import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { INumActivoRepository } from '../../domain/repositories/inum-activo.repository';
import { NumActivoEntity } from '../../domain/models/num-activo.entity';

@Injectable()
export class ObtenerNumActivoUseCase {
  private readonly repository = inject(INumActivoRepository);

  execute(): Observable<NumActivoEntity[]> {
    return this.repository.obtenerTodos();
  }
}
