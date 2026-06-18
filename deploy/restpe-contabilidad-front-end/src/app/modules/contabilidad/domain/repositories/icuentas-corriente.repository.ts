import { Observable } from 'rxjs';
import { CuentasCorrienteEntity } from '../models/cuentas-corriente.entity';

/**
 * ICuentasCorrienteRepository — Puerto de dominio (abstracción).
 * Define el contrato que debe implementar la capa de infraestructura.
 * Cumple con el Principio de Inversión de Dependencias (DIP).
 */
export abstract class ICuentasCorrienteRepository {
  abstract obtenerTodos(): Observable<CuentasCorrienteEntity>;
}
