import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { ILiqRendicionRepository, OpcionCatalogo } from '../../domain/repositories/iliq-rendicion.repository';
import { LiqRendicionEntity, LiqRendicionDetalleLinea } from '../../domain/models/liq-rendicion.entity';

/** Respuesta del backend (ms-finanzas · finanzas.liquidacion). */
interface LiquidacionResponse {
  id: number;
  solicitudGiroId?: number;
  nroLiquidacion?: string;
  fechaLiquidacion?: string;
  monedaId?: number;
  monedaCodigo?: string;
  conceptoFinancieroId?: number;
  importeNeto?: number;
  saldo?: number;
  tasaCambio?: number;
  observacion?: string;
  flagEstado?: string;
  detalles?: LiquidacionDetResponse[];
}
interface LiquidacionDetResponse {
  id?: number; item?: number; conceptoFinancieroId?: number;
  cntasPagarId?: number; cntasCobrarId?: number; importe?: number;
  flagRetencion?: string; importeRetenido?: number;
}

/** Cuerpo de creación/actualización (LiquidacionRequest). */
interface LiquidacionRequest {
  solicitudGiroId: number;
  conceptoFinancieroId: number;
  importeNeto: number;
  tasaCambio: number;
  monedaId?: number | null;
  fechaLiquidacion?: string | null;
  observacion?: string | null;
  detalles: LiquidacionDetalleRequest[];
}
interface LiquidacionDetalleRequest {
  item: number;
  conceptoFinancieroId: number;
  cntasPagarId?: number | null;
  cntasCobrarId?: number | null;
  importe: number;
  /** Signo de la línea. Imprescindible: el backend cuadra con SUM(importe * factorSigno);
   *  si va null, el cierre nunca cuadra. Por defecto 1 (positivo). */
  factorSigno?: number;
  flagRetencion?: string;
  importeRetenido?: number;
}

interface ApiResp<T> { success: boolean; message?: string; errorCode?: string; data: T; }
interface PageData<T> { content: T[]; }

/** flagEstado backend → etiqueta de la grilla. 1=Aprobada(activa), 0=Anulada/Rechazada. */
/**
 * Estados de LIQUIDACION (distintos a los de orden de giro):
 *   '1' = Activa (recién creada, pendiente de cierre) · '2' = Cerrada · '0' = Anulada.
 */
function estadoLabel(flag?: string): string {
  if (flag === '0') { return 'Anulada'; }
  if (flag === '2') { return 'Cerrada'; }
  return 'Pendiente'; // '1' = activa / pendiente de cierre
}

/**
 * Liquidaciones / Rendición de gastos — CRUD real contra ms-finanzas
 * (`/api/finanzas/liquidaciones`). El token/tenant los inyectan los interceptores.
 * Notas del backend:
 * - Master-detail: la liquidación se asocia a una solicitud de giro APROBADA y exige
 *   `conceptoFinancieroId`, `importeNeto`, `tasaCambio` y `detalles[≥1]`.
 * - Cada detalle exige `item`, `conceptoFinancieroId`, `importe` y `cntasPagarId` (o `cntasCobrarId`).
 * - POST crea · PUT edita (si activa) · POST `/{id}/anular`.
 */
@Injectable({ providedIn: 'root' })
export class LiqRendicionRepositoryImpl implements ILiqRendicionRepository {

  private readonly http = inject(HttpClient);
  private readonly base = `${environment.apiBaseUrl}/finanzas/liquidaciones`;
  private readonly solicitudesUrl = `${environment.apiBaseUrl}/finanzas/solicitudes-giro`;
  private readonly conceptosUrl = `${environment.apiBaseUrl}/finanzas/conceptos-financieros`;
  private readonly cuentasPagarUrl = `${environment.apiBaseUrl}/finanzas/cuentas-pagar`;
  private readonly monedasUrl = `${environment.apiBaseUrl}/core/monedas`;

  obtenerTodos(): Observable<LiqRendicionEntity[]> {
    return this.http.get<ApiResp<PageData<LiquidacionResponse>>>(`${this.base}?size=1000`).pipe(
      map((r) => (this.unwrap(r)?.content ?? []).map((l) => this.toEntity(l)))
    );
  }

  obtenerPorId(id: number): Observable<LiqRendicionEntity> {
    return this.http.get<ApiResp<LiquidacionResponse>>(`${this.base}/${id}`).pipe(
      map((r) => this.toEntity(this.unwrap(r)))
    );
  }

  guardar(entity: LiqRendicionEntity): Observable<LiqRendicionEntity> {
    return this.http.post<ApiResp<LiquidacionResponse>>(this.base, this.toRequest(entity)).pipe(
      map((r) => this.toEntity(this.unwrap(r)))
    );
  }

  actualizar(entity: LiqRendicionEntity): Observable<LiqRendicionEntity> {
    const id = entity.id;
    if (id == null) { throw new Error('No se pudo determinar el id de la liquidación a actualizar'); }
    return this.http.put<ApiResp<LiquidacionResponse>>(`${this.base}/${id}`, this.toRequest(entity)).pipe(
      map((r) => this.toEntity(this.unwrap(r)))
    );
  }

