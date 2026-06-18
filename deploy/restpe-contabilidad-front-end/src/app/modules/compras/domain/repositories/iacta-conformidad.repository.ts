import { Observable } from 'rxjs';
import {
  ActaConformidadEntity,
  OrdenServicioPendienteConformidadEntity,
} from '../models/acta-conformidad.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

/**
 * Contrato del repositorio de Actas de Conformidad de OS.
 */
export abstract class IActaConformidadRepository {
  abstract obtenerPendientes(): Observable<OrdenServicioPendienteConformidadEntity[]>;
  abstract obtenerActas(): Observable<ActaConformidadEntity[]>;
  abstract obtenerPorId(id: string): Observable<ActaConformidadEntity>;
  abstract crear(acta: ActaConformidadEntity): Observable<ApiResponse<ActaConformidadEntity>>;
  abstract aprobar(id: string): Observable<ApiResponse<boolean>>;
  abstract anular(id: string): Observable<ApiResponse<boolean>>;
  abstract descargarPdf(id: string): Observable<Blob>;
}
