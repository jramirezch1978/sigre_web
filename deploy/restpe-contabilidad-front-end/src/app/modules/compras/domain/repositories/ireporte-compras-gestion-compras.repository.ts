import { Observable } from 'rxjs';
import { GestionCompraEntity } from '../models/gestion-compra.entity';

/**
 * Contrato (puerto) del repositorio de Reporte de Gestión de Compras.
 * El dominio sólo depende de esta abstracción — nunca de la implementación.
 */
export abstract class IReporteComprasGestionComprasRepository {
  abstract obtenerReporte(): Observable<GestionCompraEntity[]>;
}
