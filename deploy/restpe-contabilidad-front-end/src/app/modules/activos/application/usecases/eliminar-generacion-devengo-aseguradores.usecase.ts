import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGeneracionDevengoAseguradoresRepository } from '../../domain/repositories/igeneracion-devengo-aseguradores.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarGeneracionDevengoAseguradoresUseCase {
  private readonly repo = inject(IGeneracionDevengoAseguradoresRepository);

  execute(codigo: string): Observable<ApiResponse> {
    return this.repo.eliminar(codigo);
  }
}
