import { Observable } from 'rxjs';
import { OrdenCompraEntity } from '../models/orden-compra.entity';

/**
 * Interfaz del repositorio de Órdenes de Compra (Domain Layer)
 * Define el contrato para las operaciones de datos
 * Sigue el principio de Inversión de Dependencias (DIP)
 */
export abstract class IOrdenCompraRepository {
  abstract obtenerOrdenesCompra(): Observable<OrdenCompraEntity[]>;
  abstract obtenerOrdenCompraPorId(id: string): Observable<OrdenCompraEntity | null>;
  abstract guardarOrdenCompra(ordenCompra: OrdenCompraEntity): Observable<OrdenCompraEntity>;
  abstract actualizarOrdenCompra(ordenCompra: OrdenCompraEntity): Observable<OrdenCompraEntity>;
  abstract eliminarOrdenCompra(id: string): Observable<boolean>;
}
