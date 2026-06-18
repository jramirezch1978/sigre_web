import { Observable } from 'rxjs';
import { CompraPorCategoriaEntity } from '../models/compra-por-categoria.entity';

/**
 * Contrato (puerto) del repositorio de Reporte de Compras por Categoría.
 * El dominio sólo depende de esta abstracción — nunca de la implementación.
 */
export abstract class IReporteComprasCategoriaRepository {
  abstract obtenerReporte(): Observable<CompraPorCategoriaEntity[]>;
}
