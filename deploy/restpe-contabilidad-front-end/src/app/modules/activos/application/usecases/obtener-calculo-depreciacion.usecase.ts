import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICalculoDepreciacionRepository } from '../../domain/repositories/icalculo-depreciacion.repository';
import { CalculoDepreciacionEntity } from '../../domain/models/calculo-depreciacion.entity';

@Injectable()
export class ObtenerCalculoDepreciacionUseCase {
  private readonly repository = inject(ICalculoDepreciacionRepository);

  execute(): Observable<CalculoDepreciacionEntity[]> {
    return this.repository.obtenerTodos();
  }
}
