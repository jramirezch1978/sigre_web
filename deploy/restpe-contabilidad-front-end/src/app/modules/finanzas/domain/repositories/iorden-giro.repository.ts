import { Observable } from 'rxjs';
import { OrdenGiroEntity } from '../models/orden-giro.entity';

/** Filtros del listado de solicitudes de giro (backend: fechaDesde/fechaHasta/estado). */
export interface OrdenGiroFiltros {
  fechaDesde?: string;   // yyyy-MM-dd
  fechaHasta?: string;   // yyyy-MM-dd
  estado?: string;       // flagEstado: '3' pendiente, '1' aprobada, '0' anulada
}

export abstract class IOrdenGiroRepository {
  abstract obtenerTodos(filtros?: OrdenGiroFiltros): Observable<OrdenGiroEntity[]>;
  abstract guardar(entity: OrdenGiroEntity): Observable<OrdenGiroEntity>;
  abstract actualizar(entity: OrdenGiroEntity): Observable<OrdenGiroEntity>;
  abstract anular(id: number): Observable<boolean>;
  /** Catálogo de sucursales (ms-core-maestros) para el selector. */
  abstract listarSucursales(): Observable<{ id: number; nombre: string }[]>;
  /** Catálogo de centros de costo (ms-contabilidad) para el selector. */
  abstract listarCentrosCosto(): Observable<{ id: number; nombre: string }[]>;
}
