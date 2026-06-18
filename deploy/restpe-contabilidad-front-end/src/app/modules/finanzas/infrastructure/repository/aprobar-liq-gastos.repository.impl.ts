import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IAprobarLiqGastosRepository, ValidacionCierre } from '../../domain/repositories/iaprobar-liq-gastos.repository';
import { LiqRendicionEntity } from '../../domain/models/liq-rendicion.entity';

/** Respuesta del backend `GET /liquidaciones` (FI323). */
interface LiquidacionResponse {
  id: number;
  nroLiquidacion?: string;
  proveedorRazonSocial?: string;
  fechaRegistro?: string;
  fechaLiquidacion?: string;
  monedaCodigo?: string;
  importeNeto?: number;
  saldo?: number;
  observacion?: string;
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
 * Cliente HTTP de la bandeja de aprobación de rendición de gastos contra
 * `ms-finanzas` (`/api/finanzas/liquidaciones`).
 *
 * - `obtenerTodos()` → `GET /liquidaciones`.
 * - `actualizar()` → `POST /{id}/cerrar` SOLO cuando el componente aprueba
 *   (`lr_estado === 'Aprobada'`). El backend de liquidaciones modela la
 *   aprobación como el cierre (FI324): no existe endpoint de rechazo/observación,
 *   por lo que esas acciones quedan PENDIENTES (devuelven error explícito).
 *
 * El token (Bearer) y el tenant los agregan los interceptores globales.
 */
@Injectable({ providedIn: 'root' })
export class AprobarLiqGastosRepositoryImpl implements IAprobarLiqGastosRepository {
  private readonly http = inject(HttpClient);
  private readonly base = `${environment.apiBaseUrl}/finanzas/liquidaciones`;

  obtenerTodos(): Observable<LiqRendicionEntity[]> {
    return this.http
      .get<ApiResponse<PageData<LiquidacionResponse>>>(`${this.base}?size=1000&sort=id,asc`)
      .pipe(map((r) => (this.unwrap(r)?.content ?? []).map((l) => this.toEntity(l))));
  }

  actualizar(entity: LiqRendicionEntity): Observable<LiqRendicionEntity> {
    if (entity.id == null) {
      return throwError(() => new Error('La liquidación no tiene id; no se puede procesar.'));
    }

    // El backend de liquidaciones solo expone 2 acciones de cambio de estado:
    //   Cerrar  → POST /{id}/cerrar  (1 Activa → 2 Cerrada)
    //   Anular  → POST /{id}/anular  (1 Activa → 0 Anulada)
    if (entity.lr_estado === 'Cerrada') {
      const body = { observacion: entity.observaciones ?? '' };
      return this.http
        .post<ApiResponse<unknown>>(`${this.base}/${entity.id}/cerrar`, body)
        .pipe(map((r) => { this.unwrap(r); return entity; }));
    }
    if (entity.lr_estado === 'Anulada') {
      return this.http
        .post<ApiResponse<unknown>>(`${this.base}/${entity.id}/anular`, {})
        .pipe(map((r) => { this.unwrap(r); return entity; }));
    }

    // SOBRA: Aprobar / Rechazar / Observar NO existen como endpoint en el backend
    // de liquidaciones → quedan pendientes de que backend los cree.
    return throwError(() => new Error(
      'Acción no disponible: el backend de liquidaciones solo permite Cerrar y Anular.'
    ));
  }

  validarCierre(id: number): Observable<ValidacionCierre> {
    return this.http
      .get<ApiResponse<ValidacionCierre>>(`${this.base}/${id}/validacion-cierre`)
      .pipe(map((r) => this.unwrap(r)));
  }

  /** Mapea la respuesta del backend al modelo que consume la bandeja. */
  private toEntity(l: LiquidacionResponse): LiqRendicionEntity {
    return {
      id: l.id,
      lr_num_liquidacion: l.nroLiquidacion ?? String(l.id),
      lr_fecha_desembolso: l.fechaRegistro ?? l.fechaLiquidacion ?? '',
      lr_beneficiario: l.proveedorRazonSocial ?? '',
      lr_tipo_gasto: '',
      lr_centro_costo: '',
      lr_monto_adelantado: Number(l.importeNeto ?? 0),
      lr_monto_gastado: Number(l.importeNeto ?? 0),
      lr_moneda: l.monedaCodigo ?? '',
      lr_estado: this.mapEstado(l.flagEstado),
      observaciones: l.observacion ?? '',
    };
  }

  /** flagEstado backend: "1"=activa (pendiente cierre), "2"=cerrada, "0"=anulada. */
  private mapEstado(flag?: string): string {
    if (flag === '2') return 'Cerrada';
    if (flag === '0') return 'Anulada';
    return 'Pendiente';
  }

  private unwrap<T>(r: ApiResponse<T>): T {
    if (r && r.success === false) {
      throw new Error(r.message || r.errorCode || 'Error del servidor');
    }
    return r?.data as T;
  }
}
