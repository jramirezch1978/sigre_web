import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IAlmacenRepository } from '../../domain/repositories/ialmacen.repository';
import { AlmacenEntity } from '../../domain/models/almacen.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarAlmacenUseCase {
  private readonly repository = inject(IAlmacenRepository);

  execute(almacen: AlmacenEntity): Observable<ApiResponse<AlmacenEntity>> {
    return this.repository.guardar(almacen);
  }
}
