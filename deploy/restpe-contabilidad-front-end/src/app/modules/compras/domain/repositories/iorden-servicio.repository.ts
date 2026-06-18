import { Observable } from 'rxjs';
import { OrdenServicioEntity } from '../models/orden-servicio.entity';

/**
 * Interfaz del repositorio de Órdenes de Servicio (Domain Layer)
 * Define el contrato para las operaciones de datos
 * Sigue el principio de Inversión de Dependencias (DIP)
 */
export abstract class IOrdenServicioRepository {
  abstract obtenerOrdenesServicio(): Observable<OrdenServicioEntity[]>;
  abstract obtenerOrdenServicioPorId(id: string): Observable<OrdenServicioEntity | null>;
  abstract guardarOrdenServicio(ordenServicio: OrdenServicioEntity): Observable<OrdenServicioEntity>;
  abstract actualizarOrdenServicio(ordenServicio: OrdenServicioEntity): Observable<OrdenServicioEntity>;
  abstract eliminarOrdenServicio(id: string): Observable<boolean>;
}
