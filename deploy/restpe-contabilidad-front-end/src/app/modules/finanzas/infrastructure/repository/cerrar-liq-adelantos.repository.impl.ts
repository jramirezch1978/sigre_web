import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { ICerrarLiqAdelantosRepository, ValidacionCierre, OpcionCatalogo } from '../../domain/repositories/icerrar-liq-adelantos.repository';
import { CerrarLiqAdelantosEntity } from '../../domain/models/cerrar-liq-adelantos.entity';

/** Respuesta del backend `GET /liquidaciones` (FI323). */
interface LiquidacionResponse {
  id: number;
  nroLiquidacion?: string;
  docTipoCodigo?: string;
  proveedorRazonSocial?: string;
  fechaRegistro?: string;
  fechaLiquidacion?: string;
  monedaId?: number;
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
 * Cliente HTTP de la bandeja de cierre de liquidación de adelantos contra
 * `ms-finanzas` (`/api/finanzas/liquidaciones`).
 *
 * - `obtenerTodos()` → `GET /liquidaciones`.
 * - `actualizar()` → `POST /{id}/cerrar` (FI324) cuando el componente cierra
 *   (`cla_estado === 'Cerrada'`). La reversión (`Revertida`) NO tiene endpoint
 *   en el backend → queda PENDIENTE (devuelve error explícito).
 *
 * El token (Bearer) y el tenant los agregan los interceptores globales.
 */
@Injectable({ providedIn: 'root' })
export class CerrarLiqAdelantosRepositoryImpl implements ICerrarLiqAdelantosRepository {
  private readonly http = inject(HttpClient);
  private readonly base = `${environment.apiBaseUrl}/finanzas/liquidaciones`;
  private readonly monedasUrl = `${environment.apiBaseUrl}/core/monedas`;

  obtenerTodos(): Observable<CerrarLiqAdelantosEntity[]> {
    return this.http
      .get<ApiResponse<PageData<LiquidacionResponse>>>(`${this.base}?size=1000&sort=id,asc`)
      .pipe(map((r) => (this.unwrap(r)?.content ?? []).map((l) => this.toEntity(l))));
  }

  actualizar(entity: CerrarLiqAdelantosEntity): Observable<CerrarLiqAdelantosEntity> {
    if (entity.id == null) {
      return throwError(() => new Error('La liquidación no tiene id; no se puede procesar.'));
    }

    if (entity.cla_estado === 'Cerrada') {
      const body = { observacion: entity.cla_observaciones ?? '' };
      return this.http
        .post<ApiResponse<unknown>>(`${this.base}/${entity.id}/cerrar`, body)
        .pipe(map((r) => { this.unwrap(r); return entity; }));
    }

    // Reversión: PENDIENTE — el backend solo permite cerrar (no revertir) una
    // liquidación.
    return throwError(() => new Error(
      'Reversión no disponible: el backend de liquidaciones solo permite cerrar. ' +
      'La reversión queda pendiente de un endpoint.'
    ));
  }

  validarCierre(id: number): Observable<ValidacionCierre> {
    return this.http
      .get<ApiResponse<ValidacionCierre>>(`${this.base}/${id}/validacion-cierre`)
      .pipe(map((r) => this.unwrap(r)));
  }

  listarMonedas(): Observable<OpcionCatalogo[]> {
    return this.http
      .get<ApiResponse<PageData<any>>>(`${this.monedasUrl}?size=1000`)
      .pipe(map((r) => (this.unwrap(r)?.content ?? []).map((m: any) => ({
        id: m.id,
        nombre: `${m.simbolo ?? m.siglaMoneda ?? ''} ${m.nombre ?? ''}`.trim(),
      }))));
  }

  /** Mapea la respuesta del backend al modelo que consume la bandeja. */
  private toEntity(l: LiquidacionResponse): CerrarLiqAdelantosEntity {
    return {
      id: l.id,
      cla_num_liquidacion: l.nroLiquidacion ?? String(l.id),
      cla_fecha_desembolso: l.fechaRegistro ?? '',
      cla_fecha_aprobacion: l.fechaLiquidacion ?? '',
      cla_fecha_cierre: '',
      cla_tipo_beneficiario: '',
      cla_beneficiario: l.proveedorRazonSocial ?? '',
      cla_tipo_documento: l.docTipoCodigo ?? '',
      cla_documento_beneficiario: '',
      cla_tipo_gasto: '',
      cla_centro_costo: '',
      cla_monto_adelantado: Number(l.importeNeto ?? 0),
      cla_total_gastado: Number(l.importeNeto ?? 0),
      cla_monto_gastado: Number(l.importeNeto ?? 0),
      cla_moneda: l.monedaCodigo ?? '',
      cla_moneda_id: l.monedaId,
      cla_responsable: '',
      cla_estado: this.mapEstado(l.flagEstado),
      cla_observaciones: l.observacion ?? '',
      cla_proveedor: l.proveedorRazonSocial ?? '',
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
