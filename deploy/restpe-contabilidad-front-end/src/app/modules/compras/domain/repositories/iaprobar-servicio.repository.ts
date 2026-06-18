import { Observable } from 'rxjs';
import { OrdenServicioEntity } from '../models/orden-servicio.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Repositorio abstracto para el flujo de Aprobación de Servicios - Domain Layer
 * Define el contrato para obtener órdenes de servicio pendientes y cambiar su estado
 */
export abstract class IAprobarServicioRepository {
  /**
   * Obtiene todas las órdenes de servicio con estado "Pendiente"
   */
  abstract obtenerOrdenesPendientes(): Observable<OrdenServicioEntity[]>;

  /**
   * Obtiene todas las órdenes de servicio (sin filtro de estado)
   */
  abstract obtenerTodasLasOrdenes(): Observable<OrdenServicioEntity[]>;

  /**
   * Obtiene una orden de servicio por su número
   */
  abstract obtenerPorNumero(numeroOrden: string): Observable<OrdenServicioEntity>;

  /**
   * Aprueba una orden de servicio (cambia estado a "Aprobada")
   */
  abstract aprobarOrden(numeroOrden: string): Observable<ApiResponse<OrdenServicioEntity>>;

  /**
   * Rechaza una orden de servicio (cambia estado a "Rechazada")
   */
  abstract rechazarOrden(numeroOrden: string, motivo: string): Observable<ApiResponse<OrdenServicioEntity>>;

  /**
   * Retorna una orden de servicio (cambia estado a "Retornada")
   */
  abstract retornarOrden(numeroOrden: string, motivo: string): Observable<ApiResponse<OrdenServicioEntity>>;

  /**
   * Aprueba múltiples órdenes de servicio en bloque
   */
  abstract aprobarOrdenesMasivo(numerosOrden: string[]): Observable<ApiResponse<OrdenServicioEntity[]>>;
}
