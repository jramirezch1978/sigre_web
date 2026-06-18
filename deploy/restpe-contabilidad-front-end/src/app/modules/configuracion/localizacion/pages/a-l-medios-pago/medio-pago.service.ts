import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { map, switchMap, tap } from 'rxjs/operators';
import { environment } from 'src/environments/environment';

/** Ítem del catálogo SUNAT de medios de pago (TAB01), normalizado para la pantalla. */
export interface MedioPago {
  id?: number;
  codigo: string;
  nombre: string;
  descripcion?: string;
  flagEstado?: string;
}

interface ApiResponse<T> {
  success: boolean;
  message?: string;
  errorCode?: string;
  data: T;
}
interface PageData<T> { content: T[]; }

/** Catálogo SUNAT (cabecera). */
interface BackendCatalogo { id: number; codigoCatalogo: string; nombreCatalogo: string; }
/** Detalle del catálogo SUNAT (lo que la pantalla muestra como "medio de pago"). */
interface BackendDet {
  id?: number;
  catalogoSunatId?: number;
  codigoItem: string;
  nombreItem: string;
  descripcionItem?: string;
  flagEstado?: string;
}

/**
 * Cliente HTTP de Medios de Pago (catálogo SUNAT `TAB01`) contra `ms-core-maestros`
 * (`/api/core/catalogos-sunat` + `/api/core/catalogos-sunat/detalles`).
 *
 * El backend trabaja con `catalogoSunatId` numérico (no con el código `TAB01`), así que
 * primero se resuelve el id del catálogo TAB01 y se cachea. No existe DELETE físico: el
 * borrado es lógico vía `activar`/`desactivar`. El token y el tenant los agregan los
 * interceptores globales; aquí solo se desempaqueta `ApiResponse<T>` y se mapea el contrato
 * del backend (`codigoItem/nombreItem/descripcionItem`) al modelo de la pantalla.
 */
@Injectable({ providedIn: 'root' })
export class MedioPagoService {

  private readonly http = inject(HttpClient);
  private readonly base = `${environment.apiBaseUrl}/core/catalogos-sunat`;
  /** Código del catálogo SUNAT "Tipo Medio de Pago". */
  private readonly catalogo = 'TAB01';
  /** Id numérico de TAB01 cacheado tras la primera resolución. */
  private catalogoId?: number;

  /** Lista los medios de pago (todos: activos e inactivos) del catálogo TAB01. */
  listar(): Observable<MedioPago[]> {
    return this.getCatalogoId().pipe(
      switchMap((id) =>
        this.http.get<ApiResponse<PageData<BackendDet>>>(
          `${this.base}/detalles?catalogoSunatId=${id}&size=1000&sort=codigoItem,asc`)),
      map((r) => (this.unwrap(r)?.content ?? []).map((d) => this.toMedio(d))),
    );
  }

  crear(body: MedioPago): Observable<MedioPago> {
    return this.getCatalogoId().pipe(
      switchMap((id) =>
        this.http.post<ApiResponse<BackendDet>>(`${this.base}/detalles`, this.toRequest(body, id))),
      map((r) => this.toMedio(this.unwrap(r))),
    );
  }

  actualizar(id: number, body: MedioPago): Observable<MedioPago> {
    return this.getCatalogoId().pipe(
      switchMap((catId) =>
        this.http.put<ApiResponse<BackendDet>>(`${this.base}/detalles/${id}`, this.toRequest(body, catId))),
      map((r) => this.toMedio(this.unwrap(r))),
    );
  }

  activar(id: number): Observable<MedioPago> {
    return this.http
      .patch<ApiResponse<BackendDet>>(`${this.base}/detalles/${id}/activar`, {})
      .pipe(map((r) => this.toMedio(this.unwrap(r))));
  }

  desactivar(id: number): Observable<MedioPago> {
    return this.http
      .patch<ApiResponse<BackendDet>>(`${this.base}/detalles/${id}/desactivar`, {})
      .pipe(map((r) => this.toMedio(this.unwrap(r))));
  }

  /** Resuelve (y cachea) el id numérico del catálogo TAB01. */
  private getCatalogoId(): Observable<number> {
    if (this.catalogoId != null) { return of(this.catalogoId); }
    return this.http
      .get<ApiResponse<PageData<BackendCatalogo>>>(`${this.base}?codigoCatalogo=${this.catalogo}&size=1`)
      .pipe(
        map((r) => {
          const id = this.unwrap(r)?.content?.[0]?.id;
          if (id == null) {
            throw new Error(`No se encontró el catálogo SUNAT ${this.catalogo}`);
          }
          return id;
        }),
        tap((id) => (this.catalogoId = id)),
      );
  }

  private toMedio(d: BackendDet): MedioPago {
    return {
      id: d.id,
      codigo: d.codigoItem,
      nombre: d.nombreItem,
      descripcion: d.descripcionItem ?? '',
      flagEstado: d.flagEstado,
    };
  }

  private toRequest(m: MedioPago, catalogoSunatId: number): BackendDet {
    return {
      catalogoSunatId,
      codigoItem: (m.codigo || '').trim(),
      nombreItem: (m.nombre || '').trim(),
      descripcionItem: m.descripcion || '',
      flagEstado: m.flagEstado ?? '1',
    };
  }

  private unwrap<T>(r: ApiResponse<T>): T {
    if (r && r.success === false) {
      throw new Error(r.message || r.errorCode || 'Error del servidor');
    }
    return r?.data as T;
  }
}
