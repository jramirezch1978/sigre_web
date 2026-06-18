import { Observable } from 'rxjs';
import { ClonacionAsientosEntity } from '../models/clonacion-asientos.entity';

/**
 * IClonacionAsientosRepository — Puerto de dominio (lectura).
 * Define el contrato que debe cumplir la implementación de infraestructura.
 */
export abstract class IClonacionAsientosRepository {
  abstract obtenerTodos(): Observable<ClonacionAsientosEntity>;
}
