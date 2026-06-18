import { Observable } from 'rxjs';
import { CompraTransitoEntity } from '../models/compra-transito.entity';

/**
 * Contrato de dominio para el reporte de Compras en Tránsito (read-only)
 */
export abstract class IReporteComprasTransitoRepository {
  abstract obtenerReporte(): Observable<CompraTransitoEntity[]>;
}
