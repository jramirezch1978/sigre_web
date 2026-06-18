import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICondicionPagoRepository } from '../../domain/repositories/icondicion-pago.repository';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class EliminarCondicionPagoUseCase {
  private readonly repository = inject(ICondicionPagoRepository);

  execute(codigo: string): Observable<ApiResponse<boolean>> {
    return this.repository.eliminar(codigo);
  }
}
