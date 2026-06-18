import { Observable } from 'rxjs';
import { SugerenciaCompraEntity } from '../models/sugerencia-compra.entity';

/**
 * Puerto (abstracción) del repositorio de Reporte de Compras Sugeridas.
 * Usado como token DI — las implementaciones reales están en infrastructure/.
 */
export abstract class IReporteComprasSugeridasRepository {
  abstract obtenerReporte(): Observable<SugerenciaCompraEntity[]>;
}
