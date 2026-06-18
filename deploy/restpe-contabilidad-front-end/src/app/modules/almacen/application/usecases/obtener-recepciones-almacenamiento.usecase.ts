import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IOperacionesRepository } from '../../domain/repositories/ioperaciones.repository';
import { RecepcionAlmacenamientoEntity } from '../../domain/models/recepcion-almacenamiento.entity';

@Injectable()
export class ObtenerRecepcionesAlmacenamientoUseCase {
  private readonly operacionesRepository = inject(IOperacionesRepository);

  execute(): Observable<RecepcionAlmacenamientoEntity[]> {
    return this.operacionesRepository.obtenerRecepcionesAlmacenamiento();
  }
}
