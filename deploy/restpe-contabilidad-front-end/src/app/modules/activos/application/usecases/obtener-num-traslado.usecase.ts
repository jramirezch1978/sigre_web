import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { INumTrasladoRepository } from '../../domain/repositories/inum-traslado.repository';
import { NumTrasladoEntity } from '../../domain/models/num-traslado.entity';

@Injectable()
export class ObtenerNumTrasladoUseCase {
  private readonly repository = inject(INumTrasladoRepository);

  execute(): Observable<NumTrasladoEntity[]> {
    return this.repository.obtenerTodos();
  }
}
