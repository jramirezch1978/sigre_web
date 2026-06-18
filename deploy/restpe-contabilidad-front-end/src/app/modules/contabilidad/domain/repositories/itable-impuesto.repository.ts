import { Observable } from 'rxjs';
import { TablaImpuestoEntity } from '../models/tabla-impuesto.entity';
import { ApiResponse } from 'src/app/shared/models/api-response.model';

/**
 * ITablaImpuestoRepository — Domain Repository Interface.
 * Contrato de acceso a datos para la entidad TablaImpuesto.
 * Las implementaciones concretas residen en la capa de infraestructura.
 */
export abstract class ITablaImpuestoRepository {
  /** Obtiene la lista completa de impuestos */
  abstract obtenerTodos(): Observable<TablaImpuestoEntity[]>;
  /** Guarda un nuevo registro de impuesto */
  abstract guardar(item: TablaImpuestoEntity): Observable<ApiResponse<TablaImpuestoEntity>>;
  /** Actualiza un registro de impuesto existente */
  abstract actualizar(item: TablaImpuestoEntity): Observable<ApiResponse<TablaImpuestoEntity>>;
}
