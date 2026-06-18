import { Observable } from 'rxjs';
import { AnalisisProveedorEntity } from '../models/analisis-proveedor.entity';

/**
 * Contrato (puerto) del repositorio de Reporte de Análisis de Proveedores.
 * El dominio sólo depende de esta abstracción — nunca de la implementación.
 */
export abstract class IReporteAnalisisProveedoresRepository {
  abstract obtenerReporte(): Observable<AnalisisProveedorEntity[]>;
}
