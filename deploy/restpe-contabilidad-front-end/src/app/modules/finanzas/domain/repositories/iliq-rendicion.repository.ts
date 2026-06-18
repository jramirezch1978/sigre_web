import { Observable } from 'rxjs';
import { LiqRendicionEntity } from '../models/liq-rendicion.entity';

/** Opción genérica id/nombre para los selectores. */
export interface OpcionCatalogo { id: number; nombre: string; }

export abstract class ILiqRendicionRepository {
  abstract obtenerTodos(): Observable<LiqRendicionEntity[]>;
  /** Detalle completo (incluye líneas) por id — el listado no trae detalles. */
  abstract obtenerPorId(id: number): Observable<LiqRendicionEntity>;
  abstract guardar(entity: LiqRendicionEntity): Observable<LiqRendicionEntity>;
  abstract actualizar(entity: LiqRendicionEntity): Observable<LiqRendicionEntity>;
  abstract anular(id: number): Observable<boolean>;
  /** Solicitudes de giro aprobadas (flagEstado=1) para asociar la liquidación. */
  abstract listarSolicitudesAprobadas(): Observable<OpcionCatalogo[]>;
  /** Conceptos financieros (cabecera y detalle). */
  abstract listarConceptos(): Observable<OpcionCatalogo[]>;
  /** Cuentas por pagar para las líneas de detalle. */
  abstract listarCuentasPagar(): Observable<OpcionCatalogo[]>;
  /** Monedas (ms-core-maestros) para la cabecera. */
  abstract listarMonedas(): Observable<OpcionCatalogo[]>;
}
