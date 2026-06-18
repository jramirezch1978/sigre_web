import { Observable } from 'rxjs';
import { GestionAsientosAutomaticoEntity } from '../models/gestion-asientos-automatico.entity';

/**
 * IGestionAsientosAutomaticosRepository — Puerto de dominio (lectura).
 * Define el contrato que debe cumplir la implementación de infraestructura.
 */
export abstract class IGestionAsientosAutomaticosRepository {
  abstract obtenerTodos(): Observable<GestionAsientosAutomaticoEntity>;
}
