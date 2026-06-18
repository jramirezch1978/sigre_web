import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IResumenActivoFijoRepository } from '../../domain/repositories/iresumen-activo-fijo.repository';
import { ResumenActivoFijoEntity } from '../../domain/models/resumen-activo-fijo.entity';

@Injectable()
export class ObtenerResumenActivoFijoUseCase {
  private readonly repository = inject(IResumenActivoFijoRepository);

  execute(): Observable<ResumenActivoFijoEntity[]> {
    return this.repository.obtenerTodos();
  }
}
