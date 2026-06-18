import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IAlmacenRepository } from '../../domain/repositories/ialmacen.repository';
import { AlmacenEntity } from '../../domain/models/almacen.entity';

@Injectable()
export class ObtenerAlmacenesUseCase {
  private readonly repository = inject(IAlmacenRepository);

  execute(): Observable<AlmacenEntity[]> {
    return this.repository.obtenerTodos();
  }
}
