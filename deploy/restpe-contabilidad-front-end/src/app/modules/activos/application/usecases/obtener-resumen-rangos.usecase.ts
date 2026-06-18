import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IResumenRangosRepository } from '../../domain/repositories/iresumen-rangos.repository';
import { ResumenRangosEntity } from '../../domain/models/resumen-rangos.entity';

@Injectable()
export class ObtenerResumenRangosUseCase {
  private readonly repository = inject(IResumenRangosRepository);

  execute(): Observable<ResumenRangosEntity[]> {
    return this.repository.obtenerTodos();
  }
}
