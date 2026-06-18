import { Observable } from 'rxjs';
import { ConsultaCentroCostosEntity } from '../models/consulta-centro-costos.entity';

/**
 * IConsultaCentroCostosRepository — Puerto de dominio (abstracción).
 * Define el contrato que debe implementar la capa de infraestructura.
 * Cumple con el Principio de Inversión de Dependencias (DIP).
 */
export abstract class IConsultaCentroCostosRepository {
  abstract obtenerTodos(): Observable<ConsultaCentroCostosEntity>;
}
