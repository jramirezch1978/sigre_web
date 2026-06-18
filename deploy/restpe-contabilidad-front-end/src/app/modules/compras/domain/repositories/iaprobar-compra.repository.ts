import { Observable } from 'rxjs';
import { OrdenCompraEntity } from '../models/orden-compra.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Repositorio abstracto para el flujo de Aprobación de Compras - Domain Layer
 * Define el contrato para obtener órdenes pendientes y cambiar su estado
 */
export abstract class IAprobarCompraRepository {
  /**
   * Obtiene todas las órdenes de compra con estado "Pendiente"
   */
  abstract obtenerOrdenesPendientes(): Observable<OrdenCompraEntity[]>;

  /**
   * Obtiene todas las órdenes de compra (sin filtro de estado)
   */
  abstract obtenerTodasLasOrdenes(): Observable<OrdenCompraEntity[]>;

  /**
   * Obtiene una orden por su número
   */
  abstract obtenerPorNumero(numeroOrden: string): Observable<OrdenCompraEntity>;

  /**
   * Aprueba una orden de compra (cambia estado a "Aprobada")
   */
  abstract aprobarOrden(numeroOrden: string, observacion?: string): Observable<ApiResponse<OrdenCompraEntity>>;

  /**
   * Rechaza una orden de compra (cambia estado a "Rechazada")
   */
  abstract rechazarOrden(numeroOrden: string, motivo: string): Observable<ApiResponse<OrdenCompraEntity>>;

  /**
   * Retorna una orden de compra (cambia estado a "Retornada")
   */
  abstract retornarOrden(numeroOrden: string, motivo: string): Observable<ApiResponse<OrdenCompraEntity>>;

  /**
   * Aprueba múltiples órdenes en bloque
   */
  abstract aprobarOrdenesMasivo(numerosOrden: string[]): Observable<ApiResponse<OrdenCompraEntity[]>>;
}
