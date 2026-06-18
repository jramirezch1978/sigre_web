import { Observable } from 'rxjs';
import { AjustesReclasificacionEntity } from '../models/ajustes-reclasificacion.entity';

/**
 * IAjustesReclasificacionRepository — Puerto de dominio (lectura).
 * Define el contrato que debe cumplir la implementación de infraestructura.
 */
export abstract class IAjustesReclasificacionRepository {
  abstract obtenerTodos(): Observable<AjustesReclasificacionEntity>;
}
