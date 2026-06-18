import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGeneracionAsientosIndexacionRepository } from '../../domain/repositories/igeneracion-asientos-indexacion.repository';
import { GeneracionAsientosIndexacionEntity } from '../../domain/models/generacion-asientos-indexacion.entity';

@Injectable()
export class ObtenerGeneracionAsientosIndexacionUseCase {
  private readonly repo = inject(IGeneracionAsientosIndexacionRepository);

  execute(): Observable<GeneracionAsientosIndexacionEntity[]> {
    return this.repo.obtenerTodos();
  }
}
