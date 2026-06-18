import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IRegistroIngresoDeDiaRepository } from '../../domain/repositories/iregistro-ingreso-de-dia.repository';
import { RegistroIngresoDeDiaEntity } from '../../domain/models/registro-ingreso-de-dia.entity';

@Injectable()
export class ObtenerRegistroIngresoDeDiaUseCase {
  private readonly repository = inject(IRegistroIngresoDeDiaRepository);

  execute(): Observable<RegistroIngresoDeDiaEntity[]> {
    return this.repository.obtenerIngresos();
  }
}
