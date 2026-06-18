import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { delay, map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IAplicacionPagosRepository, OpcionPago, PagoConsolidado } from '../../domain/repositories/iaplicacion-pagos.repository';
import { AplicacionPagosEntity } from '../../domain/models/aplicacion-pagos.entity';
import { AplicacionPagosPlanillaEntity } from '../../domain/models/aplicacion-pagos-planilla.entity';
import { AplicacionPagosTrabajadorEntity } from '../../domain/models/aplicacion-pagos-trabajador.entity';

/** Respuesta del backend `GET /cuentas-pagar` (FI304). */
interface CntasPagarResponse {
  id: number;
  proveedorId?: number;
  proveedorRazonSocial?: string;
  docTipoId?: number;
  docTipoCodigo?: string;
  docTipoNombre?: string;
  serie?: string;
  numero?: string;
  fechaEmision?: string;
  fechaVencimiento?: string;
  monedaCodigo?: string;
  total?: number;
  saldo?: number;
  flagEstado?: string;
}

interface ApiResponse<T> { success: boolean; message?: string; errorCode?: string; data: T; }
interface PageData<T> { content: T[]; }

const DELAY_MS = 600;

/**
 * Cartera de Pagos (Tesorería) — contra ms-finanzas.
 * - Lista documentos por pagar reales (`/api/finanzas/cuentas-pagar`).
 * - Registra el pago consolidado como movimiento de caja/bancos
 *   (`POST /api/finanzas/caja-bancos`, flag_tipo_transaccion='P'); ejecutar/anular por sus endpoints.
 * - Catálogos: cuentas bancarias y conceptos financieros.
 * El token/tenant los inyectan los interceptores. (Planillas/trabajadores siguen como estaban.)
 */
@Injectable({ providedIn: 'root' })
export class AplicacionPagosRepositoryImpl implements IAplicacionPagosRepository {
  private readonly http = inject(HttpClient);
  private readonly base = environment.apiBaseUrl;
  private readonly cuentasPagarUrl = `${this.base}/finanzas/cuentas-pagar`;
  private readonly cajaBancosUrl = `${this.base}/finanzas/caja-bancos`;

  // Catálogos mock que el backend aún no expone (planillas/trabajadores).
  private readonly urlPlanillas = 'assets/data/finanzas/tesoreria/aplicacion-pagos-planilla.json';
  private readonly urlTrabajadores = 'assets/data/finanzas/tesoreria/aplicacion-pagos-trabajadores.json';

  obtenerTodos(): Observable<AplicacionPagosEntity[]> {
    return this.http
      .get<ApiResponse<PageData<CntasPagarResponse>>>(`${this.cuentasPagarUrl}?size=1000`)
      .pipe(map((r) => (this.unwrap(r)?.content ?? []).map((c) => this.toEntity(c))));
  }

  // No se usan en el flujo nuevo (el pago va por pagarDocumentos); se conservan por contrato.
  guardar(entity: AplicacionPagosEntity): Observable<AplicacionPagosEntity> {
    return of(entity);
  }
  actualizar(entity: AplicacionPagosEntity): Observable<AplicacionPagosEntity> {
    return of(entity);
  }

  pagarDocumentos(pago: PagoConsolidado): Observable<number> {
    const impTotal = pago.documentos.reduce((s, d) => s + Number(d.ap_saldo ?? d.ap_montoTotal ?? 0), 0);
    const monedaId = pago.monedaId ?? null;
    const body = {
      flagTipoTransaccion: 'P',
      bancoCntaId: Number(pago.bancoCntaId),
      fechaEmision: pago.fechaEmision,
      impTotal,
      conceptoFinancieroId: Number(pago.conceptoFinancieroId),
      observacion: pago.observacion ?? '',
      medioPagoId: pago.medioPagoId ?? null,
      monedaId, // requerido por el backend al generar el asiento contable
      detalles: pago.documentos.map((d, i) => ({
        item: i + 1,
        entidadContribuyenteId: d.ap_proveedor_id,
        docTipoId: d.ap_doc_tipo_id,
        nroDoc: (d.ap_serieNumDoc ?? '').slice(0, 12),
        importe: Number(d.ap_saldo ?? d.ap_montoTotal ?? 0),
        cntasPagarId: d.id,
        conceptoFinancieroId: Number(pago.conceptoFinancieroId),
        monedaId,
      })),
    };
    return this.http
      .post<ApiResponse<any>>(this.cajaBancosUrl, body)
      .pipe(map((r) => this.unwrap(r)?.id as number));
  }

