import { Observable } from 'rxjs';
import { ConsistenciaAsientosEntity } from '../models/consistencia-asientos.entity';

/**
 * IConsistenciaAsientosRepository — Puerto de dominio (lectura).
 * Define el contrato que debe cumplir la implementación de infraestructura.
 */
export abstract class IConsistenciaAsientosRepository {
  abstract obtenerTodos(): Observable<ConsistenciaAsientosEntity[]>;
}
