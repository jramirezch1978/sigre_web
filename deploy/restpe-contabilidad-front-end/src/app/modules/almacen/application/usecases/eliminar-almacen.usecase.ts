import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IAlmacenRepository } from '../../domain/repositories/ialmacen.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarAlmacenUseCase {
  private readonly repository = inject(IAlmacenRepository);

  execute(almacen_codigo: string): Observable<ApiResponse<boolean>> {
    return this.repository.eliminar(almacen_codigo);
  }
}