  ejecutar(id: number): Observable<boolean> {
    return this.http.post<ApiResponse<any>>(`${this.cajaBancosUrl}/${id}/ejecutar`, {}).pipe(
      map((r) => { this.unwrap(r); return true; }));
  }

  anular(id: number): Observable<boolean> {
    return this.http.post<ApiResponse<any>>(`${this.cajaBancosUrl}/${id}/anular`, {}).pipe(
      map((r) => { this.unwrap(r); return true; }));
  }

  listarBancos(): Observable<OpcionPago[]> {
    return this.http.get<ApiResponse<PageData<any>>>(`${this.base}/finanzas/cuentas-bancarias?size=1000`).pipe(
      map((r) => (this.unwrap(r)?.content ?? []).map((b: any) => ({
        id: b.id, nombre: `${b.codigo ?? ''}${b.descripcion ? ' - ' + b.descripcion : ''}`.trim() || `#${b.id}`,
        monedaId: b.monedaId ?? null, // se usa como moneda del pago al registrar
      }))));
  }

  listarConceptos(): Observable<OpcionPago[]> {
    return this.http.get<ApiResponse<PageData<any>>>(`${this.base}/finanzas/conceptos-financieros?size=1000`).pipe(
      map((r) => (this.unwrap(r)?.content ?? []).map((c: any) => ({
        id: c.id, nombre: `${c.codigo ?? ''} - ${c.nombre ?? ''}`.trim(),
      }))));
  }

  obtenerPlanillas(): Observable<AplicacionPagosPlanillaEntity[]> {
    return this.http.get<AplicacionPagosPlanillaEntity[]>(this.urlPlanillas).pipe(delay(DELAY_MS));
  }

  obtenerTrabajadores(): Observable<AplicacionPagosTrabajadorEntity[]> {
    return this.http.get<AplicacionPagosTrabajadorEntity[]>(this.urlTrabajadores).pipe(delay(DELAY_MS));
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
  private toEntity(c: CntasPagarResponse): AplicacionPagosEntity {
    const numero = `${c.serie ? c.serie + '-' : ''}${c.numero ?? ''}`;
    return {
      id: c.id,
      ap_proveedor_id: c.proveedorId,
      ap_doc_tipo_id: c.docTipoId,
      ap_tipoDoc: c.docTipoCodigo ?? c.docTipoNombre ?? '',
      ap_serieNumDoc: numero || c.numero || String(c.id),
      ap_proveedor: c.proveedorRazonSocial ?? '',
      ap_fechaAnticipo: c.fechaEmision ?? '',
      ap_fechaPago: c.fechaVencimiento ?? '',
      ap_moneda: c.monedaCodigo ?? '',
      ap_tipoCambio: 1,
      ap_montoTotal: Number(c.total ?? 0),
      ap_montoAnticipado: 0,
      ap_saldo: c.saldo != null ? Number(c.saldo) : Number(c.total ?? 0),
      ap_medioPago: '',
      ap_ctaContablePago: '',
      ap_estado: c.flagEstado === '0' ? 'Anulada' : (c.flagEstado === '2' ? 'Pagada' : 'Pendiente'),
      ap_observaciones: '',
    };
  }

  private unwrap<T>(r: ApiResponse<T>): T {
    if (r && r.success === false) {
      throw new Error(r.message || r.errorCode || 'Error del servidor');
    }
    return r?.data as T;
  }
}
