import { Observable } from 'rxjs';
import { CompraProcesadaEntity } from '../models/compra-procesada.entity';

/**
 * Puerto (abstracción) del repositorio de Reporte de Compras.
 * Usado como token DI — las implementaciones reales están en infrastructure/.
 */
export abstract class IReporteComprasRepository {
  abstract obtenerReporte(): Observable<CompraProcesadaEntity[]>;
}
