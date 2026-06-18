import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGeneracionDevengoAseguradoresRepository } from '../../domain/repositories/igeneracion-devengo-aseguradores.repository';
import { GeneracionDevengoAseguradoresEntity } from '../../domain/models/generacion-devengo-aseguradores.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

@Injectable()
export class GuardarGeneracionDevengoAseguradoresUseCase {
  private readonly repo = inject(IGeneracionDevengoAseguradoresRepository);

  execute(item: GeneracionDevengoAseguradoresEntity): Observable<ApiResponse> {
    return this.repo.guardar(item);
  }
}
