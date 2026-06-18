import { Observable } from 'rxjs';
import { ConsistenciaEntity, ConsistenciaPreEntity, AsientosDesEntity } from '../models/reporte-validacion.entity';

/**
 * IReporteValidacionRepository — Contrato de dominio (SRP).
 * Define las operaciones de lectura del reporte de validación contable.
 */
export abstract class IReporteValidacionRepository {
  abstract obtenerConsistencia(): Observable<ConsistenciaEntity>;
  abstract obtenerConsistenciaPre(): Observable<ConsistenciaPreEntity>;
  abstract obtenerAsientosDes(): Observable<AsientosDesEntity>;
}
