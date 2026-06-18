import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IOrdenGiroRepository, OrdenGiroFiltros } from '../../domain/repositories/iorden-giro.repository';
import { OrdenGiroEntity } from '../../domain/models/orden-giro.entity';

/** Respuesta del backend (ms-finanzas · finanzas.solicitud_giro). */
interface SolicitudGiroResponse {
  id: number;
  sucursalId?: number;
  solicitanteId?: number;
  numero?: string;
  fecha?: string;
  monto?: number;
  motivo?: string;
  tipoSolicitud?: string;
  centrosCostoId?: number;
  flagEstado?: string;
}

/** Cuerpo de creación/actualización (SolicitudGiroRequest). */
interface SolicitudGiroRequest {
  sucursalId: number;
  solicitanteId?: number | null;
  fecha: string;
  monto: number;
  motivo?: string | null;
  tipoSolicitud?: string | null;
  centrosCostoId?: number | null;
}

interface ApiResp<T> { success: boolean; message?: string; errorCode?: string; data: T; }
interface PageData<T> { content: T[]; }

/** flagEstado backend → etiqueta de la grilla. 3=Pendiente, 1=Aprobada, 0=Anulada. */
function estadoLabel(flag?: string): string {
  if (flag === '1') { return 'Aprobada'; }
  if (flag === '0') { return 'Anulada'; }
  return 'Pendiente';
}

/**
 * Solicitudes de giro (adelantos) — CRUD real contra ms-finanzas
 * (`/api/finanzas/solicitudes-giro`). El token/tenant los inyectan los interceptores.
 * Notas del backend:
 * - GET paginado con filtros fechaDesde/fechaHasta/estado → `data.content`.
 * - POST crea con `flagEstado=3` (pendiente). PUT solo si está pendiente. POST `/{id}/anular`.
 * - El backend NO modela beneficiario/banco/cuenta/cuotas/moneda (esa UI rica del front queda comentada).
 */
@Injectable({ providedIn: 'root' })
export class OrdenGiroRepositoryImpl implements IOrdenGiroRepository {

  private readonly http = inject(HttpClient);
  private readonly base = `${environment.apiBaseUrl}/finanzas/solicitudes-giro`;
  private readonly sucursalesUrl = `${environment.apiBaseUrl}/core/sucursales`;
  private readonly centrosCostoUrl = `${environment.apiBaseUrl}/contabilidad/centros-costo`;

  obtenerTodos(filtros?: OrdenGiroFiltros): Observable<OrdenGiroEntity[]> {
    let params = new HttpParams().set('size', '1000');
    if (filtros?.fechaDesde) { params = params.set('fechaDesde', filtros.fechaDesde); }
    if (filtros?.fechaHasta) { params = params.set('fechaHasta', filtros.fechaHasta); }
    if (filtros?.estado) { params = params.set('estado', filtros.estado); }
    return this.http.get<ApiResp<PageData<SolicitudGiroResponse>>>(this.base, { params }).pipe(
      map((r) => (this.unwrap(r)?.content ?? []).map((s) => this.toEntity(s)))
    );
  }

  guardar(entity: OrdenGiroEntity): Observable<OrdenGiroEntity> {
    return this.http.post<ApiResp<SolicitudGiroResponse>>(this.base, this.toRequest(entity)).pipe(
      map((r) => this.toEntity(this.unwrap(r)))
    );
  }

  actualizar(entity: OrdenGiroEntity): Observable<OrdenGiroEntity> {
    const id = entity.og_id;
    if (id == null) {
      throw new Error('No se pudo determinar el id de la solicitud a actualizar');
    }
    return this.http.put<ApiResp<SolicitudGiroResponse>>(`${this.base}/${id}`, this.toRequest(entity)).pipe(
      map((r) => this.toEntity(this.unwrap(r)))
    );
  }

  anular(id: number): Observable<boolean> {
    return this.http.post<ApiResp<any>>(`${this.base}/${id}/anular`, {}).pipe(
      map((r) => { this.unwrap(r); return true; })
    );
  }

  listarSucursales(): Observable<{ id: number; nombre: string }[]> {
    return this.http.get<ApiResp<PageData<any>>>(`${this.sucursalesUrl}?size=1000`).pipe(
      map((r) => (this.unwrap(r)?.content ?? []).map((s: any) => ({
        id: s.id,
        nombre: `${s.codigo ?? ''} - ${s.nombre ?? ''}`.replace(/^ - | - $/, '').trim(),
      })))
    );
  }

  listarCentrosCosto(): Observable<{ id: number; nombre: string }[]> {
    return this.http.get<ApiResp<PageData<any>>>(`${this.centrosCostoUrl}?size=1000`).pipe(
      map((r) => (this.unwrap(r)?.content ?? []).map((c: any) => ({
        id: c.id,
        nombre: `${c.cencos ?? ''} - ${c.descCencos ?? ''}`.replace(/^ - | - $/, '').trim(),
      })))
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  private toEntity(s: SolicitudGiroResponse): OrdenGiroEntity {
    return {
      og_id: s.id,
      og_num_orden_giro: s.numero ?? '',
      og_fecha_emision: s.fecha ?? '',
      og_monto: s.monto != null ? Number(s.monto) : 0,
      og_estado: estadoLabel(s.flagEstado),
      og_sucursal_id: s.sucursalId,
      og_solicitante_id: s.solicitanteId,
      og_motivo: s.motivo ?? '',
      og_tipo_solicitud: s.tipoSolicitud ?? 'O',
      og_centro_costo_id: s.centrosCostoId,
      // SOBRA: sin respaldo en backend (UI comentada).
      og_beneficiario: '',
      og_banco: '',
      og_moneda: '',
      og_doc_asociado: '',
      og_fecha_deposito: '',
    };
  }

  private toRequest(e: Partial<OrdenGiroEntity>): SolicitudGiroRequest {
    return {
      sucursalId: Number(e.og_sucursal_id),
      solicitanteId: e.og_solicitante_id ?? null,
      fecha: (e.og_fecha_emision ?? '').slice(0, 10),
      monto: Number(e.og_monto ?? 0),
      motivo: e.og_motivo ?? null,
      tipoSolicitud: e.og_tipo_solicitud ?? 'O',
      centrosCostoId: e.og_centro_costo_id ?? null,
    };
  }

  private unwrap<T>(r: ApiResp<T>): T {
    if (r && r.success === false) {
      throw new Error(r.message || r.errorCode || 'Error del servidor');
    }
    return r?.data as T;
  }
}
