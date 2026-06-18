import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ISeguroRepository } from '../../domain/repositories/iseguro.repository';
import { SeguroEntity } from '../../domain/models/seguro.entity';

@Injectable()
export class ObtenerSeguroUseCase {
  private readonly repository = inject(ISeguroRepository);

  execute(): Observable<SeguroEntity[]> {
    return this.repository.obtenerTodos();
  }
}
