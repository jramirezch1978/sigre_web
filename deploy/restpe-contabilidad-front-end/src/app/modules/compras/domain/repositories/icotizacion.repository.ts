import { Observable } from 'rxjs';
import { CotizacionEntity } from '../models/cotizacion.entity';

/**
 * Interfaz del repositorio de Cotizaciones (Domain Layer)
 * Define el contrato para las operaciones de datos
 * Sigue el principio de Inversión de Dependencias (DIP)
 */
export abstract class ICotizacionRepository {
  abstract obtenerCotizaciones(): Observable<CotizacionEntity[]>;
  abstract obtenerCotizacionPorId(id: string): Observable<CotizacionEntity | null>;
  abstract guardarCotizacion(cotizacion: Partial<CotizacionEntity>): Observable<CotizacionEntity>;
  abstract actualizarCotizacion(cotizacion: CotizacionEntity): Observable<CotizacionEntity>;
  abstract eliminarCotizacion(id: string): Observable<boolean>;
}
