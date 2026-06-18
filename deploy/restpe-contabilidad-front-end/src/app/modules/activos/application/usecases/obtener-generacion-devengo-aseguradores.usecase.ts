import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGeneracionDevengoAseguradoresRepository } from '../../domain/repositories/igeneracion-devengo-aseguradores.repository';
import { GeneracionDevengoAseguradoresEntity } from '../../domain/models/generacion-devengo-aseguradores.entity';

@Injectable()
export class ObtenerGeneracionDevengoAseguradoresUseCase {
  private readonly repo = inject(IGeneracionDevengoAseguradoresRepository);

  execute(): Observable<GeneracionDevengoAseguradoresEntity[]> {
    return this.repo.obtenerTodos();
  }
}
