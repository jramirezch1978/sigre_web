import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { map, switchMap } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IGestionGrupoRepository } from '../../domain/repositories/igestion-grupo.repository';
import { GestionGrupoEntity } from '../../domain/models/gestion-grupo.entity';

/** Respuesta del backend (ms-finanzas · finanzas.grupo_codigo_flujo_caja). */
interface GrupoFlujoCajaResponse {
  id: number;
  codigo: string;
  nombre?: string;
  flagReporte?: string;
  factor?: string;
  orden?: number;
  codActividad?: string;
  flagReplicacion?: string;
  flagEstado?: string;
  activo?: boolean;
  fecCreacion?: string;
}

/** Cuerpo de creación/actualización (GrupoCodigoFlujoCajaRequest): codigo + nombre + orden (+ opcionales). */
interface GrupoFlujoCajaRequest {
  codigo: string;
  nombre: string;
  orden: number;
  factor?: string;
  flagReporte?: string;
  codActividad?: string;
}

interface ApiResp<T> { success: boolean; message?: string; errorCode?: string; data: T; }
interface PageData<T> { content: T[]; }

/**
 * Grupos de flujo de caja — CRUD real contra ms-finanzas
 * (`/api/finanzas/grupos-flujo-caja`). El token/tenant los inyectan los interceptores.
 * Notas del backend:
 * - GET es paginado (orden ASC) → la lista viene en `data.content`.
 * - El Request acepta `codigo`, `nombre`, `orden` (obligatorio) y opcionales factor/flagReporte/codActividad.
 * - El estado NO va en el Request → se aplica por PATCH `/activar` · `/desactivar`.
 * - El backend NO modela: niveles/jerarquía, tipo de flujo, naturaleza contable ni conceptos asociados
 *   (esas partes del front quedan comentadas, no borradas).
 */
@Injectable({ providedIn: 'root' })
export class GestionGrupoRepositoryImpl implements IGestionGrupoRepository {

  private readonly http = inject(HttpClient);
  private readonly base = `${environment.apiBaseUrl}/finanzas/grupos-flujo-caja`;

  obtenerTodos(): Observable<GestionGrupoEntity[]> {
    return this.http.get<ApiResp<PageData<GrupoFlujoCajaResponse>>>(`${this.base}?size=1000`).pipe(
      map((r) => (this.unwrap(r)?.content ?? []).map((g) => this.toEntity(g)))
    );
  }

  guardar(grupo: Partial<GestionGrupoEntity>): Observable<{ success: boolean; data?: GestionGrupoEntity }> {
    return this.http.post<ApiResp<GrupoFlujoCajaResponse>>(this.base, this.toRequest(grupo)).pipe(
      switchMap((r) => this.aplicarEstado(this.unwrap(r), grupo.grupo_estado)),
      map((g) => ({ success: true, data: this.toEntity(g) }))
    );
  }

  actualizar(codigo: string, cambios: Partial<GestionGrupoEntity>): Observable<{ success: boolean; data?: GestionGrupoEntity }> {
    const id = cambios.grupo_id;
    if (id == null) {
      // El backend actualiza por id (la grilla siempre trae el id real).
      throw new Error('No se pudo determinar el id del grupo a actualizar');
    }
    return this.http.put<ApiResp<GrupoFlujoCajaResponse>>(`${this.base}/${id}`, this.toRequest(cambios)).pipe(
      switchMap((r) => this.aplicarEstado(this.unwrap(r), cambios.grupo_estado)),
      map((g) => ({ success: true, data: this.toEntity(g) }))
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  /** Aplica el estado (activo/inactivo) por PATCH si difiere del actual; el Request no lo soporta. */
  private aplicarEstado(g: GrupoFlujoCajaResponse, estado?: string): Observable<GrupoFlujoCajaResponse> {
    if (!estado) {
      return of(g);
    }
    const quiereActivo = estado === 'Activo' || estado === 'activo';
    const yaActivo = g.flagEstado === '1' || g.activo === true;
    if (quiereActivo === yaActivo) {
      return of(g);
    }
    const accion = quiereActivo ? 'activar' : 'desactivar';
    return this.http.patch<ApiResp<GrupoFlujoCajaResponse>>(`${this.base}/${g.id}/${accion}`, {}).pipe(
      map((r) => this.unwrap(r))
    );
  }

  private toEntity(g: GrupoFlujoCajaResponse): GestionGrupoEntity {
    const nombre = g.nombre ?? '';
    return {
      grupo_id: g.id,
      grupo_codigo: g.codigo,
      grupo_descripcion: nombre,
      grupo_orden: g.orden,
      grupo_factor: g.factor,
      grupo_flag_reporte: g.flagReporte,
      grupo_cod_actividad: g.codActividad,
      grupo_estado: (g.flagEstado === '1' || g.activo === true) ? 'Activo' : 'Inactivo',
      // El backend es plano (sin jerarquía): el árbol muestra cada grupo como una sola fila.
      grupo_org_hierarchy: [`${g.codigo} - ${nombre}`],
      grupo_nivel: '01',
      grupo_fecha_creacion: g.fecCreacion ?? '',
      // SOBRA: el backend (grupo_codigo_flujo_caja) no devuelve estos campos → vacíos (UI comentada).
      grupo_tipo_flujo: '',
      grupo_naturaleza_contable: '',
      grupo_conceptos: '',
      grupo_detalle: [],
    };
  }

  private toRequest(e: Partial<GestionGrupoEntity>): GrupoFlujoCajaRequest {
    return {
      codigo: (e.grupo_codigo ?? '').trim(),
      nombre: (e.grupo_descripcion ?? '').trim(),
      orden: Number(e.grupo_orden ?? 0),
      factor: e.grupo_factor || undefined,
      flagReporte: e.grupo_flag_reporte || undefined,
      codActividad: e.grupo_cod_actividad || undefined,
    };
  }

  private unwrap<T>(r: ApiResp<T>): T {
    if (r && r.success === false) {
      throw new Error(r.message || r.errorCode || 'Error del servidor');
    }
    return r?.data as T;
  }
}
