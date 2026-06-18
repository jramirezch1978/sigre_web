import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IAprobarGiroRepository } from '../../domain/repositories/iaprobar-giro.repository';
import { AprobarGiroEntity } from '../../domain/models/aprobar-giro.entity';

/** Respuesta del backend `GET /pendientes-aprobacion` (FI308). */
interface SolicitudPendienteAprobacion {
  id: number;
  solicitanteId?: number;
  numero?: string;
  fecha?: string;
  monto?: number;
  motivo?: string;
  flagEstado?: string;
}

interface ApiResponse<T> {
  success: boolean;
  message?: string;
  errorCode?: string;
  data: T;
}
interface PageData<T> { content: T[]; }

/**
 * Cliente HTTP de la bandeja de aprobación de solicitudes de giro contra
 * `ms-finanzas` (`/api/finanzas/solicitudes-giro`).
 *
 * - `obtenerTodos()` → `GET /pendientes-aprobacion` (solo solicitudes en estado
 *   pendiente; flagEstado=3).
 * - `actualizar()` → `POST /{id}/aprobar` o `POST /{id}/rechazar` según el estado
 *   que fija el componente (`ag_estado`).
 *
 * El token (Bearer) y las cabeceras de tenant las agregan los interceptores
 * globales (jwt/tenant).
 *
 * NOTA: el endpoint del backend solo entrega `numero, fecha, monto, motivo,
 * estado` (+ IDs); no devuelve nombres de beneficiario/banco/moneda/sucursal,
 * por lo que esas columnas de la bandeja quedan vacías hasta que el backend las
 * exponga.
 */
@Injectable({ providedIn: 'root' })
export class AprobarGiroRepositoryImpl implements IAprobarGiroRepository {
  private readonly http = inject(HttpClient);
  private readonly base = `${environment.apiBaseUrl}/finanzas/solicitudes-giro`;

  obtenerTodos(): Observable<AprobarGiroEntity[]> {
    return this.http
      .get<ApiResponse<PageData<SolicitudPendienteAprobacion>>>(
        `${this.base}/pendientes-aprobacion?size=1000&sort=id,asc`
      )
      .pipe(map((r) => (this.unwrap(r)?.content ?? []).map((s) => this.toEntity(s))));
  }

  actualizar(entity: AprobarGiroEntity): Observable<AprobarGiroEntity> {
    if (entity.id == null) {
      return throwError(() => new Error('La solicitud no tiene id; no se puede procesar.'));
    }

    if (entity.ag_estado === 'Rechazado') {
      const body = { observacion: entity.ag_motivo_rechazo ?? '' };
      return this.http
        .post<ApiResponse<unknown>>(`${this.base}/${entity.id}/rechazar`, body)
        .pipe(map((r) => { this.unwrap(r); return entity; }));
    }

    // Aprobación (ag_estado === 'Aprobada')
    const body = { observacion: entity.ag_glosa_contable ?? '', crearOrdenGiro: false };
    return this.http
      .post<ApiResponse<unknown>>(`${this.base}/${entity.id}/aprobar`, body)
      .pipe(map((r) => { this.unwrap(r); return entity; }));
  }

  /** Mapea la respuesta del backend al modelo que consume la bandeja. */
  private toEntity(s: SolicitudPendienteAprobacion): AprobarGiroEntity {
    return {
      id: s.id,
      ag_num_orden_giro: s.numero ?? String(s.id),
      ag_fecha_solicitud: s.fecha ?? '',
      // Campos REALES del backend (pendientes-aprobacion).
      ag_solicitante_id: s.solicitanteId,
      ag_motivo: s.motivo ?? '',
      ag_monto_giro: Number(s.monto ?? 0),
      ag_estado: 'Pendiente',
      // Compat: el form/columnas heredados aún leen estos; sin respaldo en backend → vacíos.
      ag_beneficiario: s.solicitanteId != null ? `Solicitante #${s.solicitanteId}` : '',
      ag_documento_asociado: s.numero ?? '',
      ag_banco: '',
      ag_moneda: '',
      ag_responsable: '',
      ag_glosa_contable: s.motivo ?? '',
    };
  }

  private unwrap<T>(r: ApiResponse<T>): T {
    if (r && r.success === false) {
      throw new Error(r.message || r.errorCode || 'Error del servidor');
    }
    return r?.data as T;
  }
}
