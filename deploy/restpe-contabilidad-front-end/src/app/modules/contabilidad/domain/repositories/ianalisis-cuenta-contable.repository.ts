import { Observable } from 'rxjs';
import { AnalisisCuentaContableEntity } from '../models/analisis-cuenta-contable.entity';

/**
 * IAnalisisCuentaContableRepository — Contrato de dominio (SRP).
 * Define la operación de lectura del análisis de cuenta contable.
 */
export abstract class IAnalisisCuentaContableRepository {
  abstract obtenerTodos(): Observable<AnalisisCuentaContableEntity>;
}
