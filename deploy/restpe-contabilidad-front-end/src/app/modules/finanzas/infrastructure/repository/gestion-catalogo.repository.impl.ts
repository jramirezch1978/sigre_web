import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map, switchMap } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { IGestionCatalogoRepository } from '../../domain/repositories/igestion-catalogo.repository';
import { GestionCatalogoEntity } from '../../domain/models/gestion-catalogo.entity';

/** Respuesta del backend (ms-core-maestros · core.doc_tipo). */
interface DocTipoResponse {
  id: number;
  codigo: string;
  nombre: string;
  sunatCodigo?: string;
  flagEstado?: string;
}

/** Cuerpo de creación/actualización (DocTipoRequest). */
interface DocTipoRequest {
  codigo: string;
  nombre: string;
  sunatCodigo?: string;
  flagEstado?: string;
}

interface ApiResp<T> { success: boolean; message?: string; errorCode?: string; data: T; }

/**
 * Gestión del catálogo de tipos de documento — CRUD real contra
 * ms-core-maestros (`/api/core/tipos-documento`). El token/tenant los inyectan
 * los interceptores. Mapea entre la entidad del front (`catalogo_*`) y el
 * DTO del backend (codigo, nombre, sunatCodigo, flagEstado).
 */
@Injectable({ providedIn: 'root' })
export class GestionCatalogoRepositoryImpl implements IGestionCatalogoRepository {

  private readonly http = inject(HttpClient);
  private readonly base = `${environment.apiBaseUrl}/core/tipos-documento`;

  obtenerTodos(): Observable<GestionCatalogoEntity[]> {
    return this.http.get<ApiResp<DocTipoResponse[]>>(this.base).pipe(
      map((r) => (this.unwrap(r) ?? []).map((d) => this.toEntity(d)))
    );
  }

  guardar(documento: Partial<GestionCatalogoEntity>): Observable<{ success: boolean; data?: GestionCatalogoEntity }> {
    return this.http.post<ApiResp<DocTipoResponse>>(this.base, this.toRequest(documento)).pipe(
      map((r) => ({ success: true, data: this.toEntity(this.unwrap(r)) }))
    );
  }

  actualizar(codigo: string, cambios: Partial<GestionCatalogoEntity>): Observable<{ success: boolean; data?: GestionCatalogoEntity }> {
    // El backend actualiza por id. Si la fila ya trae el id lo usamos directo;
    // si no, lo resolvemos por código (GET /codigo/{codigo}) y luego PUT.
    const put$ = (id: number) =>
      this.http.put<ApiResp<DocTipoResponse>>(`${this.base}/${id}`, this.toRequest(cambios)).pipe(
        map((r) => ({ success: true, data: this.toEntity(this.unwrap(r)) }))
      );

    if (cambios.catalogo_id != null) {
      return put$(cambios.catalogo_id);
    }
    return this.http.get<ApiResp<DocTipoResponse>>(`${this.base}/codigo/${encodeURIComponent(codigo)}`).pipe(
      map((r) => this.unwrap(r)),
      switchMap((d) => put$(d.id))
    );
  }

  /** Eliminación por id (DELETE /api/core/tipos-documento/{id}). */
  eliminar(id: number): Observable<{ success: boolean }> {
    return this.http.delete<ApiResp<boolean>>(`${this.base}/${id}`).pipe(
      map((r) => ({ success: this.unwrap(r) !== false }))
    );
  }

  // ── Mapeos backend ↔ entidad ────────────────────────────────────────────────

  private toEntity(d: DocTipoResponse): GestionCatalogoEntity {
    return {
      catalogo_id: d.id,
      catalogo_codigo: d.codigo,
      catalogo_nombre_doc: d.nombre,
      catalogo_sunat_codigo: d.sunatCodigo ?? '',
      catalogo_estado: d.flagEstado === '1' ? 'Activo' : 'Inactivo',
      catalogo_fecha_creacion: '',
      // Campos no soportados por el backend (doc_tipo): se devuelven vacíos.
      catalogo_tipo_documento: '',
      catalogo_naturaleza: '',
      catalogo_uso: '',
      catalogo_cuenta_contable: '',
    };
  }

  private toRequest(e: Partial<GestionCatalogoEntity>): DocTipoRequest {
    return {
      codigo: (e.catalogo_codigo ?? '').trim(),
      nombre: (e.catalogo_nombre_doc ?? '').trim(),
      sunatCodigo: e.catalogo_sunat_codigo ?? '',
      flagEstado: e.catalogo_estado === 'Activo' ? '1' : '0',
    };
  }

  private unwrap<T>(r: ApiResp<T>): T {
    if (r && r.success === false) {
      throw new Error(r.message || r.errorCode || 'Error del servidor');
    }
    return r?.data as T;
  }
}
