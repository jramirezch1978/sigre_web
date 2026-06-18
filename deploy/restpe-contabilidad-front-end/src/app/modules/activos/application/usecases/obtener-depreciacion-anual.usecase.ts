import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IDepreciacionAnualRepository } from '../../domain/repositories/idepreciacion-anual.repository';
import { DepreciacionAnualEntity } from '../../domain/models/depreciacion-anual.entity';

@Injectable()
export class ObtenerDepreciacionAnualUseCase {
  private readonly repository = inject(IDepreciacionAnualRepository);

  execute(): Observable<DepreciacionAnualEntity[]> {
    return this.repository.obtenerTodos();
  }
}
