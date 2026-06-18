import { Observable } from 'rxjs';
import { SeleccionarCuentaContableEntity } from '../models/seleccionar-cuenta-contable.entity';

/**
 * ISeleccionarCuentaContableRepository — Puerto de dominio (lectura).
 * Define el contrato que debe cumplir la implementación de infraestructura.
 */
export abstract class ISeleccionarCuentaContableRepository {
  abstract obtenerTodos(): Observable<SeleccionarCuentaContableEntity>;
}
