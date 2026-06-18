import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IClasifActivoRepository } from '../../domain/repositories/iclasif-activo.repository';
import { ClasifActivoEntity } from '../../domain/models/clasif-activo.entity';

/**
 * Use Case: Obtener todas las clasificaciones de activos.
 * SRP: única responsabilidad — consulta de clasificaciones.
 */
@Injectable()
export class ObtenerClasifActivosUseCase {
  private readonly repository = inject(IClasifActivoRepository);

  execute(): Observable<ClasifActivoEntity[]> {
    return this.repository.obtenerTodos();
  }
}
