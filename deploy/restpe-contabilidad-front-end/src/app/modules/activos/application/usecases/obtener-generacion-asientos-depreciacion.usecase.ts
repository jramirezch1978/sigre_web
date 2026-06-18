import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGeneracionAsientosDepreciacionRepository } from '../../domain/repositories/igeneracion-asientos-depreciacion.repository';
import { GeneracionAsientosDepreciacionEntity } from '../../domain/models/generacion-asientos-depreciacion.entity';

@Injectable()
export class ObtenerGeneracionAsientosDepreciacionUseCase {
  private readonly repository = inject(IGeneracionAsientosDepreciacionRepository);

  execute(): Observable<GeneracionAsientosDepreciacionEntity[]> {
    return this.repository.obtenerTodos();
  }
}
