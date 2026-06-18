import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReporteValidacionRepository } from '../../domain/repositories/ireporte-validacion.repository';
import { ConsistenciaEntity, ConsistenciaPreEntity, AsientosDesEntity } from '../../domain/models/reporte-validacion.entity';

/**
 * ObtenerReporteValidacionUseCase — Caso de uso de lectura.
 * Orquesta la obtención de cada tipo de reporte de validación contable.
 */
@Injectable()
export class ObtenerReporteValidacionUseCase {

  private readonly repository = inject(IReporteValidacionRepository);

  ejecutarConsistencia(): Observable<ConsistenciaEntity> {
    return this.repository.obtenerConsistencia();
  }

  ejecutarConsistenciaPre(): Observable<ConsistenciaPreEntity> {
    return this.repository.obtenerConsistenciaPre();
  }

  ejecutarAsientosDes(): Observable<AsientosDesEntity> {
    return this.repository.obtenerAsientosDes();
  }
}
