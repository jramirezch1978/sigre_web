import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IMatrizContableRepository } from '../../domain/repositories/imatriz-contable.repository';
import { MatrizContableEntity } from '../../domain/models/matriz-contable.entity';

@Injectable()
export class ObtenerMatrizContableUseCase {
  private readonly repository = inject(IMatrizContableRepository);

  execute(): Observable<MatrizContableEntity[]> {
    return this.repository.obtenerTodos();
  }
}