  anular(id: number): Observable<boolean> {
    return this.http.post<ApiResp<any>>(`${this.base}/${id}/anular`, {}).pipe(
      map((r) => { this.unwrap(r); return true; })
    );
  }

  listarSolicitudesAprobadas(): Observable<OpcionCatalogo[]> {
    return this.http.get<ApiResp<PageData<any>>>(`${this.solicitudesUrl}?estado=1&size=1000`).pipe(
      map((r) => (this.unwrap(r)?.content ?? []).map((s: any) => ({
        id: s.id,
        nombre: `${s.numero ?? s.id} · S/ ${Number(s.monto ?? 0).toFixed(2)}`,
      })))
    );
  }

  listarConceptos(): Observable<OpcionCatalogo[]> {
    return this.http.get<ApiResp<PageData<any>>>(`${this.conceptosUrl}?size=1000`).pipe(
      map((r) => (this.unwrap(r)?.content ?? []).map((c: any) => ({
        id: c.id, nombre: `${c.codigo ?? ''} - ${c.nombre ?? ''}`.trim(),
      })))
    );
  }

  listarCuentasPagar(): Observable<OpcionCatalogo[]> {
    return this.http.get<ApiResp<PageData<any>>>(`${this.cuentasPagarUrl}?size=1000`).pipe(
      map((r) => (this.unwrap(r)?.content ?? []).map((c: any) => ({
        id: c.id,
        nombre: `${c.numero ?? c.nroDocumento ?? c.id}${c.proveedorRazonSocial ? ' · ' + c.proveedorRazonSocial : ''}`,
      })))
    );
  }

  listarMonedas(): Observable<OpcionCatalogo[]> {
    return this.http.get<ApiResp<PageData<any>>>(`${this.monedasUrl}?size=1000`).pipe(
      map((r) => (this.unwrap(r)?.content ?? []).map((m: any) => ({
        id: m.id,
        nombre: `${m.simbolo ?? m.siglaMoneda ?? ''} ${m.nombre ?? ''}`.trim(),
      })))
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  private toEntity(l: LiquidacionResponse): LiqRendicionEntity {
    const detalles: LiqRendicionDetalleLinea[] = (l.detalles ?? []).map((d) => ({
      item: d.item,
      conceptoFinancieroId: d.conceptoFinancieroId,
      cntasPagarId: d.cntasPagarId,
      cntasCobrarId: d.cntasCobrarId,
      importe: d.importe != null ? Number(d.importe) : 0,
      flagRetencion: d.flagRetencion,
      importeRetenido: d.importeRetenido != null ? Number(d.importeRetenido) : 0,
    }));
    return {
      id: l.id,
      lr_num_liquidacion: l.nroLiquidacion ?? '',
      lr_fecha_desembolso: l.fechaLiquidacion ?? '',
      lr_monto_gastado: l.importeNeto != null ? Number(l.importeNeto) : 0,
      lr_moneda: l.monedaCodigo ?? '',
      lr_estado: estadoLabel(l.flagEstado),
      lr_solicitud_giro_id: l.solicitudGiroId,
      lr_concepto_financiero_id: l.conceptoFinancieroId,
      lr_importe_neto: l.importeNeto != null ? Number(l.importeNeto) : 0,
      lr_tasa_cambio: l.tasaCambio != null ? Number(l.tasaCambio) : 1,
      lr_moneda_id: l.monedaId,
      lr_saldo: l.saldo != null ? Number(l.saldo) : 0,
      lr_observacion: l.observacion ?? '',
      lr_detalles: detalles,
    };
  }

  private toRequest(e: LiqRendicionEntity): LiquidacionRequest {
    const detalles: LiquidacionDetalleRequest[] = (e.lr_detalles ?? []).map((d, i) => ({
      item: d.item ?? (i + 1),
      conceptoFinancieroId: Number(d.conceptoFinancieroId),
      cntasPagarId: d.cntasPagarId ?? null,
      cntasCobrarId: d.cntasCobrarId ?? null,
      importe: Number(d.importe ?? 0),
      factorSigno: 1, // positivo por defecto; el backend usa SUM(importe * factorSigno) para el cuadre
      flagRetencion: d.flagRetencion ?? '0',
      importeRetenido: Number(d.importeRetenido ?? 0),
    }));
    return {
      solicitudGiroId: Number(e.lr_solicitud_giro_id),
      conceptoFinancieroId: Number(e.lr_concepto_financiero_id),
      importeNeto: Number(e.lr_importe_neto ?? 0),
      tasaCambio: Number(e.lr_tasa_cambio ?? 1),
      monedaId: e.lr_moneda_id ?? null,
      fechaLiquidacion: e.lr_fecha_desembolso ? e.lr_fecha_desembolso.slice(0, 10) : null,
      observacion: e.lr_observacion ?? null,
      detalles,
    };
  }

  private unwrap<T>(r: ApiResp<T>): T {
    if (r && r.success === false) {
      throw new Error(r.message || r.errorCode || 'Error del servidor');
    }
    return r?.data as T;
  }
}
