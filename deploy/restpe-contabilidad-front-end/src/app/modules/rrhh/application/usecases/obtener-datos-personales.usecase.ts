import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IMaestroPersonalRepository } from '../../domain/repositories/imaestro-personal.repository';
import { DatosPersonalesEntity } from '../../domain/models/datos-personales.entity';

@Injectable()
export class ObtenerDatosPersonalesUseCase {
  private readonly repository = inject(IMaestroPersonalRepository);

  execute(): Observable<DatosPersonalesEntity[]> {
    return this.repository.obtenerDatosPersonales();
  }
}
