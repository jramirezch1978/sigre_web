import { Observable } from 'rxjs';
import { CompraPorIngresarEntity } from '../models/compra-por-ingresar.entity';

/**
 * Contrato de dominio para el reporte de Compras por Ingresar (read-only)
 */
export abstract class IReporteComprasIngresarRepository {
  abstract obtenerReporte(): Observable<CompraPorIngresarEntity[]>;
}
